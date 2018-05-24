mov ah, 0x0 

get_key:
    mov ah, 0x0 
    int 0x16
    call print_key
    jmp get_key

print_key:
    mov ah, 0x0e
    int 0x10
    ret

jmp $
times 510-($-$$) db 0
dw 0xaa55