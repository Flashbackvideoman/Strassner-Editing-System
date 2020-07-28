; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner

; VMPMC.ASM
;
;	MAINTAIN A BUFFER FOR SIX SPEED CHANGES
;	FORMAT:	1 BYTE VTR A=1, B=2, C=3, D=4
;		1 BYTE SPEED IN FRAMES/SECOND
;		1 BYTE SIGN (+ OR -) OF FOLLOWING OFFSET
;		3 BYTE TIME CODE OFFSET FROM Preroll

%nolist
include vm.equ

extrn BuiltInMacro:byte,Abort_Flag:byte,Current_Machine:byte
extrn Current_Source:byte,Input_Flag:word,Rtcf:byte,Sign_Flag:byte
extrn Trim_Ci_Flag:byte,Vtr_Mult_Type:byte

extrn Bytstr1:word,Bytstr2:word
extrn PointShootData:word,Cursor:word,Editspeed_Msg:word
extrn Empty_Msg:word,Framesec_Msg:word,Kilfil_Msg:word,List_Scr:word
extrn Offset_Buffer:word,Pmc_Flags:word,Preroll:word,Progmotion_Tbl:word
extrn R_Tc:word,Ramp_Flags:word,RampSpeedChange:word
extrn Rm_xcmd:word,Sort_Tcfmt:word,Spd_Flags:word,Spdall_Msg:word
extrn Spdbufsel_Msg:word,spdchange_rqst:word,Spdchg_Msg:word,Spdkil_Msg:word
extrn Speed_Msg:word,Speedbuf_Msg:word,Sttime:word,Tags_Table:word
extrn Tc_Format:word,Tcdispbuf:word,Temp_Wrkspce:word,Vtrcb:word

extrn A_Machine:near,all_update:near,dec_cimsg:near,event_recall:near
extrn get_Vtrcb:near,get_Vtrcb_FCM:near,Idxatcf:near,keythru:near
extrn m20_chs:near,Machine_Change:near,motion:near,Pmc_Upd:near
extrn position_query:near,Preroll_delayed:near,rdchar:near,space_2_out:near
extrn Spd_Upd:near,switch:near,Synctag:near,tc_cimsg:near,tc_parenth:near
extrn vtr_answer:near,vtr_cmd:near,vtr_pmccmd:near,vtr_rehearse:near
extrn vtr_rmpcmd:near,vtr_sendcmd:near,SetActiveVtr_CH:near,yn_chos:near
extrn ramp_upd:near,ramp_upd:near

extrn _A_DecOut:far,_ConOut:FAR,_DecOut:far,_DecOut_100_pad:far
extrn _DispRampVtr:far,_PMC_compensate:far,_PromptForDecimal:far
extrn _REVERSE_compensateIN:far,_RampSpeed_CARD:far,_RestoreWorkspace:far
extrn _SaveWorkspace:far,_Space_Out:far,_Break_check:FAR,_check4edl:far
extrn _check4pmc:far,_check4spd:far,_clear_tc:far,_cmp24b:far,_cnvt2tc_DS:far
extrn _comsg:FAR,_convert2bin:far,_crlf:FAR,_default_val:FAR
extrn _draw_EDITSPEEDS:far,_draw_PMCBUFFERS:far,_error_bell:FAR
extrn _evnt_dispthis:far,_get_dur:far,_get_in:far,_get_out:far,_help_pos:FAR
extrn _index2edspeed:far,_Inout_init:far,_kbd_cln:FAR,_kbd_clr:FAR
extrn _kbd_message:far,_machine_disp:far,_machine_keys:far,_make_ucase:far
extrn _mmv3byt:far,_mmv:far,_motion_convert:far,_mpbdiv:far,_mpbmul:far
extrn _mvb2st1:far,_mvb2st2:far,_rdnum:FAR,_speed_percent:far,_time_value:far
extrn _tlinepmc_save:far,_vpslmin:far,_Delay_Vtr_Function:far

	if ALLOWRAMPSPEED
extrn rampstart_ovr:word,rampend_ovr:word,rampdur_ovr:word,ramptime_ovr:word
extrn rampenabled_ovr:word
	ENDIF



%list

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

%nolist

Public  RampVtrSpeed, CheckLegalRamp, RampSpeedDialog, rsdxit, GetRampTimeCode
Public  grst_x, Prompt4_SPEED_FROM, p4sfr, Prompt4_SPEED_TO, p4str
Public  Prompt4_SPEED_TIME, Prompt4_SPEED_START, RVSmakechanges, RVSmcx
Public  CalculateRampChanges, WriteRampToVlan, AutoPmcMatch, APMxit, APMret
Public  speed_fill, spdfil1, spdfil2, spdfilx, spderr, MotionControlMenu
Public  pgmmok, pgmsp, pgmsplp, pgmch0, pgmch1, pgmch2, pgmch3, pgmch4, pgmch5
Public  pgmch6, pgmch6a, pgmch7, pgmch_next, pgmch_last, pgms1, pgmsa1a, pgms1a
Public  pgms2, pgms3, pgms4, pgms5, pgmsper, pgmc0, pgmc1, pgmc1a, pgmadd
Public  pgmadd1, pgmadd2, siIndexToSpeedChange, pgmdel, pgmdel1, pgmdelx
Public  pgmdel2, pgmdel4, pgmclr, pgmclrx, pgmxit, pgmxit2, pgmxit5, pgmupdx
Public  get_editspeed, gedspd2, gedspd3, gedspd5, getspd6, PromptForSpeedChange
Public  gpcm6, gpcm7, gpcm10, gpcmclr, gpcmret, gpcmsgn, gpcmfmt
Public  DisplaySpeedChanges, vspd_line, vspdspl, vspd1, vspd2, vspd4, vspd5
Public  vspdagn, vspdxit, DisplaySpeedsAtInPoint, edspdlp, edspd1, pmctag_disp
Public  pmctg1, pmctg2, mosource_disp, modevice_disp, dec_plusminus, decplm1
Public  decplmc, decplmx, key_machine, pgmd1a, pgmd1b, reset_editspeed, rstsp1
Public  reset_varispeeds, rstvari, rstvagn, clear_speedtable, clear_spdtbl
Public  clrspds, clrspdr, clear_tagstable, WriteAllSpeeds, was1, svtspd1
Public  svtspd2, svtspdl, svtspds, svtspdx, test_4_varispd, motion_sort, mosrt1
Public  mosrt2, mosrt3, mosrt5, mosrt_n, mosrt_x, mosrt_p, ms_srtr, ms_srtl
Public  ms_srt2, ms_srt5, ms_srt9, ramploopcounter, rampposchoices

