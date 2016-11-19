
;    LIST	 P=18LF25K50

#include p18f25k50.inc

    
 config PLLSEL = PLL3X      ; 3x clock multiplier
 config CFGPLLEN = ON       ; PLL Enabled
 config CPUDIV = NOCLKDIV   ; 1:1 mode
 config LS48MHZ = SYS48X8   ; System clock at 48 MHz, USB clock divider is set to 8
 config FOSC = INTOSCIO     ; Internal oscillator
 config PCLKEN = OFF        ; Primary oscillator disabled
 config FCMEN = OFF         ; Fail-Safe Clock Monitor disabled
 config IESO = OFF          ; Oscillator Switchover mode disabled
 config nPWRTEN = ON        ; Power up timer enabled
 config BOREN = OFF         ; BOR disabled
 config nLPBOR = OFF        ; Low-Power Brown-out Reset disabled
 config WDTEN = OFF         ; WDT disabled in hardware (SWDTEN ignored)
 config CCP2MX = RC1        ; CCP2 input/output is multiplexed with RC1
 config PBADEN = OFF        ; PORTB<5:0> pins are configured as digital I/O on Reset
 config MCLRE = ON          ; MCLR pin enabled; RE3 input disabled
 config STVREN = OFF        ; Stack full/underflow will not cause Reset
 config LVP = OFF           ; Single-Supply ICSP disabled
 config XINST = OFF         ; Instruction set extension and Indexed Addressing mode disabled
 config DEBUG = OFF         ; Bkgnd debugger disabled, RB6 and RB7 configured as gp I/O pins
 config CP0 = OFF           ; Block 0 is not code-protected
 config CP1 = OFF           ; Block 1 is not code-protected
 config CPB = OFF           ; Boot block is not code-protected
 config CPD = OFF           ; Data EEPROM is not code-protected
 config WRT0 = OFF          ; Block 0 (0800-1FFFh) is not write-protected
 config WRT1 = OFF          ; Block 1 (2000-3FFFh) is not write-protected
 config WRTC = OFF          ; Configuration registers (300000-3000FFh) are not write-protected
 config WRTB = OFF          ; Boot block (0000-7FFh) is not write-protected
 config WRTD = OFF          ; Data EEPROM is not write-protected
 config EBTR0 = OFF         ; Block 0 is not protected from table reads executed in other blocks
 config EBTRB = OFF         ; Boot block is not protected from table reads executed in other blocks

access	equ	0
banked	equ	1
	
#define MyFlag flags,0,access

; TODO PLACE VARIABLE DEFINITIONS GO HERE

    udata
		
    access_ovr
flags		res 1; flag bit register
W_TEMP		res 1    
STATUS_TEMP	res 1
BSR_TEMP	res 1
TBLPTR_TEMP	res 2
oledWriteCount	res 1
oledState	res 1


;*******************************************************************************
; Reset Vector
;*******************************************************************************

RES_VECT  CODE    0x0000            ; processor reset vector
    bra    START                   ; go to beginning of program

    ;TODO hide data here, or add a few init instructions above
    db 0x11, 0x11
    db 0x11, 0x11
    db 0x11, 0x11
;*******************************************************************************
; TODO Step #4 - Interrupt Service Routines
;
; There are a few different ways to structure interrupt routines in the 8
; bit device families.  On PIC18's the high priority and low priority
; interrupts are located at 0x0008 and 0x0018, respectively.  On PIC16's and
; lower the interrupt is at 0x0004.  Between device families there is subtle
; variation in the both the hardware supporting the ISR (for restoring
; interrupt context) as well as the software used to restore the context
; (without corrupting the STATUS bits).
;
; General formats are shown below in relocatible format.
;
;------------------------------PIC16's and below--------------------------------
;
; ISR       CODE    0x0008           ; interrupt vector location
;
;     <Search the device datasheet for 'context' and copy interrupt
;     context saving code here.  Older devices need context saving code,
;     but newer devices like the 16F#### don't need context saving code.>
;
;     RETFIE
;
    
HIGHISR       CODE    0x0008
    ;TODO maybe handle keyboard, timers?
    RETFIE
    ;TODO maybe hide some data here    
    db 0x11, 0x11
    db 0x11, 0x11
    db 0x11, 0x11
    db 0x11, 0x11
    db 0x11, 0x11
    db 0x11, 0x11
    db 0x11, 0x11

LOWISR       CODE    0x0018
isr:
    MOVWF W_TEMP, access
    MOVFF STATUS, STATUS_TEMP
    MOVFF BSR, BSR_TEMP
    movff TBLPTRL, TBLPTR_TEMP+0
    movff TBLPTRH, TBLPTR_TEMP+1

    
    
    movff TBLPTR_TEMP+0, TBLPTRL
    movff TBLPTR_TEMP+1, TBLPTRH
    MOVFF BSR_TEMP, BSR
    MOVF W_TEMP, W, access
    MOVFF STATUS_TEMP, STATUS
    RETFIE

;----------------------------------PIC18's--------------------------------------
;
; ISRHV     CODE    0x0008
;     GOTO    HIGH_ISR
; ISRLV     CODE    0x0018
;     GOTO    LOW_ISR
;
; ISRH      CODE                     ; let linker place high ISR routine
; HIGH_ISR
;     <Insert High Priority ISR Here - no SW context saving>
;     RETFIE  FAST
;
; ISRL      CODE                     ; let linker place low ISR routine
; LOW_ISR
;       <Search the device datasheet for 'context' and copy interrupt
;       context saving code here>
;     RETFIE
;
;*******************************************************************************

; TODO INSERT ISR HERE

;*******************************************************************************
; MAIN PROGRAM
;*******************************************************************************    
    
        

    
MAIN_PROG CODE                      ; let linker place main program
 
     #include <oled.asm>

 
START
    bcf T0CON, T0CS, access
    bsf OSCCON, IRCF2, access
 
    oledInit
    
    
mainloop:
;    rcall oledPrepDraw
;    clrf oledWriteCount, access
;    rcall i2cStart
;    movlw OLED_CONTROL_BYTE_DATA_STREAM
;    rcall i2cWrite
;drawLoop:
;    movf TMR0, w, access
;;    movlw 0x00
;    rcall i2cWrite
;    movf TMR0, w, access
;    rcall i2cWrite
;    movf TMR0, w, access
;    rcall i2cWrite
;    movf TMR0, w, access
;    rcall i2cWrite
;    decfsz oledWriteCount, f, access
;    bra drawLoop
;    rcall i2cStop
    bra mainloop
    

;    movlw oledInitSequence
        

    end
    
