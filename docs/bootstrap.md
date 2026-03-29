Bootstrap process for the Program Input Routine
===============================================

The [LGP-21 Programming Manual](https://bitsavers.org/pdf/generalPrecision/LGP-21/LGP-21_Programming_Manual_1963.pdf) and
[LGP-21 Reference Manual](https://bitsavers.org/pdf/generalPrecision/LGP-21/LGP-21_Reference_Manual_1963.pdf)
describe the process of bootstrapping the "Program Input Routine" or "PIR"
into memory.  It can be difficult to understand.  This document tries to
explain what is happening step by step.

The PIR is loaded from paper tape, either via the paper tape reader on
the typewriter or the paper tape reader in the main unit.  There are three
pieces on the tape:

* First stage bootstrap which loads the second stage bootstrap.
* Second stage bootstrap which loads the PIR to address 0000 in memory.
* The PIR itself.

Here we explain the bootstrap process for [version 2](https://bitsavers.org/pdf/generalPrecision/LGP-21/paper_tapes/Program_Input_%232.ptp)
of the PIR, loaded using the paper tape reader on the main unit.
Version 1 would be similar.

## First Stage Bootstrap

This is what the first stage bootstrap looks like on the tape:

    000c0008'800i0000'
    000c000j'000c0014'
    000c0010'800i0000'
    000u0008'norma1        '

Words are terminated by conditional stop / single quote characters.
Each pair of hexadecimal words is a value to put into the instruction
register and a value to put into the accumulator.  Then the instruction
is executed.  As each word is entered, it is typed on the typewriter.

See the LGP-21 manuals for the right combination of buttons and
switches to use.  When the final word "normal" is printed, the
user can switch the computer to NORMAL mode and start execution using
the final instruction word "000u0008".  After that the computer takes over.

Here is what the word pairs correspond to:

    000c0008    Store A to location 0002 in memory and clear A
    800i0000    Read a word from paper tape and put it into A

    000c000j    Store A to location 0003 in memory and clear A
    000c0014    Store A to location 0005 in memory

    000c0010    Store A to location 0004 in memory and clear A
    800i0000    Read a word from paper tape and put it into A

    000u0008    Jump to location 0002 in memory

As can be seen, the first three pairs set up a store instruction and
the value to be stored.  The full sequence has the effect of building
up the following instructions in memory starting at location 0002:

    0002    800i0000    Read a word from paper tape and put it into A
    0003    000c0014    Store A to location 0005 in memory and clear A
    0004    800i0000    Read a word from paper tape and put it into A

And then it jumps to the start of this sequence at location 0002.

The leading zeros are important as they shift out any other characters
on the tape like carriage returns, spaces, or introductory header comments.
The eight spaces after "normal" shift the characters "normal" out of the
accumulator, leaving A set to zero just before the bootstrap runs.

## Second Stage Bootstrap

The second stage bootstrap continues the process of loading instructions
into memory with pairs of words:

    000c0018'u0008'c3w00'800i0000'c3w04'gwc0000'c3w08'
    u3w20'c3w20'b3w04'c3w24's3w44'c3w28't3w34'
    c3w2j'c3w04'c3w30'u3w00'c3w34''c3w38'u0000'
    c3w44'wwwwj'u3w00''

We can now drop leading zeroes because we clear A after every store with
the "c" instruction.

The first two words are loaded by the first-stage bootstrap and
deposited at locations 0005 and 0006 in memory.  The bootstrap code in
memory now reads:

    0002    800i0000    Read a word from paper tape and put it into A
    0003    000c0014    Store A to location 0005 in memory and clear A
    0004    800i0000    Read a word from paper tape and put it into A
    0005    000c0018    Store A to location 0006 in memory and clear A
    0006       u0008    Jump to location 0002 in memory

This creates a complete program to replicate what the operator previously
did with front panel switches: read a store instruction and the value
to store.  Each time around the loop, the store instruction is put at
address 0005 and the process repeats for the next pair of words.

The rest of the second stage bootstrap populates words starting at
location 6300 (track 63, sector 0) in memory:

    c3w00'800i0000'
    c3w04'gwc0000'
    c3w08'u3w20'
    c3w20'b3w04'
    c3w24's3w44'
    c3w28't3w34'
    c3w2j'c3w04'
    c3w30'u3w00'
    c3w34''
    c3w38'u0000'
    c3w44'wwwwj'
    u3w00''

The final instruction "u3w00" is an unconditonal jump to location 6300
and overwrites the store instruction at location 0005.  Execution of the
bootstrap code on track 63 starts running.

This is what the second stage bootstrap code on track 63 looks like:

    6300    800i0000'   Read a word from paper tape and put it into A
    6301     gwc0000'   Store A to location 0000 in memory and clear A (*)
    6302       u3w20'   Jump to location 6308 in memory
    6303                Unused
    6304                Unused
    6305                Unused
    6306                Unused
    6307                Unused
    6308       b3w04'   Load the value at location 6301 into A
    6309       s3w44'   Subtract the value at location 6317 from A
    6310       t3w34'   Jump to location 6313 if A is negative
    6311       c3w04'   Store the value in A to location 6301 in memory
    6312       u3w00'   Jump to location 6300 in memory
    6313            '   Halt
    6314       u0000'   Jump to location 0000 in memory
    6315                Unused
    6316                Unused
    6317       wwwwj'   The constant 0x000ffffc

The key to understanding this is the instruction marked with a star.
Every time through the loop, the instruction at location 6301 is
updated with a new store instruction for the next address.

The starting instruction "gwc0000" has the hexadecimal value 0x0bfd0000.
The "gw" part is ignored by the machine; the actual instruction is "c0000".

Each time around the loop, 0x000ffffc is subtracted from the instruction
at 6301 to create a new instruction.  Eventually this causes a numeric
underflow, causing the conditional jump instruction at location 6310 to
exit the loop after 192 iterations.  Which coincidentally is the size
of the PIR on the rest of the tape!

After the second stage bootstrap completes, tracks 0, 1, and 2 are
populated with the PIR and the machine halts.  If the machine is
resumed in this state, it will execute the "u0000" instruction at
location 6314 and control passes to the PIR.
