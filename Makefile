AS := fasm

hghex: hghex.s
	$(AS) hghex.s hghex.o

