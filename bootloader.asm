;Attempt at a bootloader
org 0x7c00 ;not sure what this does, I *think* it's the address the boot sector places the pc
bits 16 ;setting CPU to 16 bit mode
start: jmp boot ;program starts at boot

boot:
	cli
	cld
	hlt ;clears any interrupt flags, clears direction flag so program doesn't increase, then halts

;boot file MUST be 512 byes, last 2 are set w/ the boot signatures 0xAA55 so that BIOS recognizes bootable media

;keep below code, needed for boot
times 510 - ($-$$) db 0 ;assembler directive, 510 MINUS from here to the end fill every byte w/ 0
dw 0xAA55 ;word because 2 bytes
