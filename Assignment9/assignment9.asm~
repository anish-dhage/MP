%macro intr 4
mov eax,%1
mov ebx,%2
mov ecx,%3
mov edx,%4
int 0x80
%endmacro

section .data
	emsg db "Invalid number (number range : 0 - 20)",10
	lemsg equ $- emsg
	
	msg1 db 10
	lmsg1 equ $- msg1
	
section .bss
	num1 resb 16
	num2 resb 8
	count resb 2

section .text
	global main
	
main:
	pop rax				;pop number of arguments
	pop rax				;pop name of program
	pop rsi				;pop number
	
	call ascii_to_hex
	
	mov [count],rcx
	mov [num2],rbx
	
	cmp rbx,20H
	ja exit_msg
	
jmp2:
	mov eax,1
	xor rbx,rbx
	mov rbx,[num2]
	call factorial
	
	b2:
	mov rdx,rax
	mov rdi,num1
	call hex_to_ascii
	
	intr 4,1,num1,16
	
	intr 4,1,msg1,lmsg1
	

exit:
mov rax,1
int 0x80	

exit_msg:
intr 4,1,emsg,lemsg
mov rax,1
int 0x80	

factorial:
	cmp rbx,01H				;check if rbx is 1
	jle jmp4				
	push rbx
	dec rbx					;decrement rbx
	call factorial
	jmp jmp1
	jmp4:
	push 1
	jmp1:
	pop rdx
	mul rdx					;multiply rax with rbx			
	ret
	
hex_to_ascii:
	mov rcx,10H				;move length to counter	
	xor rax,rax
	l20: 
	rol rdx,04H				;rotate edx by 4
	mov al,dl			
	and al,0FH				;perform and operation on value in al
	cmp al,09H
	jbe l30
	add al,07H				;add additional value if number is above 10
	l30: add al,30H			;convert hex to ascii number
	mov byte[rdi],al		;move value in al to sum
	inc rdi			
	loop l20	
	ret		

ascii_to_hex:
	xor rcx,rcx
	xor rbx,rbx
	l4:
	mov al,byte[rsi]		;move number to al
	cmp al,'!'
	je l6
	cmp al,'-'
	je exit_msg
	inc rcx
	rol bx,4				;rotate bx left by 4
	cmp al,5BH				;compare with A-F
	jbe la
	sub al,20H
	la:
	cmp al,39H				;compare with value of 0-9
	jbe l5
	sub al,07H				;subtract additional value if number is above 10
	l5: sub ax,30H			;convert hex to ascii number
	add bl,al
	inc rsi	
	jmp l4
	l6:
	ret
	
