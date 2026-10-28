; Definitions file for Simple6502 MSBasic build

; Define our target build since it may be used later
SIMPLE6502 := 1                     ; Target platform 

; Simple6502 BIOS entry points (BIOS_* labels from the BIOS jump table)
.include "bios_jumptable.inc"

; configuration
CONFIG_2A   := 1
CONFIG_2    := 1
CONFIG_11A  := 1
CONFIG_11   := 1
CONFIG_10A  := 1

CONFIG_DATAFLG := 1                 ; ???
CONFIG_EASTER_EGG := 1              ; include the CBM2 “WAIT 6502″ easter egg
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

; inputbuffer
INPUTBUFFER                 := $0200
CONFIG_NO_INPUTBUFFER_ZP    := 1
CONFIG_INPUTBUFFER_0200     := 1
INPUTBUFFERX = INPUTBUFFER & $FF00

; extra/override ZP variables
; @todo check what we are using from this to make the ZP tighter
POSX			:= $00C6
TXPSV			:= LASTOP
USR				:= GORESTART      ; XXX

; constants
SPACE_FOR_GOSUB := $3E
STACK_TOP		:= $FA
WIDTH			:= 40       ; init.s stores both WIDTH in Z17 and Z18 at startup. 
WIDTH2			:= 30       ; with CONFIG_NO_CR on, they are written but never used

RAMSTART2		:= $0400        ; is fine for us also it gives room for the INPUTBUFFER

; magic memory locations
ENTROPY = $E844             ; for RND seed, pulls 8 bits of the count value for VIA1 Timer 1 (T1C-L)
                            ; this is a free running timer in CBM computers used 
                            ; by basic for generating pseudorandom numbers.
                            ; @todo we need to change that to our timer

; monitor functions
MONCOUT	:= BIOS_SERIAL_OUT  ; character out, preserves A, X and Y
; MONRDKEY, MONRDKEY2, LOAD and SAVE are in simple6502_extra.s

; Floating point parameters - @todo check if true
BYTES_FP		    := 5
BYTES_PER_ELEMENT   := BYTES_FP
BYTES_PER_VARIABLE  := BYTES_FP+2
MANTISSA_BYTES	    := BYTES_FP-1
BYTES_PER_FRAME     := 2*BYTES_FP+8
FOR_STACK1		    := 2*BYTES_FP+5
FOR_STACK2		    := BYTES_FP+4

MAX_EXPON = 10


STACK           := $0100
STACK2          := STACK




CR=13
LF=10

.ifndef CRLF_1
CRLF_1 := CR
CRLF_2 := LF
.endif



