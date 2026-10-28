.segment "CODE"
; Checks the serial port for a Control-C (called between BASIC statements).
; Any other character received is discarded.
ISCNTC:
        jsr     BIOS_SERIAL_POLL
        bcc     @NOTHING        ; no byte received
        cmp     #$03            ; Control-C?
        beq     @STOPIT
@NOTHING:
        rts
@STOPIT:
;!!! runs into "STOP"