; from FS to TS fps, over D duration starting at offset O
; if duration < 90 frames

;================================================================
; Ramp up the speed of a VTR over time
RampVtrSpeed	proc	near
	if ALLOWRAMPSPEED
	push	ds
	pop	es

	mov	bx,offset PS_RAMPSPEED
	call	_SetPointAndShootParams

	call	_help_pos

	mov	al,Current_Source	; Display the source vtr
	call	Machine_Change

	mov	di,offset RampSpeedChange
	mov	ds:[di].SPEED_VTR,al

RVSconfagn:
	call	_RampSpeed_CARD

	mov	cl,rampposchoices
	call	position_query
	mov	di,offset RampSpeedChange
	jc	RVS_xit
	mov	rampposchoices,cl
	cmp	cl,1
	jnz	RVS_2
	jmp	RVS_xit

RVS_2:	cmp	cl,2
	jnz	RVS_3
	call	RampSpeedDialog
	jmp	RVSconfagn

RVS_3:	cmp	cl,3
	jnz	RVS_4
	mov	bx,offset rampenabled_ovr
	mov	dx,offset Ramp_Flags
	mov	ax,Enabled_MSBIT
	call	m20_chs
	call	ramp_upd
	jmp	RVSconfagn

;................................................................
; 1. Get the start speed in FPS
RVS_4:	cmp	cl,4
	jnz	RVS_5
	call	Prompt4_SPEED_FROM
	jmp	RVSconfagn

;................................................................
; 2. Get the end speed in FPS
RVS_5:	cmp	cl,5
	jnz	RVS_6
	call	Prompt4_SPEED_TO
	jmp	RVSconfagn

;................................................................
; 3. Get the duration for the speed change
RVS_6:	cmp	cl,6
	jnz	RVS_7
	call	Prompt4_SPEED_TIME
	jmp	RVSconfagn

;................................................................
; 4. Get the offset from the record in point for the speed change to start
RVS_7:	cmp	cl,7
	jnz	RVS_8
	call	Prompt4_SPEED_START
	jmp	RVSconfagn

RVS_8:	jmp	RVSconfagn

RVS_xit:test	Ramp_Flags,enabled_MSBIT
	jz	rvsxit1
	call	CheckLegalRamp
	jnc	rvsxit1
	jmp	RVSconfagn
rvsxit1:call	_evnt_dispthis

	ENDIF
	ret
RampVtrSpeed	endp


CheckLegalRamp	proc	near
	if ALLOWRAMPSPEED
	push	bx
	mov	bx,offset RampSpeedChange
	mov	ax,[bx].SPEED_FROM
	mov	dx,[bx].SPEED_FROM+2
	cmp	ax,[bx].SPEED_TO
	jnz	lglrmp1
	cmp	dx,[bx].SPEED_TO+2
	jz	nolglrmp
lglrmp1:add	bx,ZeroBase.SPEED_TIME
	call	_time_value
	jz	nolglrmp
	pop	bx
	clc
	ret

nolglrmp:
	and	word ptr Ramp_Flags, NOT Enabled_MSBIT
	ERROR	rampspecsillegal_error, ERET_Return
	pop	bx
	stc
	ENDIF ;	if ALLOWRAMPSPEED
	ret

CheckLegalRamp	endp


;================================================================
RampSpeedDialog	proc	near
	if ALLOWRAMPSPEED

;................................................................
; 1. Get the start speed in FPS
	call	Prompt4_SPEED_FROM
	jc	rsdxit
;................................................................
; 2. Get the end speed in FPS
	call	Prompt4_SPEED_TO
	jc	rsdxit
;................................................................
; 3. Get the duration for the speed change
	call	Prompt4_SPEED_TIME
;;	jc	rsdxit
;................................................................
; 4. Get the offset from the record in point for the speed change to start
	call	Prompt4_SPEED_START
	ENDIF ;	if ALLOWRAMPSPEED
rsdxit:	ret
RampSpeedDialog	endp


;================================================================
; Enter: BX-> message to send
;	 DX-> Destination buffer
; Exit:	 Carry set (1) if timecode=0
;	 BX-> timecode destination buffer
;	 (timecode *) DX filled in
GetRampTimeCode	proc	near
	if ALLOWRAMPSPEED
	norm_VIDEO FALSE,FALSE
	push	dx
	mov	al,DF_CHAR
	call	_Inout_init
	mov	bx,offset Sttime	; Get start time
	mov	al,DF_CHAR
	call	tc_cimsg		; From user
	pop	dx
	jnc	grst_1
	call	_clear_tc
grst_1:	call	_time_value		; Anything there?
	stc
	jz	grst_x			; Skip if not
grst_2:	call	_mmv3byt
	clc
	ENDIF ;	if ALLOWRAMPSPEED
grst_x:	ret
GetRampTimeCode	endp


Prompt4_SPEED_FROM	proc	far
	if ALLOWRAMPSPEED
	call	_DispRampVtr
	mov	dx,di
	add	dx,ZeroBase.SPEED_FROM
	mov	bx,offset rampstart_ovr
	mov	al,6
	call	_PromptForDecimal
	jc	p4sfr
	mov	ds:[di].SPEED_FROMDIR,cl
	mov	ds:[di].SPEED_FROM,ax
	mov	ds:[di].SPEED_FROM+2,dx
	ENDIF ;	if ALLOWRAMPSPEED
p4sfr:	ret
Prompt4_SPEED_FROM	endp

Prompt4_SPEED_TO	proc	far
	if ALLOWRAMPSPEED
	call	_DispRampVtr
	mov	dx,di
	add	dx,ZeroBase.SPEED_TO
	mov	bx,offset rampend_ovr
	mov	al,6
	call	_PromptForDecimal
	jc	p4str
	mov	ds:[di].SPEED_TODIR,cl 
	mov	ds:[di].SPEED_TO,ax
	mov	ds:[di].SPEED_TO+2,dx
	ENDIF ;	if ALLOWRAMPSPEED
p4str:	ret
Prompt4_SPEED_TO	endp

Prompt4_SPEED_TIME	proc	far
	if ALLOWRAMPSPEED
	mov	bx,offset rampdur_ovr	; Display prompt
	mov	dx, di
	add	dx, ZeroBase.SPEED_TIME
	call	GetRampTimeCode
	ENDIF ;	if ALLOWRAMPSPEED
	ret
Prompt4_SPEED_TIME	endp

