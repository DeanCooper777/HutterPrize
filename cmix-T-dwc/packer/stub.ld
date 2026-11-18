/* Linker script of the packed executable (see stage0.S for the layout). One read-write-execute
 * segment at 0x400000 that holds the ELF header, stage 0, the compressed stage 1 and the packed
 * image; its memory size extends past the file (the .zero section) so that the zero-filled rest
 * holds stage 1 at S1_BASE (0x600000) and stage 0's count table at S0_HASH (0x800000, 2 MB).
 * The same addresses are in pack.sh (S1_BASE, S0_HASH).
 * New in this entry (part of the packer that replaces UPX, see pk.cpp). Used by pack.sh for the
 * final link. Points the rest of the packer relies on:
 *   - FILEHDR PHDRS put the ELF header and the program header inside the segment, so file
 *     offset 0 is address 0x400000: pkdec.c reads byte 9 of the ELF header there, and pack.sh
 *     turns the address of `packed` into a file offset by subtracting 0x400000;
 *   - there is exactly one program header, which is the one selfextract_comp
 *     (src/readalike_prepr/self_extract.h) patches when it writes the cut copy;
 *   - FLAGS(7) = readable, writable, executable: stage 0 writes stage 1 and then runs it;
 *   - .zero starts at 0x500000, so the file (stub + packed image) must stay below 1 MB. */
ENTRY(_start)
PHDRS { all PT_LOAD FILEHDR PHDRS FLAGS(7); }
SECTIONS {
  . = 0x400000 + SIZEOF_HEADERS;
  .text : { *(.text*) *(.rodata*) *(.data*) } :all
  .zero 0x500000 (NOLOAD) : { . += 0x500000; } :all
  /DISCARD/ : { *(.comment) *(.note*) *(.eh_frame*) *(.llvm*) }
}
