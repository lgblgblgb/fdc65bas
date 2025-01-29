#!/usr/bin/env python3

import sys, re

fline, bline = 0, -1

with open(sys.argv[1], "r") as f:
    for l in f:
        fline += 1
        l = l.strip()
        for c in l:
            if c >= 'a' and c <= 'z':
                raise RuntimeError(f"Lower-case character detected at file line {fline}")
        if l == "":
            continue
        b = re.findall("^[0-9]+", l)
        if len(b) != 1:
            raise RuntimeError(f"Bad line (not starting with number) detected at file line {fline}")
        b = int(b[0], 10)
        if b <= bline:
            raise RuntimeError(f"Non-increasing line number {b} detected at file line {fline}")
        bline = b

