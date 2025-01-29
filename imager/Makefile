xemu:
	../build/checkbas65.py imager.bas
	xemu-xmega65 -importbas imager.bas -driveled -fastboot -dumpmem dump.mem

dump.mem: imager.bas Makefile
	$(MAKE) xemu

imager.prg: dump.mem imager.bas Makefile
	../build/extractbas65.py dump.mem imager.prg

mega65: imager.prg
	mega65_etherload imager.prg

clean:
	rm -f dump.mem

.PHONY: xemu clean
