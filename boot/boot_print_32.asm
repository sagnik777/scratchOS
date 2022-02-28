;
; Utility to print in 32 Bit Protected mode
;

[BITS 32]

; Display related Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f		; Colour Byte for each character


PRINT_MSG_32_BIT:
pusha 				; Push all to stack
mov edx, VIDEO_MEMORY

print_loop_32:
mov al, [ebx]			; ebx contains string
mov ah, WHITE_ON_BLACK

cmp al, 0			; Check for end of data
je print_loop_32_done

mov [edx], ax			; Update character + attribute
add ebx, 1			; Next character
add edx, 2			; Next display position

jmp print_loop_32


print_loop_32_done:
popa				; Pop all from stack
ret			