Prompt4_SPEED_START	proc	far
	if ALLOWRAMPSPEED
	mov	bx,offset ramptime_ovr
	mov	dx, di
	add	dx, ZeroBase.SPEED_START
	call	GetRampTimeCode
	ENDIF ;	if ALLOWRAMPSPEED
	ret
Prompt4_SPEED_START	endp



;================================================================
RVSmakechanges	proc	near
	if ALLOWRAMPSPEED
	test	Ramp_Flags,enabled_MSBIT
	jz	RVSmcx
	call	CheckLegalRamp
	jnc	RVSmcx0
	ERROR	rampspecsillegal_error, ERET_Keyboard
RVSmcx0:call	CalculateRampChanges
	call	WriteRampToVlan
	ENDIF
RVSmcx:	ret
RVSmakechanges	endp

;================================================================
;	SPEED_DIRECTION	db	0
;	SPEED_VTR	db	0ffh
;	SPEED_FROM	dd	0
;	SPEED_FROMDIR	db	0
;	SPEED_TO	dd	0
;	SPEED_TODIR	db	'+'
;	SPEED_TIME	db	3 dup(0)
;	SPEED_START	db	3 dup(0)


;================================================================
CalculateRampChanges	proc	near
	if ALLOWRAMPSPEED
	push	ax
	push	bx
	push	dx
	push	si
	push	di

	push	ds
	pop	es

	mov	di,offset RampSpeedChange

; Select VTR as active
	mov	al,Current_Source
	call	Machine_Change

; Clear speed change buffer
	mov	ax,offset M_change_speed
	xor	cx,cx
	call	vtr_cmd			; Clear speed changes

; Get ABS(speed) of the TO and FROM speed change
	mov	ds:[di].SPEED_DIRECTION, 0	; Preset for speed increase

	mov	ax,ds:[di].SPEED_TO	; AX:DX = SPEED_TO
	mov	dx,ds:[di].SPEED_TO+2
	mov	cx,ds:[di].SPEED_FROM	; CX:BX = SPEED_FROM
	mov	bx,ds:[di].SPEED_FROM+2

	cmp	bx,dx			; From < To?
	jb	crchinc
	cmp	cx,ax
	jb	crchinc
	xchg	bx,dx
	xchg	cx,ax
	mov	ds:[di].SPEED_DIRECTION, 1	; Set for speed decrease

crchinc:sub	ax,cx
	sbb	dx,bx

; Save the difference in the speeds to RampChange
	mov	RampChange, ax
	mov	RampChange+2, dx

;...
; 				 NUMBER OF TOTAL CHANGES
; SPEED INCREMENTS (RampSteps) =	---------	  
;				     AVAILABLE CHANGES
	mov	cx,RAMPSPEEDBUFFERS * 100
	div	cx
	mov	RampSteps,ax
;...

	mov	si,offset RampSpeedTable
	mov	ramploopcounter, 0

; Spread the change out over the buffers
;	for(M=0; M < RAMPSPEEDBUFFERS; M+=RAMPSTEPS)

CRClp:
;				        M * RampChange
; SPEED(ZC) = (INT) SPEED_FROM +/-  -------------------------
;					RAMPSPEEDBUFFERS
	mov	ax, RampChange
	mov	dx, RampChange+2

	mov	cx,ramploopcounter
	mul	cx
	mov	cx,RAMPSPEEDBUFFERS
	div	cx
	xor	dx,dx

	mov	cx,ds:[di].SPEED_FROM
	mov	bx,ds:[di].SPEED_FROM+2
	cmp	ds:[di].SPEED_DIRECTION, 0		; Incrementing?
	jz	crcinc
	sub	cx, ax
	sbb	bx, dx
	jmp	crcinc1
crcinc:	add	cx, ax
	adc	bx, dx
crcinc1:mov	[si],cx
	mov	[si+2],bx
	add	si,4
	mov	bx,RampSteps
	add	ramploopcounter,bx
	cmp	ramploopcounter, RAMPSPEEDBUFFERS
	jbe	CRClp

	pop	di
	pop	si
	pop	dx
	pop	bx
	pop	ax

	ENDIF
	ret
CalculateRampChanges	endp

;FOR N = 1 TO DURATION STEP (DURATION / RAMPSPEEDBUFFERS)
WriteRampToVlan	proc	near
	if ALLOWRAMPSPEED
	push	ax
	push	bx
	push	dx
	push	si
	push	di

	mov	di,offset RampSpeedChange

	mov	si,offset RampSpeedTable

	mov	bx,di
	add	bx,ZeroBase.SPEED_START
	mov	dx,offset RampTiming
	push	dx
	call	_mmv3byt
	pop	bx
	dec	bx		; Point to sign before time code buffer

	mov	ax,word ptr ds:[di].SPEED_TIME
	mov	dl,byte ptr ds:[di].SPEED_TIME + 2
	mov	dh,0
	mov	cx,RAMPSPEEDBUFFERS
	div	cx
	mov	dx,ax			; dx = step
	xor	cx,cx

CRCdlp:	push	cx
	push	dx
	push	bx
	mov	cl,DF_CHAR
	mov	ch,[bx]

	call	Preroll_delayed		; Offset delay from Preroll
	call	_PMC_compensate		; Add or subtract programmed offsets
	call	_REVERSE_compensateIN	; Uncompensate for previews

	mov	dx,si			; Get pointer to speed
	add	si,4

	mov	ax,offset M_change_speed
	call	vtr_rmpcmd	; provides + or - depending on high bit in CH
	pop	bx
	pop	dx
	pop	cx

	add	word ptr [bx + 1], dx
	add	cx,dx
	cmp	cx,word ptr ds:[di].SPEED_TIME
	jbe	CRCdlp

	pop	di
	pop	si
	pop	dx
	pop	bx
	pop	ax
	ENDIF
	ret
WriteRampToVlan	endp

;================================================================
;================================================================
;================================================================






%list
; Automatic new match frame outpoint
;	SAVE MARKS
;	STORE CURRENT RECORD IN POINT
;	RECALL EDIT
;	SET RECORD OUT FROM "STORE CURRENT RECORD IN POINT"
;	PREVIEW EDIT
;	RESTORE MARKS
;	MATCHFRAME
	
