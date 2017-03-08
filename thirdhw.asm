
%include "asm_io.inc"

segment .data
	msg1 db "Enter a postfix equation: ",0
	max_string_size equ 100
	counter db 0
	count db 2
segment .bss
	input resd max_string_size
	operands resb max_string_size
	infix resb max_string_size
	tmp resb max_string_size
	prefix resd 1
	
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
						;10 or 0xA but it is 0804A02C which means nothing
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
	cmp al, '/'
	je infix_middle
	cmp al, '*'
	je infix_middle
	cmp al, '-'
	je infix_middle
	cmp al, '+'
	je infix_middle
	mov edx, ecx
	add [count],byte 1
	inc ecx
	cmp al, 0	;A
	je return

	jmp middle
	ret
return:
	ret
	
infix_first:
	mov [infix + ebx], byte'('
	inc ebx
	mov al, [input + ecx - 2]
	mov [infix + ebx], eax		;it is only adding this]
	inc ebx
	mov al,[input + ecx]
	mov [infix + ebx], al	;operator
	inc ebx
	mov al, [input + ecx - 1]
	mov [infix + ebx], eax
	inc ebx
	mov [infix + ebx], byte')'
	
	;push eax		;when commented out, does not cause segmentation error
	;call print_char
	
	xor eax, eax
	inc ecx
	sub [count], byte 2
	jmp middle
infix_middle:
	xor eax,eax
	mov [tmp], byte'(' ;adds 
	inc ebx
	cmp [count], byte 1
	jg infix_first
	cmp [count], byte 1
	jl infix_inner
	doing:
	mov al, [infix + ebx-1]
	mov [tmp+ebx], al
	inc ebx
	cmp al, 0
	jne doing
	
	dec ebx
	xor eax,eax
	mov al, [input + ecx]
	mov [tmp+ebx], al
	mov al, [input + edx]
	inc ebx
	mov [tmp+ebx],al
	inc ebx
	mov [tmp+ebx],byte')'
	xor ebx,ebx
	xor eax,eax
	
	looping:
	

	mov al,[tmp+ebx]
	mov [infix+ebx],al
	inc ebx
	cmp al,0
	jne looping
	inc ecx
	mov [count], byte 0
	jmp middle
	
infix_inner:
	xor edx,edx
	find_inner:
	mov al, [infix + edx]
	inc edx
	cmp al,'('
	je counter_open
	cmp al,')'
	je counter_close
	back:
	cmp [counter],byte 0
	jne find_inner
	mov al, [input + ecx]
	inc ecx
	move_right:
	cmp al,0
	je middle
	mov ah, [infix + edx]
	mov [infix + edx], al
	inc edx
	mov al, [infix + edx]
	mov [infix + edx], ah
	inc edx
	cmp ah,0
	jne move_right
	jmp middle
counter_open:
	add [counter], byte 1
	jmp back
counter_close:
	sub [counter], byte 1
	jmp back
	
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call read_postfix
	call postfix_to_infix
	xor ecx,ecx
	mov eax, infix
	call print_string
	call print_nl
	
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

