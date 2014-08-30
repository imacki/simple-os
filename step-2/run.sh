#!/bin/sh

nasm -f bin -o bootsec1.img bootsec1.asm
qemu-system-i386 -m 1M -fda bootsec1.img -boot order=a
