mov ah, 0x0e  ; tetetype mode
mov al, 0x41  ;'A'
int 0x10

jmp $
times 510-($-$$) db 0
dw 0xaa55