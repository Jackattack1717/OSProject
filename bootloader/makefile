ASM=nasm
BUILD_DIR=../build/bootloader
BOOTLOADER_SRCS := $(wildcard *.asm)
BOOTLOADER_OBJS := $(patsubst %.asm, $(BUILD_DIR)/%.o, $(BOOTLOADER_SRCS))

all: $(BOOTLOADER_OBJS)

$(BOOTLOADER_OBJS): $(BOOTLOADER_SRCS)
	$(ASM) -f bin $< -o $@

clean:
	rm $(BUILD_DIR)/*
