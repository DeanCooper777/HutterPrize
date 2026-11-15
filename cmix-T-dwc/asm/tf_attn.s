	.text
	.file	"attn.cpp"
	.section	.text._ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_,"ax",@progbits
	.globl	_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_ # -- Begin function _ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_
	.p2align	4, 0x90
	.type	_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_,@function
_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_: # @_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	movl	%esi, %eax
	sarl	$4, %eax
	movslq	%eax, %r8
	movslq	%esi, %rax
	andl	$15, %esi
	leaq	(%rdi,%rsi,2), %rsi
	shlq	$10, %r8
	movzwl	(%rdx), %r9d
	movw	%r9w, (%r8,%rsi)
	movzwl	2(%rdx), %r9d
	movw	%r9w, 32(%r8,%rsi)
	movzwl	4(%rdx), %r9d
	movw	%r9w, 64(%r8,%rsi)
	movzwl	6(%rdx), %r9d
	movw	%r9w, 96(%r8,%rsi)
	movzwl	8(%rdx), %r9d
	movw	%r9w, 128(%r8,%rsi)
	movzwl	10(%rdx), %r9d
	movw	%r9w, 160(%r8,%rsi)
	movzwl	12(%rdx), %r9d
	movw	%r9w, 192(%r8,%rsi)
	movzwl	14(%rdx), %r9d
	movw	%r9w, 224(%r8,%rsi)
	movzwl	16(%rdx), %r9d
	movw	%r9w, 256(%r8,%rsi)
	movzwl	18(%rdx), %r9d
	movw	%r9w, 288(%r8,%rsi)
	movzwl	20(%rdx), %r9d
	movw	%r9w, 320(%r8,%rsi)
	movzwl	22(%rdx), %r9d
	movw	%r9w, 352(%r8,%rsi)
	movzwl	24(%rdx), %r9d
	movw	%r9w, 384(%r8,%rsi)
	movzwl	26(%rdx), %r9d
	movw	%r9w, 416(%r8,%rsi)
	movzwl	28(%rdx), %r9d
	movw	%r9w, 448(%r8,%rsi)
	movzwl	30(%rdx), %r9d
	movw	%r9w, 480(%r8,%rsi)
	movzwl	32(%rdx), %r9d
	movw	%r9w, 512(%r8,%rsi)
	movzwl	34(%rdx), %r9d
	movw	%r9w, 544(%r8,%rsi)
	movzwl	36(%rdx), %r9d
	movw	%r9w, 576(%r8,%rsi)
	movzwl	38(%rdx), %r9d
	movw	%r9w, 608(%r8,%rsi)
	movzwl	40(%rdx), %r9d
	movw	%r9w, 640(%r8,%rsi)
	movzwl	42(%rdx), %r9d
	movw	%r9w, 672(%r8,%rsi)
	movzwl	44(%rdx), %r9d
	movw	%r9w, 704(%r8,%rsi)
	movzwl	46(%rdx), %r9d
	movw	%r9w, 736(%r8,%rsi)
	movzwl	48(%rdx), %r9d
	movw	%r9w, 768(%r8,%rsi)
	movzwl	50(%rdx), %r9d
	movw	%r9w, 800(%r8,%rsi)
	movzwl	52(%rdx), %r9d
	movw	%r9w, 832(%r8,%rsi)
	movzwl	54(%rdx), %r9d
	movw	%r9w, 864(%r8,%rsi)
	movzwl	56(%rdx), %r9d
	movw	%r9w, 896(%r8,%rsi)
	movzwl	58(%rdx), %r9d
	movw	%r9w, 928(%r8,%rsi)
	movzwl	60(%rdx), %r9d
	movw	%r9w, 960(%r8,%rsi)
	movzwl	62(%rdx), %r9d
	movw	%r9w, 992(%r8,%rsi)
	shlq	$6, %rax
	vmovups	(%rcx), %ymm0
	vmovups	32(%rcx), %ymm1
	vmovups	%ymm1, 196640(%rdi,%rax)
	vmovups	%ymm0, 196608(%rdi,%rax)
	movzwl	64(%rdx), %r9d
	movw	%r9w, 65536(%r8,%rsi)
	movzwl	66(%rdx), %r9d
	movw	%r9w, 65568(%r8,%rsi)
	movzwl	68(%rdx), %r9d
	movw	%r9w, 65600(%r8,%rsi)
	movzwl	70(%rdx), %r9d
	movw	%r9w, 65632(%r8,%rsi)
	movzwl	72(%rdx), %r9d
	movw	%r9w, 65664(%r8,%rsi)
	movzwl	74(%rdx), %r9d
	movw	%r9w, 65696(%r8,%rsi)
	movzwl	76(%rdx), %r9d
	movw	%r9w, 65728(%r8,%rsi)
	movzwl	78(%rdx), %r9d
	movw	%r9w, 65760(%r8,%rsi)
	movzwl	80(%rdx), %r9d
	movw	%r9w, 65792(%r8,%rsi)
	movzwl	82(%rdx), %r9d
	movw	%r9w, 65824(%r8,%rsi)
	movzwl	84(%rdx), %r9d
	movw	%r9w, 65856(%r8,%rsi)
	movzwl	86(%rdx), %r9d
	movw	%r9w, 65888(%r8,%rsi)
	movzwl	88(%rdx), %r9d
	movw	%r9w, 65920(%r8,%rsi)
	movzwl	90(%rdx), %r9d
	movw	%r9w, 65952(%r8,%rsi)
	movzwl	92(%rdx), %r9d
	movw	%r9w, 65984(%r8,%rsi)
	movzwl	94(%rdx), %r9d
	movw	%r9w, 66016(%r8,%rsi)
	movzwl	96(%rdx), %r9d
	movw	%r9w, 66048(%r8,%rsi)
	movzwl	98(%rdx), %r9d
	movw	%r9w, 66080(%r8,%rsi)
	movzwl	100(%rdx), %r9d
	movw	%r9w, 66112(%r8,%rsi)
	movzwl	102(%rdx), %r9d
	movw	%r9w, 66144(%r8,%rsi)
	movzwl	104(%rdx), %r9d
	movw	%r9w, 66176(%r8,%rsi)
	movzwl	106(%rdx), %r9d
	movw	%r9w, 66208(%r8,%rsi)
	movzwl	108(%rdx), %r9d
	movw	%r9w, 66240(%r8,%rsi)
	movzwl	110(%rdx), %r9d
	movw	%r9w, 66272(%r8,%rsi)
	movzwl	112(%rdx), %r9d
	movw	%r9w, 66304(%r8,%rsi)
	movzwl	114(%rdx), %r9d
	movw	%r9w, 66336(%r8,%rsi)
	movzwl	116(%rdx), %r9d
	movw	%r9w, 66368(%r8,%rsi)
	movzwl	118(%rdx), %r9d
	movw	%r9w, 66400(%r8,%rsi)
	movzwl	120(%rdx), %r9d
	movw	%r9w, 66432(%r8,%rsi)
	movzwl	122(%rdx), %r9d
	movw	%r9w, 66464(%r8,%rsi)
	movzwl	124(%rdx), %r9d
	movw	%r9w, 66496(%r8,%rsi)
	movzwl	126(%rdx), %r9d
	movw	%r9w, 66528(%r8,%rsi)
	vmovups	64(%rcx), %ymm0
	vmovups	96(%rcx), %ymm1
	vmovups	%ymm1, 262176(%rdi,%rax)
	vmovups	%ymm0, 262144(%rdi,%rax)
	movzwl	128(%rdx), %r9d
	movw	%r9w, 131072(%r8,%rsi)
	movzwl	130(%rdx), %r9d
	movw	%r9w, 131104(%r8,%rsi)
	movzwl	132(%rdx), %r9d
	movw	%r9w, 131136(%r8,%rsi)
	movzwl	134(%rdx), %r9d
	movw	%r9w, 131168(%r8,%rsi)
	movzwl	136(%rdx), %r9d
	movw	%r9w, 131200(%r8,%rsi)
	movzwl	138(%rdx), %r9d
	movw	%r9w, 131232(%r8,%rsi)
	movzwl	140(%rdx), %r9d
	movw	%r9w, 131264(%r8,%rsi)
	movzwl	142(%rdx), %r9d
	movw	%r9w, 131296(%r8,%rsi)
	movzwl	144(%rdx), %r9d
	movw	%r9w, 131328(%r8,%rsi)
	movzwl	146(%rdx), %r9d
	movw	%r9w, 131360(%r8,%rsi)
	movzwl	148(%rdx), %r9d
	movw	%r9w, 131392(%r8,%rsi)
	movzwl	150(%rdx), %r9d
	movw	%r9w, 131424(%r8,%rsi)
	movzwl	152(%rdx), %r9d
	movw	%r9w, 131456(%r8,%rsi)
	movzwl	154(%rdx), %r9d
	movw	%r9w, 131488(%r8,%rsi)
	movzwl	156(%rdx), %r9d
	movw	%r9w, 131520(%r8,%rsi)
	movzwl	158(%rdx), %r9d
	movw	%r9w, 131552(%r8,%rsi)
	movzwl	160(%rdx), %r9d
	movw	%r9w, 131584(%r8,%rsi)
	movzwl	162(%rdx), %r9d
	movw	%r9w, 131616(%r8,%rsi)
	movzwl	164(%rdx), %r9d
	movw	%r9w, 131648(%r8,%rsi)
	movzwl	166(%rdx), %r9d
	movw	%r9w, 131680(%r8,%rsi)
	movzwl	168(%rdx), %r9d
	movw	%r9w, 131712(%r8,%rsi)
	movzwl	170(%rdx), %r9d
	movw	%r9w, 131744(%r8,%rsi)
	movzwl	172(%rdx), %r9d
	movw	%r9w, 131776(%r8,%rsi)
	movzwl	174(%rdx), %r9d
	movw	%r9w, 131808(%r8,%rsi)
	movzwl	176(%rdx), %r9d
	movw	%r9w, 131840(%r8,%rsi)
	movzwl	178(%rdx), %r9d
	movw	%r9w, 131872(%r8,%rsi)
	movzwl	180(%rdx), %r9d
	movw	%r9w, 131904(%r8,%rsi)
	movzwl	182(%rdx), %r9d
	movw	%r9w, 131936(%r8,%rsi)
	movzwl	184(%rdx), %r9d
	movw	%r9w, 131968(%r8,%rsi)
	movzwl	186(%rdx), %r9d
	movw	%r9w, 132000(%r8,%rsi)
	movzwl	188(%rdx), %r9d
	movw	%r9w, 132032(%r8,%rsi)
	movzwl	190(%rdx), %edx
	movw	%dx, 132064(%r8,%rsi)
	vmovups	128(%rcx), %ymm0
	vmovups	160(%rcx), %ymm1
	vmovups	%ymm1, 327712(%rdi,%rax)
	vmovups	%ymm0, 327680(%rdi,%rax)
	vzeroupper
	retq
.Lfunc_end0:
	.size	_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_, .Lfunc_end0-_ZN3fx23opt14attn_kv_insertERNS0_6AttnKVEiPKaS4_
                                        # -- End function
	.section	.text._ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_,"ax",@progbits
	.globl	_ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_ # -- Begin function _ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_
	.p2align	4, 0x90
	.type	_ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_,@function
_ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_: # @_ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	leal	(%rsi,%rsi), %r8d
	movl	%esi, %eax
	sarl	$4, %eax
	cltq
	andl	$30, %r8d
	leaq	(%rdi,%r8,2), %r8
	vpmovsxbw	(%rdx), %ymm1
	vpmovsxbw	16(%rdx), %ymm2
	vpmovsxbw	32(%rdx), %ymm3
	shlq	$11, %rax
	vpmovsxbw	48(%rdx), %ymm0
	vmovd	%xmm1, (%rax,%r8)
	vpextrd	$1, %xmm1, 64(%rax,%r8)
	vpextrd	$2, %xmm1, 128(%rax,%r8)
	vpextrd	$3, %xmm1, 192(%rax,%r8)
	vextracti128	$1, %ymm1, %xmm1
	vmovd	%xmm1, 256(%rax,%r8)
	vpextrd	$1, %xmm1, 320(%rax,%r8)
	vpextrd	$2, %xmm1, 384(%rax,%r8)
	vpextrd	$3, %xmm1, 448(%rax,%r8)
	vmovd	%xmm2, 512(%rax,%r8)
	vpextrd	$1, %xmm2, 576(%rax,%r8)
	vpextrd	$2, %xmm2, 640(%rax,%r8)
	vpextrd	$3, %xmm2, 704(%rax,%r8)
	vextracti128	$1, %ymm2, %xmm1
	vmovd	%xmm1, 768(%rax,%r8)
	vpextrd	$1, %xmm1, 832(%rax,%r8)
	vpextrd	$2, %xmm1, 896(%rax,%r8)
	vpextrd	$3, %xmm1, 960(%rax,%r8)
	vmovd	%xmm3, 1024(%rax,%r8)
	vpextrd	$1, %xmm3, 1088(%rax,%r8)
	vpextrd	$2, %xmm3, 1152(%rax,%r8)
	vpextrd	$3, %xmm3, 1216(%rax,%r8)
	vextracti128	$1, %ymm3, %xmm1
	vmovd	%xmm1, 1280(%rax,%r8)
	vpextrd	$1, %xmm1, 1344(%rax,%r8)
	vpextrd	$2, %xmm1, 1408(%rax,%r8)
	vpextrd	$3, %xmm1, 1472(%rax,%r8)
	vmovd	%xmm0, 1536(%rax,%r8)
	vpextrd	$1, %xmm0, 1600(%rax,%r8)
	vpextrd	$2, %xmm0, 1664(%rax,%r8)
	vpextrd	$3, %xmm0, 1728(%rax,%r8)
	vextracti128	$1, %ymm0, %xmm0
	vmovd	%xmm0, 1792(%rax,%r8)
	vpextrd	$1, %xmm0, 1856(%rax,%r8)
	vpextrd	$2, %xmm0, 1920(%rax,%r8)
	vpextrd	$3, %xmm0, 1984(%rax,%r8)
	movslq	%esi, %rsi
	shlq	$6, %rsi
	vmovups	(%rcx), %ymm0
	vmovups	32(%rcx), %ymm1
	vmovups	%ymm1, 393248(%rdi,%rsi)
	vmovups	%ymm0, 393216(%rdi,%rsi)
	vpmovsxbw	64(%rdx), %ymm1
	vpmovsxbw	80(%rdx), %ymm2
	vpmovsxbw	96(%rdx), %ymm3
	vpmovsxbw	112(%rdx), %ymm0
	vmovd	%xmm1, 131072(%rax,%r8)
	vpextrd	$1, %xmm1, 131136(%rax,%r8)
	vpextrd	$2, %xmm1, 131200(%rax,%r8)
	vpextrd	$3, %xmm1, 131264(%rax,%r8)
	vextracti128	$1, %ymm1, %xmm1
	vmovd	%xmm1, 131328(%rax,%r8)
	vpextrd	$1, %xmm1, 131392(%rax,%r8)
	vpextrd	$2, %xmm1, 131456(%rax,%r8)
	vpextrd	$3, %xmm1, 131520(%rax,%r8)
	vmovd	%xmm2, 131584(%rax,%r8)
	vpextrd	$1, %xmm2, 131648(%rax,%r8)
	vpextrd	$2, %xmm2, 131712(%rax,%r8)
	vpextrd	$3, %xmm2, 131776(%rax,%r8)
	vextracti128	$1, %ymm2, %xmm1
	vmovd	%xmm1, 131840(%rax,%r8)
	vpextrd	$1, %xmm1, 131904(%rax,%r8)
	vpextrd	$2, %xmm1, 131968(%rax,%r8)
	vpextrd	$3, %xmm1, 132032(%rax,%r8)
	vmovd	%xmm3, 132096(%rax,%r8)
	vpextrd	$1, %xmm3, 132160(%rax,%r8)
	vpextrd	$2, %xmm3, 132224(%rax,%r8)
	vpextrd	$3, %xmm3, 132288(%rax,%r8)
	vextracti128	$1, %ymm3, %xmm1
	vmovd	%xmm1, 132352(%rax,%r8)
	vpextrd	$1, %xmm1, 132416(%rax,%r8)
	vpextrd	$2, %xmm1, 132480(%rax,%r8)
	vpextrd	$3, %xmm1, 132544(%rax,%r8)
	vmovd	%xmm0, 132608(%rax,%r8)
	vpextrd	$1, %xmm0, 132672(%rax,%r8)
	vpextrd	$2, %xmm0, 132736(%rax,%r8)
	vpextrd	$3, %xmm0, 132800(%rax,%r8)
	vextracti128	$1, %ymm0, %xmm0
	vmovd	%xmm0, 132864(%rax,%r8)
	vpextrd	$1, %xmm0, 132928(%rax,%r8)
	vpextrd	$2, %xmm0, 132992(%rax,%r8)
	vpextrd	$3, %xmm0, 133056(%rax,%r8)
	vmovups	64(%rcx), %ymm0
	vmovups	96(%rcx), %ymm1
	vmovups	%ymm1, 458784(%rdi,%rsi)
	vmovups	%ymm0, 458752(%rdi,%rsi)
	vpmovsxbw	128(%rdx), %ymm1
	vpmovsxbw	144(%rdx), %ymm2
	vpmovsxbw	160(%rdx), %ymm3
	vpmovsxbw	176(%rdx), %ymm0
	vmovd	%xmm1, 262144(%rax,%r8)
	vpextrd	$1, %xmm1, 262208(%rax,%r8)
	vpextrd	$2, %xmm1, 262272(%rax,%r8)
	vpextrd	$3, %xmm1, 262336(%rax,%r8)
	vextracti128	$1, %ymm1, %xmm1
	vmovd	%xmm1, 262400(%rax,%r8)
	vpextrd	$1, %xmm1, 262464(%rax,%r8)
	vpextrd	$2, %xmm1, 262528(%rax,%r8)
	vpextrd	$3, %xmm1, 262592(%rax,%r8)
	vmovd	%xmm2, 262656(%rax,%r8)
	vpextrd	$1, %xmm2, 262720(%rax,%r8)
	vpextrd	$2, %xmm2, 262784(%rax,%r8)
	vpextrd	$3, %xmm2, 262848(%rax,%r8)
	vextracti128	$1, %ymm2, %xmm1
	vmovd	%xmm1, 262912(%rax,%r8)
	vpextrd	$1, %xmm1, 262976(%rax,%r8)
	vpextrd	$2, %xmm1, 263040(%rax,%r8)
	vpextrd	$3, %xmm1, 263104(%rax,%r8)
	vmovd	%xmm3, 263168(%rax,%r8)
	vpextrd	$1, %xmm3, 263232(%rax,%r8)
	vpextrd	$2, %xmm3, 263296(%rax,%r8)
	vpextrd	$3, %xmm3, 263360(%rax,%r8)
	vextracti128	$1, %ymm3, %xmm1
	vmovd	%xmm1, 263424(%rax,%r8)
	vpextrd	$1, %xmm1, 263488(%rax,%r8)
	vpextrd	$2, %xmm1, 263552(%rax,%r8)
	vpextrd	$3, %xmm1, 263616(%rax,%r8)
	vmovd	%xmm0, 263680(%rax,%r8)
	vpextrd	$1, %xmm0, 263744(%rax,%r8)
	vpextrd	$2, %xmm0, 263808(%rax,%r8)
	vpextrd	$3, %xmm0, 263872(%rax,%r8)
	vextracti128	$1, %ymm0, %xmm0
	vmovd	%xmm0, 263936(%rax,%r8)
	vpextrd	$1, %xmm0, 264000(%rax,%r8)
	vpextrd	$2, %xmm0, 264064(%rax,%r8)
	vpextrd	$3, %xmm0, 264128(%rax,%r8)
	vmovups	128(%rcx), %ymm0
	vmovups	160(%rcx), %ymm1
	vmovups	%ymm1, 524320(%rdi,%rsi)
	vmovups	%ymm0, 524288(%rdi,%rsi)
	vzeroupper
	retq
