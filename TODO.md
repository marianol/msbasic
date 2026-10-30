
## Simple6502 Build ToDo's

- [x] Figure out what each source in SOURCE_FILES.md does.
- [x] Create a reference binary and a script that can compile and check against it as I am cleaning up in the source
- [x] see opportunities for file consolidation
- [x] the `CONFIG_*` flags in the defines are not read by any source now. They are commented out in one block as documentation of how it was configured. Only `CONFIG_NULL` is still used
- [x] the `-D simple6502` in the build scripts is not needed any more (the build works without it)
- [x] clean up souces for .ifdef(s) that refer to other architectures.
  - Only the `CONFIG_NULL` / `CONFIG_PRINTNULLS` conditionals are left on purpose (token.s, flow1.s, print.s, init.s). To enable NULL uncomment `CONFIG_NULL` and `NULL_MAX` in the defines.
- [ ] update init.s once the cleanup is done:
  - [ ] use the BIOS RAM size (`RAM_SIZE` at $E3/$E4) for `MEMSIZ` and `FRETOP`, remove the RAM scan (L40D7 loop). The scan has no upper limit and can write into the I/O area at $7F00
  - [ ] remove the `MEMORY SIZE?` and `TERMINAL WIDTH?` prompts
  - [ ] `Z17` and `Z18` are written but never read (`CONFIG_NO_CR`): remove them with `WIDTH` and `WIDTH2` in the defines to free $5C-$5D
  - [ ] new startup banner. `QT_BYTES_FREE` has no 0 at the end and runs into the copyright line (`QT_BASIC`), change both together
  - [ ] `DSCLEN` is set to 3 twice in the cold start, remove one (changes the binary, rebuild the reference)
- [ ] zero page ($E0-$E4): the BASIC `RNDSEED` overlaps the BIOS `TOCKS` and `RAM_SIZE`. Move one of them (see ZEROPAGE_MAP.md). Must be decided before init.s uses `RAM_SIZE`
- [ ] `ENTROPY` in the defines is unused now. Use the timer for the `RND` seed or remove it
- [x] `USR` has its own vector at $4D-$4F (it was an alias of `GORESTART`)
- [ ] TEST `USR` in the emulator (not tested yet):
  - `PRINT USR(0)` should give `?ILLEGAL QUANTITY ERROR`
  - load a routine ending in `RTS` (for example at $0300), then `POKE 78,0 : POKE 79,3 : X=USR(5)` should run it and return to the OK prompt
- [ ] `LOAD` and `SAVE` are stubs (`loadsave.s`), hook them to the BIOS

### From original source

* convert messy init code into completely different
  files without ifdefs (not much in common!)
* move all machine specific code into separate files
* rename all labels that point to RTS to RTSn
* look for all " $", i.e. (zeropage) constants, replace them
  with symbols
* convert platform ifdefs in generic files into feature ifdefs or macros

