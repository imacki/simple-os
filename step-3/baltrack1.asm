    bits 16

    ; boot sector loads main program (rest of track 1) into address 0000:0600
    org 0x0600
    
    jmp start

message db 'Main Program loaded', 13, 10, 0

start:
    ; initialize segment registers and stack
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE

    ; print message on screen
    mov ax, message
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

    ; fill rest of track 1 with NUL bytes
    times 512*17-($-$$) db 0
