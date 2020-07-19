%macro intr 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
	
section .bss
	comm resb 10
	fname1 resb 50
	fd1 resb 50
	fname2 resb 50
	fd2 resb 50
	string resb 1000
	size1 resb 10
	
section .text
	global _start
	
_start:	
	pop rax
	pop rax
	pop rax
	mov rsi,rax
	mov bl,byte[rsi]
	mov [comm],	bl
	b1:
	
	cmp byte[comm],'t'
	je opr1
	
	cmp byte[comm],'d'
	je opr2
	
	cmp byte[comm],'c'
	je opr3
	
	jmp exit
	
opr1:
	pop rax
	mov rbx,rax
	mov [fname1],rbx
	
	intr 2,[fname1],2,0777
	mov [fd1],rax
	
	bt rax,63
	jc exit
	
	intr 0,[fd1],string,1000			;read contents of file into string 
	mov [size1],rax
	
	mov eax,4
	mov ebx,1
	mov ecx,string
	mov edx,[size1]
	int 80h
	
	mov rax,3
	mov rdi,[fd1]
	syscall
	
	jmp exit
	
opr3:
	pop rax
	mov rbx,rax
	mov [fname1],rbx
	
	pop rax
	mov rbx,rax
	mov [fname2],rbx
	
	intr 2,[fname1],2,0777
	mov [fd1],rax
	
	bt rax,63
	jc exit
	
	intr 0,[fd1],string,1000			;read contents of file into string 
	mov [size1],rax
	
	mov rax,3
	mov rdi,[fd1]
	syscall
	
	intr 2,[fname2],0102o,0660o
	mov [fd2],rax
	
	bt rax,63
	jc exit
	
	intr 1,[fd2],string,[size1]
	
	mov rax,3
	mov rdi,[fd1]
	syscall
	
	jmp exit
	
opr2:
	pop rax
	mov rbx,rax
	mov [fname1],rbx
	
	mov rax,87
	mov rdi,[fname1]
	syscall
	
exit:
	mov eax,1
	int 0x80	
	