AutoPmcMatch	proc	near
	call	_check4edl
	jz	APMret

	mov	BuiltInMacro, 1
	call	_SaveWorkspace
	mov	al,0
	call	Machine_Change

	mov	bx, offset R_Tc.tcIN
	mov	dx, offset Offset_Buffer
	call	_mmv3byt
	call	event_recall
	mov	bx, offset Offset_Buffer
	mov	dx, offset R_Tc.tcOUT
	call	_mmv3byt

	call	vtr_rehearse
	call	_RestoreWorkspace
	cmp	Abort_Flag,0ffh
	jz	APMxit

	call	Synctag
	call	_get_in
	mov	dx,bx

	mov	al,Current_Source
	dec	al
	cbw
	mov	bx,ax			; Multiply * 3
	shl	bx,1
	add	bx,ax
	add	bx,offset Tags_Table
	call	_mmv3byt

APMxit:	call	all_update
	mov	BuiltInMacro, 0
APMret:
	ret

AutoPmcMatch	endp

;================================================================
;		PUT BLIVITS WHERE THEY DONT FIT!
;		VARIABLE SPEED FILL MODE
; Fill% = (100 X SOURCE DURATION) / RECORD DURATION
speed_fill:
	mov	al,Current_Machine
	push	ax
	call	Machine_Change
	call	_get_in
	JMP_Z	spdfilx
	mov	dx,bx
	call	_get_out
	jz	spdfilx			; Skip if NO OUT POINT
	call	_cmp24b			; Compare IN to OUT
	jb	spdfilx			; Skip it if OUT < IN

	call	_get_dur		; Get source duration
	jnz	spdfil1			; Jump if not null
	xor	ax,ax
	jmps	spdfil2

spdfil1:call	_mvb2st1			; Bytstr1 = Source dur
	mov	bx,offset Bytstr2
	mov	byte ptr [bx],100	; Multiply by 100
	mov	word ptr 1[bx],0
	mov	dx,bx
	mov	bx,offset Bytstr1	; Get Source duration * 100
	call	_mpbmul			;Bytstr1 = SOURCE DURATION * 100

	xor	al,al			; Set record
	call	Machine_Change		;  machine
	call	_get_in
	jz	spdfilx
	call	_get_dur
	jz	spdfilx			; Bail out if null
	call	_mvb2st2			; Bytstr2 = R DURATION
	mov	bx,offset Bytstr1	; Source duration * 100
	mov	dx,offset Bytstr2	; R_duration

	call	_mpbdiv			; (Source duration * 100) / r_dur
	mov	ax,[bx]			; Get 16bit result from division
	cmp	ax,421			; 999% is it, absolutly
	jnb	spderr

spdfil2:call	_motion_convert
	mov	cx,ax
	mov	al,Current_Source
	call	_index2edspeed		; Get current speed
	mov	[bx],cl			; Set speed
	or	Spd_Flags,Enabled_MSBIT
	call	Spd_Upd
	pop	ax			; Restore Current_Machine
	call	Machine_Change
	jmp	MotionControlMenu	; Where to return to on success

spdfilx:pop	ax			; Restore Current_Machine
	call	Machine_Change
	ret

spderr:	pop	ax
	ERROR	badfill_error, ERET_Keyboard

;================================================================
;		SET SPEED DURING AN EDIT
;================================================================
MotionControlMenu:
	mov	al,Current_Machine
	or	al,al
	jnz	pgmmok
	mov	al,Current_Source
	call	Machine_Change
pgmmok:	cmp	al,MAX_DEVICES - 1
	jc	pgmsp
	ERROR	novarispd_error, ERET_Keyboard

pgmsp:	mov	Input_Flag,INFL_speed
	call	_help_pos		; Display header

	if ALLOWED_VTRS EQ 7
	call	_draw_EDITSPEEDS	; Draw EDIT SPEED box
	endif
	call	_draw_PMCBUFFERS	; Draw PMC box

;----------------------------------------------------------------
pgmsplp:call	DisplaySpeedChanges		; Display values for this trigger

	call	_kbd_cln			; Display which VTR
	call	mosource_disp
	call	_Space_Out
	mov	bx,offset Spdbufsel_Msg	; Ask for what to change
	call	_comsg
	call	_Space_Out

	call	rdchar			; Get command selection
	call	_Break_check		; Check for bail-out
	jnz	pgmch0
	jmp	pgmxit2

pgmch0:	cmp	ax,offset DelEv_xcmd		; Delete one?
	jnz	pgmch1
	jmp	pgmdel

pgmch1:	cmp	ax,offset InsEv_xcmd		; Insert?
	jnz	pgmch2
	jmp	pgmadd

pgmch2:	cmp	ax,offset Colonplus_xcmd	; Add?
	jnz	pgmch3
	jmp	pgmadd

pgmch3:	cmp	ax,offset Progspeed_xcmd	; Toggle Flag/Exit
	jnz	pgmch4
	jmp	pgmxit

pgmch4:	cmp	ax,offset Enter_xcmd		; Exit?
	jnz	pgmch5
	jmp	pgmxit2

pgmch5:	cmp	ax,offset Clrrd_xcmd		; Clear speed changes?
	jnz	pgmch6
	jmp	pgmclr

pgmch6:	cmp	ax,offset Play_xcmd
	jz	pgmch6a
	cmp	ax,offset Inrtn_xcmd
	jz	pgmch6a
	cmp	ax,offset Outrt_xcmd
	jz	pgmch6a
	cmp	ax,offset Durrt_xcmd
	jz	pgmch6a
	cmp	ax,offset Trimin_xcmd
	jz	pgmch6a
	cmp	ax,offset Trimout_xcmd
	jz	pgmch7

	if ALLOWED_VTRS EQ 7
	cmp	ax,offset Fill_xcmd
	jnz	pgmch7
	else
	jmp	pgmch7
	endif

pgmch6a:mov	al,Current_Source
	call	get_editspeed
	jmp	pgmsplp

pgmch7:	cmp	ax,offset Pause_xcmd	; Down
	jz	pgmch_next
	cmp	ax,offset Search_xcmd	; Up
	jz	pgmch_last
	jmp	pgms1

pgmch_next:
	mov	ch,Current_Machine
	inc	ch
	cmp	ch,MAX_SOURCES + 1
	jc	pgmsa1a
	mov	ch,a_dev
	jmp	pgmsa1a
pgmch_last:
	mov	ch,Current_Machine
	dec	ch
	jnz	pgmsa1a
	mov	ch,MAX_SOURCES
	jmp	pgmsa1a

;----------------------------------------------------------------
pgms1:	cmp	ax,offset Rm_xcmd	; Skip the record machine
	JMP_Z	pgmsplp

	push	ax
	call	_machine_keys		; CH has machine if Z=1
	pop	ax
	jnz	pgms2
