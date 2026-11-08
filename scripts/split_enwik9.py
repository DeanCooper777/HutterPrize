"""Create smaller test files from enwik9.

By default writes the standard prefixes enwik4 .. enwik8 (the first 10^N
bytes of enwik9). enwik8 is the classic 100 MB benchmark file; it is exactly
the first 10^8 bytes of enwik9.

Usage:
    python scripts/split_enwik9.py [--src enwik9] [--out data] [--sizes 4 5 6 7 8]
"""
import argparse
import hashlib
import os
import sys

CHUNK = 1 << 20


def main() -> int:
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--src", default=os.path.join(root, "enwik9"))
    ap.add_argument("--out", default=os.path.join(root, "data"))
    ap.add_argument("--sizes", type=int, nargs="+", default=[4, 5, 6, 7, 8],
                    help="powers of ten to cut (e.g. 6 -> enwik6 = 1,000,000 bytes)")
    args = ap.parse_args()

    src_size = os.path.getsize(args.src)
    if src_size != 10**9:
        print(f"warning: {args.src} is {src_size} bytes, expected 1,000,000,000",
              file=sys.stderr)
    os.makedirs(args.out, exist_ok=True)

    for n in sorted(args.sizes):
        size = 10**n
        if size > src_size:
            print(f"skip enwik{n}: larger than source")
            continue
        dst = os.path.join(args.out, f"enwik{n}")
        if os.path.exists(dst) and os.path.getsize(dst) == size:
            print(f"enwik{n}: already present")
            continue
        md5 = hashlib.md5()
        remaining = size
        with open(args.src, "rb") as fi, open(dst + ".tmp", "wb") as fo:
            while remaining:
                buf = fi.read(min(CHUNK, remaining))
                if not buf:
                    raise IOError("unexpected end of source file")
                fo.write(buf)
                md5.update(buf)
                remaining -= len(buf)
        os.replace(dst + ".tmp", dst)
        print(f"enwik{n}: {size:>13,} bytes  md5 {md5.hexdigest()}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
