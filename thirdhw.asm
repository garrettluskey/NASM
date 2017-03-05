
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100
segment .bss
	input resd max_string_size
	symbols resd max_string_size
	infix resd 0
	prefix resd 1
	count resd 0
segment .text
        global  _asm_main

read_postfix:
		mov eax, msg1
		call print_string
		xor ecx,ecx
		xor edx, edx
		do:
		call read_char
		mov [input + ecx], al
		inc ecx
		cmp al,10
		jne do
		ret
		
postfix_to_infix:
		
		xor ecx,ecx
		xor edx, edx
		doing:
		mov al,[input + ecx]
		cmp al, '/'
		je infix_middle
		cmp al, '*'
		je infix_middle
		cmp al, '-'
		je infix_middle
		cmp al, '+'
		je infix_middle
		inc ecx
		cmp al, 10
		jne doing
		ret

postfix_to_prefix:

infix_middle:
		mov eax, [input + ecx - 2]
		call print_char
		mov [infix + edx], eax
		inc edx
		mov eax, [input + ecx]
		mov [infix + edx], eax
		inc edx
		mov eax, [input + ecx - 1]
		mov [infix + edx], eax
		inc edx
		ret
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call read_postfix
	call postfix_to_infix
	xor ecx,ecx
	call print_nl
	
	looping:
	dump_regs 1
	mov al,[infix+ecx]
	inc ecx
	call print_char
	
	cmp al,10
	
	jne looping
	
	call print_nl
	dump_regs 1
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

