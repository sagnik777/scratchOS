;
; GDT for boot sector
;

GDT_START:
dd 0x0			; First 8 bytes must be NULL
dd 0x0


GDT_CODE:
dw 0xffff		; Lower Limit (Bits 0:15) = ffff
dw 0x0			; Base Low (Bits 0:15) = 0000
db 0x0			; Base Med (Bits 16:23) = 00
db 10011010b		; Access Flags
db 11001111b		; Granularity Flags
db 0x0			; Base High (Bits 24:31) = 00


GDT_DATA:
dw 0xffff		; Lower limit (0:15) = ffff
dw 0x0			; Base Low (0:15) = 0
db 0x0			; Base Med (16:23) = 0
db 10010010b		; Access Flags
db 11001111b		; Granularity Flags
db 0x0			; Base High (24:31) = 0


GDT_END:


GDT_DESCRIPTOR:
dw GDT_END - GDT_START - 1	; Size of gdt (16 Bits)
dd GDT_START			; Address of start (32 Bits)


; Constants
CODE_SEG equ GDT_CODE - GDT_START
DATA_SEG equ GDT_DATA - GDT_START
