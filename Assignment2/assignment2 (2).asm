;non overlapping 28
section .data

msg db "1. original array",10
    db "2. display copied array using non overlapping method",10
    db "3. display copied array using overlapping method",10
    db "4. display copied array using non overlapping string method",10
    db "5. display copied array using overlapping string method",10	
    db "6. Exit",10
len equ $-msg

msg2 db 10
len2 equ $-msg2

msg1 db "Enter your choice",10
len1 equ $-msg1

array dq 0x0123456789012345 , 0x1234567890123456 , 0x2345678901234567 , 0x3456789012345678 , 0x4567890123456789 ,0x0000000000000000,0x0000000000000000


section .bss

count resb 2
count1 resb 2
result resb 16
choice resb 2

%macro print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .text

global _start:
_start:

menu:
; write the menu
mov rax,1
mov rdi,1
mov rsi,msg
mov rdx,len
syscall

; write the choice statement
mov rax,1
mov rdi,1
mov rsi,msg1
mov rdx,len1
syscall

; get the choice
mov rax,0
mov rdi,1
mov rsi,choice
mov rdx,2
syscall

; case statements
cmp byte[choice],31H
jz original
cmp byte[choice],32H
je nonoverlap
cmp byte[choice],33H
jz o
cmp byte[choice],34H
je nonoverlaps
cmp byte[choice],35H
jz os
cmp byte[choice],36H
jz exit

; HEX to ASCII

h2a:	mov rcx,10H
	mov rdi,result
	l5: rol rdx,04H
	mov al,dl
	and al,0FH
	cmp al,09H	
	jbe l6
	add al,07H
	l6: add al,30H
	mov byte[rdi],al
	inc rdi
	loop l5
	print result,16
	ret

; original array display

original:mov rsi,array
	mov byte[count],05H
	l1:	mov rdx,rsi
		push rsi
	   	call h2a ; address display
		print msg2,len2
		pop rsi
		mov rdx,qword[rsi]
		push rsi
		call h2a ; value display
		print msg2,len2
		print msg2,len2
		pop rsi
		add rsi,08H
		dec byte[count]
		jnz l1
		jmp menu

; non-overlapping method

nonoverlap: 
	mov byte[count1],05H
	mov rsi,array
	mov rdi,array+100
	A2: mov rbx,qword[rsi]
	    mov qword[rdi],rbx
	    add rsi,08
	    add rdi,08
	    dec byte[count1]
	    jnz A2
	mov rsi,array+100
	mov byte[count1],05H
	l11:	mov rdx,rsi
		push rsi
	   	call h2a ; address display
		print msg2,len2
		pop rsi
		mov rdx,qword[rsi]
		push rsi
		call h2a ; value display
		print msg2,len2
		print msg2,len2
		pop rsi
		add rsi,08H
		dec byte[count1]
		jnz l11
	
	    jmp menu 	 

; overlapping method
o:
	

	mov byte[count1],05
	mov rdi,array+16
	mov rsi,array+100
	A26: mov rbx,qword[rsi]
	    mov qword[rdi],rbx
	    add rsi,08H
	    add rdi,08H
	    dec byte[count1]
	    jnz A26
	mov byte[count1],07
	mov rsi,array
	l131:	mov rdx,rsi
		push rsi
	   	call h2a ; address display
		print msg2,len2
		pop rsi
		mov rdx,qword[rsi]
		push rsi
		call h2a ; value display
		print msg2,len2
		print msg2,len2
		pop rsi
		add rsi,08
		dec byte[count1]
		jnz l131
	
		jmp menu

; non overlapping string

nonoverlaps:

	mov rcx,05
	mov rsi,array
	mov rdi,array+100
	repnz movsq
	mov rsi,array+100
	mov byte[count1],05H
	l9:	mov rdx,rsi
		push rsi
	   	call h2a ; address display
		print msg2,len2
		pop rsi
		mov rdx,qword[rsi]
		push rsi
		call h2a ; value display
		print msg2,len2
		print msg2,len2
		pop rsi
		add rsi,08H
		dec byte[count1]
		jnz l9
	
		jmp menu


; overlapping string

os:
	mov rcx,05
	mov rdi,array+16
	mov rsi,array+100	
	repnz movsq
	mov rsi,array
	mov byte[count1],07H
	lii:	mov rdx,rsi
		push rsi
	   	call h2a ; address display
		print msg2,len2
		pop rsi
		mov rdx,qword[rsi]
		push rsi
		call h2a ; value display
		print msg2,len2
		print msg2,len2
		pop rsi
		add rsi,08H
		dec byte[count1]
		jnz lii

		jmp menu

; exit
exit:   mov rax,60
	mov rdi,0
	syscall	
