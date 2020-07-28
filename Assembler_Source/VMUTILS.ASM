
; VMUTILS.ASM
; Produces VMUTILS.LIB for static linking to SES.EXE

include vmver.equ


TENTHTICK EQU TRUE

if (TENTHTICK)
TMRES1      EQU 16384              ;; (WORD)((TIMERRES*10*65536)/1000)
TMRES2      EQU 549                ;; (TIMERRES*10/1000)
TMRES3      EQU 8788               ;; (TIMERRES*10*16)/1000
else
TMRES1      EQU 60620              ;; (WORD)((TIMERRES*65536)/1000)
TMRES2      EQU 54                 ;; (TIMERRES/1000)
TMRES3      EQU 56243              ;; (TIMERRES*256*4)/1000
endif


extrn Divdval:word,Dvend:word,Dvsor:word,Hdeptr:word,Odeptr:word,Count:word,tick_Count:dword
extrn sync_count1:dword,sync_count2:dword,delay_count1:dword,delay_count2:dword
extrn synctime1:dword,synctime2:dword,wFrac:word,Hide1:word,Hide2:word,Calcstor3:word
extrn Alb_Pntr:word,Twenty4hrs:word
extrn Bytstr1:word,Bytstr2:word,Bytstr3:word,Bytstr4:word
extrn _ConOut:far

UTILSEG	segment word public 'CODE'
	assume	cs:UTILSEG, ds:_DATA

Public SyncTime,dhd,_strlen,_get_checksum,_DelayMilliseconds,GetLowTickCount
Public _adv2chr,_advance,_adv2spc,_cmpchr,_BitCountSet,_BitCountReset,_mpbadd
Public _mpbsub,_mpbdiv,_time_value,_mpbmul,_cmp24b,_cmp24b_DSES,_cmp24b_ESDS
Public _mmv3byt,_mmv3_ds2es,_mmv3_es2ds,_store_Spaces,_space_store,_tcm_store
Public _comsg_store,_mvb2st1_es,_mvb2st2_es,_mvb2st1,_mvb2st2,_mvb2st3
Public _mvb2st4,_tc_negate,_mmv_dx2bx,_mmv,_mmv16,_mmv_dx2esbx,_mmv_DSES
Public _mmv_ESDS,_mmv_ESES,mmvxit,_strcat,_move_subdir,_delete_backslash
Public _add_backslash,_path_extract,_title_loop_DS,_title_loop_ES,_title_loop
Public _make_ucase,_dhw,_dhb


; Find length of string at BX and return length in AL
_strlen	proc	far
	xor	al,al
strllp:	cmp	byte ptr [bx],0
	jz	strlenx
	cmp	byte ptr [bx],cr
	jz	strlenx
	inc	bx
	inc	al
	jnz	strllp
strlenx:ret
_strlen	endp


; DX = segment, BX = offset, CX = size
_get_checksum	proc	far
	push	si
	push	ds
	mov	ds,dx			; Set segment
	xor	di,di			; Zero checksum
	mov	si,bx			; Set starting offset
	shr	cx,1			; Half the Count
	clc
gcksum:	lodsw
	adc	di,ax
	ror	di,1
	loop	gcksum
	mov	bx,di
	neg	bx
	pop	ds
	pop	si
	ret
_get_checksum	endp
;================================================================
; Enter DX:AX = tick Count to delay
_DelayMilliseconds	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	es

	push	ax
	push	dx
	call	near ptr SyncTime
	pop	dx
	pop	ax

	add	ax,word ptr [tick_Count]	; Start tick
	adc	dx,word ptr [tick_Count + 2]
	mov	word ptr [delay_count1+2],dx
	mov	word ptr [delay_count1],ax
dlyms1:
	call	 FAR PTR GetLowTickCount
	mov	word ptr [delay_count2+2],dx
	mov	word ptr [delay_count2],ax
	cmp	dx,word ptr [delay_count1+2]
	jb	dlyms1
	jne	dlyms2
	cmp	ax,word ptr [delay_count1]
	jb	dlyms1
