# stage1.s: stage 1 of the unpacking stub in assembly (see stage0.S, pkdec.c, pack.sh).
# Generated from pkdec.c by: gcc -Oz -fno-inline -fno-pie -fcf-protection=none (pack.sh, PACK_STUB_REGEN=1).
# pkdec.c md5 a82bd3a4708551500a95f3ed8781aaed
# pkdec.c is the readable reference of this code and the test decoder; if it changes,
# regenerate this file (pack.sh refuses to use it when the md5 above no longer matches).
# Hand edits for size are welcome: keep the behaviour and note them here.
	.text
	.type	alloc, @function
alloc:
	movq	arena(%rip), %rax
	addq	$63, %rdi
	andq	$-64, %rdi
	addq	%rax, %rdi
	movq	%rdi, arena(%rip)
	ret
	.size	alloc, .-alloc
	.type	squash, @function
squash:
	movl	$4095, %eax
	cmpl	$2048, %edi
	je	.L2
	xorl	%eax, %eax
	cmpl	$-2048, %edi
	je	.L2
	movl	%edi, %ecx
	sarl	$7, %edi
	leal	16(%rdi), %eax
	andl	$127, %ecx
	addl	$17, %edi
	cltq
	movslq	%edi, %rdi
	movswl	sqt(%rax,%rax), %edx
	movl	$128, %eax
	subl	%ecx, %eax
	imull	%eax, %edx
	movswl	sqt(%rdi,%rdi), %eax
	imull	%ecx, %eax
	leal	64(%rdx,%rax), %eax
	sarl	$7, %eax
.L2:
	ret
	.size	squash, .-squash
	.type	clampd, @function
clampd:
	sarq	$16, %rdi
	movl	$-2047, %eax
	movl	$2047, %edx
	cmpl	%eax, %edi
	cmovge	%edi, %eax
	cmpl	%edx, %eax
	cmovg	%edx, %eax
	ret
	.size	clampd, .-clampd
	.type	init_optab, @function
init_optab:
	xorl	%eax, %eax
.L10:
	movb	$1, %dl
	testb	$4, %al
	je	.L9
	movl	%eax, %ecx
	movb	$2, %dl
	andl	$7, %ecx
	cmpl	$4, %ecx
	je	.L9
	cmpl	$5, %ecx
	sete	%dl
	sall	$2, %edx
.L9:
	movb	%dl, optab(%rax)
	incq	%rax
	cmpq	$64, %rax
	jne	.L10
	xorl	%eax, %eax
	movl	$optab, %ecx
.L14:
	cmpl	$168, %eax
	jne	.L11
	addq	$256, %rcx
	movl	$169, %eax
.L11:
	leal	1(%rax), %edx
	leal	2(%rax), %edi
	movzbl	opr(%rdx), %esi
	movl	%eax, %edx
	movzbl	opr(%rdx), %edx
.L12:
	cmpl	%edx, %esi
	jl	.L20
	movb	opr(%rdi), %r8b
	movb	%r8b, (%rcx,%rdx)
	incq	%rdx
	jmp	.L12
.L20:
	addl	$3, %eax
	cmpl	$216, %eax
	jbe	.L14
	ret
	.size	init_optab, .-init_optab
	.type	B, @function
B:
	movl	pos(%rip), %eax
	xorl	%edx, %edx
	cmpl	%edi, %eax
	jb	.L21
	movq	buf(%rip), %rdx
	subl	%edi, %eax
	movzbl	(%rdx,%rax), %edx
.L21:
	xchgl	%edx, %eax
	ret
	.size	B, .-B
	.type	intextp, @function
intextp:
	movl	$PK_TEXT_LO, %eax
	cmpl	%eax, %edi
	jb	.L25
	movl	$PK_TEXT_HI, %eax
	movl	$PK_HOLE_LEN, %ecx
	pushq	$1
	popq	%rdx
	subl	%ecx, %eax
	cmpl	%eax, %edi
	jb	.L24
.L25:
	xorl	%edx, %edx
	cmpl	t2lo(%rip), %edi
	setnb	%dl
.L24:
	xchgl	%edx, %eax
	ret
	.size	intextp, .-intextp
	.type	intext, @function
intext:
	movl	pos(%rip), %edi
	jmp	intextp
	.size	intext, .-intext
	.type	byte_update, @function
byte_update:
	subq	$192, %rsp
	leaq	4(%rsp), %rax
	movq	%rax, %rsi
.L30:
	andl	$0, (%rax)
	leaq	192(%rsp), %rdi
	addq	$4, %rax
	cmpq	%rax, %rdi
	jne	.L30
	pushq	$1
	popq	%rcx
.L31:
	movl	%ecx, %edi
	call	B
	movl	%eax, -4(%rsi,%rcx,4)
	incq	%rcx
	cmpq	$9, %rcx
	jne	.L31
	pushq	$9
	popq	%rdi
	call	B
	movl	%eax, 152(%rsp)
	pushq	$12
	popq	%rdi
	call	B
	movl	%eax, 164(%rsp)
	pushq	$16
	popq	%rdi
	call	B
	movl	%eax, 168(%rsp)
	pushq	$24
	popq	%rdi
	call	B
	movl	X+24(%rip), %edx
	movl	X+32(%rip), %esi
	movl	%eax, 172(%rsp)
	movl	X+20(%rip), %eax
	leal	(%rax,%rdx,2), %eax
	movl	X(%rip), %edx
	movl	%eax, 140(%rsp)
	movl	X+4(%rip), %eax
	pushq	$15
	popq	%rcx
	sall	$4, %edx
	cmpl	%ecx, %eax
	cmovle	%eax, %ecx
	sall	$28, %eax
	addl	%ecx, %edx
	movl	%edx, 36(%rsp)
	movl	X+12(%rip), %edx
	movl	%edx, 40(%rsp)
	leal	1(%rsi), %edx
	movl	%edx, 44(%rsp)
	movq	X+64(%rip), %rdx
	movq	%rdx, 48(%rsp)
	addl	X+60(%rip), %eax
	movl	X+72(%rip), %edx
	movl	pos(%rip), %ecx
	movl	%eax, 64(%rsp)
	movl	X+80(%rip), %eax
	movl	%edx, 56(%rsp)
	movl	X+76(%rip), %edx
	movl	%eax, 68(%rsp)
	movl	X+84(%rip), %eax
	movl	%edx, 120(%rsp)
	movl	X+16(%rip), %edx
	movl	%eax, 124(%rsp)
	movl	%ecx, %eax
	andl	$7, %eax
	movl	%edx, 60(%rsp)
	xorl	%edx, %edx
	movl	%eax, 80(%rsp)
	movl	%ecx, %eax
	divl	%edi
	movl	mm+24(%rip), %eax
	incl	%eax
	movl	%eax, 92(%rsp)
	movl	%esi, %eax
	sarl	$6, %eax
	incl	%eax
	movl	%edx, 84(%rsp)
	xorl	%edx, %edx
	testl	%esi, %esi
	movl	$ctx+16, %esi
	cmovs	%edx, %eax
	shrl	$12, %ecx
	movl	%ecx, 116(%rsp)
	movl	$-2128831035, %ecx
	movl	%eax, 100(%rsp)
	pushq	$1
	popq	%rdi
	call	B
	movl	X+52(%rip), %edx
	movl	$cfg, %edi
	shrl	$4, %eax
	movl	%eax, 128(%rsp)
	movl	X+56(%rip), %eax
	leal	(%rax,%rdx,2), %eax
	movl	%eax, 184(%rsp)
	movl	X+64(%rip), %eax
	shrl	$2, %eax
	andl	$255, %eax
	movl	%eax, 188(%rsp)
