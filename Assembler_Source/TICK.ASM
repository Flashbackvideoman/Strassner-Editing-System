; Last revised: 7-27-1994, 9:45:28   (C)1989-1994 Norman H. Strassner

;TICK.ASM


.xlist
include	VM.EQU
.list
;*****************************************************************************
;
;  A GetTickCount() that is accurate to the millisecond
;
;  Copyright (C) 1988-1991 Datametrics Systems Corporation
;
;  Notes:
;
;    - Proc directly accesses the 8254 timer chip (does port I/O).
;    - Proc issues sti/cli instructions.
;    - Assumes timer interrupt frequency has not been changed.
;    - There is a dramatic performance degradation if this proc
;      is executed on a 386 w/ I/O port trapping enabled for the
;      timer chip.
;    - Time will wrap after 49.7 days (1ms) or 4.97 days (100us).
;    - TIMERRES is 54925, the interrupt period in microseconds.
;
;*****************************************************************************

TENTHTICK EQU 0

if (TENTHTICK)
TMRES1      EQU 16384              ;; (WORD)((TIMERRES*10*65536)/1000)
TMRES2      EQU 549                ;; (TIMERRES*10/1000)
TMRES3      EQU 8788               ;; (TIMERRES*10*16)/1000
else
TMRES1      EQU 60620              ;; (WORD)((TIMERRES*65536)/1000)
TMRES2      EQU 54                 ;; (TIMERRES/1000)
TMRES3      EQU 56243              ;; (TIMERRES*256*4)/1000
endif


bseg	segment word public 'CODE'
	assume	cs:bseg,ds:dseg,es:dseg

Public _DelayMilliseconds, _SyncTime, GetLowTickCount

; Enter AX:DX = tick count to delay
_DelayMilliseconds	proc	far
	call	near ptr _SyncTime
	add	ax,word ptr [dwLowTickCount]
	adc	dx,word ptr [dwLowTickCount + 2]
	mov	word ptr [dw1+2],dx
	mov	word ptr [dw1],ax
	jmp	short @2
@4:
@2:
	call	far ptr GETLOWTICKCOUNT
	mov	word ptr [dw2+2],dx
	mov	word ptr [dw2],ax
	cmp	dx,word ptr [dw1+2]
	jb	@4
	jne	@5
	cmp	ax,word ptr [dw1]
	jb	@4
@5:
@3:
@1:
	ret	
_DelayMilliseconds	endp

_SyncTime	proc	far

	call	far ptr GETLOWTICKCOUNT
	mov	word ptr [synctime1+2],dx
	mov	word ptr [synctime1],ax
	jmp	short @7
@9:
@7:
	call	far ptr GETLOWTICKCOUNT
	mov	word ptr [synctime2+2],dx
	mov	word ptr [synctime2],ax
	cmp	dx,word ptr [synctime1+2]
	jne	@10
	cmp	ax,word ptr [synctime1]
	je	@9
@10:
@8:
	mov	dx,word ptr [synctime2+2]
	mov	ax,word ptr [synctime2]
	jmp	short @6
@6:
	ret	
_SyncTime	endp





GetLowTickCount PROC FAR
;       /*--- Disable interrupts; Issue read-back command for counter 0 ---*/
start:	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	es

startagn:
	  mov     al, 0C2h                ;; read back command
		cli
		out     43h, al                 ;; send command to 8254
		jmp     short $+2               ;; I/O wait

;       /*--- Set carry flag to counter 0 OUT pin status ---*/
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
        jcxz    restart                 ;; restart if counter is zero
        rcr     cx, 1                   ;; combine OUT status w/ counter
        not     cx                      ;; change high->low to low->high

;       /*--- Convert BIOS ticks to milliseconds (into DI:SI) ---*/
;;if (?WIN EQ 1)
;;extrn __0040H:ABS
;;		mov     bx, __0040H             ;; Windows requires external absolute
;;else
        mov     bx, 040h                ;; ROM BIOS data area segment
;;endif
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
;       /*--- Get tick count accurate to 1/10000 second ---*/
        mov     ax, TMRES3
        shr     cx, 1
        shr     cx, 1
        shr     cx, 1
        shr     cx, 1
        mul     cx                      ;; where in interval
        add     ax, WORD PTR [wFrac]    ;; add fraction
        mov     ax, si                  ;; ax = tick count low
        adc     ax, dx
        mov     dx, di                  ;; dx = tick count high
        adc     dx, 0                   ;;
else
;       /*--- Get tick count accurate to 1/1000 second ---*/
        mov     ax, TMRES3
        shr     cx, 1
        shr     cx, 1
        mul     cx                      ;; where in interval
        add     ah, BYTE PTR [wFrac]    ;; add fraction low/high
        adc     dl, BYTE PTR [wFrac+1]  ;; ..to get carry
        mov     ax, si                  ;; ax = tick count low
        adc     al, dh                  ;;
        adc     ah, 0                   ;;
        mov     dx, di                  ;; dx = tick count high
        adc     dx, 0                   ;;
endif

;       /*--- Assure tick count is equal or advancing ---*/
        cmp     dx, WORD PTR [dwLowTickCount+2]
        ja      done
        cmp     ax, WORD PTR [dwLowTickCount]
        jb      restart

;       /*--- Save last tick count obtained ---*/
done:   mov     WORD PTR [dwLowTickCount], ax
        mov     WORD PTR [dwLowTickCount+2], dx
        sti
	pop	es
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
        ret

;       /*--- Restart procedure ---*/
restart: sti
         jmp    startagn

GetLowTickCount ENDP

bseg	ends

dseg	segment byte public 'DATA'

dwLowTickCount	dd	0
wFrac		dw	0
sync_count1	dd	0
sync_count2	dd	0
dw1		dd	0
dw2		dd	0
synctime1	dd	0
synctime2	dd	0
dseg	ends

        END
