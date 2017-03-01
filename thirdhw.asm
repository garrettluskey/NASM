
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: "

segment .bss
	input resd 10
	infix resd 1
	prefix resd 1
segment .text
        global  _asm_main

read_postfix:
		mov eax, msg1
		call print_string
		do:
		call read_char
		call print_int
		call print_nl
		cmp al,10
		jne do
		return:
		ret
postfix_to_infix:


postfix_to_prefix:
		
_asm_main:
	enter   0,0               ; setup routine
	pusha
	xor ecx,ecx
	call read_postfix
	
			
			
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