pgmsa1a:or	ch,ch
	jz	pgms2

	cmp	ch,MAX_DEVICES - 1
	jnc	pgms2

	dec	ch
	mov	bx,offset A_Machine
	jz	pgms1a

	IF ALLOWED_VTRS GT 2
	dec	ch
	mov	bx,offset b_machine	
	jz	pgms1a
	endif

	IF ALLOWED_VTRS GT 3
	dec	ch
	mov	bx,offset c_machine
	jz	pgms1a
	endif

	IF ALLOWED_VTRS GT 4
	dec	ch
	mov	bx,offset d_machine
	jz	pgms1a
	endif

	IF ALLOWED_VTRS GT 5
	dec	ch
	mov	bx,offset e_machine
	jz	pgms1a
	endif

	IF ALLOWED_VTRS GT 6
	mov	bx,offset f_machine
	endif
pgms1a:	call	bx
	jmp	pgmsplp

pgms2:	cmp	al,'0'
	jc	pgms3
	cmp	al,'9'
	jbe	pgms4

pgms3:	call	keythru				; Try for "override" commands
	jmp	pgmsplp

;----------------------------------------------------------------
pgms4:	and	al,0fh			; Make decimal
pgms5:	cmp	al,MAX_SPEED_CHANGES + 1	; Change buffer?
	jc	pgmc0
pgmsper:call	_error_bell
	jmp	pgmsplp

pgmc0:	or	al,al
	jz	pgmsper

pgmc1:	cmp	al,MAX_SPEED_CHANGES + 1
	jc	pgmc1a
	jmp	pgmsplp
pgmc1a:	push	ax			; Save buffer number 1 - 6
	dec	al			; Adjust for 0 table offset
	call	siIndexToSpeedChange
	pop	ax
	call	PromptForSpeedChange
	jmp	pgmsplp

;================================================================
;		ADD A NEW SPEED CHANGE BUFFER
pgmadd:	mov	al,0
pgmadd1:call	siIndexToSpeedChange
	inc	al
	cmp	byte ptr [si], 0ffh
	jnz	pgmadd2
	jmp	pgms5			; Use this number
pgmadd2:cmp	al,MAX_SPEED_CHANGES
	jc	pgmadd1
	call	_error_bell
	jmp	pgmsplp

;================================================================
; Return SI->speed change buffer requested for AL, offset 0
siIndexToSpeedChange	proc	near
	push	ax			; Save buffer number
	push	cx
	cbw				; Convert to word
	mov	cl,SIZE VARSPEEDCHANGE	; Multiply by length of buffer
	mul	cl			;  to get the offset
	mov	si,offset Progmotion_Tbl ; Point to table
	add	si,ax			;  at correct offset
	pop	cx
	pop	ax			; Restore buffer number
	ret
siIndexToSpeedChange	endp


;================================================================
; 		DELETE A SPEED CHANGE BUFFER
; Delete a key
pgmdel:	mov	bx,offset Kilfil_Msg	; "Delete speed change
	call	_kbd_message		;  buffer #"
	mov	bx,offset Speedbuf_Msg
	call	_comsg

	call	_rdnum			; Get number 0-7
	jnc	pgmdel2			; Jump if number
	call	key_machine
	jc	pgmdel1
	jmp	pgmclr

pgmdel1:call	_make_ucase
	cmp	al,'A'			; Delete all?
	jnz	pgmdelx
	mov	bx,offset Kilfil_Msg
	call	_kbd_message
	mov	bx,offset Spdall_Msg
	call	_comsg
	mov	cl,'N'
	call	yn_chos
	jnz	pgmdelx
	call	clear_speedtable
pgmdelx:jmp	pgmsplp

pgmdel2:or	al,al			; Selection 0?
	jz	pgmdel
	cmp	al,MAX_SPEED_CHANGES
	ja	pgmdel

	push	ax			; Save selection
	mov	cx,ax
	mov	bx,offset Kilfil_Msg
	call	_kbd_message
	mov	bx,offset Speedbuf_Msg
	call	_comsg

	mov	al,cl
	call	_A_DecOut		; Ask for sure
	call	_Space_Out
	mov	cl,'N'
	call	yn_chos			; Default to NO
	pop	ax
	jnz	pgmdel4
	dec	al			; Adjust for 0 table offset
	call	siIndexToSpeedChange
	mov	word ptr [si].VSPD_VTR, 0ffh
;;	mov	word ptr [si].VSPD_SPD, 0ffh
;;	mov	word ptr [si].VSPD_DIR, PLUS_ASCII
;;	mov	word ptr [si].VSPD_TIM, 0

	call	motion_sort
pgmdel4:jmp	pgmsplp

;----------------------------------------------------------------
;	CLEAR VTR'S PROGRAMMED EDIT SPEED BUFFER
pgmclr:	call	DisplaySpeedChanges		; Display values for this trigger
	call	_kbd_cln
	call	mosource_disp
	mov	bx,offset Spdkil_Msg
	call	_comsg
	mov	cl,'N'
	call	yn_chos			; Default to NO
	jnz	pgmclrx
	mov	al,Current_Source
	call	_index2edspeed
	mov	byte ptr [bx],FPS	; Set to normal speed
pgmclrx:jmp	pgmsplp

;----------------------------------------------------------------
; Exits from routine
pgmxit:	mov	ax,Pmc_Flags		; 01100000
	and	ax,Enabled_MSBIT	; 00000000
	not	ax			; 11111111
	and	ax,Enabled_MSBIT	; 10000000
	and	Pmc_Flags,not Enabled_MSBIT
	or	Pmc_Flags,ax
	test	Pmc_Flags,Enabled_MSBIT
	jz	pgmxit5
pgmxit2:or	Pmc_Flags,Enabled_MSBIT
	call	_check4pmc			; Check if any available
	jnz	pgmxit5				; NZ if active
	and	Pmc_Flags,not Enabled_MSBIT
pgmxit5:or	Spd_Flags,Enabled_MSBIT
	call	_check4spd
	jnz	pgmupdx
	and	Spd_Flags,not Enabled_MSBIT
pgmupdx:call	Spd_Upd
	call	Pmc_Upd
	call	ramp_upd
	call	_evnt_dispthis
	ret

;================================================================
; Get speed for edit
get_editspeed:
	push	ax			; Save machine#
	call	_index2edspeed		; Get current speed
	mov	si,bx			; Save pointer to edit speed
	pop	ax

	push	ax
	call	_kbd_cln

	call	modevice_disp
	call	_Space_Out
	mov	bx,offset Editspeed_Msg	; Prompt for
	call	_comsg			;  speed at edit

	call	dec_plusminus		; Get +/- 1 to 3 digits
	jc	gedspd5

	cmp	ax,421			; Cut off point for 99 fps
	jc	gedspd2
	pop	ax
	ERROR	bad_parameters, ERET_Return
	jmp	get_editspeed

