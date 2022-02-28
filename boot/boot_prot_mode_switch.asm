;
; Utility to seitch to 32 Bit protected mode
;
[BITS 16]
SWITCH_PROTECT_MODE:
cli 			; Clear all INTRs
lgdt [GDT_DESCRIPTOR]	; Load custom gdt

mov eax, cr0		; Copy Bit 1 of Control Register
or eax, 0x1		; SET Bit 1 => Switch to 32 Bit Mode
mov cr0, eax		; Update CR

jmp CODE_SEG:init_prot_mode	; Far jump


[BITS 32]
init_prot_mode:

mov ax, DATA_SEG	; Update all segment registers
mov ds, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax

mov ebp, 0x90000	; Update Stack location to 90000h
mov esp, ebp

call INIT_PROTECT_MODE	; Call to start kernel code
