

;  hello_world.asm 
;  Print a message on the screen
;  Assemble:  nasm -f elf hello.asm 
;  Link:      gcc -o hello hello.o   

	section .data 
msg:	db "Hello World",10 ; 10 is CR 
len:	equ $-msg           ; length of string 

	section .text           ; code section  
	global main  
main: 
	mov edx,len 
	mov ecx,msg 
	mov ebx,1 
	mov eax,4 
	int 0x80                ; kernel interrupt  
	
	mov ebx,0 
	mov eax,1  
	int 0x80 
	
	 
