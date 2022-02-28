;
; Main Boot code
;
[ORG 0x7c00]
KERNEL_OFFSET equ 0x1000	; Kernel code linked at Memory Location 1000h

mov [DRIVE_NUMBER], dl		; Read the drive number and save for disk_read

mov bp, 0x9000			; Move Base and Stack pointers to safe location
mov sp, bp

mov bx, MSG_REAL_MODE		; Inform user of Code running in 16 BIT mode
call PRINT_MSG_16_BIT	
call NEW_LINE

call LOAD_KERNEL		; Load the kernel from disk

call SWITCH_PROTECT_MODE	; Switch to 32 BIT protected Mode
jmp $				; END


; Includes
%include "./boot/boot_gdt.asm"
%include "./boot/boot_print_16.asm"
%include "./boot/boot_print_32.asm"
%include "./boot/boot_prot_mode_switch.asm"
%include "./boot/boot_read_disk.asm"


[BITS 16]
LOAD_KERNEL:
mov bx, MSG_LOAD_KERNEL		; Inform User of Kernel Loading process
call PRINT_MSG_16_BIT
call NEW_LINE

mov bx, KERNEL_OFFSET		; Read from disk and store in 0x1000 -> Kernel location
mov dh, 16			; Read 16 sectors -> BIG KERNEL
mov dl, [DRIVE_NUMBER]		; Copy the drive number to dl
call READ_DISK			; Read disk, using INTR 0x13,2
ret				; Return to caller


[BITS 32]
INIT_PROTECT_MODE:
mov ebx, MSG_PROTECT_MODE	; Inform user of 32 Bit mode started
call PRINT_MSG_32_BIT
call KERNEL_OFFSET		; Handover to Kernel Code
jmp $


; Constants
DRIVE_NUMBER db 0		; Memory to read drive details for reading from disk
MSG_REAL_MODE db "In Boot Sector, 16 Bit Real Mode", 0
MSG_LOAD_KERNEL db "Loading Kernel", 0
MSG_PROTECT_MODE db "In 32 Bit Protected Mode", 0


; Padding anf Magic Number
times 510 - ($-$$) db 0
dw 0xaa55
