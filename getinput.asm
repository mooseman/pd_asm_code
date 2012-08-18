
;  getinput.asm  
;  Get a string from the keyboard and evaluate it.  
;  
;  Acknowledgement -  
;  This code is by Nathan Campos who has kindly confirmed that 
;  it is in the public domain. 
;  Many thanks to Nathan for doing this!  


; How to call it from the program

main:
    	call getinput
    	
    	mov si, buffer
    	cmp byte[si], 0		; Blank line
    	je main 		; Ignore it
    	
    	mov si, buffer
    	mov di, cmd_help	; Input compare: help
    	call strcmp
    	jc .help
    	
    	mov si, buffer
	mov di, cmd_hello	; Input compare: hello
	call strcmp
    	jc .hello
    	
    	mov si, err_cmd		; input entered is invalid
    	call printf
    	jmp main		; Infinity loop
    	
    	.hello:
    	    mov si, msg_hello
    	    call printf
    	    jmp main
    	
    	.help:
    	    mov si, msg_help
    	    call printf
    	    jmp main


; The function

getinput:
    xor cl, cl
    
    .loop:
    	mov ah, 00h
    	int 16h		; Key press wait
    	
    	cmp al, 08h	; Backspace key
    	je .backspace	; Handle
    	
    	cmp al, 0dh	; Enter key
    	je .enter	; Handle
    	
    	cmp cl, 3fh	; Inputted 63 characters
    	je .loop	; Only backspace and enter are accepted

    	mov ah, 0eh   
    	int 10h
    	
    	stosb
    	inc cl
    	jmp .loop
    	
    .backspace:
    	cmp cl, 0	; Begin of the input
    	je .loop	; Ignore
    	
    	dec di
    	mov byte[di], 0	; Delete character
    	dec cl		; Decrementing the string counter
    	
    	mov ah, 0eh
    	mov al, 08h
    	int 10h		; Print the backspace
    	
    	mov al, ' '
    	int 10h		; Blank character
    	
    	mov al, 08h
    	int 10h		; Backspace one more time
    	
    	jmp .loop	; Goes back to the loop
    	
    .enter:
    	mov al, 0	; Null terminator
    	stosb
    	
    	mov ah, 0eh
    	
    	mov al, 0dh	; Enter character
    	int 10h
    	
    	mov al, 0ah	; Newline character
    	int 10h
    	
    	ret
    	
strcmp:
    .loop:
    	mov al, [si]	; Grab byte from SI
    	mov bl, [di]	; Grab byte from DI
    	cmp al, bl	; Compare if they are equal
    	jne .notequal	; They aren't equal
    	
    	cmp al, 0	; Both bytes are null
    	je .done
    	
    	inc di		; Increment DI
    	inc si		; Increment SI
    	jmp .loop	; Start looping
    	
    .notequal:
    	clc		; Clear the carry flag
    	ret
    
    .done:
    	stc		; Set the carry flag
    	ret

printf:
    lodsb
    mov ah, 0eh
    mov bh, 99h

    .nextchar:
    	lodsb
    	or al, al
        jz .return
        int 10h
        jmp .nextchar

    .return:
        ret
cmd_help db "help", 0
msg_help db " Get help on our forums! :D", 0dh, 0ah, 0
cmd_hello db "hello", 0
msg_hello db " Hi all from Dream.In.Code!", 0dh, 0ah, 0
err_msg db "Input don't have any to compare.", 0dh, 0ah, 0


