	.text
	.file	"model_opt.cpp"
	.section	.text._ZN3fx23opt10prof_resetEv,"ax",@progbits
	.globl	_ZN3fx23opt10prof_resetEv       # -- Begin function _ZN3fx23opt10prof_resetEv
	.p2align	4, 0x90
	.type	_ZN3fx23opt10prof_resetEv,@function
_ZN3fx23opt10prof_resetEv:              # @_ZN3fx23opt10prof_resetEv
# %bb.0:
	retq
.Lfunc_end0:
	.size	_ZN3fx23opt10prof_resetEv, .Lfunc_end0-_ZN3fx23opt10prof_resetEv
                                        # -- End function
	.section	.text._ZN3fx23opt12prof_enabledEv,"ax",@progbits
	.globl	_ZN3fx23opt12prof_enabledEv     # -- Begin function _ZN3fx23opt12prof_enabledEv
	.p2align	4, 0x90
	.type	_ZN3fx23opt12prof_enabledEv,@function
_ZN3fx23opt12prof_enabledEv:            # @_ZN3fx23opt12prof_enabledEv
# %bb.0:
	xorl	%eax, %eax
	retq
.Lfunc_end1:
	.size	_ZN3fx23opt12prof_enabledEv, .Lfunc_end1-_ZN3fx23opt12prof_enabledEv
                                        # -- End function
	.section	.text._ZN3fx23opt10prof_printEdl,"ax",@progbits
	.globl	_ZN3fx23opt10prof_printEdl      # -- Begin function _ZN3fx23opt10prof_printEdl
	.p2align	4, 0x90
	.type	_ZN3fx23opt10prof_printEdl,@function
_ZN3fx23opt10prof_printEdl:             # @_ZN3fx23opt10prof_printEdl
# %bb.0:
	movl	$.Lstr, %edi
	jmp	puts@PLT                        # TAILCALL
.Lfunc_end2:
	.size	_ZN3fx23opt10prof_printEdl, .Lfunc_end2-_ZN3fx23opt10prof_printEdl
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE # -- Begin function _ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE,@function
_ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE: # @_ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%r12
	pushq	%rbx
	pushq	%rax
	movl	%edx, %ebx
	movq	%rsi, %r14
	movq	%rdi, %r15
	movl	$57472, %edi                    # imm = 0xE080
	movl	$64, %esi
	callq	_ZnwmSt11align_val_t
	movq	%rax, %r12
	movq	%rax, %rdi
	movq	%r14, %rsi
	xorl	%edx, %edx
	movl	%ebx, %ecx
	callq	_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE
	movq	%r12, (%r15)
	addq	$8, %rsp
	popq	%rbx
	popq	%r12
	popq	%r14
	popq	%r15
	retq
.Lfunc_end3:
	.size	_ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE, .Lfunc_end3-_ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE
                                        # -- End function
	.section	.rodata.cst32,"aM",@progbits,32
	.p2align	5, 0x0                          # -- Begin function _ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE
.LCPI4_0:
	.short	0                               # 0x0
	.short	1                               # 0x1
	.short	2                               # 0x2
	.short	3                               # 0x3
	.short	4                               # 0x4
	.short	5                               # 0x5
	.short	6                               # 0x6
	.short	7                               # 0x7
	.short	8                               # 0x8
	.short	9                               # 0x9
	.short	10                              # 0xa
	.short	11                              # 0xb
	.short	12                              # 0xc
	.short	13                              # 0xd
	.short	14                              # 0xe
	.short	15                              # 0xf
.LCPI4_1:
	.short	16                              # 0x10
	.short	17                              # 0x11
	.short	18                              # 0x12
	.short	19                              # 0x13
	.short	20                              # 0x14
	.short	21                              # 0x15
	.short	22                              # 0x16
	.short	23                              # 0x17
	.short	24                              # 0x18
	.short	25                              # 0x19
	.short	26                              # 0x1a
	.short	27                              # 0x1b
	.short	28                              # 0x1c
	.short	29                              # 0x1d
	.short	30                              # 0x1e
	.short	31                              # 0x1f
.LCPI4_2:
	.short	32                              # 0x20
	.short	33                              # 0x21
	.short	34                              # 0x22
	.short	35                              # 0x23
	.short	36                              # 0x24
	.short	37                              # 0x25
	.short	38                              # 0x26
	.short	39                              # 0x27
	.short	40                              # 0x28
	.short	41                              # 0x29
	.short	42                              # 0x2a
	.short	43                              # 0x2b
	.short	44                              # 0x2c
	.short	45                              # 0x2d
	.short	46                              # 0x2e
	.short	47                              # 0x2f
.LCPI4_3:
	.short	48                              # 0x30
	.short	49                              # 0x31
	.short	50                              # 0x32
	.short	51                              # 0x33
	.short	52                              # 0x34
	.short	53                              # 0x35
	.short	54                              # 0x36
	.short	55                              # 0x37
	.short	56                              # 0x38
	.short	57                              # 0x39
	.short	58                              # 0x3a
	.short	59                              # 0x3b
	.short	60                              # 0x3c
	.short	61                              # 0x3d
	.short	62                              # 0x3e
	.short	63                              # 0x3f
.LCPI4_4:
	.short	64                              # 0x40
	.short	65                              # 0x41
	.short	66                              # 0x42
	.short	67                              # 0x43
	.short	68                              # 0x44
	.short	69                              # 0x45
	.short	70                              # 0x46
	.short	71                              # 0x47
	.short	72                              # 0x48
	.short	73                              # 0x49
	.short	74                              # 0x4a
	.short	75                              # 0x4b
	.short	76                              # 0x4c
	.short	77                              # 0x4d
	.short	78                              # 0x4e
	.short	79                              # 0x4f
.LCPI4_5:
	.short	80                              # 0x50
	.short	81                              # 0x51
	.short	82                              # 0x52
	.short	83                              # 0x53
	.short	84                              # 0x54
	.short	85                              # 0x55
	.short	86                              # 0x56
	.short	87                              # 0x57
	.short	88                              # 0x58
	.short	89                              # 0x59
	.short	90                              # 0x5a
	.short	91                              # 0x5b
	.short	92                              # 0x5c
	.short	93                              # 0x5d
	.short	94                              # 0x5e
	.short	95                              # 0x5f
.LCPI4_6:
	.short	96                              # 0x60
	.short	97                              # 0x61
	.short	98                              # 0x62
	.short	99                              # 0x63
	.short	100                             # 0x64
	.short	101                             # 0x65
	.short	102                             # 0x66
	.short	103                             # 0x67
	.short	104                             # 0x68
	.short	105                             # 0x69
	.short	106                             # 0x6a
	.short	107                             # 0x6b
	.short	108                             # 0x6c
	.short	109                             # 0x6d
	.short	110                             # 0x6e
	.short	111                             # 0x6f
.LCPI4_7:
	.short	112                             # 0x70
	.short	113                             # 0x71
	.short	114                             # 0x72
	.short	115                             # 0x73
	.short	116                             # 0x74
	.short	117                             # 0x75
	.short	118                             # 0x76
	.short	119                             # 0x77
	.short	120                             # 0x78
	.short	121                             # 0x79
	.short	122                             # 0x7a
	.short	123                             # 0x7b
	.short	124                             # 0x7c
	.short	125                             # 0x7d
	.short	126                             # 0x7e
	.short	127                             # 0x7f
.LCPI4_8:
	.short	128                             # 0x80
	.short	129                             # 0x81
	.short	130                             # 0x82
	.short	131                             # 0x83
	.short	132                             # 0x84
	.short	133                             # 0x85
	.short	134                             # 0x86
	.short	135                             # 0x87
	.short	136                             # 0x88
	.short	137                             # 0x89
	.short	138                             # 0x8a
	.short	139                             # 0x8b
	.short	140                             # 0x8c
	.short	141                             # 0x8d
	.short	142                             # 0x8e
	.short	143                             # 0x8f
.LCPI4_9:
	.short	144                             # 0x90
	.short	145                             # 0x91
	.short	146                             # 0x92
	.short	147                             # 0x93
	.short	148                             # 0x94
	.short	149                             # 0x95
	.short	150                             # 0x96
	.short	151                             # 0x97
	.short	152                             # 0x98
	.short	153                             # 0x99
	.short	154                             # 0x9a
	.short	155                             # 0x9b
	.short	156                             # 0x9c
	.short	157                             # 0x9d
	.short	158                             # 0x9e
	.short	159                             # 0x9f
.LCPI4_10:
	.short	160                             # 0xa0
	.short	161                             # 0xa1
	.short	162                             # 0xa2
	.short	163                             # 0xa3
	.short	164                             # 0xa4
	.short	165                             # 0xa5
	.short	166                             # 0xa6
	.short	167                             # 0xa7
	.short	168                             # 0xa8
	.short	169                             # 0xa9
	.short	170                             # 0xaa
	.short	171                             # 0xab
	.short	172                             # 0xac
	.short	173                             # 0xad
	.short	174                             # 0xae
	.short	175                             # 0xaf
.LCPI4_11:
	.short	176                             # 0xb0
	.short	177                             # 0xb1
	.short	178                             # 0xb2
	.short	179                             # 0xb3
	.short	180                             # 0xb4
	.short	181                             # 0xb5
	.short	182                             # 0xb6
	.short	183                             # 0xb7
	.short	184                             # 0xb8
	.short	185                             # 0xb9
	.short	186                             # 0xba
	.short	187                             # 0xbb
	.short	188                             # 0xbc
	.short	189                             # 0xbd
	.short	190                             # 0xbe
	.short	191                             # 0xbf
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI4_12:
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0
.LCPI4_13:
	.short	191                             # 0xbf
	.short	191                             # 0xbf
	.section	.text._ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE,"axG",@progbits,_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE,comdat
	.weak	_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE
	.p2align	4, 0x90
	.type	_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE,@function
_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE: # @_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$40, %rsp
	movl	%ecx, %r13d
	movq	%rdx, %r15
	movq	%rsi, %r14
	movq	%rdi, %rbx
	testq	%rsi, %rsi
	je	.LBB4_2
# %bb.1:
	movl	$9880, %edi                     # imm = 0x2698
	callq	_Znwm
	movq	%rax, %r15
	movl	$9880, %edx                     # imm = 0x2698
	movq	%rax, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movq	%r15, %rdi
	callq	_ZN3fx23opt8OptModelC2Ev
.LBB4_2:
	testq	%r14, %r14
	movq	%r15, (%rbx)
	setne	8(%rbx)
	movq	%r15, 16(%rbx)
	movl	%r13d, 24(%rbx)
	leaq	32(%rbx), %rax
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	leaq	128(%rbx), %rax
	movq	%rax, (%rsp)                    # 8-byte Spill
	leaq	12736(%rbx), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	leaq	17216(%rbx), %rax
	movq	%rax, 24(%rsp)                  # 8-byte Spill
	leaq	22656(%rbx), %rdi
	movl	$1568, %edx                     # imm = 0x620
	xorl	%esi, %esi
	callq	memset@PLT
	leaq	24256(%rbx), %rdi
	movl	$1568, %edx                     # imm = 0x620
	xorl	%esi, %esi
	callq	memset@PLT
	leaq	25856(%rbx), %rax
	movq	%rax, 8(%rsp)                   # 8-byte Spill
	vxorps	%xmm0, %xmm0, %xmm0
	vmovaps	%ymm0, 26944(%rbx)
	vmovaps	%ymm0, 26976(%rbx)
	vmovaps	%ymm0, 27008(%rbx)
	vmovaps	%ymm0, 27040(%rbx)
	vmovaps	%ymm0, 27072(%rbx)
	vmovaps	%ymm0, 27104(%rbx)
	vmovaps	%ymm0, 27136(%rbx)
	vmovaps	%ymm0, 27168(%rbx)
	vmovaps	%ymm0, 27200(%rbx)
	vmovaps	%ymm0, 27232(%rbx)
	vmovaps	%ymm0, 27264(%rbx)
	vmovaps	%ymm0, 27296(%rbx)
	vmovaps	%ymm0, 27328(%rbx)
	vmovaps	%ymm0, 27360(%rbx)
	vmovaps	%ymm0, 27392(%rbx)
	leaq	27456(%rbx), %rbp
	leaq	48000(%rbx), %r12
	vmovaps	%ymm0, 32(%rbx)
	vmovups	%ymm0, 56(%rbx)
	movl	$12576, %edx                    # imm = 0x3120
	movq	(%rsp), %rdi                    # 8-byte Reload
	xorl	%esi, %esi
	vzeroupper
	callq	memset@PLT
	movl	$4420, %edx                     # imm = 0x1144
	movq	16(%rsp), %rdi                  # 8-byte Reload
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$5408, %edx                     # imm = 0x1520
	movq	24(%rsp), %rdi                  # 8-byte Reload
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$1056, %edx                     # imm = 0x420
	movq	8(%rsp), %rdi                   # 8-byte Reload
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$20532, %edx                    # imm = 0x5034
	movq	%rbp, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	movl	$9472, %edx                     # imm = 0x2500
	movq	%r12, %rdi
	xorl	%esi, %esi
	callq	memset@PLT
	testq	%r14, %r14
	je	.LBB4_4
# %bb.3:
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt8OptModel4loadEPKc
	movl	24(%rbx), %r13d
