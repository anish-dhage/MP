%macro myprintf 1
	mov rdi,formatpf
	mov rax,1
	sub rsp,8
	movsd xmm0,[%1]
	call printf
	add rsp,8
%endmacro
	
%macro myscanf 1
	mov rdi,formatsf
	mov rax,0
	sub rsp,8
	mov rsi,rsp
	call scanf
	mov r8,qword[rsp]
	mov qword[%1],r8
	add rsp,8
%endmacro

%macro write 2
	mov rax,1
	mov rdi,1
	mov rsi,%1
	mov rdx,%2
	syscall
%endmacro

extern printf,scanf

section .data

deci dd 100
m1 db "-",0
lm1 equ $- m1
m2 db ".",0
lm2 equ $- m2
m3 db "Mean is :",0
lm3 equ $- m3
m4 db "Variance is :",0
lm4 equ $- m4
m5 db "Standard deviation is :",0
lm5 equ $- m5
m6 db " ",10,0
lm6 equ $- m6
ft db "%llx",0
arr dq -2.0,-3.0,-4.0,-5.0,-6.0
cnt dq 5.0
formatpf: db "%lf",10,0
formatsf: db "%lf",0

section .bss

temp resq 1
x resq 1
mean resq 1
variance resq 1
sdev resq 1
term1 resq 1
term2 resq 1

section .text
global main
main:

mean1:					;to find mean
mov r15,5		
fldz
mov rsi,arr
back:
fadd qword[rsi]
add rsi,8
dec r15
jnz back

write m3,lm3

fdiv qword[cnt]
fst qword[mean]
fstp qword[x]

myprintf x

var:
mov r15,5
fldz
mov rsi,arr

back1:
fld qword[rsi]
fmul qword[rsi]
add rsi,8
fstp qword[temp]
fadd qword[temp]
dec r15
jnz back1

fdiv qword[cnt]
fstp qword[term1]

fld qword[mean]
fmul qword[mean]
fstp qword[term2]

fld qword[term1]
fsub qword[term2]
fst qword[variance]
fstp qword[x]

write m4,lm4

myprintf x

sdev1:
fld qword[variance]
fsqrt
fst qword[sdev]
fstp qword[x]

write m5,lm5

myprintf x

mov eax,1
int 0x80