gedspd2:call	_motion_convert		; Convert it to speed
	cmp	cl,MINUS_ASCII
	jnz	gedspd3
	or	al,10000000b		; Set hi bit
gedspd3:mov	[si],al			; Save new speed
	or	Spd_Flags,Enabled_MSBIT	; Turn it on
gedspd5:call	_check4spd
	jnz	getspd6
	and	Spd_Flags,not Enabled_MSBIT
getspd6:call	Spd_Upd
	pop	ax
	ret

;================================================================
; Get input for a speed change buffer
; SI points to correect SIZE VARSPEEDCHANGE buffer
; AX = buffer number
PromptForSpeedChange	proc	near
	push	ax
	push	si
	call	DisplaySpeedChanges		; display values
	pop	si
	call	_kbd_cln
	call	mosource_disp

	mov	bx,offset Spdchg_Msg
	call	_comsg
	pop	ax			; Restore the buffer number from CX
	call	_A_DecOut
	mov	bx,offset Speed_Msg
	call	_comsg

; Get input
	call	dec_plusminus
	jc	gpcm10		; Move on to offset if null
	jz	gpcm7
	cmp	ax,421			; Cut off point for 99 fps
	jc	gpcm6
	ERROR	bad_parameters, ERET_Return
	jmp	PromptForSpeedChange

gpcm6:	call	_motion_convert		; Convert it to speed
	cmp	cl,MINUS_ASCII
	jnz	gpcm7
	or	al,10000000b		; Set hi bit

gpcm7:	mov	cl,Current_Source	; VTR is LSB
	mov	ch,al			; SPEED is MSB
	mov	[si],cx			; Save new vtr and speed

gpcm10:	mov	bx,offset spdchange_rqst
	call	_Inout_init
	mov	Trim_Ci_Flag,0ffh	; Use + and -

	inc	si			; Point to offset buffer
	inc	si

	lodsb				; Get sign
	mov	cl,al			; to CL
	mov	bx,si			; Get pointer
	mov	ch,Rtcf			; Use record fcm
	call	tc_parenth
	call	get_Vtrcb_FCM		; To AL
	mov	bx,offset Sttime	; Use Sttime for work area
 	call	tc_cimsg
	jc	gpcmclr
;;	call	_time_value
;;	jz	gpcmfmt
	jmp	gpcmret

gpcmclr:mov	bx,offset Tc_Format	; Clear it out
gpcmret:mov	dx,si
	call	_mmv3byt
	mov	al,Sign_Flag
	cmp	al,MINUS_ASCII
	jz	gpcmsgn
	mov	al,PLUS_ASCII
gpcmsgn:mov	byte ptr -1[si],al	; Save sign
gpcmfmt:call	motion_sort
	or	Pmc_Flags,Enabled_MSBIT	; Turn it on
	call	Pmc_Upd
	ret
PromptForSpeedChange	endp


;================================================================
;	Display all seven of the machine's speed info
;================================================================
; AX = current machine
DisplaySpeedChanges	proc	near
	if ALLOWED_VTRS EQ 7
	call	DisplaySpeedsAtInPoint
	endif
	mov	si,offset Progmotion_Tbl; Point to table
	mov	di,offset List_Scr + 126h
	mov	cx,MAX_SPEED_CHANGES	; # of buffers
	mov	al,1			; Local buffer number

vspd_line:
	push	ax			; Save pass counter
	push	cx

	mov	Cursor,di			; Get Cursor
	add	di,100h

	cbw
	mov	bx,ax			; Display pass counter
	call	_default_val
	dec	Cursor			; OH NO! TRICKING THE Cursor?

	mov	al,[si].VSPD_VTR	; Get machine
	cmp	al,0ffh
	jnz	vspd1
	dim_VIDEO FALSE,TRUE
	mov	bx, SpacePointer(8); 8 leading Spaces
	call	_comsg
	mov	bx,offset Empty_Msg	; <empty> message
	call	_comsg
	mov	cx,21
vspdspl:call	_Space_Out
	loop	vspdspl
	jmp	vspdagn

vspd1:	dim_VIDEO FALSE,TRUE
	cmp	al,Current_Source
	jnz	vspd2
	norm_VIDEO FALSE,TRUE
vspd2:	call	_Space_Out
	add	al,'A'-1
	call	_ConOut
	call	space_2_out
	call	_Space_Out
	mov	al,[si].VSPD_SPD		; Get speed
	call	_speed_percent			; Display speed in %

	call	_vpslmin			; Norm vid, adjust for +-
	xor	ah,ah
	mov	bx,ax
	call	_DecOut_100_pad			; Display padded version
	mov	bx,offset Framesec_Msg		; Frames/second message
	call	_comsg
	call	_Space_Out

	mov	al,[si].VSPD_DIR		; Get sign
	mov	bx,si
	add	bx,offset ZeroBase.VSPD_TIM			; Point to TC
	push	ax
	call	_time_value
	pop	ax
	jnz	vspd4
	call	_Space_Out
	jmps	vspd5

vspd4:	call	_ConOut
vspd5:	mov	dx,offset Tcdispbuf	; Ascii buffer
	mov	cl,Rtcf			;Force record TCF type
	call	_cnvt2tc_DS
	call	_comsg			; Character 11 - 22
vspdagn:pop	cx
	pop	ax
	add	si,SIZE VARSPEEDCHANGE
	inc	al
	dec	cx
	jz	vspdxit
	jmp	vspd_line
vspdxit:ret
DisplaySpeedChanges	endp

;===================================================
;	Display source speed at edit point
;===================================================
DisplaySpeedsAtInPoint:
	mov	al,1
	mov	di,offset List_Scr + 101h; Screen at column 40
	mov	si,offset Tags_Table
edspdlp:norm_VIDEO FALSE,TRUE
	cmp	al,Current_Source
	jnz	edspd1
	rev_VIDEO FALSE,TRUE
