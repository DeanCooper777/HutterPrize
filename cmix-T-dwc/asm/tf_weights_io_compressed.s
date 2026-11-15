	.text
	.file	"weights_io_compressed.cpp"
	.section	.rodata,"a",@progbits
	.p2align	1, 0x0                          # -- Begin function _ZN3fx211WeightsFile15load_compressedEPKc
.LCPI0_0:
	.short	1024                            # 0x400
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI0_1:
	.long	0x3f22f983                      # float 0.636619746
.LCPI0_2:
	.long	0xbfc90fda                      # float -1.57079625
.LCPI0_3:
	.long	0xb3a22168                      # float -7.54978942E-8
.LCPI0_4:
	.long	0xa7c234c5                      # float -5.39030295E-15
.LCPI0_5:
	.long	0x7fffffff                      # float NaN
.LCPI0_6:
	.long	0x47ce4780                      # float 105615
.LCPI0_8:
	.long	0x80000000                      # float -0
.LCPI0_9:
	.long	0x3f800000                      # float 1
.LCPI0_10:
	.long	0x37cbac00                      # float 2.42795795E-5
.LCPI0_11:
	.long	0xbab607ed                      # float -0.00138878601
.LCPI0_12:
	.long	0x3d2aaabb                      # float 0.0416667275
.LCPI0_13:
	.long	0xb94d4153                      # float -1.95746587E-4
.LCPI0_14:
	.long	0x3c0885e4                      # float 0.00833270326
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI0_7:
	.quad	0x3bf921fb54442d19              # double 8.5153039502163873E-20
.LCPI0_15:
	.long	0xbeffffff                      # float -0.49999997
	.long	0xbe2aaaa8                      # float -0.166666627
	.section	.text._ZN3fx211WeightsFile15load_compressedEPKc,"ax",@progbits
	.globl	_ZN3fx211WeightsFile15load_compressedEPKc
	.p2align	1, 0x90
	.type	_ZN3fx211WeightsFile15load_compressedEPKc,@function
_ZN3fx211WeightsFile15load_compressedEPKc: # @_ZN3fx211WeightsFile15load_compressedEPKc
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$2376, %rsp                     # imm = 0x948
	movq	%rsi, %r15
	movq	%rdi, 32(%rsp)                  # 8-byte Spill
	movl	$.L.str, %esi
	movq	%r15, %rdi
	callq	fopen
	testq	%rax, %rax
	je	.LBB0_187
# %bb.1:
	movq	%rax, %rbx
	movq	%rax, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	fseek
	movq	%rbx, %rdi
	callq	ftell
	movq	%rax, %r14
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	callq	fseek
	cmpq	$11, %r14
	jle	.LBB0_188
# %bb.2:
	movq	%r15, 8(%rsp)                   # 8-byte Spill
	leaq	280(%rsp), %r15
	leaq	320(%rsp), %rdx
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZNSt6vectorIhSaIhEEC2EmRKS0_
	movq	(%r15), %rdi
	movq	8(%r15), %rdx
	subq	%rdi, %rdx
	movl	$1, %esi
	movq	%rbx, %rcx
	callq	fread
	movq	8(%r15), %rcx
	subq	(%r15), %rcx
	cmpq	%rcx, %rax
	jne	.LBB0_191
# %bb.3:
	movq	%rbx, %rdi
	callq	fclose
	movq	280(%rsp), %r13
	movq	288(%rsp), %r15
	subq	%r13, %r15
	cmpq	$7, %r15
	jbe	.LBB0_192
# %bb.4:
	movq	(%r13), %rcx
	leaq	-8(%r15), %rax
	movabsq	$3549776890869995590, %rdx      # imm = 0x3143574654325846
	cmpq	%rdx, %rcx
	je	.LBB0_117
# %bb.5:
	movabsq	$3621834484907923526, %rdx      # imm = 0x3243574654325846
	cmpq	%rdx, %rcx
	jne	.LBB0_193
# %bb.6:
	cmpq	$3, %rax
	jbe	.LBB0_163
# %bb.7:
	movl	8(%r13), %eax
	movq	%rax, 264(%rsp)                 # 8-byte Spill
	addq	%r13, %r15
	movq	%r15, 64(%rsp)
	movl	$4294967295, %eax               # imm = 0xFFFFFFFF
	movq	%rax, 72(%rsp)
	addq	$13, %r13
	movq	%r13, 56(%rsp)
	xorl	%eax, %eax
	movl	$4, %ecx
.LBB0_8:                                # =>This Inner Loop Header: Depth=1
	cmpq	%r15, %r13
	jae	.LBB0_10
# %bb.9:                                #   in Loop: Header=BB0_8 Depth=1
	leaq	1(%r13), %rsi
	movq	%rsi, 56(%rsp)
	movb	(%r13), %dl
	movq	%rsi, %r13
	jmp	.LBB0_11
.LBB0_10:                               #   in Loop: Header=BB0_8 Depth=1
	xorl	%edx, %edx
.LBB0_11:                               #   in Loop: Header=BB0_8 Depth=1
	shll	$8, %eax
	movzbl	%dl, %edx
	orl	%edx, %eax
	movl	%eax, 76(%rsp)
	decl	%ecx
	jne	.LBB0_8
# %bb.12:
	movl	$131072, %edi                   # imm = 0x20000
	callq	_Znwm
	movq	%rax, %rbp
	xorl	%eax, %eax
	vpbroadcastw	.LCPI0_0(%rip), %ymm0   # ymm0 = [1024,1024,1024,1024,1024,1024,1024,1024,1024,1024,1024,1024,1024,1024,1024,1024]
.LBB0_13:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	%ymm0, (%rbp,%rax,2)
	addq	$16, %rax
	cmpq	$65536, %rax                    # imm = 0x10000
	jne	.LBB0_13
