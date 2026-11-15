#!/usr/bin/env python3
"""enc_only.py: find the functions of the cmix executable that only COMPRESSION can reach.

Why: the executable is stored twice, in the compressor package (comp9) and at the head of the
self-extracting archive (archive9). The copy in the archive never compresses, so every function
that only the compressor can reach is dead weight there. The build places those functions last in
.text and the packer (pk.cpp, "hole") codes them last, so that the archive's copy is simply the
packed file cut short. This tool decides which functions those are, from the linked binary itself.

Method (static, conservative):
  * nodes  = the symbols of the code sections of the unstripped, fixed-address (non-PIE) ELF, as
             labelled by `objdump -d` (a node runs from its label to the next label);
  * edges  = every address inside the code that an instruction of the node mentions: call/jump
             targets, RIP-relative operands, absolute immediates (so taking a function's address
             counts as calling it);
  * roots  = the ELF entry point, .init/.fini, and every node whose START address is stored in a
             data section (function pointers, vtables, .init_array, GOT). Pointers into the middle
             of a node are jump tables of that node and are not roots;
  * the compress-only entry functions (ENTRY patterns below) are never traversed: main() calls
    them only in the compression modes.
  Everything not reachable from the roots is compress-only.

Usage:
  enc_only.py order  CMIX.SYM CMIX.MAP OUT.ld    first link: write a --section-ordering-file that
                                                 lists every kept function section (compress-only
                                                 sections then fall to the end of .text)
  enc_only.py hole   CMIX.SYM                    second link: check that the compress-only code is
                                                 one contiguous run and print "hole FILE_LO FILE_HI"
                                                 (file offsets), or "hole 0 0" if there is none
Testing: `enc_only.py list CMIX.SYM` prints the compress-only functions with their sizes.
New in this entry.
"""
# Header notes (comments, so that the docstring above stays as it is).
# New in this entry: the previous winning entry (fx2-cmix-transformer-v1) stored one identical
# UPX-packed executable in comp9 and in archive9. This tool is what makes the two copies differ
# safely. Called twice by build_and_construct_comp.sh (modes order and hole, around a second
# link); its "hole" output reaches the packer as PACK_HOLE (pack.sh) and from there the "hole"
# line of pk.cpp's config. Needs readelf and objdump.
# The result is only safe if nothing reachable in decompression refers to a compress-only
# function; analyse() stops the build when it finds such a reference to an ENTRY function.
import re, subprocess, sys, struct

# Entry points of compression. A function is listed here only if main() reaches it exclusively in
# the compression modes (-e, -c, -h). Matched as substrings of the mangled symbol name.
ENTRY = ["_Z14RunCompression", "_Z16selfextract_compv", "_Z8Compressy",
         "_Z10split4CompPKc", "_Z7reorderv", "_Z11phda9_preprv"]


# Run a command, return its standard output.
def sh(*a):
    return subprocess.run(a, capture_output=True, text=True, check=True).stdout


# Section table of the ELF (name, type, address, file offset, size, flags) from readelf.
def sections(elf):
    out = []
    for ln in sh("readelf", "-SW", elf).split("\n"):
        m = re.match(r"\s*\[\s*\d+\]\s+(\S+)\s+(\S+)\s+([0-9a-f]+)\s+([0-9a-f]+)\s+([0-9a-f]+)\s+\S+\s+(\S*)", ln)
        if m:
            out.append(dict(name=m.group(1), type=m.group(2), addr=int(m.group(3), 16), off=int(m.group(4), 16),
                            size=int(m.group(5), 16), flags=m.group(6)))
    return out


