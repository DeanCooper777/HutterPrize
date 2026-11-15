/* Linker script of stage 1 (pkdec.c): a flat image that stage 0 decodes to S1_BASE and calls at
 * its first byte (cstart is placed first through its section name). The image is .text; .bss
 * follows it in memory and is already zero (see stub.ld). S1_BASE is passed by pack.sh.
 * New in this entry (part of the packer that replaces UPX, see pk.cpp). pack.sh links stage1.s
 * with it, also passing the layout of the packed binary as symbols (PK_TEXT_LO, PK_TEXT_HI,
 * PK_HOLE_LO, PK_HOLE_LEN, see pkdec.c), and takes .text out as the flat image with objcopy. */
SECTIONS {
  . = S1_BASE;
  .text : { *(.text.entry) *(.text*) *(.rodata*) *(.data*) }
  .bss : { *(.bss*) *(COMMON) }
  /DISCARD/ : { *(.comment) *(.note*) *(.eh_frame*) *(.llvm*) }
}
