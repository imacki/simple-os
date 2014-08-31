    bits 16

    ; boot sector loads main program (rest of track 1) into address 0000:0600
    org 0x0600
    
    jmp start

    align 2, db 0
keystrokes dw 0

message1 db 'Main Program loaded', 13, 10, 10, 0
message2 db 'Type your name and press <Enter>: ', 0
message3 db 'Hello, ', 0
message4 db '. Welcome to Step 4!', 13, 10, 10, 0
message5 db 'INT 0x09 intercepted ', 0
message6 db ' times', 13, 10, 10, 0

    align 2, db 0
hextbl db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
    
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

; replace BIOS keyboard handler (int 9) with own keyboard handler (new_int9)

    ; copy old int 9 vector to int 51 vector (new handler will call old handler)
    mov dx, [0x09*4]    ; loads old int 9 vector into AX:DX
    mov ax, [0x09*4+2]
    mov [0x51*4], dx    ; stores old int 9 vector as int 51
    mov [0x51*4+2], ax

    ; store new keyboard handler address as int 9 vector
    mov dx, new_int9    ; loads new int 9 vector into AX:DX
    mov ax, cs
    cli                 ; disable external interrupts
    mov [0x09*4], dx
    mov [0x09*4+2], ax
    sti                 ; enable external interrupts

; test new keyboad handler

    ; print number of keystrokes intercepted
    mov ax, message5
    call print
    mov ax, [keystrokes]
    call print_num
    mov ax, message6
    call print

    ; prompt user for name
    mov ax, message2
    call print
    mov ax, buffer
    call input

    ; print personalized greeting for user
    mov ax, message3
    call print
    mov ax, buffer
    call print
    mov ax, message4
    call print

    ; print number of keystrokes intercepted
    mov ax, message5
    call print
    mov ax, [keystrokes]
    call print_num
    mov ax, message6
    call print

    ; infinite loop to hang the CPU
hang:
    hlt
    jmp hang

    ; function print(string)
print:
    cld
    mov si, ax
.next:
    lodsb
    cmp al, 0
    je .done
    mov ah, 0x0E
    int 0x10
    jmp .next
.done:
    ret

    ; function print_num
print_num:
    push bp
    mov bp, sp
    push ax
    mov ax, 0x0E30  ; print '0x' before hex number
    int 0x10
    mov al, 'x'
    int 0x10
    pop ax
    mov cx, 4
.next:
    push cx
    rol ax, 4
    push ax
    and al, 0x0F    ; get next hex digit
    mov bx, hextbl  
    xlat            ; translate into ASCII character
    mov ah, 0x0E    
    int 0x10        ; print it
    pop ax
    pop cx
    loop .next
    pop bp
    ret

    ; function input(buffer)
input:
    cld
    mov di, ax
.next:
    mov ah, 0x10    ; get extended keyboard input
    int 0x16
    cmp al, 0       ; skip non-ASCII keystrokes
    je .next
    mov ah, 0x0E    ; echo character to screen
    int 0x10
    cmp al, 0xD     ; if key==Enter then done
    je .done
    stosb
    jmp .next
.done:
    mov ax, 0x0E0A  ; output CRLF
    int 0x10
    mov al, 0
    stosb
    ret

    ; keyboard interrupt handler
new_int9:
    inc word [cs:keystrokes]    ; count number of times int 9 is intercepted
    int 0x51
    iret

buffer:
    times 80 db 0

    ; fill rest of track 1 with NUL bytes
heap:
    times 512*17-($-$$) db 0