# The reachability analysis described at the top. Returns the sections, the .text section, the
# nodes [start address, name, section], the end address of each node, the compress-only nodes
# (enc) and the set of reachable node addresses (seen).
def analyse(elf):
    secs = sections(elf)
    code = [s for s in secs if "X" in s["flags"] and s["size"]]
    text = next(s for s in secs if s["name"] == ".text")
    lo, hi = min(s["addr"] for s in code), max(s["addr"] + s["size"] for s in code)
    hdr = sh("readelf", "-hW", elf)
    if "EXEC (Executable file)" not in hdr:
        sys.exit("enc_only.py: %s is not a fixed-address executable (link with -no-pie)" % elf)
    entry = int(re.search(r"Entry point address:\s+0x([0-9a-f]+)", hdr).group(1), 16)

    # Pass over the disassembly: a label line starts a node; from every instruction line take
    # each hexadecimal number that lies inside the code as an edge to that address.
    nodes = []          # [start, name, section]
    edges = {}          # start -> set(target addresses)
    cur = None; sec = None
    num = re.compile(r"(?:\$0x|# |\s|,|\*)(?:0x)?([0-9a-f]{5,16})\b")
    for ln in sh("objdump", "-d", "--no-show-raw-insn", elf).split("\n"):
        m = re.match(r"Disassembly of section (\S+):", ln)
        if m: sec = m.group(1); continue
        m = re.match(r"([0-9a-f]+) <(.+)>:$", ln)
        if m:
            cur = int(m.group(1), 16); nodes.append([cur, m.group(2), sec]); edges[cur] = set(); continue
        m = re.match(r"\s*([0-9a-f]+):\t(.*)$", ln)
        if m and cur is not None:
            for t in num.findall(" " + m.group(2)):
                v = int(t, 16)
                if lo <= v < hi: edges[cur].add(v)
    # node_of(a) = the node that contains address a; ends[start] = where a node ends (the next
    # label of the same section, or the end of the section for its last node).
    nodes.sort()
    starts = [n[0] for n in nodes]
    import bisect
    def node_of(a):
        i = bisect.bisect_right(starts, a) - 1
        return starts[i] if i >= 0 else None
    ends = {starts[i]: (starts[i + 1] if i + 1 < len(starts) and nodes[i + 1][2] == nodes[i][2] else None) for i in range(len(starts))}
    for s in code:
        last = [n for n in nodes if n[2] == s["name"]]
        if last: ends[last[-1][0]] = s["addr"] + s["size"]

    # Roots: the entry point, _start and main, everything outside .text, and every node whose
    # start address appears as an 8-byte value in a loaded data section.
    roots = {node_of(entry)}
    for n in nodes:
        if n[2] != ".text" or n[1] in ("_start", "main"): roots.add(n[0])     # .init, .fini, .plt...
    data = open(elf, "rb").read()
    startset = set(starts)
    for s in secs:
        if "A" in s["flags"] and "X" not in s["flags"] and s["type"] != "NOBITS" and s["size"] >= 8:
            b = data[s["off"]:s["off"] + s["size"]]
            for k in range(0, len(b) - 7, 4):          # pointers are 8 bytes; 4-byte steps for packed tables
                v = struct.unpack_from("<Q", b, k)[0]
                if v in startset: roots.add(v)
    # Traversal from the roots. ENTRY functions are neither marked nor followed, so whatever
    # only they lead to stays unmarked: that is the compress-only set.
    name = {n[0]: n[1] for n in nodes}
    is_entry = lambda a: any(e in name[a] for e in ENTRY)
    seen = set(); todo = [r for r in roots if r is not None]
    while todo:
        a = todo.pop()
        if a in seen or is_entry(a): continue
        seen.add(a)
        for t in edges[a]:
            b = node_of(t)
            if b is not None and b not in seen: todo.append(b)
    enc = [n for n in nodes if n[2] == ".text" and n[0] not in seen]
    # Safety: an entry function may be referenced only by main() and by other compress-only code.
    # Anything else means the ENTRY list is wrong for this source and the split would be unsafe.
    for a in seen:
        if name[a] == "main" or name[a].startswith("main."): continue
        for t in edges[a]:
            b = node_of(t)
            if b is not None and is_entry(b):
                sys.exit("enc_only.py: %s is referenced by %s, which decompression can reach" % (name[b], name[a]))
    return dict(secs=secs, text=text, nodes=nodes, ends=ends, enc=enc, seen=seen)


