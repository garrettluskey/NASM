
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

		cmp al,0xA 
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
		cmp al, [esp]
		jne doing
		;mov [infix + edx], 0xA
		ret

postfix_to_prefix:
		
		mov [prefix + edx], eax
		inc edx
		mov ebx, [input + ecx - 2]
		mov [prefix + edx], ebx
		inc edx
		mov ebx, [input + ecx - 1]
		mov [prefix + edx], ebx
		

infix_middle:
		mov al, [input + ecx - 2]
		;call print_char
		mov [infix + edx], eax
		inc edx
		mov al, [input + ecx]
		mov [infix + edx], eax
		inc edx
		mov al, [input + ecx - 1]
		mov [infix + edx], eax
		inc edx
		ret
		
print:
	call print_char
	;jmp looping
	
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call read_postfix
	call postfix_to_infix
	xor ecx,ecx
	call print_nl
	mov eax, infix
	call print_string
	;looping:
	; mov al,[infix+ecx]
	; inc ecx
	; call print_char
	; mov al,[infix+ecx]
	; inc ecx
	; call print_char
	; mov al,[infix+ecx]
	; inc ecx
	; call print_char
	; mov al,[infix+ecx]
	; inc ecx
	; call print_char
	
	;cmp al,0xA
	;jne print
	;jne looping
	call print_nl
	
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

