section .data
choice db "1. HEX to DEC",10
	   db "2. DEC to HEX",10	 
	   db "3. Exit",10
lc equ $- choice	 

hp db "H",10
lhp equ $- hp

enternum db "Enter Number : ",10
le equ $- enternum  
	   	   		
section .bss
op resb 1
decimal resb 16
hexnum resb 8
sum resb 5
count resb 2

section .text
	global main
	
main:
	xor rcx,rcx

	;mov eax,4				;write choices
	;mov ebx,1
	;mov ecx,choice
	;mov edx,lc
	;int 0x80
	
	;mov eax,3				;read option
	;mov ebx,0
	;mov ecx,op
	;mov edx,2
	;int 0x80

	pop rdx					;pop number of arguments(argv)
	pop rdx					;pop name of file
	pop rdx					;pop first argument
	
	mov rcx,[rdx]
	
	mov [op],cx
	
	pop rdx					;pop second argument
	mov rcx,[rdx]
	
	mov [hexnum],ecx
	mov [decimal],rcx
	
	cmp byte[op],'H'		;jump to hex to bcd conversion
	je hex_dec
	
	cmp byte[op],'D'		;jump to bcd to hex conversion
	je dec_hex
	
	cmp byte[op],'E'
	je exit
	
hex_dec:

	;mov eax,4 				;write choices
	;mov ebx,1
	;mov ecx,enternum
	;mov edx,le
	;int 0x80
	
	;mov eax,3				;read option
	;mov ebx,0
	;mov ecx,hexnum
	;mov edx,4
	;int 0x80
	
ascii_to_hex:
	mov esi,hexnum  		;move value of hexnum into edx
	mov ecx,4				;move length into counter
	xor bx,bx
	l4:
	rol bx,4	
	mov al,byte[esi]
	cmp al,39H				;compare with value of 0-9
	jbe l5
	sub al,07H				;subtract additional value if number is above 10
	l5: sub ax,30H			;convert hex to ascii number
	add bl,al
	inc esi	
	loop l4

	xor rax,rax				;clear rax
	xor rdx,rdx				;clear rdx
	mov byte[count],0
	mov rax,rbx				;store number in rax
	mov rbx,0AH				
	l6:
 	div rbx					;divide number in rax by 10
    push dx 				;store remainder in stack
	inc byte[count]			;increment counter
    xor rdx,rdx				;clear remainder
	cmp rax,00H				;see if number has been fully divided
	jnz l6
	l7:
	pop dx					;pop number from stack
	add dx,30H				;convert to equivalent ascii form
	mov byte[decimal],dl	
	
	mov eax,4 				;write choices
	mov ebx,1
	mov ecx,decimal
	mov edx,1
	int 0x80
	
	dec byte[count]
	jnz l7
	
	jmp exit
	
dec_hex:

	;mov eax,4 				;write choices
	;mov ebx,1
	;mov ecx,enternum
	;mov edx,le
	;int 0x80
	
	;mov eax,3				;read option
	;mov ebx,0
	;mov ecx,decimal
	;mov edx,5
	;int 0x80
		
	mov esi,decimal			;move address of first digit into register 
	mov bl,0AH				;move multiplier into register
	mov ecx,5				;move count into register
	xor eax,eax				;clear register eax,edx
	xor edx,edx
	mov word[sum],0
	
	l1:
	mul ebx
	mov dl,byte[esi] 		;move value into register
	sub dl,30H				;convert from ascii to hex
	add ax,dx				;add to sum
	inc esi
	dec ecx
	jnz l1
	
hex_to_ascii:
	mov edx,eax				;store final value in edx
	mov rcx,4				;move length to counter	
	mov rdi,sum				;store destination address in register
	
	l2: 
	rol dx,04H				;rotate edx by 4
	mov al,dl			
	and al,0FH				;perform and operation on value in al
	cmp al,09H
	jbe l3
	add al,07H				;add additional value if number is above 10
	l3: add al,30H			;convert hex to ascii number
	mov byte[rdi],al		;move value in al to sum
	inc rdi			
	loop l2
	
	mov eax,4 				;write final answer
	mov ebx,1
	mov ecx,sum
	mov edx,4
	int 0x80
	
	mov eax,4 				;write final answer
	mov ebx,1
	mov ecx,hp
	mov edx,lhp
	int 0x80
	
				
exit:
	mov eax,1
	int 0x80	
	
	
	
	

