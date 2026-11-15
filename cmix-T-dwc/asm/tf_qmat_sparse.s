	.text
	.file	"qmat_sparse.cpp"
	.section	.text._ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf,"ax",@progbits
	.globl	_ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf # -- Begin function _ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf,@function
_ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf: # @_ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%r8, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	movq	(%rdi), %rdi
	movq	%rsp, %r8
	callq	_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi
	vcvtdq2ps	(%rsp), %ymm0
	vmulps	(%r14), %ymm0, %ymm0
	vmovups	%ymm0, (%rbx)
	vcvtdq2ps	32(%rsp), %ymm0
	vmulps	32(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 32(%rbx)
	vcvtdq2ps	64(%rsp), %ymm0
	vmulps	64(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 64(%rbx)
	vcvtdq2ps	96(%rsp), %ymm0
	vmulps	96(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 96(%rbx)
	vcvtdq2ps	128(%rsp), %ymm0
	vmulps	128(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 128(%rbx)
	vcvtdq2ps	160(%rsp), %ymm0
	vmulps	160(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 160(%rbx)
	vcvtdq2ps	192(%rsp), %ymm0
	vmulps	192(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 192(%rbx)
	vcvtdq2ps	224(%rsp), %ymm0
	vmulps	224(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 224(%rbx)
	vcvtdq2ps	256(%rsp), %ymm0
	vmulps	256(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 256(%rbx)
	vcvtdq2ps	288(%rsp), %ymm0
	vmulps	288(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 288(%rbx)
	vcvtdq2ps	320(%rsp), %ymm0
	vmulps	320(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 320(%rbx)
	vcvtdq2ps	352(%rsp), %ymm0
	vmulps	352(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 352(%rbx)
	vcvtdq2ps	384(%rsp), %ymm0
	vmulps	384(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 384(%rbx)
	vcvtdq2ps	416(%rsp), %ymm0
	vmulps	416(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 416(%rbx)
	vcvtdq2ps	448(%rsp), %ymm0
	vmulps	448(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 448(%rbx)
	vcvtdq2ps	480(%rsp), %ymm0
	vmulps	480(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 480(%rbx)
	vcvtdq2ps	512(%rsp), %ymm0
	vmulps	512(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 512(%rbx)
	vcvtdq2ps	544(%rsp), %ymm0
	vmulps	544(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 544(%rbx)
	vcvtdq2ps	576(%rsp), %ymm0
	vmulps	576(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 576(%rbx)
	vcvtdq2ps	608(%rsp), %ymm0
	vmulps	608(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 608(%rbx)
	vcvtdq2ps	640(%rsp), %ymm0
	vmulps	640(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 640(%rbx)
	vcvtdq2ps	672(%rsp), %ymm0
	vmulps	672(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 672(%rbx)
	vcvtdq2ps	704(%rsp), %ymm0
	vmulps	704(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 704(%rbx)
	vcvtdq2ps	736(%rsp), %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end0:
	.size	_ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf, .Lfunc_end0-_ZN3fx23opt11qsparse_f32ERKNS0_7QSparseEPKhPKtiPf
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi
	.type	_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi,@function
_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi: # @_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$776, %rsp                      # imm = 0x308
	movq	%r8, %rbx
	movl	%ecx, %ebp
	movq	%rdx, %r12
	movq	%rsi, %r15
	movq	%rdi, %r14
	xorl	%r13d, %r13d
	movl	$768, %edx                      # imm = 0x300
	movq	%r8, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	cmpl	$2, %ebp
	jl	.LBB1_8
# %bb.1:
	movl	%ebp, %eax
	shrl	$31, %eax
	addl	%ebp, %eax
	sarl	%eax
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%ymm0, 320(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 192(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 160(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 128(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 384(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	vmovdqu	%ymm0, 352(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	jmp	.LBB1_2
	.p2align	4, 0x90
.LBB1_3:                                #   in Loop: Header=BB1_2 Depth=1
	movl	%r13d, %ecx
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
.LBB1_6:                                #   in Loop: Header=BB1_2 Depth=1
	vmovdqu	32(%rsp), %ymm7                 # 32-byte Reload
	vmovdqu	(%rsp), %ymm6                   # 32-byte Reload
	vpmovsxwd	%xmm3, %ymm4
	vmovdqu	64(%rsp), %ymm5                 # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqu	%ymm5, 64(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vmovdqu	352(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm4, 352(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm2, %ymm3
	vmovdqu	736(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, (%rsp)                   # 32-byte Spill
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm7
	vmovdqu	%ymm7, 32(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vmovdqu	384(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 384(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm0, %ymm1
	vmovdqu	96(%rsp), %ymm2                 # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 96(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	128(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm15, %ymm0
	vmovdqu	160(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm15, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	192(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm14, %ymm0
	vmovdqu	224(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 224(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm14, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	256(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 256(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm13, %ymm0
	vmovdqu	288(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm13, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	320(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 320(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm12, %ymm0
	vmovdqu	416(%rsp), %ymm15               # 32-byte Reload
	vpaddd	%ymm0, %ymm15, %ymm15
	vextracti128	$1, %ymm12, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	448(%rsp), %ymm14               # 32-byte Reload
	vpaddd	%ymm0, %ymm14, %ymm14
	vpmovsxwd	%xmm11, %ymm0
	vmovdqu	480(%rsp), %ymm13               # 32-byte Reload
	vpaddd	%ymm0, %ymm13, %ymm13
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	512(%rsp), %ymm12               # 32-byte Reload
	vpaddd	%ymm0, %ymm12, %ymm12
	vpmovsxwd	%xmm10, %ymm0
	vmovdqu	544(%rsp), %ymm11               # 32-byte Reload
	vpaddd	%ymm0, %ymm11, %ymm11
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	576(%rsp), %ymm10               # 32-byte Reload
	vpaddd	%ymm0, %ymm10, %ymm10
	vpmovsxwd	%xmm9, %ymm0
	vmovdqu	608(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm0, %ymm5, %ymm5
	vextracti128	$1, %ymm9, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	640(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm0, %ymm3, %ymm3
	vpmovsxwd	%xmm8, %ymm0
	vmovdqu	672(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm0, %ymm2, %ymm2
	vextracti128	$1, %ymm8, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	704(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	movl	%ecx, %r13d
	cmpl	%eax, %ecx
	jge	.LBB1_7
.LBB1_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB1_5 Depth 2
	leal	18(%r13), %ecx
	cmpl	%ecx, %eax
	cmovll	%eax, %ecx
	cmpl	%ecx, %r13d
	vmovdqu	%ymm4, 736(%rsp)                # 32-byte Spill
	vmovdqu	%ymm1, 704(%rsp)                # 32-byte Spill
	vmovdqu	%ymm2, 672(%rsp)                # 32-byte Spill
	vmovdqu	%ymm3, 640(%rsp)                # 32-byte Spill
	vmovdqu	%ymm5, 608(%rsp)                # 32-byte Spill
	vmovdqu	%ymm10, 576(%rsp)               # 32-byte Spill
	vmovdqu	%ymm11, 544(%rsp)               # 32-byte Spill
	vmovdqu	%ymm12, 512(%rsp)               # 32-byte Spill
	vmovdqu	%ymm13, 480(%rsp)               # 32-byte Spill
	vmovdqu	%ymm14, 448(%rsp)               # 32-byte Spill
	vmovdqu	%ymm15, 416(%rsp)               # 32-byte Spill
	jge	.LBB1_3
# %bb.4:                                #   in Loop: Header=BB1_2 Depth=1
	movslq	%r13d, %rsi
	movslq	%ecx, %rdx
	subq	%rsi, %rdx
	addl	%r13d, %r13d
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB1_5:                                #   Parent Loop BB1_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	%r13d, %r13
	movzwl	(%r12,%r13,2), %r8d
	leal	1(%r13), %esi
	movslq	%esi, %rsi
	movzwl	(%r12,%rsi,2), %r9d
	leal	8(%r13), %esi
	movslq	%esi, %rsi
	movzwl	(%r12,%rsi,2), %esi
	leaq	(%rsi,%rsi,2), %rsi
	shlq	$6, %rsi
	leal	9(%r13), %edi
	movslq	%edi, %rdi
	movzwl	(%r12,%rdi,2), %edi
	leaq	(%rdi,%rdi,2), %rdi
	shlq	$6, %rdi
	prefetcht0	(%r14,%rsi)
	prefetcht0	64(%r14,%rsi)
	prefetcht0	128(%r14,%rsi)
	prefetcht0	(%r14,%rdi)
	prefetcht0	64(%r14,%rdi)
	prefetcht0	128(%r14,%rdi)
	leaq	(%r8,%r8,2), %rsi
	shlq	$6, %rsi
	leaq	(%r9,%r9,2), %rdi
	shlq	$6, %rdi
	movzbl	(%r15,%r8), %r8d
	movzbl	(%r15,%r9), %r9d
	shll	$8, %r9d
	orl	%r8d, %r9d
	vmovd	%r9d, %xmm4
	vpbroadcastw	%xmm4, %ymm4
	vmovdqa	(%r14,%rsi), %ymm5
	vmovdqa	(%r14,%rdi), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm3, %ymm7, %ymm3
	vmovdqa	32(%r14,%rsi), %ymm7
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vmovdqa	32(%r14,%rdi), %ymm6
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm2
	vpunpcklbw	%ymm6, %ymm7, %ymm5     # ymm5 = ymm7[0],ymm6[0],ymm7[1],ymm6[1],ymm7[2],ymm6[2],ymm7[3],ymm6[3],ymm7[4],ymm6[4],ymm7[5],ymm6[5],ymm7[6],ymm6[6],ymm7[7],ymm6[7],ymm7[16],ymm6[16],ymm7[17],ymm6[17],ymm7[18],ymm6[18],ymm7[19],ymm6[19],ymm7[20],ymm6[20],ymm7[21],ymm6[21],ymm7[22],ymm6[22],ymm7[23],ymm6[23]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqa	64(%r14,%rsi), %ymm5
	vpunpckhbw	%ymm6, %ymm7, %ymm6     # ymm6 = ymm7[8],ymm6[8],ymm7[9],ymm6[9],ymm7[10],ymm6[10],ymm7[11],ymm6[11],ymm7[12],ymm6[12],ymm7[13],ymm6[13],ymm7[14],ymm6[14],ymm7[15],ymm6[15],ymm7[24],ymm6[24],ymm7[25],ymm6[25],ymm7[26],ymm6[26],ymm7[27],ymm6[27],ymm7[28],ymm6[28],ymm7[29],ymm6[29],ymm7[30],ymm6[30],ymm7[31],ymm6[31]
	vmovdqa	64(%r14,%rdi), %ymm7
	vpmaddubsw	%ymm6, %ymm4, %ymm6
	vpaddw	%ymm0, %ymm6, %ymm0
	vpunpcklbw	%ymm7, %ymm5, %ymm6     # ymm6 = ymm5[0],ymm7[0],ymm5[1],ymm7[1],ymm5[2],ymm7[2],ymm5[3],ymm7[3],ymm5[4],ymm7[4],ymm5[5],ymm7[5],ymm5[6],ymm7[6],ymm5[7],ymm7[7],ymm5[16],ymm7[16],ymm5[17],ymm7[17],ymm5[18],ymm7[18],ymm5[19],ymm7[19],ymm5[20],ymm7[20],ymm5[21],ymm7[21],ymm5[22],ymm7[22],ymm5[23],ymm7[23]
	vpmaddubsw	%ymm6, %ymm4, %ymm6
	vpaddw	%ymm6, %ymm15, %ymm15
	vmovdqa	96(%r14,%rsi), %ymm6
	vpunpckhbw	%ymm7, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm7[8],ymm5[9],ymm7[9],ymm5[10],ymm7[10],ymm5[11],ymm7[11],ymm5[12],ymm7[12],ymm5[13],ymm7[13],ymm5[14],ymm7[14],ymm5[15],ymm7[15],ymm5[24],ymm7[24],ymm5[25],ymm7[25],ymm5[26],ymm7[26],ymm5[27],ymm7[27],ymm5[28],ymm7[28],ymm5[29],ymm7[29],ymm5[30],ymm7[30],ymm5[31],ymm7[31]
	vmovdqa	96(%r14,%rdi), %ymm7
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm14, %ymm14
	vpunpcklbw	%ymm7, %ymm6, %ymm5     # ymm5 = ymm6[0],ymm7[0],ymm6[1],ymm7[1],ymm6[2],ymm7[2],ymm6[3],ymm7[3],ymm6[4],ymm7[4],ymm6[5],ymm7[5],ymm6[6],ymm7[6],ymm6[7],ymm7[7],ymm6[16],ymm7[16],ymm6[17],ymm7[17],ymm6[18],ymm7[18],ymm6[19],ymm7[19],ymm6[20],ymm7[20],ymm6[21],ymm7[21],ymm6[22],ymm7[22],ymm6[23],ymm7[23]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm13, %ymm13
	vpunpckhbw	%ymm7, %ymm6, %ymm5     # ymm5 = ymm6[8],ymm7[8],ymm6[9],ymm7[9],ymm6[10],ymm7[10],ymm6[11],ymm7[11],ymm6[12],ymm7[12],ymm6[13],ymm7[13],ymm6[14],ymm7[14],ymm6[15],ymm7[15],ymm6[24],ymm7[24],ymm6[25],ymm7[25],ymm6[26],ymm7[26],ymm6[27],ymm7[27],ymm6[28],ymm7[28],ymm6[29],ymm7[29],ymm6[30],ymm7[30],ymm6[31],ymm7[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm12, %ymm12
	vmovdqa	128(%r14,%rsi), %ymm5
	vmovdqa	128(%r14,%rdi), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm7, %ymm11, %ymm11
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm10, %ymm10
	vmovdqa	160(%r14,%rsi), %ymm5
	vmovdqa	160(%r14,%rdi), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm9
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm8, %ymm8
	addl	$2, %r13d
	decq	%rdx
	jne	.LBB1_5
	jmp	.LBB1_6
.LBB1_7:
	vmovups	64(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, (%rbx)
	vmovdqu	352(%rsp), %ymm9                # 32-byte Reload
	vmovdqa	%ymm9, 64(%rbx)
	vmovdqa	%ymm4, 32(%rbx)
	vmovdqu	(%rsp), %ymm8                   # 32-byte Reload
	vmovdqa	%ymm8, 96(%rbx)
	vmovdqu	32(%rsp), %ymm7                 # 32-byte Reload
	vmovdqa	%ymm7, 128(%rbx)
	vmovdqu	384(%rsp), %ymm6                # 32-byte Reload
	vmovdqa	%ymm6, 192(%rbx)
	vmovups	96(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 160(%rbx)
	vmovups	128(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 224(%rbx)
	vmovups	160(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 256(%rbx)
	vmovups	192(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 320(%rbx)
	vmovups	224(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 288(%rbx)
	vmovups	256(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 352(%rbx)
	vmovups	288(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 384(%rbx)
	vmovdqu	320(%rsp), %ymm0                # 32-byte Reload
	vmovdqa	%ymm0, 448(%rbx)
	vmovdqa	%ymm15, 416(%rbx)
	vmovdqa	%ymm14, 480(%rbx)
	vmovdqa	%ymm13, 512(%rbx)
	vmovdqa	%ymm12, 576(%rbx)
	vmovdqa	%ymm11, 544(%rbx)
	vmovdqa	%ymm10, 608(%rbx)
	vmovdqa	%ymm5, 640(%rbx)
	vmovdqa	%ymm6, %ymm5
	vmovdqa	%ymm7, %ymm6
	vmovdqa	%ymm8, %ymm7
	vmovdqa	%ymm9, %ymm8
	vmovdqu	64(%rsp), %ymm9                 # 32-byte Reload
	vmovdqa	%ymm3, 704(%rbx)
	vmovdqa	%ymm2, 672(%rbx)
	vmovdqa	%ymm1, 736(%rbx)
.LBB1_8:
	testb	$1, %bpl
	je	.LBB1_10
# %bb.9:
	movslq	%ebp, %rax
	movzwl	-2(%r12,%rax,2), %ecx
	leaq	(%rcx,%rcx,2), %rax
	shlq	$6, %rax
	movzbl	(%r15,%rcx), %ecx
	vmovd	%ecx, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqa	(%r14,%rax), %ymm1
	vpunpcklbw	%ymm1, %ymm1, %ymm2     # ymm2 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vpmovsxwd	%xmm2, %ymm3
	vpaddd	%ymm3, %ymm9, %ymm3
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm2
	vmovdqa	%ymm3, (%rbx)
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vmovdqa	%ymm2, 64(%rbx)
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	%ymm2, %ymm4, %ymm2
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm1
	vmovdqa	32(%r14,%rax), %ymm3
	vmovdqa	%ymm2, 32(%rbx)
	vpunpcklbw	%ymm3, %ymm3, %ymm2     # ymm2 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vmovdqa	%ymm1, 96(%rbx)
	vpmovsxwd	%xmm2, %ymm1
	vpaddd	%ymm1, %ymm6, %ymm1
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm5, %ymm2
	vmovdqa	%ymm1, 128(%rbx)
	vmovdqa	64(%r14,%rax), %ymm1
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm3, %ymm0, %ymm3
	vmovdqa	%ymm2, 192(%rbx)
	vpmovsxwd	%xmm3, %ymm2
	vpaddd	160(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 160(%rbx)
	vpunpcklbw	%ymm1, %ymm1, %ymm2     # ymm2 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vpaddd	224(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 224(%rbx)
	vpmovsxwd	%xmm2, %ymm3
	vpaddd	256(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 256(%rbx)
	vmovdqa	96(%r14,%rax), %ymm3
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	320(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 320(%rbx)
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	288(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 288(%rbx)
	vpunpcklbw	%ymm3, %ymm3, %ymm2     # ymm2 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm3, %ymm0, %ymm3
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	352(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 352(%rbx)
	vpmovsxwd	%xmm2, %ymm1
	vextracti128	$1, %ymm2, %xmm2
	vpaddd	384(%rbx), %ymm1, %ymm1
	vpmovsxwd	%xmm2, %ymm2
	vmovdqa	%ymm1, 384(%rbx)
	vpaddd	448(%rbx), %ymm2, %ymm1
	vmovdqa	%ymm1, 448(%rbx)
	vpmovsxwd	%xmm3, %ymm1
	vpaddd	416(%rbx), %ymm1, %ymm1
	vmovdqa	128(%r14,%rax), %ymm2
	vmovdqa	%ymm1, 416(%rbx)
	vpunpcklbw	%ymm2, %ymm2, %ymm1     # ymm1 = ymm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vpunpckhbw	%ymm2, %ymm2, %ymm2     # ymm2 = ymm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vpaddd	480(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 480(%rbx)
	vpmovsxwd	%xmm1, %ymm3
	vpaddd	512(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 512(%rbx)
	vmovdqa	160(%r14,%rax), %ymm3
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	576(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 576(%rbx)
	vpmovsxwd	%xmm2, %ymm1
	vpaddd	544(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 544(%rbx)
	vpunpcklbw	%ymm3, %ymm3, %ymm1     # ymm1 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	608(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 608(%rbx)
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	640(%rbx), %ymm2, %ymm2
	vpmaddubsw	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm2, 640(%rbx)
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	704(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 704(%rbx)
	vpmovsxwd	%xmm0, %ymm1
	vpaddd	672(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 672(%rbx)
	vextracti128	$1, %ymm0, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vpaddd	736(%rbx), %ymm0, %ymm0
	vmovdqa	%ymm0, 736(%rbx)
.LBB1_10:
	addq	$776, %rsp                      # imm = 0x308
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end1:
	.size	_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi, .Lfunc_end1-_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi
                                        # -- End function
	.section	.text._ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf,"ax",@progbits
	.globl	_ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf # -- Begin function _ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf,@function
_ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf: # @_ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$680, %rsp                      # imm = 0x2A8
	movq	(%rdi), %rax
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%ymm0, 128(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	vmovdqu	%ymm0, -32(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -64(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -96(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -128(%rsp)               # 32-byte Spill
	cmpl	$2, %ecx
	jl	.LBB2_8
# %bb.1:
	movl	%ecx, %r9d
	shrl	$31, %r9d
	addl	%ecx, %r9d
	sarl	%r9d
	xorl	%r11d, %r11d
	vmovdqu	%ymm0, 128(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	vmovdqu	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -32(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -64(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -96(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, -128(%rsp)               # 32-byte Spill
	jmp	.LBB2_2
	.p2align	4, 0x90
.LBB2_3:                                #   in Loop: Header=BB2_2 Depth=1
	movl	%r11d, %r10d
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vmovdqa	%ymm6, %ymm5
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vmovdqa	%ymm7, %ymm6
.LBB2_7:                                #   in Loop: Header=BB2_2 Depth=1
	vpmovsxwd	%xmm3, %ymm4
	vmovdqu	-128(%rsp), %ymm7               # 32-byte Reload
	vpaddd	%ymm4, %ymm7, %ymm7
	vmovdqu	%ymm7, -128(%rsp)               # 32-byte Spill
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vmovdqu	224(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm4, 224(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm2, %ymm3
	vmovdqu	-96(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm4, -96(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vmovdqu	-64(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, -64(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm1, %ymm2
	vmovdqu	-32(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, -32(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vmovdqu	256(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 256(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm0, %ymm1
	vmovdqu	(%rsp), %ymm2                   # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, (%rsp)                   # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	32(%rsp), %ymm1                 # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 32(%rsp)                 # 32-byte Spill
	vpmovsxwd	%xmm15, %ymm0
	vmovdqu	64(%rsp), %ymm1                 # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 64(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm15, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	288(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm14, %ymm0
	vmovdqu	96(%rsp), %ymm1                 # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 96(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm14, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	128(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm13, %ymm0
	vmovdqu	160(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vextracti128	$1, %ymm13, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	448(%rsp), %ymm14               # 32-byte Reload
	vpaddd	%ymm0, %ymm14, %ymm14
	vpmovsxwd	%xmm12, %ymm0
	vmovdqu	416(%rsp), %ymm15               # 32-byte Reload
	vpaddd	%ymm0, %ymm15, %ymm15
	vextracti128	$1, %ymm12, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	384(%rsp), %ymm13               # 32-byte Reload
	vpaddd	%ymm0, %ymm13, %ymm13
	vpmovsxwd	%xmm11, %ymm0
	vmovdqu	480(%rsp), %ymm12               # 32-byte Reload
	vpaddd	%ymm0, %ymm12, %ymm12
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	544(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm0, %ymm4, %ymm4
	vpmovsxwd	%xmm10, %ymm0
	vmovdqu	512(%rsp), %ymm11               # 32-byte Reload
	vpaddd	%ymm0, %ymm11, %ymm11
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	576(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm0, %ymm3, %ymm3
	vpmovsxwd	%xmm9, %ymm0
	vmovdqu	192(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm0, %ymm2, %ymm2
	vextracti128	$1, %ymm9, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	608(%rsp), %ymm10               # 32-byte Reload
	vpaddd	%ymm0, %ymm10, %ymm10
	vpmovsxwd	%xmm8, %ymm0
	vpaddd	%ymm0, %ymm5, %ymm5
	vextracti128	$1, %ymm8, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vpaddd	%ymm0, %ymm6, %ymm7
	movl	%r10d, %r11d
	cmpl	%r9d, %r10d
	vmovdqa	%ymm5, %ymm6
	jge	.LBB2_8
.LBB2_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB2_5 Depth 2
	leal	18(%r11), %r10d
	cmpl	%r10d, %r9d
	cmovll	%r9d, %r10d
	cmpl	%r10d, %r11d
	vmovdqu	%ymm10, 608(%rsp)               # 32-byte Spill
	vmovdqu	%ymm2, 192(%rsp)                # 32-byte Spill
	vmovdqu	%ymm3, 576(%rsp)                # 32-byte Spill
	vmovdqu	%ymm4, 544(%rsp)                # 32-byte Spill
	vmovdqu	%ymm11, 512(%rsp)               # 32-byte Spill
	vmovdqu	%ymm12, 480(%rsp)               # 32-byte Spill
	vmovdqu	%ymm13, 384(%rsp)               # 32-byte Spill
	vmovdqu	%ymm14, 448(%rsp)               # 32-byte Spill
	vmovdqu	%ymm15, 416(%rsp)               # 32-byte Spill
	vmovdqu	%ymm1, 160(%rsp)                # 32-byte Spill
	jge	.LBB2_3
# %bb.4:                                #   in Loop: Header=BB2_2 Depth=1
	vmovdqu	%ymm6, 352(%rsp)                # 32-byte Spill
	vmovdqu	%ymm7, 320(%rsp)                # 32-byte Spill
	movslq	%r11d, %r14
	movslq	%r10d, %rbx
	subq	%r14, %rbx
	addl	%r11d, %r11d
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB2_5:                                #   Parent Loop BB2_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	%r11d, %r11
	movzwl	(%rdx,%r11,2), %r12d
	leal	1(%r11), %ebp
	movslq	%ebp, %r14
	movzwl	(%rdx,%r14,2), %r13d
	leaq	(%r12,%r12,2), %r14
	shlq	$6, %r14
	leaq	(,%r13,2), %r15
	addq	%r13, %r15
	shlq	$6, %r15
	movzbl	(%rsi,%r12), %ebp
	movzbl	(%rsi,%r13), %r12d
	shll	$8, %r12d
	orl	%ebp, %r12d
	vmovd	%r12d, %xmm4
	vpbroadcastw	%xmm4, %ymm4
	vmovdqa	(%rax,%r14), %ymm5
	vmovdqa	(%rax,%r15), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm3, %ymm7, %ymm3
	vmovdqa	32(%rax,%r14), %ymm7
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vmovdqa	32(%rax,%r15), %ymm6
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm2
	vpunpcklbw	%ymm6, %ymm7, %ymm5     # ymm5 = ymm7[0],ymm6[0],ymm7[1],ymm6[1],ymm7[2],ymm6[2],ymm7[3],ymm6[3],ymm7[4],ymm6[4],ymm7[5],ymm6[5],ymm7[6],ymm6[6],ymm7[7],ymm6[7],ymm7[16],ymm6[16],ymm7[17],ymm6[17],ymm7[18],ymm6[18],ymm7[19],ymm6[19],ymm7[20],ymm6[20],ymm7[21],ymm6[21],ymm7[22],ymm6[22],ymm7[23],ymm6[23]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqa	64(%rax,%r14), %ymm5
	vpunpckhbw	%ymm6, %ymm7, %ymm6     # ymm6 = ymm7[8],ymm6[8],ymm7[9],ymm6[9],ymm7[10],ymm6[10],ymm7[11],ymm6[11],ymm7[12],ymm6[12],ymm7[13],ymm6[13],ymm7[14],ymm6[14],ymm7[15],ymm6[15],ymm7[24],ymm6[24],ymm7[25],ymm6[25],ymm7[26],ymm6[26],ymm7[27],ymm6[27],ymm7[28],ymm6[28],ymm7[29],ymm6[29],ymm7[30],ymm6[30],ymm7[31],ymm6[31]
	vmovdqa	64(%rax,%r15), %ymm7
	vpmaddubsw	%ymm6, %ymm4, %ymm6
	vpaddw	%ymm0, %ymm6, %ymm0
	vpunpcklbw	%ymm7, %ymm5, %ymm6     # ymm6 = ymm5[0],ymm7[0],ymm5[1],ymm7[1],ymm5[2],ymm7[2],ymm5[3],ymm7[3],ymm5[4],ymm7[4],ymm5[5],ymm7[5],ymm5[6],ymm7[6],ymm5[7],ymm7[7],ymm5[16],ymm7[16],ymm5[17],ymm7[17],ymm5[18],ymm7[18],ymm5[19],ymm7[19],ymm5[20],ymm7[20],ymm5[21],ymm7[21],ymm5[22],ymm7[22],ymm5[23],ymm7[23]
	vpmaddubsw	%ymm6, %ymm4, %ymm6
	vpaddw	%ymm6, %ymm15, %ymm15
	vmovdqa	96(%rax,%r14), %ymm6
	vpunpckhbw	%ymm7, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm7[8],ymm5[9],ymm7[9],ymm5[10],ymm7[10],ymm5[11],ymm7[11],ymm5[12],ymm7[12],ymm5[13],ymm7[13],ymm5[14],ymm7[14],ymm5[15],ymm7[15],ymm5[24],ymm7[24],ymm5[25],ymm7[25],ymm5[26],ymm7[26],ymm5[27],ymm7[27],ymm5[28],ymm7[28],ymm5[29],ymm7[29],ymm5[30],ymm7[30],ymm5[31],ymm7[31]
	vmovdqa	96(%rax,%r15), %ymm7
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm14, %ymm14
	vpunpcklbw	%ymm7, %ymm6, %ymm5     # ymm5 = ymm6[0],ymm7[0],ymm6[1],ymm7[1],ymm6[2],ymm7[2],ymm6[3],ymm7[3],ymm6[4],ymm7[4],ymm6[5],ymm7[5],ymm6[6],ymm7[6],ymm6[7],ymm7[7],ymm6[16],ymm7[16],ymm6[17],ymm7[17],ymm6[18],ymm7[18],ymm6[19],ymm7[19],ymm6[20],ymm7[20],ymm6[21],ymm7[21],ymm6[22],ymm7[22],ymm6[23],ymm7[23]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm13, %ymm13
	vpunpckhbw	%ymm7, %ymm6, %ymm5     # ymm5 = ymm6[8],ymm7[8],ymm6[9],ymm7[9],ymm6[10],ymm7[10],ymm6[11],ymm7[11],ymm6[12],ymm7[12],ymm6[13],ymm7[13],ymm6[14],ymm7[14],ymm6[15],ymm7[15],ymm6[24],ymm7[24],ymm6[25],ymm7[25],ymm6[26],ymm7[26],ymm6[27],ymm7[27],ymm6[28],ymm7[28],ymm6[29],ymm7[29],ymm6[30],ymm7[30],ymm6[31],ymm7[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm12, %ymm12
	vmovdqa	128(%rax,%r14), %ymm5
	vmovdqa	128(%rax,%r15), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm7, %ymm11, %ymm11
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm10, %ymm10
	vmovdqa	160(%rax,%r14), %ymm5
	vmovdqa	160(%rax,%r15), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm9
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm8, %ymm8
	addl	$2, %r11d
	decq	%rbx
	jne	.LBB2_5
# %bb.6:                                #   in Loop: Header=BB2_2 Depth=1
	vmovdqu	320(%rsp), %ymm6                # 32-byte Reload
	vmovdqu	352(%rsp), %ymm5                # 32-byte Reload
	jmp	.LBB2_7
.LBB2_8:
	testb	$1, %cl
	jne	.LBB2_10
# %bb.9:
	vmovdqu	288(%rsp), %ymm5                # 32-byte Reload
	vmovdqu	256(%rsp), %ymm8                # 32-byte Reload
	vmovdqu	224(%rsp), %ymm9                # 32-byte Reload
	jmp	.LBB2_11
.LBB2_10:
	movslq	%ecx, %rcx
	movzwl	-2(%rdx,%rcx,2), %edx
	leaq	(%rdx,%rdx,2), %rcx
	shlq	$6, %rcx
	movzbl	(%rsi,%rdx), %edx
	vmovd	%edx, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqu	%ymm1, 160(%rsp)                # 32-byte Spill
	vmovdqa	(%rax,%rcx), %ymm1
	vmovdqu	%ymm2, 192(%rsp)                # 32-byte Spill
	vmovdqa	32(%rax,%rcx), %ymm2
	vmovdqu	%ymm3, 576(%rsp)                # 32-byte Spill
	vmovdqa	64(%rax,%rcx), %ymm3
	vmovdqu	%ymm10, 608(%rsp)               # 32-byte Spill
	vmovdqa	96(%rax,%rcx), %ymm5
	vmovdqu	%ymm4, 544(%rsp)                # 32-byte Spill
	vpunpcklbw	%ymm1, %ymm1, %ymm4     # ymm4 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vmovdqu	%ymm15, 416(%rsp)               # 32-byte Spill
	vmovdqu	%ymm6, 352(%rsp)                # 32-byte Spill
	vpmaddubsw	%ymm4, %ymm0, %ymm6
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vmovdqu	%ymm14, 448(%rsp)               # 32-byte Spill
	vmovdqa	%ymm13, %ymm14
	vpmaddubsw	%ymm1, %ymm0, %ymm13
	vpunpcklbw	%ymm2, %ymm2, %ymm1     # ymm1 = ymm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vmovdqu	%ymm12, 480(%rsp)               # 32-byte Spill
	vpmaddubsw	%ymm1, %ymm0, %ymm12
	vpunpckhbw	%ymm2, %ymm2, %ymm1     # ymm1 = ymm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vmovdqu	%ymm11, 512(%rsp)               # 32-byte Spill
	vpmaddubsw	%ymm1, %ymm0, %ymm11
	vpunpcklbw	%ymm3, %ymm3, %ymm1     # ymm1 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm4
	vpunpckhbw	%ymm3, %ymm3, %ymm1     # ymm1 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm10
	vpunpcklbw	%ymm5, %ymm5, %ymm1     # ymm1 = ymm5[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm3
	vpunpckhbw	%ymm5, %ymm5, %ymm1     # ymm1 = ymm5[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm8
	vmovdqa	128(%rax,%rcx), %ymm1
	vpunpcklbw	%ymm1, %ymm1, %ymm2     # ymm2 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vmovdqu	%ymm1, 640(%rsp)                # 32-byte Spill
	vmovdqa	160(%rax,%rcx), %ymm5
	vpunpcklbw	%ymm5, %ymm5, %ymm1     # ymm1 = ymm5[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vmovdqu	%ymm1, 320(%rsp)                # 32-byte Spill
	vpunpckhbw	%ymm5, %ymm5, %ymm5     # ymm5 = ymm5[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 384(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm6, %ymm5
	vmovdqu	-128(%rsp), %ymm0               # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, -128(%rsp)               # 32-byte Spill
	vextracti128	$1, %ymm6, %xmm5
	vmovdqu	416(%rsp), %ymm15               # 32-byte Reload
	vpmovsxwd	%xmm5, %ymm5
	vmovdqu	224(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm5, %ymm1, %ymm1
	vpmovsxwd	%xmm13, %ymm5
	vmovdqu	-96(%rsp), %ymm0                # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, -96(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm13, %xmm5
	vmovdqa	%ymm14, %ymm13
	vmovdqu	448(%rsp), %ymm14               # 32-byte Reload
	vpmovsxwd	%xmm5, %ymm5
	vmovdqu	-64(%rsp), %ymm0                # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, -64(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm12, %ymm5
	vmovdqu	-32(%rsp), %ymm0                # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, -32(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm12, %xmm5
	vmovdqu	480(%rsp), %ymm12               # 32-byte Reload
	vpmovsxwd	%xmm5, %ymm5
	vmovdqu	256(%rsp), %ymm9                # 32-byte Reload
	vpaddd	%ymm5, %ymm9, %ymm9
	vpmovsxwd	%xmm11, %ymm5
	vmovdqu	(%rsp), %ymm0                   # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	vextracti128	$1, %ymm11, %xmm5
	vmovdqu	512(%rsp), %ymm11               # 32-byte Reload
	vpmovsxwd	%xmm5, %ymm5
	vmovdqu	32(%rsp), %ymm0                 # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vpmovsxwd	%xmm4, %ymm5
	vmovdqu	64(%rsp), %ymm0                 # 32-byte Reload
	vpaddd	%ymm5, %ymm0, %ymm0
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovdqu	608(%rsp), %ymm0                # 32-byte Reload
	vextracti128	$1, %ymm4, %xmm4
	vpmovsxwd	%xmm4, %ymm4
	vmovdqu	288(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vpmovsxwd	%xmm10, %ymm4
	vmovdqu	96(%rsp), %ymm6                 # 32-byte Reload
	vpaddd	%ymm4, %ymm6, %ymm6
	vmovdqu	%ymm6, 96(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm10, %xmm4
	vpmovsxwd	%xmm4, %ymm4
	vmovdqu	128(%rsp), %ymm10               # 32-byte Reload
	vpaddd	%ymm4, %ymm10, %ymm10
	vmovdqu	%ymm10, 128(%rsp)               # 32-byte Spill
	vpmovsxwd	%xmm3, %ymm4
	vmovdqu	160(%rsp), %ymm10               # 32-byte Reload
	vpaddd	%ymm4, %ymm10, %ymm10
	vmovdqu	%ymm10, 160(%rsp)               # 32-byte Spill
	vmovdqa	%ymm0, %ymm10
	vmovdqu	352(%rsp), %ymm6                # 32-byte Reload
	vextracti128	$1, %ymm3, %xmm4
	vpmovsxwd	%xmm4, %ymm4
	vpaddd	%ymm4, %ymm14, %ymm14
	vpmovsxwd	%xmm8, %ymm4
	vpaddd	%ymm4, %ymm15, %ymm15
	vextracti128	$1, %ymm8, %xmm4
	vpmovsxwd	%xmm4, %ymm4
	vpaddd	%ymm4, %ymm13, %ymm13
	vpmovsxwd	%xmm2, %ymm4
	vpaddd	%ymm4, %ymm12, %ymm12
	vmovdqu	544(%rsp), %ymm4                # 32-byte Reload
	vextracti128	$1, %ymm2, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	640(%rsp), %ymm0                # 32-byte Reload
	vpmovsxwd	%xmm0, %ymm3
	vpaddd	%ymm3, %ymm11, %ymm11
	vmovdqu	576(%rsp), %ymm3                # 32-byte Reload
	vextracti128	$1, %ymm0, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqu	320(%rsp), %ymm0                # 32-byte Reload
	vpmovsxwd	%xmm0, %ymm2
	vmovdqu	192(%rsp), %ymm8                # 32-byte Reload
	vpaddd	%ymm2, %ymm8, %ymm8
	vmovdqu	%ymm8, 192(%rsp)                # 32-byte Spill
	vmovdqa	%ymm9, %ymm8
	vmovdqa	%ymm1, %ymm9
	vmovdqu	192(%rsp), %ymm2                # 32-byte Reload
	vextracti128	$1, %ymm0, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm10, %ymm10
	vmovdqu	384(%rsp), %ymm0                # 32-byte Reload
	vpmovsxwd	%xmm0, %ymm1
	vpaddd	%ymm1, %ymm6, %ymm6
	vmovdqu	160(%rsp), %ymm1                # 32-byte Reload
	vextracti128	$1, %ymm0, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vpaddd	%ymm0, %ymm7, %ymm7
.LBB2_11:
	vmovups	-128(%rsp), %ymm0               # 32-byte Reload
	movq	8(%rdi), %rax
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	(%rax), %ymm0, %ymm0
	vmovups	%ymm0, (%r8)
	vcvtdq2ps	-96(%rsp), %ymm0        # 32-byte Folded Reload
	vmulps	32(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 32(%r8)
	vcvtdq2ps	%ymm9, %ymm0
	vmulps	64(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 64(%r8)
	vcvtdq2ps	-64(%rsp), %ymm0        # 32-byte Folded Reload
	vmulps	96(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 96(%r8)
	vcvtdq2ps	-32(%rsp), %ymm0        # 32-byte Folded Reload
	vmulps	128(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 128(%r8)
	vcvtdq2ps	(%rsp), %ymm0           # 32-byte Folded Reload
	vmulps	160(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 160(%r8)
	vcvtdq2ps	%ymm8, %ymm0
	vmulps	192(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 192(%r8)
	vcvtdq2ps	32(%rsp), %ymm0         # 32-byte Folded Reload
	vmulps	224(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 224(%r8)
	vcvtdq2ps	64(%rsp), %ymm0         # 32-byte Folded Reload
	vmulps	256(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 256(%r8)
	vcvtdq2ps	96(%rsp), %ymm0         # 32-byte Folded Reload
	vmulps	288(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 288(%r8)
	vcvtdq2ps	%ymm5, %ymm0
	vmulps	320(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 320(%r8)
	vcvtdq2ps	128(%rsp), %ymm0        # 32-byte Folded Reload
	vmulps	352(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 352(%r8)
	vcvtdq2ps	%ymm1, %ymm0
	vmulps	384(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 384(%r8)
	vcvtdq2ps	%ymm15, %ymm0
	vmulps	416(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 416(%r8)
	vcvtdq2ps	%ymm14, %ymm0
	vmulps	448(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 448(%r8)
	vcvtdq2ps	%ymm13, %ymm0
	vmulps	480(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 480(%r8)
	vcvtdq2ps	%ymm12, %ymm0
	vmulps	512(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 512(%r8)
	vcvtdq2ps	%ymm11, %ymm0
	vmulps	544(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 544(%r8)
	vcvtdq2ps	%ymm4, %ymm0
	vmulps	576(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 576(%r8)
	vcvtdq2ps	%ymm3, %ymm0
	vmulps	608(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 608(%r8)
	vcvtdq2ps	%ymm2, %ymm0
	vmulps	640(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 640(%r8)
	vcvtdq2ps	%ymm6, %ymm0
	vmulps	672(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 672(%r8)
	vcvtdq2ps	%ymm10, %ymm0
	vmulps	704(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 704(%r8)
	vcvtdq2ps	%ymm7, %ymm0
	vmulps	736(%rax), %ymm0, %ymm0
	vmovups	%ymm0, 736(%r8)
	addq	$680, %rsp                      # imm = 0x2A8
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end2:
	.size	_ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf, .Lfunc_end2-_ZN3fx23opt16qsparse_f32_nopfERKNS0_7QSparseEPKhPKtiPf
                                        # -- End function
	.section	.text._ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf,"ax",@progbits
	.globl	_ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf # -- Begin function _ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf,@function
_ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf: # @_ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%r8, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	testq	%r8, %r8
	je	.LBB3_2
# %bb.1:
	prefetcht0	(%rbx)
	prefetcht0	64(%rbx)
	prefetcht0	128(%rbx)
	prefetcht0	192(%rbx)
	prefetcht0	256(%rbx)
	prefetcht0	320(%rbx)
	prefetcht0	384(%rbx)
	prefetcht0	448(%rbx)
	prefetcht0	512(%rbx)
	prefetcht0	576(%rbx)
	prefetcht0	640(%rbx)
	prefetcht0	704(%rbx)
.LBB3_2:
	movq	(%rdi), %rdi
	movq	%rsp, %r8
	callq	_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi
	vcvtdq2ps	(%rsp), %ymm0
	vmulps	(%r14), %ymm0, %ymm0
	vaddps	(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, (%rbx)
	vcvtdq2ps	32(%rsp), %ymm0
	vmulps	32(%r14), %ymm0, %ymm0
	vaddps	32(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 32(%rbx)
	vcvtdq2ps	64(%rsp), %ymm0
	vmulps	64(%r14), %ymm0, %ymm0
	vaddps	64(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 64(%rbx)
	vcvtdq2ps	96(%rsp), %ymm0
	vmulps	96(%r14), %ymm0, %ymm0
	vaddps	96(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 96(%rbx)
	vcvtdq2ps	128(%rsp), %ymm0
	vmulps	128(%r14), %ymm0, %ymm0
	vaddps	128(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 128(%rbx)
	vcvtdq2ps	160(%rsp), %ymm0
	vmulps	160(%r14), %ymm0, %ymm0
	vaddps	160(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 160(%rbx)
	vcvtdq2ps	192(%rsp), %ymm0
	vmulps	192(%r14), %ymm0, %ymm0
	vaddps	192(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 192(%rbx)
	vcvtdq2ps	224(%rsp), %ymm0
	vmulps	224(%r14), %ymm0, %ymm0
	vaddps	224(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 224(%rbx)
	vcvtdq2ps	256(%rsp), %ymm0
	vmulps	256(%r14), %ymm0, %ymm0
	vaddps	256(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 256(%rbx)
	vcvtdq2ps	288(%rsp), %ymm0
	vmulps	288(%r14), %ymm0, %ymm0
	vaddps	288(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 288(%rbx)
	vcvtdq2ps	320(%rsp), %ymm0
	vmulps	320(%r14), %ymm0, %ymm0
	vaddps	320(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 320(%rbx)
	vcvtdq2ps	352(%rsp), %ymm0
	vmulps	352(%r14), %ymm0, %ymm0
	vaddps	352(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 352(%rbx)
	vcvtdq2ps	384(%rsp), %ymm0
	vmulps	384(%r14), %ymm0, %ymm0
	vaddps	384(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 384(%rbx)
	vcvtdq2ps	416(%rsp), %ymm0
	vmulps	416(%r14), %ymm0, %ymm0
	vaddps	416(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 416(%rbx)
	vcvtdq2ps	448(%rsp), %ymm0
	vmulps	448(%r14), %ymm0, %ymm0
	vaddps	448(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 448(%rbx)
	vcvtdq2ps	480(%rsp), %ymm0
	vmulps	480(%r14), %ymm0, %ymm0
	vaddps	480(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 480(%rbx)
	vcvtdq2ps	512(%rsp), %ymm0
	vmulps	512(%r14), %ymm0, %ymm0
	vaddps	512(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 512(%rbx)
	vcvtdq2ps	544(%rsp), %ymm0
	vmulps	544(%r14), %ymm0, %ymm0
	vaddps	544(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 544(%rbx)
	vcvtdq2ps	576(%rsp), %ymm0
	vmulps	576(%r14), %ymm0, %ymm0
	vaddps	576(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 576(%rbx)
	vcvtdq2ps	608(%rsp), %ymm0
	vmulps	608(%r14), %ymm0, %ymm0
	vaddps	608(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 608(%rbx)
	vcvtdq2ps	640(%rsp), %ymm0
	vmulps	640(%r14), %ymm0, %ymm0
	vaddps	640(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 640(%rbx)
	vcvtdq2ps	672(%rsp), %ymm0
	vmulps	672(%r14), %ymm0, %ymm0
	vaddps	672(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 672(%rbx)
	vcvtdq2ps	704(%rsp), %ymm0
	vmulps	704(%r14), %ymm0, %ymm0
	vaddps	704(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 704(%rbx)
	vcvtdq2ps	736(%rsp), %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vaddps	736(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end3:
	.size	_ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf, .Lfunc_end3-_ZN3fx23opt11qsparse_addERKNS0_7QSparseEPKhPKtiPf
                                        # -- End function
	.section	.text._ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi,"ax",@progbits
	.globl	_ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi # -- Begin function _ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi,@function
_ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi: # @_ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%r8, %rbx
	movq	(%rdi), %rdi
	movq	%rsp, %r14
	movq	%r14, %r8
	callq	_ZN3fx23opt12_GLOBAL__N_112sparse_accumILb1EEEvPKaPKhPKtiPi
	movl	$768, %edx                      # imm = 0x300
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	memcpy@PLT
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
.Lfunc_end4:
	.size	_ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi, .Lfunc_end4-_ZN3fx23opt11qsparse_i32ERKNS0_7QSparseEPKhPKtiPi
                                        # -- End function
	.section	.text._ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf # -- Begin function _ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf,@function
_ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf: # @_ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%rdx, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	movq	(%rdi), %rax
	movl	16(%rdi), %edx
	movq	%rsp, %rcx
	movq	%rax, %rdi
	callq	_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi
	vcvtdq2ps	(%rsp), %ymm0
	vmulps	(%r14), %ymm0, %ymm0
	vmovups	%ymm0, (%rbx)
	vcvtdq2ps	32(%rsp), %ymm0
	vmulps	32(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 32(%rbx)
	vcvtdq2ps	64(%rsp), %ymm0
	vmulps	64(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 64(%rbx)
	vcvtdq2ps	96(%rsp), %ymm0
	vmulps	96(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 96(%rbx)
	vcvtdq2ps	128(%rsp), %ymm0
	vmulps	128(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 128(%rbx)
	vcvtdq2ps	160(%rsp), %ymm0
	vmulps	160(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 160(%rbx)
	vcvtdq2ps	192(%rsp), %ymm0
	vmulps	192(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 192(%rbx)
	vcvtdq2ps	224(%rsp), %ymm0
	vmulps	224(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 224(%rbx)
	vcvtdq2ps	256(%rsp), %ymm0
	vmulps	256(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 256(%rbx)
	vcvtdq2ps	288(%rsp), %ymm0
	vmulps	288(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 288(%rbx)
	vcvtdq2ps	320(%rsp), %ymm0
	vmulps	320(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 320(%rbx)
	vcvtdq2ps	352(%rsp), %ymm0
	vmulps	352(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 352(%rbx)
	vcvtdq2ps	384(%rsp), %ymm0
	vmulps	384(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 384(%rbx)
	vcvtdq2ps	416(%rsp), %ymm0
	vmulps	416(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 416(%rbx)
	vcvtdq2ps	448(%rsp), %ymm0
	vmulps	448(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 448(%rbx)
	vcvtdq2ps	480(%rsp), %ymm0
	vmulps	480(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 480(%rbx)
	vcvtdq2ps	512(%rsp), %ymm0
	vmulps	512(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 512(%rbx)
	vcvtdq2ps	544(%rsp), %ymm0
	vmulps	544(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 544(%rbx)
	vcvtdq2ps	576(%rsp), %ymm0
	vmulps	576(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 576(%rbx)
	vcvtdq2ps	608(%rsp), %ymm0
	vmulps	608(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 608(%rbx)
	vcvtdq2ps	640(%rsp), %ymm0
	vmulps	640(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 640(%rbx)
	vcvtdq2ps	672(%rsp), %ymm0
	vmulps	672(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 672(%rbx)
	vcvtdq2ps	704(%rsp), %ymm0
	vmulps	704(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 704(%rbx)
	vcvtdq2ps	736(%rsp), %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end5:
	.size	_ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf, .Lfunc_end5-_ZN3fx23opt17qsparse_dense_f32ERKNS0_7QSparseEPKhPf
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi
	.type	_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi,@function
_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi: # @_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$768, %rsp                      # imm = 0x300
	movq	%rcx, %rbx
	movl	%edx, %r15d
	movq	%rsi, %r12
	movq	%rdi, %r14
	xorl	%r13d, %r13d
	movl	$768, %edx                      # imm = 0x300
	movq	%rcx, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	cmpl	$2, %r15d
	jl	.LBB6_8
# %bb.1:
	movl	%r15d, %eax
	shrl	$31, %eax
	addl	%r15d, %eax
	sarl	%eax
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%ymm0, 320(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 192(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 160(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 128(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 384(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	vmovdqu	%ymm0, 352(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	jmp	.LBB6_2
	.p2align	4, 0x90
.LBB6_3:                                #   in Loop: Header=BB6_2 Depth=1
	movl	%r13d, %ecx
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm3, %xmm3, %xmm3
.LBB6_6:                                #   in Loop: Header=BB6_2 Depth=1
	vmovdqu	32(%rsp), %ymm7                 # 32-byte Reload
	vmovdqu	(%rsp), %ymm6                   # 32-byte Reload
	vpmovsxwd	%xmm3, %ymm4
	vmovdqu	64(%rsp), %ymm5                 # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqu	%ymm5, 64(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vmovdqu	352(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm4, 352(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm2, %ymm3
	vmovdqu	736(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm6, %ymm6
	vmovdqu	%ymm6, (%rsp)                   # 32-byte Spill
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	%ymm2, %ymm7, %ymm7
	vmovdqu	%ymm7, 32(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vmovdqu	384(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 384(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm0, %ymm1
	vmovdqu	96(%rsp), %ymm2                 # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 96(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	128(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 128(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm15, %ymm0
	vmovdqu	160(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 160(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm15, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	192(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 192(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm14, %ymm0
	vmovdqu	224(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 224(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm14, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	256(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 256(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm13, %ymm0
	vmovdqu	288(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 288(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm13, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	320(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 320(%rsp)                # 32-byte Spill
	vpmovsxwd	%xmm12, %ymm0
	vmovdqu	416(%rsp), %ymm15               # 32-byte Reload
	vpaddd	%ymm0, %ymm15, %ymm15
	vextracti128	$1, %ymm12, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	448(%rsp), %ymm14               # 32-byte Reload
	vpaddd	%ymm0, %ymm14, %ymm14
	vpmovsxwd	%xmm11, %ymm0
	vmovdqu	480(%rsp), %ymm13               # 32-byte Reload
	vpaddd	%ymm0, %ymm13, %ymm13
	vextracti128	$1, %ymm11, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	512(%rsp), %ymm12               # 32-byte Reload
	vpaddd	%ymm0, %ymm12, %ymm12
	vpmovsxwd	%xmm10, %ymm0
	vmovdqu	544(%rsp), %ymm11               # 32-byte Reload
	vpaddd	%ymm0, %ymm11, %ymm11
	vextracti128	$1, %ymm10, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	576(%rsp), %ymm10               # 32-byte Reload
	vpaddd	%ymm0, %ymm10, %ymm10
	vpmovsxwd	%xmm9, %ymm0
	vmovdqu	608(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm0, %ymm5, %ymm5
	vextracti128	$1, %ymm9, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	640(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm0, %ymm3, %ymm3
	vpmovsxwd	%xmm8, %ymm0
	vmovdqu	672(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm0, %ymm2, %ymm2
	vextracti128	$1, %ymm8, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vmovdqu	704(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	movl	%ecx, %r13d
	cmpl	%eax, %ecx
	jge	.LBB6_7
.LBB6_2:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_5 Depth 2
	leal	18(%r13), %ecx
	cmpl	%ecx, %eax
	cmovll	%eax, %ecx
	movl	%ecx, %edx
	subl	%r13d, %edx
	vmovdqu	%ymm4, 736(%rsp)                # 32-byte Spill
	vmovdqu	%ymm1, 704(%rsp)                # 32-byte Spill
	vmovdqu	%ymm2, 672(%rsp)                # 32-byte Spill
	vmovdqu	%ymm3, 640(%rsp)                # 32-byte Spill
	vmovdqu	%ymm5, 608(%rsp)                # 32-byte Spill
	vmovdqu	%ymm10, 576(%rsp)               # 32-byte Spill
	vmovdqu	%ymm11, 544(%rsp)               # 32-byte Spill
	vmovdqu	%ymm12, 512(%rsp)               # 32-byte Spill
	vmovdqu	%ymm13, 480(%rsp)               # 32-byte Spill
	vmovdqu	%ymm14, 448(%rsp)               # 32-byte Spill
	vmovdqu	%ymm15, 416(%rsp)               # 32-byte Spill
	jle	.LBB6_3
# %bb.4:                                #   in Loop: Header=BB6_2 Depth=1
	leal	(,%r13,2), %esi
	shll	$7, %r13d
	leal	(%r13,%r13,2), %edi
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm2, %xmm2, %xmm2
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm0, %xmm0, %xmm0
	vpxor	%xmm15, %xmm15, %xmm15
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm11, %xmm11, %xmm11
	vpxor	%xmm10, %xmm10, %xmm10
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm8, %xmm8, %xmm8
	.p2align	4, 0x90
.LBB6_5:                                #   Parent Loop BB6_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	leal	1(%rsi), %r10d
	movl	%edi, %r8d
	prefetcht0	2048(%r14,%r8)
	prefetcht0	2112(%r14,%r8)
	prefetcht0	2176(%r14,%r8)
	prefetcht0	2240(%r14,%r8)
	prefetcht0	2304(%r14,%r8)
	prefetcht0	2368(%r14,%r8)
	leal	192(%rdi), %r9d
	movl	%esi, %r11d
	movzbl	(%r12,%r11), %r11d
	movzbl	(%r12,%r10), %r10d
	shll	$8, %r10d
	orl	%r11d, %r10d
	vmovd	%r10d, %xmm4
	vpbroadcastw	%xmm4, %ymm4
	vmovdqa	(%r14,%r8), %ymm5
	vmovdqa	(%r14,%r9), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm3, %ymm7, %ymm3
	vmovdqa	32(%r14,%r8), %ymm7
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vmovdqa	32(%r14,%r9), %ymm6
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm2, %ymm5, %ymm2
	vpunpcklbw	%ymm6, %ymm7, %ymm5     # ymm5 = ymm7[0],ymm6[0],ymm7[1],ymm6[1],ymm7[2],ymm6[2],ymm7[3],ymm6[3],ymm7[4],ymm6[4],ymm7[5],ymm6[5],ymm7[6],ymm6[6],ymm7[7],ymm6[7],ymm7[16],ymm6[16],ymm7[17],ymm6[17],ymm7[18],ymm6[18],ymm7[19],ymm6[19],ymm7[20],ymm6[20],ymm7[21],ymm6[21],ymm7[22],ymm6[22],ymm7[23],ymm6[23]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm1, %ymm5, %ymm1
	vmovdqa	64(%r14,%r8), %ymm5
	vpunpckhbw	%ymm6, %ymm7, %ymm6     # ymm6 = ymm7[8],ymm6[8],ymm7[9],ymm6[9],ymm7[10],ymm6[10],ymm7[11],ymm6[11],ymm7[12],ymm6[12],ymm7[13],ymm6[13],ymm7[14],ymm6[14],ymm7[15],ymm6[15],ymm7[24],ymm6[24],ymm7[25],ymm6[25],ymm7[26],ymm6[26],ymm7[27],ymm6[27],ymm7[28],ymm6[28],ymm7[29],ymm6[29],ymm7[30],ymm6[30],ymm7[31],ymm6[31]
	vmovdqa	64(%r14,%r9), %ymm7
	vpmaddubsw	%ymm6, %ymm4, %ymm6
	vpaddw	%ymm0, %ymm6, %ymm0
	vpunpcklbw	%ymm7, %ymm5, %ymm6     # ymm6 = ymm5[0],ymm7[0],ymm5[1],ymm7[1],ymm5[2],ymm7[2],ymm5[3],ymm7[3],ymm5[4],ymm7[4],ymm5[5],ymm7[5],ymm5[6],ymm7[6],ymm5[7],ymm7[7],ymm5[16],ymm7[16],ymm5[17],ymm7[17],ymm5[18],ymm7[18],ymm5[19],ymm7[19],ymm5[20],ymm7[20],ymm5[21],ymm7[21],ymm5[22],ymm7[22],ymm5[23],ymm7[23]
	vpmaddubsw	%ymm6, %ymm4, %ymm6
	vpaddw	%ymm6, %ymm15, %ymm15
	vmovdqa	96(%r14,%r8), %ymm6
	vpunpckhbw	%ymm7, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm7[8],ymm5[9],ymm7[9],ymm5[10],ymm7[10],ymm5[11],ymm7[11],ymm5[12],ymm7[12],ymm5[13],ymm7[13],ymm5[14],ymm7[14],ymm5[15],ymm7[15],ymm5[24],ymm7[24],ymm5[25],ymm7[25],ymm5[26],ymm7[26],ymm5[27],ymm7[27],ymm5[28],ymm7[28],ymm5[29],ymm7[29],ymm5[30],ymm7[30],ymm5[31],ymm7[31]
	vmovdqa	96(%r14,%r9), %ymm7
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm14, %ymm14
	vpunpcklbw	%ymm7, %ymm6, %ymm5     # ymm5 = ymm6[0],ymm7[0],ymm6[1],ymm7[1],ymm6[2],ymm7[2],ymm6[3],ymm7[3],ymm6[4],ymm7[4],ymm6[5],ymm7[5],ymm6[6],ymm7[6],ymm6[7],ymm7[7],ymm6[16],ymm7[16],ymm6[17],ymm7[17],ymm6[18],ymm7[18],ymm6[19],ymm7[19],ymm6[20],ymm7[20],ymm6[21],ymm7[21],ymm6[22],ymm7[22],ymm6[23],ymm7[23]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm13, %ymm13
	vpunpckhbw	%ymm7, %ymm6, %ymm5     # ymm5 = ymm6[8],ymm7[8],ymm6[9],ymm7[9],ymm6[10],ymm7[10],ymm6[11],ymm7[11],ymm6[12],ymm7[12],ymm6[13],ymm7[13],ymm6[14],ymm7[14],ymm6[15],ymm7[15],ymm6[24],ymm7[24],ymm6[25],ymm7[25],ymm6[26],ymm7[26],ymm6[27],ymm7[27],ymm6[28],ymm7[28],ymm6[29],ymm7[29],ymm6[30],ymm7[30],ymm6[31],ymm7[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm12, %ymm12
	vmovdqa	128(%r14,%r8), %ymm5
	vmovdqa	128(%r14,%r9), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm7, %ymm11, %ymm11
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm5
	vpaddw	%ymm5, %ymm10, %ymm10
	vmovdqa	160(%r14,%r8), %ymm5
	vmovdqa	160(%r14,%r9), %ymm6
	vpunpcklbw	%ymm6, %ymm5, %ymm7     # ymm7 = ymm5[0],ymm6[0],ymm5[1],ymm6[1],ymm5[2],ymm6[2],ymm5[3],ymm6[3],ymm5[4],ymm6[4],ymm5[5],ymm6[5],ymm5[6],ymm6[6],ymm5[7],ymm6[7],ymm5[16],ymm6[16],ymm5[17],ymm6[17],ymm5[18],ymm6[18],ymm5[19],ymm6[19],ymm5[20],ymm6[20],ymm5[21],ymm6[21],ymm5[22],ymm6[22],ymm5[23],ymm6[23]
	vpmaddubsw	%ymm7, %ymm4, %ymm7
	vpaddw	%ymm7, %ymm9, %ymm9
	vpunpckhbw	%ymm6, %ymm5, %ymm5     # ymm5 = ymm5[8],ymm6[8],ymm5[9],ymm6[9],ymm5[10],ymm6[10],ymm5[11],ymm6[11],ymm5[12],ymm6[12],ymm5[13],ymm6[13],ymm5[14],ymm6[14],ymm5[15],ymm6[15],ymm5[24],ymm6[24],ymm5[25],ymm6[25],ymm5[26],ymm6[26],ymm5[27],ymm6[27],ymm5[28],ymm6[28],ymm5[29],ymm6[29],ymm5[30],ymm6[30],ymm5[31],ymm6[31]
	vpmaddubsw	%ymm5, %ymm4, %ymm4
	vpaddw	%ymm4, %ymm8, %ymm8
	addl	$2, %esi
	addl	$384, %edi                      # imm = 0x180
	decl	%edx
	jne	.LBB6_5
	jmp	.LBB6_6
.LBB6_7:
	vmovups	64(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, (%rbx)
	vmovdqu	352(%rsp), %ymm9                # 32-byte Reload
	vmovdqa	%ymm9, 64(%rbx)
	vmovdqa	%ymm4, 32(%rbx)
	vmovdqu	(%rsp), %ymm8                   # 32-byte Reload
	vmovdqa	%ymm8, 96(%rbx)
	vmovdqu	32(%rsp), %ymm7                 # 32-byte Reload
	vmovdqa	%ymm7, 128(%rbx)
	vmovdqu	384(%rsp), %ymm6                # 32-byte Reload
	vmovdqa	%ymm6, 192(%rbx)
	vmovups	96(%rsp), %ymm0                 # 32-byte Reload
	vmovaps	%ymm0, 160(%rbx)
	vmovups	128(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 224(%rbx)
	vmovups	160(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 256(%rbx)
	vmovups	192(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 320(%rbx)
	vmovups	224(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 288(%rbx)
	vmovups	256(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 352(%rbx)
	vmovups	288(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 384(%rbx)
	vmovdqu	320(%rsp), %ymm0                # 32-byte Reload
	vmovdqa	%ymm0, 448(%rbx)
	vmovdqa	%ymm15, 416(%rbx)
	vmovdqa	%ymm14, 480(%rbx)
	vmovdqa	%ymm13, 512(%rbx)
	vmovdqa	%ymm12, 576(%rbx)
	vmovdqa	%ymm11, 544(%rbx)
	vmovdqa	%ymm10, 608(%rbx)
	vmovdqa	%ymm5, 640(%rbx)
	vmovdqa	%ymm6, %ymm5
	vmovdqa	%ymm7, %ymm6
	vmovdqa	%ymm8, %ymm7
	vmovdqa	%ymm9, %ymm8
	vmovdqu	64(%rsp), %ymm9                 # 32-byte Reload
	vmovdqa	%ymm3, 704(%rbx)
	vmovdqa	%ymm2, 672(%rbx)
	vmovdqa	%ymm1, 736(%rbx)
.LBB6_8:
	testb	$1, %r15b
	je	.LBB6_10
# %bb.9:
	decl	%r15d
	movl	%r15d, %eax
	shll	$6, %eax
	leal	(%rax,%rax,2), %eax
	movzbl	(%r12,%r15), %ecx
	vmovd	%ecx, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vmovdqa	(%r14,%rax), %ymm1
	vpunpcklbw	%ymm1, %ymm1, %ymm2     # ymm2 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vpmovsxwd	%xmm2, %ymm3
	vpaddd	%ymm3, %ymm9, %ymm3
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm8, %ymm2
	vmovdqa	%ymm3, (%rbx)
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vmovdqa	%ymm2, 64(%rbx)
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	%ymm2, %ymm4, %ymm2
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	%ymm1, %ymm7, %ymm1
	vmovdqa	32(%r14,%rax), %ymm3
	vmovdqa	%ymm2, 32(%rbx)
	vpunpcklbw	%ymm3, %ymm3, %ymm2     # ymm2 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vmovdqa	%ymm1, 96(%rbx)
	vpmovsxwd	%xmm2, %ymm1
	vpaddd	%ymm1, %ymm6, %ymm1
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	%ymm2, %ymm5, %ymm2
	vmovdqa	%ymm1, 128(%rbx)
	vmovdqa	64(%r14,%rax), %ymm1
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm3, %ymm0, %ymm3
	vmovdqa	%ymm2, 192(%rbx)
	vpmovsxwd	%xmm3, %ymm2
	vpaddd	160(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 160(%rbx)
	vpunpcklbw	%ymm1, %ymm1, %ymm2     # ymm2 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vpaddd	224(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 224(%rbx)
	vpmovsxwd	%xmm2, %ymm3
	vpaddd	256(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 256(%rbx)
	vmovdqa	96(%r14,%rax), %ymm3
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	320(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 320(%rbx)
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	288(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 288(%rbx)
	vpunpcklbw	%ymm3, %ymm3, %ymm2     # ymm2 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm3, %ymm0, %ymm3
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	352(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 352(%rbx)
	vpmovsxwd	%xmm2, %ymm1
	vextracti128	$1, %ymm2, %xmm2
	vpaddd	384(%rbx), %ymm1, %ymm1
	vpmovsxwd	%xmm2, %ymm2
	vmovdqa	%ymm1, 384(%rbx)
	vpaddd	448(%rbx), %ymm2, %ymm1
	vmovdqa	%ymm1, 448(%rbx)
	vpmovsxwd	%xmm3, %ymm1
	vpaddd	416(%rbx), %ymm1, %ymm1
	vmovdqa	128(%r14,%rax), %ymm2
	vmovdqa	%ymm1, 416(%rbx)
	vpunpcklbw	%ymm2, %ymm2, %ymm1     # ymm1 = ymm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vpunpckhbw	%ymm2, %ymm2, %ymm2     # ymm2 = ymm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm2, %ymm0, %ymm2
	vextracti128	$1, %ymm3, %xmm3
	vpmovsxwd	%xmm3, %ymm3
	vpaddd	480(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 480(%rbx)
	vpmovsxwd	%xmm1, %ymm3
	vpaddd	512(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 512(%rbx)
	vmovdqa	160(%r14,%rax), %ymm3
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	576(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 576(%rbx)
	vpmovsxwd	%xmm2, %ymm1
	vpaddd	544(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 544(%rbx)
	vpunpcklbw	%ymm3, %ymm3, %ymm1     # ymm1 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm1, %ymm0, %ymm1
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vextracti128	$1, %ymm2, %xmm2
	vpmovsxwd	%xmm2, %ymm2
	vpaddd	608(%rbx), %ymm2, %ymm2
	vmovdqa	%ymm2, 608(%rbx)
	vpmovsxwd	%xmm1, %ymm2
	vpaddd	640(%rbx), %ymm2, %ymm2
	vpmaddubsw	%ymm3, %ymm0, %ymm0
	vmovdqa	%ymm2, 640(%rbx)
	vextracti128	$1, %ymm1, %xmm1
	vpmovsxwd	%xmm1, %ymm1
	vpaddd	704(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 704(%rbx)
	vpmovsxwd	%xmm0, %ymm1
	vpaddd	672(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 672(%rbx)
	vextracti128	$1, %ymm0, %xmm0
	vpmovsxwd	%xmm0, %ymm0
	vpaddd	736(%rbx), %ymm0, %ymm0
	vmovdqa	%ymm0, 736(%rbx)
.LBB6_10:
	addq	$768, %rsp                      # imm = 0x300
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	vzeroupper
	retq
.Lfunc_end6:
	.size	_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi, .Lfunc_end6-_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi
                                        # -- End function
	.section	.text._ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf # -- Begin function _ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf,@function
_ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf: # @_ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%rdx, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	testq	%rdx, %rdx
	je	.LBB7_2
# %bb.1:
	prefetcht0	(%rbx)
	prefetcht0	64(%rbx)
	prefetcht0	128(%rbx)
	prefetcht0	192(%rbx)
	prefetcht0	256(%rbx)
	prefetcht0	320(%rbx)
	prefetcht0	384(%rbx)
	prefetcht0	448(%rbx)
	prefetcht0	512(%rbx)
	prefetcht0	576(%rbx)
	prefetcht0	640(%rbx)
	prefetcht0	704(%rbx)
.LBB7_2:
	movq	(%rdi), %rax
	movl	16(%rdi), %edx
	movq	%rsp, %rcx
	movq	%rax, %rdi
	callq	_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi
	vcvtdq2ps	(%rsp), %ymm0
	vmulps	(%r14), %ymm0, %ymm0
	vaddps	(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, (%rbx)
	vcvtdq2ps	32(%rsp), %ymm0
	vmulps	32(%r14), %ymm0, %ymm0
	vaddps	32(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 32(%rbx)
	vcvtdq2ps	64(%rsp), %ymm0
	vmulps	64(%r14), %ymm0, %ymm0
	vaddps	64(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 64(%rbx)
	vcvtdq2ps	96(%rsp), %ymm0
	vmulps	96(%r14), %ymm0, %ymm0
	vaddps	96(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 96(%rbx)
	vcvtdq2ps	128(%rsp), %ymm0
	vmulps	128(%r14), %ymm0, %ymm0
	vaddps	128(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 128(%rbx)
	vcvtdq2ps	160(%rsp), %ymm0
	vmulps	160(%r14), %ymm0, %ymm0
	vaddps	160(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 160(%rbx)
	vcvtdq2ps	192(%rsp), %ymm0
	vmulps	192(%r14), %ymm0, %ymm0
	vaddps	192(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 192(%rbx)
	vcvtdq2ps	224(%rsp), %ymm0
	vmulps	224(%r14), %ymm0, %ymm0
	vaddps	224(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 224(%rbx)
	vcvtdq2ps	256(%rsp), %ymm0
	vmulps	256(%r14), %ymm0, %ymm0
	vaddps	256(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 256(%rbx)
	vcvtdq2ps	288(%rsp), %ymm0
	vmulps	288(%r14), %ymm0, %ymm0
	vaddps	288(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 288(%rbx)
	vcvtdq2ps	320(%rsp), %ymm0
	vmulps	320(%r14), %ymm0, %ymm0
	vaddps	320(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 320(%rbx)
	vcvtdq2ps	352(%rsp), %ymm0
	vmulps	352(%r14), %ymm0, %ymm0
	vaddps	352(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 352(%rbx)
	vcvtdq2ps	384(%rsp), %ymm0
	vmulps	384(%r14), %ymm0, %ymm0
	vaddps	384(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 384(%rbx)
	vcvtdq2ps	416(%rsp), %ymm0
	vmulps	416(%r14), %ymm0, %ymm0
	vaddps	416(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 416(%rbx)
	vcvtdq2ps	448(%rsp), %ymm0
	vmulps	448(%r14), %ymm0, %ymm0
	vaddps	448(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 448(%rbx)
	vcvtdq2ps	480(%rsp), %ymm0
	vmulps	480(%r14), %ymm0, %ymm0
	vaddps	480(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 480(%rbx)
	vcvtdq2ps	512(%rsp), %ymm0
	vmulps	512(%r14), %ymm0, %ymm0
	vaddps	512(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 512(%rbx)
	vcvtdq2ps	544(%rsp), %ymm0
	vmulps	544(%r14), %ymm0, %ymm0
	vaddps	544(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 544(%rbx)
	vcvtdq2ps	576(%rsp), %ymm0
	vmulps	576(%r14), %ymm0, %ymm0
	vaddps	576(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 576(%rbx)
	vcvtdq2ps	608(%rsp), %ymm0
	vmulps	608(%r14), %ymm0, %ymm0
	vaddps	608(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 608(%rbx)
	vcvtdq2ps	640(%rsp), %ymm0
	vmulps	640(%r14), %ymm0, %ymm0
	vaddps	640(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 640(%rbx)
	vcvtdq2ps	672(%rsp), %ymm0
	vmulps	672(%r14), %ymm0, %ymm0
	vaddps	672(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 672(%rbx)
	vcvtdq2ps	704(%rsp), %ymm0
	vmulps	704(%r14), %ymm0, %ymm0
	vaddps	704(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 704(%rbx)
	vcvtdq2ps	736(%rsp), %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vaddps	736(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end7:
	.size	_ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf, .Lfunc_end7-_ZN3fx23opt17qsparse_dense_addERKNS0_7QSparseEPKhPf
                                        # -- End function
	.section	.text._ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi,"ax",@progbits
	.globl	_ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi # -- Begin function _ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi,@function
_ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi: # @_ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%rdx, %rbx
	movq	(%rdi), %rax
	movl	16(%rdi), %edx
	movq	%rsp, %r14
	movq	%rax, %rdi
	movq	%r14, %rcx
	callq	_ZN3fx23opt12_GLOBAL__N_111dense_accumEPKaPKhiPi
	movl	$768, %edx                      # imm = 0x300
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	memcpy@PLT
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	retq
.Lfunc_end8:
	.size	_ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi, .Lfunc_end8-_ZN3fx23opt17qsparse_dense_i32ERKNS0_7QSparseEPKhPi
                                        # -- End function
	.section	.text._ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf,"ax",@progbits
	.globl	_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf # -- Begin function _ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf,@function
_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf: # @_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%r8, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	movq	(%rdi), %rdi
	movq	%rsp, %r8
	callq	_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	(%r14), %ymm1, %ymm1
	vmovups	%ymm1, (%rbx)
	vmovdqa	32(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 32(%rbx)
	vmovdqa	64(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	64(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 64(%rbx)
	vmovdqa	96(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	96(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 96(%rbx)
	vmovdqa	128(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	128(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 128(%rbx)
	vmovdqa	160(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	160(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 160(%rbx)
	vmovdqa	192(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	192(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 192(%rbx)
	vmovdqa	224(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	224(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 224(%rbx)
	vmovdqa	256(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	256(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 256(%rbx)
	vmovdqa	288(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	288(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 288(%rbx)
	vmovdqa	320(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	320(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 320(%rbx)
	vmovdqa	352(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	352(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 352(%rbx)
	vmovdqa	384(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	384(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 384(%rbx)
	vmovdqa	416(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	416(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 416(%rbx)
	vmovdqa	448(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	448(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 448(%rbx)
	vmovdqa	480(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	480(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 480(%rbx)
	vmovdqa	512(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	512(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 512(%rbx)
	vmovdqa	544(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	544(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 544(%rbx)
	vmovdqa	576(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	576(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 576(%rbx)
	vmovdqa	608(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	608(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 608(%rbx)
	vmovdqa	640(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	640(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 640(%rbx)
	vmovdqa	672(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	672(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 672(%rbx)
	vmovdqa	704(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	704(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 704(%rbx)
	vmovdqa	736(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end9:
	.size	_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf, .Lfunc_end9-_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function _ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi
.LCPI10_0:
	.quad	-9223231297218904064            # 0x8000800080008000
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI10_1:
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
.LCPI10_2:
	.zero	32,15
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI10_3:
	.short	32768                           # 0x8000
.LCPI10_4:
	.byte	15                              # 0xf
	.section	.text._ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi,"ax",@progbits
	.p2align	4, 0x90
	.type	_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi,@function
_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi: # @_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$872, %rsp                      # imm = 0x368
	movq	%r8, %rbx
	movl	%ecx, %ebp
	movq	%rdx, %r12
	movq	%rsi, %r15
	movq	%rdi, %r14
	xorl	%r13d, %r13d
	movl	$768, %edx                      # imm = 0x300
	movq	%r8, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm10, %xmm10, %xmm10
	cmpl	$2, %ebp
	jl	.LBB10_9
# %bb.1:
	movl	%ebp, %eax
	shrl	$31, %eax
	addl	%ebp, %eax
	sarl	%eax
	xorl	%r13d, %r13d
	vpxor	%xmm2, %xmm2, %xmm2
	vpbroadcastq	.LCPI10_0(%rip), %ymm0  # ymm0 = [9223512776490647552,9223512776490647552,9223512776490647552,9223512776490647552]
	vmovdqu	%ymm0, 544(%rsp)                # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%ymm0, 512(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 480(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 448(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 416(%rsp)                # 32-byte Spill
	xorl	%edx, %edx
	vmovdqu	%ymm0, 384(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 352(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 320(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 192(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	jmp	.LBB10_2
	.p2align	4, 0x90
.LBB10_3:                               #   in Loop: Header=BB10_2 Depth=1
	movl	%edx, %ecx
	vmovdqu	544(%rsp), %ymm8                # 32-byte Reload
	vmovdqu	%ymm8, 160(%rsp)                # 32-byte Spill
	vmovdqu	%ymm8, 128(%rsp)                # 32-byte Spill
	vmovdqa	%ymm8, %ymm11
	vmovdqa	%ymm8, %ymm12
	vmovdqa	%ymm8, %ymm13
	vmovdqa	%ymm8, %ymm14
	vmovdqa	%ymm8, %ymm0
	vmovdqa	%ymm8, %ymm2
	vmovdqa	%ymm8, %ymm3
	vmovdqa	%ymm8, %ymm4
	vmovdqa	%ymm8, %ymm5
	vmovdqa	%ymm8, %ymm6
	vmovdqu	96(%rsp), %ymm9                 # 32-byte Reload
	vmovdqu	64(%rsp), %ymm7                 # 32-byte Reload
	vmovdqu	32(%rsp), %ymm10                # 32-byte Reload
	vmovdqu	(%rsp), %ymm15                  # 32-byte Reload
.LBB10_7:                               #   in Loop: Header=BB10_2 Depth=1
	vpxor	%ymm6, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm6            # ymm6 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm6, %ymm15, %ymm15
	vmovdqu	%ymm15, (%rsp)                  # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm1, %ymm10, %ymm10
	vmovdqu	%ymm10, 32(%rsp)                # 32-byte Spill
	vpxor	%ymm5, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm5            # ymm5 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm5, %ymm7, %ymm7
	vmovdqu	%ymm7, 64(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm1, %ymm9, %ymm9
	vmovdqu	%ymm9, 96(%rsp)                 # 32-byte Spill
	vpxor	%ymm4, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm4            # ymm4 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	192(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqu	%ymm5, 192(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	224(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm1, %ymm4, %ymm4
	vmovdqu	%ymm4, 224(%rsp)                # 32-byte Spill
	vpxor	%ymm3, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm3            # ymm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	256(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm4, 256(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	288(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rsp)                # 32-byte Spill
	vpxor	%ymm2, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm2            # ymm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	320(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	352(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 352(%rsp)                # 32-byte Spill
	vpxor	%ymm0, %ymm8, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	384(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 384(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	416(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 416(%rsp)                # 32-byte Spill
	vpxor	%ymm8, %ymm14, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	448(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 448(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	480(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 480(%rsp)                # 32-byte Spill
	vpxor	%ymm8, %ymm13, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	512(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 512(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	576(%rsp), %ymm14               # 32-byte Reload
	vpaddd	%ymm0, %ymm14, %ymm14
	vpxor	%ymm8, %ymm12, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	608(%rsp), %ymm13               # 32-byte Reload
	vpaddd	%ymm1, %ymm13, %ymm13
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	640(%rsp), %ymm12               # 32-byte Reload
	vpaddd	%ymm0, %ymm12, %ymm12
	vpxor	%ymm8, %ymm11, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	672(%rsp), %ymm6                # 32-byte Reload
	vpaddd	%ymm1, %ymm6, %ymm6
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	704(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm0, %ymm5, %ymm5
	vpxor	128(%rsp), %ymm8, %ymm0         # 32-byte Folded Reload
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	736(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm1, %ymm4, %ymm4
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	768(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm0, %ymm3, %ymm3
	vpxor	160(%rsp), %ymm8, %ymm0         # 32-byte Folded Reload
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	800(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm1
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	832(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm0, %ymm2, %ymm2
	movl	%ecx, %edx
	cmpl	%eax, %ecx
	jge	.LBB10_8
.LBB10_2:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB10_5 Depth 2
	leal	18(%rdx), %ecx
	cmpl	%ecx, %eax
	cmovll	%eax, %ecx
	cmpl	%ecx, %edx
	vmovdqu	%ymm2, 832(%rsp)                # 32-byte Spill
	vmovdqu	%ymm1, 800(%rsp)                # 32-byte Spill
	vmovdqu	%ymm3, 768(%rsp)                # 32-byte Spill
	vmovdqu	%ymm4, 736(%rsp)                # 32-byte Spill
	vmovdqu	%ymm5, 704(%rsp)                # 32-byte Spill
	vmovdqu	%ymm6, 672(%rsp)                # 32-byte Spill
	vmovdqu	%ymm12, 640(%rsp)               # 32-byte Spill
	vmovdqu	%ymm13, 608(%rsp)               # 32-byte Spill
	vmovdqu	%ymm14, 576(%rsp)               # 32-byte Spill
	jge	.LBB10_3
# %bb.4:                                #   in Loop: Header=BB10_2 Depth=1
	movslq	%edx, %rdi
	movslq	%ecx, %rsi
	subq	%rdi, %rsi
	addl	%edx, %edx
	vpbroadcastw	.LCPI10_3(%rip), %ymm1  # ymm1 = [32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768]
	vmovdqa	%ymm1, %ymm6
	vmovdqa	%ymm1, %ymm5
	vmovdqa	%ymm1, %ymm4
	vmovdqa	%ymm1, %ymm3
	vmovdqa	%ymm1, %ymm2
	vmovdqa	%ymm1, %ymm0
	vmovdqa	%ymm1, %ymm14
	vmovdqa	%ymm1, %ymm13
	vmovdqa	%ymm1, %ymm12
	vmovdqa	%ymm1, %ymm11
	vmovdqu	%ymm1, 128(%rsp)                # 32-byte Spill
	vmovdqu	%ymm1, 160(%rsp)                # 32-byte Spill
	vpbroadcastb	.LCPI10_4(%rip), %ymm10 # ymm10 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	.p2align	4, 0x90
.LBB10_5:                               #   Parent Loop BB10_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movslq	%edx, %rdx
	movzwl	(%r12,%rdx,2), %edi
	leal	1(%rdx), %r8d
	movslq	%r8d, %r8
	movzwl	(%r12,%r8,2), %r8d
	leal	8(%rdx), %r9d
	movslq	%r9d, %r9
	movzwl	(%r12,%r9,2), %r9d
	shlq	$7, %r9
	leal	9(%rdx), %r10d
	movslq	%r10d, %r10
	movzwl	(%r12,%r10,2), %r10d
	shlq	$7, %r10
	prefetcht0	(%r14,%r9)
	prefetcht0	64(%r14,%r9)
	prefetcht0	(%r14,%r10)
	prefetcht0	64(%r14,%r10)
	movzbl	(%r15,%rdi), %r9d
	shlq	$7, %rdi
	movzbl	(%r15,%r8), %r10d
	shlq	$7, %r8
	addl	%r9d, %r13d
	addl	%r10d, %r13d
	shll	$8, %r10d
	orl	%r9d, %r10d
	vmovd	%r10d, %xmm8
	vpbroadcastw	%xmm8, %ymm8
	vmovdqa	(%r14,%rdi), %ymm9
	vpand	%ymm10, %ymm9, %ymm7
	vmovdqa	(%r14,%r8), %ymm1
	vpand	%ymm1, %ymm10, %ymm15
	vpunpcklbw	%ymm15, %ymm7, %ymm10   # ymm10 = ymm7[0],ymm15[0],ymm7[1],ymm15[1],ymm7[2],ymm15[2],ymm7[3],ymm15[3],ymm7[4],ymm15[4],ymm7[5],ymm15[5],ymm7[6],ymm15[6],ymm7[7],ymm15[7],ymm7[16],ymm15[16],ymm7[17],ymm15[17],ymm7[18],ymm15[18],ymm7[19],ymm15[19],ymm7[20],ymm15[20],ymm7[21],ymm15[21],ymm7[22],ymm15[22],ymm7[23],ymm15[23]
	vpmaddubsw	%ymm8, %ymm10, %ymm10
	vpaddw	%ymm6, %ymm10, %ymm6
	vmovdqa	32(%r14,%rdi), %ymm10
	vpunpckhbw	%ymm15, %ymm7, %ymm7    # ymm7 = ymm7[8],ymm15[8],ymm7[9],ymm15[9],ymm7[10],ymm15[10],ymm7[11],ymm15[11],ymm7[12],ymm15[12],ymm7[13],ymm15[13],ymm7[14],ymm15[14],ymm7[15],ymm15[15],ymm7[24],ymm15[24],ymm7[25],ymm15[25],ymm7[26],ymm15[26],ymm7[27],ymm15[27],ymm7[28],ymm15[28],ymm7[29],ymm15[29],ymm7[30],ymm15[30],ymm7[31],ymm15[31]
	vmovdqa	32(%r14,%r8), %ymm15
	vpmaddubsw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm5, %ymm7, %ymm5
	vpsrlw	$4, %ymm9, %ymm7
	vpsrlw	$4, %ymm1, %ymm1
	vpand	.LCPI10_2(%rip), %ymm7, %ymm7
	vpand	.LCPI10_2(%rip), %ymm1, %ymm1
	vpunpcklbw	%ymm1, %ymm7, %ymm9     # ymm9 = ymm7[0],ymm1[0],ymm7[1],ymm1[1],ymm7[2],ymm1[2],ymm7[3],ymm1[3],ymm7[4],ymm1[4],ymm7[5],ymm1[5],ymm7[6],ymm1[6],ymm7[7],ymm1[7],ymm7[16],ymm1[16],ymm7[17],ymm1[17],ymm7[18],ymm1[18],ymm7[19],ymm1[19],ymm7[20],ymm1[20],ymm7[21],ymm1[21],ymm7[22],ymm1[22],ymm7[23],ymm1[23]
	vpmaddubsw	%ymm8, %ymm9, %ymm9
	vpaddw	%ymm4, %ymm9, %ymm4
	vpunpckhbw	%ymm1, %ymm7, %ymm1     # ymm1 = ymm7[8],ymm1[8],ymm7[9],ymm1[9],ymm7[10],ymm1[10],ymm7[11],ymm1[11],ymm7[12],ymm1[12],ymm7[13],ymm1[13],ymm7[14],ymm1[14],ymm7[15],ymm1[15],ymm7[24],ymm1[24],ymm7[25],ymm1[25],ymm7[26],ymm1[26],ymm7[27],ymm1[27],ymm7[28],ymm1[28],ymm7[29],ymm1[29],ymm7[30],ymm1[30],ymm7[31],ymm1[31]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm3, %ymm1, %ymm3
	vpand	.LCPI10_2(%rip), %ymm10, %ymm1
	vpand	.LCPI10_2(%rip), %ymm15, %ymm7
	vpunpcklbw	%ymm7, %ymm1, %ymm9     # ymm9 = ymm1[0],ymm7[0],ymm1[1],ymm7[1],ymm1[2],ymm7[2],ymm1[3],ymm7[3],ymm1[4],ymm7[4],ymm1[5],ymm7[5],ymm1[6],ymm7[6],ymm1[7],ymm7[7],ymm1[16],ymm7[16],ymm1[17],ymm7[17],ymm1[18],ymm7[18],ymm1[19],ymm7[19],ymm1[20],ymm7[20],ymm1[21],ymm7[21],ymm1[22],ymm7[22],ymm1[23],ymm7[23]
	vpmaddubsw	%ymm8, %ymm9, %ymm9
	vpaddw	%ymm2, %ymm9, %ymm2
	vmovdqa	64(%r14,%rdi), %ymm9
	vpunpckhbw	%ymm7, %ymm1, %ymm1     # ymm1 = ymm1[8],ymm7[8],ymm1[9],ymm7[9],ymm1[10],ymm7[10],ymm1[11],ymm7[11],ymm1[12],ymm7[12],ymm1[13],ymm7[13],ymm1[14],ymm7[14],ymm1[15],ymm7[15],ymm1[24],ymm7[24],ymm1[25],ymm7[25],ymm1[26],ymm7[26],ymm1[27],ymm7[27],ymm1[28],ymm7[28],ymm1[29],ymm7[29],ymm1[30],ymm7[30],ymm1[31],ymm7[31]
	vmovdqa	64(%r14,%r8), %ymm7
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm0, %ymm1, %ymm0
	vpsrlw	$4, %ymm10, %ymm1
	vpsrlw	$4, %ymm15, %ymm10
	vpand	.LCPI10_2(%rip), %ymm1, %ymm1
	vpand	.LCPI10_2(%rip), %ymm10, %ymm10
	vpunpcklbw	%ymm10, %ymm1, %ymm15   # ymm15 = ymm1[0],ymm10[0],ymm1[1],ymm10[1],ymm1[2],ymm10[2],ymm1[3],ymm10[3],ymm1[4],ymm10[4],ymm1[5],ymm10[5],ymm1[6],ymm10[6],ymm1[7],ymm10[7],ymm1[16],ymm10[16],ymm1[17],ymm10[17],ymm1[18],ymm10[18],ymm1[19],ymm10[19],ymm1[20],ymm10[20],ymm1[21],ymm10[21],ymm1[22],ymm10[22],ymm1[23],ymm10[23]
	vpmaddubsw	%ymm8, %ymm15, %ymm15
	vpaddw	%ymm14, %ymm15, %ymm14
	vpunpckhbw	%ymm10, %ymm1, %ymm1    # ymm1 = ymm1[8],ymm10[8],ymm1[9],ymm10[9],ymm1[10],ymm10[10],ymm1[11],ymm10[11],ymm1[12],ymm10[12],ymm1[13],ymm10[13],ymm1[14],ymm10[14],ymm1[15],ymm10[15],ymm1[24],ymm10[24],ymm1[25],ymm10[25],ymm1[26],ymm10[26],ymm1[27],ymm10[27],ymm1[28],ymm10[28],ymm1[29],ymm10[29],ymm1[30],ymm10[30],ymm1[31],ymm10[31]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm13, %ymm13
	vpand	.LCPI10_2(%rip), %ymm9, %ymm1
	vpand	.LCPI10_2(%rip), %ymm7, %ymm10
	vpunpcklbw	%ymm10, %ymm1, %ymm15   # ymm15 = ymm1[0],ymm10[0],ymm1[1],ymm10[1],ymm1[2],ymm10[2],ymm1[3],ymm10[3],ymm1[4],ymm10[4],ymm1[5],ymm10[5],ymm1[6],ymm10[6],ymm1[7],ymm10[7],ymm1[16],ymm10[16],ymm1[17],ymm10[17],ymm1[18],ymm10[18],ymm1[19],ymm10[19],ymm1[20],ymm10[20],ymm1[21],ymm10[21],ymm1[22],ymm10[22],ymm1[23],ymm10[23]
	vpmaddubsw	%ymm8, %ymm15, %ymm15
	vpaddw	%ymm12, %ymm15, %ymm12
	vpunpckhbw	%ymm10, %ymm1, %ymm1    # ymm1 = ymm1[8],ymm10[8],ymm1[9],ymm10[9],ymm1[10],ymm10[10],ymm1[11],ymm10[11],ymm1[12],ymm10[12],ymm1[13],ymm10[13],ymm1[14],ymm10[14],ymm1[15],ymm10[15],ymm1[24],ymm10[24],ymm1[25],ymm10[25],ymm1[26],ymm10[26],ymm1[27],ymm10[27],ymm1[28],ymm10[28],ymm1[29],ymm10[29],ymm1[30],ymm10[30],ymm1[31],ymm10[31]
	vpbroadcastb	.LCPI10_4(%rip), %ymm10 # ymm10 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm11, %ymm11
	vpsrlw	$4, %ymm9, %ymm1
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm10, %ymm1
	vpand	%ymm7, %ymm10, %ymm7
	vpunpcklbw	%ymm7, %ymm1, %ymm9     # ymm9 = ymm1[0],ymm7[0],ymm1[1],ymm7[1],ymm1[2],ymm7[2],ymm1[3],ymm7[3],ymm1[4],ymm7[4],ymm1[5],ymm7[5],ymm1[6],ymm7[6],ymm1[7],ymm7[7],ymm1[16],ymm7[16],ymm1[17],ymm7[17],ymm1[18],ymm7[18],ymm1[19],ymm7[19],ymm1[20],ymm7[20],ymm1[21],ymm7[21],ymm1[22],ymm7[22],ymm1[23],ymm7[23]
	vpmaddubsw	%ymm8, %ymm9, %ymm9
	vmovdqu	128(%rsp), %ymm15               # 32-byte Reload
	vpaddw	%ymm15, %ymm9, %ymm15
	vmovdqu	%ymm15, 128(%rsp)               # 32-byte Spill
	vpunpckhbw	%ymm7, %ymm1, %ymm1     # ymm1 = ymm1[8],ymm7[8],ymm1[9],ymm7[9],ymm1[10],ymm7[10],ymm1[11],ymm7[11],ymm1[12],ymm7[12],ymm1[13],ymm7[13],ymm1[14],ymm7[14],ymm1[15],ymm7[15],ymm1[24],ymm7[24],ymm1[25],ymm7[25],ymm1[26],ymm7[26],ymm1[27],ymm7[27],ymm1[28],ymm7[28],ymm1[29],ymm7[29],ymm1[30],ymm7[30],ymm1[31],ymm7[31]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vmovdqu	160(%rsp), %ymm7                # 32-byte Reload
	vpaddw	%ymm7, %ymm1, %ymm7
	vmovdqu	%ymm7, 160(%rsp)                # 32-byte Spill
	addl	$2, %edx
	decq	%rsi
	jne	.LBB10_5
# %bb.6:                                #   in Loop: Header=BB10_2 Depth=1
	vmovdqu	96(%rsp), %ymm9                 # 32-byte Reload
	vmovdqu	64(%rsp), %ymm7                 # 32-byte Reload
	vmovdqu	32(%rsp), %ymm10                # 32-byte Reload
	vmovdqu	(%rsp), %ymm15                  # 32-byte Reload
	vmovdqu	544(%rsp), %ymm8                # 32-byte Reload
	jmp	.LBB10_7
.LBB10_8:
	vmovdqu	(%rsp), %ymm10                  # 32-byte Reload
	vmovdqa	%ymm10, (%rbx)
	vmovdqu	32(%rsp), %ymm7                 # 32-byte Reload
	vmovdqa	%ymm7, 64(%rbx)
	vmovdqu	64(%rsp), %ymm9                 # 32-byte Reload
	vmovdqa	%ymm9, 32(%rbx)
	vmovdqu	96(%rsp), %ymm8                 # 32-byte Reload
	vmovdqa	%ymm8, 96(%rbx)
	vmovups	192(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 384(%rbx)
	vmovups	224(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 448(%rbx)
	vmovups	256(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 416(%rbx)
	vmovups	288(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 480(%rbx)
	vmovups	320(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 128(%rbx)
	vmovups	352(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 192(%rbx)
	vmovups	384(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 160(%rbx)
	vmovups	416(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 224(%rbx)
	vmovups	448(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 512(%rbx)
	vmovups	480(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 576(%rbx)
	vmovdqu	512(%rsp), %ymm0                # 32-byte Reload
	vmovdqa	%ymm0, 544(%rbx)
	vmovdqa	%ymm14, 608(%rbx)
	vmovdqa	%ymm13, 256(%rbx)
	vmovdqa	%ymm12, 320(%rbx)
	vmovdqa	%ymm6, 288(%rbx)
	vmovdqa	%ymm5, 352(%rbx)
	vmovdqa	%ymm4, 640(%rbx)
	vmovdqa	%ymm3, 704(%rbx)
	vmovdqa	%ymm1, 672(%rbx)
	vmovdqa	%ymm2, 736(%rbx)
.LBB10_9:
	testb	$1, %bpl
	je	.LBB10_11
# %bb.10:
	movslq	%ebp, %rax
	movzwl	-2(%r12,%rax,2), %ecx
	movzbl	(%r15,%rcx), %eax
	shlq	$7, %rcx
	movzwl	%ax, %eax
	vmovd	%eax, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vpbroadcastb	.LCPI10_4(%rip), %ymm1  # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vmovdqa	(%r14,%rcx), %ymm2
	vpand	%ymm1, %ymm2, %ymm3
	vpunpcklbw	%ymm3, %ymm3, %ymm4     # ymm4 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpmovzxwd	%xmm4, %ymm5            # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	%ymm5, %ymm10, %ymm5
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	%ymm4, %ymm7, %ymm4
	vmovdqa	32(%r14,%rcx), %ymm6
	vmovdqa	%ymm5, (%rbx)
	vmovdqa	64(%r14,%rcx), %ymm5
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpsrlw	$4, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm7
	vmovdqa	%ymm4, 64(%rbx)
	vpmovzxwd	%xmm3, %ymm2            # ymm2 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	%ymm2, %ymm9, %ymm2
	vpunpcklbw	%ymm7, %ymm7, %ymm4     # ymm4 = ymm7[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	%ymm3, %ymm8, %ymm3
	vpand	%ymm1, %ymm6, %ymm8
	vpsrlw	$4, %ymm6, %ymm6
	vpand	%ymm1, %ymm6, %ymm6
	vmovdqa	%ymm2, 32(%rbx)
	vpand	%ymm1, %ymm5, %ymm2
	vpsrlw	$4, %ymm5, %ymm5
	vmovdqa	%ymm3, 96(%rbx)
	vpmovzxwd	%xmm4, %ymm3            # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	384(%rbx), %ymm3, %ymm3
	vpand	%ymm1, %ymm5, %ymm1
	vmovdqa	%ymm3, 384(%rbx)
	vpunpckhbw	%ymm7, %ymm7, %ymm3     # ymm3 = ymm7[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	448(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 448(%rbx)
	vpmovzxwd	%xmm3, %ymm4            # ymm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	416(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 416(%rbx)
	vpunpcklbw	%ymm8, %ymm8, %ymm4     # ymm4 = ymm8[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	480(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 480(%rbx)
	vpmovzxwd	%xmm4, %ymm3            # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	128(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 128(%rbx)
	vpunpckhbw	%ymm8, %ymm8, %ymm3     # ymm3 = ymm8[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	192(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 192(%rbx)
	vpmovzxwd	%xmm3, %ymm4            # ymm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	160(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 160(%rbx)
	vpunpcklbw	%ymm6, %ymm6, %ymm4     # ymm4 = ymm6[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpunpckhbw	%ymm6, %ymm6, %ymm5     # ymm5 = ymm6[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm5, %ymm5
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	224(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 224(%rbx)
	vpmovzxwd	%xmm4, %ymm3            # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	512(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 512(%rbx)
	vpunpcklbw	%ymm2, %ymm2, %ymm3     # ymm3 = ymm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpunpckhbw	%ymm2, %ymm2, %ymm2     # ymm2 = ymm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	576(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 576(%rbx)
	vpmovzxwd	%xmm5, %ymm4            # ymm4 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero,xmm5[4],zero,xmm5[5],zero,xmm5[6],zero,xmm5[7],zero
	vpaddd	544(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 544(%rbx)
	vpunpcklbw	%ymm1, %ymm1, %ymm4     # ymm4 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vextracti128	$1, %ymm5, %xmm5
	vpmovzxwd	%xmm5, %ymm5            # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero,xmm5[4],zero,xmm5[5],zero,xmm5[6],zero,xmm5[7],zero
	vpaddd	608(%rbx), %ymm5, %ymm5
	vmovdqa	%ymm5, 608(%rbx)
	vpmovzxwd	%xmm3, %ymm5            # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	256(%rbx), %ymm5, %ymm5
	vpmaddubsw	%ymm0, %ymm1, %ymm0
	vmovdqa	%ymm5, 256(%rbx)
	vextracti128	$1, %ymm3, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	320(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 320(%rbx)
	vpmovzxwd	%xmm2, %ymm1            # ymm1 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vpaddd	288(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 288(%rbx)
	vextracti128	$1, %ymm2, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	352(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 352(%rbx)
	vpmovzxwd	%xmm4, %ymm1            # ymm1 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	640(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 640(%rbx)
	vextracti128	$1, %ymm4, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	704(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 704(%rbx)
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vpaddd	672(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 672(%rbx)
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vpaddd	736(%rbx), %ymm0, %ymm0
	vmovdqa	%ymm0, 736(%rbx)
	addl	%eax, %r13d
.LBB10_11:
	leal	(,%r13,8), %eax
	subl	%r13d, %eax
	addq	$872, %rsp                      # imm = 0x368
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end10:
	.size	_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi, .Lfunc_end10-_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi
                                        # -- End function
	.section	.text._ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf,"ax",@progbits
	.globl	_ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf # -- Begin function _ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf,@function
_ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf: # @_ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%r8, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	testq	%r8, %r8
	je	.LBB11_2
# %bb.1:
	prefetcht0	(%rbx)
	prefetcht0	64(%rbx)
	prefetcht0	128(%rbx)
	prefetcht0	192(%rbx)
	prefetcht0	256(%rbx)
	prefetcht0	320(%rbx)
	prefetcht0	384(%rbx)
	prefetcht0	448(%rbx)
	prefetcht0	512(%rbx)
	prefetcht0	576(%rbx)
	prefetcht0	640(%rbx)
	prefetcht0	704(%rbx)
.LBB11_2:
	movq	(%rdi), %rdi
	movq	%rsp, %r8
	callq	_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	(%r14), %ymm1, %ymm1
	vaddps	(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, (%rbx)
	vmovdqa	32(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%r14), %ymm1, %ymm1
	vaddps	32(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 32(%rbx)
	vmovdqa	64(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	64(%r14), %ymm1, %ymm1
	vaddps	64(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 64(%rbx)
	vmovdqa	96(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	96(%r14), %ymm1, %ymm1
	vaddps	96(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 96(%rbx)
	vmovdqa	128(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	128(%r14), %ymm1, %ymm1
	vaddps	128(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 128(%rbx)
	vmovdqa	160(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	160(%r14), %ymm1, %ymm1
	vaddps	160(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 160(%rbx)
	vmovdqa	192(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	192(%r14), %ymm1, %ymm1
	vaddps	192(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 192(%rbx)
	vmovdqa	224(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	224(%r14), %ymm1, %ymm1
	vaddps	224(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 224(%rbx)
	vmovdqa	256(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	256(%r14), %ymm1, %ymm1
	vaddps	256(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 256(%rbx)
	vmovdqa	288(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	288(%r14), %ymm1, %ymm1
	vaddps	288(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 288(%rbx)
	vmovdqa	320(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	320(%r14), %ymm1, %ymm1
	vaddps	320(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 320(%rbx)
	vmovdqa	352(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	352(%r14), %ymm1, %ymm1
	vaddps	352(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 352(%rbx)
	vmovdqa	384(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	384(%r14), %ymm1, %ymm1
	vaddps	384(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 384(%rbx)
	vmovdqa	416(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	416(%r14), %ymm1, %ymm1
	vaddps	416(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 416(%rbx)
	vmovdqa	448(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	448(%r14), %ymm1, %ymm1
	vaddps	448(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 448(%rbx)
	vmovdqa	480(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	480(%r14), %ymm1, %ymm1
	vaddps	480(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 480(%rbx)
	vmovdqa	512(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	512(%r14), %ymm1, %ymm1
	vaddps	512(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 512(%rbx)
	vmovdqa	544(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	544(%r14), %ymm1, %ymm1
	vaddps	544(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 544(%rbx)
	vmovdqa	576(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	576(%r14), %ymm1, %ymm1
	vaddps	576(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 576(%rbx)
	vmovdqa	608(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	608(%r14), %ymm1, %ymm1
	vaddps	608(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 608(%rbx)
	vmovdqa	640(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	640(%r14), %ymm1, %ymm1
	vaddps	640(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 640(%rbx)
	vmovdqa	672(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	672(%r14), %ymm1, %ymm1
	vaddps	672(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 672(%rbx)
	vmovdqa	704(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	704(%r14), %ymm1, %ymm1
	vaddps	704(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 704(%rbx)
	vmovdqa	736(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vaddps	736(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end11:
	.size	_ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf, .Lfunc_end11-_ZN3fx23opt12qsparse4_addERKNS0_8QSparse4EPKhPKtiPf
                                        # -- End function
	.section	.text._ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi,"ax",@progbits
	.globl	_ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi # -- Begin function _ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi,@function
_ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi: # @_ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%r8, %rbx
	movq	(%rdi), %rdi
	movq	%rsp, %r8
	callq	_ZN3fx23opt12_GLOBAL__N_113sparse4_accumILb1EEEiPKhS4_PKtiPi
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	(%rsp), %ymm1
	vmovdqa	32(%rsp), %ymm2
	vmovdqa	64(%rsp), %ymm3
	vmovdqa	96(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, (%rbx)
	vmovdqu	%ymm2, 32(%rbx)
	vmovdqu	%ymm3, 64(%rbx)
	vmovdqu	%ymm4, 96(%rbx)
	vmovdqa	128(%rsp), %ymm1
	vmovdqa	160(%rsp), %ymm2
	vmovdqa	192(%rsp), %ymm3
	vmovdqa	224(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 128(%rbx)
	vmovdqu	%ymm2, 160(%rbx)
	vmovdqu	%ymm3, 192(%rbx)
	vmovdqu	%ymm4, 224(%rbx)
	vmovdqa	256(%rsp), %ymm1
	vmovdqa	288(%rsp), %ymm2
	vmovdqa	320(%rsp), %ymm3
	vmovdqa	352(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 256(%rbx)
	vmovdqu	%ymm2, 288(%rbx)
	vmovdqu	%ymm3, 320(%rbx)
	vmovdqu	%ymm4, 352(%rbx)
	vmovdqa	384(%rsp), %ymm1
	vmovdqa	416(%rsp), %ymm2
	vmovdqa	448(%rsp), %ymm3
	vmovdqa	480(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 384(%rbx)
	vmovdqu	%ymm2, 416(%rbx)
	vmovdqu	%ymm3, 448(%rbx)
	vmovdqu	%ymm4, 480(%rbx)
	vmovdqa	512(%rsp), %ymm1
	vmovdqa	544(%rsp), %ymm2
	vmovdqa	576(%rsp), %ymm3
	vmovdqa	608(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 512(%rbx)
	vmovdqu	%ymm2, 544(%rbx)
	vmovdqu	%ymm3, 576(%rbx)
	vmovdqu	%ymm4, 608(%rbx)
	vmovdqa	640(%rsp), %ymm1
	vmovdqa	672(%rsp), %ymm2
	vmovdqa	704(%rsp), %ymm3
	vmovdqa	736(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm0
	vmovdqu	%ymm1, 640(%rbx)
	vmovdqu	%ymm2, 672(%rbx)
	vmovdqu	%ymm3, 704(%rbx)
	vmovdqu	%ymm0, 736(%rbx)
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end12:
	.size	_ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi, .Lfunc_end12-_ZN3fx23opt12qsparse4_i32ERKNS0_8QSparse4EPKhPKtiPi
                                        # -- End function
	.section	.text._ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf # -- Begin function _ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf,@function
_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf: # @_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%rdx, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	movq	(%rdi), %rax
	movl	16(%rdi), %edx
	movq	%rsp, %rcx
	movq	%rax, %rdi
	callq	_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	(%r14), %ymm1, %ymm1
	vmovups	%ymm1, (%rbx)
	vmovdqa	32(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 32(%rbx)
	vmovdqa	64(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	64(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 64(%rbx)
	vmovdqa	96(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	96(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 96(%rbx)
	vmovdqa	128(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	128(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 128(%rbx)
	vmovdqa	160(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	160(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 160(%rbx)
	vmovdqa	192(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	192(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 192(%rbx)
	vmovdqa	224(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	224(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 224(%rbx)
	vmovdqa	256(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	256(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 256(%rbx)
	vmovdqa	288(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	288(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 288(%rbx)
	vmovdqa	320(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	320(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 320(%rbx)
	vmovdqa	352(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	352(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 352(%rbx)
	vmovdqa	384(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	384(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 384(%rbx)
	vmovdqa	416(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	416(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 416(%rbx)
	vmovdqa	448(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	448(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 448(%rbx)
	vmovdqa	480(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	480(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 480(%rbx)
	vmovdqa	512(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	512(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 512(%rbx)
	vmovdqa	544(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	544(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 544(%rbx)
	vmovdqa	576(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	576(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 576(%rbx)
	vmovdqa	608(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	608(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 608(%rbx)
	vmovdqa	640(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	640(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 640(%rbx)
	vmovdqa	672(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	672(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 672(%rbx)
	vmovdqa	704(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	704(%r14), %ymm1, %ymm1
	vmovups	%ymm1, 704(%rbx)
	vmovdqa	736(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end13:
	.size	_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf, .Lfunc_end13-_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf
                                        # -- End function
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0                          # -- Begin function _ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi
.LCPI14_0:
	.quad	-9223231297218904064            # 0x8000800080008000
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI14_1:
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
	.short	32768                           # 0x8000
.LCPI14_2:
	.zero	32,15
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0
.LCPI14_3:
	.short	32768                           # 0x8000
.LCPI14_4:
	.byte	15                              # 0xf
	.section	.text._ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi,"ax",@progbits
	.p2align	4, 0x90
	.type	_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi,@function
_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi: # @_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$864, %rsp                      # imm = 0x360
	movq	%rcx, %rbx
	movl	%edx, %r15d
	movq	%rsi, %r12
	movq	%rdi, %r14
	xorl	%r13d, %r13d
	movl	$768, %edx                      # imm = 0x300
	movq	%rcx, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	vpxor	%xmm8, %xmm8, %xmm8
	vpxor	%xmm9, %xmm9, %xmm9
	vpxor	%xmm7, %xmm7, %xmm7
	vpxor	%xmm10, %xmm10, %xmm10
	cmpl	$2, %r15d
	jl	.LBB14_9
# %bb.1:
	movl	%r15d, %eax
	shrl	$31, %eax
	addl	%r15d, %eax
	sarl	%eax
	xorl	%r13d, %r13d
	vpxor	%xmm2, %xmm2, %xmm2
	vpbroadcastq	.LCPI14_0(%rip), %ymm0  # ymm0 = [9223512776490647552,9223512776490647552,9223512776490647552,9223512776490647552]
	vmovdqu	%ymm0, 544(%rsp)                # 32-byte Spill
	vpxor	%xmm1, %xmm1, %xmm1
	vpxor	%xmm3, %xmm3, %xmm3
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm6, %xmm6, %xmm6
	vpxor	%xmm12, %xmm12, %xmm12
	vpxor	%xmm13, %xmm13, %xmm13
	vpxor	%xmm14, %xmm14, %xmm14
	vpxor	%xmm0, %xmm0, %xmm0
	vmovdqu	%ymm0, 512(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 480(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 448(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 416(%rsp)                # 32-byte Spill
	xorl	%edx, %edx
	vmovdqu	%ymm0, 384(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 352(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 320(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 288(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 256(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 224(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 192(%rsp)                # 32-byte Spill
	vmovdqu	%ymm0, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 64(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm0, (%rsp)                   # 32-byte Spill
	jmp	.LBB14_2
	.p2align	4, 0x90
.LBB14_3:                               #   in Loop: Header=BB14_2 Depth=1
	movl	%edx, %ecx
	vmovdqu	544(%rsp), %ymm8                # 32-byte Reload
	vmovdqu	%ymm8, 160(%rsp)                # 32-byte Spill
	vmovdqu	%ymm8, 128(%rsp)                # 32-byte Spill
	vmovdqa	%ymm8, %ymm11
	vmovdqa	%ymm8, %ymm12
	vmovdqa	%ymm8, %ymm13
	vmovdqa	%ymm8, %ymm14
	vmovdqa	%ymm8, %ymm0
	vmovdqa	%ymm8, %ymm2
	vmovdqa	%ymm8, %ymm3
	vmovdqa	%ymm8, %ymm4
	vmovdqa	%ymm8, %ymm5
	vmovdqa	%ymm8, %ymm6
	vmovdqu	96(%rsp), %ymm9                 # 32-byte Reload
	vmovdqu	64(%rsp), %ymm7                 # 32-byte Reload
	vmovdqu	32(%rsp), %ymm10                # 32-byte Reload
	vmovdqu	(%rsp), %ymm15                  # 32-byte Reload
.LBB14_7:                               #   in Loop: Header=BB14_2 Depth=1
	vpxor	%ymm6, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm6            # ymm6 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm6, %ymm15, %ymm15
	vmovdqu	%ymm15, (%rsp)                  # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm1, %ymm10, %ymm10
	vmovdqu	%ymm10, 32(%rsp)                # 32-byte Spill
	vpxor	%ymm5, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm5            # ymm5 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm5, %ymm7, %ymm7
	vmovdqu	%ymm7, 64(%rsp)                 # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	%ymm1, %ymm9, %ymm9
	vmovdqu	%ymm9, 96(%rsp)                 # 32-byte Spill
	vpxor	%ymm4, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm4            # ymm4 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	192(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm4, %ymm5, %ymm5
	vmovdqu	%ymm5, 192(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	224(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm1, %ymm4, %ymm4
	vmovdqu	%ymm4, 224(%rsp)                # 32-byte Spill
	vpxor	%ymm3, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm3            # ymm3 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	256(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmovdqu	%ymm4, 256(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	288(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm1, %ymm3, %ymm3
	vmovdqu	%ymm3, 288(%rsp)                # 32-byte Spill
	vpxor	%ymm2, %ymm8, %ymm1
	vpmovzxwd	%xmm1, %ymm2            # ymm2 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	320(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm2, %ymm3, %ymm3
	vmovdqu	%ymm3, 320(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm1, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vmovdqu	352(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 352(%rsp)                # 32-byte Spill
	vpxor	%ymm0, %ymm8, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	384(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 384(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	416(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 416(%rsp)                # 32-byte Spill
	vpxor	%ymm8, %ymm14, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	448(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 448(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	480(%rsp), %ymm1                # 32-byte Reload
	vpaddd	%ymm0, %ymm1, %ymm1
	vmovdqu	%ymm1, 480(%rsp)                # 32-byte Spill
	vpxor	%ymm8, %ymm13, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	512(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm2
	vmovdqu	%ymm2, 512(%rsp)                # 32-byte Spill
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	576(%rsp), %ymm14               # 32-byte Reload
	vpaddd	%ymm0, %ymm14, %ymm14
	vpxor	%ymm8, %ymm12, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	608(%rsp), %ymm13               # 32-byte Reload
	vpaddd	%ymm1, %ymm13, %ymm13
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	640(%rsp), %ymm12               # 32-byte Reload
	vpaddd	%ymm0, %ymm12, %ymm12
	vpxor	%ymm8, %ymm11, %ymm0
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	672(%rsp), %ymm6                # 32-byte Reload
	vpaddd	%ymm1, %ymm6, %ymm6
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	704(%rsp), %ymm5                # 32-byte Reload
	vpaddd	%ymm0, %ymm5, %ymm5
	vpxor	128(%rsp), %ymm8, %ymm0         # 32-byte Folded Reload
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	736(%rsp), %ymm4                # 32-byte Reload
	vpaddd	%ymm1, %ymm4, %ymm4
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	768(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm0, %ymm3, %ymm3
	vpxor	160(%rsp), %ymm8, %ymm0         # 32-byte Folded Reload
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	800(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm1, %ymm2, %ymm1
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vmovdqu	832(%rsp), %ymm2                # 32-byte Reload
	vpaddd	%ymm0, %ymm2, %ymm2
	movl	%ecx, %edx
	cmpl	%eax, %ecx
	jge	.LBB14_8
.LBB14_2:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB14_5 Depth 2
	leal	18(%rdx), %ecx
	cmpl	%ecx, %eax
	cmovll	%eax, %ecx
	movl	%ecx, %esi
	subl	%edx, %esi
	vmovdqu	%ymm2, 832(%rsp)                # 32-byte Spill
	vmovdqu	%ymm1, 800(%rsp)                # 32-byte Spill
	vmovdqu	%ymm3, 768(%rsp)                # 32-byte Spill
	vmovdqu	%ymm4, 736(%rsp)                # 32-byte Spill
	vmovdqu	%ymm5, 704(%rsp)                # 32-byte Spill
	vmovdqu	%ymm6, 672(%rsp)                # 32-byte Spill
	vmovdqu	%ymm12, 640(%rsp)               # 32-byte Spill
	vmovdqu	%ymm13, 608(%rsp)               # 32-byte Spill
	vmovdqu	%ymm14, 576(%rsp)               # 32-byte Spill
	jle	.LBB14_3
# %bb.4:                                #   in Loop: Header=BB14_2 Depth=1
	movl	%edx, %edi
	shll	$8, %edi
	addl	%edx, %edx
	vpbroadcastw	.LCPI14_3(%rip), %ymm1  # ymm1 = [32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768,32768]
	vmovdqa	%ymm1, %ymm6
	vmovdqa	%ymm1, %ymm5
	vmovdqa	%ymm1, %ymm4
	vmovdqa	%ymm1, %ymm3
	vmovdqa	%ymm1, %ymm2
	vmovdqa	%ymm1, %ymm0
	vmovdqa	%ymm1, %ymm14
	vmovdqa	%ymm1, %ymm13
	vmovdqa	%ymm1, %ymm12
	vmovdqa	%ymm1, %ymm11
	vmovdqu	%ymm1, 128(%rsp)                # 32-byte Spill
	vmovdqu	%ymm1, 160(%rsp)                # 32-byte Spill
	vpbroadcastb	.LCPI14_4(%rip), %ymm10 # ymm10 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	.p2align	4, 0x90
.LBB14_5:                               #   Parent Loop BB14_2 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	leal	1(%rdx), %r10d
	movl	%edi, %r8d
	prefetcht0	2048(%r14,%r8)
	prefetcht0	2112(%r14,%r8)
	prefetcht0	2176(%r14,%r8)
	prefetcht0	2240(%r14,%r8)
	leal	128(%rdi), %r9d
	movl	%edx, %r11d
	movzbl	(%r12,%r11), %r11d
	movzbl	(%r12,%r10), %r10d
	addl	%r11d, %r13d
	addl	%r10d, %r13d
	shll	$8, %r10d
	orl	%r11d, %r10d
	vmovd	%r10d, %xmm8
	vpbroadcastw	%xmm8, %ymm8
	vmovdqa	(%r14,%r8), %ymm9
	vpand	%ymm10, %ymm9, %ymm7
	vmovdqa	(%r14,%r9), %ymm1
	vpand	%ymm1, %ymm10, %ymm15
	vpunpcklbw	%ymm15, %ymm7, %ymm10   # ymm10 = ymm7[0],ymm15[0],ymm7[1],ymm15[1],ymm7[2],ymm15[2],ymm7[3],ymm15[3],ymm7[4],ymm15[4],ymm7[5],ymm15[5],ymm7[6],ymm15[6],ymm7[7],ymm15[7],ymm7[16],ymm15[16],ymm7[17],ymm15[17],ymm7[18],ymm15[18],ymm7[19],ymm15[19],ymm7[20],ymm15[20],ymm7[21],ymm15[21],ymm7[22],ymm15[22],ymm7[23],ymm15[23]
	vpmaddubsw	%ymm8, %ymm10, %ymm10
	vpaddw	%ymm6, %ymm10, %ymm6
	vmovdqa	32(%r14,%r8), %ymm10
	vpunpckhbw	%ymm15, %ymm7, %ymm7    # ymm7 = ymm7[8],ymm15[8],ymm7[9],ymm15[9],ymm7[10],ymm15[10],ymm7[11],ymm15[11],ymm7[12],ymm15[12],ymm7[13],ymm15[13],ymm7[14],ymm15[14],ymm7[15],ymm15[15],ymm7[24],ymm15[24],ymm7[25],ymm15[25],ymm7[26],ymm15[26],ymm7[27],ymm15[27],ymm7[28],ymm15[28],ymm7[29],ymm15[29],ymm7[30],ymm15[30],ymm7[31],ymm15[31]
	vmovdqa	32(%r14,%r9), %ymm15
	vpmaddubsw	%ymm8, %ymm7, %ymm7
	vpaddw	%ymm5, %ymm7, %ymm5
	vpsrlw	$4, %ymm9, %ymm7
	vpsrlw	$4, %ymm1, %ymm1
	vpand	.LCPI14_2(%rip), %ymm7, %ymm7
	vpand	.LCPI14_2(%rip), %ymm1, %ymm1
	vpunpcklbw	%ymm1, %ymm7, %ymm9     # ymm9 = ymm7[0],ymm1[0],ymm7[1],ymm1[1],ymm7[2],ymm1[2],ymm7[3],ymm1[3],ymm7[4],ymm1[4],ymm7[5],ymm1[5],ymm7[6],ymm1[6],ymm7[7],ymm1[7],ymm7[16],ymm1[16],ymm7[17],ymm1[17],ymm7[18],ymm1[18],ymm7[19],ymm1[19],ymm7[20],ymm1[20],ymm7[21],ymm1[21],ymm7[22],ymm1[22],ymm7[23],ymm1[23]
	vpmaddubsw	%ymm8, %ymm9, %ymm9
	vpaddw	%ymm4, %ymm9, %ymm4
	vpunpckhbw	%ymm1, %ymm7, %ymm1     # ymm1 = ymm7[8],ymm1[8],ymm7[9],ymm1[9],ymm7[10],ymm1[10],ymm7[11],ymm1[11],ymm7[12],ymm1[12],ymm7[13],ymm1[13],ymm7[14],ymm1[14],ymm7[15],ymm1[15],ymm7[24],ymm1[24],ymm7[25],ymm1[25],ymm7[26],ymm1[26],ymm7[27],ymm1[27],ymm7[28],ymm1[28],ymm7[29],ymm1[29],ymm7[30],ymm1[30],ymm7[31],ymm1[31]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm3, %ymm1, %ymm3
	vpand	.LCPI14_2(%rip), %ymm10, %ymm1
	vpand	.LCPI14_2(%rip), %ymm15, %ymm7
	vpunpcklbw	%ymm7, %ymm1, %ymm9     # ymm9 = ymm1[0],ymm7[0],ymm1[1],ymm7[1],ymm1[2],ymm7[2],ymm1[3],ymm7[3],ymm1[4],ymm7[4],ymm1[5],ymm7[5],ymm1[6],ymm7[6],ymm1[7],ymm7[7],ymm1[16],ymm7[16],ymm1[17],ymm7[17],ymm1[18],ymm7[18],ymm1[19],ymm7[19],ymm1[20],ymm7[20],ymm1[21],ymm7[21],ymm1[22],ymm7[22],ymm1[23],ymm7[23]
	vpmaddubsw	%ymm8, %ymm9, %ymm9
	vpaddw	%ymm2, %ymm9, %ymm2
	vmovdqa	64(%r14,%r8), %ymm9
	vpunpckhbw	%ymm7, %ymm1, %ymm1     # ymm1 = ymm1[8],ymm7[8],ymm1[9],ymm7[9],ymm1[10],ymm7[10],ymm1[11],ymm7[11],ymm1[12],ymm7[12],ymm1[13],ymm7[13],ymm1[14],ymm7[14],ymm1[15],ymm7[15],ymm1[24],ymm7[24],ymm1[25],ymm7[25],ymm1[26],ymm7[26],ymm1[27],ymm7[27],ymm1[28],ymm7[28],ymm1[29],ymm7[29],ymm1[30],ymm7[30],ymm1[31],ymm7[31]
	vmovdqa	64(%r14,%r9), %ymm7
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm0, %ymm1, %ymm0
	vpsrlw	$4, %ymm10, %ymm1
	vpsrlw	$4, %ymm15, %ymm10
	vpand	.LCPI14_2(%rip), %ymm1, %ymm1
	vpand	.LCPI14_2(%rip), %ymm10, %ymm10
	vpunpcklbw	%ymm10, %ymm1, %ymm15   # ymm15 = ymm1[0],ymm10[0],ymm1[1],ymm10[1],ymm1[2],ymm10[2],ymm1[3],ymm10[3],ymm1[4],ymm10[4],ymm1[5],ymm10[5],ymm1[6],ymm10[6],ymm1[7],ymm10[7],ymm1[16],ymm10[16],ymm1[17],ymm10[17],ymm1[18],ymm10[18],ymm1[19],ymm10[19],ymm1[20],ymm10[20],ymm1[21],ymm10[21],ymm1[22],ymm10[22],ymm1[23],ymm10[23]
	vpmaddubsw	%ymm8, %ymm15, %ymm15
	vpaddw	%ymm14, %ymm15, %ymm14
	vpunpckhbw	%ymm10, %ymm1, %ymm1    # ymm1 = ymm1[8],ymm10[8],ymm1[9],ymm10[9],ymm1[10],ymm10[10],ymm1[11],ymm10[11],ymm1[12],ymm10[12],ymm1[13],ymm10[13],ymm1[14],ymm10[14],ymm1[15],ymm10[15],ymm1[24],ymm10[24],ymm1[25],ymm10[25],ymm1[26],ymm10[26],ymm1[27],ymm10[27],ymm1[28],ymm10[28],ymm1[29],ymm10[29],ymm1[30],ymm10[30],ymm1[31],ymm10[31]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm13, %ymm13
	vpand	.LCPI14_2(%rip), %ymm9, %ymm1
	vpand	.LCPI14_2(%rip), %ymm7, %ymm10
	vpunpcklbw	%ymm10, %ymm1, %ymm15   # ymm15 = ymm1[0],ymm10[0],ymm1[1],ymm10[1],ymm1[2],ymm10[2],ymm1[3],ymm10[3],ymm1[4],ymm10[4],ymm1[5],ymm10[5],ymm1[6],ymm10[6],ymm1[7],ymm10[7],ymm1[16],ymm10[16],ymm1[17],ymm10[17],ymm1[18],ymm10[18],ymm1[19],ymm10[19],ymm1[20],ymm10[20],ymm1[21],ymm10[21],ymm1[22],ymm10[22],ymm1[23],ymm10[23]
	vpmaddubsw	%ymm8, %ymm15, %ymm15
	vpaddw	%ymm12, %ymm15, %ymm12
	vpunpckhbw	%ymm10, %ymm1, %ymm1    # ymm1 = ymm1[8],ymm10[8],ymm1[9],ymm10[9],ymm1[10],ymm10[10],ymm1[11],ymm10[11],ymm1[12],ymm10[12],ymm1[13],ymm10[13],ymm1[14],ymm10[14],ymm1[15],ymm10[15],ymm1[24],ymm10[24],ymm1[25],ymm10[25],ymm1[26],ymm10[26],ymm1[27],ymm10[27],ymm1[28],ymm10[28],ymm1[29],ymm10[29],ymm1[30],ymm10[30],ymm1[31],ymm10[31]
	vpbroadcastb	.LCPI14_4(%rip), %ymm10 # ymm10 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vpaddw	%ymm1, %ymm11, %ymm11
	vpsrlw	$4, %ymm9, %ymm1
	vpsrlw	$4, %ymm7, %ymm7
	vpand	%ymm1, %ymm10, %ymm1
	vpand	%ymm7, %ymm10, %ymm7
	vpunpcklbw	%ymm7, %ymm1, %ymm9     # ymm9 = ymm1[0],ymm7[0],ymm1[1],ymm7[1],ymm1[2],ymm7[2],ymm1[3],ymm7[3],ymm1[4],ymm7[4],ymm1[5],ymm7[5],ymm1[6],ymm7[6],ymm1[7],ymm7[7],ymm1[16],ymm7[16],ymm1[17],ymm7[17],ymm1[18],ymm7[18],ymm1[19],ymm7[19],ymm1[20],ymm7[20],ymm1[21],ymm7[21],ymm1[22],ymm7[22],ymm1[23],ymm7[23]
	vpmaddubsw	%ymm8, %ymm9, %ymm9
	vmovdqu	128(%rsp), %ymm15               # 32-byte Reload
	vpaddw	%ymm15, %ymm9, %ymm15
	vmovdqu	%ymm15, 128(%rsp)               # 32-byte Spill
	vpunpckhbw	%ymm7, %ymm1, %ymm1     # ymm1 = ymm1[8],ymm7[8],ymm1[9],ymm7[9],ymm1[10],ymm7[10],ymm1[11],ymm7[11],ymm1[12],ymm7[12],ymm1[13],ymm7[13],ymm1[14],ymm7[14],ymm1[15],ymm7[15],ymm1[24],ymm7[24],ymm1[25],ymm7[25],ymm1[26],ymm7[26],ymm1[27],ymm7[27],ymm1[28],ymm7[28],ymm1[29],ymm7[29],ymm1[30],ymm7[30],ymm1[31],ymm7[31]
	vpmaddubsw	%ymm8, %ymm1, %ymm1
	vmovdqu	160(%rsp), %ymm7                # 32-byte Reload
	vpaddw	%ymm7, %ymm1, %ymm7
	vmovdqu	%ymm7, 160(%rsp)                # 32-byte Spill
	addl	$256, %edi                      # imm = 0x100
	addl	$2, %edx
	decl	%esi
	jne	.LBB14_5
# %bb.6:                                #   in Loop: Header=BB14_2 Depth=1
	vmovdqu	96(%rsp), %ymm9                 # 32-byte Reload
	vmovdqu	64(%rsp), %ymm7                 # 32-byte Reload
	vmovdqu	32(%rsp), %ymm10                # 32-byte Reload
	vmovdqu	(%rsp), %ymm15                  # 32-byte Reload
	vmovdqu	544(%rsp), %ymm8                # 32-byte Reload
	jmp	.LBB14_7
.LBB14_8:
	vmovdqu	(%rsp), %ymm10                  # 32-byte Reload
	vmovdqa	%ymm10, (%rbx)
	vmovdqu	32(%rsp), %ymm7                 # 32-byte Reload
	vmovdqa	%ymm7, 64(%rbx)
	vmovdqu	64(%rsp), %ymm9                 # 32-byte Reload
	vmovdqa	%ymm9, 32(%rbx)
	vmovdqu	96(%rsp), %ymm8                 # 32-byte Reload
	vmovdqa	%ymm8, 96(%rbx)
	vmovups	192(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 384(%rbx)
	vmovups	224(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 448(%rbx)
	vmovups	256(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 416(%rbx)
	vmovups	288(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 480(%rbx)
	vmovups	320(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 128(%rbx)
	vmovups	352(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 192(%rbx)
	vmovups	384(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 160(%rbx)
	vmovups	416(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 224(%rbx)
	vmovups	448(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 512(%rbx)
	vmovups	480(%rsp), %ymm0                # 32-byte Reload
	vmovaps	%ymm0, 576(%rbx)
	vmovdqu	512(%rsp), %ymm0                # 32-byte Reload
	vmovdqa	%ymm0, 544(%rbx)
	vmovdqa	%ymm14, 608(%rbx)
	vmovdqa	%ymm13, 256(%rbx)
	vmovdqa	%ymm12, 320(%rbx)
	vmovdqa	%ymm6, 288(%rbx)
	vmovdqa	%ymm5, 352(%rbx)
	vmovdqa	%ymm4, 640(%rbx)
	vmovdqa	%ymm3, 704(%rbx)
	vmovdqa	%ymm1, 672(%rbx)
	vmovdqa	%ymm2, 736(%rbx)
.LBB14_9:
	testb	$1, %r15b
	je	.LBB14_11
# %bb.10:
	decl	%r15d
	movl	%r15d, %ecx
	shll	$7, %ecx
	movzbl	(%r12,%r15), %eax
	movzwl	%ax, %eax
	vmovd	%eax, %xmm0
	vpbroadcastw	%xmm0, %ymm0
	vpbroadcastb	.LCPI14_4(%rip), %ymm1  # ymm1 = [15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15]
	vmovdqa	(%r14,%rcx), %ymm2
	vpand	%ymm1, %ymm2, %ymm3
	vpunpcklbw	%ymm3, %ymm3, %ymm4     # ymm4 = ymm3[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpmovzxwd	%xmm4, %ymm5            # ymm5 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	%ymm5, %ymm10, %ymm5
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	%ymm4, %ymm7, %ymm4
	vmovdqa	32(%r14,%rcx), %ymm6
	vmovdqa	%ymm5, (%rbx)
	vmovdqa	64(%r14,%rcx), %ymm5
	vpunpckhbw	%ymm3, %ymm3, %ymm3     # ymm3 = ymm3[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpsrlw	$4, %ymm2, %ymm2
	vpand	%ymm1, %ymm2, %ymm7
	vmovdqa	%ymm4, 64(%rbx)
	vpmovzxwd	%xmm3, %ymm2            # ymm2 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	%ymm2, %ymm9, %ymm2
	vpunpcklbw	%ymm7, %ymm7, %ymm4     # ymm4 = ymm7[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	%ymm3, %ymm8, %ymm3
	vpand	%ymm1, %ymm6, %ymm8
	vpsrlw	$4, %ymm6, %ymm6
	vpand	%ymm1, %ymm6, %ymm6
	vmovdqa	%ymm2, 32(%rbx)
	vpand	%ymm1, %ymm5, %ymm2
	vpsrlw	$4, %ymm5, %ymm5
	vmovdqa	%ymm3, 96(%rbx)
	vpmovzxwd	%xmm4, %ymm3            # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	384(%rbx), %ymm3, %ymm3
	vpand	%ymm1, %ymm5, %ymm1
	vmovdqa	%ymm3, 384(%rbx)
	vpunpckhbw	%ymm7, %ymm7, %ymm3     # ymm3 = ymm7[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	448(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 448(%rbx)
	vpmovzxwd	%xmm3, %ymm4            # ymm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	416(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 416(%rbx)
	vpunpcklbw	%ymm8, %ymm8, %ymm4     # ymm4 = ymm8[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	480(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 480(%rbx)
	vpmovzxwd	%xmm4, %ymm3            # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	128(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 128(%rbx)
	vpunpckhbw	%ymm8, %ymm8, %ymm3     # ymm3 = ymm8[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	192(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 192(%rbx)
	vpmovzxwd	%xmm3, %ymm4            # ymm4 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	160(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 160(%rbx)
	vpunpcklbw	%ymm6, %ymm6, %ymm4     # ymm4 = ymm6[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpunpckhbw	%ymm6, %ymm6, %ymm5     # ymm5 = ymm6[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm5, %ymm5
	vextracti128	$1, %ymm3, %xmm3
	vpmovzxwd	%xmm3, %ymm3            # ymm3 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	224(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 224(%rbx)
	vpmovzxwd	%xmm4, %ymm3            # ymm3 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	512(%rbx), %ymm3, %ymm3
	vmovdqa	%ymm3, 512(%rbx)
	vpunpcklbw	%ymm2, %ymm2, %ymm3     # ymm3 = ymm2[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm3, %ymm3
	vpunpckhbw	%ymm2, %ymm2, %ymm2     # ymm2 = ymm2[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vpmaddubsw	%ymm0, %ymm2, %ymm2
	vextracti128	$1, %ymm4, %xmm4
	vpmovzxwd	%xmm4, %ymm4            # ymm4 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	576(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 576(%rbx)
	vpmovzxwd	%xmm5, %ymm4            # ymm4 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero,xmm5[4],zero,xmm5[5],zero,xmm5[6],zero,xmm5[7],zero
	vpaddd	544(%rbx), %ymm4, %ymm4
	vmovdqa	%ymm4, 544(%rbx)
	vpunpcklbw	%ymm1, %ymm1, %ymm4     # ymm4 = ymm1[0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23]
	vpmaddubsw	%ymm0, %ymm4, %ymm4
	vpunpckhbw	%ymm1, %ymm1, %ymm1     # ymm1 = ymm1[8,8,9,9,10,10,11,11,12,12,13,13,14,14,15,15,24,24,25,25,26,26,27,27,28,28,29,29,30,30,31,31]
	vextracti128	$1, %ymm5, %xmm5
	vpmovzxwd	%xmm5, %ymm5            # ymm5 = xmm5[0],zero,xmm5[1],zero,xmm5[2],zero,xmm5[3],zero,xmm5[4],zero,xmm5[5],zero,xmm5[6],zero,xmm5[7],zero
	vpaddd	608(%rbx), %ymm5, %ymm5
	vmovdqa	%ymm5, 608(%rbx)
	vpmovzxwd	%xmm3, %ymm5            # ymm5 = xmm3[0],zero,xmm3[1],zero,xmm3[2],zero,xmm3[3],zero,xmm3[4],zero,xmm3[5],zero,xmm3[6],zero,xmm3[7],zero
	vpaddd	256(%rbx), %ymm5, %ymm5
	vpmaddubsw	%ymm0, %ymm1, %ymm0
	vmovdqa	%ymm5, 256(%rbx)
	vextracti128	$1, %ymm3, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	320(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 320(%rbx)
	vpmovzxwd	%xmm2, %ymm1            # ymm1 = xmm2[0],zero,xmm2[1],zero,xmm2[2],zero,xmm2[3],zero,xmm2[4],zero,xmm2[5],zero,xmm2[6],zero,xmm2[7],zero
	vpaddd	288(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 288(%rbx)
	vextracti128	$1, %ymm2, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	352(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 352(%rbx)
	vpmovzxwd	%xmm4, %ymm1            # ymm1 = xmm4[0],zero,xmm4[1],zero,xmm4[2],zero,xmm4[3],zero,xmm4[4],zero,xmm4[5],zero,xmm4[6],zero,xmm4[7],zero
	vpaddd	640(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 640(%rbx)
	vextracti128	$1, %ymm4, %xmm1
	vpmovzxwd	%xmm1, %ymm1            # ymm1 = xmm1[0],zero,xmm1[1],zero,xmm1[2],zero,xmm1[3],zero,xmm1[4],zero,xmm1[5],zero,xmm1[6],zero,xmm1[7],zero
	vpaddd	704(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 704(%rbx)
	vpmovzxwd	%xmm0, %ymm1            # ymm1 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vpaddd	672(%rbx), %ymm1, %ymm1
	vmovdqa	%ymm1, 672(%rbx)
	vextracti128	$1, %ymm0, %xmm0
	vpmovzxwd	%xmm0, %ymm0            # ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
	vpaddd	736(%rbx), %ymm0, %ymm0
	vmovdqa	%ymm0, 736(%rbx)
	addl	%eax, %r13d
.LBB14_11:
	leal	(,%r13,8), %eax
	subl	%r13d, %eax
	addq	$864, %rsp                      # imm = 0x360
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	vzeroupper
	retq
.Lfunc_end14:
	.size	_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi, .Lfunc_end14-_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi
                                        # -- End function
	.section	.text._ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf,"ax",@progbits
	.globl	_ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf # -- Begin function _ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf,@function
_ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf: # @_ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r14
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%rdx, %rbx
	movq	8(%rdi), %r14
	prefetcht0	(%r14)
	prefetcht0	64(%r14)
	prefetcht0	128(%r14)
	prefetcht0	192(%r14)
	prefetcht0	256(%r14)
	prefetcht0	320(%r14)
	prefetcht0	384(%r14)
	prefetcht0	448(%r14)
	prefetcht0	512(%r14)
	prefetcht0	576(%r14)
	prefetcht0	640(%r14)
	prefetcht0	704(%r14)
	testq	%rdx, %rdx
	je	.LBB15_2
# %bb.1:
	prefetcht0	(%rbx)
	prefetcht0	64(%rbx)
	prefetcht0	128(%rbx)
	prefetcht0	192(%rbx)
	prefetcht0	256(%rbx)
	prefetcht0	320(%rbx)
	prefetcht0	384(%rbx)
	prefetcht0	448(%rbx)
	prefetcht0	512(%rbx)
	prefetcht0	576(%rbx)
	prefetcht0	640(%rbx)
	prefetcht0	704(%rbx)
.LBB15_2:
	movq	(%rdi), %rax
	movl	16(%rdi), %edx
	movq	%rsp, %rcx
	movq	%rax, %rdi
	callq	_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	(%r14), %ymm1, %ymm1
	vaddps	(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, (%rbx)
	vmovdqa	32(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	32(%r14), %ymm1, %ymm1
	vaddps	32(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 32(%rbx)
	vmovdqa	64(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	64(%r14), %ymm1, %ymm1
	vaddps	64(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 64(%rbx)
	vmovdqa	96(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	96(%r14), %ymm1, %ymm1
	vaddps	96(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 96(%rbx)
	vmovdqa	128(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	128(%r14), %ymm1, %ymm1
	vaddps	128(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 128(%rbx)
	vmovdqa	160(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	160(%r14), %ymm1, %ymm1
	vaddps	160(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 160(%rbx)
	vmovdqa	192(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	192(%r14), %ymm1, %ymm1
	vaddps	192(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 192(%rbx)
	vmovdqa	224(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	224(%r14), %ymm1, %ymm1
	vaddps	224(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 224(%rbx)
	vmovdqa	256(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	256(%r14), %ymm1, %ymm1
	vaddps	256(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 256(%rbx)
	vmovdqa	288(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	288(%r14), %ymm1, %ymm1
	vaddps	288(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 288(%rbx)
	vmovdqa	320(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	320(%r14), %ymm1, %ymm1
	vaddps	320(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 320(%rbx)
	vmovdqa	352(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	352(%r14), %ymm1, %ymm1
	vaddps	352(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 352(%rbx)
	vmovdqa	384(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	384(%r14), %ymm1, %ymm1
	vaddps	384(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 384(%rbx)
	vmovdqa	416(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	416(%r14), %ymm1, %ymm1
	vaddps	416(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 416(%rbx)
	vmovdqa	448(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	448(%r14), %ymm1, %ymm1
	vaddps	448(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 448(%rbx)
	vmovdqa	480(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	480(%r14), %ymm1, %ymm1
	vaddps	480(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 480(%rbx)
	vmovdqa	512(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	512(%r14), %ymm1, %ymm1
	vaddps	512(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 512(%rbx)
	vmovdqa	544(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	544(%r14), %ymm1, %ymm1
	vaddps	544(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 544(%rbx)
	vmovdqa	576(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	576(%r14), %ymm1, %ymm1
	vaddps	576(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 576(%rbx)
	vmovdqa	608(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	608(%r14), %ymm1, %ymm1
	vaddps	608(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 608(%rbx)
	vmovdqa	640(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	640(%r14), %ymm1, %ymm1
	vaddps	640(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 640(%rbx)
	vmovdqa	672(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	672(%r14), %ymm1, %ymm1
	vaddps	672(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 672(%rbx)
	vmovdqa	704(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm1
	vcvtdq2ps	%ymm1, %ymm1
	vmulps	704(%r14), %ymm1, %ymm1
	vaddps	704(%rbx), %ymm1, %ymm1
	vmovups	%ymm1, 704(%rbx)
	vmovdqa	736(%rsp), %ymm1
	vpsubd	%ymm0, %ymm1, %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmulps	736(%r14), %ymm0, %ymm0
	vaddps	736(%rbx), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rbx)
	leaq	-16(%rbp), %rsp
	popq	%rbx
	popq	%r14
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end15:
	.size	_ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf, .Lfunc_end15-_ZN3fx23opt18qsparse4_dense_addERKNS0_8QSparse4EPKhPf
                                        # -- End function
	.section	.text._ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi,"ax",@progbits
	.globl	_ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi # -- Begin function _ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi,@function
_ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi: # @_ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%rbx
	andq	$-64, %rsp
	subq	$832, %rsp                      # imm = 0x340
	movq	%rdx, %rbx
	movq	(%rdi), %rax
	movl	16(%rdi), %edx
	movq	%rsp, %rcx
	movq	%rax, %rdi
	callq	_ZN3fx23opt12_GLOBAL__N_112dense4_accumEPKhS3_iPi
	vmovd	%eax, %xmm0
	vpbroadcastd	%xmm0, %ymm0
	vmovdqa	(%rsp), %ymm1
	vmovdqa	32(%rsp), %ymm2
	vmovdqa	64(%rsp), %ymm3
	vmovdqa	96(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, (%rbx)
	vmovdqu	%ymm2, 32(%rbx)
	vmovdqu	%ymm3, 64(%rbx)
	vmovdqu	%ymm4, 96(%rbx)
	vmovdqa	128(%rsp), %ymm1
	vmovdqa	160(%rsp), %ymm2
	vmovdqa	192(%rsp), %ymm3
	vmovdqa	224(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 128(%rbx)
	vmovdqu	%ymm2, 160(%rbx)
	vmovdqu	%ymm3, 192(%rbx)
	vmovdqu	%ymm4, 224(%rbx)
	vmovdqa	256(%rsp), %ymm1
	vmovdqa	288(%rsp), %ymm2
	vmovdqa	320(%rsp), %ymm3
	vmovdqa	352(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 256(%rbx)
	vmovdqu	%ymm2, 288(%rbx)
	vmovdqu	%ymm3, 320(%rbx)
	vmovdqu	%ymm4, 352(%rbx)
	vmovdqa	384(%rsp), %ymm1
	vmovdqa	416(%rsp), %ymm2
	vmovdqa	448(%rsp), %ymm3
	vmovdqa	480(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 384(%rbx)
	vmovdqu	%ymm2, 416(%rbx)
	vmovdqu	%ymm3, 448(%rbx)
	vmovdqu	%ymm4, 480(%rbx)
	vmovdqa	512(%rsp), %ymm1
	vmovdqa	544(%rsp), %ymm2
	vmovdqa	576(%rsp), %ymm3
	vmovdqa	608(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm4
	vmovdqu	%ymm1, 512(%rbx)
	vmovdqu	%ymm2, 544(%rbx)
	vmovdqu	%ymm3, 576(%rbx)
	vmovdqu	%ymm4, 608(%rbx)
	vmovdqa	640(%rsp), %ymm1
	vmovdqa	672(%rsp), %ymm2
	vmovdqa	704(%rsp), %ymm3
	vmovdqa	736(%rsp), %ymm4
	vpsubd	%ymm0, %ymm1, %ymm1
	vpsubd	%ymm0, %ymm2, %ymm2
	vpsubd	%ymm0, %ymm3, %ymm3
	vpsubd	%ymm0, %ymm4, %ymm0
	vmovdqu	%ymm1, 640(%rbx)
	vmovdqu	%ymm2, 672(%rbx)
	vmovdqu	%ymm3, 704(%rbx)
	vmovdqu	%ymm0, 736(%rbx)
	leaq	-8(%rbp), %rsp
	popq	%rbx
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end16:
	.size	_ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi, .Lfunc_end16-_ZN3fx23opt18qsparse4_dense_i32ERKNS0_8QSparse4EPKhPi
                                        # -- End function
	.section	.text._ZN3fx23opt16qsparse_make_idxEPKhiPt,"ax",@progbits
	.globl	_ZN3fx23opt16qsparse_make_idxEPKhiPt # -- Begin function _ZN3fx23opt16qsparse_make_idxEPKhiPt
	.p2align	4, 0x90
	.type	_ZN3fx23opt16qsparse_make_idxEPKhiPt,@function
_ZN3fx23opt16qsparse_make_idxEPKhiPt:   # @_ZN3fx23opt16qsparse_make_idxEPKhiPt
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	leal	31(%rsi), %ecx
	leal	62(%rsi), %eax
	testl	%ecx, %ecx
	cmovnsl	%ecx, %eax
	testl	%esi, %esi
	jle	.LBB17_1
# %bb.3:
	pushq	%rbp
	pushq	%rbx
	sarl	$5, %eax
	andl	$31, %esi
	je	.LBB17_6
# %bb.4:
	movl	$-1, %ecx
	shlxl	%esi, %ecx, %ecx
	notl	%ecx
	leal	-1(%rax), %esi
	cmpl	$2, %eax
	movl	$1, %r8d
	cmovgel	%eax, %r8d
	shlq	$5, %rsi
	shlq	$5, %r8
	xorl	%r9d, %r9d
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB17_5:                               # =>This Inner Loop Header: Depth=1
	vpcmpeqb	(%rdi,%r9), %ymm0, %ymm1
	vpmovmskb	%ymm1, %r10d
	cmpq	%r9, %rsi
	movl	$-1, %r11d
	cmovel	%ecx, %r11d
	andnl	%r11d, %r10d, %ebx
	movzbl	%bl, %r10d
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%r10,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vmovd	%r9d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%r10d, %r10d
	addl	%r10d, %eax
	movzbl	%bh, %ebp
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%rbp,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	8(%r9), %r10d
	vmovd	%r10d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%ebp, %r10d
	addl	%r10d, %eax
	movl	%ebx, %r10d
	shrl	$16, %r10d
	movzbl	%r10b, %r10d
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%r10,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	16(%r9), %r11d
	vmovd	%r11d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%r10d, %r10d
	addl	%r10d, %eax
	shrl	$24, %ebx
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%rbx,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	24(%r9), %r10d
	vmovd	%r10d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%ebx, %r10d
	addl	%r10d, %eax
	addq	$32, %r9
	cmpq	%r9, %r8
	jne	.LBB17_5
	jmp	.LBB17_8
.LBB17_1:
	xorl	%eax, %eax
                                        # kill: def $eax killed $eax killed $rax
	retq
.LBB17_6:
	cmpl	$2, %eax
	movl	$1, %ecx
	cmovgel	%eax, %ecx
	shlq	$5, %rcx
	xorl	%esi, %esi
	vpxor	%xmm0, %xmm0, %xmm0
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB17_7:                               # =>This Inner Loop Header: Depth=1
	vpcmpeqb	(%rdi,%rsi), %ymm0, %ymm1
	vpmovmskb	%ymm1, %ebx
	notl	%ebx
	movzbl	%bl, %r8d
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%r8,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vmovd	%esi, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%r8d, %r8d
	addl	%r8d, %eax
	movzbl	%bh, %ebp
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%rbp,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	8(%rsi), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%ebp, %r8d
	addl	%r8d, %eax
	movl	%ebx, %r8d
	shrl	$16, %r8d
	movzbl	%r8b, %r8d
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%r8,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	16(%rsi), %r9d
	vmovd	%r9d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%r8d, %r8d
	addl	%r8d, %eax
	shrl	$24, %ebx
	vpmovzxbw	_ZN3fx23opt12_GLOBAL__N_15g_lutE(,%rbx,8), %xmm1 # xmm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	leal	24(%rsi), %r8d
	vmovd	%r8d, %xmm2
	vpbroadcastw	%xmm2, %xmm2
	vpaddw	%xmm1, %xmm2, %xmm1
	cltq
	vmovdqu	%xmm1, (%rdx,%rax,2)
	popcntl	%ebx, %r8d
	addl	%r8d, %eax
	addq	$32, %rsi
	cmpq	%rsi, %rcx
	jne	.LBB17_7
.LBB17_8:
	popq	%rbx
	popq	%rbp
                                        # kill: def $eax killed $eax killed $rax
	vzeroupper
	retq
.Lfunc_end17:
	.size	_ZN3fx23opt16qsparse_make_idxEPKhiPt, .Lfunc_end17-_ZN3fx23opt16qsparse_make_idxEPKhiPt
                                        # -- End function
	.section	.text.startup,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _GLOBAL__sub_I_qmat_sparse.cpp
	.type	_GLOBAL__sub_I_qmat_sparse.cpp,@function
_GLOBAL__sub_I_qmat_sparse.cpp:         # @_GLOBAL__sub_I_qmat_sparse.cpp
# %bb.0:
	pushq	%rbx
	movq	$-256, %rbx
	jmp	.LBB18_1
	.p2align	4, 0x90
.LBB18_18:                              #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %ecx
	leaq	(%rcx,%rbx,8), %rdi
	addq	$_ZN3fx23opt12_GLOBAL__N_15g_lutE+2048, %rdi
	movl	$7, %edx
	subl	%eax, %edx
	incq	%rdx
	xorl	%esi, %esi
	callq	memset@PLT
.LBB18_19:                              #   in Loop: Header=BB18_1 Depth=1
	incq	%rbx
	je	.LBB18_20
.LBB18_1:                               # =>This Inner Loop Header: Depth=1
	leaq	256(%rbx), %rcx
	movl	$0, %eax
	testb	$1, %cl
	jne	.LBB18_2
# %bb.3:                                #   in Loop: Header=BB18_1 Depth=1
	testb	$2, %cl
	jne	.LBB18_4
.LBB18_5:                               #   in Loop: Header=BB18_1 Depth=1
	testb	$4, %cl
	jne	.LBB18_6
.LBB18_7:                               #   in Loop: Header=BB18_1 Depth=1
	testb	$8, %cl
	jne	.LBB18_8
.LBB18_9:                               #   in Loop: Header=BB18_1 Depth=1
	testb	$16, %cl
	jne	.LBB18_10
.LBB18_11:                              #   in Loop: Header=BB18_1 Depth=1
	testb	$32, %cl
	jne	.LBB18_12
.LBB18_13:                              #   in Loop: Header=BB18_1 Depth=1
	testb	$64, %cl
	jne	.LBB18_14
.LBB18_15:                              #   in Loop: Header=BB18_1 Depth=1
	testb	%cl, %cl
	jns	.LBB18_18
	jmp	.LBB18_16
	.p2align	4, 0x90
.LBB18_2:                               #   in Loop: Header=BB18_1 Depth=1
	movb	$0, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(,%rbx,8)
	movl	$1, %eax
	testb	$2, %cl
	je	.LBB18_5
.LBB18_4:                               #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$1, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rdx,%rbx,8)
	testb	$4, %cl
	je	.LBB18_7
.LBB18_6:                               #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$2, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rdx,%rbx,8)
	testb	$8, %cl
	je	.LBB18_9
.LBB18_8:                               #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$3, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rdx,%rbx,8)
	testb	$16, %cl
	je	.LBB18_11
.LBB18_10:                              #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$4, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rdx,%rbx,8)
	testb	$32, %cl
	je	.LBB18_13
.LBB18_12:                              #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$5, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rdx,%rbx,8)
	testb	$64, %cl
	je	.LBB18_15
.LBB18_14:                              #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %edx
	incl	%eax
	movb	$6, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rdx,%rbx,8)
	testb	%cl, %cl
	jns	.LBB18_18
.LBB18_16:                              #   in Loop: Header=BB18_1 Depth=1
	movl	%eax, %ecx
	movb	$7, _ZN3fx23opt12_GLOBAL__N_15g_lutE+2048(%rcx,%rbx,8)
	cmpl	$7, %eax
	jae	.LBB18_19
# %bb.17:                               #   in Loop: Header=BB18_1 Depth=1
	incl	%eax
	jmp	.LBB18_18
.LBB18_20:
	popq	%rbx
	retq
.Lfunc_end18:
	.size	_GLOBAL__sub_I_qmat_sparse.cpp, .Lfunc_end18-_GLOBAL__sub_I_qmat_sparse.cpp
                                        # -- End function
	.type	_ZN3fx23opt12_GLOBAL__N_15g_lutE,@object # @_ZN3fx23opt12_GLOBAL__N_15g_lutE
	.section	.bss._ZN3fx23opt12_GLOBAL__N_15g_lutE,"aw",@nobits
	.p2align	6, 0x0
_ZN3fx23opt12_GLOBAL__N_15g_lutE:
	.zero	2048
	.size	_ZN3fx23opt12_GLOBAL__N_15g_lutE, 2048

	.section	.init_array,"aw",@init_array
	.p2align	3, 0x90
	.quad	_GLOBAL__sub_I_qmat_sparse.cpp
	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _GLOBAL__sub_I_qmat_sparse.cpp
	.addrsig_sym _ZN3fx23opt12_GLOBAL__N_15g_lutE
