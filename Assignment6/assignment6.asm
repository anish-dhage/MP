%macro print 2
mov eax,4
mov ebx,1
mov ecx,%1
mov edx,%2
int 0x80
%endmacro

section .data
	msg1 db "In Protected Mode"
	lm1 equ $- msg1
	msg2 db 10,"GDTR : "
	lm2 equ $- msg2
	msg3 db 10,"IDTR : "
	lm3 equ $- msg3
	msg4 db 10,"LDTR : "
	lm4 equ $- msg4
	msg5 db 10,"TR : "
	lm5 equ $- msg5
	space db ":"
	
section .bss
	p_msw resw 1
	p_gdtr resw 3
	p_idtr resw 3
	p_ldtr resw 1
	p_tr resw 1
	buff resb 4
	
section .text
	global main
	
main:
	smsw [p_msw]			;store contents of msw in variable
	mov eax,[p_msw]			;move contents to register
	bt eax,0				;test lsb which is Protection Enable bit
	jnc exit				;jump to exit if PE bit is not set
	
lab1:
	mov eax,4				;write message 
	mov ebx,1
	mov ecx,msg1
	mov edx,lm1
	int 0x80	

lab2:
	print msg2,lm2
	sgdt [p_gdtr]			;store contents of gdtr in variable
	mov dx, word[p_gdtr+4]
	call hex_to_ascii
	mov dx, word[p_gdtr+2]
	call hex_to_ascii
	mov dx, word[p_gdtr]	
	call hex_to_ascii
	
lab3:	
	print msg3,lm3
	sidt [p_idtr]			;store contents of idtr in variable
	mov dx, word[p_idtr+4]
	call hex_to_ascii
	mov dx, word[p_idtr+2]
	call hex_to_ascii
	mov dx, word[p_idtr]
	call hex_to_ascii
	
lab4:	
	print msg4,lm4
	sldt [p_ldtr]			;store contents of ldtr in variable
	mov dx, word[p_ldtr]
	call hex_to_ascii
		
lab5:
	print msg5,lm5
	str [p_tr]			;store contents of ldtr in variable
	mov dx, word[p_tr]
	call hex_to_ascii
			
exit:
	mov eax,1
	int 0x80
	
hex_to_ascii: 
	mov ecx,4
	mov rdi,buff
	
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
	
	mov eax,4
	mov ebx,1
	mov ecx,buff
	mov edx,4
	int 0x80
	ret	