dlyms2:
	pop	es
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret	
_DelayMilliseconds	endp

SyncTime	proc	near
	call	 FAR PTR GetLowTickCount
	mov	word ptr [synctime1+2],dx
	mov	word ptr [synctime1],ax
SyncT1:	call	 FAR PTR GetLowTickCount
	mov	word ptr [synctime2+2],dx
	mov	word ptr [synctime2],ax
	cmp	dx,word ptr [synctime1+2]
	jne	SyncT2
	cmp	ax,word ptr [synctime1]
	je	SyncT1
SyncT2:	mov	dx,word ptr [synctime2+2]
	mov	ax,word ptr [synctime2]
	ret	
SyncTime	endp


GetLowTickCount	proc	far
;       /*--- Disable interrupts; Issue read-back command for counter 0 ---*/
startagn:
	mov     al, 0C2h                ;; read back command
	cli
	out     43h, al                 ;; send command to 8254
	jmp     short $+2               ;; I/O wait

;       /*--- Set carry Flag to counter 0 OUT pin status ---*/
	in      al, 40h                 ;; OUT status is in bit 7
	jmp     short $+2               ;; I/O wait
	shl     al, 1                   ;; carry = OUT status

;       /*--- Set CX to where in interval we are ---*/
        in      al, 40h                 ;; read counter low
        jmp     short $+2               ;; I/O wait
        mov     cl, al                  ;; save counter low
        in      al, 40h                 ;; read counter high
        jmp     short $+2               ;; I/O wait
        mov     ch, al                  ;; save counter high
        jcxz    glrstrt                 ;; Restart if counter is zero
        rcr     cx, 1                   ;; combine OUT status w/ counter
        not     cx                      ;; change high->low to low->high

;       /*--- Convert BIOS ticks to milliseconds (into DI:SI) ---*/
        mov     bx, 040h                ;; ROM BIOS data area segment
        mov     es, bx
        mov     bx, 06Ch                ;; offset to timer info
        mov     ax, TMRES1
        mul     WORD PTR es:[bx]
        mov     wFrac, ax               ;; fraction
        mov     si, dx
        mov     ax, TMRES1
        mul     WORD PTR es:[bx+2]
        mov     di, dx
        add     si, ax
        adc     di, 0
        mov     ax, TMRES2
        mul     WORD PTR es:[bx]
        add     si, ax
        adc     di, dx
        mov     ax, TMRES2
        mul     WORD PTR es:[bx+2]
        add     di, ax

if (TENTHTICK)
;       /*--- Get tick Count accurate to 1/10000 second ---*/
        mov     ax, TMRES3
        shr     cx, 1
        shr     cx, 1
        shr     cx, 1
        shr     cx, 1
        mul     cx                      ;; where in interval
        add     ax, WORD PTR [wFrac]    ;; add fraction
        mov     ax, si                  ;; ax = tick Count low
        adc     ax, dx
        mov     dx, di                  ;; dx = tick Count high
        adc     dx, 0                   ;;
else
;       /*--- Get tick Count accurate to 1/1000 second ---*/
        mov     ax, TMRES3
        shr     cx, 1
        shr     cx, 1
        mul     cx                      ;; where in interval
        add     ah, BYTE PTR [wFrac]    ;; add fraction low/high
        adc     dl, BYTE PTR [wFrac+1]  ;; ..to get carry
        mov     ax, si                  ;; ax = tick Count low
        adc     al, dh                  ;;
        adc     ah, 0                   ;;
        mov     dx, di                  ;; dx = tick Count high
        adc     dx, 0                   ;;
endif

;       /*--- Assure tick Count is equal or advancing ---*/
        cmp     dx, WORD PTR [tick_Count+2]
        ja      gltcdone
        cmp     ax, WORD PTR [tick_Count]
        jb      glrstrt

;       /*--- Save last tick Count obtained ---*/
gltcdone:
	mov     WORD PTR [tick_Count], ax
        mov     WORD PTR [tick_Count+2], dx
        sti
        ret

