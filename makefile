BUILD_DIR=build
BOOTLOADER=$(BUILD_DIR)/bootloader/bootloader.o
KERNEL=$(BUILD_DIR)/kernel/tester.o
DISK_IMG=$(BUILD_DIR)/jacksonOS.img

all: bootdisk

.PHONY: bootdisk bootloader kernel

clean:
	make -C bootloader/ clean
	make -C kernel/ clean
	rm $(DISK_IMG)

run:
	make
	./launchOS.sh $(DISK_IMG)

debug:
	make
	./launchOS_DEBUG.sh $(DISK_IMG)

bootloader:
	make -C bootloader/

kernel:
	make -C kernel/

bootdisk: bootloader kernel
	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=2880 #creates a 1.4MB floppy
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1 seek=0
	mcopy -i $(DISK_IMG) $(KERNEL) "::kernel.bin"
