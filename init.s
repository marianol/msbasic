.segment "INIT"

; ============================================================================
; COLD START
;
; Entry point when BASIC is started (the BIOS jumps here through the vector at
; the start of BASIC ROM, see header.s). It sets up the zero page, copies CHRGET
; into RAM, asks for the memory size and terminal width, prints the banner and
; the free memory, and ends by jumping to RESTART (the "OK" prompt).
; ============================================================================

; ----------------------------------------------------------------------------
; Credits. Reached by typing "A" at the MEMORY SIZE prompt. Prints
; QT_WRITTEN_BY and then continues into a normal cold start.
; ----------------------------------------------------------------------------
PR_WRITTEN_BY:
      lda     #<QT_WRITTEN_BY
      ldy     #>QT_WRITTEN_BY
      jsr     STROUT

; ----------------------------------------------------------------------------
; COLD_START
; Step 1: stack and zero page vectors
; ----------------------------------------------------------------------------
COLD_START:
        ldx     #$FF
        stx     CURLIN+1                ; $FF in the high byte = direct mode
        ldx     #$FB
        txs                             ; stack pointer
        lda     #<COLD_START
        ldy     #>COLD_START
        sta     GORESTART+1             ; GORESTART: JMP to COLD_START for now
        sty     GORESTART+2
        sta     GOSTROUT+1              ; GOSTROUT: JMP to COLD_START for now
        sty     GOSTROUT+2
        lda     #<AYINT
        ldy     #>AYINT
        sta     GOAYINT                 ; GOAYINT: vector to AYINT (float to integer)
        sty     GOAYINT+1
        lda     #<GIVAYF
        ldy     #>GIVAYF
        sta     GOGIVEAYF               ; GOGIVEAYF: vector to GIVAYF (integer to float)
        sty     GOGIVEAYF+1
        lda     #$4C                    ; $4C = JMP opcode
        sta     GORESTART
        sta     GOSTROUT
        sta     JMPADRS                 ; JMPADRS is only used by KBD, harmless here
        sta     USR
        lda     #<IQERR
        ldy     #>IQERR
        sta     USR+1                   ; USR(x) -> ILLEGAL QUANTITY. NOTE: USR is an alias
        sty     USR+2                   ; of GORESTART here, so this is replaced by RESTART
                                        ; at the end of init (see the defines)
        lda     #WIDTH
        sta     Z17                     ; default terminal width (see ZEROPAGE_MAP.md)
        lda     #WIDTH2
        sta     Z18                     ; default last print zone


; ----------------------------------------------------------------------------
; Step 2: copy CHRGET into RAM (zero page)
;
; GENERIC_CHRGET in ROM (chrget.s) is the text scanner. It modifies its own
; code (the TXTPTR operand), so it must run from RAM. It is copied to CHRGET
; in zero page, together with the random number seed.
;
; All non-CONFIG_SMALL versions of BASIC have
; the same bug here: While the number of bytes
; to be copied is correct for CONFIG_SMALL,
; it is one byte short on non-CONFIG_SMALL:
; It seems the "ldx" value below has been
; hardcoded. So on these configurations,
; the last byte of GENERIC_RNDSEED, which
; is 5 bytes instead of 4, does not get copied -
; which is nothing major, because it is just
; the least significant 8 bits of the mantissa
; of the random number seed.
; ----------------------------------------------------------------------------
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET-1 ; XXX
L4098:                                  ; copy loop, X counts down to 0
        lda     GENERIC_CHRGET-1,x
        sta     CHRGET-1,x
        dex
        bne     L4098

; ----------------------------------------------------------------------------
; Step 3: initialize variables (X is 0 here)
; ----------------------------------------------------------------------------
        lda     #$03
        sta     DSCLEN                  ; (set again a few lines below, same value)
        txa                             ; A = 0
        sta     SHIFTSIGNEXT
        sta     LASTPT+1
        pha                             ; push 0 as the bottom of the stack marker, the
                                        ; FOR/GOSUB frame search stops at it
        sta     Z14                     ; output is not suppressed
        lda     #$03
        sta     DSCLEN
        jsr     CRDO                    ; start on a new line
        ldx     #TEMPST
        stx     TEMPPT                  ; empty the temporary string descriptor stack

