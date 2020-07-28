; Last revised: 2-22-1995, 11:12:23   (C)1989-1995 Norman H. Strassner

;vm_Eggs.asm

;;include vm.equ
include vmver.equ
include sessum.dat

extrn Pgm_Start:near

;================================================================

_TEXT	segment para public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg,ss:_STACK

Public  PosID, _main, Stacks, EDL_Bin, Max_Lines, Next_Edit, Current_Event
Public  Next_Avail_Num, Mode_Pntr, Edl_Fcm, Page_Position, EDL_Header
Public  File_Title, Event_Storage

PosID	db	'0000',rt,' '
	db	d1,d2,d3,d4,d5,d6
	db	'-',v1,v2,v3

_main	proc	far
	cli
	mov	ax,_STACK
	mov	ss,ax
	mov	sp,offset Stacks
	sti
	mov	ax,dmseg
	mov	bx,ax
	mov	ax,scrseg
	mov	cx,ax
	mov	ax,eseg
	mov	dx,ax
	mov	ax,_DATA
	jmp	Pgm_Start
_main	endp

_TEXT	ends

BSEG	segment para public 'CODE'
BSEG	ends

UTILSEG	segment word public 'CODE'
UTILSEG	ends

;================================================================
scrseg	segment para public 'ENTRY'
scrseg	ends

_STACK	segment word stack 'STACK'
	db	512 dup(?)		; 512 byte stack
	Stacks    LABEL  BYTE
_STACK	ends

;================================================================
_DATA	segment byte public 'DATA'
_DATA	ends

;================================================================
dmseg	segment para public 'OVERLAY'
	db	((OVRFILE_size / 16) + 1) * 16 dup(?)
dmseg	ends

;================================================================
eseg	segment para public 'EDLBIN1'


; Bin   Max_Lines next   current next_avail
; 0000    0000    0000    0000    0000
;  +0      +2      +4      +6      +8
	org	0

EDL_Bin		dw	?	; 00h	;
Max_Lines	dw	?	; 02h	; Max # of lines allowed in EDL bin
Next_Edit	dw	?	; 04h	; Next edit number to be used
Current_Event	dw	?	; 06h	; Just what it says
Next_Avail_Num	dw	?	; 08h	; Next available edit position in bin
Mode_Pntr	dw	?	; 0ah	; Mode pointer for EDL format type
Edl_Fcm		db	?	; 0ch	; FCM of EDL (record side)
		db	?	; 0dh
Page_Position	dw	?	; 0eh

EDL_Header	db	70h dup(?)	; Filler

File_Title	db	80h dup(?)	; Just what it says, folks!

Event_Storage	db	0feffH DUP(?)	; Good or bad, these are edits

eseg	ends


	end	_main

