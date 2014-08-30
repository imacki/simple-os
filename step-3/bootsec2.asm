    bits 16

    ; BIOS loads boot sector into address 0000:7C00
    org 0x7C00
    
    jmp start

driveno db 0
message db 'Boot Sector', 13, 10, 0
warning db 'Error: cannot read diskette', 13, 10, 0

start:
    ; set DS register to old location (0000:7C00) and save boot drive number
    mov ax, cs
    mov ds, ax
    mov [driveno], dl
    ; set ES and SS:SP registers to new location (8000:7C00)
    mov ax, 0x8000
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE

    ; copy boot sector code to new location
    mov si, 0x7C00
    mov di, si
    mov cx, 512/2
    rep movsw

    ; jump to new location
    jmp 0x8000:relocated

relocated:
    ; re-initialize DS register
    mov ax, cs
    mov ds, ax

    ; print message on screen
    mov ax, message
    call print

    ; load rest of Cylinder 0 Head 0 (Records 2-18) into 0000:0510
    mov ax, 0x0211  ; read 17 sectors
    mov cx, 0x0002  ; from cylinder 0 record 2
    mov dh, 0x00    ; head 0 on boot drive
    mov dl, [driveno]
    xor bx, bx
    mov es, bx      ; to segment 0000
    mov bx, 0x0510  ; offset 0510
    int 0x13
    jc load_error
    or ah, ah
    jnz load_error
    or al, al
    jz load_error

    ; jump to newly loaded code (exit boot sector code)
    jmp 0x0000:0x0510

load_error:
    mov ax, warning
    call print

    ; boot failed - call BIOS interrupt 18
    int 0x18

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
