#!/usr/bin/env python3

import sys

if len(sys.argv) != 3:
    sys.stderr.write("Bad usage.\n")
    exit(1)

with open(sys.argv[1], "rb") as mem:
    mem = mem.read()

if len(mem) < 64000:
    raise RuntimeError(f"Bad {sys.argv[1]} size (too short)")

eob = 0
for i in range(0x2001, len(mem) - 2):
    if mem[i] == 0 and mem[i + 1] == 0 and mem[i + 2] == 0:
        eob = i
        break

if eob == 0:
    raise RuntimeError(f"Bad {sys.argv[1]} BASIC program, does not found the ending 00-00-00 sequence.")

with open(sys.argv[2], "wb") as f:
    f.write(bytearray([0x01, 0x20]))
    f.write(mem[0x2001:eob + 3])


