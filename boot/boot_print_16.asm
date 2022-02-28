;
; Print Utility for boot sector
; Support only 16 bit mode
;
[BITS 16]
PRINT_MSG_16_BIT:
pusha			; Push all to stack


print:
mov ah, 0x0e		; INTR 0x10, AH 0x0e
mov al, [bx]		; Load string sent in bx to al
cmp al, 0		; Check if string end is reached
je print_done		; Complete
int 0x10		; INTR to print on screen
add bx, 1		; Increment pointer
jmp print		; Loop


print_done:
popa			; Pop all from stack
ret


NEW_LINE:
pusha			; Push all to stack
mov ah, 0x0e		; INTR 0x10, 0x0e
mov al, 0x0a		; NEW LINE CHARACTER
int 0x10		; Print
mov al, 0x0d		; CARRIAGE RETURN
int 0x10		; Print
popa			; Pop all
ret


PRINT_HEX_16_BIT:
pusha               	; Push all to stack
mov cx, 0		; Index


hex_loop:
cmp cx, 4  	        ; Loop 4 times
je hex_done

mov ax, dx      	; Move data to working register
and ax, 0x000f     	; Only choose last digit
add al, 0x30        	; Convert number to ascii string
cmp al, 0x39        	; Check if more than 9
jle ascii_loop      	; Create new ascii string
add al, 7           	; "A" is 65 -> so add 7


ascii_loop:
mov bx, OUT_MEMORY+5	; Base add+length
sub bx, cx          	; Index variable
mov [bx], al        	; Copy to position
ror dx, 4           	; Rotate org data
add cx, 1           	; Increment counter
jmp hex_loop


hex_done:
mov bx, OUT_MEMORY   	; Move data to bx and call print
call PRINT_MSG_16_BIT	; Call printer for string print

popa                	; Pop all from stack
ret                 	; Return to caller


OUT_MEMORY: db '0x0000', 0      ; Reserve memory for new string
