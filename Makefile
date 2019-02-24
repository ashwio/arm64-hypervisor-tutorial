#
# Copyright (c) 2019 Ash Wilding. All rights reserved.
#
# SPDX-License-Identifier: MIT
#


#
# OS specific tools
# fRM removes a file, dRM removes a directory, dMK makes a directory
#
ifeq ($(OS), Windows_NT)
	fRM := cmd.exe /c del /f /q
	dRM := cmd.exe /c rd /s /q
	dMK := cmd.exe /c mkdir
else
	fRM := rm -f
	dRM := rm -rf
	dMK := mkdir -p
endif


#
# Directories and output file
#
dSRC := source
dINC := include
dOUT := out
fOUT := out.elf


#
# Compiler, assembler, linker
# ${CROSS_COMPILE} needs be /path/to/gcc/bin/aarch64-elf-
# Where "/path/to/gcc/" is where you installed aarch64-elf-gcc
#
CC := ${CROSS_COMPILE}gcc
AS := ${CROSS_COMPILE}gcc
LD := ${CROSS_COMPILE}ld


#
# Compiler, assembler, and linker flags
#
CC_FLAGS := -I$(dINC) -g -O1
AS_FLAGS := -I$(dINC) -g -O1
LD_FLAGS := -T linker.ld


#
# Generate list of objects to build
# 
C_SOURCES   := $(wildcard ${dSRC}/*.c)
ASM_SOURCES := $(wildcard ${dSRC}/*.S)
C_OBJECTS	:= $(C_SOURCES:${dSRC}/%.c=${dOUT}/%.o)
ASM_OBJECTS := $(ASM_SOURCES:${dSRC}/%.S=${dOUT}/%.o)
OBJECTS		:= $(C_OBJECTS) $(ASM_OBJECTS)


#
# Rules to build the project
#
.PHONY: all clean rebuild

all: ${dOUT} ${fOUT}

${dOUT}:
	@${dMK} $@

clean:
	@${dRM} ${dOUT}
	@${fRM} ${fOUT}

rebuild: clean all

${dOUT}/%.o: ${dSRC}/%.c
	$(CC) $(CC_FLAGS) -c $< -o $@

${dOUT}/%.o: ${dSRC}/%.S
	$(AS) $(AS_FLAGS) -c $< -o $@

${fOUT}: ${OBJECTS} linker.ld
	${LD} $^ -o $@ ${LD_FLAGS}
