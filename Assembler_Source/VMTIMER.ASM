; Last revised: 2-22-1995, 11:12:28   (C)1989-1995 Norman H. Strassner
; VMTIMER.ASM

; Hardware Flags
HDWR_8086	equ	0000000000000001b
HDWR_80186	equ	0000000000000010b
HDWR_80286	equ	0000000000000100b
HDWR_80386	equ	0000000000001000b
HDWR_80486	equ	0000000000010000b
HDWR_80586	equ	0000000000100000b
HDWR_EISA	equ	0000000100000000b


nIterations equ 20

BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg


Public  HDWR_8086, HDWR_80186, HDWR_80286, HDWR_80386, HDWR_80486, HDWR_80586
Public  HDWR_EISA, nIterations, _get_cpu_type, acumlp, Accumulate_cpu, tp8086
Public  tpok, mulit, sktp, Time_Processor_8086, Time_Processor_80386, timdivide
Public  tmcl3, ermpb, okmpb, mpb, processor_cycles, intel_id, intel_proc
Public  vendor_id, saved_cpuid, themodel, stepping, ticks, CPUtype, top_speed
Public  hdwrFlags, clockfreq, million, result, dhide1, dhide2, dvend1, dvsor1
Public  hdeptr1, odeptr1

_get_cpu_type	proc	far
	push	es
	push	ds
	pop	es

	xor	ax,ax
	mov	top_speed,ax
	mov	cx,10
acumlp:	push	cx
	call	Accumulate_cpu
	pop	cx
	loop	acumlp
	mov	ax,word ptr top_speed
	mov	cx,hdwrFlags
	pop	es
	ret
_get_cpu_type	endp

Accumulate_cpu	proc near
	cmp	CPUtype,3
	jb	tp8086
	call	Time_Processor_80386
	jmp	tpok
tp8086:	call	Time_Processor_8086
tpok:	mov	ticks,ax
	mov	bx,offset processor_cycles
	add	bx,CPUtype		; Index to the processor cycles
	mov	al,[bx]
	mov	ah,0
	mov	cl,nIterations
	mul	cl
	mov	cx,ax			; # of iterations
	mov	bx,offset clockfreq
	mov	si,offset result
	mov	word ptr [si],0		;Zero out accumulator
	mov	word ptr 2[si],0

; cps = (ulong) cycles * 1193180 / (ulong) ticks;
; Multiply cycles * 1193180
mulit:	mov	ax,[bx]
	add	word ptr [si],ax
	mov	ax,2[bx]
	adc	word ptr 2[si],ax
	loop	mulit

; div result  / (ulong) ticks;
	mov	bx,si
	mov	dx,offset ticks
	call	timdivide

	mov	bx,si
	mov	dx,offset million
	call	timdivide

	mov	ax,[bx]		; Get speed
	cmp	ax,top_speed
	jb	sktp
	mov	top_speed,ax
sktp:	ret
Accumulate_cpu	endp

.8086
; timing code for 8086/286 processors
Time_Processor_8086	proc	near
	cli
	mov cx,1234
	xor dx,dx
	xor ax,ax

	mov al,10111000b	;channel 2, LSB+MSB, mode 4, binary
	out 43h,al
	in al,61h
	or al,1
	out 61h,al
	xor al,al
	out 42h,al
	out 42h,al
	xor ax,ax		;dividing into zero

	rept nIterations
	idiv cx
endm
	in al,42h	;MSB
	mov ah,al
	in al,42h	;LSB
	xchg al,ah
	neg ax

	sti
	ret
Time_Processor_8086 endp

; timing code for 386/486 processors
Time_Processor_80386	proc	near
	cli

	mov al,10111000b	;channel 2, LSB+MSB, mode 4, binary
	out 43h,al
	in al,61h
	or al,1
	out 61h,al
	xor al,al
	out 42h,al
	out 42h,al

.386
	mov eax,80000000h
	rept nIterations
	bsf ecx,eax	;46 cycles (on a 486)
endm
.8086
	in al,42h	;MSB
	mov ah,al
	in al,42h	;LSB
	xchg al,ah
	neg ax

	sti
	ret
Time_Processor_80386 endp


;****************************************************************
timdivide	proc	near
	push	si
	push	di
	push	bx
	mov	dvend1,bx
	mov	dvsor1,dx
	mov	cx,33

;Clear out accumulators, 8 contiguous bytes at dhide1, dhide2
	mov	bx,offset dhide1
	xor	ax,ax
	mov	[bx],ax			; 0,1
	mov	2[bx],ax		; 2,3
	mov	4[bx],ax		; 0,1
	mov	6[bx],ax		; 2,3
	mov	hdeptr1,bx		; dhide1
	mov	odeptr1,offset dhide2	; dhide2

	mov	bx,dx			; Check
	or	ax,[bx]			; divisor
	or	ax,2[bx]		; for 0
	jz	ermpb
	clc

tmcl3:	mov	bx,dvend1
	rcl	word ptr [bx],1
	rcl	word ptr 2[bx],1
	dec	cx
	jz	okmpb

	mov	bx,hdeptr1
	rcl	word ptr [bx],1
	rcl	word ptr 2[bx],1

	mov	di,odeptr1
	mov	si,hdeptr1
	mov	bx,dvsor1

	lodsw			; Get byte from [SI], si=si+1
	sub	ax,[bx]
	stosw
	lodsw
	sbb	ax,2[bx]
	stosw
	cmc
	jnc	tmcl3

	mov	si,hdeptr1
	mov	bx,odeptr1
	mov	hdeptr1,bx
	mov	odeptr1,si
	jmp	tmcl3

ermpb:	stc
	jmp	mpb
okmpb:	or	al,al
mpb:	pop	bx
	pop	di
	pop	si
	ret
timdivide	endp

BSEG	ends

_DATA	segment byte public 'DATA'
processor_cycles	db	165, 165, 25, 103, 42
intel_id		db	"GenuineIntel"
intel_proc		db	?
vendor_id		db	12 dup (?)
saved_cpuid		dd	?
themodel		db	?
stepping		db	?

ticks			dw	0,0
;cycles			dw	0
CPUtype			dw	0
top_speed		dw	0
hdwrFlags		dw	0
clockfreq		dd	1193180
million			dd	1000000
result			dd	0
dhide1			db	0,0,0,0
dhide2			db	0,0,0,0
dvend1			dw	0		; Address of dividend
dvsor1			dw	0		; Address of divisor
hdeptr1			dw	0		; Address of current high dividend array
odeptr1			dw	0		; Address of other hight dividend array

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
