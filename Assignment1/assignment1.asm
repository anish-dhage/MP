section	.text
   global main      ;must be declared for linker (ld)
	
main:	            ;tells linker entry point	   
    
    mov edi,l 		;store length into register
    mov esi,myarr 	;base address of array
    mov ecx,0 		;initialize positive counter to 0
    mov edx,0 		;initialize negative counter to 0

	start:
    mov ebx,[esi] 	;move base address into register
    cmp ebx,0 		;update sign flag
    js neg 			;jump if sign flag is set
    inc ecx 		;increment positive counter
    jmp con 		;jump to continue
    
    neg:
    inc edx 		;increment negative counter
    
    con:
    add esi,4 		;increment address by 4 bytes
    dec edi 		;decrement counter
    jnz start 		;jump to start if counter is not zero
    
    add ecx,48 		;convert to ascii value
    add edx,48 
    
    mov [pc],ecx 	;store counts into variables
    mov [nc],edx
    
    mov edx,1		
    mov ecx,pc
    mov ebx,1       ;file descriptor (stdout)
    mov eax,4       ;system call number (sys_write)
    int 0x80		;call kernel
    
    mov edx,1
    mov ecx,nc
    mov ebx,1       ;file descriptor (stdout)
    mov eax,4       ;system call number (sys_write)
    int 0x80        ;call kernel
    
exit:    

    mov	eax,1       ;system call number (sys_exit)
    int	0x80        ;call kernel

section	.data
myarr dd -2,3,4,-5,6,7,8,-9 	;array of 8 elements
l equ 8     		;length of the array
pc db 0     		;positive counter
nc db 0 			;negative counter


 

