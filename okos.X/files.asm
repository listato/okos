
;ideas for filesystem included all kinds of things, but the simpliest is just chunks of memory
;32k flash in 2k segments works well, about as much as we can hold in ram, and that gives 16 files.
;could store metadata in eeprom, or perhaps first block (64b) for filename, flags, etc
;files that are 2048 - 64 = 1984 bytes will also fit in ram better

;writes the next byte in WREG to the holding registers
;if a 64b page boundary is crossed, the page is flushed
fputc:
    movwf TABLAT
    tblwt*+
    movlw 0x3f
    andwf TBLPTRL, w
    bz flushLastPage
    return
;flushes the page the previous TBLPTR address points to
flushLastPage:
    bcf INTCON, GIE
    tblrd*-; go back to previous page
    ; erase a page of program flash
    ; EEPGD = 1 | CFGS = 0 | x | FREE = 1 | x | WREN = 1 | WR = 0 | RD = 0
    movlw b'10010100'
    rcall startFlashWrite
    
    ;write the page in the holding registers
    ; EEPGD = 1 | CFGS = 0 | x | FREE = 0 | x | WREN = 1 | WR = 1 | RD = 0
    movlw b'10000100'
    rcall startFlashWrite
    
    tblrd*-; repair tblptr
    bsf INTCON, GIE
    return
    
;copies buffer data to the "file" referenced by currentFile
saveFile:
    ;set up tblptr for writing
    rcall openFile

    lfsr 2, buffer
saveFileLoop:
    movf POSTINC2, w
    rcall fputc
    btfss FSR2H, 3 ; outside of implemented memory range
    bra saveFileLoop

    return

;sets TBLPTR to the section of memory pointed to by currentFile
openFile:
    movf currentFile, w
    mullw 0x8
    movff PRODL, TBLPTRH
    ;TODO offset by 1 page (64 bytes) to reserve some room for file metadata.
    clrf TBLPTRL
    return
    
;sets EECON1 to WREG value
;flash write/erase required sequence
;will stall for ~2ms
startFlashWrite:
    movwf EECON1
    movlw 0x55
    movwf EECON2
    movlw 0xaa
    movwf EECON2
    bsf EECON1, WR
    return