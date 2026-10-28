
## Simple6502 Build ToDo's

- [x] Figure out what each source in SOURCE_FILES.md does.
- [ ] see opportunities for file consolidation
- [ ] clean up souces for .ifdef(s) that refer to other architectures.

### From original source

* convert messy init code into completely different
  files without ifdefs (not much in common!)
* move all machine specific code into separate files
* rename all labels that point to RTS to RTSn
* look for all " $", i.e. (zeropage) constants, replace them
  with symbols
* convert platform ifdefs in generic files into feature ifdefs or macros

