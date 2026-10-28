; configuration
CONFIG_2A := 1

; CONFIG_CBM_ALL := 1                 ; add all Commodore-specific additions except file I/O
CONFIG_DATAFLG := 1                 ; ???
CONFIG_EASTER_EGG := 1              ; include the CBM2 “WAIT 6502″ easter egg
; CONFIG_FILE := 1                    ; support PRINT#, INPUT#, GET#, CMD
CONFIG_NO_CR := 1                   ; no automatic line wrap in PRINT/TAB/comma zones (terminal wraps itself)
CONFIG_NO_LINE_EDITING := 1         ; disable support for Microsoft-style “@”, “_”, BEL etc.
CONFIG_NO_READ_Y_IS_ZERO_HACK := 1  ; don’t do a very volatile trick that saves one byte
CONFIG_PEEK_SAVE_LINNUM := 1        ; preserve LINNUM on a PEEK
CONFIG_SCRTCH_ORDER := 2            ; ?? where in the init code to call SCRTCH

; zero page variables reserved in zeropage.s
ZP_START1 = $50
ZP_START2 = $5A
ZP_START3 = $60
ZP_START4 = $6B

; extra/override ZP variables
; @todo check what we are suing from this to make the ZP tighter
CURDVC			:= $000E
TISTR			:= $008D
Z96				:= $0096
POSX			:= $00C6
TXPSV			:= LASTOP
USR				:= GORESTART ; XXX

; inputbuffer
INPUTBUFFER     := $0200

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP		:= $FA
WIDTH			:= 40       ; what is this? term width?
WIDTH2			:= 30

RAMSTART2		:= $0400    ; is fine for us also it gives room for the INPUTBUFFER

; magic memory locations
ENTROPY = $E844             ; for RND seed, pulls 8 bits of the count value for VIA1 Timer 1 (T1C-L)
                            ; this is a free running timer in CBM computers used 
                            ; by basic for generating pseudorandom numbers.
                            ; @todo we need to change that to our timer

; monitor functions
; need to change this to labels when I move this to the BIOS project

; OPEN	:= $FFC0
; CLOSE	:= $FFC3
; CHKIN	:= $FFC6
; CHKOUT	:= $FFC9
; CLRCH	:= $FFCC
; CHRIN	:= $FFCF
LOAD	:= $FFD5    ; I have the Intel Hex now need to check if it works like the C=
SAVE	:= $FFD8    ; I have the Intel Hex now need to check if it works like the C=
; VERIFY	:= $FFDB
; SYS		:= $FFDE
ISCNTC	:= $FFE1    ; used Is Control C, do not have this what does it do?
; CLALL	:= $FFE7
; LE7F3	:= $E7F3    ; for CBM1
MONCOUT	:= $8006    ; Character out routine BIOS_SERIAL_OUT for us
MONRDKEY := $8009   ; Character in routine BIOS_SERIAL_IN for us 
