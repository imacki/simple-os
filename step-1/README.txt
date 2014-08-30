Simple OS / Step 1
==================

Introduction
------------

Step 1 shows how to create and run/test a very simple boot sector, using NASM to assemble and output 
a raw boot sector and QEMU to load and execute it.

Requirements
------------

(tested on Debian Testing):

    nasm
    qemu-system-x86

These packages should be available for other versions of Linux and for MacOSX and Windows operating systems.
See e.g.
    http://www.nasm.us/pub/nasm/releasebuilds/2.11.05/
    http://wiki.qemu.org/Links

Usage
-----

1.  cd to simple-os/step-1 directory
2.  . run.sh

NB: 2. will require changing for Windows: e.g. delete the first two lines of "run.sh" and save as "run.bat", and execute it

Explanation
-----------

Running step-1 should:

    1.  compile the bootsec0.asm source into a raw boot sector (bootsec0)
    2.  open a window with QEMU booting a virtual machine
    3.  upon loading, the boot sector should initialize registers, print a message, and then hang (infinite loop)

You should close the window once you have verified that the message "I am the boot sector" was printed on the screen.

Exercises
---------

1.  You could try printing a different message.
2.  You could try printing additional messages.
3.  You could try using other BIOS functions to change the color of the text, the back ground color, clear the screen 
    before printing messages, etc.
4.  You could try an interactive program: print a message, read characters from the keyboard, respond.
5.  You could try printing the message in an infinite loop (perhaps with a pause), rather than printing the message once and then hanging.
6.  You could try writing a simple text-based game - e.g. a simple guessing game - in the boot sector.

