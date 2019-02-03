/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * The Armv8-A architecture defines:
 *      - Vector table base addresses are aligned to 4KB
 *      - Each entry is 32 instructions (128 bytes) long
 *
 * The vectors in this file use the following taxonomy:
 *      <table>_<src>_<type>[_<sp>]
 *
 * Where <src> is one of:
 *      - "c" for current exception level (EL)
 *      - "l64" for a lower EL, where one or more ELs below this one is 64-bit
 *      - "l32" for a lower EL, where all ELs below this one are 32-bit
 *
 * Where <type> is one of:
 *      - "sync" for synchronous exceptions
 *      - "irq" for IRQs
 *      - "fiq" for FIQs
 *      - "serror" for System Errors
 *
 * Where <sp> is one of:
 *      - "sp0" for thread mode
 *      - "spx" for handler mode
 *
 * Example: "dummy_c_sync_sp0" is dummy table handler for synchronous
 * exceptions take from the current EL when we were in thread mode.
 */


/*
 * Dummy vector table where all entries are branches-to-self; useful to
 * safely spin on unexpected exceptions:
 *  - During early development before we've written a proper table
 *  - During early boot before we've had a chance to install a proper table
 * 
 * We can also install this table at EL3 when not using actual firmware;
 * this way we safely spin on SMC instructions.
 */
    .align 12
    .global dummy_vectors
dummy_vectors:
dummy_c_sync_sp0:     B   .
    .align 7
dummy_c_irq_sp0:      B   .
    .align 7
dummy_c_fiq_sp0:      B   .
    .align 7
dummy_c_serror_sp0:   B   .
    .align 7
dummy_c_sync_spx:     B   .
    .align 7
dummy_c_irq_spx:      B   .
    .align 7
dummy_c_fiq_spx:      B   .
    .align 7
dummy_c_serror_spx:   B   .
    .align 7
dummy_l64_sync:       B   .
    .align 7
dummy_l64_irq:        B   .
    .align 7
dummy_l64_fiq:        B   .
    .align 7
dummy_l64_serror:     B   .
    .align 7
dummy_l32_sync:       B   .
    .align 7
dummy_l32_irq:        B   .
    .align 7
dummy_l32_fiq:        B   .
    .align 7
dummy_l32_serror:     B   .
