
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100
segment .bss
	input resd max_string_size
	operands resb max_string_size
	buffer resd max_string_size
	infix resd 0
	prefix resd 1
	count resd 0
	operand resb 0
	
segment .text
	global  _asm_main

read_postfix:
	mov eax, msg1
	call print_string
	xor ecx,ecx
	xor edx, edx
	xor ebx, ebx
	do:
	call read_char
	mov [input + ecx], al
	inc ecx

	cmp al,0xA 
	jne do
	ret
		
postfix_to_infix:
	dump_stack 1,2,3
	xor ecx,ecx
	xor edx, edx
	xor ebx,ebx
	first:
	mov al,[input + ecx]
	cmp al, 10
	je return
	cmp al, '/'
	je infix_first
	cmp al, '*'
	je infix_first
	cmp al, '-'
	je infix_first
	cmp al, '+'
	je infix_first
	push eax
	dump_regs ecx
	inc ecx
	jmp first

	return:
	pop eax
	mov [infix], eax
	dump_regs 1
	ret
infix_first:
	xor edx,edx
	mov [buffer], edx
	mov [buffer + 4], al
	;call print_char
	pop eax
	;call print_int
	mov [buffer], eax
	pop eax
	;call print_string
	mov [buffer + 8], eax
	mov eax,[buffer]
	dump_regs 2
	;call print_string
	push eax
	xor eax, eax
	inc ecx
	jmp first
infix_middle:
postfix_to_prefix:
		
	mov [prefix + edx], eax
	mov [count], ecx
	sub ecx,ebx
	inc edx
	mov al, [input + ecx - 1]
	mov [prefix + edx], al
	inc ebx
	inc ebx
	ret


		
print:
	call print_char
	;jmp looping
	
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call print_int
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

