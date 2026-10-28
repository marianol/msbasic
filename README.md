# Microsoft BASIC for 6502

This is a single integrated assembly source tree that can generate nine different versions of Microsoft BASIC for 6502.

By running ./make.sh, this will generate all versions and compare them to the original files byte by byte. The CC65 compiler suite is need to build this project.

These are the first ten (known) versions of Microsoft BASIC for 6502:

| Name                | Release  | MS Version   | ROM  | 9digit | INPUTBUFFER  | extensions  | .define    |
| ------------------- |:--------:| ------------ |:----:|:------:|:------------:|:-----------:| ---------- |
| Commodore BASIC 1   |  1977    |              |  Y   |   Y    |      ZP      |    CBM      |            |
| OSI BASIC           |  1977    | 1.0 REV 3.2  |  Y   |   N    |      ZP      |      -      | CONFIG_10A |
| AppleSoft I         |  1977    | 1.1          |  N   |   Y    |    $0200     |    Apple    | CONFIG_11  |
| KIM BASIC           |  1977    | 1.1          |  N   |   Y    |      ZP      |      -      | CONFIG_11A |
| AppleSoft II        |  1978    |              |  Y   |   Y    |    $0200     |    Apple    | CONFIG_2   |
| AIM-65 BASIC        |  1978    | 1.1?         |  Y   |   N    |      ZP      |     AIM     | CONFIG_2A  |
| SYM-1 BASIC         |  1978    | 1.1?         |  Y   |   N    |      ZP      |     SYM     | CONFIG_2A  |
| Commodore BASIC 2   |  1979    |              |  Y   |   Y    |    $0200     |     CBM     | CONFIG_2A  |
| KBD BASIC           |  1982    |              |  Y   |   N    |    $0700     |     KBD     | CONFIG_2B  |
| MicroTAN            |  1980    |              |  Y   |   Y    |      ZP      |      -      | CONFIG_2C  |

(Note that this assembly source cannot (yet) build AppleSoft II.)

This lists the versions in the order in which they were forked from the Microsoft source base. Commodore BASIC 1, as used on the original PET is the oldest known version of Microsoft BASIC for 6502. It contains some additions to Microsoft's version, like Commodore-style file I/O.

The CONFIG_n defines specify what Microsoft-version the OEM version is based on. If CONFIG_2B is defined, for example, CONFIG_2A, CONFIG_2, CONFIG_11A, CONFIG_11 and CONFIG_10A will be defined as well, and all bugfixes up to version 2B will be enabled.

Additionally these releases are built for computer originally not having "original" Microsoft BASIC
| Name                | Release  | .define    |
| ------------------- |:--------:| ---------- |
| W65C816SXB          |  2014    | CONFIG_2C  |
| Simple6502          |  2025    | CONFIG_2A  |


The following symbols can be defined in addition:

| Configuration Symbol              | Description
| --------------------------------- | --------------------------------------------------------------------------------
| CONFIG_CBM1_PATCHES               | jump out into CBM1's binary patches instead of doing the right thing inline
| CONFIG_CBM_ALL                    | add all Commodore-specific additions except file I/O
| CONFIG_DATAFLG                    | ?
| CONFIG_EASTER_EGG                 | include the CBM2 "WAIT 6502" easter egg
| CONFIG_FILE                       | support Commodore PRINT#, INPUT#, GET#, CMD
| CONFIG_IO_MSB                     | all I/O has bit #7 set
| CONFIG_MONCOUT_DESTROYS_Y         | Y needs to be preserved when calling MONCOUT
| CONFIG_NO_CR                      | terminal doesn't need explicit CRs on line ends
| CONFIG_NO_LINE_EDITING            | disable support for Microsoft-style "@", "_", BEL etc.
| CONFIG_NO_POKE                    | don't support PEEK, POKE and WAIT
| CONFIG_NO_READ_Y_IS_ZERO_HACK     | don't do a very volatile trick that saves one byte
| CONFIG_NULL                       | support for the NULL statement
| CONFIG_PEEK_SAVE_LINNUM           | preserve LINNUM on a PEEK
| CONFIG_PRINTNULLS                 | whether PRINTNULLS does anything
| CONFIG_PRINT_CR                   | print CR when line end reached
| CONFIG_RAM                        | optimizations for RAM version of BASIC, only use on 1.x
| CONFIG_ROR_WORKAROUND             | use workaround for buggy 6502s from 1975/1976; not safe for CONFIG_SMALL!
| CONFIG_SAFE_NAMENOTFOUND          | check both bytes of the caller's address in NAMENOTFOUND
| CONFIG_SCRTCH_ORDER               | where in the init code to call SCRTCH
| CONFIG_SMALL                      | use 6 digit FP instead of 9 digit, use 2 character error messages, don't have GET
| CONFIG_SMALL_ERROR                | use 2 character error messages

