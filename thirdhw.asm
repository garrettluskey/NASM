
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100

segment .bss
	input resd max_string_size
	operands resb max_string_size
	buffer resb max_string_size
	infix times max_string_size resd 0
	tmp resb max_string_size
	tmp2 resb max_string_size
	prefix resd 1
	count resd 1
	counter resd 1
	base resb 0
	
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
	mov al,[input + ecx]	;was oringinally set to 10
						;not jumping to return. it should be. EAX should be 
	dump_regs 4		;10 or 0xA but it is 0804A02C which means nothing
	cmp al, '/'
	je infix_first
	cmp al, '*'
	je infix_first
	cmp al, '-'
	je infix_first
	cmp al, '+'
	je infix_first
	inc ecx	;only inc when not operand
	jmp first
	
	middle:
	
	mov al,[input + ecx]
	inc ecx
	
	cmp al, '/'
	je infix_middle
	cmp al, '*'
	je infix_middle
	cmp al, '-'
	je infix_middle
	cmp al, '+'
	je infix_middle
	cmp al, 10	;A
	je return
	;push eax
	inc ecx	;only inc when not operand
	jmp middle
	ret
return:
	ret
	
infix_first:

	xor edx,edx
	mov [buffer], edx
	mov bl, al	
	mov [buffer], byte'('
	mov al, [input + ecx - 2]	
	mov [buffer+1], eax		;it is only adding this]
	mov [buffer + 2], ebx	;operator
	mov al, [input + ecx - 1]
	mov [buffer + 3], eax
	mov [buffer+4], byte')'
	mov eax, buffer
	call print_string
	dump_regs 2
	
	;push eax		;when commented out, does not cause segmentation error
	;call print_char
	xor eax, eax
	inc ecx
	mov ecx,4
	jmp middle
infix_middle:
	
	mov [tmp], byte'('
	inc ebx
	xor ebx,ebx
	doing:
	mov al, [buffer + ebx]
	mov [tmp+ebx], eax
	dump_regs 123
	inc ebx
	cmp al, ')'
	jne doing
	mov al, [input + ecx -1]
	mov [tmp+ebx], al
	mov al, [input + ecx - 2]
	inc ebx
	mov [tmp+ebx],al
	inc ebx
	mov [tmp+ebx],byte')'

	looping:
	xor ebx,ebx
	mov eax, tmp
	dump_regs 1023
	call print_string
	xor eax,eax
	mov al,[tmp+ebx]
	mov [buffer+ebx],al
	inc ebx
	call print_char
	cmp al,0xA
	
	;jne looping
	jmp middle
	
	

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
	dump_regs 201
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

