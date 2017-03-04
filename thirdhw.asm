
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100
segment .bss
	input resd max_string_size
	index resd 1
	infix resd max_string_size
	prefix resd 1
	count resd 0
	counter resd 0
segment .text
        global  _asm_main

read_postfix:
		
		mov eax, msg1
		call print_string
		do:
		call read_char
		call print_int
		cmp  al,'/'
		je pop_stack
		cmp  al,'*'
		je pop_stack
		cmp  al,'-'
		je pop_stack
	    cmp  al,'+'
		je pop_stack
		cmp al, 65  ;A
		jge push_stack
		cmp  al,10
		jne do
		jmp done
		

;done:
			;dont know
			
push_stack:
		push eax
		call print_char
		jmp do
pop_stack:
		pop edx
		pop ebx
		mov eax, edx
		call print_char
		mov eax, ebx
		call print_char
		xor ecx,ecx
		mov ah, '('
		mov [infix + ecx], ah
		inc ecx
		mov [infix + ecx], ebx
		inc ecx
		mov[infix + ecx], al
		inc ecx
		mov [infix + ecx], edx
		inc ecx
		mov ah, ')'
		mov [infix + ecx], ah
		jmp do
postfix_to_infix:


postfix_to_prefix:


_asm_main:
	enter   0,0               ; setup routine
	pusha
	jmp read_postfix
	done:
	mov eax, [infix]
	call print_string
			
			
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

