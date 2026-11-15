	.text
	.file	"act16.cpp"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt13relu2_quant16EPKffiPsPt
.LCPI0_0:
	.long	0x46fffe00                      # float 32767
	.section	.text._ZN3fx23opt13relu2_quant16EPKffiPsPt,"ax",@progbits
	.globl	_ZN3fx23opt13relu2_quant16EPKffiPsPt
	.p2align	4, 0x90
	.type	_ZN3fx23opt13relu2_quant16EPKffiPsPt,@function
_ZN3fx23opt13relu2_quant16EPKffiPsPt:   # @_ZN3fx23opt13relu2_quant16EPKffiPsPt
# %bb.0:
	testl	%esi, %esi
	jle	.LBB0_1
# %bb.5:
	vbroadcastss	%xmm0, %ymm0
	movl	%esi, %esi
	xorl	%r8d, %r8d
	vxorps	%xmm1, %xmm1, %xmm1
	vbroadcastss	.LCPI0_0(%rip), %ymm2   # ymm2 = [3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4]
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB0_6:                                # =>This Inner Loop Header: Depth=1
	movl	%eax, %r9d
	vmovups	(%rdi,%r8,4), %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vmulps	%ymm3, %ymm3, %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm4
	vmovdqu	%xmm4, (%rdx,%r8,2)
	vpcmpeqd	%ymm1, %ymm3, %ymm3
	vmovmskps	%ymm3, %eax
	notb	%al
	movzbl	%al, %eax
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_14kPosE(,%rax,8), %xmm3 # xmm3 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vmovd	%r8d, %xmm4
	vpbroadcastw	%xmm4, %xmm4
	vpaddw	%xmm3, %xmm4, %xmm3
	movl	%r9d, %r10d
	vmovdqu	%xmm3, (%rcx,%r10,2)
	popcntl	%eax, %eax
	addl	%r9d, %eax
	addq	$8, %r8
	cmpq	%rsi, %r8
	jb	.LBB0_6
# %bb.3:
	testl	%eax, %eax
	je	.LBB0_1
# %bb.4:
	movslq	%eax, %rdx
	movzwl	-2(%rcx,%rdx,2), %edx
	jmp	.LBB0_2
.LBB0_1:
	xorl	%eax, %eax
	xorl	%edx, %edx
.LBB0_2:
	movl	%eax, %esi
	vmovd	%edx, %xmm0
	vpbroadcastw	%xmm0, %xmm0
	vmovdqu	%xmm0, (%rcx,%rsi,2)
	vzeroupper
	retq
.Lfunc_end0:
	.size	_ZN3fx23opt13relu2_quant16EPKffiPsPt, .Lfunc_end0-_ZN3fx23opt13relu2_quant16EPKffiPsPt
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt12quant192_i16EPKffPs
.LCPI1_0:
	.long	0xc7000000                      # float -32768
.LCPI1_1:
	.long	0x46fffe00                      # float 32767
	.section	.text._ZN3fx23opt12quant192_i16EPKffPs,"ax",@progbits
	.globl	_ZN3fx23opt12quant192_i16EPKffPs
	.p2align	4, 0x90
	.type	_ZN3fx23opt12quant192_i16EPKffPs,@function
