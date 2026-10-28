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

- `token.s`, `error.s` and `message.s`: removed `.ifdef`s for other targets. `CONFIG_NULL` is
  kept on purpose. `ERR_BADDATA` is commented out (needs `CONFIG_FILE`).
- `misc3.s` removed (KBD only); `msbasic.s` no longer includes it.
- `header.s` now has the entry points: `jmp COLD_START` at $DC00 and
  `jmp RESTART` (warm start) at $DC03. The `.ifdef`s were removed.
- `iscntc.s` holds the Ctrl-C check directly; `simple6502_iscntc.s` and
  `cbm_iscntc.s` removed.
- Reference binary rebuilt: the entry jumps add 6 bytes at the start of BASIC.
- `defines.s` merged into `defines_simple6502.s`; `msbasic.s` includes it
  directly. Unused defines removed (`CURDVC`, `TISTR`, `Z96`).
- `TODO.txt` renamed to `TODO.md`.
- README rewritten for the Simple6502-only branch.

### Fixed

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
