/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * Simple PL011 UART driver using polled I/O with no error handling.
 * For documentation, see ARM DDI 0183.
 */

#include "asm.h"
#include "pl011.h"

#define FR_TXFF (1 << 5)
#define FR_RXFE (1 << 4)
#define FR_BUSY (1 << 3)

#define DR   0x00
#define ECR  0x04
#define FR   0x18
#define CR   0x30

#define ASCII_NL 10
#define ASCII_CR 13


/*
 * Initialise the PL011 UART with Tx and Rx enabled.
 * Note: We don't program LCR/IBRD/FBRD as they have no effect on FVP.
 */
globalfunc pl011_init
    LDR     x0, =PLATFORM_PL011_BASE
    STR     wzr, [x0, #CR]
    STR     wzr, [x0, #ECR]
    STR     wzr, [x0, #DR]
    LDR     w1, =0x301
    STR     w1, [x0, #CR]
    RET
endfunc pl011_init


globalfunc pl011_putc
    LDR     x1, =PLATFORM_PL011_BASE
    .macro wait_for_tx_ready
        1:
            LDR     w2, [x1, #FR]
            MOV     w3, #(FR_TXFF | FR_BUSY)
            AND     w2, w2, w3
            CBNZ    w2, 1b
    .endm 
    wait_for_tx_ready
    CMP     w0, #ASCII_NL
    B.NE    2f
    MOV     w2, #ASCII_CR
    STR     w2, [x1, #DR]
    wait_for_tx_ready
2:
    STR     w0, [x1, #DR]
    RET
endfunc pl011_putc


globalfunc pl011_puts
    push    x20, x30
    MOV     x20, x0
1:
    LDRB    w0, [x20], #1
    CBZ     w0, 2f
    BL      pl011_putc
    B       1b
2:
    pop     x20, x30
    RET
endfunc pl011_puts


globalfunc pl011_getc
    LDR     x1, =PLATFORM_PL011_BASE
1:
    LDR     w2, [x1, #FR]
    AND     w2, w2, #FR_RXFE
    CBNZ    w2, 1b
    LDRB    w0, [x1, #DR]
    RET
endfunc pl011_getc
