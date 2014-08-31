#!/bin/sh

nasm -f bin -o bootsec2.img ../step-3/bootsec2.asm
nasm -f bin -o baltrack2.img baltrack2.asm
cat bootsec2.img baltrack2.img > track2.img
qemu-system-i386 -m 1M -fda track2.img -boot order=a