Changing symbol definitions can alter an existing base configuration, but it not guaranteed to assemble
or work correctly.

## Simple6502 Port

This fork adds a build target for [Simple6502](https://github.com/marianol/simple6502), a homebrew 6502 single board computer with a serial terminal. It is based on the Commodore BASIC 2 configuration (CONFIG_2A, `INPUTBUFFER` at $0200).

To build it, run `./make_simple6502.sh`. The output goes to `out/` (`simple6502.bin` and `simple6502.lbl`). `./make.sh` now writes the original targets to `out-orig/`. Both directories are ignored by git.

What was added or changed:

| File                  | Change
| --------------------- | --------------------------------------------------------------------------------
| defines_simple6502.s  | Target configuration: CONFIG_* flags, zero page layout, `INPUTBUFFER`, and the BIOS entry points (`MONCOUT`, `MONRDKEY`, `LOAD`, `SAVE`, `ISCNTC`)
| defines.s             | Selects the new target when `simple6502` is defined
| simple6502.cfg        | Linker memory map, see below
| header.s              | Uses the `BASHEADER` segment instead of `HEADER` when building for Simple6502, so it does not clash with the BIOS `HEADER` segment. Other targets are unchanged.
| print.s               | The `INPUTBUFFER` setup in `L29B9` takes the same path as CBM2 for Simple6502. The default path uses `sty abs,x`, which does not exist on the 6502 and only works when `INPUTBUFFER` is in zero page.
| zeropage.s            | Comments only
| make_simple6502.sh    | Assembles and links the Simple6502 target

`CONFIG_CBM_ALL` and `CONFIG_FILE` are not enabled, so the Commodore-specific additions and file I/O are left out. `CONFIG_NO_CR` is enabled because the serial terminal does its own line wrapping.

### Memory map

`simple6502.cfg` places BASIC in its own `BASROM` region so it can be merged with the BIOS project. The BIOS, monitor and reset vector segments are also declared (all `optional`), and the BIOS and reset vector entries are meant to be removed once the BIOS project provides them.

| Region     | Start | Size  | Contents
| ---------- |:-----:|:-----:| ---------------------------------------------------
| ZP         | $0000 | $0100 | Zero page
| STACK      | $0100 | $0100 | Stack
| RAM        | $0200 | $7D00 | RAM, includes `INPUTBUFFER` at $0200
| IO         | $7F00 | $0100 | I/O
| ROM        | $8000 | $5C00 | BIOS (`HEADER`, `BIOS`)
| BASROM     | $DC00 | $2400 | BASIC (`BASHEADER`, `VECTORS`, `KEYWORDS`, `ERROR`, `CODE`, `CHRGET`, `INIT`, `EXTRA`)
| MONITOR    | $FF00 | $00FA | `WOZMON`
| RSTVECTORS | $FFFA | $0006 | `RESETVECTORS`

## More Information

More information on the differences of the respective versions can be found on this blog entry: [Create your own Version of Microsoft BASIC for 6502](http://www.pagetable.com/?p=46).

Also, Ben Eater has an published excellent video demonstrating how to port BASIC to a new system: [Running MSBASIC on my breadboard 6502 computer
](https://www.youtube.com/watch?v=XlbPnihCM0E)

## License

2-clause BSD

## Credits

* Main work by Michael Steil <mist64@mac.com>.
* AIM-65 and SYM-1 by Martin Hoffmann-Vetter
* Function names and all uppercase comments taken from Bob Sander-Cederlof's excellent [AppleSoft II disassembly](http://www.txbobsc.com/scsc/scdocumentor/).
* [Applesoft lite](http://cowgod.org/replica1/applesoft/) by Tom Greene helped a lot, too.
* Thanks to Joe Zbicak for help with Intellision Keyboard BASIC
* This work is dedicated to the memory of my dear hacking pal Michael "acidity" Kollmann.
