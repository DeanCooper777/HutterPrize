#!/usr/bin/env bash
# ft_run.sh: testing tool (not part of any submitted program).
#
# The full-data fine-tune pilot of the cmix-neif 2.0 transformer on ONE card, stage by stage
# (a stage whose result exists is skipped).  Modelled on the authors' reproduce.sh
# (training/tf/3_train), with the same environment of the training form.
#
#   NEIF=<cmix-neif 2.0 tree> PKG=<training package> W=<work dir> FT=<scripts/neif-ft> \
#     PY=<python of the training environment> bash ft_run.sh <stage> [...]
#
# PKG holds the package of build_package.sh including ppmd-probs.float16, and
# cmix-bits.float16 (bits_merge.py).  W/ft must hold start.tch and alloc_ft.npz (the shipped
# weights as a training state: step2_roundtrip.sh tch, alloc_fix.py).
# Stages:
#   tree            assemble the training tree (README section 1) and the patched copies
#   check_strict    C1: strict evaluation of start.tch (rx3a.py, no training)
#   check_probe     C2: PROBE at step 0 and the full evaluation with the qat forward pass
#   check_parity    C3: 8 updates with the original rx7r.py, the patched one without "ft",
#                   and (after prefit) the patched one in mode observe; compares the loss
#   prefit          the stand-in mixer fitted on the start weights (shared by all arms)
#   lrpilot         optional: the control at three peak rates, 136 updates each
#   arm T|C1|C2|C3  3 quantization-aware epochs, then 1 fp32 epoch with the strict evaluation
#   export T|C1|C2|C3|start   checkpoint -> reference weight file -> v3, v4, v5 -> NP2, under
#                   the shipped file name in W/ft/<arm>/np2/ (for `cmix -t`, NEIF_T_WEIGHTS_ANY=1)
set -euo pipefail
: "${NEIF:?NEIF missing (cmix-neif 2.0 tree)}"; : "${PKG:?PKG missing}"; : "${W:?W missing}"; : "${FT:?FT missing}"
PY="${PY:-python3}"
T3="$NEIF/training/tf/3_train"
TREE_ORIG="$W/ft/tree_orig"; TREE="$W/ft/tree"; export TFT_TREE="$W/ft/tft"
PORT="${PORT:-30731}"
CFG="$FT/ftcfg"
SHIP=weights-poc8m_w2048_tf2t3_pruned_v5k_np2.c5
# environment of the training hosts (reproduce.sh), one card: 8 micro-batches of 131,072 per update
export PKG TFT_GEOMETRY=poc8m_w2048 PK_DUMP_DIR="$PKG" TFT_DATA_DIR="$PKG" TFT_MMAP="${TFT_MMAP:-1}" ZCTX_ARM=pkd ZCTX_SEED=20260901 \
  PK_LAST_X0ROW=1 PK_REDIRMERGE=1 PK_SLOT_DIM=16 TFT_OPTIMIZER_BATCH_TOKENS=1048576 \
  TFT_MICRO_BATCH_TOKENS=131072 PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True \
  OMP_NUM_THREADS=4 MKL_NUM_THREADS=4 OPENBLAS_NUM_THREADS=4 NUMEXPR_NUM_THREADS=4 \
  NCCL_P2P_DISABLE=1 NCCL_CUMEM_ENABLE=0 NCCL_NVLS_ENABLE=0 TORCH_NCCL_ASYNC_ERROR_HANDLING=0
