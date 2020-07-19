%macro intr 4
mov rax,%1
mov rdi,%2
mov rsi,%3
mov rdx,%4
syscall
%endmacro

section .data
	filename db "nums.txt",0
	
section .bss
	desc resb 1024
	string resb 1024
	size resb 8
	count1 resb 4
	count2 resb 4

section .text
	global main
	
main:
	intr 2,filename,2,0777				;open file
	
	bt rax,63							;bit test to check if file is open 
	jc exit								;jump if file not open
	
	mov [desc],rax						;handle descriptor using eax
	push rax
	
	intr 0,[desc],string,1000			;read contents of file into string 
	
	mov [size],rax						;store size in variable
	
	mov eax,4
	mov ebx,1
	mov ecx,string
	mov edx,[size]						;write contents of file
	int 0x80
	
	mov ecx,[size]						
	mov esi,string
	mov edx,0
	
	loop1:								;to count total numbers
	mov al,byte[esi]					;move value to register
	cmp al,32
	jne jmp1
	inc edx								;increment if delimiter
	jmp1:
	inc esi
	loop loop1
	
	lab1:
	mov [count1],edx					;store final count
	mov [count2],edx
	mov ecx,edx
	
	loop2:	
	mov [count1],ecx							
	mov esi,string						;store address of string in registers
	mov edi,string+2					
	xor rax,rax
	xor rbx,rbx
		
	loop3:
	mov al,byte[esi]					;move value at addresses to registers
	mov bl,byte[edi]
	
	sub al,bl							;compare values
	cmp al,0
	jl jmp2								;swap if required condition
	mov dl,byte[esi]
	mov al,byte[edi]
	mov byte[esi],al
	mov byte[edi],dl
	jmp2:
	add esi,2							;increment addresses
	add edi,2
	
	push rax
	push rbx
	push rcx
	push rdx
	push rsi
	push rdi
	
	mov eax,4
	mov ebx,1
	mov ecx,string
	mov edx,[size]						;write contents of sorted string
	int 0x80
	
	pop rdi
	pop rsi
	pop rdx 
	pop rcx
	pop rbx
	pop rax 
	
	dec byte[count1]
	jnz loop3
	
	
	dec byte[count2]
	jnz loop2
	
	mov eax,4
	mov ebx,1
	mov ecx,string
	mov edx,[size]						;write contents of sorted string
	int 0x80
	
	b1:
	pop rax
	mov [desc],rax
	intr 1,[desc],string,[size]			;write into file

exit:
	mov rax,3							;close file
	mov rdi,[desc]				
	syscall

	mov eax,1							;exit
	int 0x80
		
