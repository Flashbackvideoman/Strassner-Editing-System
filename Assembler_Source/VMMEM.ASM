	.286p
	ifndef	??version
?debug	macro
	endm
publicdll macro	name
	public	name
	endm
$comm	macro	name,dist,size,count
	comm	dist name:BYTE:count*size
	endm
	else
$comm	macro	name,dist,size,count
	comm	dist name[size]:BYTE:count
	endm
	endif
	?debug	V 301h
	?debug	S "vmmem.c"
	?debug	C E96D574C1E07766D6D656D2E63
_TEXT	segment byte public 'CODE'
_TEXT	ends
DGROUP	group	_DATA,_BSS
	assume	cs:_TEXT,ds:DGROUP
_DATA	segment word public 'DATA'
d@	label	byte
d@w	label	word
_DATA	ends
_BSS	segment word public 'BSS'
b@	label	byte
b@w	label	word
_BSS	ends
_DATA	segment word public 'DATA'
$eefapoga	label	word
	db	192
	db	122
	db	16
	db	0
	db	224
	db	165
	db	1
	db	0
	db	80
	db	70
	db	0
	db	0
	db	8
	db	7
	db	0
	db	0
	db	44
	db	1
	db	0
	db	0
	db	30
	db	0
	db	0
	db	0
	db	10
	db	0
	db	0
	db	0
	db	1
	db	0
	db	0
	db	0
	db	136
	db	118
	db	16
	db	0
	db	116
	db	165
	db	1
	db	0
	db	62
	db	70
	db	0
	db	0
	db	6
	db	7
	db	0
	db	0
	db	44
	db	1
	db	0
	db	0
	db	30
	db	0
	db	0
	db	0
	db	10
	db	0
	db	0
	db	0
	db	1
	db	0
	db	0
	db	0
	db	160
	db	187
	db	13
	db	0
	db	144
	db	95
	db	1
	db	0
	db	152
	db	58
	db	0
	db	0
	db	220
	db	5
	db	0
	db	0
	db	250
	db	0
	db	0
	db	0
	db	25
	db	0
	db	0
	db	0
	db	10
	db	0
	db	0
	db	0
	db	1
	db	0
	db	0
	db	0
_DATA	ends
_TEXT	segment byte public 'CODE'
   ;	
   ;	unsigned long _pascal ConvertToVal(char * tc, char cfcm)
   ;	
	assume	cs:_TEXT,ds:DGROUP
