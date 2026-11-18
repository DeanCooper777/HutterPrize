#!/usr/bin/env python3
# patch_ft_tree.py: testing tool (not part of any submitted program).
#
#   patch_ft_tree.py <training tree COPY> <COPY of training/tf/3_train/tree> [--check]
#
# Prepares COPIES of the training tree of cmix-neif 2.0 (tree_upstream + tree_overlay +
# patch_paket11.py, see setup_tree.sh) and of its training scripts for the fine-tune pilot.
# The reference tree is never written.  Every edit is an exact, single-occurrence text
# replacement marked NEIF-FT; a second run changes nothing; an anchor that is missing or
# ambiguous stops the tool (the upstream text changed).  With --check nothing is written.
#
# Edits (all inert unless the run's JSON has the key "ft", see mixloss.py):
#   pysrc/data.py    MicroBatch gets the optional field cmix_bit_logits; the seed of the epoch
#                    permutations comes from FT_PERM_SEED (default 0 = theirs)
#   zctx/zpdump.py   the dump loader maps FT_CMIX_BITS ([n_tokens, 8] float16, package
#                    coordinates) and gives every row the dump row of its TARGET token
#                    (bits[ziel]; the prior beside it is priors[ziel - 1]); rows without a
#                    stream target get NaN
#   pysrc/train.py   (the loop of the fp32 stage) passes the bits to the model, steps the stand-in
#   rx7r.py          installs mixloss, passes the bits, steps the stand-in, saves it with the
#                    state, skips the scale initialisation on request, runs the prefit
#   rx3a.py          installs mixloss, loads the stand-in, saves it
# mixloss.py is copied next to the training scripts.
import os
import shutil
import sys

M = "NEIF-FT"