edspd1:	mov	Cursor,di
	add	di,100h
	call	_Space_Out		; Leading space in case of rev_vid
	push	ax
	add	al,'A'-1
	call	_ConOut
	call	_Space_Out		; Leading space in case of rev_vid
	pop	ax
	push	ax
	call	_index2edspeed		; Get speed at edit (AL), BX points
	xor	ah,ah
	call	_speed_percent		; Display speed in %
	call	_vpslmin
	mov	bx,ax
	call	_DecOut_100_pad		; Display padded version
	mov	bx,offset Framesec_Msg	; Frames/second message
	call	_comsg
	call	_Space_Out

	pop	ax			; Get VTR number to AL
	push	ax			;  and push it back
	mov	cl,al			; Copy VTR to CH
	call	pmctag_disp

	pop	ax
	inc	al
	cmp	al,MAX_DEVICES - 1
	jnz	edspdlp
	ret

; ENTER: AL and CL = machine to display
; AX, CX, BX, DX used
pmctag_disp:
	push	si
	call	Idxatcf			; Get then FCM
	cmp	cl,Current_Source	; If already reverse video,
	mov	cl,al			;Force record TCF type
	mov	bx,si
	jz	pmctg2			;  then just display information

	call	_time_value		; Anything here?
	jnz	pmctg1
	dim_VIDEO FALSE,FALSE
	jmp	pmctg2
pmctg1:	norm_VIDEO FALSE,FALSE
pmctg2:	mov	dx,offset Tcdispbuf	; Ascii buffer
	call	_cnvt2tc_DS
	call	_comsg			; Character 11 - 22
	call	_Space_Out
	pop	si
	inc	si
	inc	si
	inc	si
	ret

; Display VTR
mosource_disp:
	mov	al,Current_Source
modevice_disp:
	call	_machine_disp
	mov	al,'R'
	call	_ConOut
	ret

;================================================================
; Return a value in AX and DX (same), sign in CL
dec_plusminus:
	mov	al,4
	call	dec_cimsg
	jz	decplmc			; Move on to offset if null
	mov	cl,[bx]			; Check for +/-
	cmp	cl,PLUS_ASCII
	jz	decplmx
	cmp	cl,MINUS_ASCII
	jz	decplmx
	call	_convert2bin
	mov	cl,[bx]			; Check for +/- on tail
	cmp	cl,PLUS_ASCII
	jz	decplm1
	cmp	cl,MINUS_ASCII
	jz	decplm1
	mov	cl,PLUS_ASCII
decplm1:clc
	ret

decplmc:stc
	ret
decplmx:inc	bx			; Point to value
	call	_convert2bin		; Get %
	clc
	ret

;----------------------------------------------------------------
; See if AX is A-VTR, B-VTR, C-VTR, or D-VTR
; If it is, switch machines, return carry clear, CH = machine
; If not, return carry set
key_machine:
	push	ax
	call	_machine_keys
	pop	ax
	jnz	pgmd1b
	or	ch,ch
	jz	pgmd1b
	cmp	ch,MAX_DEVICES - 1
	jnc	pgmd1b
	dec	ch
	mov	bx,offset A_Machine
	jz	pgmd1a

	IF ALLOWED_VTRS GT 2
	dec	ch
	mov	bx,offset b_machine
	jz	pgmd1a
	ENDIF
	IF ALLOWED_VTRS GT 3
	dec	ch
	mov	bx,offset c_machine
	jz	pgmd1a
	ENDIF
	IF ALLOWED_VTRS GT 4
	dec	ch
	mov	bx,offset d_machine
	jz	pgmd1a
	ENDIF
	IF ALLOWED_VTRS GT 5
	dec	ch
	mov	bx,offset e_machine
	jz	pgmd1a
	ENDIF
	IF ALLOWED_VTRS GT 6
	mov	bx,offset f_machine
	ENDIF
pgmd1a:	pushf
	call	bx
	popf
	clc
	ret

pgmd1b:	stc
	ret


;================================================================
; Reset variable speed table to NULL
reset_editspeed:
	push	ax
	push	bx
	mov	cl,1			; Start with first SOURCE VTR
	mov	ch,FPS			; Set to this speed
rstsp1:	mov	al,cl
	call	_index2edspeed		; Index BX to speed byte in Vtrcb
	mov	[bx],ch			; Reset speed
	inc	cl
	cmp	cl,MAX_SOURCES
	jbe	rstsp1
	pop	bx
	pop	ax
	ret

; Reset variable speeds
reset_varispeeds:
	push	ax
	push	bx
	mov	ch,1			; Start with first source VTR
rstvari:push	cx

	call	get_Vtrcb		; Get node number
	or	ch,ch			; 3-22-1993 was "or al,al" WRONG!!
	jz	rstvagn

	mov	cl,VX_DIGITch		; Set node # request
	mov	ax,offset M_node_address
	call	vtr_cmd			; Set From side on
	cmp	word ptr [bx],'RE'	; Error?
	jz	rstvagn
	mov	ax,offset M_change_speed	; Reset vari speeds
	call	motion
rstvagn:
	pop	cx
	inc	ch
	cmp	ch,ALLOWED_VTRS
	jb	rstvari
	pop	bx
	pop	ax
	ret

;================================================================
; Clear out the speed table
clear_speedtable:
	mov	al,Current_Source
	or	al,al			; Record machine?
	jz	clrspdr
	cmp	al,MAX_DEVICES - 1
	jnc	clrspdr

	call	reset_editspeed

; Dont check, just clear the indicated machine's table
clear_spdtbl:
	mov	bx,offset Progmotion_Tbl ; Point to table
	mov	cx,MAX_SPEED_CHANGES
clrspds:mov	byte ptr [bx],0ffh
;	mov	word ptr [bx],0ffffh	; 0ffffh and "+"
;	mov	word ptr 2[bx],002bh
;	mov	word ptr 4[bx],00
	add	bx,SIZE VARSPEEDCHANGE
	loop	clrspds
clrspdr:ret

;================================================================
; CLEAR Tags_Table
;
clear_tagstable:
	push	ax
	push	es
	push	ds
	pop	es
	mov	di,offset Tags_Table
	mov	cx,3 * (MAX_DEVICES - 1)
	xor	al,al
	rep stosb
	pop	es
	pop	ax
	ret

;================================================================
;		SET SPEED OF CURRENT VTR
;================================================================
; ENTER: AL = VTR
WriteAllSpeeds	proc	near
	push	ax
	push	bx
	push	cx

; Ramp speeds override any speed changes
	test	Ramp_Flags,Enabled_MSBIT	; Is SPD Enabled?
	jz	was1
	cmp	al, RampSpeedChange.SPEED_VTR	; For this VTR?
	jnz	was1
	call	RVSmakechanges
	jmp	svtspdx

; WRITE THE EDIT SPEED TO THE VLAN
was1:	test	Spd_Flags,Enabled_MSBIT		; Is SPD Enabled?
	jnz	svtspd1				; Jump if ENABLED
	mov	cl,PLUS_ASCII			; Else set for
	mov	al,FPS				;  play speed
	jmp	svtspd2

