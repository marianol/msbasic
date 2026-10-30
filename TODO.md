
## Simple6502 Build ToDo's

- [x] Figure out what each source in SOURCE_FILES.md does.
- [x] Create a reference binary and a script that can compile and check against it as I am cleaning up in the source
- [ ] see opportunities for file consolidation
- [ ] clean up souces for .ifdef(s) that refer to other architectures.
  - [x] done: all files except print.s, input.s and inline.s
- [ ] update init.s once the cleanup is done:
  - [ ] use the BIOS RAM size (`RAM_SIZE` at $E3/$E4) for `MEMSIZ` and `FRETOP`, remove the RAM scan (L40D7 loop). The scan has no upper limit and can write into the I/O area at $7F00
  - [ ] remove the `MEMORY SIZE?` and `TERMINAL WIDTH?` prompts
  - [ ] `Z17` and `Z18` are written but never read (`CONFIG_NO_CR`): remove them with `WIDTH` and `WIDTH2` in the defines to free $5C-$5D
  - [ ] new startup banner. `QT_BYTES_FREE` has no 0 at the end and runs into the copyright line (`QT_BASIC`), change both together
  - [ ] `DSCLEN` is set to 3 twice in the cold start, remove one (changes the binary, rebuild the reference)
- [ ] zero page ($E0-$E4): the BASIC `RNDSEED` overlaps the BIOS `TOCKS` and `RAM_SIZE`. Move one of them (see ZEROPAGE_MAP.md). Must be decided before init.s uses `RAM_SIZE`
- [ ] `ENTROPY` in the defines is unused now. Use the timer for the `RND` seed or remove it
- [ ] `USR` is an alias of `GORESTART` ($50), so `USR(x)` ends up at the OK prompt. Give it its own vector
- [ ] `LOAD` and `SAVE` are stubs (`loadsave.s`), hook them to the BIOS

### From original source

* convert messy init code into completely different
  files without ifdefs (not much in common!)
* move all machine specific code into separate files
* rename all labels that point to RTS to RTSn
* look for all " $", i.e. (zeropage) constants, replace them
  with symbols
* convert platform ifdefs in generic files into feature ifdefs or macros

