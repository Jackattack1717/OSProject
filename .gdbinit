set architecture i8086
target remote localhost:26000
layout regs
b * 0x200
b * 0x500
b * 0x520