.LBB4_4:
	testl	%r13d, %r13d
	movl	$3475008, %eax                  # imm = 0x350640
	movl	$1705536, %esi                  # imm = 0x1A0640
	cmoveq	%rax, %rsi
	movq	32(%rsp), %rdi                  # 8-byte Reload
	callq	_ZN3fx23opt7HugeBuf5allocEm
	movq	32(%rbx), %rdi
	movq	%rdi, 48(%rbx)
	leaq	525888(%rdi), %rax
	cmpl	$0, 24(%rbx)
	je	.LBB4_5
# %bb.6:
	movq	%rax, 64(%rbx)
	jmp	.LBB4_7
.LBB4_5:
	movq	%rax, 56(%rbx)
.LBB4_7:
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$58432, %edi                    # imm = 0xE440
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$116864, %edi                   # imm = 0x1C880
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$175296, %edi                   # imm = 0x2ACC0
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$233728, %edi                   # imm = 0x39100
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$292160, %edi                   # imm = 0x47540
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$350592, %edi                   # imm = 0x55980
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$409024, %edi                   # imm = 0x63DC0
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$467456, %edi                   # imm = 0x72200
	addq	48(%rbx), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	vmovaps	.LCPI4_0(%rip), %ymm0           # ymm0 = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
	vmovaps	%ymm0, 22208(%rbx)
	vmovaps	.LCPI4_1(%rip), %ymm0           # ymm0 = [16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
	vmovaps	%ymm0, 22240(%rbx)
	vmovaps	.LCPI4_2(%rip), %ymm0           # ymm0 = [32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47]
	vmovaps	%ymm0, 22272(%rbx)
	vmovaps	.LCPI4_3(%rip), %ymm0           # ymm0 = [48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63]
	vmovaps	%ymm0, 22304(%rbx)
	vmovaps	.LCPI4_4(%rip), %ymm0           # ymm0 = [64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79]
	vmovaps	%ymm0, 22336(%rbx)
	vmovaps	.LCPI4_5(%rip), %ymm0           # ymm0 = [80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95]
	vmovaps	%ymm0, 22368(%rbx)
	vmovaps	.LCPI4_6(%rip), %ymm0           # ymm0 = [96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111]
	vmovaps	%ymm0, 22400(%rbx)
	vmovaps	.LCPI4_7(%rip), %ymm0           # ymm0 = [112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127]
	vmovaps	%ymm0, 22432(%rbx)
	vmovaps	.LCPI4_8(%rip), %ymm0           # ymm0 = [128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143]
	vmovaps	%ymm0, 22464(%rbx)
	vmovaps	.LCPI4_9(%rip), %ymm0           # ymm0 = [144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159]
	vmovaps	%ymm0, 22496(%rbx)
	vmovaps	.LCPI4_10(%rip), %ymm0          # ymm0 = [160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175]
	vmovaps	%ymm0, 22528(%rbx)
	vmovaps	.LCPI4_11(%rip), %ymm0          # ymm0 = [176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191]
	vmovaps	%ymm0, 22560(%rbx)
	vbroadcastss	.LCPI4_13(%rip), %xmm0  # xmm0 = [191,191,191,191,191,191,191,191]
	vmovaps	%xmm0, 22592(%rbx)
	vmovaps	%xmm0, 22608(%rbx)
	addq	$40, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end4:
	.size	_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE, .Lfunc_end4-_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE # -- Begin function _ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE,@function
_ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE: # @_ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	movq	%rsi, %rbx
	movq	%rdi, %r14
	movl	$57472, %edi                    # imm = 0xE080
	movl	$64, %esi
	callq	_ZnwmSt11align_val_t
	movq	%rax, %r15
	movq	(%rbx), %rax
	movq	(%rax), %rdx
	movl	24(%rax), %ecx
	movq	%r15, %rdi
	xorl	%esi, %esi
	callq	_ZN3fx23opt18TransformerOptImplC2EPKcPNS0_8OptModelENS0_8AttnKindE
	movq	%r15, (%r14)
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.Lfunc_end5:
	.size	_ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE, .Lfunc_end5-_ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOptD2Ev,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOptD2Ev # -- Begin function _ZN3fx23opt14TransformerOptD2Ev
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOptD2Ev,@function
_ZN3fx23opt14TransformerOptD2Ev:        # @_ZN3fx23opt14TransformerOptD2Ev
# %bb.0:
	jmp	_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev # TAILCALL
.Lfunc_end6:
	.size	_ZN3fx23opt14TransformerOptD2Ev, .Lfunc_end6-_ZN3fx23opt14TransformerOptD2Ev
                                        # -- End function
	.section	.text._ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev,"axG",@progbits,_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev,comdat
	.weak	_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev # -- Begin function _ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev
	.p2align	4, 0x90
	.type	_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev,@function
_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev: # @_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev
# %bb.0:
	pushq	%r15
	pushq	%r14
	pushq	%rbx
	movq	%rdi, %rbx
	movq	(%rdi), %r14
	testq	%r14, %r14
	je	.LBB7_9
# %bb.1:
	cmpb	$0, 8(%r14)
	je	.LBB7_8
# %bb.2:
	movq	(%r14), %r15
	testq	%r15, %r15
	je	.LBB7_8
# %bb.3:
	movq	7616(%r15), %rdi
	testq	%rdi, %rdi
	je	.LBB7_5
# %bb.4:
	callq	_ZdlPv
.LBB7_5:
	movq	7592(%r15), %rdi
	testq	%rdi, %rdi
	je	.LBB7_7
# %bb.6:
	callq	_ZdlPv
.LBB7_7:
	movq	%r15, %rdi
	callq	_ZN3fx23opt7HugeBufD1Ev
	movq	%r15, %rdi
	callq	_ZdlPv
.LBB7_8:
	leaq	32(%r14), %rdi
	callq	_ZN3fx23opt7HugeBufD1Ev
	movl	$64, %esi
	movq	%r14, %rdi
	callq	_ZdlPvSt11align_val_t
.LBB7_9:
	movq	$0, (%rbx)
	popq	%rbx
	popq	%r14
	popq	%r15
	retq
.Lfunc_end7:
	.size	_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev, .Lfunc_end7-_ZNSt10unique_ptrIN3fx23opt18TransformerOptImplESt14default_deleteIS2_EED2Ev
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOpt13begin_articleEl,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOpt13begin_articleEl # -- Begin function _ZN3fx23opt14TransformerOpt13begin_articleEl
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOpt13begin_articleEl,@function
_ZN3fx23opt14TransformerOpt13begin_articleEl: # @_ZN3fx23opt14TransformerOpt13begin_articleEl
# %bb.0:
	pushq	%r14
	pushq	%rbx
	pushq	%rax
	movq	%rsi, %rbx
	movq	(%rdi), %r14
	movq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$58432, %edi                    # imm = 0xE440
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$116864, %edi                   # imm = 0x1C880
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$175296, %edi                   # imm = 0x2ACC0
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$233728, %edi                   # imm = 0x39100
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$292160, %edi                   # imm = 0x47540
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$350592, %edi                   # imm = 0x55980
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$409024, %edi                   # imm = 0x63DC0
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movl	$467456, %edi                   # imm = 0x72200
	addq	48(%r14), %rdi
	callq	_ZN3fx23opt15kda_layer_resetERNS0_8KdaStateE
	movq	$0, 72(%r14)
	movq	%rbx, 80(%r14)
	addq	$8, %rsp
	popq	%rbx
	popq	%r14
	retq
.Lfunc_end8:
	.size	_ZN3fx23opt14TransformerOpt13begin_articleEl, .Lfunc_end8-_ZN3fx23opt14TransformerOpt13begin_articleEl
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOpt4stepEhPKtPf,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOpt4stepEhPKtPf # -- Begin function _ZN3fx23opt14TransformerOpt4stepEhPKtPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOpt4stepEhPKtPf,@function
_ZN3fx23opt14TransformerOpt4stepEhPKtPf: # @_ZN3fx23opt14TransformerOpt4stepEhPKtPf
# %bb.0:
	pushq	%rbp
	pushq	%r14
	pushq	%rbx
	movq	%rcx, %rbx
	movl	%esi, %ebp
	movq	%rdi, %r14
	movl	$25856, %esi                    # imm = 0x6500
	addq	(%rdi), %rsi
	movq	%rdx, %rdi
	callq	_ZN3fx23opt16prior_f16_to_f32EPKtPf
	movq	(%r14), %rdi
	movl	%ebp, %esi
	movq	%rbx, %rdx
	popq	%rbx
	popq	%r14
	popq	%rbp
	jmp	_ZN3fx23opt18TransformerOptImpl4stepEhPf # TAILCALL
.Lfunc_end9:
	.size	_ZN3fx23opt14TransformerOpt4stepEhPKtPf, .Lfunc_end9-_ZN3fx23opt14TransformerOpt4stepEhPKtPf
                                        # -- End function
	.section	.text._ZN3fx23opt18TransformerOptImpl4stepEhPf,"axG",@progbits,_ZN3fx23opt18TransformerOptImpl4stepEhPf,comdat
	.weak	_ZN3fx23opt18TransformerOptImpl4stepEhPf # -- Begin function _ZN3fx23opt18TransformerOptImpl4stepEhPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt18TransformerOptImpl4stepEhPf,@function
_ZN3fx23opt18TransformerOptImpl4stepEhPf: # @_ZN3fx23opt18TransformerOptImpl4stepEhPf
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$104, %rsp
	movq	%rdi, %rbx
	movq	16(%rdi), %rax
	movl	%esi, %ecx
	leaq	(%rcx,%rcx,2), %rcx
	shlq	$8, %rcx
	addq	7584(%rax), %rcx
	movq	%rcx, 24(%rsp)                  # 8-byte Spill
	movq	%rdx, %r12
	addq	$25856, %rdi                    # imm = 0x6500
	vmovss	48(%rax), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	leaq	26688(%rbx), %r14
	movq	%r14, %rsi
	callq	_ZN3fx23opt15prior_quant_rawEPKffPh
	leaq	26944(%rbx), %r15
	movq	%r14, %rdi
	movl	$205, %esi
	movq	%r15, %rdx
	callq	_ZN3fx23opt16qsparse_make_idxEPKhiPt
	movslq	%eax, %rcx
	testl	%eax, %eax
	je	.LBB10_1
# %bb.2:
	movzwl	26942(%rbx,%rcx,2), %edx
	jmp	.LBB10_3
.LBB10_1:
	xorl	%edx, %edx
.LBB10_3:
	vmovd	%edx, %xmm0
	vpbroadcastw	%xmm0, %xmm0
	vmovdqu	%xmm0, 26944(%rbx,%rcx,2)
	movq	16(%rbx), %rdi
	addq	$24, %rdi
	leaq	6272(%rbx), %r13
	cmpl	$195, %eax
	movq	%r12, 32(%rsp)                  # 8-byte Spill
	movq	%r14, %rsi
	jl	.LBB10_5
# %bb.4:
	movq	%r13, %rdx
	callq	_ZN3fx23opt18qsparse4_dense_f32ERKNS0_8QSparse4EPKhPf
	jmp	.LBB10_6
.LBB10_5:
	movq	%r15, %rdx
	movl	%eax, %ecx
	movq	%r13, %r8
	callq	_ZN3fx23opt12qsparse4_f32ERKNS0_8QSparse4EPKhPKtiPf
.LBB10_6:
	leaq	4736(%rbx), %rdx
	movq	24(%rsp), %rdi                  # 8-byte Reload
	movq	%r13, %rsi
	movq	%rdx, %r12
	callq	_ZN3fx23opt16embed_combine192EPKfS2_Pf
	leaq	5504(%rbx), %rax
	movq	%rax, 16(%rsp)                  # 8-byte Spill
	leaq	21824(%rbx), %rax
	movq	%rax, 80(%rsp)                  # 8-byte Spill
	leaq	17216(%rbx), %rax
	movq	%rax, 72(%rsp)                  # 8-byte Spill
	leaq	20288(%rbx), %rax
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	leaq	22656(%rbx), %rax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	leaq	24256(%rbx), %rax
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	leaq	8576(%rbx), %r14
	leaq	128(%rbx), %r15
	xorl	%r13d, %r13d
	xorl	%ebp, %ebp
	movq	%r12, 40(%rsp)                  # 8-byte Spill
	jmp	.LBB10_7
	.p2align	4, 0x90
.LBB10_14:                              #   in Loop: Header=BB10_7 Depth=1
	incq	%rbp
	movq	96(%rsp), %r14                  # 8-byte Reload
	addq	$-768, %r14                     # imm = 0xFD00
	addq	$768, %r15                      # imm = 0x300
	addq	$32, %r13
	cmpq	$12, %rbp
	je	.LBB10_15
.LBB10_7:                               # =>This Inner Loop Header: Depth=1
	cmpq	$6, %rbp
	jb	.LBB10_9
# %bb.8:                                #   in Loop: Header=BB10_7 Depth=1
	movq	16(%rbx), %rax
	leal	-6(%rbp), %ecx
	vmovd	7560(%rax,%rcx,4), %xmm0        # xmm0 = mem[0],zero,zero,zero
	movq	%r12, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt13add_scaled192EPffPKf
