;
;
;Names: Garrett Ludskey and Justin Mulrooney
;Course: CS 3230, Section 2, Spring 2017
;Purpose: This programs takes in a postfix expression and then
;		  outputs the expression in infix and prefix formatting.
;
;Note: the prefix only works with 3 opeands and two opeartors. Such as
;      ab*c- it will output *ab-c
;
;
;Input: The input is a postfix expression
;
;
;Output: The output is a prefix and infix expression
;


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

;--------------------------------------------------------------
;This subprogram takes in the input from the user and stores it
;in an variable, input
;--------------------------------------------------------------	
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
	je return
	jne do

;--------------------------------------------------------------
;This subprogram takes the input in postfix form and makes it in
;infix form. It loops and calls infix_first
;--------------------------------------------------------------			
postfix_to_infix:
	xor ecx,ecx
	xor edx, edx
	xor ebx,ebx
	xor eax, eax
	first:
	mov al,[input + ecx]
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
	
;--------------------------------------------------------------
;This subprogram is called whenever we need a ret
;--------------------------------------------------------------
return:
	ret
;--------------------------------------------------------------
;This subprogram is called to finish the postfix expression and
;then it adds parenthesis where needed
;--------------------------------------------------------------	
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
	
;--------------------------------------------------------------
;This subprogram is called to take in a prefix expression and
;then call the correct subprogram depending on what pass it is in
;--------------------------------------------------------------		
postfix_to_prefix:
	xor ecx, ecx
	xor edx, edx
	xor eax,eax
	the_great_loop:
	mov al, [input + ecx]
	cmp al, '/'
	je prefix_first
	cmp al, '*'
	je prefix_first
	cmp al, '-'
	je prefix_first
	cmp al, '+'
	je prefix_first
	cmp al, 0	;A
	je return

	inc ecx
	jmp the_great_loop
;--------------------------------------------------------------
;This subprogram is called durring the first pass and gets the first
; two operands and the first operator. It places the first operator
;in front of the first two operands
;--------------------------------------------------------------			
prefix_first:
	mov [prefix + edx], eax
	mov al, [input + ecx - 2]
	inc edx
	mov [prefix + edx], eax	
	mov al, [input + ecx - 1]
	inc edx
	mov [prefix + edx], eax
	inc ecx
	jmp the_greater_loop
;--------------------------------------------------------------
;This subprogram is called from prefix second so that it will call
;the correct subprogram after the first pass
;--------------------------------------------------------------			
postfix_to_prefix_second:
	the_greater_loop:
	mov al, [input + ecx]
	cmp al, '/'
	je prefix_second
	cmp al, '*'
	je prefix_second
	cmp al, '-'
	je prefix_second
	cmp al, '+'
	je prefix_second
	cmp al, 0	;A
	je return
	inc ecx
	jmp the_greater_loop
;--------------------------------------------------------------
;This subprogram is called durring the second pass. It puts the
; operand in front of the last operand
;--------------------------------------------------------------			
prefix_second:
	inc edx
	mov [prefix + edx], eax
	mov al, [input + ecx - 1]
	inc edx
	mov [prefix + edx], eax
	inc edx
	inc ecx
	jmp the_greater_loop
	
_asm_main:
	enter   0,0               ; setup routine
	pusha
	call read_postfix
	call postfix_to_infix
	call postfix_to_prefix
	mov eax, prefix
	call print_string
	call print_nl
	xor ecx,ecx
	mov eax, infix
	call print_string
	call print_nl
	
	popa
	mov     eax, 0            ; return back to C
	leave                     
	ret