;       /*--- Restart procedure ---*/
glrstrt: sti
         jmp    startagn

GetLowTickCount ENDP



;================================================================
;	ADVANCE TO POSITIONS IN ASCII STRING
;================================================================
_adv2chr	proc	far
	mov	al,[bx]
	cmp	al,' '
	jnz	advret
	inc	bx
	jmp short	_adv2chr
_adv2chr	endp

;_adv2chr BX to next non-space or null or CH=0
_advance	proc	far
	mov	al,[bx]
	or	al,al
	jz	advret
	cmp	al,' '
	jnz	advret
	inc	bx
	dec	ch
	jnz	_advance
advret:	ret
_advance	endp

; _adv2chr BX to next space. Decrement CH (needed (?))
_adv2spc	proc	far
	mov	al,[bx]
	or	al,al
	jz	advspcx
	cmp	al,' '
	jbe	advspcx
	inc	bx
	dec	ch
	jmp	_adv2spc
advspcx:ret
_adv2spc	endp

;================================================================
;_cmpchr - compare strings es:BX : ds:DX len in CL
;================================================================
_cmpchr	proc	far
	push	bx
	push	cx
	push	si
	mov	si,dx
cmpch0:	mov	al,[si]
	cmp	al,es:[bx]
	jnz	cmpch1
	inc	bx
	inc	si
	dec	ch
	jnz	cmpch0
cmpch1:	pop	si
	pop	cx
	pop	bx
	ret
_cmpchr	endp


;================================================================
; Enter with AL = the bit number to set
; Exit with AL set the the right bit number
; i.e. if AL = 5 then Exit with AL = 00100000b
;================================================================
_BitCountSet	proc	far
	push	cx
	mov	cx,ax
	inc	cx
	xor	ax,ax
	stc
bcslp:	rcl	ax,1
	loop	bcslp
	pop	cx
	ret
_BitCountSet	endp

_BitCountReset	proc	far
	push	cx
	mov	cx,ax
	xor	ax,ax
bcrlp:	rcr	cx,1
	jc	bcrx
	inc	ax
	jmp	bcrlp
bcrx:	pop	cx
	ret
_BitCountReset	endp

;================================================================
; 24 bit binary addition
;================================================================
;ENTRY	BX = base address of array 1	ADDEND
;	DX = base address of array 2	ADDER
;Exit	Addend replaced by addend plus adder
_mpbadd	proc	far
	push	si
	mov	si,dx
	mov	ax,[si]
	add	[bx],ax
	mov	al,2[si]
	adc	2[bx],al
	xor	al,al
	pop	si
	ret
_mpbadd	endp

;
;ENTRY	BX = base address of minuend
;	DX = base address of subtrahend
;Exit	Minuend = minuend - subtrahend
_mpbsub	proc	far
	push	si
	mov	si,dx
	mov	ax,[si]
	sub	[bx],ax
	mov	al,2[si]
	sbb 	2[bx],al
	pop	si
	ret
_mpbsub	endp

;================================================================
;Divide 24 bit arrays
;================================================================
;Enter	BX = address of dividend
;	DX = address of divisor
;Exit	Dividend = dividend / divisor
;	BX = address of product
;	AX -> Hdeptr =  address of remainder
;	Carry set if division by zero
;
; NOTE: CX IS USED
;

_mpbdiv	proc	far
	push	es
	push	ds
	pop	es

	push	si
	push	di
	push	bx
	mov	Dvend,bx
	mov	Dvsor,dx
	mov	Count,25	; Count = number of bits in array + 1

;Clear out accumulators, 6 contiguous bytes at Hide1, Hide2
	mov	bx,offset Hide1
	xor	ax,ax
	mov	[bx],ax			; 0,1
	mov	2[bx],ax		; 2,0
	mov	4[bx],ax		; 1,2
	mov	Hdeptr,bx		; Hide1
	mov	Odeptr,offset Hide2	; Hide2

	mov	bx,dx			; Check
	or	al,[bx]			; divisor
	or	ax,1[bx]		; for 0
	jz	ermpbdx
	clc

