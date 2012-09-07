all:
	nasm boob_loader.asm -f bin -o boot.bin                                                                                                                                         
	dd if=boot.bin bs=512 of=boot.img
clean:
	rm -rf boot.bin boot.img
