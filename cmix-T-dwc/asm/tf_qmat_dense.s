	.text
	.file	"qmat_dense.cpp"
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
.LCPI0_0:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI0_1:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf,@function
_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf: # @_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
# %bb.0:
	pushq	%rax
	movl	12(%rdi), %eax
	cmpl	$204, %eax
	jle	.LBB0_1
# %bb.8:
	cmpl	$205, %eax
	je	.LBB0_19
# %bb.9:
	cmpl	$224, %eax
	je	.LBB0_19
# %bb.10:
	cmpl	$768, %eax                      # imm = 0x300
	jne	.LBB0_25
# %bb.11:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB0_24
# %bb.12:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI0_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB0_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_14 Depth 2
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%r8d, %r8d
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB0_14:                               #   Parent Loop BB0_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqa	(%rsi,%r8), %ymm5
	vpmaddubsw	32(%rcx,%r8,4), %ymm5, %ymm6
	vpmaddubsw	64(%rcx,%r8,4), %ymm5, %ymm7
	vpmaddubsw	96(%rcx,%r8,4), %ymm5, %ymm8
	vpmaddubsw	128(%rcx,%r8,4), %ymm5, %ymm5
	prefetcht0	2208(%rcx,%r8,4)
	prefetcht0	2272(%rcx,%r8,4)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	160(%rcx,%r8,4), %ymm9, %ymm10
	vpmaddubsw	192(%rcx,%r8,4), %ymm9, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm7, %ymm11, %ymm7
	vpmaddubsw	224(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	256(%rcx,%r8,4), %ymm9, %ymm9
	prefetcht0	2336(%rcx,%r8,4)
	prefetcht0	2400(%rcx,%r8,4)
	vmovdqa	64(%rsi,%r8), %ymm10
	vpmaddubsw	288(%rcx,%r8,4), %ymm10, %ymm11
	vpmaddubsw	320(%rcx,%r8,4), %ymm10, %ymm12
	vpmaddubsw	352(%rcx,%r8,4), %ymm10, %ymm13
	vpaddw	%ymm5, %ymm9, %ymm9
	vpmaddubsw	384(%rcx,%r8,4), %ymm10, %ymm10
	prefetcht0	2464(%rcx,%r8,4)
	prefetcht0	2528(%rcx,%r8,4)
	vmovdqa	96(%rsi,%r8), %ymm14
	vpmaddubsw	416(%rcx,%r8,4), %ymm14, %ymm5
	vpaddw	%ymm5, %ymm11, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmaddubsw	448(%rcx,%r8,4), %ymm14, %ymm6
	vpaddw	%ymm6, %ymm12, %ymm6
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmaddubsw	480(%rcx,%r8,4), %ymm14, %ymm7
	vpaddw	%ymm7, %ymm13, %ymm7
	vpaddw	%ymm7, %ymm8, %ymm7
	vpmaddubsw	512(%rcx,%r8,4), %ymm14, %ymm8
	vpaddw	%ymm8, %ymm10, %ymm8
	prefetcht0	2592(%rcx,%r8,4)
	prefetcht0	2656(%rcx,%r8,4)
	vmovdqa	128(%rsi,%r8), %ymm10
	vpmaddubsw	544(%rcx,%r8,4), %ymm10, %ymm11
	vpmaddubsw	576(%rcx,%r8,4), %ymm10, %ymm12
	vpmaddubsw	608(%rcx,%r8,4), %ymm10, %ymm13
	vpmaddubsw	640(%rcx,%r8,4), %ymm10, %ymm10
	vpaddw	%ymm8, %ymm9, %ymm8
	prefetcht0	2720(%rcx,%r8,4)
	prefetcht0	2784(%rcx,%r8,4)
	vmovdqa	160(%rsi,%r8), %ymm9
	vpmaddubsw	672(%rcx,%r8,4), %ymm9, %ymm14
	vpmaddubsw	704(%rcx,%r8,4), %ymm9, %ymm15
	vpaddw	%ymm14, %ymm11, %ymm11
	vpaddw	%ymm15, %ymm12, %ymm12
	vpmaddubsw	736(%rcx,%r8,4), %ymm9, %ymm14
	vpaddw	%ymm14, %ymm13, %ymm13
	vpmaddubsw	768(%rcx,%r8,4), %ymm9, %ymm9
	prefetcht0	2848(%rcx,%r8,4)
	prefetcht0	2912(%rcx,%r8,4)
	vmovdqa	192(%rsi,%r8), %ymm14
	vpmaddubsw	800(%rcx,%r8,4), %ymm14, %ymm15
	vpaddw	%ymm9, %ymm10, %ymm9
	vpaddw	%ymm15, %ymm11, %ymm10
	vpmaddubsw	832(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm10
	vpmaddubsw	864(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm11, %ymm13, %ymm10
	vpmaddubsw	896(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm11, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm8, %ymm8
	prefetcht0	2976(%rcx,%r8,4)
	prefetcht0	3040(%rcx,%r8,4)
	vmovdqa	224(%rsi,%r8), %ymm9
	vpmaddubsw	928(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm5, %ymm10, %ymm5
	vpmaddubsw	960(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm6, %ymm10, %ymm6
	vpmaddubsw	992(%rcx,%r8,4), %ymm9, %ymm10
	vpmaddubsw	1024(%rcx,%r8,4), %ymm9, %ymm9
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm9, %ymm8, %ymm8
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpaddd	%ymm1, %ymm5, %ymm1
	vpmaddwd	%ymm0, %ymm6, %ymm5
	vpaddd	%ymm4, %ymm5, %ymm4
	vpmaddwd	%ymm0, %ymm7, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm0, %ymm8, %ymm5
	vpaddd	%ymm2, %ymm5, %ymm2
	addq	$256, %r8                       # imm = 0x100
	cmpq	$768, %r8                       # imm = 0x300
	jne	.LBB0_14
# %bb.15:                               #   in Loop: Header=BB0_13 Depth=1
	vphaddd	%ymm4, %ymm1, %ymm1
	vphaddd	%ymm2, %ymm3, %ymm2
	vphaddd	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpsubd	(%rcx), %xmm1, %xmm1
	vpaddd	%xmm2, %xmm1, %xmm1
	leal	(,%rdi,4), %r8d
	vcvtdq2ps	%xmm1, %xmm1
	vmulps	16(%rcx), %xmm1, %xmm1
	vmovups	%xmm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$3104, %rcx                     # imm = 0xC20
	cmpq	%rax, %rdi
	jne	.LBB0_13
	jmp	.LBB0_24
.LBB0_1:
	cmpl	$64, %eax
	je	.LBB0_16
# %bb.2:
	cmpl	$192, %eax
	jne	.LBB0_25
# %bb.3:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB0_24
# %bb.4:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI0_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB0_5:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_6 Depth 2
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB0_6:                                #   Parent Loop BB0_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r8,8)
	prefetcht0	2368(%rcx,%r8,8)
	prefetcht0	2432(%rcx,%r8,8)
	prefetcht0	2496(%rcx,%r8,8)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	320(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	352(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	384(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	416(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	448(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	480(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	512(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	544(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$160, %r8
	jne	.LBB0_6
# %bb.7:                                #   in Loop: Header=BB0_5 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	leal	(,%rdi,8), %r8d
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1600, %rcx                     # imm = 0x640
	cmpq	%rax, %rdi
	jne	.LBB0_5
	jmp	.LBB0_24
.LBB0_19:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB0_24
# %bb.20:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI0_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB0_21:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_22 Depth 2
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB0_22:                               #   Parent Loop BB0_21 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r8,8)
	prefetcht0	2368(%rcx,%r8,8)
	prefetcht0	2432(%rcx,%r8,8)
	prefetcht0	2496(%rcx,%r8,8)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	320(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	352(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	384(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	416(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	448(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	480(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	512(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	544(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$192, %r8
	jne	.LBB0_22
# %bb.23:                               #   in Loop: Header=BB0_21 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	leal	(,%rdi,8), %r8d
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1856, %rcx                     # imm = 0x740
	cmpq	%rax, %rdi
	jne	.LBB0_21
	jmp	.LBB0_24
.LBB0_16:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB0_24
# %bb.17:
	movq	(%rdi), %rcx
	shlq	$3, %rax
	xorl	%edi, %edi
	vpbroadcastw	.LCPI0_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB0_18:                               # =>This Inner Loop Header: Depth=1
	vmovdqa	(%rsi), %ymm3
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm3, %ymm4
	vpmaddubsw	128(%rcx), %ymm3, %ymm5
	vpmaddubsw	192(%rcx), %ymm3, %ymm2
	vpmaddubsw	256(%rcx), %ymm3, %ymm1
	vpmaddubsw	96(%rcx), %ymm3, %ymm6
	vpmaddubsw	160(%rcx), %ymm3, %ymm7
	vpmaddubsw	224(%rcx), %ymm3, %ymm8
	vpmaddubsw	288(%rcx), %ymm3, %ymm3
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	vmovdqa	32(%rsi), %ymm9
	prefetcht0	2304(%rcx)
	vpmaddubsw	320(%rcx), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	352(%rcx), %ymm9, %ymm10
	vpmaddubsw	384(%rcx), %ymm9, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm5, %ymm11, %ymm5
	vpmaddubsw	416(%rcx), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	448(%rcx), %ymm9, %ymm10
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm4, %ymm4
	vpmaddubsw	480(%rcx), %ymm9, %ymm6
	vpmaddubsw	512(%rcx), %ymm9, %ymm11
	vpaddw	%ymm2, %ymm10, %ymm2
	vpmaddubsw	544(%rcx), %ymm9, %ymm9
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vphaddd	%ymm7, %ymm5, %ymm5
	vpaddw	%ymm6, %ymm8, %ymm6
	vphaddd	%ymm5, %ymm4, %ymm4
	vpaddw	%ymm1, %ymm11, %ymm1
	vpaddw	%ymm3, %ymm9, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm6, %ymm5
	vphaddd	%ymm5, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm1, %ymm1
	prefetcht0	2368(%rcx)
	vphaddd	%ymm1, %ymm2, %ymm1
	prefetcht0	2432(%rcx)
	prefetcht0	2496(%rcx)
	vinserti128	$1, %xmm1, %ymm4, %ymm2
	vperm2i128	$49, %ymm1, %ymm4, %ymm1 # ymm1 = ymm4[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	movl	%edi, %r8d
	andl	$-8, %r8d
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	addq	$576, %rcx                      # imm = 0x240
	addq	$8, %rdi
	cmpq	%rdi, %rax
	jne	.LBB0_18
.LBB0_24:
	popq	%rax
	vzeroupper
	retq
.LBB0_25:
	movl	$.L.str.13, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end0:
	.size	_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf, .Lfunc_end0-_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf
.LCPI1_0:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI1_1:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf,@function
_ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf: # @_ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf
# %bb.0:
	pushq	%rax
	movl	12(%rdi), %eax
	cmpl	$204, %eax
	jle	.LBB1_1
# %bb.8:
	cmpl	$205, %eax
	je	.LBB1_19
# %bb.9:
	cmpl	$224, %eax
	je	.LBB1_19
# %bb.10:
	cmpl	$768, %eax                      # imm = 0x300
	jne	.LBB1_25
# %bb.11:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB1_24
# %bb.12:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI1_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB1_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_14 Depth 2
	vpxor	%xmm1, %xmm1, %xmm1
	movl	$256, %r8d                      # imm = 0x100
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB1_14:                               #   Parent Loop BB1_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqa	-256(%rsi,%r8), %ymm5
	vmovdqa	-224(%rsi,%r8), %ymm6
	vmovdqa	-192(%rsi,%r8), %ymm7
	vmovdqa	-160(%rsi,%r8), %ymm8
	vpmaddubsw	-992(%rcx,%r8,4), %ymm5, %ymm9
	vpmaddubsw	-960(%rcx,%r8,4), %ymm5, %ymm10
	vpmaddubsw	-928(%rcx,%r8,4), %ymm5, %ymm11
	vpmaddubsw	-896(%rcx,%r8,4), %ymm5, %ymm5
	vpmaddubsw	-864(%rcx,%r8,4), %ymm6, %ymm12
	vpaddw	%ymm9, %ymm12, %ymm9
	vpmaddubsw	-832(%rcx,%r8,4), %ymm6, %ymm12
	vpaddw	%ymm10, %ymm12, %ymm10
	vpmaddubsw	-800(%rcx,%r8,4), %ymm6, %ymm12
	vpmaddubsw	-768(%rcx,%r8,4), %ymm6, %ymm6
	vpaddw	%ymm11, %ymm12, %ymm11
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmaddubsw	-736(%rcx,%r8,4), %ymm7, %ymm6
	vpmaddubsw	-704(%rcx,%r8,4), %ymm7, %ymm12
	vpmaddubsw	-672(%rcx,%r8,4), %ymm7, %ymm13
	vpmaddubsw	-640(%rcx,%r8,4), %ymm7, %ymm7
	vpmaddubsw	-608(%rcx,%r8,4), %ymm8, %ymm14
	vpaddw	%ymm6, %ymm14, %ymm6
	vpaddw	%ymm6, %ymm9, %ymm6
	vpmaddubsw	-576(%rcx,%r8,4), %ymm8, %ymm9
	vpaddw	%ymm9, %ymm12, %ymm9
	vpaddw	%ymm9, %ymm10, %ymm9
	vpmaddubsw	-544(%rcx,%r8,4), %ymm8, %ymm10
	vpaddw	%ymm10, %ymm13, %ymm10
	vpaddw	%ymm10, %ymm11, %ymm10
	vpmaddubsw	-512(%rcx,%r8,4), %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vmovdqa	-128(%rsi,%r8), %ymm8
	vpmaddubsw	-480(%rcx,%r8,4), %ymm8, %ymm11
	vpmaddubsw	-448(%rcx,%r8,4), %ymm8, %ymm12
	vpmaddubsw	-416(%rcx,%r8,4), %ymm8, %ymm13
	vpaddw	%ymm7, %ymm5, %ymm5
	vpmaddubsw	-384(%rcx,%r8,4), %ymm8, %ymm7
	vmovdqa	-96(%rsi,%r8), %ymm8
	vpmaddubsw	-352(%rcx,%r8,4), %ymm8, %ymm14
	vpmaddubsw	-320(%rcx,%r8,4), %ymm8, %ymm15
	vpaddw	%ymm14, %ymm11, %ymm11
	vpaddw	%ymm15, %ymm12, %ymm12
	vpmaddubsw	-288(%rcx,%r8,4), %ymm8, %ymm14
	vpaddw	%ymm14, %ymm13, %ymm13
	vpmaddubsw	-256(%rcx,%r8,4), %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vmovdqa	-64(%rsi,%r8), %ymm8
	vpmaddubsw	-224(%rcx,%r8,4), %ymm8, %ymm14
	vpaddw	%ymm14, %ymm11, %ymm11
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	-192(%rcx,%r8,4), %ymm8, %ymm11
	vpaddw	%ymm11, %ymm12, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vpmaddubsw	-160(%rcx,%r8,4), %ymm8, %ymm11
	vpaddw	%ymm11, %ymm13, %ymm11
	vpaddw	%ymm11, %ymm10, %ymm10
	vpmaddubsw	-128(%rcx,%r8,4), %ymm8, %ymm8
	vpaddw	%ymm7, %ymm8, %ymm7
	vpaddw	%ymm7, %ymm5, %ymm5
	vmovdqa	-32(%rsi,%r8), %ymm7
	vpmaddubsw	-96(%rcx,%r8,4), %ymm7, %ymm8
	vpaddw	%ymm6, %ymm8, %ymm6
	vpmaddubsw	-64(%rcx,%r8,4), %ymm7, %ymm8
	vpaddw	%ymm8, %ymm9, %ymm8
	vpmaddubsw	-32(%rcx,%r8,4), %ymm7, %ymm9
	vpmaddubsw	(%rcx,%r8,4), %ymm7, %ymm7
	vpaddw	%ymm9, %ymm10, %ymm9
	vpaddw	%ymm7, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vpaddd	%ymm1, %ymm6, %ymm1
	vpmaddwd	%ymm0, %ymm8, %ymm6
	vpaddd	%ymm4, %ymm6, %ymm4
	vpmaddwd	%ymm0, %ymm9, %ymm6
	vpaddd	%ymm3, %ymm6, %ymm3
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpaddd	%ymm2, %ymm5, %ymm2
	addq	$256, %r8                       # imm = 0x100
	cmpq	$1024, %r8                      # imm = 0x400
	jne	.LBB1_14
# %bb.15:                               #   in Loop: Header=BB1_13 Depth=1
	vphaddd	%ymm4, %ymm1, %ymm1
	vphaddd	%ymm2, %ymm3, %ymm2
	vphaddd	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpsubd	(%rcx), %xmm1, %xmm1
	vpaddd	%xmm2, %xmm1, %xmm1
	leal	(,%rdi,4), %r8d
	vcvtdq2ps	%xmm1, %xmm1
	vmulps	16(%rcx), %xmm1, %xmm1
	vmovups	%xmm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$3104, %rcx                     # imm = 0xC20
	cmpq	%rax, %rdi
	jne	.LBB1_13
	jmp	.LBB1_24
.LBB1_1:
	cmpl	$64, %eax
	je	.LBB1_16
# %bb.2:
	cmpl	$192, %eax
	jne	.LBB1_25
# %bb.3:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB1_24
# %bb.4:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI1_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB1_5:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_6 Depth 2
	vmovdqa	(%rsi), %ymm1
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	movl	$68, %r8d
	.p2align	4, 0x90
.LBB1_6:                                #   Parent Loop BB1_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqa	-36(%rsi,%r8), %ymm9
	vpmaddubsw	-224(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	-192(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	-160(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	-128(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	-96(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	-64(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	-32(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$228, %r8
	jne	.LBB1_6
# %bb.7:                                #   in Loop: Header=BB1_5 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	leal	(,%rdi,8), %r8d
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1600, %rcx                     # imm = 0x640
	cmpq	%rax, %rdi
	jne	.LBB1_5
	jmp	.LBB1_24
.LBB1_19:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB1_24
# %bb.20:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI1_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB1_21:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_22 Depth 2
	vmovdqa	(%rsi), %ymm1
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	movl	$68, %r8d
	.p2align	4, 0x90
.LBB1_22:                               #   Parent Loop BB1_21 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqa	-36(%rsi,%r8), %ymm9
	vpmaddubsw	-224(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	-192(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	-160(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	-128(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	-96(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	-64(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	-32(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$260, %r8                       # imm = 0x104
	jne	.LBB1_22
# %bb.23:                               #   in Loop: Header=BB1_21 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	leal	(,%rdi,8), %r8d
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1856, %rcx                     # imm = 0x740
	cmpq	%rax, %rdi
	jne	.LBB1_21
	jmp	.LBB1_24
.LBB1_16:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB1_24
# %bb.17:
	shlq	$3, %rax
	movl	$544, %ecx                      # imm = 0x220
	addq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI1_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB1_18:                               # =>This Inner Loop Header: Depth=1
	vmovdqa	(%rsi), %ymm1
	vpmaddubsw	-480(%rcx), %ymm1, %ymm2
	vpmaddubsw	-448(%rcx), %ymm1, %ymm3
	vpmaddubsw	-416(%rcx), %ymm1, %ymm4
	vpmaddubsw	-384(%rcx), %ymm1, %ymm5
	vpmaddubsw	-352(%rcx), %ymm1, %ymm6
	vpmaddubsw	-320(%rcx), %ymm1, %ymm7
	vpmaddubsw	-288(%rcx), %ymm1, %ymm8
	vpmaddubsw	-256(%rcx), %ymm1, %ymm1
	vmovdqa	32(%rsi), %ymm9
	vpmaddubsw	-224(%rcx), %ymm9, %ymm10
	vpaddw	%ymm2, %ymm10, %ymm2
	vpmaddubsw	-192(%rcx), %ymm9, %ymm10
	vpmaddubsw	-160(%rcx), %ymm9, %ymm11
	vpaddw	%ymm3, %ymm10, %ymm3
	vpaddw	%ymm4, %ymm11, %ymm4
	vpmaddubsw	-128(%rcx), %ymm9, %ymm10
	vpaddw	%ymm5, %ymm10, %ymm5
	vpmaddubsw	-96(%rcx), %ymm9, %ymm10
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm2, %ymm2
	vpmaddubsw	-64(%rcx), %ymm9, %ymm3
	vpmaddubsw	-32(%rcx), %ymm9, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpmaddubsw	(%rcx), %ymm9, %ymm9
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm4, %ymm4
	vpaddw	%ymm7, %ymm3, %ymm3
	vphaddd	%ymm4, %ymm2, %ymm2
	vpaddw	%ymm8, %ymm11, %ymm4
	vpaddw	%ymm1, %ymm9, %ymm1
	vpmaddwd	%ymm0, %ymm6, %ymm5
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm4, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm3
	vperm2i128	$49, %ymm1, %ymm2, %ymm1 # ymm1 = ymm2[2,3],ymm1[2,3]
	vpsubd	-544(%rcx), %ymm3, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	movl	%edi, %r8d
	andl	$-8, %r8d
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	-512(%rcx), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	addq	$8, %rdi
	addq	$576, %rcx                      # imm = 0x240
	cmpq	%rdi, %rax
	jne	.LBB1_18
.LBB1_24:
	popq	%rax
	vzeroupper
	retq
.LBB1_25:
	movl	$.L.str.13, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end1:
	.size	_ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf, .Lfunc_end1-_ZN3fx23opt14qgemv_f32_nopfERKNS0_6QDenseEPKhPf
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf
.LCPI2_0:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI2_1:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf,@function
_ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf: # @_ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf
# %bb.0:
	pushq	%rax
	movl	12(%rdi), %eax
	cmpl	$204, %eax
	jle	.LBB2_1
# %bb.8:
	cmpl	$205, %eax
	je	.LBB2_19
# %bb.9:
	cmpl	$224, %eax
	je	.LBB2_19
# %bb.10:
	cmpl	$768, %eax                      # imm = 0x300
	jne	.LBB2_25
# %bb.11:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB2_24
# %bb.12:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI2_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB2_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_14 Depth 2
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%r8d, %r8d
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB2_14:                               #   Parent Loop BB2_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqa	(%rsi,%r8), %ymm5
	vpmaddubsw	32(%rcx,%r8,4), %ymm5, %ymm6
	vpmaddubsw	64(%rcx,%r8,4), %ymm5, %ymm7
	vpmaddubsw	96(%rcx,%r8,4), %ymm5, %ymm8
	vpmaddubsw	128(%rcx,%r8,4), %ymm5, %ymm5
	prefetcht0	2208(%rcx,%r8,4)
	prefetcht0	2272(%rcx,%r8,4)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	160(%rcx,%r8,4), %ymm9, %ymm10
	vpmaddubsw	192(%rcx,%r8,4), %ymm9, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm7, %ymm11, %ymm7
	vpmaddubsw	224(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	256(%rcx,%r8,4), %ymm9, %ymm9
	prefetcht0	2336(%rcx,%r8,4)
	prefetcht0	2400(%rcx,%r8,4)
	vmovdqa	64(%rsi,%r8), %ymm10
	vpmaddubsw	288(%rcx,%r8,4), %ymm10, %ymm11
	vpmaddubsw	320(%rcx,%r8,4), %ymm10, %ymm12
	vpmaddubsw	352(%rcx,%r8,4), %ymm10, %ymm13
	vpaddw	%ymm5, %ymm9, %ymm9
	vpmaddubsw	384(%rcx,%r8,4), %ymm10, %ymm10
	prefetcht0	2464(%rcx,%r8,4)
	prefetcht0	2528(%rcx,%r8,4)
	vmovdqa	96(%rsi,%r8), %ymm14
	vpmaddubsw	416(%rcx,%r8,4), %ymm14, %ymm5
	vpaddw	%ymm5, %ymm11, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmaddubsw	448(%rcx,%r8,4), %ymm14, %ymm6
	vpaddw	%ymm6, %ymm12, %ymm6
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmaddubsw	480(%rcx,%r8,4), %ymm14, %ymm7
	vpaddw	%ymm7, %ymm13, %ymm7
	vpaddw	%ymm7, %ymm8, %ymm7
	vpmaddubsw	512(%rcx,%r8,4), %ymm14, %ymm8
	vpaddw	%ymm8, %ymm10, %ymm8
	prefetcht0	2592(%rcx,%r8,4)
	prefetcht0	2656(%rcx,%r8,4)
	vmovdqa	128(%rsi,%r8), %ymm10
	vpmaddubsw	544(%rcx,%r8,4), %ymm10, %ymm11
	vpmaddubsw	576(%rcx,%r8,4), %ymm10, %ymm12
	vpmaddubsw	608(%rcx,%r8,4), %ymm10, %ymm13
	vpmaddubsw	640(%rcx,%r8,4), %ymm10, %ymm10
	vpaddw	%ymm8, %ymm9, %ymm8
	prefetcht0	2720(%rcx,%r8,4)
	prefetcht0	2784(%rcx,%r8,4)
	vmovdqa	160(%rsi,%r8), %ymm9
	vpmaddubsw	672(%rcx,%r8,4), %ymm9, %ymm14
	vpmaddubsw	704(%rcx,%r8,4), %ymm9, %ymm15
	vpaddw	%ymm14, %ymm11, %ymm11
	vpaddw	%ymm15, %ymm12, %ymm12
	vpmaddubsw	736(%rcx,%r8,4), %ymm9, %ymm14
	vpaddw	%ymm14, %ymm13, %ymm13
	vpmaddubsw	768(%rcx,%r8,4), %ymm9, %ymm9
	prefetcht0	2848(%rcx,%r8,4)
	prefetcht0	2912(%rcx,%r8,4)
	vmovdqa	192(%rsi,%r8), %ymm14
	vpmaddubsw	800(%rcx,%r8,4), %ymm14, %ymm15
	vpaddw	%ymm9, %ymm10, %ymm9
	vpaddw	%ymm15, %ymm11, %ymm10
	vpmaddubsw	832(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm10
	vpmaddubsw	864(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm11, %ymm13, %ymm10
	vpmaddubsw	896(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm11, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm8, %ymm8
	prefetcht0	2976(%rcx,%r8,4)
	prefetcht0	3040(%rcx,%r8,4)
	vmovdqa	224(%rsi,%r8), %ymm9
	vpmaddubsw	928(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm5, %ymm10, %ymm5
	vpmaddubsw	960(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm6, %ymm10, %ymm6
	vpmaddubsw	992(%rcx,%r8,4), %ymm9, %ymm10
	vpmaddubsw	1024(%rcx,%r8,4), %ymm9, %ymm9
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm9, %ymm8, %ymm8
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpaddd	%ymm1, %ymm5, %ymm1
	vpmaddwd	%ymm0, %ymm6, %ymm5
	vpaddd	%ymm4, %ymm5, %ymm4
	vpmaddwd	%ymm0, %ymm7, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm0, %ymm8, %ymm5
	vpaddd	%ymm2, %ymm5, %ymm2
	addq	$256, %r8                       # imm = 0x100
	cmpq	$768, %r8                       # imm = 0x300
	jne	.LBB2_14
# %bb.15:                               #   in Loop: Header=BB2_13 Depth=1
	vphaddd	%ymm4, %ymm1, %ymm1
	vphaddd	%ymm2, %ymm3, %ymm2
	vphaddd	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpsubd	(%rcx), %xmm1, %xmm1
	vpaddd	%xmm2, %xmm1, %xmm1
	vcvtdq2ps	%xmm1, %xmm1
	vmulps	16(%rcx), %xmm1, %xmm1
	leal	(,%rdi,4), %r8d
	vaddps	(%rdx,%r8,4), %xmm1, %xmm1
	vmovups	%xmm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$3104, %rcx                     # imm = 0xC20
	cmpq	%rax, %rdi
	jne	.LBB2_13
	jmp	.LBB2_24
.LBB2_1:
	cmpl	$64, %eax
	je	.LBB2_16
# %bb.2:
	cmpl	$192, %eax
	jne	.LBB2_25
# %bb.3:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB2_24
# %bb.4:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI2_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB2_5:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_6 Depth 2
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB2_6:                                #   Parent Loop BB2_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r8,8)
	prefetcht0	2368(%rcx,%r8,8)
	prefetcht0	2432(%rcx,%r8,8)
	prefetcht0	2496(%rcx,%r8,8)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	320(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	352(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	384(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	416(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	448(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	480(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	512(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	544(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$160, %r8
	jne	.LBB2_6
# %bb.7:                                #   in Loop: Header=BB2_5 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	leal	(,%rdi,8), %r8d
	vaddps	(%rdx,%r8,4), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1600, %rcx                     # imm = 0x640
	cmpq	%rax, %rdi
	jne	.LBB2_5
	jmp	.LBB2_24
.LBB2_19:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB2_24
# %bb.20:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI2_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB2_21:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_22 Depth 2
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB2_22:                               #   Parent Loop BB2_21 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r8,8)
	prefetcht0	2368(%rcx,%r8,8)
	prefetcht0	2432(%rcx,%r8,8)
	prefetcht0	2496(%rcx,%r8,8)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	320(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	352(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	384(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	416(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	448(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	480(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	512(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	544(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$192, %r8
	jne	.LBB2_22
# %bb.23:                               #   in Loop: Header=BB2_21 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	leal	(,%rdi,8), %r8d
	vaddps	(%rdx,%r8,4), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1856, %rcx                     # imm = 0x740
	cmpq	%rax, %rdi
	jne	.LBB2_21
	jmp	.LBB2_24
.LBB2_16:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB2_24
# %bb.17:
	movq	(%rdi), %rcx
	shlq	$3, %rax
	xorl	%edi, %edi
	vpbroadcastw	.LCPI2_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB2_18:                               # =>This Inner Loop Header: Depth=1
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm2
	vpmaddubsw	128(%rcx), %ymm1, %ymm3
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	256(%rcx), %ymm1, %ymm5
	vpmaddubsw	96(%rcx), %ymm1, %ymm6
	vpmaddubsw	160(%rcx), %ymm1, %ymm7
	vpmaddubsw	224(%rcx), %ymm1, %ymm8
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	vmovdqa	32(%rsi), %ymm9
	prefetcht0	2304(%rcx)
	vpmaddubsw	320(%rcx), %ymm9, %ymm10
	vpaddw	%ymm2, %ymm10, %ymm2
	vpmaddubsw	352(%rcx), %ymm9, %ymm10
	vpaddw	%ymm6, %ymm10, %ymm6
	vpmaddubsw	384(%rcx), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	416(%rcx), %ymm9, %ymm10
	vpmaddubsw	448(%rcx), %ymm9, %ymm11
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm4, %ymm11, %ymm4
	vpmaddubsw	480(%rcx), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	512(%rcx), %ymm9, %ymm10
	vpaddw	%ymm5, %ymm10, %ymm5
	vpmaddubsw	544(%rcx), %ymm9, %ymm9
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vpmaddwd	%ymm0, %ymm7, %ymm6
	vphaddd	%ymm6, %ymm3, %ymm3
	vpaddw	%ymm1, %ymm9, %ymm1
	vphaddd	%ymm3, %ymm2, %ymm2
	prefetcht0	2368(%rcx)
	prefetcht0	2432(%rcx)
	vpmaddwd	%ymm0, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm8, %ymm4
	vphaddd	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm0, %ymm5, %ymm4
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm4, %ymm1
	prefetcht0	2496(%rcx)
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm2, %ymm3
	vperm2i128	$49, %ymm1, %ymm2, %ymm1 # ymm1 = ymm2[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm3, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rcx), %ymm1, %ymm1
	movl	%edi, %r8d
	andl	$-8, %r8d
	vaddps	(%rdx,%r8,4), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx,%r8,4)
	addq	$576, %rcx                      # imm = 0x240
	addq	$8, %rdi
	cmpq	%rdi, %rax
	jne	.LBB2_18
.LBB2_24:
	popq	%rax
	vzeroupper
	retq
.LBB2_25:
	movl	$.L.str.13, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end2:
	.size	_ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf, .Lfunc_end2-_ZN3fx23opt9qgemv_addERKNS0_6QDenseEPKhPf
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt
.LCPI3_0:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI3_1:
	.long	0x42fe0000                      # float 127
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI3_2:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt,"ax",@progbits
	.globl	_ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt
	.p2align	4, 0x90
	.type	_ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt,@function
_ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt: # @_ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	andq	$-64, %rsp
	subq	$3136, %rsp                     # imm = 0xC40
	cmpl	$192, 12(%rdi)
	jne	.LBB3_29
# %bb.1:
	cmpl	$769, 32(%rdi)                  # imm = 0x301
	jge	.LBB3_30
# %bb.2:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB3_7
# %bb.3:
	movq	(%rdi), %r8
	vmovdqa	(%rsi), %ymm1
	xorl	%r9d, %r9d
	vpbroadcastw	.LCPI3_2(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB3_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_5 Depth 2
	prefetcht0	2048(%r8)
	vpmaddubsw	64(%r8), %ymm1, %ymm9
	vpmaddubsw	96(%r8), %ymm1, %ymm10
	vpmaddubsw	128(%r8), %ymm1, %ymm7
	vpmaddubsw	160(%r8), %ymm1, %ymm8
	vpmaddubsw	192(%r8), %ymm1, %ymm6
	vpmaddubsw	224(%r8), %ymm1, %ymm5
	vpmaddubsw	256(%r8), %ymm1, %ymm4
	vpmaddubsw	288(%r8), %ymm1, %ymm3
	prefetcht0	2112(%r8)
	prefetcht0	2176(%r8)
	prefetcht0	2240(%r8)
	xorl	%r10d, %r10d
	.p2align	4, 0x90
.LBB3_5:                                #   Parent Loop BB3_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%r8,%r10,8)
	prefetcht0	2368(%r8,%r10,8)
	prefetcht0	2432(%r8,%r10,8)
	prefetcht0	2496(%r8,%r10,8)
	vmovdqa	32(%rsi,%r10), %ymm11
	vpmaddubsw	320(%r8,%r10,8), %ymm11, %ymm12
	vpaddw	%ymm9, %ymm12, %ymm9
	vpmaddubsw	352(%r8,%r10,8), %ymm11, %ymm12
	vpaddw	%ymm10, %ymm12, %ymm10
	vpmaddubsw	384(%r8,%r10,8), %ymm11, %ymm12
	vpmaddubsw	416(%r8,%r10,8), %ymm11, %ymm13
	vpaddw	%ymm7, %ymm12, %ymm7
	vpaddw	%ymm8, %ymm13, %ymm8
	vpmaddubsw	448(%r8,%r10,8), %ymm11, %ymm12
	vpaddw	%ymm6, %ymm12, %ymm6
	vpmaddubsw	480(%r8,%r10,8), %ymm11, %ymm12
	vpaddw	%ymm5, %ymm12, %ymm5
	vpmaddubsw	512(%r8,%r10,8), %ymm11, %ymm12
	vpmaddubsw	544(%r8,%r10,8), %ymm11, %ymm11
	vpaddw	%ymm4, %ymm12, %ymm4
	vpaddw	%ymm3, %ymm11, %ymm3
	addq	$32, %r10
	cmpq	$160, %r10
	jne	.LBB3_5
# %bb.6:                                #   in Loop: Header=BB3_4 Depth=1
	vpmaddwd	%ymm2, %ymm9, %ymm9
	vpmaddwd	%ymm2, %ymm10, %ymm10
	vphaddd	%ymm10, %ymm9, %ymm9
	vpmaddwd	%ymm2, %ymm7, %ymm7
	vpmaddwd	%ymm2, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vphaddd	%ymm7, %ymm9, %ymm7
	vpmaddwd	%ymm2, %ymm6, %ymm6
	vpmaddwd	%ymm2, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm6, %ymm5
	vpmaddwd	%ymm2, %ymm4, %ymm4
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	vinserti128	$1, %xmm3, %ymm7, %ymm4
	vperm2i128	$49, %ymm3, %ymm7, %ymm3 # ymm3 = ymm7[2,3],ymm3[2,3]
	vpsubd	(%r8), %ymm4, %ymm4
	vpaddd	%ymm3, %ymm4, %ymm3
	leal	(,%r9,8), %r10d
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	32(%r8), %ymm3, %ymm3
	vmovaps	%ymm3, (%rsp,%r10,4)
	incq	%r9
	addq	$1600, %r8                      # imm = 0x640
	cmpq	%rax, %r9
	jne	.LBB3_4
.LBB3_7:
	vbroadcastss	%xmm0, %ymm0
	movl	%eax, %esi
	andl	$-2, %esi
	testl	%esi, %esi
	jle	.LBB3_11
# %bb.8:
	leaq	32(%rsp), %rax
	xorl	%r8d, %r8d
	vpxor	%xmm1, %xmm1, %xmm1
	vbroadcastss	.LCPI3_1(%rip), %ymm2   # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	.p2align	4, 0x90
.LBB3_9:                                # =>This Inner Loop Header: Depth=1
	vmovaps	-32(%rax), %ymm3
	vmovaps	(%rax), %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vmulps	%ymm3, %ymm3, %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmulps	%ymm4, %ymm4, %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpackuswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, (%rdx,%r8,8)
	addq	$2, %r8
	addq	$64, %rax
	cmpq	%rsi, %r8
	jb	.LBB3_9
# %bb.10:
	movl	28(%rdi), %eax
.LBB3_11:
	testb	$1, %al
	je	.LBB3_13
# %bb.12:
	leal	-8(,%rax,8), %eax
	cltq
	vmovaps	(%rsp,%rax,4), %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	vmaxps	%ymm2, %ymm1, %ymm1
	vmulps	%ymm1, %ymm1, %ymm1
	vdivps	%ymm0, %ymm1, %ymm0
	vbroadcastss	.LCPI3_1(%rip), %ymm1   # ymm1 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vminps	%ymm1, %ymm0, %ymm0
	vcvtps2dq	%ymm0, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vpackuswb	%xmm0, %xmm0, %xmm0
	vmovq	%xmm0, (%rdx,%rax)
.LBB3_13:
	movl	32(%rdi), %r10d
	xorl	%eax, %eax
	cmpl	$32, %r10d
	jl	.LBB3_17
# %bb.14:
	andl	$-32, %r10d
	xorl	%r8d, %r8d
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB3_15:                               # =>This Inner Loop Header: Depth=1
	vpcmpeqb	(%rdx,%r8), %ymm0, %ymm1
	vpmovmskb	%ymm1, %ebx
	notl	%ebx
	movzbl	%bl, %r9d
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_18g_idxlutE(,%r9,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vmovd	%r8d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rcx,%rax,2)
	popcntl	%r9d, %r9d
	addl	%r9d, %eax
	movzbl	%bh, %esi
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_18g_idxlutE(,%rsi,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	8(%r8), %r9d
	vmovd	%r9d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rcx,%rax,2)
	popcntl	%esi, %esi
	addl	%esi, %eax
	movl	%ebx, %esi
	shrl	$16, %esi
	movzbl	%sil, %esi
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_18g_idxlutE(,%rsi,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	16(%r8), %r9d
	vmovd	%r9d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rcx,%rax,2)
	popcntl	%esi, %esi
	addl	%esi, %eax
	shrl	$24, %ebx
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_18g_idxlutE(,%rbx,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	24(%r8), %esi
	vmovd	%esi, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rcx,%rax,2)
	popcntl	%ebx, %esi
	addl	%esi, %eax
	addq	$32, %r8
	cmpq	%r8, %r10
	jne	.LBB3_15
# %bb.16:
	movl	32(%rdi), %r10d
.LBB3_17:
	movslq	%r10d, %rsi
	movq	%rsi, %rdi
	andq	$-32, %rdi
	cmpl	%esi, %edi
	jge	.LBB3_28
# %bb.18:
	movq	%rdi, %r8
	notq	%r8
	testb	$1, %sil
	je	.LBB3_22
# %bb.19:
	cmpb	$0, (%rdx,%rdi)
	je	.LBB3_21
# %bb.20:
	movslq	%eax, %r9
	incl	%eax
	movw	%di, (%rcx,%r9,2)
.LBB3_21:
	orq	$1, %rdi
.LBB3_22:
	addq	%rsi, %r8
	jne	.LBB3_23
.LBB3_28:
                                        # kill: def $eax killed $eax killed $rax
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	vzeroupper
	retq
	.p2align	4, 0x90
.LBB3_27:                               #   in Loop: Header=BB3_23 Depth=1
	addq	$2, %rdi
	cmpq	%rdi, %rsi
	je	.LBB3_28
.LBB3_23:                               # =>This Inner Loop Header: Depth=1
	cmpb	$0, (%rdx,%rdi)
	je	.LBB3_25
# %bb.24:                               #   in Loop: Header=BB3_23 Depth=1
	movslq	%eax, %r8
	incl	%eax
	movw	%di, (%rcx,%r8,2)
.LBB3_25:                               #   in Loop: Header=BB3_23 Depth=1
	cmpb	$0, 1(%rdx,%rdi)
	je	.LBB3_27
# %bb.26:                               #   in Loop: Header=BB3_23 Depth=1
	movslq	%eax, %r8
	incl	%eax
	leal	1(%rdi), %r9d
	movw	%r9w, (%rcx,%r8,2)
	jmp	.LBB3_27
.LBB3_29:
	movl	$.L.str, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB3_30:
	movl	$.L.str.3, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end3:
	.size	_ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt, .Lfunc_end3-_ZN3fx23opt12qgemv_relu2qERKNS0_6QDenseEPKhfPhPt
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_13dieEPKc,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_13dieEPKc
	.type	_ZN3fx23opt12_GLOBAL__N_13dieEPKc,@function
_ZN3fx23opt12_GLOBAL__N_13dieEPKc:      # @_ZN3fx23opt12_GLOBAL__N_13dieEPKc
# %bb.0:
	pushq	%rax
	movq	%rdi, %rdx
	movq	stderr(%rip), %rdi
	movl	$.L.str.12, %esi
	xorl	%eax, %eax
	callq	fprintf
	movl	$1, %edi
	callq	exit
.Lfunc_end4:
	.size	_ZN3fx23opt12_GLOBAL__N_13dieEPKc, .Lfunc_end4-_ZN3fx23opt12_GLOBAL__N_13dieEPKc
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh
.LCPI5_0:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI5_1:
	.long	0xc3000000                      # float -128
.LCPI5_2:
	.long	0x42fe0000                      # float 127
.LCPI5_3:
	.long	128                             # 0x80
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI5_4:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh,"ax",@progbits
	.globl	_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh,@function
_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh: # @_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	andq	$-64, %rsp
	subq	$3136, %rsp                     # imm = 0xC40
	cmpl	$192, 12(%rdi)
	jne	.LBB5_11
# %bb.1:
	cmpl	$769, 32(%rdi)                  # imm = 0x301
	jge	.LBB5_12
# %bb.2:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB5_10
# %bb.3:
	movq	(%rdi), %rcx
	vmovdqa	(%rsi), %ymm1
	xorl	%r8d, %r8d
	vpbroadcastw	.LCPI5_4(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB5_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB5_5 Depth 2
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm9
	vpmaddubsw	96(%rcx), %ymm1, %ymm10
	vpmaddubsw	128(%rcx), %ymm1, %ymm7
	vpmaddubsw	160(%rcx), %ymm1, %ymm8
	vpmaddubsw	192(%rcx), %ymm1, %ymm6
	vpmaddubsw	224(%rcx), %ymm1, %ymm5
	vpmaddubsw	256(%rcx), %ymm1, %ymm4
	vpmaddubsw	288(%rcx), %ymm1, %ymm3
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB5_5:                                #   Parent Loop BB5_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r9,8)
	prefetcht0	2368(%rcx,%r9,8)
	prefetcht0	2432(%rcx,%r9,8)
	prefetcht0	2496(%rcx,%r9,8)
	vmovdqa	32(%rsi,%r9), %ymm11
	vpmaddubsw	320(%rcx,%r9,8), %ymm11, %ymm12
	vpaddw	%ymm9, %ymm12, %ymm9
	vpmaddubsw	352(%rcx,%r9,8), %ymm11, %ymm12
	vpaddw	%ymm10, %ymm12, %ymm10
	vpmaddubsw	384(%rcx,%r9,8), %ymm11, %ymm12
	vpmaddubsw	416(%rcx,%r9,8), %ymm11, %ymm13
	vpaddw	%ymm7, %ymm12, %ymm7
	vpaddw	%ymm8, %ymm13, %ymm8
	vpmaddubsw	448(%rcx,%r9,8), %ymm11, %ymm12
	vpaddw	%ymm6, %ymm12, %ymm6
	vpmaddubsw	480(%rcx,%r9,8), %ymm11, %ymm12
	vpaddw	%ymm5, %ymm12, %ymm5
	vpmaddubsw	512(%rcx,%r9,8), %ymm11, %ymm12
	vpmaddubsw	544(%rcx,%r9,8), %ymm11, %ymm11
	vpaddw	%ymm4, %ymm12, %ymm4
	vpaddw	%ymm3, %ymm11, %ymm3
	addq	$32, %r9
	cmpq	$160, %r9
	jne	.LBB5_5
# %bb.6:                                #   in Loop: Header=BB5_4 Depth=1
	vpmaddwd	%ymm2, %ymm9, %ymm9
	vpmaddwd	%ymm2, %ymm10, %ymm10
	vphaddd	%ymm10, %ymm9, %ymm9
	vpmaddwd	%ymm2, %ymm7, %ymm7
	vpmaddwd	%ymm2, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vphaddd	%ymm7, %ymm9, %ymm7
	vpmaddwd	%ymm2, %ymm6, %ymm6
	vpmaddwd	%ymm2, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm6, %ymm5
	vpmaddwd	%ymm2, %ymm4, %ymm4
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	vinserti128	$1, %xmm3, %ymm7, %ymm4
	vperm2i128	$49, %ymm3, %ymm7, %ymm3 # ymm3 = ymm7[2,3],ymm3[2,3]
	vpsubd	(%rcx), %ymm4, %ymm4
	vpaddd	%ymm3, %ymm4, %ymm3
	leal	(,%r8,8), %r9d
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	32(%rcx), %ymm3, %ymm3
	vmovaps	%ymm3, (%rsp,%r9,4)
	incq	%r8
	addq	$1600, %rcx                     # imm = 0x640
	cmpq	%rax, %r8
	jne	.LBB5_4
# %bb.7:
	testl	%eax, %eax
	jle	.LBB5_10
# %bb.8:
	vbroadcastss	%xmm0, %ymm0
	movq	%rsp, %rax
	xorl	%ecx, %ecx
	vbroadcastss	.LCPI5_1(%rip), %ymm1   # ymm1 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI5_2(%rip), %ymm2   # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastd	.LCPI5_3(%rip), %ymm3   # ymm3 = [128,128,128,128,128,128,128,128]
	.p2align	4, 0x90
.LBB5_9:                                # =>This Inner Loop Header: Depth=1
	vmovaps	(%rax), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm4, %ymm4
	vpaddd	%ymm3, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpackssdw	%xmm5, %xmm4, %xmm4
	vpackuswb	%xmm4, %xmm4, %xmm4
	vmovq	%xmm4, (%rdx,%rcx,8)
	incq	%rcx
	movslq	28(%rdi), %rsi
	addq	$32, %rax
	cmpq	%rsi, %rcx
	jl	.LBB5_9
.LBB5_10:
	movq	%rbp, %rsp
	popq	%rbp
	vzeroupper
	retq
.LBB5_11:
	movl	$.L.str.4, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB5_12:
	movl	$.L.str.5, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end5:
	.size	_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh, .Lfunc_end5-_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi
.LCPI6_0:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI6_1:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi,"ax",@progbits
	.globl	_ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi,@function
_ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi: # @_ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi
# %bb.0:
	pushq	%rax
	movl	12(%rdi), %eax
	cmpl	$204, %eax
	jle	.LBB6_1
# %bb.8:
	cmpl	$205, %eax
	je	.LBB6_19
# %bb.9:
	cmpl	$224, %eax
	je	.LBB6_19
# %bb.10:
	cmpl	$768, %eax                      # imm = 0x300
	jne	.LBB6_25
# %bb.11:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB6_24
# %bb.12:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI6_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB6_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_14 Depth 2
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%r8d, %r8d
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	.p2align	4, 0x90
.LBB6_14:                               #   Parent Loop BB6_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqa	(%rsi,%r8), %ymm5
	vpmaddubsw	32(%rcx,%r8,4), %ymm5, %ymm6
	vpmaddubsw	64(%rcx,%r8,4), %ymm5, %ymm7
	vpmaddubsw	96(%rcx,%r8,4), %ymm5, %ymm8
	vpmaddubsw	128(%rcx,%r8,4), %ymm5, %ymm5
	prefetcht0	2208(%rcx,%r8,4)
	prefetcht0	2272(%rcx,%r8,4)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	160(%rcx,%r8,4), %ymm9, %ymm10
	vpmaddubsw	192(%rcx,%r8,4), %ymm9, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm7, %ymm11, %ymm7
	vpmaddubsw	224(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	256(%rcx,%r8,4), %ymm9, %ymm9
	prefetcht0	2336(%rcx,%r8,4)
	prefetcht0	2400(%rcx,%r8,4)
	vmovdqa	64(%rsi,%r8), %ymm10
	vpmaddubsw	288(%rcx,%r8,4), %ymm10, %ymm11
	vpmaddubsw	320(%rcx,%r8,4), %ymm10, %ymm12
	vpmaddubsw	352(%rcx,%r8,4), %ymm10, %ymm13
	vpaddw	%ymm5, %ymm9, %ymm9
	vpmaddubsw	384(%rcx,%r8,4), %ymm10, %ymm10
	prefetcht0	2464(%rcx,%r8,4)
	prefetcht0	2528(%rcx,%r8,4)
	vmovdqa	96(%rsi,%r8), %ymm14
	vpmaddubsw	416(%rcx,%r8,4), %ymm14, %ymm5
	vpaddw	%ymm5, %ymm11, %ymm5
	vpaddw	%ymm5, %ymm6, %ymm5
	vpmaddubsw	448(%rcx,%r8,4), %ymm14, %ymm6
	vpaddw	%ymm6, %ymm12, %ymm6
	vpaddw	%ymm6, %ymm7, %ymm6
	vpmaddubsw	480(%rcx,%r8,4), %ymm14, %ymm7
	vpaddw	%ymm7, %ymm13, %ymm7
	vpaddw	%ymm7, %ymm8, %ymm7
	vpmaddubsw	512(%rcx,%r8,4), %ymm14, %ymm8
	vpaddw	%ymm8, %ymm10, %ymm8
	prefetcht0	2592(%rcx,%r8,4)
	prefetcht0	2656(%rcx,%r8,4)
	vmovdqa	128(%rsi,%r8), %ymm10
	vpmaddubsw	544(%rcx,%r8,4), %ymm10, %ymm11
	vpmaddubsw	576(%rcx,%r8,4), %ymm10, %ymm12
	vpmaddubsw	608(%rcx,%r8,4), %ymm10, %ymm13
	vpmaddubsw	640(%rcx,%r8,4), %ymm10, %ymm10
	vpaddw	%ymm8, %ymm9, %ymm8
	prefetcht0	2720(%rcx,%r8,4)
	prefetcht0	2784(%rcx,%r8,4)
	vmovdqa	160(%rsi,%r8), %ymm9
	vpmaddubsw	672(%rcx,%r8,4), %ymm9, %ymm14
	vpmaddubsw	704(%rcx,%r8,4), %ymm9, %ymm15
	vpaddw	%ymm14, %ymm11, %ymm11
	vpaddw	%ymm15, %ymm12, %ymm12
	vpmaddubsw	736(%rcx,%r8,4), %ymm9, %ymm14
	vpaddw	%ymm14, %ymm13, %ymm13
	vpmaddubsw	768(%rcx,%r8,4), %ymm9, %ymm9
	prefetcht0	2848(%rcx,%r8,4)
	prefetcht0	2912(%rcx,%r8,4)
	vmovdqa	192(%rsi,%r8), %ymm14
	vpmaddubsw	800(%rcx,%r8,4), %ymm14, %ymm15
	vpaddw	%ymm9, %ymm10, %ymm9
	vpaddw	%ymm15, %ymm11, %ymm10
	vpmaddubsw	832(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm11, %ymm12, %ymm10
	vpmaddubsw	864(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm11, %ymm13, %ymm10
	vpmaddubsw	896(%rcx,%r8,4), %ymm14, %ymm11
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm11, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm8, %ymm8
	prefetcht0	2976(%rcx,%r8,4)
	prefetcht0	3040(%rcx,%r8,4)
	vmovdqa	224(%rsi,%r8), %ymm9
	vpmaddubsw	928(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm5, %ymm10, %ymm5
	vpmaddubsw	960(%rcx,%r8,4), %ymm9, %ymm10
	vpaddw	%ymm6, %ymm10, %ymm6
	vpmaddubsw	992(%rcx,%r8,4), %ymm9, %ymm10
	vpmaddubsw	1024(%rcx,%r8,4), %ymm9, %ymm9
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm9, %ymm8, %ymm8
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpaddd	%ymm1, %ymm5, %ymm1
	vpmaddwd	%ymm0, %ymm6, %ymm5
	vpaddd	%ymm4, %ymm5, %ymm4
	vpmaddwd	%ymm0, %ymm7, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm0, %ymm8, %ymm5
	vpaddd	%ymm2, %ymm5, %ymm2
	addq	$256, %r8                       # imm = 0x100
	cmpq	$768, %r8                       # imm = 0x300
	jne	.LBB6_14
# %bb.15:                               #   in Loop: Header=BB6_13 Depth=1
	vphaddd	%ymm4, %ymm1, %ymm1
	vphaddd	%ymm2, %ymm3, %ymm2
	vphaddd	%ymm2, %ymm1, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpsubd	(%rcx), %xmm1, %xmm1
	vpaddd	%xmm2, %xmm1, %xmm1
	leal	(,%rdi,4), %r8d
	vmovdqu	%xmm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$3104, %rcx                     # imm = 0xC20
	cmpq	%rax, %rdi
	jne	.LBB6_13
	jmp	.LBB6_24
.LBB6_1:
	cmpl	$64, %eax
	je	.LBB6_16
# %bb.2:
	cmpl	$192, %eax
	jne	.LBB6_25
# %bb.3:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB6_24
# %bb.4:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI6_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB6_5:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_6 Depth 2
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB6_6:                                #   Parent Loop BB6_5 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r8,8)
	prefetcht0	2368(%rcx,%r8,8)
	prefetcht0	2432(%rcx,%r8,8)
	prefetcht0	2496(%rcx,%r8,8)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	320(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	352(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	384(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	416(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	448(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	480(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	512(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	544(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$160, %r8
	jne	.LBB6_6
# %bb.7:                                #   in Loop: Header=BB6_5 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	leal	(,%rdi,8), %r8d
	vmovdqu	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1600, %rcx                     # imm = 0x640
	cmpq	%rax, %rdi
	jne	.LBB6_5
	jmp	.LBB6_24
.LBB6_19:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB6_24
# %bb.20:
	movq	(%rdi), %rcx
	xorl	%edi, %edi
	vpbroadcastw	.LCPI6_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB6_21:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_22 Depth 2
	vmovdqa	(%rsi), %ymm1
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm1, %ymm7
	vpmaddubsw	96(%rcx), %ymm1, %ymm8
	vpmaddubsw	128(%rcx), %ymm1, %ymm5
	vpmaddubsw	160(%rcx), %ymm1, %ymm6
	vpmaddubsw	192(%rcx), %ymm1, %ymm4
	vpmaddubsw	224(%rcx), %ymm1, %ymm3
	vpmaddubsw	256(%rcx), %ymm1, %ymm2
	vpmaddubsw	288(%rcx), %ymm1, %ymm1
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB6_22:                               #   Parent Loop BB6_21 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	2304(%rcx,%r8,8)
	prefetcht0	2368(%rcx,%r8,8)
	prefetcht0	2432(%rcx,%r8,8)
	prefetcht0	2496(%rcx,%r8,8)
	vmovdqa	32(%rsi,%r8), %ymm9
	vpmaddubsw	320(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	352(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm8, %ymm10, %ymm8
	vpmaddubsw	384(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	416(%rcx,%r8,8), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	448(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	480(%rcx,%r8,8), %ymm9, %ymm10
	vpaddw	%ymm3, %ymm10, %ymm3
	vpmaddubsw	512(%rcx,%r8,8), %ymm9, %ymm10
	vpmaddubsw	544(%rcx,%r8,8), %ymm9, %ymm9
	vpaddw	%ymm2, %ymm10, %ymm2
	vpaddw	%ymm1, %ymm9, %ymm1
	addq	$32, %r8
	cmpq	$192, %r8
	jne	.LBB6_22
# %bb.23:                               #   in Loop: Header=BB6_21 Depth=1
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm8, %ymm8
	vphaddd	%ymm8, %ymm7, %ymm7
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm5, %ymm5
	vphaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vphaddd	%ymm1, %ymm2, %ymm1
	vphaddd	%ymm1, %ymm3, %ymm1
	vinserti128	$1, %xmm1, %ymm5, %ymm2
	vperm2i128	$49, %ymm1, %ymm5, %ymm1 # ymm1 = ymm5[2,3],ymm1[2,3]
	vpsubd	(%rcx), %ymm2, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	leal	(,%rdi,8), %r8d
	vmovdqu	%ymm1, (%rdx,%r8,4)
	incq	%rdi
	addq	$1856, %rcx                     # imm = 0x740
	cmpq	%rax, %rdi
	jne	.LBB6_21
	jmp	.LBB6_24
.LBB6_16:
	movl	28(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB6_24
# %bb.17:
	movq	(%rdi), %rcx
	shlq	$3, %rax
	xorl	%edi, %edi
	vpbroadcastw	.LCPI6_1(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB6_18:                               # =>This Inner Loop Header: Depth=1
	vmovdqa	(%rsi), %ymm2
	prefetcht0	2048(%rcx)
	vpmaddubsw	64(%rcx), %ymm2, %ymm3
	vpmaddubsw	128(%rcx), %ymm2, %ymm4
	vpmaddubsw	192(%rcx), %ymm2, %ymm5
	vpmaddubsw	256(%rcx), %ymm2, %ymm1
	vpmaddubsw	96(%rcx), %ymm2, %ymm6
	vpmaddubsw	160(%rcx), %ymm2, %ymm7
	vpmaddubsw	224(%rcx), %ymm2, %ymm8
	vpmaddubsw	288(%rcx), %ymm2, %ymm2
	prefetcht0	2112(%rcx)
	prefetcht0	2176(%rcx)
	prefetcht0	2240(%rcx)
	vmovdqa	32(%rsi), %ymm9
	prefetcht0	2304(%rcx)
	vpmaddubsw	320(%rcx), %ymm9, %ymm10
	vpmaddubsw	352(%rcx), %ymm9, %ymm11
	vpaddw	%ymm3, %ymm10, %ymm3
	vpaddw	%ymm6, %ymm11, %ymm6
	vpmaddubsw	384(%rcx), %ymm9, %ymm10
	vpaddw	%ymm4, %ymm10, %ymm4
	vpmaddubsw	416(%rcx), %ymm9, %ymm10
	vpaddw	%ymm7, %ymm10, %ymm7
	vpmaddubsw	448(%rcx), %ymm9, %ymm10
	vpmaddubsw	480(%rcx), %ymm9, %ymm11
	vpaddw	%ymm5, %ymm10, %ymm5
	vpaddw	%ymm8, %ymm11, %ymm8
	vpmaddubsw	512(%rcx), %ymm9, %ymm10
	vpmaddubsw	544(%rcx), %ymm9, %ymm9
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vphaddd	%ymm6, %ymm3, %ymm3
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm7, %ymm6
	vphaddd	%ymm6, %ymm4, %ymm4
	vpaddw	%ymm1, %ymm10, %ymm1
	vphaddd	%ymm4, %ymm3, %ymm3
	vpaddw	%ymm2, %ymm9, %ymm2
	prefetcht0	2368(%rcx)
	vpmaddwd	%ymm0, %ymm5, %ymm4
	vpmaddwd	%ymm0, %ymm8, %ymm5
	vphaddd	%ymm5, %ymm4, %ymm4
	vpmaddwd	%ymm0, %ymm1, %ymm1
	vpmaddwd	%ymm0, %ymm2, %ymm2
	vphaddd	%ymm2, %ymm1, %ymm1
	prefetcht0	2432(%rcx)
	vphaddd	%ymm1, %ymm4, %ymm1
	prefetcht0	2496(%rcx)
	vinserti128	$1, %xmm1, %ymm3, %ymm2
	vpsubd	(%rcx), %ymm2, %ymm2
	vperm2i128	$49, %ymm1, %ymm3, %ymm1 # ymm1 = ymm3[2,3],ymm1[2,3]
	vpaddd	%ymm1, %ymm2, %ymm1
	movl	%edi, %r8d
	andl	$-8, %r8d
	vmovdqu	%ymm1, (%rdx,%r8,4)
	addq	$576, %rcx                      # imm = 0x240
	addq	$8, %rdi
	cmpq	%rdi, %rax
	jne	.LBB6_18
.LBB6_24:
	popq	%rax
	vzeroupper
	retq
.LBB6_25:
	movl	$.L.str.13, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end6:
	.size	_ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi, .Lfunc_end6-_ZN3fx23opt9qgemv_i32ERKNS0_6QDenseEPKhPi
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf
.LCPI7_0:
	.zero	32,15
.LCPI7_1:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI7_2:
	.byte	15                              # 0xf
	.zero	1
.LCPI7_3:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf,"ax",@progbits
	.globl	_ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf,@function
_ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf: # @_ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf
# %bb.0:
	subq	$56, %rsp
	movl	20(%rdi), %eax
	decl	%eax
	cmpl	$11, %eax
	ja	.LBB7_17
# %bb.1:
	jmpq	*.LJTI7_0(,%rax,8)
.LBB7_2:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB7_16
# %bb.3:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	shlq	$2, %rax
	xorl	%edx, %edx
	vpbroadcastb	.LCPI7_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI7_3(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB7_4:                                # =>This Inner Loop Header: Depth=1
	vmovdqa	(%rsi), %ymm3
	vmovdqa	32(%rsi), %ymm4
	vmovdqa	32(%rdi), %ymm5
	vmovdqa	64(%rdi), %ymm6
	vmovdqa	96(%rdi), %ymm7
	vmovdqa	128(%rdi), %ymm8
	vpsrlw	$4, %ymm5, %ymm9
	vpand	%ymm1, %ymm5, %ymm5
	vpmaddubsw	%ymm3, %ymm5, %ymm5
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpaddw	%ymm5, %ymm9, %ymm5
	vpsrlw	$4, %ymm6, %ymm9
	vpand	%ymm1, %ymm6, %ymm6
	vpmaddubsw	%ymm3, %ymm6, %ymm6
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpaddw	%ymm6, %ymm9, %ymm6
	vpsrlw	$4, %ymm7, %ymm9
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm3, %ymm7, %ymm7
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsrlw	$4, %ymm8, %ymm9
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm3, %ymm8, %ymm3
	vpand	%ymm1, %ymm9, %ymm8
	vpmaddubsw	%ymm4, %ymm8, %ymm4
	vpaddw	%ymm3, %ymm4, %ymm3
	vpmaddwd	%ymm2, %ymm5, %ymm4
	vpmaddwd	%ymm2, %ymm6, %ymm5
	vphaddd	%ymm5, %ymm4, %ymm4
	vpmaddwd	%ymm2, %ymm7, %ymm5
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	prefetcht0	2048(%rdi)
	vphaddd	%ymm3, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpaddd	%xmm3, %xmm0, %xmm3
	vpaddd	%xmm4, %xmm3, %xmm3
	movl	%edx, %r8d
	andl	$-4, %r8d
	vcvtdq2ps	%xmm3, %xmm3
	vmulps	(%rdi), %xmm3, %xmm3
	vmovups	%xmm3, (%rcx,%r8,4)
	addq	$160, %rdi
	addq	$4, %rdx
	cmpq	%rdx, %rax
	jne	.LBB7_4
	jmp	.LBB7_16
.LBB7_8:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB7_16
# %bb.9:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	vmovdqa	%xmm0, 16(%rsp)                 # 16-byte Spill
	shlq	$2, %rax
	xorl	%edx, %edx
	vpbroadcastb	.LCPI7_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI7_3(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB7_10:                               # =>This Inner Loop Header: Depth=1
	prefetcht0	2048(%rdi)
	vmovdqa	384(%rdi), %ymm4
	vpand	%ymm1, %ymm4, %ymm3
	vmovdqa	128(%rsi), %ymm9
	vpmaddubsw	%ymm9, %ymm3, %ymm3
	vmovdqa	256(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm11
	vmovdqa	(%rsi), %ymm7
	vmovdqa	32(%rsi), %ymm6
	vmovdqa	64(%rsi), %ymm10
	vmovdqa	96(%rsi), %ymm5
	vpmaddubsw	%ymm10, %ymm11, %ymm11
	vpaddw	%ymm3, %ymm11, %ymm3
	vmovdqa	64(%rdi), %ymm12
	vmovdqa	96(%rdi), %ymm13
	vmovdqa	128(%rdi), %ymm11
	vpand	%ymm1, %ymm11, %ymm14
	vpmaddubsw	%ymm7, %ymm14, %ymm14
	vpaddw	%ymm3, %ymm14, %ymm3
	vpsrlw	$4, %ymm11, %ymm11
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm6, %ymm11, %ymm11
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm5, %ymm8, %ymm8
	vpaddw	%ymm8, %ymm11, %ymm8
	vpaddw	%ymm3, %ymm8, %ymm3
	vmovdqa	352(%rdi), %ymm11
	vpand	%ymm1, %ymm11, %ymm8
	vpmaddubsw	%ymm9, %ymm8, %ymm8
	vmovdqa	224(%rdi), %ymm14
	vpand	%ymm1, %ymm14, %ymm15
	vpmaddubsw	%ymm10, %ymm15, %ymm15
	vpaddw	%ymm8, %ymm15, %ymm8
	vpand	%ymm1, %ymm13, %ymm15
	vpmaddubsw	%ymm7, %ymm15, %ymm15
	vpaddw	%ymm15, %ymm8, %ymm8
	vpsrlw	$4, %ymm13, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm6, %ymm13, %ymm13
	vpsrlw	$4, %ymm14, %ymm14
	vpand	%ymm1, %ymm14, %ymm14
	vpmaddubsw	%ymm5, %ymm14, %ymm14
	vpaddw	%ymm14, %ymm13, %ymm13
	vpaddw	%ymm13, %ymm8, %ymm8
	vmovdqa	320(%rdi), %ymm13
	vpand	%ymm1, %ymm13, %ymm14
	vpmaddubsw	%ymm9, %ymm14, %ymm14
	vmovdqa	192(%rdi), %ymm15
	vpand	%ymm1, %ymm15, %ymm0
	vpmaddubsw	%ymm10, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm14, %ymm0
	vpand	%ymm1, %ymm12, %ymm14
	vpmaddubsw	%ymm7, %ymm14, %ymm14
	vpaddw	%ymm0, %ymm14, %ymm0
	vpsrlw	$4, %ymm12, %ymm12
	vpand	%ymm1, %ymm12, %ymm12
	vpmaddubsw	%ymm6, %ymm12, %ymm12
	vpsrlw	$4, %ymm15, %ymm14
	vpand	%ymm1, %ymm14, %ymm14
	vpmaddubsw	%ymm5, %ymm14, %ymm14
	vpaddw	%ymm14, %ymm12, %ymm12
	vpaddw	%ymm0, %ymm12, %ymm12
	vmovdqa	288(%rdi), %ymm0
	vpand	%ymm1, %ymm0, %ymm14
	vpmaddubsw	%ymm9, %ymm14, %ymm9
	vmovdqa	160(%rdi), %ymm14
	vpand	%ymm1, %ymm14, %ymm15
	vpmaddubsw	%ymm10, %ymm15, %ymm10
	vmovdqa	32(%rdi), %ymm15
	vpaddw	%ymm9, %ymm10, %ymm9
	vpand	%ymm1, %ymm15, %ymm10
	vpmaddubsw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsrlw	$4, %ymm15, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm6
	vpsrlw	$4, %ymm4, %ymm4
	vpand	%ymm1, %ymm4, %ymm4
	vpsrlw	$4, %ymm14, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm5, %ymm9, %ymm5
	vmovdqa	160(%rsi), %ymm9
	vpmaddubsw	%ymm9, %ymm4, %ymm4
	vpsrlw	$4, %ymm11, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm9, %ymm10, %ymm10
	vpsrlw	$4, %ymm13, %ymm11
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm9, %ymm11, %ymm11
	vpaddw	%ymm5, %ymm6, %ymm5
	vpaddw	%ymm5, %ymm7, %ymm5
	vpsrlw	$4, %ymm0, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpmaddubsw	%ymm9, %ymm0, %ymm0
	vmovdqa	192(%rsi), %ymm6
	vmovdqa	416(%rdi), %ymm7
	vpand	%ymm1, %ymm7, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm9
	vpaddw	%ymm0, %ymm9, %ymm0
	vmovdqa	224(%rsi), %ymm9
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm9, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm5, %ymm0
	vmovdqa	448(%rdi), %ymm5
	vpand	%ymm1, %ymm5, %ymm7
	vpmaddubsw	%ymm6, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm11, %ymm7
	vpsrlw	$4, %ymm5, %ymm5
	vpand	%ymm1, %ymm5, %ymm5
	vpmaddubsw	%ymm9, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm7, %ymm5
	vpaddw	%ymm5, %ymm12, %ymm5
	vmovdqa	480(%rdi), %ymm7
	vpand	%ymm1, %ymm7, %ymm11
	vpmaddubsw	%ymm6, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm10, %ymm10
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm9, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm7, %ymm8, %ymm7
	vmovdqa	512(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm10
	vpmaddubsw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm6, %ymm4, %ymm4
	vpsrlw	$4, %ymm8, %ymm6
	vpand	%ymm1, %ymm6, %ymm6
	vpmaddubsw	%ymm9, %ymm6, %ymm6
	vpaddw	%ymm6, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm2, %ymm0, %ymm0
	vpmaddwd	%ymm2, %ymm5, %ymm4
	vphaddd	%ymm4, %ymm0, %ymm0
	vpmaddwd	%ymm2, %ymm7, %ymm4
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vphaddd	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpaddd	16(%rsp), %xmm0, %xmm0          # 16-byte Folded Reload
	vpaddd	%xmm3, %xmm0, %xmm0
	movl	%edx, %r8d
	andl	$-4, %r8d
	vcvtdq2ps	%xmm0, %xmm0
	vmulps	(%rdi), %xmm0, %xmm0
	vmovups	%xmm0, (%rcx,%r8,4)
	addq	$544, %rdi                      # imm = 0x220
	addq	$4, %rdx
	cmpq	%rdx, %rax
	jne	.LBB7_10
	jmp	.LBB7_16
.LBB7_11:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB7_16
# %bb.12:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	vmovdqa	%xmm0, (%rsp)                   # 16-byte Spill
	xorl	%edx, %edx
	vpbroadcastb	.LCPI7_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	.p2align	4, 0x90
.LBB7_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB7_14 Depth 2
	vxorps	%xmm9, %xmm9, %xmm9
	movl	$224, %r8d
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB7_14:                               #   Parent Loop BB7_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovups	%ymm9, 16(%rsp)                 # 32-byte Spill
	prefetcht0	1600(%rdi,%r8,2)
	vmovdqa	-416(%rdi,%r8,2), %ymm7
	vmovdqa	-384(%rdi,%r8,2), %ymm8
	vmovdqa	-352(%rdi,%r8,2), %ymm9
	vmovdqa	-320(%rdi,%r8,2), %ymm10
	vpsrlw	$4, %ymm7, %ymm11
	vpand	%ymm1, %ymm7, %ymm12
	vmovdqa	-224(%rsi,%r8), %ymm13
	vmovdqa	-192(%rsi,%r8), %ymm14
	vmovdqa	-160(%rsi,%r8), %ymm7
	vpmaddubsw	%ymm13, %ymm12, %ymm12
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm14, %ymm11, %ymm11
	vpsrlw	$4, %ymm8, %ymm15
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm13, %ymm8, %ymm0
	vpand	%ymm1, %ymm15, %ymm8
	vpmaddubsw	%ymm14, %ymm8, %ymm15
	vpsrlw	$4, %ymm9, %ymm8
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm13, %ymm9, %ymm2
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm14, %ymm8, %ymm3
	vpsrlw	$4, %ymm10, %ymm9
	vpand	%ymm1, %ymm10, %ymm8
	vpmaddubsw	%ymm13, %ymm8, %ymm8
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm14, %ymm9, %ymm9
	vmovdqa	-288(%rdi,%r8,2), %ymm13
	vpand	%ymm1, %ymm13, %ymm10
	vpmaddubsw	%ymm7, %ymm10, %ymm10
	vpaddw	%ymm10, %ymm12, %ymm10
	vpaddw	%ymm10, %ymm11, %ymm10
	vmovdqa	-256(%rdi,%r8,2), %ymm14
	vpand	%ymm1, %ymm14, %ymm11
	vpmaddubsw	%ymm7, %ymm11, %ymm11
	vpaddw	%ymm0, %ymm11, %ymm0
	vpaddw	%ymm0, %ymm15, %ymm11
	vmovdqa	-224(%rdi,%r8,2), %ymm0
	vpand	%ymm1, %ymm0, %ymm12
	vpmaddubsw	%ymm7, %ymm12, %ymm12
	vpaddw	%ymm2, %ymm12, %ymm2
	vpaddw	%ymm2, %ymm3, %ymm12
	vmovdqa	-192(%rdi,%r8,2), %ymm2
	vpand	%ymm1, %ymm2, %ymm3
	vpmaddubsw	%ymm7, %ymm3, %ymm3
	vmovdqa	-128(%rsi,%r8), %ymm7
	vpsrlw	$4, %ymm13, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm7, %ymm13, %ymm15
	vpsrlw	$4, %ymm14, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm7, %ymm13, %ymm14
	vpsrlw	$4, %ymm0, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpmaddubsw	%ymm7, %ymm0, %ymm0
	vpsrlw	$4, %ymm2, %ymm2
	vpaddw	%ymm3, %ymm8, %ymm3
	vpaddw	%ymm3, %ymm9, %ymm13
	vpand	%ymm1, %ymm2, %ymm2
	vpmaddubsw	%ymm7, %ymm2, %ymm2
	vmovdqa	-96(%rsi,%r8), %ymm3
	vmovdqa	-160(%rdi,%r8,2), %ymm7
	vpand	%ymm1, %ymm7, %ymm8
	vpmaddubsw	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm8, %ymm15, %ymm8
	vpaddw	%ymm8, %ymm10, %ymm9
	vmovdqa	-128(%rdi,%r8,2), %ymm10
	vpand	%ymm1, %ymm10, %ymm8
	vpmaddubsw	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm8, %ymm14, %ymm8
	vpaddw	%ymm8, %ymm11, %ymm8
	vmovdqa	-96(%rdi,%r8,2), %ymm11
	vpand	%ymm1, %ymm11, %ymm14
	vpmaddubsw	%ymm3, %ymm14, %ymm14
	vpaddw	%ymm0, %ymm14, %ymm0
	vpaddw	%ymm0, %ymm12, %ymm0
	vmovdqa	-64(%rdi,%r8,2), %ymm12
	vpand	%ymm1, %ymm12, %ymm14
	vpmaddubsw	%ymm3, %ymm14, %ymm3
	vmovdqa	-64(%rsi,%r8), %ymm14
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm14, %ymm7, %ymm7
	vpsrlw	$4, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm14, %ymm10, %ymm15
	vpsrlw	$4, %ymm11, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm14, %ymm10, %ymm11
	vpsrlw	$4, %ymm12, %ymm12
	vpaddw	%ymm3, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm13, %ymm10
	vpand	%ymm1, %ymm12, %ymm2
	vpmaddubsw	%ymm14, %ymm2, %ymm2
	vmovdqa	-32(%rsi,%r8), %ymm3
	vmovdqa	-32(%rdi,%r8,2), %ymm12
	vpand	%ymm1, %ymm12, %ymm13
	vpmaddubsw	%ymm3, %ymm13, %ymm13
	vpaddw	%ymm7, %ymm13, %ymm7
	vmovdqa	(%rsi,%r8), %ymm13
	vpsrlw	$4, %ymm12, %ymm12
	vpand	%ymm1, %ymm12, %ymm12
	vpmaddubsw	%ymm13, %ymm12, %ymm12
	vpaddw	%ymm7, %ymm12, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm7
	vmovdqa	(%rdi,%r8,2), %ymm9
	vpand	%ymm1, %ymm9, %ymm12
	vpmaddubsw	%ymm3, %ymm12, %ymm12
	vpaddw	%ymm12, %ymm15, %ymm12
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm13, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm12, %ymm9
	vpaddw	%ymm9, %ymm8, %ymm8
	vmovdqa	32(%rdi,%r8,2), %ymm9
	vpand	%ymm1, %ymm9, %ymm12
	vpmaddubsw	%ymm3, %ymm12, %ymm12
	vpaddw	%ymm12, %ymm11, %ymm11
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm13, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm0, %ymm9, %ymm0
	vmovdqa	64(%rdi,%r8,2), %ymm9
	vpand	%ymm1, %ymm9, %ymm11
	vpmaddubsw	%ymm3, %ymm11, %ymm3
	vpaddw	%ymm3, %ymm2, %ymm2
	vpsrlw	$4, %ymm9, %ymm3
	vmovdqu	16(%rsp), %ymm9                 # 32-byte Reload
	vpand	%ymm1, %ymm3, %ymm3
	vpmaddubsw	%ymm13, %ymm3, %ymm3
	vpaddw	%ymm3, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm10, %ymm2
	vpmaddwd	.LCPI7_1(%rip), %ymm7, %ymm3
	vpbroadcastw	.LCPI7_3(%rip), %ymm7   # ymm7 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	vpaddd	%ymm3, %ymm9, %ymm9
	vpmaddwd	%ymm7, %ymm8, %ymm3
	vpaddd	%ymm4, %ymm3, %ymm4
	vpmaddwd	%ymm7, %ymm0, %ymm0
	vpaddd	%ymm5, %ymm0, %ymm5
	vpmaddwd	%ymm7, %ymm2, %ymm0
	vpaddd	%ymm6, %ymm0, %ymm6
	addq	$256, %r8                       # imm = 0x100
	cmpq	$992, %r8                       # imm = 0x3E0
	jne	.LBB7_14
# %bb.15:                               #   in Loop: Header=BB7_13 Depth=1
	vphaddd	%ymm4, %ymm9, %ymm3
	vphaddd	%ymm6, %ymm5, %ymm4
	vphaddd	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpaddd	(%rsp), %xmm3, %xmm3            # 16-byte Folded Reload
	vpaddd	%xmm4, %xmm3, %xmm3
	leal	(,%rdx,4), %r8d
	vcvtdq2ps	%xmm3, %xmm3
	vmulps	(%rdi), %xmm3, %xmm3
	vmovups	%xmm3, (%rcx,%r8,4)
	incq	%rdx
	addq	$1568, %rdi                     # imm = 0x620
	cmpq	%rax, %rdx
	jne	.LBB7_13
	jmp	.LBB7_16
.LBB7_5:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB7_16
# %bb.6:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	shlq	$2, %rax
	xorl	%edx, %edx
	vpbroadcastb	.LCPI7_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI7_3(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB7_7:                                # =>This Inner Loop Header: Depth=1
	prefetcht0	2048(%rdi)
	vmovdqa	256(%rdi), %ymm4
	vpand	%ymm1, %ymm4, %ymm3
	vmovdqa	(%rsi), %ymm9
	vmovdqa	32(%rsi), %ymm7
	vmovdqa	64(%rsi), %ymm11
	vmovdqa	96(%rsi), %ymm6
	vpmaddubsw	%ymm11, %ymm3, %ymm3
	vmovdqa	32(%rdi), %ymm10
	vmovdqa	64(%rdi), %ymm12
	vmovdqa	96(%rdi), %ymm5
	vmovdqa	128(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm13
	vpmaddubsw	%ymm9, %ymm13, %ymm13
	vpaddw	%ymm3, %ymm13, %ymm3
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm7, %ymm8, %ymm8
	vpaddw	%ymm3, %ymm8, %ymm3
	vpsrlw	$4, %ymm4, %ymm4
	vpand	%ymm1, %ymm4, %ymm4
	vpmaddubsw	%ymm6, %ymm4, %ymm4
	vmovdqa	224(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm13
	vpmaddubsw	%ymm11, %ymm13, %ymm13
	vpand	%ymm1, %ymm5, %ymm14
	vpmaddubsw	%ymm9, %ymm14, %ymm14
	vpaddw	%ymm13, %ymm14, %ymm13
	vpsrlw	$4, %ymm5, %ymm5
	vpand	%ymm1, %ymm5, %ymm5
	vpmaddubsw	%ymm7, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm13, %ymm5
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm6, %ymm8, %ymm8
	vmovdqa	192(%rdi), %ymm13
	vpand	%ymm1, %ymm13, %ymm14
	vpmaddubsw	%ymm11, %ymm14, %ymm14
	vpand	%ymm1, %ymm12, %ymm15
	vpmaddubsw	%ymm9, %ymm15, %ymm15
	vpaddw	%ymm14, %ymm15, %ymm14
	vpsrlw	$4, %ymm12, %ymm12
	vpand	%ymm1, %ymm12, %ymm12
	vpmaddubsw	%ymm7, %ymm12, %ymm12
	vpaddw	%ymm12, %ymm14, %ymm12
	vpsrlw	$4, %ymm13, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm6, %ymm13, %ymm13
	vmovdqa	160(%rdi), %ymm14
	vpand	%ymm1, %ymm14, %ymm15
	vpmaddubsw	%ymm11, %ymm15, %ymm11
	vpand	%ymm1, %ymm10, %ymm15
	vpmaddubsw	%ymm9, %ymm15, %ymm9
	vpaddw	%ymm11, %ymm9, %ymm9
	vpsrlw	$4, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsrlw	$4, %ymm14, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm9
	vmovdqa	128(%rsi), %ymm10
	vmovdqa	160(%rsi), %ymm6
	vmovdqa	288(%rdi), %ymm11
	vpsrlw	$4, %ymm11, %ymm14
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm10, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vpand	%ymm1, %ymm14, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vmovdqa	320(%rdi), %ymm9
	vpsrlw	$4, %ymm9, %ymm11
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm10, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm13, %ymm9
	vpaddw	%ymm9, %ymm12, %ymm9
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm6, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vmovdqa	352(%rdi), %ymm11
	vpsrlw	$4, %ymm11, %ymm12
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm10, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm8, %ymm8
	vpaddw	%ymm5, %ymm8, %ymm5
	vpand	%ymm1, %ymm12, %ymm8
	vpmaddubsw	%ymm6, %ymm8, %ymm8
	vpaddw	%ymm5, %ymm8, %ymm5
	vmovdqa	384(%rdi), %ymm8
	vpsrlw	$4, %ymm8, %ymm11
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm10, %ymm8, %ymm8
	vpaddw	%ymm4, %ymm8, %ymm4
	vpaddw	%ymm4, %ymm3, %ymm3
	vpand	%ymm1, %ymm11, %ymm4
	vpmaddubsw	%ymm6, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm2, %ymm7, %ymm4
	vpmaddwd	%ymm2, %ymm9, %ymm6
	vphaddd	%ymm6, %ymm4, %ymm4
	vpmaddwd	%ymm2, %ymm5, %ymm5
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpaddd	%xmm3, %xmm0, %xmm3
	vpaddd	%xmm4, %xmm3, %xmm3
	movl	%edx, %r8d
	andl	$-4, %r8d
	vcvtdq2ps	%xmm3, %xmm3
	vmulps	(%rdi), %xmm3, %xmm3
	vmovups	%xmm3, (%rcx,%r8,4)
	addq	$416, %rdi                      # imm = 0x1A0
	addq	$4, %rdx
	cmpq	%rdx, %rax
	jne	.LBB7_7
.LBB7_16:
	addq	$56, %rsp
	vzeroupper
	retq
.LBB7_17:
	movl	$.L.str.14, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end7:
	.size	_ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf, .Lfunc_end7-_ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf
	.section	.rodata._ZN3fx23opt16qgemv_packed_f32ERKNS0_7QPackedEPKaiPf,"a",@progbits
	.p2align	3, 0x0
.LJTI7_0:
	.quad	.LBB7_2
	.quad	.LBB7_17
	.quad	.LBB7_5
	.quad	.LBB7_8
	.quad	.LBB7_17
	.quad	.LBB7_17
	.quad	.LBB7_17
	.quad	.LBB7_17
	.quad	.LBB7_17
	.quad	.LBB7_17
	.quad	.LBB7_17
	.quad	.LBB7_11
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi
.LCPI8_0:
	.zero	32,15
.LCPI8_1:
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.short	1                               # 0x1
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI8_2:
	.byte	15                              # 0xf
	.zero	1
.LCPI8_3:
	.short	1                               # 0x1
	.section	.text._ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi,"ax",@progbits
	.globl	_ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi,@function
_ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi: # @_ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi
# %bb.0:
	subq	$56, %rsp
	movl	20(%rdi), %eax
	decl	%eax
	cmpl	$11, %eax
	ja	.LBB8_17
# %bb.1:
	jmpq	*.LJTI8_0(,%rax,8)
.LBB8_2:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB8_16
# %bb.3:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	shlq	$2, %rax
	addq	$32, %rdi
	xorl	%edx, %edx
	vpbroadcastb	.LCPI8_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI8_3(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB8_4:                                # =>This Inner Loop Header: Depth=1
	vmovdqa	(%rsi), %ymm3
	vmovdqa	32(%rsi), %ymm4
	vmovdqa	(%rdi), %ymm5
	vmovdqa	32(%rdi), %ymm6
	vmovdqa	64(%rdi), %ymm7
	vmovdqa	96(%rdi), %ymm8
	vpsrlw	$4, %ymm5, %ymm9
	vpand	%ymm1, %ymm5, %ymm5
	vpmaddubsw	%ymm3, %ymm5, %ymm5
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpaddw	%ymm5, %ymm9, %ymm5
	vpsrlw	$4, %ymm6, %ymm9
	vpand	%ymm1, %ymm6, %ymm6
	vpmaddubsw	%ymm3, %ymm6, %ymm6
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpaddw	%ymm6, %ymm9, %ymm6
	vpsrlw	$4, %ymm7, %ymm9
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm3, %ymm7, %ymm7
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm4, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsrlw	$4, %ymm8, %ymm9
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm3, %ymm8, %ymm3
	vpand	%ymm1, %ymm9, %ymm8
	vpmaddubsw	%ymm4, %ymm8, %ymm4
	vpaddw	%ymm3, %ymm4, %ymm3
	prefetcht0	2016(%rdi)
	vpmaddwd	%ymm2, %ymm5, %ymm4
	vpmaddwd	%ymm2, %ymm6, %ymm5
	vphaddd	%ymm5, %ymm4, %ymm4
	vpmaddwd	%ymm2, %ymm7, %ymm5
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpaddd	%xmm3, %xmm0, %xmm3
	vpaddd	%xmm4, %xmm3, %xmm3
	movl	%edx, %r8d
	andl	$-4, %r8d
	vmovdqu	%xmm3, (%rcx,%r8,4)
	addq	$4, %rdx
	addq	$160, %rdi
	cmpq	%rdx, %rax
	jne	.LBB8_4
	jmp	.LBB8_16
.LBB8_8:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB8_16
# %bb.9:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	vmovdqa	%xmm0, 16(%rsp)                 # 16-byte Spill
	shlq	$2, %rax
	addq	$32, %rdi
	xorl	%edx, %edx
	vpbroadcastb	.LCPI8_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI8_3(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB8_10:                               # =>This Inner Loop Header: Depth=1
	prefetcht0	2016(%rdi)
	vmovdqa	352(%rdi), %ymm4
	vpand	%ymm1, %ymm4, %ymm3
	vmovdqa	128(%rsi), %ymm9
	vpmaddubsw	%ymm9, %ymm3, %ymm3
	vmovdqa	224(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm11
	vmovdqa	(%rsi), %ymm7
	vmovdqa	32(%rsi), %ymm6
	vmovdqa	64(%rsi), %ymm10
	vmovdqa	96(%rsi), %ymm5
	vpmaddubsw	%ymm10, %ymm11, %ymm11
	vpaddw	%ymm3, %ymm11, %ymm3
	vmovdqa	32(%rdi), %ymm12
	vmovdqa	64(%rdi), %ymm13
	vmovdqa	96(%rdi), %ymm11
	vpand	%ymm1, %ymm11, %ymm14
	vpmaddubsw	%ymm7, %ymm14, %ymm14
	vpaddw	%ymm3, %ymm14, %ymm3
	vpsrlw	$4, %ymm11, %ymm11
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm6, %ymm11, %ymm11
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm5, %ymm8, %ymm8
	vpaddw	%ymm8, %ymm11, %ymm8
	vpaddw	%ymm3, %ymm8, %ymm3
	vmovdqa	320(%rdi), %ymm11
	vpand	%ymm1, %ymm11, %ymm8
	vpmaddubsw	%ymm9, %ymm8, %ymm8
	vmovdqa	192(%rdi), %ymm14
	vpand	%ymm1, %ymm14, %ymm15
	vpmaddubsw	%ymm10, %ymm15, %ymm15
	vpaddw	%ymm8, %ymm15, %ymm8
	vpand	%ymm1, %ymm13, %ymm15
	vpmaddubsw	%ymm7, %ymm15, %ymm15
	vpaddw	%ymm15, %ymm8, %ymm8
	vpsrlw	$4, %ymm13, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm6, %ymm13, %ymm13
	vpsrlw	$4, %ymm14, %ymm14
	vpand	%ymm1, %ymm14, %ymm14
	vpmaddubsw	%ymm5, %ymm14, %ymm14
	vpaddw	%ymm14, %ymm13, %ymm13
	vpaddw	%ymm13, %ymm8, %ymm8
	vmovdqa	288(%rdi), %ymm13
	vpand	%ymm1, %ymm13, %ymm14
	vpmaddubsw	%ymm9, %ymm14, %ymm14
	vmovdqa	160(%rdi), %ymm15
	vpand	%ymm1, %ymm15, %ymm0
	vpmaddubsw	%ymm10, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm14, %ymm0
	vpand	%ymm1, %ymm12, %ymm14
	vpmaddubsw	%ymm7, %ymm14, %ymm14
	vpaddw	%ymm0, %ymm14, %ymm0
	vpsrlw	$4, %ymm12, %ymm12
	vpand	%ymm1, %ymm12, %ymm12
	vpmaddubsw	%ymm6, %ymm12, %ymm12
	vpsrlw	$4, %ymm15, %ymm14
	vpand	%ymm1, %ymm14, %ymm14
	vpmaddubsw	%ymm5, %ymm14, %ymm14
	vpaddw	%ymm14, %ymm12, %ymm12
	vpaddw	%ymm0, %ymm12, %ymm12
	vmovdqa	256(%rdi), %ymm0
	vpand	%ymm1, %ymm0, %ymm14
	vpmaddubsw	%ymm9, %ymm14, %ymm9
	vmovdqa	128(%rdi), %ymm14
	vpand	%ymm1, %ymm14, %ymm15
	vpmaddubsw	%ymm10, %ymm15, %ymm10
	vmovdqa	(%rdi), %ymm15
	vpaddw	%ymm9, %ymm10, %ymm9
	vpand	%ymm1, %ymm15, %ymm10
	vpmaddubsw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsrlw	$4, %ymm15, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm6
	vpsrlw	$4, %ymm4, %ymm4
	vpand	%ymm1, %ymm4, %ymm4
	vpsrlw	$4, %ymm14, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm5, %ymm9, %ymm5
	vmovdqa	160(%rsi), %ymm9
	vpmaddubsw	%ymm9, %ymm4, %ymm4
	vpsrlw	$4, %ymm11, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm9, %ymm10, %ymm10
	vpsrlw	$4, %ymm13, %ymm11
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm9, %ymm11, %ymm11
	vpaddw	%ymm5, %ymm6, %ymm5
	vpaddw	%ymm5, %ymm7, %ymm5
	vpsrlw	$4, %ymm0, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpmaddubsw	%ymm9, %ymm0, %ymm0
	vmovdqa	192(%rsi), %ymm6
	vmovdqa	384(%rdi), %ymm7
	vpand	%ymm1, %ymm7, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm9
	vpaddw	%ymm0, %ymm9, %ymm0
	vmovdqa	224(%rsi), %ymm9
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm9, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm5, %ymm0
	vmovdqa	416(%rdi), %ymm5
	vpand	%ymm1, %ymm5, %ymm7
	vpmaddubsw	%ymm6, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm11, %ymm7
	vpsrlw	$4, %ymm5, %ymm5
	vpand	%ymm1, %ymm5, %ymm5
	vpmaddubsw	%ymm9, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm7, %ymm5
	vpaddw	%ymm5, %ymm12, %ymm5
	vmovdqa	448(%rdi), %ymm7
	vpand	%ymm1, %ymm7, %ymm11
	vpmaddubsw	%ymm6, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm10, %ymm10
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm9, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm7, %ymm8, %ymm7
	vmovdqa	480(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm10
	vpmaddubsw	%ymm6, %ymm10, %ymm6
	vpaddw	%ymm6, %ymm4, %ymm4
	vpsrlw	$4, %ymm8, %ymm6
	vpand	%ymm1, %ymm6, %ymm6
	vpmaddubsw	%ymm9, %ymm6, %ymm6
	vpaddw	%ymm6, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm2, %ymm0, %ymm0
	vpmaddwd	%ymm2, %ymm5, %ymm4
	vphaddd	%ymm4, %ymm0, %ymm0
	vpmaddwd	%ymm2, %ymm7, %ymm4
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vphaddd	%ymm3, %ymm0, %ymm0
	vextracti128	$1, %ymm0, %xmm3
	vpaddd	16(%rsp), %xmm0, %xmm0          # 16-byte Folded Reload
	vpaddd	%xmm3, %xmm0, %xmm0
	movl	%edx, %r8d
	andl	$-4, %r8d
	vmovdqu	%xmm0, (%rcx,%r8,4)
	addq	$4, %rdx
	addq	$544, %rdi                      # imm = 0x220
	cmpq	%rdx, %rax
	jne	.LBB8_10
	jmp	.LBB8_16
.LBB8_11:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB8_16
# %bb.12:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	vmovdqa	%xmm0, (%rsp)                   # 16-byte Spill
	xorl	%edx, %edx
	vpbroadcastb	.LCPI8_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	.p2align	4, 0x90
.LBB8_13:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB8_14 Depth 2
	vxorps	%xmm9, %xmm9, %xmm9
	movl	$224, %r8d
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	.p2align	4, 0x90
.LBB8_14:                               #   Parent Loop BB8_13 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovups	%ymm9, 16(%rsp)                 # 32-byte Spill
	prefetcht0	1600(%rdi,%r8,2)
	vmovdqa	-416(%rdi,%r8,2), %ymm7
	vmovdqa	-384(%rdi,%r8,2), %ymm8
	vmovdqa	-352(%rdi,%r8,2), %ymm9
	vmovdqa	-320(%rdi,%r8,2), %ymm10
	vpsrlw	$4, %ymm7, %ymm11
	vpand	%ymm1, %ymm7, %ymm12
	vmovdqa	-224(%rsi,%r8), %ymm13
	vmovdqa	-192(%rsi,%r8), %ymm14
	vmovdqa	-160(%rsi,%r8), %ymm7
	vpmaddubsw	%ymm13, %ymm12, %ymm12
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm14, %ymm11, %ymm11
	vpsrlw	$4, %ymm8, %ymm15
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm13, %ymm8, %ymm0
	vpand	%ymm1, %ymm15, %ymm8
	vpmaddubsw	%ymm14, %ymm8, %ymm15
	vpsrlw	$4, %ymm9, %ymm8
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm13, %ymm9, %ymm2
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm14, %ymm8, %ymm3
	vpsrlw	$4, %ymm10, %ymm9
	vpand	%ymm1, %ymm10, %ymm8
	vpmaddubsw	%ymm13, %ymm8, %ymm8
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm14, %ymm9, %ymm9
	vmovdqa	-288(%rdi,%r8,2), %ymm13
	vpand	%ymm1, %ymm13, %ymm10
	vpmaddubsw	%ymm7, %ymm10, %ymm10
	vpaddw	%ymm10, %ymm12, %ymm10
	vpaddw	%ymm10, %ymm11, %ymm10
	vmovdqa	-256(%rdi,%r8,2), %ymm14
	vpand	%ymm1, %ymm14, %ymm11
	vpmaddubsw	%ymm7, %ymm11, %ymm11
	vpaddw	%ymm0, %ymm11, %ymm0
	vpaddw	%ymm0, %ymm15, %ymm11
	vmovdqa	-224(%rdi,%r8,2), %ymm0
	vpand	%ymm1, %ymm0, %ymm12
	vpmaddubsw	%ymm7, %ymm12, %ymm12
	vpaddw	%ymm2, %ymm12, %ymm2
	vpaddw	%ymm2, %ymm3, %ymm12
	vmovdqa	-192(%rdi,%r8,2), %ymm2
	vpand	%ymm1, %ymm2, %ymm3
	vpmaddubsw	%ymm7, %ymm3, %ymm3
	vmovdqa	-128(%rsi,%r8), %ymm7
	vpsrlw	$4, %ymm13, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm7, %ymm13, %ymm15
	vpsrlw	$4, %ymm14, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm7, %ymm13, %ymm14
	vpsrlw	$4, %ymm0, %ymm0
	vpand	%ymm1, %ymm0, %ymm0
	vpmaddubsw	%ymm7, %ymm0, %ymm0
	vpsrlw	$4, %ymm2, %ymm2
	vpaddw	%ymm3, %ymm8, %ymm3
	vpaddw	%ymm3, %ymm9, %ymm13
	vpand	%ymm1, %ymm2, %ymm2
	vpmaddubsw	%ymm7, %ymm2, %ymm2
	vmovdqa	-96(%rsi,%r8), %ymm3
	vmovdqa	-160(%rdi,%r8,2), %ymm7
	vpand	%ymm1, %ymm7, %ymm8
	vpmaddubsw	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm8, %ymm15, %ymm8
	vpaddw	%ymm8, %ymm10, %ymm9
	vmovdqa	-128(%rdi,%r8,2), %ymm10
	vpand	%ymm1, %ymm10, %ymm8
	vpmaddubsw	%ymm3, %ymm8, %ymm8
	vpaddw	%ymm8, %ymm14, %ymm8
	vpaddw	%ymm8, %ymm11, %ymm8
	vmovdqa	-96(%rdi,%r8,2), %ymm11
	vpand	%ymm1, %ymm11, %ymm14
	vpmaddubsw	%ymm3, %ymm14, %ymm14
	vpaddw	%ymm0, %ymm14, %ymm0
	vpaddw	%ymm0, %ymm12, %ymm0
	vmovdqa	-64(%rdi,%r8,2), %ymm12
	vpand	%ymm1, %ymm12, %ymm14
	vpmaddubsw	%ymm3, %ymm14, %ymm3
	vmovdqa	-64(%rsi,%r8), %ymm14
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm7, %ymm7
	vpmaddubsw	%ymm14, %ymm7, %ymm7
	vpsrlw	$4, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm14, %ymm10, %ymm15
	vpsrlw	$4, %ymm11, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm14, %ymm10, %ymm11
	vpsrlw	$4, %ymm12, %ymm12
	vpaddw	%ymm3, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm13, %ymm10
	vpand	%ymm1, %ymm12, %ymm2
	vpmaddubsw	%ymm14, %ymm2, %ymm2
	vmovdqa	-32(%rsi,%r8), %ymm3
	vmovdqa	-32(%rdi,%r8,2), %ymm12
	vpand	%ymm1, %ymm12, %ymm13
	vpmaddubsw	%ymm3, %ymm13, %ymm13
	vpaddw	%ymm7, %ymm13, %ymm7
	vmovdqa	(%rsi,%r8), %ymm13
	vpsrlw	$4, %ymm12, %ymm12
	vpand	%ymm1, %ymm12, %ymm12
	vpmaddubsw	%ymm13, %ymm12, %ymm12
	vpaddw	%ymm7, %ymm12, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm7
	vmovdqa	(%rdi,%r8,2), %ymm9
	vpand	%ymm1, %ymm9, %ymm12
	vpmaddubsw	%ymm3, %ymm12, %ymm12
	vpaddw	%ymm12, %ymm15, %ymm12
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm13, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm12, %ymm9
	vpaddw	%ymm9, %ymm8, %ymm8
	vmovdqa	32(%rdi,%r8,2), %ymm9
	vpand	%ymm1, %ymm9, %ymm12
	vpmaddubsw	%ymm3, %ymm12, %ymm12
	vpaddw	%ymm12, %ymm11, %ymm11
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm13, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm11, %ymm9
	vpaddw	%ymm0, %ymm9, %ymm0
	vmovdqa	64(%rdi,%r8,2), %ymm9
	vpand	%ymm1, %ymm9, %ymm11
	vpmaddubsw	%ymm3, %ymm11, %ymm3
	vpaddw	%ymm3, %ymm2, %ymm2
	vpsrlw	$4, %ymm9, %ymm3
	vmovdqu	16(%rsp), %ymm9                 # 32-byte Reload
	vpand	%ymm1, %ymm3, %ymm3
	vpmaddubsw	%ymm13, %ymm3, %ymm3
	vpaddw	%ymm3, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm10, %ymm2
	vpmaddwd	.LCPI8_1(%rip), %ymm7, %ymm3
	vpbroadcastw	.LCPI8_3(%rip), %ymm7   # ymm7 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	vpaddd	%ymm3, %ymm9, %ymm9
	vpmaddwd	%ymm7, %ymm8, %ymm3
	vpaddd	%ymm4, %ymm3, %ymm4
	vpmaddwd	%ymm7, %ymm0, %ymm0
	vpaddd	%ymm5, %ymm0, %ymm5
	vpmaddwd	%ymm7, %ymm2, %ymm0
	vpaddd	%ymm6, %ymm0, %ymm6
	addq	$256, %r8                       # imm = 0x100
	cmpq	$992, %r8                       # imm = 0x3E0
	jne	.LBB8_14
# %bb.15:                               #   in Loop: Header=BB8_13 Depth=1
	vphaddd	%ymm4, %ymm9, %ymm3
	vphaddd	%ymm6, %ymm5, %ymm4
	vphaddd	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpaddd	(%rsp), %xmm3, %xmm3            # 16-byte Folded Reload
	vpaddd	%xmm4, %xmm3, %xmm3
	leal	(,%rdx,4), %r8d
	vmovdqu	%xmm3, (%rcx,%r8,4)
	incq	%rdx
	addq	$1568, %rdi                     # imm = 0x620
	cmpq	%rax, %rdx
	jne	.LBB8_13
	jmp	.LBB8_16
.LBB8_5:
	movl	24(%rdi), %eax
	testl	%eax, %eax
	jle	.LBB8_16
# %bb.6:
	movq	(%rdi), %rdi
	negl	%edx
	vmovd	%edx, %xmm0
	vpbroadcastd	%xmm0, %xmm0
	shlq	$2, %rax
	addq	$32, %rdi
	xorl	%edx, %edx
	vpbroadcastb	.LCPI8_2(%rip), %ymm1   # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI8_3(%rip), %ymm2   # ymm2 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	.p2align	4, 0x90
.LBB8_7:                                # =>This Inner Loop Header: Depth=1
	prefetcht0	2016(%rdi)
	vmovdqa	224(%rdi), %ymm4
	vpand	%ymm1, %ymm4, %ymm3
	vmovdqa	(%rsi), %ymm9
	vmovdqa	32(%rsi), %ymm7
	vmovdqa	64(%rsi), %ymm11
	vmovdqa	96(%rsi), %ymm6
	vpmaddubsw	%ymm11, %ymm3, %ymm3
	vmovdqa	(%rdi), %ymm10
	vmovdqa	32(%rdi), %ymm12
	vmovdqa	64(%rdi), %ymm5
	vmovdqa	96(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm13
	vpmaddubsw	%ymm9, %ymm13, %ymm13
	vpaddw	%ymm3, %ymm13, %ymm3
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm7, %ymm8, %ymm8
	vpaddw	%ymm3, %ymm8, %ymm3
	vpsrlw	$4, %ymm4, %ymm4
	vpand	%ymm1, %ymm4, %ymm4
	vpmaddubsw	%ymm6, %ymm4, %ymm4
	vmovdqa	192(%rdi), %ymm8
	vpand	%ymm1, %ymm8, %ymm13
	vpmaddubsw	%ymm11, %ymm13, %ymm13
	vpand	%ymm1, %ymm5, %ymm14
	vpmaddubsw	%ymm9, %ymm14, %ymm14
	vpaddw	%ymm13, %ymm14, %ymm13
	vpsrlw	$4, %ymm5, %ymm5
	vpand	%ymm1, %ymm5, %ymm5
	vpmaddubsw	%ymm7, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm13, %ymm5
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm6, %ymm8, %ymm8
	vmovdqa	160(%rdi), %ymm13
	vpand	%ymm1, %ymm13, %ymm14
	vpmaddubsw	%ymm11, %ymm14, %ymm14
	vpand	%ymm1, %ymm12, %ymm15
	vpmaddubsw	%ymm9, %ymm15, %ymm15
	vpaddw	%ymm14, %ymm15, %ymm14
	vpsrlw	$4, %ymm12, %ymm12
	vpand	%ymm1, %ymm12, %ymm12
	vpmaddubsw	%ymm7, %ymm12, %ymm12
	vpaddw	%ymm12, %ymm14, %ymm12
	vpsrlw	$4, %ymm13, %ymm13
	vpand	%ymm1, %ymm13, %ymm13
	vpmaddubsw	%ymm6, %ymm13, %ymm13
	vmovdqa	128(%rdi), %ymm14
	vpand	%ymm1, %ymm14, %ymm15
	vpmaddubsw	%ymm11, %ymm15, %ymm11
	vpand	%ymm1, %ymm10, %ymm15
	vpmaddubsw	%ymm9, %ymm15, %ymm9
	vpaddw	%ymm11, %ymm9, %ymm9
	vpsrlw	$4, %ymm10, %ymm10
	vpand	%ymm1, %ymm10, %ymm10
	vpmaddubsw	%ymm7, %ymm10, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm7
	vpsrlw	$4, %ymm14, %ymm9
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm9
	vmovdqa	128(%rsi), %ymm10
	vmovdqa	160(%rsi), %ymm6
	vmovdqa	256(%rdi), %ymm11
	vpsrlw	$4, %ymm11, %ymm14
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm10, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vpand	%ymm1, %ymm14, %ymm9
	vpmaddubsw	%ymm6, %ymm9, %ymm9
	vpaddw	%ymm7, %ymm9, %ymm7
	vmovdqa	288(%rdi), %ymm9
	vpsrlw	$4, %ymm9, %ymm11
	vpand	%ymm1, %ymm9, %ymm9
	vpmaddubsw	%ymm10, %ymm9, %ymm9
	vpaddw	%ymm9, %ymm13, %ymm9
	vpaddw	%ymm9, %ymm12, %ymm9
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm6, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm9, %ymm9
	vmovdqa	320(%rdi), %ymm11
	vpsrlw	$4, %ymm11, %ymm12
	vpand	%ymm1, %ymm11, %ymm11
	vpmaddubsw	%ymm10, %ymm11, %ymm11
	vpaddw	%ymm11, %ymm8, %ymm8
	vpaddw	%ymm5, %ymm8, %ymm5
	vpand	%ymm1, %ymm12, %ymm8
	vpmaddubsw	%ymm6, %ymm8, %ymm8
	vpaddw	%ymm5, %ymm8, %ymm5
	vmovdqa	352(%rdi), %ymm8
	vpsrlw	$4, %ymm8, %ymm11
	vpand	%ymm1, %ymm8, %ymm8
	vpmaddubsw	%ymm10, %ymm8, %ymm8
	vpaddw	%ymm4, %ymm8, %ymm4
	vpaddw	%ymm4, %ymm3, %ymm3
	vpand	%ymm1, %ymm11, %ymm4
	vpmaddubsw	%ymm6, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm3, %ymm3
	vpmaddwd	%ymm2, %ymm7, %ymm4
	vpmaddwd	%ymm2, %ymm9, %ymm6
	vphaddd	%ymm6, %ymm4, %ymm4
	vpmaddwd	%ymm2, %ymm5, %ymm5
	vpmaddwd	%ymm2, %ymm3, %ymm3
	vphaddd	%ymm3, %ymm5, %ymm3
	vphaddd	%ymm3, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpaddd	%xmm3, %xmm0, %xmm3
	vpaddd	%xmm4, %xmm3, %xmm3
	movl	%edx, %r8d
	andl	$-4, %r8d
	vmovdqu	%xmm3, (%rcx,%r8,4)
	addq	$4, %rdx
	addq	$416, %rdi                      # imm = 0x1A0
	cmpq	%rdx, %rax
	jne	.LBB8_7
.LBB8_16:
	addq	$56, %rsp
	vzeroupper
	retq
.LBB8_17:
	movl	$.L.str.14, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end8:
	.size	_ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi, .Lfunc_end8-_ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi
	.section	.rodata._ZN3fx23opt16qgemv_packed_i32ERKNS0_7QPackedEPKaiPi,"a",@progbits
	.p2align	3, 0x0
.LJTI8_0:
	.quad	.LBB8_2
	.quad	.LBB8_17
	.quad	.LBB8_5
	.quad	.LBB8_8
	.quad	.LBB8_17
	.quad	.LBB8_17
	.quad	.LBB8_17
	.quad	.LBB8_17
	.quad	.LBB8_17
	.quad	.LBB8_17
	.quad	.LBB8_17
	.quad	.LBB8_11
                                        # -- End function
	.section	.text._ZN3fx23opt12qdense_bytesEii,"ax",@progbits
	.globl	_ZN3fx23opt12qdense_bytesEii    # -- Begin function _ZN3fx23opt12qdense_bytesEii
	.p2align	4, 0x90
	.type	_ZN3fx23opt12qdense_bytesEii,@function
_ZN3fx23opt12qdense_bytesEii:           # @_ZN3fx23opt12qdense_bytesEii
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
                                        # kill: def $edi killed $edi def $rdi
	xorl	%ecx, %ecx
	cmpl	$257, %esi                      # imm = 0x101
	setl	%cl
	leal	4(,%rcx,4), %r8d
	leal	31(%rsi), %eax
	addl	$62, %esi
	testl	%eax, %eax
	cmovnsl	%eax, %esi
	andl	$-32, %esi
	leal	(%rdi,%rcx,4), %eax
	addl	$3, %eax
	cltd
	idivl	%r8d
	movq	%rcx, %rdx
	shlq	$5, %rdx
	movslq	%esi, %rsi
	orb	$2, %cl
	shlxq	%rcx, %rsi, %rcx
	movzbl	_ZN3fx23opt12_GLOBAL__N_18g_packedE(%rip), %esi
	shrxq	%rsi, %rcx, %rcx
	addq	%rdx, %rcx
	addq	$32, %rcx
	cltq
	imulq	%rcx, %rax
	retq
.Lfunc_end9:
	.size	_ZN3fx23opt12qdense_bytesEii, .Lfunc_end9-_ZN3fx23opt12qdense_bytesEii
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt12qdense_buildEPhPKaPKfiib
.LCPI10_0:
	.zero	32,119
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI10_1:
	.zero	4,119
	.section	.text._ZN3fx23opt12qdense_buildEPhPKaPKfiib,"ax",@progbits
	.globl	_ZN3fx23opt12qdense_buildEPhPKaPKfiib
	.p2align	4, 0x90
	.type	_ZN3fx23opt12qdense_buildEPhPKaPKfiib,@function
_ZN3fx23opt12qdense_buildEPhPKaPKfiib:  # @_ZN3fx23opt12qdense_buildEPhPKaPKfiib
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$152, %rsp
                                        # kill: def $r9d killed $r9d def $r9
                                        # kill: def $r8d killed $r8d def $r8
	movq	%rcx, 32(%rsp)                  # 8-byte Spill
	movq	%rdx, 16(%rsp)                  # 8-byte Spill
	testb	$63, %sil
	jne	.LBB10_76
# %bb.1:
	movq	%rsi, (%rdi)
	movl	%r8d, 8(%rdi)
	movl	%r9d, 12(%rdi)
	leal	31(%r9), %eax
	leal	62(%r9), %r14d
	testl	%eax, %eax
	cmovnsl	%eax, %r14d
	movl	%r14d, %ecx
	andl	$-32, %ecx
	movl	%ecx, 16(%rdi)
	sarl	$5, %r14d
	movl	%r14d, 20(%rdi)
	xorl	%r10d, %r10d
	cmpl	$257, %r9d                      # imm = 0x101
	setl	%r10b
	leal	4(,%r10,4), %ebx
	movl	%ebx, 24(%rdi)
	leal	3(%r8,%r10,4), %r11d
	movl	%r11d, %eax
	cltd
	movl	%ebx, 4(%rsp)                   # 4-byte Spill
	idivl	%ebx
	subl	%edx, %r11d
	movl	%r11d, 32(%rdi)
	movl	%eax, 28(%rdi)
	movq	%r10, %r11
	shlq	$5, %r11
	movslq	%ecx, %rcx
	orb	$2, %r10b
	shlxq	%r10, %rcx, %rcx
	movzbl	_ZN3fx23opt12_GLOBAL__N_18g_packedE(%rip), %edx
	shrxq	%rdx, %rcx, %rcx
	leaq	(%rcx,%r11), %r12
	addq	$32, %r12
	cltq
	movq	%r12, %rcx
	imulq	%rax, %rcx
	movq	%rcx, 40(%rdi)
	movb	%dl, 48(%rdi)
	testl	%eax, %eax
	jle	.LBB10_33
# %bb.2:
	movq	%r11, %r10
	addq	$32, %r10
	xorl	%eax, %eax
	cmpl	$257, %r9d                      # imm = 0x101
	setl	%al
	movq	%r10, 72(%rsp)                  # 8-byte Spill
                                        # kill: def $r10d killed $r10d killed $r10 def $r10
	shrl	%r10d
	movq	%r10, 48(%rsp)                  # 8-byte Spill
	orl	$2, %eax
	movl	%eax, 68(%rsp)                  # 4-byte Spill
	movslq	%r9d, %r15
	movl	4(%rsp), %eax                   # 4-byte Reload
	movl	%eax, %ecx
	shrl	%ecx
	movl	%ecx, 64(%rsp)                  # 4-byte Spill
	movslq	%r8d, %rcx
	movq	%rcx, 8(%rsp)                   # 8-byte Spill
	movl	%eax, %eax
	movq	%rax, 96(%rsp)                  # 8-byte Spill
	movl	%r9d, %r11d
	movl	%r11d, %eax
	andl	$-32, %eax
	movq	%rax, 144(%rsp)                 # 8-byte Spill
	leaq	4(%rsi), %rdx
	movq	16(%rsp), %rax                  # 8-byte Reload
	leaq	24(%rax), %rcx
	movq	%rcx, 104(%rsp)                 # 8-byte Spill
	incq	%rax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	xorl	%ecx, %ecx
	vxorps	%xmm0, %xmm0, %xmm0
	vbroadcastss	.LCPI10_1(%rip), %ymm1  # ymm1 = [119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119]
	movq	%rdi, 24(%rsp)                  # 8-byte Spill
	movq	%rsi, 120(%rsp)                 # 8-byte Spill
	movq	%r12, 112(%rsp)                 # 8-byte Spill
	movq	%r11, 88(%rsp)                  # 8-byte Spill
	jmp	.LBB10_3
	.p2align	4, 0x90
.LBB10_32:                              #   in Loop: Header=BB10_3 Depth=1
	movq	128(%rsp), %rcx                 # 8-byte Reload
	incq	%rcx
	movslq	28(%rdi), %rax
	movq	112(%rsp), %r12                 # 8-byte Reload
	movq	136(%rsp), %rdx                 # 8-byte Reload
	addq	%r12, %rdx
	cmpq	%rax, %rcx
	movq	120(%rsp), %rsi                 # 8-byte Reload
	jge	.LBB10_33
.LBB10_3:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB10_5 Depth 2
                                        #     Child Loop BB10_20 Depth 2
                                        #       Child Loop BB10_25 Depth 3
                                        #       Child Loop BB10_27 Depth 3
                                        #     Child Loop BB10_13 Depth 2
                                        #       Child Loop BB10_14 Depth 3
                                        #         Child Loop BB10_17 Depth 4
                                        #         Child Loop BB10_43 Depth 4
                                        #         Child Loop BB10_53 Depth 4
                                        #     Child Loop BB10_62 Depth 2
                                        #       Child Loop BB10_63 Depth 3
                                        #         Child Loop BB10_65 Depth 4
	movq	%r14, 80(%rsp)                  # 8-byte Spill
	imulq	%rcx, %r12
	addq	%rsi, %r12
	movl	68(%rsp), %eax                  # 4-byte Reload
	movq	%rcx, 128(%rsp)                 # 8-byte Spill
	shlxl	%eax, %ecx, %r10d
	movslq	%r10d, %rax
	cmpb	$0, 208(%rsp)
	movq	%rdx, 136(%rsp)                 # 8-byte Spill
	je	.LBB10_4
# %bb.19:                               #   in Loop: Header=BB10_3 Depth=1
	movq	48(%rsp), %rcx                  # 8-byte Reload
	addq	%r12, %rcx
	movq	%rcx, 40(%rsp)                  # 8-byte Spill
	movq	%r15, %rdi
	imulq	%rax, %rdi
	movq	104(%rsp), %rcx                 # 8-byte Reload
	leaq	(%rcx,%rdi), %r13
	addq	16(%rsp), %rdi                  # 8-byte Folded Reload
	xorl	%ebp, %ebp
	movl	4(%rsp), %esi                   # 4-byte Reload
	jmp	.LBB10_20
	.p2align	4, 0x90
.LBB10_30:                              #   in Loop: Header=BB10_20 Depth=2
	movq	40(%rsp), %rcx                  # 8-byte Reload
	vmovd	%xmm2, (%rcx,%rbp,4)
	incq	%rbp
	addq	%r15, %r13
	addq	%r15, %rdi
	cmpq	96(%rsp), %rbp                  # 8-byte Folded Reload
	je	.LBB10_10
.LBB10_20:                              #   Parent Loop BB10_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB10_25 Depth 3
                                        #       Child Loop BB10_27 Depth 3
	leaq	(%rax,%rbp), %rcx
	xorl	%edx, %edx
	cmpq	8(%rsp), %rcx                   # 8-byte Folded Reload
	jge	.LBB10_28
# %bb.21:                               #   in Loop: Header=BB10_20 Depth=2
	testl	%r9d, %r9d
	jle	.LBB10_28
# %bb.22:                               #   in Loop: Header=BB10_20 Depth=2
	cmpl	$32, %r9d
	jae	.LBB10_24
# %bb.23:                               #   in Loop: Header=BB10_20 Depth=2
	xorl	%ebx, %ebx
	xorl	%edx, %edx
	movq	88(%rsp), %r11                  # 8-byte Reload
	jmp	.LBB10_27
	.p2align	4, 0x90
.LBB10_24:                              #   in Loop: Header=BB10_20 Depth=2
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%edx, %edx
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	movq	144(%rsp), %r11                 # 8-byte Reload
	.p2align	4, 0x90
.LBB10_25:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_20 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	vpmovsxbd	-24(%r13,%rdx), %ymm6
	vpaddd	%ymm6, %ymm2, %ymm2
	vpmovsxbd	-16(%r13,%rdx), %ymm6
	vpaddd	%ymm6, %ymm3, %ymm3
	vpmovsxbd	-8(%r13,%rdx), %ymm6
	vpmovsxbd	(%r13,%rdx), %ymm7
	vpaddd	%ymm6, %ymm4, %ymm4
	vpaddd	%ymm7, %ymm5, %ymm5
	addq	$32, %rdx
	cmpq	%rdx, %r11
	jne	.LBB10_25
# %bb.26:                               #   in Loop: Header=BB10_20 Depth=2
	vpaddd	%ymm2, %ymm3, %ymm2
	vpaddd	%ymm2, %ymm4, %ymm2
	vpaddd	%ymm2, %ymm5, %ymm2
	vextracti128	$1, %ymm2, %xmm3
	vpaddd	%xmm3, %xmm2, %xmm2
	vpshufd	$238, %xmm2, %xmm3              # xmm3 = xmm2[2,3,2,3]
	vpaddd	%xmm3, %xmm2, %xmm2
	vpshufd	$85, %xmm2, %xmm3               # xmm3 = xmm2[1,1,1,1]
	vpaddd	%xmm3, %xmm2, %xmm2
	vmovd	%xmm2, %edx
	movq	%r11, %rbx
	movq	%r11, %r14
	movq	88(%rsp), %r11                  # 8-byte Reload
	cmpq	%r11, %r14
	je	.LBB10_28
	.p2align	4, 0x90
.LBB10_27:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_20 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movsbl	(%rdi,%rbx), %r14d
	addl	%r14d, %edx
	incq	%rbx
	cmpq	%rbx, %r11
	jne	.LBB10_27
.LBB10_28:                              #   in Loop: Header=BB10_20 Depth=2
	shll	$7, %edx
	movl	%edx, (%r12,%rbp,4)
	vpxor	%xmm2, %xmm2, %xmm2
	cmpq	8(%rsp), %rcx                   # 8-byte Folded Reload
	jge	.LBB10_30
# %bb.29:                               #   in Loop: Header=BB10_20 Depth=2
	movq	32(%rsp), %rdx                  # 8-byte Reload
	vmovd	(%rdx,%rcx,4), %xmm2            # xmm2 = mem[0],zero,zero,zero
	jmp	.LBB10_30
	.p2align	4, 0x90
.LBB10_4:                               #   in Loop: Header=BB10_3 Depth=1
	incq	%rax
	movq	96(%rsp), %rcx                  # 8-byte Reload
	movl	4(%rsp), %esi                   # 4-byte Reload
	jmp	.LBB10_5
	.p2align	4, 0x90
.LBB10_9:                               #   in Loop: Header=BB10_5 Depth=2
	movq	48(%rsp), %rdi                  # 8-byte Reload
	vmovd	%xmm2, (%rdx,%rdi)
	addq	$2, %rax
	addq	$8, %rdx
	addq	$-2, %rcx
	je	.LBB10_10
.LBB10_5:                               #   Parent Loop BB10_3 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	leaq	-1(%rax), %rdi
	movl	$0, -4(%rdx)
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	cmpq	8(%rsp), %rdi                   # 8-byte Folded Reload
	jge	.LBB10_7
# %bb.6:                                #   in Loop: Header=BB10_5 Depth=2
	movq	32(%rsp), %rdi                  # 8-byte Reload
	vmovd	-4(%rdi,%rax,4), %xmm3          # xmm3 = mem[0],zero,zero,zero
.LBB10_7:                               #   in Loop: Header=BB10_5 Depth=2
	movq	48(%rsp), %rdi                  # 8-byte Reload
	vmovd	%xmm3, -4(%rdx,%rdi)
	movl	$0, (%rdx)
	cmpq	8(%rsp), %rax                   # 8-byte Folded Reload
	jge	.LBB10_9
# %bb.8:                                #   in Loop: Header=BB10_5 Depth=2
	movq	32(%rsp), %rdi                  # 8-byte Reload
	vmovd	(%rdi,%rax,4), %xmm2            # xmm2 = mem[0],zero,zero,zero
	jmp	.LBB10_9
	.p2align	4, 0x90
.LBB10_10:                              #   in Loop: Header=BB10_3 Depth=1
	movq	24(%rsp), %rdi                  # 8-byte Reload
	cmpb	$0, 48(%rdi)
	je	.LBB10_60
# %bb.11:                               #   in Loop: Header=BB10_3 Depth=1
	movq	80(%rsp), %r14                  # 8-byte Reload
	testl	%r14d, %r14d
	jle	.LBB10_32
# %bb.12:                               #   in Loop: Header=BB10_3 Depth=1
	addq	72(%rsp), %r12                  # 8-byte Folded Reload
	xorl	%eax, %eax
	movl	64(%rsp), %esi                  # 4-byte Reload
	jmp	.LBB10_13
	.p2align	4, 0x90
.LBB10_31:                              #   in Loop: Header=BB10_13 Depth=2
	movq	40(%rsp), %rax                  # 8-byte Reload
	incq	%rax
	movq	24(%rsp), %rdi                  # 8-byte Reload
	movslq	20(%rdi), %r14
	cmpq	%r14, %rax
	jge	.LBB10_32
.LBB10_13:                              #   Parent Loop BB10_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB10_14 Depth 3
                                        #         Child Loop BB10_17 Depth 4
                                        #         Child Loop BB10_43 Depth 4
                                        #         Child Loop BB10_53 Depth 4
	movq	%rax, 40(%rsp)                  # 8-byte Spill
                                        # kill: def $eax killed $eax killed $rax def $rax
	shll	$5, %eax
	movq	16(%rsp), %rcx                  # 8-byte Reload
	leaq	(%rcx,%rax), %rdi
	xorl	%ecx, %ecx
	jmp	.LBB10_14
	.p2align	4, 0x90
.LBB10_34:                              #   in Loop: Header=BB10_14 Depth=3
	vmovups	%ymm1, (%r12)
	addq	$32, %r12
.LBB10_51:                              #   in Loop: Header=BB10_14 Depth=3
	incl	%ecx
	cmpl	%esi, %ecx
	je	.LBB10_31
.LBB10_14:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_13 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB10_17 Depth 4
                                        #         Child Loop BB10_43 Depth 4
                                        #         Child Loop BB10_53 Depth 4
	leal	(%r10,%rcx,2), %edx
	movl	%edx, %ebx
	orl	$1, %ebx
	movslq	%edx, %r13
	imulq	%r15, %r13
	cmpl	%r8d, %ebx
	jge	.LBB10_15
# %bb.41:                               #   in Loop: Header=BB10_14 Depth=3
	movslq	%ebx, %rbp
	imulq	%r15, %rbp
	cmpl	%r8d, %edx
	jge	.LBB10_42
# %bb.52:                               #   in Loop: Header=BB10_14 Depth=3
	addq	%rdi, %rbp
	addq	%rdi, %r13
	xorl	%r14d, %r14d
	jmp	.LBB10_53
	.p2align	4, 0x90
.LBB10_54:                              #   in Loop: Header=BB10_53 Depth=4
	movb	$112, %bl
	xorl	%edx, %edx
.LBB10_58:                              #   in Loop: Header=BB10_53 Depth=4
	addb	$7, %dl
	orb	%bl, %dl
	movb	%dl, (%r12,%r14)
	incq	%r14
	cmpq	$32, %r14
	je	.LBB10_59
.LBB10_53:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_13 Depth=2
                                        #       Parent Loop BB10_14 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	leal	(%rax,%r14), %edx
	cmpl	%r9d, %edx
	jge	.LBB10_54
# %bb.55:                               #   in Loop: Header=BB10_53 Depth=4
	movzbl	(%rbp,%r14), %ebx
	leal	-8(%rbx), %edx
	cmpb	$-16, %dl
	jbe	.LBB10_77
# %bb.56:                               #   in Loop: Header=BB10_53 Depth=4
	movzbl	(%r13,%r14), %edx
	leal	-8(%rdx), %r11d
	cmpb	$-16, %r11b
	jbe	.LBB10_77
# %bb.57:                               #   in Loop: Header=BB10_53 Depth=4
	shlb	$4, %bl
	addb	$112, %bl
	jmp	.LBB10_58
	.p2align	4, 0x90
.LBB10_15:                              #   in Loop: Header=BB10_14 Depth=3
	cmpl	%r8d, %edx
	jge	.LBB10_34
# %bb.16:                               #   in Loop: Header=BB10_14 Depth=3
	addq	56(%rsp), %r13                  # 8-byte Folded Reload
	movq	%rax, %r14
	xorl	%ebp, %ebp
	jmp	.LBB10_17
	.p2align	4, 0x90
.LBB10_37:                              #   in Loop: Header=BB10_17 Depth=4
	xorl	%edx, %edx
.LBB10_39:                              #   in Loop: Header=BB10_17 Depth=4
	addb	$7, %dl
	orb	$112, %dl
	movb	%dl, 1(%r12,%rbp)
	addq	$2, %rbp
	addq	$2, %r14
	cmpq	$32, %rbp
	je	.LBB10_40
.LBB10_17:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_13 Depth=2
                                        #       Parent Loop BB10_14 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	cmpl	%r9d, %r14d
	jge	.LBB10_18
# %bb.35:                               #   in Loop: Header=BB10_17 Depth=4
	movzbl	-1(%r13,%r14), %edx
	leal	-8(%rdx), %ebx
	cmpb	$-15, %bl
	jae	.LBB10_36
	jmp	.LBB10_77
	.p2align	4, 0x90
.LBB10_18:                              #   in Loop: Header=BB10_17 Depth=4
	xorl	%edx, %edx
.LBB10_36:                              #   in Loop: Header=BB10_17 Depth=4
	addb	$7, %dl
	orb	$112, %dl
	movb	%dl, (%r12,%rbp)
	leal	1(%r14), %edx
	cmpl	%r9d, %edx
	jge	.LBB10_37
# %bb.38:                               #   in Loop: Header=BB10_17 Depth=4
	movzbl	(%r13,%r14), %edx
	leal	-8(%rdx), %ebx
	cmpb	$-15, %bl
	jae	.LBB10_39
	jmp	.LBB10_77
	.p2align	4, 0x90
.LBB10_42:                              #   in Loop: Header=BB10_14 Depth=3
	addq	56(%rsp), %rbp                  # 8-byte Folded Reload
	movq	%rax, %r14
	xorl	%r13d, %r13d
	jmp	.LBB10_43
	.p2align	4, 0x90
.LBB10_47:                              #   in Loop: Header=BB10_43 Depth=4
	xorl	%edx, %edx
.LBB10_49:                              #   in Loop: Header=BB10_43 Depth=4
	shlb	$4, %dl
	addb	$119, %dl
	movb	%dl, 1(%r12,%r13)
	addq	$2, %r13
	addq	$2, %r14
	cmpq	$32, %r13
	je	.LBB10_50
.LBB10_43:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_13 Depth=2
                                        #       Parent Loop BB10_14 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	cmpl	%r9d, %r14d
	jge	.LBB10_44
# %bb.45:                               #   in Loop: Header=BB10_43 Depth=4
	movzbl	-1(%rbp,%r14), %edx
	leal	-8(%rdx), %ebx
	cmpb	$-15, %bl
	jae	.LBB10_46
	jmp	.LBB10_77
	.p2align	4, 0x90
.LBB10_44:                              #   in Loop: Header=BB10_43 Depth=4
	xorl	%edx, %edx
.LBB10_46:                              #   in Loop: Header=BB10_43 Depth=4
	shlb	$4, %dl
	addb	$119, %dl
	movb	%dl, (%r12,%r13)
	leal	1(%r14), %edx
	cmpl	%r9d, %edx
	jge	.LBB10_47
# %bb.48:                               #   in Loop: Header=BB10_43 Depth=4
	movzbl	(%rbp,%r14), %edx
	leal	-8(%rdx), %ebx
	cmpb	$-15, %bl
	jae	.LBB10_49
	jmp	.LBB10_77
	.p2align	4, 0x90
.LBB10_59:                              #   in Loop: Header=BB10_14 Depth=3
	addq	%r14, %r12
	jmp	.LBB10_51
	.p2align	4, 0x90
.LBB10_40:                              #   in Loop: Header=BB10_14 Depth=3
	addq	%rbp, %r12
	jmp	.LBB10_51
	.p2align	4, 0x90
.LBB10_50:                              #   in Loop: Header=BB10_14 Depth=3
	addq	%r13, %r12
	jmp	.LBB10_51
	.p2align	4, 0x90
.LBB10_60:                              #   in Loop: Header=BB10_3 Depth=1
	movq	80(%rsp), %r14                  # 8-byte Reload
	testl	%r14d, %r14d
	jle	.LBB10_32
# %bb.61:                               #   in Loop: Header=BB10_3 Depth=1
	addq	72(%rsp), %r12                  # 8-byte Folded Reload
	xorl	%eax, %eax
	jmp	.LBB10_62
	.p2align	4, 0x90
.LBB10_70:                              #   in Loop: Header=BB10_62 Depth=2
	incq	%rax
	movq	24(%rsp), %rdi                  # 8-byte Reload
	movslq	20(%rdi), %r14
	cmpq	%r14, %rax
	jge	.LBB10_32
.LBB10_62:                              #   Parent Loop BB10_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB10_63 Depth 3
                                        #         Child Loop BB10_65 Depth 4
	movl	%eax, %ecx
	andl	$134217727, %ecx                # imm = 0x7FFFFFF
	shlq	$5, %rcx
	xorl	%edi, %edi
	jmp	.LBB10_63
	.p2align	4, 0x90
.LBB10_67:                              #   in Loop: Header=BB10_63 Depth=3
	vmovups	%ymm0, (%r12)
	addq	$32, %r12
	incl	%edi
	cmpl	%esi, %edi
	je	.LBB10_70
.LBB10_63:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_62 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB10_65 Depth 4
	leal	(%rdi,%r10), %edx
	cmpl	%r8d, %edx
	jge	.LBB10_67
# %bb.64:                               #   in Loop: Header=BB10_63 Depth=3
	movslq	%edx, %rdx
	imulq	%r15, %rdx
	addq	56(%rsp), %rdx                  # 8-byte Folded Reload
	movq	%rcx, %r13
	xorl	%r14d, %r14d
	jmp	.LBB10_65
	.p2align	4, 0x90
.LBB10_73:                              #   in Loop: Header=BB10_65 Depth=4
	xorl	%ebx, %ebx
.LBB10_75:                              #   in Loop: Header=BB10_65 Depth=4
	movb	%bl, 1(%r12,%r14)
	addq	$2, %r14
	addq	$2, %r13
	cmpq	$32, %r14
	je	.LBB10_68
.LBB10_65:                              #   Parent Loop BB10_3 Depth=1
                                        #     Parent Loop BB10_62 Depth=2
                                        #       Parent Loop BB10_63 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	cmpl	%r9d, %r13d
	jge	.LBB10_66
# %bb.71:                               #   in Loop: Header=BB10_65 Depth=4
	movzbl	-1(%rdx,%r13), %ebx
	leal	-8(%rbx), %r11d
	cmpb	$-16, %r11b
	jbe	.LBB10_77
# %bb.72:                               #   in Loop: Header=BB10_65 Depth=4
	movb	%bl, (%r12,%r14)
	leal	1(%r13), %r11d
	cmpl	%r9d, %r11d
	jge	.LBB10_73
	jmp	.LBB10_74
	.p2align	4, 0x90
.LBB10_66:                              #   in Loop: Header=BB10_65 Depth=4
	xorl	%ebx, %ebx
	movb	%bl, (%r12,%r14)
	leal	1(%r13), %r11d
	cmpl	%r9d, %r11d
	jge	.LBB10_73
.LBB10_74:                              #   in Loop: Header=BB10_65 Depth=4
	movzbl	(%rdx,%r13), %ebx
	leal	-8(%rbx), %r11d
	cmpb	$-15, %r11b
	jae	.LBB10_75
	jmp	.LBB10_77
	.p2align	4, 0x90
.LBB10_68:                              #   in Loop: Header=BB10_63 Depth=3
	addq	%r14, %r12
	incl	%edi
	cmpl	%esi, %edi
	jne	.LBB10_63
	jmp	.LBB10_70
.LBB10_33:
	movq	%rdi, %rax
	addq	$152, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.LBB10_77:
	movl	$.L.str.7, %edi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB10_76:
	movl	$.L.str.6, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end10:
	.size	_ZN3fx23opt12qdense_buildEPhPKaPKfiib, .Lfunc_end10-_ZN3fx23opt12qdense_buildEPhPKaPKfiib
                                        # -- End function
	.section	.text._ZN3fx23opt13qsparse_bytesEi,"ax",@progbits
	.globl	_ZN3fx23opt13qsparse_bytesEi    # -- Begin function _ZN3fx23opt13qsparse_bytesEi
	.p2align	4, 0x90
	.type	_ZN3fx23opt13qsparse_bytesEi,@function
_ZN3fx23opt13qsparse_bytesEi:           # @_ZN3fx23opt13qsparse_bytesEi
# %bb.0:
	movslq	%edi, %rax
	shlq	$6, %rax
	leaq	(%rax,%rax,2), %rax
	retq
.Lfunc_end11:
	.size	_ZN3fx23opt13qsparse_bytesEi, .Lfunc_end11-_ZN3fx23opt13qsparse_bytesEi
                                        # -- End function
	.section	.text._ZN3fx23opt13qsparse_buildEPaPfPKaPKfii,"ax",@progbits
	.globl	_ZN3fx23opt13qsparse_buildEPaPfPKaPKfii # -- Begin function _ZN3fx23opt13qsparse_buildEPaPfPKaPKfii
	.p2align	4, 0x90
	.type	_ZN3fx23opt13qsparse_buildEPaPfPKaPKfii,@function
_ZN3fx23opt13qsparse_buildEPaPfPKaPKfii: # @_ZN3fx23opt13qsparse_buildEPaPfPKaPKfii
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	cmpl	$192, %r9d
	jne	.LBB12_11
# %bb.1:
	movq	%rsi, %r15
	testb	$63, %r15b
	jne	.LBB12_12
# %bb.2:
	movq	%rdx, %r14
	movq	%rdi, %rbx
	movl	48(%rsp), %ebp
	testl	%ebp, %ebp
	jle	.LBB12_8
# %bb.3:
	movl	%ebp, %eax
	leaq	(%rax,%rax), %rdx
	xorl	%esi, %esi
	movq	%r15, %rdi
	.p2align	4, 0x90
.LBB12_4:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB12_5 Depth 2
	movl	$1, %r9d
	movq	%rcx, %r10
	.p2align	4, 0x90
.LBB12_5:                               #   Parent Loop BB12_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movzbl	(%r10), %r11d
	leal	-8(%r11), %r12d
	cmpb	$-16, %r12b
	jbe	.LBB12_6
# %bb.9:                                #   in Loop: Header=BB12_5 Depth=2
	movb	%r11b, -1(%rdi,%r9)
	movzbl	(%r10,%rax), %r11d
	leal	-8(%r11), %r12d
	cmpb	$-15, %r12b
	jb	.LBB12_6
# %bb.10:                               #   in Loop: Header=BB12_5 Depth=2
	movb	%r11b, (%rdi,%r9)
	addq	%rdx, %r10
	addq	$2, %r9
	cmpq	$193, %r9
	jne	.LBB12_5
# %bb.7:                                #   in Loop: Header=BB12_4 Depth=1
	incq	%rsi
	incq	%rcx
	addq	$192, %rdi
	cmpq	%rax, %rsi
	jne	.LBB12_4
.LBB12_8:
	movl	$768, %edx                      # imm = 0x300
	movq	%r14, %rdi
	movq	%r8, %rsi
	callq	memcpy@PLT
	movq	%r15, (%rbx)
	movq	%r14, 8(%rbx)
	movl	%ebp, 16(%rbx)
	movl	$192, 20(%rbx)
	movq	%rbx, %rax
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB12_6:
	movl	$.L.str.7, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB12_11:
	movl	$.L.str.8, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB12_12:
	movl	$.L.str.9, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end12:
	.size	_ZN3fx23opt13qsparse_buildEPaPfPKaPKfii, .Lfunc_end12-_ZN3fx23opt13qsparse_buildEPaPfPKaPKfii
                                        # -- End function
	.section	.text._ZN3fx23opt14qsparse4_bytesEi,"ax",@progbits
	.globl	_ZN3fx23opt14qsparse4_bytesEi   # -- Begin function _ZN3fx23opt14qsparse4_bytesEi
	.p2align	4, 0x90
	.type	_ZN3fx23opt14qsparse4_bytesEi,@function
_ZN3fx23opt14qsparse4_bytesEi:          # @_ZN3fx23opt14qsparse4_bytesEi
# %bb.0:
	movslq	%edi, %rax
	shlq	$7, %rax
	retq
.Lfunc_end13:
	.size	_ZN3fx23opt14qsparse4_bytesEi, .Lfunc_end13-_ZN3fx23opt14qsparse4_bytesEi
                                        # -- End function
	.section	.text._ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii,"ax",@progbits
	.globl	_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii # -- Begin function _ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii
	.p2align	4, 0x90
	.type	_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii,@function
_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii: # @_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	cmpl	$192, %r9d
	jne	.LBB14_13
# %bb.1:
	movq	%rsi, %r15
	testb	$63, %r15b
	jne	.LBB14_9
# %bb.2:
	movq	%rdx, %r14
	movq	%rdi, %rbx
	movl	64(%rsp), %ebp
	testl	%ebp, %ebp
	jle	.LBB14_12
# %bb.3:
	movl	%ebp, %eax
	movq	%rax, %rdx
	shlq	$5, %rdx
	leaq	(%rdx,%rdx,2), %rdx
	xorl	%esi, %esi
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%r15, %rdi
	.p2align	4, 0x90
.LBB14_4:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB14_5 Depth 2
	movq	%rsi, %r9
	shlq	$7, %r9
	addq	%r15, %r9
	movq	$-96, %r10
	movq	%rcx, %r11
	.p2align	4, 0x90
.LBB14_5:                               #   Parent Loop BB14_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movzbl	(%r11), %r12d
	leal	-8(%r12), %r13d
	cmpb	$-15, %r13b
	jb	.LBB14_8
# %bb.6:                                #   in Loop: Header=BB14_5 Depth=2
	movzbl	(%r11,%rdx), %r13d
	cmpb	$-7, %r13b
	jl	.LBB14_8
# %bb.7:                                #   in Loop: Header=BB14_5 Depth=2
	cmpb	$8, %r13b
	jge	.LBB14_8
# %bb.10:                               #   in Loop: Header=BB14_5 Depth=2
	addb	$7, %r12b
	shlb	$4, %r13b
	addb	$112, %r13b
	orb	%r12b, %r13b
	movb	%r13b, 96(%rdi,%r10)
	addq	%rax, %r11
	incq	%r10
	jne	.LBB14_5
# %bb.11:                               #   in Loop: Header=BB14_4 Depth=1
	vmovups	%ymm0, 96(%r9)
	incq	%rsi
	incq	%rcx
	subq	$-128, %rdi
	cmpq	%rax, %rsi
	jne	.LBB14_4
.LBB14_12:
	movl	$768, %edx                      # imm = 0x300
	movq	%r14, %rdi
	movq	%r8, %rsi
	vzeroupper
	callq	memcpy@PLT
	movq	%r15, (%rbx)
	movq	%r14, 8(%rbx)
	movl	%ebp, 16(%rbx)
	movl	$192, 20(%rbx)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB14_8:
	movl	$.L.str.7, %edi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB14_13:
	movl	$.L.str.10, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB14_9:
	movl	$.L.str.9, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end14:
	.size	_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii, .Lfunc_end14-_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii
                                        # -- End function
	.section	.text._ZN3fx23opt13qpacked_bytesEii,"ax",@progbits
	.globl	_ZN3fx23opt13qpacked_bytesEii   # -- Begin function _ZN3fx23opt13qpacked_bytesEii
	.p2align	4, 0x90
	.type	_ZN3fx23opt13qpacked_bytesEii,@function
_ZN3fx23opt13qpacked_bytesEii:          # @_ZN3fx23opt13qpacked_bytesEii
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
                                        # kill: def $edi killed $edi def $rdi
	leal	63(%rsi), %eax
	addl	$126, %esi
	testl	%eax, %eax
	cmovnsl	%eax, %esi
	andl	$-64, %esi
	leal	3(%rdi), %eax
	addl	$6, %edi
	testl	%eax, %eax
	cmovnsl	%eax, %edi
	sarl	$2, %edi
	movslq	%edi, %rcx
	movslq	%esi, %rax
	leaq	32(,%rax,2), %rax
	imulq	%rcx, %rax
	retq
.Lfunc_end15:
	.size	_ZN3fx23opt13qpacked_bytesEii, .Lfunc_end15-_ZN3fx23opt13qpacked_bytesEii
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt13qpacked_buildEPhPKaPKfii
.LCPI16_0:
	.zero	32,119
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI16_1:
	.zero	4,119
	.section	.text._ZN3fx23opt13qpacked_buildEPhPKaPKfii,"ax",@progbits
	.globl	_ZN3fx23opt13qpacked_buildEPhPKaPKfii
	.p2align	4, 0x90
	.type	_ZN3fx23opt13qpacked_buildEPhPKaPKfii,@function
_ZN3fx23opt13qpacked_buildEPhPKaPKfii:  # @_ZN3fx23opt13qpacked_buildEPhPKaPKfii
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
                                        # kill: def $r9d killed $r9d def $r9
                                        # kill: def $r8d killed $r8d def $r8
	movq	%rcx, 16(%rsp)                  # 8-byte Spill
	testb	$63, %sil
	jne	.LBB16_46
# %bb.1:
	movq	%rsi, (%rdi)
	movl	%r8d, 8(%rdi)
	movl	%r9d, 12(%rdi)
	leal	63(%r9), %eax
	leal	126(%r9), %r15d
	testl	%eax, %eax
	cmovnsl	%eax, %r15d
	movl	%r15d, %eax
	andl	$-64, %eax
	movl	%eax, 16(%rdi)
	sarl	$6, %r15d
	leal	3(%r8), %ebx
	leal	6(%r8), %ecx
	testl	%ebx, %ebx
	cmovnsl	%ebx, %ecx
	movl	%r15d, 20(%rdi)
	movl	%ecx, %r10d
	andl	$-4, %r10d
	movl	%r10d, 28(%rdi)
	sarl	$2, %ecx
	movl	%ecx, 24(%rdi)
	movl	%ecx, 12(%rsp)                  # 4-byte Spill
	movslq	%ecx, %r10
	cltq
	leaq	32(,%rax,2), %rax
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	imulq	%rax, %r10
	movq	%r10, 32(%rdi)
	cmpl	$4, %ebx
	jl	.LBB16_22
# %bb.2:
	movslq	%r9d, %rax
	movl	%r8d, %r8d
	leaq	32(%rdx), %r10
	leaq	(,%rax,4), %rbx
	movq	%rbx, 56(%rsp)                  # 8-byte Spill
	leaq	32(%rdx,%rax), %rbx
	leaq	(%rdx,%rax,2), %r14
	addq	$32, %r14
	leaq	(%rax,%rax,2), %rax
	addq	%rax, %rdx
	addq	$32, %rdx
	xorl	%ebp, %ebp
	vxorps	%xmm0, %xmm0, %xmm0
	vbroadcastss	.LCPI16_1(%rip), %ymm1  # ymm1 = [119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119,119]
	movq	%rsi, 48(%rsp)                  # 8-byte Spill
	jmp	.LBB16_3
	.p2align	4, 0x90
.LBB16_20:                              #   in Loop: Header=BB16_3 Depth=1
	movl	24(%rdi), %eax
	movl	%eax, 12(%rsp)                  # 4-byte Spill
	movq	48(%rsp), %rsi                  # 8-byte Reload
	movq	72(%rsp), %rbp                  # 8-byte Reload
.LBB16_21:                              #   in Loop: Header=BB16_3 Depth=1
	incq	%rbp
	movslq	12(%rsp), %rax                  # 4-byte Folded Reload
	movq	56(%rsp), %r12                  # 8-byte Reload
	addq	%r12, %r10
	addq	%r12, %rbx
	addq	%r12, %r14
	addq	%r12, %rdx
	cmpq	%rax, %rbp
	jge	.LBB16_22
.LBB16_3:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB16_13 Depth 2
                                        #       Child Loop BB16_15 Depth 3
                                        #       Child Loop BB16_26 Depth 3
                                        #       Child Loop BB16_33 Depth 3
                                        #       Child Loop BB16_40 Depth 3
	leaq	(,%rbp,4), %r12
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	cmpq	%r8, %r12
	jae	.LBB16_5
# %bb.4:                                #   in Loop: Header=BB16_3 Depth=1
	movq	16(%rsp), %rax                  # 8-byte Reload
	vmovss	(%rax,%r12,4), %xmm3            # xmm3 = mem[0],zero,zero,zero
.LBB16_5:                               #   in Loop: Header=BB16_3 Depth=1
	movq	64(%rsp), %r13                  # 8-byte Reload
	imulq	%rbp, %r13
	movq	%rsi, %rcx
	addq	%rsi, %r13
	vmovss	%xmm3, (%r13)
	movq	%r12, %r11
	orq	$1, %r11
	movq	%r11, %rax
	movq	%r11, 40(%rsp)                  # 8-byte Spill
	cmpq	%r8, %r11
	jae	.LBB16_7
# %bb.6:                                #   in Loop: Header=BB16_3 Depth=1
	movq	40(%rsp), %rax                  # 8-byte Reload
	movq	16(%rsp), %rsi                  # 8-byte Reload
	vmovss	(%rsi,%rax,4), %xmm2            # xmm2 = mem[0],zero,zero,zero
.LBB16_7:                               #   in Loop: Header=BB16_3 Depth=1
	vmovss	%xmm2, 4(%r13)
	movq	%r12, %rax
	orq	$2, %rax
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	movq	%rax, %r11
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	cmpq	%r8, %rax
	jae	.LBB16_9
# %bb.8:                                #   in Loop: Header=BB16_3 Depth=1
	movq	32(%rsp), %rax                  # 8-byte Reload
	movq	16(%rsp), %rsi                  # 8-byte Reload
	vmovss	(%rsi,%rax,4), %xmm3            # xmm3 = mem[0],zero,zero,zero
.LBB16_9:                               #   in Loop: Header=BB16_3 Depth=1
	vmovss	%xmm3, 8(%r13)
	movq	%r12, %rax
	orq	$3, %rax
	movq	%rax, %r11
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	cmpq	%r8, %rax
	jae	.LBB16_11
# %bb.10:                               #   in Loop: Header=BB16_3 Depth=1
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	16(%rsp), %rsi                  # 8-byte Reload
	vmovss	(%rsi,%rax,4), %xmm2            # xmm2 = mem[0],zero,zero,zero
.LBB16_11:                              #   in Loop: Header=BB16_3 Depth=1
	vmovss	%xmm2, 12(%r13)
	vmovups	%xmm0, 16(%r13)
	testl	%r15d, %r15d
	movq	%rcx, %rsi
	jle	.LBB16_21
# %bb.12:                               #   in Loop: Header=BB16_3 Depth=1
	movq	%rbp, 72(%rsp)                  # 8-byte Spill
	addq	$32, %r13
	xorl	%esi, %esi
	xorl	%ecx, %ecx
	movq	%r12, 80(%rsp)                  # 8-byte Spill
	jmp	.LBB16_13
	.p2align	4, 0x90
.LBB16_49:                              #   in Loop: Header=BB16_13 Depth=2
	vmovups	%ymm1, (%r13)
	addq	$32, %r13
.LBB16_45:                              #   in Loop: Header=BB16_13 Depth=2
	incq	%rcx
	movq	%rax, %rdi
	movslq	20(%rax), %r15
	addl	$64, %esi
	cmpq	%r15, %rcx
	movq	80(%rsp), %r12                  # 8-byte Reload
	jge	.LBB16_20
.LBB16_13:                              #   Parent Loop BB16_3 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB16_15 Depth 3
                                        #       Child Loop BB16_26 Depth 3
                                        #       Child Loop BB16_33 Depth 3
                                        #       Child Loop BB16_40 Depth 3
	movq	%rdi, %rax
	movl	%esi, %esi
	cmpq	%r8, %r12
	jae	.LBB16_23
# %bb.14:                               #   in Loop: Header=BB16_13 Depth=2
	movl	$32, %r15d
	movq	%rsi, %r11
	jmp	.LBB16_15
	.p2align	4, 0x90
.LBB16_19:                              #   in Loop: Header=BB16_15 Depth=3
	shlb	$4, %bpl
	orb	%dil, %bpl
	movb	%bpl, (%r13)
	incq	%r13
	incq	%r11
	decq	%r15
	je	.LBB16_24
.LBB16_15:                              #   Parent Loop BB16_3 Depth=1
                                        #     Parent Loop BB16_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	leal	32(%r11), %r12d
	movb	$7, %dil
	movb	$7, %bpl
	cmpl	%r9d, %r12d
	jge	.LBB16_17
# %bb.16:                               #   in Loop: Header=BB16_15 Depth=3
	movzbl	(%r10,%r11), %ebp
	addb	$7, %bpl
.LBB16_17:                              #   in Loop: Header=BB16_15 Depth=3
	cmpl	%r9d, %r11d
	jge	.LBB16_19
# %bb.18:                               #   in Loop: Header=BB16_15 Depth=3
	movzbl	-32(%r10,%r11), %edi
	addb	$7, %dil
	jmp	.LBB16_19
	.p2align	4, 0x90
.LBB16_23:                              #   in Loop: Header=BB16_13 Depth=2
	vmovups	%ymm1, (%r13)
	addq	$32, %r13
.LBB16_24:                              #   in Loop: Header=BB16_13 Depth=2
	cmpq	%r8, 40(%rsp)                   # 8-byte Folded Reload
	jae	.LBB16_47
# %bb.25:                               #   in Loop: Header=BB16_13 Depth=2
	movl	$32, %r15d
	movq	%rsi, %r11
	jmp	.LBB16_26
	.p2align	4, 0x90
.LBB16_30:                              #   in Loop: Header=BB16_26 Depth=3
	shlb	$4, %bpl
	orb	%dil, %bpl
	movb	%bpl, (%r13)
	incq	%r13
	incq	%r11
	decq	%r15
	je	.LBB16_31
.LBB16_26:                              #   Parent Loop BB16_3 Depth=1
                                        #     Parent Loop BB16_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	leal	32(%r11), %r12d
	movb	$7, %dil
	movb	$7, %bpl
	cmpl	%r9d, %r12d
	jge	.LBB16_28
# %bb.27:                               #   in Loop: Header=BB16_26 Depth=3
	movzbl	(%rbx,%r11), %ebp
	addb	$7, %bpl
.LBB16_28:                              #   in Loop: Header=BB16_26 Depth=3
	cmpl	%r9d, %r11d
	jge	.LBB16_30
# %bb.29:                               #   in Loop: Header=BB16_26 Depth=3
	movzbl	-32(%rbx,%r11), %edi
	addb	$7, %dil
	jmp	.LBB16_30
	.p2align	4, 0x90
.LBB16_47:                              #   in Loop: Header=BB16_13 Depth=2
	vmovups	%ymm1, (%r13)
	addq	$32, %r13
.LBB16_31:                              #   in Loop: Header=BB16_13 Depth=2
	cmpq	%r8, 32(%rsp)                   # 8-byte Folded Reload
	jae	.LBB16_48
# %bb.32:                               #   in Loop: Header=BB16_13 Depth=2
	movl	$32, %r15d
	movq	%rsi, %r11
	jmp	.LBB16_33
	.p2align	4, 0x90
.LBB16_37:                              #   in Loop: Header=BB16_33 Depth=3
	shlb	$4, %bpl
	orb	%dil, %bpl
	movb	%bpl, (%r13)
	incq	%r13
	incq	%r11
	decq	%r15
	je	.LBB16_38
.LBB16_33:                              #   Parent Loop BB16_3 Depth=1
                                        #     Parent Loop BB16_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	leal	32(%r11), %r12d
	movb	$7, %dil
	movb	$7, %bpl
	cmpl	%r9d, %r12d
	jge	.LBB16_35
# %bb.34:                               #   in Loop: Header=BB16_33 Depth=3
	movzbl	(%r14,%r11), %ebp
	addb	$7, %bpl
.LBB16_35:                              #   in Loop: Header=BB16_33 Depth=3
	cmpl	%r9d, %r11d
	jge	.LBB16_37
# %bb.36:                               #   in Loop: Header=BB16_33 Depth=3
	movzbl	-32(%r14,%r11), %edi
	addb	$7, %dil
	jmp	.LBB16_37
	.p2align	4, 0x90
.LBB16_48:                              #   in Loop: Header=BB16_13 Depth=2
	vmovups	%ymm1, (%r13)
	addq	$32, %r13
.LBB16_38:                              #   in Loop: Header=BB16_13 Depth=2
	cmpq	%r8, 24(%rsp)                   # 8-byte Folded Reload
	jae	.LBB16_49
# %bb.39:                               #   in Loop: Header=BB16_13 Depth=2
	movl	$32, %r15d
	movq	%rsi, %r11
	jmp	.LBB16_40
	.p2align	4, 0x90
.LBB16_44:                              #   in Loop: Header=BB16_40 Depth=3
	shlb	$4, %bpl
	orb	%dil, %bpl
	movb	%bpl, (%r13)
	incq	%r13
	incq	%r11
	decq	%r15
	je	.LBB16_45
.LBB16_40:                              #   Parent Loop BB16_3 Depth=1
                                        #     Parent Loop BB16_13 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	leal	32(%r11), %r12d
	movb	$7, %dil
	movb	$7, %bpl
	cmpl	%r9d, %r12d
	jge	.LBB16_42
# %bb.41:                               #   in Loop: Header=BB16_40 Depth=3
	movzbl	(%rdx,%r11), %ebp
	addb	$7, %bpl
.LBB16_42:                              #   in Loop: Header=BB16_40 Depth=3
	cmpl	%r9d, %r11d
	jge	.LBB16_44
# %bb.43:                               #   in Loop: Header=BB16_40 Depth=3
	movzbl	-32(%rdx,%r11), %edi
	addb	$7, %dil
	jmp	.LBB16_44
.LBB16_22:
	movq	%rdi, %rax
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.LBB16_46:
	movl	$.L.str.6, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end16:
	.size	_ZN3fx23opt13qpacked_buildEPhPKaPKfii, .Lfunc_end16-_ZN3fx23opt13qpacked_buildEPhPKaPKfii
                                        # -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _GLOBAL__sub_I_qmat_dense.cpp
	.type	_GLOBAL__sub_I_qmat_dense.cpp,@function
_GLOBAL__sub_I_qmat_dense.cpp:          # @_GLOBAL__sub_I_qmat_dense.cpp
# %bb.0:
	pushq	%rbx
	movq	$-256, %rbx
	jmp	.LBB17_1
	.p2align	4, 0x90
.LBB17_18:                              #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %ecx
	leaq	(%rcx,%rbx,8), %rdi
	addq	$_ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048, %rdi
	movl	$7, %edx
	subl	%eax, %edx
	incq	%rdx
	xorl	%esi, %esi
	callq	memset@PLT
.LBB17_19:                              #   in Loop: Header=BB17_1 Depth=1
	incq	%rbx
	je	.LBB17_20
.LBB17_1:                               # =>This Inner Loop Header: Depth=1
	leaq	256(%rbx), %rcx
	movl	$0, %eax
	testb	$1, %cl
	jne	.LBB17_2
# %bb.3:                                #   in Loop: Header=BB17_1 Depth=1
	testb	$2, %cl
	jne	.LBB17_4
.LBB17_5:                               #   in Loop: Header=BB17_1 Depth=1
	testb	$4, %cl
	jne	.LBB17_6
.LBB17_7:                               #   in Loop: Header=BB17_1 Depth=1
	testb	$8, %cl
	jne	.LBB17_8
.LBB17_9:                               #   in Loop: Header=BB17_1 Depth=1
	testb	$16, %cl
	jne	.LBB17_10
.LBB17_11:                              #   in Loop: Header=BB17_1 Depth=1
	testb	$32, %cl
	jne	.LBB17_12
.LBB17_13:                              #   in Loop: Header=BB17_1 Depth=1
	testb	$64, %cl
	jne	.LBB17_14
.LBB17_15:                              #   in Loop: Header=BB17_1 Depth=1
	testb	%cl, %cl
	jns	.LBB17_18
	jmp	.LBB17_16
	.p2align	4, 0x90
.LBB17_2:                               #   in Loop: Header=BB17_1 Depth=1
	movb	$0, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(,%rbx,8)
	movl	$1, %eax
	testb	$2, %cl
	je	.LBB17_5
.LBB17_4:                               #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$1, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rdx,%rbx,8)
	testb	$4, %cl
	je	.LBB17_7
.LBB17_6:                               #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$2, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rdx,%rbx,8)
	testb	$8, %cl
	je	.LBB17_9
.LBB17_8:                               #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$3, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rdx,%rbx,8)
	testb	$16, %cl
	je	.LBB17_11
.LBB17_10:                              #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$4, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rdx,%rbx,8)
	testb	$32, %cl
	je	.LBB17_13
.LBB17_12:                              #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$5, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rdx,%rbx,8)
	testb	$64, %cl
	je	.LBB17_15
.LBB17_14:                              #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$6, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rdx,%rbx,8)
	testb	%cl, %cl
	jns	.LBB17_18
.LBB17_16:                              #   in Loop: Header=BB17_1 Depth=1
	movl	%eax, %ecx
	movb	$7, _ZN3fx23opt12_GLOBAL__N_18g_idxlutE+2048(%rcx,%rbx,8)
	cmpl	$7, %eax
	jae	.LBB17_19
# %bb.17:                               #   in Loop: Header=BB17_1 Depth=1
	incl	%eax
	jmp	.LBB17_18
.LBB17_20:
	movb	$0, _ZN3fx23opt12_GLOBAL__N_18g_packedE(%rip)
	movl	$.L.str.11, %edi
	callq	getenv
	testq	%rax, %rax
	je	.LBB17_21
# %bb.22:
	movzbl	(%rax), %eax
	testb	%al, %al
	setne	%cl
	cmpb	$48, %al
	setne	%al
	andb	%cl, %al
	movb	%al, _ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE(%rip)
	popq	%rbx
	retq
.LBB17_21:
	xorl	%eax, %eax
	movb	%al, _ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE(%rip)
	popq	%rbx
	retq
.Lfunc_end17:
	.size	_GLOBAL__sub_I_qmat_dense.cpp, .Lfunc_end17-_GLOBAL__sub_I_qmat_dense.cpp
                                        # -- End function
	.type	_ZN3fx23opt12_GLOBAL__N_18g_idxlutE,@object # @_ZN3fx23opt12_GLOBAL__N_18g_idxlutE
	.section	.bss._ZN3fx23opt12_GLOBAL__N_18g_idxlutE,"aw",@nobits
	.p2align	6, 0x0
_ZN3fx23opt12_GLOBAL__N_18g_idxlutE:
	.zero	2048
	.size	_ZN3fx23opt12_GLOBAL__N_18g_idxlutE, 2048

	.type	_ZN3fx23opt12_GLOBAL__N_18g_packedE,@object # @_ZN3fx23opt12_GLOBAL__N_18g_packedE
	.section	.bss._ZN3fx23opt12_GLOBAL__N_18g_packedE,"aw",@nobits
_ZN3fx23opt12_GLOBAL__N_18g_packedE:
	.byte	0                               # 0x0
	.size	_ZN3fx23opt12_GLOBAL__N_18g_packedE, 1

	.type	_ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE,@object # @_ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE
	.section	.bss._ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE,"aw",@nobits
_ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE:
	.byte	0                               # 0x0
	.size	_ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE, 1

	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"relu2q epilogue requires d_in==192"
	.size	.L.str, 35

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"relu2q epilogue requires d_out<=768"
	.size	.L.str.3, 36

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	"quant_bias epilogue requires d_in==192"
	.size	.L.str.4, 39

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"quant_bias epilogue requires d_out<=768"
	.size	.L.str.5, 40

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"arena not 64B-aligned"
	.size	.L.str.6, 22

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"weight out of [-7,7]"
	.size	.L.str.7, 21

	.type	.L.str.8,@object                # @.str.8
.L.str.8:
	.asciz	"sparse arena requires d_out==192"
	.size	.L.str.8, 33

	.type	.L.str.9,@object                # @.str.9
.L.str.9:
	.asciz	"cols not 64B-aligned"
	.size	.L.str.9, 21

	.type	.L.str.10,@object               # @.str.10
.L.str.10:
	.asciz	"sparse4 arena requires d_out==192"
	.size	.L.str.10, 34

	.type	.L.str.11,@object               # @.str.11
.L.str.11:
	.asciz	"CMIX_QMAT_PF_NTA"
	.size	.L.str.11, 17

	.type	.L.str.12,@object               # @.str.12
.L.str.12:
	.asciz	"qmat: %s\n"
	.size	.L.str.12, 10

	.type	.L.str.13,@object               # @.str.13
.L.str.13:
	.asciz	"unsupported d_in"
	.size	.L.str.13, 17

	.type	.L.str.14,@object               # @.str.14
.L.str.14:
	.asciz	"unsupported packed npair"
	.size	.L.str.14, 25

	.section	.init_array,"aw",@init_array
	.p2align	3, 0x90
	.quad	_GLOBAL__sub_I_qmat_dense.cpp
	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _GLOBAL__sub_I_qmat_dense.cpp
	.addrsig_sym _ZN3fx23opt12_GLOBAL__N_18g_idxlutE
	.addrsig_sym _ZN3fx23opt12_GLOBAL__N_18g_packedE
	.addrsig_sym _ZN3fx23opt12_GLOBAL__N_18g_pf_ntaE
