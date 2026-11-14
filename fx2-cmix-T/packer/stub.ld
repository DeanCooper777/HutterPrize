ENTRY(_start)
PHDRS { all PT_LOAD FILEHDR PHDRS FLAGS(7); }
SECTIONS {
  . = 0x400000 + SIZEOF_HEADERS;
  .text : { *(.text*) *(.rodata*) *(.data*) } :all
  .packed : { *(.packed) } :all
  .bss : { *(.bss*) *(COMMON) } :all
  /DISCARD/ : { *(.comment) *(.note*) *(.eh_frame*) *(.llvm*) }
}
