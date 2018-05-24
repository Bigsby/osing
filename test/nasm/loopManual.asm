db 0xeb ; small jump
db 0xfe ; previous byte - 0xfd second previous - 0xfc - third previous - etc
times 510-($-$$) db 0
dw 0xaa55