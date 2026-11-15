# data.py: training data loader for the transformer byte model.
#
# What it reads (all produced by the compressor itself, so that training sees exactly what the
# model sees at compression time):
#   tokens              uint8, the preprocessed enwik9 stream as vocabulary indices (0..204)
#   priors              float16, one row of 205 values per token: PPMD's distribution for the
#                       NEXT token; it is an input of the transformer
#   article boundaries  int32 token offsets; every article is trained as its own sequence
#   cmix bits           [this entry] float16, 8 logits per token: the probability cmix assigned
#                       to each bit of the token WITHOUT the transformer (--no-transformer
#                       --save-cmix-bits); the target-side input of the mixture loss
#
# What it yields: Batch objects, each a list of MicroBatch. A micro batch is one long row of
# micro_batch_tokens positions holding many articles back to back, with the article boundaries
# passed along so attention never crosses them. Articles are shuffled per epoch with a fixed
# seed; short neighbouring articles can be merged and over-long ones are split.
#
# Where it fits: used by pysrc/train.py and pysrc/save_outputs.py (training / evaluation
# only).
#
# Changes from the previous winning entry (fx2-cmix-transformer-v1):
#   - [this entry] cmix_bits_filename / MicroBatch.cmix_bit_logits for the cmix-aware loss.
#   - [this entry] a host copy of the sequence boundaries travels with the device tensor,
#     which removes a GPU synchronisation per call (training speed only).
import numpy as np
import torch
from torch import Tensor, tensor, zeros
import os
import queue
import threading
from dataclasses import dataclass, field
from jaxtyping import Float, Int32, Int64, Bool
from typing import Iterable, Iterator, Sequence


# One forward pass worth of data. Position p predicts output_tokens[p] from input_tokens[..p]
# and priors[p]; loss_mask is False on the padding at the end of the row.
@dataclass(frozen=True, slots=True)
class MicroBatch:
    input_tokens: Int64[Tensor, "batch position"]
    output_tokens: Int64[Tensor, "batch position"]
    loss_mask: Bool[Tensor, "batch position"]
    priors: Float[Tensor, "batch position vocabulary_size"]
    cumulative_sequence_lengths: Int32[Tensor, "batch document"]
    # cmix's per-bit logits (without the transformer) for each OUTPUT token,
    # when the loader has a cmix_bits_filename (cmix mixture loss)
    cmix_bit_logits: Float[Tensor, "batch position 8"] | None = None


# One optimizer step worth of micro batches (this rank's share), plus progress counters used
# by the learning-rate and window-size schedules.
@dataclass(frozen=True, slots=True)
class Batch:
    micro_batches: list[MicroBatch]
    epoch: float
    fraction_done: float
    is_last: bool