.Lfunc_end1:
	.size	_ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_, .Lfunc_end1-_ZN3fx23opt14attn_kv_insertERNS0_8AttnKV16EiPKaS4_
                                        # -- End function
	.section	.text._ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_,"ax",@progbits
	.globl	_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_ # -- Begin function _ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_
	.p2align	4, 0x90
	.type	_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_,@function
_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_: # @_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	movl	%esi, %eax
	sarl	$4, %eax
	movslq	%eax, %r8
	movslq	%esi, %rax
	andl	$15, %esi
	leaq	(%rdi,%rsi,2), %rsi
	shlq	$10, %r8
	movzwl	(%rdx), %r9d
	movw	%r9w, (%r8,%rsi)
	movzwl	2(%rdx), %r9d
	movw	%r9w, 32(%r8,%rsi)
	movzwl	4(%rdx), %r9d
	movw	%r9w, 64(%r8,%rsi)
	movzwl	6(%rdx), %r9d
	movw	%r9w, 96(%r8,%rsi)
	movzwl	8(%rdx), %r9d
	movw	%r9w, 128(%r8,%rsi)
	movzwl	10(%rdx), %r9d
	movw	%r9w, 160(%r8,%rsi)
	movzwl	12(%rdx), %r9d
	movw	%r9w, 192(%r8,%rsi)
	movzwl	14(%rdx), %r9d
	movw	%r9w, 224(%r8,%rsi)
	movzwl	16(%rdx), %r9d
	movw	%r9w, 256(%r8,%rsi)
	movzwl	18(%rdx), %r9d
	movw	%r9w, 288(%r8,%rsi)
	movzwl	20(%rdx), %r9d
	movw	%r9w, 320(%r8,%rsi)
	movzwl	22(%rdx), %r9d
	movw	%r9w, 352(%r8,%rsi)
	movzwl	24(%rdx), %r9d
	movw	%r9w, 384(%r8,%rsi)
	movzwl	26(%rdx), %r9d
	movw	%r9w, 416(%r8,%rsi)
	movzwl	28(%rdx), %r9d
	movw	%r9w, 448(%r8,%rsi)
	movzwl	30(%rdx), %r9d
	movw	%r9w, 480(%r8,%rsi)
	movzwl	32(%rdx), %r9d
	movw	%r9w, 512(%r8,%rsi)
	movzwl	34(%rdx), %r9d
	movw	%r9w, 544(%r8,%rsi)
	movzwl	36(%rdx), %r9d
	movw	%r9w, 576(%r8,%rsi)
	movzwl	38(%rdx), %r9d
	movw	%r9w, 608(%r8,%rsi)
	movzwl	40(%rdx), %r9d
	movw	%r9w, 640(%r8,%rsi)
	movzwl	42(%rdx), %r9d
	movw	%r9w, 672(%r8,%rsi)
	movzwl	44(%rdx), %r9d
	movw	%r9w, 704(%r8,%rsi)
	movzwl	46(%rdx), %r9d
	movw	%r9w, 736(%r8,%rsi)
	movzwl	48(%rdx), %r9d
	movw	%r9w, 768(%r8,%rsi)
	movzwl	50(%rdx), %r9d
	movw	%r9w, 800(%r8,%rsi)
	movzwl	52(%rdx), %r9d
	movw	%r9w, 832(%r8,%rsi)
	movzwl	54(%rdx), %r9d
	movw	%r9w, 864(%r8,%rsi)
	movzwl	56(%rdx), %r9d
	movw	%r9w, 896(%r8,%rsi)
	movzwl	58(%rdx), %r9d
	movw	%r9w, 928(%r8,%rsi)
	movzwl	60(%rdx), %r9d
	movw	%r9w, 960(%r8,%rsi)
	movzwl	62(%rdx), %r9d
	movw	%r9w, 992(%r8,%rsi)
	shlq	$8, %rax
	vpmovsxbd	(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196608(%rdi,%rax)
	vpmovsxbd	8(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196640(%rdi,%rax)
	vpmovsxbd	16(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196672(%rdi,%rax)
	vpmovsxbd	24(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196704(%rdi,%rax)
	vpmovsxbd	32(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196736(%rdi,%rax)
	vpmovsxbd	40(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196768(%rdi,%rax)
	vpmovsxbd	48(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196800(%rdi,%rax)
	vpmovsxbd	56(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 196832(%rdi,%rax)
	movzwl	64(%rdx), %r9d
	movw	%r9w, 65536(%r8,%rsi)
	movzwl	66(%rdx), %r9d
	movw	%r9w, 65568(%r8,%rsi)
	movzwl	68(%rdx), %r9d
	movw	%r9w, 65600(%r8,%rsi)
	movzwl	70(%rdx), %r9d
	movw	%r9w, 65632(%r8,%rsi)
	movzwl	72(%rdx), %r9d
	movw	%r9w, 65664(%r8,%rsi)
	movzwl	74(%rdx), %r9d
	movw	%r9w, 65696(%r8,%rsi)
	movzwl	76(%rdx), %r9d
	movw	%r9w, 65728(%r8,%rsi)
	movzwl	78(%rdx), %r9d
	movw	%r9w, 65760(%r8,%rsi)
	movzwl	80(%rdx), %r9d
	movw	%r9w, 65792(%r8,%rsi)
	movzwl	82(%rdx), %r9d
	movw	%r9w, 65824(%r8,%rsi)
	movzwl	84(%rdx), %r9d
	movw	%r9w, 65856(%r8,%rsi)
	movzwl	86(%rdx), %r9d
	movw	%r9w, 65888(%r8,%rsi)
	movzwl	88(%rdx), %r9d
	movw	%r9w, 65920(%r8,%rsi)
	movzwl	90(%rdx), %r9d
	movw	%r9w, 65952(%r8,%rsi)
	movzwl	92(%rdx), %r9d
	movw	%r9w, 65984(%r8,%rsi)
	movzwl	94(%rdx), %r9d
	movw	%r9w, 66016(%r8,%rsi)
	movzwl	96(%rdx), %r9d
	movw	%r9w, 66048(%r8,%rsi)
	movzwl	98(%rdx), %r9d
	movw	%r9w, 66080(%r8,%rsi)
	movzwl	100(%rdx), %r9d
	movw	%r9w, 66112(%r8,%rsi)
	movzwl	102(%rdx), %r9d
	movw	%r9w, 66144(%r8,%rsi)
	movzwl	104(%rdx), %r9d
	movw	%r9w, 66176(%r8,%rsi)
	movzwl	106(%rdx), %r9d
	movw	%r9w, 66208(%r8,%rsi)
	movzwl	108(%rdx), %r9d
	movw	%r9w, 66240(%r8,%rsi)
	movzwl	110(%rdx), %r9d
	movw	%r9w, 66272(%r8,%rsi)
	movzwl	112(%rdx), %r9d
	movw	%r9w, 66304(%r8,%rsi)
	movzwl	114(%rdx), %r9d
	movw	%r9w, 66336(%r8,%rsi)
	movzwl	116(%rdx), %r9d
	movw	%r9w, 66368(%r8,%rsi)
	movzwl	118(%rdx), %r9d
	movw	%r9w, 66400(%r8,%rsi)
	movzwl	120(%rdx), %r9d
	movw	%r9w, 66432(%r8,%rsi)
	movzwl	122(%rdx), %r9d
	movw	%r9w, 66464(%r8,%rsi)
	movzwl	124(%rdx), %r9d
	movw	%r9w, 66496(%r8,%rsi)
	movzwl	126(%rdx), %r9d
	movw	%r9w, 66528(%r8,%rsi)
	vpmovsxbd	64(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458752(%rdi,%rax)
	vpmovsxbd	72(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458784(%rdi,%rax)
	vpmovsxbd	80(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458816(%rdi,%rax)
	vpmovsxbd	88(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458848(%rdi,%rax)
	vpmovsxbd	96(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458880(%rdi,%rax)
	vpmovsxbd	104(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458912(%rdi,%rax)
	vpmovsxbd	112(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458944(%rdi,%rax)
	vpmovsxbd	120(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 458976(%rdi,%rax)
	movzwl	128(%rdx), %r9d
	movw	%r9w, 131072(%r8,%rsi)
	movzwl	130(%rdx), %r9d
	movw	%r9w, 131104(%r8,%rsi)
	movzwl	132(%rdx), %r9d
	movw	%r9w, 131136(%r8,%rsi)
	movzwl	134(%rdx), %r9d
	movw	%r9w, 131168(%r8,%rsi)
	movzwl	136(%rdx), %r9d
	movw	%r9w, 131200(%r8,%rsi)
	movzwl	138(%rdx), %r9d
	movw	%r9w, 131232(%r8,%rsi)
	movzwl	140(%rdx), %r9d
	movw	%r9w, 131264(%r8,%rsi)
	movzwl	142(%rdx), %r9d
	movw	%r9w, 131296(%r8,%rsi)
	movzwl	144(%rdx), %r9d
	movw	%r9w, 131328(%r8,%rsi)
	movzwl	146(%rdx), %r9d
	movw	%r9w, 131360(%r8,%rsi)
	movzwl	148(%rdx), %r9d
	movw	%r9w, 131392(%r8,%rsi)
	movzwl	150(%rdx), %r9d
	movw	%r9w, 131424(%r8,%rsi)
	movzwl	152(%rdx), %r9d
	movw	%r9w, 131456(%r8,%rsi)
	movzwl	154(%rdx), %r9d
	movw	%r9w, 131488(%r8,%rsi)
	movzwl	156(%rdx), %r9d
	movw	%r9w, 131520(%r8,%rsi)
	movzwl	158(%rdx), %r9d
	movw	%r9w, 131552(%r8,%rsi)
	movzwl	160(%rdx), %r9d
	movw	%r9w, 131584(%r8,%rsi)
	movzwl	162(%rdx), %r9d
	movw	%r9w, 131616(%r8,%rsi)
	movzwl	164(%rdx), %r9d
	movw	%r9w, 131648(%r8,%rsi)
	movzwl	166(%rdx), %r9d
	movw	%r9w, 131680(%r8,%rsi)
	movzwl	168(%rdx), %r9d
	movw	%r9w, 131712(%r8,%rsi)
	movzwl	170(%rdx), %r9d
	movw	%r9w, 131744(%r8,%rsi)
	movzwl	172(%rdx), %r9d
	movw	%r9w, 131776(%r8,%rsi)
	movzwl	174(%rdx), %r9d
	movw	%r9w, 131808(%r8,%rsi)
	movzwl	176(%rdx), %r9d
	movw	%r9w, 131840(%r8,%rsi)
	movzwl	178(%rdx), %r9d
	movw	%r9w, 131872(%r8,%rsi)
	movzwl	180(%rdx), %r9d
	movw	%r9w, 131904(%r8,%rsi)
	movzwl	182(%rdx), %r9d
	movw	%r9w, 131936(%r8,%rsi)
	movzwl	184(%rdx), %r9d
	movw	%r9w, 131968(%r8,%rsi)
	movzwl	186(%rdx), %r9d
	movw	%r9w, 132000(%r8,%rsi)
	movzwl	188(%rdx), %r9d
	movw	%r9w, 132032(%r8,%rsi)
	movzwl	190(%rdx), %edx
	movw	%dx, 132064(%r8,%rsi)
	vpmovsxbd	128(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 720896(%rdi,%rax)
	vpmovsxbd	136(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 720928(%rdi,%rax)
	vpmovsxbd	144(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 720960(%rdi,%rax)
	vpmovsxbd	152(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 720992(%rdi,%rax)
	vpmovsxbd	160(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 721024(%rdi,%rax)
	vpmovsxbd	168(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 721056(%rdi,%rax)
	vpmovsxbd	176(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 721088(%rdi,%rax)
	vpmovsxbd	184(%rcx), %ymm0
	vcvtdq2ps	%ymm0, %ymm0
	vmovaps	%ymm0, 721120(%rdi,%rax)
	vzeroupper
	retq
.Lfunc_end2:
	.size	_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_, .Lfunc_end2-_ZN3fx23opt14attn_kv_insertERNS0_9AttnKVF32EiPKaS4_
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi
.LCPI3_0:
	.long	0x7149f2ca                      # float 1.00000002E+30
	.section	.text._ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi,"ax",@progbits
	.globl	_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi,@function
_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi: # @_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$224, %rsp
	movq	%r9, 40(%rsp)                   # 8-byte Spill
	movl	%r8d, %r14d
	movq	%rcx, %r13
	movq	%rsi, %r12
	movq	%rdi, %r15
	vxorps	%xmm1, %xmm1, %xmm1
	vcmpltss	%xmm0, %xmm1, %xmm1
	vbroadcastss	.LCPI3_0(%rip), %xmm2   # xmm2 = [1.00000002E+30,1.00000002E+30,1.00000002E+30,1.00000002E+30]
	vblendvps	%xmm1, %xmm0, %xmm2, %xmm0
	vmovaps	%xmm0, 48(%rsp)                 # 16-byte Spill
	vpmovsxbw	(%rsi), %ymm0
	movq	16(%rbp), %rbx
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	16(%rsi), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	32(%rsi), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	48(%rsi), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	movq	%rdx, 24(%rsp)                  # 8-byte Spill
	vmovss	(%rdx), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r8d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	leal	(%r14,%r14,2), %ecx
	testq	%rbx, %rbx
	movq	%r13, 32(%rsp)                  # 8-byte Spill
	je	.LBB3_3
# %bb.1:
	movl	20(%rsp), %eax
	movl	%eax, (%rbx)
	leaq	196608(%r15), %rdi
	vmovss	(%r13), %xmm1                   # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	shll	$2, %eax
	cmpl	%ecx, %eax
	movl	%ecx, %r13d
	movl	%r14d, %esi
	jge	.LBB3_5
# %bb.2:
	movq	40(%rsp), %rbx                  # 8-byte Reload
	movq	%rbx, %rdx
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	jmp	.LBB3_6
.LBB3_3:
	leaq	196608(%r15), %rdi
	movl	20(%rsp), %eax
	vmovss	(%r13), %xmm1                   # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	shll	$2, %eax
	cmpl	%ecx, %eax
	movl	%ecx, %r13d
	movq	40(%rsp), %rbx                  # 8-byte Reload
	movl	%r14d, %esi
	movq	%rbx, %rdx
	jge	.LBB3_12
# %bb.4:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	jmp	.LBB3_13
.LBB3_5:
	movq	40(%rsp), %rbx                  # 8-byte Reload
	movq	%rbx, %rdx
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
.LBB3_6:
	vpmovsxbw	64(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	80(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	96(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	112(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	65536(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	4(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	movl	20(%rsp), %eax
	movq	16(%rbp), %rcx
	movl	%eax, 4(%rcx)
	leaq	262144(%r15), %rdi
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	4(%rcx), %xmm1                  # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	leaq	256(%rbx), %rdx
	shll	$2, %eax
	movl	%r14d, %esi
	cmpl	%r13d, %eax
	jge	.LBB3_8
# %bb.7:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	jmp	.LBB3_9
.LBB3_8:
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
.LBB3_9:
	vpmovsxbw	128(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	144(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	160(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	176(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	131072(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	8(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	movl	20(%rsp), %eax
	movq	16(%rbp), %rcx
	movl	%eax, 8(%rcx)
	addq	$327680, %r15                   # imm = 0x50000
	jmp	.LBB3_10
.LBB3_12:
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
.LBB3_13:
	vpmovsxbw	64(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	80(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	96(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	112(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	65536(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	4(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	leaq	262144(%r15), %rdi
	movl	20(%rsp), %eax
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	4(%rcx), %xmm1                  # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	leaq	256(%rbx), %rdx
	shll	$2, %eax
	movl	%r14d, %esi
	cmpl	%r13d, %eax
	jge	.LBB3_15
# %bb.14:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	jmp	.LBB3_16
.LBB3_15:
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
.LBB3_16:
	vpmovsxbw	128(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	144(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	160(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	176(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	131072(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	8(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	addq	$327680, %r15                   # imm = 0x50000
	movl	20(%rsp), %eax
.LBB3_10:
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	8(%rcx), %xmm1                  # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	addq	$512, %rbx                      # imm = 0x200
	shll	$2, %eax
	movq	%r15, %rdi
	movl	%r14d, %esi
	movq	%rbx, %rdx
	cmpl	%r13d, %eax
	jge	.LBB3_11
# %bb.17:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	jmp	.LBB3_18
.LBB3_11:
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
.LBB3_18:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end3:
	.size	_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi, .Lfunc_end3-_ZN3fx23opt13attn_step_varERKNS0_6AttnKVEPKaPKfS7_iPffPi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi
.LCPI4_0:
	.long	0x7149f2ca                      # float 1.00000002E+30
.LCPI4_1:
	.long	0xff800000                      # float -Inf
	.section	.text._ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi,"ax",@progbits
	.globl	_ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi,@function
_ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi: # @_ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$320, %rsp                      # imm = 0x140
	movq	%r9, 104(%rsp)                  # 8-byte Spill
                                        # kill: def $r8d killed $r8d def $r8
	movq	%rcx, 96(%rsp)                  # 8-byte Spill
	movq	%rdx, 88(%rsp)                  # 8-byte Spill
	movq	%rsi, 80(%rsp)                  # 8-byte Spill
	vxorps	%xmm1, %xmm1, %xmm1
	vcmpltss	%xmm0, %xmm1, %xmm1
	vbroadcastss	.LCPI4_0(%rip), %xmm2   # xmm2 = [1.00000002E+30,1.00000002E+30,1.00000002E+30,1.00000002E+30]
	vblendvps	%xmm1, %xmm0, %xmm2, %xmm0
	vmovaps	%xmm0, 112(%rsp)                # 16-byte Spill
	movq	%rdi, 48(%rsp)                  # 8-byte Spill
	movl	%r8d, %eax
	andl	$-32, %eax
	movl	%r8d, %ecx
	andl	$31, %ecx
	movl	%r8d, %r12d
	shrl	$5, %r12d
	leal	31(%r8), %edx
	andl	$-32, %edx
	movq	%r8, (%rsp)                     # 8-byte Spill
	movslq	%r8d, %r15
	movl	%edx, 12(%rsp)                  # 4-byte Spill
	movslq	%edx, %rbx
	movq	%rbx, %rdx
	subq	%r15, %rdx
	movq	%rcx, 72(%rsp)                  # 8-byte Spill
	addl	$15, %ecx
	andl	$-16, %ecx
	movl	%ecx, 16(%rsp)                  # 4-byte Spill
	movq	%rdx, 32(%rsp)                  # 8-byte Spill
	movq	%rdx, %r9
	andq	$-32, %r9
	vbroadcastss	.LCPI4_1(%rip), %ymm9   # ymm9 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	movl	%eax, 20(%rsp)                  # 4-byte Spill
	cltq
	movq	%rax, 64(%rsp)                  # 8-byte Spill
	leal	(%r15,%r15,2), %eax
	movl	%eax, 24(%rsp)                  # 4-byte Spill
	leaq	(%r9,%r15), %rax
	movq	%rax, 56(%rsp)                  # 8-byte Spill
	xorl	%r13d, %r13d
	movq	%r9, 40(%rsp)                   # 8-byte Spill
	vmovaps	%ymm9, 128(%rsp)                # 32-byte Spill
	jmp	.LBB4_1
	.p2align	4, 0x90
.LBB4_26:                               #   in Loop: Header=BB4_1 Depth=1
	movq	(%rsp), %rsi                    # 8-byte Reload
                                        # kill: def $esi killed $esi killed $rsi
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
.LBB4_27:                               #   in Loop: Header=BB4_1 Depth=1
	movq	40(%rsp), %r9                   # 8-byte Reload
	vmovaps	128(%rsp), %ymm9                # 32-byte Reload
	incq	%r13
	cmpq	$3, %r13
	je	.LBB4_28
.LBB4_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB4_22 Depth 2
                                        #       Child Loop BB4_23 Depth 3
                                        #     Child Loop BB4_5 Depth 2
                                        #     Child Loop BB4_8 Depth 2
                                        #     Child Loop BB4_13 Depth 2
                                        #     Child Loop BB4_25 Depth 2
                                        #     Child Loop BB4_16 Depth 2
	movq	%r13, %r14
	shlq	$6, %r14
	movq	80(%rsp), %rax                  # 8-byte Reload
	vpmovsxbw	(%rax,%r14), %ymm0
	movq	%r13, %rsi
	vmovdqa	%ymm0, 160(%rsp)
	vpmovsxbw	16(%rax,%r14), %ymm0
	shlq	$17, %rsi
	vmovdqa	%ymm0, 192(%rsp)
	vpmovsxbw	32(%rax,%r14), %ymm0
	addq	48(%rsp), %rsi                  # 8-byte Folded Reload
	vmovdqa	%ymm0, 224(%rsp)
	vpmovsxbw	48(%rax,%r14), %ymm0
	vmovdqa	%ymm0, 256(%rsp)
	movq	88(%rsp), %rax                  # 8-byte Reload
	vbroadcastss	(%rax,%r13,4), %ymm1
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_scE, %eax
	cmpl	$32, (%rsp)                     # 4-byte Folded Reload
	jl	.LBB4_2
# %bb.21:                               #   in Loop: Header=BB4_1 Depth=1
	xorl	%edx, %edx
	vmovaps	%ymm9, %ymm0
	.p2align	4, 0x90
.LBB4_22:                               #   Parent Loop BB4_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB4_23 Depth 3
	leaq	4096(%rsi), %rcx
	vxorps	%xmm2, %xmm2, %xmm2
	movq	$-2, %rdi
	movl	$1024, %r8d                     # imm = 0x400
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB4_23:                               #   Parent Loop BB4_1 Depth=1
                                        #     Parent Loop BB4_22 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	prefetcht0	(%rsi,%r8,4)
	prefetcht0	64(%rsi,%r8,4)
	vpbroadcastd	168(%rsp,%rdi,4), %ymm6
	vpmaddwd	-2048(%rsi,%r8,2), %ymm6, %ymm7
	vpaddd	%ymm2, %ymm7, %ymm2
	vpmaddwd	-2016(%rsi,%r8,2), %ymm6, %ymm7
	vpaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	(%rsi,%r8,2), %ymm6, %ymm7
	vpaddd	%ymm4, %ymm7, %ymm4
	vpmaddwd	32(%rsi,%r8,2), %ymm6, %ymm6
	vpbroadcastd	172(%rsp,%rdi,4), %ymm7
	vpaddd	%ymm3, %ymm6, %ymm3
	vpmaddwd	-1984(%rsi,%r8,2), %ymm7, %ymm6
	vpaddd	%ymm6, %ymm2, %ymm2
	vpmaddwd	-1952(%rsi,%r8,2), %ymm7, %ymm6
	vpmaddwd	64(%rsi,%r8,2), %ymm7, %ymm8
	vpaddd	%ymm6, %ymm5, %ymm5
	vpaddd	%ymm4, %ymm8, %ymm4
	vpmaddwd	96(%rsi,%r8,2), %ymm7, %ymm6
	vpaddd	%ymm6, %ymm3, %ymm3
	addq	$2, %rdi
	addq	$64, %r8
	cmpq	$30, %rdi
	jb	.LBB4_23
# %bb.24:                               #   in Loop: Header=BB4_22 Depth=2
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vcvtdq2ps	%ymm5, %ymm5
	vmulps	%ymm5, %ymm1, %ymm5
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm4, %ymm1, %ymm4
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm2, (%rax)
	vmovaps	%ymm5, 32(%rax)
	vmovaps	%ymm4, 64(%rax)
	vmovaps	%ymm3, 96(%rax)
	vmaxps	%ymm5, %ymm2, %ymm2
	vmaxps	%ymm3, %ymm4, %ymm3
	vmaxps	%ymm3, %ymm2, %ymm2
	vmaxps	%ymm2, %ymm0, %ymm0
	incl	%edx
	subq	$-128, %rax
	movq	%rcx, %rsi
	cmpl	%r12d, %edx
	jne	.LBB4_22
# %bb.3:                                #   in Loop: Header=BB4_1 Depth=1
	cmpl	$0, 72(%rsp)                    # 4-byte Folded Reload
	jne	.LBB4_4
	jmp	.LBB4_17
	.p2align	4, 0x90
.LBB4_2:                                #   in Loop: Header=BB4_1 Depth=1
	movq	%rsi, %rcx
	vmovaps	%ymm9, %ymm0
	cmpl	$0, 72(%rsp)                    # 4-byte Folded Reload
	je	.LBB4_17
.LBB4_4:                                #   in Loop: Header=BB4_1 Depth=1
	leaq	96(%rcx), %rdx
	vxorps	%xmm2, %xmm2, %xmm2
	xorl	%esi, %esi
	vxorps	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB4_5:                                #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpbroadcastd	160(%rsp,%rsi,4), %ymm4
	vpmaddwd	-96(%rdx), %ymm4, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	-64(%rdx), %ymm4, %ymm4
	vpbroadcastd	164(%rsp,%rsi,4), %ymm5
	vpmaddwd	-32(%rdx), %ymm5, %ymm6
	vpaddd	%ymm2, %ymm4, %ymm2
	vpaddd	%ymm3, %ymm6, %ymm3
	vpmaddwd	(%rdx), %ymm5, %ymm4
	vpaddd	%ymm2, %ymm4, %ymm2
	addq	$2, %rsi
	subq	$-128, %rdx
	cmpq	$32, %rsi
	jne	.LBB4_5
# %bb.6:                                #   in Loop: Header=BB4_1 Depth=1
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm3, (%rax)
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm2, 32(%rax)
	cmpl	$16, 16(%rsp)                   # 4-byte Folded Reload
	je	.LBB4_10
# %bb.7:                                #   in Loop: Header=BB4_1 Depth=1
	addq	$2144, %rcx                     # imm = 0x860
	vxorps	%xmm2, %xmm2, %xmm2
	xorl	%edx, %edx
	vxorps	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB4_8:                                #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vpbroadcastd	160(%rsp,%rdx,4), %ymm4
	vpmaddwd	-96(%rcx), %ymm4, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	-64(%rcx), %ymm4, %ymm4
	vpbroadcastd	164(%rsp,%rdx,4), %ymm5
	vpmaddwd	-32(%rcx), %ymm5, %ymm6
	vpaddd	%ymm2, %ymm4, %ymm2
	vpaddd	%ymm3, %ymm6, %ymm3
	vpmaddwd	(%rcx), %ymm5, %ymm4
	vpaddd	%ymm2, %ymm4, %ymm2
	addq	$2, %rdx
	subq	$-128, %rcx
	cmpq	$32, %rdx
	jne	.LBB4_8
# %bb.9:                                #   in Loop: Header=BB4_1 Depth=1
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm3, 64(%rax)
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm1
	vmovaps	%ymm1, 96(%rax)
.LBB4_10:                               #   in Loop: Header=BB4_1 Depth=1
	movl	12(%rsp), %eax                  # 4-byte Reload
	cmpl	(%rsp), %eax                    # 4-byte Folded Reload
	jle	.LBB4_15
# %bb.11:                               #   in Loop: Header=BB4_1 Depth=1
	movq	%r15, %rax
	cmpq	$32, 32(%rsp)                   # 8-byte Folded Reload
	jb	.LBB4_25
# %bb.12:                               #   in Loop: Header=BB4_1 Depth=1
	xorl	%eax, %eax
	.p2align	4, 0x90
.LBB4_13:                               #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	leaq	(,%r15,4), %rcx
	vmovups	%ymm9, _ZN3fx23opt12_GLOBAL__N_14g_scE(%rcx,%rax,4)
	vmovups	%ymm9, _ZN3fx23opt12_GLOBAL__N_14g_scE+32(%rcx,%rax,4)
	vmovups	%ymm9, _ZN3fx23opt12_GLOBAL__N_14g_scE+64(%rcx,%rax,4)
	vmovups	%ymm9, _ZN3fx23opt12_GLOBAL__N_14g_scE+96(%rcx,%rax,4)
	addq	$32, %rax
	cmpq	%rax, %r9
	jne	.LBB4_13
# %bb.14:                               #   in Loop: Header=BB4_1 Depth=1
	movq	56(%rsp), %rax                  # 8-byte Reload
	cmpq	%r9, 32(%rsp)                   # 8-byte Folded Reload
	je	.LBB4_15
	.p2align	4, 0x90
.LBB4_25:                               #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	movl	$-8388608, _ZN3fx23opt12_GLOBAL__N_14g_scE(,%rax,4) # imm = 0xFF800000
	incq	%rax
	cmpq	%rax, %rbx
	jne	.LBB4_25
.LBB4_15:                               #   in Loop: Header=BB4_1 Depth=1
	movq	64(%rsp), %rax                  # 8-byte Reload
	movl	12(%rsp), %ecx                  # 4-byte Reload
	cmpl	%ecx, 20(%rsp)                  # 4-byte Folded Reload
	jge	.LBB4_17
	.p2align	4, 0x90
.LBB4_16:                               #   Parent Loop BB4_1 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	vmaxps	_ZN3fx23opt12_GLOBAL__N_14g_scE(,%rax,4), %ymm0, %ymm0
	addq	$8, %rax
	cmpq	%rbx, %rax
	jl	.LBB4_16
.LBB4_17:                               #   in Loop: Header=BB4_1 Depth=1
	vextractf128	$1, %ymm0, %xmm1
	vmaxps	%xmm1, %xmm0, %xmm0
	vshufpd	$3, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,1]
	vmaxps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vmaxss	%xmm1, %xmm0, %xmm0
	movq	(%rsp), %rdi                    # 8-byte Reload
                                        # kill: def $edi killed $edi killed $rdi
	vmovaps	112(%rsp), %xmm1                # 16-byte Reload
	leaq	28(%rsp), %rsi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	movl	28(%rsp), %eax
	movq	16(%rbp), %rcx
	testq	%rcx, %rcx
	je	.LBB4_19
# %bb.18:                               #   in Loop: Header=BB4_1 Depth=1
	movl	%eax, (%rcx,%r13,4)
.LBB4_19:                               #   in Loop: Header=BB4_1 Depth=1
	movq	%r13, %rcx
	shlq	$16, %rcx
	movq	48(%rsp), %rdx                  # 8-byte Reload
	leaq	(%rdx,%rcx), %rdi
	addq	$393216, %rdi                   # imm = 0x60000
	movq	96(%rsp), %rcx                  # 8-byte Reload
	vmovss	(%rcx,%r13,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	movq	104(%rsp), %rcx                 # 8-byte Reload
	leaq	(%rcx,%r14,4), %rdx
	shll	$2, %eax
	cmpl	24(%rsp), %eax                  # 4-byte Folded Reload
	jl	.LBB4_26
# %bb.20:                               #   in Loop: Header=BB4_1 Depth=1
	movq	(%rsp), %rsi                    # 8-byte Reload
                                        # kill: def $esi killed $esi killed $rsi
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
	jmp	.LBB4_27
.LBB4_28:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	vzeroupper
	retq
.Lfunc_end4:
	.size	_ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi, .Lfunc_end4-_ZN3fx23opt13attn_step_varERKNS0_8AttnKV16EPKaPKfS7_iPffPi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi
.LCPI5_0:
	.long	0x7149f2ca                      # float 1.00000002E+30
	.section	.text._ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi,"ax",@progbits
	.globl	_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi,@function
_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi: # @_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$224, %rsp
	movq	%r9, 40(%rsp)                   # 8-byte Spill
	movl	%r8d, %r14d
	movq	%rcx, %r13
	movq	%rsi, %r12
	movq	%rdi, %r15
	vxorps	%xmm1, %xmm1, %xmm1
	vcmpltss	%xmm0, %xmm1, %xmm1
	vbroadcastss	.LCPI5_0(%rip), %xmm2   # xmm2 = [1.00000002E+30,1.00000002E+30,1.00000002E+30,1.00000002E+30]
	vblendvps	%xmm1, %xmm0, %xmm2, %xmm0
	vmovaps	%xmm0, 48(%rsp)                 # 16-byte Spill
	vpmovsxbw	(%rsi), %ymm0
	movq	16(%rbp), %rbx
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	16(%rsi), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	32(%rsi), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	48(%rsi), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	movq	%rdx, 24(%rsp)                  # 8-byte Spill
	vmovss	(%rdx), %xmm0                   # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r8d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	leal	(%r14,%r14,2), %ecx
	testq	%rbx, %rbx
	movq	%r13, 32(%rsp)                  # 8-byte Spill
	je	.LBB5_3
# %bb.1:
	movl	20(%rsp), %eax
	movl	%eax, (%rbx)
	leaq	196608(%r15), %rdi
	vmovss	(%r13), %xmm1                   # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	shll	$2, %eax
	cmpl	%ecx, %eax
	movl	%ecx, %r13d
	movl	%r14d, %esi
	jge	.LBB5_5
# %bb.2:
	movq	40(%rsp), %rbx                  # 8-byte Reload
	movq	%rbx, %rdx
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	jmp	.LBB5_6
.LBB5_3:
	leaq	196608(%r15), %rdi
	movl	20(%rsp), %eax
	vmovss	(%r13), %xmm1                   # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	shll	$2, %eax
	cmpl	%ecx, %eax
	movl	%ecx, %r13d
	movq	40(%rsp), %rbx                  # 8-byte Reload
	movl	%r14d, %esi
	movq	%rbx, %rdx
	jge	.LBB5_12
# %bb.4:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	jmp	.LBB5_13
.LBB5_5:
	movq	40(%rsp), %rbx                  # 8-byte Reload
	movq	%rbx, %rdx
	callq	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
.LBB5_6:
	vpmovsxbw	64(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	80(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	96(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	112(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	65536(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	4(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	movl	20(%rsp), %eax
	movq	16(%rbp), %rcx
	movl	%eax, 4(%rcx)
	leaq	458752(%r15), %rdi
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	4(%rcx), %xmm1                  # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	leaq	256(%rbx), %rdx
	shll	$2, %eax
	movl	%r14d, %esi
	cmpl	%r13d, %eax
	jge	.LBB5_8
# %bb.7:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	jmp	.LBB5_9
.LBB5_8:
	callq	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
.LBB5_9:
	vpmovsxbw	128(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	144(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	160(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	176(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	131072(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	8(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	movl	20(%rsp), %eax
	movq	16(%rbp), %rcx
	movl	%eax, 8(%rcx)
	addq	$720896, %r15                   # imm = 0xB0000
	jmp	.LBB5_10
.LBB5_12:
	callq	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
.LBB5_13:
	vpmovsxbw	64(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	80(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	96(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	112(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	65536(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	4(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	leaq	458752(%r15), %rdi
	movl	20(%rsp), %eax
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	4(%rcx), %xmm1                  # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	leaq	256(%rbx), %rdx
	shll	$2, %eax
	movl	%r14d, %esi
	cmpl	%r13d, %eax
	jge	.LBB5_15
# %bb.14:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	jmp	.LBB5_16
.LBB5_15:
	callq	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
.LBB5_16:
	vpmovsxbw	128(%r12), %ymm0
	vmovdqa	%ymm0, 64(%rsp)
	vpmovsxbw	144(%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	160(%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	176(%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	leaq	131072(%r15), %rdi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vmovss	8(%rax), %xmm0                  # xmm0 = mem[0],zero,zero,zero
	leaq	64(%rsp), %rsi
	movl	%r14d, %edx
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
	leaq	20(%rsp), %rsi
	movl	%r14d, %edi
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
	addq	$720896, %r15                   # imm = 0xB0000
	movl	20(%rsp), %eax
.LBB5_10:
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	8(%rcx), %xmm1                  # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	addq	$512, %rbx                      # imm = 0x200
	shll	$2, %eax
	movq	%r15, %rdi
	movl	%r14d, %esi
	movq	%rbx, %rdx
	cmpl	%r13d, %eax
	jge	.LBB5_11
# %bb.17:
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	jmp	.LBB5_18
.LBB5_11:
	callq	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
.LBB5_18:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end5:
	.size	_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi, .Lfunc_end5-_ZN3fx23opt13attn_step_varERKNS0_9AttnKVF32EPKaPKfS7_iPffPi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi
.LCPI6_0:
	.long	0x7149f2ca                      # float 1.00000002E+30
.LCPI6_1:
	.long	0xff800000                      # float -Inf
	.section	.text._ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi,"ax",@progbits
	.globl	_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi,@function
_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi: # @_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$256, %rsp                      # imm = 0x100
	movq	%r9, 40(%rsp)                   # 8-byte Spill
	movq	%r8, 32(%rsp)                   # 8-byte Spill
	movq	%rcx, 24(%rsp)                  # 8-byte Spill
	movq	%rdx, 16(%rsp)                  # 8-byte Spill
	movq	%rsi, %r13
	vxorps	%xmm1, %xmm1, %xmm1
	vcmpltss	%xmm0, %xmm1, %xmm1
	vbroadcastss	.LCPI6_0(%rip), %xmm2   # xmm2 = [1.00000002E+30,1.00000002E+30,1.00000002E+30,1.00000002E+30]
	vblendvps	%xmm1, %xmm0, %xmm2, %xmm0
	vmovaps	%xmm0, 48(%rsp)                 # 16-byte Spill
	movq	%rdi, %r14
	xorl	%r15d, %r15d
	vbroadcastss	.LCPI6_1(%rip), %ymm0   # ymm0 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	vmovaps	%ymm0, 64(%rsp)                 # 32-byte Spill
	jmp	.LBB6_1
	.p2align	4, 0x90
.LBB6_9:                                #   in Loop: Header=BB6_1 Depth=1
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	incq	%r15
	cmpq	$3, %r15
	je	.LBB6_11
.LBB6_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB6_2 Depth 2
                                        #       Child Loop BB6_3 Depth 3
	movq	%r15, %r12
	shlq	$6, %r12
	vpmovsxbw	(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	16(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	32(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	vpmovsxbw	48(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 192(%rsp)
	movq	%r15, %rbx
	shlq	$16, %rbx
	leaq	(%r14,%rbx), %rsi
	movq	16(%rsp), %rax                  # 8-byte Reload
	vbroadcastss	(%rax,%r15,4), %ymm1
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_scE, %eax
	vmovaps	64(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB6_2:                                #   Parent Loop BB6_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB6_3 Depth 3
	leaq	2048(%rsi), %rdx
	vpxor	%xmm3, %xmm3, %xmm3
	movl	$1, %r8d
	movl	$512, %edi                      # imm = 0x200
	vxorps	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB6_3:                                #   Parent Loop BB6_1 Depth=1
                                        #     Parent Loop BB6_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	prefetcht0	(%rsi,%rdi,4)
	prefetcht0	32(%rsi,%rdi,4)
	vpbroadcastd	92(%rsp,%r8,4), %ymm6
	vpmovsxbw	-1024(%rsi,%rdi,2), %ymm7
	vpmovsxbw	-1008(%rsi,%rdi,2), %ymm8
	vpmovsxbw	(%rsi,%rdi,2), %ymm9
	vpmovsxbw	16(%rsi,%rdi,2), %ymm10
	vpmaddwd	%ymm7, %ymm6, %ymm7
	vpaddd	%ymm3, %ymm7, %ymm3
	vpmaddwd	%ymm6, %ymm8, %ymm7
	vpaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm6, %ymm9, %ymm7
	vpaddd	%ymm4, %ymm7, %ymm4
	vpmaddwd	%ymm6, %ymm10, %ymm6
	vpbroadcastd	96(%rsp,%r8,4), %ymm7
	vpmovsxbw	-992(%rsi,%rdi,2), %ymm8
	vpmovsxbw	-976(%rsi,%rdi,2), %ymm9
	vpmovsxbw	32(%rsi,%rdi,2), %ymm10
	vpaddd	%ymm2, %ymm6, %ymm2
	vpmovsxbw	48(%rsi,%rdi,2), %ymm6
	vpmaddwd	%ymm7, %ymm8, %ymm8
	vpaddd	%ymm3, %ymm8, %ymm3
	vpmaddwd	%ymm7, %ymm9, %ymm8
	vpaddd	%ymm5, %ymm8, %ymm5
	vpmaddwd	%ymm7, %ymm10, %ymm8
	vpaddd	%ymm4, %ymm8, %ymm4
	vpmaddwd	%ymm6, %ymm7, %ymm6
	vpaddd	%ymm6, %ymm2, %ymm2
	leaq	2(%r8), %r9
	decq	%r8
	addq	$32, %rdi
	cmpq	$30, %r8
	movq	%r9, %r8
	jb	.LBB6_3
# %bb.4:                                #   in Loop: Header=BB6_2 Depth=2
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vcvtdq2ps	%ymm5, %ymm5
	vmulps	%ymm5, %ymm1, %ymm5
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm4, %ymm1, %ymm4
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm3, (%rax)
	vmovaps	%ymm5, 32(%rax)
	vmovaps	%ymm4, 64(%rax)
	vmovaps	%ymm2, 96(%rax)
	vmaxps	%ymm5, %ymm3, %ymm3
	vmaxps	%ymm2, %ymm4, %ymm2
	vmaxps	%ymm2, %ymm3, %ymm2
	vmaxps	%ymm2, %ymm0, %ymm0
	incl	%ecx
	subq	$-128, %rax
	movq	%rdx, %rsi
	cmpl	$32, %ecx
	jne	.LBB6_2
# %bb.5:                                #   in Loop: Header=BB6_1 Depth=1
	vextractf128	$1, %ymm0, %xmm1
	vmaxps	%xmm1, %xmm0, %xmm0
	vshufpd	$3, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,1]
	vmaxps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vmaxss	%xmm1, %xmm0, %xmm0
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	leaq	12(%rsp), %rdi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi
	movl	12(%rsp), %eax
	movq	40(%rsp), %rcx                  # 8-byte Reload
	testq	%rcx, %rcx
	je	.LBB6_7
# %bb.6:                                #   in Loop: Header=BB6_1 Depth=1
	movl	%eax, (%rcx,%r15,4)
.LBB6_7:                                #   in Loop: Header=BB6_1 Depth=1
	leaq	(%r14,%rbx), %rdi
	addq	$196608, %rdi                   # imm = 0x30000
	movq	24(%rsp), %rcx                  # 8-byte Reload
	vmovss	(%rcx,%r15,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	movq	32(%rsp), %rcx                  # 8-byte Reload
	leaq	(%rcx,%r12,4), %rdx
	movl	$1024, %esi                     # imm = 0x400
	cmpl	$768, %eax                      # imm = 0x300
	jl	.LBB6_9
# %bb.8:                                #   in Loop: Header=BB6_1 Depth=1
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
	incq	%r15
	cmpq	$3, %r15
	jne	.LBB6_1
.LBB6_11:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end6:
	.size	_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi, .Lfunc_end6-_ZN3fx23opt15attn_step_fixedERKNS0_6AttnKVEPKaPKfS7_PffPi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi
.LCPI7_0:
	.long	0x7149f2ca                      # float 1.00000002E+30
.LCPI7_1:
	.long	0xff800000                      # float -Inf
	.section	.text._ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi,"ax",@progbits
	.globl	_ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi,@function
_ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi: # @_ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$256, %rsp                      # imm = 0x100
	movq	%r9, %rbx
	movq	%r8, 40(%rsp)                   # 8-byte Spill
	movq	%rcx, 32(%rsp)                  # 8-byte Spill
	movq	%rdx, 24(%rsp)                  # 8-byte Spill
	movq	%rsi, %r13
	vxorps	%xmm1, %xmm1, %xmm1
	vcmpltss	%xmm0, %xmm1, %xmm1
	vbroadcastss	.LCPI7_0(%rip), %xmm2   # xmm2 = [1.00000002E+30,1.00000002E+30,1.00000002E+30,1.00000002E+30]
	vblendvps	%xmm1, %xmm0, %xmm2, %xmm0
	vmovaps	%xmm0, 48(%rsp)                 # 16-byte Spill
	movq	%rdi, %r14
	xorl	%r15d, %r15d
	vbroadcastss	.LCPI7_1(%rip), %ymm0   # ymm0 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	vmovaps	%ymm0, 64(%rsp)                 # 32-byte Spill
	jmp	.LBB7_1
	.p2align	4, 0x90
.LBB7_9:                                #   in Loop: Header=BB7_1 Depth=1
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	incq	%r15
	cmpq	$3, %r15
	je	.LBB7_11
.LBB7_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB7_2 Depth 2
                                        #       Child Loop BB7_3 Depth 3
	movq	%r15, %r12
	shlq	$6, %r12
	vpmovsxbw	(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	16(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	32(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	vpmovsxbw	48(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 192(%rsp)
	movq	%r15, %rsi
	shlq	$17, %rsi
	addq	%r14, %rsi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vbroadcastss	(%rax,%r15,4), %ymm1
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_scE, %eax
	vmovaps	64(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB7_2:                                #   Parent Loop BB7_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB7_3 Depth 3
	leaq	4096(%rsi), %rdx
	vpxor	%xmm3, %xmm3, %xmm3
	movl	$1, %r8d
	movl	$1024, %edi                     # imm = 0x400
	vxorps	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB7_3:                                #   Parent Loop BB7_1 Depth=1
                                        #     Parent Loop BB7_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	prefetcht0	(%rsi,%rdi,4)
	prefetcht0	64(%rsi,%rdi,4)
	vpbroadcastd	92(%rsp,%r8,4), %ymm6
	vpmaddwd	-2048(%rsi,%rdi,2), %ymm6, %ymm7
	vpaddd	%ymm3, %ymm7, %ymm3
	vpmaddwd	-2016(%rsi,%rdi,2), %ymm6, %ymm7
	vpmaddwd	(%rsi,%rdi,2), %ymm6, %ymm8
	vpaddd	%ymm5, %ymm7, %ymm5
	vpaddd	%ymm4, %ymm8, %ymm4
	vpmaddwd	32(%rsi,%rdi,2), %ymm6, %ymm6
	vpbroadcastd	96(%rsp,%r8,4), %ymm7
	vpmaddwd	-1984(%rsi,%rdi,2), %ymm7, %ymm8
	vpaddd	%ymm2, %ymm6, %ymm2
	vpaddd	%ymm3, %ymm8, %ymm3
	vpmaddwd	-1952(%rsi,%rdi,2), %ymm7, %ymm6
	vpaddd	%ymm6, %ymm5, %ymm5
	vpmaddwd	64(%rsi,%rdi,2), %ymm7, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm4
	vpmaddwd	96(%rsi,%rdi,2), %ymm7, %ymm6
	vpaddd	%ymm6, %ymm2, %ymm2
	leaq	2(%r8), %r9
	decq	%r8
	addq	$64, %rdi
	cmpq	$30, %r8
	movq	%r9, %r8
	jb	.LBB7_3
# %bb.4:                                #   in Loop: Header=BB7_2 Depth=2
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vcvtdq2ps	%ymm5, %ymm5
	vmulps	%ymm5, %ymm1, %ymm5
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm4, %ymm1, %ymm4
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm3, (%rax)
	vmovaps	%ymm5, 32(%rax)
	vmovaps	%ymm4, 64(%rax)
	vmovaps	%ymm2, 96(%rax)
	vmaxps	%ymm5, %ymm3, %ymm3
	vmaxps	%ymm2, %ymm4, %ymm2
	vmaxps	%ymm2, %ymm3, %ymm2
	vmaxps	%ymm2, %ymm0, %ymm0
	incl	%ecx
	subq	$-128, %rax
	movq	%rdx, %rsi
	cmpl	$32, %ecx
	jne	.LBB7_2
# %bb.5:                                #   in Loop: Header=BB7_1 Depth=1
	vextractf128	$1, %ymm0, %xmm1
	vmaxps	%xmm1, %xmm0, %xmm0
	vshufpd	$3, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,1]
	vmaxps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vmaxss	%xmm1, %xmm0, %xmm0
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	leaq	20(%rsp), %rdi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi
	movl	20(%rsp), %eax
	testq	%rbx, %rbx
	je	.LBB7_7
# %bb.6:                                #   in Loop: Header=BB7_1 Depth=1
	movl	%eax, (%rbx,%r15,4)
.LBB7_7:                                #   in Loop: Header=BB7_1 Depth=1
	movq	%r15, %rcx
	shlq	$16, %rcx
	leaq	(%r14,%rcx), %rdi
	addq	$393216, %rdi                   # imm = 0x60000
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	(%rcx,%r15,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	movq	40(%rsp), %rcx                  # 8-byte Reload
	leaq	(%rcx,%r12,4), %rdx
	movl	$1024, %esi                     # imm = 0x400
	cmpl	$768, %eax                      # imm = 0x300
	jl	.LBB7_9
# %bb.8:                                #   in Loop: Header=BB7_1 Depth=1
	callq	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
	incq	%r15
	cmpq	$3, %r15
	jne	.LBB7_1
.LBB7_11:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end7:
	.size	_ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi, .Lfunc_end7-_ZN3fx23opt15attn_step_fixedERKNS0_8AttnKV16EPKaPKfS7_PffPi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi
.LCPI8_0:
	.long	0x7149f2ca                      # float 1.00000002E+30
.LCPI8_1:
	.long	0xff800000                      # float -Inf
	.section	.text._ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi,"ax",@progbits
	.globl	_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi
	.p2align	4, 0x90
	.type	_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi,@function
_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi: # @_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi
# %bb.0:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r15
	pushq	%r14
	pushq	%r13
	pushq	%r12
	pushq	%rbx
	andq	$-32, %rsp
	subq	$256, %rsp                      # imm = 0x100
	movq	%r9, %rbx
	movq	%r8, 40(%rsp)                   # 8-byte Spill
	movq	%rcx, 32(%rsp)                  # 8-byte Spill
	movq	%rdx, 24(%rsp)                  # 8-byte Spill
	movq	%rsi, %r13
	vxorps	%xmm1, %xmm1, %xmm1
	vcmpltss	%xmm0, %xmm1, %xmm1
	vbroadcastss	.LCPI8_0(%rip), %xmm2   # xmm2 = [1.00000002E+30,1.00000002E+30,1.00000002E+30,1.00000002E+30]
	vblendvps	%xmm1, %xmm0, %xmm2, %xmm0
	vmovaps	%xmm0, 48(%rsp)                 # 16-byte Spill
	movq	%rdi, %r14
	xorl	%r15d, %r15d
	vbroadcastss	.LCPI8_1(%rip), %ymm0   # ymm0 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	vmovaps	%ymm0, 64(%rsp)                 # 32-byte Spill
	jmp	.LBB8_1
	.p2align	4, 0x90
.LBB8_9:                                #   in Loop: Header=BB8_1 Depth=1
	callq	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	incq	%r15
	cmpq	$3, %r15
	je	.LBB8_11
.LBB8_1:                                # =>This Loop Header: Depth=1
                                        #     Child Loop BB8_2 Depth 2
                                        #       Child Loop BB8_3 Depth 3
	movq	%r15, %r12
	shlq	$6, %r12
	vpmovsxbw	(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 96(%rsp)
	vpmovsxbw	16(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 128(%rsp)
	vpmovsxbw	32(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 160(%rsp)
	vpmovsxbw	48(%r13,%r12), %ymm0
	vmovdqa	%ymm0, 192(%rsp)
	movq	%r15, %rsi
	shlq	$16, %rsi
	addq	%r14, %rsi
	movq	24(%rsp), %rax                  # 8-byte Reload
	vbroadcastss	(%rax,%r15,4), %ymm1
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_scE, %eax
	vmovaps	64(%rsp), %ymm0                 # 32-byte Reload
	xorl	%ecx, %ecx
	.p2align	4, 0x90
.LBB8_2:                                #   Parent Loop BB8_1 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB8_3 Depth 3
	leaq	2048(%rsi), %rdx
	vpxor	%xmm3, %xmm3, %xmm3
	movl	$1, %r8d
	movl	$512, %edi                      # imm = 0x200
	vxorps	%xmm2, %xmm2, %xmm2
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB8_3:                                #   Parent Loop BB8_1 Depth=1
                                        #     Parent Loop BB8_2 Depth=2
                                        # =>    This Inner Loop Header: Depth=3
	prefetcht0	(%rsi,%rdi,4)
	prefetcht0	32(%rsi,%rdi,4)
	vpbroadcastd	92(%rsp,%r8,4), %ymm6
	vpmovsxbw	-1024(%rsi,%rdi,2), %ymm7
	vpmovsxbw	-1008(%rsi,%rdi,2), %ymm8
	vpmovsxbw	(%rsi,%rdi,2), %ymm9
	vpmovsxbw	16(%rsi,%rdi,2), %ymm10
	vpmaddwd	%ymm7, %ymm6, %ymm7
	vpaddd	%ymm3, %ymm7, %ymm3
	vpmaddwd	%ymm6, %ymm8, %ymm7
	vpaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm6, %ymm9, %ymm7
	vpaddd	%ymm4, %ymm7, %ymm4
	vpmaddwd	%ymm6, %ymm10, %ymm6
	vpbroadcastd	96(%rsp,%r8,4), %ymm7
	vpmovsxbw	-992(%rsi,%rdi,2), %ymm8
	vpmovsxbw	-976(%rsi,%rdi,2), %ymm9
	vpmovsxbw	32(%rsi,%rdi,2), %ymm10
	vpaddd	%ymm2, %ymm6, %ymm2
	vpmovsxbw	48(%rsi,%rdi,2), %ymm6
	vpmaddwd	%ymm7, %ymm8, %ymm8
	vpaddd	%ymm3, %ymm8, %ymm3
	vpmaddwd	%ymm7, %ymm9, %ymm8
	vpaddd	%ymm5, %ymm8, %ymm5
	vpmaddwd	%ymm7, %ymm10, %ymm8
	vpaddd	%ymm4, %ymm8, %ymm4
	vpmaddwd	%ymm6, %ymm7, %ymm6
	vpaddd	%ymm6, %ymm2, %ymm2
	leaq	2(%r8), %r9
	decq	%r8
	addq	$32, %rdi
	cmpq	$30, %r8
	movq	%r9, %r8
	jb	.LBB8_3
# %bb.4:                                #   in Loop: Header=BB8_2 Depth=2
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vcvtdq2ps	%ymm5, %ymm5
	vmulps	%ymm5, %ymm1, %ymm5
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm4, %ymm1, %ymm4
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm3, (%rax)
	vmovaps	%ymm5, 32(%rax)
	vmovaps	%ymm4, 64(%rax)
	vmovaps	%ymm2, 96(%rax)
	vmaxps	%ymm5, %ymm3, %ymm3
	vmaxps	%ymm2, %ymm4, %ymm2
	vmaxps	%ymm2, %ymm3, %ymm2
	vmaxps	%ymm2, %ymm0, %ymm0
	incl	%ecx
	subq	$-128, %rax
	movq	%rdx, %rsi
	cmpl	$32, %ecx
	jne	.LBB8_2
# %bb.5:                                #   in Loop: Header=BB8_1 Depth=1
	vextractf128	$1, %ymm0, %xmm1
	vmaxps	%xmm1, %xmm0, %xmm0
	vshufpd	$3, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,1]
	vmaxps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vmaxss	%xmm1, %xmm0, %xmm0
	vmovaps	48(%rsp), %xmm1                 # 16-byte Reload
	leaq	20(%rsp), %rdi
	vzeroupper
	callq	_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi
	movl	20(%rsp), %eax
	testq	%rbx, %rbx
	je	.LBB8_7
# %bb.6:                                #   in Loop: Header=BB8_1 Depth=1
	movl	%eax, (%rbx,%r15,4)
.LBB8_7:                                #   in Loop: Header=BB8_1 Depth=1
	movq	%r15, %rcx
	shlq	$18, %rcx
	leaq	(%r14,%rcx), %rdi
	addq	$196608, %rdi                   # imm = 0x30000
	movq	32(%rsp), %rcx                  # 8-byte Reload
	vmovss	(%rcx,%r15,4), %xmm1            # xmm1 = mem[0],zero,zero,zero
	vdivss	%xmm0, %xmm1, %xmm0
	movq	40(%rsp), %rcx                  # 8-byte Reload
	leaq	(%rcx,%r12,4), %rdx
	movl	$1024, %esi                     # imm = 0x400
	cmpl	$768, %eax                      # imm = 0x300
	jl	.LBB8_9
# %bb.8:                                #   in Loop: Header=BB8_1 Depth=1
	callq	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
	incq	%r15
	cmpq	$3, %r15
	jne	.LBB8_1
.LBB8_11:
	leaq	-40(%rbp), %rsp
	popq	%rbx
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	popq	%rbp
	retq
.Lfunc_end8:
	.size	_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi, .Lfunc_end8-_ZN3fx23opt15attn_step_fixedERKNS0_9AttnKVF32EPKaPKfS7_PffPi
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
.LCPI9_0:
	.long	0xff800000                      # float -Inf
	.section	.text._ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf,"ax",@progbits
	.p2align	4, 0x90
	.type	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf,@function
_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf: # @_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
# %bb.0:
                                        # kill: def $edx killed $edx def $rdx
	vbroadcastss	%xmm0, %ymm1
	cmpl	$32, %edx
	jl	.LBB9_1
# %bb.13:
	movl	%edx, %ecx
	shrl	$5, %ecx
	xorl	%r8d, %r8d
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_scE, %eax
	vbroadcastss	.LCPI9_0(%rip), %ymm0   # ymm0 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	movq	%rdi, %r9
	.p2align	4, 0x90
.LBB9_14:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB9_15 Depth 2
	leaq	2048(%r9), %rdi
	vpxor	%xmm3, %xmm3, %xmm3
	movq	$-2, %r10
	movl	$256, %r11d                     # imm = 0x100
	vpxor	%xmm5, %xmm5, %xmm5
	vpxor	%xmm4, %xmm4, %xmm4
	vpxor	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB9_15:                               #   Parent Loop BB9_14 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	prefetcht0	(%r9,%r11,8)
	prefetcht0	32(%r9,%r11,8)
	vpbroadcastd	8(%rsi,%r10,4), %ymm6
	vpmovsxbw	-1024(%r9,%r11,4), %ymm7
	vpmovsxbw	-1008(%r9,%r11,4), %ymm8
	vpmovsxbw	(%r9,%r11,4), %ymm9
	vpmovsxbw	16(%r9,%r11,4), %ymm10
	vpmaddwd	%ymm7, %ymm6, %ymm7
	vpaddd	%ymm3, %ymm7, %ymm3
	vpmaddwd	%ymm6, %ymm8, %ymm7
	vpaddd	%ymm5, %ymm7, %ymm5
	vpmaddwd	%ymm6, %ymm9, %ymm7
	vpaddd	%ymm4, %ymm7, %ymm4
	vpmaddwd	%ymm6, %ymm10, %ymm6
	vpbroadcastd	12(%rsi,%r10,4), %ymm7
	vpmovsxbw	-992(%r9,%r11,4), %ymm8
	vpmovsxbw	-976(%r9,%r11,4), %ymm9
	vpmovsxbw	32(%r9,%r11,4), %ymm10
	vpmovsxbw	48(%r9,%r11,4), %ymm11
	vpaddd	%ymm2, %ymm6, %ymm2
	vpmaddwd	%ymm7, %ymm8, %ymm6
	vpaddd	%ymm6, %ymm3, %ymm3
	vpmaddwd	%ymm7, %ymm9, %ymm6
	vpaddd	%ymm6, %ymm5, %ymm5
	vpmaddwd	%ymm7, %ymm10, %ymm6
	vpaddd	%ymm6, %ymm4, %ymm4
	vpmaddwd	%ymm7, %ymm11, %ymm6
	vpaddd	%ymm6, %ymm2, %ymm2
	addq	$2, %r10
	addq	$16, %r11
	cmpq	$30, %r10
	jb	.LBB9_15
# %bb.16:                               #   in Loop: Header=BB9_14 Depth=1
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vcvtdq2ps	%ymm5, %ymm5
	vmulps	%ymm5, %ymm1, %ymm5
	vcvtdq2ps	%ymm4, %ymm4
	vmulps	%ymm4, %ymm1, %ymm4
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm3, (%rax)
	vmovaps	%ymm5, 32(%rax)
	vmovaps	%ymm4, 64(%rax)
	vmovaps	%ymm2, 96(%rax)
	vmaxps	%ymm5, %ymm3, %ymm3
	vmaxps	%ymm2, %ymm4, %ymm2
	vmaxps	%ymm2, %ymm3, %ymm2
	vmaxps	%ymm2, %ymm0, %ymm0
	incl	%r8d
	subq	$-128, %rax
	movq	%rdi, %r9
	cmpl	%ecx, %r8d
	jne	.LBB9_14
# %bb.2:
	movl	%edx, %r8d
	andl	$31, %r8d
	jne	.LBB9_3
	jmp	.LBB9_23
.LBB9_1:
	vbroadcastss	.LCPI9_0(%rip), %ymm0   # ymm0 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_scE, %eax
	movl	%edx, %r8d
	andl	$31, %r8d
	je	.LBB9_23
.LBB9_3:
	movl	%edx, %ecx
	andl	$-32, %ecx
	addl	$15, %r8d
	vxorps	%xmm2, %xmm2, %xmm2
	xorl	%r9d, %r9d
	vxorps	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB9_4:                                # =>This Inner Loop Header: Depth=1
	vpbroadcastd	(%rsi,%r9), %ymm4
	vpmovsxbw	(%rdi,%r9,8), %ymm5
	vpmovsxbw	16(%rdi,%r9,8), %ymm6
	vpmaddwd	%ymm5, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm6, %ymm4, %ymm4
	vpaddd	%ymm2, %ymm4, %ymm2
	vpbroadcastd	4(%rsi,%r9), %ymm4
	vpmovsxbw	32(%rdi,%r9,8), %ymm5
	vpmovsxbw	48(%rdi,%r9,8), %ymm6
	vpmaddwd	%ymm5, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm6, %ymm4, %ymm4
	vpaddd	%ymm2, %ymm4, %ymm2
	addq	$8, %r9
	cmpq	$128, %r9
	jne	.LBB9_4
# %bb.5:
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm3, (%rax)
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm2
	vmovaps	%ymm2, 32(%rax)
	andl	$-16, %r8d
	cmpl	$16, %r8d
	je	.LBB9_9
# %bb.6:
	vxorps	%xmm2, %xmm2, %xmm2
	movl	$4, %r8d
	vxorps	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB9_7:                                # =>This Inner Loop Header: Depth=1
	vpbroadcastd	-4(%rsi,%r8), %ymm4
	vpmovsxbw	992(%rdi,%r8,8), %ymm5
	vpmovsxbw	1008(%rdi,%r8,8), %ymm6
	vpmaddwd	%ymm5, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm6, %ymm4, %ymm4
	vpaddd	%ymm2, %ymm4, %ymm2
	vpbroadcastd	(%rsi,%r8), %ymm4
	vpmovsxbw	1024(%rdi,%r8,8), %ymm5
	vpmovsxbw	1040(%rdi,%r8,8), %ymm6
	vpmaddwd	%ymm5, %ymm4, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm3
	vpmaddwd	%ymm6, %ymm4, %ymm4
	vpaddd	%ymm2, %ymm4, %ymm2
	addq	$8, %r8
	cmpq	$132, %r8
	jne	.LBB9_7
# %bb.8:
	vcvtdq2ps	%ymm3, %ymm3
	vmulps	%ymm3, %ymm1, %ymm3
	vmovaps	%ymm3, 64(%rax)
	vcvtdq2ps	%ymm2, %ymm2
	vmulps	%ymm2, %ymm1, %ymm1
	vmovaps	%ymm1, 96(%rax)
.LBB9_9:
	leal	31(%rdx), %esi
	andl	$-32, %esi
	movslq	%esi, %rax
	cmpl	%edx, %esi
	jle	.LBB9_20
# %bb.10:
	movslq	%edx, %rdi
	movq	%rax, %r8
	subq	%rdi, %r8
	cmpq	$32, %r8
	jae	.LBB9_17
# %bb.11:
	movq	%rdi, %rdx
	jmp	.LBB9_12
.LBB9_17:
	movq	%r8, %r9
	andq	$-32, %r9
	leaq	(%r9,%rdi), %rdx
	xorl	%r10d, %r10d
	shlq	$2, %rdi
	vbroadcastss	.LCPI9_0(%rip), %ymm1   # ymm1 = [-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf,-Inf]
	.p2align	4, 0x90
.LBB9_18:                               # =>This Inner Loop Header: Depth=1
	vmovups	%ymm1, _ZN3fx23opt12_GLOBAL__N_14g_scE(%rdi,%r10,4)
	vmovups	%ymm1, _ZN3fx23opt12_GLOBAL__N_14g_scE+32(%rdi,%r10,4)
	vmovups	%ymm1, _ZN3fx23opt12_GLOBAL__N_14g_scE+64(%rdi,%r10,4)
	vmovups	%ymm1, _ZN3fx23opt12_GLOBAL__N_14g_scE+96(%rdi,%r10,4)
	addq	$32, %r10
	cmpq	%r10, %r9
	jne	.LBB9_18
# %bb.19:
	cmpq	%r9, %r8
	je	.LBB9_20
	.p2align	4, 0x90
.LBB9_12:                               # =>This Inner Loop Header: Depth=1
	movl	$-8388608, _ZN3fx23opt12_GLOBAL__N_14g_scE(,%rdx,4) # imm = 0xFF800000
	incq	%rdx
	cmpq	%rdx, %rax
	jne	.LBB9_12
.LBB9_20:
	cmpl	%esi, %ecx
	jge	.LBB9_23
# %bb.21:
	movslq	%ecx, %rcx
	.p2align	4, 0x90
.LBB9_22:                               # =>This Inner Loop Header: Depth=1
	vmaxps	_ZN3fx23opt12_GLOBAL__N_14g_scE(,%rcx,4), %ymm0, %ymm0
	addq	$8, %rcx
	cmpq	%rax, %rcx
	jl	.LBB9_22
.LBB9_23:
	vextractf128	$1, %ymm0, %xmm1
	vmaxps	%xmm1, %xmm0, %xmm0
	vshufpd	$3, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,1]
	vmaxps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vmaxss	%xmm1, %xmm0, %xmm0
	vzeroupper
	retq
.Lfunc_end9:
	.size	_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf, .Lfunc_end9-_ZN3fx23opt12_GLOBAL__N_17qk_scanILb0EaEEfPKT0_PKifiPf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
.LCPI10_0:
	.long	0x80000000                      # float -0
.LCPI10_1:
	.long	0x42b00000                      # float 88
.LCPI10_2:
	.long	0xc2aeac50                      # float -87.3365478
.LCPI10_3:
	.long	0x3f000000                      # float 0.5
.LCPI10_4:
	.long	0x3fb8aa3b                      # float 1.44269502
.LCPI10_5:
	.long	0x3f318000                      # float 0.693359375
.LCPI10_6:
	.long	0xb95e8083                      # float -2.12194442E-4
.LCPI10_7:
	.long	0x3e2aaaaa                      # float 0.166666657
.LCPI10_8:
	.long	0x3d2aa9c1                      # float 0.0416657962
.LCPI10_9:
	.long	0x3c088908                      # float 0.00833345205
.LCPI10_10:
	.long	0x3ab743ce                      # float 0.00139819994
.LCPI10_11:
	.long	0x39506967                      # float 1.98756912E-4
.LCPI10_12:
	.long	0x3f800000                      # float 1
.LCPI10_13:
	.long	0xbf318000                      # float -0.693359375
.LCPI10_14:
	.long	0x395e8083                      # float 2.12194442E-4
	.section	.text._ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi,"ax",@progbits
	.p2align	4, 0x90
	.type	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi,@function
_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi: # @_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
# %bb.0:
	subq	$648, %rsp                      # imm = 0x288
                                        # kill: def $edi killed $edi def $rdi
	vpbroadcastd	.LCPI10_0(%rip), %xmm2  # xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	vbroadcastss	%xmm0, %ymm4
	vpxor	%xmm2, %xmm1, %xmm0
	vpbroadcastd	%xmm0, %ymm8
	leal	7(%rdi), %eax
	sarl	$3, %eax
	movl	%edi, %ecx
	sarl	$3, %ecx
	cmpl	$32, %edi
	vmovups	%ymm4, 96(%rsp)                 # 32-byte Spill
	vmovdqu	%ymm8, 320(%rsp)                # 32-byte Spill
	jge	.LBB10_13
# %bb.1:
	vxorps	%xmm7, %xmm7, %xmm7
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	xorl	%edx, %edx
	vpxor	%xmm0, %xmm0, %xmm0
	cmpl	%eax, %edx
	vmovups	%ymm7, -128(%rsp)               # 32-byte Spill
	vmovdqu	%ymm1, -32(%rsp)                # 32-byte Spill
	jl	.LBB10_4
	jmp	.LBB10_8
.LBB10_13:
	movslq	%ecx, %r8
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vpxor	%xmm2, %xmm2, %xmm2
	xorl	%r9d, %r9d
	vbroadcastss	.LCPI10_1(%rip), %ymm0  # ymm0 = [8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1]
	vmovups	%ymm0, (%rsp)                   # 32-byte Spill
	vbroadcastss	.LCPI10_2(%rip), %ymm0  # ymm0 = [-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1]
	vmovups	%ymm0, 288(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_3(%rip), %ymm0  # ymm0 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1]
	vmovups	%ymm0, 448(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_4(%rip), %ymm0  # ymm0 = [1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0]
	vmovups	%ymm0, 256(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_5(%rip), %ymm0  # ymm0 = [6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1]
	vmovups	%ymm0, 224(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_6(%rip), %ymm0  # ymm0 = [-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4]
	vmovups	%ymm0, 192(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_7(%rip), %ymm0  # ymm0 = [1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1]
	vmovups	%ymm0, -64(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_8(%rip), %ymm0  # ymm0 = [4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2]
	vmovups	%ymm0, 160(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_9(%rip), %ymm0  # ymm0 = [8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3]
	vmovups	%ymm0, -96(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_10(%rip), %ymm0 # ymm0 = [1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3]
	vmovups	%ymm0, 128(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_11(%rip), %ymm0 # ymm0 = [1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4]
	vmovups	%ymm0, 416(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_12(%rip), %ymm0 # ymm0 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	vmovups	%ymm0, 384(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_12(%rip), %ymm0 # ymm0 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	vmovups	%ymm0, 352(%rsp)                # 32-byte Spill
	xorl	%edx, %edx
	vxorps	%xmm7, %xmm7, %xmm7
	.p2align	4, 0x90
.LBB10_14:                              # =>This Inner Loop Header: Depth=1
	vmovdqu	%ymm1, -32(%rsp)                # 32-byte Spill
	vmovups	%ymm7, -128(%rsp)               # 32-byte Spill
	vmovdqu	%ymm2, 608(%rsp)                # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE(%r9), %ymm3
	vsubps	%ymm4, %ymm3, %ymm0
	vmovups	%ymm0, 576(%rsp)                # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE+32(%r9), %ymm3
	vsubps	%ymm4, %ymm3, %ymm8
	vmovups	%ymm8, 512(%rsp)                # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE+64(%r9), %ymm3
	vsubps	%ymm4, %ymm3, %ymm1
	vmovups	%ymm1, 32(%rsp)                 # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE+96(%r9), %ymm3
	vsubps	%ymm4, %ymm3, %ymm2
	vmovups	%ymm2, 64(%rsp)                 # 32-byte Spill
	vmovups	(%rsp), %ymm1                   # 32-byte Reload
	vminps	%ymm1, %ymm0, %ymm3
	vmovaps	%ymm1, %ymm7
	vmovups	288(%rsp), %ymm2                # 32-byte Reload
	vmaxps	%ymm2, %ymm3, %ymm3
	vmovups	256(%rsp), %ymm10               # 32-byte Reload
	vmovaps	%ymm10, %ymm4
	vmovups	448(%rsp), %ymm0                # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm3, %ymm4     # ymm4 = (ymm3 * ymm4) + ymm0
	vroundps	$1, %ymm4, %ymm4
	vmovups	%ymm4, 544(%rsp)                # 32-byte Spill
	vmovups	224(%rsp), %ymm5                # 32-byte Reload
	vfnmadd231ps	%ymm5, %ymm4, %ymm3     # ymm3 = -(ymm4 * ymm5) + ymm3
	vmovups	192(%rsp), %ymm12               # 32-byte Reload
	vfnmadd231ps	%ymm12, %ymm4, %ymm3    # ymm3 = -(ymm4 * ymm12) + ymm3
	vmulps	%ymm3, %ymm3, %ymm4
	vmulps	%ymm4, %ymm4, %ymm6
	vmovups	-64(%rsp), %ymm9                # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm3, %ymm9     # ymm9 = (ymm3 * ymm9) + ymm0
	vmovups	-96(%rsp), %ymm13               # 32-byte Reload
	vmovups	160(%rsp), %ymm1                # 32-byte Reload
	vfmadd213ps	%ymm1, %ymm3, %ymm13    # ymm13 = (ymm3 * ymm13) + ymm1
	vmovups	416(%rsp), %ymm11               # 32-byte Reload
	vmovaps	%ymm11, %ymm15
	vmovaps	%ymm11, %ymm14
	vfmadd213ps	128(%rsp), %ymm3, %ymm15 # 32-byte Folded Reload
                                        # ymm15 = (ymm3 * ymm15) + mem
	vfmadd213ps	%ymm9, %ymm4, %ymm13    # ymm13 = (ymm4 * ymm13) + ymm9
	vfmadd231ps	%ymm15, %ymm6, %ymm13   # ymm13 = (ymm6 * ymm15) + ymm13
	vfmadd213ps	%ymm3, %ymm4, %ymm13    # ymm13 = (ymm4 * ymm13) + ymm3
	vminps	%ymm7, %ymm8, %ymm3
	vmovaps	%ymm7, %ymm8
	vmaxps	%ymm2, %ymm3, %ymm6
	vmovaps	%ymm2, %ymm7
	vfmadd213ps	%ymm0, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm0
	vroundps	$1, %ymm10, %ymm2
	vmovups	%ymm2, 480(%rsp)                # 32-byte Spill
	vfnmadd231ps	%ymm5, %ymm2, %ymm6     # ymm6 = -(ymm2 * ymm5) + ymm6
	vfnmadd231ps	%ymm12, %ymm2, %ymm6    # ymm6 = -(ymm2 * ymm12) + ymm6
	vmulps	%ymm6, %ymm6, %ymm9
	vmulps	%ymm9, %ymm9, %ymm15
	vmovups	-64(%rsp), %ymm4                # 32-byte Reload
	vmovaps	%ymm4, %ymm11
	vfmadd213ps	%ymm0, %ymm6, %ymm11    # ymm11 = (ymm6 * ymm11) + ymm0
	vmovups	-96(%rsp), %ymm2                # 32-byte Reload
	vmovaps	%ymm2, %ymm3
	vfmadd213ps	%ymm1, %ymm6, %ymm3     # ymm3 = (ymm6 * ymm3) + ymm1
	vmovaps	%ymm14, %ymm10
	vmovaps	%ymm14, %ymm5
	vmovups	128(%rsp), %ymm1                # 32-byte Reload
	vfmadd213ps	%ymm1, %ymm6, %ymm10    # ymm10 = (ymm6 * ymm10) + ymm1
	vfmadd213ps	%ymm11, %ymm9, %ymm3    # ymm3 = (ymm9 * ymm3) + ymm11
	vfmadd231ps	%ymm10, %ymm15, %ymm3   # ymm3 = (ymm15 * ymm10) + ymm3
	vfmadd213ps	%ymm6, %ymm9, %ymm3     # ymm3 = (ymm9 * ymm3) + ymm6
	vmovups	32(%rsp), %ymm6                 # 32-byte Reload
	vminps	%ymm8, %ymm6, %ymm6
	vmaxps	%ymm7, %ymm6, %ymm10
	vmovups	256(%rsp), %ymm7                # 32-byte Reload
	vmovaps	%ymm7, %ymm6
	vfmadd213ps	%ymm0, %ymm10, %ymm6    # ymm6 = (ymm10 * ymm6) + ymm0
	vroundps	$1, %ymm6, %ymm9
	vmovups	224(%rsp), %ymm8                # 32-byte Reload
	vfnmadd231ps	%ymm8, %ymm9, %ymm10    # ymm10 = -(ymm9 * ymm8) + ymm10
	vfnmadd231ps	%ymm12, %ymm9, %ymm10   # ymm10 = -(ymm9 * ymm12) + ymm10
	vmulps	%ymm10, %ymm10, %ymm11
	vmulps	%ymm11, %ymm11, %ymm15
	vmovaps	%ymm4, %ymm14
	vfmadd213ps	%ymm0, %ymm10, %ymm14   # ymm14 = (ymm10 * ymm14) + ymm0
	vmovaps	%ymm2, %ymm6
	vmovups	160(%rsp), %ymm4                # 32-byte Reload
	vfmadd213ps	%ymm4, %ymm10, %ymm6    # ymm6 = (ymm10 * ymm6) + ymm4
	vmovaps	%ymm5, %ymm12
	vfmadd213ps	%ymm1, %ymm10, %ymm12   # ymm12 = (ymm10 * ymm12) + ymm1
	vfmadd213ps	%ymm14, %ymm11, %ymm6   # ymm6 = (ymm11 * ymm6) + ymm14
	vfmadd231ps	%ymm12, %ymm15, %ymm6   # ymm6 = (ymm15 * ymm12) + ymm6
	vfmadd213ps	%ymm10, %ymm11, %ymm6   # ymm6 = (ymm11 * ymm6) + ymm10
	vmovups	64(%rsp), %ymm10                # 32-byte Reload
	vminps	(%rsp), %ymm10, %ymm10          # 32-byte Folded Reload
	vmaxps	288(%rsp), %ymm10, %ymm10       # 32-byte Folded Reload
	vmovups	608(%rsp), %ymm2                # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm10, %ymm7    # ymm7 = (ymm10 * ymm7) + ymm0
	vroundps	$1, %ymm7, %ymm11
	vfnmadd231ps	%ymm8, %ymm11, %ymm10   # ymm10 = -(ymm11 * ymm8) + ymm10
	vfnmadd231ps	192(%rsp), %ymm11, %ymm10 # 32-byte Folded Reload
                                        # ymm10 = -(ymm11 * mem) + ymm10
	vmulps	%ymm10, %ymm10, %ymm12
	vmovups	-64(%rsp), %ymm14               # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm10, %ymm14   # ymm14 = (ymm10 * ymm14) + ymm0
	vmovups	-96(%rsp), %ymm15               # 32-byte Reload
	vfmadd213ps	%ymm4, %ymm10, %ymm15   # ymm15 = (ymm10 * ymm15) + ymm4
	vfmadd213ps	%ymm14, %ymm12, %ymm15  # ymm15 = (ymm12 * ymm15) + ymm14
	vfmadd213ps	%ymm1, %ymm10, %ymm5    # ymm5 = (ymm10 * ymm5) + ymm1
	vmulps	%ymm12, %ymm12, %ymm1
	vfmadd231ps	%ymm5, %ymm1, %ymm15    # ymm15 = (ymm1 * ymm5) + ymm15
	vfmadd213ps	%ymm10, %ymm12, %ymm15  # ymm15 = (ymm12 * ymm15) + ymm10
	vmovups	-128(%rsp), %ymm7               # 32-byte Reload
	vmovups	320(%rsp), %ymm8                # 32-byte Reload
	vmovups	384(%rsp), %ymm10               # 32-byte Reload
	vaddps	%ymm10, %ymm13, %ymm1
	vcvtps2dq	544(%rsp), %ymm5        # 32-byte Folded Reload
	vpslld	$23, %ymm5, %ymm5
	vmovdqu	352(%rsp), %ymm12               # 32-byte Reload
	vpaddd	%ymm5, %ymm12, %ymm5
	vmulps	%ymm5, %ymm1, %ymm1
	vaddps	%ymm3, %ymm10, %ymm3
	vcvtps2dq	480(%rsp), %ymm4        # 32-byte Folded Reload
	vpslld	$23, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm12, %ymm4
	vmulps	%ymm4, %ymm3, %ymm3
	vaddps	%ymm6, %ymm10, %ymm4
	vcvtps2dq	%ymm9, %ymm5
	vpslld	$23, %ymm5, %ymm5
	vpaddd	%ymm5, %ymm12, %ymm5
	vmulps	%ymm5, %ymm4, %ymm4
	vaddps	%ymm10, %ymm15, %ymm5
	vcvtps2dq	%ymm11, %ymm6
	vpslld	$23, %ymm6, %ymm6
	vpaddd	%ymm6, %ymm12, %ymm6
	vmulps	%ymm6, %ymm5, %ymm5
	vcmpleps	576(%rsp), %ymm8, %ymm6         # 32-byte Folded Reload
	vcmpleps	512(%rsp), %ymm8, %ymm9         # 32-byte Folded Reload
	vandps	%ymm6, %ymm1, %ymm1
	vandps	%ymm3, %ymm9, %ymm3
	vmovaps	%ymm1, _ZN3fx23opt12_GLOBAL__N_14g_ebE(%r9)
	vmovaps	%ymm3, _ZN3fx23opt12_GLOBAL__N_14g_ebE+32(%r9)
	vaddps	%ymm3, %ymm1, %ymm1
	vaddps	%ymm1, %ymm2, %ymm2
	vcmpleps	32(%rsp), %ymm8, %ymm1          # 32-byte Folded Reload
	vcmpleps	64(%rsp), %ymm8, %ymm3          # 32-byte Folded Reload
	vandps	%ymm1, %ymm4, %ymm4
	vandps	%ymm3, %ymm5, %ymm5
	vmovaps	%ymm4, _ZN3fx23opt12_GLOBAL__N_14g_ebE+64(%r9)
	vmovaps	%ymm5, _ZN3fx23opt12_GLOBAL__N_14g_ebE+96(%r9)
	vaddps	%ymm5, %ymm4, %ymm4
	vaddps	%ymm4, %ymm7, %ymm7
	vandps	-32(%rsp), %ymm6, %ymm4         # 32-byte Folded Reload
	vandps	%ymm1, %ymm9, %ymm1
	vandps	%ymm1, %ymm4, %ymm1
	vmovups	96(%rsp), %ymm4                 # 32-byte Reload
	vandps	%ymm3, %ymm1, %ymm1
	movq	%rdx, %r10
	addq	$4, %rdx
	subq	$-128, %r9
	addq	$8, %r10
	cmpq	%r8, %r10
	jle	.LBB10_14
# %bb.2:
	vmovdqa	%ymm2, %ymm0
	cmpl	%eax, %edx
	vmovups	%ymm7, -128(%rsp)               # 32-byte Spill
	vmovdqu	%ymm1, -32(%rsp)                # 32-byte Spill
	jge	.LBB10_8
.LBB10_4:
	movl	%edx, %edx
	movslq	%ecx, %rcx
	movl	%eax, %r8d
	movq	%rdx, %r9
	shlq	$5, %r9
	vbroadcastss	.LCPI10_1(%rip), %ymm1  # ymm1 = [8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1]
	vmovups	%ymm1, -64(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_2(%rip), %ymm1  # ymm1 = [-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1]
	vmovups	%ymm1, -96(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI10_3(%rip), %ymm3  # ymm3 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1]
	vbroadcastss	.LCPI10_4(%rip), %ymm1  # ymm1 = [1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0]
	vmovups	%ymm1, 64(%rsp)                 # 32-byte Spill
	vbroadcastss	.LCPI10_13(%rip), %ymm1 # ymm1 = [-6.93359375E-1,-6.93359375E-1,-6.93359375E-1,-6.93359375E-1,-6.93359375E-1,-6.93359375E-1,-6.93359375E-1,-6.93359375E-1]
	vmovups	%ymm1, 32(%rsp)                 # 32-byte Spill
	vbroadcastss	.LCPI10_14(%rip), %ymm1 # ymm1 = [2.12194442E-4,2.12194442E-4,2.12194442E-4,2.12194442E-4,2.12194442E-4,2.12194442E-4,2.12194442E-4,2.12194442E-4]
	vmovups	%ymm1, (%rsp)                   # 32-byte Spill
	vbroadcastss	.LCPI10_7(%rip), %ymm1  # ymm1 = [1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1]
	vbroadcastss	.LCPI10_8(%rip), %ymm8  # ymm8 = [4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2]
	vbroadcastss	.LCPI10_9(%rip), %ymm6  # ymm6 = [8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3]
	vbroadcastss	.LCPI10_10(%rip), %ymm10 # ymm10 = [1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3]
	vbroadcastss	.LCPI10_11(%rip), %ymm11 # ymm11 = [1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4]
	vbroadcastss	.LCPI10_12(%rip), %ymm12 # ymm12 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	vpbroadcastd	.LCPI10_12(%rip), %ymm13 # ymm13 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	jmp	.LBB10_5
	.p2align	4, 0x90
.LBB10_7:                               #   in Loop: Header=BB10_5 Depth=1
	vmovups	96(%rsp), %ymm4                 # 32-byte Reload
	vaddps	%ymm0, %ymm14, %ymm0
	incq	%rdx
	addq	$32, %r9
	cmpq	%rdx, %r8
	je	.LBB10_8
.LBB10_5:                               # =>This Inner Loop Header: Depth=1
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE(%r9), %ymm14
	vsubps	%ymm4, %ymm14, %ymm14
	vminps	-64(%rsp), %ymm14, %ymm15       # 32-byte Folded Reload
	vmaxps	-96(%rsp), %ymm15, %ymm15       # 32-byte Folded Reload
	vmovups	64(%rsp), %ymm4                 # 32-byte Reload
	vfmadd213ps	%ymm3, %ymm15, %ymm4    # ymm4 = (ymm15 * ymm4) + ymm3
	vroundps	$1, %ymm4, %ymm4
	vfmadd231ps	32(%rsp), %ymm4, %ymm15 # 32-byte Folded Reload
                                        # ymm15 = (ymm4 * mem) + ymm15
	vfmadd231ps	(%rsp), %ymm4, %ymm15   # 32-byte Folded Reload
                                        # ymm15 = (ymm4 * mem) + ymm15
	vmulps	%ymm15, %ymm15, %ymm2
	vmulps	%ymm2, %ymm2, %ymm5
	vmovaps	%ymm1, %ymm7
	vfmadd213ps	%ymm3, %ymm15, %ymm7    # ymm7 = (ymm15 * ymm7) + ymm3
	vmovaps	%ymm6, %ymm9
	vfmadd213ps	%ymm8, %ymm15, %ymm9    # ymm9 = (ymm15 * ymm9) + ymm8
	vfmadd213ps	%ymm7, %ymm2, %ymm9     # ymm9 = (ymm2 * ymm9) + ymm7
	vmovaps	%ymm11, %ymm7
	vfmadd213ps	%ymm10, %ymm15, %ymm7   # ymm7 = (ymm15 * ymm7) + ymm10
	vfmadd231ps	%ymm7, %ymm5, %ymm9     # ymm9 = (ymm5 * ymm7) + ymm9
	vfmadd213ps	%ymm15, %ymm2, %ymm9    # ymm9 = (ymm2 * ymm9) + ymm15
	vaddps	%ymm12, %ymm9, %ymm2
	vcvtps2dq	%ymm4, %ymm4
	vpslld	$23, %ymm4, %ymm4
	vpaddd	%ymm4, %ymm13, %ymm4
	vmulps	%ymm4, %ymm2, %ymm2
	vmovups	320(%rsp), %ymm4                # 32-byte Reload
	vcmpleps	%ymm14, %ymm4, %ymm15
	vandps	%ymm2, %ymm15, %ymm14
	vmovaps	%ymm14, _ZN3fx23opt12_GLOBAL__N_14g_ebE(%r9)
	cmpq	%rcx, %rdx
	jge	.LBB10_7
# %bb.6:                                #   in Loop: Header=BB10_5 Depth=1
	vmovups	-32(%rsp), %ymm2                # 32-byte Reload
	vandps	%ymm2, %ymm15, %ymm2
	vmovups	%ymm2, -32(%rsp)                # 32-byte Spill
	jmp	.LBB10_7
.LBB10_8:
	vpcmpeqd	%ymm1, %ymm1, %ymm1
	vmovups	-32(%rsp), %ymm2                # 32-byte Reload
	vtestps	%ymm1, %ymm2
	jb	.LBB10_20
# %bb.9:
	testl	%edi, %edi
	jle	.LBB10_10
# %bb.15:
	cmpl	$2, %eax
	movl	$1, %edx
	cmovgel	%eax, %edx
	movl	%edx, %eax
	andl	$3, %eax
	cmpl	$4, %edx
	jae	.LBB10_29
# %bb.16:
	vpxor	%xmm1, %xmm1, %xmm1
	xorl	%ecx, %ecx
	vmovups	-128(%rsp), %ymm8               # 32-byte Reload
	jmp	.LBB10_17
.LBB10_20:
	movl	%edi, %r8d
	andl	$-8, %r8d
	cmpl	%edi, %r8d
	jge	.LBB10_21
# %bb.22:
	movslq	%r8d, %r9
	movslq	%edi, %rax
	movq	%rax, %rdx
	subq	%r9, %rdx
	cmpq	$32, %rdx
	vmovups	-128(%rsp), %ymm8               # 32-byte Reload
	jae	.LBB10_24
# %bb.23:
	movq	%r9, %rcx
	jmp	.LBB10_27
.LBB10_10:
	vpxor	%xmm1, %xmm1, %xmm1
	vmovups	-128(%rsp), %ymm8               # 32-byte Reload
	jmp	.LBB10_11
.LBB10_29:
	andl	$2147483644, %edx               # imm = 0x7FFFFFFC
	vxorps	%xmm2, %xmm2, %xmm2
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_ebE+96, %edi
	xorl	%ecx, %ecx
	vpxor	%xmm1, %xmm1, %xmm1
	vmovups	-128(%rsp), %ymm8               # 32-byte Reload
	.p2align	4, 0x90
.LBB10_30:                              # =>This Inner Loop Header: Depth=1
	vcmpneq_oqps	-96(%rdi), %ymm2, %ymm3
	vpsubd	%ymm3, %ymm1, %ymm1
	vcmpneq_oqps	-64(%rdi), %ymm2, %ymm3
	vcmpneq_oqps	-32(%rdi), %ymm2, %ymm4
	vpsubd	%ymm3, %ymm1, %ymm1
	vpsubd	%ymm4, %ymm1, %ymm1
	vcmpneq_oqps	(%rdi), %ymm2, %ymm3
	vpsubd	%ymm3, %ymm1, %ymm1
	addq	$4, %rcx
	subq	$-128, %rdi
	cmpq	%rcx, %rdx
	jne	.LBB10_30
.LBB10_17:
	testq	%rax, %rax
	je	.LBB10_11
# %bb.18:
	shlq	$5, %rcx
	shlq	$5, %rax
	xorl	%edx, %edx
	vxorps	%xmm2, %xmm2, %xmm2
	.p2align	4, 0x90
.LBB10_19:                              # =>This Inner Loop Header: Depth=1
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx,%rdx), %ymm2, %ymm3
	vpsubd	%ymm3, %ymm1, %ymm1
	addq	$32, %rdx
	cmpq	%rdx, %rax
	jne	.LBB10_19
.LBB10_11:
	vextracti128	$1, %ymm1, %xmm2
	vpaddd	%xmm1, %xmm2, %xmm1
	vpshufd	$78, %xmm1, %xmm2               # xmm2 = xmm1[2,3,0,1]
	vpaddd	%xmm1, %xmm2, %xmm1
	vpshufd	$85, %xmm1, %xmm2               # xmm2 = xmm1[1,1,1,1]
	vpaddd	%xmm1, %xmm2, %xmm1
	vmovd	%xmm1, %r8d
	jmp	.LBB10_12
.LBB10_21:
	vmovups	-128(%rsp), %ymm8               # 32-byte Reload
	jmp	.LBB10_12
.LBB10_24:
	movq	%rdx, %rdi
	andq	$-32, %rdi
	leaq	(%rdi,%r9), %rcx
	vmovd	%r8d, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	xorl	%r8d, %r8d
	shlq	$2, %r9
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB10_25:                              # =>This Inner Loop Header: Depth=1
	vcmpneqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%r9,%r8,4), %ymm2, %ymm6
	vpsubd	%ymm6, %ymm1, %ymm1
	vcmpneqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+32(%r9,%r8,4), %ymm2, %ymm6
	vpsubd	%ymm6, %ymm3, %ymm3
	vcmpneqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+64(%r9,%r8,4), %ymm2, %ymm6
	vcmpneqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+96(%r9,%r8,4), %ymm2, %ymm7
	vpsubd	%ymm6, %ymm4, %ymm4
	vpsubd	%ymm7, %ymm5, %ymm5
	addq	$32, %r8
	cmpq	%r8, %rdi
	jne	.LBB10_25
# %bb.26:
	vpaddd	%ymm1, %ymm3, %ymm1
	vpaddd	%ymm4, %ymm5, %ymm2
	vpaddd	%ymm1, %ymm2, %ymm1
	vextracti128	$1, %ymm1, %xmm2
	vpaddd	%xmm2, %xmm1, %xmm1
	vpshufd	$238, %xmm1, %xmm2              # xmm2 = xmm1[2,3,2,3]
	vpaddd	%xmm2, %xmm1, %xmm1
	vpshufd	$85, %xmm1, %xmm2               # xmm2 = xmm1[1,1,1,1]
	vpaddd	%xmm2, %xmm1, %xmm1
	vmovd	%xmm1, %r8d
	cmpq	%rdi, %rdx
	je	.LBB10_12
.LBB10_27:
	vpxor	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB10_28:                              # =>This Inner Loop Header: Depth=1
	vcmpneqss	_ZN3fx23opt12_GLOBAL__N_14g_ebE(,%rcx,4), %xmm1, %xmm2
	vmovd	%xmm2, %edx
	subl	%edx, %r8d
	incq	%rcx
	cmpq	%rcx, %rax
	jne	.LBB10_28
.LBB10_12:
	movl	%r8d, (%rsi)
	vaddps	%ymm0, %ymm8, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vaddps	%xmm1, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	addq	$648, %rsp                      # imm = 0x288
	vzeroupper
	retq
.Lfunc_end10:
	.size	_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi, .Lfunc_end10-_ZN3fx23opt12_GLOBAL__N_18exp_passILb0EEEfPKfiffPfRi
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
	.type	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf,@function
_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf: # @_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	testl	%esi, %esi
	jle	.LBB11_1
# %bb.3:
	addl	$7, %esi
	shrl	$3, %esi
	vxorps	%xmm9, %xmm9, %xmm9
	xorl	%eax, %eax
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	jmp	.LBB11_4
	.p2align	4, 0x90
.LBB11_7:                               #   in Loop: Header=BB11_4 Depth=1
	incq	%rax
	cmpq	%rsi, %rax
	je	.LBB11_2
.LBB11_4:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB11_6 Depth 2
	movq	%rax, %rcx
	shlq	$5, %rcx
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx), %ymm9, %ymm10
	vmovmskps	%ymm10, %r8d
	testl	%r8d, %r8d
	je	.LBB11_7
# %bb.5:                                #   in Loop: Header=BB11_4 Depth=1
	leaq	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx), %rcx
	movzbl	%r8b, %r8d
	movq	%rax, %r9
	shlq	$9, %r9
	addq	%rdi, %r9
	.p2align	4, 0x90
.LBB11_6:                               #   Parent Loop BB11_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	tzcntl	%r8d, %r11d
	movq	%r11, %r10
	shlq	$6, %r10
	blsrl	%r8d, %r8d
	prefetcht0	512(%r9,%r10)
	vbroadcastss	(%rcx,%r11,4), %ymm10
	vpmovsxbd	(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm8   # ymm8 = (ymm10 * ymm11) + ymm8
	vpmovsxbd	8(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm7   # ymm7 = (ymm10 * ymm11) + ymm7
	vpmovsxbd	16(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm6   # ymm6 = (ymm10 * ymm11) + ymm6
	vpmovsxbd	24(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm5   # ymm5 = (ymm10 * ymm11) + ymm5
	vpmovsxbd	32(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm4   # ymm4 = (ymm10 * ymm11) + ymm4
	vpmovsxbd	40(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm3   # ymm3 = (ymm10 * ymm11) + ymm3
	vpmovsxbd	48(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm2   # ymm2 = (ymm10 * ymm11) + ymm2
	vpmovsxbd	56(%r9,%r10), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm10, %ymm1   # ymm1 = (ymm10 * ymm11) + ymm1
	jne	.LBB11_6
	jmp	.LBB11_7
.LBB11_1:
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
.LBB11_2:
	vbroadcastss	%xmm0, %ymm0
	vmulps	%ymm0, %ymm8, %ymm8
	vmovaps	%ymm8, (%rdx)
	vmulps	%ymm7, %ymm0, %ymm7
	vmovaps	%ymm7, 32(%rdx)
	vmulps	%ymm6, %ymm0, %ymm6
	vmovaps	%ymm6, 64(%rdx)
	vmulps	%ymm5, %ymm0, %ymm5
	vmovaps	%ymm5, 96(%rdx)
	vmulps	%ymm4, %ymm0, %ymm4
	vmovaps	%ymm4, 128(%rdx)
	vmulps	%ymm3, %ymm0, %ymm3
	vmovaps	%ymm3, 160(%rdx)
	vmulps	%ymm2, %ymm0, %ymm2
	vmovaps	%ymm2, 192(%rdx)
	vmulps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 224(%rdx)
	vzeroupper
	retq
.Lfunc_end11:
	.size	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf, .Lfunc_end11-_ZN3fx23opt12_GLOBAL__N_19pv_sparseIaEEvPKT_PKfifPf
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
	.type	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf,@function
_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf: # @_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
# %bb.0:
	vmovaps	%xmm0, %xmm14
	movl	%esi, %eax
	sarl	%eax
	andl	$1, %esi
	movl	$_ZN3fx23opt12_GLOBAL__N_14g_ebE, %ecx
	#APP
	vxorps	%xmm0, %xmm0, %xmm0
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	testl	%eax, %eax
	je	.Ltmp0
	.p2align	4, 0x90
.Ltmp1:
	vbroadcastss	(%rcx), %ymm12
	vbroadcastss	4(%rcx), %ymm13
	prefetcht0	1024(%rdi)
	prefetcht0	1088(%rdi)
	vpmovsxbd	(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm0    # ymm0 = (ymm12 * ymm8) + ymm0
	vpmovsxbd	8(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm1    # ymm1 = (ymm12 * ymm9) + ymm1
	vpmovsxbd	16(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm2    # ymm2 = (ymm12 * ymm8) + ymm2
	vpmovsxbd	24(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm3    # ymm3 = (ymm12 * ymm9) + ymm3
	vpmovsxbd	32(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm4    # ymm4 = (ymm12 * ymm8) + ymm4
	vpmovsxbd	40(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm5    # ymm5 = (ymm12 * ymm9) + ymm5
	vpmovsxbd	48(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm6    # ymm6 = (ymm12 * ymm8) + ymm6
	vpmovsxbd	56(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm7    # ymm7 = (ymm12 * ymm9) + ymm7
	vpmovsxbd	64(%rdi), %ymm10
	vcvtdq2ps	%ymm10, %ymm10
	vfmadd231ps	%ymm10, %ymm13, %ymm0   # ymm0 = (ymm13 * ymm10) + ymm0
	vpmovsxbd	72(%rdi), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm13, %ymm1   # ymm1 = (ymm13 * ymm11) + ymm1
	vpmovsxbd	80(%rdi), %ymm10
	vcvtdq2ps	%ymm10, %ymm10
	vfmadd231ps	%ymm10, %ymm13, %ymm2   # ymm2 = (ymm13 * ymm10) + ymm2
	vpmovsxbd	88(%rdi), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm13, %ymm3   # ymm3 = (ymm13 * ymm11) + ymm3
	vpmovsxbd	96(%rdi), %ymm10
	vcvtdq2ps	%ymm10, %ymm10
	vfmadd231ps	%ymm10, %ymm13, %ymm4   # ymm4 = (ymm13 * ymm10) + ymm4
	vpmovsxbd	104(%rdi), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm13, %ymm5   # ymm5 = (ymm13 * ymm11) + ymm5
	vpmovsxbd	112(%rdi), %ymm10
	vcvtdq2ps	%ymm10, %ymm10
	vfmadd231ps	%ymm10, %ymm13, %ymm6   # ymm6 = (ymm13 * ymm10) + ymm6
	vpmovsxbd	120(%rdi), %ymm11
	vcvtdq2ps	%ymm11, %ymm11
	vfmadd231ps	%ymm11, %ymm13, %ymm7   # ymm7 = (ymm13 * ymm11) + ymm7
	addq	$128, %rdi
	addq	$8, %rcx
	decl	%eax
	jne	.Ltmp1
.Ltmp0:
	testl	%esi, %esi
	je	.Ltmp2
	vbroadcastss	(%rcx), %ymm12
	vpmovsxbd	(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm0    # ymm0 = (ymm12 * ymm8) + ymm0
	vpmovsxbd	8(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm1    # ymm1 = (ymm12 * ymm9) + ymm1
	vpmovsxbd	16(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm2    # ymm2 = (ymm12 * ymm8) + ymm2
	vpmovsxbd	24(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm3    # ymm3 = (ymm12 * ymm9) + ymm3
	vpmovsxbd	32(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm4    # ymm4 = (ymm12 * ymm8) + ymm4
	vpmovsxbd	40(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm5    # ymm5 = (ymm12 * ymm9) + ymm5
	vpmovsxbd	48(%rdi), %ymm8
	vcvtdq2ps	%ymm8, %ymm8
	vfmadd231ps	%ymm8, %ymm12, %ymm6    # ymm6 = (ymm12 * ymm8) + ymm6
	vpmovsxbd	56(%rdi), %ymm9
	vcvtdq2ps	%ymm9, %ymm9
	vfmadd231ps	%ymm9, %ymm12, %ymm7    # ymm7 = (ymm12 * ymm9) + ymm7
.Ltmp2:
	vbroadcastss	%xmm14, %ymm13
	vmulps	%ymm0, %ymm13, %ymm0
	vmulps	%ymm1, %ymm13, %ymm1
	vmulps	%ymm2, %ymm13, %ymm2
	vmulps	%ymm3, %ymm13, %ymm3
	vmulps	%ymm4, %ymm13, %ymm4
	vmulps	%ymm5, %ymm13, %ymm5
	vmulps	%ymm6, %ymm13, %ymm6
	vmulps	%ymm7, %ymm13, %ymm7
	vmovaps	%ymm0, (%rdx)
	vmovaps	%ymm1, 32(%rdx)
	vmovaps	%ymm2, 64(%rdx)
	vmovaps	%ymm3, 96(%rdx)
	vmovaps	%ymm4, 128(%rdx)
	vmovaps	%ymm5, 160(%rdx)
	vmovaps	%ymm6, 192(%rdx)
	vmovaps	%ymm7, 224(%rdx)

	#NO_APP
	vzeroupper
	retq
.Lfunc_end12:
	.size	_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf, .Lfunc_end12-_ZN3fx23opt12_GLOBAL__N_111pv_dense_i8EPKaPKfifPf
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
	.type	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf,@function
_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf: # @_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
# %bb.0:
                                        # kill: def $esi killed $esi def $rsi
	testl	%esi, %esi
	jle	.LBB13_1
# %bb.3:
	addl	$7, %esi
	shrl	$3, %esi
	vxorps	%xmm9, %xmm9, %xmm9
	xorl	%eax, %eax
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	jmp	.LBB13_4
	.p2align	4, 0x90
.LBB13_7:                               #   in Loop: Header=BB13_4 Depth=1
	incq	%rax
	cmpq	%rsi, %rax
	je	.LBB13_2
.LBB13_4:                               # =>This Loop Header: Depth=1
                                        #     Child Loop BB13_6 Depth 2
	movq	%rax, %rcx
	shlq	$5, %rcx
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx), %ymm9, %ymm10
	vmovmskps	%ymm10, %r8d
	testl	%r8d, %r8d
	je	.LBB13_7
# %bb.5:                                #   in Loop: Header=BB13_4 Depth=1
	leaq	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx), %rcx
	movzbl	%r8b, %r8d
	movq	%rax, %r9
	shlq	$11, %r9
	addq	%rdi, %r9
	.p2align	4, 0x90
.LBB13_6:                               #   Parent Loop BB13_4 Depth=1
                                        # =>  This Inner Loop Header: Depth=2
	tzcntl	%r8d, %r10d
	movl	%r10d, %r11d
	shll	$6, %r11d
	blsrl	%r8d, %r8d
	prefetcht0	2048(%r9,%r11,4)
	vbroadcastss	(%rcx,%r10,4), %ymm10
	vfmadd231ps	(%r9,%r11,4), %ymm10, %ymm8 # ymm8 = (ymm10 * mem) + ymm8
	vfmadd231ps	32(%r9,%r11,4), %ymm10, %ymm7 # ymm7 = (ymm10 * mem) + ymm7
	vfmadd231ps	64(%r9,%r11,4), %ymm10, %ymm6 # ymm6 = (ymm10 * mem) + ymm6
	vfmadd231ps	96(%r9,%r11,4), %ymm10, %ymm5 # ymm5 = (ymm10 * mem) + ymm5
	vfmadd231ps	128(%r9,%r11,4), %ymm10, %ymm4 # ymm4 = (ymm10 * mem) + ymm4
	vfmadd231ps	160(%r9,%r11,4), %ymm10, %ymm3 # ymm3 = (ymm10 * mem) + ymm3
	vfmadd231ps	192(%r9,%r11,4), %ymm10, %ymm2 # ymm2 = (ymm10 * mem) + ymm2
	vfmadd231ps	224(%r9,%r11,4), %ymm10, %ymm1 # ymm1 = (ymm10 * mem) + ymm1
	jne	.LBB13_6
	jmp	.LBB13_7
.LBB13_1:
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	vxorps	%xmm6, %xmm6, %xmm6
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
.LBB13_2:
	vbroadcastss	%xmm0, %ymm0
	vmulps	%ymm0, %ymm8, %ymm8
	vmovaps	%ymm8, (%rdx)
	vmulps	%ymm7, %ymm0, %ymm7
	vmovaps	%ymm7, 32(%rdx)
	vmulps	%ymm6, %ymm0, %ymm6
	vmovaps	%ymm6, 64(%rdx)
	vmulps	%ymm5, %ymm0, %ymm5
	vmovaps	%ymm5, 96(%rdx)
	vmulps	%ymm4, %ymm0, %ymm4
	vmovaps	%ymm4, 128(%rdx)
	vmulps	%ymm3, %ymm0, %ymm3
	vmovaps	%ymm3, 160(%rdx)
	vmulps	%ymm2, %ymm0, %ymm2
	vmovaps	%ymm2, 192(%rdx)
	vmulps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 224(%rdx)
	vzeroupper
	retq
.Lfunc_end13:
	.size	_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf, .Lfunc_end13-_ZN3fx23opt12_GLOBAL__N_19pv_sparseIfEEvPKT_PKfifPf
                                        # -- End function
	.section	.text._ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf,"ax",@progbits
	.p2align	4, 0x90                         # -- Begin function _ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
	.type	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf,@function
_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf: # @_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
# %bb.0:
	testl	%esi, %esi
	jle	.LBB14_1
# %bb.3:
	movl	%esi, %eax
	shlq	$2, %rax
	vxorps	%xmm6, %xmm6, %xmm6
	xorl	%ecx, %ecx
	vxorps	%xmm8, %xmm8, %xmm8
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm5, %xmm5, %xmm5
	.p2align	4, 0x90
.LBB14_4:                               # =>This Inner Loop Header: Depth=1
	prefetcht0	4096(%rdi)
	vbroadcastss	_ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx), %ymm9
	vfmadd231ps	(%rdi), %ymm9, %ymm6    # ymm6 = (ymm9 * mem) + ymm6
	vfmadd231ps	32(%rdi), %ymm9, %ymm8  # ymm8 = (ymm9 * mem) + ymm8
	vfmadd231ps	64(%rdi), %ymm9, %ymm7  # ymm7 = (ymm9 * mem) + ymm7
	vfmadd231ps	96(%rdi), %ymm9, %ymm5  # ymm5 = (ymm9 * mem) + ymm5
	vfmadd231ps	128(%rdi), %ymm9, %ymm4 # ymm4 = (ymm9 * mem) + ymm4
	vfmadd231ps	160(%rdi), %ymm9, %ymm3 # ymm3 = (ymm9 * mem) + ymm3
	vfmadd231ps	192(%rdi), %ymm9, %ymm2 # ymm2 = (ymm9 * mem) + ymm2
	vfmadd231ps	224(%rdi), %ymm9, %ymm1 # ymm1 = (ymm9 * mem) + ymm1
	addq	$4, %rcx
	addq	$256, %rdi                      # imm = 0x100
	cmpq	%rcx, %rax
	jne	.LBB14_4
	jmp	.LBB14_2
.LBB14_1:
	vxorps	%xmm5, %xmm5, %xmm5
	vxorps	%xmm4, %xmm4, %xmm4
	vxorps	%xmm3, %xmm3, %xmm3
	vxorps	%xmm2, %xmm2, %xmm2
	vxorps	%xmm1, %xmm1, %xmm1
	vxorps	%xmm7, %xmm7, %xmm7
	vxorps	%xmm8, %xmm8, %xmm8
	vxorps	%xmm6, %xmm6, %xmm6
.LBB14_2:
	vbroadcastss	%xmm0, %ymm0
	vmulps	%ymm6, %ymm0, %ymm6
	vmovaps	%ymm6, (%rdx)
	vmulps	%ymm0, %ymm8, %ymm6
	vmovaps	%ymm6, 32(%rdx)
	vmulps	%ymm7, %ymm0, %ymm6
	vmovaps	%ymm6, 64(%rdx)
	vmulps	%ymm5, %ymm0, %ymm5
	vmovaps	%ymm5, 96(%rdx)
	vmulps	%ymm4, %ymm0, %ymm4
	vmovaps	%ymm4, 128(%rdx)
	vmulps	%ymm3, %ymm0, %ymm3
	vmovaps	%ymm3, 160(%rdx)
	vmulps	%ymm2, %ymm0, %ymm2
	vmovaps	%ymm2, 192(%rdx)
	vmulps	%ymm1, %ymm0, %ymm0
	vmovaps	%ymm0, 224(%rdx)
	vzeroupper
	retq
.Lfunc_end14:
	.size	_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf, .Lfunc_end14-_ZN3fx23opt12_GLOBAL__N_112pv_dense_f32EPKfS3_ifPf
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function _ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi
.LCPI15_0:
	.long	0x80000000                      # float -0
.LCPI15_1:
	.long	0x42b00000                      # float 88
.LCPI15_2:
	.long	0xc2aeac50                      # float -87.3365478
.LCPI15_3:
	.long	0x3f000000                      # float 0.5
.LCPI15_4:
	.long	0x3fb8aa3b                      # float 1.44269502
.LCPI15_5:
	.long	0x3f318000                      # float 0.693359375
.LCPI15_6:
	.long	0xb95e8083                      # float -2.12194442E-4
.LCPI15_7:
	.long	0x3e2aaaaa                      # float 0.166666657
.LCPI15_8:
	.long	0x3d2aa9c1                      # float 0.0416657962
.LCPI15_9:
	.long	0x3c088908                      # float 0.00833345205
.LCPI15_10:
	.long	0x3ab743ce                      # float 0.00139819994
.LCPI15_11:
	.long	0x39506967                      # float 1.98756912E-4
.LCPI15_12:
	.long	0x3f800000                      # float 1
	.section	.text._ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi,"ax",@progbits
	.p2align	4, 0x90
	.type	_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi,@function
_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi: # @_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi
# %bb.0:
	subq	$648, %rsp                      # imm = 0x288
	vbroadcastss	%xmm0, %ymm0
	vmovups	%ymm0, 352(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_0(%rip), %xmm0  # xmm0 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
	vxorps	%xmm0, %xmm1, %xmm0
	vbroadcastss	%xmm0, %ymm0
	vmovups	%ymm0, 320(%rsp)                # 32-byte Spill
	vpcmpeqd	%ymm3, %ymm3, %ymm3
	vxorps	%xmm11, %xmm11, %xmm11
	movq	$-4, %rax
	xorl	%ecx, %ecx
	vbroadcastss	.LCPI15_1(%rip), %ymm1  # ymm1 = [8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1,8.8E+1]
	vmovups	%ymm1, -32(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_2(%rip), %ymm1  # ymm1 = [-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1,-8.73365478E+1]
	vmovups	%ymm1, 96(%rsp)                 # 32-byte Spill
	vbroadcastss	.LCPI15_3(%rip), %ymm0  # ymm0 = [5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1,5.0E-1]
	vmovups	%ymm0, 224(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_4(%rip), %ymm0  # ymm0 = [1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0,1.44269502E+0]
	vmovups	%ymm0, 64(%rsp)                 # 32-byte Spill
	vbroadcastss	.LCPI15_5(%rip), %ymm0  # ymm0 = [6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1,6.93359375E-1]
	vmovups	%ymm0, 288(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_6(%rip), %ymm0  # ymm0 = [-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4,-2.12194442E-4]
	vmovups	%ymm0, 256(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_7(%rip), %ymm0  # ymm0 = [1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1,1.66666657E-1]
	vmovups	%ymm0, 32(%rsp)                 # 32-byte Spill
	vbroadcastss	.LCPI15_8(%rip), %ymm0  # ymm0 = [4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2,4.16657962E-2]
	vmovups	%ymm0, -64(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_9(%rip), %ymm0  # ymm0 = [8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3,8.33345205E-3]
	vmovups	%ymm0, -96(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_10(%rip), %ymm0 # ymm0 = [1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3,1.39819994E-3]
	vmovups	%ymm0, (%rsp)                   # 32-byte Spill
	vbroadcastss	.LCPI15_11(%rip), %ymm0 # ymm0 = [1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4,1.98756912E-4]
	vmovups	%ymm0, -128(%rsp)               # 32-byte Spill
	vbroadcastss	.LCPI15_12(%rip), %ymm0 # ymm0 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	vmovups	%ymm0, 192(%rsp)                # 32-byte Spill
	vbroadcastss	.LCPI15_12(%rip), %ymm0 # ymm0 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
	vmovups	%ymm0, 160(%rsp)                # 32-byte Spill
	vxorps	%xmm1, %xmm1, %xmm1
	.p2align	4, 0x90
.LBB15_1:                               # =>This Inner Loop Header: Depth=1
	vmovdqu	%ymm3, 544(%rsp)                # 32-byte Spill
	vmovups	%ymm1, 576(%rsp)                # 32-byte Spill
	vmovups	%ymm11, 608(%rsp)               # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE(%rcx), %ymm4
	vmovups	352(%rsp), %ymm2                # 32-byte Reload
	vsubps	%ymm2, %ymm4, %ymm0
	vmovups	%ymm0, 512(%rsp)                # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE+32(%rcx), %ymm4
	vsubps	%ymm2, %ymm4, %ymm7
	vmovups	%ymm7, 416(%rsp)                # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE+64(%rcx), %ymm4
	vsubps	%ymm2, %ymm4, %ymm1
	vmovups	%ymm1, 128(%rsp)                # 32-byte Spill
	vmovaps	_ZN3fx23opt12_GLOBAL__N_14g_scE+96(%rcx), %ymm4
	vsubps	%ymm2, %ymm4, %ymm2
	vmovups	%ymm2, 448(%rsp)                # 32-byte Spill
	vmovups	-32(%rsp), %ymm1                # 32-byte Reload
	vminps	%ymm1, %ymm0, %ymm4
	vmovaps	%ymm1, %ymm3
	vmovups	96(%rsp), %ymm14                # 32-byte Reload
	vmaxps	%ymm14, %ymm4, %ymm5
	vmovups	64(%rsp), %ymm1                 # 32-byte Reload
	vmovaps	%ymm1, %ymm4
	vmovaps	%ymm1, %ymm11
	vmovups	224(%rsp), %ymm0                # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm5, %ymm4     # ymm4 = (ymm5 * ymm4) + ymm0
	vroundps	$1, %ymm4, %ymm6
	vmovups	%ymm6, 480(%rsp)                # 32-byte Spill
	vmovups	288(%rsp), %ymm1                # 32-byte Reload
	vfnmadd231ps	%ymm1, %ymm6, %ymm5     # ymm5 = -(ymm6 * ymm1) + ymm5
	vmovups	256(%rsp), %ymm4                # 32-byte Reload
	vfnmadd231ps	%ymm4, %ymm6, %ymm5     # ymm5 = -(ymm6 * ymm4) + ymm5
	vmulps	%ymm5, %ymm5, %ymm6
	vmulps	%ymm6, %ymm6, %ymm8
	vmovups	32(%rsp), %ymm12                # 32-byte Reload
	vmovaps	%ymm12, %ymm9
	vfmadd213ps	%ymm0, %ymm5, %ymm9     # ymm9 = (ymm5 * ymm9) + ymm0
	vmovups	-96(%rsp), %ymm13               # 32-byte Reload
	vfmadd213ps	-64(%rsp), %ymm5, %ymm13 # 32-byte Folded Reload
                                        # ymm13 = (ymm5 * ymm13) + mem
	vmovups	-128(%rsp), %ymm15              # 32-byte Reload
	vmovups	(%rsp), %ymm10                  # 32-byte Reload
	vfmadd213ps	%ymm10, %ymm5, %ymm15   # ymm15 = (ymm5 * ymm15) + ymm10
	vfmadd213ps	%ymm9, %ymm6, %ymm13    # ymm13 = (ymm6 * ymm13) + ymm9
	vfmadd231ps	%ymm15, %ymm8, %ymm13   # ymm13 = (ymm8 * ymm15) + ymm13
	vfmadd213ps	%ymm5, %ymm6, %ymm13    # ymm13 = (ymm6 * ymm13) + ymm5
	vminps	%ymm3, %ymm7, %ymm5
	vmovaps	%ymm14, %ymm2
	vmaxps	%ymm14, %ymm5, %ymm8
	vmovaps	%ymm11, %ymm5
	vfmadd213ps	%ymm0, %ymm8, %ymm5     # ymm5 = (ymm8 * ymm5) + ymm0
	vroundps	$1, %ymm5, %ymm5
	vmovups	%ymm5, 384(%rsp)                # 32-byte Spill
	vmovaps	%ymm1, %ymm3
	vfnmadd231ps	%ymm1, %ymm5, %ymm8     # ymm8 = -(ymm5 * ymm1) + ymm8
	vmovaps	%ymm4, %ymm6
	vfnmadd231ps	%ymm4, %ymm5, %ymm8     # ymm8 = -(ymm5 * ymm4) + ymm8
	vmulps	%ymm8, %ymm8, %ymm9
	vmulps	%ymm9, %ymm9, %ymm15
	vmovaps	%ymm12, %ymm1
	vmovaps	%ymm12, %ymm11
	vfmadd213ps	%ymm0, %ymm8, %ymm11    # ymm11 = (ymm8 * ymm11) + ymm0
	vmovups	-96(%rsp), %ymm4                # 32-byte Reload
	vmovaps	%ymm4, %ymm5
	vmovups	-64(%rsp), %ymm14               # 32-byte Reload
	vfmadd213ps	%ymm14, %ymm8, %ymm5    # ymm5 = (ymm8 * ymm5) + ymm14
	vmovups	-128(%rsp), %ymm7               # 32-byte Reload
	vmovaps	%ymm7, %ymm12
	vfmadd213ps	%ymm10, %ymm8, %ymm12   # ymm12 = (ymm8 * ymm12) + ymm10
	vfmadd213ps	%ymm11, %ymm9, %ymm5    # ymm5 = (ymm9 * ymm5) + ymm11
	vfmadd231ps	%ymm12, %ymm15, %ymm5   # ymm5 = (ymm15 * ymm12) + ymm5
	vfmadd213ps	%ymm8, %ymm9, %ymm5     # ymm5 = (ymm9 * ymm5) + ymm8
	vmovups	128(%rsp), %ymm8                # 32-byte Reload
	vminps	-32(%rsp), %ymm8, %ymm8         # 32-byte Folded Reload
	vmaxps	%ymm2, %ymm8, %ymm11
	vmovups	64(%rsp), %ymm2                 # 32-byte Reload
	vmovaps	%ymm2, %ymm8
	vfmadd213ps	%ymm0, %ymm11, %ymm8    # ymm8 = (ymm11 * ymm8) + ymm0
	vroundps	$1, %ymm8, %ymm8
	vfnmadd231ps	%ymm3, %ymm8, %ymm11    # ymm11 = -(ymm8 * ymm3) + ymm11
	vfnmadd231ps	%ymm6, %ymm8, %ymm11    # ymm11 = -(ymm8 * ymm6) + ymm11
	vmulps	%ymm11, %ymm11, %ymm12
	vmulps	%ymm12, %ymm12, %ymm15
	vfmadd213ps	%ymm0, %ymm11, %ymm1    # ymm1 = (ymm11 * ymm1) + ymm0
	vmovaps	%ymm4, %ymm9
	vfmadd213ps	%ymm14, %ymm11, %ymm9   # ymm9 = (ymm11 * ymm9) + ymm14
	vmovaps	%ymm7, %ymm14
	vmovups	(%rsp), %ymm4                   # 32-byte Reload
	vfmadd213ps	%ymm4, %ymm11, %ymm14   # ymm14 = (ymm11 * ymm14) + ymm4
	vfmadd213ps	%ymm1, %ymm12, %ymm9    # ymm9 = (ymm12 * ymm9) + ymm1
	vfmadd231ps	%ymm14, %ymm15, %ymm9   # ymm9 = (ymm15 * ymm14) + ymm9
	vfmadd213ps	%ymm11, %ymm12, %ymm9   # ymm9 = (ymm12 * ymm9) + ymm11
	vmovups	448(%rsp), %ymm7                # 32-byte Reload
	vminps	-32(%rsp), %ymm7, %ymm10        # 32-byte Folded Reload
	vmaxps	96(%rsp), %ymm10, %ymm10        # 32-byte Folded Reload
	vmovups	576(%rsp), %ymm1                # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm10, %ymm2    # ymm2 = (ymm10 * ymm2) + ymm0
	vroundps	$1, %ymm2, %ymm11
	vfnmadd231ps	%ymm3, %ymm11, %ymm10   # ymm10 = -(ymm11 * ymm3) + ymm10
	vfnmadd231ps	%ymm6, %ymm11, %ymm10   # ymm10 = -(ymm11 * ymm6) + ymm10
	vmulps	%ymm10, %ymm10, %ymm12
	vmovups	32(%rsp), %ymm14                # 32-byte Reload
	vfmadd213ps	%ymm0, %ymm10, %ymm14   # ymm14 = (ymm10 * ymm14) + ymm0
	vmovups	-96(%rsp), %ymm15               # 32-byte Reload
	vfmadd213ps	-64(%rsp), %ymm10, %ymm15 # 32-byte Folded Reload
                                        # ymm15 = (ymm10 * ymm15) + mem
	vfmadd213ps	%ymm14, %ymm12, %ymm15  # ymm15 = (ymm12 * ymm15) + ymm14
	vmovups	-128(%rsp), %ymm14              # 32-byte Reload
	vfmadd213ps	%ymm4, %ymm10, %ymm14   # ymm14 = (ymm10 * ymm14) + ymm4
	vmulps	%ymm12, %ymm12, %ymm2
	vfmadd231ps	%ymm14, %ymm2, %ymm15   # ymm15 = (ymm2 * ymm14) + ymm15
	vfmadd213ps	%ymm10, %ymm12, %ymm15  # ymm15 = (ymm12 * ymm15) + ymm10
	vmovups	192(%rsp), %ymm0                # 32-byte Reload
	vaddps	%ymm0, %ymm13, %ymm2
	vcvtps2dq	480(%rsp), %ymm4        # 32-byte Folded Reload
	vpslld	$23, %ymm4, %ymm4
	vmovdqu	160(%rsp), %ymm3                # 32-byte Reload
	vpaddd	%ymm3, %ymm4, %ymm4
	vmulps	%ymm4, %ymm2, %ymm2
	vaddps	%ymm0, %ymm5, %ymm4
	vcvtps2dq	384(%rsp), %ymm5        # 32-byte Folded Reload
	vpslld	$23, %ymm5, %ymm5
	vpaddd	%ymm3, %ymm5, %ymm5
	vmulps	%ymm5, %ymm4, %ymm4
	vaddps	%ymm0, %ymm9, %ymm5
	vcvtps2dq	%ymm8, %ymm6
	vpslld	$23, %ymm6, %ymm6
	vpaddd	%ymm3, %ymm6, %ymm6
	vmulps	%ymm6, %ymm5, %ymm5
	vaddps	%ymm0, %ymm15, %ymm6
	vcvtps2dq	%ymm11, %ymm8
	vmovups	608(%rsp), %ymm11               # 32-byte Reload
	vpslld	$23, %ymm8, %ymm8
	vpaddd	%ymm3, %ymm8, %ymm8
	vmulps	%ymm6, %ymm8, %ymm6
	vmovups	320(%rsp), %ymm10               # 32-byte Reload
	vcmpleps	512(%rsp), %ymm10, %ymm8        # 32-byte Folded Reload
	vcmpleps	416(%rsp), %ymm10, %ymm9        # 32-byte Folded Reload
	vandps	%ymm2, %ymm8, %ymm2
	vandps	%ymm4, %ymm9, %ymm4
	vmovaps	%ymm2, _ZN3fx23opt12_GLOBAL__N_14g_ebE(%rcx)
	vmovaps	%ymm4, _ZN3fx23opt12_GLOBAL__N_14g_ebE+32(%rcx)
	vaddps	%ymm4, %ymm2, %ymm2
	vaddps	%ymm2, %ymm11, %ymm11
	vcmpleps	128(%rsp), %ymm10, %ymm2        # 32-byte Folded Reload
	vcmpleps	%ymm7, %ymm10, %ymm4
	vandps	%ymm2, %ymm5, %ymm5
	vandps	%ymm4, %ymm6, %ymm6
	vmovaps	%ymm5, _ZN3fx23opt12_GLOBAL__N_14g_ebE+64(%rcx)
	vmovaps	%ymm6, _ZN3fx23opt12_GLOBAL__N_14g_ebE+96(%rcx)
	vaddps	%ymm6, %ymm5, %ymm5
	vaddps	%ymm5, %ymm1, %ymm1
	vandps	544(%rsp), %ymm8, %ymm5         # 32-byte Folded Reload
	vandps	%ymm2, %ymm9, %ymm2
	vandps	%ymm2, %ymm5, %ymm2
	vandps	%ymm4, %ymm2, %ymm3
	addq	$4, %rax
	subq	$-128, %rcx
	cmpq	$121, %rax
	jb	.LBB15_1
# %bb.2:
	vpcmpeqd	%ymm2, %ymm2, %ymm2
	vtestps	%ymm2, %ymm3
	jb	.LBB15_3
# %bb.4:
	vxorps	%xmm2, %xmm2, %xmm2
	movq	$-4096, %rax                    # imm = 0xF000
	vpxor	%xmm3, %xmm3, %xmm3
	.p2align	4, 0x90
.LBB15_5:                               # =>This Inner Loop Header: Depth=1
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+4096(%rax), %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm3
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+4128(%rax), %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm3
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+4160(%rax), %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm3
	vcmpneq_oqps	_ZN3fx23opt12_GLOBAL__N_14g_ebE+4192(%rax), %ymm2, %ymm4
	vpsubd	%ymm4, %ymm3, %ymm3
	subq	$-128, %rax
	jne	.LBB15_5
# %bb.6:
	vextracti128	$1, %ymm3, %xmm2
	vpaddd	%xmm3, %xmm2, %xmm2
	vpshufd	$78, %xmm2, %xmm3               # xmm3 = xmm2[2,3,0,1]
	vpaddd	%xmm2, %xmm3, %xmm2
	vpshufd	$85, %xmm2, %xmm3               # xmm3 = xmm2[1,1,1,1]
	vpaddd	%xmm2, %xmm3, %xmm2
	vmovd	%xmm2, %eax
	jmp	.LBB15_7
.LBB15_3:
	movl	$1024, %eax                     # imm = 0x400
.LBB15_7:
	movl	%eax, (%rdi)
	vaddps	%ymm1, %ymm11, %ymm0
	vextractf128	$1, %ymm0, %xmm1
	vaddps	%xmm1, %xmm0, %xmm0
	vshufpd	$1, %xmm0, %xmm0, %xmm1         # xmm1 = xmm0[1,0]
	vaddps	%xmm1, %xmm0, %xmm0
	vmovshdup	%xmm0, %xmm1            # xmm1 = xmm0[1,1,3,3]
	vaddss	%xmm1, %xmm0, %xmm0
	addq	$648, %rsp                      # imm = 0x288
	vzeroupper
	retq
.Lfunc_end15:
	.size	_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi, .Lfunc_end15-_ZN3fx23opt12_GLOBAL__N_18exp_passILb1EEEfPKfiffPfRi
                                        # -- End function
	.type	_ZN3fx23opt11g_attn_profE,@object # @_ZN3fx23opt11g_attn_profE
	.section	.bss._ZN3fx23opt11g_attn_profE,"aw",@nobits
	.globl	_ZN3fx23opt11g_attn_profE
	.p2align	4, 0x0
_ZN3fx23opt11g_attn_profE:
	.zero	32
	.size	_ZN3fx23opt11g_attn_profE, 32

	.type	_ZN3fx23opt12_GLOBAL__N_14g_scE,@object # @_ZN3fx23opt12_GLOBAL__N_14g_scE
	.section	.bss._ZN3fx23opt12_GLOBAL__N_14g_scE,"aw",@nobits
	.p2align	6, 0x0
_ZN3fx23opt12_GLOBAL__N_14g_scE:
	.zero	4224
	.size	_ZN3fx23opt12_GLOBAL__N_14g_scE, 4224

	.type	_ZN3fx23opt12_GLOBAL__N_14g_ebE,@object # @_ZN3fx23opt12_GLOBAL__N_14g_ebE
	.section	.bss._ZN3fx23opt12_GLOBAL__N_14g_ebE,"aw",@nobits
	.p2align	6, 0x0
_ZN3fx23opt12_GLOBAL__N_14g_ebE:
	.zero	4224
	.size	_ZN3fx23opt12_GLOBAL__N_14g_ebE, 4224

	.ident	"Ubuntu clang version 17.0.6 (23ubuntu7)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _ZN3fx23opt12_GLOBAL__N_14g_ebE