# Modes: list (report), order (linker ordering file for the second link), hole (file range).
def main():
    mode, elf = sys.argv[1], sys.argv[2]
    A = analyse(elf)
    text, ends = A["text"], A["ends"]
    if mode == "list":
        tot = 0
        for a, nm, _ in sorted(A["enc"], key=lambda n: -(ends[n[0]] - n[0])):
            print("%6d  %x  %s" % (ends[a] - a, a, nm)); tot += ends[a] - a
        print("compress-only: %d functions, %d bytes of %d" % (len(A["enc"]), tot, text["size"]))
    elif mode == "order":
        # Map every input section of .text to its address range from the link map, then list all
        # sections that hold kept code, in their present order. GNU ld places the listed sections
        # first in .text; whatever is not listed (the compress-only ones) follows them.
        encaddr = {n[0] for n in A["enc"]}
        encstart = sorted(encaddr)
        import bisect
        items = []; lines = open(sys.argv[3], errors="replace").read().split("\n"); i = 0
        while i < len(lines):
            ln = lines[i]
            m = re.match(r"^ (\.text\S*)$", ln)
            if m and i + 1 < len(lines): ln = " " + m.group(1) + " " + lines[i + 1].strip(); i += 1
            m = re.match(r"^ (\.text\S*)\s+0x([0-9a-f]+)\s+0x([0-9a-f]+)\s+(\S+)", ln)
            if m and int(m.group(3), 16):
                items.append((int(m.group(2), 16), int(m.group(3), 16), m.group(1), m.group(4)))
            i += 1
        kept = dropped = 0; done = set()
        nodeaddrs = sorted(n[0] for n in A["nodes"])
        with open(sys.argv[4], "w") as f:
            f.write(".text : {\n")
            for addr, size, sec, obj in sorted(items):
                if not (text["addr"] <= addr < text["addr"] + text["size"]): continue
                # a section is compress-only if every symbol in it is
                k = bisect.bisect_left(nodeaddrs, addr)
                syms = [a for a in nodeaddrs[k:bisect.bisect_left(nodeaddrs, addr + size)]]
                if syms and all(a in encaddr for a in syms): dropped += size; continue
                kept += size
                if sec == ".text":
                    # plain .text of one object (startup files, library members): name the file
                    m = re.match(r"(.*)\((.*)\)$", obj)
                    pat = "*%s:%s(.text)" % (re.sub(r".*/", "", m.group(1)), m.group(2)) if m else "*%s(.text)" % re.sub(r".*/", "", obj)
                else:
                    pat = "*(%s)" % sec
                if pat not in done: done.add(pat); f.write("  %s\n" % pat)
            f.write("}\n")
        print("order: kept %d bytes listed, %d bytes compress-only" % (kept, dropped))
    elif mode == "hole":
        # The range from the first compress-only function to the end of the last. It is the
        # hole only if no kept code lies inside; otherwise it is cut down to the last
        # uninterrupted run. A hole under 256 bytes is not worth having.
        enc = sorted(A["enc"])
        if not enc: print("hole 0 0"); return
        lo, hi = enc[0][0], max(ends[n[0]] for n in enc)
        inside = [n for n in A["nodes"] if lo <= n[0] < hi and n[2] == ".text"]
        stray = [n for n in inside if n[0] in A["seen"]]
        if stray:
            # kept code inside the range: use the longest run of compress-only code that ends it
            run_lo = None
            for n in sorted(inside):
                if n[0] in A["seen"]: run_lo = None
                elif run_lo is None: run_lo = n[0]
            lo = run_lo
            sys.stderr.write("enc_only.py: %d kept symbols inside the compress-only range (first %s); "
                             "hole reduced to its last run\n" % (len(stray), stray[0][1]))
        if lo is None or hi - lo < 256: print("hole 0 0"); return
        # virtual address -> file offset (the packer works on file offsets)
        off = text["off"] - text["addr"]
        tot = sum(ends[n[0]] - n[0] for n in enc)
        sys.stderr.write("enc_only.py: compress-only code %d bytes in %d functions; hole %d bytes\n" % (tot, len(enc), hi - lo))
        print("hole %d %d" % (lo + off, hi + off))


if __name__ == "__main__":
    main()
