	.text
	.file	"weights_io.cpp"
	.section	.text._ZN3fx211WeightsFile4loadEPKc,"ax",@progbits
	.globl	_ZN3fx211WeightsFile4loadEPKc   # -- Begin function _ZN3fx211WeightsFile4loadEPKc
	.p2align	4, 0x90
	.type	_ZN3fx211WeightsFile4loadEPKc,@function
_ZN3fx211WeightsFile4loadEPKc:          # @_ZN3fx211WeightsFile4loadEPKc
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$152, %rsp
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	$.L.str, %esi
	movq	%r14, %rdi
	callq	fopen
	testq	%rax, %rax
	je	.LBB0_1
# %bb.3:
	movq	%rax, %rbx
	movq	%rax, %rdi
	xorl	%esi, %esi
	movl	$2, %edx
	callq	fseek
	movq	%rbx, %rdi
	callq	ftell
	movq	%rax, %r12
	movq	%rbx, %rdi
	xorl	%esi, %esi
	xorl	%edx, %edx
	callq	fseek
	cmpq	$11, %r12
	jle	.LBB0_4
# %bb.5:
	movq	%r12, %rdi
	callq	_Znwm
	movq	%rax, %r13
	movb	$0, (%rax)
	leaq	1(%rax), %rdi
	leaq	-1(%r12), %rdx
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$1, %esi
	movq	%r13, %rdi
	movq	%r12, %rdx
	movq	%rbx, %rcx
	callq	fread
	cmpq	%r12, %rax
	jne	.LBB0_6
# %bb.7:
	movq	%rbx, %rdi
	callq	fclose
	movabsq	$3544428866312493126, %rax      # imm = 0x3130574654325846
	cmpq	%rax, (%r13)
	jne	.LBB0_8
# %bb.9:
	movq	%r12, %rax
	andq	$-4, %rax
	cmpq	$8, %rax
	je	.LBB0_88
# %bb.10:
	movl	8(%r13), %ebp
	leaq	48(%r15), %rax
	movq	%rax, (%r15)
	movq	$1, 8(%r15)
	leaq	32(%r15), %rdi
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, 16(%r15)
	movl	$1065353216, 32(%r15)           # imm = 0x3F800000
	vmovups	%xmm0, 40(%r15)
	cmpl	$1, %ebp
	movl	%ebp, %esi
	adcl	$0, %esi
	callq	_ZNKSt8__detail20_Prime_rehash_policy11_M_next_bktEm
	cmpq	8(%r15), %rax
	jne	.LBB0_11
# %bb.12:
	leaq	40(%r15), %rax
	movq	$0, (%rax)
	jmp	.LBB0_13
.LBB0_11:
	movq	%r15, %rdi
	movq	%rax, %rsi
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
.LBB0_13:
	movq	%r14, 8(%rsp)                   # 8-byte Spill
	addq	$-12, %r12
	testl	%ebp, %ebp
	movq	%r13, 128(%rsp)                 # 8-byte Spill
	je	.LBB0_86
# %bb.14:
	addq	$12, %r13
	leaq	48(%rsp), %r14
	movq	%r15, 144(%rsp)                 # 8-byte Spill
	jmp	.LBB0_15
	.p2align	4, 0x90
.LBB0_85:                               #   in Loop: Header=BB0_15 Depth=1
	addq	%rbx, %r13
	decl	%ebp
	je	.LBB0_86
.LBB0_15:                               # =>This Inner Loop Header: Depth=1
	cmpq	$3, %r12
	jbe	.LBB0_16
# %bb.18:                               #   in Loop: Header=BB0_15 Depth=1
	movl	(%r13), %ebx
	cmpq	$4097, %rbx                     # imm = 0x1001
	jae	.LBB0_89
# %bb.19:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$-4, %r12
	movq	%r14, 32(%rsp)
	leaq	32(%rsp), %rdi
	movq	%rbx, %rsi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_M_constructEmc
	cmpq	%rbx, %r12
	jb	.LBB0_90
# %bb.20:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$4, %r13
	movq	32(%rsp), %rdi
	movq	%r13, %rsi
	movq	%rbx, %rdx
	callq	memcpy@PLT
	movb	$0, 64(%rsp)
	leaq	72(%rsp), %rax
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 24(%rax)
	vmovups	%ymm0, (%rax)
	cmpq	%rbx, %r12
	je	.LBB0_21
# %bb.22:                               #   in Loop: Header=BB0_15 Depth=1
	movzbl	(%r13,%rbx), %esi
	movb	%sil, 64(%rsp)
	cmpl	$4, %esi
	jae	.LBB0_91
# %bb.23:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%rbx, %rax
	notq	%rax
	addq	%rax, %r12
	cmpq	$3, %r12
	jbe	.LBB0_16
# %bb.24:                               #   in Loop: Header=BB0_15 Depth=1
	addq	%rbx, %r13
	movl	1(%r13), %ebx
	cmpq	$9, %rbx
	jae	.LBB0_92
# %bb.25:                               #   in Loop: Header=BB0_15 Depth=1
	testq	%rbx, %rbx
	je	.LBB0_26
# %bb.56:                               #   in Loop: Header=BB0_15 Depth=1
	leaq	72(%rsp), %rdi
	movq	%rbx, %rsi
	vzeroupper
	callq	_ZNSt6vectorIjSaIjEE17_M_default_appendEm
	movq	%r12, %rax
	andq	$-4, %rax
	cmpq	$4, %rax
	je	.LBB0_16
# %bb.57:                               #   in Loop: Header=BB0_15 Depth=1
	movq	72(%rsp), %rax
	movl	5(%r13), %r8d
	movl	%r8d, (%rax)
	leaq	-8(%r12), %rcx
	cmpl	$1, %ebx
	jne	.LBB0_59
# %bb.58:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$9, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
	.p2align	4, 0x90
