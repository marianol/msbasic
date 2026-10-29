# Changelog

All notable changes to this Simple6502 fork of
[mist64/msbasic](https://github.com/mist64/msbasic) are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Removed

- Files for all other targets (defines, linker configs, extra, iscntc and
  loadsave files), `make.sh`, `regress.sh` and the `orig/` reference binaries.

### Added

- `SOURCE_FILES.md`: files the simple6502 build reads, with a short
  description of each.
- This changelog.

- `compare_simple6502.sh`: builds simple6502 and compares it byte by byte with
  `ref/simple6502_ref.bin`, the binary built before the cleanup.

### Changed

- Zero page: `POSX` and `TXPSV` overrides removed. `POSX` is now at $5B and no
  longer overlaps `STRNG2`; `TXPSV` shares `LINNUM`. Override `.ifdef`s removed
  from `zeropage.s`. Added `ZEROPAGE_MAP.md`. Reference rebuilt.
- `token.s`, `error.s`, `message.s`, `program.s`, `flow1.s`, `flow2.s`, `misc1.s`: removed `.ifdef`s for other targets. `CONFIG_NULL` is
  kept on purpose. `ERR_BADDATA` is commented out (needs `CONFIG_FILE`).
- LOAD/SAVE stubs moved from `simple6502_extra.s` to `loadsave.s`.
- `simple6502_extra.s` merged into `extra.s`. `.ifdef KBD` removed from `chrget.s`.
- `misc3.s` removed (KBD only); `msbasic.s` no longer includes it.
- `header.s` now has the entry points: `jmp COLD_START` at $DC00 and
  `jmp RESTART` (warm start) at $DC03. The `.ifdef`s were removed.
- `iscntc.s` holds the Ctrl-C check directly; `simple6502_iscntc.s` and
  `cbm_iscntc.s` removed.
- Reference binary rebuilt for the entry jumps (6 bytes at the start of BASIC)
  and for the backspace fix.
- `defines.s` merged into `defines_simple6502.s`; `msbasic.s` includes it
  directly. Unused defines removed (`CURDVC`, `TISTR`, `Z96`).
- `TODO.txt` renamed to `TODO.md`.
- README rewritten for the Simple6502-only branch.

### Fixed

- Backspace ($08) and DEL ($7F) are handled in `MONRDKEY`: the last character
  is removed from the line buffer and erased on the terminal. `inline.s` is
  unchanged. Tested in the emulator, together with Ctrl-C.
- README typos.

## [0.1.0]

### Added

- Simple6502 build target (`defines_simple6502.s`, `make_simple6502.sh`).
- `simple6502.cfg`: BASIC in its own `BASROM` region ($DC00-$FEFF) for merging
  with the BIOS. `header.s` uses a `BASHEADER` segment for this target.
- BIOS integration through `bios_jumptable.inc` (BIOS v0.6.1 or later):
  `MONCOUT`, blocking `MONRDKEY`, non-blocking `MONRDKEY2` (GET) and a Ctrl-C
  check. LOAD and SAVE are stubs.

### Changed

- `print.s`: the CBM2 `INPUTBUFFER` setup is also used for Simple6502.
- `.gitignore`: ignore `out/`, `out-orig/` and `.DS_Store`.
