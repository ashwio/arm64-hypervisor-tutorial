/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * EL2 hypervisor main().
 */

#include "pl011.h"

void main( void ) {
    pl011_init();
    pl011_puts("Hello, world!\0");
}
