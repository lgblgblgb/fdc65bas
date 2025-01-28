xemu:
	xemu-xmega65 -8 fdc.d81 -importbas fdc.bas -driveled -fastboot -dumpmem dump.mem

dump.mem: fdc.bas Makefile
	$(MAKE) xemu

fdc.prg: dump.mem fdc.bas Makefile extractbas65.py
	./extractbas65.py dump.mem fdc.prg

mega65: fdc.prg
	mega65_etherload fdc.prg

clean:
	rm -f dump.mem fdc.prg

.PHONY: xemu clean
