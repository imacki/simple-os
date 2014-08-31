#!/bin/sh

nasm -f bin -o bootsec0.img bootsec0.asm
qemu-system-i386 -m 1M -fda bootsec0.img -boot order=a
