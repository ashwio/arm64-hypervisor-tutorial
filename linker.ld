
ENTRY(entry3)

SECTIONS
{
    . = 0x80000000;
    .text : { 
        out/entry3.o(.text)
        out/entry2.o(.text)
        *(.text)
    }
    .data : { *(.data) }
    .bss  : { *(.bss)  }
}
