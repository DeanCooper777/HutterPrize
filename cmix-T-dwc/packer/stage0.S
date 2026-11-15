/* stage0.S: first stage of the unpacking stub. Hand-written x86-64 assembly, Linux, no libc.
 * New in this entry.
 *
 * What it does. The packed cmix executable starts with this code. It decodes "stage 1" (the
 * context-mixing unpacker pkdec.c, about 6 KB compiled, stored here compressed by s0pack.cpp)
 * into memory at S1_BASE and calls it. Stage 1 then decodes the real cmix executable and
 * executes it. Splitting the stub in two makes it smaller: stage 1 compresses to about 70% and
 * this decoder is under 300 bytes, and the stub is stored twice in the entry (comp9, archive9).
 *
 * How it fits. File layout of the packed executable (one RWX segment loaded at 0x400000):
 *     ELF header | program header | stage 0 (this file) | masks | stage 1, compressed
 *     | packed cmix image (pk.cpp)
 * The segment's memory size is larger than the file: the zero-filled rest holds stage 1 at
 * S1_BASE and the count table at S0_HASH, so nothing has to be allocated or cleared here.
 *
 * The model is documented in s0pack.cpp, which also verifies that a C++ copy of this decoder
 * reproduces stage 1 exactly. s0pack writes s1.inc (S1_LEN, S0_NM, S0_MASKS, S0_TBITS, S0_BOOST).
 *
 * Registers:  rsi  next input byte            rdi  next output byte (stage 1 being written)
 *             rbp  count table                r8d  x, the 32 bits of the stream being decoded
 *             r9d  x1, r10d x2 (coder range)  r11d c0: 1, then the bits of the current byte
 *             r12d N0, r13d N1 (summed counts)   r14d model counter, then the decoded bit
 *             r15  stack pointer at entry (argc/argv/envp for stage 1)
 * Testing: pack.sh runs the finished executable; a wrong byte here fails the build.
 *
 * What it replaces: the previous winning entry (fx2-cmix-transformer-v1) packed its executable
 * with UPX, whose own stub did this job; see pk.cpp for why the packer is new.
 * History bytes before the start of stage 1 are read from the memory below S1_BASE, which is
 * zero (s0pack.cpp counts them as zero too). The hash table and stage 1's memory are zero
 * because they lie in the part of the segment that the file does not cover.
 */
#include "s1.inc"

        .intel_syntax noprefix
        .text
        .globl  _start
_start:
        mov     r15, rsp
        mov     esi, offset s1_stream
        mov     edi, S1_BASE
        mov     ebp, S0_HASH
        lodsd                                   /* x = first four bytes, big endian */
        bswap   eax
        mov     r8d, eax
        xor     r9d, r9d                        /* x1 = 0 */
        or      r10d, -1                        /* x2 = 0xffffffff */
.Lbyte:
        push    1
        pop     r11                             /* c0 = 1 */
.Lbit:
        xor     r12d, r12d
        xor     r13d, r13d
        mov     ebx, offset s0_masks
        push    S0_NM
        pop     r14
.Lmodel:                                        /* one model: hash its context, add its counts */
        movzx   eax, byte ptr [rbx]             /* mask: bit j set = byte at [rdi-1-j] is used */
        inc     rbx
        mov     edx, eax                        /* hash starts as the mask itself */
        push    -1
        pop     rcx
.Lhist: shr     al, 1
        jnc     1f
        crc32   edx, byte ptr [rdi + rcx]
1:      dec     rcx
        test    al, al
        jnz     .Lhist
        crc32   edx, r11b                       /* ...and the bits of this byte so far */
        and     edx, (1 << S0_TBITS) - 1
        lea     rdx, [rbp + rdx*2]              /* slot: two counts, n0 then n1 */
        push    rdx                             /* kept for the update below */
        movzx   eax, byte ptr [rdx]
        movzx   ecx, byte ptr [rdx + 1]
        test    al, al                          /* a context that has seen only one value */
        jz      2f                              /* counts for more: multiply by 2^S0_BOOST */
        test    cl, cl
        jnz     3f
2:      shl     eax, S0_BOOST
        shl     ecx, S0_BOOST
3:      add     r12d, eax
        add     r13d, ecx
        dec     r14d
        jnz     .Lmodel

        /* decode one bit: xmid = x1 + (x2 - x1) * (N1 + 1) / (N0 + N1 + 2); bit = x <= xmid */
        lea     ecx, [r12 + r13 + 2]
        lea     eax, [r13 + 1]
        mov     edx, r10d
        sub     edx, r9d
        mul     edx
        div     ecx
        add     eax, r9d
        cmp     r8d, eax
        setbe   r14b                            /* r14d was 0: now the bit */
        jbe     4f
        lea     r9d, [rax + 1]                  /* 0: x1 = xmid + 1 */
        jmp     .Lnorm
4:      mov     r10d, eax                       /* 1: x2 = xmid */
.Lnorm:                                         /* shift out the bytes x1 and x2 agree on */
        mov     eax, r9d
        xor     eax, r10d
        shr     eax, 24
        jnz     5f
        shl     r9d, 8
        shl     r10d, 8
        mov     r10b, 255
        shl     r8d, 8
        lodsb
        mov     r8b, al
        jmp     .Lnorm
5:
        push    S0_NM                           /* update the counts of every model */
        pop     rcx
6:      pop     rdx
        lea     rax, [rdx + r14]                /* count of the decoded bit: +1, at most 255 */
        inc     byte ptr [rax]
        jnz     7f
        dec     byte ptr [rax]
7:      lea     rax, [rdx + 1]
        sub     rax, r14                        /* the other count: halved if above 1 */
        cmp     byte ptr [rax], 1
        jbe     8f
        shr     byte ptr [rax], 1
8:      loop    6b

        lea     r11d, [r11*2 + r14]             /* c0 = c0 * 2 + bit */
        bt      r11d, 8
        jnc     .Lbit
        mov     eax, r11d
        stosb                                   /* byte complete */
        cmp     edi, S1_BASE + S1_LEN
        jne     .Lbyte

        mov     rdi, r15                        /* stage 1: cstart(initial stack pointer, image) */
        mov     esi, offset packed
        and     rsp, -16
        mov     eax, S1_BASE
        call    rax

s0_masks:
        .byte   S0_MASKS
s1_stream:
        .incbin "s1.cm"
        .globl  packed
packed:                                         /* the packed cmix image (pk.cpp) */
        .incbin "image.pk"

        .section .note.GNU-stack,"",@progbits
