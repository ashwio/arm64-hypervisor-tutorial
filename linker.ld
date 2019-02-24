/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 */


ENTRY(entry3)

SECTIONS
{
    . = 0x80000000;
    _stack_end = .;

    .stack (NOLOAD): {
        . = . + 16K;
    }

    _stack_start = .;
    . = ALIGN(4K);
    _rw_start = .;

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
    
    . = ALIGN(2M);

    _heap_start = .;
    .heap (NOLOAD): {
        . = . + 2M;
    }
    _heap_end = .;

    _vm1_start = .;
    .vm1 (NOLOAD): {
        . = . + 2M;
    }
    _vm1_end = .;

    _vm2_start = .;
    .vm2 (NOLOAD): {
        . = . + 2M;
    }
    _vm2_end = .;  
}
