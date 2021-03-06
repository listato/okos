;*******************************************************************************
; Memory allocations
; Make heavy (light?) use of access ram to avoid bank switching code in OS
; TODO overlay temporary variables
;*******************************************************************************

    udata
;nope
    udata_acs
currentFile	res 1;* which bank of memory is active. used for editor and assembler and running programs
flags		res 1;* flag bit register

keyboardCode	res 1
keyboardAscii	res 1;* used to be ASCII, not anymore

oledWriteCount	res 1
oledRow		res 1;* also contains row setting flags in high nibble
oledSegment	res 1;
oledFontData	res 2; temp 16bit for decoding font pixels

editorTemp	res 1
editorOffset	res 1; current line offset from top of screen (using fsr0)

cursorX		res 1
cursorY		res 1

opcode		res 2
opcodeIndex	res 1
mismatches	res 1
assemblerTemp	res 1
assemblerArg	res 3

tblptr_save	res 2

fsr0_save	res 2
	
line		res .32

bitbucket	res 1 ; a memory location just before buffer, allows underruning by 1 to save code space
buffer		res 1 ; the rest of memory


#define pageDirty flags,0
#define keyboardIgnore flags,1
#define editorEditMode flags,2
#define editorAtStartOfFile flags,3
#define editorSkipDraw flags,4
