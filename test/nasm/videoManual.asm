mov ax, 0xb800
mov es, ax
mov ax, 0x0741
mov [es:0x500], ax

jmp $
times 510-($-$$) db 0
dw 0xaa55