.L35:
	movl	%ecx, %eax
.L33:
	movzbl	(%rdi), %edx
	incq	%rdi
	cmpb	$-1, %dl
	je	.L41
	xorl	4(%rsp,%rdx,4), %eax
	movzbl	%dl, %r8d
	imull	$789269863, %eax, %eax
	movl	%eax, %edx
	shrl	$15, %edx
	xorl	%edx, %eax
	imull	$-1640531535, %r8d, %edx
	addl	%edx, %eax
	jmp	.L33
.L41:
	addl	$16777619, %ecx
	movl	%eax, (%rsi)
	addq	$2072, %rsi
	cmpl	$-1709390560, %ecx
	jne	.L35
	addq	$192, %rsp
	ret
	.size	byte_update, .-byte_update
	.type	mm_predict, @function
mm_predict:
	movl	20(%rdi), %esi
	orq	$-1, 24(%rdi)
	movl	nin(%rip), %eax
	testl	%esi, %esi
	jle	.L43
	movl	16(%rdi), %edx
	cmpl	pos(%rip), %edx
	jnb	.L43
	movq	buf(%rip), %rcx
	movl	bpos(%rip), %r8d
	movzbl	(%rcx,%rdx), %r9d
	pushq	$8
	popq	%rcx
	movl	%r9d, %edx
	subl	%r8d, %ecx
	orb	$1, %dh
	movl	%edx, %r10d
	sarl	%cl, %r10d
	cmpl	c0(%rip), %r10d
	jne	.L44
	pushq	$7
	popq	%rcx
	subl	%r8d, %ecx
	movl	%r9d, 24(%rdi)
	sarl	%cl, %edx
	movl	%edx, %ecx
	movslq	%esi, %rdx
	andl	$1, %ecx
	cmpl	$31, %esi
	jle	.L45
	pushq	$32
	cmpl	$63, %esi
	popq	%rdx
	pushq	$31
	popq	%r8
	cmovle	%r8, %rdx
.L45:
	movl	%edx, 28(%rdi)
	movl	32(%rdi,%rdx,4), %edx
	movl	%esi, %r9d
	movq	stretch_t(%rip), %r8
	sall	$5, %r9d
	shrw	$4, %dx
	movzwl	%dx, %edx
	movswl	(%r8,%rdx,2), %r8d
	movl	$400, %edx
	cmpl	%edx, %esi
	cmovle	%esi, %edx
	addl	$512, %edx
	cmpl	$15, %esi
	cmovle	%r9d, %edx
	testl	%ecx, %ecx
	jne	.L48
	negl	%r8d
.L48:
	movslq	%eax, %r9
	leal	1(%rax), %esi
	movl	%r8d, in(,%r9,4)
	testl	%ecx, %ecx
	jne	.L49
	negl	%edx
.L49:
	addl	$2, %eax
	movw	%cx, 34(%rdi)
	movl	%eax, nin(%rip)
	movslq	%esi, %rax
	movl	%edx, in(,%rax,4)
	ret
.L44:
	andl	$0, 20(%rdi)
.L43:
	movslq	%eax, %rdx
	andl	$0, in(,%rdx,4)
	leal	2(%rax), %edx
	incl	%eax
	cltq
	movl	%edx, nin(%rip)
	andl	$0, in(,%rax,4)
	ret
	.size	mm_predict, .-mm_predict
	.type	mm_byte, @function
mm_byte:
	movl	20(%rdi), %ecx
	movl	pos(%rip), %edx
	testl	%ecx, %ecx
	jle	.L54
	movl	16(%rdi), %eax
	cmpl	%edx, %eax
	jnb	.L54
	movq	buf(%rip), %r8
	leal	-1(%rdx), %r9d
	movl	%eax, %esi
	movb	(%r8,%r9), %r10b
	cmpb	%r10b, (%r8,%rsi)
	jne	.L54
	incl	%ecx
	incl	%eax
	movl	%ecx, 20(%rdi)
	movl	%eax, 16(%rdi)
	jmp	.L55
.L54:
	andl	$0, 20(%rdi)
.L55:
	movl	(%rdi), %esi
	cmpl	%esi, %edx
	jb	.L53
	movq	buf(%rip), %r8
	pushq	$1
	xorl	%eax, %eax
	popq	%rcx
.L57:
	cmpl	%ecx, %esi
	jl	.L70
	movl	%edx, %r9d
	subl	%ecx, %r9d
	incl	%ecx
	movzbl	(%r8,%r9), %r9d
	leal	1(%rax,%r9), %eax
	imull	$789269863, %eax, %eax
	jmp	.L57
.L70:
	movq	8(%rdi), %rcx
	shrl	$12, %eax
	leaq	(%rcx,%rax,4), %r9
	cmpl	$0, 20(%rdi)
	jne	.L60
	movl	(%r9), %ecx
	movl	%ecx, 16(%rdi)
	testl	%ecx, %ecx
	je	.L60
	pushq	$1
	popq	%rax
.L61:
	movl	%ecx, %r11d
	movl	%edx, %r10d
	subl	%eax, %r10d
	subl	%eax, %r11d
	movb	(%r8,%r10), %r10b
	cmpb	%r10b, (%r8,%r11)
	jne	.L71
	cmpl	$65535, %eax
	je	.L63
	cmpl	%eax, %ecx
	je	.L63
	incl	%eax
	jmp	.L61
.L71:
	decl	%eax
.L63:
	xorl	%ecx, %ecx
	cmpl	%esi, %eax
	cmovb	%ecx, %eax
	movl	%eax, 20(%rdi)
.L60:
	movl	%edx, (%r9)
.L53:
	ret
	.size	mm_byte, .-mm_byte
	.type	apm_pp, @function
apm_pp:
	movq	stretch_t(%rip), %rax
	movslq	%esi, %rsi
	imull	$33, %edx, %ecx
	movswl	(%rax,%rsi,2), %esi
	movq	%rcx, %rdx
	leal	2048(%rsi), %eax
	andl	$127, %esi
	sarl	$7, %eax
	movslq	%eax, %r8
	addl	%edx, %eax
	movl	%esi, %edx
	sarl	$6, %edx
	addq	%r8, %rcx
	addl	%edx, %eax
	addq	%rcx, %rcx
	addq	(%rdi), %rcx
	movl	$128, %edx
	movl	%eax, 8(%rdi)
	movzwl	(%rcx), %eax
	subl	%esi, %edx
	imull	%edx, %eax
	movzwl	2(%rcx), %edx
	imull	%esi, %edx
	addl	%edx, %eax
	sarl	$11, %eax
	ret
	.size	apm_pp, .-apm_pp
	.type	predict, @function
