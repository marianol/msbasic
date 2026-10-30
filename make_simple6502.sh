#!/bin/sh
# Assembles and links the Simple6502 BASIC. Output (.o, .bin and .lbl) goes to out/.

NAME=Simple6502-BASIC

mkdir -p out &&
ca65 msbasic.s -o out/$NAME.o &&
ld65 -C simple6502.cfg out/$NAME.o -o out/$NAME.bin -Ln out/$NAME.lbl
