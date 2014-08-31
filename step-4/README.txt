Simple OS / Step 4
==================

Introduction
------------

Step 4 shows how a boot sector can load a program that manipulates interrupt vectors and handlers.

In Step 4, the loaded program copies the interrupt vector of the BIOS keyboard handler (int 9) to interrupt 0x51. Then it replaces the BIOS vector for interrupt 9 with the address of its own keyboard handler (0000:new_int9).

The new keyboard handler does two things: it keeps count of the number of times it is called, and then it calls the old BIOS keyboard handler that is now at interrupt 0x51.

So Step 4 shows how to copy an interrupt vector to a new interrupt number (i.e. how to read and write interrupt vectors); how to put the address of your own interrupt handler into the Interrupt vector table (IVT); and how to call the old interrupt handler from inside the new interrupt handler.

Requirements
------------

Same as previous steps.

Usage
-----

1.  cd to simple-os/step-4 directory
2.  . run.sh

NB: as in Step 1, item 2. above will require changing for Windows

Explanation
-----------

Running step-4 should:

    1.  do everything as in step-3 except hanging the system (see Explanation in README of step-3)
    2.  the new program should read the offset and segment address of the old (BIOS) keyboard handler for interrupt 9 and write them to interrupt 0x51
    3.  it should then get the offset and segment of the new keyboard handler (new_int9 in baltrack2.asm) and write them to interrupt 9
    4.  it should then print a message reporting how many keyboard interrupts (int 9) have been received since the vector was changed (should be 0)
    5.  it should then prompt for user input (user's name, terminated with Enter key) which is stored in a buffer
    6.  it should then print a welcome message incorporating the user's name
    7.  it should then print a message reporting how many keyboard interrupts (int 9) have been received since the vector was changed (should be *more* than 0)

You should close the window once you have verified that all the messages described above were printed on the screen.

Exercises
---------

NB: you should use CLI immediately before, and STI immediately after, writing the segment and offset of an interrupt vector, to prevent external interrupts from trying to call half altered interrupt vectors.

1.  You can try to do the same thing for interrupt 8 (move to int 0x50) and the other hardware interrupts called by IRQ 0-7 (move old BIOS vectors to interrupt 0x50-0x57)