.LBB10_9:                               #   in Loop: Header=BB10_7 Depth=1
	movq	16(%rbx), %rax
	vmovss	7464(%rax,%rbp,4), %xmm0        # xmm0 = mem[0],zero,zero,zero
	vmovss	7512(%rax,%rbp,4), %xmm1        # xmm1 = mem[0],zero,zero,zero
	movq	%r12, %rdi
	movq	24(%rsp), %rsi                  # 8-byte Reload
	callq	_ZN3fx23opt12axpby_tok192EfPffPKf
	movl	%ebp, 17152(%rbx)
	movl	$2184, %eax                     # imm = 0x888
	btq	%rbp, %rax
	movq	16(%rbx), %rax
	movq	%r14, 96(%rsp)                  # 8-byte Spill
	movq	%r15, 88(%rsp)                  # 8-byte Spill
	jb	.LBB10_11
# %bb.10:                               #   in Loop: Header=BB10_7 Depth=1
	movl	7368(%rax,%rbp,4), %esi
	movq	%rbx, %rdi
	callq	_ZN3fx23opt18TransformerOptImpl10kimi_layerEi
	jmp	.LBB10_12
	.p2align	4, 0x90
.LBB10_11:                              #   in Loop: Header=BB10_7 Depth=1
	movl	7416(%rax,%rbp,4), %esi
	movq	%rbx, %rdi
	callq	_ZN3fx23opt18TransformerOptImpl9van_layerEi
.LBB10_12:                              #   in Loop: Header=BB10_7 Depth=1
	movq	%r12, %rdi
	movq	16(%rsp), %r12                  # 8-byte Reload
	movq	%r12, %rsi
	callq	_ZN3fx23opt11rms_norm192EPKfPf
	movq	16(%rbx), %rax
	vmovss	7792(%rax,%r13), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	%r12, %rdi
	movq	80(%rsp), %r14                  # 8-byte Reload
	movq	%r14, %rsi
	callq	_ZN3fx23opt12quant192_i16EPKffPs
	movl	$0, 12(%rsp)
	movl	$0, 8(%rsp)
	movq	16(%rbx), %rax
	movq	7784(%rax,%r13), %rsi
	movq	7768(%rax,%r13), %rdi
	movq	7776(%rax,%r13), %rdx
	movq	%r14, %rcx
	movl	$768, %r8d                      # imm = 0x300
	movq	72(%rsp), %r14                  # 8-byte Reload
	movq	%r14, %r9
	callq	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
	movq	16(%rbx), %rax
	vmovd	9496(%rax,%rbp,4), %xmm0        # xmm0 = mem[0],zero,zero,zero
	subq	$8, %rsp
	movq	%r14, %rdi
	movl	$768, %esi                      # imm = 0x300
	movq	72(%rsp), %r14                  # 8-byte Reload
	movq	%r14, %rdx
	movq	64(%rsp), %r12                  # 8-byte Reload
	movq	%r12, %rcx
	movq	56(%rsp), %r15                  # 8-byte Reload
	movq	%r15, %r8
	leaq	20(%rsp), %r9
	leaq	16(%rsp), %rax
	pushq	%rax
	callq	_ZN3fx23opt14relu2_quant16pEPKffiPsPtS4_PiS5_
	addq	$16, %rsp
	movq	16(%rbx), %rcx
	movq	9304(%rcx,%rbp,8), %rdi
	movq	9400(%rcx,%rbp,8), %rsi
	movl	12(%rsp), %r10d
	movl	8(%rsp), %r11d
	subq	$8, %rsp
	movq	%r14, %rdx
	movq	%r12, %rcx
	movl	%eax, %r8d
	movq	%r15, %r9
	movq	48(%rsp), %rax                  # 8-byte Reload
	movq	%rax, %r12
	pushq	%rax
	pushq	%r11
	pushq	%r10
	callq	_ZN3fx23opt11spmv16p_addEPKhPKfPKsPKtiS8_iiPf
	addq	$32, %rsp
	cmpq	$5, %rbp
	movq	88(%rsp), %r15                  # 8-byte Reload
	ja	.LBB10_14
# %bb.13:                               #   in Loop: Header=BB10_7 Depth=1
	movl	$768, %edx                      # imm = 0x300
	movq	%r15, %rdi
	movq	%r12, %rsi
	callq	memcpy@PLT
	jmp	.LBB10_14
.LBB10_15:
	movq	16(%rbx), %rax
	vmovss	7360(%rax), %xmm0               # xmm0 = mem[0],zero,zero,zero
	leaq	7040(%rbx), %r14
	movq	%r12, %rdi
	movq	16(%rsp), %rsi                  # 8-byte Reload
	movq	%r14, %rdx
	callq	_ZN3fx23opt17rms_norm_quant192EPKfPffPh
	movl	$7304, %edi                     # imm = 0x1C88
	addq	16(%rbx), %rdi
	leaq	27456(%rbx), %r15
	movq	%r14, %rsi
	movq	%r15, %rdx
	callq	_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
	leaq	28288(%rbx), %r14
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt20head_softcap_softmaxEPfS1_
	movl	$820, %edx                      # imm = 0x334
	movq	32(%rsp), %rdi                  # 8-byte Reload
	movq	%r14, %rsi
	callq	memcpy@PLT
	incq	72(%rbx)
	addq	$104, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end10:
	.size	_ZN3fx23opt18TransformerOptImpl4stepEhPf, .Lfunc_end10-_ZN3fx23opt18TransformerOptImpl4stepEhPf
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOpt4stepEhPKfPf,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOpt4stepEhPKfPf # -- Begin function _ZN3fx23opt14TransformerOpt4stepEhPKfPf
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOpt4stepEhPKfPf,@function
_ZN3fx23opt14TransformerOpt4stepEhPKfPf: # @_ZN3fx23opt14TransformerOpt4stepEhPKfPf
# %bb.0:
	pushq	%rbp
	pushq	%r14
	pushq	%rbx
	movq	%rcx, %rbx
	movq	%rdx, %rax
	movl	%esi, %ebp
	movq	%rdi, %r14
	movl	$25856, %edi                    # imm = 0x6500
	addq	(%r14), %rdi
	movl	$820, %edx                      # imm = 0x334
	movq	%rax, %rsi
	callq	memcpy@PLT
	movq	(%r14), %rdi
	movl	$0, 26684(%rdi)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovlps	%xmm0, 26676(%rdi)
	movl	%ebp, %esi
	movq	%rbx, %rdx
	popq	%rbx
	popq	%r14
	popq	%rbp
	jmp	_ZN3fx23opt18TransformerOptImpl4stepEhPf # TAILCALL
.Lfunc_end11:
	.size	_ZN3fx23opt14TransformerOpt4stepEhPKfPf, .Lfunc_end11-_ZN3fx23opt14TransformerOpt4stepEhPKfPf
                                        # -- End function
	.section	.text._ZNK3fx23opt14TransformerOpt11last_logitsEv,"ax",@progbits
	.globl	_ZNK3fx23opt14TransformerOpt11last_logitsEv # -- Begin function _ZNK3fx23opt14TransformerOpt11last_logitsEv
	.p2align	4, 0x90
	.type	_ZNK3fx23opt14TransformerOpt11last_logitsEv,@function
_ZNK3fx23opt14TransformerOpt11last_logitsEv: # @_ZNK3fx23opt14TransformerOpt11last_logitsEv
# %bb.0:
	movl	$27456, %eax                    # imm = 0x6B40
	addq	(%rdi), %rax
	retq
.Lfunc_end12:
	.size	_ZNK3fx23opt14TransformerOpt11last_logitsEv, .Lfunc_end12-_ZNK3fx23opt14TransformerOpt11last_logitsEv
                                        # -- End function
	.section	.text._ZNK3fx23opt14TransformerOpt11last_hiddenEv,"ax",@progbits
	.globl	_ZNK3fx23opt14TransformerOpt11last_hiddenEv # -- Begin function _ZNK3fx23opt14TransformerOpt11last_hiddenEv
	.p2align	4, 0x90
	.type	_ZNK3fx23opt14TransformerOpt11last_hiddenEv,@function
_ZNK3fx23opt14TransformerOpt11last_hiddenEv: # @_ZNK3fx23opt14TransformerOpt11last_hiddenEv
# %bb.0:
	movl	$5504, %eax                     # imm = 0x1580
	addq	(%rdi), %rax
	retq
.Lfunc_end13:
	.size	_ZNK3fx23opt14TransformerOpt11last_hiddenEv, .Lfunc_end13-_ZNK3fx23opt14TransformerOpt11last_hiddenEv
                                        # -- End function
	.section	.text._ZN3fx23opt14TransformerOpt18set_capture_layersEj,"ax",@progbits
	.globl	_ZN3fx23opt14TransformerOpt18set_capture_layersEj # -- Begin function _ZN3fx23opt14TransformerOpt18set_capture_layersEj
	.p2align	4, 0x90
	.type	_ZN3fx23opt14TransformerOpt18set_capture_layersEj,@function
_ZN3fx23opt14TransformerOpt18set_capture_layersEj: # @_ZN3fx23opt14TransformerOpt18set_capture_layersEj
# %bb.0:
	movq	(%rdi), %rax
	movl	%esi, 29120(%rax)
	retq
.Lfunc_end14:
	.size	_ZN3fx23opt14TransformerOpt18set_capture_layersEj, .Lfunc_end14-_ZN3fx23opt14TransformerOpt18set_capture_layersEj
                                        # -- End function
	.section	.text._ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh,"ax",@progbits
	.globl	_ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh # -- Begin function _ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh
	.p2align	4, 0x90
	.type	_ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh,@function
_ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh: # @_ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh
# %bb.0:
	movq	(%rdi), %rax
	movslq	%esi, %rsi
	imulq	$1568, %rsi, %r8                # imm = 0x620
	addq	%r8, %rax
	addq	$29172, %rax                    # imm = 0x71F4
	movq	%rax, (%rdx)
	movq	(%rdi), %rax
	leaq	(%rsi,%rsi,2), %rdx
	shlq	$8, %rdx
	addq	%rdx, %rax
	addq	$48000, %rax                    # imm = 0xBB80
	movq	%rax, (%rcx)
	movq	(%rdi), %rax
	movl	29124(%rax,%rsi,4), %eax
	retq
.Lfunc_end15:
	.size	_ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh, .Lfunc_end15-_ZNK3fx23opt14TransformerOpt8mlp_actsEiPPKtPPKh
                                        # -- End function
	.section	.text._ZNK3fx23opt14TransformerOpt9attn_kindEv,"ax",@progbits
	.globl	_ZNK3fx23opt14TransformerOpt9attn_kindEv # -- Begin function _ZNK3fx23opt14TransformerOpt9attn_kindEv
	.p2align	4, 0x90
	.type	_ZNK3fx23opt14TransformerOpt9attn_kindEv,@function
_ZNK3fx23opt14TransformerOpt9attn_kindEv: # @_ZNK3fx23opt14TransformerOpt9attn_kindEv
# %bb.0:
	movq	(%rdi), %rax
	movl	24(%rax), %eax
	retq
.Lfunc_end16:
	.size	_ZNK3fx23opt14TransformerOpt9attn_kindEv, .Lfunc_end16-_ZNK3fx23opt14TransformerOpt9attn_kindEv
                                        # -- End function
	.section	.text._ZN3fx23opt8OptModelC2Ev,"axG",@progbits,_ZN3fx23opt8OptModelC2Ev,comdat
	.weak	_ZN3fx23opt8OptModelC2Ev        # -- Begin function _ZN3fx23opt8OptModelC2Ev
	.p2align	4, 0x90
	.type	_ZN3fx23opt8OptModelC2Ev,@function
