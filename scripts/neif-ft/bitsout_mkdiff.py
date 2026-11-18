#!/usr/bin/env python3
# bitsout_mkdiff.py: testing tool (not part of any submitted program).
#
#   bitsout_mkdiff.py <cmix-neif 2.0 development tree> <work dir, e.g. runs/neif-ft>
#
# Writes the change for the bit dump of the compressor WITHOUT the transformer
# (NEIF_TF_OFF=1, NEIF_BITS_OUT=<file>, in mode -t of a build with -DNEIF_TEST=1
# -DNEIF_BITS_DUMP=1) as a unified diff, without touching the development tree: the five
# files are copied to <work>/bitsout_base/src and <work>/bitsout/src, the copies in bitsout/
# are edited (exact single-occurrence replacements), and <work>/neif_bitsout.diff is the
# difference, made the way <work>/neif_tap.diff was.  Apply with `patch -p1` in a COPY of the
# tree (bitsout_build.sh).  Everything new is behind NEIF_BITS_DUMP, so the chunk test build
# (-DNEIF_TEST=1 alone) and the official build are unchanged by it.
import difflib
import os
import shutil
import sys

FILES = ["src/neif_test.h", "src/coder/encoder.cpp", "src/predictor.h", "src/predictor.cpp", "src/runner.cpp"]