.LBB0_26:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$5, %r13
	addq	$-4, %r12
	movl	$1, %r8d
	jmp	.LBB0_27
	.p2align	4, 0x90
.LBB0_59:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.60:                               #   in Loop: Header=BB0_15 Depth=1
	movl	9(%r13), %ecx
	movl	%ecx, 4(%rax)
	imulq	%rcx, %r8
	leaq	-12(%r12), %rcx
	cmpl	$2, %ebx
	jne	.LBB0_62
# %bb.61:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$13, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
.LBB0_62:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.63:                               #   in Loop: Header=BB0_15 Depth=1
	movl	13(%r13), %ecx
	movl	%ecx, 8(%rax)
	imulq	%rcx, %r8
	leaq	-16(%r12), %rcx
	cmpl	$3, %ebx
	jne	.LBB0_65
# %bb.64:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$17, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
.LBB0_65:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.66:                               #   in Loop: Header=BB0_15 Depth=1
	movl	17(%r13), %ecx
	movl	%ecx, 12(%rax)
	imulq	%rcx, %r8
	leaq	-20(%r12), %rcx
	cmpl	$4, %ebx
	jne	.LBB0_68
# %bb.67:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$21, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
.LBB0_68:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.69:                               #   in Loop: Header=BB0_15 Depth=1
	movl	21(%r13), %ecx
	movl	%ecx, 16(%rax)
	imulq	%rcx, %r8
	leaq	-24(%r12), %rcx
	cmpl	$5, %ebx
	jne	.LBB0_71
# %bb.70:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$25, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
.LBB0_71:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.72:                               #   in Loop: Header=BB0_15 Depth=1
	movl	25(%r13), %ecx
	movl	%ecx, 20(%rax)
	imulq	%rcx, %r8
	leaq	-28(%r12), %rcx
	cmpl	$6, %ebx
	jne	.LBB0_74
# %bb.73:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$29, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
.LBB0_74:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.75:                               #   in Loop: Header=BB0_15 Depth=1
	movl	29(%r13), %ecx
	movl	%ecx, 24(%rax)
	imulq	%rcx, %r8
	leaq	-32(%r12), %rcx
	cmpl	$7, %ebx
	jne	.LBB0_77
# %bb.76:                               #   in Loop: Header=BB0_15 Depth=1
	addq	$33, %r13
	movq	%rcx, %r12
	jmp	.LBB0_27
.LBB0_77:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	$4, %rcx
	jb	.LBB0_16
# %bb.78:                               #   in Loop: Header=BB0_15 Depth=1
	movl	33(%r13), %ecx
	addq	$37, %r13
	movl	%ecx, 28(%rax)
	imulq	%rcx, %r8
	addq	$-36, %r12
	.p2align	4, 0x90
.LBB0_27:                               #   in Loop: Header=BB0_15 Depth=1
	movl	%ebp, 28(%rsp)                  # 4-byte Spill
	movq	%r8, 120(%rsp)
	movzbl	64(%rsp), %esi
	cmpl	$4, %esi
	jae	.LBB0_93
# %bb.28:                               #   in Loop: Header=BB0_15 Depth=1
	movsbq	%sil, %rax
	imulq	.Lswitch.table._ZN3fx211WeightsFile4loadEPKc(,%rax,8), %r8
	movq	96(%rsp), %rbx
	movq	104(%rsp), %rbp
	movq	%rbp, %r14
	subq	%rbx, %r14
	movq	%r8, %r15
	subq	%r14, %r15
	jbe	.LBB0_50
# %bb.29:                               #   in Loop: Header=BB0_15 Depth=1
	movq	112(%rsp), %rax
	subq	%rbp, %rax
	cmpq	%r15, %rax
	jae	.LBB0_30
# %bb.33:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%r14, %rax
	movabsq	$9223372036854775807, %rcx      # imm = 0x7FFFFFFFFFFFFFFF
	xorq	%rcx, %rax
	cmpq	%r15, %rax
	jb	.LBB0_94
# %bb.34:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%r14, %rax
	cmpq	%r15, %r14
	jbe	.LBB0_35
# %bb.36:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%rax, %rdx
	addq	%r14, %rdx
	jns	.LBB0_37
.LBB0_38:                               #   in Loop: Header=BB0_15 Depth=1
	movabsq	$9223372036854775807, %rdi      # imm = 0x7FFFFFFFFFFFFFFF
	addq	%r14, %rax
	jae	.LBB0_39
.LBB0_40:                               #   in Loop: Header=BB0_15 Depth=1
	testq	%rdi, %rdi
	movq	%rdi, 136(%rsp)                 # 8-byte Spill
	je	.LBB0_41
.LBB0_42:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%r8, 16(%rsp)                   # 8-byte Spill
	vzeroupper
	callq	_Znwm
	movq	16(%rsp), %r8                   # 8-byte Reload
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movb	$0, (%rax,%r14)
	decq	%r15
	je	.LBB0_45
.LBB0_44:                               #   in Loop: Header=BB0_15 Depth=1
	movq	16(%rsp), %rax                  # 8-byte Reload
	leaq	(%rax,%r14), %rdi
	incq	%rdi
	xorl	%esi, %esi
	movq	%r15, %rdx
	movq	%r8, %r15
	vzeroupper
	callq	memset@PLT
	movq	%r15, %r8
.LBB0_45:                               #   in Loop: Header=BB0_15 Depth=1
	cmpq	%rbx, %rbp
	je	.LBB0_47
# %bb.46:                               #   in Loop: Header=BB0_15 Depth=1
	movq	16(%rsp), %rdi                  # 8-byte Reload
	movq	%rbx, %rsi
	movq	%r14, %rdx
	movq	%r8, %r14
	vzeroupper
	callq	memcpy@PLT
	movq	%r14, %r8
