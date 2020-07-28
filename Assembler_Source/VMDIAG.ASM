; Last revised: 2-22-1995, 11:12:28   (C)1989-1995 Norman H. Strassner

include vm.equ

; vmdiag.asm

testmsg_scr	equ	(2 * 256) + 60
testcnt_scr	equ	(2 * 256) + 71
testdur_scr	equ	(4 * 256) + 67
testbase_scr	equ	(6 * 256) + 4

extrn Current_Machine:byte,Diag_Test_Number:byte,Diag_Vtr_Number:byte
extrn Diagnose_Single:byte,Diagnostics_Flag:byte,Rtcf:byte
extrn PS_DIAGNOSE:word,_SetPointAndShootParams:far

extrn Dplay_Cnt:word
extrn Dstart_Cnt:word,Dtest_Cnt:word,INSTL_Choices:word,PointShootData:word
extrn TCver_ovr:word,VTRnames_ovr:word,Current_VTRS:word,Cursor:word
extrn Diag_Loop_Count:word,diag_ovr:word,diagselvtr_ovr:word
extrn Diagsum_Table:word,Done_Msg:word,List_Scr:word,Sttime:word
extrn Synching_Msg:word,Tcdispbuf:word,Testing_Msg:word,Vtrcb:word

extrn Clear_VTR_FCMs:near,all_locations:near,all_still:near,cstat:near
extrn devstat_clr:near,get_vtr:near,get_Vtrcb:near,locations:near
extrn Machine_Change:near,machine_init:near,motion:near,play:near
extrn position_query:near,rdchar:near,read_VTR_time:near,scan:near
extrn screen_init:near,still:near,vtr_cmd:near,vtr_opt:near,vtr_stat:near

extrn _DecOut:far,_DrawMenuBox:far,_all_machine_keys:far,_Break_check:far
extrn _clear_screen:far,_cmp24b:far,_cnvt2tc_DS:far,_comsg:far
extrn _Cursor_off:far,_delfrm:far,_error_bell:far,_help_pos:far,_kbd_cln:far
extrn _line_erase:far,_menu_columns:far,_mmv:far,_msgread:far
extrn _Done_msgs:far,_Diag_Msgs:far,_Show_Test:far,_VTR_Summary:far
extrn _Norm_Test:far


_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg


Public  testmsg_scr, testcnt_scr, testdur_scr, testbase_scr, Diagnostics
Public  Diagn1, diag_agn, DG_xit, DG_2, DG_3, DG_4, diag_disp, diagnose_VTR
Public  dsinglx, diag_screen, diagnose_VTRS, DiagV, DTCx, DTCx1, DTCx2, DTCxx
Public  diag_scan, TestVtrTc, TVTTC1, TVTTC1a, TVTTC1b, TVTTC2, TVTTC3, TVTTC4
Public  TVTC_loop, TTClp_4, TTCagn, TVTCnup, TVTCskp, TVTC_go, TTClp_3, TTClpj
Public  TTCxit, VTRTC_clear, vtrtcc, VTRTini

;================================================================
;
;		DIAGNOSE VTRS
;
;================================================================
Diagnostics:
	mov	bx,offset screen_init
	push	bx

	cmp	Current_Machine,aux_dev
	jc	Diagn1
	mov	al,a_dev
	call	Machine_Change

Diagn1:	call	_clear_screen
	mov	Diagnostics_Flag,0ffh

	mov	bx,offset PS_DIAGNOSE
	call	_SetPointAndShootParams
	call	diag_screen
	call	VTRTini

diag_agn:
	call	diag_disp
	mov	cl,byte ptr INSTL_Choices + 14
	call	position_query
	jc	DG_xit
	mov	byte ptr INSTL_Choices + 14,cl
	cmp	cl,1
	jnz	DG_2
DG_xit:	call	_help_pos
	ret

DG_2:	cmp	cl,2
	jnz	DG_3
	call	diagnose_VTRS
	jmp	diag_agn

DG_3:	cmp	cl,3
	jnz	DG_4
	call	diagnose_VTR
	jmp	diag_agn

DG_4:	jmp	diag_agn

