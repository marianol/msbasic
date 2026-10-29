# Zero page map

BASIC variables are from this build (`zeropage.s` + `defines_simple6502.s`, addresses checked against the ld65 label file).
BIOS variables are from `firmware/defines_simple6502.s` in the simple6502 repo (`main`). WozMon and BASIC never run together, so overlaps with WozMon, monitor and Intel HEX variables are fine; the others need a decision.

Status: `BASIC` = BASIC only, `BIOS` = BIOS only, `OVERLAP` = BASIC and BIOS share bytes, `free` = unused.

## Needs a decision

| Bytes | BASIC | BIOS | Problem |
| ----- | ----- | ---- | ------- |
| $E0-$E4 | RNDSEED (CHRGET block) | TOCKS ($E0-$E2), RAM_SIZE ($E3-$E4) | BASIC copies its CHRGET block here at startup. |

## Map

| Bytes | Size | BASIC | BIOS | Status | Notes |
| ----- | ---- | ----- | ---- | ------ | ----- |
| $00 | 1 |  | ZP_START | BIOS | fault beacon scratch (post_fail only) |
| $01-$23 | 35 |  |  | free |  |
| $24-$25 | 2 |  | XAML/XAMH | BIOS | WozMon |
| $26-$27 | 2 |  | STL/STH | BIOS | WozMon |
| $28-$29 | 2 |  | L/H | BIOS | WozMon |
| $2A | 1 |  | YSAV | BIOS | WozMon |
| $2B | 1 |  | MODE | BIOS | WozMon |
| $2C-$2F | 4 |  |  | free |  |
| $30-$31 | 2 |  | IHEX_ADDR | BIOS | Intel HEX |
| $32 | 1 |  | IHEX_LEN | BIOS | Intel HEX |
| $33 | 1 |  | IHEX_TYPE | BIOS | Intel HEX |
| $34 | 1 |  | IHEX_SUM | BIOS | Intel HEX |
| $35 | 1 |  | IHEX_TMP | BIOS | Intel HEX |
| $36-$3F | 10 |  |  | free |  |
| $40-$41 | 2 |  | PC_REG_H/L | BIOS | monitor register print |
| $42 | 1 |  | SP_REG | BIOS | monitor register print |
| $43 | 1 |  | A_REG | BIOS | monitor register print |
| $44 | 1 |  | X_REG | BIOS | monitor register print |
| $45 | 1 |  | Y_REG | BIOS | monitor register print |
| $46 | 1 |  | SR_REG | BIOS | monitor register print |
| $47-$4F | 9 |  |  | free |  |
| $50-$52 | 3 | GORESTART / USR |  | BASIC | USR(x) jumps here |
| $53-$55 | 3 | GOSTROUT |  | BASIC |  |
| $56-$57 | 2 | GOAYINT |  | BASIC |  |
| $58-$59 | 2 | GOGIVEAYF |  | BASIC |  |
| $5A | 1 | Z15 |  | BASIC |  |
| $5B | 1 | POSX |  | BASIC | cursor column |
| $5C | 1 | Z17 |  | BASIC |  |
| $5D | 1 | Z18 |  | BASIC |  |
| $5E-$5F | 2 | LINNUM / TXPSV |  | BASIC | TXPSV (INPUT/READ text pointer save) shares LINNUM |
| $60 | 1 | CHARAC |  | BASIC |  |
| $61 | 1 | ENDCHR |  | BASIC |  |
| $62 | 1 | EOLPNTR |  | BASIC |  |
| $63 | 1 | DIMFLG |  | BASIC |  |
| $64-$65 | 2 | VALTYP |  | BASIC |  |
| $66 | 1 | DATAFLG |  | BASIC |  |
| $67 | 1 | SUBFLG |  | BASIC |  |
| $68 | 1 | INPUTFLG |  | BASIC |  |
| $69 | 1 | CPRMASK |  | BASIC |  |
| $6A | 1 | Z14 |  | BASIC |  |
| $6B | 1 | TEMPPT |  | BASIC |  |
| $6C-$6D | 2 | LASTPT |  | BASIC |  |
| $6E-$76 | 9 | TEMPST |  | BASIC |  |
| $77-$78 | 2 | INDEX |  | BASIC |  |
| $79-$7A | 2 | DEST |  | BASIC |  |
| $7B-$7F | 5 | RESULT |  | BASIC |  |
| $80-$81 | 2 | TXTTAB |  | BASIC |  |
| $82-$83 | 2 | VARTAB |  | BASIC |  |
| $84-$85 | 2 | ARYTAB |  | BASIC |  |
| $86-$87 | 2 | STREND |  | BASIC |  |
| $88-$89 | 2 | FRETOP |  | BASIC |  |
| $8A-$8B | 2 | FRESPC |  | BASIC |  |
| $8C-$8D | 2 | MEMSIZ |  | BASIC |  |
| $8E-$8F | 2 | CURLIN |  | BASIC |  |
| $90-$91 | 2 | OLDLIN |  | BASIC |  |
| $92-$93 | 2 | OLDTEXT |  | BASIC |  |
| $94-$95 | 2 | Z8C |  | BASIC |  |
| $96-$97 | 2 | DATPTR |  | BASIC |  |
| $98-$99 | 2 | INPTR |  | BASIC |  |
| $9A-$9B | 2 | VARNAM |  | BASIC |  |
| $9C-$9D | 2 | VARPNT |  | BASIC |  |
| $9E-$9F | 2 | FORPNT |  | BASIC |  |
| $A0-$A1 | 2 | LASTOP |  | BASIC |  |
| $A2 | 1 | CPRTYP |  | BASIC |  |
| $A3-$A4 | 2 | FNCNAM / TEMP3 |  | BASIC |  |
| $A5-$A7 | 3 | DSCPTR |  | BASIC |  |
| $A8-$A9 | 2 | DSCLEN |  | BASIC | JMPADRS = DSCLEN+1 (KBD only, unused) |
| $AA | 1 | Z52 |  | BASIC |  |
| $AB | 1 | ARGEXTENSION |  | BASIC |  |
| $AC | 1 | TEMP1 |  | BASIC |  |
| $AD-$AE | 2 | HIGHDS |  | BASIC |  |
| $AF-$B0 | 2 | HIGHTR |  | BASIC |  |
| $B1 | 1 | TEMP2 |  | BASIC |  |
| $B2 | 1 | INDX / TMPEXP |  | BASIC |  |
| $B3 | 1 | EXPON |  | BASIC |  |
| $B4 | 1 | LOWTR / LOWTRX |  | BASIC | LOWTR+1 is EXPSGN |
| $B5 | 1 | EXPSGN |  | BASIC |  |
| $B6-$BA | 5 | FAC |  | BASIC |  |
| $BB | 1 | FACSIGN |  | BASIC |  |
| $BC | 1 | SERLEN |  | BASIC |  |
| $BD | 1 | SHIFTSIGNEXT |  | BASIC |  |
| $BE-$C2 | 5 | ARG |  | BASIC |  |
| $C3 | 1 | ARGSIGN |  | BASIC |  |
| $C4-$C5 | 2 | STRNG1 |  | BASIC | SGNCPR = STRNG1, FACEXTENSION = STRNG1+1 |
| $C6-$C7 | 2 | STRNG2 |  | BASIC |  |
| $C8-$DF | 24 | CHRGET code |  | BASIC | CHRGOT=$CE, CHRGOT2=$D5, TXTPTR=$CF-$D0 |
| $E0-$E4 | 5 | RNDSEED | TOCKS ($E0-$E2), RAM_SIZE ($E3-$E4) | OVERLAP | part of the CHRGET block |
| $E5 | 1 |  | PTR_RD_RX_BUF | BIOS |  |
| $E6 | 1 |  | PTR_WR_RX_BUF | BIOS |  |
| $E7-$E8 | 2 |  | PTR_TX | BIOS | string pointer |
| $E9-$EA | 2 |  | POST_PTR | BIOS | POST RAM walk |
| $EB-$FF | 21 |  |  | free |  |

## Totals

* BASIC uses 149 bytes ($50-$E4).
* BIOS uses 33 bytes.
* 79 bytes are free in both.
* Block starts: ZP_START1=$50, ZP_START2=$5A, ZP_START3=$60, ZP_START4=$6B.
* `STACK_TOP` ($FA) is a stack page offset, not a zero page address.
