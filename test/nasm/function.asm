; 
; A simple boot sector that prints a message to the screen using a BIOS routine. 
;

mov al, 'H'
call print_char
mov al, 'e'
call print_char
mov al, 'l'
call print_char
mov al, 'l'
call print_char
mov al, 'o'
call print_char

jmp $                   ; Jump to the current address (i.e. forever).

print_char:
    pusha
    mov ah, 0x0e
    int 0x10
    popa
    ret
; 
; Padding and magic BIOS number. 
;

times 510-($-$$) db 0   ; Pad the boot sector out with zeros

dw 0xaa55               ; Last two bytes form the magic number , 
                        ; so BIOS knows we are a boot sector.