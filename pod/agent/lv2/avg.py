"""Average snapshots. usage: python avg.py OUT.tch SNAP1 SNAP2 ... [--force]
Checks the quantized ints (round(w / bf16 scale)) of every snapshot against the last one; averages all float tensors
only if none changed (or --force, for the dry run). Prints AVG OK / AVG SKIP with the change counts."""
import sys, torch
args = [a for a in sys.argv[1:] if a != "--force"]; force = "--force" in sys.argv; out, snaps = args[0], args[1:]
sds = [torch.load(f, map_location="cpu") for f in snaps]
def ints(sd):
    r = {}
    for k, v in sd.items():
        sk = k.replace(".weight", ".quantize_weight.scale")
        if k.endswith(".weight") and sk in sd and v.dim() == 2:
            s = sd[sk].float().to(torch.bfloat16).float(); r[k] = (v.float() / s[:, None]).round()
    return r
last = ints(sds[-1]); n = sum(x.numel() for x in last.values())
ch = [sum(int((ints(sd)[k] != last[k]).sum()) for k in last) for sd in sds[:-1]]
print("ints differing from the last snapshot:", ch, "of", n, flush=True)
if any(ch) and not force:
    print("AVG SKIP: quantized ints change inside the window"); sys.exit(0)
avg = {}
for k, v in sds[-1].items():
    avg[k] = (sum(sd[k].double() for sd in sds) / len(sds)).to(v.dtype) if v.is_floating_point() else v
a = ints(avg); ca = sum(int((a[k] != last[k]).sum()) for k in last)
torch.save(avg, out); print(f"AVG {'OK' if not ca else 'FORCED'}: {len(sds)} snapshots, ints of the average differ from the last in {ca}; saved {out}")
