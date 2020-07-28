	ifndef	??version
?debug	macro
	endm
	endif
	?debug	S "timer.c"
_TEXT	segment	byte public 'CODE'
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP,ss:DGROUP
_TEXT	ends
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
	?debug	C E9764BFB1C0774696D65722E63
_BSS	ends
_TEXT	segment	byte public 'CODE'
;	?debug	L 21
_DelayMilliseconds	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
;	?debug	L 25
	call	near ptr _SyncTime
	add	ax,word ptr [bp+4]
	adc	dx,word ptr [bp+6]
	mov	word ptr [bp-6],dx
	mov	word ptr [bp-8],ax
;	?debug	L 26
	jmp	short @2
@4:
@2:
	call	far ptr GETLOWTICKCOUNT
	mov	word ptr [bp-2],dx
	mov	word ptr [bp-4],ax
	cmp	dx,word ptr [bp-6]
	jb	@4
	jne	@5
	cmp	ax,word ptr [bp-8]
	jb	@4
@5:
@3:
@1:
;	?debug	L 28
	mov	sp,bp
	pop	bp
	ret	
_DelayMilliseconds	endp
;	?debug	L 30
_SyncTime	proc	near
	push	bp
	mov	bp,sp
	sub	sp,8
;	?debug	L 35
	call	far ptr GETLOWTICKCOUNT
	mov	word ptr [bp-6],dx
	mov	word ptr [bp-8],ax
	jmp	short @7
@9:
@7:
;	?debug	L 36
	call	far ptr GETLOWTICKCOUNT
	mov	word ptr [bp-2],dx
	mov	word ptr [bp-4],ax
	cmp	dx,word ptr [bp-6]
	jne	@10
	cmp	ax,word ptr [bp-8]
	je	@9
@10:
@8:
;	?debug	L 38
	mov	dx,word ptr [bp-2]
	mov	ax,word ptr [bp-4]
	jmp	short @6
@6:
;	?debug	L 40
	mov	sp,bp
	pop	bp
	ret	
_SyncTime	endp
_TEXT	ends
	?debug	C E9
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
	extrn	GETLOWTICKCOUNT:far
_TEXT	segment	byte public 'CODE'
_TEXT	ends
	public	_SyncTime
	public	_DelayMilliseconds
	end