EDITS = {
    "pysrc/data.py": [
        ('    priors: Float[Tensor, "batch position vocabulary_size"]\n'
         '    cumulative_sequence_lengths: Int32[Tensor, "batch document"]\n',
         '    priors: Float[Tensor, "batch position vocabulary_size"]\n'
         '    cumulative_sequence_lengths: Int32[Tensor, "batch document"]\n'
         '    # NEIF-FT: [batch, position, 8] float16 logits of the compressor without the transformer\n'
         '    # for the bits of the TARGET token (inf = bit not coded, NaN = no dump row); None = not loaded\n'
         '    cmix_bit_logits: Tensor | None = None\n'),
        ('        rng = np.random.default_rng(seed=0)\n',
         '        rng = np.random.default_rng(seed=int(os.environ.get("FT_PERM_SEED", "0")))   # NEIF-FT\n'),
    ],
    "zctx/zpdump.py": [
        ('        object.__setattr__(self, "_prior0_weg", p0_weg)\n',
         '        object.__setattr__(self, "_prior0_weg", p0_weg)\n'
         '        # NEIF-FT: the bit dump of the compressor without the transformer, one row of 8 float16\n'
         '        # per token of the package (row p = the token ppmd-bytes[p], i.e. coder stream byte\n'
         '        # p + cut - 6)\n'
         '        _bw = os.environ.get("FT_CMIX_BITS")\n'
         '        _bits = None\n'
         '        if _bw:\n'
         '            _bits = np.memmap(_bw, dtype=np.float16, mode="r")\n'
         '            assert _bits.size == 8 * len(self._tokens), (\n'
         '                "%s has %d float16, the package %d tokens x 8" % (_bw, _bits.size, len(self._tokens)))\n'
         '            _bits = _bits.reshape(-1, 8)\n'
         '        object.__setattr__(self, "_cmix_bits", _bits)\n'),
        ('        priors = zeros((1, n_positions, v), dtype=torch.float16, pin_memory=pin)\n',
         '        priors = zeros((1, n_positions, v), dtype=torch.float16, pin_memory=pin)\n'
         '        _bits = getattr(self, "_cmix_bits", None)   # NEIF-FT\n'
         '        cmix = (torch.full((1, n_positions, 8), float("nan"), dtype=torch.float16, pin_memory=pin)\n'
         '                if _bits is not None else None)\n'),
        ('            priors[0, position:position + length] = torch.from_numpy(\n'
         '                np.ascontiguousarray(block))\n',
         '            priors[0, position:position + length] = torch.from_numpy(\n'
         '                np.ascontiguousarray(block))\n'
         '            if cmix is not None:\n'
         '                # NEIF-FT: the row of the target token itself (ziel), where the prior is the PPMd\n'
         '                # row in front of it (ziel - 1); a row without a stream target keeps NaN\n'
         '                _cb = np.array(_bits[np.where(ziel >= 0, ziel, 0)])\n'
         '                _cb[ziel < 0] = np.nan\n'
         '                cmix[0, position:position + length] = torch.from_numpy(_cb)\n'),
        ('            cumulative_sequence_lengths=tensor(\n'
         '                [boundaries], dtype=torch.int32).to(self.device),\n'
         '        )\n',
         '            cumulative_sequence_lengths=tensor(\n'
         '                [boundaries], dtype=torch.int32).to(self.device),\n'
         '            cmix_bit_logits=(None if cmix is None   # NEIF-FT\n'
         '                             else cmix.to(self.device, non_blocking=pin)),\n'
         '        )\n'),
    ],
    "pysrc/train.py": [
        ('from pysrc.logger import Logger, LoggerConfig\n',
         'from pysrc.logger import Logger, LoggerConfig\n'
         'import sys as _ft_sys   # NEIF-FT: mixloss, when the training script has loaded it\n'),
        ('                override_window_size=window_size,\n'
         '            )\n'
         '            total_step_loss += loss.detach()\n',
         '                override_window_size=window_size,\n'
         '                **(_ft_sys.modules["mixloss"].kw(micro_batch) if "mixloss" in _ft_sys.modules else {}),   # NEIF-FT\n'
         '            )\n'
         '            total_step_loss += loss.detach()\n'),
        ('        optimizers.step()\n'
         '        optimizers.zero_grad()\n',
         '        optimizers.step()\n'
         '        if "mixloss" in _ft_sys.modules:   # NEIF-FT: one step of the stand-in mixer\n'
         '            _ft_sys.modules["mixloss"].after_step()\n'
         '        optimizers.zero_grad()\n'),
    ],
}

