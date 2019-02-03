/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * EL3 firmware entry point.
 * We perform minimal setup before dropping to the hypervisor at EL2.
 */

    .global entry3
    .type entry3, @function
entry3:
    // Install dummy vector table; each entry branches-to-self
    ADRP    x0, dummy_vectors
    MSR     VBAR_EL3, x0
    
    //
    // Configure SCR_EL3
    //
    //   10:10 RW       x1      make EL2 be 64-bit
    //   08:08 HCE      x1      enable HVC instructions
    //   05:04 RES1     x3      reserved
    //   00:00 NS       x1      switch to Normal world
    //
    MOV     w0, #0x531
    MSR     SCR_EL3, x0

    //
    // Configure SCTLR_EL2
    //
    //   29:28 RES1     x3      reserved
    //   23:22 RES1     x3      reserved
    //   18:18 RES1     x1      reserved
    //   16:16 RES1     x1      reserved
    //   12:12 I        x0      disable allocation of instrs into unified $s
    //   11:11 RES1     x1      reserved
    //   05:04 RES1     x3      reserved
    //   02:02 C        x0      disable allocation of data into data/unified $s
    //   00:00 M        x0      disable MMU
    //
    LDR     w0, =0x30C50830
    MSR     SCTLR_EL2, x0

    //
    // Prepare to drop to EL2h with all asynchronous exceptions masked
    //
    //   09:09 D        x1      Mask debug exceptions
    //   08:08 A        x1      Mask SErrors
    //   07:07 I        x1      Mask IRQs
    //   06:06 F        x1      Mask FIQs
    //   04:04 M[4]     x0      Bits 03:00 define an AArch64 state
    //   03:00 M[3:0]   x9      EL2h
    //
    MOV     w0, #0x3C9
    MSR     SPSR_EL3, x0

    // Drop to hypervisor code
    ADR     x0, entry2
    MSR     ELR_EL3, x0
    ERET