.LBB0_47:                               #   in Loop: Header=BB0_15 Depth=1
	testq	%rbx, %rbx
	je	.LBB0_49
# %bb.48:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%rbx, %rdi
	movq	%r8, %rbx
	vzeroupper
	callq	_ZdlPv
	movq	%rbx, %r8
.LBB0_49:                               #   in Loop: Header=BB0_15 Depth=1
	movq	16(%rsp), %rcx                  # 8-byte Reload
	movq	%rcx, 96(%rsp)
	leaq	(%rcx,%r8), %rax
	movq	%rax, 104(%rsp)
	movq	136(%rsp), %rax                 # 8-byte Reload
	addq	%rcx, %rax
	movq	%rax, 112(%rsp)
	leaq	48(%rsp), %r14
	jmp	.LBB0_53
	.p2align	4, 0x90
.LBB0_50:                               #   in Loop: Header=BB0_15 Depth=1
	leaq	48(%rsp), %r14
	jae	.LBB0_53
# %bb.51:                               #   in Loop: Header=BB0_15 Depth=1
	addq	%r8, %rbx
	cmpq	%rbx, %rbp
	je	.LBB0_53
# %bb.52:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%rbx, 104(%rsp)
	jmp	.LBB0_53
	.p2align	4, 0x90
.LBB0_30:                               #   in Loop: Header=BB0_15 Depth=1
	movb	$0, (%rbp)
	leaq	1(%rbp), %rdi
	movq	%r15, %rdx
	decq	%rdx
	je	.LBB0_32
# %bb.31:                               #   in Loop: Header=BB0_15 Depth=1
	addq	%r15, %rbp
	xorl	%esi, %esi
	movq	%r8, %rbx
	vzeroupper
	callq	memset@PLT
	movq	%rbx, %r8
	movq	%rbp, %rdi
.LBB0_32:                               #   in Loop: Header=BB0_15 Depth=1
	leaq	48(%rsp), %r14
	movq	%rdi, 104(%rsp)
.LBB0_53:                               #   in Loop: Header=BB0_15 Depth=1
	subq	%r8, %r12
	jb	.LBB0_95
# %bb.54:                               #   in Loop: Header=BB0_15 Depth=1
	movq	96(%rsp), %rdi
	movq	%r13, %rsi
	movq	%r8, %rbx
	movq	%r8, %rdx
	vzeroupper
	callq	memcpy@PLT
	movq	144(%rsp), %r15                 # 8-byte Reload
	movq	%r15, %rdi
	leaq	32(%rsp), %rsi
	leaq	64(%rsp), %rdx
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
	testb	$1, %dl
	movl	28(%rsp), %ebp                  # 4-byte Reload
	je	.LBB0_55
