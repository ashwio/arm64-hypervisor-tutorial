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
    // Install dummy vector table; each entry branches-to-self
    ADRP    x0, dummy_vectors
    MSR     VBAR_EL2, x0
    
    // Install stack as defined in linker.ld script
    ADRP    x0, _stack_start
    MOV     sp, x0

    //
    // Configure TCR_EL2
    //
    //  31:31  RES1     x1      reserved
    //  23:23  RES1     x1      reserved
    //  18:16  PS       x2      32-bit physical address space
    //  15:14  TG0      x2      4KB translation granule
    //  13:12  SH0      x2      Inner Shareable tables
    //  11:10  ORGN0    x2      Normal Inner/Outer WB RAWA tables
    //  09:08  IRGN0    x2      Normal Inner/Outer WB RAWA ables
    //  05:00  T0SZ     x6      32-bit virtual address space
    //
    LDR     x0, =0x80803520
    MSR     TCR_EL2, x0

    //
    // Configure MAIR_EL2
    //
    //  AttrIndx [0] --> Device-nGnRnE
    //  AttrIndx [1] --> Normal Inner/Outer WB RAWA
    //
    LDR     x0, =0xFF00
    MSR     MAIR_EL2, x0

    //
    // Program early translation tables.
    //
    // We have a 32-bit virtual address space and are using a 4KB translation
    // granule, which implies that translation begins at L1 i.e. TTBR0_EL2
    // points to an L1 table.
    //
    // To keep things simple here we'll just have the following two entries:
    //
    //  [0] mapping 0x00000000 to 0x3FFFFFFF = Device-nGnRnE
    //  [2] mapping 0x80000000 to 0xBFFFFFFF = Normal Inner/Outer WB RAWA
    //
    // With entries [1] and [3..511] inclusive all Unmapped; this gives us 1GB
    // of DRAM to play with, as well as access to most of the peripherals that
    // we care about this early in the boot such as a PL011 UART (for a serial
    // console) and a GIC-500 (interrupt controller).
    //
    // We'll then trash over these tables with proper ones later on.
    //
    // The translation table entries have the following format:
    //
    //  54:54  XN       x1      execute never; region [2] is executable
    //  32:12  PADDR    x20     base physical address
    //  10:10  AF       x1      access flag; set for both regions
    //  09:08  SH       x2      shareability; region [2] is Inner Shareable
    //  07:06  AP       x2      access permissions; both regions are read/write
    //  04:02  AttrIndx x3      index into MAIR_EL2; specifies the memory type
    //  01:00  Descr    x2      descriptor type; both regions are Blocks
    //
    ADRP    x0, _early_ttbase
    MSR     TTBR0_EL2, x0
    LDR     x1, =0x40000000000401
    STR     x1, [x0], #8
    STR     xzr, [x0], #8
    LDR     x1, =0x80000705
    STR     x1, [x0], #8
    MOV     x1, #509
1:
    STR     xzr, [x0], #8
    SUBS    x1, x1, #1
    B.NE    1b

    //
    // Configure SCTLR_EL2
    //
    //  23:22  RES1     x2      reserved   
    //  18:18  RES1     x1      reserved
    //  16:16  RES1     x1      reserved
    //  12:12  I        x1      enable allocation of instrs into unified $s
    //  11:11  RES1     x1      reserved
    //  05:04  RES1     x2      reserved
    //  02:02  C        x1      enable allocation of data into data/unified $s
    //  00:00  M        x1      enable MMU
    //  
    LDR     x0, =0xC51835
    MSR     SCTLR_EL2, x0

    // Jump to C code
    BL      main
    B       .
endfunc entry2
