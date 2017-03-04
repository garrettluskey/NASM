
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100
segment .bss
	input resd max_string_size
	infix resd 1
	prefix resd 1
	count resd 0
	counter resd 0
segment .text
        global  _asm_main

read_postfix:
		mov eax, msg1
		call read_string
		mov input, eax
		do:
		mov al, [input + count]
		cmp  al,'/'
		je pop_stack
		cmp  al,'*'
		je pop_stack
		cmp  al,'-'
		je pop_stack
		cmp  al,'+'
		je pop_stack
		cmp al, 41  ;A
		jge push_stack
		cmp  al,10
		jne do
		jmp done
		

done:
			;dont know
			
push_stack:
		push eax
		
pop_stack:
		pop eax
		pop ebx
		mov [infix + counter], '('
		add counter, 1
		mov [infix + counter], ebx
		add counter, 1
		mov[infix + counter], eax
		add counter, 1
		mov [infix + counter], ')'
		
postfix_to_infix:


postfix_to_prefix:


_asm_main:
	enter   0,0               ; setup routine
	pusha
	jmp read_postfix
			
			
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