# %bb.79:                               #   in Loop: Header=BB0_15 Depth=1
	movq	96(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_81
# %bb.80:                               #   in Loop: Header=BB0_15 Depth=1
	callq	_ZdlPv
.LBB0_81:                               #   in Loop: Header=BB0_15 Depth=1
	movq	72(%rsp), %rdi
	testq	%rdi, %rdi
	je	.LBB0_83
# %bb.82:                               #   in Loop: Header=BB0_15 Depth=1
	callq	_ZdlPv
.LBB0_83:                               #   in Loop: Header=BB0_15 Depth=1
	movq	32(%rsp), %rdi
	cmpq	%r14, %rdi
	je	.LBB0_85
# %bb.84:                               #   in Loop: Header=BB0_15 Depth=1
	callq	_ZdlPv
	jmp	.LBB0_85
.LBB0_35:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%r15, %rax
	movq	%rax, %rdx
	addq	%r14, %rdx
	js	.LBB0_38
.LBB0_37:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%rdx, %rcx
	movabsq	$9223372036854775807, %rdi      # imm = 0x7FFFFFFFFFFFFFFF
	addq	%r14, %rax
	jb	.LBB0_40
.LBB0_39:                               #   in Loop: Header=BB0_15 Depth=1
	movq	%rcx, %rdi
	testq	%rdi, %rdi
	movq	%rdi, 136(%rsp)                 # 8-byte Spill
	jne	.LBB0_42
.LBB0_41:                               #   in Loop: Header=BB0_15 Depth=1
	xorl	%eax, %eax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	movb	$0, (%rax,%r14)
	decq	%r15
	jne	.LBB0_44
	jmp	.LBB0_45
.LBB0_86:
	testq	%r12, %r12
	jne	.LBB0_96
# %bb.87:
	movq	128(%rsp), %rdi                 # 8-byte Reload
	callq	_ZdlPv
	movq	%r15, %rax
	addq	$152, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB0_16:
	movl	$.L.str.16, %edi
	movl	$4, %edx
	movq	8(%rsp), %rsi                   # 8-byte Reload
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_89:
	movl	$.L.str.6, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movl	%ebx, %edx
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_90:
	movl	$.L.str.16, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movq	%rbx, %rdx
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_21:
	movl	$.L.str.16, %edi
	movl	$1, %edx
	movq	8(%rsp), %rsi                   # 8-byte Reload
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_91:
	movl	$.L.str.17, %edi
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_92:
	movq	32(%rsp), %rdx
	movl	$.L.str.7, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movl	%ebx, %ecx
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_93:
	movl	$.L.str.17, %edi
                                        # kill: def $esi killed $esi killed $rsi
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_95:
	movl	$.L.str.16, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movq	%r8, %rdx
	xorl	%eax, %eax
	vzeroupper
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_55:
	movq	32(%rsp), %rdx
	movl	$.L.str.8, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_94:
	movl	$.L.str.19, %edi
	vzeroupper
	callq	_ZSt20__throw_length_errorPKc
.LBB0_1:
	movl	$.L.str.1, %edi
	movq	%r14, %rsi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_4:
	movl	$.L.str.2, %edi
	movq	%r14, %rsi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_6:
	movl	$.L.str.3, %edi
	movq	%r14, %rsi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_8:
	movl	$.L.str.5, %edi
	movq	%r14, %rsi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_88:
	movl	$.L.str.16, %edi
	movl	$4, %edx
	movq	%r14, %rsi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB0_96:
	movl	$.L.str.9, %edi
	movq	8(%rsp), %rsi                   # 8-byte Reload
	movq	%r12, %rdx
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.Lfunc_end0:
	.size	_ZN3fx211WeightsFile4loadEPKc, .Lfunc_end0-_ZN3fx211WeightsFile4loadEPKc
                                        # -- End function
	.section	.text._ZN3fx212_GLOBAL__N_13dieEPKcz,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx212_GLOBAL__N_13dieEPKcz
	.type	_ZN3fx212_GLOBAL__N_13dieEPKcz,@function
_ZN3fx212_GLOBAL__N_13dieEPKcz:         # @_ZN3fx212_GLOBAL__N_13dieEPKcz
# %bb.0:
	pushq	%rbx
	subq	$208, %rsp
	movq	%rdi, %rbx
	movq	%rsi, 40(%rsp)
	movq	%rdx, 48(%rsp)
	movq	%rcx, 56(%rsp)
	movq	%r8, 64(%rsp)
	movq	%r9, 72(%rsp)
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
	leaq	32(%rsp), %rax
	movq	%rax, 16(%rsp)
	leaq	224(%rsp), %rax
	movq	%rax, 8(%rsp)
	movabsq	$206158430216, %rax             # imm = 0x3000000008
	movq	%rax, (%rsp)
	movq	stderr(%rip), %rcx
	movl	$.L.str.14, %edi
	movl	$12, %esi
	movl	$1, %edx
	callq	fwrite@PLT
	movq	stderr(%rip), %rdi
	movq	%rsp, %rdx
	movq	%rbx, %rsi
	callq	vfprintf
	movq	stderr(%rip), %rsi
	movl	$10, %edi
	callq	fputc@PLT
	movl	$1, %edi
	callq	exit
.Lfunc_end1:
	.size	_ZN3fx212_GLOBAL__N_13dieEPKcz, .Lfunc_end1-_ZN3fx212_GLOBAL__N_13dieEPKcz
                                        # -- End function
	.section	.text._ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,"ax",@progbits
	.globl	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE # -- Begin function _ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.p2align	4, 0x90
	.type	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,@function
_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE: # @_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
# %bb.0:
	pushq	%rbx
	subq	$32, %rsp
	movq	%rsi, %rbx
	movq	%rdi, %rsi
	leaq	8(%rsp), %rdi
	movq	%rbx, %rdx
	callq	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_
	movq	8(%rsp), %rax
	testq	%rax, %rax
	je	.LBB2_3
# %bb.1:
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB2_3
# %bb.2:
	addq	$40, %rax
	addq	$32, %rsp
	popq	%rbx
	retq
.LBB2_3:
	movq	(%rbx), %rsi
	movl	$.L.str.10, %edi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.Lfunc_end2:
	.size	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, .Lfunc_end2-_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
                                        # -- End function
	.section	.text._ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE,"ax",@progbits
	.globl	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE # -- Begin function _ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
	.p2align	4, 0x90
	.type	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE,@function
_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE: # @_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	subq	$24, %rsp
	movq	%r8, %rbx
	movq	%rcx, %r15
	movl	%edx, %ebp
	movq	%rsi, %r14
	movq	%rdi, %rsi
	movq	%rsp, %rdi
	movq	%r14, %rdx
	callq	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_
	movq	(%rsp), %rax
	testq	%rax, %rax
	je	.LBB3_9
# %bb.1:
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB3_9
# %bb.2:
	movzbl	40(%rax), %edx
	cmpb	%bpl, %dl
	jne	.LBB3_10
# %bb.3:
	movq	48(%rax), %rsi
	movq	56(%rax), %rdx
	subq	%rsi, %rdx
	shrq	$2, %rdx
	cmpq	%rbx, %rdx
	jne	.LBB3_11
# %bb.4:
	testq	%rbx, %rbx
	je	.LBB3_8
# %bb.5:
	shlq	$2, %rbx
	xorl	%edx, %edx
	.p2align	4, 0x90
.LBB3_6:                                # =>This Inner Loop Header: Depth=1
	movl	(%r15,%rdx,4), %r8d
	movl	(%rsi,%rdx,4), %ecx
	cmpl	%r8d, %ecx
	jne	.LBB3_12
# %bb.7:                                #   in Loop: Header=BB3_6 Depth=1
	incq	%rdx
	addq	$-4, %rbx
	jne	.LBB3_6
.LBB3_8:
	addq	$40, %rax
	addq	$24, %rsp
	popq	%rbx
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB3_12:
	movq	(%r14), %rsi
	movl	$.L.str.13, %edi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB3_9:
	movq	(%r14), %rsi
	movl	$.L.str.10, %edi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB3_10:
	movzbl	%bpl, %ecx
	movq	(%r14), %rsi
	movl	$.L.str.11, %edi
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.LBB3_11:
	movq	(%r14), %rsi
	movl	$.L.str.12, %edi
	movq	%rbx, %rcx
	xorl	%eax, %eax
	callq	_ZN3fx212_GLOBAL__N_13dieEPKcz
.Lfunc_end3:
	.size	_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE, .Lfunc_end3-_ZNK3fx211WeightsFile3getERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEhSt16initializer_listIjE
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
	.p2align	4, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movq	%rsi, %rbx
	movq	%rdi, %r14
	cmpq	$1, %rsi
	je	.LBB4_1
# %bb.2:
	movq	%rbx, %rax
	shrq	$60, %rax
	jne	.LBB4_3
# %bb.5:
	leaq	(,%rbx,8), %r12
	movq	%r12, %rdi
	callq	_Znwm
	movq	%rax, %r15
	movq	%rax, %rdi
	xorl	%esi, %esi
	movq	%r12, %rdx
	callq	memset@PLT
	movq	16(%r14), %rsi
	movq	$0, 16(%r14)
	testq	%rsi, %rsi
	je	.LBB4_17
.LBB4_7:
	leaq	16(%r14), %rcx
	xorl	%r8d, %r8d
	jmp	.LBB4_8
	.p2align	4, 0x90
.LBB4_14:                               #   in Loop: Header=BB4_8 Depth=1
	movq	(%rax), %rax
	movq	%rax, (%rsi)
	movq	(%r15,%rdx,8), %rax
	movq	%r8, %rdx
.LBB4_15:                               #   in Loop: Header=BB4_8 Depth=1
	movq	%rsi, (%rax)
.LBB4_16:                               #   in Loop: Header=BB4_8 Depth=1
	movq	%rdi, %rsi
	movq	%rdx, %r8
	testq	%rdi, %rdi
	je	.LBB4_17
.LBB4_8:                                # =>This Inner Loop Header: Depth=1
	movq	(%rsi), %rdi
	movq	104(%rsi), %rax
	movq	%rax, %rdx
	orq	%rbx, %rdx
	shrq	$32, %rdx
	je	.LBB4_9
# %bb.10:                               #   in Loop: Header=BB4_8 Depth=1
	xorl	%edx, %edx
	divq	%rbx
	movq	(%r15,%rdx,8), %rax
	testq	%rax, %rax
	jne	.LBB4_14
	jmp	.LBB4_12
	.p2align	4, 0x90
.LBB4_9:                                #   in Loop: Header=BB4_8 Depth=1
                                        # kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%ebx
                                        # kill: def $edx killed $edx def $rdx
	movq	(%r15,%rdx,8), %rax
	testq	%rax, %rax
	jne	.LBB4_14
.LBB4_12:                               #   in Loop: Header=BB4_8 Depth=1
	movq	(%rcx), %rax
	movq	%rax, (%rsi)
	movq	%rsi, (%rcx)
	movq	%rcx, (%r15,%rdx,8)
	cmpq	$0, (%rsi)
	je	.LBB4_16
# %bb.13:                               #   in Loop: Header=BB4_8 Depth=1
	leaq	(%r15,%r8,8), %rax
	jmp	.LBB4_15
.LBB4_1:
	leaq	48(%r14), %r15
	movq	$0, 48(%r14)
	movq	16(%r14), %rsi
	movq	$0, 16(%r14)
	testq	%rsi, %rsi
	jne	.LBB4_7
.LBB4_17:
	movq	(%r14), %rdi
	leaq	48(%r14), %rax
	cmpq	%rdi, %rax
	je	.LBB4_19
# %bb.18:
	callq	_ZdlPv
.LBB4_19:
	movq	%rbx, 8(%r14)
	movq	%r15, (%r14)
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
.LBB4_3:
	shrq	$61, %rbx
	je	.LBB4_4
# %bb.20:
	callq	_ZSt28__throw_bad_array_new_lengthv
.LBB4_4:
	callq	_ZSt17__throw_bad_allocv
.Lfunc_end4:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE, .Lfunc_end4-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
                                        # -- End function
	.section	.text._ZNSt6vectorIjSaIjEE17_M_default_appendEm,"axG",@progbits,_ZNSt6vectorIjSaIjEE17_M_default_appendEm,comdat
	.weak	_ZNSt6vectorIjSaIjEE17_M_default_appendEm # -- Begin function _ZNSt6vectorIjSaIjEE17_M_default_appendEm
	.p2align	4, 0x90
	.type	_ZNSt6vectorIjSaIjEE17_M_default_appendEm,@function
_ZNSt6vectorIjSaIjEE17_M_default_appendEm: # @_ZNSt6vectorIjSaIjEE17_M_default_appendEm
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	testq	%rsi, %rsi
	je	.LBB5_16
# %bb.1:
	movq	%rsi, %r14
	movq	%rdi, %rbx
	movq	8(%rdi), %rbp
	movq	16(%rdi), %rax
	subq	%rbp, %rax
	sarq	$2, %rax
	cmpq	%rsi, %rax
	jae	.LBB5_2
# %bb.5:
	movabsq	$2305843009213693951, %rax      # imm = 0x1FFFFFFFFFFFFFFF
	movq	(%rbx), %rcx
	movq	%rbp, %rdx
	movq	%rcx, 16(%rsp)                  # 8-byte Spill
	subq	%rcx, %rdx
	movq	%rdx, %r15
	shrq	$2, %r15
	movq	%r15, %rcx
	xorq	%rax, %rcx
	cmpq	%r14, %rcx
	jb	.LBB5_17
# %bb.6:
	movq	%rdx, 8(%rsp)                   # 8-byte Spill
	cmpq	%r14, %r15
	movq	%r14, %rcx
	cmovaq	%r15, %rcx
	leaq	(%rcx,%r15), %r12
	cmpq	%rax, %r12
	cmovaq	%rax, %r12
	addq	%r15, %rcx
	cmovbq	%rax, %r12
	testq	%r12, %r12
	je	.LBB5_7
# %bb.8:
	leaq	(,%r12,4), %rdi
	callq	_Znwm
	movq	%rax, %r13
	jmp	.LBB5_9
.LBB5_2:
	movl	$0, (%rbp)
	leaq	4(%rbp), %rdi
	cmpq	$1, %r14
	je	.LBB5_4
# %bb.3:
	leaq	-4(,%r14,4), %rdx
	xorl	%esi, %esi
	callq	memset@PLT
	leaq	(,%r14,4), %rdi
	addq	%rbp, %rdi
.LBB5_4:
	movq	%rdi, 8(%rbx)
	jmp	.LBB5_16
.LBB5_7:
	xorl	%r13d, %r13d
.LBB5_9:
	leaq	(,%r15,4), %rax
	addq	%r13, %rax
	movq	%rax, (%rsp)                    # 8-byte Spill
	movl	$0, (%r13,%r15,4)
	cmpq	$1, %r14
	je	.LBB5_11
# %bb.10:
	movq	(%rsp), %rax                    # 8-byte Reload
	leaq	4(%rax), %rdi
	leaq	-4(,%r14,4), %rdx
	xorl	%esi, %esi
	callq	memset@PLT
.LBB5_11:
	movq	16(%rsp), %r15                  # 8-byte Reload
	cmpq	%r15, %rbp
	je	.LBB5_13
# %bb.12:
	movq	%r13, %rdi
	movq	%r15, %rsi
	movq	8(%rsp), %rdx                   # 8-byte Reload
	callq	memcpy@PLT
.LBB5_13:
	testq	%r15, %r15
	je	.LBB5_15
# %bb.14:
	movq	%r15, %rdi
	callq	_ZdlPv
.LBB5_15:
	movq	%r13, (%rbx)
	movq	(%rsp), %rax                    # 8-byte Reload
	leaq	(%rax,%r14,4), %rax
	movq	%rax, 8(%rbx)
	leaq	(,%r12,4), %rax
	addq	%r13, %rax
	movq	%rax, 16(%rbx)
.LBB5_16:
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.LBB5_17:
	movl	$.L.str.19, %edi
	callq	_ZSt20__throw_length_errorPKc
.Lfunc_end5:
	.size	_ZNSt6vectorIjSaIjEE17_M_default_appendEm, .Lfunc_end5-_ZNSt6vectorIjSaIjEE17_M_default_appendEm
                                        # -- End function
	.section	.text._ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_,"axG",@progbits,_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_,comdat
	.weak	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_ # -- Begin function _ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
	.p2align	4, 0x90
	.type	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_,@function
_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_: # @_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdx, %r13
	movq	%rsi, %r12
	movq	%rdi, %rbx
	leaq	8(%rsp), %rdi
	movq	%rbx, %rsi
	movq	%r12, %rdx
	callq	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_
	movq	8(%rsp), %rax
	testq	%rax, %rax
	je	.LBB6_2
# %bb.1:
	movq	(%rax), %r14
	xorl	%edx, %edx
	jmp	.LBB6_21
.LBB6_2:
	movq	16(%rsp), %rax
	movq	%rax, (%rsp)                    # 8-byte Spill
	movq	24(%rsp), %rbp
	movl	$112, %edi
	callq	_Znwm
	movq	%rax, %r14
	movq	$0, (%rax)
	leaq	24(%rax), %r15
	movq	%r15, 8(%rax)
	movq	(%r12), %rsi
	movq	8(%r12), %rdx
	movq	%rdx, 8(%rsp)
	cmpq	$16, %rdx
	jb	.LBB6_4
# %bb.3:
	leaq	8(%r14), %r12
	movq	%rsi, 32(%rsp)                  # 8-byte Spill
	leaq	8(%rsp), %rsi
	movq	%r12, %rdi
	xorl	%edx, %edx
	callq	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
	movq	32(%rsp), %rsi                  # 8-byte Reload
	movq	%rax, (%r12)
	movq	8(%rsp), %rdx
	movq	%rdx, (%r15)
	movq	%rax, %r15
.LBB6_4:
	movq	%rbp, %r12
	movq	(%rsp), %rbp                    # 8-byte Reload
	cmpq	$-1, %rdx
	je	.LBB6_8
# %bb.5:
	testq	%rdx, %rdx
	jne	.LBB6_7
# %bb.6:
	movzbl	(%rsi), %eax
	movb	%al, (%r15)
	jmp	.LBB6_8
.LBB6_7:
	incq	%rdx
	movq	%r15, %rdi
	callq	memcpy@PLT
.LBB6_8:
	movq	8(%rsp), %rax
	movq	%rax, 16(%r14)
	movzbl	(%r13), %eax
	movb	%al, 40(%r14)
	vxorps	%xmm0, %xmm0, %xmm0
	vbroadcastsd	24(%r13), %ymm1
	vblendps	$207, 8(%r13), %ymm1, %ymm1     # ymm1 = mem[0,1,2,3],ymm1[4,5],mem[6,7]
	vmovups	%xmm0, 8(%r13)
	movq	$0, 24(%r13)
	vbroadcastsd	32(%r13), %ymm2
	vblendps	$192, %ymm2, %ymm1, %ymm1       # ymm1 = ymm1[0,1,2,3,4,5],ymm2[6,7]
	vmovups	%ymm1, 48(%r14)
	vmovups	40(%r13), %xmm1
	vmovups	%xmm1, 80(%r14)
	vmovups	%xmm0, 32(%r13)
	movq	$0, 48(%r13)
	movq	56(%r13), %rax
	movq	%rax, 96(%r14)
	leaq	32(%rbx), %rdi
	movq	8(%rbx), %rsi
	movq	24(%rbx), %rdx
	movl	$1, %ecx
	vzeroupper
	callq	_ZNKSt8__detail20_Prime_rehash_policy14_M_need_rehashEmmm
	testb	$1, %al
	je	.LBB6_12
# %bb.9:
	movq	%rbx, %rdi
	movq	%rdx, %rsi
	callq	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_rehashEmSt17integral_constantIbLb1EE
	movq	8(%rbx), %rcx
	movq	%rbp, %rax
	orq	%rcx, %rax
	shrq	$32, %rax
	je	.LBB6_10
# %bb.11:
	movq	%rbp, %rax
	xorl	%edx, %edx
	divq	%rcx
	movq	%rdx, %r12
	jmp	.LBB6_12
.LBB6_10:
	movl	%ebp, %eax
	xorl	%edx, %edx
	divl	%ecx
	movl	%edx, %r12d
.LBB6_12:
	movq	%rbp, 104(%r14)
	movq	(%rbx), %rcx
	movq	(%rcx,%r12,8), %rax
	testq	%rax, %rax
	je	.LBB6_14
# %bb.13:
	movq	(%rax), %rax
	movq	%rax, (%r14)
	movq	(%rcx,%r12,8), %rax
	movq	%r14, (%rax)
	jmp	.LBB6_20
.LBB6_14:
	leaq	16(%rbx), %rsi
	movq	16(%rbx), %rax
	movq	%rax, (%r14)
	movq	%r14, 16(%rbx)
	testq	%rax, %rax
	je	.LBB6_19
# %bb.15:
	movq	8(%rbx), %rdi
	movq	104(%rax), %rax
	movq	%rax, %rdx
	orq	%rdi, %rdx
	shrq	$32, %rdx
	je	.LBB6_16
# %bb.17:
	xorl	%edx, %edx
	divq	%rdi
	jmp	.LBB6_18
.LBB6_16:
                                        # kill: def $eax killed $eax killed $rax
	xorl	%edx, %edx
	divl	%edi
                                        # kill: def $edx killed $edx def $rdx
.LBB6_18:
	movq	%r14, (%rcx,%rdx,8)
	movq	(%rbx), %rcx
.LBB6_19:
	movq	%rsi, (%rcx,%r12,8)
.LBB6_20:
	incq	24(%rbx)
	movb	$1, %dl
.LBB6_21:
	movq	%r14, %rax
                                        # kill: def $dl killed $dl killed $edx
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end6:
	.size	_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_, .Lfunc_end6-_ZNSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE15_M_emplace_uniqIJRS5_S9_EEES6_INSC_14_Node_iteratorISA_Lb0ELb1EEEbEDpOT_
                                        # -- End function
	.section	.text._ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_,"axG",@progbits,_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_,comdat
	.weak	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_ # -- Begin function _ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_
	.p2align	4, 0x90
	.type	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_,@function
_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_: # @_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%rdx, 8(%rsp)                   # 8-byte Spill
	movq	%rsi, %r13
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, (%rdi)
	movq	%rdi, 16(%rsp)                  # 8-byte Spill
	movq	$-1, 16(%rdi)
	movq	24(%rsi), %rbx
	cmpq	$20, %rbx
	ja	.LBB7_9
# %bb.1:
	movq	16(%r13), %rax
	testq	%rax, %rax
	je	.LBB7_9
# %bb.2:
	leaq	16(%r13), %r12
	movq	8(%rsp), %rcx                   # 8-byte Reload
	movq	8(%rcx), %r14
	testq	%r14, %r14
	je	.LBB7_7
# %bb.3:
	movq	(%rcx), %r15
	jmp	.LBB7_4
	.p2align	4, 0x90
.LBB7_6:                                #   in Loop: Header=BB7_4 Depth=1
	movq	(%rbp), %rax
	movq	%rbp, %r12
	testq	%rax, %rax
	je	.LBB7_9
.LBB7_4:                                # =>This Inner Loop Header: Depth=1
	movq	%rax, %rbp
	cmpq	16(%rax), %r14
	jne	.LBB7_6
# %bb.5:                                #   in Loop: Header=BB7_4 Depth=1
	movq	8(%rbp), %rsi
	movq	%r15, %rdi
	movq	%r14, %rdx
	callq	bcmp@PLT
	testl	%eax, %eax
	jne	.LBB7_6
	jmp	.LBB7_32
	.p2align	4, 0x90
.LBB7_8:                                #   in Loop: Header=BB7_7 Depth=1
	movq	%rax, %r12
	movq	(%rax), %rax
	testq	%rax, %rax
	je	.LBB7_9
.LBB7_7:                                # =>This Inner Loop Header: Depth=1
	cmpq	$0, 16(%rax)
	jne	.LBB7_8
	jmp	.LBB7_32
.LBB7_9:
	movq	8(%rsp), %rax                   # 8-byte Reload
	movq	(%rax), %rdi
	movq	8(%rax), %rsi
	movl	$3339675911, %edx               # imm = 0xC70F6907
	callq	_ZSt11_Hash_bytesPKvmm
	movq	%rax, %r14
	movq	16(%rsp), %rcx                  # 8-byte Reload
	movq	%rax, 8(%rcx)
	movq	8(%r13), %rbp
	orq	%rbp, %rax
	shrq	$32, %rax
	je	.LBB7_10
# %bb.11:
	movq	%r14, %rax
	xorl	%edx, %edx
	divq	%rbp
	movq	%rdx, %r15
	movq	%r15, 16(%rcx)
	cmpq	$21, %rbx
	jae	.LBB7_13
	jmp	.LBB7_33
.LBB7_10:
	movl	%r14d, %eax
	xorl	%edx, %edx
	divl	%ebp
	movl	%edx, %r15d
	movq	%r15, 16(%rcx)
	cmpq	$21, %rbx
	jb	.LBB7_33
.LBB7_13:
	movq	(%r13), %rax
	movq	(%rax,%r15,8), %r12
	testq	%r12, %r12
	je	.LBB7_31
# %bb.14:
	movq	(%r12), %rbx
	movq	8(%rsp), %rax                   # 8-byte Reload
	movq	8(%rax), %r13
	movq	104(%rbx), %rcx
	testq	%r13, %r13
	je	.LBB7_22
# %bb.15:
	movq	(%rax), %rax
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	jmp	.LBB7_16
	.p2align	4, 0x90
.LBB7_29:                               #   in Loop: Header=BB7_16 Depth=1
	movq	%rcx, %rax
	xorl	%edx, %edx
	divq	%rbp
	movq	%rbx, %r12
	movq	%rsi, %rbx
	cmpq	%r15, %rdx
	jne	.LBB7_31
.LBB7_16:                               # =>This Inner Loop Header: Depth=1
	cmpq	%r14, %rcx
	jne	.LBB7_19
# %bb.17:                               #   in Loop: Header=BB7_16 Depth=1
	cmpq	16(%rbx), %r13
	jne	.LBB7_19
# %bb.18:                               #   in Loop: Header=BB7_16 Depth=1
	movq	8(%rbx), %rsi
	movq	8(%rsp), %rdi                   # 8-byte Reload
	movq	%r13, %rdx
	callq	bcmp@PLT
	testl	%eax, %eax
	je	.LBB7_32
.LBB7_19:                               #   in Loop: Header=BB7_16 Depth=1
	movq	(%rbx), %rsi
	testq	%rsi, %rsi
	je	.LBB7_31
# %bb.20:                               #   in Loop: Header=BB7_16 Depth=1
	movq	104(%rsi), %rcx
	movq	%rcx, %rax
	orq	%rbp, %rax
	shrq	$32, %rax
	jne	.LBB7_29
# %bb.21:                               #   in Loop: Header=BB7_16 Depth=1
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%ebp
                                        # kill: def $edx killed $edx def $rdx
	movq	%rbx, %r12
	movq	%rsi, %rbx
	cmpq	%r15, %rdx
	je	.LBB7_16
.LBB7_31:
	xorl	%r12d, %r12d
.LBB7_32:
	movq	16(%rsp), %rcx                  # 8-byte Reload
	movq	%r12, (%rcx)
.LBB7_33:
	movq	%rcx, %rax
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
	.p2align	4, 0x90
.LBB7_27:                               #   in Loop: Header=BB7_22 Depth=1
	movq	%rcx, %rax
	xorl	%edx, %edx
	divq	%rbp
.LBB7_28:                               #   in Loop: Header=BB7_22 Depth=1
	movq	%rbx, %r12
	movq	%rsi, %rbx
	cmpq	%r15, %rdx
	jne	.LBB7_31
.LBB7_22:                               # =>This Inner Loop Header: Depth=1
	cmpq	%r14, %rcx
	jne	.LBB7_24
# %bb.23:                               #   in Loop: Header=BB7_22 Depth=1
	cmpq	$0, 16(%rbx)
	je	.LBB7_32
.LBB7_24:                               #   in Loop: Header=BB7_22 Depth=1
	movq	(%rbx), %rsi
	testq	%rsi, %rsi
	je	.LBB7_31
# %bb.25:                               #   in Loop: Header=BB7_22 Depth=1
	movq	104(%rsi), %rcx
	movq	%rcx, %rax
	orq	%rbp, %rax
	shrq	$32, %rax
	jne	.LBB7_27
# %bb.26:                               #   in Loop: Header=BB7_22 Depth=1
	movl	%ecx, %eax
	xorl	%edx, %edx
	divl	%ebp
                                        # kill: def $edx killed $edx def $rdx
	jmp	.LBB7_28
.Lfunc_end7:
	.size	_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_, .Lfunc_end7-_ZNKSt10_HashtableINSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEESt4pairIKS5_N3fx27WTensorEESaISA_ENSt8__detail10_Select1stESt8equal_toIS5_ESt4hashIS5_ENSC_18_Mod_range_hashingENSC_20_Default_ranged_hashENSC_20_Prime_rehash_policyENSC_17_Hashtable_traitsILb1ELb0ELb1EEEE9_M_locateERS7_
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

	.type	.L.str.5,@object                # @.str.5
.L.str.5:
	.asciz	"%s: bad magic"
	.size	.L.str.5, 14

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"%s: absurd name length %u"
	.size	.L.str.6, 26

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"%s: %s: absurd ndim %u"
	.size	.L.str.7, 23

	.type	.L.str.8,@object                # @.str.8
.L.str.8:
	.asciz	"%s: duplicate tensor %s"
	.size	.L.str.8, 24

	.type	.L.str.9,@object                # @.str.9
.L.str.9:
	.asciz	"%s: %zu trailing bytes after last tensor"
	.size	.L.str.9, 41

	.type	.L.str.10,@object               # @.str.10
.L.str.10:
	.asciz	"missing tensor %s"
	.size	.L.str.10, 18

	.type	.L.str.11,@object               # @.str.11
.L.str.11:
	.asciz	"%s: dtype %u, expected %u"
	.size	.L.str.11, 26

	.type	.L.str.12,@object               # @.str.12
.L.str.12:
	.asciz	"%s: ndim %zu, expected %zu"
	.size	.L.str.12, 27

	.type	.L.str.13,@object               # @.str.13
.L.str.13:
	.asciz	"%s: shape[%zu] = %u, expected %u"
	.size	.L.str.13, 33

	.type	.L.str.14,@object               # @.str.14
.L.str.14:
	.asciz	"weights_io: "
	.size	.L.str.14, 13

	.type	.L.str.16,@object               # @.str.16
.L.str.16:
	.asciz	"%s: truncated file (need %zu more bytes)"
	.size	.L.str.16, 41

	.type	.L.str.17,@object               # @.str.17
.L.str.17:
	.asciz	"unknown dtype code %u"
	.size	.L.str.17, 22

	.type	.L.str.19,@object               # @.str.19
.L.str.19:
	.asciz	"vector::_M_default_append"
	.size	.L.str.19, 26

	.type	.Lswitch.table._ZN3fx211WeightsFile4loadEPKc,@object # @switch.table._ZN3fx211WeightsFile4loadEPKc
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	3, 0x0
.Lswitch.table._ZN3fx211WeightsFile4loadEPKc:
	.quad	1                               # 0x1
	.quad	2                               # 0x2
	.quad	4                               # 0x4
	.quad	4                               # 0x4
	.size	.Lswitch.table._ZN3fx211WeightsFile4loadEPKc, 32

	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