; ----------------------------------------------------------------------------
; Step 4: "MEMORY SIZE" prompt
;   A      = credits (PR_WRITTEN_BY), then a normal start
;   number = use it as the top of memory (L40EE)
;   Enter  = detect the top of RAM (L40D7 loop)
; ----------------------------------------------------------------------------
        lda     #<QT_MEMORY_SIZE
        ldy     #>QT_MEMORY_SIZE
        jsr     STROUT
        jsr     NXIN                    ; read a line, X/Y point to the buffer
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET                  ; first character of the answer
        cmp     #$41                    ; 'A'?
        beq     PR_WRITTEN_BY
        tay                             ; set Z if the line is empty
        bne     L40EE                   ; something typed, parse it as a number
        lda     #<RAMSTART2             ; start of RAM for BASIC ($0400)
        ldy     #>RAMSTART2
        sta     TXTTAB                  ; program text starts at RAMSTART2
        sty     TXTTAB+1
        sta     LINNUM                  ; LINNUM is the address being tested
        sty     LINNUM+1
        ldy     #$00
; Find the top of RAM: walk up one byte at a time. A byte is RAM if $55 and then
; $AA can be written to it and read back. The first byte that fails is the end.
; NOTE: there is no upper limit, so this keeps going into the I/O area ($7F00)
; and writes there if the read back happens to work. The BIOS POST stops at
; $7F00 and stores the result in RAM_SIZE.
L40D7:
        inc     LINNUM
        bne     L40DD
        inc     LINNUM+1
L40DD:
        lda     #$55 ; 01010101 / 10101010
        sta     (LINNUM),y
        cmp     (LINNUM),y
        bne     L40FA                   ; read back failed, not RAM
        asl     a                       ; $55 -> $AA
        sta     (LINNUM),y
        cmp     (LINNUM),y
        bne     L40FA; new: slower      ; read back failed, not RAM
        beq     L40D7                   ; byte is RAM, test the next one
; The user typed a memory size: parse the number into LINNUM
L40EE:
        jsr     CHRGOT
        jsr     LINGET
        tay
        beq     L40FA                   ; end of line, OK
        jmp     SYNERR                  ; extra characters after the number
; LINNUM = first address that is not usable, store as the end of memory
L40FA:
        lda     LINNUM
        ldy     LINNUM+1
        sta     MEMSIZ                  ; top of memory
        sty     MEMSIZ+1
        sta     FRETOP                  ; string space grows down from here
        sty     FRETOP+1

; ----------------------------------------------------------------------------
; Step 5: "TERMINAL WIDTH" prompt
;   Enter  = keep the defaults
;   number = must be 16 to 255, otherwise it asks again
; The width goes to Z17 and the last print zone to Z18. With CONFIG_NO_CR on
; nothing reads them (see ZEROPAGE_MAP.md).
; ----------------------------------------------------------------------------
L4106:
        lda     #<QT_TERMINAL_WIDTH
        ldy     #>QT_TERMINAL_WIDTH
        jsr     STROUT
        jsr     NXIN
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        tay
        beq     L4136                   ; Enter, keep the defaults
        jsr     LINGET
        lda     LINNUM+1
        bne     L4106                   ; more than 255, ask again
        lda     LINNUM
        cmp     #$10
        bcc     L4106                   ; less than 16, ask again
L2829:
        sta     Z17                     ; terminal width
L4129:                                  ; subtract 14 until it goes below 0
        sbc     #$0E
        bcs     L4129
        eor     #$FF
        sbc     #$0C
        clc
        adc     Z17
        sta     Z18                     ; last print zone
; ----------------------------------------------------------------------------
; Step 6: set up the program area
; ----------------------------------------------------------------------------
L4136:
        ldx     #<RAMSTART2
        ldy     #>RAMSTART2
        stx     TXTTAB                  ; start of program text
        sty     TXTTAB+1
        ldy     #$00
        tya
        sta     (TXTTAB),y              ; a 0 byte before the first program line
        inc     TXTTAB                  ; the program starts one byte after it
        bne     L4192
        inc     TXTTAB+1