mpbd3:	mov	bx,Dvend
	rcl	byte ptr [bx],1
	rcl	byte ptr 1[bx],1
	rcl	byte ptr 2[bx],1
	dec	Count
	jz	okmpbdx

	mov	bx,Hdeptr
	rcl	byte ptr [bx],1
	rcl	byte ptr 1[bx],1
	rcl	byte ptr 2[bx],1

	mov	di,Odeptr
	mov	si,Hdeptr
	mov	bx,Dvsor

	lodsw			; Get byte from [SI], si=si+1
	sub	ax,[bx]
	stosw
	lodsb
	sbb	al,2[bx]
	stosb
	cmc
	jnc	mpbd3

	mov	si,Hdeptr
	mov	bx,Odeptr
	mov	Hdeptr,bx
	mov	Odeptr,si
	jmp short	mpbd3

ermpbdx:stc
	jmp short	mpbdx
okmpbdx:or	al,al
mpbdx:	pop	bx
	pop	di
	pop	si
	pop	es
	mov	ax,offset Hdeptr
	ret
_mpbdiv	endp

;================================================================
;Check time code (pointed to by BX) for all zeros
;================================================================
;Return with Z set if so
_time_value	proc	far
	xor	ax,ax
	or	al,[bx]			; LSB, MSB
	or	ax,1[bx]		; MSB
tvxit:	ret
_time_value	endp


;========================================================
;	MULTIPLE PRECISION BINARY MULTIPLICATION
;========================================================
; Enter: BX = base address of multiplicand
;	 DX = base address of multiplier
;
_mpbmul	proc	far
	push	bx		; Save address of multiplicand

; Make pointers point to end of arrays
	mov	Dvsor,dx	; Save address of multiplier
	mov	dx,bx		; DX points to multiplicand

; Set Count to number of bits in array plus 1
; Count: = (length * 8 + 1)
	mov	Count,25	; Save number of bits to do

;Zero high product array
	xor	ax,ax
	mov	bx,offset Calcstor3
	mov	[bx],ax
	mov	2[bx],al

; Multiply using shift and add algorithm
	clc			; Clear carry first time through

;Shift carry into Calcstor3 array and least significant
; bit of Calcstor3 array to carry
mpbmulp:mov	bx,offset Calcstor3
	rcr	byte ptr 2[bx],1
	rcr	byte ptr 1[bx],1
	rcr	byte ptr [bx],1

; Shift carry (next bit of lower product) into most
;  significant bit of multiplicand.
; This also shifts next bit of multiplicand to carry
	mov	bx,dx		; BX = address of end of multiplicand
	rcr	byte ptr 2[bx],1
	rcr	byte ptr 1[bx],1
	rcr	byte ptr [bx],1

; If next bit ofmultipland is 1
;  add multiplier to Calcstor3 array
	jnc	mulcnt		; Jump if next bit is zero

; add multiplier to Calcstor3
	push	dx		; Save address of multiplicand
	mov	dx,Dvsor	; DX = address of multiplier
	mov	bx,OFFSET Calcstor3 ; HL = address of Calcstor3
	mov	cx,3		; CX = length of bytes
	clc			; Clear carry to start

mmulpb:	xchg	bx,dx
	mov	al,[bx]
	xchg	bx,dx		; Get next multiplier byte
	adc	al,[bx]		; Add to Calcstor3
	mov	[bx],al
	inc	dx
	inc	bx
	loop	mmulpb
	pop	dx		; Restore address of multiplicand

; Decrement bit counter, Exit if done
;  Does not change carry

mulcnt:	dec	Count	; subtract 1 from bit counter
	jnz	mpbmulp
	pop	bx		; Restore address of multiplicand
	ret
_mpbmul	endp