_ZN3fx23opt12quant192_i16EPKffPs:       # @_ZN3fx23opt12quant192_i16EPKffPs
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rdi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm2
	vbroadcastss	.LCPI1_0(%rip), %ymm1   # ymm1 = [-3.2768E+4,-3.2768E+4,-3.2768E+4,-3.2768E+4,-3.2768E+4,-3.2768E+4,-3.2768E+4,-3.2768E+4]
	vmaxps	%ymm1, %ymm2, %ymm3
	vbroadcastss	.LCPI1_1(%rip), %ymm2   # ymm2 = [3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4]
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, (%rsi)
	vmovups	32(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 16(%rsi)
	vmovups	64(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 32(%rsi)
	vmovups	96(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 48(%rsi)
	vmovups	128(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 64(%rsi)
	vmovups	160(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 80(%rsi)
	vmovups	192(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 96(%rsi)
	vmovups	224(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 112(%rsi)
	vmovups	256(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 128(%rsi)
	vmovups	288(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 144(%rsi)
	vmovups	320(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 160(%rsi)
	vmovups	352(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 176(%rsi)
	vmovups	384(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 192(%rsi)
	vmovups	416(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 208(%rsi)
	vmovups	448(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 224(%rsi)
	vmovups	480(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 240(%rsi)
	vmovups	512(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 256(%rsi)
	vmovups	544(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 272(%rsi)
	vmovups	576(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 288(%rsi)
	vmovups	608(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 304(%rsi)
	vmovups	640(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 320(%rsi)
	vmovups	672(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 336(%rsi)
	vmovups	704(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm3, %ymm3
	vextractf128	$1, %ymm3, %xmm4
	vpackssdw	%xmm4, %xmm3, %xmm3
	vmovdqu	%xmm3, 352(%rsi)
	vmovups	736(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm0
	vmaxps	%ymm1, %ymm0, %ymm0
	vminps	%ymm2, %ymm0, %ymm0
	vcvtps2dq	%ymm0, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vpackssdw	%xmm1, %xmm0, %xmm0
	vmovdqu	%xmm0, 368(%rsi)
	vzeroupper
	retq
.Lfunc_end1:
	.size	_ZN3fx23opt12quant192_i16EPKffPs, .Lfunc_end1-_ZN3fx23opt12quant192_i16EPKffPs
                                        # -- End function
	.section	.text._ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf,"ax",@progbits
	.globl	_ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf # -- Begin function _ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf,@function
_ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf: # @_ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%r9, %rbx
	movl	%r8d, %ebp
	movq	%rcx, %r14
	movq	%rdx, %r15
	movq	%rsi, %r12
	movq	%rdi, %r13
	movq	%r9, (%rsp)
	xorl	%r9d, %r9d
	callq	_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf
	movq	%rbx, (%rsp)
	movq	%r13, %rdi
	movq	%r12, %rsi
	movq	%r15, %rdx
	movq	%r14, %rcx
	movl	%ebp, %r8d
	movl	$96, %r9d
	callq	_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end2:
	.size	_ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf, .Lfunc_end2-_ZN3fx23opt10spmv16_addEPKaPKfPKsPKtiPf
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf
	.type	_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf,@function
_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf: # @_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	movl	%r9d, %eax
	cmpl	$2, %r8d
	jl	.LBB3_1
# %bb.2:
	leaq	(%rdi,%rax), %r10
	movl	%r8d, %r11d
	movl	$1, %r9d
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm11, %xmm11, %xmm11
	.p2align	4, 0x90
.LBB3_3:                                # =>This Inner Loop Header: Depth=1
	movzwl	-2(%rcx,%r9,2), %ebx
	movzwl	(%rcx,%r9,2), %r14d
	movzwl	(%rdx,%rbx,2), %ebp
	movzwl	(%rdx,%r14,2), %r15d
	shll	$16, %r15d
	orl	%ebp, %r15d
	vmovd	%r15d, %xmm12
	vpbroadcastd	%xmm12, %ymm12
	leaq	(%rbx,%rbx,2), %rbx
	shlq	$6, %rbx
	leaq	(%r14,%r14,2), %r14
	shlq	$6, %r14
	movzwl	2(%rcx,%r9,2), %r15d
	leaq	(%r15,%r15,2), %r15
	shlq	$6, %r15
	prefetcht0	(%r10,%r15)
	prefetcht0	64(%r10,%r15)
	movzwl	4(%rcx,%r9,2), %r15d
	leaq	(%r15,%r15,2), %r15
	shlq	$6, %r15
	prefetcht0	(%r10,%r15)
	prefetcht0	64(%r10,%r15)
	vpmovsxbw	(%r10,%rbx), %ymm13
	vpmovsxbw	(%r10,%r14), %ymm14
	vpunpcklwd	%ymm14, %ymm13, %ymm15  # ymm15 = ymm13[0],ymm14[0],ymm13[1],ymm14[1],ymm13[2],ymm14[2],ymm13[3],ymm14[3],ymm13[8],ymm14[8],ymm13[9],ymm14[9],ymm13[10],ymm14[10],ymm13[11],ymm14[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm10, %ymm15, %ymm10
	vpunpckhwd	%ymm14, %ymm13, %ymm13  # ymm13 = ymm13[4],ymm14[4],ymm13[5],ymm14[5],ymm13[6],ymm14[6],ymm13[7],ymm14[7],ymm13[12],ymm14[12],ymm13[13],ymm14[13],ymm13[14],ymm14[14],ymm13[15],ymm14[15]
	vpmaddwd	%ymm12, %ymm13, %ymm13
	vpaddd	%ymm11, %ymm13, %ymm11
	vpmovsxbw	16(%r10,%rbx), %ymm13
	vpmovsxbw	16(%r10,%r14), %ymm14
	vpunpcklwd	%ymm14, %ymm13, %ymm15  # ymm15 = ymm13[0],ymm14[0],ymm13[1],ymm14[1],ymm13[2],ymm14[2],ymm13[3],ymm14[3],ymm13[8],ymm14[8],ymm13[9],ymm14[9],ymm13[10],ymm14[10],ymm13[11],ymm14[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm8, %ymm15, %ymm8
	vpunpckhwd	%ymm14, %ymm13, %ymm13  # ymm13 = ymm13[4],ymm14[4],ymm13[5],ymm14[5],ymm13[6],ymm14[6],ymm13[7],ymm14[7],ymm13[12],ymm14[12],ymm13[13],ymm14[13],ymm13[14],ymm14[14],ymm13[15],ymm14[15]
	vpmaddwd	%ymm12, %ymm13, %ymm13
	vpaddd	%ymm9, %ymm13, %ymm9
	vpmovsxbw	32(%r10,%rbx), %ymm13
	vpmovsxbw	32(%r10,%r14), %ymm14
	vpunpcklwd	%ymm14, %ymm13, %ymm15  # ymm15 = ymm13[0],ymm14[0],ymm13[1],ymm14[1],ymm13[2],ymm14[2],ymm13[3],ymm14[3],ymm13[8],ymm14[8],ymm13[9],ymm14[9],ymm13[10],ymm14[10],ymm13[11],ymm14[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm6, %ymm15, %ymm6
	vpunpckhwd	%ymm14, %ymm13, %ymm13  # ymm13 = ymm13[4],ymm14[4],ymm13[5],ymm14[5],ymm13[6],ymm14[6],ymm13[7],ymm14[7],ymm13[12],ymm14[12],ymm13[13],ymm14[13],ymm13[14],ymm14[14],ymm13[15],ymm14[15]
	vpmaddwd	%ymm12, %ymm13, %ymm13
	vpaddd	%ymm7, %ymm13, %ymm7
	vpmovsxbw	48(%r10,%rbx), %ymm13
	vpmovsxbw	48(%r10,%r14), %ymm14
	vpunpcklwd	%ymm14, %ymm13, %ymm15  # ymm15 = ymm13[0],ymm14[0],ymm13[1],ymm14[1],ymm13[2],ymm14[2],ymm13[3],ymm14[3],ymm13[8],ymm14[8],ymm13[9],ymm14[9],ymm13[10],ymm14[10],ymm13[11],ymm14[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm4, %ymm15, %ymm4
	vpunpckhwd	%ymm14, %ymm13, %ymm13  # ymm13 = ymm13[4],ymm14[4],ymm13[5],ymm14[5],ymm13[6],ymm14[6],ymm13[7],ymm14[7],ymm13[12],ymm14[12],ymm13[13],ymm14[13],ymm13[14],ymm14[14],ymm13[15],ymm14[15]
	vpmaddwd	%ymm12, %ymm13, %ymm13
	vpaddd	%ymm5, %ymm13, %ymm5
	vpmovsxbw	64(%r10,%rbx), %ymm13
	vpmovsxbw	64(%r10,%r14), %ymm14
	vpunpcklwd	%ymm14, %ymm13, %ymm15  # ymm15 = ymm13[0],ymm14[0],ymm13[1],ymm14[1],ymm13[2],ymm14[2],ymm13[3],ymm14[3],ymm13[8],ymm14[8],ymm13[9],ymm14[9],ymm13[10],ymm14[10],ymm13[11],ymm14[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm2, %ymm15, %ymm2
	vpunpckhwd	%ymm14, %ymm13, %ymm13  # ymm13 = ymm13[4],ymm14[4],ymm13[5],ymm14[5],ymm13[6],ymm14[6],ymm13[7],ymm14[7],ymm13[12],ymm14[12],ymm13[13],ymm14[13],ymm13[14],ymm14[14],ymm13[15],ymm14[15]
	vpmaddwd	%ymm12, %ymm13, %ymm13
	vpaddd	%ymm3, %ymm13, %ymm3
	vpmovsxbw	80(%r10,%rbx), %ymm13
	vpmovsxbw	80(%r10,%r14), %ymm14
	vpunpcklwd	%ymm14, %ymm13, %ymm15  # ymm15 = ymm13[0],ymm14[0],ymm13[1],ymm14[1],ymm13[2],ymm14[2],ymm13[3],ymm14[3],ymm13[8],ymm14[8],ymm13[9],ymm14[9],ymm13[10],ymm14[10],ymm13[11],ymm14[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm0, %ymm15, %ymm0
	vpunpckhwd	%ymm14, %ymm13, %ymm13  # ymm13 = ymm13[4],ymm14[4],ymm13[5],ymm14[5],ymm13[6],ymm14[6],ymm13[7],ymm14[7],ymm13[12],ymm14[12],ymm13[13],ymm14[13],ymm13[14],ymm14[14],ymm13[15],ymm14[15]
	vpmaddwd	%ymm12, %ymm13, %ymm12
	vpaddd	%ymm1, %ymm12, %ymm1
	addq	$2, %r9
	cmpq	%r11, %r9
	jb	.LBB3_3
# %bb.4:
	decl	%r9d
	movq	40(%rsp), %r10
	cmpl	%r8d, %r9d
	jl	.LBB3_6
	jmp	.LBB3_7
.LBB3_1:
	xorl	%r9d, %r9d
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm11, %xmm11, %xmm11
	movq	40(%rsp), %r10
	cmpl	%r8d, %r9d
	jge	.LBB3_7
.LBB3_6:
	movl	%r9d, %r8d
	movzwl	(%rcx,%r8,2), %ecx
	movzwl	(%rdx,%rcx,2), %edx
	vmovd	%edx, %xmm12
	leaq	(%rcx,%rcx,2), %rcx
	shlq	$6, %rcx
	addq	%rcx, %rdi
	vpmovsxbw	(%rax,%rdi), %ymm14
	vpbroadcastd	%xmm12, %ymm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpunpcklwd	%ymm13, %ymm14, %ymm15  # ymm15 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm10, %ymm15, %ymm10
	vpunpckhwd	%ymm13, %ymm14, %ymm14  # ymm14 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpmaddwd	%ymm12, %ymm14, %ymm14
	vpaddd	%ymm11, %ymm14, %ymm11
	vpmovsxbw	16(%rax,%rdi), %ymm14
	vpunpcklwd	%ymm13, %ymm14, %ymm15  # ymm15 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm8, %ymm15, %ymm8
	vpunpckhwd	%ymm13, %ymm14, %ymm14  # ymm14 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpmaddwd	%ymm12, %ymm14, %ymm14
	vpaddd	%ymm9, %ymm14, %ymm9
	vpmovsxbw	32(%rax,%rdi), %ymm14
	vpunpcklwd	%ymm13, %ymm14, %ymm15  # ymm15 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm6, %ymm15, %ymm6
	vpunpckhwd	%ymm13, %ymm14, %ymm14  # ymm14 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpmaddwd	%ymm12, %ymm14, %ymm14
	vpaddd	%ymm7, %ymm14, %ymm7
	vpmovsxbw	48(%rax,%rdi), %ymm14
	vpunpcklwd	%ymm13, %ymm14, %ymm15  # ymm15 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm4, %ymm15, %ymm4
	vpunpckhwd	%ymm13, %ymm14, %ymm14  # ymm14 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpmaddwd	%ymm12, %ymm14, %ymm14
	vpaddd	%ymm5, %ymm14, %ymm5
	vpmovsxbw	64(%rax,%rdi), %ymm14
	vpunpcklwd	%ymm13, %ymm14, %ymm15  # ymm15 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm2, %ymm15, %ymm2
	vpunpckhwd	%ymm13, %ymm14, %ymm14  # ymm14 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpmaddwd	%ymm12, %ymm14, %ymm14
	vpaddd	%ymm3, %ymm14, %ymm3
	vpmovsxbw	80(%rax,%rdi), %ymm14
	vpunpcklwd	%ymm13, %ymm14, %ymm15  # ymm15 = ymm14[0],ymm13[0],ymm14[1],ymm13[1],ymm14[2],ymm13[2],ymm14[3],ymm13[3],ymm14[8],ymm13[8],ymm14[9],ymm13[9],ymm14[10],ymm13[10],ymm14[11],ymm13[11]
	vpmaddwd	%ymm12, %ymm15, %ymm15
	vpaddd	%ymm0, %ymm15, %ymm0
	vpunpckhwd	%ymm13, %ymm14, %ymm13  # ymm13 = ymm14[4],ymm13[4],ymm14[5],ymm13[5],ymm14[6],ymm13[6],ymm14[7],ymm13[7],ymm14[12],ymm13[12],ymm14[13],ymm13[13],ymm14[14],ymm13[14],ymm14[15],ymm13[15]
	vpmaddwd	%ymm12, %ymm13, %ymm12
	vpaddd	%ymm1, %ymm12, %ymm1
.LBB3_7:
	vinserti128	$1, %xmm11, %ymm10, %ymm12
	vperm2i128	$49, %ymm11, %ymm10, %ymm10 # ymm10 = ymm10[2,3],ymm11[2,3]
	vcvtdq2ps	%ymm12, %ymm11
	vmulps	(%rsi,%rax,4), %ymm11, %ymm11
	vaddps	(%r10,%rax,4), %ymm11, %ymm11
	vmovups	%ymm11, (%r10,%rax,4)
	vcvtdq2ps	%ymm10, %ymm10
	vmulps	32(%rsi,%rax,4), %ymm10, %ymm10
	vaddps	32(%r10,%rax,4), %ymm10, %ymm10
	vmovups	%ymm10, 32(%r10,%rax,4)
	vinserti128	$1, %xmm9, %ymm8, %ymm10
	vperm2i128	$49, %ymm9, %ymm8, %ymm8 # ymm8 = ymm8[2,3],ymm9[2,3]
	vcvtdq2ps	%ymm10, %ymm9
	vmulps	64(%rsi,%rax,4), %ymm9, %ymm9
	vaddps	64(%r10,%rax,4), %ymm9, %ymm9
	vmovups	%ymm9, 64(%r10,%rax,4)
	vcvtdq2ps	%ymm8, %ymm8
	vmulps	96(%rsi,%rax,4), %ymm8, %ymm8
	vaddps	96(%r10,%rax,4), %ymm8, %ymm8
	vmovups	%ymm8, 96(%r10,%rax,4)
	vinserti128	$1, %xmm7, %ymm6, %ymm8
	vperm2i128	$49, %ymm7, %ymm6, %ymm6 # ymm6 = ymm6[2,3],ymm7[2,3]
	vcvtdq2ps	%ymm8, %ymm7
	vmulps	128(%rsi,%rax,4), %ymm7, %ymm7
	vaddps	128(%r10,%rax,4), %ymm7, %ymm7
	vmovups	%ymm7, 128(%r10,%rax,4)
	vcvtdq2ps	%ymm6, %ymm6
	vmulps	160(%rsi,%rax,4), %ymm6, %ymm6
	vaddps	160(%r10,%rax,4), %ymm6, %ymm6
	vmovups	%ymm6, 160(%r10,%rax,4)
	vinserti128	$1, %xmm5, %ymm4, %ymm6
	vperm2i128	$49, %ymm5, %ymm4, %ymm4 # ymm4 = ymm4[2,3],ymm5[2,3]
	vcvtdq2ps	%ymm6, %ymm5
	vmulps	192(%rsi,%rax,4), %ymm5, %ymm5
	vaddps	192(%r10,%rax,4), %ymm5, %ymm5
	vmovups	%ymm5, 192(%r10,%rax,4)
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	224(%rsi,%rax,4), %ymm4, %ymm4
	vaddps	224(%r10,%rax,4), %ymm4, %ymm4
	vmovups	%ymm4, 224(%r10,%rax,4)
	vinserti128	$1, %xmm3, %ymm2, %ymm4
	vperm2i128	$49, %ymm3, %ymm2, %ymm2 # ymm2 = ymm2[2,3],ymm3[2,3]
	vcvtdq2ps	%ymm4, %ymm3
	vmulps	256(%rsi,%rax,4), %ymm3, %ymm3
	vaddps	256(%r10,%rax,4), %ymm3, %ymm3
	vmovups	%ymm3, 256(%r10,%rax,4)
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	288(%rsi,%rax,4), %ymm2, %ymm2
	vaddps	288(%r10,%rax,4), %ymm2, %ymm2
	vmovups	%ymm2, 288(%r10,%rax,4)
	vinserti128	$1, %xmm1, %ymm0, %ymm2
	vperm2i128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vcvtdq2ps	%ymm2, %ymm1
	vmulps	320(%rsi,%rax,4), %ymm1, %ymm1
	vaddps	320(%r10,%rax,4), %ymm1, %ymm1
	vmovups	%ymm1, 320(%r10,%rax,4)
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	352(%rsi,%rax,4), %ymm0, %ymm0
	vaddps	352(%r10,%rax,4), %ymm0, %ymm0
	vmovups	%ymm0, 352(%r10,%rax,4)
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end3:
	.size	_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf, .Lfunc_end3-_ZN3fx23opt12_GLOBAL__N_111spmv16_halfEPKaPKfPKsPKtiiPf
                                        # -- End function
	.section	.text._ZN3fx23opt10gemv16_addEPKaPKfPKsPf,"ax",@progbits
	.globl	_ZN3fx23opt10gemv16_addEPKaPKfPKsPf # -- Begin function _ZN3fx23opt10gemv16_addEPKaPKfPKsPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt10gemv16_addEPKaPKfPKsPf,@function
_ZN3fx23opt10gemv16_addEPKaPKfPKsPf:    # @_ZN3fx23opt10gemv16_addEPKaPKfPKsPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	andq	$-32, %rsp
	subq	$320, %rsp                      # imm = 0x140
	vmovdqu	(%rdx), %ymm0
	vmovdqu	32(%rdx), %ymm1
	vmovdqu	64(%rdx), %ymm2
	vmovdqu	96(%rdx), %ymm3
	vmovdqu	128(%rdx), %ymm4
	vmovdqu	160(%rdx), %ymm5
	vmovdqu	192(%rdx), %ymm6
	vmovdqu	224(%rdx), %ymm7
	vmovdqu	256(%rdx), %ymm8
	vmovdqu	288(%rdx), %ymm9
	vmovdqu	320(%rdx), %ymm10
	vmovdqu	352(%rdx), %ymm11
	leaq	176(%rdi), %rax
	addq	$1712, %rdi                     # imm = 0x6B0
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB4_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB4_2 Depth 2
                                        #     Child Loop BB4_4 Depth 2
	movq	%rax, %r8
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB4_2:                                #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovsxbw	-176(%r8), %ymm12
	vpmaddwd	%ymm0, %ymm12, %ymm12
	vpmovsxbw	-160(%r8), %ymm13
	vpmaddwd	%ymm1, %ymm13, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vpmovsxbw	-144(%r8), %ymm13
	vpmovsxbw	-128(%r8), %ymm14
	vpmaddwd	%ymm2, %ymm13, %ymm13
	vpmaddwd	%ymm3, %ymm14, %ymm14
	vpaddd	%ymm13, %ymm14, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vpmovsxbw	-112(%r8), %ymm13
	vpmovsxbw	-96(%r8), %ymm14
	vpmaddwd	%ymm4, %ymm13, %ymm13
	vpmaddwd	%ymm5, %ymm14, %ymm14
	vpmovsxbw	-80(%r8), %ymm15
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmaddwd	%ymm6, %ymm15, %ymm14
	vpaddd	%ymm13, %ymm14, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vpmovsxbw	-64(%r8), %ymm13
	vpmovsxbw	-48(%r8), %ymm14
	vpmaddwd	%ymm7, %ymm13, %ymm13
	vpmaddwd	%ymm8, %ymm14, %ymm14
	vpmovsxbw	-32(%r8), %ymm15
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmaddwd	%ymm9, %ymm15, %ymm14
	vpmovsxbw	-16(%r8), %ymm15
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmaddwd	%ymm10, %ymm15, %ymm14
	vpaddd	%ymm13, %ymm14, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vpmovsxbw	(%r8), %ymm13
	vpmaddwd	%ymm11, %ymm13, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vmovdqa	%ymm12, (%rsp,%r9)
	addq	$32, %r9
	addq	$192, %r8
	cmpq	$256, %r9                       # imm = 0x100
	jne	.LBB4_2
# %bb.3:                                #   in Loop: Header=BB4_1 Depth=1
	vmovdqa	(%rsp), %ymm12
	vmovdqa	128(%rsp), %ymm13
	vmovdqa	192(%rsp), %ymm14
	vphaddd	160(%rsp), %ymm13, %ymm13
	vphaddd	224(%rsp), %ymm14, %ymm14
	vmovdqa	64(%rsp), %ymm15
	vphaddd	%ymm14, %ymm13, %ymm13
	vphaddd	32(%rsp), %ymm12, %ymm12
	vphaddd	96(%rsp), %ymm15, %ymm14
	vphaddd	%ymm14, %ymm12, %ymm12
	vperm2i128	$49, %ymm13, %ymm12, %ymm14 # ymm14 = ymm12[2,3],ymm13[2,3]
	vinserti128	$1, %xmm13, %ymm12, %ymm12
	vpaddd	%ymm12, %ymm14, %ymm12
	vmovdqa	%ymm12, 256(%rsp)               # 32-byte Spill
	movq	%rdi, %r8
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB4_4:                                #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovsxbw	-176(%r8), %ymm13
	vpmaddwd	%ymm0, %ymm13, %ymm13
	vpmovsxbw	-160(%r8), %ymm14
	vpmaddwd	%ymm1, %ymm14, %ymm14
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmovsxbw	-144(%r8), %ymm14
	vpmovsxbw	-128(%r8), %ymm15
	vpmaddwd	%ymm2, %ymm14, %ymm14
	vpmaddwd	%ymm3, %ymm15, %ymm15
	vpaddd	%ymm14, %ymm15, %ymm14
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmovsxbw	-112(%r8), %ymm14
	vpmovsxbw	-96(%r8), %ymm15
	vpmaddwd	%ymm4, %ymm14, %ymm14
	vpmaddwd	%ymm5, %ymm15, %ymm15
	vpmovsxbw	-80(%r8), %ymm12
	vpaddd	%ymm14, %ymm15, %ymm14
	vpmaddwd	%ymm6, %ymm12, %ymm12
	vpaddd	%ymm14, %ymm12, %ymm12
	vpaddd	%ymm13, %ymm12, %ymm12
	vpmovsxbw	-64(%r8), %ymm13
	vpmovsxbw	-48(%r8), %ymm14
	vpmaddwd	%ymm7, %ymm13, %ymm13
	vpmaddwd	%ymm8, %ymm14, %ymm14
	vpmovsxbw	-32(%r8), %ymm15
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmaddwd	%ymm9, %ymm15, %ymm14
	vpmovsxbw	-16(%r8), %ymm15
	vpaddd	%ymm13, %ymm14, %ymm13
	vpmaddwd	%ymm10, %ymm15, %ymm14
	vpaddd	%ymm13, %ymm14, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vpmovsxbw	(%r8), %ymm13
	vpmaddwd	%ymm11, %ymm13, %ymm13
	vpaddd	%ymm12, %ymm13, %ymm12
	vmovdqa	%ymm12, (%rsp,%r9)
	addq	$32, %r9
	addq	$192, %r8
	cmpq	$256, %r9                       # imm = 0x100
	jne	.LBB4_4
# %bb.5:                                #   in Loop: Header=BB4_1 Depth=1
	vmovdqa	(%rsp), %ymm12
	vmovdqa	128(%rsp), %ymm13
	vmovdqa	192(%rsp), %ymm14
	vphaddd	160(%rsp), %ymm13, %ymm13
	vphaddd	224(%rsp), %ymm14, %ymm14
	vmovdqa	64(%rsp), %ymm15
	vphaddd	%ymm14, %ymm13, %ymm13
	vphaddd	32(%rsp), %ymm12, %ymm12
	vphaddd	96(%rsp), %ymm15, %ymm14
	vphaddd	%ymm14, %ymm12, %ymm12
	vperm2i128	$49, %ymm13, %ymm12, %ymm14 # ymm14 = ymm12[2,3],ymm13[2,3]
	vinserti128	$1, %xmm13, %ymm12, %ymm12
	vpaddd	%ymm12, %ymm14, %ymm12
	vcvtdq2ps	256(%rsp), %ymm13       # 32-byte Folded Reload
	vmulps	(%rsi,%rdx,4), %ymm13, %ymm13
	vaddps	(%rcx,%rdx,4), %ymm13, %ymm13
	vmovups	%ymm13, (%rcx,%rdx,4)
	vcvtdq2ps	%ymm12, %ymm12
	vmulps	32(%rsi,%rdx,4), %ymm12, %ymm12
	vaddps	32(%rcx,%rdx,4), %ymm12, %ymm12
	vmovups	%ymm12, 32(%rcx,%rdx,4)
	leaq	16(%rdx), %r8
	addq	$3072, %rax                     # imm = 0xC00
	addq	$3072, %rdi                     # imm = 0xC00
	cmpq	$176, %rdx
	movq	%r8, %rdx
	jb	.LBB4_1
# %bb.6:
	movq	%rbp, %rsp
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end4:
	.size	_ZN3fx23opt10gemv16_addEPKaPKfPKsPf, .Lfunc_end4-_ZN3fx23opt10gemv16_addEPKaPKfPKsPf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_
.LCPI5_0:
	.long	0x46fffe00                      # float 32767
.LCPI5_1:
	.long	255                             # 0xff
	.section	.text._ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_,"ax",@progbits
	.globl	_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_
	.p2align	4, 0x90
	.type	_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_,@function
_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_: # @_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	movq	40(%rsp), %r10
	testl	%esi, %esi
	jle	.LBB5_5
# %bb.1:
	vbroadcastss	%xmm0, %ymm1
	movl	%esi, %esi
	xorl	%r11d, %r11d
	vxorps	%xmm2, %xmm2, %xmm2
	vpbroadcastd	.LCPI5_1(%rip), %ymm3   # ymm3 = [255,255,255,255,255,255,255,255]
	vbroadcastss	.LCPI5_0(%rip), %ymm4   # ymm4 = [3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4,3.2767E+4]
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	xorl	%ebx, %ebx
	.p2align	4, 0x90
.LBB5_2:                                # =>This Inner Loop Header: Depth=1
	vmovups	(%rdi,%r11,4), %ymm5
	vmaxps	%ymm2, %ymm5, %ymm5
	vmulps	%ymm5, %ymm5, %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	movl	%ebx, %ebp
	movl	%eax, %ebx
	vminps	%ymm4, %ymm5, %ymm5
	vcvtps2dq	%ymm5, %ymm5
	vpaddd	%ymm0, %ymm5, %ymm0
	vextracti128	$1, %ymm5, %xmm6
	vpackssdw	%xmm6, %xmm5, %xmm6
	vmovdqu	%xmm6, (%rdx,%r11,2)
	vpcmpeqd	%ymm2, %ymm5, %ymm6
	vmovmskps	%ymm6, %eax
	notb	%al
	vpcmpgtd	%ymm3, %ymm5, %ymm5
	vmovmskps	%ymm5, %r14d
	vmovd	%r11d, %xmm5
	vpbroadcastw	%xmm5, %xmm5
	movl	%ebx, %r15d
	movzbl	%al, %eax
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_14kPosE(,%rax,8), %xmm6 # xmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpaddw	%xmm6, %xmm5, %xmm6
	vmovdqu	%xmm6, (%rcx,%r15,2)
	popcntl	%eax, %eax
	addl	%ebx, %eax
	movl	%ebp, %ebx
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_14kPosE(,%r14,8), %xmm6 # xmm6 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpaddw	%xmm6, %xmm5, %xmm5
	vmovdqu	%xmm5, (%r8,%rbx,2)
	popcntl	%r14d, %ebx
	addl	%ebp, %ebx
	addq	$8, %r11
	cmpq	%rsi, %r11
	jb	.LBB5_2
# %bb.3:
	testl	%eax, %eax
	je	.LBB5_6
# %bb.4:
	movslq	%eax, %rdx
	movzwl	-2(%rcx,%rdx,2), %edx
	jmp	.LBB5_8
.LBB5_5:
	xorl	%eax, %eax
	vxorps	%xmm0, %xmm0, %xmm0
	xorl	%ebx, %ebx
	jmp	.LBB5_7
.LBB5_6:
	xorl	%eax, %eax
.LBB5_7:
	xorl	%edx, %edx
.LBB5_8:
	movl	%eax, %esi
	vmovd	%edx, %xmm1
	vpbroadcastw	%xmm1, %ymm1
	vmovdqu	%ymm1, (%rcx,%rsi,2)
	vextractf128	$1, %ymm0, %xmm1
	vpaddd	%xmm0, %xmm1, %xmm0
	vpshufd	$78, %xmm0, %xmm1               # xmm1 = xmm0[2,3,0,1]
	vpaddd	%xmm0, %xmm1, %xmm0
	vpshufd	$85, %xmm0, %xmm1               # xmm1 = xmm0[1,1,1,1]
	vpaddd	%xmm0, %xmm1, %xmm0
	vmovd	%xmm0, (%r10)
	movl	%ebx, (%r9)
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end5:
	.size	_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_, .Lfunc_end5-_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt14pack16_nibblesEPKaiPh
.LCPI6_0:
	.zero	32,7
.LCPI6_1:
	.zero	32,240
.LCPI6_2:
	.zero	32,112
	.section	.rodata,"a",@progbits
.LCPI6_3:
	.byte	7                               # 0x7
.LCPI6_4:
	.byte	240                             # 0xf0
.LCPI6_5:
	.byte	112                             # 0x70
	.section	.text._ZN3fx23opt14pack16_nibblesEPKaiPh,"ax",@progbits
	.globl	_ZN3fx23opt14pack16_nibblesEPKaiPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt14pack16_nibblesEPKaiPh,@function
_ZN3fx23opt14pack16_nibblesEPKaiPh:     # @_ZN3fx23opt14pack16_nibblesEPKaiPh
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	cmpl	$64, %esi
	jl	.LBB6_9
# %bb.1:
	pushq	%rbx
	shrl	$6, %esi
	leaq	33(%rdi), %rax
	leaq	1(%rdx), %rcx
	xorl	%r8d, %r8d
	vpbroadcastb	.LCPI6_3(%rip), %ymm0   # ymm0 = [7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7]
	vpbroadcastb	.LCPI6_4(%rip), %ymm1   # ymm1 = [240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240,240]
	vpbroadcastb	.LCPI6_5(%rip), %ymm2   # ymm2 = [112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112,112]
	jmp	.LBB6_2
	.p2align	4, 0x90
.LBB6_6:                                #   in Loop: Header=BB6_2 Depth=1
	vpaddb	(%rdi,%r10), %ymm0, %ymm3
	orq	$32, %r10
	vmovdqu	(%rdi,%r10), %ymm4
	vpsllw	$4, %ymm4, %ymm4
	vpand	%ymm1, %ymm4, %ymm4
	vpaddb	%ymm2, %ymm4, %ymm4
	vpor	%ymm3, %ymm4, %ymm3
	vmovdqu	%ymm3, (%rdx,%r9)
.LBB6_7:                                #   in Loop: Header=BB6_2 Depth=1
	incq	%r8
	addq	$64, %rax
	addq	$32, %rcx
	cmpq	%rsi, %r8
	je	.LBB6_8
.LBB6_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_5 Depth 2
	movq	%r8, %r10
	shlq	$6, %r10
	movq	%r8, %r9
	shlq	$5, %r9
	leaq	(%rdi,%r10), %r11
	addq	$64, %r11
	leaq	(%rdx,%r9), %rbx
	cmpq	%r11, %rbx
	jae	.LBB6_6
# %bb.3:                                #   in Loop: Header=BB6_2 Depth=1
	leaq	(%rdi,%r10), %r11
	leaq	(%rdx,%r9), %rbx
	addq	$32, %rbx
	cmpq	%rbx, %r11
	jae	.LBB6_6
# %bb.4:                                #   in Loop: Header=BB6_2 Depth=1
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB6_5:                                #   Parent Loop BB6_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movzbl	-33(%rax,%r9), %r10d
	movzbl	-1(%rax,%r9), %r11d
	addb	$7, %r10b
	shlb	$4, %r11b
	addb	$112, %r11b
	orb	%r10b, %r11b
	movb	%r11b, -1(%rcx,%r9)
	movzbl	-32(%rax,%r9), %r10d
	movzbl	(%rax,%r9), %r11d
	addb	$7, %r10b
	shlb	$4, %r11b
	addb	$112, %r11b
	orb	%r10b, %r11b
	movb	%r11b, (%rcx,%r9)
	addq	$2, %r9
	cmpq	$32, %r9
	jne	.LBB6_5
	jmp	.LBB6_7
.LBB6_8:
	popq	%rbx
.LBB6_9:
	vzeroupper
	retq
.Lfunc_end6:
	.size	_ZN3fx23opt14pack16_nibblesEPKaiPh, .Lfunc_end6-_ZN3fx23opt14pack16_nibblesEPKaiPh
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf
.LCPI7_0:
	.zero	32,15
	.section	.rodata,"a",@progbits
.LCPI7_1:
	.byte	15                              # 0xf
	.section	.text._ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf,"ax",@progbits
	.globl	_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf,@function
_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf: # @_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$2432, %rsp                     # imm = 0x980
	movq	%r9, 824(%rsp)                  # 8-byte Spill
	movl	%r8d, (%rsp)                    # 4-byte Spill
	movq	%rcx, %r13
	movq	%rdx, %r15
	movq	%rsi, %rbx
	movq	%rdi, %r12
	leaq	1632(%rsp), %rdi
	xorl	%r14d, %r14d
	movl	$768, %edx                      # imm = 0x300
	xorl	%esi, %esi
	callq	memset@PLT
	leaq	864(%rsp), %rdi
	movl	$768, %edx                      # imm = 0x300
	xorl	%esi, %esi
	callq	memset@PLT
	movl	(%rsp), %eax                    # 4-byte Reload
	testl	%eax, %eax
	jle	.LBB7_11
# %bb.1:
	movl	%eax, %eax
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%ymm0, 768(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 736(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 704(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 672(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 640(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 608(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 576(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 544(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 512(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 480(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 448(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 416(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 384(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 352(%rsp)                # 32-byte Spill
	xorl	%ecx, %ecx
	vmovdqa	%ymm0, 320(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 192(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 160(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 128(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqa	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovdqa	%ymm0, 32(%rsp)                 # 32-byte Spill
	vpxor	%xmm11, %xmm11, %xmm11
	vmovdqa	%ymm0, (%rsp)                   # 32-byte Spill
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	jmp	.LBB7_2
	.p2align	4, 0x90
.LBB7_8:                                #   in Loop: Header=BB7_2 Depth=1
	vpmovzxwd	%xmm6, %ymm7            # ymm7 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero,xmm6[4],zero,xmm6[5],zero,xmm6[6],zero,xmm6[7],zero
	vmovdqa	32(%rsp), %ymm9                 # 32-byte Reload
	vpaddd	%ymm7, %ymm9, %ymm9
	vmovdqa	%ymm9, 32(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm6, %xmm6
	vpmovzxwd	%xmm6, %ymm6            # ymm6 = xmm6[0],zero,xmm6[1],zero,xmm6[2],zero,xmm6[3],zero,xmm6[4],zero,xmm6[5],zero,xmm6[6],zero,xmm6[7],zero
	vmovdqa	64(%rsp), %ymm7                 # 32-byte Reload
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovdqa	%ymm7, 64(%rsp)                 # 32-byte Spill
	vpmovzxwd	%xmm5, %ymm6            # ymm6 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero,xmm5[4],zero,xmm5[5],zero,xmm5[6],zero,xmm5[7],zero
	vmovdqa	96(%rsp), %ymm7                 # 32-byte Reload
	vpaddd	%ymm6, %ymm7, %ymm7
	vmovdqa	%ymm7, 96(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm5, %xmm5
	vpmovzxwd	%xmm5, %ymm5            # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero,xmm5[4],zero,xmm5[5],zero,xmm5[6],zero,xmm5[7],zero
	vmovdqa	128(%rsp), %ymm6                # 32-byte Reload
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqa	%ymm6, 128(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm4, %ymm5            # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vmovdqa	160(%rsp), %ymm6                # 32-byte Reload
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqa	%ymm6, 160(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vmovdqa	192(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqa	%ymm5, 192(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm3, %ymm4            # ymm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vmovdqa	224(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqa	%ymm5, 224(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vmovdqa	256(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqa	%ymm4, 256(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm2, %ymm3            # ymm3 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vmovdqa	288(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqa	%ymm4, 288(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxwd	%xmm2, %ymm2            # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vmovdqa	320(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqa	%ymm3, 320(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm1, %ymm2            # ymm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqa	352(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqa	%ymm3, 352(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqa	384(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqa	%ymm2, 384(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm12, %ymm1           # ymm1 = xmm12[0],zero,xmm12[1],zero,xmm12[2],zero,xmm12[3],zero,xmm12[4],zero,xmm12[5],zero,xmm12[6],zero,xmm12[7],zero
	vmovdqa	416(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqa	%ymm2, 416(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm12, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	448(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 448(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm15, %ymm0           # ymm0 = xmm15[0],zero,xmm15[1],zero,xmm15[2],zero,xmm15[3],zero,xmm15[4],zero,xmm15[5],zero,xmm15[6],zero,xmm15[7],zero
	vmovdqa	480(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 480(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm15, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	512(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 512(%rsp)                # 32-byte Spill
	vmovdqa	832(%rsp), %ymm15               # 32-byte Reload
	vpmovzxwd	%xmm15, %ymm0           # ymm0 = xmm15[0],zero,xmm15[1],zero,xmm15[2],zero,xmm15[3],zero,xmm15[4],zero,xmm15[5],zero,xmm15[6],zero,xmm15[7],zero
	vmovdqa	544(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 544(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm15, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	576(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 576(%rsp)                # 32-byte Spill
	vmovdqa	(%rsp), %ymm2                   # 32-byte Reload
	vpmovzxwd	%xmm2, %ymm0            # ymm0 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vmovdqa	608(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 608(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm2, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	640(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 640(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm11, %ymm0           # ymm0 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero,xmm11[4],zero,xmm11[5],zero,xmm11[6],zero,xmm11[7],zero
	vmovdqa	672(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 672(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm11, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	704(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 704(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm10, %ymm0           # ymm0 = xmm10[0],zero,xmm10[1],zero,xmm10[2],zero,xmm10[3],zero,xmm10[4],zero,xmm10[5],zero,xmm10[6],zero,xmm10[7],zero
	vmovdqa	736(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 736(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm10, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	768(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 768(%rsp)                # 32-byte Spill
	xorl	%r14d, %r14d
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%ymm0, (%rsp)                   # 32-byte Spill
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	cmpq	%rax, %rcx
	jae	.LBB7_10
.LBB7_2:                                # =>This Inner Loop Header: Depth=1
	movzwl	(%r13,%rcx,2), %edx
	leaq	1(%rcx), %rsi
	cmpq	%rax, %rsi
	jae	.LBB7_3
# %bb.4:                                #   in Loop: Header=BB7_2 Depth=1
	movzwl	2(%r13,%rcx,2), %esi
	movzbl	(%r15,%rsi,2), %edi
	jmp	.LBB7_5
	.p2align	4, 0x90
.LBB7_3:                                #   in Loop: Header=BB7_2 Depth=1
	xorl	%edi, %edi
	movl	%edx, %esi
.LBB7_5:                                #   in Loop: Header=BB7_2 Depth=1
	movzbl	(%r15,%rdx,2), %r8d
	movzwl	%di, %edi
	shll	$8, %edi
	orl	%r8d, %edi
	vmovd	%edi, %xmm7
	vpbroadcastw	%xmm7, %ymm7
	movl	%edx, %edx
	leaq	(%rdx,%rdx,2), %rdx
	shlq	$5, %rdx
	movl	%esi, %esi
	leaq	(%rsi,%rsi,2), %rsi
	shlq	$5, %rsi
	movzwl	24(%r13,%rcx,2), %edi
	leaq	(%rdi,%rdi,2), %rdi
	shlq	$5, %rdi
	movzwl	26(%r13,%rcx,2), %r8d
	leaq	(%r8,%r8,2), %r8
	shlq	$5, %r8
	prefetcht0	(%r12,%rdi)
	prefetcht0	64(%r12,%rdi)
	prefetcht0	(%r12,%r8)
	prefetcht0	64(%r12,%r8)
	vmovdqu	(%r12,%rdx), %ymm8
	vmovdqu	(%r12,%rsi), %ymm9
	vpunpcklbw	%ymm9, %ymm8, %ymm14    # ymm14 = ymm8[0],ymm9[0],ymm8[1],ymm9[1],ymm8[2],ymm9[2],ymm8[3],ymm9[3],ymm8[4],ymm9[4],ymm8[5],ymm9[5],ymm8[6],ymm9[6],ymm8[7],ymm9[7],ymm8[16],ymm9[16],ymm8[17],ymm9[17],ymm8[18],ymm9[18],ymm8[19],ymm9[19],ymm8[20],ymm9[20],ymm8[21],ymm9[21],ymm8[22],ymm9[22],ymm8[23],ymm9[23]
	vpunpckhbw	%ymm9, %ymm8, %ymm8     # ymm8 = ymm8[8],ymm9[8],ymm8[9],ymm9[9],ymm8[10],ymm9[10],ymm8[11],ymm9[11],ymm8[12],ymm9[12],ymm8[13],ymm9[13],ymm8[14],ymm9[14],ymm8[15],ymm9[15],ymm8[24],ymm9[24],ymm8[25],ymm9[25],ymm8[26],ymm9[26],ymm8[27],ymm9[27],ymm8[28],ymm9[28],ymm8[29],ymm9[29],ymm8[30],ymm9[30],ymm8[31],ymm9[31]
	vpbroadcastb	.LCPI7_1(%rip), %ymm0   # ymm0 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpand	%ymm0, %ymm14, %ymm9
	vpmaddubsw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm6, %ymm9, %ymm6
	vpand	%ymm0, %ymm8, %ymm9
	vpmaddubsw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm5, %ymm9, %ymm5
	vmovdqu	32(%r12,%rdx), %ymm9
	vpsrlw	$4, %ymm14, %ymm14
	vpand	%ymm0, %ymm14, %ymm14
	vpmaddubsw	%ymm14, %ymm7, %ymm14
	vpaddw	%ymm4, %ymm14, %ymm4
	vmovdqu	32(%r12,%rsi), %ymm14
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm0, %ymm8, %ymm8
	vpmaddubsw	%ymm8, %ymm7, %ymm8
	vpaddw	%ymm3, %ymm8, %ymm3
	vpunpcklbw	%ymm14, %ymm9, %ymm8    # ymm8 = ymm9[0],ymm14[0],ymm9[1],ymm14[1],ymm9[2],ymm14[2],ymm9[3],ymm14[3],ymm9[4],ymm14[4],ymm9[5],ymm14[5],ymm9[6],ymm14[6],ymm9[7],ymm14[7],ymm9[16],ymm14[16],ymm9[17],ymm14[17],ymm9[18],ymm14[18],ymm9[19],ymm14[19],ymm9[20],ymm14[20],ymm9[21],ymm14[21],ymm9[22],ymm14[22],ymm9[23],ymm14[23]
	vpunpckhbw	%ymm14, %ymm9, %ymm9    # ymm9 = ymm9[8],ymm14[8],ymm9[9],ymm14[9],ymm9[10],ymm14[10],ymm9[11],ymm14[11],ymm9[12],ymm14[12],ymm9[13],ymm14[13],ymm9[14],ymm14[14],ymm9[15],ymm14[15],ymm9[24],ymm14[24],ymm9[25],ymm14[25],ymm9[26],ymm14[26],ymm9[27],ymm14[27],ymm9[28],ymm14[28],ymm9[29],ymm14[29],ymm9[30],ymm14[30],ymm9[31],ymm14[31]
	vpand	%ymm0, %ymm8, %ymm14
	vpmaddubsw	%ymm14, %ymm7, %ymm14
	vpaddw	%ymm2, %ymm14, %ymm2
	vpand	%ymm0, %ymm9, %ymm14
	vpmaddubsw	%ymm14, %ymm7, %ymm14
	vpaddw	%ymm1, %ymm14, %ymm1
	vmovdqu	64(%r12,%rdx), %ymm14
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm0, %ymm8, %ymm8
	vpmaddubsw	%ymm8, %ymm7, %ymm8
	vpaddw	%ymm12, %ymm8, %ymm12
	vmovdqu	64(%r12,%rsi), %ymm8
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpmaddubsw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm15, %ymm9, %ymm15
	vpunpcklbw	%ymm8, %ymm14, %ymm9    # ymm9 = ymm14[0],ymm8[0],ymm14[1],ymm8[1],ymm14[2],ymm8[2],ymm14[3],ymm8[3],ymm14[4],ymm8[4],ymm14[5],ymm8[5],ymm14[6],ymm8[6],ymm14[7],ymm8[7],ymm14[16],ymm8[16],ymm14[17],ymm8[17],ymm14[18],ymm8[18],ymm14[19],ymm8[19],ymm14[20],ymm8[20],ymm14[21],ymm8[21],ymm14[22],ymm8[22],ymm14[23],ymm8[23]
	vpunpckhbw	%ymm8, %ymm14, %ymm8    # ymm8 = ymm14[8],ymm8[8],ymm14[9],ymm8[9],ymm14[10],ymm8[10],ymm14[11],ymm8[11],ymm14[12],ymm8[12],ymm14[13],ymm8[13],ymm14[14],ymm8[14],ymm14[15],ymm8[15],ymm14[24],ymm8[24],ymm14[25],ymm8[25],ymm14[26],ymm8[26],ymm14[27],ymm8[27],ymm14[28],ymm8[28],ymm14[29],ymm8[29],ymm14[30],ymm8[30],ymm14[31],ymm8[31]
	vpand	%ymm0, %ymm9, %ymm14
	vpmaddubsw	%ymm14, %ymm7, %ymm14
	vpaddw	%ymm13, %ymm14, %ymm13
	vmovdqa	%ymm13, 832(%rsp)               # 32-byte Spill
	vpand	%ymm0, %ymm8, %ymm14
	vpmaddubsw	%ymm14, %ymm7, %ymm14
	vmovdqa	(%rsp), %ymm13                  # 32-byte Reload
	vpaddw	%ymm13, %ymm14, %ymm13
	vmovdqa	%ymm13, (%rsp)                  # 32-byte Spill
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpmaddubsw	%ymm9, %ymm7, %ymm9
	vpaddw	%ymm11, %ymm9, %ymm11
	vpsrlw	$4, %ymm8, %ymm8
	vpand	%ymm0, %ymm8, %ymm8
	vpmaddubsw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm7, %ymm10, %ymm10
	incl	%r14d
	addq	$2, %rcx
	cmpl	$8, %r14d
	je	.LBB7_8
# %bb.6:                                #   in Loop: Header=BB7_2 Depth=1
	cmpq	%rax, %rcx
	jae	.LBB7_8
# %bb.7:                                #   in Loop: Header=BB7_2 Depth=1
	vmovdqa	832(%rsp), %ymm13               # 32-byte Reload
	cmpq	%rax, %rcx
	jb	.LBB7_2
.LBB7_10:
	vmovaps	32(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 1632(%rsp)
	vmovaps	64(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 1696(%rsp)
	vmovaps	96(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 1664(%rsp)
	vmovaps	128(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1728(%rsp)
	vmovaps	160(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1760(%rsp)
	vmovaps	192(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1824(%rsp)
	vmovaps	224(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1792(%rsp)
	vmovaps	256(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1856(%rsp)
	vmovaps	288(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1888(%rsp)
	vmovaps	320(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1952(%rsp)
	vmovaps	352(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1920(%rsp)
	vmovaps	384(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1984(%rsp)
	vmovaps	416(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2016(%rsp)
	vmovaps	448(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2080(%rsp)
	vmovaps	480(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2048(%rsp)
	vmovaps	512(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2112(%rsp)
	vmovaps	544(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2144(%rsp)
	vmovaps	576(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2208(%rsp)
	vmovaps	608(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2176(%rsp)
	vmovaps	640(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2240(%rsp)
	vmovaps	672(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2272(%rsp)
	vmovaps	704(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2336(%rsp)
	vmovaps	736(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2304(%rsp)
	vmovaps	768(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 2368(%rsp)
.LBB7_11:
	movl	24(%rbp), %eax
	movl	16(%rbp), %ecx
	testl	%ecx, %ecx
	jle	.LBB7_22
# %bb.12:
	movl	%ecx, %ecx
	vmovaps	864(%rsp), %ymm0
	vmovaps	%ymm0, 320(%rsp)                # 32-byte Spill
	vmovaps	896(%rsp), %ymm0
	vmovaps	%ymm0, 768(%rsp)                # 32-byte Spill
	vmovaps	928(%rsp), %ymm0
	vmovaps	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovaps	960(%rsp), %ymm0
	vmovaps	%ymm0, 352(%rsp)                # 32-byte Spill
	vmovaps	992(%rsp), %ymm0
	vmovaps	%ymm0, 384(%rsp)                # 32-byte Spill
	vmovaps	1056(%rsp), %ymm0
	vmovaps	%ymm0, 416(%rsp)                # 32-byte Spill
	vmovaps	1024(%rsp), %ymm0
	vmovaps	%ymm0, 448(%rsp)                # 32-byte Spill
	vmovaps	1088(%rsp), %ymm0
	vmovaps	%ymm0, 480(%rsp)                # 32-byte Spill
	vmovaps	1120(%rsp), %ymm0
	vmovaps	%ymm0, 512(%rsp)                # 32-byte Spill
	vmovaps	1184(%rsp), %ymm0
	vmovaps	%ymm0, 544(%rsp)                # 32-byte Spill
	vmovaps	1152(%rsp), %ymm0
	vmovaps	%ymm0, 576(%rsp)                # 32-byte Spill
	vmovaps	1216(%rsp), %ymm0
	vmovaps	%ymm0, 608(%rsp)                # 32-byte Spill
	vmovaps	1248(%rsp), %ymm0
	vmovaps	%ymm0, 640(%rsp)                # 32-byte Spill
	vmovaps	1312(%rsp), %ymm0
	vmovaps	%ymm0, 672(%rsp)                # 32-byte Spill
	vmovaps	1280(%rsp), %ymm0
	vmovaps	%ymm0, 704(%rsp)                # 32-byte Spill
	vmovaps	1344(%rsp), %ymm0
	vmovaps	%ymm0, 736(%rsp)                # 32-byte Spill
	xorl	%esi, %esi
	movl	$1, %edx
	vmovaps	1376(%rsp), %ymm0
	vmovaps	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovaps	1440(%rsp), %ymm0
	vmovaps	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovaps	1408(%rsp), %ymm0
	vmovaps	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovaps	1472(%rsp), %ymm0
	vmovaps	%ymm0, 128(%rsp)                # 32-byte Spill
	vmovaps	1504(%rsp), %ymm0
	vmovaps	%ymm0, 160(%rsp)                # 32-byte Spill
	vmovaps	1568(%rsp), %ymm0
	vmovaps	%ymm0, 192(%rsp)                # 32-byte Spill
	vmovaps	1536(%rsp), %ymm0
	vmovaps	%ymm0, 224(%rsp)                # 32-byte Spill
	vpxor	%xmm10, %xmm10, %xmm10
	vmovdqa	1600(%rsp), %ymm0
	vmovdqa	%ymm0, 256(%rsp)                # 32-byte Spill
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%ymm0, (%rsp)                   # 32-byte Spill
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	movq	824(%rsp), %r11                 # 8-byte Reload
	jmp	.LBB7_13
	.p2align	4, 0x90
.LBB7_19:                               #   in Loop: Header=BB7_13 Depth=1
	vpmovzxwd	%xmm4, %ymm5            # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vmovdqa	320(%rsp), %ymm6                # 32-byte Reload
	vpaddd	%ymm5, %ymm6, %ymm6
	vmovdqa	%ymm6, 320(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vmovdqa	288(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqa	%ymm5, 288(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm3, %ymm4            # ymm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vmovdqa	768(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqa	%ymm5, 768(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vmovdqa	352(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqa	%ymm4, 352(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm2, %ymm3            # ymm3 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vmovdqa	384(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqa	%ymm4, 384(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm2, %xmm2
	vpmovzxwd	%xmm2, %ymm2            # ymm2 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vmovdqa	416(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqa	%ymm3, 416(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm1, %ymm2            # ymm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqa	448(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqa	%ymm3, 448(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqa	480(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqa	%ymm2, 480(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm8, %ymm1            # ymm1 = xmm8[0],zero,xmm8[1],zero,xmm8[2],zero,xmm8[3],zero,xmm8[4],zero,xmm8[5],zero,xmm8[6],zero,xmm8[7],zero
	vmovdqa	512(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqa	%ymm2, 512(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm8, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	544(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 544(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm15, %ymm0           # ymm0 = xmm15[0],zero,xmm15[1],zero,xmm15[2],zero,xmm15[3],zero,xmm15[4],zero,xmm15[5],zero,xmm15[6],zero,xmm15[7],zero
	vmovdqa	576(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 576(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm15, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	608(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 608(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm14, %ymm0           # ymm0 = xmm14[0],zero,xmm14[1],zero,xmm14[2],zero,xmm14[3],zero,xmm14[4],zero,xmm14[5],zero,xmm14[6],zero,xmm14[7],zero
	vmovdqa	640(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 640(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm14, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	672(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 672(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm13, %ymm0           # ymm0 = xmm13[0],zero,xmm13[1],zero,xmm13[2],zero,xmm13[3],zero,xmm13[4],zero,xmm13[5],zero,xmm13[6],zero,xmm13[7],zero
	vmovdqa	704(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 704(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm13, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	736(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 736(%rsp)                # 32-byte Spill
	vmovdqa	832(%rsp), %ymm13               # 32-byte Reload
	vpmovzxwd	%xmm13, %ymm0           # ymm0 = xmm13[0],zero,xmm13[1],zero,xmm13[2],zero,xmm13[3],zero,xmm13[4],zero,xmm13[5],zero,xmm13[6],zero,xmm13[7],zero
	vmovdqa	32(%rsp), %ymm1                 # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 32(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm13, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	64(%rsp), %ymm1                 # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 64(%rsp)                 # 32-byte Spill
	vmovdqa	(%rsp), %ymm2                   # 32-byte Reload
	vpmovzxwd	%xmm2, %ymm0            # ymm0 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vmovdqa	96(%rsp), %ymm1                 # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 96(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm2, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	128(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 128(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm11, %ymm0           # ymm0 = xmm11[0],zero,xmm11[1],zero,xmm11[2],zero,xmm11[3],zero,xmm11[4],zero,xmm11[5],zero,xmm11[6],zero,xmm11[7],zero
	vmovdqa	160(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 160(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm11, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	192(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 192(%rsp)                # 32-byte Spill
	vpmovzxwd	%xmm10, %ymm0           # ymm0 = xmm10[0],zero,xmm10[1],zero,xmm10[2],zero,xmm10[3],zero,xmm10[4],zero,xmm10[5],zero,xmm10[6],zero,xmm10[7],zero
	vmovdqa	224(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 224(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm10, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqa	256(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqa	%ymm1, 256(%rsp)                # 32-byte Spill
	xorl	%esi, %esi
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqa	%ymm0, (%rsp)                   # 32-byte Spill
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	addq	$2, %rdx
	cmpq	%rcx, %rdi
	jae	.LBB7_21
.LBB7_13:                               # =>This Inner Loop Header: Depth=1
	movzwl	-2(%r11,%rdx,2), %edi
	cmpq	%rcx, %rdx
	jae	.LBB7_14
# %bb.15:                               #   in Loop: Header=BB7_13 Depth=1
	movzwl	(%r11,%rdx,2), %r8d
	movzbl	1(%r15,%r8,2), %r9d
	jmp	.LBB7_16
	.p2align	4, 0x90
.LBB7_14:                               #   in Loop: Header=BB7_13 Depth=1
	xorl	%r9d, %r9d
	movl	%edi, %r8d
.LBB7_16:                               #   in Loop: Header=BB7_13 Depth=1
	movzbl	1(%r15,%rdi,2), %r10d
	movzwl	%r9w, %r9d
	shll	$8, %r9d
	orl	%r10d, %r9d
	vmovd	%r9d, %xmm5
	vpbroadcastw	%xmm5, %ymm5
	movl	%edi, %edi
	leaq	(%rdi,%rdi,2), %rdi
	shlq	$5, %rdi
	movl	%r8d, %r8d
	leaq	(%r8,%r8,2), %r8
	shlq	$5, %r8
	vmovdqu	(%r12,%rdi), %ymm6
	vmovdqu	(%r12,%r8), %ymm7
	vpunpcklbw	%ymm7, %ymm6, %ymm9     # ymm9 = ymm6[0],ymm7[0],ymm6[1],ymm7[1],ymm6[2],ymm7[2],ymm6[3],ymm7[3],ymm6[4],ymm7[4],ymm6[5],ymm7[5],ymm6[6],ymm7[6],ymm6[7],ymm7[7],ymm6[16],ymm7[16],ymm6[17],ymm7[17],ymm6[18],ymm7[18],ymm6[19],ymm7[19],ymm6[20],ymm7[20],ymm6[21],ymm7[21],ymm6[22],ymm7[22],ymm6[23],ymm7[23]
	vpunpckhbw	%ymm7, %ymm6, %ymm6     # ymm6 = ymm6[8],ymm7[8],ymm6[9],ymm7[9],ymm6[10],ymm7[10],ymm6[11],ymm7[11],ymm6[12],ymm7[12],ymm6[13],ymm7[13],ymm6[14],ymm7[14],ymm6[15],ymm7[15],ymm6[24],ymm7[24],ymm6[25],ymm7[25],ymm6[26],ymm7[26],ymm6[27],ymm7[27],ymm6[28],ymm7[28],ymm6[29],ymm7[29],ymm6[30],ymm7[30],ymm6[31],ymm7[31]
	vpbroadcastb	.LCPI7_1(%rip), %ymm0   # ymm0 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpand	%ymm0, %ymm9, %ymm7
	vpmaddubsw	%ymm7, %ymm5, %ymm7
	vpaddw	%ymm4, %ymm7, %ymm4
	vpand	%ymm0, %ymm6, %ymm7
	vpmaddubsw	%ymm7, %ymm5, %ymm7
	vpaddw	%ymm3, %ymm7, %ymm3
	vmovdqu	32(%r12,%rdi), %ymm7
	vpsrlw	$4, %ymm9, %ymm9
	vpand	%ymm0, %ymm9, %ymm9
	vpmaddubsw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm2, %ymm9, %ymm2
	vmovdqu	32(%r12,%r8), %ymm9
	vpsrlw	$4, %ymm6, %ymm6
	vpand	%ymm0, %ymm6, %ymm6
	vpmaddubsw	%ymm6, %ymm5, %ymm6
	vpaddw	%ymm1, %ymm6, %ymm1
	vpunpcklbw	%ymm9, %ymm7, %ymm6     # ymm6 = ymm7[0],ymm9[0],ymm7[1],ymm9[1],ymm7[2],ymm9[2],ymm7[3],ymm9[3],ymm7[4],ymm9[4],ymm7[5],ymm9[5],ymm7[6],ymm9[6],ymm7[7],ymm9[7],ymm7[16],ymm9[16],ymm7[17],ymm9[17],ymm7[18],ymm9[18],ymm7[19],ymm9[19],ymm7[20],ymm9[20],ymm7[21],ymm9[21],ymm7[22],ymm9[22],ymm7[23],ymm9[23]
	vpunpckhbw	%ymm9, %ymm7, %ymm7     # ymm7 = ymm7[8],ymm9[8],ymm7[9],ymm9[9],ymm7[10],ymm9[10],ymm7[11],ymm9[11],ymm7[12],ymm9[12],ymm7[13],ymm9[13],ymm7[14],ymm9[14],ymm7[15],ymm9[15],ymm7[24],ymm9[24],ymm7[25],ymm9[25],ymm7[26],ymm9[26],ymm7[27],ymm9[27],ymm7[28],ymm9[28],ymm7[29],ymm9[29],ymm7[30],ymm9[30],ymm7[31],ymm9[31]
	vpand	%ymm0, %ymm6, %ymm9
	vpmaddubsw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm8, %ymm9, %ymm8
	vpand	%ymm0, %ymm7, %ymm9
	vpmaddubsw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm15, %ymm9, %ymm15
	vmovdqu	64(%r12,%rdi), %ymm9
	vpsrlw	$4, %ymm6, %ymm6
	vpand	%ymm0, %ymm6, %ymm6
	vpmaddubsw	%ymm6, %ymm5, %ymm6
	vpaddw	%ymm6, %ymm14, %ymm14
	vmovdqu	64(%r12,%r8), %ymm6
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm0, %ymm7, %ymm7
	vpmaddubsw	%ymm7, %ymm5, %ymm7
	vpaddw	%ymm7, %ymm13, %ymm13
	vpunpcklbw	%ymm6, %ymm9, %ymm7     # ymm7 = ymm9[0],ymm6[0],ymm9[1],ymm6[1],ymm9[2],ymm6[2],ymm9[3],ymm6[3],ymm9[4],ymm6[4],ymm9[5],ymm6[5],ymm9[6],ymm6[6],ymm9[7],ymm6[7],ymm9[16],ymm6[16],ymm9[17],ymm6[17],ymm9[18],ymm6[18],ymm9[19],ymm6[19],ymm9[20],ymm6[20],ymm9[21],ymm6[21],ymm9[22],ymm6[22],ymm9[23],ymm6[23]
	vpunpckhbw	%ymm6, %ymm9, %ymm6     # ymm6 = ymm9[8],ymm6[8],ymm9[9],ymm6[9],ymm9[10],ymm6[10],ymm9[11],ymm6[11],ymm9[12],ymm6[12],ymm9[13],ymm6[13],ymm9[14],ymm6[14],ymm9[15],ymm6[15],ymm9[24],ymm6[24],ymm9[25],ymm6[25],ymm9[26],ymm6[26],ymm9[27],ymm6[27],ymm9[28],ymm6[28],ymm9[29],ymm6[29],ymm9[30],ymm6[30],ymm9[31],ymm6[31]
	vpand	%ymm0, %ymm7, %ymm9
	vpmaddubsw	%ymm9, %ymm5, %ymm9
	vpaddw	%ymm12, %ymm9, %ymm12
	vmovdqa	%ymm12, 832(%rsp)               # 32-byte Spill
	vpand	%ymm0, %ymm6, %ymm9
	vpmaddubsw	%ymm9, %ymm5, %ymm9
	vmovdqa	(%rsp), %ymm12                  # 32-byte Reload
	vpaddw	%ymm12, %ymm9, %ymm12
	vmovdqa	%ymm12, (%rsp)                  # 32-byte Spill
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm0, %ymm7, %ymm7
	vpmaddubsw	%ymm7, %ymm5, %ymm7
	vpaddw	%ymm7, %ymm11, %ymm11
	vpsrlw	$4, %ymm6, %ymm6
	vpand	%ymm0, %ymm6, %ymm6
	vpmaddubsw	%ymm6, %ymm5, %ymm5
	vpaddw	%ymm5, %ymm10, %ymm10
	incl	%esi
	leaq	1(%rdx), %rdi
	cmpl	$16, %esi
	je	.LBB7_19
# %bb.17:                               #   in Loop: Header=BB7_13 Depth=1
	cmpq	%rcx, %rdi
	jae	.LBB7_19
# %bb.18:                               #   in Loop: Header=BB7_13 Depth=1
	vmovdqa	832(%rsp), %ymm12               # 32-byte Reload
	addq	$2, %rdx
	cmpq	%rcx, %rdi
	jb	.LBB7_13
.LBB7_21:
	vmovaps	320(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 864(%rsp)
	vmovaps	288(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 928(%rsp)
	vmovaps	768(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 896(%rsp)
	vmovaps	352(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 960(%rsp)
	vmovaps	384(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 992(%rsp)
	vmovaps	416(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1056(%rsp)
	vmovaps	448(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1024(%rsp)
	vmovaps	480(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1088(%rsp)
	vmovaps	512(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1120(%rsp)
	vmovaps	544(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1184(%rsp)
	vmovaps	576(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1152(%rsp)
	vmovaps	608(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1216(%rsp)
	vmovaps	640(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1248(%rsp)
	vmovaps	672(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1312(%rsp)
	vmovaps	704(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1280(%rsp)
	vmovaps	736(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1344(%rsp)
	vmovaps	32(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 1376(%rsp)
	vmovaps	64(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 1440(%rsp)
	vmovaps	96(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 1408(%rsp)
	vmovaps	128(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1472(%rsp)
	vmovaps	160(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1504(%rsp)
	vmovaps	192(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1568(%rsp)
	vmovaps	224(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1536(%rsp)
	vmovaps	256(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 1600(%rsp)
.LBB7_22:
	movq	32(%rbp), %rcx
	leal	(,%rax,8), %edx
	subl	%edx, %eax
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	movq	$-8, %rax
	.p2align	4, 0x90
.LBB7_23:                               # =>This Inner Loop Header: Depth=1
	vmovdqa	896(%rsp,%rax,4), %ymm1
	vpslld	$8, %ymm1, %ymm1
	vpaddd	1664(%rsp,%rax,4), %ymm0, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%rbx,%rax,4), %ymm1, %ymm1
	vaddps	32(%rcx,%rax,4), %ymm1, %ymm1
	vmovups	%ymm1, 32(%rcx,%rax,4)
	vmovdqa	928(%rsp,%rax,4), %ymm1
	vpslld	$8, %ymm1, %ymm1
	vpaddd	1696(%rsp,%rax,4), %ymm0, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	64(%rbx,%rax,4), %ymm1, %ymm1
	vaddps	64(%rcx,%rax,4), %ymm1, %ymm1
	vmovups	%ymm1, 64(%rcx,%rax,4)
	addq	$16, %rax
	cmpq	$184, %rax
	jb	.LBB7_23
# %bb.24:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end7:
	.size	_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf, .Lfunc_end7-_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf
                                        # -- End function
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0                          # -- Begin function _ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf
.LCPI8_0:
	.byte	255                             # 0xff
	.byte	0                               # 0x0
.LCPI8_5:
	.short	1                               # 0x1
.LCPI8_6:
	.byte	15                              # 0xf
	.zero	1
.LCPI8_7:
	.short	256                             # 0x100
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI8_1:
	.quad	-9187201950435737472            # 0x8080808080808080
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI8_2:
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
.LCPI8_3:
	.zero	32,15
.LCPI8_4:
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.section	.text._ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf,"ax",@progbits
	.globl	_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf,@function
_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf: # @_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	andq	$-32, %rsp
	subq	$640, %rsp                      # imm = 0x280
	vpbroadcastw	.LCPI8_0(%rip), %ymm1   # ymm1 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vmovdqu	(%rcx), %ymm3
	vmovdqu	32(%rcx), %ymm4
	vmovdqu	64(%rcx), %ymm5
	vmovdqu	96(%rcx), %ymm6
	vpand	%ymm1, %ymm3, %ymm0
	vpand	%ymm1, %ymm4, %ymm2
	vpackuswb	%ymm2, %ymm0, %ymm2
	vpsraw	$8, %ymm3, %ymm0
	vpsraw	$8, %ymm4, %ymm7
	vpacksswb	%ymm7, %ymm0, %ymm0
	vmovdqa	%ymm0, 32(%rsp)                 # 32-byte Spill
	vpbroadcastw	.LCPI8_5(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	vpmaddwd	%ymm0, %ymm3, %ymm3
	vpmaddwd	%ymm0, %ymm4, %ymm4
	vpaddd	%ymm3, %ymm4, %ymm4
	vpand	%ymm1, %ymm5, %ymm3
	vpand	%ymm1, %ymm6, %ymm7
	vpackuswb	%ymm7, %ymm3, %ymm3
	vpsraw	$8, %ymm5, %ymm7
	vpsraw	$8, %ymm6, %ymm9
	vpacksswb	%ymm9, %ymm7, %ymm7
	vmovdqa	%ymm7, (%rsp)                   # 32-byte Spill
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm4, %ymm6
	vmovdqu	128(%rcx), %ymm5
	vmovdqu	160(%rcx), %ymm7
	vpand	%ymm1, %ymm5, %ymm4
	vpand	%ymm1, %ymm7, %ymm10
	vpackuswb	%ymm10, %ymm4, %ymm4
	vpsraw	$8, %ymm5, %ymm10
	vpsraw	$8, %ymm7, %ymm11
	vpacksswb	%ymm11, %ymm10, %ymm10
	vpmaddwd	%ymm0, %ymm5, %ymm5
	vpmaddwd	%ymm0, %ymm7, %ymm7
	vpaddd	%ymm7, %ymm5, %ymm7
	vmovdqu	192(%rcx), %ymm12
	vmovdqu	224(%rcx), %ymm13
	vpand	%ymm1, %ymm12, %ymm5
	vpand	%ymm1, %ymm13, %ymm11
	vpackuswb	%ymm11, %ymm5, %ymm5
	vpsraw	$8, %ymm12, %ymm11
	vpsraw	$8, %ymm13, %ymm14
	vpacksswb	%ymm14, %ymm11, %ymm11
	vpmaddwd	%ymm0, %ymm12, %ymm12
	vpaddd	%ymm7, %ymm12, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm7
	vmovdqu	256(%rcx), %ymm6
	vmovdqu	288(%rcx), %ymm14
	vpand	%ymm1, %ymm6, %ymm12
	vpand	%ymm1, %ymm14, %ymm15
	vpackuswb	%ymm15, %ymm12, %ymm15
	vpsraw	$8, %ymm6, %ymm12
	vpsraw	$8, %ymm14, %ymm8
	vpacksswb	%ymm8, %ymm12, %ymm12
	vpmaddwd	%ymm0, %ymm13, %ymm8
	vpmaddwd	%ymm0, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm8, %ymm6
	vpmaddwd	%ymm0, %ymm14, %ymm8
	vpaddd	%ymm6, %ymm8, %ymm8
	vmovdqu	320(%rcx), %ymm13
	vmovdqu	352(%rcx), %ymm14
	vpand	%ymm1, %ymm13, %ymm6
	vpand	%ymm1, %ymm14, %ymm1
	vpackuswb	%ymm1, %ymm6, %ymm6
	vpsraw	$8, %ymm13, %ymm1
	vpsraw	$8, %ymm14, %ymm9
	vpacksswb	%ymm9, %ymm1, %ymm1
	vmovdqa	%ymm1, 64(%rsp)                 # 32-byte Spill
	vpbroadcastq	.LCPI8_1(%rip), %ymm9   # ymm9 = [9259542123273814144,9259542123273814144,9259542123273814144,9259542123273814144]
	vpermq	$216, %ymm2, %ymm1              # ymm1 = ymm2[0,2,1,3]
	vpxor	%ymm1, %ymm9, %ymm1
	vmovdqa	%ymm1, 320(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm3, %ymm2              # ymm2 = ymm3[0,2,1,3]
	vpxor	%ymm2, %ymm9, %ymm1
	vmovdqa	%ymm1, 288(%rsp)                # 32-byte Spill
	vmovdqa	%ymm0, %ymm2
	vpermq	$216, %ymm4, %ymm3              # ymm3 = ymm4[0,2,1,3]
	vpxor	%ymm3, %ymm9, %ymm0
	vmovdqa	%ymm0, 192(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm5, %ymm4              # ymm4 = ymm5[0,2,1,3]
	vpxor	%ymm4, %ymm9, %ymm0
	vmovdqa	%ymm0, 160(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm15, %ymm5             # ymm5 = ymm15[0,2,1,3]
	vpxor	%ymm5, %ymm9, %ymm0
	vmovdqa	%ymm0, 256(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm6, %ymm6              # ymm6 = ymm6[0,2,1,3]
	vpxor	%ymm6, %ymm9, %ymm15
	vpmaddwd	%ymm2, %ymm13, %ymm9
	vpaddd	%ymm9, %ymm8, %ymm8
	vpaddd	%ymm7, %ymm8, %ymm7
	vpmaddwd	%ymm2, %ymm14, %ymm8
	vpaddd	%ymm7, %ymm8, %ymm7
	vextracti128	$1, %ymm7, %xmm8
	vpaddd	%xmm7, %xmm8, %xmm7
	vpshufd	$78, %xmm7, %xmm8               # xmm8 = xmm7[2,3,0,1]
	vpaddd	%xmm7, %xmm8, %xmm7
	vpshufd	$85, %xmm7, %xmm8               # xmm8 = xmm7[1,1,1,1]
	vpaddd	%xmm7, %xmm8, %xmm7
	vmovd	%xmm7, %eax
	movl	%eax, %ecx
	shll	$3, %ecx
	negl	%ecx
	addl	%ecx, %eax
	addl	$172032, %eax                   # imm = 0x2A000
	vmovd	%eax, %xmm7
	vpbroadcastd	%xmm7, %ymm0
	vmovdqa	%ymm0, 128(%rsp)                # 32-byte Spill
	vpermpd	$216, 32(%rsp), %ymm0           # 32-byte Folded Reload
                                        # ymm0 = mem[0,2,1,3]
	vmovaps	%ymm0, 96(%rsp)                 # 32-byte Spill
	vpermpd	$216, (%rsp), %ymm0             # 32-byte Folded Reload
                                        # ymm0 = mem[0,2,1,3]
	vmovaps	%ymm0, 32(%rsp)                 # 32-byte Spill
	vpermq	$216, %ymm10, %ymm0             # ymm0 = ymm10[0,2,1,3]
	vmovdqa	%ymm0, (%rsp)                   # 32-byte Spill
	vpermq	$216, %ymm11, %ymm0             # ymm0 = ymm11[0,2,1,3]
	vmovdqa	%ymm0, 224(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm12, %ymm6             # ymm6 = ymm12[0,2,1,3]
	vpermq	$216, 64(%rsp), %ymm11          # 32-byte Folded Reload
                                        # ymm11 = mem[0,2,1,3]
	addq	$64, %rdi
	xorl	%eax, %eax
	vpbroadcastb	.LCPI8_6(%rip), %ymm14  # ymm14 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI8_7(%rip), %ymm8   # ymm8 = [256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256]
	vmovdqa	192(%rsp), %ymm9                # 32-byte Reload
	vmovdqa	160(%rsp), %ymm10               # 32-byte Reload
	vmovdqa	96(%rsp), %ymm13                # 32-byte Reload
	.p2align	4, 0x90
.LBB8_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB8_2 Depth 2
	movq	%rdi, %rcx
	xorl	%r9d, %r9d
	.p2align	4, 0x90
.LBB8_2:                                #   Parent Loop BB8_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	-64(%rcx), %ymm0
	vmovdqu	-32(%rcx), %ymm7
	vmovdqa	%ymm15, %ymm12
	vmovdqu	(%rcx), %ymm15
	vpsrlw	$4, %ymm0, %ymm1
	vpand	%ymm0, %ymm14, %ymm0
	vmovdqa	%ymm2, %ymm5
	vpmaddubsw	320(%rsp), %ymm0, %ymm2 # 32-byte Folded Reload
	vpand	%ymm1, %ymm14, %ymm1
	vpand	%ymm7, %ymm14, %ymm3
	vpmaddubsw	%ymm9, %ymm3, %ymm4
	vpaddw	%ymm4, %ymm2, %ymm2
	vpmaddubsw	288(%rsp), %ymm1, %ymm4 # 32-byte Folded Reload
	vpmaddubsw	%ymm13, %ymm0, %ymm0
	vpmaddubsw	32(%rsp), %ymm1, %ymm1  # 32-byte Folded Reload
	vpsrlw	$4, %ymm7, %ymm7
	vpaddw	%ymm2, %ymm4, %ymm2
	vpand	%ymm7, %ymm14, %ymm4
	vpmaddubsw	%ymm10, %ymm4, %ymm7
	vpmaddubsw	(%rsp), %ymm3, %ymm3    # 32-byte Folded Reload
	vpaddw	%ymm3, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm1, %ymm0
	vpand	%ymm14, %ymm15, %ymm1
	vpmaddubsw	256(%rsp), %ymm1, %ymm3 # 32-byte Folded Reload
	vpaddw	%ymm3, %ymm7, %ymm3
	vpsrlw	$4, %ymm15, %ymm7
	vmovdqa	%ymm12, %ymm15
	vpaddw	%ymm3, %ymm2, %ymm2
	vpand	%ymm7, %ymm14, %ymm3
	vpmaddubsw	%ymm12, %ymm3, %ymm7
	vpaddw	%ymm7, %ymm2, %ymm2
	vpmaddubsw	224(%rsp), %ymm4, %ymm4 # 32-byte Folded Reload
	vpmaddubsw	%ymm6, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm4, %ymm1
	vpaddw	%ymm1, %ymm0, %ymm0
	vpmaddubsw	%ymm11, %ymm3, %ymm1
	vpaddw	%ymm1, %ymm0, %ymm0
	vpmaddwd	%ymm0, %ymm8, %ymm0
	vpmaddwd	%ymm5, %ymm2, %ymm1
	vmovdqa	%ymm5, %ymm2
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovdqa	%ymm0, 352(%rsp,%r9)
	addq	$32, %r9
	addq	$96, %rcx
	cmpq	$256, %r9                       # imm = 0x100
	jne	.LBB8_2
# %bb.3:                                #   in Loop: Header=BB8_1 Depth=1
	vmovdqa	352(%rsp), %ymm7
	vmovdqa	416(%rsp), %ymm0
	vmovdqa	480(%rsp), %ymm1
	vphaddd	384(%rsp), %ymm7, %ymm7
	vphaddd	448(%rsp), %ymm0, %ymm0
	vmovdqa	544(%rsp), %ymm5
	vphaddd	%ymm0, %ymm7, %ymm0
	vphaddd	512(%rsp), %ymm1, %ymm1
	vphaddd	576(%rsp), %ymm5, %ymm7
	vphaddd	%ymm7, %ymm1, %ymm7
	vinserti128	$1, %xmm7, %ymm0, %ymm5
	vperm2i128	$49, %ymm7, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm7[2,3]
	vmovdqa	128(%rsp), %ymm1                # 32-byte Reload
	vpaddd	(%rdx,%rax,4), %ymm1, %ymm7
	vpaddd	%ymm5, %ymm7, %ymm7
	vpaddd	%ymm0, %ymm7, %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	(%rsi,%rax,4), %ymm0, %ymm0
	vaddps	(%r8,%rax,4), %ymm0, %ymm0
	vmovups	%ymm0, (%r8,%rax,4)
	leaq	8(%rax), %rcx
	addq	$768, %rdi                      # imm = 0x300
	cmpq	$184, %rax
	movq	%rcx, %rax
	jb	.LBB8_1
# %bb.4:
	movq	%rbp, %rsp
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end8:
	.size	_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf, .Lfunc_end8-_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
.LCPI9_0:
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
.LCPI9_3:
	.zero	32,15
.LCPI9_4:
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.short	256                             # 0x100
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI9_1:
	.byte	255                             # 0xff
	.byte	0                               # 0x0
.LCPI9_5:
	.short	1                               # 0x1
.LCPI9_6:
	.byte	15                              # 0xf
	.zero	1
.LCPI9_7:
	.short	256                             # 0x100
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI9_2:
	.quad	-9187201950435737472            # 0x8080808080808080
	.section	.text._ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf,"ax",@progbits
	.globl	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf,@function
_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf: # @_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
# %bb.0:
	testl	%r8d, %r8d
	jle	.LBB9_6
# %bb.1:
	pushq	%rbp
	movq	%rsp, %rbp
	andq	$-32, %rsp
	subq	$608, %rsp                      # imm = 0x260
	vmovdqu	(%rcx), %ymm2
	vmovdqu	32(%rcx), %ymm3
	vmovdqa	%ymm3, (%rsp)                   # 32-byte Spill
	vmovdqu	64(%rcx), %ymm1
	vmovdqu	96(%rcx), %ymm4
	vpbroadcastw	.LCPI9_5(%rip), %ymm0   # ymm0 = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
	vpmaddwd	%ymm0, %ymm2, %ymm5
	vpmaddwd	%ymm0, %ymm3, %ymm6
	vpaddd	%ymm5, %ymm6, %ymm5
	vpmaddwd	%ymm0, %ymm1, %ymm6
	vpmaddwd	%ymm0, %ymm4, %ymm7
	vpaddd	%ymm7, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm5, %ymm9
	vmovdqu	128(%rcx), %ymm5
	vmovdqu	160(%rcx), %ymm6
	vpmaddwd	%ymm0, %ymm5, %ymm7
	vpmaddwd	%ymm0, %ymm6, %ymm8
	vpaddd	%ymm7, %ymm8, %ymm10
	vmovdqu	192(%rcx), %ymm7
	vmovdqu	224(%rcx), %ymm8
	vpmaddwd	%ymm0, %ymm7, %ymm11
	vpaddd	%ymm11, %ymm10, %ymm10
	vpaddd	%ymm10, %ymm9, %ymm11
	vpmaddwd	%ymm0, %ymm8, %ymm12
	vmovdqu	256(%rcx), %ymm9
	vmovdqu	288(%rcx), %ymm10
	vpmaddwd	%ymm0, %ymm9, %ymm13
	vpaddd	%ymm13, %ymm12, %ymm12
	vpmaddwd	%ymm0, %ymm10, %ymm13
	vpaddd	%ymm13, %ymm12, %ymm12
	vmovdqu	320(%rcx), %ymm14
	vmovdqu	352(%rcx), %ymm15
	vpmaddwd	%ymm0, %ymm14, %ymm13
	vpaddd	%ymm13, %ymm12, %ymm12
	vpaddd	%ymm12, %ymm11, %ymm11
	vpmaddwd	%ymm0, %ymm15, %ymm12
	vpaddd	%ymm12, %ymm11, %ymm11
	vextracti128	$1, %ymm11, %xmm12
	vpaddd	%xmm11, %xmm12, %xmm11
	vpshufd	$78, %xmm11, %xmm12             # xmm12 = xmm11[2,3,0,1]
	vpaddd	%xmm11, %xmm12, %xmm11
	vpshufd	$85, %xmm11, %xmm12             # xmm12 = xmm11[1,1,1,1]
	vpaddd	%xmm11, %xmm12, %xmm11
	vmovd	%xmm11, %eax
	movl	%eax, %ecx
	shll	$3, %ecx
	negl	%ecx
	addl	%ecx, %eax
	addl	$172032, %eax                   # imm = 0x2A000
	vpsraw	$8, %ymm14, %ymm11
	vpsraw	$8, %ymm15, %ymm12
	vpacksswb	%ymm12, %ymm11, %ymm0
	vmovdqa	%ymm0, 64(%rsp)                 # 32-byte Spill
	vpbroadcastw	.LCPI9_1(%rip), %ymm11  # ymm11 = [255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0,255,0]
	vpand	%ymm11, %ymm14, %ymm12
	vpand	%ymm11, %ymm15, %ymm14
	vpackuswb	%ymm14, %ymm12, %ymm14
	vpsraw	$8, %ymm9, %ymm12
	vpsraw	$8, %ymm10, %ymm15
	vpacksswb	%ymm15, %ymm12, %ymm0
	vmovdqa	%ymm0, 32(%rsp)                 # 32-byte Spill
	vpand	%ymm11, %ymm9, %ymm9
	vpand	%ymm11, %ymm10, %ymm10
	vpackuswb	%ymm10, %ymm9, %ymm3
	vpsraw	$8, %ymm7, %ymm10
	vpsraw	$8, %ymm8, %ymm15
	vpacksswb	%ymm15, %ymm10, %ymm15
	vpand	%ymm7, %ymm11, %ymm7
	vpand	%ymm11, %ymm8, %ymm8
	vpackuswb	%ymm8, %ymm7, %ymm12
	vpsraw	$8, %ymm5, %ymm8
	vpsraw	$8, %ymm6, %ymm10
	vpacksswb	%ymm10, %ymm8, %ymm13
	vpand	%ymm5, %ymm11, %ymm5
	vpand	%ymm6, %ymm11, %ymm6
	vpackuswb	%ymm6, %ymm5, %ymm5
	vpsraw	$8, %ymm1, %ymm6
	vpsraw	$8, %ymm4, %ymm8
	vpacksswb	%ymm8, %ymm6, %ymm10
	vpand	%ymm1, %ymm11, %ymm1
	vpand	%ymm4, %ymm11, %ymm4
	vpackuswb	%ymm4, %ymm1, %ymm6
	vpsraw	$8, %ymm2, %ymm1
	vmovdqa	(%rsp), %ymm7                   # 32-byte Reload
	vpsraw	$8, %ymm7, %ymm4
	vpacksswb	%ymm4, %ymm1, %ymm9
	vmovd	%eax, %xmm1
	vpbroadcastd	%xmm1, %ymm0
	vmovdqa	%ymm0, 160(%rsp)                # 32-byte Spill
	vpand	%ymm2, %ymm11, %ymm8
	vpand	%ymm7, %ymm11, %ymm11
	vpbroadcastq	.LCPI9_2(%rip), %ymm7   # ymm7 = [9259542123273814144,9259542123273814144,9259542123273814144,9259542123273814144]
	vpermq	$216, %ymm14, %ymm2             # ymm2 = ymm14[0,2,1,3]
	vpxor	%ymm7, %ymm2, %ymm0
	vmovdqa	%ymm0, (%rsp)                   # 32-byte Spill
	vpermq	$216, %ymm3, %ymm3              # ymm3 = ymm3[0,2,1,3]
	vpxor	%ymm7, %ymm3, %ymm0
	vmovdqa	%ymm0, 288(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm12, %ymm4             # ymm4 = ymm12[0,2,1,3]
	vpxor	%ymm7, %ymm4, %ymm0
	vmovdqa	%ymm0, 128(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm5, %ymm5              # ymm5 = ymm5[0,2,1,3]
	vpxor	%ymm7, %ymm5, %ymm5
	vpermq	$216, %ymm6, %ymm6              # ymm6 = ymm6[0,2,1,3]
	vpxor	%ymm7, %ymm6, %ymm0
	vmovdqa	%ymm0, 256(%rsp)                # 32-byte Spill
	vpackuswb	%ymm11, %ymm8, %ymm8
	vpermq	$216, %ymm8, %ymm8              # ymm8 = ymm8[0,2,1,3]
	vpxor	%ymm7, %ymm8, %ymm11
	movl	%r8d, %eax
	vpermq	$216, %ymm9, %ymm0              # ymm0 = ymm9[0,2,1,3]
	vmovdqa	%ymm0, 96(%rsp)                 # 32-byte Spill
	vpermq	$216, %ymm10, %ymm0             # ymm0 = ymm10[0,2,1,3]
	vmovdqa	%ymm0, 224(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm13, %ymm0             # ymm0 = ymm13[0,2,1,3]
	vmovdqa	%ymm0, 192(%rsp)                # 32-byte Spill
	vpermq	$216, %ymm15, %ymm9             # ymm9 = ymm15[0,2,1,3]
	vpermq	$216, 32(%rsp), %ymm13          # 32-byte Folded Reload
                                        # ymm13 = mem[0,2,1,3]
	vpermq	$216, 64(%rsp), %ymm2           # 32-byte Folded Reload
                                        # ymm2 = mem[0,2,1,3]
	addq	$64, %rdi
	xorl	%ecx, %ecx
	vpbroadcastb	.LCPI9_6(%rip), %ymm14  # ymm14 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpbroadcastw	.LCPI9_7(%rip), %ymm4   # ymm4 = [256,256,256,256,256,256,256,256,256,256,256,256,256,256,256,256]
	vmovdqa	128(%rsp), %ymm8                # 32-byte Reload
	vmovdqa	96(%rsp), %ymm12                # 32-byte Reload
	.p2align	4, 0x90
.LBB9_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB9_3 Depth 2
	movq	%rdi, %r8
	xorl	%r10d, %r10d
	.p2align	4, 0x90
.LBB9_3:                                #   Parent Loop BB9_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovdqu	-64(%r8), %ymm0
	vmovdqu	-32(%r8), %ymm1
	vmovdqu	(%r8), %ymm15
	vmovdqa	%ymm2, %ymm6
	vpsrlw	$4, %ymm0, %ymm2
	vpand	%ymm0, %ymm14, %ymm0
	vpmaddubsw	%ymm11, %ymm0, %ymm3
	vpand	%ymm2, %ymm14, %ymm2
	vmovdqa	%ymm4, %ymm7
	vpand	%ymm1, %ymm14, %ymm4
	vmovdqa	%ymm9, %ymm10
	vmovdqa	%ymm5, %ymm9
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm3, %ymm3
	vpmaddubsw	256(%rsp), %ymm2, %ymm5 # 32-byte Folded Reload
	vpmaddubsw	%ymm12, %ymm0, %ymm0
	vpmaddubsw	224(%rsp), %ymm2, %ymm2 # 32-byte Folded Reload
	vpsrlw	$4, %ymm1, %ymm1
	vpaddw	%ymm3, %ymm5, %ymm3
	vpand	%ymm1, %ymm14, %ymm1
	vpmaddubsw	%ymm8, %ymm1, %ymm5
	vpmaddubsw	192(%rsp), %ymm4, %ymm4 # 32-byte Folded Reload
	vpaddw	%ymm4, %ymm0, %ymm0
	vpaddw	%ymm0, %ymm2, %ymm0
	vpand	%ymm14, %ymm15, %ymm2
	vpmaddubsw	288(%rsp), %ymm2, %ymm4 # 32-byte Folded Reload
	vpaddw	%ymm4, %ymm5, %ymm4
	vpsrlw	$4, %ymm15, %ymm5
	vpaddw	%ymm4, %ymm3, %ymm3
	vpand	%ymm5, %ymm14, %ymm4
	vpmaddubsw	(%rsp), %ymm4, %ymm5    # 32-byte Folded Reload
	vpaddw	%ymm5, %ymm3, %ymm3
	vmovdqa	%ymm9, %ymm5
	vmovdqa	%ymm10, %ymm9
	vpmaddubsw	%ymm10, %ymm1, %ymm1
	vpmaddubsw	%ymm13, %ymm2, %ymm2
	vpaddw	%ymm2, %ymm1, %ymm1
	vmovdqa	%ymm6, %ymm2
	vpaddw	%ymm1, %ymm0, %ymm0
	vpmaddubsw	%ymm6, %ymm4, %ymm1
	vmovdqa	%ymm7, %ymm4
	vpaddw	%ymm1, %ymm0, %ymm0
	vpmaddwd	%ymm7, %ymm0, %ymm0
	vpmaddwd	.LCPI9_0(%rip), %ymm3, %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	vmovdqa	%ymm0, 320(%rsp,%r10)
	addq	$32, %r10
	addq	$96, %r8
	cmpq	$256, %r10                      # imm = 0x100
	jne	.LBB9_3
# %bb.4:                                #   in Loop: Header=BB9_2 Depth=1
	vmovdqa	320(%rsp), %ymm1
	vmovdqa	384(%rsp), %ymm0
	vmovdqa	448(%rsp), %ymm6
	vphaddd	352(%rsp), %ymm1, %ymm1
	vphaddd	416(%rsp), %ymm0, %ymm0
	vmovdqa	512(%rsp), %ymm7
	vphaddd	%ymm0, %ymm1, %ymm0
	vphaddd	480(%rsp), %ymm6, %ymm6
	vphaddd	544(%rsp), %ymm7, %ymm1
	vphaddd	%ymm1, %ymm6, %ymm1
	vinserti128	$1, %xmm1, %ymm0, %ymm6
	vperm2i128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovdqa	160(%rsp), %ymm1                # 32-byte Reload
	vpaddd	(%rdx,%rcx,4), %ymm1, %ymm1
	vpaddd	%ymm6, %ymm1, %ymm1
	vpaddd	%ymm0, %ymm1, %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	(%rsi,%rcx,4), %ymm0, %ymm0
	vmovups	%ymm0, (%r9,%rcx,4)
	addq	$8, %rcx
	addq	$768, %rdi                      # imm = 0x300
	cmpq	%rax, %rcx
	jb	.LBB9_2
# %bb.5:
	movq	%rbp, %rsp
	popq	%rbp
.LBB9_6:
	vzeroupper
	retq
.Lfunc_end9:
	.size	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf, .Lfunc_end9-_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
                                        # -- End function
	.type	_ZN3fx23opt12_GLOBAL__N_14kPosE,@object # @_ZN3fx23opt12_GLOBAL__N_14kPosE
	.section	.rodata._ZN3fx23opt12_GLOBAL__N_14kPosE,"a",@progbits
	.p2align	3, 0x0
_ZN3fx23opt12_GLOBAL__N_14kPosE:
	.quad	0                               # 0x0
	.quad	0                               # 0x0
	.quad	1                               # 0x1
	.quad	256                             # 0x100
	.quad	2                               # 0x2
	.quad	512                             # 0x200
	.quad	513                             # 0x201
	.quad	131328                          # 0x20100
	.quad	3                               # 0x3
	.quad	768                             # 0x300
	.quad	769                             # 0x301
	.quad	196864                          # 0x30100
	.quad	770                             # 0x302
	.quad	197120                          # 0x30200
	.quad	197121                          # 0x30201
	.quad	50462976                        # 0x3020100
	.quad	4                               # 0x4
	.quad	1024                            # 0x400
	.quad	1025                            # 0x401
	.quad	262400                          # 0x40100
	.quad	1026                            # 0x402
	.quad	262656                          # 0x40200
	.quad	262657                          # 0x40201
	.quad	67240192                        # 0x4020100
	.quad	1027                            # 0x403
	.quad	262912                          # 0x40300
	.quad	262913                          # 0x40301
	.quad	67305728                        # 0x4030100
	.quad	262914                          # 0x40302
	.quad	67305984                        # 0x4030200
	.quad	67305985                        # 0x4030201
	.quad	17230332160                     # 0x403020100
	.quad	5                               # 0x5
	.quad	1280                            # 0x500
	.quad	1281                            # 0x501
	.quad	327936                          # 0x50100
	.quad	1282                            # 0x502
	.quad	328192                          # 0x50200
	.quad	328193                          # 0x50201
	.quad	84017408                        # 0x5020100
	.quad	1283                            # 0x503
	.quad	328448                          # 0x50300
	.quad	328449                          # 0x50301
	.quad	84082944                        # 0x5030100
	.quad	328450                          # 0x50302
	.quad	84083200                        # 0x5030200
	.quad	84083201                        # 0x5030201
	.quad	21525299456                     # 0x503020100
	.quad	1284                            # 0x504
	.quad	328704                          # 0x50400
	.quad	328705                          # 0x50401
	.quad	84148480                        # 0x5040100
	.quad	328706                          # 0x50402
	.quad	84148736                        # 0x5040200
	.quad	84148737                        # 0x5040201
	.quad	21542076672                     # 0x504020100
	.quad	328707                          # 0x50403
	.quad	84148992                        # 0x5040300
	.quad	84148993                        # 0x5040301
	.quad	21542142208                     # 0x504030100
	.quad	84148994                        # 0x5040302
	.quad	21542142464                     # 0x504030200
	.quad	21542142465                     # 0x504030201
	.quad	5514788471040                   # 0x50403020100
	.quad	6                               # 0x6
	.quad	1536                            # 0x600
	.quad	1537                            # 0x601
	.quad	393472                          # 0x60100
	.quad	1538                            # 0x602
	.quad	393728                          # 0x60200
	.quad	393729                          # 0x60201
	.quad	100794624                       # 0x6020100
	.quad	1539                            # 0x603
	.quad	393984                          # 0x60300
	.quad	393985                          # 0x60301
	.quad	100860160                       # 0x6030100
	.quad	393986                          # 0x60302
	.quad	100860416                       # 0x6030200
	.quad	100860417                       # 0x6030201
	.quad	25820266752                     # 0x603020100
	.quad	1540                            # 0x604
	.quad	394240                          # 0x60400
	.quad	394241                          # 0x60401
	.quad	100925696                       # 0x6040100
	.quad	394242                          # 0x60402
	.quad	100925952                       # 0x6040200
	.quad	100925953                       # 0x6040201
	.quad	25837043968                     # 0x604020100
	.quad	394243                          # 0x60403
	.quad	100926208                       # 0x6040300
	.quad	100926209                       # 0x6040301
	.quad	25837109504                     # 0x604030100
	.quad	100926210                       # 0x6040302
	.quad	25837109760                     # 0x604030200
	.quad	25837109761                     # 0x604030201
	.quad	6614300098816                   # 0x60403020100
	.quad	1541                            # 0x605
	.quad	394496                          # 0x60500
	.quad	394497                          # 0x60501
	.quad	100991232                       # 0x6050100
	.quad	394498                          # 0x60502
	.quad	100991488                       # 0x6050200
	.quad	100991489                       # 0x6050201
	.quad	25853821184                     # 0x605020100
	.quad	394499                          # 0x60503
	.quad	100991744                       # 0x6050300
	.quad	100991745                       # 0x6050301
	.quad	25853886720                     # 0x605030100
	.quad	100991746                       # 0x6050302
	.quad	25853886976                     # 0x605030200
	.quad	25853886977                     # 0x605030201
	.quad	6618595066112                   # 0x60503020100
	.quad	394500                          # 0x60504
	.quad	100992000                       # 0x6050400
	.quad	100992001                       # 0x6050401
	.quad	25853952256                     # 0x605040100
	.quad	100992002                       # 0x6050402
	.quad	25853952512                     # 0x605040200
	.quad	25853952513                     # 0x605040201
	.quad	6618611843328                   # 0x60504020100
	.quad	100992003                       # 0x6050403
	.quad	25853952768                     # 0x605040300
	.quad	25853952769                     # 0x605040301
	.quad	6618611908864                   # 0x60504030100
	.quad	25853952770                     # 0x605040302
	.quad	6618611909120                   # 0x60504030200
	.quad	6618611909121                   # 0x60504030201
	.quad	1694364648734976                # 0x6050403020100
	.quad	7                               # 0x7
	.quad	1792                            # 0x700
	.quad	1793                            # 0x701
	.quad	459008                          # 0x70100
	.quad	1794                            # 0x702
	.quad	459264                          # 0x70200
	.quad	459265                          # 0x70201
	.quad	117571840                       # 0x7020100
	.quad	1795                            # 0x703
	.quad	459520                          # 0x70300
	.quad	459521                          # 0x70301
	.quad	117637376                       # 0x7030100
	.quad	459522                          # 0x70302
	.quad	117637632                       # 0x7030200
	.quad	117637633                       # 0x7030201
	.quad	30115234048                     # 0x703020100
	.quad	1796                            # 0x704
	.quad	459776                          # 0x70400
	.quad	459777                          # 0x70401
	.quad	117702912                       # 0x7040100
	.quad	459778                          # 0x70402
	.quad	117703168                       # 0x7040200
	.quad	117703169                       # 0x7040201
	.quad	30132011264                     # 0x704020100
	.quad	459779                          # 0x70403
	.quad	117703424                       # 0x7040300
	.quad	117703425                       # 0x7040301
	.quad	30132076800                     # 0x704030100
	.quad	117703426                       # 0x7040302
	.quad	30132077056                     # 0x704030200
	.quad	30132077057                     # 0x704030201
	.quad	7713811726592                   # 0x70403020100
	.quad	1797                            # 0x705
	.quad	460032                          # 0x70500
	.quad	460033                          # 0x70501
	.quad	117768448                       # 0x7050100
	.quad	460034                          # 0x70502
	.quad	117768704                       # 0x7050200
	.quad	117768705                       # 0x7050201
	.quad	30148788480                     # 0x705020100
	.quad	460035                          # 0x70503
	.quad	117768960                       # 0x7050300
	.quad	117768961                       # 0x7050301
	.quad	30148854016                     # 0x705030100
	.quad	117768962                       # 0x7050302
	.quad	30148854272                     # 0x705030200
	.quad	30148854273                     # 0x705030201
	.quad	7718106693888                   # 0x70503020100
	.quad	460036                          # 0x70504
	.quad	117769216                       # 0x7050400
	.quad	117769217                       # 0x7050401
	.quad	30148919552                     # 0x705040100
	.quad	117769218                       # 0x7050402
	.quad	30148919808                     # 0x705040200
	.quad	30148919809                     # 0x705040201
	.quad	7718123471104                   # 0x70504020100
	.quad	117769219                       # 0x7050403
	.quad	30148920064                     # 0x705040300
	.quad	30148920065                     # 0x705040301
	.quad	7718123536640                   # 0x70504030100
	.quad	30148920066                     # 0x705040302
	.quad	7718123536896                   # 0x70504030200
	.quad	7718123536897                   # 0x70504030201
	.quad	1975839625445632                # 0x7050403020100
	.quad	1798                            # 0x706
	.quad	460288                          # 0x70600
	.quad	460289                          # 0x70601
	.quad	117833984                       # 0x7060100
	.quad	460290                          # 0x70602
	.quad	117834240                       # 0x7060200
	.quad	117834241                       # 0x7060201
	.quad	30165565696                     # 0x706020100
	.quad	460291                          # 0x70603
	.quad	117834496                       # 0x7060300
	.quad	117834497                       # 0x7060301
	.quad	30165631232                     # 0x706030100
	.quad	117834498                       # 0x7060302
	.quad	30165631488                     # 0x706030200
	.quad	30165631489                     # 0x706030201
	.quad	7722401661184                   # 0x70603020100
	.quad	460292                          # 0x70604
	.quad	117834752                       # 0x7060400
	.quad	117834753                       # 0x7060401
	.quad	30165696768                     # 0x706040100
	.quad	117834754                       # 0x7060402
	.quad	30165697024                     # 0x706040200
	.quad	30165697025                     # 0x706040201
	.quad	7722418438400                   # 0x70604020100
	.quad	117834755                       # 0x7060403
	.quad	30165697280                     # 0x706040300
	.quad	30165697281                     # 0x706040301
	.quad	7722418503936                   # 0x70604030100
	.quad	30165697282                     # 0x706040302
	.quad	7722418504192                   # 0x70604030200
	.quad	7722418504193                   # 0x70604030201
	.quad	1976939137073408                # 0x7060403020100
	.quad	460293                          # 0x70605
	.quad	117835008                       # 0x7060500
	.quad	117835009                       # 0x7060501
	.quad	30165762304                     # 0x706050100
	.quad	117835010                       # 0x7060502
	.quad	30165762560                     # 0x706050200
	.quad	30165762561                     # 0x706050201
	.quad	7722435215616                   # 0x70605020100
	.quad	117835011                       # 0x7060503
	.quad	30165762816                     # 0x706050300
	.quad	30165762817                     # 0x706050301
	.quad	7722435281152                   # 0x70605030100
	.quad	30165762818                     # 0x706050302
	.quad	7722435281408                   # 0x70605030200
	.quad	7722435281409                   # 0x70605030201
	.quad	1976943432040704                # 0x7060503020100
	.quad	117835012                       # 0x7060504
	.quad	30165763072                     # 0x706050400
	.quad	30165763073                     # 0x706050401
	.quad	7722435346688                   # 0x70605040100
	.quad	30165763074                     # 0x706050402
	.quad	7722435346944                   # 0x70605040200
	.quad	7722435346945                   # 0x70605040201
	.quad	1976943448817920                # 0x7060504020100
	.quad	30165763075                     # 0x706050403
	.quad	7722435347200                   # 0x70605040300
	.quad	7722435347201                   # 0x70605040301
	.quad	1976943448883456                # 0x7060504030100
	.quad	7722435347202                   # 0x70605040302
	.quad	1976943448883712                # 0x7060504030200
	.quad	1976943448883713                # 0x7060504030201
	.quad	506097522914230528              # 0x706050403020100
	.size	_ZN3fx23opt12_GLOBAL__N_14kPosE, 2048

	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
