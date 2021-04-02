program_space equ 0x7e00

read:
	mov ah, 0x02
	mov bx, program_space
	mov al, 2
	mov dl, [boot_disk]
	mov ch, 0x00
	mov dh, 0x00
	mov cl, 0x02

	int 0x13
	jc readfail

	ret

boot_disk:
	db 0

diskmsg:
	db 'disk fail', 0
readfail:
	mov bx, diskmsg
	call prt
	jmp $