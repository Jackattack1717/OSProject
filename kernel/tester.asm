	mov ah, 0x0E
	mov al, 'A'
	int 0x10
    ;THIS SECTION JUST HALTS THE CPU GRACEFULLY.
	cli
	cld
	hlt ;clears any interrupt flags, clears direction flag so program doesn't increase, then halts
