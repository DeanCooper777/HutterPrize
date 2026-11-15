"""N3 validation: predict Afull/ext costs from the base dump (first-order in the transformer
input) and compare with their real costs on the same bits. Also the reverse (from ext's dump).
Real split-eval reference (whole stream): base->Afull -553,370, Afull->ext -29,689."""
import numpy as np, json
W = "/workspace"; DUMP = __import__("os").environ.get("DUMP", "/workspace/n3/dump"); N = 593343776; K = 16; LEN = 8388608
st = np.memmap(f"{W}/upload/stream.bin", np.uint8, mode="r")
def bce(z, y):  # bits
    return np.logaddexp(0, -np.where(y > 0, z, -z)) / np.log(2)
def cost_p(p, y):
    p = np.clip(p.astype(np.float64), 1e-6, 1 - 1e-6); return -np.log2(np.where(y > 0, p, 1 - p))
res = {}
S = 1 << 23
for k in (3, 7, 11, 15):
    s0 = N * k // K
    D = {t: np.memmap(f"{DUMP}/{t}.c{k}.f32", np.float32, mode="r").reshape(-1, 4) for t in ("base", "Afull", "ext")}
    r = {}; wsum = 0.0
    for i in range(0, 8 * LEN, S):
        y = np.unpackbits(np.array(st[s0 + i // 8: s0 + (i + S) // 8])).astype(np.int8)
        d = {t: np.array(D[t][i:i + S]) for t in D}
        for t in d: r[f"real_{t}"] = r.get(f"real_{t}", 0.0) + float(cost_p(d[t][:, 3], y).sum() / 8)
        for src in ("base", "ext"):
            z, x, w = (d[src][:, j].astype(np.float64) for j in range(3))
            c0 = bce(z, y).sum()
            for t in d:
                if t == src: continue
                key = f"pred_{t}_from_{src}"
                r[key] = r.get(key, 0.0) + float((bce(z + w * (d[t][:, 1] - x), y).sum() - c0) / 8)
        wsum += float(d["base"][:, 2].sum())
    r["w_eff_mean"] = wsum / (8 * LEN)
    res[k] = r; print(k, json.dumps(r), flush=True)
tot = {key: sum(res[k][key] for k in res) for key in res[3] if not key.startswith("w_eff")}
print("TOTAL over 4 chunks (33.5 MB):", json.dumps(tot))
real_ba = tot["real_Afull"] - tot["real_base"]; real_ae = tot["real_ext"] - tot["real_Afull"]
print(f"real base->Afull {real_ba:,.0f}  pred(from base) {tot['pred_Afull_from_base']:,.0f}  ratio {tot['pred_Afull_from_base']/real_ba:.2f}")
print(f"real Afull->ext {real_ae:,.0f}  pred(from base) {tot['pred_ext_from_base']-tot['pred_Afull_from_base']:,.0f}")
print(f"real base->ext {tot['real_ext']-tot['real_base']:,.0f}  pred(from base) {tot['pred_ext_from_base']:,.0f}  pred(from ext, reversed) {-tot['pred_base_from_ext']:,.0f}")
json.dump(dict(chunks=res, total=tot), open(f"{W}/n3/n3_validation.json", "w"), indent=1)
