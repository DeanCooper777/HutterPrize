	.text
	.file	"glue.cpp"
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt11rms_norm192EPKfPf
.LCPI0_0:
	.long	0x43400000                      # float 192
.LCPI0_1:
	.long	0x34000000                      # float 1.1920929E-7
	.section	.text._ZN3fx23opt11rms_norm192EPKfPf,"ax",@progbits
	.globl	_ZN3fx23opt11rms_norm192EPKfPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt11rms_norm192EPKfPf,@function
_ZN3fx23opt11rms_norm192EPKfPf:         # @_ZN3fx23opt11rms_norm192EPKfPf
# %bb.0:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd231ps	%ymm0, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm0) + ymm1
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	192(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	256(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	320(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	384(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	448(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	512(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	576(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	640(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	704(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vextractf128	$1, %ymm1, %xmm2
	vaddps	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm1, %xmm1, %xmm2         # xmm2 = xmm1[1,0]
	vaddps	%xmm2, %xmm1, %xmm1
	vmovshdup	%xmm1, %xmm2            # xmm2 = xmm1[1,1,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vdivss	.LCPI0_0(%rip), %xmm1, %xmm1
	vaddss	.LCPI0_1(%rip), %xmm1, %xmm1
	vsqrtss	%xmm1, %xmm1, %xmm1
	vbroadcastss	%xmm1, %ymm1
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, (%rsi)
	vmovups	32(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 32(%rsi)
	vmovups	64(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 64(%rsi)
	vmovups	96(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 96(%rsi)
	vmovups	128(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 128(%rsi)
	vmovups	160(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 160(%rsi)
	vmovups	192(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 192(%rsi)
	vmovups	224(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 224(%rsi)
	vmovups	256(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 256(%rsi)
	vmovups	288(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 288(%rsi)
	vmovups	320(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 320(%rsi)
	vmovups	352(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 352(%rsi)
	vmovups	384(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 384(%rsi)
	vmovups	416(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 416(%rsi)
	vmovups	448(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 448(%rsi)
	vmovups	480(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 480(%rsi)
	vmovups	512(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 512(%rsi)
	vmovups	544(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 544(%rsi)
	vmovups	576(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 576(%rsi)
	vmovups	608(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 608(%rsi)
	vmovups	640(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 640(%rsi)
	vmovups	672(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 672(%rsi)
	vmovups	704(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 704(%rsi)
	vmovups	736(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 736(%rsi)
	vzeroupper
	retq
.Lfunc_end0:
	.size	_ZN3fx23opt11rms_norm192EPKfPf, .Lfunc_end0-_ZN3fx23opt11rms_norm192EPKfPf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt10rms_norm64EPKfPf
.LCPI1_0:
	.long	0x3c800000                      # float 0.015625
.LCPI1_1:
	.long	0x34000000                      # float 1.1920929E-7
	.section	.text._ZN3fx23opt10rms_norm64EPKfPf,"ax",@progbits
	.globl	_ZN3fx23opt10rms_norm64EPKfPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt10rms_norm64EPKfPf,@function
_ZN3fx23opt10rms_norm64EPKfPf:          # @_ZN3fx23opt10rms_norm64EPKfPf
# %bb.0:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd231ps	%ymm0, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm0) + ymm1
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	192(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vextractf128	$1, %ymm1, %xmm2
	vaddps	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm1, %xmm1, %xmm2         # xmm2 = xmm1[1,0]
	vaddps	%xmm2, %xmm1, %xmm1
	vmovshdup	%xmm1, %xmm2            # xmm2 = xmm1[1,1,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vmulss	.LCPI1_0(%rip), %xmm1, %xmm1
	vaddss	.LCPI1_1(%rip), %xmm1, %xmm1
	vsqrtss	%xmm1, %xmm1, %xmm1
	vbroadcastss	%xmm1, %ymm1
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, (%rsi)
	vmovups	32(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 32(%rsi)
	vmovups	64(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 64(%rsi)
	vmovups	96(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 96(%rsi)
	vmovups	128(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 128(%rsi)
	vmovups	160(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 160(%rsi)
	vmovups	192(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 192(%rsi)
	vmovups	224(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 224(%rsi)
	vzeroupper
	retq
.Lfunc_end1:
	.size	_ZN3fx23opt10rms_norm64EPKfPf, .Lfunc_end1-_ZN3fx23opt10rms_norm64EPKfPf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt12rms_denom192EPKf
.LCPI2_0:
	.long	0x43400000                      # float 192
.LCPI2_1:
	.long	0x34000000                      # float 1.1920929E-7
	.section	.text._ZN3fx23opt12rms_denom192EPKf,"ax",@progbits
	.globl	_ZN3fx23opt12rms_denom192EPKf
	.p2align	4, 0x90
	.type	_ZN3fx23opt12rms_denom192EPKf,@function
_ZN3fx23opt12rms_denom192EPKf:          # @_ZN3fx23opt12rms_denom192EPKf
# %bb.0:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	192(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	256(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	320(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	384(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	448(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	512(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	576(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	640(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	704(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vdivss	.LCPI2_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI2_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm0
	vzeroupper
	retq
.Lfunc_end2:
	.size	_ZN3fx23opt12rms_denom192EPKf, .Lfunc_end2-_ZN3fx23opt12rms_denom192EPKf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh
.LCPI3_0:
	.long	0x43400000                      # float 192
.LCPI3_1:
	.long	0x34000000                      # float 1.1920929E-7
.LCPI3_2:
	.long	0xc3000000                      # float -128
.LCPI3_3:
	.long	0x42fe0000                      # float 127
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI3_4:
	.zero	16,128
	.section	.rodata,"a",@progbits
.LCPI3_5:
	.byte	128                             # 0x80
	.section	.text._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh,"ax",@progbits
	.globl	_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh,@function
_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh: # @_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	movq	%r8, %rbx
                                        # kill: def $ecx killed $ecx def $rcx
	movq	%rdx, %r15
	movq	%rsi, %r14
	leal	-1(%rcx), %eax
	cmpl	$4, %eax
	ja	.LBB3_11
# %bb.1:
	jmpq	*.LJTI3_0(,%rax,8)
.LBB3_2:
	movq	%r14, %rsi
	movq	%r15, %rdx
	movq	%rbx, %rcx
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	jmp	_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi # TAILCALL
.LBB3_3:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	192(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	256(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	320(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	384(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	448(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	512(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	576(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	640(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	704(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vdivss	.LCPI3_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI3_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm2
	vbroadcastss	(%r15), %ymm0
	vbroadcastss	4(%r15), %ymm1
	vbroadcastss	%xmm2, %ymm2
	movq	$-16, %rax
	vbroadcastss	.LCPI3_2(%rip), %ymm3   # ymm3 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI3_3(%rip), %ymm4   # ymm4 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastb	.LCPI3_5(%rip), %xmm5   # xmm5 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	.p2align	4, 0x90
.LBB3_4:                                # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm6
	vdivps	%ymm2, %ymm6, %ymm6
	vmovups	96(%rdi,%rax,4), %ymm7
	vdivps	%ymm2, %ymm7, %ymm7
	vmovups	%ymm6, 64(%r14,%rax,4)
	vdivps	%ymm0, %ymm6, %ymm8
	vmovups	%ymm7, 96(%r14,%rax,4)
	vdivps	%ymm0, %ymm7, %ymm9
	vmaxps	%ymm3, %ymm8, %ymm8
	vminps	%ymm4, %ymm8, %ymm8
	vmaxps	%ymm3, %ymm9, %ymm9
	vminps	%ymm4, %ymm9, %ymm9
	vcvtps2dq	%ymm8, %ymm8
	vcvtps2dq	%ymm9, %ymm9
	vpackssdw	%ymm9, %ymm8, %ymm8
	vextracti128	$1, %ymm8, %xmm9
	vpacksswb	%xmm9, %xmm8, %xmm8
	vdivps	%ymm1, %ymm6, %ymm6
	vpshufd	$216, %xmm8, %xmm8              # xmm8 = xmm8[0,2,1,3]
	vdivps	%ymm1, %ymm7, %ymm7
	vpxor	%xmm5, %xmm8, %xmm8
	vmovdqu	%xmm8, 16(%rbx,%rax)
	vmaxps	%ymm3, %ymm6, %ymm6
	vminps	%ymm4, %ymm6, %ymm6
	vmaxps	%ymm3, %ymm7, %ymm7
	vminps	%ymm4, %ymm7, %ymm7
	vcvtps2dq	%ymm6, %ymm6
	vcvtps2dq	%ymm7, %ymm7
	vpackssdw	%ymm7, %ymm6, %ymm6
	vextracti128	$1, %ymm6, %xmm7
	vpacksswb	%xmm7, %xmm6, %xmm6
	vpshufd	$216, %xmm6, %xmm6              # xmm6 = xmm6[0,2,1,3]
	vpxor	%xmm5, %xmm6, %xmm6
	vmovdqu	%xmm6, 208(%rbx,%rax)
	addq	$16, %rax
	cmpq	$176, %rax
	jb	.LBB3_4
	jmp	.LBB3_14
.LBB3_5:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	192(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	256(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	320(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	384(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	448(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	512(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	576(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	640(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	704(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vdivss	.LCPI3_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI3_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm3
	vbroadcastss	(%r15), %ymm0
	vbroadcastss	4(%r15), %ymm1
	vbroadcastss	8(%r15), %ymm2
	vbroadcastss	%xmm3, %ymm3
	movq	$-16, %rax
	vbroadcastss	.LCPI3_2(%rip), %ymm4   # ymm4 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI3_3(%rip), %ymm5   # ymm5 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastb	.LCPI3_5(%rip), %xmm6   # xmm6 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	.p2align	4, 0x90
.LBB3_6:                                # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm7
	vdivps	%ymm3, %ymm7, %ymm7
	vmovups	96(%rdi,%rax,4), %ymm8
	vdivps	%ymm3, %ymm8, %ymm8
	vdivps	%ymm0, %ymm7, %ymm9
	vdivps	%ymm0, %ymm8, %ymm10
	vmovups	%ymm7, 64(%r14,%rax,4)
	vmovups	%ymm8, 96(%r14,%rax,4)
	vmaxps	%ymm4, %ymm9, %ymm9
	vminps	%ymm5, %ymm9, %ymm9
	vmaxps	%ymm4, %ymm10, %ymm10
	vminps	%ymm5, %ymm10, %ymm10
	vcvtps2dq	%ymm9, %ymm9
	vcvtps2dq	%ymm10, %ymm10
	vpackssdw	%ymm10, %ymm9, %ymm9
	vextracti128	$1, %ymm9, %xmm10
	vpacksswb	%xmm10, %xmm9, %xmm9
	vpshufd	$216, %xmm9, %xmm9              # xmm9 = xmm9[0,2,1,3]
	vpxor	%xmm6, %xmm9, %xmm9
	vdivps	%ymm1, %ymm7, %ymm10
	vmovdqu	%xmm9, 16(%rbx,%rax)
	vdivps	%ymm1, %ymm8, %ymm9
	vmaxps	%ymm4, %ymm10, %ymm10
	vminps	%ymm5, %ymm10, %ymm10
	vmaxps	%ymm4, %ymm9, %ymm9
	vminps	%ymm5, %ymm9, %ymm9
	vcvtps2dq	%ymm10, %ymm10
	vcvtps2dq	%ymm9, %ymm9
	vpackssdw	%ymm9, %ymm10, %ymm9
	vextracti128	$1, %ymm9, %xmm10
	vpacksswb	%xmm10, %xmm9, %xmm9
	vdivps	%ymm2, %ymm7, %ymm7
	vpshufd	$216, %xmm9, %xmm9              # xmm9 = xmm9[0,2,1,3]
	vdivps	%ymm2, %ymm8, %ymm8
	vpxor	%xmm6, %xmm9, %xmm9
	vmovdqu	%xmm9, 208(%rbx,%rax)
	vmaxps	%ymm4, %ymm7, %ymm7
	vminps	%ymm5, %ymm7, %ymm7
	vmaxps	%ymm4, %ymm8, %ymm8
	vminps	%ymm5, %ymm8, %ymm8
	vcvtps2dq	%ymm7, %ymm7
	vcvtps2dq	%ymm8, %ymm8
	vpackssdw	%ymm8, %ymm7, %ymm7
	vextracti128	$1, %ymm7, %xmm8
	vpacksswb	%xmm8, %xmm7, %xmm7
	vpshufd	$216, %xmm7, %xmm7              # xmm7 = xmm7[0,2,1,3]
	vpxor	%xmm6, %xmm7, %xmm7
	vmovdqu	%xmm7, 400(%rbx,%rax)
	addq	$16, %rax
	cmpq	$176, %rax
	jb	.LBB3_6
	jmp	.LBB3_14
.LBB3_7:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	192(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	256(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	320(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	384(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	448(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	512(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	576(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	640(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	704(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vdivss	.LCPI3_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI3_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm4
	vbroadcastss	(%r15), %ymm0
	vbroadcastss	4(%r15), %ymm1
	vbroadcastss	8(%r15), %ymm2
	vbroadcastss	12(%r15), %ymm3
	vbroadcastss	%xmm4, %ymm4
	movq	$-16, %rax
	vbroadcastss	.LCPI3_2(%rip), %ymm5   # ymm5 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI3_3(%rip), %ymm6   # ymm6 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastb	.LCPI3_5(%rip), %xmm7   # xmm7 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	.p2align	4, 0x90
.LBB3_8:                                # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm8
	vdivps	%ymm4, %ymm8, %ymm8
	vmovups	96(%rdi,%rax,4), %ymm9
	vdivps	%ymm4, %ymm9, %ymm9
	vmovups	%ymm8, 64(%r14,%rax,4)
	vdivps	%ymm0, %ymm8, %ymm10
	vmovups	%ymm9, 96(%r14,%rax,4)
	vdivps	%ymm0, %ymm9, %ymm11
	vmaxps	%ymm5, %ymm10, %ymm10
	vminps	%ymm6, %ymm10, %ymm10
	vmaxps	%ymm5, %ymm11, %ymm11
	vminps	%ymm6, %ymm11, %ymm11
	vcvtps2dq	%ymm10, %ymm10
	vcvtps2dq	%ymm11, %ymm11
	vpackssdw	%ymm11, %ymm10, %ymm10
	vextracti128	$1, %ymm10, %xmm11
	vpacksswb	%xmm11, %xmm10, %xmm10
	vdivps	%ymm1, %ymm8, %ymm11
	vpshufd	$216, %xmm10, %xmm10            # xmm10 = xmm10[0,2,1,3]
	vdivps	%ymm1, %ymm9, %ymm12
	vpxor	%xmm7, %xmm10, %xmm10
	vmovdqu	%xmm10, 16(%rbx,%rax)
	vmaxps	%ymm5, %ymm11, %ymm10
	vminps	%ymm6, %ymm10, %ymm10
	vmaxps	%ymm5, %ymm12, %ymm11
	vminps	%ymm6, %ymm11, %ymm11
	vcvtps2dq	%ymm10, %ymm10
	vcvtps2dq	%ymm11, %ymm11
	vpackssdw	%ymm11, %ymm10, %ymm10
	vextracti128	$1, %ymm10, %xmm11
	vpacksswb	%xmm11, %xmm10, %xmm10
	vpshufd	$216, %xmm10, %xmm10            # xmm10 = xmm10[0,2,1,3]
	vpxor	%xmm7, %xmm10, %xmm10
	vdivps	%ymm2, %ymm8, %ymm11
	vmovdqu	%xmm10, 208(%rbx,%rax)
	vdivps	%ymm2, %ymm9, %ymm10
	vmaxps	%ymm5, %ymm11, %ymm11
	vminps	%ymm6, %ymm11, %ymm11
	vmaxps	%ymm5, %ymm10, %ymm10
	vminps	%ymm6, %ymm10, %ymm10
	vcvtps2dq	%ymm11, %ymm11
	vcvtps2dq	%ymm10, %ymm10
	vpackssdw	%ymm10, %ymm11, %ymm10
	vextracti128	$1, %ymm10, %xmm11
	vpacksswb	%xmm11, %xmm10, %xmm10
	vdivps	%ymm3, %ymm8, %ymm8
	vpshufd	$216, %xmm10, %xmm10            # xmm10 = xmm10[0,2,1,3]
	vdivps	%ymm3, %ymm9, %ymm9
	vpxor	%xmm7, %xmm10, %xmm10
	vmovdqu	%xmm10, 400(%rbx,%rax)
	vmaxps	%ymm5, %ymm8, %ymm8
	vminps	%ymm6, %ymm8, %ymm8
	vmaxps	%ymm5, %ymm9, %ymm9
	vminps	%ymm6, %ymm9, %ymm9
	vcvtps2dq	%ymm8, %ymm8
	vcvtps2dq	%ymm9, %ymm9
	vpackssdw	%ymm9, %ymm8, %ymm8
	vextracti128	$1, %ymm8, %xmm9
	vpacksswb	%xmm9, %xmm8, %xmm8
	vpshufd	$216, %xmm8, %xmm8              # xmm8 = xmm8[0,2,1,3]
	vpxor	%xmm7, %xmm8, %xmm8
	vmovdqu	%xmm8, 592(%rbx,%rax)
	addq	$16, %rax
	cmpq	$176, %rax
	jb	.LBB3_8
	jmp	.LBB3_14
.LBB3_9:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	192(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	256(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	320(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	384(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	448(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	512(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	576(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	640(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	704(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vdivss	.LCPI3_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI3_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm5
	vbroadcastss	(%r15), %ymm0
	vbroadcastss	4(%r15), %ymm1
	vbroadcastss	8(%r15), %ymm2
	vbroadcastss	12(%r15), %ymm3
	vbroadcastss	16(%r15), %ymm4
	vbroadcastss	%xmm5, %ymm5
	movq	$-16, %rax
	vbroadcastss	.LCPI3_2(%rip), %ymm6   # ymm6 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI3_3(%rip), %ymm7   # ymm7 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastb	.LCPI3_5(%rip), %xmm8   # xmm8 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	.p2align	4, 0x90
.LBB3_10:                               # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm9
	vdivps	%ymm5, %ymm9, %ymm9
	vmovups	96(%rdi,%rax,4), %ymm10
	vdivps	%ymm5, %ymm10, %ymm10
	vdivps	%ymm0, %ymm9, %ymm11
	vdivps	%ymm0, %ymm10, %ymm12
	vmovups	%ymm9, 64(%r14,%rax,4)
	vmovups	%ymm10, 96(%r14,%rax,4)
	vmaxps	%ymm6, %ymm11, %ymm11
	vminps	%ymm7, %ymm11, %ymm11
	vmaxps	%ymm6, %ymm12, %ymm12
	vminps	%ymm7, %ymm12, %ymm12
	vcvtps2dq	%ymm11, %ymm11
	vcvtps2dq	%ymm12, %ymm12
	vpackssdw	%ymm12, %ymm11, %ymm11
	vextracti128	$1, %ymm11, %xmm12
	vpacksswb	%xmm12, %xmm11, %xmm11
	vpshufd	$216, %xmm11, %xmm11            # xmm11 = xmm11[0,2,1,3]
	vpxor	%xmm8, %xmm11, %xmm11
	vdivps	%ymm1, %ymm9, %ymm12
	vmovdqu	%xmm11, 16(%rbx,%rax)
	vdivps	%ymm1, %ymm10, %ymm11
	vmaxps	%ymm6, %ymm12, %ymm12
	vminps	%ymm7, %ymm12, %ymm12
	vmaxps	%ymm6, %ymm11, %ymm11
	vminps	%ymm7, %ymm11, %ymm11
	vcvtps2dq	%ymm12, %ymm12
	vcvtps2dq	%ymm11, %ymm11
	vpackssdw	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm11, %xmm12
	vpacksswb	%xmm12, %xmm11, %xmm11
	vdivps	%ymm2, %ymm9, %ymm12
	vpshufd	$216, %xmm11, %xmm11            # xmm11 = xmm11[0,2,1,3]
	vdivps	%ymm2, %ymm10, %ymm13
	vpxor	%xmm8, %xmm11, %xmm11
	vmovdqu	%xmm11, 208(%rbx,%rax)
	vmaxps	%ymm6, %ymm12, %ymm11
	vminps	%ymm7, %ymm11, %ymm11
	vmaxps	%ymm6, %ymm13, %ymm12
	vminps	%ymm7, %ymm12, %ymm12
	vcvtps2dq	%ymm11, %ymm11
	vcvtps2dq	%ymm12, %ymm12
	vpackssdw	%ymm12, %ymm11, %ymm11
	vextracti128	$1, %ymm11, %xmm12
	vpacksswb	%xmm12, %xmm11, %xmm11
	vpshufd	$216, %xmm11, %xmm11            # xmm11 = xmm11[0,2,1,3]
	vpxor	%xmm8, %xmm11, %xmm11
	vdivps	%ymm3, %ymm9, %ymm12
	vmovdqu	%xmm11, 400(%rbx,%rax)
	vdivps	%ymm3, %ymm10, %ymm11
	vmaxps	%ymm6, %ymm12, %ymm12
	vminps	%ymm7, %ymm12, %ymm12
	vmaxps	%ymm6, %ymm11, %ymm11
	vminps	%ymm7, %ymm11, %ymm11
	vcvtps2dq	%ymm12, %ymm12
	vcvtps2dq	%ymm11, %ymm11
	vpackssdw	%ymm11, %ymm12, %ymm11
	vextracti128	$1, %ymm11, %xmm12
	vpacksswb	%xmm12, %xmm11, %xmm11
	vdivps	%ymm4, %ymm9, %ymm9
	vpshufd	$216, %xmm11, %xmm11            # xmm11 = xmm11[0,2,1,3]
	vdivps	%ymm4, %ymm10, %ymm10
	vpxor	%xmm8, %xmm11, %xmm11
	vmovdqu	%xmm11, 592(%rbx,%rax)
	vmaxps	%ymm6, %ymm9, %ymm9
	vminps	%ymm7, %ymm9, %ymm9
	vmaxps	%ymm6, %ymm10, %ymm10
	vminps	%ymm7, %ymm10, %ymm10
	vcvtps2dq	%ymm9, %ymm9
	vcvtps2dq	%ymm10, %ymm10
	vpackssdw	%ymm10, %ymm9, %ymm9
	vextracti128	$1, %ymm9, %xmm10
	vpacksswb	%xmm10, %xmm9, %xmm9
	vpshufd	$216, %xmm9, %xmm9              # xmm9 = xmm9[0,2,1,3]
	vpxor	%xmm8, %xmm9, %xmm9
	vmovdqu	%xmm9, 784(%rbx,%rax)
	addq	$16, %rax
	cmpq	$176, %rax
	jb	.LBB3_10
	jmp	.LBB3_14
.LBB3_11:
	cmpl	$8, %eax
	jae	.LBB3_15
# %bb.12:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd231ps	%ymm0, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm0) + ymm1
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	192(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	256(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	320(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	384(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	448(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	512(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	576(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	640(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vmovups	704(%rdi), %ymm2
	vfmadd213ps	%ymm1, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm2, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm2
	vextractf128	$1, %ymm1, %xmm2
	vaddps	%xmm2, %xmm1, %xmm1
	vshufpd	$1, %xmm1, %xmm1, %xmm2         # xmm2 = xmm1[1,0]
	vaddps	%xmm2, %xmm1, %xmm1
	vmovshdup	%xmm1, %xmm2            # xmm2 = xmm1[1,1,3,3]
	vaddss	%xmm2, %xmm1, %xmm1
	vdivss	.LCPI3_0(%rip), %xmm1, %xmm1
	vaddss	.LCPI3_1(%rip), %xmm1, %xmm1
	vsqrtss	%xmm1, %xmm1, %xmm1
	vbroadcastss	%xmm1, %ymm1
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, (%r14)
	vmovups	32(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 32(%r14)
	vmovups	64(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 64(%r14)
	vmovups	96(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 96(%r14)
	vmovups	128(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 128(%r14)
	vmovups	160(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 160(%r14)
	vmovups	192(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 192(%r14)
	vmovups	224(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 224(%r14)
	vmovups	256(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 256(%r14)
	vmovups	288(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 288(%r14)
	vmovups	320(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 320(%r14)
	vmovups	352(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 352(%r14)
	vmovups	384(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 384(%r14)
	vmovups	416(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 416(%r14)
	vmovups	448(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 448(%r14)
	vmovups	480(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 480(%r14)
	vmovups	512(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 512(%r14)
	vmovups	544(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 544(%r14)
	vmovups	576(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 576(%r14)
	vmovups	608(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 608(%r14)
	vmovups	640(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 640(%r14)
	vmovups	672(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 672(%r14)
	vmovups	704(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 704(%r14)
	vmovups	736(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovups	%ymm0, 736(%r14)
	movl	%ecx, %r12d
	xorl	%r13d, %r13d
	.p2align	4, 0x90
.LBB3_13:                               # =>This Inner Loop Header: Depth=1
	vmovss	(%r15,%r13,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	movq	%r14, %rdi
	movq	%rbx, %rsi
	vzeroupper
	callq	_ZN3fx23opt11quant192_u8EPKffPh
	incq	%r13
	addq	$192, %rbx
	cmpq	%r13, %r12
	jne	.LBB3_13
.LBB3_14:
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	vzeroupper
	retq
.LBB3_15:
	movl	$.L.str, %edi
	movl	$.L.str.1, %esi
	movl	$.L__PRETTY_FUNCTION__._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh, %ecx
	movl	$131, %edx
	callq	__assert_fail
.Lfunc_end3:
	.size	_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh, .Lfunc_end3-_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh
	.section	.rodata._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh,"a",@progbits
	.p2align	3, 0x0
.LJTI3_0:
	.quad	.LBB3_2
	.quad	.LBB3_3
	.quad	.LBB3_5
	.quad	.LBB3_7
	.quad	.LBB3_9
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi
.LCPI4_0:
	.long	0x43400000                      # float 192
.LCPI4_1:
	.long	0x34000000                      # float 1.1920929E-7
.LCPI4_2:
	.long	0xc3000000                      # float -128
.LCPI4_3:
	.long	0x42fe0000                      # float 127
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI4_4:
	.zero	16,128
	.section	.rodata,"a",@progbits
.LCPI4_5:
	.byte	128                             # 0x80
	.section	.text._ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi,"ax",@progbits
	.p2align	4, 0x90
	.type	_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi,@function
_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi: # @_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi
# %bb.0:
	vxorps	%xmm1, %xmm1, %xmm1
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd231ps	%ymm0, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm0) + ymm1
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	192(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	256(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	320(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	384(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	448(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	512(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	576(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	640(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vmovups	704(%rdi), %ymm3
	vfmadd213ps	%ymm1, %ymm3, %ymm3     # ymm3 = (ymm3 * ymm3) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm3, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm3
	vextractf128	$1, %ymm1, %xmm3
	vaddps	%xmm3, %xmm1, %xmm1
	vshufpd	$1, %xmm1, %xmm1, %xmm3         # xmm3 = xmm1[1,0]
	vaddps	%xmm3, %xmm1, %xmm1
	vmovshdup	%xmm1, %xmm3            # xmm3 = xmm1[1,1,3,3]
	vaddss	%xmm3, %xmm1, %xmm1
	vdivss	.LCPI4_0(%rip), %xmm1, %xmm1
	vaddss	.LCPI4_1(%rip), %xmm1, %xmm1
	vsqrtss	%xmm1, %xmm1, %xmm1
	vbroadcastss	%xmm1, %ymm1
	vdivps	%ymm1, %ymm0, %ymm3
	vdivps	%ymm1, %ymm2, %ymm2
	vbroadcastss	(%rdx), %ymm0
	vdivps	%ymm0, %ymm3, %ymm4
	vmovups	%ymm3, (%rsi)
	vdivps	%ymm0, %ymm2, %ymm5
	vmovups	%ymm2, 32(%rsi)
	vbroadcastss	.LCPI4_2(%rip), %ymm2   # ymm2 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vmaxps	%ymm2, %ymm4, %ymm4
	vbroadcastss	.LCPI4_3(%rip), %ymm3   # ymm3 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vminps	%ymm3, %ymm4, %ymm4
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm5              # xmm5 = xmm4[0,2,1,3]
	vpbroadcastb	.LCPI4_5(%rip), %xmm4   # xmm4 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, (%rcx)
	vmovups	64(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	96(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 64(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 96(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 16(%rcx)
	vmovups	128(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	160(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 128(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 160(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 32(%rcx)
	vmovups	192(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	224(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 192(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 224(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 48(%rcx)
	vmovups	256(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	288(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 256(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 288(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 64(%rcx)
	vmovups	320(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	352(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 320(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 352(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 80(%rcx)
	vmovups	384(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	416(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 384(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 416(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 96(%rcx)
	vmovups	448(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	480(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 448(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 480(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 112(%rcx)
	vmovups	512(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	544(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 512(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 544(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 128(%rcx)
	vmovups	576(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	608(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 576(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 608(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 144(%rcx)
	vmovups	640(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	672(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm6
	vmovups	%ymm5, 640(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm6, 672(%rsi)
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm6, %ymm6
	vminps	%ymm3, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm5, 160(%rcx)
	vmovups	704(%rdi), %ymm5
	vdivps	%ymm1, %ymm5, %ymm5
	vmovups	736(%rdi), %ymm6
	vdivps	%ymm1, %ymm6, %ymm1
	vmovups	%ymm5, 704(%rsi)
	vdivps	%ymm0, %ymm5, %ymm5
	vmovups	%ymm1, 736(%rsi)
	vdivps	%ymm0, %ymm1, %ymm0
	vmaxps	%ymm2, %ymm5, %ymm1
	vminps	%ymm3, %ymm1, %ymm1
	vmaxps	%ymm2, %ymm0, %ymm0
	vminps	%ymm3, %ymm0, %ymm0
	vcvtps2dq	%ymm1, %ymm1
	vcvtps2dq	%ymm0, %ymm0
	vpackssdw	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpacksswb	%xmm1, %xmm0, %xmm0
	vpshufd	$216, %xmm0, %xmm0              # xmm0 = xmm0[0,2,1,3]
	vpxor	%xmm4, %xmm0, %xmm0
	vmovdqu	%xmm0, 176(%rcx)
	vzeroupper
	retq
.Lfunc_end4:
	.size	_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi, .Lfunc_end4-_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt11quant192_u8EPKffPh
.LCPI5_0:
	.long	0xc3000000                      # float -128
.LCPI5_1:
	.long	0x42fe0000                      # float 127
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI5_2:
	.zero	16,128
	.section	.rodata,"a",@progbits
.LCPI5_3:
	.byte	128                             # 0x80
	.section	.text._ZN3fx23opt11quant192_u8EPKffPh,"ax",@progbits
	.globl	_ZN3fx23opt11quant192_u8EPKffPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt11quant192_u8EPKffPh,@function
_ZN3fx23opt11quant192_u8EPKffPh:        # @_ZN3fx23opt11quant192_u8EPKffPh
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rdi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm2
	vmovups	32(%rdi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm3
	vbroadcastss	.LCPI5_0(%rip), %ymm1   # ymm1 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vmaxps	%ymm1, %ymm2, %ymm4
	vbroadcastss	.LCPI5_1(%rip), %ymm2   # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vpackssdw	%ymm3, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm4              # xmm4 = xmm3[0,2,1,3]
	vpbroadcastb	.LCPI5_3(%rip), %xmm3   # xmm3 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, (%rsi)
	vmovups	64(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	96(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 16(%rsi)
	vmovups	128(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	160(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 32(%rsi)
	vmovups	192(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	224(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 48(%rsi)
	vmovups	256(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	288(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 64(%rsi)
	vmovups	320(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	352(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 80(%rsi)
	vmovups	384(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	416(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 96(%rsi)
	vmovups	448(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	480(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 112(%rsi)
	vmovups	512(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	544(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 128(%rsi)
	vmovups	576(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	608(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 144(%rsi)
	vmovups	640(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	672(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 160(%rsi)
	vmovups	704(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	736(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm0
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm0, %ymm0
	vminps	%ymm2, %ymm0, %ymm0
	vcvtps2dq	%ymm4, %ymm1
	vcvtps2dq	%ymm0, %ymm0
	vpackssdw	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpacksswb	%xmm1, %xmm0, %xmm0
	vpshufd	$216, %xmm0, %xmm0              # xmm0 = xmm0[0,2,1,3]
	vpxor	%xmm3, %xmm0, %xmm0
	vmovdqu	%xmm0, 176(%rsi)
	vzeroupper
	retq
.Lfunc_end5:
	.size	_ZN3fx23opt11quant192_u8EPKffPh, .Lfunc_end5-_ZN3fx23opt11quant192_u8EPKffPh
                                        # -- End function
	.section	.text._ZN3fx23opt17rms_norm_quant192EPKfPffPh,"ax",@progbits
	.globl	_ZN3fx23opt17rms_norm_quant192EPKfPffPh # -- Begin function _ZN3fx23opt17rms_norm_quant192EPKfPffPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt17rms_norm_quant192EPKfPffPh,@function
_ZN3fx23opt17rms_norm_quant192EPKfPffPh: # @_ZN3fx23opt17rms_norm_quant192EPKfPffPh
# %bb.0:
	pushq	%rax
	movq	%rdx, %rcx
	vmovss	%xmm0, 4(%rsp)
	leaq	4(%rsp), %rdx
	callq	_ZN3fx23opt12_GLOBAL__N_119rms_norm_quant_implILi1EEEvPKfPfS4_Phi
	popq	%rax
	retq
.Lfunc_end6:
	.size	_ZN3fx23opt17rms_norm_quant192EPKfPffPh, .Lfunc_end6-_ZN3fx23opt17rms_norm_quant192EPKfPffPh
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_
.LCPI7_0:
	.long	0x43400000                      # float 192
.LCPI7_1:
	.long	0x34000000                      # float 1.1920929E-7
.LCPI7_2:
	.long	0xc3000000                      # float -128
.LCPI7_3:
	.long	0x42fe0000                      # float 127
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI7_4:
	.zero	16,128
	.section	.rodata,"a",@progbits
.LCPI7_5:
	.byte	128                             # 0x80
	.section	.text._ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_,"ax",@progbits
	.globl	_ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_
	.p2align	4, 0x90
	.type	_ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_,@function
_ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_: # @_ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_
# %bb.0:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vmovups	64(%rdi), %ymm3
	vmovups	96(%rdi), %ymm4
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm1     # ymm1 = (ymm2 * ymm2) + ymm1
	vfmadd231ps	%ymm3, %ymm3, %ymm1     # ymm1 = (ymm3 * ymm3) + ymm1
	vfmadd231ps	%ymm4, %ymm4, %ymm1     # ymm1 = (ymm4 * ymm4) + ymm1
	vmovups	128(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	160(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	192(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	224(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	256(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	288(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	320(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	352(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	384(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	416(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	448(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	480(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	512(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	544(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	576(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	608(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	640(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	672(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vmovups	704(%rdi), %ymm0
	vfmadd213ps	%ymm1, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm1
	vmovups	736(%rdi), %ymm1
	vfmadd213ps	%ymm0, %ymm1, %ymm1     # ymm1 = (ymm1 * ymm1) + ymm0
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vdivss	.LCPI7_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI7_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm0
	vbroadcastss	%xmm0, %ymm0
	vbroadcastss	(%rdx), %ymm1
	vbroadcastss	4(%rdx), %ymm2
	vbroadcastss	8(%rdx), %ymm3
	movq	$-16, %rax
	vbroadcastss	.LCPI7_2(%rip), %ymm4   # ymm4 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI7_3(%rip), %ymm5   # ymm5 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastb	.LCPI7_5(%rip), %xmm6   # xmm6 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	.p2align	4, 0x90
.LBB7_1:                                # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm7
	vdivps	%ymm0, %ymm7, %ymm7
	vmovups	96(%rdi,%rax,4), %ymm8
	vdivps	%ymm0, %ymm8, %ymm8
	vdivps	%ymm1, %ymm7, %ymm9
	vdivps	%ymm1, %ymm8, %ymm10
	vmovups	%ymm7, 64(%rsi,%rax,4)
	vmovups	%ymm8, 96(%rsi,%rax,4)
	vmaxps	%ymm4, %ymm9, %ymm9
	vminps	%ymm5, %ymm9, %ymm9
	vmaxps	%ymm4, %ymm10, %ymm10
	vminps	%ymm5, %ymm10, %ymm10
	vcvtps2dq	%ymm9, %ymm9
	vcvtps2dq	%ymm10, %ymm10
	vpackssdw	%ymm10, %ymm9, %ymm9
	vextracti128	$1, %ymm9, %xmm10
	vpacksswb	%xmm10, %xmm9, %xmm9
	vpshufd	$216, %xmm9, %xmm9              # xmm9 = xmm9[0,2,1,3]
	vpxor	%xmm6, %xmm9, %xmm9
	vdivps	%ymm2, %ymm7, %ymm10
	vmovdqu	%xmm9, 16(%rcx,%rax)
	vdivps	%ymm2, %ymm8, %ymm9
	vmaxps	%ymm4, %ymm10, %ymm10
	vminps	%ymm5, %ymm10, %ymm10
	vmaxps	%ymm4, %ymm9, %ymm9
	vminps	%ymm5, %ymm9, %ymm9
	vcvtps2dq	%ymm10, %ymm10
	vcvtps2dq	%ymm9, %ymm9
	vpackssdw	%ymm9, %ymm10, %ymm9
	vextracti128	$1, %ymm9, %xmm10
	vpacksswb	%xmm10, %xmm9, %xmm9
	vdivps	%ymm3, %ymm7, %ymm7
	vpshufd	$216, %xmm9, %xmm9              # xmm9 = xmm9[0,2,1,3]
	vdivps	%ymm3, %ymm8, %ymm8
	vpxor	%xmm6, %xmm9, %xmm9
	vmovdqu	%xmm9, 16(%r8,%rax)
	vmaxps	%ymm4, %ymm7, %ymm7
	vminps	%ymm5, %ymm7, %ymm7
	vmaxps	%ymm4, %ymm8, %ymm8
	vminps	%ymm5, %ymm8, %ymm8
	vcvtps2dq	%ymm7, %ymm7
	vcvtps2dq	%ymm8, %ymm8
	vpackssdw	%ymm8, %ymm7, %ymm7
	vextracti128	$1, %ymm7, %xmm8
	vpacksswb	%xmm8, %xmm7, %xmm7
	vpshufd	$216, %xmm7, %xmm7              # xmm7 = xmm7[0,2,1,3]
	vpxor	%xmm6, %xmm7, %xmm7
	vmovdqu	%xmm7, 16(%r9,%rax)
	addq	$16, %rax
	cmpq	$176, %rax
	jb	.LBB7_1
# %bb.2:
	vzeroupper
	retq
.Lfunc_end7:
	.size	_ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_, .Lfunc_end7-_ZN3fx23opt20rms_norm_quant192_x3EPKfPfS2_PhS4_S4_
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt10quant64_u8EPKffPh
.LCPI8_0:
	.long	0xc3000000                      # float -128
.LCPI8_1:
	.long	0x42fe0000                      # float 127
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI8_2:
	.zero	16,128
	.section	.rodata,"a",@progbits
.LCPI8_3:
	.byte	128                             # 0x80
	.section	.text._ZN3fx23opt10quant64_u8EPKffPh,"ax",@progbits
	.globl	_ZN3fx23opt10quant64_u8EPKffPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt10quant64_u8EPKffPh,@function
_ZN3fx23opt10quant64_u8EPKffPh:         # @_ZN3fx23opt10quant64_u8EPKffPh
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rdi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm2
	vmovups	32(%rdi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm3
	vbroadcastss	.LCPI8_0(%rip), %ymm1   # ymm1 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vmaxps	%ymm1, %ymm2, %ymm4
	vbroadcastss	.LCPI8_1(%rip), %ymm2   # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vpackssdw	%ymm3, %ymm4, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm4              # xmm4 = xmm3[0,2,1,3]
	vpbroadcastb	.LCPI8_3(%rip), %xmm3   # xmm3 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, (%rsi)
	vmovups	64(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	96(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 16(%rsi)
	vmovups	128(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	160(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vpxor	%xmm3, %xmm4, %xmm4
	vmovdqu	%xmm4, 32(%rsi)
	vmovups	192(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmovups	224(%rdi), %ymm5
	vdivps	%ymm0, %ymm5, %ymm0
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm0, %ymm0
	vminps	%ymm2, %ymm0, %ymm0
	vcvtps2dq	%ymm4, %ymm1
	vcvtps2dq	%ymm0, %ymm0
	vpackssdw	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpacksswb	%xmm1, %xmm0, %xmm0
	vpshufd	$216, %xmm0, %xmm0              # xmm0 = xmm0[0,2,1,3]
	vpxor	%xmm3, %xmm0, %xmm0
	vmovdqu	%xmm0, 48(%rsi)
	vzeroupper
	retq
.Lfunc_end8:
	.size	_ZN3fx23opt10quant64_u8EPKffPh, .Lfunc_end8-_ZN3fx23opt10quant64_u8EPKffPh
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt10quant64_i8EPKffPa
.LCPI9_0:
	.long	0xc3000000                      # float -128
.LCPI9_1:
	.long	0x42fe0000                      # float 127
	.section	.text._ZN3fx23opt10quant64_i8EPKffPa,"ax",@progbits
	.globl	_ZN3fx23opt10quant64_i8EPKffPa
	.p2align	4, 0x90
	.type	_ZN3fx23opt10quant64_i8EPKffPa,@function
_ZN3fx23opt10quant64_i8EPKffPa:         # @_ZN3fx23opt10quant64_i8EPKffPa
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vdivps	%ymm0, %ymm1, %ymm3
	vdivps	%ymm0, %ymm2, %ymm4
	vbroadcastss	.LCPI9_0(%rip), %ymm1   # ymm1 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vmaxps	%ymm1, %ymm3, %ymm3
	vbroadcastss	.LCPI9_1(%rip), %ymm2   # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, (%rsi)
	vmovups	64(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	96(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 16(%rsi)
	vmovups	128(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	160(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 32(%rsi)
	vmovups	192(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	224(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm0
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm0, %ymm0
	vminps	%ymm2, %ymm0, %ymm0
	vcvtps2dq	%ymm3, %ymm1
	vcvtps2dq	%ymm0, %ymm0
	vpackssdw	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpacksswb	%xmm1, %xmm0, %xmm0
	vpshufd	$216, %xmm0, %xmm0              # xmm0 = xmm0[0,2,1,3]
	vmovdqu	%xmm0, 48(%rsi)
	vzeroupper
	retq
.Lfunc_end9:
	.size	_ZN3fx23opt10quant64_i8EPKffPa, .Lfunc_end9-_ZN3fx23opt10quant64_i8EPKffPa
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt14relu2_quant768EPKffPh
.LCPI10_0:
	.long	0xc3000000                      # float -128
.LCPI10_1:
	.long	0x42fe0000                      # float 127
	.section	.text._ZN3fx23opt14relu2_quant768EPKffPh,"ax",@progbits
	.globl	_ZN3fx23opt14relu2_quant768EPKffPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt14relu2_quant768EPKffPh,@function
_ZN3fx23opt14relu2_quant768EPKffPh:     # @_ZN3fx23opt14relu2_quant768EPKffPh
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	movq	$-16, %rax
	vxorps	%xmm1, %xmm1, %xmm1
	vbroadcastss	.LCPI10_0(%rip), %ymm2  # ymm2 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI10_1(%rip), %ymm3  # ymm3 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	.p2align	4, 0x90
.LBB10_1:                               # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm4
	vmovups	96(%rdi,%rax,4), %ymm5
	vmaxps	%ymm1, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm5, %ymm5
	vmulps	%ymm4, %ymm4, %ymm4
	vmulps	%ymm5, %ymm5, %ymm5
	vdivps	%ymm0, %ymm4, %ymm4
	vdivps	%ymm0, %ymm5, %ymm5
	vmaxps	%ymm2, %ymm4, %ymm4
	vminps	%ymm3, %ymm4, %ymm4
	vmaxps	%ymm2, %ymm5, %ymm5
	vminps	%ymm3, %ymm5, %ymm5
	vcvtps2dq	%ymm4, %ymm4
	vcvtps2dq	%ymm5, %ymm5
	vpackssdw	%ymm5, %ymm4, %ymm4
	vextracti128	$1, %ymm4, %xmm5
	vpacksswb	%xmm5, %xmm4, %xmm4
	vpshufd	$216, %xmm4, %xmm4              # xmm4 = xmm4[0,2,1,3]
	vmovdqu	%xmm4, 16(%rsi,%rax)
	addq	$16, %rax
	cmpq	$752, %rax                      # imm = 0x2F0
	jb	.LBB10_1
# %bb.2:
	vzeroupper
	retq
.Lfunc_end10:
	.size	_ZN3fx23opt14relu2_quant768EPKffPh, .Lfunc_end10-_ZN3fx23opt14relu2_quant768EPKffPh
                                        # -- End function
	.section	.text._ZN3fx23opt12axpby_tok192EfPffPKf,"ax",@progbits
	.globl	_ZN3fx23opt12axpby_tok192EfPffPKf # -- Begin function _ZN3fx23opt12axpby_tok192EfPffPKf
	.p2align	4, 0x90
	.type	_ZN3fx23opt12axpby_tok192EfPffPKf,@function
_ZN3fx23opt12axpby_tok192EfPffPKf:      # @_ZN3fx23opt12axpby_tok192EfPffPKf
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vbroadcastss	%xmm1, %ymm1
	vmulps	(%rsi), %ymm1, %ymm2
	vfmadd231ps	(%rdi), %ymm0, %ymm2    # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, (%rdi)
	vmulps	32(%rsi), %ymm1, %ymm2
	vfmadd231ps	32(%rdi), %ymm0, %ymm2  # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 32(%rdi)
	vmulps	64(%rsi), %ymm1, %ymm2
	vfmadd231ps	64(%rdi), %ymm0, %ymm2  # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 64(%rdi)
	vmulps	96(%rsi), %ymm1, %ymm2
	vfmadd231ps	96(%rdi), %ymm0, %ymm2  # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 96(%rdi)
	vmulps	128(%rsi), %ymm1, %ymm2
	vfmadd231ps	128(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 128(%rdi)
	vmulps	160(%rsi), %ymm1, %ymm2
	vfmadd231ps	160(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 160(%rdi)
	vmulps	192(%rsi), %ymm1, %ymm2
	vfmadd231ps	192(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 192(%rdi)
	vmulps	224(%rsi), %ymm1, %ymm2
	vfmadd231ps	224(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 224(%rdi)
	vmulps	256(%rsi), %ymm1, %ymm2
	vfmadd231ps	256(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 256(%rdi)
	vmulps	288(%rsi), %ymm1, %ymm2
	vfmadd231ps	288(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 288(%rdi)
	vmulps	320(%rsi), %ymm1, %ymm2
	vfmadd231ps	320(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 320(%rdi)
	vmulps	352(%rsi), %ymm1, %ymm2
	vfmadd231ps	352(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 352(%rdi)
	vmulps	384(%rsi), %ymm1, %ymm2
	vfmadd231ps	384(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 384(%rdi)
	vmulps	416(%rsi), %ymm1, %ymm2
	vfmadd231ps	416(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 416(%rdi)
	vmulps	448(%rsi), %ymm1, %ymm2
	vfmadd231ps	448(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 448(%rdi)
	vmulps	480(%rsi), %ymm1, %ymm2
	vfmadd231ps	480(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 480(%rdi)
	vmulps	512(%rsi), %ymm1, %ymm2
	vfmadd231ps	512(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 512(%rdi)
	vmulps	544(%rsi), %ymm1, %ymm2
	vfmadd231ps	544(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 544(%rdi)
	vmulps	576(%rsi), %ymm1, %ymm2
	vfmadd231ps	576(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 576(%rdi)
	vmulps	608(%rsi), %ymm1, %ymm2
	vfmadd231ps	608(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 608(%rdi)
	vmulps	640(%rsi), %ymm1, %ymm2
	vfmadd231ps	640(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 640(%rdi)
	vmulps	672(%rsi), %ymm1, %ymm2
	vfmadd231ps	672(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 672(%rdi)
	vmulps	704(%rsi), %ymm1, %ymm2
	vfmadd231ps	704(%rdi), %ymm0, %ymm2 # ymm2 = (ymm0 * mem) + ymm2
	vmovups	%ymm2, 704(%rdi)
	vmulps	736(%rsi), %ymm1, %ymm1
	vfmadd231ps	736(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	%ymm1, 736(%rdi)
	vzeroupper
	retq
.Lfunc_end11:
	.size	_ZN3fx23opt12axpby_tok192EfPffPKf, .Lfunc_end11-_ZN3fx23opt12axpby_tok192EfPffPKf
                                        # -- End function
	.section	.text._ZN3fx23opt6add192EPfPKf,"ax",@progbits
	.globl	_ZN3fx23opt6add192EPfPKf        # -- Begin function _ZN3fx23opt6add192EPfPKf
	.p2align	4, 0x90
	.type	_ZN3fx23opt6add192EPfPKf,@function
_ZN3fx23opt6add192EPfPKf:               # @_ZN3fx23opt6add192EPfPKf
# %bb.0:
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm1
	vmovups	64(%rdi), %ymm2
	vaddps	(%rsi), %ymm0, %ymm0
	vmovups	96(%rdi), %ymm3
	vmovups	%ymm0, (%rdi)
	vaddps	32(%rsi), %ymm1, %ymm0
	vmovups	%ymm0, 32(%rdi)
	vaddps	64(%rsi), %ymm2, %ymm0
	vmovups	%ymm0, 64(%rdi)
	vaddps	96(%rsi), %ymm3, %ymm0
	vmovups	%ymm0, 96(%rdi)
	vmovups	128(%rdi), %ymm0
	vaddps	128(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 128(%rdi)
	vmovups	160(%rdi), %ymm0
	vaddps	160(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 160(%rdi)
	vmovups	192(%rdi), %ymm0
	vaddps	192(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 192(%rdi)
	vmovups	224(%rdi), %ymm0
	vaddps	224(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 224(%rdi)
	vmovups	256(%rdi), %ymm0
	vaddps	256(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 256(%rdi)
	vmovups	288(%rdi), %ymm0
	vaddps	288(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 288(%rdi)
	vmovups	320(%rdi), %ymm0
	vaddps	320(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 320(%rdi)
	vmovups	352(%rdi), %ymm0
	vaddps	352(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 352(%rdi)
	vmovups	384(%rdi), %ymm0
	vaddps	384(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 384(%rdi)
	vmovups	416(%rdi), %ymm0
	vaddps	416(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 416(%rdi)
	vmovups	448(%rdi), %ymm0
	vaddps	448(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 448(%rdi)
	vmovups	480(%rdi), %ymm0
	vaddps	480(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 480(%rdi)
	vmovups	512(%rdi), %ymm0
	vaddps	512(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 512(%rdi)
	vmovups	544(%rdi), %ymm0
	vaddps	544(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 544(%rdi)
	vmovups	576(%rdi), %ymm0
	vaddps	576(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 576(%rdi)
	vmovups	608(%rdi), %ymm0
	vaddps	608(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 608(%rdi)
	vmovups	640(%rdi), %ymm0
	vaddps	640(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 640(%rdi)
	vmovups	672(%rdi), %ymm0
	vaddps	672(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 672(%rdi)
	vmovups	704(%rdi), %ymm0
	vaddps	704(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 704(%rdi)
	vmovups	736(%rdi), %ymm0
	vaddps	736(%rsi), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rdi)
	vzeroupper
	retq
.Lfunc_end12:
	.size	_ZN3fx23opt6add192EPfPKf, .Lfunc_end12-_ZN3fx23opt6add192EPfPKf
                                        # -- End function
	.section	.text._ZN3fx23opt13add_scaled192EPffPKf,"ax",@progbits
	.globl	_ZN3fx23opt13add_scaled192EPffPKf # -- Begin function _ZN3fx23opt13add_scaled192EPffPKf
	.p2align	4, 0x90
	.type	_ZN3fx23opt13add_scaled192EPffPKf,@function
_ZN3fx23opt13add_scaled192EPffPKf:      # @_ZN3fx23opt13add_scaled192EPffPKf
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rsi), %ymm1
	vfmadd213ps	(%rdi), %ymm0, %ymm1    # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, (%rdi)
	vmovups	32(%rsi), %ymm1
	vfmadd213ps	32(%rdi), %ymm0, %ymm1  # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 32(%rdi)
	vmovups	64(%rsi), %ymm1
	vfmadd213ps	64(%rdi), %ymm0, %ymm1  # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 64(%rdi)
	vmovups	96(%rsi), %ymm1
	vfmadd213ps	96(%rdi), %ymm0, %ymm1  # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 96(%rdi)
	vmovups	128(%rsi), %ymm1
	vfmadd213ps	128(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 128(%rdi)
	vmovups	160(%rsi), %ymm1
	vfmadd213ps	160(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 160(%rdi)
	vmovups	192(%rsi), %ymm1
	vfmadd213ps	192(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 192(%rdi)
	vmovups	224(%rsi), %ymm1
	vfmadd213ps	224(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 224(%rdi)
	vmovups	256(%rsi), %ymm1
	vfmadd213ps	256(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 256(%rdi)
	vmovups	288(%rsi), %ymm1
	vfmadd213ps	288(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 288(%rdi)
	vmovups	320(%rsi), %ymm1
	vfmadd213ps	320(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 320(%rdi)
	vmovups	352(%rsi), %ymm1
	vfmadd213ps	352(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 352(%rdi)
	vmovups	384(%rsi), %ymm1
	vfmadd213ps	384(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 384(%rdi)
	vmovups	416(%rsi), %ymm1
	vfmadd213ps	416(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 416(%rdi)
	vmovups	448(%rsi), %ymm1
	vfmadd213ps	448(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 448(%rdi)
	vmovups	480(%rsi), %ymm1
	vfmadd213ps	480(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 480(%rdi)
	vmovups	512(%rsi), %ymm1
	vfmadd213ps	512(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 512(%rdi)
	vmovups	544(%rsi), %ymm1
	vfmadd213ps	544(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 544(%rdi)
	vmovups	576(%rsi), %ymm1
	vfmadd213ps	576(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 576(%rdi)
	vmovups	608(%rsi), %ymm1
	vfmadd213ps	608(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 608(%rdi)
	vmovups	640(%rsi), %ymm1
	vfmadd213ps	640(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 640(%rdi)
	vmovups	672(%rsi), %ymm1
	vfmadd213ps	672(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 672(%rdi)
	vmovups	704(%rsi), %ymm1
	vfmadd213ps	704(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 704(%rdi)
	vmovups	736(%rsi), %ymm1
	vfmadd213ps	736(%rdi), %ymm0, %ymm1 # ymm1 = (ymm0 * ymm1) + mem
	vmovups	%ymm1, 736(%rdi)
	vzeroupper
	retq
.Lfunc_end13:
	.size	_ZN3fx23opt13add_scaled192EPffPKf, .Lfunc_end13-_ZN3fx23opt13add_scaled192EPffPKf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf
.LCPI14_0:
	.long	0x43400000                      # float 192
.LCPI14_1:
	.long	0x34000000                      # float 1.1920929E-7
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0
.LCPI14_2:
	.zero	32
	.section	.text._ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf,"ax",@progbits
	.globl	_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf,@function
_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf: # @_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf
# %bb.0:
	pushq	%r14
	pushq	%rbx
	subq	$200, %rsp
	leaq	3(%rdi), %rax
	leaq	12(%rdx), %rcx
	xorl	%r8d, %r8d
	jmp	.LBB14_1
	.p2align	4, 0x90
.LBB14_5:                               #   in Loop: Header=BB14_1 Depth=1
	vbroadcastss	%xmm0, %ymm3
	vpmovsxbd	(%rdi,%r10), %ymm0
	vpmovsxbd	8(%rdi,%r10), %ymm1
	vpmovsxbd	16(%rdi,%r10), %ymm2
	vpmovsxbd	24(%rdi,%r10), %ymm4
	vcvtdq2ps	%ymm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vcvtdq2ps	%ymm2, %ymm2
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm0, %ymm3, %ymm0
	vmulps	%ymm1, %ymm3, %ymm1
	vmulps	%ymm2, %ymm3, %ymm2
	vmulps	%ymm4, %ymm3, %ymm4
	vmovups	%ymm0, (%r9)
	vmovups	%ymm1, 32(%r9)
	vmovups	%ymm2, 64(%r9)
	vmovups	%ymm4, 96(%r9)
	vpmovsxbd	32(%rdi,%r10), %ymm0
	vpmovsxbd	40(%rdi,%r10), %ymm1
	vpmovsxbd	48(%rdi,%r10), %ymm2
	vpmovsxbd	56(%rdi,%r10), %ymm4
	vcvtdq2ps	%ymm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vcvtdq2ps	%ymm2, %ymm2
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm0, %ymm3, %ymm0
	vmulps	%ymm1, %ymm3, %ymm1
	vmulps	%ymm2, %ymm3, %ymm2
	vmulps	%ymm4, %ymm3, %ymm4
	vmovups	%ymm0, 128(%r9)
	vmovups	%ymm1, 160(%r9)
	vmovups	%ymm2, 192(%r9)
	vmovups	%ymm4, 224(%r9)
	vpmovsxbd	64(%rdi,%r10), %ymm0
	vpmovsxbd	72(%rdi,%r10), %ymm1
	vpmovsxbd	80(%rdi,%r10), %ymm2
	vpmovsxbd	88(%rdi,%r10), %ymm4
	vcvtdq2ps	%ymm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vcvtdq2ps	%ymm2, %ymm2
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm0, %ymm3, %ymm0
	vmulps	%ymm1, %ymm3, %ymm1
	vmulps	%ymm2, %ymm3, %ymm2
	vmulps	%ymm4, %ymm3, %ymm4
	vmovups	%ymm0, 256(%r9)
	vmovups	%ymm1, 288(%r9)
	vmovups	%ymm2, 320(%r9)
	vmovups	%ymm4, 352(%r9)
	vpmovsxbd	96(%rdi,%r10), %ymm0
	vpmovsxbd	104(%rdi,%r10), %ymm1
	vpmovsxbd	112(%rdi,%r10), %ymm2
	vpmovsxbd	120(%rdi,%r10), %ymm4
	vcvtdq2ps	%ymm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vcvtdq2ps	%ymm2, %ymm2
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm0, %ymm3, %ymm0
	vmulps	%ymm1, %ymm3, %ymm1
	vmulps	%ymm2, %ymm3, %ymm2
	vmulps	%ymm4, %ymm3, %ymm4
	vmovups	%ymm0, 384(%r9)
	vmovups	%ymm1, 416(%r9)
	vmovups	%ymm2, 448(%r9)
	vmovups	%ymm4, 480(%r9)
	vpmovsxbd	128(%rdi,%r10), %ymm0
	vpmovsxbd	136(%rdi,%r10), %ymm1
	vpmovsxbd	144(%rdi,%r10), %ymm2
	vpmovsxbd	152(%rdi,%r10), %ymm4
	vcvtdq2ps	%ymm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vcvtdq2ps	%ymm2, %ymm2
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm0, %ymm3, %ymm0
	vmulps	%ymm1, %ymm3, %ymm1
	vmulps	%ymm2, %ymm3, %ymm2
	vmulps	%ymm4, %ymm3, %ymm4
	vmovups	%ymm0, 512(%r9)
	vmovups	%ymm1, 544(%r9)
	vmovups	%ymm2, 576(%r9)
	vmovups	%ymm4, 608(%r9)
	vpmovsxbd	160(%rdi,%r10), %ymm0
	vpmovsxbd	168(%rdi,%r10), %ymm1
	vpmovsxbd	176(%rdi,%r10), %ymm2
	vpmovsxbd	184(%rdi,%r10), %ymm4
	vcvtdq2ps	%ymm0, %ymm0
	vcvtdq2ps	%ymm1, %ymm1
	vcvtdq2ps	%ymm2, %ymm2
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm0, %ymm3, %ymm0
	vmulps	%ymm1, %ymm3, %ymm1
	vmulps	%ymm2, %ymm3, %ymm2
	vmulps	%ymm4, %ymm3, %ymm3
	vmovups	%ymm0, 640(%r9)
	vmovups	%ymm1, 672(%r9)
	vmovups	%ymm2, 704(%r9)
	vmovups	%ymm3, 736(%r9)
.LBB14_6:                               #   in Loop: Header=BB14_1 Depth=1
	vmovups	(%r9), %ymm6
	vmovups	%ymm6, 160(%rsp)                # 32-byte Spill
	vmovups	32(%r9), %ymm2
	vmovups	%ymm2, 64(%rsp)                 # 32-byte Spill
	vmovups	64(%r9), %ymm1
	vmovups	%ymm1, 96(%rsp)                 # 32-byte Spill
	vmovups	96(%r9), %ymm0
	vmovups	%ymm0, 128(%rsp)                # 32-byte Spill
	vfmadd213ps	.LCPI14_2(%rip), %ymm6, %ymm6 # ymm6 = (ymm6 * ymm6) + mem
	vfmadd231ps	%ymm2, %ymm2, %ymm6     # ymm6 = (ymm2 * ymm2) + ymm6
	vfmadd231ps	%ymm1, %ymm1, %ymm6     # ymm6 = (ymm1 * ymm1) + ymm6
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	128(%r9), %ymm0
	vmovups	%ymm0, 32(%rsp)                 # 32-byte Spill
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	160(%r9), %ymm0
	vmovups	%ymm0, (%rsp)                   # 32-byte Spill
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	192(%r9), %ymm0
	vmovups	%ymm0, -32(%rsp)                # 32-byte Spill
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	224(%r9), %ymm0
	vmovups	%ymm0, -64(%rsp)                # 32-byte Spill
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	256(%r9), %ymm0
	vmovups	%ymm0, -96(%rsp)                # 32-byte Spill
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	288(%r9), %ymm0
	vmovups	%ymm0, -128(%rsp)               # 32-byte Spill
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vmovups	320(%r9), %ymm13
	vfmadd231ps	%ymm13, %ymm13, %ymm6   # ymm6 = (ymm13 * ymm13) + ymm6
	vmovups	352(%r9), %ymm14
	vfmadd231ps	%ymm14, %ymm14, %ymm6   # ymm6 = (ymm14 * ymm14) + ymm6
	vmovups	384(%r9), %ymm15
	vfmadd231ps	%ymm15, %ymm15, %ymm6   # ymm6 = (ymm15 * ymm15) + ymm6
	vmovups	416(%r9), %ymm11
	vfmadd231ps	%ymm11, %ymm11, %ymm6   # ymm6 = (ymm11 * ymm11) + ymm6
	vmovups	448(%r9), %ymm10
	vfmadd231ps	%ymm10, %ymm10, %ymm6   # ymm6 = (ymm10 * ymm10) + ymm6
	vmovups	480(%r9), %ymm9
	vfmadd231ps	%ymm9, %ymm9, %ymm6     # ymm6 = (ymm9 * ymm9) + ymm6
	vmovups	512(%r9), %ymm8
	vfmadd231ps	%ymm8, %ymm8, %ymm6     # ymm6 = (ymm8 * ymm8) + ymm6
	vmovups	544(%r9), %ymm7
	vfmadd231ps	%ymm7, %ymm7, %ymm6     # ymm6 = (ymm7 * ymm7) + ymm6
	vmovups	576(%r9), %ymm5
	vfmadd231ps	%ymm5, %ymm5, %ymm6     # ymm6 = (ymm5 * ymm5) + ymm6
	vmovups	608(%r9), %ymm4
	vfmadd231ps	%ymm4, %ymm4, %ymm6     # ymm6 = (ymm4 * ymm4) + ymm6
	vmovups	640(%r9), %ymm3
	vfmadd231ps	%ymm3, %ymm3, %ymm6     # ymm6 = (ymm3 * ymm3) + ymm6
	vmovups	672(%r9), %ymm2
	vfmadd231ps	%ymm2, %ymm2, %ymm6     # ymm6 = (ymm2 * ymm2) + ymm6
	vmovups	704(%r9), %ymm1
	vfmadd231ps	%ymm1, %ymm1, %ymm6     # ymm6 = (ymm1 * ymm1) + ymm6
	vmovups	736(%r9), %ymm0
	vfmadd231ps	%ymm0, %ymm0, %ymm6     # ymm6 = (ymm0 * ymm0) + ymm6
	vextractf128	$1, %ymm6, %xmm12
	vaddps	%xmm6, %xmm12, %xmm6
	vshufpd	$1, %xmm6, %xmm6, %xmm12        # xmm12 = xmm6[1,0]
	vaddps	%xmm6, %xmm12, %xmm6
	vmovshdup	%xmm6, %xmm12           # xmm12 = xmm6[1,1,3,3]
	vaddss	%xmm6, %xmm12, %xmm6
	vdivss	.LCPI14_0(%rip), %xmm6, %xmm6
	vaddss	.LCPI14_1(%rip), %xmm6, %xmm6
	vsqrtss	%xmm6, %xmm6, %xmm6
	vbroadcastss	%xmm6, %ymm6
	vmovups	160(%rsp), %ymm12               # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, (%r9)
	vmovups	64(%rsp), %ymm12                # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 32(%r9)
	vmovups	96(%rsp), %ymm12                # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 64(%r9)
	vmovups	128(%rsp), %ymm12               # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 96(%r9)
	vmovups	32(%rsp), %ymm12                # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 128(%r9)
	vmovups	(%rsp), %ymm12                  # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 160(%r9)
	vmovups	-32(%rsp), %ymm12               # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 192(%r9)
	vmovups	-64(%rsp), %ymm12               # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 224(%r9)
	vmovups	-96(%rsp), %ymm12               # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 256(%r9)
	vmovups	-128(%rsp), %ymm12              # 32-byte Reload
	vdivps	%ymm6, %ymm12, %ymm12
	vmovups	%ymm12, 288(%r9)
	vdivps	%ymm6, %ymm13, %ymm12
	vmovups	%ymm12, 320(%r9)
	vdivps	%ymm6, %ymm14, %ymm12
	vmovups	%ymm12, 352(%r9)
	vdivps	%ymm6, %ymm15, %ymm12
	vmovups	%ymm12, 384(%r9)
	vdivps	%ymm6, %ymm11, %ymm11
	vmovups	%ymm11, 416(%r9)
	vdivps	%ymm6, %ymm10, %ymm10
	vmovups	%ymm10, 448(%r9)
	vdivps	%ymm6, %ymm9, %ymm9
	vmovups	%ymm9, 480(%r9)
	vdivps	%ymm6, %ymm8, %ymm8
	vmovups	%ymm8, 512(%r9)
	vdivps	%ymm6, %ymm7, %ymm7
	vmovups	%ymm7, 544(%r9)
	vdivps	%ymm6, %ymm5, %ymm5
	vmovups	%ymm5, 576(%r9)
	vdivps	%ymm6, %ymm4, %ymm4
	vmovups	%ymm4, 608(%r9)
	vdivps	%ymm6, %ymm3, %ymm3
	vmovups	%ymm3, 640(%r9)
	vdivps	%ymm6, %ymm2, %ymm2
	vmovups	%ymm2, 672(%r9)
	vdivps	%ymm6, %ymm1, %ymm1
	vmovups	%ymm1, 704(%r9)
	vdivps	%ymm6, %ymm0, %ymm0
	vmovups	%ymm0, 736(%r9)
	incq	%r8
	addq	$192, %rax
	addq	$768, %rcx                      # imm = 0x300
	cmpq	$205, %r8
	je	.LBB14_7
.LBB14_1:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB14_4 Depth 2
	movq	%r8, %r9
	shlq	$6, %r9
	leaq	(%r9,%r9,2), %r10
	leaq	(%rdx,%r10,4), %r9
	vmovss	(%rsi,%r8,4), %xmm0             # xmm0 = mem[0],zero,zero,zero
	leaq	(%rdi,%r10), %rbx
	addq	$192, %rbx
	leaq	(%r8,%r8,2), %r11
	shlq	$8, %r11
	leaq	(%rdx,%r11), %r14
	cmpq	%rbx, %r14
	jae	.LBB14_5
# %bb.2:                                #   in Loop: Header=BB14_1 Depth=1
	leaq	(%rdi,%r10), %rbx
	addq	%rdx, %r11
	addq	$768, %r11                      # imm = 0x300
	cmpq	%r11, %rbx
	jae	.LBB14_5
# %bb.3:                                #   in Loop: Header=BB14_1 Depth=1
	xorl	%r10d, %r10d
	.p2align	4, 0x90
.LBB14_4:                               #   Parent Loop BB14_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movsbl	-3(%rax,%r10), %r11d
	vxorps	%xmm13, %xmm13, %xmm13
	vcvtsi2ss	%r11d, %xmm13, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	vmovss	%xmm1, -12(%rcx,%r10,4)
	movsbl	-2(%rax,%r10), %r11d
	vxorps	%xmm13, %xmm13, %xmm13
	vcvtsi2ss	%r11d, %xmm13, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	vmovss	%xmm1, -8(%rcx,%r10,4)
	movsbl	-1(%rax,%r10), %r11d
	vxorps	%xmm13, %xmm13, %xmm13
	vcvtsi2ss	%r11d, %xmm13, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	vmovss	%xmm1, -4(%rcx,%r10,4)
	movsbl	(%rax,%r10), %r11d
	vcvtsi2ss	%r11d, %xmm13, %xmm1
	vmulss	%xmm1, %xmm0, %xmm1
	vmovss	%xmm1, (%rcx,%r10,4)
	addq	$4, %r10
	cmpq	$192, %r10
	jne	.LBB14_4
	jmp	.LBB14_6
.LBB14_7:
	addq	$200, %rsp
	popq	%rbx
	popq	%r14
	vzeroupper
	retq
.Lfunc_end14:
	.size	_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf, .Lfunc_end14-_ZN3fx23opt28build_normed_embedding_tableEPKaPKfPf
                                        # -- End function
	.section	.text._ZN3fx23opt16prior_f16_to_f32EPKtPf,"ax",@progbits
	.globl	_ZN3fx23opt16prior_f16_to_f32EPKtPf # -- Begin function _ZN3fx23opt16prior_f16_to_f32EPKtPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt16prior_f16_to_f32EPKtPf,@function
_ZN3fx23opt16prior_f16_to_f32EPKtPf:    # @_ZN3fx23opt16prior_f16_to_f32EPKtPf
# %bb.0:
	vcvtph2ps	(%rdi), %ymm0
	vmovups	%ymm0, (%rsi)
	vcvtph2ps	16(%rdi), %ymm0
	vmovups	%ymm0, 32(%rsi)
	vcvtph2ps	32(%rdi), %ymm0
	vmovups	%ymm0, 64(%rsi)
	vcvtph2ps	48(%rdi), %ymm0
	vmovups	%ymm0, 96(%rsi)
	vcvtph2ps	64(%rdi), %ymm0
	vmovups	%ymm0, 128(%rsi)
	vcvtph2ps	80(%rdi), %ymm0
	vmovups	%ymm0, 160(%rsi)
	vcvtph2ps	96(%rdi), %ymm0
	vmovups	%ymm0, 192(%rsi)
	vcvtph2ps	112(%rdi), %ymm0
	vmovups	%ymm0, 224(%rsi)
	vcvtph2ps	128(%rdi), %ymm0
	vmovups	%ymm0, 256(%rsi)
	vcvtph2ps	144(%rdi), %ymm0
	vmovups	%ymm0, 288(%rsi)
	vcvtph2ps	160(%rdi), %ymm0
	vmovups	%ymm0, 320(%rsi)
	vcvtph2ps	176(%rdi), %ymm0
	vmovups	%ymm0, 352(%rsi)
	vcvtph2ps	192(%rdi), %ymm0
	vmovups	%ymm0, 384(%rsi)
	vcvtph2ps	208(%rdi), %ymm0
	vmovups	%ymm0, 416(%rsi)
	vcvtph2ps	224(%rdi), %ymm0
	vmovups	%ymm0, 448(%rsi)
	vcvtph2ps	240(%rdi), %ymm0
	vmovups	%ymm0, 480(%rsi)
	vcvtph2ps	256(%rdi), %ymm0
	vmovups	%ymm0, 512(%rsi)
	vcvtph2ps	272(%rdi), %ymm0
	vmovups	%ymm0, 544(%rsi)
	vcvtph2ps	288(%rdi), %ymm0
	vmovups	%ymm0, 576(%rsi)
	vcvtph2ps	304(%rdi), %ymm0
	vmovups	%ymm0, 608(%rsi)
	vcvtph2ps	320(%rdi), %ymm0
	vmovups	%ymm0, 640(%rsi)
	vcvtph2ps	336(%rdi), %ymm0
	vmovups	%ymm0, 672(%rsi)
	vcvtph2ps	352(%rdi), %ymm0
	vmovups	%ymm0, 704(%rsi)
	vcvtph2ps	368(%rdi), %ymm0
	vmovups	%ymm0, 736(%rsi)
	vcvtph2ps	384(%rdi), %ymm0
	vmovups	%ymm0, 768(%rsi)
	vcvtph2ps	394(%rdi), %ymm0
	vmovups	%ymm0, 788(%rsi)
	movl	$0, 828(%rsi)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovlps	%xmm0, 820(%rsi)
	vzeroupper
	retq
.Lfunc_end15:
	.size	_ZN3fx23opt16prior_f16_to_f32EPKtPf, .Lfunc_end15-_ZN3fx23opt16prior_f16_to_f32EPKtPf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt15prior_quant_rawEPKffPh
.LCPI16_0:
	.long	0xc3000000                      # float -128
.LCPI16_1:
	.long	0x42fe0000                      # float 127
	.section	.text._ZN3fx23opt15prior_quant_rawEPKffPh,"ax",@progbits
	.globl	_ZN3fx23opt15prior_quant_rawEPKffPh
	.p2align	4, 0x90
	.type	_ZN3fx23opt15prior_quant_rawEPKffPh,@function
_ZN3fx23opt15prior_quant_rawEPKffPh:    # @_ZN3fx23opt15prior_quant_rawEPKffPh
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rdi), %ymm1
	vmovups	32(%rdi), %ymm2
	vdivps	%ymm0, %ymm1, %ymm3
	vdivps	%ymm0, %ymm2, %ymm4
	vbroadcastss	.LCPI16_0(%rip), %ymm1  # ymm1 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vmaxps	%ymm1, %ymm3, %ymm3
	vbroadcastss	.LCPI16_1(%rip), %ymm2  # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, (%rsi)
	vmovups	64(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	96(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 16(%rsi)
	vmovups	128(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	160(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 32(%rsi)
	vmovups	192(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	224(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 48(%rsi)
	vmovups	256(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	288(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 64(%rsi)
	vmovups	320(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	352(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 80(%rsi)
	vmovups	384(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	416(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 96(%rsi)
	vmovups	448(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	480(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 112(%rsi)
	vmovups	512(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	544(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 128(%rsi)
	vmovups	576(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	608(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 144(%rsi)
	vmovups	640(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	672(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 160(%rsi)
	vmovups	704(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	736(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm4
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm4, %ymm4
	vminps	%ymm2, %ymm4, %ymm4
	vcvtps2dq	%ymm3, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpackssdw	%ymm4, %ymm3, %ymm3
	vextracti128	$1, %ymm3, %xmm4
	vpacksswb	%xmm4, %xmm3, %xmm3
	vpshufd	$216, %xmm3, %xmm3              # xmm3 = xmm3[0,2,1,3]
	vmovdqu	%xmm3, 176(%rsi)
	vmovups	768(%rdi), %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vmovups	800(%rdi), %ymm4
	vdivps	%ymm0, %ymm4, %ymm0
	vmaxps	%ymm1, %ymm3, %ymm3
	vminps	%ymm2, %ymm3, %ymm3
	vmaxps	%ymm1, %ymm0, %ymm0
	vminps	%ymm2, %ymm0, %ymm0
	vcvtps2dq	%ymm3, %ymm1
	vcvtps2dq	%ymm0, %ymm0
	vpackssdw	%ymm0, %ymm1, %ymm0
	vextracti128	$1, %ymm0, %xmm1
	vpacksswb	%xmm1, %xmm0, %xmm0
	vpshufd	$216, %xmm0, %xmm0              # xmm0 = xmm0[0,2,1,3]
	vmovdqu	%xmm0, 192(%rsi)
	vzeroupper
	retq
.Lfunc_end16:
	.size	_ZN3fx23opt15prior_quant_rawEPKffPh, .Lfunc_end16-_ZN3fx23opt15prior_quant_rawEPKffPh
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi
.LCPI17_0:
	.long	0xc3000000                      # float -128
.LCPI17_1:
	.long	0x42fe0000                      # float 127
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI17_2:
	.zero	16,128
	.section	.rodata,"a",@progbits
.LCPI17_3:
	.byte	128                             # 0x80
	.section	.text._ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi,"ax",@progbits
	.globl	_ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi
	.p2align	4, 0x90
	.type	_ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi,@function
_ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi: # @_ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi
# %bb.0:
	vbroadcastss	%xmm0, %ymm0
	addq	$32, %rdi
	xorl	%eax, %eax
	vbroadcastss	.LCPI17_0(%rip), %ymm1  # ymm1 = [-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2,-1.28E+2]
	vbroadcastss	.LCPI17_1(%rip), %ymm2  # ymm2 = [1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2,1.27E+2]
	vpbroadcastb	.LCPI17_3(%rip), %xmm3  # xmm3 = [128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128]
	vpxor	%xmm4, %xmm4, %xmm4
	xorl	%r8d, %r8d
	.p2align	4, 0x90
.LBB17_1:                               # =>This Inner Loop Header: Depth=1
	vmovups	-32(%rdi), %ymm5
	vmovups	(%rdi), %ymm6
	vdivps	%ymm0, %ymm5, %ymm5
	vdivps	%ymm0, %ymm6, %ymm6
	vmaxps	%ymm1, %ymm5, %ymm5
	vminps	%ymm2, %ymm5, %ymm5
	vmaxps	%ymm1, %ymm6, %ymm6
	vminps	%ymm2, %ymm6, %ymm6
	vcvtps2dq	%ymm5, %ymm5
	vcvtps2dq	%ymm6, %ymm6
	vpackssdw	%ymm6, %ymm5, %ymm5
	vextracti128	$1, %ymm5, %xmm6
	vpacksswb	%xmm6, %xmm5, %xmm5
	vpshufd	$216, %xmm5, %xmm5              # xmm5 = xmm5[0,2,1,3]
	vpxor	%xmm3, %xmm5, %xmm6
	vpcmpeqb	%xmm4, %xmm5, %xmm5
	vmovdqu	%xmm6, (%rsi,%rax,4)
	vpmovmskb	%xmm5, %r9d
	xorl	$65535, %r9d                    # imm = 0xFFFF
	popcntl	%r9d, %r10d
	movl	%r9d, -56(%rsp,%rax)
	addl	%r10d, %r8d
	addq	$4, %rax
	addq	$64, %rdi
	cmpq	$52, %rax
	jne	.LBB17_1
# %bb.2:
	movl	$-1, %eax
	cmpl	%ecx, %r8d
	jg	.LBB17_47
# %bb.3:
	movl	-56(%rsp), %edi
	testl	%edi, %edi
	je	.LBB17_4
# %bb.5:
	popcntl	%edi, %eax
	cmpl	$1, %eax
	jne	.LBB17_7
# %bb.6:
	xorl	%ecx, %ecx
	jmp	.LBB17_9
.LBB17_4:
	xorl	%eax, %eax
	jmp	.LBB17_11
.LBB17_7:
	movl	%eax, %r8d
	andl	$-2, %r8d
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB17_8:                               # =>This Inner Loop Header: Depth=1
	tzcntl	%edi, %r9d
	blsrl	%edi, %edi
	movw	%r9w, 4(%rdx,%rcx,2)
	movzbl	(%rsi,%r9), %r9d
	addb	$-128, %r9b
	movb	%r9b, 414(%rdx,%rcx)
	tzcntl	%edi, %r9d
	blsrl	%edi, %edi
	movw	%r9w, 6(%rdx,%rcx,2)
	movzbl	(%rsi,%r9), %r9d
	addb	$-128, %r9b
	movb	%r9b, 415(%rdx,%rcx)
	addq	$2, %rcx
	cmpq	%rcx, %r8
	jne	.LBB17_8
.LBB17_9:
	testb	$1, %al
	je	.LBB17_11
# %bb.10:
	tzcntl	%edi, %edi
	movw	%di, 4(%rdx,%rcx,2)
	movzbl	(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rcx)
.LBB17_11:
	movl	-52(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_14
# %bb.12:
	movl	%eax, %eax
	.p2align	4, 0x90
.LBB17_13:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	16(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	16(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_13
.LBB17_14:
	movl	-48(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_17
# %bb.15:
	cltq
	.p2align	4, 0x90
.LBB17_16:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	orq	$32, %rdi
	movw	%di, 4(%rdx,%rax,2)
	movzbl	(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_16
.LBB17_17:
	movl	-44(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_20
# %bb.18:
	cltq
	.p2align	4, 0x90
.LBB17_19:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	48(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	48(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_19
.LBB17_20:
	movl	-40(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_23
# %bb.21:
	cltq
	.p2align	4, 0x90
.LBB17_22:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	64(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	64(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_22
.LBB17_23:
	movl	-36(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_26
# %bb.24:
	cltq
	.p2align	4, 0x90
.LBB17_25:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	80(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	80(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_25
.LBB17_26:
	movl	-32(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_29
# %bb.27:
	cltq
	.p2align	4, 0x90
.LBB17_28:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	orq	$96, %rdi
	movw	%di, 4(%rdx,%rax,2)
	movzbl	(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_28
.LBB17_29:
	movl	-28(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_32
# %bb.30:
	cltq
	.p2align	4, 0x90
.LBB17_31:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	112(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	112(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_31
.LBB17_32:
	movl	-24(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_35
# %bb.33:
	cltq
	.p2align	4, 0x90
.LBB17_34:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	128(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	128(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_34
.LBB17_35:
	movl	-20(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_38
# %bb.36:
	cltq
	.p2align	4, 0x90
.LBB17_37:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	144(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	144(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_37
.LBB17_38:
	movl	-16(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_41
# %bb.39:
	cltq
	.p2align	4, 0x90
.LBB17_40:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	orq	$160, %rdi
	movw	%di, 4(%rdx,%rax,2)
	movzbl	(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_40
.LBB17_41:
	movl	-12(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_44
# %bb.42:
	cltq
	.p2align	4, 0x90
.LBB17_43:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	176(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	176(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_43
.LBB17_44:
	movl	-8(%rsp), %ecx
	testl	%ecx, %ecx
	je	.LBB17_47
# %bb.45:
	cltq
	.p2align	4, 0x90
.LBB17_46:                              # =>This Inner Loop Header: Depth=1
	tzcntl	%ecx, %edi
	leaq	192(%rdi), %r8
	movw	%r8w, 4(%rdx,%rax,2)
	movzbl	192(%rsi,%rdi), %edi
	addb	$-128, %dil
	movb	%dil, 414(%rdx,%rax)
	incq	%rax
	blsrl	%ecx, %ecx
	jne	.LBB17_46
.LBB17_47:
	movl	%eax, (%rdx)
	vzeroupper
	retq
.Lfunc_end17:
	.size	_ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi, .Lfunc_end17-_ZN3fx23opt11prior_quantEPKffPhPNS_10SparseActsEi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt16embed_combine192EPKfS2_Pf
.LCPI18_0:
	.long	0x43400000                      # float 192
.LCPI18_1:
	.long	0x34000000                      # float 1.1920929E-7
	.section	.text._ZN3fx23opt16embed_combine192EPKfS2_Pf,"ax",@progbits
	.globl	_ZN3fx23opt16embed_combine192EPKfS2_Pf
	.p2align	4, 0x90
	.type	_ZN3fx23opt16embed_combine192EPKfS2_Pf,@function
_ZN3fx23opt16embed_combine192EPKfS2_Pf: # @_ZN3fx23opt16embed_combine192EPKfS2_Pf
# %bb.0:
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	(%rsi), %ymm1
	vmovups	32(%rsi), %ymm2
	vmovups	64(%rsi), %ymm3
	vmovups	96(%rsi), %ymm4
	vfmadd231ps	%ymm1, %ymm1, %ymm0     # ymm0 = (ymm1 * ymm1) + ymm0
	vfmadd231ps	%ymm2, %ymm2, %ymm0     # ymm0 = (ymm2 * ymm2) + ymm0
	vfmadd231ps	%ymm3, %ymm3, %ymm0     # ymm0 = (ymm3 * ymm3) + ymm0
	vfmadd231ps	%ymm4, %ymm4, %ymm0     # ymm0 = (ymm4 * ymm4) + ymm0
	vmovups	128(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	160(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	192(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	224(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	256(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	288(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	320(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	352(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	384(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	416(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	448(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	480(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	512(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	544(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	576(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	608(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	640(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	672(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vmovups	704(%rsi), %ymm2
	vfmadd213ps	%ymm0, %ymm2, %ymm2     # ymm2 = (ymm2 * ymm2) + ymm0
	vmovups	736(%rsi), %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm0     # ymm0 = (ymm0 * ymm0) + ymm2
	vextractf128	$1, %ymm0, %xmm2
	vaddps	%xmm2, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm2         # xmm2 = xmm0[1,0]
	vaddps	%xmm2, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm2            # xmm2 = xmm0[1,1,3,3]
	vaddss	%xmm2, %xmm0, %xmm0
	vdivss	.LCPI18_0(%rip), %xmm0, %xmm0
	vaddss	.LCPI18_1(%rip), %xmm0, %xmm0
	vsqrtss	%xmm0, %xmm0, %xmm0
	vbroadcastss	%xmm0, %ymm0
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, (%rdx)
	vmovups	32(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	32(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 32(%rdx)
	vmovups	64(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	64(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 64(%rdx)
	vmovups	96(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	96(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 96(%rdx)
	vmovups	128(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	128(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 128(%rdx)
	vmovups	160(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	160(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 160(%rdx)
	vmovups	192(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	192(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 192(%rdx)
	vmovups	224(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	224(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 224(%rdx)
	vmovups	256(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	256(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 256(%rdx)
	vmovups	288(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	288(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 288(%rdx)
	vmovups	320(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	320(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 320(%rdx)
	vmovups	352(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	352(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 352(%rdx)
	vmovups	384(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	384(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 384(%rdx)
	vmovups	416(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	416(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 416(%rdx)
	vmovups	448(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	448(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 448(%rdx)
	vmovups	480(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	480(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 480(%rdx)
	vmovups	512(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	512(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 512(%rdx)
	vmovups	544(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	544(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 544(%rdx)
	vmovups	576(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	576(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 576(%rdx)
	vmovups	608(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	608(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 608(%rdx)
	vmovups	640(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	640(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 640(%rdx)
	vmovups	672(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	672(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 672(%rdx)
	vmovups	704(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vaddps	704(%rdi), %ymm1, %ymm1
	vmovups	%ymm1, 704(%rdx)
	vmovups	736(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm0
	vaddps	736(%rdi), %ymm0, %ymm0
	vmovups	%ymm0, 736(%rdx)
	vzeroupper
	retq
.Lfunc_end18:
	.size	_ZN3fx23opt16embed_combine192EPKfS2_Pf, .Lfunc_end18-_ZN3fx23opt16embed_combine192EPKfS2_Pf
                                        # -- End function
	.section	.text._ZN3fx23opt13rope_apply_64EPfPKfS3_,"ax",@progbits
	.globl	_ZN3fx23opt13rope_apply_64EPfPKfS3_ # -- Begin function _ZN3fx23opt13rope_apply_64EPfPKfS3_
	.p2align	4, 0x90
	.type	_ZN3fx23opt13rope_apply_64EPfPKfS3_,@function
_ZN3fx23opt13rope_apply_64EPfPKfS3_:    # @_ZN3fx23opt13rope_apply_64EPfPKfS3_
# %bb.0:
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm1
	vmovups	64(%rdi), %ymm2
	vmovups	96(%rdi), %ymm3
	vshufps	$136, %ymm1, %ymm0, %ymm4       # ymm4 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm4, %ymm4              # ymm4 = ymm4[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	(%rsi), %ymm1
	vmovups	(%rdx), %ymm5
	vmulps	%ymm0, %ymm1, %ymm6
	vfmadd231ps	%ymm5, %ymm4, %ymm6     # ymm6 = (ymm4 * ymm5) + ymm6
	vmulps	%ymm1, %ymm4, %ymm1
	vfmsub231ps	%ymm5, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm5) - ymm1
	vunpcklps	%ymm1, %ymm6, %ymm0     # ymm0 = ymm6[0],ymm1[0],ymm6[1],ymm1[1],ymm6[4],ymm1[4],ymm6[5],ymm1[5]
	vunpckhps	%ymm1, %ymm6, %ymm1     # ymm1 = ymm6[2],ymm1[2],ymm6[3],ymm1[3],ymm6[6],ymm1[6],ymm6[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm4
	vmovups	%ymm4, (%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 32(%rdi)
	vshufps	$136, %ymm3, %ymm2, %ymm0       # ymm0 = ymm2[0,2],ymm3[0,2],ymm2[4,6],ymm3[4,6]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vshufps	$221, %ymm3, %ymm2, %ymm1       # ymm1 = ymm2[1,3],ymm3[1,3],ymm2[5,7],ymm3[5,7]
	vpermpd	$216, %ymm1, %ymm1              # ymm1 = ymm1[0,2,1,3]
	vmovups	32(%rsi), %ymm2
	vmovups	32(%rdx), %ymm3
	vmulps	%ymm1, %ymm2, %ymm4
	vfmadd231ps	%ymm3, %ymm0, %ymm4     # ymm4 = (ymm0 * ymm3) + ymm4
	vmulps	%ymm2, %ymm0, %ymm0
	vfmsub231ps	%ymm3, %ymm1, %ymm0     # ymm0 = (ymm1 * ymm3) - ymm0
	vunpcklps	%ymm0, %ymm4, %ymm1     # ymm1 = ymm4[0],ymm0[0],ymm4[1],ymm0[1],ymm4[4],ymm0[4],ymm4[5],ymm0[5]
	vunpckhps	%ymm0, %ymm4, %ymm0     # ymm0 = ymm4[2],ymm0[2],ymm4[3],ymm0[3],ymm4[6],ymm0[6],ymm4[7],ymm0[7]
	vinsertf128	$1, %xmm0, %ymm1, %ymm2
	vmovups	%ymm2, 64(%rdi)
	vperm2f128	$49, %ymm0, %ymm1, %ymm0 # ymm0 = ymm1[2,3],ymm0[2,3]
	vmovups	%ymm0, 96(%rdi)
	vmovups	128(%rdi), %ymm0
	vmovups	160(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	64(%rsi), %ymm1
	vmovups	64(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 128(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 160(%rdi)
	vmovups	192(%rdi), %ymm0
	vmovups	224(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	96(%rsi), %ymm1
	vmovups	96(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 192(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 224(%rdi)
	vzeroupper
	retq
.Lfunc_end19:
	.size	_ZN3fx23opt13rope_apply_64EPfPKfS3_, .Lfunc_end19-_ZN3fx23opt13rope_apply_64EPfPKfS3_
                                        # -- End function
	.section	.text._ZN3fx23opt14rope_apply_192EPfPKfS3_,"ax",@progbits
	.globl	_ZN3fx23opt14rope_apply_192EPfPKfS3_ # -- Begin function _ZN3fx23opt14rope_apply_192EPfPKfS3_
	.p2align	4, 0x90
	.type	_ZN3fx23opt14rope_apply_192EPfPKfS3_,@function
_ZN3fx23opt14rope_apply_192EPfPKfS3_:   # @_ZN3fx23opt14rope_apply_192EPfPKfS3_
# %bb.0:
	vmovups	(%rdi), %ymm0
	vmovups	32(%rdi), %ymm1
	vmovups	64(%rdi), %ymm2
	vmovups	96(%rdi), %ymm3
	vshufps	$136, %ymm1, %ymm0, %ymm4       # ymm4 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm4, %ymm4              # ymm4 = ymm4[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	(%rsi), %ymm1
	vmovups	(%rdx), %ymm5
	vmulps	%ymm0, %ymm1, %ymm6
	vfmadd231ps	%ymm5, %ymm4, %ymm6     # ymm6 = (ymm4 * ymm5) + ymm6
	vmulps	%ymm1, %ymm4, %ymm1
	vfmsub231ps	%ymm5, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm5) - ymm1
	vunpcklps	%ymm1, %ymm6, %ymm0     # ymm0 = ymm6[0],ymm1[0],ymm6[1],ymm1[1],ymm6[4],ymm1[4],ymm6[5],ymm1[5]
	vunpckhps	%ymm1, %ymm6, %ymm1     # ymm1 = ymm6[2],ymm1[2],ymm6[3],ymm1[3],ymm6[6],ymm1[6],ymm6[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm4
	vmovups	%ymm4, (%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 32(%rdi)
	vshufps	$136, %ymm3, %ymm2, %ymm0       # ymm0 = ymm2[0,2],ymm3[0,2],ymm2[4,6],ymm3[4,6]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vshufps	$221, %ymm3, %ymm2, %ymm1       # ymm1 = ymm2[1,3],ymm3[1,3],ymm2[5,7],ymm3[5,7]
	vpermpd	$216, %ymm1, %ymm1              # ymm1 = ymm1[0,2,1,3]
	vmovups	32(%rsi), %ymm2
	vmovups	32(%rdx), %ymm3
	vmulps	%ymm1, %ymm2, %ymm4
	vfmadd231ps	%ymm3, %ymm0, %ymm4     # ymm4 = (ymm0 * ymm3) + ymm4
	vmulps	%ymm2, %ymm0, %ymm0
	vfmsub231ps	%ymm3, %ymm1, %ymm0     # ymm0 = (ymm1 * ymm3) - ymm0
	vunpcklps	%ymm0, %ymm4, %ymm1     # ymm1 = ymm4[0],ymm0[0],ymm4[1],ymm0[1],ymm4[4],ymm0[4],ymm4[5],ymm0[5]
	vunpckhps	%ymm0, %ymm4, %ymm0     # ymm0 = ymm4[2],ymm0[2],ymm4[3],ymm0[3],ymm4[6],ymm0[6],ymm4[7],ymm0[7]
	vinsertf128	$1, %xmm0, %ymm1, %ymm2
	vmovups	%ymm2, 64(%rdi)
	vperm2f128	$49, %ymm0, %ymm1, %ymm0 # ymm0 = ymm1[2,3],ymm0[2,3]
	vmovups	%ymm0, 96(%rdi)
	vmovups	128(%rdi), %ymm0
	vmovups	160(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	64(%rsi), %ymm1
	vmovups	64(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 128(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 160(%rdi)
	vmovups	192(%rdi), %ymm0
	vmovups	224(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	96(%rsi), %ymm1
	vmovups	96(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 192(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 224(%rdi)
	vmovups	256(%rdi), %ymm0
	vmovups	288(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	(%rsi), %ymm1
	vmovups	(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 256(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 288(%rdi)
	vmovups	320(%rdi), %ymm0
	vmovups	352(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	32(%rsi), %ymm1
	vmovups	32(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 320(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 352(%rdi)
	vmovups	384(%rdi), %ymm0
	vmovups	416(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	64(%rsi), %ymm1
	vmovups	64(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 384(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 416(%rdi)
	vmovups	448(%rdi), %ymm0
	vmovups	480(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	96(%rsi), %ymm1
	vmovups	96(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 448(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 480(%rdi)
	vmovups	512(%rdi), %ymm0
	vmovups	544(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	(%rsi), %ymm1
	vmovups	(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 512(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 544(%rdi)
	vmovups	576(%rdi), %ymm0
	vmovups	608(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	32(%rsi), %ymm1
	vmovups	32(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 576(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 608(%rdi)
	vmovups	640(%rdi), %ymm0
	vmovups	672(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	64(%rsi), %ymm1
	vmovups	64(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 640(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 672(%rdi)
	vmovups	704(%rdi), %ymm0
	vmovups	736(%rdi), %ymm1
	vshufps	$136, %ymm1, %ymm0, %ymm2       # ymm2 = ymm0[0,2],ymm1[0,2],ymm0[4,6],ymm1[4,6]
	vpermpd	$216, %ymm2, %ymm2              # ymm2 = ymm2[0,2,1,3]
	vshufps	$221, %ymm1, %ymm0, %ymm0       # ymm0 = ymm0[1,3],ymm1[1,3],ymm0[5,7],ymm1[5,7]
	vpermpd	$216, %ymm0, %ymm0              # ymm0 = ymm0[0,2,1,3]
	vmovups	96(%rsi), %ymm1
	vmovups	96(%rdx), %ymm3
	vmulps	%ymm0, %ymm1, %ymm4
	vfmadd231ps	%ymm3, %ymm2, %ymm4     # ymm4 = (ymm2 * ymm3) + ymm4
	vmulps	%ymm1, %ymm2, %ymm1
	vfmsub231ps	%ymm3, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm3) - ymm1
	vunpcklps	%ymm1, %ymm4, %ymm0     # ymm0 = ymm4[0],ymm1[0],ymm4[1],ymm1[1],ymm4[4],ymm1[4],ymm4[5],ymm1[5]
	vunpckhps	%ymm1, %ymm4, %ymm1     # ymm1 = ymm4[2],ymm1[2],ymm4[3],ymm1[3],ymm4[6],ymm1[6],ymm4[7],ymm1[7]
	vinsertf128	$1, %xmm1, %ymm0, %ymm2
	vmovups	%ymm2, 704(%rdi)
	vperm2f128	$49, %ymm1, %ymm0, %ymm0 # ymm0 = ymm0[2,3],ymm1[2,3]
	vmovups	%ymm0, 736(%rdi)
	vzeroupper
	retq
.Lfunc_end20:
	.size	_ZN3fx23opt14rope_apply_192EPfPKfS3_, .Lfunc_end20-_ZN3fx23opt14rope_apply_192EPfPKfS3_
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt20head_softcap_softmaxEPfS1_
.LCPI21_0:
	.long	0xff800000                      # float -Inf
.LCPI21_1:
	.long	0x41700000                      # float 15
.LCPI21_2:
	.long	2147483647                      # 0x7fffffff
.LCPI21_3:
	.long	0x42b00000                      # float 88
.LCPI21_4:
	.long	0xc2aeac50                      # float -87.3365478
.LCPI21_5:
	.long	0x3f000000                      # float 0.5
.LCPI21_6:
	.long	0x3fb8aa3b                      # float 1.44269502
.LCPI21_7:
	.long	0x3f318000                      # float 0.693359375
.LCPI21_8:
	.long	0xb95e8083                      # float -2.12194442E-4
.LCPI21_9:
	.long	0x3e2aaaab                      # float 0.166666672
.LCPI21_10:
	.long	0x3d2aaaab                      # float 0.0416666679
.LCPI21_11:
	.long	0x3c088889                      # float 0.00833333377
.LCPI21_12:
	.long	0x3ab60b61                      # float 0.00138888892
.LCPI21_13:
	.long	0x39500d01                      # float 1.98412701E-4
.LCPI21_14:
	.long	1065353216                      # 0x3f800000
.LCPI21_15:
	.long	0xbf800000                      # float -1
.LCPI21_16:
	.long	0x40000000                      # float 2
.LCPI21_17:
	.long	0xc0000000                      # float -2
.LCPI21_18:
	.long	2147483648                      # 0x80000000
.LCPI21_19:
	.long	0x3e2aaaaa                      # float 0.166666657
.LCPI21_20:
	.long	0x3d2aa9c1                      # float 0.0416657962
.LCPI21_21:
	.long	0x3c088908                      # float 0.00833345205
.LCPI21_22:
	.long	0x3ab743ce                      # float 0.00139819994
.LCPI21_23:
	.long	0x39506967                      # float 1.98756912E-4
	.section	.text._ZN3fx23opt20head_softcap_softmaxEPfS1_,"ax",@progbits
	.globl	_ZN3fx23opt20head_softcap_softmaxEPfS1_
	.p2align	4, 0x90
	.type	_ZN3fx23opt20head_softcap_softmaxEPfS1_,@function
_ZN3fx23opt20head_softcap_softmaxEPfS1_: # @_ZN3fx23opt20head_softcap_softmaxEPfS1_
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	andq	$-32, %rsp
	subq	$1504, %rsp                     # imm = 0x5E0
	movl	$-8388608, 828(%rdi)            # imm = 0xFF800000
	vbroadcastss	.LCPI21_0(%rip), %ymm8  # ymm8 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	vmovlps	%xmm8, 820(%rdi)
	vmovups	(%rdi), %ymm0
	vbroadcastss	.LCPI21_1(%rip), %ymm1  # ymm1 = [1.5E+1,1.5E+1,1.5E+1,1.5E+1,1.5E+1,1.5E+1,1.5E+1,1.5E+1]
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 640(%rsp)
	vmovups	32(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 672(%rsp)
	vmovups	64(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 704(%rsp)
	vmovups	96(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 736(%rsp)
	vmovups	128(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 768(%rsp)
	vmovups	160(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 800(%rsp)
	vmovups	192(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 832(%rsp)
	vmovups	224(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 864(%rsp)
	vmovups	256(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 896(%rsp)
	vmovups	288(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 928(%rsp)
	vmovups	320(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 960(%rsp)
	vmovups	352(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 992(%rsp)
	vmovups	384(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1024(%rsp)
	vmovups	416(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1056(%rsp)
	vmovups	448(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1088(%rsp)
	vmovups	480(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1120(%rsp)
	vmovups	512(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1152(%rsp)
	vmovups	544(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1184(%rsp)
	vmovups	576(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1216(%rsp)
	vmovups	608(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1248(%rsp)
	vmovups	640(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1280(%rsp)
	vmovups	672(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1312(%rsp)
	vmovups	704(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1344(%rsp)
	vmovups	736(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1376(%rsp)
	vmovups	768(%rdi), %ymm0
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1408(%rsp)
	vmovups	800(%rdi), %ymm0
	vmovaps	%ymm1, 320(%rsp)                # 32-byte Spill
	vdivps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 1440(%rsp)
	vbroadcastss	.LCPI21_2(%rip), %ymm0  # ymm0 = [2147483647,2147483647,2147483647,2147483647,2147483647,2147483647,2147483647,2147483647]
	vmovaps	%ymm0, 224(%rsp)                # 32-byte Spill
	movq	$-16, %rax
	vbroadcastss	.LCPI21_3(%rip), %ymm0  # ymm0 = [8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1]
	vmovaps	%ymm0, 448(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_4(%rip), %ymm2  # ymm2 = [-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1]
	vbroadcastss	.LCPI21_5(%rip), %ymm0  # ymm0 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1]
	vmovaps	%ymm0, 416(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_6(%rip), %ymm4  # ymm4 = [1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0]
	vbroadcastss	.LCPI21_7(%rip), %ymm5  # ymm5 = [6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1]
	vbroadcastss	.LCPI21_8(%rip), %ymm9  # ymm9 = [-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4]
	vbroadcastss	.LCPI21_9(%rip), %ymm0  # ymm0 = [1.66666672E-1,1.66666672E-1,1.66666672E-1,1.66666672E-1,1.66666672E-1,1.66666672E-1,1.66666672E-1,1.66666672E-1]
	vmovaps	%ymm0, 192(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_10(%rip), %ymm0 # ymm0 = [4.16666679E-2,4.16666679E-2,4.16666679E-2,4.16666679E-2,4.16666679E-2,4.16666679E-2,4.16666679E-2,4.16666679E-2]
	vmovaps	%ymm0, 288(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_11(%rip), %ymm0 # ymm0 = [8.33333377E-3,8.33333377E-3,8.33333377E-3,8.33333377E-3,8.33333377E-3,8.33333377E-3,8.33333377E-3,8.33333377E-3]
	vmovaps	%ymm0, 256(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_12(%rip), %ymm0 # ymm0 = [1.38888892E-3,1.38888892E-3,1.38888892E-3,1.38888892E-3,1.38888892E-3,1.38888892E-3,1.38888892E-3,1.38888892E-3]
	vmovaps	%ymm0, 32(%rsp)                 # 32-byte Spill
	vbroadcastss	.LCPI21_13(%rip), %ymm0 # ymm0 = [1.98412701E-4,1.98412701E-4,1.98412701E-4,1.98412701E-4,1.98412701E-4,1.98412701E-4,1.98412701E-4,1.98412701E-4]
	vmovaps	%ymm0, 608(%rsp)                # 32-byte Spill
	vpbroadcastd	.LCPI21_14(%rip), %ymm11 # ymm11 = [1065353216,1065353216,1065353216,1065353216,1065353216,1065353216,1065353216,1065353216]
	vbroadcastss	.LCPI21_15(%rip), %ymm0 # ymm0 = [-1.0E+0,-1.0E+0,-1.0E+0,-1.0E+0,-1.0E+0,-1.0E+0,-1.0E+0,-1.0E+0]
	vmovaps	%ymm0, (%rsp)                   # 32-byte Spill
	vbroadcastss	.LCPI21_16(%rip), %ymm0 # ymm0 = [2.0E+0,2.0E+0,2.0E+0,2.0E+0,2.0E+0,2.0E+0,2.0E+0,2.0E+0]
	vmovaps	%ymm0, 576(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_17(%rip), %ymm0 # ymm0 = [-2.0E+0,-2.0E+0,-2.0E+0,-2.0E+0,-2.0E+0,-2.0E+0,-2.0E+0,-2.0E+0]
	vmovaps	%ymm0, 544(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_18(%rip), %ymm0 # ymm0 = [2147483648,2147483648,2147483648,2147483648,2147483648,2147483648,2147483648,2147483648]
	vmovaps	%ymm0, 512(%rsp)                # 32-byte Spill
	vmovaps	%ymm8, %ymm7
	vmovdqa	%ymm11, 480(%rsp)               # 32-byte Spill
	vmovaps	%ymm2, 384(%rsp)                # 32-byte Spill
	vmovaps	%ymm9, 128(%rsp)                # 32-byte Spill
	vmovaps	%ymm4, 160(%rsp)                # 32-byte Spill
	vmovaps	224(%rsp), %ymm13               # 32-byte Reload
	.p2align	4, 0x90
.LBB21_1:                               # =>This Inner Loop Header: Depth=1
	vmovaps	%ymm8, 96(%rsp)                 # 32-byte Spill
	vmovaps	704(%rsp,%rax,4), %ymm1
	vmovaps	%ymm1, 352(%rsp)                # 32-byte Spill
	vmovaps	736(%rsp,%rax,4), %ymm0
	vmovaps	%ymm0, 64(%rsp)                 # 32-byte Spill
	vandps	%ymm1, %ymm13, %ymm12
	vaddps	%ymm12, %ymm12, %ymm12
	vmovaps	448(%rsp), %ymm0                # 32-byte Reload
	vminps	%ymm0, %ymm12, %ymm12
	vmaxps	%ymm2, %ymm12, %ymm12
	vmovaps	160(%rsp), %ymm4                # 32-byte Reload
	vmovaps	416(%rsp), %ymm6                # 32-byte Reload
	vfmadd213ps	%ymm6, %ymm12, %ymm4    # ymm4 = (ymm12 * ymm4) + ymm6
	vroundps	$1, %ymm4, %ymm4
	vfnmadd231ps	%ymm5, %ymm4, %ymm12    # ymm12 = -(ymm4 * ymm5) + ymm12
	vmulps	%ymm4, %ymm9, %ymm15
	vsubps	%ymm15, %ymm12, %ymm8
	vsubps	%ymm8, %ymm12, %ymm12
	vsubps	%ymm15, %ymm12, %ymm12
	vmulps	%ymm8, %ymm8, %ymm15
	vmovaps	192(%rsp), %ymm14               # 32-byte Reload
	vmovaps	%ymm14, %ymm9
	vfmadd213ps	%ymm6, %ymm8, %ymm9     # ymm9 = (ymm8 * ymm9) + ymm6
	vmovaps	256(%rsp), %ymm10               # 32-byte Reload
	vmovaps	%ymm10, %ymm3
	vmovaps	288(%rsp), %ymm2                # 32-byte Reload
	vfmadd213ps	%ymm2, %ymm8, %ymm3     # ymm3 = (ymm8 * ymm3) + ymm2
	vmovaps	608(%rsp), %ymm1                # 32-byte Reload
	vmovaps	%ymm1, %ymm11
	vfmadd213ps	32(%rsp), %ymm8, %ymm11 # 32-byte Folded Reload
                                        # ymm11 = (ymm8 * ymm11) + mem
	vfmadd213ps	%ymm3, %ymm15, %ymm11   # ymm11 = (ymm15 * ymm11) + ymm3
	vfmadd213ps	%ymm9, %ymm15, %ymm11   # ymm11 = (ymm15 * ymm11) + ymm9
	vmovaps	%ymm15, %ymm3
	vfmadd213ps	%ymm8, %ymm11, %ymm3    # ymm3 = (ymm11 * ymm3) + ymm8
	vsubps	%ymm8, %ymm3, %ymm8
	vfmsub231ps	%ymm11, %ymm15, %ymm8   # ymm8 = (ymm15 * ymm11) - ymm8
	vfmadd231ps	%ymm12, %ymm3, %ymm12   # ymm12 = (ymm3 * ymm12) + ymm12
	vaddps	%ymm8, %ymm12, %ymm8
	vaddps	%ymm3, %ymm8, %ymm3
	vcvtps2dq	%ymm4, %ymm4
	vpslld	$23, %ymm4, %ymm4
	vpaddd	480(%rsp), %ymm4, %ymm4         # 32-byte Folded Reload
	vaddps	(%rsp), %ymm4, %ymm12           # 32-byte Folded Reload
	vfmadd231ps	%ymm3, %ymm4, %ymm12    # ymm12 = (ymm4 * ymm3) + ymm12
	vandps	64(%rsp), %ymm13, %ymm3         # 32-byte Folded Reload
	vaddps	%ymm3, %ymm3, %ymm3
	vminps	%ymm0, %ymm3, %ymm3
	vmaxps	384(%rsp), %ymm3, %ymm3         # 32-byte Folded Reload
	vmovaps	160(%rsp), %ymm4                # 32-byte Reload
	vfmadd213ps	%ymm6, %ymm3, %ymm4     # ymm4 = (ymm3 * ymm4) + ymm6
	vroundps	$1, %ymm4, %ymm4
	vfnmadd231ps	%ymm5, %ymm4, %ymm3     # ymm3 = -(ymm4 * ymm5) + ymm3
	vmulps	128(%rsp), %ymm4, %ymm8         # 32-byte Folded Reload
	vsubps	%ymm8, %ymm3, %ymm9
	vmulps	%ymm9, %ymm9, %ymm11
	vfmadd213ps	%ymm6, %ymm9, %ymm14    # ymm14 = (ymm9 * ymm14) + ymm6
	vfmadd213ps	%ymm2, %ymm9, %ymm10    # ymm10 = (ymm9 * ymm10) + ymm2
	vmovaps	%ymm5, %ymm6
	vfmadd213ps	32(%rsp), %ymm9, %ymm1  # 32-byte Folded Reload
                                        # ymm1 = (ymm9 * ymm1) + mem
	vfmadd213ps	%ymm10, %ymm11, %ymm1   # ymm1 = (ymm11 * ymm1) + ymm10
	vfmadd213ps	%ymm14, %ymm11, %ymm1   # ymm1 = (ymm11 * ymm1) + ymm14
	vmovaps	%ymm11, %ymm0
	vfmadd213ps	%ymm9, %ymm1, %ymm0     # ymm0 = (ymm1 * ymm0) + ymm9
	vsubps	%ymm9, %ymm0, %ymm15
	vfmsub231ps	%ymm1, %ymm11, %ymm15   # ymm15 = (ymm11 * ymm1) - ymm15
	vmovaps	576(%rsp), %ymm1                # 32-byte Reload
	vaddps	%ymm1, %ymm12, %ymm5
	vmovaps	544(%rsp), %ymm10               # 32-byte Reload
	vaddps	%ymm5, %ymm10, %ymm11
	vsubps	%ymm11, %ymm12, %ymm11
	vdivps	%ymm5, %ymm11, %ymm11
	vdivps	%ymm5, %ymm12, %ymm5
	vfnmadd231ps	%ymm5, %ymm11, %ymm5    # ymm5 = -(ymm11 * ymm5) + ymm5
	vmovdqa	480(%rsp), %ymm11               # 32-byte Reload
	vsubps	%ymm9, %ymm3, %ymm3
	vmovaps	128(%rsp), %ymm9                # 32-byte Reload
	vsubps	%ymm8, %ymm3, %ymm3
	vmovaps	96(%rsp), %ymm8                 # 32-byte Reload
	vfmadd231ps	%ymm3, %ymm0, %ymm3     # ymm3 = (ymm0 * ymm3) + ymm3
	vaddps	%ymm3, %ymm15, %ymm3
	vmovaps	384(%rsp), %ymm2                # 32-byte Reload
	vaddps	%ymm3, %ymm0, %ymm0
	vcvtps2dq	%ymm4, %ymm3
	vpslld	$23, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm11, %ymm3
	vaddps	(%rsp), %ymm3, %ymm4            # 32-byte Folded Reload
	vfmadd231ps	%ymm0, %ymm3, %ymm4     # ymm4 = (ymm3 * ymm0) + ymm4
	vaddps	%ymm1, %ymm4, %ymm0
	vaddps	%ymm0, %ymm10, %ymm3
	vsubps	%ymm3, %ymm4, %ymm3
	vdivps	%ymm0, %ymm3, %ymm3
	vdivps	%ymm0, %ymm4, %ymm0
	vmovaps	512(%rsp), %ymm1                # 32-byte Reload
	vandps	352(%rsp), %ymm1, %ymm4         # 32-byte Folded Reload
	vorps	%ymm5, %ymm4, %ymm4
	vmovaps	%ymm6, %ymm5
	vfnmadd231ps	%ymm0, %ymm3, %ymm0     # ymm0 = -(ymm3 * ymm0) + ymm0
	vandps	64(%rsp), %ymm1, %ymm1          # 32-byte Folded Reload
	vorps	%ymm0, %ymm1, %ymm0
	vmovaps	320(%rsp), %ymm3                # 32-byte Reload
	vmulps	%ymm3, %ymm4, %ymm1
	vmovaps	160(%rsp), %ymm4                # 32-byte Reload
	vmovups	%ymm1, 64(%rdi,%rax,4)
	vmaxps	%ymm1, %ymm8, %ymm8
	vmulps	%ymm3, %ymm0, %ymm0
	vmovups	%ymm0, 96(%rdi,%rax,4)
	vmaxps	%ymm0, %ymm7, %ymm7
	addq	$16, %rax
	cmpq	$192, %rax
	jb	.LBB21_1
# %bb.2:
	vmaxps	%ymm7, %ymm8, %ymm1
	vextractf128	$1, %ymm1, %xmm7
	vmaxps	%xmm7, %xmm1, %xmm1
	vshufpd	$3, %xmm1, %xmm1, %xmm7         # xmm7 = xmm1[1,1]
	vmaxps	%xmm7, %xmm1, %xmm1
	vmovshdup	%xmm1, %xmm7            # xmm7 = xmm1[1,1,3,3]
	vmaxss	%xmm7, %xmm1, %xmm1
	vbroadcastss	%xmm1, %ymm0
	vmovaps	%ymm0, 96(%rsp)                 # 32-byte Spill
	vxorps	%xmm0, %xmm0, %xmm0
	vmovaps	%ymm0, 64(%rsp)                 # 32-byte Spill
	movq	$-16, %rax
	vbroadcastss	.LCPI21_19(%rip), %ymm0 # ymm0 = [1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1]
	vmovaps	%ymm0, 288(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_20(%rip), %ymm0 # ymm0 = [4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2]
	vmovaps	%ymm0, 224(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_21(%rip), %ymm0 # ymm0 = [8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3]
	vmovaps	%ymm0, 352(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_22(%rip), %ymm0 # ymm0 = [1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3]
	vmovaps	%ymm0, 192(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_23(%rip), %ymm0 # ymm0 = [1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4]
	vmovaps	%ymm0, 256(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI21_14(%rip), %ymm0 # ymm0 = [1065353216,1065353216,1065353216,1065353216,1065353216,1065353216,1065353216,1065353216]
	vmovaps	%ymm0, 320(%rsp)                # 32-byte Spill
	vxorps	%xmm0, %xmm0, %xmm0
	vmovaps	%ymm0, 32(%rsp)                 # 32-byte Spill
	vmovaps	416(%rsp), %ymm14               # 32-byte Reload
	vmovaps	224(%rsp), %ymm13               # 32-byte Reload
	vmovaps	192(%rsp), %ymm8                # 32-byte Reload
	.p2align	4, 0x90
.LBB21_3:                               # =>This Inner Loop Header: Depth=1
	vmovups	64(%rdi,%rax,4), %ymm0
	vmovups	96(%rdi,%rax,4), %ymm1
	vmovaps	%ymm1, (%rsp)                   # 32-byte Spill
	vmovaps	96(%rsp), %ymm3                 # 32-byte Reload
	vsubps	%ymm3, %ymm0, %ymm0
	vmovaps	448(%rsp), %ymm15               # 32-byte Reload
	vminps	%ymm15, %ymm0, %ymm0
	vmaxps	384(%rsp), %ymm0, %ymm0         # 32-byte Folded Reload
	vmovaps	%ymm4, %ymm1
	vfmadd213ps	%ymm14, %ymm0, %ymm1    # ymm1 = (ymm0 * ymm1) + ymm14
	vroundps	$1, %ymm1, %ymm1
	vfnmadd231ps	%ymm5, %ymm1, %ymm0     # ymm0 = -(ymm1 * ymm5) + ymm0
	vfnmadd231ps	%ymm9, %ymm1, %ymm0     # ymm0 = -(ymm1 * ymm9) + ymm0
	vmulps	%ymm0, %ymm0, %ymm5
	vmulps	%ymm5, %ymm5, %ymm4
	vmovaps	288(%rsp), %ymm10               # 32-byte Reload
	vmovaps	%ymm10, %ymm11
	vfmadd213ps	%ymm14, %ymm0, %ymm11   # ymm11 = (ymm0 * ymm11) + ymm14
	vmovaps	352(%rsp), %ymm2                # 32-byte Reload
	vmovaps	%ymm2, %ymm9
	vfmadd213ps	%ymm13, %ymm0, %ymm9    # ymm9 = (ymm0 * ymm9) + ymm13
	vmovaps	256(%rsp), %ymm7                # 32-byte Reload
	vmovaps	%ymm7, %ymm12
	vfmadd213ps	%ymm8, %ymm0, %ymm12    # ymm12 = (ymm0 * ymm12) + ymm8
	vfmadd213ps	%ymm11, %ymm5, %ymm9    # ymm9 = (ymm5 * ymm9) + ymm11
	vfmadd231ps	%ymm12, %ymm4, %ymm9    # ymm9 = (ymm4 * ymm12) + ymm9
	vfmadd213ps	%ymm0, %ymm5, %ymm9     # ymm9 = (ymm5 * ymm9) + ymm0
	vmovaps	(%rsp), %ymm0                   # 32-byte Reload
	vsubps	%ymm3, %ymm0, %ymm0
	vminps	%ymm15, %ymm0, %ymm0
	vmovaps	384(%rsp), %ymm15               # 32-byte Reload
	vmaxps	%ymm15, %ymm0, %ymm0
	vmovaps	160(%rsp), %ymm3                # 32-byte Reload
	vfmadd213ps	%ymm14, %ymm0, %ymm3    # ymm3 = (ymm0 * ymm3) + ymm14
	vroundps	$1, %ymm3, %ymm3
	vfnmadd231ps	%ymm6, %ymm3, %ymm0     # ymm0 = -(ymm3 * ymm6) + ymm0
	vfnmadd231ps	128(%rsp), %ymm3, %ymm0 # 32-byte Folded Reload
                                        # ymm0 = -(ymm3 * mem) + ymm0
	vmulps	%ymm0, %ymm0, %ymm4
	vmulps	%ymm4, %ymm4, %ymm5
	vfmadd213ps	%ymm14, %ymm0, %ymm10   # ymm10 = (ymm0 * ymm10) + ymm14
	vmovaps	%ymm2, %ymm12
	vfmadd213ps	%ymm13, %ymm0, %ymm12   # ymm12 = (ymm0 * ymm12) + ymm13
	vfmadd213ps	%ymm10, %ymm4, %ymm12   # ymm12 = (ymm4 * ymm12) + ymm10
	vfmadd213ps	%ymm8, %ymm0, %ymm7     # ymm7 = (ymm0 * ymm7) + ymm8
	vfmadd231ps	%ymm7, %ymm5, %ymm12    # ymm12 = (ymm5 * ymm7) + ymm12
	vmovdqa	480(%rsp), %ymm11               # 32-byte Reload
	vmovaps	%ymm6, %ymm5
	vfmadd213ps	%ymm0, %ymm4, %ymm12    # ymm12 = (ymm4 * ymm12) + ymm0
	vmovaps	160(%rsp), %ymm4                # 32-byte Reload
	vmovaps	320(%rsp), %ymm2                # 32-byte Reload
	vaddps	%ymm2, %ymm9, %ymm0
	vmovaps	128(%rsp), %ymm9                # 32-byte Reload
	vcvtps2dq	%ymm1, %ymm1
	vpslld	$23, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm11, %ymm1
	vmulps	%ymm1, %ymm0, %ymm0
	vaddps	%ymm2, %ymm12, %ymm1
	vcvtps2dq	%ymm3, %ymm3
	vpslld	$23, %ymm3, %ymm3
	vpaddd	%ymm3, %ymm11, %ymm3
	vmulps	%ymm3, %ymm1, %ymm1
	vmovups	%ymm0, 64(%rsi,%rax,4)
	vmovaps	64(%rsp), %ymm2                 # 32-byte Reload
	vaddps	%ymm0, %ymm2, %ymm2
	vmovaps	%ymm2, 64(%rsp)                 # 32-byte Spill
	vmovups	%ymm1, 96(%rsi,%rax,4)
	vmovaps	32(%rsp), %ymm0                 # 32-byte Reload
	vaddps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 32(%rsp)                 # 32-byte Spill
	addq	$16, %rax
	cmpq	$176, %rax
	jb	.LBB21_3
# %bb.4:
	vmovups	768(%rdi), %ymm0
	vsubps	96(%rsp), %ymm0, %ymm0          # 32-byte Folded Reload
	vmovaps	448(%rsp), %ymm12               # 32-byte Reload
	vminps	%ymm12, %ymm0, %ymm0
	vmaxps	%ymm15, %ymm0, %ymm0
	vmovaps	%ymm4, %ymm1
	vmovaps	416(%rsp), %ymm2                # 32-byte Reload
	vfmadd213ps	%ymm2, %ymm0, %ymm1     # ymm1 = (ymm0 * ymm1) + ymm2
	vroundps	$1, %ymm1, %ymm1
	vmovaps	%ymm1, (%rsp)                   # 32-byte Spill
	vfnmadd231ps	%ymm5, %ymm1, %ymm0     # ymm0 = -(ymm1 * ymm5) + ymm0
	vfnmadd231ps	%ymm9, %ymm1, %ymm0     # ymm0 = -(ymm1 * ymm9) + ymm0
	vmovaps	288(%rsp), %ymm14               # 32-byte Reload
	vmovaps	%ymm14, %ymm3
	vfmadd213ps	%ymm2, %ymm0, %ymm3     # ymm3 = (ymm0 * ymm3) + ymm2
	vmovaps	352(%rsp), %ymm13               # 32-byte Reload
	vmovaps	%ymm13, %ymm9
	vmovaps	224(%rsp), %ymm6                # 32-byte Reload
	vfmadd213ps	%ymm6, %ymm0, %ymm9     # ymm9 = (ymm0 * ymm9) + ymm6
	vmovaps	%ymm4, %ymm10
	vmovaps	%ymm5, %ymm4
	vmulps	%ymm0, %ymm0, %ymm5
	vfmadd213ps	%ymm3, %ymm5, %ymm9     # ymm9 = (ymm5 * ymm9) + ymm3
	vmovaps	256(%rsp), %ymm7                # 32-byte Reload
	vmovaps	%ymm7, %ymm3
	vmovaps	192(%rsp), %ymm8                # 32-byte Reload
	vfmadd213ps	%ymm8, %ymm0, %ymm3     # ymm3 = (ymm0 * ymm3) + ymm8
	vmulps	%ymm5, %ymm5, %ymm1
	vfmadd231ps	%ymm3, %ymm1, %ymm9     # ymm9 = (ymm1 * ymm3) + ymm9
	vfmadd213ps	%ymm0, %ymm5, %ymm9     # ymm9 = (ymm5 * ymm9) + ymm0
	vmovups	800(%rdi), %ymm0
	vsubps	96(%rsp), %ymm0, %ymm0          # 32-byte Folded Reload
	vminps	%ymm12, %ymm0, %ymm0
	vmaxps	%ymm15, %ymm0, %ymm0
	vfmadd213ps	%ymm2, %ymm0, %ymm10    # ymm10 = (ymm0 * ymm10) + ymm2
	vroundps	$1, %ymm10, %ymm1
	vfnmadd213ps	%ymm0, %ymm1, %ymm4     # ymm4 = -(ymm1 * ymm4) + ymm0
	vfnmadd231ps	128(%rsp), %ymm1, %ymm4 # 32-byte Folded Reload
                                        # ymm4 = -(ymm1 * mem) + ymm4
	vfmadd213ps	%ymm2, %ymm4, %ymm14    # ymm14 = (ymm4 * ymm14) + ymm2
	vfmadd213ps	%ymm6, %ymm4, %ymm13    # ymm13 = (ymm4 * ymm13) + ymm6
	vfmadd213ps	%ymm8, %ymm4, %ymm7     # ymm7 = (ymm4 * ymm7) + ymm8
	vmulps	%ymm4, %ymm4, %ymm0
	vfmadd213ps	%ymm14, %ymm0, %ymm13   # ymm13 = (ymm0 * ymm13) + ymm14
	vmulps	%ymm0, %ymm0, %ymm2
	vfmadd231ps	%ymm7, %ymm2, %ymm13    # ymm13 = (ymm2 * ymm7) + ymm13
	vfmadd213ps	%ymm4, %ymm0, %ymm13    # ymm13 = (ymm0 * ymm13) + ymm4
	vmovaps	320(%rsp), %ymm3                # 32-byte Reload
	vaddps	%ymm3, %ymm9, %ymm0
	vcvtps2dq	(%rsp), %ymm2           # 32-byte Folded Reload
	vpslld	$23, %ymm2, %ymm2
	vpaddd	%ymm2, %ymm11, %ymm2
	vmulps	%ymm2, %ymm0, %ymm0
	vaddps	%ymm3, %ymm13, %ymm2
	vcvtps2dq	%ymm1, %ymm1
	vpslld	$23, %ymm1, %ymm1
	vpaddd	%ymm1, %ymm11, %ymm1
	vmulps	%ymm1, %ymm2, %ymm1
	vxorps	%xmm2, %xmm2, %xmm2
	vblendps	$224, %ymm2, %ymm1, %ymm1       # ymm1 = ymm1[0,1,2,3,4],ymm2[5,6,7]
	vmovups	%ymm0, 768(%rsi)
	vmovups	%ymm1, 800(%rsi)
	vaddps	64(%rsp), %ymm0, %ymm0          # 32-byte Folded Reload
	vaddps	32(%rsp), %ymm1, %ymm1          # 32-byte Folded Reload
	vaddps	%ymm1, %ymm0, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vaddps	%xmm1, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddps	%xmm1, %xmm0, %xmm0
	vbroadcastss	%xmm0, %ymm0
	vmovups	(%rsi), %ymm1
	vmovups	32(%rsi), %ymm2
	vmovups	64(%rsi), %ymm3
	vmovups	96(%rsi), %ymm4
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, (%rsi)
	vdivps	%ymm0, %ymm2, %ymm1
	vmovups	%ymm1, 32(%rsi)
	vdivps	%ymm0, %ymm3, %ymm1
	vmovups	%ymm1, 64(%rsi)
	vdivps	%ymm0, %ymm4, %ymm1
	vmovups	%ymm1, 96(%rsi)
	vmovups	128(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 128(%rsi)
	vmovups	160(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 160(%rsi)
	vmovups	192(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 192(%rsi)
	vmovups	224(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 224(%rsi)
	vmovups	256(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 256(%rsi)
	vmovups	288(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 288(%rsi)
	vmovups	320(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 320(%rsi)
	vmovups	352(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 352(%rsi)
	vmovups	384(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 384(%rsi)
	vmovups	416(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 416(%rsi)
	vmovups	448(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 448(%rsi)
	vmovups	480(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 480(%rsi)
	vmovups	512(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 512(%rsi)
	vmovups	544(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 544(%rsi)
	vmovups	576(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 576(%rsi)
	vmovups	608(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 608(%rsi)
	vmovups	640(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 640(%rsi)
	vmovups	672(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 672(%rsi)
	vmovups	704(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 704(%rsi)
	vmovups	736(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 736(%rsi)
	vmovups	768(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm1
	vmovups	%ymm1, 768(%rsi)
	vmovups	800(%rsi), %ymm1
	vdivps	%ymm0, %ymm1, %ymm0
	vmovups	%ymm0, 800(%rsi)
	movq	%rbp, %rsp
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end21:
	.size	_ZN3fx23opt20head_softcap_softmaxEPfS1_, .Lfunc_end21-_ZN3fx23opt20head_softcap_softmaxEPfS1_
                                        # -- End function
	.section	.text._ZN3fx23opt12probs_to_f16EPKfPt,"ax",@progbits
	.globl	_ZN3fx23opt12probs_to_f16EPKfPt # -- Begin function _ZN3fx23opt12probs_to_f16EPKfPt
	.p2align	4, 0x90
	.type	_ZN3fx23opt12probs_to_f16EPKfPt,@function
_ZN3fx23opt12probs_to_f16EPKfPt:        # @_ZN3fx23opt12probs_to_f16EPKfPt
# %bb.0:
	vmovups	(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, (%rsi)
	vmovups	32(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 16(%rsi)
	vmovups	64(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 32(%rsi)
	vmovups	96(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 48(%rsi)
	vmovups	128(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 64(%rsi)
	vmovups	160(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 80(%rsi)
	vmovups	192(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 96(%rsi)
	vmovups	224(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 112(%rsi)
	vmovups	256(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 128(%rsi)
	vmovups	288(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 144(%rsi)
	vmovups	320(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 160(%rsi)
	vmovups	352(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 176(%rsi)
	vmovups	384(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 192(%rsi)
	vmovups	416(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 208(%rsi)
	vmovups	448(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 224(%rsi)
	vmovups	480(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 240(%rsi)
	vmovups	512(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 256(%rsi)
	vmovups	544(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 272(%rsi)
	vmovups	576(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 288(%rsi)
	vmovups	608(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 304(%rsi)
	vmovups	640(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 320(%rsi)
	vmovups	672(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 336(%rsi)
	vmovups	704(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 352(%rsi)
	vmovups	736(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 368(%rsi)
	vmovups	768(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 384(%rsi)
	vmovups	788(%rdi), %ymm0
	vcvtps2ph	$8, %ymm0, 394(%rsi)
	vzeroupper
	retq
.Lfunc_end22:
	.size	_ZN3fx23opt12probs_to_f16EPKfPt, .Lfunc_end22-_ZN3fx23opt12probs_to_f16EPKfPt
                                        # -- End function
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0                          # -- Begin function _ZN3fx23opt12neg_log_probEPKfi
.LCPI23_0:
	.quad	0x8000000000000000              # double -0
	.quad	0x8000000000000000              # double -0
	.section	.text._ZN3fx23opt12neg_log_probEPKfi,"ax",@progbits
	.globl	_ZN3fx23opt12neg_log_probEPKfi
	.p2align	4, 0x90
	.type	_ZN3fx23opt12neg_log_probEPKfi,@function
_ZN3fx23opt12neg_log_probEPKfi:         # @_ZN3fx23opt12neg_log_probEPKfi
# %bb.0:
	pushq	%rax
	movslq	%esi, %rax
	vmovss	(%rdi,%rax,4), %xmm0            # xmm0 = mem[0],zero,zero,zero
	vcvtss2sd	%xmm0, %xmm0, %xmm0
	callq	log@PLT
	vxorps	.LCPI23_0(%rip), %xmm0, %xmm0
	popq	%rax
	retq
.Lfunc_end23:
	.size	_ZN3fx23opt12neg_log_probEPKfi, .Lfunc_end23-_ZN3fx23opt12neg_log_probEPKfi
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"m > 0 && m <= 8"
	.size	.L.str, 16

	.type	.L.str.1,@object                # @.str.1
.L.str.1:
	.asciz	"cpp_infer/src/opt/glue.cpp"
	.size	.L.str.1, 27

	.type	.L__PRETTY_FUNCTION__._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh,@object # @__PRETTY_FUNCTION__._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh
.L__PRETTY_FUNCTION__._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh:
	.asciz	"void fx2::opt::rms_norm_quant192_multi(const float *, float *, const float *, int, uint8_t *)"
	.size	.L__PRETTY_FUNCTION__._ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh, 94

	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
