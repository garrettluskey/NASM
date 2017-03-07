
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100

segment .bss
	input resd max_string_size
	operands resb max_string_size
	buffer resb max_string_size
	infix times max_string_size resd 0
	prefix resd 1
	count resd 1
	counter resd 1
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
	je exit
	add byte[count], 1
	jne do

	
exit:
	;mov word[input + ecx], 'NUL'
	ret
		
postfix_to_infix:
	;dump_stack 1,2,3
	xor ecx,ecx
	xor edx, edx
	xor ebx,ebx
	mov eax, input
	call print_string
	xor eax, eax
	first:
	mov al,[input + ecx]
	call print_char
	sub byte[count], 1
	cmp byte[count], 0		;was oringinally set to 10
						;not jumping to return. it should be. EAX should be 
	je return
	dump_regs 4		;10 or 0xA but it is 0804A02C which means nothing
	cmp al, '/'
	je infix_first
	cmp al, '*'
	je infix_first
	cmp al, '-'
	je infix_first
	cmp al, '+'
	je infix_first
	cmp al, 41	;A
	;push eax
	jge pusher
	inc ecx	;only inc when not operand
	jmp first

return:
	ret
pusher:
	push eax
	inc ecx
	jmp first
	
	
infix_first:
	
	xor edx,edx
	mov [buffer], edx
	mov bl, al	
	pop eax		
	call print_char
	call print_nl
	mov byte[buffer], '('
	mov [buffer + 1], eax		;it is only adding this
	mov edx, [counter]
	mov [buffer + edx], ebx	;operator
	add byte[counter], 1
	pop eax
	call print_char
	call print_nl
	mov edx, [counter]
	mov [buffer + edx], eax
	add byte[counter], 1
	mov edx, [counter]
	mov byte[buffer + edx], ')'
	add byte[counter], 2
	mov eax, buffer
	call print_string
	dump_regs 2
	
	;push eax		;when commented out, does not cause segmentation error
	;call print_char
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
	;call print_int
	mov byte[count], 1
	mov byte[counter], 2
	call read_postfix
	call postfix_to_infix
	xor ecx,ecx
	mov eax, buffer
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

