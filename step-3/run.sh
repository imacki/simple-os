#!/bin/sh

nasm -f bin -o bootsec2.img bootsec2.asm
nasm -f bin -o baltrack1.img baltrack1.asm
cat bootsec2.img baltrack1.img > track1.img
qemu-system-i386 -m 1M -fda track1.img -boot order=a