;================================================================
diag_disp:
	call	_help_pos
	call	_kbd_cln
	mov	bx,offset diag_ovr
	call	_menu_columns
	call	_DrawMenuBox
	ret

diagnose_VTR:
	mov	Diagnose_Single,0ffh
	call	_kbd_cln
	mov	bx,offset diagselvtr_ovr
	call	_msgread
	call	rdchar
	call	_Break_check
	jz	dsinglx
	call	_all_machine_keys
	jnz	dsinglx
	call	Machine_Change
	call	vtr_stat
	jnz	DiagV
	call	_error_bell
	jmp	diagnose_VTR
dsinglx:ret

diag_screen:
	mov	Cursor,0			; Init screen
	norm_VIDEO FALSE,FALSE
	mov	bx,offset TCver_ovr
	call	_msgread
	mov	bx,offset VTRnames_ovr
	call	_msgread
	ret

;================================================================
diagnose_VTRS:
	mov	Diagnose_Single,0

DiagV:	call	_help_pos
	call	_kbd_cln
	call	VTRTC_clear
	call	all_locations
	call	_Cursor_off

	mov	Diag_Test_Number,0
	mov	si,offset Dstart_Cnt
	mov	bx,offset play
	call	TestVtrTc
	jc	DTCx

	mov	si,offset Dtest_Cnt
	mov	cl,PLUS_ASCII			; Forward Speed
	mov	ch,3			; Speed factor = 2 (from 1-9)
	call	diag_scan
	jc	DTCx
	mov	ch,5
	call	diag_scan
	jc	DTCx
	mov	ch,7
	call	diag_scan
	jc	DTCx
	mov	ch,9
	call	diag_scan
	jc	DTCx

	mov	cl,MINUS_ASCII			; Forward Speed
	mov	ch,3			; Speed factor = 2 (from 1-9)
	call	diag_scan
	jc	DTCx
	mov	ch,5
	call	diag_scan
	jc	DTCx
	mov	ch,7
	call	diag_scan
	jc	DTCx
	mov	ch,9
	call	diag_scan
	jc	DTCx

	pushf
	call	_Done_msgs
	jmps	DTCx1

DTCx:	pushf
DTCx1:	cmp	Diagnose_Single,0ffh
	jnz	DTCx2
	call	still
	jmp	DTCxx
DTCx2:	call	all_still
	call	_delfrm
DTCxx:	call	all_locations
	popf
	ret

diag_scan:
	push	dx
	push	cx
	push	si
	mov	bx,offset scan
	call	TestVtrTc
	pop	si
	pop	cx
	pop	dx
	ret

;................................................................
; SI = Buffer pointing to test time
; BX = Offset pointer to VTR motion routine to call
TestVtrTc:
	push	si			; Save pointer to test time
	mov	al,Current_Machine
	push	ax

	mov	bp,MAX_MACHINES		; Do for all VTRs
	mov	di,offset Vtrcb
	mov	si,offset Diagsum_Table

TVTTC1:
	mov	word ptr [si],0ffffh	; Set accumulator for no node present
	mov	al,ds:[di].Vtrcb_PORT	; Get Port
	or	al,al
	jz	TVTTC2

	push	si
	push	di
	push	cx
	push	bx
	call	get_vtr
	call	vtr_stat
	jz	TVTTC1a
	cmp	cl,81h
	jbe	TVTTC1a
	cmp	cl,90h
	jnc	TVTTC1a

	cmp	Diagnose_Single,0ffh
	jnz	TVTTC1b
	cmp	al,Current_Machine	; 
	jz	TVTTC1b
TVTTC1a:pop	bx
	pop	cx
	pop	di
	pop	si
	jmp	TVTTC2

TVTTC1b:mov	word ptr [si],0		; Clear accumulator
	call	Machine_Change

	mov	ax,offset M_ee_off
	call	motion

	call	_delfrm

	pop	bx
	pop	cx

	push	cx
	push	bx
	push	bp
	call	bx			; Call VTR command, Get all VTRs moving
	pop	bp
	pop	bx
	pop	cx
	pop	di
	pop	si
