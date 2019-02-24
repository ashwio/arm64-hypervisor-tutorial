/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * EL2 hypervisor entry point.
 */

#include "asm.h"

globalfunc entry2
    ADRP    x0, dummy_vectors
    MSR     VBAR_EL2, x0
    ADRP    x0, _stack_start
    MOV     sp, x0
    BL      main
    B       .
endfunc entry2
