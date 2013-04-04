
format MS COFF
section '.code' code readable executable

public __cmp64
public __add64
public __sub64
public __and64
public __or64
public __xor64
public __umul64
public __shl64
public __shr64
public __sar64
public __lookup

__cmp64:
	mov	eax, [esp + 16]
	cmp	eax, [esp + 8]
	jnz	.1
	mov	eax, [esp + 12]
	cmp	eax, [esp + 4]
	jz	.1
	mov	ax, $0201
	ja	.2
	cmp	al, ah
	ret	16
.2:	cmp	ah, al
.1:	ret	16

__add64:
	mov	eax, [esp + 12]
	mov	edx, [esp + 16]
	add	eax, [esp + 4]
	adc	edx, [esp + 8]
	ret	16

__sub64:
	mov	eax, [esp + 12]
	mov	edx, [esp + 16]
	sub	eax, [esp + 4]
	sbb	edx, [esp + 8]
	ret	16

__and64:
	mov	eax, [esp + 12]
	mov	edx, [esp + 16]
	and	eax, [esp + 4]
	and	edx, [esp + 8]
	ret	16

__or64:
	mov	eax, [esp + 12]
	mov	edx, [esp + 16]
	or	eax, [esp + 4]
	or	edx, [esp + 8]
	ret	16

__xor64:
	mov	eax, [esp + 12]
	mov	edx, [esp + 16]
	xor	eax, [esp + 4]
	xor	edx, [esp + 8]
	ret	16

__umul64:
	push	ebx
	mov	eax, [esp + 8]
	mul	dword [esp + 16]
	mov	ebx, eax
	mov	ecx, edx
	
	mov	eax, [esp + 8]
	mul	dword [esp + 20]
	add	ecx, eax
	
	mov	eax, [esp + 12]
	mul	dword [esp + 16]
	add	ecx, eax
	
	mov	eax, ebx
	mov	edx, ecx
	pop	ebx
	ret	16

__shl64:
	mov	eax, [esp + 8]
	mov	edx, [esp + 12]
	mov	ecx, [esp + 4]
        	cmp	cl, 64
	jnc	.zero
	cmp	cl, 32
	jnc	.1
	shld	edx, eax, cl
	shl	eax, cl
	ret	12

.1:	mov	edx, eax
	xor	eax, eax
	sub	cl, 32
	shl	edx, cl
	ret	12

.zero:	xor	edx, edx
	xor	eax, eax
	ret	12

__shr64:
	mov	eax, [esp + 8]
	mov	edx, [esp + 12]
	mov	ecx, [esp + 4]
        	cmp	cl, 64
	jnc	.zero
	cmp	cl, 32
	jnc	.1
	shrd	eax, edx, cl
	shr	edx, cl
	ret	12

.1:	sub	cl, 32
	mov	eax, edx
	shr	eax, cl
	xor	edx, edx
	ret	12

.zero:	xor	edx, edx
	xor	eax, eax
	ret	12

__sar64:
	mov	eax, [esp + 8]
	mov	edx, [esp + 12]
	mov	ecx, [esp + 4]
        	cmp	cl, 64
	jnc	.sign
	cmp	cl, 32
	jnc	.1
	shrd	eax, edx, cl
	sar	edx, cl
	ret	12

.1:	sub	cl, 32
	mov	eax, edx
	sar	eax, cl
	sar	edx, 31
	ret	12

.sign:	sar	edx, 31
	mov	eax, edx
	ret	12

__lookup:
	sub	ecx, 8
.next:	add	ecx, 8
	cmp	dword [ecx + 4], 0
	jz	.default
	cmp	[ecx], eax
	jnz	.next
	jmp	dword [ecx + 4]
.default:	jmp	dword [ecx]
