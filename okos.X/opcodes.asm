;first 3 are characters for mnemonic, 4th byte is first byte of opcode
;TODO could save 2 bytes per opcode if an xor + rlf hash was used instead
;and maybe even support 4 or variable sized mnemonic words
    
opcodeTable:
    db 0x0b, 0x0c   ; bcf (bcf)
    db 0x0f, 0x90   
    db 0x0b, 0x1c   ; bsf (bsf)
    db 0x0f, 0x80   
    db 0x0b, 0x1d   ; btc (btfsc)
    db 0x0c, 0xB0   
    db 0x0b, 0x1d   ; bts (btfss)
    db 0x1c, 0xA0   
    db 0x16, 0x1f   ; mvl (movlw)
    db 0x15, 0x0E   
    db 0x16, 0x1f   ; mvw (movwf)
    db 0x20, 0x6E   
    db 0x16, 0x1f   ; mvf (movf)
    db 0x0f, 0x50   
    db 0x0a, 0x0d   ; add (addwf)
    db 0x0d, 0x24   
    db 0x0a, 0x17   ; and (andwf)
    db 0x0d, 0x14   
    db 0x12, 0x18   ; ior (iorwf)
    db 0x1b, 0x10   
    db 0x21, 0x18   ; xor (xorwf)
    db 0x1b, 0x18   
    db 0x1b, 0x15   ; rlc (rlcf)
    db 0x0c, 0x34   
    db 0x1b, 0x1b   ; rrc (rrcf)
    db 0x0c, 0x30   
    db 0x0b, 0x1b   ; bra (goto) doubles as return as well, just "bra 0016"
    db 0x0a, 0xEF   
    db 0x0c, 0x0a   ; cal (call)
    db 0x15, 0xEC   
