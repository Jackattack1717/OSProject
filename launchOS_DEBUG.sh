#!/bin/bash
qemu-system-i386 -machine q35 -fda $1 -gdb tcp::26000 -S &
gdb