EDITS = {
    "src/neif_test.h": [(
        "// ---- profile (NEIF_PROF=1): where the time of the model bytes goes ----------\n",
        r'''#ifdef NEIF_BITS_DUMP
// ---- bit dump of the compressor WITHOUT the transformer (a build with
// -DNEIF_TEST=1 -DNEIF_BITS_DUMP=1; a tool of its own, the chunk test build is
// not changed by this block) ---------------------------------------------------
// NEIF_TF_OFF=1 (mode -t, one process): no network step is run and every byte
// takes the gate-neutral transformer row, the row the coder itself uses in the
// gated zones, on alias rows and on timestamps (Tf1Slot::SetProbsNeutral, fast
// weights neutral).  All stream automata of the transformer driver run as in a
// real run, so the coded bytes, forced bits, inserted rows and PPMd are the
// same.  The network is left out through the ownership bits of the pipeline:
// g_own = kOwnPpmd | kOwnMix makes Tf1Engine::Impl::Feed() book the row and
// return (as the coder stage of a pipeline does), and nothing waits for a
// queue because g_own != kOwnMix and g_out == nullptr.
// NEIF_BITS_OUT=<file>: per model byte of the stream (from warm_from to end,
// in stream order) 8 float16, most significant bit first: the logit
// ln(p / (1 - p)) of P(bit == 1) at the return value of Predictor::Predict()
// (the "tap" of CostTap above) for a coded bit, and +inf or -inf (the sign of
// the bit) for a bit that is not coded (ChrForced, forced bits of the grammar
// automaton and of the text start, forced bytes).  The file has no header; the
// result file names warm_from and end.
inline bool g_tf_off = false;
inline FILE* g_bo_file = nullptr;
inline float g_bo_row[8] = {0, 0, 0, 0, 0, 0, 0, 0};
inline unsigned int g_bo_have = 0;                 // bit k set: g_bo_row[k] holds a coded bit
inline unsigned long long g_bo_rows = 0, g_bo_coded = 0, g_bo_forced = 0;
// from Encoder::Encode(), a coded bit: k = number of bits of this byte already
// coded (0 = most significant), p = the return value of Predict().  A plain
// call of a noinline function, as Cost() and CostTap(): no branch in the caller.
__attribute__((noinline)) inline void BitsOutBit(unsigned int k, float p) {
  if (!g_bo_file) return;
  double q = (double)p;
  if (!(q >= 1e-10)) q = 1e-10;                    // a hard 0 or 1 stays finite: +-inf means "not coded"
  if (q > 1.0 - 1e-10) q = 1.0 - 1e-10;
  g_bo_row[k & 7u] = (float)log(q / (1.0 - q));
  g_bo_have |= 1u << (k & 7u);
}
// from Compress(), behind the eight bits of the stream byte c
__attribute__((noinline)) inline void BitsOutByte(unsigned int c) {
  if (!g_bo_file) return;
  unsigned short h[8];
  for (unsigned int k = 0; k < 8; ++k) {
    float v;
    if (g_bo_have & (1u << k)) { v = g_bo_row[k]; ++g_bo_coded; }
    else { v = ((c >> (7 - k)) & 1u) ? HUGE_VALF : -HUGE_VALF; ++g_bo_forced; }
    h[k] = _cvtss_sh(v, _MM_FROUND_TO_NEAREST_INT | _MM_FROUND_NO_EXC);
  }
  if (fwrite(h, 2, 8, g_bo_file) != 8) { fprintf(stderr, "\nneif_test: NEIF_BITS_OUT: write failed\n"); _exit(3); }
  g_bo_have = 0;
  ++g_bo_rows;
}
#endif  // NEIF_BITS_DUMP

// ---- profile (NEIF_PROF=1): where the time of the model bytes goes ----------
''')],
    "src/coder/encoder.cpp": [(
        "  neif_test::CostTap(neif_tap_p, bit);\n",
        r'''  neif_test::CostTap(neif_tap_p, bit);
#ifdef NEIF_BITS_DUMP
  // bit dump: the same value as a logit, at its bit position within the byte
  // (the bit context is 1 at the first bit of a byte)
  neif_test::BitsOutBit((unsigned int)(31 - __builtin_clz(p_->BbBitCtx() | 1u)), neif_tap_p);
#endif
''')],
    "src/predictor.h": [(
        "  void NeifSkipEnd();                     // before the first byte the model runs on\n",
        r'''  void NeifSkipEnd();                     // before the first byte the model runs on
#ifdef NEIF_BITS_DUMP
  void NeifTfOffSlot();                   // NEIF_TF_OFF: both transformer slots to the gate-neutral row
#endif
''')],
    "src/predictor.cpp": [(
        r'''      // no transformer: abstention row, arithmetically no slot at all.
      tf1_slot_->SetProbsOff();
      FwSetOff();
    }
  }
''',
        r'''      // no transformer: abstention row, arithmetically no slot at all.
      tf1_slot_->SetProbsOff();
      FwSetOff();
    }
#if defined(NEIF_TEST) && defined(NEIF_BITS_DUMP)
    NeifTfOffSlot();   // bit dump without the transformer (a plain call: no branch here)
#endif
  }
'''), (
        "void Predictor::NeifSkipEnd() { bit_head::NeifSyncSlot(); }\n",
        r'''void Predictor::NeifSkipEnd() { bit_head::NeifSyncSlot(); }
#ifdef NEIF_BITS_DUMP
// NEIF_TF_OFF=1 (src/neif_test.h): behind the slot update of every byte both
// transformer slots are set again, to the gate-neutral row, exactly as the
// branch above does for a gated byte (uniform row, no live row for the path
// selectors and the semantic cache, no fast-weight update).  The network was
// not run (Tf1Engine::Impl::Feed() returns early), so the row replaced here
// held no prediction.
__attribute__((noinline)) void Predictor::NeifTfOffSlot() {
  if (!neif_test::g_tf_off) return;
  tf1_slot_->SetProbsNeutral();
  FwSetNeutral();
}
#endif
''')],
    "src/runner.cpp": [(
        r'''      AfterStreamByte(p, c);   // the readers of the stream, mirrored in Decompress()
      if (--prog_left == 0) {
''',
        r'''#if defined(NEIF_TEST) && defined(NEIF_BITS_DUMP)
      neif_test::BitsOutByte(c);   // bit dump: the row of this stream byte (8 coded or forced bits)
#endif
      AfterStreamByte(p, c);   // the readers of the stream, mirrored in Decompress()
      if (--prog_left == 0) {
'''), (
        r'''  neif_stream_path = stream_path;
  if (!neif_test::g_skip) neif_test::g_warm_from = 0;
''',
        r'''  neif_stream_path = stream_path;
  if (!neif_test::g_skip) neif_test::g_warm_from = 0;
#ifdef NEIF_BITS_DUMP
  // NEIF_TF_OFF=1: the compressor without the transformer (src/neif_test.h); set
  // before the Predictor is built, one process only.  NEIF_BITS_OUT=<file>: the
  // per-bit logits at the return value of Predict(), 16 B per model byte.
  neif_test::g_tf_off = NeifEnv("NEIF_TF_OFF", 0) != 0;
  if (neif_test::g_tf_off) {
    if (neif_pipe_n > 1) { fprintf(stderr, "neif_test: NEIF_TF_OFF runs in one process (NEIF_PIPE must be 0)\n"); return 2; }
    neif_test::g_own = neif_test::kOwnPpmd | neif_test::kOwnMix;   // no stage owns the network
  }
  {
    const char* bo = getenv("NEIF_BITS_OUT");
    if (bo && *bo) {
      if (neif_pipe_n > 1) { fprintf(stderr, "neif_test: NEIF_BITS_OUT runs in one process (NEIF_PIPE must be 0)\n"); return 2; }
      neif_test::g_bo_file = fopen(bo, "wb");
      if (!neif_test::g_bo_file) { fprintf(stderr, "neif_test: cannot write %s\n", bo); return 2; }
      setvbuf(neif_test::g_bo_file, nullptr, _IOFBF, 1 << 20);
    }
  }
#endif
'''), (
        r'''  fclose(in);
  fclose(out);
  remove(".dict.ta");
''',
        r'''  fclose(in);
  fclose(out);
#ifdef NEIF_BITS_DUMP
  if (neif_test::g_bo_file && fclose(neif_test::g_bo_file) != 0) { fprintf(stderr, "neif_test: NEIF_BITS_OUT: close failed\n"); return 3; }
#endif
  remove(".dict.ta");
'''), (
        "  // pipe: number of stages (0 = one process).  model_cpu_seconds: CPU time of\n",
        r'''#ifdef NEIF_BITS_DUMP
  // bit dump: rows written (must be end - warm_from), coded bits among them
  // (must be tap_bit_count) and bits written as +-inf (not coded)
  fprintf(j, " \"tf_off\": %d, \"bits_out_rows\": %llu, \"bits_out_coded_bits\": %llu, \"bits_out_forced_bits\": %llu,\n",
          neif_test::g_tf_off ? 1 : 0, neif_test::g_bo_rows, neif_test::g_bo_coded, neif_test::g_bo_forced);
#endif
  // pipe: number of stages (0 = one process).  model_cpu_seconds: CPU time of
''')],
}


