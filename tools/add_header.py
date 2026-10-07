#!/usr/bin/env python3
"""
add_header.py — prepend a 512-byte SMC copier header to a raw .sfc ROM.

Usage:
    python3 tools/add_header.py input.sfc output.smc

The Super Wildcard DX transfer software expects this header.
Test both with and without it — some SWC software versions accept
headerless .sfc files directly.
"""

import sys
import pathlib


def main():
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} input.sfc output.smc")
        sys.exit(1)

    src = pathlib.Path(sys.argv[1])
    dst = pathlib.Path(sys.argv[2])

    if not src.exists():
        print(f"Error: {src} not found")
        sys.exit(1)

    rom = src.read_bytes()
    dst.write_bytes(bytes(512) + rom)  # 512 zero-byte copier header
    print(f"→ {dst}  ({len(rom) // 1024} KB + 512 B header)")


if __name__ == "__main__":
    main()
