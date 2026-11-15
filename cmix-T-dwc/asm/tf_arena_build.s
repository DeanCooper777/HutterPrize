	.text
	.file	"arena_build.cpp"
	.section	.text._ZN3fx23opt7HugeBuf5allocEm,"ax",@progbits
	.globl	_ZN3fx23opt7HugeBuf5allocEm     # -- Begin function _ZN3fx23opt7HugeBuf5allocEm
	.p2align	1, 0x90
	.type	_ZN3fx23opt7HugeBuf5allocEm,@function
_ZN3fx23opt7HugeBuf5allocEm:            # @_ZN3fx23opt7HugeBuf5allocEm
# %bb.0:
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	movq	%rdi, %rbx
	addq	$2097151, %rsi                  # imm = 0x1FFFFF
	andq	$-2097152, %rsi                 # imm = 0xFFE00000
	movq	%rsi, 8(%rdi)
	xorl	%edi, %edi
	movl	$3, %edx
	movl	$34, %ecx
	movl	$-1, %r8d
	xorl	%r9d, %r9d
	callq	mmap
	cmpq	$-1, %rax
	je	.LBB0_2
# %bb.1:
	movq	%rax, %r14
	movq	8(%rbx), %rsi
	movq	%rax, %rdi
	movl	$14, %edx
	callq	madvise
	movq	8(%rbx), %rdx
	movq	%r14, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movq	%r14, (%rbx)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB0_2:
	movl	$.L.str, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end0:
	.size	_ZN3fx23opt7HugeBuf5allocEm, .Lfunc_end0-_ZN3fx23opt7HugeBuf5allocEm
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_13dieEPKc,"ax",@progbits
	.type	_ZN3fx23opt12_GLOBAL__N_13dieEPKc,@function # -- Begin function _ZN3fx23opt12_GLOBAL__N_13dieEPKc
_ZN3fx23opt12_GLOBAL__N_13dieEPKc:      # @_ZN3fx23opt12_GLOBAL__N_13dieEPKc
# %bb.0:
	pushq	%rax
	movq	%rdi, %rdx
	movq	stderr(%rip), %rdi
	movl	$.L.str.41, %esi
	xorl	%eax, %eax
	callq	fprintf
	movl	$1, %edi
	callq	exit
.Lfunc_end1:
	.size	_ZN3fx23opt12_GLOBAL__N_13dieEPKc, .Lfunc_end1-_ZN3fx23opt12_GLOBAL__N_13dieEPKc
                                        # -- End function
	.section	.text._ZN3fx23opt7HugeBufD2Ev,"ax",@progbits
	.globl	_ZN3fx23opt7HugeBufD2Ev         # -- Begin function _ZN3fx23opt7HugeBufD2Ev
	.p2align	1, 0x90
	.type	_ZN3fx23opt7HugeBufD2Ev,@function
_ZN3fx23opt7HugeBufD2Ev:                # @_ZN3fx23opt7HugeBufD2Ev
# %bb.0:
	movq	%rdi, %rax
	movq	(%rdi), %rdi
	testq	%rdi, %rdi
	je	.LBB2_1
# %bb.2:
	movq	8(%rax), %rsi
	jmp	munmap                          # TAILCALL
.LBB2_1:
	retq
.Lfunc_end2:
	.size	_ZN3fx23opt7HugeBufD2Ev, .Lfunc_end2-_ZN3fx23opt7HugeBufD2Ev
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt8OptModel4loadEPKc
.LCPI3_0:
	.long	0x3e000000                      # float 0.125
.LCPI3_1:
	.long	0x80000000                      # float -0
	.section	.text._ZN3fx23opt8OptModel4loadEPKc,"ax",@progbits
	.globl	_ZN3fx23opt8OptModel4loadEPKc
	.p2align	1, 0x90
	.type	_ZN3fx23opt8OptModel4loadEPKc,@function
_ZN3fx23opt8OptModel4loadEPKc:          # @_ZN3fx23opt8OptModel4loadEPKc
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$408, %rsp                      # imm = 0x198
	movq	%rsi, %rbx
	movq	%rdi, %r12
	movq	$0, 216(%rsp)
	movl	$.L.str.1, %esi
	movq	%rbx, %rdi
	callq	fopen
	testq	%rax, %rax
	je	.LBB3_4
# %bb.1:
	movq	%rax, %r14
	leaq	216(%rsp), %rdi
	movl	$1, %esi
	movl	$8, %edx
	movq	%rax, %rcx
	callq	fread
	cmpq	$8, %rax
	je	.LBB3_3
# %bb.2:
	movb	$0, 216(%rsp)
.LBB3_3:
	movq	%r14, %rdi
	callq	fclose
.LBB3_4:
	movl	$1412585542, %eax               # imm = 0x54325846
	xorl	216(%rsp), %eax
	movl	$1129793108, %ecx               # imm = 0x43574654
	xorl	219(%rsp), %ecx
	leaq	248(%rsp), %rdi
	movq	%rbx, %rsi
	orl	%eax, %ecx
	je	.LBB3_5
# %bb.6:
	callq	_ZN3fx211WeightsFile4loadEPKc
	jmp	.LBB3_7
.LBB3_5:
	callq	_ZN3fx211WeightsFile15load_compressedEPKc
.LBB3_7:
	leaq	56(%rsp), %r15
	movq	%r15, -16(%r15)
	leaq	40(%rsp), %r14
	movl	$.L.str.3, %esi
	movl	$.L.str.3+11, %edx
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	152(%rsp), %rcx
	movl	$11, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$1, %r8d
	movq	%r14, %rsi
	movl	$3, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	(%r14), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_9
# %bb.8:
	callq	_ZdlPv
.LBB3_9:
	movq	32(%rbx), %rax
	xorl	%ecx, %ecx
.LBB3_10:                               # =>This Inner Loop Header: Depth=1
	movl	(%rax,%rcx), %edx
	cmpl	.L__const._ZN3fx23opt8OptModel4loadEPKc.want(%rcx), %edx
	jne	.LBB3_17
# %bb.11:                               #   in Loop: Header=BB3_10 Depth=1
	addq	$4, %rcx
	cmpq	$44, %rcx
	jne	.LBB3_10
# %bb.12:
	leaq	40(%rsp), %r14
	movq	%r15, (%r14)
	movl	$.L.str.5, %esi
	movl	$.L.str.5+11, %edx
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	152(%rsp), %rcx
	movl	$12, (%rcx)
	movq	%r15, %r13
	leaq	248(%rsp), %r15
	movl	$1, %r8d
	movq	%r15, %rdi
	movq	%r14, %rsi
	movl	$3, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	(%r14), %rdi
	cmpq	%r13, %rdi
	je	.LBB3_14
# %bb.13:
	callq	_ZdlPv
.LBB3_14:
	movq	32(%rbx), %rax
	xorl	%ecx, %ecx
	movl	$1911, %edx                     # imm = 0x777
.LBB3_15:                               # =>This Inner Loop Header: Depth=1
	cmpl	$0, (%rax,%rcx,4)
	sete	%sil
	btq	%rcx, %rdx
	setb	%dil
	xorb	%sil, %dil
	je	.LBB3_16
# %bb.18:                               #   in Loop: Header=BB3_15 Depth=1
	incq	%rcx
	cmpq	$12, %rcx
	jne	.LBB3_15
# %bb.19:
	movl	$16777216, %esi                 # imm = 0x1000000
	movq	%r12, %rdi
	callq	_ZN3fx23opt7HugeBuf5allocEm
	xorl	%r13d, %r13d
	leaq	328(%rsp), %rax
	movq	%r13, (%rax)
	leaq	200(%rsp), %rcx
	movq	%rax, (%rcx)
	movq	%r12, 136(%rsp)                 # 8-byte Spill
	movq	%r12, 8(%rcx)
	movq	%r15, 232(%rsp)
	movq	%rcx, 240(%rsp)
	movq	%r15, 352(%rsp)
	movq	%rcx, 360(%rsp)
	movq	%r15, 336(%rsp)
	movq	%rcx, 344(%rsp)
	leaq	168(%rsp), %rax
	movq	%rax, -16(%rax)
	leaq	152(%rsp), %rbx
	movl	$.L.str.10, %esi
	movl	$.L.str.10+15, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	movq	(%rbx), %r14
	movq	8(%rbx), %r12
	leaq	40(%rsp), %rbx
	leaq	56(%rsp), %rbp
	movq	%rbp, (%rbx)
	movq	%r13, 8(%rbx)
	movb	$0, 16(%rbx)
	leaq	9(%r12), %rsi
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbx, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.42, %esi
	movl	$9, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movabsq	$880468295872, %rax             # imm = 0xCD000000C0
	leaq	104(%rsp), %rcx
	movq	%rax, (%rcx)
	movl	$2, %r8d
	movq	%r15, %rdi
	movq	%rbx, %rsi
	xorl	%edx, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r15
	movq	(%rbx), %rdi
	cmpq	%rbp, %rdi
	je	.LBB3_21
# %bb.20:
	callq	_ZdlPv
.LBB3_21:
	movq	152(%rsp), %r14
	movq	160(%rsp), %r12
	leaq	40(%rsp), %rbx
	leaq	56(%rsp), %r13
	movq	%r13, (%rbx)
	movq	$0, 8(%rbx)
	movb	$0, 16(%rbx)
	leaq	13(%r12), %rsi
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbx, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.43, %esi
	movl	$13, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	104(%rsp), %rcx
	movl	$192, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$1, %r8d
	movq	%rbx, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r12
	movq	(%rbx), %rdi
	cmpq	%r13, %rdi
	je	.LBB3_23
# %bb.22:
	callq	_ZdlPv
.LBB3_23:
	movq	152(%rsp), %r14
	movq	160(%rsp), %r13
	leaq	40(%rsp), %rbx
	leaq	56(%rsp), %rbp
	movq	%rbp, (%rbx)
	movq	$0, 8(%rbx)
	movb	$0, 16(%rbx)
	leaq	26(%r13), %rsi
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbx, %rdi
	movq	%r14, %rsi
	movq	%r13, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.44, %esi
	movl	$26, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	104(%rsp), %rcx
	movl	$1, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$1, %r8d
	movq	%rbx, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r14
	movq	(%rbx), %rdi
	cmpq	%rbp, %rdi
	je	.LBB3_25
# %bb.24:
	callq	_ZdlPv
.LBB3_25:
	movq	32(%r14), %rax
	movzwl	(%rax), %eax
	shll	$16, %eax
	vmovd	%eax, %xmm1
	vxorps	%xmm0, %xmm0, %xmm0
	vmovdqa	%xmm1, 304(%rsp)                # 16-byte Spill
	vucomiss	%xmm0, %xmm1
	movq	136(%rsp), %rcx                 # 8-byte Reload
	jbe	.LBB3_141
# %bb.26:
	movl	%eax, 48(%rcx)
	movl	$768, %edi                      # imm = 0x300
	callq	_Znwm
	movq	%rax, %r13
	xorl	%ebx, %ebx
	movl	$768, %edx                      # imm = 0x300
	movq	%rax, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movq	32(%r12), %rax
	vbroadcastss	304(%rsp), %ymm0        # 16-byte Folded Reload
.LBB3_27:                               # =>This Inner Loop Header: Depth=1
	vpmovzxwd	(%rax,%rbx,2), %ymm1    # ymm1 = mem[0],zero,mem[1],zero,mem[2],zero,mem[3],zero,mem[4],zero,mem[5],zero,mem[6],zero,mem[7],zero
	vpslld	$16, %ymm1, %ymm1
	vmulps	%ymm1, %ymm0, %ymm1
	vmovups	%ymm1, (%r13,%rbx,4)
	addq	$8, %rbx
	cmpq	$192, %rbx
	jne	.LBB3_27