say() { echo "$(date -u '+%F %T') $*"; }
cfg() {   # cfg <file in ftcfg> <out file>: <W> and <PKG> replaced
  mkdir -p "$(dirname "$2")"
  "$PY" - "$CFG/$1" "$2" "$W" "$PKG" <<'PYEOF'
import json, sys
src, dst, w, pkg = sys.argv[1:5]
def sub(o):
    if isinstance(o, dict): return {k: sub(v) for k, v in o.items()}
    if isinstance(o, list): return [sub(v) for v in o]
    return o.replace("<W>", w).replace("<PKG>", pkg) if isinstance(o, str) else o
json.dump(sub(json.load(open(src))), open(dst, "w"), indent=1)
PYEOF
}
run() {   # run <tree dir> <script> <cfg>: one card
  ( cd "$1" && "$PY" -m torch.distributed.run --nproc_per_node 1 --master_port "$PORT" "$2" "$3" ) 2>&1 | tee -a "$(dirname "$3")/stdout.log"
}
need_start() { [ -s "$W/ft/start.tch" ] && [ -s "$W/ft/alloc_ft.npz" ] || { echo "W/ft/start.tch or alloc_ft.npz missing" >&2; exit 2; }; }

st_tree() {
  [ -s "$TREE/mixloss.py" ] && [ -d "$TFT_TREE/pysrc" ] && return 0
  mkdir -p "$W/ft"; rm -rf "$TFT_TREE" "$TREE" "$TREE_ORIG"
  cp -a "$NEIF/training/tf/tree_upstream" "$TFT_TREE"
  cp -a "$NEIF/training/tf/tree_overlay/." "$TFT_TREE/"
  "$PY" "$NEIF/training/tf/2_package/patch_paket11.py" "$TFT_TREE"
  cp -a "$T3/tree" "$TREE_ORIG"              # the authors' scripts, for the parity check (they need an
  cp -a "$TFT_TREE" "$W/ft/tft_orig"         # unpatched training tree: MicroBatch without the new field)
  cp -a "$T3/tree" "$TREE"
  "$PY" "$FT/patch_ft_tree.py" "$TFT_TREE" "$TREE"
}
st_check_strict() {
  local o="$W/ft/check_strict"; [ -s "$o/result.json" ] && return 0
  need_start; cfg check_strict.json "$o/cfg.json"; run "$TREE" rx3a.py "$o/cfg.json"
  grep '^EVAL' "$o/stdout.log" | tail -n 1
  echo "expected (training/tf/3_train/chain/results/fp32.json): bits_per_tok 1.4050690846, n_scored 487298491"
}
st_check_probe() {
  local o="$W/ft/check_probe"
  need_start
  if [ ! -s "$o/state/state.json" ]; then cfg check_probe.json "$o/cfg.json"; run "$TREE" rx7r.py "$o/cfg.json"; fi
  cfg check_probe_eval.json "$o/cfg_eval.json"; cp "$o/cfg_eval.json" "$o/cfg.json"; run "$TREE" rx7r.py "$o/cfg.json"
  grep -a 'PROBE\|^EVAL\|ft: ' "$o/stdout.log" | tail -n 6
}
st_check_parity() {
  need_start
  local o
  o="$W/ft/check_orig"; if [ ! -s "$o/result.json" ]; then cfg check_parity_orig.json "$o/cfg.json"
    ( export TFT_TREE="$W/ft/tft_orig"; run "$TREE_ORIG" rx7r.py "$o/cfg.json" ); fi
  o="$W/ft/check_off"; if [ ! -s "$o/result.json" ]; then cfg check_parity_patched.json "$o/cfg.json"; run "$TREE" rx7r.py "$o/cfg.json"; fi
  if [ -s "$W/ft/prefit/mixer_prefit.pt" ]; then
    o="$W/ft/check_obs"; if [ ! -s "$o/result.json" ]; then cfg check_parity_observe.json "$o/cfg.json"; run "$TREE" rx7r.py "$o/cfg.json"; fi
  fi
  for o in check_orig check_off check_obs; do [ -s "$W/ft/$o/log.jsonl" ] && echo "$o $(tail -n 1 "$W/ft/$o/log.jsonl")"; done
}
st_prefit() {
  local o="$W/ft/prefit"; [ -s "$o/mixer_prefit.pt" ] && return 0
  need_start; [ -s "$PKG/cmix-bits.float16" ] || { echo "$PKG/cmix-bits.float16 missing (bits_merge.py)" >&2; exit 2; }
  cfg prefit.json "$o/cfg.json"; run "$TREE" rx7r.py "$o/cfg.json"
  grep -a '^PREFIT' "$o/stdout.log" | tail -n 1
}
st_lrpilot() {
  for m in 0.0125 0.025 0.05; do
    local o="$W/ft/lr_$m"; [ -s "$o/result.json" ] && continue
    cfg "lrpilot_$m.json" "$o/cfg.json"; run "$TREE" rx7r.py "$o/cfg.json"
  done
}
st_arm() {
  local a=$1 o="$W/ft/$1"
  need_start; [ -s "$W/ft/prefit/mixer_prefit.pt" ] || { echo "run the stage prefit first" >&2; exit 2; }
  if [ ! -s "$o/qat/result.json" ] || ! grep -q '"tag": "final"' "$o/qat/result.json"; then
    cfg "${a}_qat.json" "$o/qat/cfg.json"; run "$TREE" rx7r.py "$o/qat/cfg.json"
  fi
  if [ ! -s "$o/fp32/result.json" ]; then
    cfg "${a}_fp32.json" "$o/fp32/cfg.json"; run "$TREE" rx3a.py "$o/fp32/cfg.json"
  fi
  grep -a '^EVAL' "$o/qat/stdout.log" "$o/fp32/stdout.log" | tail -n 2
}
st_export() {
  local a=$1 o="$W/ft/$1/export" m="$W/ft/$1/fp32/model.tch"
  [ "$a" = start ] && m="$W/ft/start.tch"
  [ -s "$W/ft/$a/np2/$SHIP" ] && return 0
  mkdir -p "$o/raw" "$o/c4" "$W/ft/$a/np2"
  "$PY" - "$T3/chain/08_export.json" "$o/cfg.json" "$W" <<'PYEOF'
import json, sys
c = json.load(open(sys.argv[1]))
c["out"] = sys.argv[3] + "/ft/export"
c["mixed"] = sys.argv[3] + "/ft/alloc_ft.npz"
json.dump(c, open(sys.argv[2], "w"), indent=1)
PYEOF
  # on a CUDA card, as the authors did: the RoPE tables then are the CUDA tables the container
  # writer expects (an export on a CPU needs rope_fix.py, see step2_roundtrip.sh)
  ( cd "$T3/export" && EXPORT_DEVICE="${EXPORT_DEVICE:-cuda}" "$PY" export_v3_ar.py "$o/cfg.json" "$m" "$o/raw" )
  TREE="$TFT_TREE" PYTHON="$PY" bash "$T3/export/export4/export.sh" "$o/raw/weights-poc8m_w2048.bin" "$o/c4"
  PYTHONPATH="$TFT_TREE" "$PY" "$T3/export/export4/convert_container_v5.py" "$o/c4/weights-poc8m_w2048_pruned_v4.c4" "$o/v5.c5"
  "$PY" "$T3/export/np2/np2_container.py" np "$o/v5.c5" "$W/ft/$a/np2/$SHIP" k fw np2 dead
  ls -l "$W/ft/$a/np2/$SHIP"; sha256sum "$W/ft/$a/np2/$SHIP"
  [ "$a" = start ] && { cmp "$NEIF/$SHIP" "$W/ft/start/np2/$SHIP" && echo "start export BYTE IDENTICAL to the shipped container"; }
  return 0
}

[ $# -ge 1 ] || { sed -n 2,26p "$0"; exit 2; }
while [ $# -gt 0 ]; do
  s=$1; shift
  say "stage $s"
  case $s in
    tree) st_tree ;;
    check_strict) st_tree; st_check_strict ;;
    check_probe) st_tree; st_check_probe ;;
    check_parity) st_tree; st_check_parity ;;
    prefit) st_tree; st_prefit ;;
    lrpilot) st_tree; st_lrpilot ;;
    arm) st_tree; st_arm "$1"; shift ;;
    export) st_tree; st_export "$1"; shift ;;
    *) echo "unknown stage $s" >&2; exit 2 ;;
  esac
done
say "done"