;================================================================
;Multiple-precision binary comparison
;compares 2 arrays of binary bytes and resturn the carry and
;zero Flags set or cleared
;Entry: BX = bas address of minuend
;	DX = base address of subtrahend
;Exit:	If minuend = subtrahend then C=0, Z=1
;	If minuend > subtrahend then C=0, Z=0
;	If minuend < subtrahend then C=1, Z=0
;(Flags set as if subtrahend had been subtracted from minuend)
;All registers used

_cmp24b	proc	far
	push	si
	mov	si,dx
	mov	al,2[bx]
	cmp	al,2[si]
	jnz	c24bx
	mov	ax,[bx]
	cmp	ax,[si]
	jnz	c24bx
	xor	al,al
c24bx:	pop	si
	ret
_cmp24b	endp


;================================================================
; Compare DS:BX to ES:DX
_cmp24b_DSES	proc	far
	push	si
	mov	si,dx
	mov	al,2[bx]
	cmp	al,es:2[si]
	jnz	c24bDEx
	mov	ax,[bx]
	cmp	ax,es:[si]
	jnz	c24bDEx
	xor	al,al
c24bDEx:pop	si
	ret
_cmp24b_DSES	endp


; Compare ES:BX to DS:DX
_cmp24b_ESDS	proc	far
	push	si
	mov	si,dx
	mov	al,es:2[bx]
	cmp	al,2[si]
	jnz	c24bEDx
	mov	ax,es:[bx]
	cmp	ax,[si]
	jnz	c24bEDx
	xor	al,al
c24bEDx:pop	si
	ret
_cmp24b_ESDS	endp




; Move three bytes of data from [BX] to [DX]
_mmv3byt	proc	far
	push	si
	mov	si,dx
mvb3:	mov	ax,[bx]
	mov	[si],ax
	mov	al,[bx + 2]
	mov	[si + 2],al
	pop	si
	ret
_mmv3byt	endp

_mmv3_ds2es	proc	far
	push	si
	mov	si,dx
	mov	ax,[bx]
	mov	es:[si],ax
	mov	al,2[bx]
	mov	es:2[si],al
	pop	si
	ret
_mmv3_ds2es	endp

_mmv3_es2ds	proc	far
	push	si
	mov	si,dx
	mov	ax,es:[bx]
	mov	[si],ax
	mov	al,es:2[bx]
	mov	2[si],al
	pop	si
	ret
_mmv3_es2ds	endp



; Store AL Spaces
_store_Spaces	proc	far
	jcxz	spcx
	call	 FAR PTR _space_store
	loop	_store_Spaces
spcx:	ret
_store_Spaces	endp

_space_store	proc	far
	mov	al,' '
_space_store	endp

_tcm_store	proc	far
	push	bx
	mov	bx,Alb_Pntr
	mov	[bx],al
	inc	bx
	mov	Alb_Pntr,bx
	pop	bx
	ret
_tcm_store	endp

_comsg_store	proc	far
	mov	al,[bx]
	inc	bx
	or	al,al
	jz	cmsstrx
	call	 _tcm_store
	jmp	 _comsg_store
cmsstrx:ret
_comsg_store	endp


;================================================================
;Move 24 bit number in extra segment to Bytstr1
_mvb2st1_es	proc	far
	push	si
	mov	si,offset Bytstr1
	jmp short	st12mmv
_mvb2st1_es	endp

_mvb2st2_es	proc	far
	push	si
	mov	si,offset Bytstr2
st12mmv:mov	ax,es:[bx]
	mov	[si],ax
	mov	al,es:2[bx]
	mov	2[si],al
	pop	si
	ret
_mvb2st2_es	endp

_mvb2st1	proc	far
	push	si
	mov	si,offset Bytstr1
	jmp short	_mvb3
_mvb2st1	endp

_mvb2st2	proc	far
	push	si
	mov	si,offset Bytstr2
	jmp short	_mvb3
_mvb2st2	endp

_mvb2st3	proc	far
	push	si
	mov	si,offset Bytstr3
	jmp short	_mvb3
_mvb2st3	endp

_mvb2st4	proc	far
	push	si
	mov	si,offset Bytstr4
