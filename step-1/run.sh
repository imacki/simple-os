#!/bin/sh

nasm -f bin bootsec0.asm
qemu-system-i386 -m 1M -fda bootsec0 -boot order=a
