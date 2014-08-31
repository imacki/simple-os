Simple OS / Step 2
==================

Introduction
------------

Step 2 shows how to load a simple boot sector and then move the boot sector code to a different location in memory.

Moving the boot sector code out of the first 512 KB of RAM allows a kernel or other program to be loaded efficiently into this region of memory.

Requirements
------------

Same as Step 1

Usage
-----

1.  cd to simple-os/step-2 directory
2.  . run.sh

NB: as in Step 1, item 2. above will require changing for Windows

Explanation
-----------

Running step-2 should:

    1.  compile the bootsec1.asm source into a raw boot sector image (bootsec1.img)
    2.  open a window with QEMU booting a virtual machine using the bootsector image just created (bootsec1.img)
    3.  upon loading, the boot sector code should first initialize registers and print a message (message1)
    4.  it should then copy the 512 bytes at 0000:7C00 to 8000:7C00 and destroy the copy of message2 in the old location
    5.  it should jump into the new copy of the boot sector code, and print a second message (message2) using the text copied to the new location
    5.  then it should loop infinitely (hang the CPU).

You should close the window once you have verified that the messages "Original Boot Sector" and "Relocated Boot Sector" were printed on the screen.

Exercises
---------

You can try similar execises to those mentioned in step-1/README.txt
