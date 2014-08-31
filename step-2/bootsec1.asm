    bits 16

    ; BIOS loads boot sector into address 0000:7C00
    org 0x7C00
    
    jmp start

message1 db 'Original Boot Sector', 13, 10, 0
message2 db 'Relocated Boot Sector', 13, 10, 0

start:
    ; initialize segment registers and stack
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE

    ; print message1 on screen
    mov ax, message1
    call print

    ; relocate boot sector code to 8000:7C00
    mov ax, 0x8000
    mov es, ax
    mov si, 0x7C00
    mov di, si
    mov cx, 512/2
    rep movsw
    mov [message2], cx  ; destroy old message2 to test relocation
    jmp 0x8000:relocated

relocated:
    mov ax, cs
    mov ds, ax
    mov ss, ax
    mov sp, 0xFFFE

    ; print message2 on screen
    mov ax, message2
    call print

    ; infinite loop to hang the CPU
hang:
    hlt
    jmp hang

    ; function print(string)
print:
    mov si, ax
_2:
    lodsb
    cmp al, 0
    je _3
    mov ah, 0x0E
    int 0x10
    jmp _2
_3:
    ret

    ; fill rest of boot sector with NUL bytes, and end with 0x55, 0xAA
    times 510-($-$$) db 0
    db 0x55, 0xAA
