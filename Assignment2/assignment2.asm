section .data
array1 db "AnishABCD",'\'  ;first block	

section .bss
len resb 2
choice resb 1

section .text
	global main
	
main:	
	mov eax,3			;read choice
	mov ebx,0
	mov ecx,choice
	mov edx,1
	int 0x80
	
	mov eax,'\' 		;move delimiter into register
	mov esi,array1		;move base address into register
	mov ecx,0			;set counter to zero
	
len1:
	mov ebx,[esi]		;move value at address into register
	cmp eax,ebx			;compare ascii values
	je len2				;exit if equal
	add esi,1			;increment address
	inc ecx				;increment length counter
	jmp len1
	
len2:
	mov edx,[choice]
	mov al,byte[choice]	;move choice into eax and jump to desired choice
	cmp al,'w'
	je up1
	cmp al,'a'
	je left1
	cmp al,'s'
	je down1
	cmp al,'d'
	je right1
	
up1:
	mov [len],ecx		 ;store length in variable
	mov ecx,[len]
	mov esi,array1		 ;move base address of source into register
	mov edi,array1+100	 ;move base address of destination into register
	jmp comp
	
down1:	
	mov [len],ecx		 ;store length in variable
	mov ecx,[len]
	mov esi,array1		 ;move base address of source into register
	mov edi,array1-100	 ;move base address of destination into register
	jmp comp
	
left1:
	mov [len],ecx		 ;store length in variable
	mov ecx,[len]
	mov esi,array1		 ;move base address of source into register
	mov edi,array1-3	 ;move base address of destination into register
	jmp comp
	
right1:
	mov [len],ecx		 ;store length in variable
	mov ecx,[len]
	mov esi,array1		 ;move base address of source into register
	mov edi,array1+3	 ;move base address of destination into register			

comp:	
	mov eax,esi			 ;move value of source address into eax
	mov ebx,edi			 ;move value of destination address into ebx
	sub eax,ebx			 ;find difference
	cmp eax,0			
	jl label1			 ;jump if difference is negative
	cmp eax,0
	je exit				 ;exit if addresses are equal
	
label2:
	mov al,byte[esi]	 ;move value at address into eax
	mov byte[edi],al	 ;move value at eax into address
	add esi,1			 ;increment address of source
	add edi,1			 ;increment address of destination
	dec ecx				 ;decrement counter
	jnz label2			 ;jump if not zero
	jz write
		
		
label1:
	add edi,ecx			 ;add length to destination address as we copy from last element
	add esi,ecx			 ;add length to source address as we copy from last element
	add ecx,1
	
label3:
	mov al,0
	mov al,byte[esi]	 ;move value at address into eax
	mov byte[edi],al	 ;move value at eax into address
	sub esi,1			 ;decrement address of source
	sub edi,1		     ;decrement address of destination
	dec ecx				 ;decrement counter
	jnz label3			 ;jump if not zero
	
write:
	mov eax,edx			 ;move choice into eax and jump to desired choice
	cmp eax,'w'
	je write1
	cmp eax,'a'
	je write2
	cmp eax,'s'
	je write3
	cmp eax,'d'
	je write4	
	jmp exit
	
write1:	
	mov eax,4 			 ;write message in destination array
	mov ebx,1
	mov ecx,array1+100
	mov edx,[len]
	int 0x80
	jmp exit
	
write2:	
	mov eax,4 			 ;write message in destination array
	mov ebx,1
	mov ecx,array1-3
	mov edx,12
	int 0x80
	jmp exit
	
write3:	
	mov eax,4 			 ;write message in destination array
	mov ebx,1
	mov ecx,array1-100
	mov edx,[len]
	int 0x80	
	jmp exit

write4:	
	mov eax,4 			 ;write message in destination array
	mov ebx,1
	mov ecx,array1
	mov edx,12
	int 0x80		
	
exit:	
	mov eax,1
	int 0x80	

		
