
This directory contains examples for the LGP-21 computer.  The examples
have the following files:

* `.asm` - Assembly source code.
* `.ptp` - Binary tape image for loading using PIR.
* `.txt` - Text version of the `.ptp` file.
* `.boot` - Binary tape image that can be bootstraped without PIR.
* `.btxt` - Text version of the `.boot` file.

Use the `.ptp` or `.boot` tape images when punching paper tapes to load
into a real LGP-21.

The following assembly files are present:

* `1dlife.asm` - 1-D version of the Game of Life.
* `dump.asm` - Program that bootstraps into track 0 to dump the rest of the disk.
* `fibonacci.asm` - Prints a Fibonacci sequence in hexadecimal.
* `hellorld.asm` - Prints "he11or1d" to the typewriter.
* `random.asm` - Library of routines to help generate random numbers.
* `rand_test.asm` - Test program for `random.asm`.
* `sier.asm` - Draws a Sierpiński Triangle fractal.