_mvb3:	mov	ax,[bx]
	mov	[si],ax
	mov	al,2[bx]
	mov	2[si],al
	pop	si
	ret
_mvb2st4	endp


;================================================================
;		Negate a time code number
;================================================================
; ENTER: BX points to tc value
; Exit:  TC = Twenty4hrs - TC
; USES AX
_tc_negate	proc	far
	push	dx			; Save DX
	mov	ax,Twenty4hrs
	mov	dl,byte ptr Twenty4hrs + 2
	sub	ax,[bx]
	sbb	dl,2[bx]
	mov	[bx],ax
	mov	2[bx],dl
	pop	dx
	ret
_tc_negate	endp




_mmv_dx2bx	proc	far
	xchg	bx,dx
	call	 FAR PTR _mmv
	xchg	bx,dx
	ret
_mmv_dx2bx	endp

;================================================================
;Memory block move [BX] to [DX], for CH bytes
_mmv	proc	far
	push	si
	mov	si,dx
mmv1:	mov	al,[bx]
	mov	[si],al
	inc	bx
	inc	si
	dec	ch
	jnz	mmv1
	mov	dx,si
	pop	si
	ret
_mmv	endp

_mmv16	proc	far
	push	si
	mov	si,dx
mmv161:	mov	al,[bx]
	mov	[si],al
	inc	bx
	inc	si
	loop	mmv161
	mov	dx,si
	pop	si
	ret
_mmv16	endp


_mmv_dx2esbx	proc	far
	push	si
	mov	si,dx
mmvd2eb:mov 	al,[si]
	mov	es:[bx],al
	inc	bx
	inc	si
	dec	ch
	jnz	mmvd2eb
	jmp	mmvxit
_mmv_dx2esbx	endp

_mmv_DSES	proc	far
	push	si
	mov	si,dx
mmv_dses1:
	mov	al,[bx]
	mov	es:[si],al
	inc	bx
	inc	si
	dec	ch
	jnz	mmv_dses1
	jmp	mmvxit
_mmv_DSES	endp

_mmv_ESDS	proc	far
	push	si
	mov	si,dx
mmv_ESDS1:
	mov	al,es:[bx]
	mov	[si],al
	inc	bx
	inc	si
	dec	ch
	jnz	mmv_ESDS1
	jmp	mmvxit
_mmv_ESDS	endp

_mmv_ESES	proc	far
	push	si
	mov	si,dx
ev_eses:mov	al,es:[bx]
	mov	es:[si],al
	inc	bx
	inc	si
	dec	ch
	jnz	ev_eses
_mmv_ESES	endp

mmvxit	proc	far
	mov	dx,si
	pop	si
	ret
mmvxit	endp


;================================================================
;		FILENAME AND FILE I/O SUPPORT ROUTINES
;================================================================
; Concantate string at BX with string at DX.
; ENTER: DX = source, BX = destination, CX = max # of bytes, or 0 = 80H
; Exit:  String moved
;	 BX = EOS ptr (=0) terminator
;	 Z=1 (set) and AH = '.' if extension found
_strcat	proc	far
;	push	es
;
;	push	ds
;	pop	es
;
;	; Search for null termination character
;	or	cx,cx
;	jnz	strct1
;	mov	cx,80h		; Maximum length of string
;	mov	di,bx
;strct1:	mov	al,0
;	cld
;	repne scasb
;	jcxz	strctx
;	mov	si,dx
;strct2:	lodsb
;	stosb
;	or	al,al
;	jz	strctx
;	dec	cx
;	jnz	strct2
;	xor	al,al
;	stosb
;strctx:	pop	es
	ret
_strcat	endp


;================================================================
;		FILENAME AND FILE I/O SUPPORT ROUTINES
;================================================================
; Move string, terminated by null byte, from SI to BX
; ENTER: SI = source, BX = destination
; Exit:  String moved
;	 BX = EOS ptr (=0) terminator
;	 Z=1 (set) and AH = '.' if extension found
_move_subdir	proc	far
	push	ax
	push	si
	xor	ah,ah