# %bb.14:
	movl	$33554432, %edi                 # imm = 0x2000000
	vmovdqu	%ymm0, 80(%rsp)                 # 32-byte Spill
	vzeroupper
	callq	_Znwm
	vmovups	80(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
.LBB0_15:                               # =>This Inner Loop Header: Depth=1
	vmovups	%ymm0, (%rax,%rcx,2)
	addq	$16, %rcx
	cmpq	$16777216, %rcx                 # imm = 0x1000000
	jne	.LBB0_15
# %bb.16:
	movq	%rax, 256(%rsp)                 # 8-byte Spill
	movl	$512, %edi                      # imm = 0x200
	vzeroupper
	callq	_Znwm
	vmovups	80(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
.LBB0_17:                               # =>This Inner Loop Header: Depth=1
	vmovups	%ymm0, (%rax,%rcx,2)
	addq	$16, %rcx
	cmpq	$256, %rcx                      # imm = 0x100
	jne	.LBB0_17
# %bb.18:
	movq	%rax, 248(%rsp)                 # 8-byte Spill
	movl	$32, %edi
	vzeroupper
	callq	_Znwm
	movq	%rax, %rbx
	vmovups	80(%rsp), %ymm0                 # 32-byte Reload
	vmovups	%ymm0, (%rax)
	movl	$512, %edi                      # imm = 0x200
	vzeroupper
	callq	_Znwm
	vmovups	80(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
.LBB0_19:                               # =>This Inner Loop Header: Depth=1
	vmovups	%ymm0, (%rax,%rcx,2)
	addq	$16, %rcx
	cmpq	$256, %rcx                      # imm = 0x100
	jne	.LBB0_19
# %bb.20:
	movq	%rax, 232(%rsp)                 # 8-byte Spill
	movl	$131072, %edi                   # imm = 0x20000
	vzeroupper
	callq	_Znwm
	vmovups	80(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
.LBB0_21:                               # =>This Inner Loop Header: Depth=1
	vmovups	%ymm0, (%rax,%rcx,2)
	addq	$16, %rcx
	cmpq	$65536, %rcx                    # imm = 0x10000
	jne	.LBB0_21
# %bb.22:
	movq	%rax, 224(%rsp)                 # 8-byte Spill
	movq	%rbx, 240(%rsp)                 # 8-byte Spill
	movl	$2048, %edi                     # imm = 0x800
	vzeroupper
	callq	_Znwm
	vmovups	80(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
.LBB0_23:                               # =>This Inner Loop Header: Depth=1
	vmovups	%ymm0, (%rax,%rcx,2)
	addq	$16, %rcx
	cmpq	$1024, %rcx                     # imm = 0x400
	jne	.LBB0_23
# %bb.24:
	movq	%rax, 216(%rsp)                 # 8-byte Spill
	movq	32(%rsp), %rdi                  # 8-byte Reload
	leaq	48(%rdi), %rax
	movq	%rax, (%rdi)
	movq	$1, 8(%rdi)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, 16(%rdi)
	movl	$1065353216, 32(%rdi)           # imm = 0x3F800000
	vmovups	%xmm0, 40(%rdi)
	movq	264(%rsp), %rbx                 # 8-byte Reload
	movq	%rbx, %rsi
	vzeroupper
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm
	testq	%rbx, %rbx
	je	.LBB0_116
# %bb.25:
	xorl	%eax, %eax
	leaq	56(%rsp), %r12
	vbroadcastss	.LCPI0_5(%rip), %xmm0   # xmm0 = [NaN,NaN,NaN,NaN]
	vmovaps	%xmm0, 304(%rsp)                # 16-byte Spill
	xorl	%ecx, %ecx
	movq	%rbp, 24(%rsp)                  # 8-byte Spill
.LBB0_26:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_28 Depth 2
                                        #     Child Loop BB0_32 Depth 2
                                        #       Child Loop BB0_33 Depth 3
                                        #     Child Loop BB0_92 Depth 2
                                        #       Child Loop BB0_94 Depth 3
                                        #         Child Loop BB0_99 Depth 4
                                        #     Child Loop BB0_49 Depth 2
                                        #       Child Loop BB0_54 Depth 3
                                        #         Child Loop BB0_58 Depth 4
                                        #     Child Loop BB0_86 Depth 2
                                        #     Child Loop BB0_82 Depth 2
                                        #     Child Loop BB0_78 Depth 2
                                        #     Child Loop BB0_73 Depth 2
	movq	%rax, 272(%rsp)                 # 8-byte Spill
	movzbl	%cl, %esi
	shlq	$9, %rsi
	addq	%rbp, %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movzbl	%al, %ebx
	leaq	128(%rsp), %rax
	movq	%rax, 112(%rsp)
	leaq	112(%rsp), %rdi
	movq	%rbx, %rsi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructEmc
	testl	%ebx, %ebx
	movq	256(%rsp), %r13                 # 8-byte Reload
	je	.LBB0_29
# %bb.27:                               #   in Loop: Header=BB0_26 Depth=1
	xorl	%r14d, %r14d
	xorl	%esi, %esi
	xorl	%r15d, %r15d
.LBB0_28:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	shll	$8, %esi
	orl	%r15d, %esi
	shlq	$9, %rsi
	addq	%r13, %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movl	%r15d, %esi
	movq	112(%rsp), %rcx
	movb	%al, (%rcx,%r14)
	incq	%r14
	movl	%eax, %r15d
	cmpq	%r14, %rbx
	jne	.LBB0_28
.LBB0_29:                               #   in Loop: Header=BB0_26 Depth=1
	movb	$0, 144(%rsp)
	leaq	152(%rsp), %r14
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 24(%r14)
	vmovups	%ymm0, (%r14)
	shlq	$9, %rbx
	addq	%rbp, %rbx
	movq	%r12, %rdi
	movq	%rbx, %rsi
	movl	$8, %edx
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movl	%eax, %ebx
	movb	%bl, 144(%rsp)
	movl	%eax, %edi
	movl	$255, %r13d
	andl	%r13d, %edi
	callq	_ZN3fx212_GLOBAL__N_110dtype_sizeEh
	shll	$8, %ebx
	movzwl	%bx, %eax
	leaq	(,%rax,2), %rsi
	addq	%rbp, %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movl	%eax, %r12d
	movl	%eax, %r15d
	andl	%r13d, %r15d
	cmpb	$8, %r12b
	ja	.LBB0_166
# %bb.30:                               #   in Loop: Header=BB0_26 Depth=1
	movl	%r15d, %esi
	movq	%r14, %rdi
	movq	%rsi, 80(%rsp)                  # 8-byte Spill
	callq	_ZNSt6vectorIjSaIjEE6resizeEm
	testl	%r15d, %r15d
	movl	%r12d, 52(%rsp)                 # 4-byte Spill
	movl	$1, %r13d
	je	.LBB0_35
# %bb.31:                               #   in Loop: Header=BB0_26 Depth=1
	movq	152(%rsp), %rax
	movq	%rax, 208(%rsp)                 # 8-byte Spill
	xorl	%ebx, %ebx
	movl	%r12d, %r15d
.LBB0_32:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_33 Depth 3
	movq	%r13, 40(%rsp)                  # 8-byte Spill
	xorl	%r14d, %r14d
	xorl	%r13d, %r13d
	leaq	56(%rsp), %r12
	movq	24(%rsp), %rbp                  # 8-byte Reload
.LBB0_33:                               #   Parent Loop BB0_26 Depth=1
                                        #     Parent Loop BB0_32 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	movzbl	%r15b, %esi
	shlq	$9, %rsi
	addq	%rbp, %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movl	%eax, %r15d
	movzbl	%r15b, %eax
	shlxl	%r14d, %eax, %eax
	orl	%eax, %r13d
	addl	$8, %r14d
	cmpl	$32, %r14d
	jne	.LBB0_33
# %bb.34:                               #   in Loop: Header=BB0_32 Depth=2
	movq	208(%rsp), %rax                 # 8-byte Reload
	movl	%r13d, (%rax,%rbx,4)
	movl	%r13d, %eax
	movq	40(%rsp), %r13                  # 8-byte Reload
	imulq	%rax, %r13
	incq	%rbx
	cmpq	80(%rsp), %rbx                  # 8-byte Folded Reload
	jne	.LBB0_32
	jmp	.LBB0_36
.LBB0_35:                               #   in Loop: Header=BB0_26 Depth=1
	movl	%r12d, %r15d
.LBB0_36:                               #   in Loop: Header=BB0_26 Depth=1
	movq	%r13, 200(%rsp)
	movzbl	144(%rsp), %edi
	callq	_ZN3fx212_GLOBAL__N_110dtype_sizeEh
	movq	%rax, %rbx
	imulq	%r13, %rbx
	leaq	176(%rsp), %rdi
	movq	%rbx, %rsi
	callq	_ZNSt6vectorIhSaIhEE6resizeEm
	movzbl	%r15b, %esi
	shlq	$9, %rsi
	movq	24(%rsp), %rbp                  # 8-byte Reload
	addq	%rbp, %rsi
	leaq	56(%rsp), %r12
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
                                        # kill: def $eax killed $eax def $rax
	cmpb	$6, %al
	ja	.LBB0_179
# %bb.37:                               #   in Loop: Header=BB0_26 Depth=1
	movzbl	%al, %ecx
	jmpq	*.LJTI0_0(,%rcx,8)
.LBB0_38:                               #   in Loop: Header=BB0_26 Depth=1
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	cmpb	$2, 52(%rsp)                    # 1-byte Folded Reload
	jne	.LBB0_177
# %bb.39:                               #   in Loop: Header=BB0_26 Depth=1
	cmpb	$2, 144(%rsp)
	jne	.LBB0_177
# %bb.40:                               #   in Loop: Header=BB0_26 Depth=1
	leaq	336(%rsp), %r14
	movq	%r14, 320(%rsp)
	movabsq	$8171062882947460713, %rax      # imm = 0x716572665F766E69
	movq	%rax, 5(%r14)
	movabsq	$8533873991904948082, %rax      # imm = 0x766E692E65706F72
	movq	%rax, (%r14)
	movq	$13, 328(%rsp)
	movb	$0, 349(%rsp)
	movq	32(%rsp), %rdi                  # 8-byte Reload
	leaq	320(%rsp), %rsi
	callq	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_
	movq	%rax, %rbx
	movq	320(%rsp), %rdi
	cmpq	%r14, %rdi
	je	.LBB0_42
# %bb.41:                               #   in Loop: Header=BB0_26 Depth=1
	callq	_ZdlPv
.LBB0_42:                               #   in Loop: Header=BB0_26 Depth=1
	testq	%rbx, %rbx
	je	.LBB0_178
# %bb.43:                               #   in Loop: Header=BB0_26 Depth=1
	leaq	336(%rsp), %r14
	movq	%r14, 320(%rsp)
	movabsq	$8171062882947460713, %rax      # imm = 0x716572665F766E69
	movq	%rax, 5(%r14)
	movabsq	$8533873991904948082, %rax      # imm = 0x766E692E65706F72
	movq	%rax, (%r14)
	movq	$13, 328(%rsp)
	movb	$0, 349(%rsp)
	movq	32(%rsp), %rdi                  # 8-byte Reload
	leaq	320(%rsp), %rsi
	callq	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	movq	%rax, %rbx
	movq	320(%rsp), %rdi
	cmpq	%r14, %rdi
	je	.LBB0_45
# %bb.44:                               #   in Loop: Header=BB0_26 Depth=1
	callq	_ZdlPv
.LBB0_45:                               #   in Loop: Header=BB0_26 Depth=1
	cmpb	$2, (%rbx)
	jne	.LBB0_175
# %bb.46:                               #   in Loop: Header=BB0_26 Depth=1
	movq	56(%rbx), %rax
	movq	152(%rsp), %rsi
	movl	4(%rsi), %ecx
	movq	%rcx, 40(%rsp)                  # 8-byte Spill
	cmpq	%rcx, %rax
	jne	.LBB0_175
# %bb.47:                               #   in Loop: Header=BB0_26 Depth=1
	xorl	%edx, %edx
	cmpb	$5, 16(%rsp)                    # 1-byte Folded Reload
	sete	%r9b
	movl	(%rsi), %ecx
	movq	%rcx, 80(%rsp)                  # 8-byte Spill
	testq	%rcx, %rcx
	vmovss	.LCPI0_1(%rip), %xmm5           # xmm5 = mem[0],zero,zero,zero
	vmovss	.LCPI0_2(%rip), %xmm6           # xmm6 = mem[0],zero,zero,zero
	vmovss	.LCPI0_3(%rip), %xmm7           # xmm7 = mem[0],zero,zero,zero
	vmovss	.LCPI0_4(%rip), %xmm8           # xmm8 = mem[0],zero,zero,zero
	vmovaps	304(%rsp), %xmm9                # 16-byte Reload
	vmovss	.LCPI0_6(%rip), %xmm10          # xmm10 = mem[0],zero,zero,zero
	vmovss	.LCPI0_9(%rip), %xmm11          # xmm11 = mem[0],zero,zero,zero
	vxorps	%xmm12, %xmm12, %xmm12
	vmovss	.LCPI0_10(%rip), %xmm13         # xmm13 = mem[0],zero,zero,zero
	vmovss	.LCPI0_11(%rip), %xmm14         # xmm14 = mem[0],zero,zero,zero
	vmovss	.LCPI0_12(%rip), %xmm15         # xmm15 = mem[0],zero,zero,zero
	je	.LBB0_107
# %bb.48:                               #   in Loop: Header=BB0_26 Depth=1
	movq	32(%rbx), %rdi
	movq	176(%rsp), %r8
	movb	%r9b, %dl
	xorl	%ebp, %ebp
.LBB0_49:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_54 Depth 3
                                        #         Child Loop BB0_58 Depth 4
	cmpl	$0, 40(%rsp)                    # 4-byte Folded Reload
	je	.LBB0_70
# %bb.50:                               #   in Loop: Header=BB0_49 Depth=2
	movq	%rbp, %rcx
	testq	%rbp, %rbp
	js	.LBB0_52
# %bb.51:                               #   in Loop: Header=BB0_49 Depth=2
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ss	%rcx, %xmm0, %xmm0
	jmp	.LBB0_53
.LBB0_52:                               #   in Loop: Header=BB0_49 Depth=2
	movq	%rcx, %rsi
	shrq	%rsi
	movl	%ecx, %r10d
	andl	$1, %r10d
	orq	%rsi, %r10
	vxorps	%xmm0, %xmm0, %xmm0
	vcvtsi2ss	%r10, %xmm0, %xmm0
	vaddss	%xmm0, %xmm0, %xmm0
.LBB0_53:                               #   in Loop: Header=BB0_49 Depth=2
	movq	%rcx, %r10
	imulq	%rax, %r10
	xorl	%r11d, %r11d
.LBB0_54:                               #   Parent Loop BB0_26 Depth=1
                                        #     Parent Loop BB0_49 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_58 Depth 4
	vmulss	(%rdi,%r11,4), %xmm0, %xmm2
	vmulss	%xmm5, %xmm2, %xmm1
	vcvtss2si	%xmm1, %r14
	vcvtsi2ss	%r14d, %xmm5, %xmm3
	vmovaps	%xmm2, %xmm1
	vfmadd231ss	%xmm6, %xmm3, %xmm1     # xmm1 = (xmm3 * xmm6) + xmm1
	vfmadd231ss	%xmm7, %xmm3, %xmm1     # xmm1 = (xmm3 * xmm7) + xmm1
	vfmadd231ss	%xmm8, %xmm3, %xmm1     # xmm1 = (xmm3 * xmm8) + xmm1
	vandps	%xmm2, %xmm9, %xmm3
	vucomiss	%xmm10, %xmm3
	jb	.LBB0_63
# %bb.55:                               #   in Loop: Header=BB0_54 Depth=3
	vmovd	%xmm2, %esi
	movl	%esi, %ebx
	andl	$2147483647, %ebx               # imm = 0x7FFFFFFF
	cmpl	$2139095040, %ebx               # imm = 0x7F800000
	jne	.LBB0_57
# %bb.56:                               #   in Loop: Header=BB0_54 Depth=3
	vmulss	%xmm2, %xmm12, %xmm1
	xorl	%r14d, %r14d
	jmp	.LBB0_63
.LBB0_57:                               #   in Loop: Header=BB0_54 Depth=3
	movl	%esi, %r14d
	shll	$8, %r14d
	orl	$-2147483648, %r14d             # imm = 0x80000000
	xorl	%r13d, %r13d
	xorl	%r15d, %r15d
.LBB0_58:                               #   Parent Loop BB0_26 Depth=1
                                        #     Parent Loop BB0_49 Depth=2
                                        #       Parent Loop BB0_54 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	movl	_ZN3fx212_GLOBAL__N_19kI2OverPiE(%r13), %ebx
	imulq	%r14, %rbx
	addq	%rbx, %r15
	movl	%r15d, 320(%rsp,%r13)
	shrq	$32, %r15
	addq	$4, %r13
	cmpq	$24, %r13
	jne	.LBB0_58
# %bb.59:                               #   in Loop: Header=BB0_54 Depth=3
	movl	%esi, %ebx
	shrl	$23, %ebx
	movl	%ebx, %r14d
	andl	$224, %r14d
	addl	$-128, %r14d
	movl	%r15d, 344(%rsp)
	shrl	$5, %r14d
	movl	$6, %r15d
	subl	%r14d, %r15d
	movl	$5, %r13d
	subl	%r14d, %r13d
	movslq	%r15d, %r15
	movl	320(%rsp,%r15,4), %r15d
	movslq	%r13d, %r13
	movl	320(%rsp,%r13,4), %r13d
	andl	$31, %ebx
	je	.LBB0_61
# %bb.60:                               #   in Loop: Header=BB0_54 Depth=3
	movl	$4, %ecx
	subl	%r14d, %ecx
	shlxl	%ebx, %r15d, %r14d
	movl	%ebx, %r9d
	negb	%r9b
	shrxl	%r9d, %r13d, %r15d
	addl	%r14d, %r15d
	shlxl	%ebx, %r13d, %ebx
	movslq	%ecx, %rcx
	shrxl	%r9d, 320(%rsp,%rcx,4), %r13d
	addl	%ebx, %r13d
.LBB0_61:                               #   in Loop: Header=BB0_54 Depth=3
	movl	$-2147483648, %ebx              # imm = 0x80000000
	andl	%ebx, %esi
	movl	%r15d, %ecx
	shldl	$2, %r13d, %r15d
	shrl	$30, %ecx
	shll	$2, %r13d
	movl	%r15d, %r9d
	shrl	$31, %r9d
	addl	%ecx, %r9d
	movl	%r9d, %r14d
	negl	%r14d
	testl	%esi, %esi
	cmovel	%r9d, %r14d
	movl	%esi, %ecx
	xorl	%ebx, %ecx
	movl	%r15d, %r9d
	sarl	$31, %r9d
	movl	%r9d, %ebx
	xorl	%r15d, %ebx
	xorl	%r13d, %r9d
	testl	%r15d, %r15d
	cmovnsl	%esi, %ecx
	shlq	$32, %rbx
	orq	%rbx, %r9
	vcvtsi2sd	%r9, %xmm5, %xmm1
	vmulsd	.LCPI0_7(%rip), %xmm1, %xmm1
	vcvtsd2ss	%xmm1, %xmm1, %xmm1
	testl	%ecx, %ecx
	je	.LBB0_63
# %bb.62:                               #   in Loop: Header=BB0_54 Depth=3
	vbroadcastss	.LCPI0_8(%rip), %xmm2   # xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	vxorps	%xmm2, %xmm1, %xmm1
.LBB0_63:                               #   in Loop: Header=BB0_54 Depth=3
	addl	%edx, %r14d
	xorl	%ebx, %ebx
	vmovaps	%xmm1, %xmm2
	testb	$1, %r14b
	sete	%r15b
	je	.LBB0_65
# %bb.64:                               #   in Loop: Header=BB0_54 Depth=3
	vmovaps	%xmm11, %xmm2
.LBB0_65:                               #   in Loop: Header=BB0_54 Depth=3
	vmulss	%xmm1, %xmm1, %xmm3
	vmovaps	%xmm13, %xmm4
	vfmadd213ss	%xmm14, %xmm3, %xmm4    # xmm4 = (xmm3 * xmm4) + xmm14
	vfmadd213ss	%xmm15, %xmm3, %xmm4    # xmm4 = (xmm3 * xmm4) + xmm15
	vmovss	.LCPI0_13(%rip), %xmm1          # xmm1 = mem[0],zero,zero,zero
	vfmadd213ss	.LCPI0_14(%rip), %xmm3, %xmm1 # xmm1 = (xmm3 * xmm1) + mem
	je	.LBB0_67
# %bb.66:                               #   in Loop: Header=BB0_54 Depth=3
	vmovaps	%xmm4, %xmm1
.LBB0_67:                               #   in Loop: Header=BB0_54 Depth=3
	vmovaps	%xmm2, %xmm4
	vfmadd213ss	%xmm12, %xmm3, %xmm4    # xmm4 = (xmm3 * xmm4) + xmm12
	movb	%r15b, %bl
	vfmadd213ss	.LCPI0_15(,%rbx,4), %xmm3, %xmm1 # xmm1 = (xmm3 * xmm1) + mem
	vfmadd213ss	%xmm2, %xmm4, %xmm1     # xmm1 = (xmm4 * xmm1) + xmm2
	testb	$2, %r14b
	je	.LBB0_69
# %bb.68:                               #   in Loop: Header=BB0_54 Depth=3
	vsubss	%xmm1, %xmm12, %xmm1
.LBB0_69:                               #   in Loop: Header=BB0_54 Depth=3
	leaq	(%r11,%r10), %rcx
	vmovss	%xmm1, (%r8,%rcx,4)
	incq	%r11
	cmpq	%rax, %r11
	jne	.LBB0_54
.LBB0_70:                               #   in Loop: Header=BB0_49 Depth=2
	incq	%rbp
	cmpq	80(%rsp), %rbp                  # 8-byte Folded Reload
	jne	.LBB0_49
	jmp	.LBB0_107
.LBB0_71:                               #   in Loop: Header=BB0_26 Depth=1
	testq	%rbx, %rbx
	je	.LBB0_74
# %bb.72:                               #   in Loop: Header=BB0_26 Depth=1
	xorl	%r14d, %r14d
	movq	248(%rsp), %r15                 # 8-byte Reload
.LBB0_73:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	%r12, %rdi
	movq	%r15, %rsi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movq	176(%rsp), %rcx
	movb	%al, (%rcx,%r14)
	incq	%r14
	cmpq	%r14, %rbx
	jne	.LBB0_73
.LBB0_74:                               #   in Loop: Header=BB0_26 Depth=1
	xorl	%eax, %eax
	jmp	.LBB0_87
.LBB0_75:                               #   in Loop: Header=BB0_26 Depth=1
	movzbl	144(%rsp), %ecx
	testl	%ecx, %ecx
	jne	.LBB0_180
# %bb.76:                               #   in Loop: Header=BB0_26 Depth=1
	movb	$1, %al
	testq	%r13, %r13
	je	.LBB0_87
# %bb.77:                               #   in Loop: Header=BB0_26 Depth=1
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	176(%rsp), %rbx
	xorl	%r14d, %r14d
	movq	240(%rsp), %r15                 # 8-byte Reload
.LBB0_78:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	%r12, %rdi
	movq	%r15, %rsi
	movl	$4, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	addb	$-7, %al
	movb	%al, (%rbx,%r14)
	incq	%r14
	cmpq	%r14, %r13
	jne	.LBB0_78
	jmp	.LBB0_108
.LBB0_79:                               #   in Loop: Header=BB0_26 Depth=1
	movzbl	144(%rsp), %ecx
	cmpl	$1, %ecx
	jne	.LBB0_181
# %bb.80:                               #   in Loop: Header=BB0_26 Depth=1
	movb	$2, %al
	testq	%r13, %r13
	je	.LBB0_87
# %bb.81:                               #   in Loop: Header=BB0_26 Depth=1
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movq	176(%rsp), %rax
	movq	%rax, 80(%rsp)                  # 8-byte Spill
	xorl	%r15d, %r15d
	movq	%r13, %rbp
	movq	232(%rsp), %r13                 # 8-byte Reload
	movq	224(%rsp), %r14                 # 8-byte Reload
.LBB0_82:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movq	%r12, %rdi
	movq	%r13, %rsi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movl	%eax, %ebx
	shll	$8, %ebx
	leaq	(%r14,%rbx,2), %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	orl	%ebx, %eax
	movq	80(%rsp), %rcx                  # 8-byte Reload
	movw	%ax, (%rcx,%r15,2)
	incq	%r15
	cmpq	%r15, %rbp
	jne	.LBB0_82
	jmp	.LBB0_107
.LBB0_83:                               #   in Loop: Header=BB0_26 Depth=1
	movzbl	144(%rsp), %edi
	callq	_ZN3fx212_GLOBAL__N_110dtype_sizeEh
	cmpq	$4, %rax
	jne	.LBB0_182
# %bb.84:                               #   in Loop: Header=BB0_26 Depth=1
	movb	$3, %al
	testq	%rbx, %rbx
	je	.LBB0_87
# %bb.85:                               #   in Loop: Header=BB0_26 Depth=1
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	xorl	%r14d, %r14d
	xorl	%r15d, %r15d
	movq	216(%rsp), %r13                 # 8-byte Reload
.LBB0_86:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	%r14d, %eax
	andl	$768, %eax                      # imm = 0x300
	leaq	(,%rax,2), %rsi
	addq	%r13, %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	movq	176(%rsp), %rcx
	movb	%al, (%rcx,%r15)
	incq	%r15
	addq	$256, %r14                      # imm = 0x100
	cmpq	%r15, %rbx
	jne	.LBB0_86
	jmp	.LBB0_108
.LBB0_87:                               #   in Loop: Header=BB0_26 Depth=1
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	jmp	.LBB0_108
.LBB0_88:                               #   in Loop: Header=BB0_26 Depth=1
	movzbl	144(%rsp), %ecx
	testl	%ecx, %ecx
	jne	.LBB0_183
# %bb.89:                               #   in Loop: Header=BB0_26 Depth=1
	shll	$8, %eax
	movzwl	%ax, %eax
	leaq	(,%rax,2), %rsi
	addq	%rbp, %rsi
	movq	%r12, %rdi
	movl	$8, %edx
	callq	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
                                        # kill: def $eax killed $eax def $rax
	movq	%rax, %rcx
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	addl	$-9, %eax
	cmpb	$-8, %al
	jbe	.LBB0_186
# %bb.90:                               #   in Loop: Header=BB0_26 Depth=1
	movl	$2048, %edx                     # imm = 0x800
	leaq	320(%rsp), %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	testq	%r13, %r13
	je	.LBB0_107
# %bb.91:                               #   in Loop: Header=BB0_26 Depth=1
	movq	16(%rsp), %r8                   # 8-byte Reload
	movzbl	%r8b, %eax
	movl	%eax, 80(%rsp)                  # 4-byte Spill
	movq	176(%rsp), %rax
	movq	%rax, 208(%rsp)                 # 8-byte Spill
	movl	76(%rsp), %eax
	movl	72(%rsp), %esi
	movq	56(%rsp), %r15
	movq	64(%rsp), %rdi
	leal	-1(%r8), %ecx
	movl	$-1, %edx
	shlxl	%ecx, %edx, %ecx
	shlxl	%r8d, %edx, %edx
	addl	%edx, %ecx
	incl	%ecx
	movl	%ecx, 52(%rsp)                  # 4-byte Spill
	xorl	%ebp, %ebp
	movq	%r13, 40(%rsp)                  # 8-byte Spill
.LBB0_92:                               #   Parent Loop BB0_26 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_94 Depth 3
                                        #         Child Loop BB0_99 Depth 4
	cmpl	$0, 80(%rsp)                    # 4-byte Folded Reload
	je	.LBB0_105
# %bb.93:                               #   in Loop: Header=BB0_92 Depth=2
	xorl	%r11d, %r11d
	movl	$1, %ebx
	movl	%eax, %r10d
	movl	%eax, %r9d
	movq	%r15, %r8
.LBB0_94:                               #   Parent Loop BB0_26 Depth=1
                                        #     Parent Loop BB0_92 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB0_99 Depth 4
	addl	%ebx, %ebx
	movl	320(%rsp,%rbx,4), %ecx
	movl	324(%rsp,%rbx,4), %r14d
	movq	%rcx, %rax
	shlq	$13, %rax
	orq	$4096, %rax                     # imm = 0x1000
	movq	%rcx, %rdx
	addq	%r14, %rdx
	leaq	2(,%rdx,2), %r13
	xorl	%edx, %edx
	divq	%r13
	cmpl	$2, %eax
	movl	$1, %edx
	cmovbl	%edx, %eax
	movl	$4095, %edx                     # imm = 0xFFF
	cmpl	%edx, %eax
	cmovael	%edx, %eax
	movl	%esi, %r13d
	shrl	$12, %r13d
	imull	%eax, %r13d
	movl	%r9d, %eax
	subl	%r13d, %eax
	jae	.LBB0_96
# %bb.95:                               #   in Loop: Header=BB0_94 Depth=3
	movl	%r10d, %eax
	xorl	%edx, %edx
	jmp	.LBB0_97
.LBB0_96:                               #   in Loop: Header=BB0_94 Depth=3
	movl	%eax, 76(%rsp)
	subl	%r13d, %esi
	movl	$1, %edx
	movl	%r14d, %ecx
	movl	%eax, %r9d
	movl	%esi, %r13d
.LBB0_97:                               #   in Loop: Header=BB0_94 Depth=3
	leaq	(%rsp,%rbx,4), %rsi
	addq	$320, %rsi                      # imm = 0x140
	movl	%r13d, 72(%rsp)
	movl	%edx, %r10d
	incl	%ecx
	movl	%ecx, (%rsi,%r10,4)
	cmpl	$16777215, %r13d                # imm = 0xFFFFFF
	ja	.LBB0_103
# %bb.98:                               #   in Loop: Header=BB0_94 Depth=3
	movl	%r9d, %eax
.LBB0_99:                               #   Parent Loop BB0_26 Depth=1
                                        #     Parent Loop BB0_92 Depth=2
                                        #       Parent Loop BB0_94 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	cmpq	%rdi, %r8
	jae	.LBB0_101
# %bb.100:                              #   in Loop: Header=BB0_99 Depth=4
	leaq	1(%r8), %r15
	movq	%r15, 56(%rsp)
	movb	(%r8), %cl
	movq	%r15, %r8
	jmp	.LBB0_102
.LBB0_101:                              #   in Loop: Header=BB0_99 Depth=4
	xorl	%ecx, %ecx
.LBB0_102:                              #   in Loop: Header=BB0_99 Depth=4
	shll	$8, %eax
	movzbl	%cl, %ecx
	orl	%ecx, %eax
	movl	%eax, 76(%rsp)
	movl	%r13d, %esi
	shll	$8, %esi
	movl	%esi, 72(%rsp)
	movl	%eax, %r9d
	cmpl	$65536, %r13d                   # imm = 0x10000
	movl	%esi, %r13d
	jb	.LBB0_99
	jmp	.LBB0_104
.LBB0_103:                              #   in Loop: Header=BB0_94 Depth=3
	movl	%r13d, %esi
.LBB0_104:                              #   in Loop: Header=BB0_94 Depth=3
	orl	%ebx, %edx
	incl	%r11d
	movl	%eax, %r10d
	movl	%edx, %ebx
	cmpl	80(%rsp), %r11d                 # 4-byte Folded Reload
	jne	.LBB0_94
	jmp	.LBB0_106
.LBB0_105:                              #   in Loop: Header=BB0_92 Depth=2
	movl	$1, %edx
.LBB0_106:                              #   in Loop: Header=BB0_92 Depth=2
	addl	52(%rsp), %edx                  # 4-byte Folded Reload
	movq	208(%rsp), %rcx                 # 8-byte Reload
	movb	%dl, (%rcx,%rbp)
	incq	%rbp
	movq	40(%rsp), %r13                  # 8-byte Reload
	cmpq	%r13, %rbp
	jne	.LBB0_92
.LBB0_107:                              #   in Loop: Header=BB0_26 Depth=1
	movq	24(%rsp), %rbp                  # 8-byte Reload
.LBB0_108:                              #   in Loop: Header=BB0_26 Depth=1
	movq	32(%rsp), %rdi                  # 8-byte Reload
	leaq	112(%rsp), %rsi
	leaq	144(%rsp), %rdx
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
	testb	$1, %dl
	je	.LBB0_167
# %bb.109:                              #   in Loop: Header=BB0_26 Depth=1
	movq	176(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_111
# %bb.110:                              #   in Loop: Header=BB0_26 Depth=1
	callq	_ZdlPv
.LBB0_111:                              #   in Loop: Header=BB0_26 Depth=1
	movq	152(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_113
# %bb.112:                              #   in Loop: Header=BB0_26 Depth=1
	callq	_ZdlPv
.LBB0_113:                              #   in Loop: Header=BB0_26 Depth=1
	movq	112(%rsp), %rdi
	leaq	128(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB0_115
# %bb.114:                              #   in Loop: Header=BB0_26 Depth=1
	callq	_ZdlPv
.LBB0_115:                              #   in Loop: Header=BB0_26 Depth=1
	movq	272(%rsp), %rax                 # 8-byte Reload
	incl	%eax
	cmpl	264(%rsp), %eax                 # 4-byte Folded Reload
	movq	16(%rsp), %rcx                  # 8-byte Reload
	jne	.LBB0_26
.LBB0_116:
	movq	216(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	224(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	232(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	240(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	248(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	256(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	%rbp, %rdi
	callq	_ZdlPv
	jmp	.LBB0_160
.LBB0_117:
	cmpq	$3, %rax
	jbe	.LBB0_163
# %bb.118:
	movl	8(%r13), %ebx
	addq	$-12, %r15
	movq	32(%rsp), %rdi                  # 8-byte Reload
	leaq	48(%rdi), %rax
	movq	%rax, (%rdi)
	movq	$1, 8(%rdi)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, 16(%rdi)
	movl	$1065353216, 32(%rdi)           # imm = 0x3F800000
	vmovups	%xmm0, 40(%rdi)
	movq	%rbx, %rsi
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm
	movq	%rbx, 24(%rsp)                  # 8-byte Spill
	testq	%rbx, %rbx
	je	.LBB0_159
# %bb.119:
	addq	$12, %r13
	leaq	160(%rsp), %r12
	xorl	%ebp, %ebp
.LBB0_120:                              # =>This Loop Header: Depth=1
                                        #     Child Loop BB0_128 Depth 2
                                        #     Child Loop BB0_138 Depth 2
                                        #     Child Loop BB0_144 Depth 2
                                        #       Child Loop BB0_145 Depth 3
	cmpq	$3, %r15
	jbe	.LBB0_163
# %bb.121:                              #   in Loop: Header=BB0_120 Depth=1
	movl	(%r13), %r14d
	cmpq	$4097, %r14                     # imm = 0x1001
	jae	.LBB0_168
# %bb.122:                              #   in Loop: Header=BB0_120 Depth=1
	leaq	-4(%r15), %rbx
	movq	%r12, 144(%rsp)
	leaq	144(%rsp), %rdi
	movq	%r14, %rsi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructEmc
	cmpq	%r14, %rbx
	jb	.LBB0_169
# %bb.123:                              #   in Loop: Header=BB0_120 Depth=1
	addq	$4, %r13
	movq	144(%rsp), %rdi
	movq	%r13, %rsi
	movq	%r14, %rdx
	callq	memcpy@PLT
	movb	$0, 320(%rsp)
	leaq	328(%rsp), %rax
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 24(%rax)
	vmovups	%ymm0, (%rax)
	cmpq	%r14, %rbx
	je	.LBB0_170
# %bb.124:                              #   in Loop: Header=BB0_120 Depth=1
	movq	%rbp, 80(%rsp)                  # 8-byte Spill
	movzbl	(%r13,%r14), %edi
	movq	%r14, %rax
	notq	%rax
	addq	%rax, %rbx
	movb	%dil, 320(%rsp)
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_110dtype_sizeEh
	cmpq	$3, %rbx
	jbe	.LBB0_163
# %bb.125:                              #   in Loop: Header=BB0_120 Depth=1
	movq	%r15, 40(%rsp)                  # 8-byte Spill
	addq	%r14, %r13
	movl	1(%r13), %ebp
	cmpq	$9, %rbp
	jae	.LBB0_171
# %bb.126:                              #   in Loop: Header=BB0_120 Depth=1
	addq	$5, %r13
	leaq	328(%rsp), %rdi
	movq	%rbp, %rsi
	callq	_ZNSt6vectorIjSaIjEE6resizeEm
	leaq	-4(%rbx), %r15
	testq	%rbp, %rbp
	je	.LBB0_131
# %bb.127:                              #   in Loop: Header=BB0_120 Depth=1
	movq	328(%rsp), %rcx
	shrq	$2, %r15
	shlq	$2, %rbp
	movl	$1, %r12d
	xorl	%eax, %eax
.LBB0_128:                              #   Parent Loop BB0_120 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	subq	$1, %r15
	jb	.LBB0_163
# %bb.129:                              #   in Loop: Header=BB0_128 Depth=2
	movl	(%r13,%rax), %edx
	movl	%edx, (%rcx,%rax)
	imulq	%rdx, %r12
	addq	$4, %rax
	cmpq	%rax, %rbp
	jne	.LBB0_128
# %bb.130:                              #   in Loop: Header=BB0_120 Depth=1
	movq	40(%rsp), %r15                  # 8-byte Reload
	subq	%r14, %r15
	subq	%rax, %r15
	leaq	-5(%r15), %rbx
	addq	$-9, %r15
	addq	%rax, %r13
	jmp	.LBB0_132
.LBB0_131:                              #   in Loop: Header=BB0_120 Depth=1
	movl	$1, %r12d
.LBB0_132:                              #   in Loop: Header=BB0_120 Depth=1
	movq	%r13, %r14
	movq	%r12, 376(%rsp)
	movzbl	320(%rsp), %edi
	callq	_ZN3fx212_GLOBAL__N_110dtype_sizeEh
	movq	%rax, %r13
	imulq	%r12, %r13
	leaq	352(%rsp), %rdi
	movq	%r13, %rsi
	callq	_ZNSt6vectorIhSaIhEE6resizeEm
	cmpb	$0, 320(%rsp)
	movq	80(%rsp), %rbp                  # 8-byte Reload
	je	.LBB0_135
# %bb.133:                              #   in Loop: Header=BB0_120 Depth=1
	subq	%r13, %r15
	jb	.LBB0_174
# %bb.134:                              #   in Loop: Header=BB0_120 Depth=1
	movq	352(%rsp), %rdi
	movq	%r14, %rsi
	movq	%r13, %rdx
	callq	memcpy@PLT
	addq	%r13, %r14
	movq	%r14, %r13
	jmp	.LBB0_151
.LBB0_135:                              #   in Loop: Header=BB0_120 Depth=1
	cmpq	$3, %r15
	jbe	.LBB0_163
# %bb.136:                              #   in Loop: Header=BB0_120 Depth=1
	movl	(%r14), %edx
	addq	$-8, %rbx
	movq	%rbx, %r15
	subq	%rdx, %r15
	jb	.LBB0_176
# %bb.137:                              #   in Loop: Header=BB0_120 Depth=1
	movq	352(%rsp), %rsi
	leaq	(%r14,%rdx), %r13
	addq	$4, %r13
	addq	$5, %r14
	xorl	%ecx, %ecx
	movl	$4, %eax
	movl	$2290649225, %r10d              # imm = 0x88888889
	movl	$14, %r11d
.LBB0_138:                              #   Parent Loop BB0_120 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpq	%r13, %r14
	jae	.LBB0_140
# %bb.139:                              #   in Loop: Header=BB0_138 Depth=2
	movb	(%r14), %dl
	incq	%r14
	jmp	.LBB0_141
.LBB0_140:                              #   in Loop: Header=BB0_138 Depth=2
	xorl	%edx, %edx
.LBB0_141:                              #   in Loop: Header=BB0_138 Depth=2
	movl	%ecx, %edi
	shll	$8, %edi
	movzbl	%dl, %ecx
	orl	%edi, %ecx
	decl	%eax
	jne	.LBB0_138
# %bb.142:                              #   in Loop: Header=BB0_120 Depth=1
	testq	%r12, %r12
	je	.LBB0_151
# %bb.143:                              #   in Loop: Header=BB0_120 Depth=1
	movl	$-1, %r9d
	xorl	%edi, %edi
.LBB0_144:                              #   Parent Loop BB0_120 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB0_145 Depth 3
	movl	%r9d, %r8d
	imulq	%r10, %r8
	shrq	$35, %r8
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%r8d
	cmpl	$14, %eax
	cmovael	%r11d, %eax
	movl	%eax, %edx
	imull	%r8d, %edx
	subl	%edx, %ecx
	cmpl	$251658239, %r9d                # imm = 0xEFFFFFF
	ja	.LBB0_149
.LBB0_145:                              #   Parent Loop BB0_120 Depth=1
                                        #     Parent Loop BB0_144 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	cmpq	%r13, %r14
	jae	.LBB0_147
# %bb.146:                              #   in Loop: Header=BB0_145 Depth=3
	movb	(%r14), %dl
	incq	%r14
	jmp	.LBB0_148
.LBB0_147:                              #   in Loop: Header=BB0_145 Depth=3
	xorl	%edx, %edx
.LBB0_148:                              #   in Loop: Header=BB0_145 Depth=3
	shll	$8, %ecx
	movzbl	%dl, %edx
	orl	%edx, %ecx
	movl	%r8d, %r9d
	shll	$8, %r9d
	cmpl	$65536, %r8d                    # imm = 0x10000
	movl	%r9d, %r8d
	jb	.LBB0_145
	jmp	.LBB0_150
.LBB0_149:                              #   in Loop: Header=BB0_144 Depth=2
	movl	%r8d, %r9d
.LBB0_150:                              #   in Loop: Header=BB0_144 Depth=2
	addb	$-7, %al
	movb	%al, (%rsi,%rdi)
	incq	%rdi
	cmpq	%r12, %rdi
	jne	.LBB0_144
.LBB0_151:                              #   in Loop: Header=BB0_120 Depth=1
	leaq	160(%rsp), %r12
	movq	32(%rsp), %rdi                  # 8-byte Reload
	leaq	144(%rsp), %rsi
	leaq	320(%rsp), %rdx
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
	testb	$1, %dl
	je	.LBB0_172
# %bb.152:                              #   in Loop: Header=BB0_120 Depth=1
	movq	352(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_154
# %bb.153:                              #   in Loop: Header=BB0_120 Depth=1
	callq	_ZdlPv
.LBB0_154:                              #   in Loop: Header=BB0_120 Depth=1
	movq	328(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_156
# %bb.155:                              #   in Loop: Header=BB0_120 Depth=1
	callq	_ZdlPv
.LBB0_156:                              #   in Loop: Header=BB0_120 Depth=1
	movq	144(%rsp), %rdi
	cmpq	%r12, %rdi
	je	.LBB0_158
# %bb.157:                              #   in Loop: Header=BB0_120 Depth=1
	callq	_ZdlPv
.LBB0_158:                              #   in Loop: Header=BB0_120 Depth=1
	incl	%ebp
	cmpl	24(%rsp), %ebp                  # 4-byte Folded Reload
	jne	.LBB0_120
.LBB0_159:
	testq	%r15, %r15
	jne	.LBB0_195
.LBB0_160:
	movq	280(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_162
# %bb.161:
	callq	_ZdlPv
.LBB0_162:
	movq	32(%rsp), %rax                  # 8-byte Reload
	addq	$2376, %rsp                     # imm = 0x948
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB0_163:
	movl	$.L.str.26, %edi
	movl	$4, %edx
.LBB0_164:
	movq	8(%rsp), %rsi                   # 8-byte Reload
.LBB0_165:
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_166:
	movq	112(%rsp), %rdx
	movl	$.L.str.8, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movl	%r15d, %ecx
	jmp	.LBB0_185
.LBB0_167:
	movq	112(%rsp), %rdx
	jmp	.LBB0_173
.LBB0_168:
	movl	$.L.str.7, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movl	%r14d, %edx
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_169:
	movl	$.L.str.26, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movq	%r14, %rdx
	jmp	.LBB0_165
.LBB0_170:
	movl	$.L.str.26, %edi
	movl	$1, %edx
	jmp	.LBB0_164
.LBB0_171:
	movq	144(%rsp), %rdx
	movl	$.L.str.8, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movl	%ebp, %ecx
	jmp	.LBB0_185
.LBB0_172:
	movq	144(%rsp), %rdx
.LBB0_173:
	movl	$.L.str.9, %edi
	jmp	.LBB0_164
.LBB0_174:
	movl	$.L.str.26, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movq	%r13, %rdx
	jmp	.LBB0_165
.LBB0_175:
	movq	112(%rsp), %rdx
	movl	$.L.str.21, %edi
	jmp	.LBB0_164
.LBB0_176:
	movl	$.L.str.26, %edi
	jmp	.LBB0_164
.LBB0_177:
	movq	112(%rsp), %rdx
	movl	$.L.str.18, %edi
	jmp	.LBB0_164
.LBB0_178:
	movq	112(%rsp), %rdx
	movl	$.L.str.20, %edi
	jmp	.LBB0_164
.LBB0_179:
	movzbl	%al, %ecx
	movq	112(%rsp), %rdx
	movl	$.L.str.22, %edi
	jmp	.LBB0_184
.LBB0_180:
	movq	112(%rsp), %rdx
	movl	$.L.str.15, %edi
	jmp	.LBB0_184
.LBB0_181:
	movq	112(%rsp), %rdx
	movl	$.L.str.16, %edi
	jmp	.LBB0_184
.LBB0_182:
	movq	112(%rsp), %rdx
	movzbl	144(%rsp), %ecx
	movl	$.L.str.17, %edi
	jmp	.LBB0_184
.LBB0_183:
	movq	112(%rsp), %rdx
	movl	$.L.str.13, %edi
.LBB0_184:
	movq	8(%rsp), %rsi                   # 8-byte Reload
.LBB0_185:
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_186:
	movq	112(%rsp), %rdx
	movl	$.L.str.14, %edi
	jmp	.LBB0_164
.LBB0_187:
	movl	$.L.str.1, %edi
	jmp	.LBB0_189
.LBB0_188:
	movl	$.L.str.2, %edi
.LBB0_189:
	movq	%r15, %rsi
	jmp	.LBB0_190
.LBB0_191:
	movl	$.L.str.3, %edi
	jmp	.LBB0_194
.LBB0_192:
	movl	$.L.str.26, %edi
	movl	$8, %edx
	jmp	.LBB0_164
.LBB0_193:
	movl	$.L.str.6, %edi
.LBB0_194:
	movq	8(%rsp), %rsi                   # 8-byte Reload
.LBB0_190:
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_195:
	movl	$.L.str.10, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movq	%r15, %rdx
	jmp	.LBB0_165
.Lfunc_end0:
	.size	_ZN3fx211WeightsFile15load_compressedEPKc, .Lfunc_end0-_ZN3fx211WeightsFile15load_compressedEPKc
	.section	.rodata._ZN3fx211WeightsFile15load_compressedEPKc,"a",@progbits
	.p2align	3, 0x0
.LJTI0_0:
	.quad	.LBB0_71
	.quad	.LBB0_75
	.quad	.LBB0_79
	.quad	.LBB0_83
	.quad	.LBB0_38
	.quad	.LBB0_38
	.quad	.LBB0_88
                                        # -- End function
	.section	.text._ZN3fx212_GLOBAL__N_13dieEPKcz,"ax",@progbits
	.type	_ZN3fx212_GLOBAL__N_13dieEPKcz,@function # -- Begin function _ZN3fx212_GLOBAL__N_13dieEPKcz
_ZN3fx212_GLOBAL__N_13dieEPKcz:         # @_ZN3fx212_GLOBAL__N_13dieEPKcz
# %bb.0:
	pushq	%r14
	pushq	%rbx
	subq	$216, %rsp
	movq	%rdi, %rbx
	leaq	32(%rsp), %rdi
	movq	%rsi, 8(%rdi)
	movq	%rdx, 16(%rdi)
	movq	%rcx, 24(%rdi)
	movq	%r8, 32(%rdi)
	movq	%r9, 40(%rdi)
	testb	%al, %al
	je	.LBB1_2
# %bb.1:
	vmovaps	%xmm0, 80(%rsp)
	vmovaps	%xmm1, 96(%rsp)
	vmovaps	%xmm2, 112(%rsp)
	vmovaps	%xmm3, 128(%rsp)
	vmovaps	%xmm4, 144(%rsp)
	vmovaps	%xmm5, 160(%rsp)
	vmovaps	%xmm6, 176(%rsp)
	vmovaps	%xmm7, 192(%rsp)
.LBB1_2:
	movq	%rsp, %r14
	movq	%rdi, 16(%r14)
	leaq	240(%rsp), %rax
	movq	%rax, 8(%r14)
	movabsq	$206158430216, %rax             # imm = 0x3000000008
	movq	%rax, (%r14)
	movq	stderr(%rip), %rcx
	movl	$.L.str.11, %edi
	movl	$23, %esi
	movl	$1, %edx
	callq	fwrite@PLT
	movq	stderr(%rip), %rdi
	movq	%rbx, %rsi
	movq	%r14, %rdx
	callq	vfprintf
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	callq	fputc@PLT
	movl	$1, %edi
	callq	exit
.Lfunc_end1:
	.size	_ZN3fx212_GLOBAL__N_13dieEPKcz, .Lfunc_end1-_ZN3fx212_GLOBAL__N_13dieEPKcz
                                        # -- End function
	.section	.text._ZNSt6vectorIhSaIhEEC2EmRKS0_,"axG",@progbits,_ZNSt6vectorIhSaIhEEC2EmRKS0_,comdat
	.weak	_ZNSt6vectorIhSaIhEEC2EmRKS0_   # -- Begin function _ZNSt6vectorIhSaIhEEC2EmRKS0_
	.p2align	1, 0x90
	.type	_ZNSt6vectorIhSaIhEEC2EmRKS0_,@function
_ZNSt6vectorIhSaIhEEC2EmRKS0_:          # @_ZNSt6vectorIhSaIhEEC2EmRKS0_
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	testq	%rsi, %rsi
	js	.LBB2_6
# %bb.1:
	movq	%rsi, %r14
	movq	%rdi, %rbx
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, (%rdi)
	movq	$0, 16(%rdi)
	callq	_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm
	movq	(%rbx), %r15
	testq	%r14, %r14
	je	.LBB2_5
# %bb.2:
	movb	$0, (%r15)
	leaq	1(%r15), %rdi
	movq	%r14, %rdx
	decq	%rdx
	je	.LBB2_3
# %bb.4:
	addq	%r14, %r15
	xorl	%esi, %esi
	callq	memset@PLT
	jmp	.LBB2_5
.LBB2_3:
	movq	%rdi, %r15
.LBB2_5:
	movq	%r15, 8(%rbx)
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.LBB2_6:
	movl	$.L.str.23, %edi
	callq	_ZSt20__throw_length_errorPKc
.Lfunc_end2:
	.size	_ZNSt6vectorIhSaIhEEC2EmRKS0_, .Lfunc_end2-_ZNSt6vectorIhSaIhEEC2EmRKS0_
                                        # -- End function
	.section	.text._ZN3fx212_GLOBAL__N_110dtype_sizeEh,"ax",@progbits
	.type	_ZN3fx212_GLOBAL__N_110dtype_sizeEh,@function # -- Begin function _ZN3fx212_GLOBAL__N_110dtype_sizeEh
_ZN3fx212_GLOBAL__N_110dtype_sizeEh:    # @_ZN3fx212_GLOBAL__N_110dtype_sizeEh
# %bb.0:
	cmpb	$4, %dil
	jae	.LBB3_2
# %bb.1:
	movsbq	%dil, %rax
	movq	.Lswitch.table._ZN3fx212_GLOBAL__N_110dtype_sizeEh(,%rax,8), %rax
	retq
.LBB3_2:
	pushq	%rax
	movzbl	%dil, %esi
	movl	$.L.str.25, %edi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.Lfunc_end3:
	.size	_ZN3fx212_GLOBAL__N_110dtype_sizeEh, .Lfunc_end3-_ZN3fx212_GLOBAL__N_110dtype_sizeEh
                                        # -- End function
	.section	.text._ZNSt6vectorIjSaIjEE6resizeEm,"axG",@progbits,_ZNSt6vectorIjSaIjEE6resizeEm,comdat
	.weak	_ZNSt6vectorIjSaIjEE6resizeEm   # -- Begin function _ZNSt6vectorIjSaIjEE6resizeEm
	.p2align	1, 0x90
	.type	_ZNSt6vectorIjSaIjEE6resizeEm,@function
_ZNSt6vectorIjSaIjEE6resizeEm:          # @_ZNSt6vectorIjSaIjEE6resizeEm
# %bb.0:
	movq	(%rdi), %rdx
	movq	8(%rdi), %rcx
	movq	%rcx, %r8
	subq	%rdx, %r8
	shrq	$2, %r8
	movq	%rsi, %rax
	subq	%r8, %rax
	jbe	.LBB4_1
# %bb.5:
	movq	%rax, %rsi
	jmp	_ZNSt6vectorIjSaIjEE17_M_default_appendEm # TAILCALL
.LBB4_1:
	jae	.LBB4_4
# %bb.2:
	leaq	(%rdx,%rsi,4), %rax
	cmpq	%rax, %rcx
	je	.LBB4_4
# %bb.3:
	movq	%rax, 8(%rdi)
.LBB4_4:
	retq
.Lfunc_end4:
	.size	_ZNSt6vectorIjSaIjEE6resizeEm, .Lfunc_end4-_ZNSt6vectorIjSaIjEE6resizeEm
                                        # -- End function
	.section	.text._ZNSt6vectorIhSaIhEE6resizeEm,"axG",@progbits,_ZNSt6vectorIhSaIhEE6resizeEm,comdat
	.weak	_ZNSt6vectorIhSaIhEE6resizeEm   # -- Begin function _ZNSt6vectorIhSaIhEE6resizeEm
	.p2align	1, 0x90
	.type	_ZNSt6vectorIhSaIhEE6resizeEm,@function
_ZNSt6vectorIhSaIhEE6resizeEm:          # @_ZNSt6vectorIhSaIhEE6resizeEm
# %bb.0:
	movq	(%rdi), %rcx
	movq	8(%rdi), %rdx
	movq	%rdx, %r8
	subq	%rcx, %r8
	movq	%rsi, %rax
	subq	%r8, %rax
	jbe	.LBB5_1
# %bb.5:
	movq	%rax, %rsi
	jmp	_ZNSt6vectorIhSaIhEE17_M_default_appendEm # TAILCALL
.LBB5_1:
	jae	.LBB5_4
# %bb.2:
	addq	%rsi, %rcx
	cmpq	%rcx, %rdx
	je	.LBB5_4
# %bb.3:
	movq	%rcx, 8(%rdi)
.LBB5_4:
	retq
.Lfunc_end5:
	.size	_ZNSt6vectorIhSaIhEE6resizeEm, .Lfunc_end5-_ZNSt6vectorIhSaIhEE6resizeEm
                                        # -- End function
	.section	.text._ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti,"ax",@progbits
	.p2align	1, 0x90                         # -- Begin function _ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
	.type	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti,@function
_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti: # @_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
# %bb.0:
	testl	%edx, %edx
	jle	.LBB6_1
# %bb.3:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	movq	(%rdi), %rcx
	movq	8(%rdi), %rax
	movl	20(%rdi), %r10d
	movl	16(%rdi), %ebp
	movl	$1, %r9d
	xorl	%r8d, %r8d
.LBB6_4:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_10 Depth 2
	movl	%r9d, %r14d
	movl	%ebp, %ebx
	shrl	$11, %ebx
	movzwl	(%rsi,%r14,2), %r15d
	imull	%r15d, %ebx
	movl	%r10d, %r12d
	subl	%ebx, %r12d
	jae	.LBB6_6
# %bb.5:                                #   in Loop: Header=BB6_4 Depth=1
	movl	$2048, %ebp                     # imm = 0x800
	subl	%r15d, %ebp
	shrl	$5, %ebp
	addl	%r15d, %ebp
	xorl	%r11d, %r11d
	jmp	.LBB6_7
.LBB6_6:                                #   in Loop: Header=BB6_4 Depth=1
	movl	%r12d, 20(%rdi)
	subl	%ebx, %ebp
	movl	%r15d, %r10d
	shrl	$5, %r10d
	subl	%r10d, %r15d
	movl	$1, %r11d
	movl	%r12d, %r10d
	movl	%ebp, %ebx
	movl	%r15d, %ebp
.LBB6_7:                                #   in Loop: Header=BB6_4 Depth=1
	movl	%ebx, 16(%rdi)
	movw	%bp, (%rsi,%r14,2)
	cmpl	$16777215, %ebx                 # imm = 0xFFFFFF
	ja	.LBB6_8
# %bb.9:                                #   in Loop: Header=BB6_4 Depth=1
	movq	%rcx, %r14
.LBB6_10:                               #   Parent Loop BB6_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	cmpq	%rax, %r14
	jae	.LBB6_11
# %bb.12:                               #   in Loop: Header=BB6_10 Depth=2
	leaq	1(%r14), %rcx
	movq	%rcx, (%rdi)
	movb	(%r14), %bpl
	movq	%rcx, %r14
	jmp	.LBB6_13
.LBB6_11:                               #   in Loop: Header=BB6_10 Depth=2
	xorl	%ebp, %ebp
.LBB6_13:                               #   in Loop: Header=BB6_10 Depth=2
	shll	$8, %r10d
	movzbl	%bpl, %ebp
	orl	%ebp, %r10d
	movl	%r10d, 20(%rdi)
	movl	%ebx, %ebp
	shll	$8, %ebp
	movl	%ebp, 16(%rdi)
	cmpl	$65536, %ebx                    # imm = 0x10000
	movl	%ebp, %ebx
	jb	.LBB6_10
	jmp	.LBB6_14
.LBB6_8:                                #   in Loop: Header=BB6_4 Depth=1
	movl	%ebx, %ebp
.LBB6_14:                               #   in Loop: Header=BB6_4 Depth=1
	addl	%r9d, %r9d
	orl	%r9d, %r11d
	incl	%r8d
	movl	%r11d, %r9d
	cmpl	%edx, %r8d
	jne	.LBB6_4
# %bb.15:
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	popq	%rbp
	jmp	.LBB6_2
.LBB6_1:
	movl	$1, %r11d
.LBB6_2:
	movl	$-1, %eax
	shlxl	%edx, %eax, %eax
	addl	%r11d, %eax
	retq
.Lfunc_end6:
	.size	_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti, .Lfunc_end6-_ZN3fx212_GLOBAL__N_110BinDecoder11decode_treeEPti
                                        # -- End function
	.section	.text._ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_,"axG",@progbits,_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_,comdat
	.weak	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_ # -- Begin function _ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_
	.p2align	1, 0x90
	.type	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_,@function
_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_: # @_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%rsi, %rbx
	movq	%rdi, %r14
	movq	24(%rdi), %rbp
	cmpq	$21, %rbp
	jb	.LBB7_4
# %bb.1:
	movq	(%rbx), %rdi
	movq	8(%rbx), %rsi
	movl	$3339675911, %edx               # imm = 0xC70F6907
	callq	_ZSt11_Hash_bytesPKvmm
.LBB7_2:
	movq	%rax, %rcx
	xorl	%r15d, %r15d
	xorl	%edx, %edx
	divq	8(%r14)
	movq	%r14, %rdi
	movq	%rdx, %rsi
	movq	%rbx, %rdx
	callq	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m
	testq	%rax, %rax
	je	.LBB7_12
# %bb.3:
	movq	(%rax), %r15
	jmp	.LBB7_12
.LBB7_4:
	movq	16(%r14), %r15
	movq	(%rbx), %r12
	movq	8(%rbx), %r13
	testq	%r15, %r15
	je	.LBB7_5
.LBB7_6:                                # =>This Inner Loop Header: Depth=1
	cmpq	16(%r15), %r13
	jne	.LBB7_9
# %bb.7:                                #   in Loop: Header=BB7_6 Depth=1
	testq	%r13, %r13
	je	.LBB7_12
# %bb.8:                                #   in Loop: Header=BB7_6 Depth=1
	movq	8(%r15), %rsi
	movq	%r12, %rdi
	movq	%r13, %rdx
	callq	bcmp@PLT
	testl	%eax, %eax
	je	.LBB7_12
.LBB7_9:                                #   in Loop: Header=BB7_6 Depth=1
	movq	(%r15), %r15
	testq	%r15, %r15
	jne	.LBB7_6
# %bb.10:
	movq	8(%rbx), %rsi
	movl	$3339675911, %edx               # imm = 0xC70F6907
	movq	%r12, %rdi
	callq	_ZSt11_Hash_bytesPKvmm
	cmpq	$21, %rbp
	jae	.LBB7_2
	jmp	.LBB7_11
.LBB7_5:
	movl	$3339675911, %edx               # imm = 0xC70F6907
	movq	%r12, %rdi
	movq	%r13, %rsi
	callq	_ZSt11_Hash_bytesPKvmm
.LBB7_11:
	xorl	%r15d, %r15d
.LBB7_12:
	movq	%r15, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end7:
	.size	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_, .Lfunc_end7-_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE4findERS7_
                                        # -- End function
	.section	.text._ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m,"axG",@progbits,_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m,comdat
	.weak	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m # -- Begin function _ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m
	.p2align	1, 0x90
	.type	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m,@function
_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m: # @_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	(%rdi), %rax
	movq	%rsi, (%rsp)                    # 8-byte Spill
	movq	(%rax,%rsi,8), %r13
	testq	%r13, %r13
	je	.LBB8_1
# %bb.2:
	movq	%rcx, %r8
	movq	%rdi, %r12
	movq	(%r13), %rbp
	leaq	8(%rbp), %rcx
	movq	%rdx, %r15
	movq	%rdx, %rsi
	movq	%r8, %r14
	movq	%r8, %rdx
	callq	_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE
.LBB8_4:                                # =>This Inner Loop Header: Depth=1
	testb	%al, %al
	jne	.LBB8_7
# %bb.5:                                #   in Loop: Header=BB8_4 Depth=1
	movq	%rbp, %rbx
	movq	(%rbp), %rbp
	testq	%rbp, %rbp
	je	.LBB8_1
# %bb.6:                                #   in Loop: Header=BB8_4 Depth=1
	movq	104(%rbp), %rax
	xorl	%edx, %edx
	divq	8(%r12)
	movl	$0, %r13d
	cmpq	(%rsp), %rdx                    # 8-byte Folded Reload
	jne	.LBB8_7
# %bb.3:                                #   in Loop: Header=BB8_4 Depth=1
	leaq	8(%rbp), %rcx
	movq	%r12, %rdi
	movq	%r15, %rsi
	movq	%r14, %rdx
	callq	_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE
	movq	%rbx, %r13
	jmp	.LBB8_4
.LBB8_1:
	xorl	%r13d, %r13d
.LBB8_7:
	movq	%r13, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end8:
	.size	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m, .Lfunc_end8-_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m
                                        # -- End function
	.section	.text._ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE,"axG",@progbits,_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE,comdat
	.weak	_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE # -- Begin function _ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE
	.p2align	1, 0x90
	.type	_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE,@function
_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE: # @_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE
# %bb.0:
	cmpq	%rdx, 96(%rcx)
	jne	.LBB9_4
# %bb.1:
	movq	8(%rsi), %rdx
	cmpq	8(%rcx), %rdx
	jne	.LBB9_4
# %bb.2:
	testq	%rdx, %rdx
	je	.LBB9_6
# %bb.3:
	pushq	%rax
	movq	(%rcx), %rax
	movq	(%rsi), %rdi
	movq	%rax, %rsi
	callq	bcmp@PLT
	testl	%eax, %eax
	sete	%al
	addq	$8, %rsp
                                        # kill: def $al killed $al killed $eax
	retq
.LBB9_4:
	xorl	%eax, %eax
                                        # kill: def $al killed $al killed $eax
	retq
.LBB9_6:
	movb	$1, %al
                                        # kill: def $al killed $al killed $eax
	retq
.Lfunc_end9:
	.size	_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE, .Lfunc_end9-_ZNKSt8__detail15_Hashtable_baseINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS6_N3fx27WTensorEENS_10_Select1stESt8equal_toIS6_ESt4hashIS6_ENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_equalsERS8_mRKNS_16_Hash_node_valueISB_Lb1EEE
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm
.LCPI10_0:
	.long	1127219200                      # 0x43300000
	.long	1160773632                      # 0x45300000
	.long	0                               # 0x0
	.long	0                               # 0x0
.LCPI10_1:
	.quad	0x4330000000000000              # double 4503599627370496
	.quad	0x4530000000000000              # double 1.9342813113834067E+25
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI10_2:
	.quad	0x43e0000000000000              # double 9.2233720368547758E+18
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm
	.p2align	1, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm
# %bb.0:
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	movq	%rdi, %rbx
	movq	24(%rdi), %rax
	incq	%rax
	vmovq	%rax, %xmm0
	vpunpckldq	.LCPI10_0(%rip), %xmm0, %xmm0 # xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
	vsubpd	.LCPI10_1(%rip), %xmm0, %xmm0
	vhaddpd	%xmm0, %xmm0, %xmm0
	addq	$32, %rdi
	movq	40(%rbx), %r14
	vcvtss2sd	32(%rbx), %xmm1, %xmm1
	vdivsd	%xmm1, %xmm0, %xmm0
	vroundsd	$10, %xmm0, %xmm0, %xmm0
	vcvttsd2si	%xmm0, %rax
	movq	%rax, %rcx
	sarq	$63, %rcx
	vsubsd	.LCPI10_2(%rip), %xmm0, %xmm0
	vcvttsd2si	%xmm0, %rdx
	andq	%rcx, %rdx
	orq	%rax, %rdx
	cmpq	%rsi, %rdx
	cmovaq	%rdx, %rsi
	callq	_ZNKSt8__detail20_Prime_rehash_policy11_M_next_bktEm
	cmpq	8(%rbx), %rax
	jne	.LBB10_2
# %bb.1:
	movq	%r14, 40(%rbx)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB10_2:
	movq	%rbx, %rdi
	movq	%rax, %rsi
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	jmp	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE # TAILCALL
.Lfunc_end10:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm, .Lfunc_end10-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE6rehashEm
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
	.p2align	1, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$16, %rsp
	movq	%rsi, %r14
	movq	%rdi, %rbx
	cmpq	$1, %rsi
	je	.LBB11_1
# %bb.2:
	leaq	15(%rsp), %rdi
	movq	%r14, %rsi
	xorl	%edx, %edx
	callq	_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv
	movq	%rax, %r15
	leaq	(,%r14,8), %rdx
	movq	%rax, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
.LBB11_3:
	movq	16(%rbx), %rsi
	movq	$0, 16(%rbx)
	testq	%rsi, %rsi
	je	.LBB11_11
# %bb.4:
	leaq	16(%rbx), %rcx
	xorl	%r8d, %r8d
.LBB11_5:                               # =>This Inner Loop Header: Depth=1
	movq	(%rsi), %rdi
	movq	104(%rsi), %rax
	xorl	%edx, %edx
	divq	%r14
	movq	(%r15,%rdx,8), %rax
	testq	%rax, %rax
	je	.LBB11_6
# %bb.8:                                #   in Loop: Header=BB11_5 Depth=1
	movq	(%rax), %rax
	movq	%rax, (%rsi)
	movq	(%r15,%rdx,8), %rax
	movq	%r8, %rdx
	jmp	.LBB11_9
.LBB11_6:                               #   in Loop: Header=BB11_5 Depth=1
	movq	(%rcx), %rax
	movq	%rax, (%rsi)
	movq	%rsi, (%rcx)
	movq	%rcx, (%r15,%rdx,8)
	cmpq	$0, (%rsi)
	je	.LBB11_10
# %bb.7:                                #   in Loop: Header=BB11_5 Depth=1
	leaq	(%r15,%r8,8), %rax
.LBB11_9:                               #   in Loop: Header=BB11_5 Depth=1
	movq	%rsi, (%rax)
.LBB11_10:                              #   in Loop: Header=BB11_5 Depth=1
	movq	%rdi, %rsi
	movq	%rdx, %r8
	testq	%rdi, %rdi
	jne	.LBB11_5
.LBB11_11:
	movq	(%rbx), %rdi
	leaq	48(%rbx), %rax
	cmpq	%rdi, %rax
	je	.LBB11_13
# %bb.12:
	callq	_ZdlPv
.LBB11_13:
	movq	%r14, 8(%rbx)
	movq	%r15, (%rbx)
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.LBB11_1:
	leaq	48(%rbx), %r15
	movq	$0, 48(%rbx)
	jmp	.LBB11_3
.Lfunc_end11:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE, .Lfunc_end11-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
                                        # -- End function
	.section	.text._ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv,"axG",@progbits,_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv,comdat
	.weak	_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv # -- Begin function _ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv
	.p2align	1, 0x90
	.type	_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv,@function
_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv: # @_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv
# %bb.0:
	pushq	%rax
	movq	%rsi, %rax
	shrq	$60, %rax
	jne	.LBB12_1
# %bb.3:
	shlq	$3, %rsi
	movq	%rsi, %rdi
	popq	%rax
	jmp	_Znwm                           # TAILCALL
.LBB12_1:
	shrq	$61, %rsi
	je	.LBB12_2
# %bb.4:
	callq	_ZSt28__throw_bad_array_new_lengthv
.LBB12_2:
	callq	_ZSt17__throw_bad_allocv
.Lfunc_end12:
	.size	_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv, .Lfunc_end12-_ZNSt15__new_allocatorIPNSt8__detail15_Hash_node_baseEE8allocateEmPKv
                                        # -- End function
	.section	.text._ZNSt6vectorIjSaIjEE17_M_default_appendEm,"axG",@progbits,_ZNSt6vectorIjSaIjEE17_M_default_appendEm,comdat
	.weak	_ZNSt6vectorIjSaIjEE17_M_default_appendEm # -- Begin function _ZNSt6vectorIjSaIjEE17_M_default_appendEm
	.p2align	1, 0x90
	.type	_ZNSt6vectorIjSaIjEE17_M_default_appendEm,@function
_ZNSt6vectorIjSaIjEE17_M_default_appendEm: # @_ZNSt6vectorIjSaIjEE17_M_default_appendEm
# %bb.0:
	testq	%rsi, %rsi
	je	.LBB13_16
# %bb.1:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	8(%rdi), %r13
	movq	16(%rdi), %rax
	subq	%r13, %rax
	sarq	$2, %rax
	cmpq	%rsi, %rax
	jae	.LBB13_2
# %bb.5:
	movq	(%rbx), %r15
	movq	%r13, %r12
	subq	%r15, %r12
	movq	%r12, 8(%rsp)                   # 8-byte Spill
	shrq	$2, %r12
	movl	$.L.str.27, %edx
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc
	testq	%rax, %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	je	.LBB13_6
# %bb.7:
	movq	%rbx, %rdi
	movq	%rax, %rsi
	xorl	%edx, %edx
	callq	_ZNSt15__new_allocatorIjE8allocateEmPKv
	movq	%rax, %rbp
	jmp	.LBB13_8
.LBB13_2:
	movl	$0, (%r13)
	leaq	4(%r13), %rdi
	cmpq	$1, %r14
	je	.LBB13_4
# %bb.3:
	leaq	-4(,%r14,4), %rdx
	xorl	%esi, %esi
	callq	memset@PLT
	leaq	(,%r14,4), %rdi
	addq	%r13, %rdi
.LBB13_4:
	movq	%rdi, 8(%rbx)
	jmp	.LBB13_15
.LBB13_6:
	xorl	%ebp, %ebp
.LBB13_8:
	leaq	(,%r12,4), %r12
	addq	%rbp, %r12
	movl	$0, (%r12)
	cmpq	$1, %r14
	je	.LBB13_10
# %bb.9:
	leaq	4(%r12), %rdi
	leaq	-4(,%r14,4), %rdx
	xorl	%esi, %esi
	callq	memset@PLT
.LBB13_10:
	cmpq	%r15, %r13
	je	.LBB13_12
# %bb.11:
	movq	%rbp, %rdi
	movq	%r15, %rsi
	movq	8(%rsp), %rdx                   # 8-byte Reload
	callq	memcpy@PLT
.LBB13_12:
	testq	%r15, %r15
	je	.LBB13_14
# %bb.13:
	movq	%r15, %rdi
	callq	_ZdlPv
.LBB13_14:
	movq	%rbp, (%rbx)
	leaq	(%r12,%r14,4), %rax
	movq	%rax, 8(%rbx)
	movq	16(%rsp), %rax                  # 8-byte Reload
	leaq	(,%rax,4), %rax
	addq	%rbp, %rax
	movq	%rax, 16(%rbx)
.LBB13_15:
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
.LBB13_16:
	retq
.Lfunc_end13:
	.size	_ZNSt6vectorIjSaIjEE17_M_default_appendEm, .Lfunc_end13-_ZNSt6vectorIjSaIjEE17_M_default_appendEm
                                        # -- End function
	.section	.text._ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc,"axG",@progbits,_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc,comdat
	.weak	_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc # -- Begin function _ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc
	.p2align	1, 0x90
	.type	_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc,@function
_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc: # @_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc
# %bb.0:
	movabsq	$2305843009213693951, %rcx      # imm = 0x1FFFFFFFFFFFFFFF
	movq	8(%rdi), %r8
	subq	(%rdi), %r8
	shrq	$2, %r8
	movq	%r8, %rax
	xorq	%rcx, %rax
	cmpq	%rsi, %rax
	jb	.LBB14_2
# %bb.1:
	cmpq	%rsi, %r8
	cmovaq	%r8, %rsi
	leaq	(%rsi,%r8), %rax
	cmpq	%rcx, %rax
	cmovaq	%rcx, %rax
	addq	%r8, %rsi
	cmovbq	%rcx, %rax
	retq
.LBB14_2:
	pushq	%rax
	movq	%rdx, %rdi
	callq	_ZSt20__throw_length_errorPKc
.Lfunc_end14:
	.size	_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc, .Lfunc_end14-_ZNKSt6vectorIjSaIjEE12_M_check_lenEmPKc
                                        # -- End function
	.section	.text._ZNSt15__new_allocatorIjE8allocateEmPKv,"axG",@progbits,_ZNSt15__new_allocatorIjE8allocateEmPKv,comdat
	.weak	_ZNSt15__new_allocatorIjE8allocateEmPKv # -- Begin function _ZNSt15__new_allocatorIjE8allocateEmPKv
	.p2align	1, 0x90
	.type	_ZNSt15__new_allocatorIjE8allocateEmPKv,@function
_ZNSt15__new_allocatorIjE8allocateEmPKv: # @_ZNSt15__new_allocatorIjE8allocateEmPKv
# %bb.0:
	pushq	%rax
	movq	%rsi, %rax
	shrq	$61, %rax
	jne	.LBB15_1
# %bb.3:
	shlq	$2, %rsi
	movq	%rsi, %rdi
	popq	%rax
	jmp	_Znwm                           # TAILCALL
.LBB15_1:
	shrq	$62, %rsi
	je	.LBB15_2
# %bb.4:
	callq	_ZSt28__throw_bad_array_new_lengthv
.LBB15_2:
	callq	_ZSt17__throw_bad_allocv
.Lfunc_end15:
	.size	_ZNSt15__new_allocatorIjE8allocateEmPKv, .Lfunc_end15-_ZNSt15__new_allocatorIjE8allocateEmPKv
                                        # -- End function
	.section	.text._ZNSt6vectorIhSaIhEE17_M_default_appendEm,"axG",@progbits,_ZNSt6vectorIhSaIhEE17_M_default_appendEm,comdat
	.weak	_ZNSt6vectorIhSaIhEE17_M_default_appendEm # -- Begin function _ZNSt6vectorIhSaIhEE17_M_default_appendEm
	.p2align	1, 0x90
	.type	_ZNSt6vectorIhSaIhEE17_M_default_appendEm,@function
_ZNSt6vectorIhSaIhEE17_M_default_appendEm: # @_ZNSt6vectorIhSaIhEE17_M_default_appendEm
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	testq	%rsi, %rsi
	je	.LBB16_16
# %bb.1:
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	8(%rdi), %r12
	movq	16(%rdi), %rax
	subq	%r12, %rax
	cmpq	%rsi, %rax
	jae	.LBB16_2
# %bb.5:
	movq	(%rbx), %rax
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	movl	$.L.str.27, %edx
	movq	%rbx, %rdi
	movq	%r14, %rsi
	callq	_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc
	testq	%rax, %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	je	.LBB16_6
# %bb.7:
	js	.LBB16_17
# %bb.8:
	movq	%rax, %rdi
	callq	_Znwm
	movq	%rax, %r13
	jmp	.LBB16_9
.LBB16_2:
	movb	$0, (%r12)
	leaq	1(%r12), %rdi
	movq	%r14, %rdx
	decq	%rdx
	je	.LBB16_4
# %bb.3:
	addq	%r14, %r12
	xorl	%esi, %esi
	callq	memset@PLT
	movq	%r12, %rdi
.LBB16_4:
	movq	%rdi, 8(%rbx)
	jmp	.LBB16_16
.LBB16_6:
	xorl	%r13d, %r13d
.LBB16_9:
	movq	%r12, %rbp
	subq	8(%rsp), %rbp                   # 8-byte Folded Reload
	movq	%r13, %r15
	addq	%rbp, %r15
	movb	$0, (%r13,%rbp)
	movq	%r14, %rdx
	decq	%rdx
	je	.LBB16_11
# %bb.10:
	leaq	1(%r15), %rdi
	xorl	%esi, %esi
	callq	memset@PLT
.LBB16_11:
	movq	8(%rsp), %rax                   # 8-byte Reload
	cmpq	%rax, %r12
	movq	%rax, %r12
	je	.LBB16_13
# %bb.12:
	movq	%r13, %rdi
	movq	%r12, %rsi
	movq	%rbp, %rdx
	callq	memcpy@PLT
.LBB16_13:
	testq	%r12, %r12
	je	.LBB16_15
# %bb.14:
	movq	%r12, %rdi
	callq	_ZdlPv
.LBB16_15:
	movq	%r13, (%rbx)
	addq	%r14, %r15
	movq	%r15, 8(%rbx)
	movq	16(%rsp), %rax                  # 8-byte Reload
	addq	%r13, %rax
	movq	%rax, 16(%rbx)
.LBB16_16:
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB16_17:
	callq	_ZSt17__throw_bad_allocv
.Lfunc_end16:
	.size	_ZNSt6vectorIhSaIhEE17_M_default_appendEm, .Lfunc_end16-_ZNSt6vectorIhSaIhEE17_M_default_appendEm
                                        # -- End function
	.section	.text._ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc,"axG",@progbits,_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc,comdat
	.weak	_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc # -- Begin function _ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc
	.p2align	1, 0x90
	.type	_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc,@function
_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc: # @_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc
# %bb.0:
	movq	8(%rdi), %rcx
	subq	(%rdi), %rcx
	movabsq	$9223372036854775807, %rdi      # imm = 0x7FFFFFFFFFFFFFFF
	movq	%rcx, %rax
	xorq	%rdi, %rax
	cmpq	%rsi, %rax
	jb	.LBB17_2
# %bb.1:
	cmpq	%rsi, %rcx
	cmovaq	%rcx, %rsi
	movq	%rsi, %rax
	addq	%rcx, %rax
	cmovsq	%rdi, %rax
	addq	%rcx, %rsi
	cmovbq	%rdi, %rax
	retq
.LBB17_2:
	pushq	%rax
	movq	%rdx, %rdi
	callq	_ZSt20__throw_length_errorPKc
.Lfunc_end17:
	.size	_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc, .Lfunc_end17-_ZNKSt6vectorIhSaIhEE12_M_check_lenEmPKc
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_ # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
	.p2align	1, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%rsi, %r15
	movq	%rdi, %rbx
	movq	24(%rdi), %r14
	cmpq	$21, %r14
	movq	%rdx, (%rsp)                    # 8-byte Spill
	jb	.LBB18_2
# %bb.1:
	movq	(%r15), %r13
	jmp	.LBB18_9
.LBB18_2:
	movq	16(%rbx), %r12
	movq	(%r15), %r13
	testq	%r12, %r12
	je	.LBB18_9
# %bb.3:
	movq	8(%r15), %rbp
.LBB18_4:                               # =>This Inner Loop Header: Depth=1
	cmpq	16(%r12), %rbp
	jne	.LBB18_8
# %bb.5:                                #   in Loop: Header=BB18_4 Depth=1
	testq	%rbp, %rbp
	je	.LBB18_6
# %bb.7:                                #   in Loop: Header=BB18_4 Depth=1
	movq	8(%r12), %rsi
	movq	%r13, %rdi
	movq	%rbp, %rdx
	callq	bcmp@PLT
	testl	%eax, %eax
	je	.LBB18_6
.LBB18_8:                               #   in Loop: Header=BB18_4 Depth=1
	movq	(%r12), %r12
	testq	%r12, %r12
	jne	.LBB18_4
.LBB18_9:
	movq	8(%r15), %rsi
	movl	$3339675911, %edx               # imm = 0xC70F6907
	movq	%r13, %rdi
	callq	_ZSt11_Hash_bytesPKvmm
	movq	%rax, %r12
	xorl	%edx, %edx
	divq	8(%rbx)
	movq	%rdx, %r13
	cmpq	$21, %r14
	jb	.LBB18_12
# %bb.10:
	movq	%rbx, %rdi
	movq	%r13, %rsi
	movq	%r15, %rdx
	movq	%r12, %rcx
	callq	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE19_M_find_before_nodeEmRS7_m
	testq	%rax, %rax
	je	.LBB18_12
# %bb.11:
	movq	(%rax), %r12
.LBB18_6:
	xorl	%edx, %edx
	jmp	.LBB18_13
.LBB18_12:
	movl	$112, %edi
	callq	_Znwm
	movq	%rax, %rbp
	movq	$0, (%rax)
	leaq	8(%rax), %rdi
	movq	%r15, %rsi
	movq	(%rsp), %rdx                    # 8-byte Reload
	callq	_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_
	movl	$1, %r8d
	movq	%rbx, %rdi
	movq	%r13, %rsi
	movq	%r12, %rdx
	movq	%rbp, %rcx
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm
	movq	%rax, %r12
	movb	$1, %dl
.LBB18_13:
	movq	%r12, %rax
                                        # kill: def $dl killed $dl killed $edx
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end18:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_, .Lfunc_end18-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm
	.p2align	1, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%rcx, %rbx
	movq	%rdx, %r15
	movq	%rsi, %r12
	movq	%rdi, %r14
	addq	$32, %rdi
	movq	8(%r14), %rsi
	movq	24(%r14), %rdx
	movq	%r8, %rcx
	callq	_ZNKSt8__detail20_Prime_rehash_policy14_M_need_rehashEmmm
	testb	$1, %al
	je	.LBB19_2
# %bb.1:
	movq	%r14, %rdi
	movq	%rdx, %rsi
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
	movq	%r15, %rax
	xorl	%edx, %edx
	divq	8(%r14)
	movq	%rdx, %r12
.LBB19_2:
	movq	%r15, 104(%rbx)
	movq	%r14, %rdi
	movq	%r12, %rsi
	movq	%rbx, %rdx
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE
	incq	24(%r14)
	movq	%rbx, %rax
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
.Lfunc_end19:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm, .Lfunc_end19-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE21_M_insert_unique_nodeEmmPNSC_10_Hash_nodeISA_Lb1EEEm
                                        # -- End function
	.section	.text._ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_,"axG",@progbits,_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_,comdat
	.weak	_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_ # -- Begin function _ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_
	.p2align	1, 0x90
	.type	_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_,@function
_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_: # @_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_
# %bb.0:
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	movq	%rdx, %rbx
	movq	%rdi, %r14
	leaq	16(%rdi), %rax
	movq	%rax, (%rdi)
	movq	(%rsi), %rax
	movq	8(%rsi), %rdx
	movq	%rax, %rsi
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm
	movb	(%rbx), %al
	movb	%al, 32(%r14)
	vmovups	8(%rbx), %xmm0
	vmovups	%xmm0, 40(%r14)
	movq	24(%rbx), %rax
	movq	%rax, 56(%r14)
	xorl	%eax, %eax
	movq	%rax, 24(%rbx)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, 8(%rbx)
	vmovups	32(%rbx), %xmm1
	vmovups	%xmm1, 64(%r14)
	movq	48(%rbx), %rcx
	movq	%rcx, 80(%r14)
	movq	%rax, 48(%rbx)
	vmovups	%xmm0, 32(%rbx)
	movq	56(%rbx), %rax
	movq	%rax, 88(%r14)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
.Lfunc_end20:
	.size	_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_, .Lfunc_end20-_ZNSt4pairIKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEN3fx27WTensorEEC2IRS5_S8_Lb1EEEOT_OT0_
                                        # -- End function
	.section	.text._ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm,"axG",@progbits,_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm,comdat
	.weak	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm # -- Begin function _ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm
	.p2align	1, 0x90
	.type	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm,@function
_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm: # @_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$16, %rsp
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	%rdx, 8(%rsp)
	cmpq	$15, %rdx
	jbe	.LBB21_1
# %bb.2:
	leaq	8(%rsp), %r15
	movq	%rbx, %rdi
	movq	%r15, %rsi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
	movq	%rax, (%rbx)
	movq	(%r15), %rdx
	movq	%rdx, 16(%rbx)
	jmp	.LBB21_3
.LBB21_1:
	movq	(%rbx), %rax
.LBB21_3:
	cmpq	$-1, %rdx
	je	.LBB21_7
# %bb.4:
	testq	%rdx, %rdx
	jne	.LBB21_6
# %bb.5:
	movb	(%r14), %cl
	movb	%cl, (%rax)
	jmp	.LBB21_7
.LBB21_6:
	incq	%rdx
	movq	%rax, %rdi
	movq	%r14, %rsi
	callq	memcpy@PLT
.LBB21_7:
	movq	8(%rsp), %rax
	movq	%rax, 8(%rbx)
	addq	$16, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.Lfunc_end21:
	.size	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm, .Lfunc_end21-_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructILb1EEEvPKcm
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE
	.p2align	1, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE
# %bb.0:
	movq	%rdx, %rcx
	movq	(%rdi), %r8
	movq	(%r8,%rsi,8), %rax
	testq	%rax, %rax
	je	.LBB22_2
# %bb.1:
	movq	(%rax), %rax
	movq	%rax, (%rcx)
	movq	(%r8,%rsi,8), %rax
	movq	%rcx, (%rax)
	retq
.LBB22_2:
	leaq	16(%rdi), %r9
	movq	16(%rdi), %rax
	movq	%rax, (%rcx)
	movq	%rcx, 16(%rdi)
	movq	(%rcx), %rax
	testq	%rax, %rax
	je	.LBB22_4
# %bb.3:
	movq	104(%rax), %rax
	xorl	%edx, %edx
	divq	8(%rdi)
	movq	%rcx, (%r8,%rdx,8)
	movq	(%rdi), %r8
.LBB22_4:
	movq	%r9, (%r8,%rsi,8)
	retq
.Lfunc_end22:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE, .Lfunc_end22-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE22_M_insert_bucket_beginEmPNSC_10_Hash_nodeISA_Lb1EEE
                                        # -- End function
	.section	.text._ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm,"axG",@progbits,_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm,comdat
	.weak	_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm # -- Begin function _ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm
	.p2align	1, 0x90
	.type	_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm,@function
_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm: # @_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm
# %bb.0:
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	movq	%rsi, %rbx
	movq	%rdi, %r14
	testq	%rsi, %rsi
	je	.LBB23_1
# %bb.2:
	js	.LBB23_5
# %bb.3:
	movq	%rbx, %rdi
	callq	_Znwm
	jmp	.LBB23_4
.LBB23_1:
	xorl	%eax, %eax
.LBB23_4:
	movq	%rax, (%r14)
	movq	%rax, 8(%r14)
	addq	%rax, %rbx
	movq	%rbx, 16(%r14)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
.LBB23_5:
	callq	_ZSt17__throw_bad_allocv
.Lfunc_end23:
	.size	_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm, .Lfunc_end23-_ZNSt12_Vector_baseIhSaIhEE17_M_create_storageEm
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"rb"
	.size	.L.str, 3

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"cannot open %s"
	.size	.L.str.1, 15

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"%s: too small"
	.size	.L.str.2, 14

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	"%s: short read"
	.size	.L.str.3, 15

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"%s: bad magic"
	.size	.L.str.6, 14

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"%s: absurd name length %u"
	.size	.L.str.7, 26

	.type	.L.str.8,@object                # @.str.8
.L.str.8:
	.asciz	"%s: %s: absurd ndim %u"
	.size	.L.str.8, 23

	.type	.L.str.9,@object                # @.str.9
.L.str.9:
	.asciz	"%s: duplicate tensor %s"
	.size	.L.str.9, 24

	.type	.L.str.10,@object               # @.str.10
.L.str.10:
	.asciz	"%s: %zu trailing bytes after last tensor"
	.size	.L.str.10, 41

	.type	.L.str.11,@object               # @.str.11
.L.str.11:
	.asciz	"weights_io_compressed: "
	.size	.L.str.11, 24

	.type	.L.str.13,@object               # @.str.13
.L.str.13:
	.asciz	"%s: %s: ENC_INTC on dtype %u"
	.size	.L.str.13, 29

	.type	.L.str.14,@object               # @.str.14
.L.str.14:
	.asciz	"%s: %s: bad ENC_INTC width"
	.size	.L.str.14, 27

	.type	.L.str.15,@object               # @.str.15
.L.str.15:
	.asciz	"%s: %s: ENC_INT4 on dtype %u"
	.size	.L.str.15, 29

	.type	.L.str.16,@object               # @.str.16
.L.str.16:
	.asciz	"%s: %s: ENC_BF16 on dtype %u"
	.size	.L.str.16, 29

	.type	.L.str.17,@object               # @.str.17
.L.str.17:
	.asciz	"%s: %s: ENC_PLANE4 on dtype %u"
	.size	.L.str.17, 31

	.type	.L.str.18,@object               # @.str.18
.L.str.18:
	.asciz	"%s: %s: bad rope tensor"
	.size	.L.str.18, 24

	.type	.L.str.19,@object               # @.str.19
.L.str.19:
	.asciz	"rope.inv_freq"
	.size	.L.str.19, 14

	.type	.L.str.20,@object               # @.str.20
.L.str.20:
	.asciz	"%s: %s: rope.inv_freq not decoded yet"
	.size	.L.str.20, 38

	.type	.L.str.21,@object               # @.str.21
.L.str.21:
	.asciz	"%s: %s: rope.inv_freq mismatch"
	.size	.L.str.21, 31

	.type	.L.str.22,@object               # @.str.22
.L.str.22:
	.asciz	"%s: %s: unknown encoding %u"
	.size	.L.str.22, 28

	.type	.L.str.23,@object               # @.str.23
.L.str.23:
	.asciz	"cannot create std::vector larger than max_size()"
	.size	.L.str.23, 49

	.type	_ZN3fx212_GLOBAL__N_19kI2OverPiE,@object # @_ZN3fx212_GLOBAL__N_19kI2OverPiE
	.section	.rodata._ZN3fx212_GLOBAL__N_19kI2OverPiE,"a",@progbits
	.p2align	4, 0x0
_ZN3fx212_GLOBAL__N_19kI2OverPiE:
	.long	1011060801                      # 0x3c439041
	.long	3680671129                      # 0xdb629599
	.long	4113882560                      # 0xf534ddc0
	.long	4230436817                      # 0xfc2757d1
	.long	1313084713                      # 0x4e441529
	.long	2734261102                      # 0xa2f9836e
	.size	_ZN3fx212_GLOBAL__N_19kI2OverPiE, 24

	.type	.L.str.25,@object               # @.str.25
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.25:
	.asciz	"unknown dtype code %u"
	.size	.L.str.25, 22

	.type	.L.str.26,@object               # @.str.26
.L.str.26:
	.asciz	"%s: truncated file (need %zu more bytes)"
	.size	.L.str.26, 41

	.type	.L.str.27,@object               # @.str.27
.L.str.27:
	.asciz	"vector::_M_default_append"
	.size	.L.str.27, 26

	.type	.Lswitch.table._ZN3fx212_GLOBAL__N_110dtype_sizeEh,@object # @switch.table._ZN3fx212_GLOBAL__N_110dtype_sizeEh
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	3, 0x0
.Lswitch.table._ZN3fx212_GLOBAL__N_110dtype_sizeEh:
	.quad	1                               # 0x1
	.quad	2                               # 0x2
	.quad	4                               # 0x4
	.quad	4                               # 0x4
	.size	.Lswitch.table._ZN3fx212_GLOBAL__N_110dtype_sizeEh, 32

	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
