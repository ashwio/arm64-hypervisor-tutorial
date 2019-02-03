/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * Simple PL011 UART driver using polled I/O with no error handling.
 * For documentation, see ARM DDI 0183.
 */

#ifndef H_PL011_DEFINED
#define H_PL011_DEFINED


#include "platform.h"

#ifndef __ASSEMBLER__
    void pl011_init( void );

    void pl011_putc( char c );

    void pl011_puts( const char * s );

    char pl011_getc( void );
#endif


/* H_PL011_DEFINED */
#endif
