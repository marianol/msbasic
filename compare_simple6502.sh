#!/bin/sh
# Builds simple6502 and compares the result byte by byte with the reference
# binary in ref/. Use it to check that cleanup changes did not alter the output.
# Exit code: 0 = identical, 1 = different or build failed.

REF=ref/simple6502_ref.bin
TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

ca65 -D simple6502 msbasic.s -o "$TMP/simple6502.o" &&
ld65 -C simple6502.cfg "$TMP/simple6502.o" -o "$TMP/simple6502.bin" || {
	echo "BUILD FAILED"
	exit 1
}
echo "BUILD OK"

if cmp "$REF" "$TMP/simple6502.bin"; then
	echo "COMPARE OK: identical to $REF ($(wc -c < "$REF" | tr -d ' ') bytes)"
else
	echo "COMPARE FAILED: output differs from $REF"
	exit 1
fi
