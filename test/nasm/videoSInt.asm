mov ax, 0x410e
int 0x10

jump $
times 510-($-$$) db 0
dw 0xaa55
