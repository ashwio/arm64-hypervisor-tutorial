/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 */


ENTRY(entry3)

SECTIONS
{
    . = 0x80000000;
    _rw_start = .;

    _early_ttbase = .;
    . = . + 4K;

    _stack_end = .;
    . = . + 16K;
    _stack_start = .;

    .data : {
        *(.data);
    }

    .bss : {
        *(.bss);
    }

    . = ALIGN(4K);
    _rw_end = .;


    _exec_start = .;

    .text : {
        out/entry3.o(.text);
        out/entry2.o(.text);
        *(.text);
    }

    . = ALIGN(4K);
    _exec_end = .;
}
