;
; Read disk utility for boot sector
;
[BITS 16]
READ_DISK:
pusha			; Push all to stack
push dx			; Push DX to stack to save the drive number and sectors to read

mov al, dh		; Sectors to read
mov ah, 0x02		; INTR 0x13, ah = 0x02
mov ch, 0x00		; Cylinder
mov cl, 0x02		; Sector = 0x02 
mov dh, 0x00		; Head

int 0x13		; Issue INTR to read
jc disk_read_error	; Error to read disk

pop dx			; Pop saved sectors to read
cmp al, dh		; Check if correct sectors read
jne sector_read_error	; Wrong sectors read

mov bx, DISK_READ_SUCCESS_MSG
call PRINT_MSG_16_BIT
call NEW_LINE

popa			; Pop all once complete
ret


disk_read_error:
mov bx, DISK_READ_ERROR_MSG
call PRINT_MSG_16_BIT
call NEW_LINE

mov dh, ah		; Error value will be available in ah
call PRINT_HEX_16_BIT
call NEW_LINE

jmp error_loop		; Keep looping on error


sector_read_error:
mov bx, SECT_READ_ERROR_MSG
call PRINT_MSG_16_BIT
call NEW_LINE


error_loop:
jmp $


; constants
DISK_READ_ERROR_MSG: db "DISK READ ERROR", 0
SECT_READ_ERROR_MSG: db "SECTOR READ ERROR", 0
DISK_READ_SUCCESS_MSG: db "DISK READ SUCCESS", 0
