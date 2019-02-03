/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * Useful macros for use in assembly source files.
 */

#ifndef H_ASM_DEFINED
#define H_ASM_DEFINED


/* Begin function declaration with static scope. */
.macro staticfunc name
    .section .text.\name, "ax"
    .type \name, @function
    .func \name
\name:
.endm


/* Begin function declaration with global scope. */
.macro globalfunc name
    .global \name
    staticfunc \name
.endm


/* End function declaration. */
.macro endfunc name
    .endfunc
    .size \name, .-\name
.endm


/* Stack 1-2 registers. */
.macro push reg1:req, reg2:vararg
    .ifnb reg2
        STP     \reg1, \reg2, [sp, #-16]!
    .else
        STP     \reg1, xzr, [sp, #-16]!
    .endif
.endm


/* Pop 1-2 registers. */
.macro pop reg1:req, reg2:vararg
    .ifnb reg2
        LDP     \reg1, \reg2, [sp], #16
    .else
        LDP     \reg1, xzr, [sp], #16
    .endif
.endm


/* H_ASM_DEFINED */
#endif
