# Files read by the simple6502 build

Build: `ca65 -D simple6502 msbasic.s` (see `make_simple6502.sh`).
List generated with `ca65 -D simple6502 msbasic.s --create-dep`.

Descriptions are inferred from a quick scan of each file.

## Top level and configuration

| File | What it does |
| ---- | ------------ |
| msbasic.s | Main file. Includes `defines_simple6502.s` and all the others in link order. |
| defines_simple6502.s | All target definitions: `CONFIG_*` flags, zero page layout, `INPUTBUFFER`, floating point sizes, `CR`/`LF`, `MONCOUT`. Includes `bios_jumptable.inc`. |
| bios_jumptable.inc | Copy of the Simple6502 BIOS jump table (`BIOS_*` addresses). |
| macros.s | Macros for tokens, keyword tables, error messages and high-bit strings. |
| zeropage.s | Zero page variable layout. |
| header.s | Entry points at the start of BASIC ROM: `jmp COLD_START` at $DC00 and `jmp RESTART` (warm start) at $DC03. |

## Interpreter core

| File | What it does |
| ---- | ------------ |
| token.s | Keyword table, token numbers and the statement and function vectors. |
| error.s | Error code table and error message strings. |
| message.s | Global messages: "ERROR", "IN", "OK", "BREAK". |
| memory.s | Stack frame search and memory management (shared by all BASIC versions). |
| program.s | Error handling, program entry and line editing, tokenizer (`CRUNCH`), detokenizer (`LIST`). |
| flow1.s | `FOR`/`NEXT`, statement dispatcher (`NEWSTT`), `RESTORE`, `STOP`/`END`. |
| flow2.s | `RUN`, `GOSUB`/`RETURN`, `GOTO`, `DATA`, `IF`, `REM`, `ON`. |
| misc1.s | Line number parsing (`LINGET`), `LET` and string assignment. |
| misc2.s | `FRE`, `POS`, `DEF FN` and integer-to-float helpers. |
| chrget.s | `CHRGET` and `CHRGOT` text scanner (copied to zero page at startup). |
| init.s | Cold start: memory sizing, banner and zero page setup. |

## Expressions, variables and math

| File | What it does |
| ---- | ------------ |
| eval.s | Expression evaluator and operators. |
| var.s | Variable lookup and creation (`PTRGET`). |
| array.s | Arrays: `DIM`, element addressing and integer conversion. |
| string.s | String functions and string space management (including garbage collection). |
| float.s | Floating point routines. Includes the CBM2 "WAIT 6502" Easter egg. |
| trig.s | `SIN`, `COS`, `TAN`, `ATN`. |
| rnd.s | `RND` and the random number seed. |
| poke.s | `PEEK`, `POKE`, `WAIT` and related argument parsing. |

## Input and output

| File | What it does |
| ---- | ------------ |
| print.s | `PRINT`, `TAB`, `SPC`, number and string output, character out (`OUTDO`). |
| input.s | `INPUT`, `READ`, `GET` and input conversion errors. |
| inline.s | Line input (`INLIN`) from the console. |
| iscntc.s | Ctrl-C check using `BIOS_SERIAL_POLL`. Any other key is discarded. Falls into `STOP`. |
| extra.s | Selects the target's extra code (`EXTRA` segment). |
| simple6502_extra.s | `MONRDKEY` (blocking, echoes, handles backspace) and `MONRDKEY2` (non-blocking, for GET). |
| loadsave.s | LOAD and SAVE stubs (just `rts`). The BIOS has no load/save routine yet. |

## Build files (not read by the assembler)

| File | What it does |
| ---- | ------------ |
| simple6502.cfg | ld65 linker config and memory map. |
| make_simple6502.sh | Assembles and links the Simple6502 target into `out/`. |
| compare_simple6502.sh | Builds the target and compares it byte by byte with `ref/simple6502_ref.bin`. |
| ref/simple6502_ref.bin | Reference binary. Rebuilt after adding the entry jumps in `header.s`. |
