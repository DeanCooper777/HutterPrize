"""Summarise a GNU ld / lld link map: bytes of .text/.rodata/.data per object file, and the largest functions.
Usage: python3 mapsum.py cmix.map [N_TOP]"""
import re, sys, collections
txt = open(sys.argv[1], errors="replace").read().split("\n")
top = int(sys.argv[2]) if len(sys.argv) > 2 else 40
by_obj = collections.defaultdict(lambda: collections.Counter())
funcs = []
cur = None
pat = re.compile(r"^\s*(\.[A-Za-z_][\w.$@+-]*)?\s+0x([0-9a-f]+)\s+0x([0-9a-f]+)\s+(\S.*)$")
i = 0
while i < len(txt):
    ln = txt[i]
    m = re.match(r"^ (\.[\w.$@+-]+)$", ln)          # long section name on its own line
    if m and i + 1 < len(txt):
        ln = " " + m.group(1) + " " + txt[i + 1].strip(); i += 1
    m = re.match(r"^ (\.[\w.$@+-]+)\s+0x([0-9a-f]+)\s+0x([0-9a-f]+)\s+(\S+)", ln)
    if m:
        sec, addr, size, obj = m.group(1), int(m.group(2), 16), int(m.group(3), 16), m.group(4)
        if addr and size:
            kind = sec.split(".")[1] if "." in sec[1:] else sec[1:]
            kind = sec[1:].split(".")[0]
            o = re.sub(r".*/", "", obj)
            by_obj[o][kind] += size
            if kind == "text": funcs.append((size, sec, o))
    i += 1
tot = collections.Counter()
print("%-44s %9s %8s %8s" % ("object", "text", "rodata", "data"))
for o, c in sorted(by_obj.items(), key=lambda kv: -kv[1]["text"]):
    if c["text"] + c["rodata"] + c["data"] < 200: continue
    print("%-44s %9d %8d %8d" % (o[:44], c["text"], c["rodata"], c["data"]))
    tot.update(c)
print("%-44s %9d %8d %8d" % ("TOTAL(all)", sum(c["text"] for c in by_obj.values()), sum(c["rodata"] for c in by_obj.values()), sum(c["data"] for c in by_obj.values())))
print()
for size, sec, o in sorted(funcs, reverse=True)[:top]:
    print("%7d %s %s" % (size, o[:28], sec[:110]))
