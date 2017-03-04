
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100
segment .bss
	input resd max_string_size
	infix resd 1
	prefix resd 1
	count resd 0
segment .text
        global  _asm_main

read_postfix:
		mov eax, msg1
		call print_string
		xor ecx,ecx
		do:
		call read_char
		call print_char
		call print_nl
		cmp al,'/'
		je add_stack
		cmp al,'*'
		je add_stack
		cmp al,'-'
		je add_stack
		cmp al,'+'
		je add_stack
		mov [input + ecx], al
		inc ecx
		cmp al,10
		jne do
		jmp after
		
postfix_to_infix:
		
		xor ecx,ecx
		xor edx, edx
		mov eax, [input + edx]
		dump_regs 1
		inc edx
		mov [infix + ecx], eax
		
		dump_regs 2
		inc ecx
		pop ebx
		
		dump_regs 3
		mov eax, ebx
		call print_int
		mov [infix + ecx], edx
		
		dump_regs 4
		inc ecx
		mov eax, [input + edx]
		
		dump_regs 5
		inc edx
		mov [infix + ecx], eax
		
		dump_regs 6
		inc ecx

		
		jmp done

postfix_to_prefix:

add_stack:
	push eax
	jmp do

_asm_main:
	enter   0,0               ; setup routine
	pusha
	jmp read_postfix
	after:
	jmp postfix_to_infix
	done:
	
	
	mov esp,ebp
	dump_stack 1,2,3
	mov eax,[infix]
	call print_string
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

