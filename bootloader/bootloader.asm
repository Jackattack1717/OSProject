;Simple self-written bootloader
org 0x7c00 ;bios sets the Program Counter to this address, also loading in using asm instruction
bits 16 ;setting CPU to 16 bit mode
start: jmp short boot ;short jump to boot to make room for FAT file info
nop

	;Volume labeling and setup for disk
	;Boot Parameter Block (bpb)
	bpb_oemID: db 'MSWIN4.1'
	bpb_bytes_per_sector: dw 512 ;little edian, translates to 00 02
	bpb_sectors_per_cluster: db 1
	bpb_reserved_sector: dw 1
	bpb_fat_count: db 2
	bpb_dir_entries: dw 0E0h
	bpb_total_sectors: dw 2880 ;2880 sectors with 512 bytes is 1.44MB floppy
	bpb_media_descriptor_type: db 0F0h ;F0 = 3.5" floppy
	bpb_sectors_per_fat: dw 9
	bpb_sectors_per_track: dw 18
	bpb_heads: dw 2
	bpb_hidden_sectors: dd 0
	bpb_large_sector_count: dd 0

	;extended boot record
	ebr_drive_number: db 0 ;0x00 floppy, 0x80 is HDD
	ebr_NT_flag: db 0 ;reserved, never changes
	ebr_signature: db 29h ;either 28h or 29h according to OSDev Wiki
	ebr_volume_id: db 10h, 12h, 13h, 14h ;Used for tracking volumes, can add whatever
	ebr_volume_label: db "Jackson OS " ;doesn't matter, pad w/ spaces
	ebr_sys_ID: db "FAT12   " ;spec also says this isn't trustwory

	;boot variables
	zeroval: db 0x00
	driveNum: db 0x00

boot:

	mov [driveNum], dl; saving the drive number in variable

	;loading 2nd boot sector from disk using int 0x13, AH = 3. Resources can be found for search "interrupt 0x13 read disk registers"
	mov al, 2 ; number of sectors we want to read
	mov ch, 0 ; cylinder number
	mov cl, 2 ; setting sector to read
	mov dh, 0 ; setting head number
	mov dl, [driveNum] ; setting drive number

	; es offset by bx, es:bx, is a pointer in RAM to where we want to load the above storage into memory
	mov es, [zeroval];clears this register, can't do immediate write
	mov bx, 0x7e00 ;the address is a simple 16bit address so no need to offset w/ es

	mov ah, 2 ; setting register AH for bios interrupt to read disk
	int 0x13 ; we can now read from pointer es:bx
	;TO DO: error handling using flags
	jmp 0x7e00 ;jumping to code at pointer address


;boot file MUST be 512 byes, last 2 are set w/ the boot signatures 0xAA55 so that BIOS recognizes bootable media
;keep below code, needed for boot
times 510 - ($-$$) db 0 ;assembler directive, 510 MINUS from here to the end fill every byte w/ 0
dw 0xAA55 ;word because 2 bytes
