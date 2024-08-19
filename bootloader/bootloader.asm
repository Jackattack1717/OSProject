;Attempt at a bootloader
org 0x7c00 ;not sure what this does, I *think* it's the address the boot sector places the pc
bits 16 ;setting CPU to 16 bit mode
start: jmp boot ;program starts at boot

boot:

	;THIS SECTION JUST HALTS THE CPU GRACEFULLY.
	;cli
	;cld
	;hlt ;clears any interrupt flags, clears direction flag so program doesn't increase, then halts

%macro SetCursor 2
    mov bh, 0 ;set page
    mov dh, %2 ;row
    mov dl, %1 ;column
    mov ah, 2;
	int 0x10 ; set cursor position equal to x,y
%endmacro

%macro MovCursorx 0
	mov ah, 3
	int 0x10
	inc dl
	SetCursor dl,dh
%endmacro

%macro PutChar 1
	mov al, %1
	mov bh, 0
	mov bl, 0
	mov cx, 0;
	mov ah, 0xE
	int 0x10 ;printing to the screen
%endmacro

mov ah, 1
int 0x10 ;enable the cursor
SetCursor 0,11
PutChar 'H'
PutChar 'e'
PutChar 'l'
PutChar 'l'
PutChar 'o'
PutChar ' '
PutChar 'W'
PutChar 'o'
PutChar 'r'
PutChar 'l'
PutChar 'd'


	;loading 2nd boot sector from disk using int 0x13, AH = 3
	mov ax, 0x50
	mov es, ax ; can't write to es directly, using general register AX
	xor bx, bx ;setting buffers ES:BX

	mov al, 2 ; total sector count 2 (not 0 starting number)
	mov ch, 0 ; track 0
	mov cl, 2 ; setting sector to read
	mov dh, 0 ; setting head number
	mov dl, 0 ; setting drive number

	mov ah, 0x02 ;setting register AH for interrupt
	int 0x13
	jmp 0x20:0x0 ; jump and execute sector changed to 200 from book
	;DEBUG this using gdb w/ b *0x500. If stops then works.

;boot file MUST be 512 byes, last 2 are set w/ the boot signatures 0xAA55 so that BIOS recognizes bootable media
;keep below code, needed for boot
times 510 - ($-$$) db 0 ;assembler directive, 510 MINUS from here to the end fill every byte w/ 0
dw 0xAA55 ;word because 2 bytes
