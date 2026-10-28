# Microsoft BASIC for 6502

This is based on the https://github.com/mist64/msbasic project. This branch is intended to clean up the source so it will only compile for my Simple 6502 SBC. The idea is to merge it with the existing BIOS and make it easier to maintain.


## Simple6502 Port

This fork adds a target for [Simple6502](https://github.com/marianol/simple6502), a homebrew 6502 SBC with a serial terminal. It is based on the CBM2 configuration (CONFIG_2A, `INPUTBUFFER` at $0200).

Build with `./make_simple6502.sh` (output in `out/`). `./make.sh` now writes the original targets to `out-orig/`.

* `defines_simple6502.s`: target configuration. It includes `bios_jumptable.inc`, a copy of the BIOS jump table (BIOS v0.6.1 or later, needs `BIOS_SERIAL_POLL`).
* `simple6502_extra.s`: `MONRDKEY` (blocking, echoes), `MONRDKEY2` (non-blocking, used by GET) and LOAD/SAVE stubs.
* `simple6502_iscntc.s`: Ctrl-C check.
* `simple6502.cfg`: linker config. BASIC is in its own `BASROM` region ($DC00) so it can be merged with the BIOS, which uses the `HEADER`, `BIOS`, `WOZMON` and `RESETVECTORS` segments. Because of this, `header.s` uses a `BASHEADER` segment for this target only.
* `print.s`: the CBM2 `INPUTBUFFER` setup is also used for this target.

## More Information

More information on the differences of the respective versions can be found on this blog entry: [Create your own Version of Microsoft BASIC for 6502](http://www.pagetable.com/?p=46).

Also, Ben Eater has published an excellent video demonstrating how to port BASIC to a new system: [Running MSBASIC on my breadboard 6502 computer
](https://www.youtube.com/watch?v=XlbPnihCM0E)

## License

2-clause BSD

## Credits

* MicroSoft for releasing [msbasic for 6502](https://github.com/microsoft/BASIC-M6502) code for us to tinker under MIT License
* [Main work](https://github.com/mist64/msbasic) by Michael Steil <mist64@mac.com>.
* AIM-65 and SYM-1 by Martin Hoffmann-Vetter
* Function names and all uppercase comments taken from Bob Sander-Cederlof's excellent [AppleSoft II disassembly](http://www.txbobsc.com/scsc/scdocumentor/).
* [Applesoft lite](http://cowgod.org/replica1/applesoft/) by Tom Greene helped a lot, too.
* Thanks to Joe Zbicak for help with Intellision Keyboard BASIC
* This work is dedicated to the memory of my dear hacking pal Michael "acidity" Kollmann.

