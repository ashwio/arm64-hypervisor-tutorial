/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 */


ENTRY(entry3)

SECTIONS
{
    . = 0x80000000;

    .stack (NOLOAD): {
        . = ALIGN(16);
        _stack_end = .;
        . = . + (16 * 1024);
        . = ALIGN(16);
        _stack_start = .;
    }

    .text : { 
        out/entry3.o(.text);
        out/entry2.o(.text);
        *(.text);
    }

    .data : { *(.data) }
    .bss  : { *(.bss) }
}