TVTTC2:	add	di,Vtrcb_length
	inc	si
	inc	si
	dec	bp
	jnz	TVTTC1
	pop	ax
	call	Machine_Change

	pop	si

	mov	ax,offset M_setclock		; clear clock
	mov	ch,0
	call	vtr_opt

	mov	bx,offset Synching_Msg	; Say "SYNCH"
	call	_Diag_Msgs

;...
; Delay for VTR syncing
TVTTC3:	mov	ah,0bh			; Check for ctrl Break
	int	DOS
	call	cstat
	jz	TVTTC4
	call	_Break_check
	jnz	TVTTC4
	call	diag_screen
	stc
	ret

TVTTC4:	call	all_locations
	mov	ax,offset M_readclock
	call	read_VTR_time
	mov	dx,si			; BX points to length of setup
	call	_cmp24b			; DX points to current elapsed time
	jb	TVTTC3			; Jump if BX < DX

;...
	norm_VIDEO FALSE,FALSE
	mov	Cursor,testmsg_scr
	mov	bx,offset Testing_Msg
	call	_comsg

	mov	ax,offset M_setclock		; clear clock
	mov	ch,0
	call	vtr_opt

	call	_Show_Test		; Hilight TEST type

	xor	ax,ax
	mov	Diag_Vtr_Number,al	; Begin with record VTR
	mov	Diag_Loop_Count,ax

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
TVTC_loop:
	call	cstat
	jz	TTClp_4
	call	_Break_check
	jnz	TTClp_4
	call	diag_screen
	stc
	ret

TTClp_4:call	locations		; Display VTR locations
	mov	ch,Diag_Vtr_Number	; Get current VTR number
	mov	al,ch			; Index to the correct word
	cbw				;  in the Diagsum_Table
	shl	ax,1
	mov	di,offset Diagsum_Table
	add	di,ax
	cmp	ds:word ptr [di],0ffffh
	jz	TTCagn

	call	get_Vtrcb		; Get it's node
	or	ch,ch			; OFFLINE?
	jnz	TVTC_go			; Skip this VTR
TTCagn:	mov	al,Diag_Vtr_Number
	inc	al
	cmp	al,MAX_MACHINES - 1
	jbe	TVTCskp

	inc	Diag_Loop_Count

	mov	bx,offset Sttime
	mov	dx,offset Tcdispbuf
	mov	cl,DF_CHAR
	call	_cnvt2tc_DS
	mov	Cursor,testdur_scr
	norm_VIDEO FALSE,FALSE
	call	_comsg			; Display ascii TC number

	mov	Cursor,offset testcnt_scr
	mov	bx,Diag_Loop_Count
	call	_DecOut	

	call	_VTR_Summary
TVTCnup:xor	al,al

TVTCskp:mov	Diag_Vtr_Number,al	; Begin with record VTR
	jmp	TVTC_loop

TVTC_go:mov	ax,offset M_code_valid		; Test code validity
	mov	cl,VX_PoundNum
	call	vtr_cmd
	jc	TTClpj			; Skip it, do next vtr

	mov	al,[bx]
	cmp	al,'Y'			; Is CODE VALID?
	jz	TTClp_3			; Jump if so
	cmp	al,'N'
	jnz	TTClpj

	mov	al,Diag_Vtr_Number	; Index to the correct word
	cbw				;  in the Diagsum_Table
	shl	ax,1
	mov	di,offset Diagsum_Table
	add	di,ax
	inc	ds:word ptr [di]	; Increment error Count

TTClp_3:mov	ax,offset M_readclock		; Get running test time
	call	read_VTR_time
	mov	dx,offset Dplay_Cnt	; BX = starting location (+5:00)
	call	_cmp24b			; DX = current location
	ja	TTCxit
TTClpj:	jmp	TTCagn

TTCxit:	call	_Norm_Test
	inc	Diag_Test_Number
	ret

VTRTC_clear:
	mov	dx,offset testbase_scr
	mov	cx,MAX_MACHINES
vtrtcc:	mov	Cursor,dx
	call	_line_erase
	inc	dh
	loop	vtrtcc

VTRTini:push	Current_VTRS
	call	machine_init
	call	devstat_clr
	call	Clear_VTR_FCMs
	pop	ax
	mov	al,ah			; Use last current MACHINE!
	call	Machine_Change
	ret

_TEXT	ends

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

