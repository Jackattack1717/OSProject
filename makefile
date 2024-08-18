BOOTLOADER=bootloader.o
DISK_IMG=jacksonOS.img

make: bootdisk

clean:
	rm $(BOOTLOADER) $(DISK_IMG)

run:
	make
	./launchOS.sh $(DISK_IMG)

bootloader:
	nasm -f bin bootloader.asm -o $(BOOTLOADER)

bootdisk: bootloader
	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=2880 #creates a 1.4MB floppy
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1 seek=0
