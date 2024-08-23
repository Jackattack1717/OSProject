ASM=nasm
BUILD_DIR=../build/kernel
KERNEL_SRCS := $(wildcard *.asm)
KERNEL_OBJS := $(patsubst %.asm, $(BUILD_DIR)/%.o, $(KERNEL_SRCS))

all: $(KERNEL_OBJS)

$(KERNEL_OBJS): $(KERNEL_SRCS)
	$(ASM) -f bin $< -o $@

clean:
	rm $(BUILD_DIR)/*
