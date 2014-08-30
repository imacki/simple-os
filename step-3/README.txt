Simple OS / Step 3
==================

Introduction
------------

Step 3 shows how a boot sector can load a group of sectors into memory (i.e. a kernel or other program) and let the new program take control.

Requirements
------------

Same as previous steps.

Usage
-----

1.  cd to simple-os/step-3 directory
2.  . run.sh

NB: as in Step 1, item 2. above will require changing for Windows

Explanation
-----------

Running step-3 should:

    1.  compile the bootsec2.asm source into a raw boot sector image (bootsec2.img)
    2.  compile the source for another program taking up the remaining 17 sectors of track 0
    3.  concatenate the two IMG files to form track1.img (18 sectors or 9KB)
    2.  open a window with QEMU booting a virtual machine using the track1 image just created (track1.img)
    3.  upon loading, the boot sector code should first initialize registers
    4.  it should then copy the 512 bytes at 0000:7C00 to 8000:7C00, jump into that new location, and print a message
    5.  it should then try to load 17 sectors from cylinder 0 head 0, starting at record 2, into RAM at 0000:0510

You should close the window once you have verified that the messages "Original Boot Sector" and "Relocated Boot Sector" were printed on the screen.

Exercises
---------

1.  You can change the program in baltrack1.asm to do whatever you like - it is a standalone program (although constrained to 8.5KB)
2.  You can set up the registers in the bootsector immediately before jumping to 0000:0510 so that the new program doesn't have to set up segment registers or stack
3.  after 2. you can try writing a program with C (e.g. 16 bit OpenWatcom C) with a flat raw binary output and link it to load at offset 0510
4.  try using dd -if=/dev/zero -of=empty-disk.img count=2880 to create a blank disk image, then concatenate boot sector, program, and empty-disk.img to a temporary file, and then use dd again to truncate the temporary file to 2880 blocks (sectors) - a true raw floppy image. The command is dd if=temporary-file of=floppy.img count=2880
5.  you may want to change the load address to e.g. 0000:0800. The load address of 0000:0510 was chosen because it is just above the BIOS data area (which uses RAM up to 0000:0500 inclusive).
