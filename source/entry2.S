/*
 * Copyright (c) 2019 Ash Wilding. All rights reserved.
 *
 * SPDX-License-Identifier: MIT
 *
 *
 * EL2 hypervisor entry point.
 */

    .global entry2
    .type entry2, @function
entry2:
    ADRP    x0, dummy_vectors
    MSR     VBAR_EL2, x0