# %bb.28:
	movq	200(%rsp), %rax
	movq	208(%rsp), %rcx
	movq	(%rax), %r14
	addq	$63, %r14
	andq	$-64, %r14
	movq	(%rcx), %rbx
	leaq	768(%r14), %rdx
	movq	%rdx, (%rax)
	leaq	4864(%r14), %rax
	cmpq	8(%rcx), %rax
	ja	.LBB3_142
# %bb.29:
	movl	$205, %edi
	vzeroupper
	callq	_ZN3fx23opt14qsparse4_bytesEi
	movq	200(%rsp), %rdx
	movq	208(%rsp), %rdi
	movq	(%rdx), %rcx
	addq	$63, %rcx
	andq	$-64, %rcx
	movq	(%rdi), %rsi
	leaq	(%rcx,%rax), %r8
	movq	%r8, (%rdx)
	addq	%rcx, %rax
	addq	$4096, %rax                     # imm = 0x1000
	cmpq	8(%rdi), %rax
	ja	.LBB3_142
# %bb.30:
	addq	%r14, %rbx
	addq	%rcx, %rsi
	movq	32(%r15), %rcx
	subq	$8, %rsp
	leaq	48(%rsp), %r14
	movq	%r14, %rdi
	movq	%rbx, %rdx
	movq	%r13, %r8
	movl	$192, %r9d
	pushq	$205
	callq	_ZN3fx23opt14qsparse4_buildEPhPfPKaPKfii
	addq	$16, %rsp
	movq	%r13, %rdi
	callq	_ZdlPv
	movq	16(%r14), %rax
	movq	136(%rsp), %r12                 # 8-byte Reload
	movq	%rax, 40(%r12)
	vmovups	(%r14), %xmm0
	vmovups	%xmm0, 24(%r12)
	movq	152(%rsp), %rdi
	leaq	168(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_32
# %bb.31:
	callq	_ZdlPv
.LBB3_32:
	leaq	40(%rsp), %r14
	leaq	56(%rsp), %r15
	movq	%r15, (%r14)
	movl	$.L.str.11, %esi
	movl	$.L.str.11+29, %edx
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	152(%rsp), %rcx
	movl	$6, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$1, %r8d
	movq	%r14, %rsi
	movl	$2, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	(%r14), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_34
# %bb.33:
	callq	_ZdlPv
.LBB3_34:
	movq	32(%rbx), %rax
	xorl	%ecx, %ecx
.LBB3_35:                               # =>This Inner Loop Header: Depth=1
	vmovss	(%rax,%rcx,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 7560(%r12,%rcx,4)
	incq	%rcx
	cmpq	$6, %rcx
	jne	.LBB3_35
# %bb.36:
	leaq	8152(%r12), %rax
	movq	%rax, 304(%rsp)                 # 8-byte Spill
	leaq	5532(%r12), %rax
	movq	%rax, 376(%rsp)                 # 8-byte Spill
	leaq	616(%r12), %rax
	movq	%rax, 368(%rsp)                 # 8-byte Spill
	xorl	%r12d, %r12d
	vbroadcastss	.LCPI3_1(%rip), %xmm0   # xmm0 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	movl	$3518437209, %edx               # imm = 0xD1B71759
	xorl	%r13d, %r13d
	movl	$0, 144(%rsp)                   # 4-byte Folded Spill
	movl	$0, 148(%rsp)                   # 4-byte Folded Spill
	vmovaps	%xmm0, 384(%rsp)                # 16-byte Spill
.LBB3_37:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_39 Depth 2
                                        #     Child Loop BB3_122 Depth 2
                                        #     Child Loop BB3_110 Depth 2
                                        #     Child Loop BB3_65 Depth 2
                                        #     Child Loop BB3_80 Depth 2
                                        #       Child Loop BB3_84 Depth 3
                                        #         Child Loop BB3_85 Depth 4
                                        #     Child Loop BB3_97 Depth 2
	movl	$1, %ebx
	cmpq	$10, %r13
	jb	.LBB3_49
# %bb.38:                               #   in Loop: Header=BB3_37 Depth=1
	movl	$4, %ebx
	movl	%r13d, %eax
.LBB3_39:                               #   Parent Loop BB3_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpl	$99, %eax
	jbe	.LBB3_40
# %bb.44:                               #   in Loop: Header=BB3_39 Depth=2
	cmpl	$999, %eax                      # imm = 0x3E7
	jbe	.LBB3_45
# %bb.46:                               #   in Loop: Header=BB3_39 Depth=2
	cmpl	$10000, %eax                    # imm = 0x2710
	jb	.LBB3_49
# %bb.47:                               #   in Loop: Header=BB3_39 Depth=2
	movl	%eax, %ecx
	imulq	%rdx, %rcx
	shrq	$45, %rcx
	addl	$4, %ebx
	cmpl	$99999, %eax                    # imm = 0x1869F
	movl	%ecx, %eax
	ja	.LBB3_39
# %bb.48:                               #   in Loop: Header=BB3_37 Depth=1
	addl	$-3, %ebx
	jmp	.LBB3_49
.LBB3_40:                               #   in Loop: Header=BB3_37 Depth=1
	addl	$-2, %ebx
	jmp	.LBB3_49
.LBB3_45:                               #   in Loop: Header=BB3_37 Depth=1
	decl	%ebx
.LBB3_49:                               #   in Loop: Header=BB3_37 Depth=1
	leaq	120(%rsp), %rax
	movq	%rax, 104(%rsp)
	movq	$0, 112(%rsp)
	movb	%r12b, 120(%rsp)
	movl	%ebx, %r14d
	leaq	104(%rsp), %rbp
	movq	%rbp, %rdi
	movq	%r14, %rsi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	104(%rsp), %rdi
	movb	$45, (%rdi)
	movl	%ebx, %esi
	movq	%r13, 192(%rsp)                 # 8-byte Spill
	movl	%r13d, %edx
	callq	_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_
	movq	%r14, 112(%rsp)
	movq	104(%rsp), %rax
	movb	%r12b, (%rax,%r14)
	movq	%rbp, %r12
	movl	$.L.str.12, %ecx
	movl	$7, %r8d
	movq	%rbp, %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7replaceEmmPKcm
	movq	%rax, %rbx
	movq	%r15, 40(%rsp)
	movq	(%rax), %rsi
	movq	%rax, %r14
	addq	$16, %r14
	cmpq	%r14, %rsi
	je	.LBB3_50
# %bb.51:                               #   in Loop: Header=BB3_37 Depth=1
	movq	%rsi, 40(%rsp)
	movq	(%r14), %rax
	movq	%rax, 56(%rsp)
	jmp	.LBB3_52
.LBB3_50:                               #   in Loop: Header=BB3_37 Depth=1
	movq	8(%rbx), %rdx
	incq	%rdx
	movq	%r15, %rdi
	callq	memcpy@PLT
.LBB3_52:                               #   in Loop: Header=BB3_37 Depth=1
	movq	136(%rsp), %r13                 # 8-byte Reload
	movq	8(%rbx), %rax
	movq	%rax, 48(%rsp)
	movq	%r14, (%rbx)
	movq	$0, 8(%rbx)
	movb	$0, 16(%rbx)
	movl	$.L.str.13, %esi
	leaq	40(%rsp), %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKc
	movq	%rax, %rbx
	leaq	168(%rsp), %rdi
	movq	%rdi, 152(%rsp)
	movq	(%rax), %rsi
	movq	%rax, %r14
	addq	$16, %r14
	cmpq	%r14, %rsi
	je	.LBB3_53
# %bb.54:                               #   in Loop: Header=BB3_37 Depth=1
	movq	%rsi, 152(%rsp)
	movq	(%r14), %rax
	movq	%rax, 168(%rsp)
	jmp	.LBB3_55
.LBB3_53:                               #   in Loop: Header=BB3_37 Depth=1
	movq	8(%rbx), %rdx
	incq	%rdx
	callq	memcpy@PLT
.LBB3_55:                               #   in Loop: Header=BB3_37 Depth=1
	movq	8(%rbx), %rax
	movq	%rax, 160(%rsp)
	movq	%r14, (%rbx)
	movq	$0, 8(%rbx)
	movb	$0, 16(%rbx)
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_57
# %bb.56:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_57:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rdi
	leaq	120(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_59
# %bb.58:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_59:                               #   in Loop: Header=BB3_37 Depth=1
	movq	152(%rsp), %rbx
	movq	160(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	33(%r14), %rsi
	leaq	40(%rsp), %rbp
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.14, %esi
	movl	$33, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$1, 104(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r12, %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	32(%rax), %rax
	vmovss	(%rax), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	movq	192(%rsp), %rax                 # 8-byte Reload
	vmovss	%xmm0, 7464(%r13,%rax,4)
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_61
# %bb.60:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_61:                               #   in Loop: Header=BB3_37 Depth=1
	movq	152(%rsp), %rbx
	movq	160(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	33(%r14), %rsi
	leaq	40(%rsp), %rbp
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.15, %esi
	movl	$33, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$1, 104(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%rbp, %rsi
	movl	$2, %edx
	movq	%r12, %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	32(%rax), %rax
	vmovss	(%rax), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	movq	192(%rsp), %rax                 # 8-byte Reload
	vmovss	%xmm0, 7512(%r13,%rax,4)
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_63
# %bb.62:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_63:                               #   in Loop: Header=BB3_37 Depth=1
	movq	152(%rsp), %rbx
	movq	160(%rsp), %r14
	leaq	120(%rsp), %rax
	movq	%rax, 104(%rsp)
	movq	$0, 112(%rsp)
	movb	$0, 120(%rsp)
	leaq	10(%r14), %rsi
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.16, %esi
	movl	$10, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$2184, %eax                     # imm = 0x888
	movq	192(%rsp), %rcx                 # 8-byte Reload
	btq	%rcx, %rax
	jb	.LBB3_121
# %bb.64:                               #   in Loop: Header=BB3_37 Depth=1
	movl	144(%rsp), %eax                 # 4-byte Reload
	movl	%eax, 7368(%r13,%rcx,4)
	xorl	%r15d, %r15d
.LBB3_65:                               #   Parent Loop BB3_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	.L__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names(%r15), %rbx
	movq	104(%rsp), %r14
	movq	112(%rsp), %r12
	movq	%rbx, %rdi
	callq	strlen
	movq	%rax, %rbp
	leaq	24(%rsp), %r13
	movq	%r13, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	(%rax,%r12), %rsi
	leaq	8(%rsp), %r13
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r13, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movq	%r13, %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	336(%rsp), %rsi
	movq	%r13, %rdx
	movl	$192, %ecx
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi
	vmovups	40(%rsp), %xmm0
	vmovups	52(%rsp), %xmm1
	movq	304(%rsp), %rax                 # 8-byte Reload
	vmovups	%xmm1, 12(%rax,%r15,4)
	vmovups	%xmm0, (%rax,%r15,4)
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_67
# %bb.66:                               #   in Loop: Header=BB3_65 Depth=2
	callq	_ZdlPv
.LBB3_67:                               #   in Loop: Header=BB3_65 Depth=2
	addq	$8, %r15
	cmpq	$24, %r15
	jne	.LBB3_65
# %bb.68:                               #   in Loop: Header=BB3_37 Depth=1
	movslq	144(%rsp), %r15                 # 4-byte Folded Reload
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	leaq	24(%rsp), %r12
	movq	%r12, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	25(%r14), %rsi
	leaq	8(%rsp), %r13
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r13, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.17, %esi
	movl	$25, %edx
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	232(%rsp), %rsi
	movq	%r13, %rdx
	movl	$64, %ecx
	movl	$192, %r8d
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
	leaq	(%r15,%r15,8), %rax
	shlq	$6, %rax
	vmovups	40(%rsp), %ymm0
	vmovups	68(%rsp), %ymm1
	movq	136(%rsp), %r13                 # 8-byte Reload
	vmovups	%ymm1, 276(%r13,%rax)
	movq	%rax, 184(%rsp)                 # 8-byte Spill
	vmovups	%ymm0, 248(%r13,%rax)
	movq	8(%rsp), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_70
# %bb.69:                               #   in Loop: Header=BB3_37 Depth=1
	vzeroupper
	callq	_ZdlPv
.LBB3_70:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	leaq	24(%rsp), %r15
	movq	%r15, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	27(%r14), %rsi
	leaq	8(%rsp), %r12
	movq	%r12, %rdi
	vzeroupper
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.18, %esi
	movl	$27, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	232(%rsp), %rsi
	movq	%r12, %rdx
	movl	$192, %ecx
	movl	$64, %r8d
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
	vmovups	40(%rsp), %ymm0
	vmovups	68(%rsp), %ymm1
	movq	184(%rsp), %rax                 # 8-byte Reload
	vmovups	%ymm1, 404(%r13,%rax)
	vmovups	%ymm0, 376(%r13,%rax)
	movq	8(%rsp), %rdi
	cmpq	%r15, %rdi
	leaq	56(%rsp), %r15
	je	.LBB3_72
# %bb.71:                               #   in Loop: Header=BB3_37 Depth=1
	vzeroupper
	callq	_ZdlPv
.LBB3_72:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	leaq	24(%rsp), %r12
	movq	%r12, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	25(%r14), %rsi
	leaq	8(%rsp), %rbp
	movq	%rbp, %rdi
	vzeroupper
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.19, %esi
	movl	$25, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	232(%rsp), %rsi
	movq	%rbp, %rdx
	movl	$64, %ecx
	movl	$192, %r8d
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
	vmovups	40(%rsp), %ymm0
	vmovups	68(%rsp), %ymm1
	movq	184(%rsp), %rax                 # 8-byte Reload
	vmovups	%ymm1, 340(%r13,%rax)
	vmovups	%ymm0, 312(%r13,%rax)
	movq	8(%rsp), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_74
# %bb.73:                               #   in Loop: Header=BB3_37 Depth=1
	vzeroupper
	callq	_ZdlPv
.LBB3_74:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	leaq	24(%rsp), %r12
	movq	%r12, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	27(%r14), %rsi
	leaq	8(%rsp), %rbp
	movq	%rbp, %rdi
	vzeroupper
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.20, %esi
	movl	$27, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	232(%rsp), %rsi
	movq	%rbp, %rdx
	movl	$192, %ecx
	movl	$64, %r8d
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
	vmovups	40(%rsp), %ymm0
	vmovups	68(%rsp), %ymm1
	movq	184(%rsp), %rax                 # 8-byte Reload
	vmovups	%ymm1, 468(%r13,%rax)
	vmovups	%ymm0, 440(%r13,%rax)
	movq	8(%rsp), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_76
# %bb.75:                               #   in Loop: Header=BB3_37 Depth=1
	vzeroupper
	callq	_ZdlPv
.LBB3_76:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	22(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	vzeroupper
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.21, %esi
	movl	$22, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movabsq	$824633720835, %rax             # imm = 0xC000000003
	movq	%rax, 8(%rsp)
	movl	$2, %r8d
	leaq	248(%rsp), %rdi
	movq	%r12, %rsi
	movl	$2, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_78
# %bb.77:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_78:                               #   in Loop: Header=BB3_37 Depth=1
	movq	32(%rbx), %rsi
	movq	200(%rsp), %rcx
	movq	208(%rsp), %rdx
	movq	(%rcx), %rax
	addq	$63, %rax
	andq	$-64, %rax
	movq	(%rdx), %rbx
	leaq	2304(%rax), %rdi
	movq	%rdi, (%rcx)
	leaq	6400(%rax), %rcx
	cmpq	8(%rdx), %rcx
	movq	184(%rsp), %r14                 # 8-byte Reload
	ja	.LBB3_142
# %bb.79:                               #   in Loop: Header=BB3_37 Depth=1
	addq	%rax, %rbx
	movl	$2304, %edx                     # imm = 0x900
	movq	%rbx, %rdi
	callq	memcpy@PLT
	leaq	(%r14,%r13), %rax
	addq	$576, %rax                      # imm = 0x240
	movq	%rax, 224(%rsp)                 # 8-byte Spill
	movq	%rbx, -8(%rax)
	xorl	%r15d, %r15d
.LBB3_80:                               #   Parent Loop BB3_37 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_84 Depth 3
                                        #         Child Loop BB3_85 Depth 4
	movq	.L__const._ZN3fx23opt8OptModel4loadEPKc.convs(,%r15,8), %rbx
	movq	104(%rsp), %r14
	movq	112(%rsp), %r12
	movq	%rbx, %rdi
	callq	strlen
	movq	%rax, %rbp
	leaq	56(%rsp), %r13
	movq	%r13, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	(%rax,%r12), %rsi
	leaq	40(%rsp), %r13
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r13, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movq	%r13, %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movabsq	$17179869376, %rax              # imm = 0x4000000C0
	movq	%rax, 8(%rsp)
	movl	$2, %r8d
	leaq	248(%rsp), %rdi
	movq	%r13, %rsi
	movl	$2, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	40(%rsp), %rdi
	leaq	56(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_82
# %bb.81:                               #   in Loop: Header=BB3_80 Depth=2
	callq	_ZdlPv
.LBB3_82:                               #   in Loop: Header=BB3_80 Depth=2
	movq	200(%rsp), %rdx
	movq	208(%rsp), %rsi
	movq	(%rdx), %rcx
	addq	$63, %rcx
	andq	$-64, %rcx
	movq	(%rsi), %rax
	leaq	3072(%rcx), %rdi
	movq	%rdi, (%rdx)
	leaq	7168(%rcx), %rdx
	cmpq	8(%rsi), %rdx
	ja	.LBB3_142
# %bb.83:                               #   in Loop: Header=BB3_80 Depth=2
	addq	%rcx, %rax
	movq	32(%rbx), %rcx
	movq	%rax, %rdx
	xorl	%esi, %esi
.LBB3_84:                               #   Parent Loop BB3_37 Depth=1
                                        #     Parent Loop BB3_80 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_85 Depth 4
	xorl	%edi, %edi
.LBB3_85:                               #   Parent Loop BB3_37 Depth=1
                                        #     Parent Loop BB3_80 Depth=2
                                        #       Parent Loop BB3_84 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	vmovss	(%rcx,%rdi,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, (%rdx,%rdi)
	addq	$4, %rdi
	cmpq	$768, %rdi                      # imm = 0x300
	jne	.LBB3_85
# %bb.86:                               #   in Loop: Header=BB3_84 Depth=3
	incq	%rsi
	addq	$4, %rcx
	addq	$768, %rdx                      # imm = 0x300
	cmpq	$4, %rsi
	jne	.LBB3_84
# %bb.87:                               #   in Loop: Header=BB3_80 Depth=2
	movq	224(%rsp), %rcx                 # 8-byte Reload
	movq	%rax, (%rcx,%r15,8)
	incq	%r15
	cmpq	$3, %r15
	jne	.LBB3_80
# %bb.88:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	leaq	56(%rsp), %r15
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	7(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.25, %esi
	movl	$7, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$192, 8(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%r12, %rsi
	movl	$2, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_90
# %bb.89:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_90:                               #   in Loop: Header=BB3_37 Depth=1
	movq	32(%rbx), %rsi
	movq	200(%rsp), %rcx
	movq	208(%rsp), %rdx
	movq	(%rcx), %rax
	addq	$63, %rax
	andq	$-64, %rax
	movq	(%rdx), %rbx
	leaq	768(%rax), %rdi
	movq	%rdi, (%rcx)
	leaq	4864(%rax), %rcx
	cmpq	8(%rdx), %rcx
	movq	136(%rsp), %r13                 # 8-byte Reload
	movq	184(%rsp), %r14                 # 8-byte Reload
	ja	.LBB3_142
# %bb.91:                               #   in Loop: Header=BB3_37 Depth=1
	addq	%rax, %rbx
	movl	$768, %edx                      # imm = 0x300
	movq	%rbx, %rdi
	callq	memcpy@PLT
	movq	%rbx, 600(%r13,%r14)
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	29(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.26, %esi
	movl	$29, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$64, 8(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%r12, %rsi
	movl	$2, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_93
# %bb.92:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_93:                               #   in Loop: Header=BB3_37 Depth=1
	movq	32(%rbx), %rsi
	movq	200(%rsp), %rcx
	movq	208(%rsp), %rdx
	movq	(%rcx), %rax
	addq	$63, %rax
	andq	$-64, %rax
	movq	(%rdx), %rbx
	leaq	256(%rax), %rdi
	movq	%rdi, (%rcx)
	leaq	4352(%rax), %rcx
	cmpq	8(%rdx), %rcx
	ja	.LBB3_142
# %bb.94:                               #   in Loop: Header=BB3_37 Depth=1
	addq	%rax, %rbx
	movl	$256, %edx                      # imm = 0x100
	movq	%rbx, %rdi
	callq	memcpy@PLT
	movq	184(%rsp), %rax                 # 8-byte Reload
	movq	%rbx, 608(%r13,%rax)
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	23(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.27, %esi
	movl	$23, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$3, 8(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%r12, %rsi
	movl	$2, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_96
# %bb.95:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_96:                               #   in Loop: Header=BB3_37 Depth=1
	movq	32(%rbx), %rbx
	movq	184(%rsp), %r12                 # 8-byte Reload
	addq	368(%rsp), %r12                 # 8-byte Folded Reload
	xorl	%r14d, %r14d
.LBB3_97:                               #   Parent Loop BB3_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmovss	(%rbx,%r14,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	callq	expf@PLT
	vxorps	384(%rsp), %xmm0, %xmm0         # 16-byte Folded Reload
	vmovss	%xmm0, (%r12,%r14,4)
	incq	%r14
	cmpq	$3, %r14
	jne	.LBB3_97
# %bb.98:                               #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	17(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.28, %esi
	movl	$17, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movq	192(%rsp), %rcx                 # 8-byte Reload
	leaq	9544(,%rcx,8), %r8
	addq	%r13, %r8
	leaq	9736(%r13,%rcx,8), %r9
	leaq	9832(%r13,%rcx,4), %rax
	leaq	9640(%r13,%rcx,8), %r10
	leaq	352(%rsp), %rdi
	movq	%r12, %rsi
	movl	$192, %edx
	movl	$1, %ecx
	pushq	%r10
	pushq	%rax
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi
	addq	$16, %rsp
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_100
# %bb.99:                               #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_100:                              #   in Loop: Header=BB3_37 Depth=1
	incl	144(%rsp)                       # 4-byte Folded Spill
	jmp	.LBB3_112
.LBB3_121:                              #   in Loop: Header=BB3_37 Depth=1
	movl	148(%rsp), %eax                 # 4-byte Reload
	movl	%eax, 7416(%r13,%rcx,4)
	xorl	%r15d, %r15d
.LBB3_122:                              #   Parent Loop BB3_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	.L__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names(%r15), %rbx
	movq	104(%rsp), %r14
	movq	112(%rsp), %r12
	movq	%rbx, %rdi
	callq	strlen
	movq	%rax, %rbp
	leaq	24(%rsp), %r13
	movq	%r13, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	(%rax,%r12), %rsi
	leaq	8(%rsp), %r13
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r13, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movq	%r13, %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	336(%rsp), %rsi
	movq	%r13, %rdx
	movl	$192, %ecx
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi
	vmovups	40(%rsp), %xmm0
	vmovups	52(%rsp), %xmm1
	movq	304(%rsp), %rax                 # 8-byte Reload
	vmovups	%xmm1, 12(%rax,%r15,4)
	vmovups	%xmm0, (%rax,%r15,4)
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_124
# %bb.123:                              #   in Loop: Header=BB3_122 Depth=2
	callq	_ZdlPv
.LBB3_124:                              #   in Loop: Header=BB3_122 Depth=2
	addq	$8, %r15
	cmpq	$24, %r15
	jne	.LBB3_122
# %bb.101:                              #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	leaq	56(%rsp), %r15
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	17(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.28, %esi
	movl	$17, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movq	136(%rsp), %r13                 # 8-byte Reload
	movq	192(%rsp), %rcx                 # 8-byte Reload
	leaq	9544(,%rcx,8), %r8
	addq	%r13, %r8
	leaq	9736(%r13,%rcx,8), %r9
	leaq	9832(%r13,%rcx,4), %rax
	leaq	9640(%r13,%rcx,8), %r10
	leaq	352(%rsp), %rdi
	movq	%r12, %rsi
	movl	$192, %edx
	movl	$1, %ecx
	pushq	%r10
	pushq	%rax
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi
	addq	$16, %rsp
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_103
# %bb.102:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_103:                              #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	22(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.29, %esi
	movl	$22, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$3, 8(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%r12, %rsi
	movl	$1, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, 224(%rsp)                 # 8-byte Spill
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_105
# %bb.104:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_105:                              #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rbx
	movq	112(%rsp), %r14
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	19(%r14), %rsi
	leaq	40(%rsp), %r12
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.30, %esi
	movl	$19, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$3, 8(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%r12, %rsi
	movl	$1, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_107
# %bb.106:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_107:                              #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %r14
	movq	112(%rsp), %r12
	movq	%r15, 40(%rsp)
	movq	$0, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	21(%r12), %rsi
	leaq	40(%rsp), %rbp
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%r14, %rsi
	movq	%r12, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.31, %esi
	movl	$21, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$3, 8(%rsp)
	movl	$1, %r8d
	leaq	248(%rsp), %rdi
	movq	%rbp, %rsi
	movl	$1, %edx
	leaq	8(%rsp), %rcx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r14
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_109
# %bb.108:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_109:                              #   in Loop: Header=BB3_37 Depth=1
	movslq	148(%rsp), %rsi                 # 4-byte Folded Reload
	movq	224(%rsp), %rax                 # 8-byte Reload
	movq	32(%rax), %rax
	movq	32(%rbx), %rcx
	movq	32(%r14), %rdx
	imulq	$304, %rsi, %rsi                # imm = 0x130
	addq	376(%rsp), %rsi                 # 8-byte Folded Reload
	xorl	%edi, %edi
	vmovss	.LCPI3_0(%rip), %xmm2           # xmm2 = mem[0],zero,zero,zero
.LBB3_110:                              #   Parent Loop BB3_37 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movzwl	(%rax,%rdi), %r8d
	shll	$16, %r8d
	vmovd	%r8d, %xmm0
	movl	%r8d, -36(%rsi,%rdi,2)
	movzwl	(%rcx,%rdi), %r8d
	shll	$16, %r8d
	vmovd	%r8d, %xmm1
	movl	%r8d, -24(%rsi,%rdi,2)
	movzwl	(%rdx,%rdi), %r8d
	shll	$16, %r8d
	movl	%r8d, -12(%rsi,%rdi,2)
	vmulss	%xmm2, %xmm0, %xmm0
	vmulss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, (%rsi,%rdi,2)
	addq	$2, %rdi
	cmpq	$6, %rdi
	jne	.LBB3_110
# %bb.111:                              #   in Loop: Header=BB3_37 Depth=1
	incl	148(%rsp)                       # 4-byte Folded Spill
.LBB3_112:                              #   in Loop: Header=BB3_37 Depth=1
	movq	152(%rsp), %rbx
	movq	160(%rsp), %r14
	leaq	24(%rsp), %r12
	movq	%r12, 8(%rsp)
	movq	$0, 16(%rsp)
	movb	$0, 24(%rsp)
	leaq	6(%r14), %rsi
	leaq	8(%rsp), %rbp
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.32, %esi
	movl	$6, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rdi
	leaq	336(%rsp), %rsi
	movq	%rbp, %rdx
	movl	$768, %ecx                      # imm = 0x300
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi
	movq	192(%rsp), %rax                 # 8-byte Reload
	shlq	$5, %rax
	vmovups	40(%rsp), %xmm0
	vmovups	52(%rsp), %xmm1
	vmovups	%xmm1, 7780(%r13,%rax)
	vmovups	%xmm0, 7768(%r13,%rax)
	movq	8(%rsp), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_114
# %bb.113:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_114:                              #   in Loop: Header=BB3_37 Depth=1
	movq	152(%rsp), %rbx
	movq	160(%rsp), %r14
	movq	%r15, 40(%rsp)
	xorl	%r12d, %r12d
	movq	%r12, 48(%rsp)
	movb	$0, 56(%rsp)
	leaq	8(%r14), %rsi
	leaq	40(%rsp), %rbp
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.33, %esi
	movl	$8, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movq	192(%rsp), %r13                 # 8-byte Reload
	movq	136(%rsp), %rax                 # 8-byte Reload
	leaq	(%rax,%r13,8), %r8
	addq	$9304, %r8                      # imm = 0x2458
	leaq	9400(%rax,%r13,8), %r9
	leaq	9496(%rax,%r13,4), %rax
	leaq	352(%rsp), %rdi
	movq	%rbp, %rsi
	movl	$768, %edx                      # imm = 0x300
	xorl	%ecx, %ecx
	pushq	%r12
	pushq	%rax
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi
	addq	$16, %rsp
	movq	40(%rsp), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_116
# %bb.115:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_116:                              #   in Loop: Header=BB3_37 Depth=1
	movq	104(%rsp), %rdi
	leaq	120(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_118
# %bb.117:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_118:                              #   in Loop: Header=BB3_37 Depth=1
	movq	152(%rsp), %rdi
	leaq	168(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_120
# %bb.119:                              #   in Loop: Header=BB3_37 Depth=1
	callq	_ZdlPv
.LBB3_120:                              #   in Loop: Header=BB3_37 Depth=1
	incq	%r13
	addq	$96, 304(%rsp)                  # 8-byte Folded Spill
	cmpq	$12, %r13
	movl	$3518437209, %edx               # imm = 0xD1B71759
	jne	.LBB3_37
# %bb.41:
	cmpl	$9, 144(%rsp)                   # 4-byte Folded Reload
	jne	.LBB3_43
# %bb.42:
	cmpl	$3, 148(%rsp)                   # 4-byte Folded Reload
	jne	.LBB3_43
# %bb.125:
	leaq	152(%rsp), %rbx
	leaq	168(%rsp), %r12
	movq	%r12, (%rbx)
	movl	$.L.str.35, %esi
	movl	$.L.str.35+11, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	40(%rsp), %r14
	leaq	232(%rsp), %rsi
	movq	%r14, %rdi
	movq	%rbx, %rdx
	movl	$205, %ecx
	movl	$192, %r8d
	callq	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
	vmovups	(%r14), %ymm0
	vmovups	28(%r14), %ymm1
	movq	136(%rsp), %r13                 # 8-byte Reload
	vmovups	%ymm1, 7332(%r13)
	vmovups	%ymm0, 7304(%r13)
	movq	(%rbx), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_127
# %bb.126:
	vzeroupper
	callq	_ZdlPv
.LBB3_127:
	movq	328(%rsp), %rax
	leaq	63(%rax), %rcx
	andq	$-64, %rcx
	movq	%rcx, 16(%r13)
	addq	$4096, %rax                     # imm = 0x1000
	movq	%rax, 328(%rsp)
	leaq	40(%rsp), %rbx
	movq	%r15, (%rbx)
	movl	$.L.str.36, %esi
	movl	$.L.str.36+18, %edx
	movq	%rbx, %rdi
	vzeroupper
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	movabsq	$824633721037, %rax             # imm = 0xC0000000CD
	leaq	152(%rsp), %rcx
	movq	%rax, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$2, %r8d
	movq	%rbx, %rsi
	xorl	%edx, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%r15, %rcx
	movq	%rax, %r15
	movq	(%rbx), %rdi
	cmpq	%rcx, %rdi
	je	.LBB3_129
# %bb.128:
	callq	_ZdlPv
.LBB3_129:
	leaq	40(%rsp), %rbx
	leaq	56(%rsp), %r14
	movq	%r14, (%rbx)
	movl	$.L.str.37, %esi
	movl	$.L.str.37+22, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	152(%rsp), %rcx
	movl	$205, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$1, %r8d
	movq	%rbx, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r12
	movq	(%rbx), %rdi
	cmpq	%r14, %rdi
	je	.LBB3_131
# %bb.130:
	callq	_ZdlPv
.LBB3_131:
	movl	$820, %edi                      # imm = 0x334
	callq	_Znwm
	movq	%rax, %rbx
	xorl	%r14d, %r14d
	movl	$820, %edx                      # imm = 0x334
	movq	%rax, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movq	32(%r12), %rax
.LBB3_132:                              # =>This Inner Loop Header: Depth=1
	movzwl	(%rax,%r14,2), %ecx
	shll	$16, %ecx
	movl	%ecx, (%rbx,%r14,4)
	incq	%r14
	cmpq	$205, %r14
	jne	.LBB3_132
# %bb.133:
	movq	200(%rsp), %rcx
	movq	208(%rsp), %rdx
	movq	(%rcx), %rax
	addq	$63, %rax
	andq	$-64, %rax
	movq	(%rdx), %r14
	leaq	157440(%rax), %rsi
	movq	%rsi, (%rcx)
	leaq	161536(%rax), %rcx
	cmpq	8(%rdx), %rcx
	ja	.LBB3_142
# %bb.134:
	addq	%rax, %r14
	movq	32(%r15), %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf
	movq	%r14, 7584(%r13)
	movq	%rbx, %rdi
	callq	_ZdlPv
	leaq	40(%rsp), %r14
	leaq	56(%rsp), %r15
	movq	%r15, (%r14)
	movl	$.L.str.38, %esi
	movl	$.L.str.38+13, %edx
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	152(%rsp), %rcx
	movl	$32, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$1, %r8d
	movq	%r14, %rsi
	movl	$2, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	(%r14), %rdi
	cmpq	%r15, %rdi
	je	.LBB3_136
# %bb.135:
	callq	_ZdlPv
.LBB3_136:
	movq	32(%rbx), %rax
	vmovups	(%rax), %ymm0
	vmovups	32(%rax), %ymm1
	vmovups	64(%rax), %ymm2
	vmovups	96(%rax), %ymm3
	vmovups	%ymm3, 7736(%r13)
	vmovups	%ymm2, 7704(%r13)
	vmovups	%ymm1, 7672(%r13)
	vmovups	%ymm0, 7640(%r13)
	leaq	40(%rsp), %r14
	movq	%r15, (%r14)
	movl	$.L.str.39, %esi
	movl	$.L.str.39+8, %edx
	movq	%r14, %rdi
	vzeroupper
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	movq	%r15, %r12
	movabsq	$137439084544, %r15             # imm = 0x2000020000
	leaq	152(%rsp), %rcx
	movq	%r15, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$2, %r8d
	movq	%r14, %rsi
	movl	$2, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbx
	movq	(%r14), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_138
# %bb.137:
	callq	_ZdlPv
.LBB3_138:
	leaq	40(%rsp), %r14
	leaq	56(%rsp), %r12
	movq	%r12, (%r14)
	movl	$.L.str.40, %esi
	movl	$.L.str.40+8, %edx
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	leaq	152(%rsp), %rcx
	movq	%r15, (%rcx)
	leaq	248(%rsp), %rdi
	movl	$2, %r8d
	movq	%r14, %rsi
	movl	$2, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r15
	movq	(%r14), %rdi
	cmpq	%r12, %rdi
	je	.LBB3_140
# %bb.139:
	callq	_ZdlPv
.LBB3_140:
	leaq	7592(%r13), %rdi
	movq	32(%rbx), %rsi
	movl	$16777216, %ebx                 # imm = 0x1000000
	leaq	(%rsi,%rbx), %rdx
	callq	_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag
	addq	$7616, %r13                     # imm = 0x1DC0
	movq	32(%r15), %rsi
	addq	%rsi, %rbx
	movq	%r13, %rdi
	movq	%rbx, %rdx
	callq	_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag
	leaq	248(%rsp), %rdi
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev
	addq	$408, %rsp                      # imm = 0x198
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB3_142:
	movl	$.L.str.47, %edi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB3_17:
	movl	$.L.str.4, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB3_16:
	movl	$.L.str.6, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB3_141:
	movl	$.L.str.45, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB3_43:
	movl	$.L.str.34, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end3:
	.size	_ZN3fx23opt8OptModel4loadEPKc, .Lfunc_end3-_ZN3fx23opt8OptModel4loadEPKc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi
.LCPI4_0:
	.long	0x3b800000                      # float 0.00390625
	.section	".text._ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi","ax",@progbits
	.p2align	1, 0x90
	.type	_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi,@function
_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi: # @"_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi"
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$88, %rsp
	movl	%ecx, %r15d
	movq	%rdx, %r12
	movq	%rdi, 32(%rsp)                  # 8-byte Spill
	movq	%rsi, 24(%rsp)                  # 8-byte Spill
	movq	(%rsi), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	(%rdx), %rbx
	movq	8(%rdx), %rbp
	leaq	72(%rsp), %r14
	movq	%r14, -16(%r14)
	movq	$0, -8(%r14)
	movb	$0, (%r14)
	leaq	9(%rbp), %rsi
	leaq	56(%rsp), %r13
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r13, %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.42, %esi
	movl	$9, %edx
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	%r15d, 12(%rsp)                 # 4-byte Spill
	movl	%r15d, (%rcx)
	movl	$192, 4(%rcx)
	movl	$2, %r8d
	movq	16(%rsp), %rdi                  # 8-byte Reload
	movq	%r13, %rsi
	xorl	%edx, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	(%r13), %rdi
	cmpq	%r14, %rdi
	je	.LBB4_2
# %bb.1:
	callq	_ZdlPv
.LBB4_2:
	movq	24(%rsp), %r15                  # 8-byte Reload
	movq	(%r15), %r13
	movq	(%r12), %rbx
	movq	8(%r12), %rbp
	leaq	56(%rsp), %r14
	leaq	72(%rsp), %rax
	movq	%rax, (%r14)
	movq	$0, 8(%r14)
	movb	$0, 16(%r14)
	leaq	13(%rbp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r14, %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.43, %esi
	movl	$13, %edx
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	12(%rsp), %eax                  # 4-byte Reload
	movl	%eax, (%rcx)
	movl	$1, %r8d
	movq	%r13, %rdi
	movq	%r14, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	movq	(%r14), %rdi
	leaq	72(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB4_4
# %bb.3:
	callq	_ZdlPv
.LBB4_4:
	movq	(%r15), %r14
	movq	(%r12), %rbx
	movq	8(%r12), %rbp
	leaq	56(%rsp), %r12
	leaq	72(%rsp), %r13
	movq	%r13, (%r12)
	movq	$0, 8(%r12)
	movb	$0, 16(%r12)
	leaq	26(%rbp), %rsi
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.44, %esi
	movl	$26, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	$1, (%rcx)
	movl	$1, %r8d
	movq	%r14, %rdi
	movq	%r12, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r14
	movq	(%r12), %rdi
	cmpq	%r13, %rdi
	je	.LBB4_6
# %bb.5:
	callq	_ZdlPv
.LBB4_6:
	movq	32(%r14), %rax
	movzwl	(%rax), %eax
	shll	$16, %eax
	vmovd	%eax, %xmm0
	vmulss	.LCPI4_0(%rip), %xmm0, %xmm0
	movq	32(%rsp), %rax                  # 8-byte Reload
	vmovss	%xmm0, 24(%rax)
	movq	8(%r15), %rax
	movl	12(%rsp), %r9d                  # 4-byte Reload
	movl	%r9d, %ebx
	movq	(%rax), %rdx
	movq	8(%rax), %rcx
	movq	(%rdx), %r10
	addq	$63, %r10
	andq	$-64, %r10
	movq	(%rcx), %rax
	leaq	(%r10,%rbx,4), %r15
	movq	%r15, (%rdx)
	leaq	(%r10,%rbx,4), %rsi
	addq	$4096, %rsi                     # imm = 0x1000
	cmpq	8(%rcx), %rsi
	ja	.LBB4_22
# %bb.7:
	addq	%rax, %r10
	testl	%r9d, %r9d
	jle	.LBB4_10
# %bb.8:
	movq	48(%rsp), %rsi                  # 8-byte Reload
	movq	32(%rsi), %rsi
	xorl	%edi, %edi
.LBB4_9:                                # =>This Inner Loop Header: Depth=1
	movzwl	(%rsi,%rdi,2), %r8d
	shll	$16, %r8d
	vmovd	%r8d, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	vmovss	%xmm1, (%r10,%rdi,4)
	incq	%rdi
	cmpq	%rdi, %rbx
	jne	.LBB4_9
.LBB4_10:
	movq	16(%rsp), %rsi                  # 8-byte Reload
	movq	32(%rsi), %r14
	testl	%r9d, %r9d
	je	.LBB4_14
# %bb.11:
	movq	%rbx, %rsi
	shlq	$6, %rsi
	leaq	(%rsi,%rsi,2), %rsi
	cmpq	$1, %rsi
	adcq	$0, %rsi
	xorl	%edi, %edi
.LBB4_12:                               # =>This Inner Loop Header: Depth=1
	movb	(%r14,%rdi), %r8b
	addb	$-8, %r8b
	cmpb	$-16, %r8b
	jbe	.LBB4_23
# %bb.13:                               #   in Loop: Header=BB4_12 Depth=1
	incq	%rdi
	cmpq	%rdi, %rsi
	jne	.LBB4_12
.LBB4_14:
	movq	%r10, 24(%rsp)                  # 8-byte Spill
	leaq	(,%rbx,4), %rsi
	addq	$63, %r15
	andq	$-64, %r15
	leaq	(%r15,%rsi), %r13
	movq	%r13, (%rdx)
	addq	%r15, %rsi
	addq	$4096, %rsi                     # imm = 0x1000
	cmpq	8(%rcx), %rsi
	ja	.LBB4_22
# %bb.15:
	leaq	(%rbx,%rbx,2), %rsi
	shlq	$5, %rsi
	addq	$63, %r13
	andq	$-64, %r13
	leaq	(%rsi,%r13), %rdi
	movq	%rdi, (%rdx)
	leaq	(%rsi,%r13), %rdx
	addq	$4096, %rdx                     # imm = 0x1000
	cmpq	8(%rcx), %rdx
	ja	.LBB4_22
# %bb.16:
	addq	%rax, %r15
	addq	%rax, %r13
	testl	%r9d, %r9d
	jle	.LBB4_21
# %bb.17:
	xorl	%ebp, %ebp
	movq	%r14, %r12
.LBB4_18:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB4_19 Depth 2
	movq	%rbp, %rax
	shlq	$6, %rax
	leaq	(%rax,%rax,2), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	movq	$-192, %rax
.LBB4_19:                               #   Parent Loop BB4_18 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovsxbd	192(%r12,%rax), %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	addq	$8, %rax
	jne	.LBB4_19
# %bb.20:                               #   in Loop: Header=BB4_18 Depth=1
	vextracti128	$1, %ymm0, %xmm1
	vphaddd	%xmm0, %xmm1, %xmm0
	vphaddd	%xmm0, %xmm0, %xmm0
	vphaddd	%xmm0, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	shll	$7, %eax
	movl	%eax, (%r15,%rbp,4)
	addq	%r14, %rdi
	leaq	(,%rbp,2), %rdx
	addq	%rbp, %rdx
	shlq	$5, %rdx
	addq	%r13, %rdx
	movl	$192, %esi
	vzeroupper
	callq	_ZN3fx23opt14pack16_nibblesEPKaiPh
	incq	%rbp
	addq	$192, %r12
	cmpq	%rbx, %rbp
	jne	.LBB4_18
.LBB4_21:
	movq	32(%rsp), %rax                  # 8-byte Reload
	movq	%r13, (%rax)
	movq	%r15, 8(%rax)
	movq	24(%rsp), %rcx                  # 8-byte Reload
	movq	%rcx, 16(%rax)
	addq	$88, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB4_23:
	movl	$.L.str.46, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB4_22:
	movl	$.L.str.47, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end4:
	.size	_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi, .Lfunc_end4-_ZZN3fx23opt8OptModel4loadEPKcENK3$_5clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEi
                                        # -- End function
	.section	".text._ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib","ax",@progbits
	.p2align	1, 0x90                         # -- Begin function _ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
	.type	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib,@function
_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib: # @"_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib"
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$136, %rsp
	movl	%r8d, %r14d
	movl	%ecx, %r12d
	movq	%rdx, %r13
	movq	%rdi, 72(%rsp)                  # 8-byte Spill
	movq	%rsi, 24(%rsp)                  # 8-byte Spill
	movq	(%rsi), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	(%rdx), %rbx
	movq	8(%rdx), %r15
	leaq	96(%rsp), %rax
	movq	%rax, -16(%rax)
	movq	$0, -8(%rax)
	movb	$0, (%rax)
	leaq	9(%r15), %rsi
	leaq	80(%rsp), %rbp
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbp, %rdi
	movq	%rbx, %rsi
	movq	%r15, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.42, %esi
	movl	$9, %edx
	movq	%rbp, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	%r12d, 12(%rsp)                 # 4-byte Spill
	movl	%r12d, (%rcx)
	movl	%r14d, 36(%rsp)                 # 4-byte Spill
	movl	%r14d, 4(%rcx)
	leaq	96(%rsp), %r14
	movl	$2, %r8d
	movq	16(%rsp), %rdi                  # 8-byte Reload
	movq	%rbp, %rsi
	xorl	%edx, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	movq	(%rbp), %rdi
	cmpq	%r14, %rdi
	je	.LBB5_2
# %bb.1:
	callq	_ZdlPv
.LBB5_2:
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	(%rax), %rbp
	movq	(%r13), %rbx
	movq	8(%r13), %r15
	leaq	80(%rsp), %r12
	movq	%r14, (%r12)
	movq	$0, 8(%r12)
	movb	$0, 16(%r12)
	leaq	13(%r15), %rsi
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movq	%r15, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.43, %esi
	movl	$13, %edx
	movq	%r12, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	12(%rsp), %eax                  # 4-byte Reload
	movl	%eax, (%rcx)
	movl	$1, %r8d
	movq	%rbp, %rdi
	movq	%r12, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %rbp
	movq	(%r12), %rdi
	cmpq	%r14, %rdi
	je	.LBB5_4
# %bb.3:
	callq	_ZdlPv
.LBB5_4:
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	(%rax), %r12
	movq	(%r13), %rbx
	movq	8(%r13), %r15
	leaq	80(%rsp), %r13
	movq	%r14, (%r13)
	movq	$0, 8(%r13)
	movb	$0, 16(%r13)
	leaq	26(%r15), %rsi
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r13, %rdi
	movq	%rbx, %rsi
	movq	%r15, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.44, %esi
	movl	$26, %edx
	movq	%r13, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	$1, (%rcx)
	movl	$1, %r8d
	movq	%r12, %rdi
	movq	%r13, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r12
	movq	(%r13), %rdi
	cmpq	%r14, %rdi
	je	.LBB5_6
# %bb.5:
	callq	_ZdlPv
.LBB5_6:
	movq	32(%r12), %rax
	movzwl	(%rax), %eax
	shll	$16, %eax
	vmovd	%eax, %xmm1
	movq	72(%rsp), %r14                  # 8-byte Reload
	movl	%eax, 56(%r14)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovd	%xmm1, 16(%rsp)                 # 4-byte Folded Spill
	vucomiss	%xmm0, %xmm1
	movl	12(%rsp), %r15d                 # 4-byte Reload
	jbe	.LBB5_14
# %bb.7:
	movl	%r15d, %r12d
	leaq	40(%rsp), %rdi
	leaq	80(%rsp), %rdx
	movq	%r12, %rsi
	callq	_ZNSt6vectorIfSaIfEEC2EmRKS0_
	testl	%r15d, %r15d
	vmovss	16(%rsp), %xmm1                 # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	jle	.LBB5_10
# %bb.8:
	movq	32(%rbp), %rax
	movq	40(%rsp), %rcx
	xorl	%edx, %edx
.LBB5_9:                                # =>This Inner Loop Header: Depth=1
	movzwl	(%rax,%rdx,2), %esi
	shll	$16, %esi
	vmovd	%esi, %xmm0
	vmulss	%xmm0, %xmm1, %xmm0
	vmovss	%xmm0, (%rcx,%rdx,4)
	incq	%rdx
	cmpq	%rdx, %r12
	jne	.LBB5_9
.LBB5_10:
	movq	24(%rsp), %rax                  # 8-byte Reload
	movq	8(%rax), %rbx
	movl	%r15d, %edi
	movl	36(%rsp), %ebp                  # 4-byte Reload
	movl	%ebp, %esi
	callq	_ZN3fx23opt12qdense_bytesEii
	movq	(%rbx), %rdx
	movq	8(%rbx), %rdi
	movq	(%rdx), %rcx
	addq	$63, %rcx
	andq	$-64, %rcx
	movq	(%rdi), %rsi
	leaq	(%rcx,%rax), %r8
	movq	%r8, (%rdx)
	addq	%rcx, %rax
	addq	$4096, %rax                     # imm = 0x1000
	cmpq	8(%rdi), %rax
	ja	.LBB5_15
# %bb.11:
	addq	%rcx, %rsi
	movq	64(%rsp), %rax                  # 8-byte Reload
	movq	32(%rax), %rdx
	movq	40(%rsp), %rcx
	movl	$1, (%rsp)
	leaq	80(%rsp), %rbx
	movq	%rbx, %rdi
	movl	%r15d, %r8d
	movl	%ebp, %r9d
	callq	_ZN3fx23opt12qdense_buildEPhPKaPKfiib
	vmovups	(%rbx), %ymm0
	vmovups	17(%rbx), %ymm1
	vmovups	%ymm1, 17(%r14)
	vmovups	%ymm0, (%r14)
	movq	40(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB5_13
# %bb.12:
	vzeroupper
	callq	_ZdlPv
.LBB5_13:
	movq	%r14, %rax
	addq	$136, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.LBB5_14:
	movl	$.L.str.45, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB5_15:
	movl	$.L.str.47, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end5:
	.size	_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib, .Lfunc_end5-_ZZN3fx23opt8OptModel4loadEPKcENK3$_1clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEiib
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi
.LCPI6_0:
	.long	0x3b800000                      # float 0.00390625
	.section	".text._ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi","ax",@progbits
	.p2align	1, 0x90
	.type	_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi,@function
_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi: # @"_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi"
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$264, %rsp                      # imm = 0x108
	movq	%r9, 48(%rsp)                   # 8-byte Spill
	movq	%r8, 32(%rsp)                   # 8-byte Spill
	movl	%ecx, 4(%rsp)                   # 4-byte Spill
	movl	%edx, %r12d
	movq	%rsi, %rbx
	movq	%rdi, 8(%rsp)                   # 8-byte Spill
	movq	(%rdi), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	(%rsi), %r13
	movq	8(%rsi), %rbp
	leaq	80(%rsp), %r14
	movq	%r14, -16(%r14)
	movq	$0, -8(%r14)
	movb	$0, (%r14)
	leaq	9(%rbp), %rsi
	leaq	64(%rsp), %r15
	movq	%r15, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r15, %rdi
	movq	%r13, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.42, %esi
	movl	$9, %edx
	movq	%r15, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	$192, (%rcx)
	movl	%r12d, 28(%rsp)                 # 4-byte Spill
	movl	%r12d, 4(%rcx)
	movl	$2, %r8d
	movq	16(%rsp), %rdi                  # 8-byte Reload
	movq	%r15, %rsi
	xorl	%edx, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	(%r15), %rdi
	cmpq	%r14, %rdi
	je	.LBB6_2
# %bb.1:
	callq	_ZdlPv
.LBB6_2:
	movq	8(%rsp), %r12                   # 8-byte Reload
	movq	(%r12), %r14
	movq	(%rbx), %rbp
	movq	8(%rbx), %r13
	leaq	64(%rsp), %r15
	leaq	80(%rsp), %rax
	movq	%rax, (%r15)
	movq	$0, 8(%r15)
	movb	$0, 16(%r15)
	leaq	13(%r13), %rsi
	movq	%r15, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%r15, %rdi
	movq	%rbp, %rsi
	movq	%r13, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.43, %esi
	movl	$13, %edx
	movq	%r15, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	$192, (%rcx)
	movl	$1, %r8d
	movq	%r14, %rdi
	movq	%r15, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	movq	(%r15), %rdi
	leaq	80(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB6_4
# %bb.3:
	callq	_ZdlPv
.LBB6_4:
	movq	320(%rsp), %r14
	movq	(%r12), %r15
	movq	(%rbx), %r13
	movq	8(%rbx), %rbp
	leaq	64(%rsp), %rbx
	leaq	80(%rsp), %rax
	movq	%rax, (%rbx)
	movq	$0, 8(%rbx)
	movb	$0, 16(%rbx)
	leaq	26(%rbp), %rsi
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE7reserveEm
	movq	%rbx, %rdi
	movq	%r13, %rsi
	movq	%rbp, %rdx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	movl	$.L.str.44, %esi
	movl	$26, %edx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE6appendEPKcm
	leaq	40(%rsp), %rcx
	movl	$1, (%rcx)
	movl	$1, %r8d
	movq	%r15, %rdi
	movq	%rbx, %rsi
	movl	$1, %edx
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	movq	%rax, %r15
	movq	(%rbx), %rdi
	leaq	80(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB6_6
# %bb.5:
	callq	_ZdlPv
.LBB6_6:
	movq	32(%r15), %rax
	movzwl	(%rax), %eax
	shll	$16, %eax
	vmovd	%eax, %xmm0
	vmulss	.LCPI6_0(%rip), %xmm0, %xmm0
	vmovss	%xmm0, (%r14)
	movq	8(%r12), %rax
	movq	(%rax), %rcx
	movq	8(%rax), %rax
	movq	(%rcx), %r9
	addq	$63, %r9
	andq	$-64, %r9
	movq	(%rax), %r12
	leaq	768(%r9), %rdx
	movq	%rdx, (%rcx)
	leaq	4864(%r9), %rdx
	cmpq	8(%rax), %rdx
	ja	.LBB6_31
# %bb.7:
	leaq	(%r12,%r9), %r15
	movq	56(%rsp), %rdx                  # 8-byte Reload
	movq	32(%rdx), %rdx
	xorl	%esi, %esi
	movl	28(%rsp), %r8d                  # 4-byte Reload
.LBB6_8:                                # =>This Inner Loop Header: Depth=1
	movzwl	(%rdx,%rsi,2), %edi
	shll	$16, %edi
	vmovd	%edi, %xmm0
	vmulss	(%r14), %xmm0, %xmm0
	vmovss	%xmm0, (%r15,%rsi,4)
	incq	%rsi
	cmpq	$192, %rsi
	jne	.LBB6_8
# %bb.9:
	movq	16(%rsp), %rdx                  # 8-byte Reload
	movq	32(%rdx), %rbx
	movl	%r8d, %ebp
	testl	%r8d, %r8d
	je	.LBB6_22
# %bb.10:
	movq	%rbp, %rdx
	shlq	$6, %rdx
	leaq	(%rdx,%rdx,2), %rdx
	cmpq	$1, %rdx
	adcq	$0, %rdx
	xorl	%esi, %esi
.LBB6_11:                               # =>This Inner Loop Header: Depth=1
	movb	(%rbx,%rsi), %dil
	addb	$-8, %dil
	cmpb	$-16, %dil
	jbe	.LBB6_32
# %bb.12:                               #   in Loop: Header=BB6_11 Depth=1
	incq	%rsi
	cmpq	%rsi, %rdx
	jne	.LBB6_11
# %bb.13:
	cmpb	$0, 4(%rsp)                     # 1-byte Folded Reload
	je	.LBB6_23
# %bb.14:
	cmpl	$192, %r8d
	jne	.LBB6_33
# %bb.15:
	addq	$831, %r9                       # imm = 0x33F
	andq	$-64, %r9
	leaq	768(%r9), %rdx
	movq	%rdx, (%rcx)
	leaq	4864(%r9), %rdx
	cmpq	8(%rax), %rdx
	ja	.LBB6_31
# %bb.16:
	leaq	831(%r9), %rbp
	andq	$-64, %rbp
	leaq	18432(%rbp), %rdx
	movq	%rdx, (%rcx)
	leaq	22528(%rbp), %rcx
	cmpq	8(%rax), %rcx
	ja	.LBB6_31
# %bb.17:
	addq	%r12, %r9
	movq	%r9, 8(%rsp)                    # 8-byte Spill
	addq	%r12, %rbp
	xorl	%r12d, %r12d
	movl	$192, %r13d
	movq	%rbx, %r14
.LBB6_18:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_19 Depth 2
	movq	%r12, %rax
	shlq	$6, %rax
	leaq	(%rax,%rax,2), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	movq	$-192, %rax
.LBB6_19:                               #   Parent Loop BB6_18 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpmovsxbd	192(%r14,%rax), %ymm1
	vpaddd	%ymm1, %ymm0, %ymm0
	addq	$8, %rax
	jne	.LBB6_19
# %bb.20:                               #   in Loop: Header=BB6_18 Depth=1
	vextracti128	$1, %ymm0, %xmm1
	vphaddd	%xmm0, %xmm1, %xmm0
	vphaddd	%xmm0, %xmm0, %xmm0
	vphaddd	%xmm0, %xmm0, %xmm0
	vmovd	%xmm0, %eax
	shll	$7, %eax
	movq	8(%rsp), %rcx                   # 8-byte Reload
	movl	%eax, (%rcx,%r12,4)
	addq	%rbx, %rdi
	leaq	(%r12,%r12,2), %rdx
	shlq	$5, %rdx
	addq	%rbp, %rdx
	movl	$192, %esi
	vzeroupper
	callq	_ZN3fx23opt14pack16_nibblesEPKaiPh
	incq	%r12
	addq	%r13, %r14
	cmpq	%r13, %r12
	jne	.LBB6_18
# %bb.21:
	movq	32(%rsp), %rax                  # 8-byte Reload
	movq	%rbp, (%rax)
	movq	8(%rsp), %rax                   # 8-byte Reload
	movq	328(%rsp), %rcx
	movq	%rax, (%rcx)
	jmp	.LBB6_30
.LBB6_22:
	cmpb	$0, 4(%rsp)                     # 1-byte Folded Reload
	jne	.LBB6_33
.LBB6_23:
	leaq	(,%rbp,2), %rdx
	addq	%rbp, %rdx
	shlq	$5, %rdx
	addq	$831, %r9                       # imm = 0x33F
	andq	$-64, %r9
	leaq	(%r9,%rdx), %rsi
	movq	%rsi, (%rcx)
	leaq	(%r9,%rdx), %rcx
	addq	$4096, %rcx                     # imm = 0x1000
	cmpq	8(%rax), %rcx
	ja	.LBB6_31
# %bb.24:
	addq	%r9, %r12
	testl	%r8d, %r8d
	jle	.LBB6_29
# %bb.25:
	xorl	%r13d, %r13d
	leaq	64(%rsp), %r14
.LBB6_26:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_27 Depth 2
	movq	%rbx, %rax
	xorl	%ecx, %ecx
.LBB6_27:                               #   Parent Loop BB6_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movb	(%rax), %dl
	movb	%dl, 64(%rsp,%rcx)
	incq	%rcx
	addq	%rbp, %rax
	cmpq	$192, %rcx
	jne	.LBB6_27
# %bb.28:                               #   in Loop: Header=BB6_26 Depth=1
	leaq	(,%r13,2), %rdx
	addq	%r13, %rdx
	shlq	$5, %rdx
	addq	%r12, %rdx
	movq	%r14, %rdi
	movl	$192, %esi
	callq	_ZN3fx23opt14pack16_nibblesEPKaiPh
	incq	%r13
	incq	%rbx
	cmpq	%rbp, %r13
	jne	.LBB6_26
.LBB6_29:
	movq	32(%rsp), %rax                  # 8-byte Reload
	movq	%r12, (%rax)
.LBB6_30:
	movq	48(%rsp), %rax                  # 8-byte Reload
	movq	%r15, (%rax)
	addq	$264, %rsp                      # imm = 0x108
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB6_32:
	movl	$.L.str.46, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB6_31:
	movl	$.L.str.47, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.LBB6_33:
	movl	$.L.str.48, %edi
	callq	_ZN3fx23opt12_GLOBAL__N_13dieEPKc
.Lfunc_end6:
	.size	_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi, .Lfunc_end6-_ZZN3fx23opt8OptModel4loadEPKcENK3$_4clERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEibPPKhPPKfPfPPKi
                                        # -- End function
	.section	.text._ZNSt6vectorIfSaIfEEC2EmRKS0_,"axG",@progbits,_ZNSt6vectorIfSaIfEEC2EmRKS0_,comdat
	.weak	_ZNSt6vectorIfSaIfEEC2EmRKS0_   # -- Begin function _ZNSt6vectorIfSaIfEEC2EmRKS0_
	.p2align	1, 0x90
	.type	_ZNSt6vectorIfSaIfEEC2EmRKS0_,@function
_ZNSt6vectorIfSaIfEEC2EmRKS0_:          # @_ZNSt6vectorIfSaIfEEC2EmRKS0_
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	movq	%rsi, %rax
	shrq	$61, %rax
	jne	.LBB7_7
# %bb.1:
	movq	%rsi, %r14
	movq	%rdi, %rbx
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, (%rdi)
	movq	$0, 16(%rdi)
	testq	%rsi, %rsi
	je	.LBB7_2
# %bb.3:
	movq	%rbx, %rdi
	movq	%r14, %rsi
	xorl	%edx, %edx
	callq	_ZNSt15__new_allocatorIfE8allocateEmPKv
	movq	%rax, (%rbx)
	leaq	(%rax,%r14,4), %r15
	movq	%r15, 16(%rbx)
	movl	$0, (%rax)
	addq	$4, %rax
	cmpq	$1, %r14
	jne	.LBB7_5
# %bb.4:
	movq	%rax, %r15
	jmp	.LBB7_6
.LBB7_2:
	vmovups	%xmm0, (%rbx)
	movq	$0, 16(%rbx)
	xorl	%r15d, %r15d
	jmp	.LBB7_6
.LBB7_5:
	leaq	-4(,%r14,4), %rdx
	movq	%rax, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
.LBB7_6:
	movq	%r15, 8(%rbx)
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.LBB7_7:
	movl	$.L.str.51, %edi
	callq	_ZSt20__throw_length_errorPKc
.Lfunc_end7:
	.size	_ZNSt6vectorIfSaIfEEC2EmRKS0_, .Lfunc_end7-_ZNSt6vectorIfSaIfEEC2EmRKS0_
                                        # -- End function
	.section	.text._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_,"axG",@progbits,_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_,comdat
	.weak	_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_ # -- Begin function _ZNSt8__detail18__to_chars_10_implIjEEvPcjT_
	.type	_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_,@function
_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_: # @_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	cmpl	$100, %edx
	jb	.LBB8_1
# %bb.2:
	decl	%esi
.LBB8_3:                                # =>This Inner Loop Header: Depth=1
	movl	%edx, %eax
	imulq	$1374389535, %rax, %rax         # imm = 0x51EB851F
	shrq	$37, %rax
	imull	$100, %eax, %ecx
	movl	%edx, %r8d
	subl	%ecx, %r8d
	movb	.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits+1(%r8,%r8), %cl
	movl	%esi, %r9d
	movb	%cl, (%rdi,%r9)
	movb	.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits(%r8,%r8), %cl
	leal	-1(%rsi), %r8d
	movb	%cl, (%rdi,%r8)
	addl	$-2, %esi
	cmpl	$9999, %edx                     # imm = 0x270F
	movl	%eax, %edx
	ja	.LBB8_3
	jmp	.LBB8_4
.LBB8_1:
	movl	%edx, %eax
.LBB8_4:
	cmpl	$10, %eax
	jb	.LBB8_6
# %bb.5:
	movl	%eax, %eax
	leaq	(%rax,%rax), %rcx
	movl	%ecx, %ecx
	movb	.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits+1(%rcx), %cl
	movb	%cl, 1(%rdi)
	movb	.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits(%rax,%rax), %al
	jmp	.LBB8_7
.LBB8_6:
	addb	$48, %al
.LBB8_7:
	movb	%al, (%rdi)
	retq
.Lfunc_end8:
	.size	_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_, .Lfunc_end8-_ZNSt8__detail18__to_chars_10_implIjEEvPcjT_
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev
	.p2align	1, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev
# %bb.0:
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	movq	%rdi, %rbx
	movq	16(%rdi), %rsi
	testq	%rsi, %rsi
	je	.LBB9_2
.LBB9_1:                                # =>This Inner Loop Header: Depth=1
	movq	(%rsi), %r14
	movq	%rbx, %rdi
	callq	_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_
	movq	%r14, %rsi
	testq	%r14, %r14
	jne	.LBB9_1
.LBB9_2:
	movq	(%rbx), %rdi
	addq	$48, %rbx
	addq	$8, %rsp
	cmpq	%rdi, %rbx
	je	.LBB9_3
# %bb.4:
	popq	%rbx
	popq	%r14
	jmp	_ZdlPv                          # TAILCALL
.LBB9_3:
	popq	%rbx
	popq	%r14
	retq
.Lfunc_end9:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev, .Lfunc_end9-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEED2Ev
                                        # -- End function
	.section	.text._ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_,"axG",@progbits,_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_,comdat
	.weak	_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_ # -- Begin function _ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_
	.p2align	1, 0x90
	.type	_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_,@function
_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_: # @_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_
# %bb.0:
	pushq	%rbx
	movq	%rsi, %rbx
	movq	72(%rsi), %rdi
	testq	%rdi, %rdi
	je	.LBB10_2
# %bb.1:
	callq	_ZdlPv
.LBB10_2:
	movq	48(%rbx), %rdi
	testq	%rdi, %rdi
	je	.LBB10_4
# %bb.3:
	callq	_ZdlPv
.LBB10_4:
	movq	8(%rbx), %rdi
	leaq	24(%rbx), %rax
	cmpq	%rax, %rdi
	je	.LBB10_6
# %bb.5:
	callq	_ZdlPv
.LBB10_6:
	movq	%rbx, %rdi
	popq	%rbx
	jmp	_ZdlPv                          # TAILCALL
.Lfunc_end10:
	.size	_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_, .Lfunc_end10-_ZNSt8__detail16_Hashtable_allocISaINS_10_Hash_nodeISt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEELb1EEEEE18_M_deallocate_nodeEPSD_
                                        # -- End function
	.section	.text._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag,"axG",@progbits,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag,comdat
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag # -- Begin function _ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
	.p2align	1, 0x90
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag,@function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag: # @_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%rdx, %r14
	movq	%rsi, %r15
	movq	%rdi, %rbx
	subq	%rsi, %r14
	movq	%r14, (%rsp)
	cmpq	$15, %r14
	jbe	.LBB11_1
# %bb.2:
	movq	%rsp, %r12
	movq	%rbx, %rdi
	movq	%r12, %rsi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
	movq	%rax, (%rbx)
	movq	(%r12), %rcx
	movq	%rcx, 16(%rbx)
	jmp	.LBB11_3
.LBB11_1:
	movq	(%rbx), %rax
.LBB11_3:
	testq	%r14, %r14
	je	.LBB11_7
# %bb.4:
	cmpq	$1, %r14
	jne	.LBB11_6
# %bb.5:
	movb	(%r15), %cl
	movb	%cl, (%rax)
	jmp	.LBB11_7
.LBB11_6:
	movq	%rax, %rdi
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	memcpy@PLT
.LBB11_7:
	movq	(%rsp), %rax
	movq	%rax, 8(%rbx)
	movq	(%rbx), %rcx
	movb	$0, (%rcx,%rax)
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
.Lfunc_end11:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag, .Lfunc_end11-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructIPKcEEvT_S8_St20forward_iterator_tag
                                        # -- End function
	.section	.text._ZNSt15__new_allocatorIfE8allocateEmPKv,"axG",@progbits,_ZNSt15__new_allocatorIfE8allocateEmPKv,comdat
	.weak	_ZNSt15__new_allocatorIfE8allocateEmPKv # -- Begin function _ZNSt15__new_allocatorIfE8allocateEmPKv
	.p2align	1, 0x90
	.type	_ZNSt15__new_allocatorIfE8allocateEmPKv,@function
_ZNSt15__new_allocatorIfE8allocateEmPKv: # @_ZNSt15__new_allocatorIfE8allocateEmPKv
# %bb.0:
	pushq	%rax
	movq	%rsi, %rax
	shrq	$61, %rax
	jne	.LBB12_1
# %bb.3:
	shlq	$2, %rsi
	movq	%rsi, %rdi
	popq	%rax
	jmp	_Znwm                           # TAILCALL
.LBB12_1:
	shrq	$62, %rsi
	je	.LBB12_2
# %bb.4:
	callq	_ZSt28__throw_bad_array_new_lengthv
.LBB12_2:
	callq	_ZSt17__throw_bad_allocv
.Lfunc_end12:
	.size	_ZNSt15__new_allocatorIfE8allocateEmPKv, .Lfunc_end12-_ZNSt15__new_allocatorIfE8allocateEmPKv
                                        # -- End function
	.section	.text._ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag,"axG",@progbits,_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag,comdat
	.weak	_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag # -- Begin function _ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag
	.p2align	1, 0x90
	.type	_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag,@function
_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag: # @_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%rdx, %r14
	movq	%rsi, %r13
	movq	%rdi, %rbx
	movq	(%rdi), %r15
	movq	%rdx, %rbp
	subq	%rsi, %rbp
	movq	%rbp, %r12
	sarq	$2, %r12
	movq	16(%rdi), %rax
	subq	%r15, %rax
	shrq	$2, %rax
	cmpq	%rax, %r12
	jbe	.LBB13_7
# %bb.1:
	movabsq	$9223372036854775805, %rax      # imm = 0x7FFFFFFFFFFFFFFD
	cmpq	%rax, %rbp
	jae	.LBB13_22
# %bb.2:
	movq	%rbx, %rdi
	movq	%r12, %rsi
	xorl	%edx, %edx
	callq	_ZNSt15__new_allocatorIfE8allocateEmPKv
	movq	%rax, %r15
	cmpq	%r13, %r14
	je	.LBB13_4
# %bb.3:
	movq	%r15, %rdi
	movq	%r13, %rsi
	movq	%rbp, %rdx
	callq	memcpy@PLT
.LBB13_4:
	movq	(%rbx), %rdi
	testq	%rdi, %rdi
	je	.LBB13_6
# %bb.5:
	callq	_ZdlPv
.LBB13_6:
	movq	%r15, (%rbx)
	leaq	(%r15,%r12,4), %rax
	movq	%rax, 8(%rbx)
	movq	%rax, 16(%rbx)
	jmp	.LBB13_21
.LBB13_7:
	movq	8(%rbx), %rcx
	movq	%rcx, %rdx
	subq	%r15, %rdx
	movq	%rdx, %rax
	shrq	$2, %rax
	cmpq	%r12, %rax
	jae	.LBB13_8
# %bb.14:
	leaq	(,%rax,4), %r12
	addq	%r13, %r12
	cmpq	$5, %rdx
	jb	.LBB13_16
# %bb.15:
	movq	%r15, %rdi
	movq	%r13, %rsi
	callq	memmove@PLT
	movq	8(%rbx), %rcx
.LBB13_18:
	subq	%r12, %r14
	testq	%r14, %r14
	jle	.LBB13_20
# %bb.19:
	movq	%rcx, %r15
	movq	%rcx, %rdi
	movq	%r12, %rsi
	movq	%r14, %rdx
	callq	memcpy@PLT
	movq	%r15, %rcx
	addq	%r14, %rcx
.LBB13_20:
	movq	%rcx, 8(%rbx)
	jmp	.LBB13_21
.LBB13_8:
	cmpq	$5, %rbp
	jl	.LBB13_10
# %bb.9:
	movq	%r15, %rdi
	movq	%r13, %rsi
	movq	%rbp, %rdx
	callq	memmove@PLT
	addq	%rbp, %r15
	movq	8(%rbx), %rcx
.LBB13_12:
	cmpq	%r15, %rcx
	je	.LBB13_21
# %bb.13:
	movq	%r15, 8(%rbx)
.LBB13_21:
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB13_16:
	cmpq	$4, %rdx
	jne	.LBB13_18
# %bb.17:
	vmovss	(%r13), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, (%r15)
	jmp	.LBB13_18
.LBB13_10:
	cmpq	$4, %rbp
	jne	.LBB13_12
# %bb.11:
	vmovss	(%r13), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, (%r15)
	addq	$4, %r15
	jmp	.LBB13_12
.LBB13_22:
	movl	$.L.str.51, %edi
	callq	_ZSt20__throw_length_errorPKc
.Lfunc_end13:
	.size	_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag, .Lfunc_end13-_ZNSt6vectorIfSaIfEE13_M_assign_auxIPKfEEvT_S5_St20forward_iterator_tag
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"mmap failed"
	.size	.L.str, 12

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"rb"
	.size	.L.str.1, 3

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"FX2TFWC"
	.size	.L.str.2, 8

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"config.ints"
	.size	.L.str.3, 12

	.type	.L__const._ZN3fx23opt8OptModel4loadEPKc.want,@object # @__const._ZN3fx23opt8OptModel4loadEPKc.want
	.section	.rodata..L__const._ZN3fx23opt8OptModel4loadEPKc.want,"a",@progbits
	.p2align	4, 0x0
.L__const._ZN3fx23opt8OptModel4loadEPKc.want:
	.long	205                             # 0xcd
	.long	192                             # 0xc0
	.long	12                              # 0xc
	.long	64                              # 0x40
	.long	3                               # 0x3
	.long	768                             # 0x300
	.long	1024                            # 0x400
	.long	64                              # 0x40
	.long	3                               # 0x3
	.long	4                               # 0x4
	.long	10000                           # 0x2710
	.size	.L__const._ZN3fx23opt8OptModel4loadEPKc.want, 44

	.type	.L.str.4,@object                # @.str.4
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.4:
	.asciz	"config.ints mismatch"
	.size	.L.str.4, 21

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"config.kimi"
	.size	.L.str.5, 12

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"config.kimi mismatch"
	.size	.L.str.6, 21

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"query_projection"
	.size	.L.str.7, 17

	.type	.L.str.8,@object                # @.str.8
.L.str.8:
	.asciz	"key_projection"
	.size	.L.str.8, 15

	.type	.L.str.9,@object                # @.str.9
.L.str.9:
	.asciz	"value_projection"
	.size	.L.str.9, 17

	.type	.L__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names,@object # @__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names
	.section	.rodata..L__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names,"a",@progbits
	.p2align	4, 0x0
.L__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names:
	.quad	.L.str.7
	.quad	.L.str.8
	.quad	.L.str.9
	.size	.L__const._ZN3fx23opt8OptModel4loadEPKc.qkv_names, 24

	.type	.L.str.10,@object               # @.str.10
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.10:
	.asciz	"prior_embedding"
	.size	.L.str.10, 16

	.type	.L.str.11,@object               # @.str.11
.L.str.11:
	.asciz	"skip_connection_weights.value"
	.size	.L.str.11, 30

	.type	.L.str.12,@object               # @.str.12
.L.str.12:
	.asciz	"blocks."
	.size	.L.str.12, 8

	.type	.L.str.13,@object               # @.str.13
.L.str.13:
	.asciz	"."
	.size	.L.str.13, 2

	.type	.L.str.14,@object               # @.str.14
.L.str.14:
	.asciz	"residual_stream_coefficient.value"
	.size	.L.str.14, 34

	.type	.L.str.15,@object               # @.str.15
.L.str.15:
	.asciz	"token_embedding_coefficient.value"
	.size	.L.str.15, 34

	.type	.L.str.16,@object               # @.str.16
.L.str.16:
	.asciz	"attention."
	.size	.L.str.16, 11

	.type	.L.str.17,@object               # @.str.17
.L.str.17:
	.asciz	"forget_gate_projection.up"
	.size	.L.str.17, 26

	.type	.L.str.18,@object               # @.str.18
.L.str.18:
	.asciz	"forget_gate_projection.down"
	.size	.L.str.18, 28

	.type	.L.str.19,@object               # @.str.19
.L.str.19:
	.asciz	"output_gate_projection.up"
	.size	.L.str.19, 26

	.type	.L.str.20,@object               # @.str.20
.L.str.20:
	.asciz	"output_gate_projection.down"
	.size	.L.str.20, 28

	.type	.L.str.21,@object               # @.str.21
.L.str.21:
	.asciz	"beta_projection.weight"
	.size	.L.str.21, 23

	.type	.L.str.22,@object               # @.str.22
.L.str.22:
	.asciz	"query_convolution.weight"
	.size	.L.str.22, 25

	.type	.L.str.23,@object               # @.str.23
.L.str.23:
	.asciz	"key_convolution.weight"
	.size	.L.str.23, 23

	.type	.L.str.24,@object               # @.str.24
.L.str.24:
	.asciz	"value_convolution.weight"
	.size	.L.str.24, 25

	.type	.L__const._ZN3fx23opt8OptModel4loadEPKc.convs,@object # @__const._ZN3fx23opt8OptModel4loadEPKc.convs
	.section	.rodata..L__const._ZN3fx23opt8OptModel4loadEPKc.convs,"a",@progbits
	.p2align	4, 0x0
.L__const._ZN3fx23opt8OptModel4loadEPKc.convs:
	.quad	.L.str.22
	.quad	.L.str.23
	.quad	.L.str.24
	.size	.L__const._ZN3fx23opt8OptModel4loadEPKc.convs, 24

	.type	.L.str.25,@object               # @.str.25
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.25:
	.asciz	"dt_bias"
	.size	.L.str.25, 8

	.type	.L.str.26,@object               # @.str.26
.L.str.26:
	.asciz	"output_fused_norm_gate.weight"
	.size	.L.str.26, 30

	.type	.L.str.27,@object               # @.str.27
.L.str.27:
	.asciz	"log_baseline_decay_rate"
	.size	.L.str.27, 24

	.type	.L.str.28,@object               # @.str.28
.L.str.28:
	.asciz	"output_projection"
	.size	.L.str.28, 18

	.type	.L.str.29,@object               # @.str.29
.L.str.29:
	.asciz	"quantize_queries.scale"
	.size	.L.str.29, 23

	.type	.L.str.30,@object               # @.str.30
.L.str.30:
	.asciz	"quantize_keys.scale"
	.size	.L.str.30, 20

	.type	.L.str.31,@object               # @.str.31
.L.str.31:
	.asciz	"quantize_values.scale"
	.size	.L.str.31, 22

	.type	.L.str.32,@object               # @.str.32
.L.str.32:
	.asciz	"mlp.up"
	.size	.L.str.32, 7

	.type	.L.str.33,@object               # @.str.33
.L.str.33:
	.asciz	"mlp.down"
	.size	.L.str.33, 9

	.type	.L.str.34,@object               # @.str.34
.L.str.34:
	.asciz	"layer pattern mismatch"
	.size	.L.str.34, 23

	.type	.L.str.35,@object               # @.str.35
.L.str.35:
	.asciz	"unembedding"
	.size	.L.str.35, 12

	.type	.L.str.36,@object               # @.str.36
.L.str.36:
	.asciz	"embedding.weight.q"
	.size	.L.str.36, 19

	.type	.L.str.37,@object               # @.str.37
.L.str.37:
	.asciz	"embedding.weight.scale"
	.size	.L.str.37, 23

	.type	.L.str.38,@object               # @.str.38
.L.str.38:
	.asciz	"rope.inv_freq"
	.size	.L.str.38, 14

	.type	.L.str.39,@object               # @.str.39
.L.str.39:
	.asciz	"rope.sin"
	.size	.L.str.39, 9

	.type	.L.str.40,@object               # @.str.40
.L.str.40:
	.asciz	"rope.cos"
	.size	.L.str.40, 9

	.type	.L.str.41,@object               # @.str.41
.L.str.41:
	.asciz	"arena_build: %s\n"
	.size	.L.str.41, 17

	.type	.L.str.42,@object               # @.str.42
.L.str.42:
	.asciz	".weight.q"
	.size	.L.str.42, 10

	.type	.L.str.43,@object               # @.str.43
.L.str.43:
	.asciz	".weight.scale"
	.size	.L.str.43, 14

	.type	.L.str.44,@object               # @.str.44
.L.str.44:
	.asciz	".quantize_activation.scale"
	.size	.L.str.44, 27

	.type	.L.str.45,@object               # @.str.45
.L.str.45:
	.asciz	"activation scale not positive"
	.size	.L.str.45, 30

	.type	.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits,@object # @__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4, 0x0
.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits:
	.asciz	"00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899"
	.size	.L__const._ZNSt8__detail18__to_chars_10_implIjEEvPcjT_.__digits, 201

	.type	.L.str.46,@object               # @.str.46
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.46:
	.asciz	"act16: weight outside [-7, 7]"
	.size	.L.str.46, 30

	.type	.L.str.47,@object               # @.str.47
.L.str.47:
	.asciz	"weight pool overflow"
	.size	.L.str.47, 21

	.type	.L.str.48,@object               # @.str.48
.L.str.48:
	.asciz	"act16: row layout needs d_in == 192"
	.size	.L.str.48, 36

	.type	.L.str.51,@object               # @.str.51
.L.str.51:
	.asciz	"cannot create std::vector larger than max_size()"
	.size	.L.str.51, 49

	.globl	_ZN3fx23opt7HugeBufD1Ev
	.type	_ZN3fx23opt7HugeBufD1Ev,@function
.set _ZN3fx23opt7HugeBufD1Ev, _ZN3fx23opt7HugeBufD2Ev
	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