_ZN3fx23opt8OptModelC2Ev:               # @_ZN3fx23opt8OptModelC2Ev
# %bb.0:
	movq	$0, 96(%rdi)
	movb	$0, 104(%rdi)
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%ymm0, 56(%rdi)
	movl	$0, 88(%rdi)
	movl	$0, 112(%rdi)
	movq	$0, 160(%rdi)
	movb	$0, 168(%rdi)
	vmovups	%ymm0, 120(%rdi)
	movl	$0, 152(%rdi)
	movl	$0, 176(%rdi)
	movq	$0, 224(%rdi)
	movb	$0, 232(%rdi)
	vmovups	%ymm0, 184(%rdi)
	movl	$0, 216(%rdi)
	movl	$0, 240(%rdi)
	movq	$0, 288(%rdi)
	movb	$0, 296(%rdi)
	vmovups	%ymm0, 248(%rdi)
	movl	$0, 280(%rdi)
	movl	$0, 304(%rdi)
	movq	$0, 352(%rdi)
	movb	$0, 360(%rdi)
	vmovups	%ymm0, 312(%rdi)
	movl	$0, 344(%rdi)
	movl	$0, 368(%rdi)
	movq	$0, 416(%rdi)
	movb	$0, 424(%rdi)
	vmovups	%ymm0, 376(%rdi)
	movl	$0, 408(%rdi)
	movl	$0, 432(%rdi)
	movq	$0, 480(%rdi)
	movb	$0, 488(%rdi)
	vmovups	%ymm0, 440(%rdi)
	movl	$0, 472(%rdi)
	movl	$0, 496(%rdi)
	movq	$0, 544(%rdi)
	movb	$0, 552(%rdi)
	vmovups	%ymm0, 504(%rdi)
	movl	$0, 536(%rdi)
	movl	$0, 560(%rdi)
	vmovups	%ymm0, 596(%rdi)
	vmovups	%ymm0, 568(%rdi)
	movq	$0, 672(%rdi)
	movb	$0, 680(%rdi)
	vmovups	%ymm0, 632(%rdi)
	movl	$0, 664(%rdi)
	movl	$0, 688(%rdi)
	movq	$0, 736(%rdi)
	movb	$0, 744(%rdi)
	vmovups	%ymm0, 696(%rdi)
	movl	$0, 728(%rdi)
	movl	$0, 752(%rdi)
	movq	$0, 800(%rdi)
	movb	$0, 808(%rdi)
	vmovups	%ymm0, 760(%rdi)
	movl	$0, 792(%rdi)
	movl	$0, 816(%rdi)
	movq	$0, 864(%rdi)
	movb	$0, 872(%rdi)
	vmovups	%ymm0, 824(%rdi)
	movl	$0, 856(%rdi)
	movl	$0, 880(%rdi)
	movq	$0, 928(%rdi)
	movb	$0, 936(%rdi)
	vmovups	%ymm0, 888(%rdi)
	movl	$0, 920(%rdi)
	movl	$0, 944(%rdi)
	movq	$0, 992(%rdi)
	movb	$0, 1000(%rdi)
	vmovups	%ymm0, 952(%rdi)
	movl	$0, 984(%rdi)
	movl	$0, 1008(%rdi)
	movq	$0, 1056(%rdi)
	movb	$0, 1064(%rdi)
	vmovups	%ymm0, 1016(%rdi)
	movl	$0, 1048(%rdi)
	movl	$0, 1072(%rdi)
	movq	$0, 1120(%rdi)
	movb	$0, 1128(%rdi)
	vmovups	%ymm0, 1080(%rdi)
	movl	$0, 1112(%rdi)
	movl	$0, 1136(%rdi)
	vmovups	%ymm0, 1172(%rdi)
	vmovups	%ymm0, 1144(%rdi)
	movq	$0, 1248(%rdi)
	movb	$0, 1256(%rdi)
	vmovups	%ymm0, 1208(%rdi)
	movl	$0, 1240(%rdi)
	movl	$0, 1264(%rdi)
	movq	$0, 1312(%rdi)
	movb	$0, 1320(%rdi)
	vmovups	%ymm0, 1272(%rdi)
	movl	$0, 1304(%rdi)
	movl	$0, 1328(%rdi)
	movq	$0, 1376(%rdi)
	movb	$0, 1384(%rdi)
	vmovups	%ymm0, 1336(%rdi)
	movl	$0, 1368(%rdi)
	movl	$0, 1392(%rdi)
	movq	$0, 1440(%rdi)
	movb	$0, 1448(%rdi)
	vmovups	%ymm0, 1400(%rdi)
	movl	$0, 1432(%rdi)
	movl	$0, 1456(%rdi)
	movq	$0, 1504(%rdi)
	movb	$0, 1512(%rdi)
	vmovups	%ymm0, 1464(%rdi)
	movl	$0, 1496(%rdi)
	movl	$0, 1520(%rdi)
	movq	$0, 1568(%rdi)
	movb	$0, 1576(%rdi)
	vmovups	%ymm0, 1528(%rdi)
	movl	$0, 1560(%rdi)
	movl	$0, 1584(%rdi)
	movq	$0, 1632(%rdi)
	movb	$0, 1640(%rdi)
	vmovups	%ymm0, 1592(%rdi)
	movl	$0, 1624(%rdi)
	movl	$0, 1648(%rdi)
	movq	$0, 1696(%rdi)
	movb	$0, 1704(%rdi)
	vmovups	%ymm0, 1656(%rdi)
	movl	$0, 1688(%rdi)
	movl	$0, 1712(%rdi)
	vmovups	%ymm0, 1748(%rdi)
	vmovups	%ymm0, 1720(%rdi)
	movq	$0, 1824(%rdi)
	movb	$0, 1832(%rdi)
	vmovups	%ymm0, 1784(%rdi)
	movl	$0, 1816(%rdi)
	movl	$0, 1840(%rdi)
	movq	$0, 1888(%rdi)
	movb	$0, 1896(%rdi)
	vmovups	%ymm0, 1848(%rdi)
	movl	$0, 1880(%rdi)
	movl	$0, 1904(%rdi)
	movq	$0, 1952(%rdi)
	movb	$0, 1960(%rdi)
	vmovups	%ymm0, 1912(%rdi)
	movl	$0, 1944(%rdi)
	movl	$0, 1968(%rdi)
	movq	$0, 2016(%rdi)
	movb	$0, 2024(%rdi)
	vmovups	%ymm0, 1976(%rdi)
	movl	$0, 2008(%rdi)
	movl	$0, 2032(%rdi)
	movq	$0, 2080(%rdi)
	movb	$0, 2088(%rdi)
	vmovups	%ymm0, 2040(%rdi)
	movl	$0, 2072(%rdi)
	movl	$0, 2096(%rdi)
	movq	$0, 2144(%rdi)
	movb	$0, 2152(%rdi)
	vmovups	%ymm0, 2104(%rdi)
	movl	$0, 2136(%rdi)
	movl	$0, 2160(%rdi)
	movq	$0, 2208(%rdi)
	movb	$0, 2216(%rdi)
	vmovups	%ymm0, 2168(%rdi)
	movl	$0, 2200(%rdi)
	movl	$0, 2224(%rdi)
	movq	$0, 2272(%rdi)
	movb	$0, 2280(%rdi)
	vmovups	%ymm0, 2232(%rdi)
	movl	$0, 2264(%rdi)
	movl	$0, 2288(%rdi)
	vmovups	%ymm0, 2324(%rdi)
	vmovups	%ymm0, 2296(%rdi)
	movq	$0, 2400(%rdi)
	movb	$0, 2408(%rdi)
	vmovups	%ymm0, 2360(%rdi)
	movl	$0, 2392(%rdi)
	movl	$0, 2416(%rdi)
	movq	$0, 2464(%rdi)
	movb	$0, 2472(%rdi)
	vmovups	%ymm0, 2424(%rdi)
	movl	$0, 2456(%rdi)
	movl	$0, 2480(%rdi)
	movq	$0, 2528(%rdi)
	movb	$0, 2536(%rdi)
	vmovups	%ymm0, 2488(%rdi)
	movl	$0, 2520(%rdi)
	movl	$0, 2544(%rdi)
	movq	$0, 2592(%rdi)
	movb	$0, 2600(%rdi)
	vmovups	%ymm0, 2552(%rdi)
	movl	$0, 2584(%rdi)
	movl	$0, 2608(%rdi)
	movq	$0, 2656(%rdi)
	movb	$0, 2664(%rdi)
	vmovups	%ymm0, 2616(%rdi)
	movl	$0, 2648(%rdi)
	movl	$0, 2672(%rdi)
	movq	$0, 2720(%rdi)
	movb	$0, 2728(%rdi)
	vmovups	%ymm0, 2680(%rdi)
	movl	$0, 2712(%rdi)
	movl	$0, 2736(%rdi)
	movq	$0, 2784(%rdi)
	movb	$0, 2792(%rdi)
	vmovups	%ymm0, 2744(%rdi)
	movl	$0, 2776(%rdi)
	movl	$0, 2800(%rdi)
	movq	$0, 2848(%rdi)
	movb	$0, 2856(%rdi)
	vmovups	%ymm0, 2808(%rdi)
	movl	$0, 2840(%rdi)
	movl	$0, 2864(%rdi)
	vmovups	%ymm0, 2900(%rdi)
	vmovups	%ymm0, 2872(%rdi)
	movq	$0, 2976(%rdi)
	movb	$0, 2984(%rdi)
	vmovups	%ymm0, 2936(%rdi)
	movl	$0, 2968(%rdi)
	movl	$0, 2992(%rdi)
	movq	$0, 3040(%rdi)
	movb	$0, 3048(%rdi)
	vmovups	%ymm0, 3000(%rdi)
	movl	$0, 3032(%rdi)
	movl	$0, 3056(%rdi)
	movq	$0, 3104(%rdi)
	movb	$0, 3112(%rdi)
	vmovups	%ymm0, 3064(%rdi)
	movl	$0, 3096(%rdi)
	movl	$0, 3120(%rdi)
	movq	$0, 3168(%rdi)
	movb	$0, 3176(%rdi)
	vmovups	%ymm0, 3128(%rdi)
	movl	$0, 3160(%rdi)
	movl	$0, 3184(%rdi)
	movq	$0, 3232(%rdi)
	movb	$0, 3240(%rdi)
	vmovups	%ymm0, 3192(%rdi)
	movl	$0, 3224(%rdi)
	movl	$0, 3248(%rdi)
	movq	$0, 3296(%rdi)
	movb	$0, 3304(%rdi)
	vmovups	%ymm0, 3256(%rdi)
	movl	$0, 3288(%rdi)
	movl	$0, 3312(%rdi)
	movq	$0, 3360(%rdi)
	movb	$0, 3368(%rdi)
	vmovups	%ymm0, 3320(%rdi)
	movl	$0, 3352(%rdi)
	movl	$0, 3376(%rdi)
	movq	$0, 3424(%rdi)
	movb	$0, 3432(%rdi)
	vmovups	%ymm0, 3384(%rdi)
	movl	$0, 3416(%rdi)
	movl	$0, 3440(%rdi)
	vmovups	%ymm0, 3476(%rdi)
	vmovups	%ymm0, 3448(%rdi)
	movq	$0, 3552(%rdi)
	movb	$0, 3560(%rdi)
	vmovups	%ymm0, 3512(%rdi)
	movl	$0, 3544(%rdi)
	movl	$0, 3568(%rdi)
	movq	$0, 3616(%rdi)
	movb	$0, 3624(%rdi)
	vmovups	%ymm0, 3576(%rdi)
	movl	$0, 3608(%rdi)
	movl	$0, 3632(%rdi)
	movq	$0, 3680(%rdi)
	movb	$0, 3688(%rdi)
	vmovups	%ymm0, 3640(%rdi)
	movl	$0, 3672(%rdi)
	movl	$0, 3696(%rdi)
	movq	$0, 3744(%rdi)
	movb	$0, 3752(%rdi)
	vmovups	%ymm0, 3704(%rdi)
	movl	$0, 3736(%rdi)
	movl	$0, 3760(%rdi)
	movq	$0, 3808(%rdi)
	movb	$0, 3816(%rdi)
	vmovups	%ymm0, 3768(%rdi)
	movl	$0, 3800(%rdi)
	movl	$0, 3824(%rdi)
	movq	$0, 3872(%rdi)
	movb	$0, 3880(%rdi)
	vmovups	%ymm0, 3832(%rdi)
	movl	$0, 3864(%rdi)
	movl	$0, 3888(%rdi)
	movq	$0, 3936(%rdi)
	movb	$0, 3944(%rdi)
	vmovups	%ymm0, 3896(%rdi)
	movl	$0, 3928(%rdi)
	movl	$0, 3952(%rdi)
	movq	$0, 4000(%rdi)
	movb	$0, 4008(%rdi)
	vmovups	%ymm0, 3960(%rdi)
	movl	$0, 3992(%rdi)
	movl	$0, 4016(%rdi)
	vmovups	%ymm0, 4052(%rdi)
	vmovups	%ymm0, 4024(%rdi)
	movq	$0, 4128(%rdi)
	movb	$0, 4136(%rdi)
	vmovups	%ymm0, 4088(%rdi)
	movl	$0, 4120(%rdi)
	movl	$0, 4144(%rdi)
	movq	$0, 4192(%rdi)
	movb	$0, 4200(%rdi)
	vmovups	%ymm0, 4152(%rdi)
	movl	$0, 4184(%rdi)
	movl	$0, 4208(%rdi)
	movq	$0, 4256(%rdi)
	movb	$0, 4264(%rdi)
	vmovups	%ymm0, 4216(%rdi)
	movl	$0, 4248(%rdi)
	movl	$0, 4272(%rdi)
	movq	$0, 4320(%rdi)
	movb	$0, 4328(%rdi)
	vmovups	%ymm0, 4280(%rdi)
	movl	$0, 4312(%rdi)
	movl	$0, 4336(%rdi)
	movq	$0, 4384(%rdi)
	movb	$0, 4392(%rdi)
	vmovups	%ymm0, 4344(%rdi)
	movl	$0, 4376(%rdi)
	movl	$0, 4400(%rdi)
	movq	$0, 4448(%rdi)
	movb	$0, 4456(%rdi)
	vmovups	%ymm0, 4408(%rdi)
	movl	$0, 4440(%rdi)
	movl	$0, 4464(%rdi)
	movq	$0, 4512(%rdi)
	movb	$0, 4520(%rdi)
	vmovups	%ymm0, 4472(%rdi)
	movl	$0, 4504(%rdi)
	movl	$0, 4528(%rdi)
	movq	$0, 4576(%rdi)
	movb	$0, 4584(%rdi)
	vmovups	%ymm0, 4536(%rdi)
	movl	$0, 4568(%rdi)
	movl	$0, 4592(%rdi)
	vmovups	%ymm0, 4628(%rdi)
	vmovups	%ymm0, 4600(%rdi)
	movq	$0, 4704(%rdi)
	movb	$0, 4712(%rdi)
	vmovups	%ymm0, 4664(%rdi)
	movl	$0, 4696(%rdi)
	movl	$0, 4720(%rdi)
	movq	$0, 4768(%rdi)
	movb	$0, 4776(%rdi)
	vmovups	%ymm0, 4728(%rdi)
	movl	$0, 4760(%rdi)
	movl	$0, 4784(%rdi)
	movq	$0, 4832(%rdi)
	movb	$0, 4840(%rdi)
	vmovups	%ymm0, 4792(%rdi)
	movl	$0, 4824(%rdi)
	movl	$0, 4848(%rdi)
	movq	$0, 4896(%rdi)
	movb	$0, 4904(%rdi)
	vmovups	%ymm0, 4856(%rdi)
	movl	$0, 4888(%rdi)
	movl	$0, 4912(%rdi)
	movq	$0, 4960(%rdi)
	movb	$0, 4968(%rdi)
	vmovups	%ymm0, 4920(%rdi)
	movl	$0, 4952(%rdi)
	movl	$0, 4976(%rdi)
	movq	$0, 5024(%rdi)
	movb	$0, 5032(%rdi)
	vmovups	%ymm0, 4984(%rdi)
	movl	$0, 5016(%rdi)
	movl	$0, 5040(%rdi)
	movq	$0, 5088(%rdi)
	movb	$0, 5096(%rdi)
	vmovups	%ymm0, 5048(%rdi)
	movl	$0, 5080(%rdi)
	movl	$0, 5104(%rdi)
	movq	$0, 5152(%rdi)
	movb	$0, 5160(%rdi)
	vmovups	%ymm0, 5112(%rdi)
	movl	$0, 5144(%rdi)
	movl	$0, 5168(%rdi)
	vmovups	%ymm0, 5204(%rdi)
	vmovups	%ymm0, 5176(%rdi)
	movq	$0, 5280(%rdi)
	movb	$0, 5288(%rdi)
	vmovups	%ymm0, 5240(%rdi)
	movl	$0, 5272(%rdi)
	movl	$0, 5296(%rdi)
	movq	$0, 5344(%rdi)
	movb	$0, 5352(%rdi)
	vmovups	%ymm0, 5304(%rdi)
	movl	$0, 5336(%rdi)
	movl	$0, 5360(%rdi)
	movq	$0, 5408(%rdi)
	movb	$0, 5416(%rdi)
	vmovups	%ymm0, 5368(%rdi)
	movl	$0, 5400(%rdi)
	movl	$0, 5424(%rdi)
	movq	$0, 5472(%rdi)
	movb	$0, 5480(%rdi)
	vmovups	%ymm0, 5432(%rdi)
	movl	$0, 5464(%rdi)
	movl	$0, 5488(%rdi)
	movq	$0, 5584(%rdi)
	movb	$0, 5592(%rdi)
	movl	$0, 5600(%rdi)
	movq	$0, 5648(%rdi)
	movb	$0, 5656(%rdi)
	vmovups	%ymm0, 5608(%rdi)
	movl	$0, 5640(%rdi)
	movl	$0, 5664(%rdi)
	movq	$0, 5712(%rdi)
	movb	$0, 5720(%rdi)
	vmovups	%ymm0, 5672(%rdi)
	movl	$0, 5704(%rdi)
	movl	$0, 5728(%rdi)
	movq	$0, 5776(%rdi)
	movb	$0, 5784(%rdi)
	vmovups	%ymm0, 5736(%rdi)
	movl	$0, 5768(%rdi)
	movl	$0, 5792(%rdi)
	movq	$0, 5888(%rdi)
	movb	$0, 5896(%rdi)
	movl	$0, 5904(%rdi)
	movq	$0, 5952(%rdi)
	movb	$0, 5960(%rdi)
	vmovups	%ymm0, 5912(%rdi)
	movl	$0, 5944(%rdi)
	movl	$0, 5968(%rdi)
	movq	$0, 6016(%rdi)
	movb	$0, 6024(%rdi)
	vmovups	%ymm0, 5976(%rdi)
	movl	$0, 6008(%rdi)
	movl	$0, 6032(%rdi)
	movq	$0, 6080(%rdi)
	movb	$0, 6088(%rdi)
	vmovups	%ymm0, 6040(%rdi)
	movl	$0, 6072(%rdi)
	movl	$0, 6096(%rdi)
	movq	$0, 6192(%rdi)
	movb	$0, 6200(%rdi)
	movl	$0, 6208(%rdi)
	vxorps	%xmm1, %xmm1, %xmm1
	vmovups	%xmm1, 6228(%rdi)
	vmovups	%xmm1, 6216(%rdi)
	movq	$0, 6288(%rdi)
	movb	$0, 6296(%rdi)
	vmovups	%ymm0, 6248(%rdi)
	movl	$0, 6280(%rdi)
	movl	$0, 6304(%rdi)
	vmovups	%xmm1, 6324(%rdi)
	vmovups	%xmm1, 6312(%rdi)
	movq	$0, 6384(%rdi)
	movb	$0, 6392(%rdi)
	vmovups	%ymm0, 6344(%rdi)
	movl	$0, 6376(%rdi)
	movl	$0, 6400(%rdi)
	vmovups	%xmm1, 6420(%rdi)
	vmovups	%xmm1, 6408(%rdi)
	movq	$0, 6480(%rdi)
	movb	$0, 6488(%rdi)
	vmovups	%ymm0, 6440(%rdi)
	movl	$0, 6472(%rdi)
	movl	$0, 6496(%rdi)
	vmovups	%xmm1, 6516(%rdi)
	vmovups	%xmm1, 6504(%rdi)
	movq	$0, 6576(%rdi)
	movb	$0, 6584(%rdi)
	vmovups	%ymm0, 6536(%rdi)
	movl	$0, 6568(%rdi)
	movl	$0, 6592(%rdi)
	vmovups	%xmm1, 6612(%rdi)
	vmovups	%xmm1, 6600(%rdi)
	movq	$0, 6672(%rdi)
	movb	$0, 6680(%rdi)
	vmovups	%ymm0, 6632(%rdi)
	movl	$0, 6664(%rdi)
	movl	$0, 6688(%rdi)
	vmovups	%xmm1, 6708(%rdi)
	vmovups	%xmm1, 6696(%rdi)
	movq	$0, 6768(%rdi)
	movb	$0, 6776(%rdi)
	vmovups	%ymm0, 6728(%rdi)
	movl	$0, 6760(%rdi)
	movl	$0, 6784(%rdi)
	vmovups	%xmm1, 6804(%rdi)
	vmovups	%xmm1, 6792(%rdi)
	movq	$0, 6864(%rdi)
	movb	$0, 6872(%rdi)
	vmovups	%ymm0, 6824(%rdi)
	movl	$0, 6856(%rdi)
	movl	$0, 6880(%rdi)
	vmovups	%xmm1, 6900(%rdi)
	vmovups	%xmm1, 6888(%rdi)
	movq	$0, 6960(%rdi)
	movb	$0, 6968(%rdi)
	vmovups	%ymm0, 6920(%rdi)
	movl	$0, 6952(%rdi)
	movl	$0, 6976(%rdi)
	vmovups	%xmm1, 6996(%rdi)
	vmovups	%xmm1, 6984(%rdi)
	movq	$0, 7056(%rdi)
	movb	$0, 7064(%rdi)
	vmovups	%ymm0, 7016(%rdi)
	movl	$0, 7048(%rdi)
	movl	$0, 7072(%rdi)
	vmovups	%xmm1, 7092(%rdi)
	vmovups	%xmm1, 7080(%rdi)
	movq	$0, 7152(%rdi)
	movb	$0, 7160(%rdi)
	vmovups	%ymm0, 7112(%rdi)
	movl	$0, 7144(%rdi)
	movl	$0, 7168(%rdi)
	vmovups	%xmm1, 7188(%rdi)
	vmovups	%xmm1, 7176(%rdi)
	movq	$0, 7248(%rdi)
	movb	$0, 7256(%rdi)
	vmovups	%ymm0, 7208(%rdi)
	movl	$0, 7240(%rdi)
	movl	$0, 7264(%rdi)
	vmovups	%xmm1, 7284(%rdi)
	vmovups	%xmm1, 7272(%rdi)
	movq	$0, 7344(%rdi)
	movb	$0, 7352(%rdi)
	vmovups	%ymm0, 7304(%rdi)
	movl	$0, 7336(%rdi)
	movl	$0, 7360(%rdi)
	vmovups	%xmm1, 7812(%rdi)
	vmovups	%xmm1, 7800(%rdi)
	vmovups	%xmm1, 7844(%rdi)
	vmovups	%xmm1, 7832(%rdi)
	vmovups	%xmm1, 7876(%rdi)
	vmovups	%xmm1, 7864(%rdi)
	vmovups	%xmm1, 7908(%rdi)
	vmovups	%xmm1, 7896(%rdi)
	vmovups	%xmm1, 7940(%rdi)
	vmovups	%xmm1, 7928(%rdi)
	vmovups	%xmm1, 7972(%rdi)
	vmovups	%xmm1, 7960(%rdi)
	vmovups	%xmm1, 8004(%rdi)
	vmovups	%xmm1, 7992(%rdi)
	vmovups	%xmm1, 8036(%rdi)
	vmovups	%xmm1, 8024(%rdi)
	vmovups	%xmm1, 8068(%rdi)
	vmovups	%xmm1, 8056(%rdi)
	vmovups	%xmm1, 8100(%rdi)
	vmovups	%xmm1, 8088(%rdi)
	vmovups	%xmm1, 8132(%rdi)
	vmovups	%xmm1, 8120(%rdi)
	leaq	9304(%rdi), %rax
	vmovups	%xmm1, 8164(%rdi)
	vmovups	%xmm1, 8152(%rdi)
	vmovups	%xmm1, 8196(%rdi)
	vmovups	%xmm1, 8184(%rdi)
	vmovups	%xmm1, 8228(%rdi)
	vmovups	%xmm1, 8216(%rdi)
	vmovups	%xmm1, 8260(%rdi)
	vmovups	%xmm1, 8248(%rdi)
	vmovups	%xmm1, 8292(%rdi)
	vmovups	%xmm1, 8280(%rdi)
	vmovups	%xmm1, 8324(%rdi)
	vmovups	%xmm1, 8312(%rdi)
	vmovups	%xmm1, 8356(%rdi)
	vmovups	%xmm1, 8344(%rdi)
	vmovups	%xmm1, 8388(%rdi)
	vmovups	%xmm1, 8376(%rdi)
	vmovups	%xmm1, 8420(%rdi)
	vmovups	%xmm1, 8408(%rdi)
	vmovups	%xmm1, 8452(%rdi)
	vmovups	%xmm1, 8440(%rdi)
	vmovups	%xmm1, 8484(%rdi)
	vmovups	%xmm1, 8472(%rdi)
	vmovups	%xmm1, 8516(%rdi)
	vmovups	%xmm1, 8504(%rdi)
	vmovups	%xmm1, 8548(%rdi)
	vmovups	%xmm1, 8536(%rdi)
	vmovups	%xmm1, 8580(%rdi)
	vmovups	%xmm1, 8568(%rdi)
	vmovups	%xmm1, 8612(%rdi)
	vmovups	%xmm1, 8600(%rdi)
	vmovups	%xmm1, 8644(%rdi)
	vmovups	%xmm1, 8632(%rdi)
	vmovups	%xmm1, 8676(%rdi)
	vmovups	%xmm1, 8664(%rdi)
	vmovups	%xmm1, 8708(%rdi)
	vmovups	%xmm1, 8696(%rdi)
	vmovups	%xmm1, 8740(%rdi)
	vmovups	%xmm1, 8728(%rdi)
	vmovups	%xmm1, 8772(%rdi)
	vmovups	%xmm1, 8760(%rdi)
	vmovups	%xmm1, 8804(%rdi)
	vmovups	%xmm1, 8792(%rdi)
	vmovups	%xmm1, 8836(%rdi)
	vmovups	%xmm1, 8824(%rdi)
	vmovups	%xmm1, 8868(%rdi)
	vmovups	%xmm1, 8856(%rdi)
	vmovups	%xmm1, 8900(%rdi)
	vmovups	%xmm1, 8888(%rdi)
	vmovups	%xmm1, 8932(%rdi)
	vmovups	%xmm1, 8920(%rdi)
	vmovups	%xmm1, 8964(%rdi)
	vmovups	%xmm1, 8952(%rdi)
	vmovups	%xmm1, 8996(%rdi)
	vmovups	%xmm1, 8984(%rdi)
	vmovups	%xmm1, 9028(%rdi)
	vmovups	%xmm1, 9016(%rdi)
	vmovups	%xmm1, 9060(%rdi)
	vmovups	%xmm1, 9048(%rdi)
	vmovups	%xmm1, 9092(%rdi)
	vmovups	%xmm1, 9080(%rdi)
	vmovups	%xmm1, 9124(%rdi)
	vmovups	%xmm1, 9112(%rdi)
	vmovups	%xmm1, 9156(%rdi)
	vmovups	%xmm1, 9144(%rdi)
	vmovups	%xmm1, 9188(%rdi)
	vmovups	%xmm1, 9176(%rdi)
	vmovups	%xmm1, 9220(%rdi)
	vmovups	%xmm1, 9208(%rdi)
	vmovups	%xmm1, 9252(%rdi)
	vmovups	%xmm1, 9240(%rdi)
	vmovups	%xmm1, 9284(%rdi)
	vmovups	%xmm1, 9272(%rdi)
	vmovups	%ymm0, 20(%rdi)
	vmovups	%ymm0, (%rdi)
	vmovups	%ymm0, 5548(%rdi)
	vmovups	%ymm0, 5528(%rdi)
	vmovups	%ymm0, 5496(%rdi)
	vmovups	%ymm0, 5852(%rdi)
	vmovups	%ymm0, 5832(%rdi)
	vmovups	%ymm0, 5800(%rdi)
	vmovups	%ymm0, 6156(%rdi)
	vmovups	%ymm0, 6136(%rdi)
	vmovups	%ymm0, 6104(%rdi)
	vmovups	%ymm0, 7764(%rdi)
	vmovups	%ymm0, 7752(%rdi)
	vmovups	%ymm0, 7720(%rdi)
	vmovups	%ymm0, 7688(%rdi)
	vmovups	%ymm0, 7656(%rdi)
	vmovups	%ymm0, 7624(%rdi)
	vmovups	%ymm0, 7592(%rdi)
	vmovups	%ymm0, 7560(%rdi)
	vmovups	%ymm0, 7528(%rdi)
	vmovups	%ymm0, 7496(%rdi)
	vmovups	%ymm0, 7464(%rdi)
	vmovups	%ymm0, 7432(%rdi)
	vmovups	%ymm0, 7400(%rdi)
	vmovups	%ymm0, 7368(%rdi)
	movl	$576, %edx                      # imm = 0x240
	movq	%rax, %rdi
	xorl	%esi, %esi
	vzeroupper
	jmp	memset@PLT                      # TAILCALL