L4192:
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     REASON                  ; check there is memory (OUT OF MEMORY if not)

; ----------------------------------------------------------------------------
; Step 7: banner and free memory
; ----------------------------------------------------------------------------
        jsr     CRDO
        lda     MEMSIZ
        sec
        sbc     TXTTAB
        tax                             ; bytes free = MEMSIZ - TXTTAB
        lda     MEMSIZ+1
        sbc     TXTTAB+1
        jsr     LINPRT                  ; print the number in A (high) and X (low)
        lda     #<QT_BYTES_FREE         ; prints " BYTES FREE" and, because that
        ldy     #>QT_BYTES_FREE         ; string has no 0 at the end, the copyright
        jsr     STROUT                  ; line that follows it
        jsr     SCRTCH                  ; NEW, empty program

; ----------------------------------------------------------------------------
; Step 8: final vectors and start the interpreter
; ----------------------------------------------------------------------------
        lda     #<STROUT
        ldy     #>STROUT
        sta     GOSTROUT+1              ; GOSTROUT now jumps to STROUT
        sty     GOSTROUT+2
        lda     #<RESTART
        ldy     #>RESTART
        sta     GORESTART+1             ; GORESTART now jumps to RESTART (the OK prompt)
        sty     GORESTART+2
        jmp     (GORESTART+1)           ; go to RESTART


; ============================================================================
; Messages
; ============================================================================

; Credits, shown when "A" is typed at the MEMORY SIZE prompt
QT_WRITTEN_BY:
      ; asc80 "COPYRIGHT 1977 BY MICROSOFT CO"  ; only inAppleSoft Version
      ; .byte CR,0                              ; only inAppleSoft Version
      .byte   CR,LF,$0C                         ; FORM FEED
      ; .byte "WRITTEN BY RICHARD W. WEILAND."  ; Used for version < 1.1
      .byte   "WRITTEN BY WEILAND & GATES"
      .byte   CR,LF,0

QT_MEMORY_SIZE:
      .byte   "MEMORY SIZE"
      .byte   0

QT_TERMINAL_WIDTH:
      .byte   "TERMINAL "
      .byte   "WIDTH"
      .byte   0

; NOTE: this string has no 0 at the end, it runs into the copyright line below.
QT_BYTES_FREE:
      .byte   " BYTES FREE"
      .byte   CR,LF,CR,LF           ; Need to take one of the CR/LF out

; Copyright line, printed as the end of QT_BYTES_FREE. The label itself is not
; used (it was only used by the CBM2 banner).
QT_BASIC:
; Leaving here all the banners for reference
; in the original source these are controlled by Config symbols
;
;  .byte   "OSI 6502 BASIC VERSION 1.0 REV 3.2" ; Ohio Scientific (OSI)
;  .byte   "MOS TECH 6502 BASIC V1.1"           ; KIM-1
;  .byte   "MICROTAN BASIC"                     ; Tangerine MICROTAN 65
;  .byte   "  AIM 65 BASIC V1.1"                ; Rockwell International AIM-65 SBC
;  .byte   "BASIC V1.1"                         ; Synertek SYM-1 SBC 
;  .byte   "*** COMMODORE BASIC ***"            ; CBM v1.0 1977 Commodore PET
;  .byte   "### COMMODORE BASIC ###"            ; CBM v2.0 1978 Commodore PET 2001
;  .byte	"APPLE BASIC V1.1"                  ; AppleSoft Basic 
;
; Copywrite line for all, except Commodore which had no (C) mention
; .byte   "(C) 1980 MICROSOFT"                        ; Microtan
; .byte   "(C) 1978 MICROSOFT"                        ; AIM 65
; .byte   "COPYRIGHT 1978 SYNERTEK SYSTEMS CORP."     ; Synertek SYM-1
; .byte   "COPYRIGHT 1977 BY MICROSOFT CO."           ; all others
      .byte   CR,LF
      .byte   "COPYRIGHT 1977 BY MICROSOFT CO."
      .byte   CR,LF
      .byte   0