msub1:	cld
	lodsb
	call	FAR PTR _make_ucase
	mov	[bx],al
	or	al,al
	jz	msub2
	inc	bx
	cmp	al,'.'
	jnz	msub1
	mov	ah,al
	jmp short	msub1
msub2:	cmp	ah,'.'
	pop	si
	pop	ax
	ret
_move_subdir	endp

; Check for character at -1[bx] = '\'
;  If so, delete it, move BX back one and re-terminate
_delete_backslash	proc	far
	cmp	byte ptr -1[bx],'\'
	jnz	delslh1
	dec	bx
	mov	byte ptr [bx],0
delslh1:ret
_delete_backslash	endp

; Check for character at -1[BX] = '\'
;  If not, put '\' at [bx], inc BX and re-terminate
_add_backslash	proc	far
	cmp	byte ptr -1[bx],'\'
	jz	addslh1
	mov	byte ptr [bx],'\'
	inc	bx
	mov	byte ptr [bx],0
addslh1:ret
_add_backslash	endp


;================================================================
; Extract a path from ascii line at BX
; Place path to buffer pointed to by DX
; Return C=1 if there was no path
_path_extract	proc	far
	push	bx
	push	dx
	push	si
	mov	si,bx
	xor	ch,ch

pathfe:	lodsb			; Find EOL
	or	al,al
	jz	pathx1
	inc	ch
	jmp	pathfe

pathx1:	dec	si
pathx2:	dec	si
	mov	al,[si]
	cmp	al,'\'		; Subdirectory found?
	jz	pathx3
	cmp	al,':'
	jz	pathx3
	dec	ch
	jnz	pathx2
	stc
	jmp	pathxx

; CH has # of bytes to move
pathx3:	cmp	al,'\'
	jnz	pathx4
	dec	ch
pathx4:	call	_mmv	; Move pathname
	xchg	bx,dx
	mov	byte ptr [bx],0	; Terminate pathname
	xchg	bx,dx
	clc
pathxx:	pop	si
	pop	dx
	pop	bx
	ret
_path_extract	endp



; Move string at BX terminated by null, to DX
; Exit BX = EOL+1
_title_loop_DS	proc	far
	push	ds
	push	es	; Move ES:title to DS:destination
	push	ds
	push	es
	pop	ds
	pop	es
	jmp short	movestr
_title_loop_DS	endp

_title_loop_ES	proc	far
	push	ds
	push	es	; Move DS:title to ES:destination
	jmp short	movestr
_title_loop_ES	endp

_title_loop	proc	far
	push	ds
	push	es	; Move DS:title to DS:destination
	push	ds
	pop	es
movestr:push	si
	push	di
	push	cx
	mov	cl,ch
	xor	ch,ch
	mov	si,bx
	mov	di,dx
	rep movsb
	mov	es:[di],cl
	inc	di
	mov	bx,di
	pop	cx
	pop	di
	pop	si
	pop	es
	pop	ds
	ret
_title_loop	endp


_make_ucase	proc	far
	cmp	al,61h
	jc	mucx
	cmp	al,7bh
	jnc	mucx
	and	al,5fh
mucx:	ret
_make_ucase	endp

;================================================================
;		Display hex word and bytes
;================================================================
_dhw	proc	far
	mov	al,bh
	call	 FAR PTR _dhb
	mov	al,bl
	call	 FAR PTR _dhb
	ret
_dhw	endp

_dhb	proc	far
	push	ax
	ror	al,1
	ror	al,1
	ror	al,1
	ror	al,1
	call	dhd
	pop	ax
	call	dhd
	ret
_dhb	endp

dhd	proc	near
	and	al,0fh
	cmp	al,10
	jnc	dhd1
	add	al,'0'
	call	_ConOut
	ret
dhd1:	add	al,'A'-10
	call	_ConOut
	ret
dhd	endp



UTILSEG	ENDS

;================================================================
_DATA	segment byte public 'DATA'
_DATA	ends

	end
