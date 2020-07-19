section .data
	msg1 db "Input first number",10
	l1 equ $- msg1
	msg2 db "Input second number",10
	l2 equ $- msg2
	msg3 db "1. Add and shift",10
		 db	"2. Successive Addition",10
	lm3 equ $- msg3
	
section .bss	
	num1 resb 2
	num2 resb 2
	result resb 8
	choice resb 1

section .text
	global main
	
main:
	mov eax,4				;display first message
	mov ebx,1
	mov ecx,msg1
	mov edx,l1
	int 0x80
	
	mov eax,3				;take first input
	mov ebx,0
	mov ecx,num1
	mov edx,3
	int 0x80

	mov ebx,[num1]
	
	xor rbx,rbx
	mov rsi,num1 			;move address of hexnum into esi
	call ascii_to_hex
	
fnum:	
	mov [num1],rbx			;move final number in num1
	
	mov eax,4				;display second message
	mov ebx,1
	mov ecx,msg2
	mov edx,l2
	int 0x80
	
	mov eax,3				;read second number
	mov ebx,0
	mov ecx,num2
	mov edx,3
	int 0x80
	
	mov ebx,[num1]
	
	xor rbx,rbx
	mov esi,num2 			;move address of hexnum into esi
	call ascii_to_hex

snum:	
	mov [num2],rbx			;move final number in num2
	
	mov eax,4				;display choice message
	mov ebx,1
	mov ecx,msg3
	mov edx,lm3
	int 0x80
	
	mov eax,3				;read choice number
	mov ebx,0
	mov ecx,choice 
	mov edx,2
	int 0x80
	
	xor eax,eax
	xor ebx,ebx
	xor ecx,ecx
	xor edx,edx
	
	compare:
	mov eax,[num1]
	mov ebx,[num2]
	cmp eax,ebx				;compare which number is smaller
	jb less1
	
	less2:					;if num2 is smaller
	xor eax,eax
	xor ecx,ecx
	xor ebx,ebx
	mov al,byte[num1]		;move first number into accumulator
	mov cl,byte[num2]		;move second number into counter
	jmp method
	
	less1:					;if num1 is smaller
	xor eax,eax
	xor ecx,ecx
	xor ebx,ebx
	mov al,byte[num2]		;move second number into accumulator
	mov cl,byte[num1]		;move first number into counter
	
method:
	cmp byte[choice],'2'
	je con
	
add_shift:
	xor edx,edx
	mov ebx,ecx				
	mov cx,16				;move 16 into counter
	lab:
	shr bx,1				;shift multiplier right by 1
	jnc skip
	add edx,eax				;add if carry flag is set
	skip:
	shl eax,1				;double first number
	dec ecx					;decrement counter
	jnz lab
	mov ebx,edx
	jmp hex_to_ascii
	
con:					;successive addition
	add ebx,eax
	dec ecx
	jnz con
	
hex_to_ascii:
	mov edx,ebx				;store final value in edx
	mov rcx,4				;move length to counter	
	mov rdi,result			;store destination address in register
	
	l20: 
	rol dx,04H				;rotate edx by 4
	mov al,dl			
	and al,0FH				;perform and operation on value in al
	cmp al,09H
	jbe l3
	add al,07H				;add additional value if number is above 10
	l3: add al,30H			;convert hex to ascii number
	mov byte[rdi],al		;move value in al to sum
	inc rdi			
	loop l20
	
rnum:		
	mov eax,4				;write result
	mov ebx,1
	mov ecx,result
	mov edx,4
	int 0x80
	
		
exit:
	mov eax,1
	int 0x80	
	
ascii_to_hex:
	mov ecx,02H				;move length into counter
	xor rbx,rbx
	l4:
	rol bx,4	
	mov al,byte[rsi]
	cmp al,5BH
	jbe la
	sub al,20H
	la:
	cmp al,39H				;compare with value of 0-9
	jbe l5
	sub al,07H				;subtract additional value if number is above 10
	l5: sub ax,30H			;convert hex to ascii number
	add bl,al
	inc rsi	
	loop l4
	ret
	
	
