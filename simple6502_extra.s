; Simple6502 console input, built on BIOS_SERIAL_POLL (bios_jumptable.inc).
;
; BIOS_SERIAL_POLL is non-blocking and does not echo: it returns the byte in A
; with carry set, or carry clear if nothing was received. X and Y are preserved.
.segment "EXTRA"

; MONRDKEY: blocking read with echo, used by GETLN (line input).
; BASIC's INLIN does not echo typed characters itself, so we do it here.
; Returns the char in A.
MONRDKEY:
@wait:
        jsr     BIOS_SERIAL_POLL
        bcc     @wait
        jsr     BIOS_SERIAL_OUT ; echo (preserves A)
        rts

; MONRDKEY2: non-blocking read without echo, used by GET.
; Returns the char in A, or 0 if no key is waiting.
MONRDKEY2:
        jsr     BIOS_SERIAL_POLL
        bcs     @got
        lda     #$00
@got:
        rts

; LOAD and SAVE stubs. The BIOS has no load/save routine yet (only the
; monitor's Intel HEX L and S commands).
; @todo hook these up once the BIOS provides them.
SAVE:
LOAD:
        rts