def main():
    dev, work = sys.argv[1], sys.argv[2]
    out = []
    for rel in FILES:
        src = os.path.join(dev, rel)
        for t in ("bitsout_base", "bitsout"):
            dst = os.path.join(work, t, rel)
            os.makedirs(os.path.dirname(dst), exist_ok=True)
            shutil.copyfile(src, dst)
        a = open(src, encoding="utf-8", newline="").read()
        assert "\r\n" not in a, rel
        b = a
        for old, new in EDITS[rel]:
            assert b.count(old) == 1, "%s: anchor occurs %d times:\n%s" % (rel, b.count(old), old)
            b = b.replace(old, new)
        open(os.path.join(work, "bitsout", rel), "w", encoding="utf-8", newline="").write(b)
        d = list(difflib.unified_diff(a.splitlines(True), b.splitlines(True), "a/" + rel, "b/" + rel, n=3))
        out.append("diff -ru a/%s b/%s\n" % (rel, rel))
        out.extend(d)
        print("%-24s %d edits, +%d lines" % (rel, len(EDITS[rel]), len(b.splitlines()) - len(a.splitlines())))
    open(os.path.join(work, "neif_bitsout.diff"), "w", encoding="utf-8", newline="").write("".join(out))
    print("wrote", os.path.join(work, "neif_bitsout.diff"))


if __name__ == "__main__":
    main()
