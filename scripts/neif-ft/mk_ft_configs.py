#!/usr/bin/env python3
# mk_ft_configs.py: testing tool (not part of any submitted program).
#
#   mk_ft_configs.py <reference/neif2/dev/training/tf/3_train/chain> <out dir (scripts/neif-ft/ftcfg)>
#
# Writes the run configurations of the full-data fine-tune pilot of the cmix-neif 2.0
# transformer from the authors' executed configurations (06_qat.json, 07_fp32.json), so that
# everything not named below is theirs.  <W> = work directory, <PKG> = training package; the
# run script (ft_run.sh) replaces both.
#
# Arms (each: 3 quantization-aware epochs with rx7r.py, then 1 fp32 epoch with rx3a.py):
#   T    treatment: cmix-aware mixture loss (+ their size term), data order seed 101
#   C1   control: their loss, data order seed 101 (the pair of T)
#   C2   control: their loss, data order seed 102
#   C3   control: their loss, data order seed 103
# Changes against 06_qat.json, the same in all arms:
#   init = the shipped weights as a training state (<W>/start.tch, strict load), mixed = the
#   allocation rebuilt from the container with the four mislabelled rows set to qmax 7; no
#   init_opt (fresh optimizer moments); no scale initialisation (the scales of the shipped
#   weights stay) and the int8 activation scales frozen; 3 epochs; learning rate multiplier
#   0.0025 -> 0.025 over the first 5 % of the updates, then a cosine back to 0.0025 (times
#   lr 5e-4: peak 1.25e-5 = the end rate of their 96 epochs, end 1.25e-6); size term unchanged.
# Changes against 07_fp32.json: 1 epoch instead of 16, init = the arm's qat end.
# The controls run the mixture code in mode "observe": loss and gradient are their forward
# statement for statement (unit-tested bit-identical on CPU), the stand-in is only logged.
import copy
import json
import os
import sys

chain, out = sys.argv[1], sys.argv[2]
os.makedirs(out, exist_ok=True)
qat = json.load(open(os.path.join(chain, "06_qat.json")))
fp32 = json.load(open(os.path.join(chain, "07_fp32.json")))

ARMS = {"T": ("train", 101), "C1": ("observe", 101), "C2": ("observe", 102), "C3": ("observe", 103)}
BITS = "<PKG>/cmix-bits.float16"
PREFIT = "<W>/ft/prefit/mixer_prefit.pt"


def ft(mode, seed, mixer_init, **extra):
    d = {"perm_seed": seed, "no_scale_init": True, "freeze_activation_scales": True}
    if mode != "off":
        d["cmix_bits"] = BITS
        d["mixloss"] = {"mode": mode, "ce_weight": 0.1, "rich": True, "buckets": 8, "mixer_lr": 1e-3,
                        "mixer_init": mixer_init, "log_every": 16}
        d["mixloss"].update(extra)
    return d


def qat_cfg(name, out_dir, mode, seed, **over):
    c = copy.deepcopy(qat)
    for k in ("init_opt", "init_opt_arch", "init_opt_phase", "cosine_exact", "scale_steps"):
        c.pop(k, None)
    c.update(name=name, out=out_dir, epochs=3, lr=0.0005,
             rewarm={"start": 0.0025, "peak": 0.025, "frac": 0.05, "final": 0.0025},
             init="<W>/ft/start.tch", init_strict=True, mixed="<W>/ft/alloc_ft.npz",
             eval_every=0, eval_epochs=[], state_every=1, keep_every=1, keep_epochs=[3],
             probe={"batches": 8})
    c["ft"] = ft(mode, seed, PREFIT)
    c.update(over)
    return c


def write(name, c):
    json.dump(c, open(os.path.join(out, name), "w"), indent=1)
    print(name)


for arm, (mode, seed) in ARMS.items():
    write("%s_qat.json" % arm, qat_cfg("ft_%s_qat" % arm, "<W>/ft/%s/qat" % arm, mode, seed))
    c = copy.deepcopy(fp32)
    c.update(name="ft_%s_fp32" % arm, out="<W>/ft/%s/fp32" % arm, epochs=1,
             init="<W>/ft/%s/qat/model.tch" % arm, init_strict=True, mixed="<W>/ft/alloc_ft.npz",
             eval=True, ckpt_every=1)
    # the cool-down keeps the arm's loss; its stand-in is the one the qat stage ended with;
    # another seed, so the one epoch is not the first qat epoch's order again
    c["ft"] = ft(mode, seed + 1000, "<W>/ft/%s/qat/mixer.pt" % arm)
    c["ft"].pop("no_scale_init")           # the fp32 phase has no scale initialisation
    write("%s_fp32.json" % arm, c)

# the stand-in fitted on the start weights, once, shared by all arms (rx7r.py, stops after the fit)
c = qat_cfg("ft_prefit", "<W>/ft/prefit", "train", 101, epochs=1)
c["ft"]["mixloss"].update(prefit_only=True, prefit={"micro_batches": 64, "steps": 400, "lr": 0.02})
write("prefit.json", c)

# checks before any arm (run plan, list C)
c = copy.deepcopy(fp32)                    # C1: the strict evaluation of the start state (rx3a.py, no training)
c.update(name="ft_check_strict", out="<W>/ft/check_strict", epochs=0, init="<W>/ft/start.tch",
         init_strict=True, mixed="<W>/ft/alloc_ft.npz", eval=True)
write("check_strict.json", c)
c = qat_cfg("ft_check_probe", "<W>/ft/check_probe", "off", 101, init_only=True)   # C2: PROBE at step 0, state saved
write("check_probe.json", c)
c = qat_cfg("ft_check_probe", "<W>/ft/check_probe", "off", 101, probe_only=True, probe_full_eval=True)
write("check_probe_eval.json", c)          # C2: resumes that state, full evaluation with the qat forward pass
c = qat_cfg("ft_check_orig", "<W>/ft/check_orig", "off", 0, stop_step=8)          # C3: for the unpatched rx7r.py
del c["ft"]
c.update(scale_steps=0)
write("check_parity_orig.json", c)
c = qat_cfg("ft_check_off", "<W>/ft/check_off", "off", 0, stop_step=8)            # C3: patched, ft absent
del c["ft"]
c.update(scale_steps=0)
write("check_parity_patched.json", c)
c = qat_cfg("ft_check_obs", "<W>/ft/check_obs", "observe", 0, stop_step=8)        # C3: observe against "off"
c["ft"].update(no_scale_init=False, freeze_activation_scales=False)
c.update(scale_steps=0)
write("check_parity_observe.json", c)
for mult in (0.0125, 0.025, 0.05):         # C8: control at three peak rates, a quarter epoch each
    c = qat_cfg("ft_lr_%g" % mult, "<W>/ft/lr_%g" % mult, "observe", 101, stop_step=116)
    c["rewarm"]["peak"] = mult
    write("lrpilot_%g.json" % mult, c)
