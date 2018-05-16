cli				; clean interrupts
jmp $				; jump to the current position
times 510-($-$$) db 0		; padding until magic number
dw 0xaa55			; magic number