TREE_EDITS = {
    "rx7r.py": [
        ('import arch  # noqa: E402\n',
         'import arch  # noqa: E402\n'
         'import mixloss  # noqa: E402  NEIF-FT (scripts/neif-ft/mixloss.py)\n'),
        ('"rate_term", "mixed", "hold_tail", "clamp_to_grid", "cosine_exact")\n',
         '"rate_term", "mixed", "hold_tail", "clamp_to_grid", "cosine_exact", "ft")   # NEIF-FT: "ft"\n'),
        ('    nparams = sum(p.numel() for p in raw.parameters())\n'
         '\n'
         '    epochs = int(cfgj["epochs"])\n',
         '    mixloss.install(raw, cfgj, device, main_p, world, out)   # NEIF-FT: before the loader is made\n'
         '    nparams = sum(p.numel() for p in raw.parameters())\n'
         '\n'
         '    epochs = int(cfgj["epochs"])\n'),
        ('    if phase == "qat" and step == 0 and sdir is None:\n',
         '    # NEIF-FT: ft.no_scale_init keeps the scales of the start state (the shipped weights)\n'
         '    if phase == "qat" and step == 0 and sdir is None and not (cfgj.get("ft") or {}).get("no_scale_init"):\n'),
        ('    model.train()\n'
         '    log_path = os.path.join(out, "log.jsonl" if step == 0 else "log.s%d.jsonl" % step)\n',
         '    if mixloss.prefit_or_load(raw, data):   # NEIF-FT: a prefit run ends here\n'
         '        dist.barrier()\n'
         '        dist.destroy_process_group()\n'
         '        return\n'
         '    model.train()\n'
         '    log_path = os.path.join(out, "log.jsonl" if step == 0 else "log.s%d.jsonl" % step)\n'),
        ('                         override_window_size=None)\n'
         '            win_loss += loss.detach().double()\n',
         '                         override_window_size=None, **mixloss.kw(mb))   # NEIF-FT\n'
         '            win_loss += loss.detach().double()\n'),
        ('        opts.step()\n'
         '        if clamp_list:\n',
         '        opts.step()\n'
         '        mixloss.after_step()   # NEIF-FT: one step of the stand-in mixer\n'
         '        if clamp_list:\n'),
        ('    print("STATE saved epoch %d step %d" % (epoch, step), flush=True)\n',
         '    mixloss.save(out)   # NEIF-FT: the stand-in beside the state; checks the frozen scales\n'
         '    print("STATE saved epoch %d step %d" % (epoch, step), flush=True)\n'),
    ],
    "rx3a.py": [
        ('assert safe_prefetch.install()\n',
         'assert safe_prefetch.install()\n'
         'import mixloss  # NEIF-FT (scripts/neif-ft/mixloss.py)\n'),
        ('    nparams = sum(p.numel() for p in raw.parameters())\n'
         '    if main_p:\n'
         '        print(json.dumps({"name": cfgj["name"], "phase": phase, "params": nparams, "world": world}), flush=True)\n',
         '    mixloss.install(raw, cfgj, device, main_p, world, out)   # NEIF-FT: before the loader is made\n'
         '    nparams = sum(p.numel() for p in raw.parameters())\n'
         '    if main_p:\n'
         '        print(json.dumps({"name": cfgj["name"], "phase": phase, "params": nparams, "world": world}), flush=True)\n'),
        ('        t0 = time.time()\n'
         '        train(raw_model=raw, model=model, data=data, cfg=tcfg)\n',
         '        assert not mixloss.prefit_or_load(raw, data), "prefit runs go through rx7r.py"   # NEIF-FT\n'
         '        t0 = time.time()\n'
         '        train(raw_model=raw, model=model, data=data, cfg=tcfg)\n'
         '        mixloss.save(out)   # NEIF-FT\n'),
    ],
}


def apply(path, edits, check):
    text = open(path, encoding="utf-8", newline="").read()
    assert "\r\n" not in text, "%s has CRLF line endings; copy the tree with Unix line endings" % path
    n_new = 0
    for old, new in edits:
        if new in text:
            continue
        c = text.count(old)
        if c != 1:
            raise SystemExit("%s: anchor occurs %d times (expected 1):\n%s" % (path, c, old))
        text = text.replace(old, new)
        n_new += 1
    if n_new and not check:
        open(path, "w", encoding="utf-8", newline="").write(text)
    print("%-40s %d of %d edits %s" % (path, n_new, len(edits), "needed" if check else "applied"))


def main():
    args = [a for a in sys.argv[1:] if a != "--check"]
    check = "--check" in sys.argv[1:]
    if len(args) != 2:
        raise SystemExit(__doc__ or "usage: patch_ft_tree.py <training tree copy> <3_train/tree copy> [--check]")
    tft, tree = args
    for d in (tft, tree):
        assert "reference" not in os.path.abspath(d).replace("\\", "/").split("/"), \
            "%s lies in the reference tree; give copies" % d
    for rel, edits in EDITS.items():
        apply(os.path.join(tft, rel), edits, check)
    for rel, edits in TREE_EDITS.items():
        apply(os.path.join(tree, rel), edits, check)
    if not check:
        shutil.copyfile(os.path.join(os.path.dirname(os.path.abspath(__file__)), "mixloss.py"),
                        os.path.join(tree, "mixloss.py"))
        print("mixloss.py copied to %s" % tree)


if __name__ == "__main__":
    main()
