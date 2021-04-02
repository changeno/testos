jmp enterprotmode
%include "prt.asm"
%include "gdt.asm"
enterprotmode:
	call enablea20
	cli
	lgdt [gdt_desc]
	mov eax, cr0
	or eax, 1
	mov cr0, eax
	jmp codeseg:startprotmode

enablea20:
	in al, 0x92
	or al, 2
	out 0x92, al
	ret

[bits 32]

%include "cpuid.asm"
%include "paging.asm"
startprotmode:
	mov ax, dataseg
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov [0xb8000], byte 'b'
	mov [0xb8002], byte 'o'
	mov [0xb8004], byte 'o'
	mov [0xb8006], byte 't'
	mov [0xb8010], byte 'e'
	mov [0xb8012], byte 'd'
	call detectcpuid
	call detectlongmode
	call setupidpaging
	call editgdt
	jmp codeseg:start64

[bits 64]

start64:
	mov edi, 0xb8000
	mov rax, 0x1f201f201f201f20
	mov ecx, 500
	rep stosq
	jmp $

times 2048-($-$$) db 0