svtspd1:mov	al,Current_Machine
	call	_index2edspeed		; Get initial speed at edit
	mov	cl,PLUS_ASCII
	test	al,80h				; Negative direction?
	jz	svtspd2
	and	al,7fh
	mov	cl,MINUS_ASCII
svtspd2:mov	ch,al
	mov	ax,offset M_set_variable
	call	vtr_cmd				; Set initial speed
;...

; WRITE ALL #MAX_SPEED_CHANGES BUFFERS FOR SPEED CHANGES
	mov	al,Current_Machine
	push	ax
	call	get_Vtrcb_FCM			; ( TO AL, POINTER TO BX)
	pop	ax				; Restore current machine
	mov	ah,[bx]				; Store FCM to AH

	test	Pmc_Flags,Enabled_MSBIT
	jz	svtspdx

	mov	bx,offset Progmotion_Tbl	; Point to table
	mov	cx,MAX_SPEED_CHANGES		; # of tables to do
svtspdl:cmp	byte ptr [bx],0ffh		; Check for no more
	jz	svtspdx				;  speed changes
	push	cx				; Save Count
	push	ax				; Save machine # / FCM
	push	bx
	cmp	byte ptr [bx],al		; Correct machine?
	jnz	svtspds

	call	_tlinepmc_save
	inc	bx			; Increment to SPEED byte
	mov	ch,byte ptr [bx]	; Get SPEED in FRM/SEC
	cmp	ch,0ffh			; Empty buffer?
	jz	svtspds			; Jump if empty
	mov	cl,ah			; FCM to CL
	inc	bx			; BX points to the 4 byte buf
	call	Preroll_delayed		; Offset delay from Preroll

	call	_PMC_compensate		; Add or subtract programmed offsets
	call	_REVERSE_compensateIN	; Uncompensate for previews

	call	_Delay_Vtr_Function

	mov	ax,offset M_change_speed	; AX has VLAN command type
	call	vtr_pmccmd

svtspds:pop	bx
	add	bx,SIZE VARSPEEDCHANGE		; Point to next buffer
	pop	ax				; Restore machine/FCM
	pop	cx				; Restore Count
	loop	svtspdl
svtspdx:pop	cx
	pop	bx
	pop	ax
	ret
WriteAllSpeeds	endp


;================================================================
; Check for variable speed available
; Return Z=1 if OK, else NZ
test_4_varispd	proc	near
	push	ax
	mov	ch,Current_Source
	call	SetActiveVtr_CH
	mov	ax,offset M_test_variable
	xor	cx,cx
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	cmp	byte ptr [bx],'Y'
	pop	ax
	ret
test_4_varispd	endp

;================================================================
; Sort motion buffers in time order
motion_sort:
	mov	bx,offset Progmotion_Tbl ; Point to table
	mov	dx,offset Temp_Wrkspce	; Move it to temporary buffer
	mov	si,dx			; Get buffer address to SI
	mov	di,bx			; Get original buffer to DI
	mov	ch,MAX_SPEED_CHANGES * SIZE VARSPEEDCHANGE ; Length of each entry
	call	_mmv
	call	clear_spdtbl

; Sort it:
; Scan speed table and reload the original buffer in sort order
; DO FOR NEGATIVE OFFSETS

mosrt1:	xor	ch,ch			; Indicate pass 0
mosrt2:	mov	bx,offset Tc_Format	; Find greater than 0
	or	ch,ch
	jz	mosrt3
	mov	bx,offset Sort_Tcfmt	; Find less than 23:59:59:29
mosrt3:	mov	dx,offset Offset_Buffer
	call	_mmv3byt
	push	cx
	push	si
	mov	ah,MINUS_ASCII			; First pass for negative
	or	ch,ch
	jz	mosrt5
	mov	ah,PLUS_ASCII			; Second pass for positive
mosrt5:	call	ms_srtr			; Make a pass
	or	bp,bp			; Done?
	jz	mosrt_n

	mov	si,bp			; Get buffer address
	push	es			; Move bytes
	push	ds
	pop	es
	mov	cx,SIZE VARSPEEDCHANGE
	rep movsb
	pop	es
	mov	byte ptr ds:[bp],0ffh ; Mark this as DONE.
	pop	si
	pop	cx
	jmps	mosrt2

mosrt_n:pop	si
	pop	cx
	or	ch,ch			; First pass for negative?
	jnz	mosrt_p			; Exit if not
	dec	ch			; Indicate not first pass
	jmps	mosrt2

mosrt_x:pop	si
	pop	cx
mosrt_p:ret

;================================================================
; Make a pass at the registers
; SI points to first if buffers for this machine
; AH has + or -
; Exit: BP points to next highest time or 0 for nothing left
; If Negative number, find the greatest one
ms_srtr:push	cx
	mov	bp,0
	mov	cx,7
ms_srtl:push	si			; Save buffer start
	lodsb				; Get VTR assignment byte
	cmp	al,0ffh			; Skip this buffer?
	jz	ms_srt9

	lodsb				; Get speed
	lodsb				; Get sign, (FOR NOW)
	cmp	ah,al
	jnz	ms_srt9

	mov	bx,si			; BX points to value
	mov	dx,offset Offset_Buffer
	push	ax
	call	_cmp24b			; Is new <= old?
	pop	ax
	pushf
	cmp	ah,MINUS_ASCII			; Looking for greater?
	jnz	ms_srt2
	popf
	jae	ms_srt5
	jmps	ms_srt9

ms_srt2:popf
	jnc	ms_srt9

ms_srt5:push	ax
	call	_mmv3byt			;  Below or equal, copy it
	pop	ax

	pop	bp			; Save current address
	push	bp			;  as new buffer (from SI)

ms_srt9:pop	si
	add	si,SIZE VARSPEEDCHANGE
	loop	ms_srtl
	pop	cx
	ret


_TEXT	ends

_DATA	segment byte public 'DATA'

ramploopcounter	dw	0
rampposchoices	db	1

	if ALLOWRAMPSPEED
RampSpeedTable	dw	RAMPSPEEDBUFFERS * 2 dup(0)
RampChange	dw	0,0
RampSteps	dw	0
RampSign	db	PLUS_ASCII
RampTiming	db	3 dup(0)
	ELSE
RampSpeedTable	dw	?
RampChange	dw	?,?
RampSteps	dw	?
RampSign	db	?
RampTiming	db	?
	ENDIF
_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