predict:
	pushq	%r14
	movl	$ctx, %esi
	movl	$in, %ecx
	xorl	%r8d, %r8d
	pushq	%r13
	movq	stretch_t(%rip), %r9
	movl	$512, %r10d
	pushq	%r12
	pushq	%rbp
	movl	c0(%rip), %ebp
	pushq	%rbx
	imull	$-1640531535, %ebp, %r13d
	pushq	$3
	popq	%r11
	andl	$0, nin(%rip)
.L80:
	movl	16(%rsi), %eax
	xorl	%r13d, %eax
	imull	$-2048144789, %eax, %eax
	movl	%eax, %edx
	shrl	$13, %edx
	xorl	%eax, %edx
	movq	(%rsi), %rax
	imull	$-1028477387, %edx, %edx
	movl	%edx, %edi
	shrl	$3, %edx
	shrl	$12, %edi
	leaq	(%rax,%rdi,8), %rax
	movq	%rax, 8(%rsi)
	cmpb	%dl, 5(%rax)
	je	.L74
	movl	$-2147450880, (%rax)
	movb	$0, 4(%rax)
	movb	%dl, 5(%rax)
	movb	$1, 6(%rax)
.L74:
	movzbl	4(%rax), %edx
	movzbl	6(%rax), %edi
	movl	%edx, %ebx
	sall	$8, %ebx
	cmpl	$1, %edx
	jle	.L76
	cmpl	$5, %edx
	movl	$768, %ebx
	cmovle	%r10d, %ebx
.L76:
	addl	%ebx, %edi
	movl	%edi, 20(%rsi)
	testl	%edx, %edx
	jne	.L77
	andl	$0, (%rcx)
	xorl	%eax, %eax
	andl	$0, 4(%rcx)
	jmp	.L78
.L77:
	movw	(%rax), %bx
	shrw	$4, %bx
	movzwl	%bx, %ebx
	movswl	(%r9,%rbx,2), %r12d
	xorl	%ebx, %ebx
	cmpl	$2, %edx
	jle	.L79
	pushq	$1
	popq	%rbx
	cmpl	$7, %edx
	jle	.L79
	pushq	$2
	cmpl	$32, %edx
	popq	%rbx
	cmovge	%r11d, %ebx
.L79:
	movw	2(%rax), %ax
	imull	%r12d, %ebx
	movslq	%r8d, %rdx
	movslq	%edi, %rdi
	imulq	$1036, %rdx, %rdx
	shrw	$4, %ax
	movzwl	%ax, %eax
	sarl	%ebx
	leaq	8(%rdi,%rdx), %rdx
	movswl	(%r9,%rax,2), %eax
	movw	ctx+8(%rdx,%rdx), %dx
	shrw	$4, %dx
	movzwl	%dx, %edx
	movswl	(%r9,%rdx,2), %edx
	movl	%r12d, 4(%rcx)
	movl	%edx, (%rcx)
	movl	%ebx, %edx
.L78:
	incl	%r8d
	movl	%eax, 8(%rcx)
	addq	$16, %rcx
	addq	$2072, %rsi
	movl	%edx, -4(%rcx)
	cmpl	$25, %r8d
	jne	.L80
	movl	$100, nin(%rip)
	movl	$mm, %edi
	call	mm_predict
	movl	$mm+288, %edi
	call	mm_predict
	movslq	nin(%rip), %rax
	movl	X+4(%rip), %ebx
	movl	X(%rip), %r10d
	movl	mm+20(%rip), %esi
	movl	$256, in(,%rax,4)
	leal	1(%rax), %r8d
	pushq	$3
	popq	%rax
	cmpl	%eax, %ebx
	movl	%r8d, nin(%rip)
	cmovle	%ebx, %eax
	leal	(%rax,%r10,4), %eax
	testl	%esi, %esi
	je	.L81
	cmpl	$7, %esi
	jle	.L92
	cmpl	$15, %esi
	jle	.L93
	pushq	$3
	cmpl	$32, %esi
	popq	%rsi
	pushq	$4
	popq	%rdx
	cmovge	%edx, %esi
	jmp	.L81
.L92:
	pushq	$1
	popq	%rsi
	jmp	.L81
.L93:
	pushq	$2
	popq	%rsi
.L81:
	pushq	$47
	popq	%rdx
	cmpl	%edx, %eax
	pushq	$1
	popq	%rdi
	cmovg	%edx, %eax
	movl	bpos(%rip), %r11d
	movl	%ebp, sel(%rip)
	leal	(%r11,%rax,8), %eax
	movl	%eax, sel+4(%rip)
	call	B
	pushq	$7
	popq	%rcx
	xorl	%edx, %edx
	movl	%eax, sel+8(%rip)
	movl	mm+24(%rip), %eax
	subl	%r11d, %ecx
	sarl	%cl, %eax
	andl	$1, %eax
	cmpl	$0, mm+24(%rip)
	cmovs	%edx, %eax
	leal	(%rax,%rsi,2), %eax
	leal	(%r11,%rax,8), %esi
	call	intext
	testl	%eax, %eax
	je	.L83
	leal	1(%r10), %eax
	imull	$80, %eax, %eax
.L83:
	movl	X+12(%rip), %r9d
	addl	%eax, %esi
	movl	%esi, sel+12(%rip)
	xorl	%esi, %esi
	movl	%r9d, %eax
	andl	$1023, %eax
	movl	%eax, sel+16(%rip)
	movl	X+32(%rip), %eax
	leal	1(%rax), %r14d
	movl	%r14d, %eax
	andl	$511, %eax
	leal	(%r11,%rax,8), %eax
	movl	%eax, sel+20(%rip)
.L86:
	movl	sel(,%rsi,4), %eax
	movzwl	selsize(%rsi,%rsi), %ecx
	xorl	%edi, %edi
	cltd
	idivl	%ecx
	xorl	%eax, %eax
	movl	%edx, sel(,%rsi,4)
	movslq	%edx, %rdx
	imulq	$640, %rdx, %rdx
	addq	w1(,%rsi,8), %rdx
.L84:
	cmpl	%eax, %r8d
	jle	.L106
	movslq	in(,%rax,4), %rcx
	movslq	(%rdx,%rax,4), %r11
	incq	%rax
	imulq	%r11, %rcx
	addq	%rcx, %rdi
	jmp	.L84
.L106:
	call	clampd
	movl	%eax, in2(,%rsi,4)
	xchgl	%eax, %edi
	call	squash
	movl	%eax, p1(,%rsi,4)
	incq	%rsi
	cmpq	$6, %rsi
	jne	.L86
	movl	$256, in2+24(%rip)
	movslq	%ebp, %rdx
	xorl	%eax, %eax
	xorl	%edi, %edi
	imulq	$28, %rdx, %rdx
	addq	w2(%rip), %rdx
