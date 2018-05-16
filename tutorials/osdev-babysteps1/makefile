all: assemble convert

assemble: boot.asm
	nasm boot.asm -f bin -o boot.bin

convert: boot.bin
	qemu-img convert -f raw -O vdi boot.bin boot.vdi

clean:
	rm boot.bin
	rm boot.vdi
