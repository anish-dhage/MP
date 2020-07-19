

.model tiny
.286
org 100h


code segment
     assume cs:code,ds:code,es:code
        old_ip dw 00
        old_cs dw 00
jmp init

my_tsr:
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        push es

        mov ax,0b800h    ;address of video ram
        mov es,ax
        mov di,2000

        mov ah,02h   ;to get system clock
        int 1ah    ;ch=hrs, cl=mins,dh=sec      
        mov bx,cx

        mov cl,2
loop1:  rol bh,4
        mov al,bh
        and al,0fh
        add al,30h
        mov ah,17h
        mov es:[di],ax
        inc di
        inc di
        dec cl
        jnz loop1

        mov al,':'
        mov ah,97h
        mov es:[di],ax
        inc di
        inc di

        mov cl,2
loop2:  rol bl,4
        mov al,bl
        and al,0fh
        add al,30h
        mov ah,17h
        mov es:[di],ax
        inc di
        inc di
        dec cl
        jnz loop2

        mov al,':'
        mov ah,97h
        mov es:[di],ax

        inc di
        inc di

        mov cl,2
        mov bl,dh

loop3:  rol bl,4
        mov al,bl
        and al,0fh
        add al,30h
        mov ah,17h
        mov es:[di],ax
        inc di
        inc di
        dec cl
        jnz loop3

        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax

        

init:
        mov ax,cs    ;initialize data
        mov ds,ax

        cli    ;clear interrupt flag

        mov ah,35h   ;get interrupt vector data and         store it
        mov al,08h
        int 21h

        mov old_ip,bx
        mov old_cs,es

        mov ah,25h   ;set new interrupt vector
        mov al,08h
        lea dx,my_tsr
        int 21h

        mov ah,31h   ;make program transient
        mov dx,offset init
        sti
        int 21h

code ends

end