.L87:
	movslq	in2(%rax), %rcx
	movslq	(%rdx,%rax), %rsi
	addq	$4, %rax
	imulq	%rsi, %rcx
	addq	%rcx, %rdi
	cmpq	$28, %rax
	jne	.L87
	call	clampd
	xchgl	%eax, %edi
	call	squash
	pushq	$11
	popq	%rdx
	movl	$apm, %edi
	cmpl	%edx, %r10d
	xchgl	%eax, %r11d
	cmovle	%r10d, %edx
	movl	%r11d, %esi
	movl	%r11d, pmix(%rip)
	imull	$-2048144789, %r14d, %r14d
	sall	$8, %edx
	imull	$77777, %ebx, %ebx
	addl	%ebp, %edx
	imull	$19088743, %r10d, %r10d
	call	apm_pp
	pushq	$1
	popq	%rdi
	movl	%r11d, %esi
	xchgl	%eax, %r12d
	addl	%ebx, %r10d
	call	B
	movl	$apm+16, %edi
	sall	$8, %eax
	xchgl	%eax, %edx
	orl	%ebp, %edx
	movzwl	%dx, %edx
	call	apm_pp
	imull	$789269863, %r9d, %edx
	movl	%r11d, %esi
	movl	$apm+32, %edi
	xchgl	%eax, %ebp
	xorl	%r13d, %edx
	xorl	%r14d, %edx
	xorl	%r10d, %edx
	shrl	$16, %edx
	call	apm_pp
	pushq	$6
	popq	%rcx
	xchgl	%eax, %edx
	leal	(%r12,%r11,2), %eax
	pushq	$1
	addl	%ebp, %eax
	leal	3(%rax,%rdx,2), %eax
	cltd
	idivl	%ecx
	movl	$4094, %edx
	cmpl	%edx, %eax
	cmovg	%edx, %eax
	popq	%rdx
	popq	%rbx
	popq	%rbp
	popq	%r12
	testl	%eax, %eax
	popq	%r13
	popq	%r14
	cmovle	%edx, %eax
	ret
	.size	predict, .-predict
	.type	sys.constprop.0, @function
sys.constprop.0:
	xchgq	%rdi, %rax
	movq	%r8, %r10
	movq	%rsi, %rdi
	movq	%r9, %r8
	movq	%rdx, %rsi
	xorl	%r9d, %r9d
	movq	%rcx, %rdx
#APP
# 444 "/root/b_fin/fx2-cmix-T/packer/pkdec.c" 1
	syscall
# 0 "" 2
#NO_APP
	ret
	.size	sys.constprop.0, .-sys.constprop.0
	.type	x_end.constprop.0, @function
x_end.constprop.0:
	movl	X+72(%rip), %eax
	movl	X+12(%rip), %edx
	movl	%eax, X+76(%rip)
	movl	X+68(%rip), %eax
	movl	%eax, X+72(%rip)
	movl	X+64(%rip), %eax
	movl	%eax, X+68(%rip)
	xorl	%eax, %eax
	cmpl	$0, X+20(%rip)
	setne	%al
	leal	(%rax,%rdx,4), %eax
	xorl	%edx, %edx
	cmpl	$0, X+24(%rip)
	setne	%dl
	andq	$0, X(%rip)
	leal	(%rax,%rdx,2), %eax
	andl	$0, X+12(%rip)
	movl	%eax, X+64(%rip)
	movl	X+80(%rip), %eax
	andq	$0, X+16(%rip)
	movl	%eax, X+84(%rip)
	movl	X+32(%rip), %eax
	andq	$0, X+24(%rip)
	incl	%eax
	orq	$-1, X+32(%rip)
	movl	%eax, X+80(%rip)
	andq	$0, X+40(%rip)
	andl	$0, X+88(%rip)
	andl	$0, X+52(%rip)
	andq	$0, X+56(%rip)
	ret
	.size	x_end.constprop.0, .-x_end.constprop.0
	.type	x_imm.constprop.0, @function
x_imm.constprop.0:
	movl	X+44(%rip), %eax
	testl	%eax, %eax
	jle	.L110
	movl	%eax, X+8(%rip)
	xorl	%eax, %eax
	andl	$0, X+60(%rip)
	cmpl	$4, X+48(%rip)
	movq	$9, X(%rip)
	sete	%al
	movl	%eax, X+56(%rip)
	andl	$0, X+52(%rip)
	ret
.L110:
	jmp	x_end.constprop.0
	.size	x_imm.constprop.0, .-x_imm.constprop.0
	.type	x_disp.constprop.0, @function
x_disp.constprop.0:
	movl	X+40(%rip), %eax
	testl	%eax, %eax
	jle	.L114
	movq	$8, X(%rip)
	movl	%eax, X+8(%rip)
	andq	$0, X+56(%rip)
	ret
.L114:
	jmp	x_imm.constprop.0
	.size	x_disp.constprop.0, .-x_disp.constprop.0
	.type	x_opcode.constprop.0, @function
x_opcode.constprop.0:
	movl	X+28(%rip), %eax
	movl	%eax, %edx
	sall	$8, %edx
	orl	%edi, %edx
	incl	%edx
	movl	%edx, X+12(%rip)
	cmpl	$2, %eax
	je	.L130
	cmpl	$3, %eax
	je	.L118
	testl	%eax, %eax
	setne	%al
	movzbl	%al, %eax
	sall	$8, %eax
	addl	%edi, %eax
	cltq
	movzbl	optab(%rax), %eax
	jmp	.L118
.L130:
	pushq	$1
	popq	%rax
.L118:
	movl	%eax, %esi
	pushq	$4
	popq	%rdx
	sarl	%esi
	cmpl	$0, X+20(%rip)
	movl	%esi, X+48(%rip)
	je	.L119
	pushq	$2
	popq	%rdx
.L119:
	leal	-1(%rsi), %ecx
	cmpl	$6, %ecx
	ja	.L120
	jmp	*.L122(,%rcx,8)
	.section	.rodata
	.align 8
	.align 4
.L122:
	.quad	.L132
	.quad	.L125
	.quad	.L126
	.quad	.L132
	.quad	.L124
	.quad	.L137
	.quad	.L121
	.text
.L120:
	xorl	%edx, %edx
	jmp	.L125
.L126:
	pushq	$2
	popq	%rdx
	jmp	.L125
.L124:
	cmpl	$0, X+24(%rip)
	je	.L125
.L137:
	pushq	$8
	popq	%rdx
	jmp	.L125
.L121:
	pushq	$3
	popq	%rdx
	jmp	.L125
.L132:
	movl	%esi, %edx
.L125:
	movl	%edx, X+44(%rip)
	testb	$1, %al
	je	.L128
	movl	$6, X(%rip)
	ret
.L128:
	jmp	x_imm.constprop.0
	.size	x_opcode.constprop.0, .-x_opcode.constprop.0
	.type	x_feed.constprop.0, @function