.Lfunc_end17:
	.size	_ZN3fx23opt8OptModelC2Ev, .Lfunc_end17-_ZN3fx23opt8OptModelC2Ev
                                        # -- End function
	.section	.text._ZN3fx23opt18TransformerOptImpl10kimi_layerEi,"axG",@progbits,_ZN3fx23opt18TransformerOptImpl10kimi_layerEi,comdat
	.weak	_ZN3fx23opt18TransformerOptImpl10kimi_layerEi # -- Begin function _ZN3fx23opt18TransformerOptImpl10kimi_layerEi
	.p2align	4, 0x90
	.type	_ZN3fx23opt18TransformerOptImpl10kimi_layerEi,@function
_ZN3fx23opt18TransformerOptImpl10kimi_layerEi: # @_ZN3fx23opt18TransformerOptImpl10kimi_layerEi
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$840, %rsp                      # imm = 0x348
	movq	%rdi, %rbx
	movq	16(%rdi), %r14
	movslq	%esi, %rax
	movq	%rax, 112(%rsp)                 # 8-byte Spill
	leaq	(%rax,%rax,8), %rbp
	shlq	$6, %rbp
	vmovss	112(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 48(%rsp)
	vmovss	176(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 52(%rsp)
	vmovss	240(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 56(%rsp)
	leaq	60(%rsp), %rdx
	leaq	248(%r14,%rbp), %rax
	movq	%rax, 128(%rsp)                 # 8-byte Spill
	vmovss	304(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 60(%rsp)
	leaq	312(%r14,%rbp), %rax
	movq	%rax, 160(%rsp)                 # 8-byte Spill
	vmovss	368(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	vmovss	%xmm0, 64(%rsp)
	addq	$4736, %rdi                     # imm = 0x1280
	movq	%rdi, 120(%rsp)                 # 8-byte Spill
	leaq	5504(%rbx), %rsi
	leaq	7616(%rbx), %r15
	movl	$2, %ecx
	movq	%r15, %r8
	callq	_ZN3fx23opt23rms_norm_quant192_multiEPKfPfS2_iPh
	leaq	8064(%rbx), %rsi
	movq	%rsi, 104(%rsp)                 # 8-byte Spill
	leaq	8832(%rbx), %rdx
	movq	%rdx, 96(%rsp)                  # 8-byte Spill
	leaq	9600(%rbx), %rcx
	movq	%rcx, 88(%rsp)                  # 8-byte Spill
	movq	%rbx, %rdi
	callq	_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_
	leaq	(%r14,%rbp), %r12
	addq	$376, %r12                      # imm = 0x178
	vmovss	432(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	leaq	8000(%rbx), %r13
	movq	128(%rsp), %rdi                 # 8-byte Reload
	movq	%r15, %rsi
	movq	%r13, %rdx
	callq	_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh
	leaq	10368(%rbx), %rdx
	movq	%rdx, 80(%rsp)                  # 8-byte Spill
	movq	%r12, %rdi
	movq	%r13, %rsi
	callq	_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
	leaq	7808(%rbx), %rsi
	leaq	(%r14,%rbp), %r15
	addq	$440, %r15                      # imm = 0x1B8
	vmovss	496(%r14,%rbp), %xmm0           # xmm0 = mem[0],zero,zero,zero
	movq	160(%rsp), %rdi                 # 8-byte Reload
	movq	%r13, %rdx
	callq	_ZN3fx23opt16qgemv_quant_biasERKNS0_6QDenseEPKhfPh
	leaq	11136(%rbx), %r12
	movq	%r15, %rdi
	movq	%r13, %rsi
	movq	%r12, %rdx
	callq	_ZN3fx23opt9qgemv_f32ERKNS0_6QDenseEPKhPf
	movq	568(%r14,%rbp), %rax
	vmovaps	5504(%rbx), %ymm14
	vmovups	%ymm14, 128(%rsp)               # 32-byte Spill
	vmovaps	5536(%rbx), %ymm13
	vmovups	%ymm13, 160(%rsp)               # 32-byte Spill
	vmovaps	5568(%rbx), %ymm12
	vmovaps	5600(%rbx), %ymm15
	vmovaps	5632(%rbx), %ymm11
	vmovaps	5664(%rbx), %ymm10
	vmovaps	5696(%rbx), %ymm9
	vmovaps	5728(%rbx), %ymm8
	vmovaps	5760(%rbx), %ymm7
	vmovups	%ymm7, 512(%rsp)                # 32-byte Spill
	vmovaps	5792(%rbx), %ymm6
	vmovups	%ymm6, 544(%rsp)                # 32-byte Spill
	vmovaps	5824(%rbx), %ymm5
	vmovaps	5856(%rbx), %ymm4
	vmovaps	5888(%rbx), %ymm3
	vmovaps	5920(%rbx), %ymm2
	vxorps	%xmm1, %xmm1, %xmm1
	vmovups	(%rax), %ymm0
	vfmadd213ps	%ymm1, %ymm14, %ymm0    # ymm0 = (ymm14 * ymm0) + ymm1
	vfmadd231ps	32(%rax), %ymm13, %ymm0 # ymm0 = (ymm13 * mem) + ymm0
	vfmadd231ps	64(%rax), %ymm12, %ymm0 # ymm0 = (ymm12 * mem) + ymm0
	vmovaps	%ymm12, %ymm14
	vfmadd231ps	96(%rax), %ymm15, %ymm0 # ymm0 = (ymm15 * mem) + ymm0
	vfmadd231ps	128(%rax), %ymm11, %ymm0 # ymm0 = (ymm11 * mem) + ymm0
	vmovaps	%ymm11, %ymm13
	vmovups	%ymm11, 192(%rsp)               # 32-byte Spill
	vfmadd231ps	160(%rax), %ymm10, %ymm0 # ymm0 = (ymm10 * mem) + ymm0
	vmovaps	%ymm10, %ymm12
	vmovups	%ymm10, 224(%rsp)               # 32-byte Spill
	vfmadd231ps	192(%rax), %ymm9, %ymm0 # ymm0 = (ymm9 * mem) + ymm0
	vmovaps	%ymm9, %ymm10
	vmovups	%ymm9, 256(%rsp)                # 32-byte Spill
	vfmadd231ps	224(%rax), %ymm8, %ymm0 # ymm0 = (ymm8 * mem) + ymm0
	vmovaps	%ymm8, %ymm9
	vmovups	%ymm8, 288(%rsp)                # 32-byte Spill
	vfmadd231ps	256(%rax), %ymm7, %ymm0 # ymm0 = (ymm7 * mem) + ymm0
	vfmadd231ps	288(%rax), %ymm6, %ymm0 # ymm0 = (ymm6 * mem) + ymm0
	vfmadd231ps	320(%rax), %ymm5, %ymm0 # ymm0 = (ymm5 * mem) + ymm0
	vmovaps	%ymm5, %ymm8
	vmovups	%ymm5, 352(%rsp)                # 32-byte Spill
	vfmadd231ps	352(%rax), %ymm4, %ymm0 # ymm0 = (ymm4 * mem) + ymm0
	vmovups	%ymm4, 384(%rsp)                # 32-byte Spill
	vfmadd231ps	384(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	%ymm3, %ymm7
	vmovups	%ymm3, 416(%rsp)                # 32-byte Spill
	vfmadd231ps	416(%rax), %ymm2, %ymm0 # ymm0 = (ymm2 * mem) + ymm0
	vmovups	%ymm2, 448(%rsp)                # 32-byte Spill
	vmovaps	5952(%rbx), %ymm3
	vmovups	%ymm3, 608(%rsp)                # 32-byte Spill
	vfmadd231ps	448(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	5984(%rbx), %ymm3
	vmovups	%ymm3, 704(%rsp)                # 32-byte Spill
	vfmadd231ps	480(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6016(%rbx), %ymm3
	vmovups	%ymm3, 672(%rsp)                # 32-byte Spill
	vfmadd231ps	512(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6048(%rbx), %ymm3
	vmovups	%ymm3, 640(%rsp)                # 32-byte Spill
	vfmadd231ps	544(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6080(%rbx), %ymm3
	vmovups	%ymm3, 576(%rsp)                # 32-byte Spill
	vfmadd231ps	576(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6112(%rbx), %ymm3
	vmovups	%ymm3, 800(%rsp)                # 32-byte Spill
	vfmadd231ps	608(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6144(%rbx), %ymm3
	vfmadd231ps	640(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	%ymm3, %ymm6
	vmovups	%ymm3, 320(%rsp)                # 32-byte Spill
	vmovaps	6176(%rbx), %ymm3
	vmovups	%ymm3, 768(%rsp)                # 32-byte Spill
	vfmadd231ps	672(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6208(%rbx), %ymm3
	vmovups	%ymm3, 736(%rsp)                # 32-byte Spill
	vfmadd231ps	704(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vmovaps	6240(%rbx), %ymm3
	vmovups	%ymm3, 480(%rsp)                # 32-byte Spill
	vfmadd231ps	736(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vextractf128	$1, %ymm0, %xmm11
	vaddps	%xmm0, %xmm11, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm11        # xmm11 = xmm0[1,0]
	vaddps	%xmm0, %xmm11, %xmm0
	vmovshdup	%xmm0, %xmm11           # xmm11 = xmm0[1,1,3,3]
	vaddss	%xmm0, %xmm11, %xmm0
	vmovss	%xmm0, 12672(%rbx)
	vmovups	768(%rax), %ymm0
	vfmadd132ps	128(%rsp), %ymm1, %ymm0 # 32-byte Folded Reload
                                        # ymm0 = (ymm0 * mem) + ymm1
	vmovups	160(%rsp), %ymm3                # 32-byte Reload
	vfmadd231ps	800(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vfmadd231ps	832(%rax), %ymm14, %ymm0 # ymm0 = (ymm14 * mem) + ymm0
	vfmadd231ps	864(%rax), %ymm15, %ymm0 # ymm0 = (ymm15 * mem) + ymm0
	vfmadd231ps	896(%rax), %ymm13, %ymm0 # ymm0 = (ymm13 * mem) + ymm0
	vfmadd231ps	928(%rax), %ymm12, %ymm0 # ymm0 = (ymm12 * mem) + ymm0
	vfmadd231ps	960(%rax), %ymm10, %ymm0 # ymm0 = (ymm10 * mem) + ymm0
	vfmadd231ps	992(%rax), %ymm9, %ymm0 # ymm0 = (ymm9 * mem) + ymm0
	vmovups	512(%rsp), %ymm5                # 32-byte Reload
	vfmadd231ps	1024(%rax), %ymm5, %ymm0 # ymm0 = (ymm5 * mem) + ymm0
	vmovups	544(%rsp), %ymm3                # 32-byte Reload
	vfmadd231ps	1056(%rax), %ymm3, %ymm0 # ymm0 = (ymm3 * mem) + ymm0
	vfmadd231ps	1088(%rax), %ymm8, %ymm0 # ymm0 = (ymm8 * mem) + ymm0
	vfmadd231ps	1120(%rax), %ymm4, %ymm0 # ymm0 = (ymm4 * mem) + ymm0
	vfmadd231ps	1152(%rax), %ymm7, %ymm0 # ymm0 = (ymm7 * mem) + ymm0
	vfmadd231ps	1184(%rax), %ymm2, %ymm0 # ymm0 = (ymm2 * mem) + ymm0
	vmovups	608(%rsp), %ymm10               # 32-byte Reload
	vfmadd231ps	1216(%rax), %ymm10, %ymm0 # ymm0 = (ymm10 * mem) + ymm0
	vmovups	704(%rsp), %ymm7                # 32-byte Reload
	vfmadd231ps	1248(%rax), %ymm7, %ymm0 # ymm0 = (ymm7 * mem) + ymm0
	vmovups	672(%rsp), %ymm8                # 32-byte Reload
	vfmadd231ps	1280(%rax), %ymm8, %ymm0 # ymm0 = (ymm8 * mem) + ymm0
	vmovups	640(%rsp), %ymm9                # 32-byte Reload
	vfmadd231ps	1312(%rax), %ymm9, %ymm0 # ymm0 = (ymm9 * mem) + ymm0
	vmovups	576(%rsp), %ymm12               # 32-byte Reload
	vfmadd231ps	1344(%rax), %ymm12, %ymm0 # ymm0 = (ymm12 * mem) + ymm0
	vmovups	800(%rsp), %ymm2                # 32-byte Reload
	vfmadd231ps	1376(%rax), %ymm2, %ymm0 # ymm0 = (ymm2 * mem) + ymm0
	vfmadd231ps	1408(%rax), %ymm6, %ymm0 # ymm0 = (ymm6 * mem) + ymm0
	vmovups	768(%rsp), %ymm4                # 32-byte Reload
	vfmadd231ps	1440(%rax), %ymm4, %ymm0 # ymm0 = (ymm4 * mem) + ymm0
	vmovups	736(%rsp), %ymm6                # 32-byte Reload
	vfmadd231ps	1472(%rax), %ymm6, %ymm0 # ymm0 = (ymm6 * mem) + ymm0
	vmovups	480(%rsp), %ymm13               # 32-byte Reload
	vfmadd231ps	1504(%rax), %ymm13, %ymm0 # ymm0 = (ymm13 * mem) + ymm0
	vextractf128	$1, %ymm0, %xmm11
	vaddps	%xmm0, %xmm11, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm11        # xmm11 = xmm0[1,0]
	vaddps	%xmm0, %xmm11, %xmm0
	vmovshdup	%xmm0, %xmm11           # xmm11 = xmm0[1,1,3,3]
	vaddss	%xmm0, %xmm11, %xmm0
	vmovss	%xmm0, 12676(%rbx)
	vmovups	128(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1536(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	160(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1568(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vfmadd231ps	1600(%rax), %ymm14, %ymm1 # ymm1 = (ymm14 * mem) + ymm1
	vfmadd231ps	1632(%rax), %ymm15, %ymm1 # ymm1 = (ymm15 * mem) + ymm1
	vmovups	192(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1664(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	224(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1696(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	256(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1728(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	288(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1760(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vfmadd231ps	1792(%rax), %ymm5, %ymm1 # ymm1 = (ymm5 * mem) + ymm1
	vfmadd231ps	1824(%rax), %ymm3, %ymm1 # ymm1 = (ymm3 * mem) + ymm1
	vmovups	352(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1856(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	384(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1888(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	416(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1920(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vmovups	448(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	1952(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vfmadd231ps	1984(%rax), %ymm10, %ymm1 # ymm1 = (ymm10 * mem) + ymm1
	vfmadd231ps	2016(%rax), %ymm7, %ymm1 # ymm1 = (ymm7 * mem) + ymm1
	vfmadd231ps	2048(%rax), %ymm8, %ymm1 # ymm1 = (ymm8 * mem) + ymm1
	vfmadd231ps	2080(%rax), %ymm9, %ymm1 # ymm1 = (ymm9 * mem) + ymm1
	vfmadd231ps	2112(%rax), %ymm12, %ymm1 # ymm1 = (ymm12 * mem) + ymm1
	vfmadd231ps	2144(%rax), %ymm2, %ymm1 # ymm1 = (ymm2 * mem) + ymm1
	vmovups	320(%rsp), %ymm0                # 32-byte Reload
	vfmadd231ps	2176(%rax), %ymm0, %ymm1 # ymm1 = (ymm0 * mem) + ymm1
	vfmadd231ps	2208(%rax), %ymm4, %ymm1 # ymm1 = (ymm4 * mem) + ymm1
	vfmadd231ps	2240(%rax), %ymm6, %ymm1 # ymm1 = (ymm6 * mem) + ymm1
	vfmadd231ps	2272(%rax), %ymm13, %ymm1 # ymm1 = (ymm13 * mem) + ymm1
	vextractf128	$1, %ymm1, %xmm0
	vaddps	%xmm0, %xmm1, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	vmovss	%xmm0, 12680(%rbx)
	leaq	12672(%rbx), %rax
	leaq	(%r14,%rbp), %rdi
	addq	$576, %rdi                      # imm = 0x240
	imulq	$58432, 112(%rsp), %rsi         # 8-byte Folded Reload
                                        # imm = 0xE440
	addq	48(%rbx), %rsi
	leaq	11904(%rbx), %r15
	vxorps	%xmm0, %xmm0, %xmm0
	vmovups	%xmm0, 24(%rsp)
	movq	%r15, 16(%rsp)
	movq	%rax, 8(%rsp)
	movq	%r12, (%rsp)
	movq	104(%rsp), %rdx                 # 8-byte Reload
	movq	96(%rsp), %rcx                  # 8-byte Reload
	movq	88(%rsp), %r8                   # 8-byte Reload
	movq	80(%rsp), %r9                   # 8-byte Reload
	vzeroupper
	callq	_ZN3fx23opt14kda_layer_stepERKNS0_10KdaWeightsERNS0_8KdaStateEPKfS7_S7_S7_S7_S7_PfPNS0_8KdaDebugEPNS0_10KdaProfileE
	movq	16(%rbx), %rax
	movslq	17152(%rbx), %rcx
	vmovss	9832(%rax,%rcx,4), %xmm0        # xmm0 = mem[0],zero,zero,zero
	leaq	21824(%rbx), %r14
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt12quant192_i16EPKffPs
	movq	16(%rbx), %rax
	movslq	17152(%rbx), %rcx
	movq	9736(%rax,%rcx,8), %rsi
	movq	9544(%rax,%rcx,8), %rdi
	movq	9640(%rax,%rcx,8), %rdx
	movq	%r14, %rcx
	movq	120(%rsp), %r8                  # 8-byte Reload
	callq	_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf
	addq	$840, %rsp                      # imm = 0x348
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end18:
	.size	_ZN3fx23opt18TransformerOptImpl10kimi_layerEi, .Lfunc_end18-_ZN3fx23opt18TransformerOptImpl10kimi_layerEi
                                        # -- End function
	.section	.text._ZN3fx23opt18TransformerOptImpl9van_layerEi,"axG",@progbits,_ZN3fx23opt18TransformerOptImpl9van_layerEi,comdat
	.weak	_ZN3fx23opt18TransformerOptImpl9van_layerEi # -- Begin function _ZN3fx23opt18TransformerOptImpl9van_layerEi
	.p2align	4, 0x90
	.type	_ZN3fx23opt18TransformerOptImpl9van_layerEi,@function
_ZN3fx23opt18TransformerOptImpl9van_layerEi: # @_ZN3fx23opt18TransformerOptImpl9van_layerEi
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$360, %rsp                      # imm = 0x168
	movl	%esi, %ebp
	movq	%rdi, %r14
	movq	16(%rdi), %rax
	movq	%rax, 352(%rsp)                 # 8-byte Spill
	leaq	4736(%rdi), %r15
	leaq	5504(%rdi), %rsi
	movq	%r15, %rdi
	callq	_ZN3fx23opt11rms_norm192EPKfPf
	leaq	12736(%r14), %r13
	leaq	13504(%r14), %rbx
	leaq	14272(%r14), %rcx
	movq	%r14, %rdi
	movq	%r13, %rsi
	movq	%rbx, %rdx
	movq	%rcx, 24(%rsp)                  # 8-byte Spill
	callq	_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_
	movq	%r13, %rdi
	movq	%r13, %rsi
	callq	_ZN3fx23opt10rms_norm64EPKfPf
	leaq	12992(%r14), %rdi
	movq	%rdi, 328(%rsp)                 # 8-byte Spill
	movq	%rdi, %rsi
	callq	_ZN3fx23opt10rms_norm64EPKfPf
	leaq	13248(%r14), %rdi
	movq	%rdi, 344(%rsp)                 # 8-byte Spill
	movq	%rdi, %rsi
	callq	_ZN3fx23opt10rms_norm64EPKfPf
	movq	%rbx, %rdi
	movq	%rbx, %rsi
	callq	_ZN3fx23opt10rms_norm64EPKfPf
	leaq	13760(%r14), %rdi
	movq	%rdi, 320(%rsp)                 # 8-byte Spill
	movq	%rdi, %rsi
	callq	_ZN3fx23opt10rms_norm64EPKfPf
	leaq	14016(%r14), %rdi
	movq	%rdi, 336(%rsp)                 # 8-byte Spill
	movq	%rdi, %rsi
	callq	_ZN3fx23opt10rms_norm64EPKfPf
	movslq	%ebp, %rax
	movq	%rax, 48(%rsp)                  # 8-byte Spill
	movq	72(%r14), %r12
	addq	80(%r14), %r12
	cmpq	$131071, %r12                   # imm = 0x1FFFF
	movq	%r15, 40(%rsp)                  # 8-byte Spill
	jg	.LBB19_2
# %bb.1:
	movq	16(%r14), %rax
	shlq	$7, %r12
	movq	7592(%rax), %rbp
	addq	%r12, %rbp
	addq	7616(%rax), %r12
	jmp	.LBB19_3
.LBB19_2:
	vcvtsi2ss	%r12, %xmm0, %xmm0
	vmovss	%xmm0, 16(%rsp)                 # 4-byte Spill
	movq	16(%r14), %r15
	vmulss	7640(%r15), %xmm0, %xmm0
	leaq	308(%rsp), %rdi
	leaq	304(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	304(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	308(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	leaq	57216(%r14), %rbp
	vmovss	%xmm1, 57216(%r14)
	leaq	57344(%r14), %r12
	vmovss	%xmm0, 57344(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7644(%r15), %xmm0, %xmm0
	leaq	300(%rsp), %rdi
	leaq	296(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	296(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	300(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57220(%r14)
	vmovss	%xmm0, 57348(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7648(%r15), %xmm0, %xmm0
	leaq	292(%rsp), %rdi
	leaq	288(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	288(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	292(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57224(%r14)
	vmovss	%xmm0, 57352(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7652(%r15), %xmm0, %xmm0
	leaq	284(%rsp), %rdi
	leaq	280(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	280(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	284(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57228(%r14)
	vmovss	%xmm0, 57356(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7656(%r15), %xmm0, %xmm0
	leaq	276(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	272(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	276(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57232(%r14)
	vmovss	%xmm0, 57360(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7660(%r15), %xmm0, %xmm0
	leaq	268(%rsp), %rdi
	leaq	264(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	264(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	268(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57236(%r14)
	vmovss	%xmm0, 57364(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7664(%r15), %xmm0, %xmm0
	leaq	260(%rsp), %rdi
	leaq	256(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	256(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	260(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57240(%r14)
	vmovss	%xmm0, 57368(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7668(%r15), %xmm0, %xmm0
	leaq	252(%rsp), %rdi
	leaq	248(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	248(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	252(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57244(%r14)
	vmovss	%xmm0, 57372(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7672(%r15), %xmm0, %xmm0
	leaq	244(%rsp), %rdi
	leaq	240(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	240(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	244(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57248(%r14)
	vmovss	%xmm0, 57376(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7676(%r15), %xmm0, %xmm0
	leaq	236(%rsp), %rdi
	leaq	232(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	232(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	236(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57252(%r14)
	vmovss	%xmm0, 57380(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7680(%r15), %xmm0, %xmm0
	leaq	228(%rsp), %rdi
	leaq	224(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	224(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	228(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57256(%r14)
	vmovss	%xmm0, 57384(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7684(%r15), %xmm0, %xmm0
	leaq	220(%rsp), %rdi
	leaq	216(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	216(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	220(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57260(%r14)
	vmovss	%xmm0, 57388(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7688(%r15), %xmm0, %xmm0
	leaq	212(%rsp), %rdi
	leaq	208(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	208(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	212(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57264(%r14)
	vmovss	%xmm0, 57392(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7692(%r15), %xmm0, %xmm0
	leaq	204(%rsp), %rdi
	leaq	200(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	200(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	204(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57268(%r14)
	vmovss	%xmm0, 57396(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7696(%r15), %xmm0, %xmm0
	leaq	196(%rsp), %rdi
	leaq	192(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	192(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	196(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57272(%r14)
	vmovss	%xmm0, 57400(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7700(%r15), %xmm0, %xmm0
	leaq	188(%rsp), %rdi
	leaq	184(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	184(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	188(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57276(%r14)
	vmovss	%xmm0, 57404(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7704(%r15), %xmm0, %xmm0
	leaq	180(%rsp), %rdi
	leaq	176(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	176(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	180(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57280(%r14)
	vmovss	%xmm0, 57408(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7708(%r15), %xmm0, %xmm0
	leaq	172(%rsp), %rdi
	leaq	168(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	168(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	172(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57284(%r14)
	vmovss	%xmm0, 57412(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7712(%r15), %xmm0, %xmm0
	leaq	164(%rsp), %rdi
	leaq	160(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	160(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	164(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57288(%r14)
	vmovss	%xmm0, 57416(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7716(%r15), %xmm0, %xmm0
	leaq	156(%rsp), %rdi
	leaq	152(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	152(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	156(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57292(%r14)
	vmovss	%xmm0, 57420(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7720(%r15), %xmm0, %xmm0
	leaq	148(%rsp), %rdi
	leaq	144(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	144(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	148(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57296(%r14)
	vmovss	%xmm0, 57424(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7724(%r15), %xmm0, %xmm0
	leaq	140(%rsp), %rdi
	leaq	136(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	136(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	140(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57300(%r14)
	vmovss	%xmm0, 57428(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7728(%r15), %xmm0, %xmm0
	leaq	132(%rsp), %rdi
	leaq	128(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	128(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	132(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57304(%r14)
	vmovss	%xmm0, 57432(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7732(%r15), %xmm0, %xmm0
	leaq	124(%rsp), %rdi
	leaq	120(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	120(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	124(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57308(%r14)
	vmovss	%xmm0, 57436(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7736(%r15), %xmm0, %xmm0
	leaq	116(%rsp), %rdi
	leaq	112(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	112(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	116(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57312(%r14)
	vmovss	%xmm0, 57440(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7740(%r15), %xmm0, %xmm0
	leaq	108(%rsp), %rdi
	leaq	104(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	104(%rsp), %xmm0                # xmm0 = mem[0],zero,zero,zero
	vmovss	108(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57316(%r14)
	vmovss	%xmm0, 57444(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7744(%r15), %xmm0, %xmm0
	leaq	100(%rsp), %rdi
	leaq	96(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	96(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	vmovss	100(%rsp), %xmm1                # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57320(%r14)
	vmovss	%xmm0, 57448(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7748(%r15), %xmm0, %xmm0
	leaq	92(%rsp), %rdi
	leaq	88(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	88(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	vmovss	92(%rsp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57324(%r14)
	vmovss	%xmm0, 57452(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7752(%r15), %xmm0, %xmm0
	leaq	84(%rsp), %rdi
	leaq	80(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	80(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	vmovss	84(%rsp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57328(%r14)
	vmovss	%xmm0, 57456(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7756(%r15), %xmm0, %xmm0
	leaq	76(%rsp), %rdi
	leaq	72(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	72(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	vmovss	76(%rsp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57332(%r14)
	vmovss	%xmm0, 57460(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7760(%r15), %xmm0, %xmm0
	leaq	68(%rsp), %rdi
	leaq	64(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	64(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	vmovss	68(%rsp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57336(%r14)
	vmovss	%xmm0, 57464(%r14)
	vmovss	16(%rsp), %xmm0                 # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	vmulss	7764(%r15), %xmm0, %xmm0
	leaq	60(%rsp), %rdi
	leaq	56(%rsp), %rsi
	callq	sincosf@PLT
	vmovss	56(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	vmovss	60(%rsp), %xmm1                 # xmm1 = mem[0],zero,zero,zero
	vmovss	%xmm1, 57340(%r14)
	vmovss	%xmm0, 57468(%r14)
.LBB19_3:
	movq	%r13, %rdi
	movq	%rbp, %rsi
	movq	%r12, %rdx
	callq	_ZN3fx23opt14rope_apply_192EPfPKfS3_
	movq	%rbx, %rdi
	movq	%rbp, %rsi
	movq	%r12, %rdx
	callq	_ZN3fx23opt14rope_apply_192EPfPKfS3_
	leaq	15808(%r14), %rsi
	leaq	16000(%r14), %r15
	movq	%r13, %rdi
	leaq	16192(%r14), %r13
	imulq	$304, 48(%rsp), %r12            # 8-byte Folded Reload
                                        # imm = 0x130
	movq	352(%rsp), %rbp                 # 8-byte Reload
	vmovss	5496(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	%rsi, 16(%rsp)                  # 8-byte Spill
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	vmovss	5508(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	%rbx, %rdi
	movq	%r15, 312(%rsp)                 # 8-byte Spill
	movq	%r15, %rsi
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	leaq	(%r12,%rbp), %rax
	addq	$5520, %rax                     # imm = 0x1590
	movq	%rax, 32(%rsp)                  # 8-byte Spill
	vmovss	5520(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	24(%rsp), %rdi                  # 8-byte Reload
	movq	%r13, 24(%rsp)                  # 8-byte Spill
	movq	%r13, %rsi
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	vmovss	5500(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	leaq	15872(%r14), %rsi
	movq	328(%rsp), %rdi                 # 8-byte Reload
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	vmovss	5512(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	leaq	16064(%r14), %rsi
	movq	320(%rsp), %rdi                 # 8-byte Reload
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	leaq	14528(%r14), %rdi
	vmovss	5524(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	leaq	16256(%r14), %rsi
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	vmovss	5504(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	leaq	15936(%r14), %rsi
	movq	344(%rsp), %rdi                 # 8-byte Reload
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	vmovss	5516(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	leaq	16128(%r14), %rsi
	movq	336(%rsp), %rdi                 # 8-byte Reload
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	leaq	14784(%r14), %rdi
	vmovss	5528(%rbp,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	leaq	16320(%r14), %rsi
	callq	_ZN3fx23opt10quant64_i8EPKffPa
	movq	72(%r14), %rbx
	leal	1023(%rbx), %eax
	testq	%rbx, %rbx
	cmovnsl	%ebx, %eax
	andl	$-1024, %eax                    # imm = 0xFC00
	movl	%ebx, %esi
	subl	%eax, %esi
	leaq	1(%rbx), %r15
	cmpl	$0, 24(%r14)
	leaq	5532(%rbp,%r12), %r13
	je	.LBB19_4
# %bb.7:
	movq	48(%rsp), %rax                  # 8-byte Reload
	shlq	$17, %rax
	leaq	(%rax,%rax,2), %r12
	movq	64(%r14), %rdi
	addq	%r12, %rdi
	movq	312(%rsp), %rdx                 # 8-byte Reload
	movq	24(%rsp), %rcx                  # 8-byte Reload
	callq	_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_
	addq	64(%r14), %r12
	cmpq	$1022, %rbx                     # imm = 0x3FE
	jg	.LBB19_9
# %bb.8:
	leaq	15040(%r14), %r9
	movq	$0, (%rsp)
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%r12, %rdi
	movq	16(%rsp), %rsi                  # 8-byte Reload
	movq	%r13, %rdx
	movq	32(%rsp), %rcx                  # 8-byte Reload
	movl	%r15d, %r8d
	callq	_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi
	jmp	.LBB19_10
.LBB19_4:
	movq	%r15, %rbp
	imulq	$983040, 48(%rsp), %r12         # 8-byte Folded Reload
                                        # imm = 0xF0000
	movq	56(%r14), %rdi
	addq	%r12, %rdi
	movq	312(%rsp), %rdx                 # 8-byte Reload
	movq	24(%rsp), %rcx                  # 8-byte Reload
	callq	_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_
	addq	56(%r14), %r12
	cmpq	$1022, %rbx                     # imm = 0x3FE
	movq	40(%rsp), %r15                  # 8-byte Reload
	movq	16(%rsp), %rsi                  # 8-byte Reload
	movq	32(%rsp), %rcx                  # 8-byte Reload
	jg	.LBB19_6
# %bb.5:
	leaq	15040(%r14), %r9
	movq	$0, (%rsp)
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%r12, %rdi
	movq	%r13, %rdx
	movl	%ebp, %r8d
	callq	_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi
	jmp	.LBB19_11
.LBB19_9:
	leaq	15040(%r14), %r8
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%r12, %rdi
	movq	16(%rsp), %rsi                  # 8-byte Reload
	movq	%r13, %rdx
	movq	32(%rsp), %rcx                  # 8-byte Reload
	xorl	%r9d, %r9d
	callq	_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi
.LBB19_10:
	movq	40(%rsp), %r15                  # 8-byte Reload
	jmp	.LBB19_11
.LBB19_6:
	leaq	15040(%r14), %r8
	vxorps	%xmm0, %xmm0, %xmm0
	movq	%r12, %rdi
	movq	%r13, %rdx
	xorl	%r9d, %r9d
	callq	_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi
.LBB19_11:
	leaq	15040(%r14), %rdi
	movq	16(%r14), %rax
	movslq	17152(%r14), %rcx
	vmovss	9832(%rax,%rcx,4), %xmm0        # xmm0 = mem[0],zero,zero,zero
	leaq	21824(%r14), %rbx
	movq	%rbx, %rsi
	callq	_ZN3fx23opt12quant192_i16EPKffPs
	movq	16(%r14), %rax
	movslq	17152(%r14), %rcx
	movq	9736(%rax,%rcx,8), %rsi
	movq	9544(%rax,%rcx,8), %rdi
	movq	9640(%rax,%rcx,8), %rdx
	movq	%rbx, %rcx
	movq	%r15, %r8
	addq	$360, %rsp                      # imm = 0x168
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	jmp	_ZN3fx23opt11gemv16p_addEPKhPKfPKiPKsPf # TAILCALL
.Lfunc_end19:
	.size	_ZN3fx23opt18TransformerOptImpl9van_layerEi, .Lfunc_end19-_ZN3fx23opt18TransformerOptImpl9van_layerEi
                                        # -- End function
	.section	.text._ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_,"axG",@progbits,_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_,comdat
	.weak	_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_ # -- Begin function _ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_
	.p2align	4, 0x90
	.type	_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_,@function
_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_: # @_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_
# %bb.0:
	pushq	%rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	subq	$24, %rsp
	movq	%rcx, 16(%rsp)                  # 8-byte Spill
	movq	%rdx, 8(%rsp)                   # 8-byte Spill
	movq	%rsi, %rbp
	movq	%rdi, %r12
	leaq	5504(%rdi), %r15
	leaq	21824(%rdi), %r14
	movq	16(%rdi), %rbx
	movslq	17152(%rdi), %rax
	leaq	(%rax,%rax,2), %r13
	shlq	$5, %r13
	vmovss	8176(%rbx,%r13), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt12quant192_i16EPKffPs
	movq	8168(%rbx,%r13), %rsi
	movq	8152(%rbx,%r13), %rdi
	movq	8160(%rbx,%r13), %rdx
	movq	%r14, %rcx
	movl	$192, %r8d
	movq	%rbp, %r9
	callq	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
	movq	16(%r12), %rbx
	movslq	17152(%r12), %rax
	leaq	(%rax,%rax,2), %r13
	shlq	$5, %r13
	vmovss	8208(%rbx,%r13), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt12quant192_i16EPKffPs
	movq	8200(%rbx,%r13), %rsi
	movq	8184(%rbx,%r13), %rdi
	movq	8192(%rbx,%r13), %rdx
	movq	%r14, %rcx
	movl	$192, %r8d
	movq	8(%rsp), %r9                    # 8-byte Reload
	callq	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf
	movq	16(%r12), %rbx
	movslq	17152(%r12), %rax
	leaq	(%rax,%rax,2), %r12
	shlq	$5, %r12
	vmovss	8240(%rbx,%r12), %xmm0          # xmm0 = mem[0],zero,zero,zero
	movq	%r15, %rdi
	movq	%r14, %rsi
	callq	_ZN3fx23opt12quant192_i16EPKffPs
	movq	8232(%rbx,%r12), %rsi
	movq	8216(%rbx,%r12), %rdi
	movq	8224(%rbx,%r12), %rdx
	movq	%r14, %rcx
	movl	$192, %r8d
	movq	16(%rsp), %r9                   # 8-byte Reload
	addq	$24, %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	jmp	_ZN3fx23opt11gemv16p_setEPKhPKfPKiPKsiPf # TAILCALL
.Lfunc_end20:
	.size	_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_, .Lfunc_end20-_ZN3fx23opt18TransformerOptImpl5qkv16EPfS2_S2_
                                        # -- End function
	.type	.Lstr,@object                   # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"prof: not compiled in (build with -DFX2_PROF)"
	.size	.Lstr, 46

	.globl	_ZN3fx23opt14TransformerOptC1EPKcNS0_8AttnKindE
	.type	_ZN3fx23opt14TransformerOptC1EPKcNS0_8AttnKindE,@function
.set _ZN3fx23opt14TransformerOptC1EPKcNS0_8AttnKindE, _ZN3fx23opt14TransformerOptC2EPKcNS0_8AttnKindE
	.globl	_ZN3fx23opt14TransformerOptC1ERKS1_NS1_12ShareWeightsE
	.type	_ZN3fx23opt14TransformerOptC1ERKS1_NS1_12ShareWeightsE,@function
.set _ZN3fx23opt14TransformerOptC1ERKS1_NS1_12ShareWeightsE, _ZN3fx23opt14TransformerOptC2ERKS1_NS1_12ShareWeightsE
	.globl	_ZN3fx23opt14TransformerOptD1Ev
	.type	_ZN3fx23opt14TransformerOptD1Ev,@function
.set _ZN3fx23opt14TransformerOptD1Ev, _ZN3fx23opt14TransformerOptD2Ev
	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