@dataclass(frozen=True, slots=True)
class CollatedArticlesDataLoader(Iterable[Batch]):
    """under distributed data parallelism every rank constructs its own loader
    with the same arguments except rank; a batch then spans
    gradient_accumulation_steps * world_size micro batches, assigned to ranks
    round-robin, and each rank only yields (and only reads from disk) its own
    gradient_accumulation_steps micro batches per batch"""

    tokens_filename: str
    priors_filename: str
    article_boundaries_filename: str
    mmap: bool
    epochs: int
    micro_batch_tokens: int
    gradient_accumulation_steps: int
    max_article_tokens: int
    max_merge_tokens: int | None
    device: torch.device
    rank: int
    world_size: int
    # optional: `cmix --no-transformer --save-cmix-bits` output (float16, 8
    # logits per token, in token order) for the cmix mixture loss
    cmix_bits_filename: str | None = None

    _cmix_bits: np.ndarray | None = field(
        init=False, repr=False, compare=False, default=None
    )
    _tokens: np.ndarray = field(init=False, repr=False, compare=False)
    _priors: np.ndarray = field(init=False, repr=False, compare=False)
    _article_starts: np.ndarray = field(init=False, repr=False, compare=False)
    _vocabulary_size: int = field(init=False, repr=False, compare=False)
    _permutations: list[np.ndarray] = field(init=False, repr=False, compare=False)
    _batches_per_epoch: list[int] = field(init=False, repr=False, compare=False)
    _total_batches: int = field(init=False, repr=False, compare=False)

    # Load / map the files, derive the article list (merge, split), draw the per-epoch shuffles
    # and count the batches. The dataclass is frozen, hence the object.__setattr__ calls.
    def __post_init__(self) -> None:
        assert self.epochs >= 1
        assert self.gradient_accumulation_steps >= 1
        assert self.world_size >= 1
        assert 0 <= self.rank < self.world_size
        assert self.max_article_tokens >= 2, (
            "articles of length 1 contribute no predicted tokens"
        )
        assert self.max_article_tokens <= self.micro_batch_tokens
        if self.max_merge_tokens is not None:
            assert self.max_merge_tokens <= self.max_article_tokens

        tokens: np.ndarray = np.fromfile(self.tokens_filename, dtype=np.uint8)
        n_tokens: int = len(tokens)
        assert n_tokens >= 2

        boundaries: np.ndarray = np.fromfile(
            self.article_boundaries_filename, dtype=np.int32
        ).astype(np.int64)
        assert len(boundaries) >= 2
        assert boundaries[0] == 0
        assert boundaries[-1] == n_tokens
        assert (np.diff(boundaries) > 0).all()

        float16_size: int = np.dtype(np.float16).itemsize
        priors_file_bytes: int = os.path.getsize(self.priors_filename)
        assert priors_file_bytes % float16_size == 0
        n_priors_floats: int = priors_file_bytes // float16_size
        assert n_priors_floats % n_tokens == 0, (
            f"the number of float16s in {self.priors_filename} ({n_priors_floats}) "
            f"is not divisible by the number of tokens ({n_tokens})"
        )
        vocabulary_size: int = n_priors_floats // n_tokens

        priors: np.ndarray
        if self.mmap:
            # mode="r" is a read-only mapping, so every rank mapping the same
            # file concurrently is safe (the pages are shared through the os
            # page cache, nothing is ever written back)
            priors = np.memmap(
                self.priors_filename,
                dtype=np.float16,
                mode="r",
                shape=(n_tokens, vocabulary_size),
            )
        else:
            # np.fromfile is the single allocation holding the whole file and
            # reshape is a view, so this never holds two copies of the priors
            priors = np.fromfile(self.priors_filename, dtype=np.float16).reshape(
                n_tokens, vocabulary_size
            )

        lengths: list[int] = np.diff(boundaries).tolist()
        n_articles_before_merge: int = len(lengths)
        mean_square_length_before_merge: float = sum(
            length**2 for length in lengths
        ) / len(lengths)

        if self.max_merge_tokens is not None:
            lengths = merge_article_lengths(lengths, self.max_merge_tokens)
        mean_square_length_after_merge: float = sum(
            length**2 for length in lengths
        ) / len(lengths)
        print(
            f"articles before merge: {n_articles_before_merge} "
            f"(average length {n_tokens / n_articles_before_merge:.1f}, "
            f"average square length {mean_square_length_before_merge:.1f}), "
            f"after merge: {len(lengths)} (average length {n_tokens / len(lengths):.1f}, "
            f"average square length {mean_square_length_after_merge:.1f})"
        )

        lengths, n_split_articles = split_article_lengths(
            lengths, self.max_article_tokens
        )
        print(f"articles split: {n_split_articles}")

        article_starts: np.ndarray = np.concatenate(
            (np.zeros(1, dtype=np.int64), np.cumsum(lengths, dtype=np.int64))
        )
        assert article_starts[-1] == n_tokens

        n_articles: int = len(article_starts) - 1
        rng = np.random.default_rng(seed=0)
        permutations: list[np.ndarray] = [
            rng.permutation(n_articles) for _ in range(self.epochs)
        ]

        # [this entry] cmix's bit predictions, memory-mapped; the size check guards against a dump
        # made from a different token stream.
        cmix_bits: np.ndarray | None = None
        if self.cmix_bits_filename is not None:
            cmix_bits_bytes: int = os.path.getsize(self.cmix_bits_filename)
            assert cmix_bits_bytes == n_tokens * 8 * float16_size, (
                f"{self.cmix_bits_filename} holds {cmix_bits_bytes} bytes, "
                f"expected 8 float16 per token ({n_tokens * 16})"
            )
            cmix_bits = np.memmap(
                self.cmix_bits_filename,
                dtype=np.float16,
                mode="r",
                shape=(n_tokens, 8),
            )
        object.__setattr__(self, "_cmix_bits", cmix_bits)
        object.__setattr__(self, "_tokens", tokens)
        object.__setattr__(self, "_priors", priors)
        object.__setattr__(self, "_article_starts", article_starts)
        object.__setattr__(self, "_vocabulary_size", vocabulary_size)
        object.__setattr__(self, "_permutations", permutations)

        batches_per_epoch: list[int] = [
            sum(1 for _ in self._iter_batch_article_groups(permutation))
            for permutation in permutations
        ]
        total_batches: int = sum(batches_per_epoch)
        assert total_batches > 0, "not enough data for a single complete batch"
        object.__setattr__(self, "_batches_per_epoch", batches_per_epoch)
        object.__setattr__(self, "_total_batches", total_batches)

    # Greedy packing of articles (in the given order) into micro batches of at most
    # micro_batch_tokens positions.
    def _iter_micro_batch_articles(
        self, articles: Iterable[int], drop_last: bool
    ) -> Iterator[list[int]]:
        micro_batch: list[int] = []
        micro_batch_length: int = 0
        for article in articles:
            # an article of length L contributes L - 1 positions (its last token
            # is only predicted, its first token is only an input)
            length: int = int(
                self._article_starts[article + 1] - self._article_starts[article] - 1
            )
            if length == 0:
                continue
            if micro_batch_length + length > self.micro_batch_tokens:
                yield micro_batch
                micro_batch = []
                micro_batch_length = 0
            micro_batch.append(article)
            micro_batch_length += length
        if micro_batch and not drop_last:
            yield micro_batch

    def _iter_batch_article_groups(
        self, permutation: np.ndarray
    ) -> Iterator[list[list[int]]]:
        # a batch spans gradient_accumulation_steps micro batches on each of
        # the world_size ranks; grouping uses the combined size and does not
        # depend on rank, so every rank assigns the same articles to the same
        # micro batches
        batch: list[list[int]] = []
        for micro_batch in self._iter_micro_batch_articles(
            permutation.tolist(), drop_last=True
        ):
            batch.append(micro_batch)
            if len(batch) == self.gradient_accumulation_steps * self.world_size:
                yield batch
                batch = []
        # articles left in the trailing incomplete batch are dropped

    # Materialise one micro batch: copy each article's tokens, priors and (optionally) cmix bits
    # into pinned host buffers, record the boundaries, and move everything to the device.
    def _make_micro_batch(self, articles: list[int]) -> MicroBatch:
        n_positions: int = self.micro_batch_tokens
        pin: bool = self.device.type == "cuda"

        input_tokens = zeros((1, n_positions), dtype=torch.int64, pin_memory=pin)
        output_tokens = zeros((1, n_positions), dtype=torch.int64, pin_memory=pin)
        loss_mask = zeros((1, n_positions), dtype=torch.bool, pin_memory=pin)
        priors = zeros(
            (1, n_positions, self._vocabulary_size),
            dtype=torch.float16,
            pin_memory=pin,
        )
        cmix_bits = (
            zeros((1, n_positions, 8), dtype=torch.float16, pin_memory=pin)
            if self._cmix_bits is not None
            else None
        )

        boundaries: list[int] = [0]
        position: int = 0
        for article in articles:
            start: int = int(self._article_starts[article])
            end: int = int(self._article_starts[article + 1])
            length: int = end - start - 1
            assert length > 0
            assert position + length <= n_positions

            input_tokens[0, position : position + length] = torch.from_numpy(
                self._tokens[start : end - 1].astype(np.int64)
            )
            output_tokens[0, position : position + length] = torch.from_numpy(
                self._tokens[start + 1 : end].astype(np.int64)
            )
            loss_mask[0, position : position + length] = True
            # priors row i is the distribution over token i + 1, so input token i
            # at global index g is paired with priors row g; np.array copies the
            # (possibly memmapped, read-only) slice into a small writable buffer
            priors[0, position : position + length] = torch.from_numpy(
                np.array(self._priors[start : end - 1])
            )
            if cmix_bits is not None:
                # cmix's bits row g are its predictions while coding token g,
                # so they pair with the OUTPUT tokens [start + 1, end)
                cmix_bits[0, position : position + length] = torch.from_numpy(
                    np.array(self._cmix_bits[start + 1 : end])
                )

            position += length
            boundaries.append(position)

        if position < n_positions:
            # both flash_attn_varlen_func and chunk_kda require the cumulative
            # sequence lengths to end at the full (padded) sequence length, so the
            # padding becomes its own document; when there is no padding, appending
            # would create a zero-length document instead
            boundaries.append(n_positions)

        cumulative_sequence_lengths = tensor([boundaries], dtype=torch.int32)
        # fla's varlen kernels need the boundaries on the host; given only the
        # device tensor they copy it back at every call, a stream sync each
        # (~0.5 s per micro batch, 2026-11-07). The model passes this host copy
        # on as cu_seqlens_cpu (pysrc/model.py, varlen_cpu_values).
        cumulative_sequence_lengths_device = cumulative_sequence_lengths.to(self.device)
        cumulative_sequence_lengths_device.cpu_values = cumulative_sequence_lengths  # type: ignore[attr-defined]

        return MicroBatch(
            input_tokens=input_tokens.to(self.device, non_blocking=pin),
            output_tokens=output_tokens.to(self.device, non_blocking=pin),
            loss_mask=loss_mask.to(self.device, non_blocking=pin),
            priors=priors.to(self.device, non_blocking=pin),
            cumulative_sequence_lengths=cumulative_sequence_lengths_device,
            cmix_bit_logits=cmix_bits.to(self.device, non_blocking=pin)
            if cmix_bits is not None
            else None,
        )

    # The training iteration: epochs x batches, yielding only this rank's micro batches.
    def _iter_no_prefetch(self) -> Iterator[Batch]:
        batches_done: int = 0
        for epoch in range(self.epochs):
            batches_this_epoch: int = self._batches_per_epoch[epoch]
            for batch_in_epoch, article_groups in enumerate(
                self._iter_batch_article_groups(self._permutations[epoch]), start=1
            ):
                batches_done += 1
                yield Batch(
                    # only this rank's share of the batch is materialized:
                    # with mmap, building a micro batch is what reads its
                    # priors from disk, so skipping the other ranks' micro
                    # batches keeps per-rank disk reads at 1 / world_size of
                    # the file per epoch
                    micro_batches=[
                        self._make_micro_batch(articles)
                        for index, articles in enumerate(article_groups)
                        if index % self.world_size == self.rank
                    ],
                    epoch=epoch + batch_in_epoch / batches_this_epoch,
                    fraction_done=batches_done / self._total_batches,
                    is_last=batches_done == self._total_batches,
                )

    def __iter__(self) -> Iterator[Batch]:
        return prefetch(self._iter_no_prefetch())

    def iter_micro_batches(
        self, articles: Sequence[int]
    ) -> Iterator[tuple[list[int], MicroBatch]]:
        """micro batches packing the given articles in the given order, keeping
        the trailing incomplete micro batch (articles of length 1 contribute no
        positions and are skipped, so they appear in no micro batch); every
        article is its own document, so its predictions do not depend on how the
        articles are ordered or packed"""

        def generate() -> Iterator[tuple[list[int], MicroBatch]]:
            for micro_batch_articles in self._iter_micro_batch_articles(
                articles, drop_last=False
            ):
                yield micro_batch_articles, self._make_micro_batch(micro_batch_articles)

        return prefetch(generate())

    def n_micro_batches(self, articles: Sequence[int]) -> int:
        return sum(
            1 for _ in self._iter_micro_batch_articles(articles, drop_last=False)
        )

    def iter_ordered_micro_batches(self) -> Iterator[tuple[list[int], MicroBatch]]:
        """one epoch of micro batches with articles in file order instead of
        shuffled, keeping the trailing incomplete micro batch (articles of
        length 1 still contribute no positions and are skipped)"""
        return self.iter_micro_batches(range(self.n_articles))

    def n_ordered_micro_batches(self) -> int:
        return self.n_micro_batches(range(self.n_articles))

    @property
    def n_tokens(self) -> int:
        return len(self._tokens)

    @property
    def tokens(self) -> np.ndarray:
        return self._tokens

    @property
    def n_articles(self) -> int:
        return len(self._article_starts) - 1

    @property
    def vocabulary_size(self) -> int:
        return self._vocabulary_size

    @property
    def article_starts(self) -> np.ndarray:
        """token index where each (merged and split) article starts, plus a
        final entry equal to n_tokens"""
        return self._article_starts

    @property
    def priors(self) -> np.ndarray:
        return self._priors

    def approximate_length(self) -> int:
        return self._total_batches


