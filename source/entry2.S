/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * EL2 hypervisor entry point.
 */

#include "asm.h"

.data
hello_world:
    .ascii "Hello, world!\0"


globalfunc entry2
    ADRP    x0, dummy_vectors
    MSR     VBAR_EL2, x0
    ADRP    x0, _stack_start
    MOV     sp, x0
    BL      pl011_init
    ADR     x0, hello_world
    BL      pl011_puts
    B       .
endfunc entry2
