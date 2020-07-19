global filename
global desc
global string
global size
global ipchr
global scount

extern counter


section .data
	msg db "Enter your Choice : ",10
		db "1.Count number of spaces",10
		db "2.Count newlines",10
		db "3.Count number of characters",10
	lm equ $- msg
	msg1 db "Enter Character to count : ",10
	lm1 equ $- msg1
		
	;filename1 db "textfile"		;name of file
	
section .bss
	filename resb 20
	desc resb 1000
	string resb 1000
	size resb 4
	scount resb 4
	ipchr resb 2
	choice resb 2
	lf resb 2
	
section .text
	global main
	
main:	
	
	pop rdx					;pop number of arguments(argv)
	pop rdx					;pop name of file
	pop rdx					;pop first argument
	
	mov rsi,rdx
	
	mov rdi,filename
	
	mov ecx,20
	lab10:
	mov al,byte[rsi]
	mov [rdi],al
	inc rsi
	inc	rdi
	loop lab10


	mov eax,5				;open file
	mov ebx,filename		;filename 
	mov ecx,0
	mov edx,0777			;permissions given
	int 0x80

btest:	
	bt eax,31
	jc exit
	
lab2:	
	mov dword[desc],eax		;file descriptor is stored in eax
							;store descriptor in variable
							
	mov eax,3				;read file
	mov ebx,dword[desc]		;descriptor 
	mov ecx,string			;contents of file are stored here	
	mov edx,1024			;length
	int 0x80
	
lab1:	
	mov [size],eax			;move size returned to variable
	
	mov eax,4				;write the string
	mov ebx,1
	mov ecx,string
	mov edx,[size]
	int 0x80
	
	mov eax,4				;write the message
	mov ebx,1
	mov ecx,msg
	mov edx,lm
	int 0x80
	
	mov eax,3				;read choice
	mov ebx,0
	mov ecx,choice
	mov edx,3
	int 0x80
	
	cspaces:				;count spaces
	cmp byte[choice],'1'
	jne cnewline
	mov byte[ipchr],20H		;move ascii value of space
	call counter
	jmp exit
	
	cnewline:				;count number of lines
	cmp byte[choice],'2'
	jne cchar
	mov byte[ipchr],0AH		;move ascii value of newline
	call counter
	jmp exit
	
	cchar:					;count character count 
	mov eax,4				;write the message
	mov ebx,1
	mov ecx,msg1
	mov edx,lm1
	int 0x80
	
	mov eax,3				;input the character to read 
	mov ebx,0
	mov ecx,ipchr
	mov edx,3
	int 0x80

	call counter			;call external function
	
exit:
	mov eax,6				;close file
	mov ebx,[desc]			;file descriptor in ebx
	int 0x80

	mov eax,1
	int 0x80
	
	
	
