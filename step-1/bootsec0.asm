    bits 16

    ; BIOS loads boot sector into address 0000:7C00
    org 0x7C00
    
    jmp start

message db 'I am the boot sector', 13, 10, 0

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
    ; move address of string into DS:SI ready for LODSB
    mov si, ax
_2:
    ; fetch next character of string into register AL
    lodsb
    ; if character is ASCII NUL then we are finished
    cmp al, 0
    je _3
    ; print character using function 0xE (teletype character) of BIOS interrupt 0x10 (video services)
    mov ah, 0x0E
    int 0x10
    ; move on to process next character
    jmp _2
_3:
    ret

    ; fill rest of boot sector with NUL bytes, except for last two bytes
    times 510-($-$$) db 0

    ; BIOS requires last two bytes of a valid boot sector to be 0x55, 0xAA 
    db 0x55, 0xAA
