
%include "asm_io.inc"
%include "includedsub.asm"

segment .data
	msg1 db "Enter a postfix equation: "

segment .bss
	input resd 1
	infix resd 1
	prefix resd 1
segment .text
        global  _asm_main

read_postfix:
		mov eax, msg1
		print_string
		read_string
		mov [input], eax
postfix_to_infix:


postfix_to_prefix:
		
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call read_postfix
	
			
			
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