# Join consecutive articles while the joined length stays within max_merge_tokens.
def merge_article_lengths(lengths: list[int], max_merge_tokens: int) -> list[int]:
    merged: list[int] = []
    for length in lengths:
        if merged and merged[-1] + length <= max_merge_tokens:
            merged[-1] += length
        else:
            merged.append(length)
    return merged


# Cut articles longer than max_article_tokens into pieces of at most that length.
def split_article_lengths(
    lengths: list[int], max_article_tokens: int
) -> tuple[list[int], int]:
    split: list[int] = []
    n_split_articles: int = 0
    for length in lengths:
        if length <= max_article_tokens:
            split.append(length)
            continue
        n_split_articles += 1
        split.extend([max_article_tokens] * (length // max_article_tokens))
        if length % max_article_tokens != 0:
            split.append(length % max_article_tokens)
    return split, n_split_articles


def ceil_divide(a: int, b: int) -> int:
    return -(a // -b)


# Run the iterator on a background thread, a few items ahead, so that disk reads and batch
# assembly overlap with GPU work.
def prefetch(iterator: Iterator, num_prefetch: int = 2) -> Iterator:
    q: queue.Queue = queue.Queue(maxsize=num_prefetch)
    sentinel = object()

    def producer():
        try:
            for item in iterator:
                q.put(item)
        finally:
            q.put(sentinel)

    threading.Thread(target=producer, daemon=True).start()

    while True:
        item = q.get()
        if item is sentinel:
            return
        yield item


# ruff: noqa: F722