CONVERTTOVAL	proc	near
	enter	104,0
	push	si
	push	di
   ;	
   ;	{
   ;	register int tct;
   ;	register int	l, c1;
   ;	register TIMECODE bin=0;				/* result, default=0 */
   ;	
	mov	word ptr [bp-6],0
	mov	word ptr [bp-8],0
   ;	
   ;	TIMECODE frmtbl[] =
   ;		{
   ;	
   ;	
   ;		/*  0 +00 ndf (30 frames/sec) */
   ;		0x107ac0l,0x01a5e0l,	/* 1,080,000l, 108,000l */
   ;		0x004650l,0x000708l,	/*    18,000l,   1,800l */
   ;		0x00012cl,0x00001el,	/*       300l,      30l */
   ;		0x00000al,0x000001l,	/*        10l,       1l */
   ;	
   ;		/* 1 +08 df (29.97 frames/sec) */
   ;		0x107688l,0x01a574l,	/* 1,078,920l,  107,892l */
   ;		0x00463el,0x000706l,	/*    17,982l,    1,798l */
   ;		0x00012cl,0x00001el,	/*       300l,       30l */
   ;		0x00000al,0x000001l,	/*        10l,        1l */
   ;	
   ;		/* 2 +16 pal (25 frames/second) */
   ;		0x0dbba0l,0x015f90l,	/* 900,000l, 90,000l */
   ;		0x003a98l,0x0005dcl,	/*  15,000l,  1,500l */
   ;		0x0000fal,0x000019l,	/*     250l,     25l */
   ;		0x00000al,0x000001l,	/*      10l,      1l */
   ;		};
   ;	
	lea	ax,word ptr [bp-104]
	push	ss
	push	ax
	push	ds
	push	offset DGROUP:$eefapoga
	mov	cx,96
	call	near ptr N_SCOPY@
   ;	
   ;	
   ;	register ptrTIMECODE t=&frmtbl[7]; 	/* base = units frames */
   ;	
	lea	ax,word ptr [bp-76]
	mov	di,ax
   ;	
   ;	
   ;		switch(cfcm)
   ;	
	mov	al,byte ptr [bp+4]
	cbw	
	cmp	ax,68
	je	short @1@226
	cmp	ax,78
	je	short @1@198
	cmp	ax,80
	je	short @1@254
	jmp	short @1@282
@1@198:
	jmp	short @1@282
@1@226:
   ;	
   ;			{
   ;			case 'N':	tct = 0; break;
   ;			case 'D':	tct = 1; break;
   ;	
	mov	word ptr [bp-2],1
	jmp	short @1@310
@1@254:
   ;	
   ;			case 'P':	tct = 3; break;
   ;	
	mov	word ptr [bp-2],3
	jmp	short @1@310
@1@282:
   ;	
   ;			default:	tct = 0;
   ;	
	mov	word ptr [bp-2],0
@1@310:
   ;	
   ;			}
   ;	
   ;	//	if(tct < 2) t+=(tct << 3);		/* 0 = ndf, 1 = df */
   ;		if(tct < 2) t+=(8 * tct);		/* 0 = ndf, 1 = df */
   ;	
	cmp	word ptr [bp-2],2
	jge	short @1@366
	mov	ax,word ptr [bp-2]
	shl	ax,3
	shl	ax,2
	add	di,ax
	jmp	short @1@394
@1@366:
   ;	
   ;			else t+=(16);				/* pal */
   ;	
	add	di,64
@1@394:
   ;	
   ;	
   ;		l=0;
   ;	
	xor	si,si
	jmp	short @1@450
@1@422:
   ;	
   ;		while(tc[l] != '\0') l++;
   ;	
	inc	si
@1@450:
	mov	bx,word ptr [bp+6]
	cmp	byte ptr [bx+si],0
	jne	short @1@422
   ;	
   ;		if(++l > 11)
   ;	
	inc	si
	mov	ax,si
	cmp	ax,11
	jle	short @1@534
   ;	
   ;	//	if( (l=strlen(tc)) > 11)
   ;			l = 11;					/* max chars to convert */
   ;	
	mov	si,11
@1@534:
   ;	
   ;		tc+=l;							/* to end of string */
   ;	
	add	word ptr [bp+6],si
   ;	
   ;		c1=8;							/* max table size */
   ;	
	mov	word ptr [bp-4],8
	jmp	short @1@674
@1@562:
   ;	
   ;	
   ;		/* work it out */
   ;		while(l >= 0 && c1 >=0) {
   ;			if(*tc >= '0' && *tc <= '9') {	/* number */
   ;	
	mov	bx,word ptr [bp+6]
	cmp	byte ptr [bx],48
	jl	short @1@646
	mov	bx,word ptr [bp+6]
	cmp	byte ptr [bx],57
	jg	short @1@646
   ;	
   ;				bin+= (*(tc) - '0') * (*t--);
   ;	
	mov	bx,word ptr [bp+6]
	mov	al,byte ptr [bx]
	cbw	
	add	ax,-48
	cwd	
	push	ax
	push	dx
	mov	dx,word ptr [di+2]
	mov	ax,word ptr [di]
	pop	cx
	pop	bx
	call	near ptr N_LXMUL@
	add	word ptr [bp-8],ax
	adc	word ptr [bp-6],dx
	sub	di,4
   ;	
   ;				c1--;
   ;	
	dec	word ptr [bp-4]
	jmp	short @1@646
@1@646:
   ;	
   ;				l--;
   ;				tc--;
   ;				}
   ;				else { 					/* junk character */
   ;				l--;
   ;	
	dec	si
   ;	
   ;				tc--;
   ;	
	dec	word ptr [bp+6]
@1@674:
	or	si,si
	jl	short @1@730
	cmp	word ptr [bp-4],0
	jge	short @1@562
@1@730:
   ;	
   ;				}
   ;			}
   ;		return(bin);
   ;	
	mov	dx,word ptr [bp-6]
	mov	ax,word ptr [bp-8]
	jmp	short @1@758
@1@758:
   ;	
   ;	}
   ;	
	pop	di
	pop	si
	leave	
	ret	4
CONVERTTOVAL	endp
	?debug	C E9
	?debug	C FA00000000
_TEXT	ends
_DATA	segment word public 'DATA'
s@	label	byte
_DATA	ends
_TEXT	segment byte public 'CODE'
_TEXT	ends
_s@	equ	s@
	public	CONVERTTOVAL
	extrn	N_SCOPY@:far
	extrn	N_LXMUL@:far
	end
