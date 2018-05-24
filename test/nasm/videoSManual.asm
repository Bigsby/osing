mov ax, 0xb800
mov es, ax
mov ah, 0x07
mov al, 0x41
mov [es:0x500], ax

jmp $
times 510-($-$$) db 0
dw 0xaa55
