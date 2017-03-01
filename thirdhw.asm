
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: "
	test1 db "Added: "

segment .bss
	input resd 1
	infix resd 1
	prefix resd 1
	operand resd 10 ;may be way too big or too small
	count resd 1
segment .text
        global  _asm_main

read_postfix:
		mov eax, msg1
		call print_string
		call read_char
		cmp eax, '+' 
		je pushOp
		cmp	eax, '-'
		je pushOp
		cmp eax, '*'
		je pushOp
		cmp eax, '/'
		je pushOp
		ret
postfix_to_infix:


postfix_to_prefix:

pushOp:
	;mov [opearnd], eax
	mov eax, test1
	call print_string
	;mov eax, [operand]
	call print_int
	ret
		
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call read_postfix
	
			
			
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