x_feed.constprop.0:
	movl	X+88(%rip), %eax
	andl	$0, X+96(%rip)
	cmpl	$9, X(%rip)
	leal	1(%rax), %edx
	movl	%edx, X+88(%rip)
	ja	.L138
	movl	X(%rip), %eax
	jmp	*.L141(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L141:
	.quad	.L149
	.quad	.L148
	.quad	.L184
	.quad	.L147
	.quad	.L146
	.quad	.L184
	.quad	.L144
	.quad	.L143
	.quad	.L142
	.quad	.L140
	.text
.L149:
	movslq	%edi, %rax
	movb	optab(%rax), %al
	shrb	%al
	subl	$10, %eax
	cmpb	$4, %al
	ja	.L184
	movzbl	%al, %eax
	jmp	*.L151(,%rax,8)
	.section	.rodata
	.align 8
	.align 4
.L151:
	.quad	.L155
	.quad	.L154
	.quad	.L153
	.quad	.L152
	.quad	.L150
	.text
.L155:
	imull	$31, X+16(%rip), %eax
	addl	%edi, %eax
	movl	%eax, X+16(%rip)
	cmpl	$102, %edi
	jne	.L156
	movl	$1, X+20(%rip)
.L156:
	cmpl	$8, %edx
	jle	.L138
.L157:
	jmp	x_end.constprop.0
.L153:
	imull	$31, X+16(%rip), %eax
	addl	%edi, %eax
	sarl	$3, %edi
	andl	$1, %edi
	movl	%eax, X+16(%rip)
	movl	%edi, X+24(%rip)
	ret
.L154:
	movl	$1, X(%rip)
	ret
.L152:
	movl	$3, X(%rip)
	ret
.L150:
	movl	$4, X(%rip)
	movl	$1, X+28(%rip)
	ret
.L148:
	cmpl	$56, %edi
	jne	.L158
	movl	$2, X+28(%rip)
	jmp	.L185
.L158:
	cmpl	$58, %edi
	jne	.L159
	movl	$3, X+28(%rip)
.L185:
	movl	$2, X(%rip)
	ret
.L159:
	movl	$1, X+28(%rip)
.L184:
	jmp	x_opcode.constprop.0
.L147:
	movl	%edi, %eax
	pushq	$1
	popq	%rdx
	movl	$4, X(%rip)
	andl	$3, %eax
	cmovle	%edx, %eax
	andl	$224, %edi
	movl	%eax, X+28(%rip)
	imull	$31, X+16(%rip), %eax
	addl	%edi, %eax
	movl	%eax, X+16(%rip)
	ret
.L146:
	imull	$31, X+16(%rip), %eax
	andl	$135, %edi
	movl	$5, X(%rip)
	leal	256(%rax,%rdi), %eax
	movl	%eax, X+16(%rip)
	ret
.L144:
	movl	X+48(%rip), %edx
	movl	%edi, %eax
	movl	%edi, %ecx
	movl	%edi, X+32(%rip)
	sarl	$6, %eax
	andl	$7, %ecx
	cmpl	$8, %edx
	jne	.L160
	xorl	%edx, %edx
	andl	$48, %edi
	sete	%dl
	jmp	.L162
.L160:
	cmpl	$9, %edx
	jne	.L161
	xorl	%edx, %edx
	andl	$48, %edi
	jne	.L162
	cmpl	$0, X+20(%rip)
	pushq	$4
	popq	%rdx
	je	.L162
	pushq	$2
	popq	%rdx
.L162:
	movl	%edx, X+44(%rip)
.L161:
	andl	$0, X+40(%rip)
	andl	$0, X+52(%rip)
	cmpl	$1, %eax
	jne	.L163
	movl	$1, X+40(%rip)
	jmp	.L164
.L163:
	cmpl	$2, %eax
	jne	.L165
	movl	$4, X+40(%rip)
	jmp	.L164
.L165:
	testl	%eax, %eax
	jne	.L164
	cmpl	$5, %ecx
	jne	.L164
	movl	$4, X+40(%rip)
	movl	$1, X+52(%rip)
	jmp	.L166
.L164:
	cmpl	$3, %eax
	je	.L166
	cmpl	$4, %ecx
	jne	.L166
	movl	$7, X(%rip)
	ret
.L143:
	movl	X+32(%rip), %eax
	movl	%edi, X+36(%rip)
	shrl	$6, %eax
	je	.L186
.L166:
	jmp	x_disp.constprop.0
.L186:
	andl	$7, %edi
	cmpl	$5, %edi
	jne	.L166
	movl	$4, X+40(%rip)
	jmp	.L166
.L142:
	movl	X+60(%rip), %eax
	incl	X+4(%rip)
	sall	$8, %eax
	orl	%edi, %eax
	decl	X+8(%rip)
	movl	%eax, X+60(%rip)
	jne	.L138
	cmpl	$0, X+52(%rip)
	je	.L169
	movl	$1, X+96(%rip)
	movl	X+44(%rip), %eax
	movl	%eax, X+100(%rip)
.L169:
	jmp	x_imm.constprop.0
.L140:
	movl	X+60(%rip), %eax
	incl	X+4(%rip)
	sall	$8, %eax
	orl	%edi, %eax
	decl	X+8(%rip)
	movl	%eax, X+60(%rip)
	jne	.L138
	cmpl	$0, X+56(%rip)
	je	.L157
	movq	$2, X+96(%rip)
	jmp	.L157
.L138:
	ret
	.size	x_feed.constprop.0, .-x_feed.constprop.0
	.type	x_reset.constprop.0, @function
x_reset.constprop.0:
	xorl	%eax, %eax
.L188:
	movb	$0, X(%rax)
	incq	%rax
	cmpq	$104, %rax
	jne	.L188
	orq	$-1, X+32(%rip)
	ret
	.size	x_reset.constprop.0, .-x_reset.constprop.0
	.type	unxform, @function
unxform:
	pushq	%rbp
	movl	%esi, %r9d
	movl	%edx, %r10d
	movl	%edi, %r11d
	pushq	%rbx
	leal	3(%rdi), %r8d
	call	x_reset.constprop.0
.L191:
	cmpl	%r9d, %r11d
	jnb	.L195
	movq	buf(%rip), %rbp
	leaq	0(%rbp,%r11), %rbx
	movzbl	(%rbx), %edi
	call	x_feed.constprop.0
	cmpl	$0, X+96(%rip)
	je	.L192
	cmpl	%r8d, %r11d
	jb	.L192
	leal	-3(%r11), %edi
	leal	-2(%r11), %esi
	leal	-1(%r11), %eax
	movzbl	0(%rbp,%rsi), %ecx
	leaq	0(%rbp,%rax), %rdx
	movzbl	0(%rbp,%rdi), %eax
	sall	$16, %ecx
	sall	$24, %eax
	orl	%ecx, %eax
	movzbl	(%rbx), %ecx
	orl	%ecx, %eax
	movzbl	(%rdx), %ecx
	sall	$8, %ecx
	orl	%ecx, %eax
	movl	X+100(%rip), %ecx
	notl	%ecx
	subl	%r10d, %ecx
	subl	%r11d, %ecx
	addl	%ecx, %eax
	movl	%eax, %ecx
	movb	%al, 0(%rbp,%rdi)
	shrl	$16, %ecx
	movb	%ah, 0(%rbp,%rsi)
	shrl	$24, %eax
	movb	%cl, (%rdx)
	movb	%al, (%rbx)
.L192:
	incq	%r11
	jmp	.L191
.L195:
	popq	%rbx
	popq	%rbp
	ret
	.size	unxform, .-unxform
	.type	update, @function
update:
	testl	%edi, %edi
	movl	$65535, %ecx
	movl	$0, %eax
	movl	$ctx, %r9d
	cmove	%eax, %ecx
	xorl	%r8d, %r8d
.L200:
	movq	8(%r9), %rdx
	movl	%ecx, %esi
	movzwl	(%rdx), %r11d
	movb	4(%rdx), %al
	movl	%r11d, %r10d
	subl	%r11d, %esi
	movzbl	%al, %r11d
	movzwl	rec_t(%r11,%r11), %r11d
	imull	%r11d, %esi
	sarl	$16, %esi
	addl	%esi, %r10d
	movw	%r10w, (%rdx)
	cmpb	$-1, %al
	je	.L198
	incl	%eax
	movb	%al, 4(%rdx)
.L198:
	movzwl	2(%rdx), %r10d
	movl	%ecx, %esi
	subl	%r10d, %esi
	movl	%r10d, %eax
	sarl	$8, %esi
	addl	%esi, %eax
	movslq	20(%r9), %rsi
	movw	%ax, 2(%rdx)
	movslq	%r8d, %rax
	imulq	$1036, %rax, %rax
	leaq	8(%rsi,%rax), %r10
	movl	%ecx, %esi
	movzwl	ctx+8(%r10,%r10), %r11d
	subl	%r11d, %esi
	movl	%r11d, %eax
	sarl	$6, %esi
	addl	%esi, %eax
	movw	%ax, ctx+8(%r10,%r10)
	movzbl	6(%rdx), %eax
	addl	%eax, %eax
	orl	%edi, %eax
	cmpl	$63, %eax
	jle	.L199
	andl	$31, %eax
	orl	$32, %eax
.L199:
	incl	%r8d
	movb	%al, 6(%rdx)
	addq	$2072, %r9
	cmpl	$25, %r8d
	jne	.L200
	movslq	mm+28(%rip), %rax
	testl	%eax, %eax
	js	.L201
	movzwl	mm+34(%rip), %edx
	cmpl	%edi, %edx
	sete	%dl
	addq	$8, %rax
	movzbl	%dl, %edx
	movzwl	mm(,%rax,4), %esi
	imull	$65535, %edx, %edx
	movl	%esi, %ecx
	subl	%esi, %edx
	sarl	$6, %edx
	addl	%edx, %ecx
	movw	%cx, mm(,%rax,4)
.L201:
	movslq	mm+316(%rip), %rax
	testl	%eax, %eax
	js	.L202
	movzwl	mm+322(%rip), %edx
	cmpl	%edi, %edx
	sete	%dl
	addq	$80, %rax
	movzbl	%dl, %edx
	movzwl	mm(,%rax,4), %esi
	imull	$65535, %edx, %edx
	movl	%esi, %ecx
	subl	%esi, %edx
	sarl	$6, %edx
	addl	%edx, %ecx
	movw	%cx, mm(,%rax,4)
.L202:
	movl	%edi, %ecx
	movl	nin(%rip), %r9d
	xorl	%edx, %edx
	sall	$12, %ecx
.L205:
	movslq	sel(,%rdx,4), %rax
	movl	%ecx, %r10d
	xorl	%esi, %esi
	subl	p1(,%rdx,4), %r10d
	imulq	$640, %rax, %rax
	addq	w1(,%rdx,8), %rax
.L203:
	cmpl	%esi, %r9d
	jle	.L224
	movl	in(,%rsi,4), %r8d
	incq	%rsi
	imull	%r10d, %r8d
	sarl	$11, %r8d
	addl	%r8d, (%rax)
	addq	$4, %rax
	jmp	.L203
.L224:
	incq	%rdx
	cmpq	$6, %rdx
	jne	.L205
	movslq	c0(%rip), %rax
	subl	pmix(%rip), %ecx
	xorl	%edx, %edx
	movq	%rax, %rsi
	imulq	$28, %rax, %rax
	addq	w2(%rip), %rax
.L206:
	movl	in2(%rdx), %r8d
	addq	$4, %rdx
	imull	%ecx, %r8d
	sarl	$12, %r8d
	addl	%r8d, (%rax)
	addq	$4, %rax
	cmpq	$28, %rdx
	jne	.L206
	movl	%edi, %edx
	xorl	%ecx, %ecx
	negl	%edx
	andl	$65600, %edx
	subl	%edi, %edx
	subl	%edi, %edx
.L207:
	movslq	apm+8(%rcx), %rax
	movl	%edx, %r9d
	addq	$16, %rcx
	addq	%rax, %rax
	addq	apm-16(%rcx), %rax
	movzwl	(%rax), %r10d
	subl	%r10d, %r9d
	movl	%r10d, %r8d
	sarl	$6, %r9d
	addl	%r9d, %r8d
	movw	%r8w, (%rax)
	cmpq	$48, %rcx
	jne	.L207
	movl	bpos(%rip), %eax
	addl	%esi, %esi
	orl	%edi, %esi
	incl	%eax
	movl	%esi, c0(%rip)
	movl	%eax, bpos(%rip)
	cmpl	$8, %eax
	jne	.L196
	movl	pos(%rip), %r8d
	movq	buf(%rip), %rdx
	andl	$0, bpos(%rip)
	movl	$1, c0(%rip)
	leal	1(%r8), %eax
	movl	%r8d, %edi
	movl	%eax, pos(%rip)
	movl	%r8d, %eax
	movb	%sil, (%rdx,%rax)
	call	intextp
	testl	%eax, %eax
	je	.L209
	cmpl	t2lo(%rip), %r8d
	movzbl	%sil, %edi
	je	.L210
	movl	$PK_HOLE_LO, %eax
	cmpl	%eax, %r8d
	jne	.L211
.L210:
	call	x_reset.constprop.0
.L211:
	call	x_feed.constprop.0
	jmp	.L212
.L209:
	movl	X(%rip), %eax
	orl	X+12(%rip), %eax
	je	.L212
	call	x_reset.constprop.0
.L212:
	movl	$mm, %edi
	call	mm_byte
	movl	$mm+288, %edi
	call	mm_byte
	jmp	byte_update
.L196:
	ret
	.size	update, .-update
	.type	unpack, @function
unpack:
	pushq	%r15
	movl	$PK_HOLE_LEN, %eax
	pushq	%r14
	pushq	%r13
	pushq	%r12
	movq	%rdi, %r12
	pushq	%rbp
	leal	(%rax), %ebp
	pushq	%rbx
	subq	$32, %rsp
	movl	(%rdi), %ebx
	movq	%rsi, 16(%rsp)
	movl	%edx, 4(%rsp)
	testl	%eax, %eax
	je	.L226
	movl	%ebx, %eax
	subl	%ebp, %eax
	movl	%eax, t2lo(%rip)
.L226:
	movl	%ebx, %r9d
	movl	$8192, %edi
	movl	$-2047, %r8d
	subl	%ebp, %r9d
	cmpl	$0, 4(%rsp)
	cmovne	%ebx, %r9d
	xorl	%esi, %esi
	call	alloc
	xchgq	%rax, %r10
	movq	%r10, stretch_t(%rip)
.L230:
	movl	%r8d, %edi
	call	squash
	xchgl	%eax, %edx
	movslq	%esi, %rax
.L228:
	cmpl	%eax, %edx
	jl	.L276
	movw	%r8w, (%r10,%rax,2)
	incq	%rax
	jmp	.L228
.L276:
	incl	%r8d
	leal	1(%rdx), %esi
	cmpl	$2048, %r8d
	jne	.L230
	movslq	%esi, %rax
.L231:
	cmpl	$4095, %eax
	jg	.L277
	movw	$2047, (%r10,%rax,2)
	incq	%rax
	jmp	.L231
.L277:
	call	init_optab
	pushq	$3
	movl	$rec_t, %esi
	popq	%rcx
.L233:
	movl	$131072, %eax
	addq	$2, %rsi
	cltd
	idivl	%ecx
	addl	$2, %ecx
	movw	%ax, -2(%rsi)
	cmpl	$515, %ecx
	jne	.L233
	leal	8(%rbx), %edi
	call	alloc
	movl	$4194304, %edi
	movq	%rax, 8(%rsp)
	movq	%rax, buf(%rip)
	call	x_reset.constprop.0
	movl	$4, mm(%rip)
	call	alloc
	orl	$-1, mm+24(%rip)
	movq	%rax, mm+8(%rip)
	xorl	%eax, %eax
.L234:
	movw	$-32768, mm+34(%rax)
	addq	$4, %rax
	movw	$-32768, mm+28(%rax)
	cmpq	$256, %rax
	jne	.L234
	movl	$2, mm+288(%rip)
	movl	$4194304, %edi
	call	alloc
	orl	$-1, mm+312(%rip)
	movq	%rax, mm+296(%rip)
	xorl	%eax, %eax
.L235:
	movw	$-32768, mm+322(%rax)
	addq	$4, %rax
	movw	$-32768, mm+316(%rax)
	cmpq	$256, %rax
	jne	.L235
	xorl	%edx, %edx
.L238:
	movzwl	selsize(%rdx,%rdx), %edi
	imull	$160, %edi, %esi
	imull	$640, %edi, %edi
	call	alloc
	xchgq	%rax, %rcx
	xorl	%eax, %eax
	movq	%rcx, w1(,%rdx,8)
.L236:
	cmpl	%esi, %eax
	jnb	.L278
	movl	$16384, (%rcx,%rax,4)
	incq	%rax
	jmp	.L236
.L278:
	incq	%rdx
	cmpq	$6, %rdx
	jne	.L238
	movl	$7168, %edi
	call	alloc
	xchgq	%rax, %rdx
	xorl	%eax, %eax
	movq	%rdx, w2(%rip)
.L239:
	movl	$16384, (%rdx,%rax,4)
	incq	%rax
	cmpq	$1792, %rax
	jne	.L239
	xorl	%r8d, %r8d
	movl	$101376, %r13d
.L242:
	cmpq	$1, %r8
	movl	$2162688, %r10d
	sbbl	%edx, %edx
	andl	$-62464, %edx
	addl	$65536, %edx
	imull	$66, %edx, %edi
	call	alloc
	xchgq	%rax, %r14
	movq	%r8, %rax
	salq	$4, %rax
	cmpl	$3072, %edx
	movq	%r14, apm(%rax)
	cmove	%r13d, %r10d
	xorl	%esi, %esi
	pushq	$33
	popq	%r11
.L241:
	movl	%esi, %eax
	xorl	%edx, %edx
	divl	%r11d
	leal	-16(%rdx), %edi
	sall	$7, %edi
	call	squash
	sall	$4, %eax
	movw	%ax, (%r14,%rsi,2)
	incq	%rsi
	cmpl	%r10d, %esi
	jb	.L241
	incq	%r8
	cmpq	$3, %r8
	jne	.L242
	xorl	%edx, %edx
.L245:
	movl	$8388608, %edi
	call	alloc
	xchgq	%rax, %rcx
	xorl	%eax, %eax
	movq	%rcx, ctx(%rdx)
.L243:
	movw	$-32768, 2(%rcx,%rax,8)
	movw	$-32768, (%rcx,%rax,8)
	movb	$1, 6(%rcx,%rax,8)
	incq	%rax
	cmpq	$1048576, %rax
	jne	.L243
	xorl	%eax, %eax
.L244:
	movw	$-32768, ctx+24(%rdx,%rax,2)
	incq	%rax
	cmpq	$1024, %rax
	jne	.L244
	addq	$2072, %rdx
	cmpq	$51800, %rdx
	jne	.L245
	call	byte_update
	xorl	%eax, %eax
	xorl	%edx, %edx
.L246:
	movzbl	4(%r12,%rax), %ecx
	sall	$8, %edx
	incq	%rax
	orl	%ecx, %edx
	cmpq	$4, %rax
	jne	.L246
	imull	$8, %r9d, %eax
	addq	$8, %r12
	xorl	%r13d, %r13d
	orl	$-1, %r15d
	xorl	%r14d, %r14d
	movl	%eax, 24(%rsp)
.L247:
	cmpl	24(%rsp), %r13d
	jnb	.L279
	movl	%edx, 28(%rsp)
	call	predict
	movl	28(%rsp), %edx
	movslq	%eax, %rdi
	movl	%r15d, %eax
	subl	%r14d, %eax
	imulq	%rdi, %rax
	xorl	%edi, %edi
	shrq	$12, %rax
	addl	%r14d, %eax
	cmpl	%edx, %eax
	setnb	%dil
	jnb	.L248
	leal	1(%rax), %r14d
	xchgl	%r15d, %eax
.L248:
	xchgl	%eax, %r15d
.L249:
	movl	%r14d, %eax
	xorl	%r15d, %eax
	cmpl	$16777215, %eax
	ja	.L280
	movl	%r15d, %ecx
	movzbl	(%r12), %eax
	sall	$8, %edx
	incq	%r12
	sall	$8, %ecx
	sall	$8, %r14d
	orb	$-1, %cl
	orl	%eax, %edx
	movl	%ecx, %r15d
	jmp	.L249
.L280:
	movl	%edx, 28(%rsp)
	incl	%r13d
	call	update
	movl	28(%rsp), %edx
	jmp	.L247
.L279:
	movl	$PK_TEXT_HI, %eax
	xchgl	%eax, %r13d
	movl	$PK_TEXT_LO, %eax
	xchgl	%eax, %edi
	testl	%ebp, %ebp
	je	.L252
	movl	$PK_HOLE_LO, %eax
	xorl	%edx, %edx
	xchgl	%eax, %r12d
	movl	%r12d, %esi
	call	unxform
	movl	%r13d, %esi
	movl	%ebp, %edx
	movl	%r12d, %edi
	subl	%ebp, %esi
	call	unxform
	cmpl	$0, 4(%rsp)
	je	.L253
	leal	0(%rbp,%r12), %edx
	movl	%ebx, %edi
	movl	%ebx, %esi
	subl	%ebx, %edx
	subl	%ebp, %edi
	jmp	.L275
.L252:
	cmpl	%r13d, %ebx
	movl	%r13d, %esi
	cmovbe	%ebx, %esi
	xorl	%edx, %edx
.L275:
	call	unxform
.L253:
	movq	16(%rsp), %rax
	movl	%ebx, (%rax)
	movq	8(%rsp), %rax
	addq	$32, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
	.size	unpack, .-unpack
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	""
	.section	.text.entry,"ax",@progbits
	.globl	cstart
	.type	cstart, @function
cstart:
	pushq	%r14
	orq	$-1, %r9
	movl	$335544320, %edx
	pushq	%r13
	pushq	%r12
	leaq	8(%rdi), %r12
	pushq	%rbp
	pushq	%rbx
	movq	%rsi, %rbx
	xorl	%esi, %esi
	subq	$64, %rsp
	movq	(%rdi), %rax
	pushq	$34
	popq	%r8
	pushq	$3
	popq	%rcx
	leaq	16(%rdi,%rax,8), %r13
	pushq	$9
	popq	%rdi
	call	sys.constprop.0
	xorl	%edx, %edx
	leaq	12(%rsp), %rsi
	movq	%rbx, %rdi
	movq	%rax, arena(%rip)
	cmpb	$0, 4194313
	sete	%dl
	call	unpack
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	movl	$.LC0, %esi
	movl	$319, %edi
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	xchgq	%rax, %rbx
	call	sys.constprop.0
	leaq	28(%rsp), %rdi
	pushq	$9
	popq	%rcx
	movslq	%eax, %r14
	xorl	%eax, %eax
	leal	PK_HOLE_LEN(%rip), %esi
	movl	$PK_HOLE_LEN, %edx
	rep stosl
	movl	$PK_HOLE_LO, %eax
	movl	%eax, 24(%rsp)
	movl	12(%rsp), %eax
	leaq	16(%rsp), %rbp
	movq	%rbx, 16(%rsp)
	movq	%rax, %rcx
	subq	%rsi, %rax
	addq	%rbx, %rax
	movq	%rax, 32(%rsp)
	movl	$PK_HOLE_LEN, %eax
	movl	%eax, 40(%rsp)
	leal	PK_HOLE_LO(%rip), %eax
	addq	%rax, %rbx
	movl	$PK_HOLE_LO, %eax
	addl	%edx, %eax
	movq	%rbx, 48(%rsp)
	subl	%eax, %ecx
	movl	%ecx, 56(%rsp)
.L282:
	xorl	%ebx, %ebx
.L287:
	movl	8(%rbp), %ecx
	cmpl	%ecx, %ebx
	jnb	.L286
	movl	%ebx, %edx
	addq	0(%rbp), %rdx
	pushq	$1
	subl	%ebx, %ecx
	xorl	%r9d, %r9d
	xorl	%r8d, %r8d
	movq	%r14, %rsi
	popq	%rdi
	call	sys.constprop.0
	testq	%rax, %rax
	jg	.L283
.L286:
	addq	$16, %rbp
	leaq	64(%rsp), %rax
	cmpq	%rax, %rbp
	jne	.L282
	movq	%r13, %r8
	movq	%r12, %rcx
	movq	%r14, %rsi
	movl	$4096, %r9d
	movl	$.LC0, %edx
	movl	$322, %edi
	call	sys.constprop.0
	pushq	$127
	popq	%rsi
	xorl	%r9d, %r9d
	pushq	$60
	popq	%rdi
	xorl	%r8d, %r8d
	xorl	%ecx, %ecx
	xorl	%edx, %edx
	addq	$64, %rsp
	popq	%rbx
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	jmp	sys.constprop.0
.L283:
	addl	%eax, %ebx
	jmp	.L287
	.size	cstart, .-cstart
	.data
	.align 4
	.type	t2lo, @object
	.size	t2lo, 4
t2lo:
	.long	-1
	.local	rec_t
	.comm	rec_t,512,32
	.section	.rodata
	.align 8
	.type	selsize, @object
	.size	selsize, 12
selsize:
	.value	256
	.value	3072
	.value	256
	.value	2048
	.value	1024
	.value	4096
	.local	w2
	.comm	w2,8,8
	.local	w1
	.comm	w1,48,32
	.local	pmix
	.comm	pmix,4,4
	.local	in2
	.comm	in2,28,16
	.local	p1
	.comm	p1,24,16
	.local	sel
	.comm	sel,24,16
	.local	nin
	.comm	nin,4,4
	.local	in
	.comm	in,640,32
	.local	bpos
	.comm	bpos,4,4
	.data
	.align 4
	.type	c0, @object
	.size	c0, 4
c0:
	.long	1
	.local	pos
	.comm	pos,4,4
	.local	buf
	.comm	buf,8,8
	.local	X
	.comm	X,104,32
	.local	apm
	.comm	apm,48,32
	.local	mm
	.comm	mm,576,32
	.local	ctx
	.comm	ctx,51800,32
	.section	.rodata
	.align 32
	.type	opr, @object
	.size	opr, 217
opr:
	.base64	"JiYULi4UNjYUPj4UDw8WQE8YUGIAY2MBZGcUaGgEaWkFamoCa2sDbG8AcH8CgIADgYEFgoMDhI8BkJ8AoKMMpKcAqKgCqakEqq8AsLcCuL8KwMEDwsIGw8MAxMQaxcUcxsYDx8cFyMgOyckAysoGy8wAzc0Czs8A0NMB1NcA2N8B4OcC6OkI6uoA6+sC7O8A8PAU8fEA8vMU9PUA9vYR9/cT+P0A/v8B/wD/AQULAA4OAA8PAzA3AHBzA3d3AICPCKCiAKSkA6iqAKysA7q6A8LCA8TGA8jPAA=="
	.local	optab
	.comm	optab,512,32
	.local	stretch_t
	.comm	stretch_t,8,8
	.align 32
	.type	sqt, @object
	.size	sqt, 66
sqt:
	.value	1
	.value	2
	.value	3
	.value	6
	.value	10
	.value	16
	.value	27
	.value	45
	.value	73
	.value	120
	.value	194
	.value	310
	.value	488
	.value	747
	.value	1101
	.value	1546
	.value	2047
	.value	2549
	.value	2994
	.value	3348
	.value	3607
	.value	3785
	.value	3901
	.value	3975
	.value	4024
	.value	4050
	.value	4068
	.value	4079
	.value	4085
	.value	4089
	.value	4092
	.value	4093
	.value	4094
	.local	arena
	.comm	arena,8,8
	.align 32
	.type	cfg, @object
	.size	cfg, 112
cfg:
	.base64	"AAEC/wABAgMEBf8AA/8BAgP/CAkLDP8IDwn/CA4J/wgAAf8TAP8ICQsMDR3/CBAY/wgtH/8HKSr/CBz/CAkQLv8IDhj/CAkMHv8DByj/CAkLDA3/CAkKCw7/CAkMAP8IDy3/CAkLIv8IGAH/AAQl/w=="
	.section	.note.GNU-stack,"",@progbits
