# sw_table.py: table of the model-size sweep from the result JSON files.
#   python sw_table.py DIR [BITS_PER_PARAM=3.5]
# net = coded size of the slice through the stand-in mixer + 2 x weight size (the weights sit in
# both the compressor and the archive), against cmix without a transformer.
# Testing tool; not part of the submitted programs.
import json, glob, sys, os
d = sys.argv[1]; bpp = float(sys.argv[2]) if len(sys.argv) > 2 else 3.5
rows = [json.load(open(f)) for f in sorted(glob.glob(d + "/*.json"))]
rows = [r for r in rows if "smoke" not in r["name"]]
key = lambda r: (os.path.basename(r["data"]), r.get("patch", 0), r["params"])
print("%-9s %-5s %-5s %9s %9s  %7s %7s %7s  %10s %10s %10s %10s  %6s" % (
    "name", "slice", "step", "params", "steps", "tf_bpc", "mix_bpc", "cmix_bpc", "coded_B", "weights2x", "net_B", "vs_cmix", "hours"))
for r in sorted(rows, key=key):
    coded = r["mix_bits"] / 8; w2 = 2 * r["params"] * bpp / 8; base = r["cmix_bits"] / 8
    print("%-9s %-5s %-5s %9d %9d  %7.4f %7.4f %7.4f  %10.0f %10.0f %10.0f %+10.0f  %6.2f" % (
        r["name"], os.path.basename(r["data"]), "token" if r.get("patch") else "byte", r["params"],
        r.get("trunk_steps", r["scored_tokens"]), r["tf_bpc"], r["mix_bpc"], r["cmix_bpc"], coded, w2,
        coded + w2, coded + w2 - base, r["train_seconds"] / 3600))
