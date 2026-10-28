# Changelog

All notable changes to this Simple6502 fork of
[mist64/msbasic](https://github.com/mist64/msbasic) are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Removed

- Files for all other targets (defines, linker configs, extra, iscntc and
  loadsave files), `make.sh`, `regress.sh` and the `orig/` reference binaries.

### Added

- `SOURCE_FILES.txt`: files the simple6502 build reads.
- This changelog.

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
