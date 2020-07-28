; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner
; VMVLANB.ASM
; VLAN INTERFACE MODULE "B" segment
;
%nolist
include vm.equ


extrn ememopts_ovr:word,_msg2screen:far,rampenabled_ovr:word
extrn rampstart_ovr:word,rampend_ovr:word,rampdur_ovr:word
extrn ramptime_ovr:word,testbase_scr:word,testmsg_scr:word
extrn Vlan_Swbuf_CNT:byte,Active_IOTYP:byte,Color_BKG:byte
extrn Current_Machine:byte,Current_Source:byte,Diag_Test_Number:byte
extrn Diag_Vtr_Number:byte,Effects_Address:byte,From_Machine:byte
extrn Gpi_Node:byte,Input_Flag:word,Key_Mode:byte,Keybkgnd_Src:byte
extrn Keyfor_Src:byte,Rtcf:byte,Sign_Flag:byte,To_Machine:byte
extrn Trans_Type:byte,Trim_Ci_Flag:byte,Video_Mode:byte,Vtr_Mult_Type:byte
extrn Mode_Flag:byte,Split_Mode:byte

extrn Ascii_Number:word,Cursor:word,INSTL_Choices:word,PointShootData:word
extrn Vlan_Swbuf:word,Vlan_Swbuf_PTR:word,Vlan_Swbuf_SIZ:word
extrn Atrans_Offset:word,Current_FRMbuf:word,Cursor:word
extrn Diag_Error_Count:word,Diag_Loop_Count:word
extrn Diagsum_Table:word,dirbuff:word,Done_Msg:word,Entime:word
extrn exitmenu_ovr:word,Fillhdr_Msg:word,Gpi0:word,inactive_ovr:word
extrn Key_Trans:word,List_Scr:word,offmsg_ovr:word
extrn Offset_Buffer:word,Ofspeed_Msg:word,onmsg_ovr:word,Preroll:word
extrn Progmotion_Tbl:word,R_Tc:word,Ramp_Flags:word
extrn rampdialog_ovr:word,RampSpeedChange:word,Relaytype_Tbl:word
extrn Sort_Tcfmt:word,Speed_Msg:word,Speedhdr_Msg:word,Sttime:word
extrn Tc_Format:word,Tcdispbuf:word,Temp_Wrkspce:word,Testing_Msg:word
extrn tglmsg_ovr:word,Timelineroll:word,Trans_Code:word,Trans_Length:word
extrn Vtrcb:word,Split_Delay:word

extrn INSTL_PQdisplay:near,dec_cimsg:near
extrn get_vtr:near,get_Vtrcb:near,getxpt:near,locations:near,m20_dp:near
extrn Machine_Change:near,motion:near,play:near,position_query:near
extrn Preroll_delayed:near,rdchar:near,scan:near,screen_init:near,still:near
extrn switch:near,tc_cimsg:near,tc_parenth:near,vtr_cmd:near
extrn vtr_opt:near,yn_chos:near

extrn _A_DecOut:far,_ConOut:FAR,_ConOut:far
extrn _DecOut:far,_DecOut_100_pad:far,_DecOut_Pad:far,_DrawBox:far
extrn _DrawMenuBox:far,_MsgCntr:FAR,_REVERSE_compensateIN:far,_dltoi:far
extrn _Restore_Marktable:FAR,_Space_Out:far,_VVV_compensateIN:far,_atoi:far
extrn _beeper:FAR,_blinkita:FAR,_Break_check:FAR,_Break_check:far
extrn _clear_screen:FAR,_clear_screen:far,_cmp24b:far,_cnvt2tc_DS:far
extrn _cnvt2tc_DS:far,_comsg:FAR,_comsg:far,_convert2bin:far,_crlf:FAR
extrn _dashit_cl:far,_default_val:FAR,_delfrm:FAR,_delfrm:far,_delms:FAR
extrn _dircur_lerase:FAR,_Elaptm_move:far,_Entime_move:far,_error_bell:FAR
extrn _error_bell:far,_evnt_dispthis:far,_help_pos:FAR,_help_pos:far
extrn _Inout_init:far,_itoa100:far,_kbd_cln:FAR,_kbd_cln:far,_kbd_clr:FAR
extrn _kbd_clr:far,_lblocks:FAR,_line_erase:FAR,_line_erase:far
extrn _machine_disp:far,_machine_keys:far,_make_ucase:far,_mmv16:far
extrn _mmv3byt:far,_mmv:far,_mpbadd:far,_mpbsub:far,_msgread:far,_nblocks:FAR
extrn _rdnum:FAR,_sram_dx:far,_Sttime_move:far,_timdif:far,_time_value:far
extrn dec_cimsg_FAR:far,getxpt_FAR:far,_VVV_compensateOUT:far
extrn _VVV_compensateSplit:far

BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg

Public  _VSW_sort, VSW_srtclr, VSWsrt2, VSWsrt_x, VSW_srtr, VSW_srtl, VSW_srt9
Public  _vlan_switcher_trigger, VST_2, VST_4, VST_KEYOFF, vstk1, VST_nk1
Public  VSTcpls, VSTcx, VST_cx1, VST_ret, VST_Edit_Cut, VSTC_1, VSTC_3, VSTC_5
Public  VSTC_ret, _VLAN_wipes, VWIPEx, _EFXscreen, _DispRampVtr
Public  _PromptForDecimal, pdfcbad, pdfcold, _RampSpeed_CARD
Public  _DisplayAsciiDecimal, _DispTcToShortString, dtslp, dtssn, dtseos
Public  dtsxit, _draw_EDITSPEEDS, _draw_PMCBUFFERS, _speed_percent
Public  _index2edspeed, _motion_convert, _PercentPlaySpeed, _check4pmc, c4pmclp
Public  c4pmcx, _check4spd, c4spdlp, c4spdx, _vpslmin, vngn1, vngn3, vngn4
Public  _GPI_sort, GPI_srtclr, gpisrt1, gpisrt2, gpisrt3, gpisrt5, gpisrt_n
Public  gpisrt_x, gpisrt_p, gp_srtr, gp_srtl, gp_srtp, gp_srt1, gp_srt2
Public  gp_srt5, gp_srt9, _Relay_Index, rlyind2, rlyind3, _Check4GPIs, c4g_2
Public  c4g_3, _Draw_Relays, rlydlp, rlydlp1, rlyone, rlyone1, rlycmg, rlyone2
Public  rlyone3, rlyone4, rlyone6, rlyonex, Set_PreviewSw_Bits
Public  _Draw_Relay_Lines, Drwrl2, _VTR_Summary, VTRsum2, TVTTC3o, VTRsdx
Public  _Norm_Test, _Show_Test, shotest, shotst, _Diag_Msgs, _Done_msgs
Public  VST_Edit_PvwOut, Terminate_Swbuf

;================================================================
; Sort VSW buffers in time order
;================================================================
_VSW_sort	proc	far
	mov	bx,offset Vlan_Swbuf	; Point to table
	mov	dx,offset dirbuff	; Move it to temporary buffer
	mov	si,dx			; Get buffer address to SI
	mov	di,bx			; Get original buffer to DI
	mov	cx,Vlan_Swbuf_SIZ
	push	cx
	call	_mmv16
	pop	cx
	mov	bx,di
VSW_srtclr:
	mov	byte ptr [bx],0
	inc	bx
	loop	VSW_srtclr

; Sort it:
VSWsrt2:mov	bx,offset Sort_Tcfmt
	mov	dx,offset Offset_Buffer
	call	_mmv3byt
	push	cx
	push	si
	call	VSW_srtr		; Make a pass
	or	bp,bp			; Done?
	jz	VSWsrt_x

	mov	si,bp			; Get buffer address
	push	es			; Move bytes
	push	ds
	pop	es
	mov	cx,VLANSW_LENGTH
	rep movsb
	pop	es
	mov	ds:word ptr [bp].VSW_TransitionDur,0ffffh ; Mark this as DONE.
	pop	si
	pop	cx
	jmps	VSWsrt2

VSWsrt_x:
	pop	si
	pop	cx
	ret
_VSW_sort	endp

;................................................................
; Make a pass at the BUFFER
; Exit: BP points to next highest time or 0 for nothing left
VSW_srtr:
	push	cx
	mov	bp,0
	mov	cl,Vlan_Swbuf_CNT
	mov	ch,0

VSW_srtl:
	push	si
	cmp	word ptr [si].VSW_TransitionDur,0ffffh	; Skip this buffer?
	jz	VSW_srt9

	mov	bx,si			; BX points to value
	add	bx,VSW_OfstTime
	mov	dx,offset Offset_Buffer
	push	ax
	call	_cmp24b			; Is new <= old?
	pop	ax
	jae	VSW_srt9
	call	_mmv3byt		;  above or equal, copy it
	pop	bp			; Save current address
	push	bp			;  as new buffer (from SI)

VSW_srt9:
	pop	si
	add	si,VLANSW_LENGTH
	loop	VSW_srtl
	pop	cx
	ret

;================================================================
; Sets the bits 3 to 7 for byte 4 of switcher record
; Depending on bits set in AL on entry
;  AL is usually either the Mode_Flag or the Split_Mode
Set_PreviewSw_Bits	proc	near
	xor	ah,ah
	test	al, video_Emode
	jz	SPB1
	or	ah, 00001000b
SPB1:	test	al, aud1_Emode
	jz	SPB2
	or	ah, 00010000b
SPB2:	test	al, aud2_Emode
	jz	SPB3
	or	ah, 00100000b
SPB3:	test	al, aud3_Emode
	jz	SPB4
	or	ah, 01000000b
SPB4:	test	al, aud4_Emode
	jz	SPB5
	or	ah, 10000000b
SPB5:	xchg	al,ah			; Return bit map in AL
	ret
Set_PreviewSw_Bits	endp


;================================================================
;
;		VLAN SWITCHER TRIGGER SETUP
;
;================================================================
_vlan_switcher_trigger	proc	far
	CUTSONLY_TEST

	call	VST_Edit_Cut		; Preset switcher conditions

	; If preview switch, force second switch for in point
	cmp	Active_IOTYP, preview_IOTYP
	jz	VST_1

	cmp	Trans_Type,'C'		; Set already for CUT?
	JMP_Z	VST_ret
	cmp	Trans_Type,'S'
	JMP_Z	VST_ret

VST_1:	mov	si,Vlan_Swbuf_PTR

	xor	dx,dx

;2-05-1994 
	mov	al,Active_IOTYP
	mov	byte ptr [si].VSW_IOTYP, al
;...

; Byte 0 and 1 -- Transition duration in frames
	mov	dl,2			; specify Dissolve for PRIMARY KEY
	mov	bx,Key_Trans		; USE KEY TRANSITION
	cmp	Trans_Type,'K'		;  IF KEY
	jz	VST_2
	mov	bx,Trans_Length		; USE MAIN TRANSITION
	mov	dl,2			; specify Dissolve
	cmp	Trans_Type,'D'		;
	jz	VST_2
	mov	dl,3			; specify Wipe

;3-08-1993 Fixed .VSW_TransitionDur for WORD length
VST_2:	mov	[si].VSW_TransitionDur, bx

; Byte 2 -- Pattern # for wipes, or Memory address for Memory recall
	mov	bx,Trans_Code
	mov	[si].VSW_PatternNumber, bl

; Byte 3 -- Pattern Modifier
	call	 FAR PTR _VLAN_wipes		; pattern modifier
	mov	[si].VSW_PatternModifier, al

; Byte 4 -- Pattern replication factor
	cmp	Active_IOTYP, preview_IOTYP
	jnz	VST_2S
	mov	al, Mode_Flag
	cmp	Trans_Type,'S'
	jnz	VST_2R
	mov	al, Split_Mode
VST_2R:	call	Set_PreviewSw_Bits
	jmp	VST_2T
VST_2S:	xor	al,al
VST_2T:	mov	[si].VSW_PatternReplicate, al

; Byte 5 -- Transition type / ME address
	mov	al,Effects_Address
	shl	al,1			; Move effects address
	shl	al,1			;  to upper nibble
	shl	al,1
	shl	al,1
	or	al,dl
	mov	byte ptr [si].VSW_TransME, al

; Byte 6 -- Next program source
	mov	al,To_Machine
	cmp	Trans_Type,'K'
	jnz	VST_4
	mov	al,Keybkgnd_Src
VST_4:	cmp	Active_IOTYP, preview_IOTYP
	jnz	VST_4s
	mov	al, 2			; Set for source side
	jmp	VST_4t

VST_4s:	call	getxpt_FAR
VST_4t:	mov	[si].VSW_NextPgmSrc, al

; Byte 7 -- Next key Flags
	xor	al,al
	cmp	Trans_Type,'K'		; Skip following if
	jnz	VST_KEYOFF		;  not a KEY

	cmp	Key_Mode,2		; Key OUT?
	jz	VST_KEYOFF		; Keyer will be turned OFF from ON

	mov	al,00010000b		; Set for PRIMARY KEYER

VST_KEYOFF:
	mov	[si].VSW_NextKeyFlags, al

; Subrecord Byte 1, KEY FOREGROUND SOURCE
	mov	al,Keyfor_Src
	call	getxpt_FAR
	mov	[si].VSW_KeyFore, al

; Subrecord Byte 2, KEY SOURCE (PATTERN # IF A PATTERN LIMIT)
; SAME AS FOREGROUND SOURCE
	mov	[si].VSW_KeySrc, al

; Subrecord Byte 3, KEY MODIFIERS
	mov	al,0
	mov	[si].VSW_KeyMods, al

	mov	bx,offset Preroll
	cmp	Vtr_Mult_Type,V_roll
	jnz	vstk1
	mov	bx,offset Timelineroll
vstk1:
; Check for a KEY OUT
	cmp	Trans_Type,'K'		; Is edit a KEY
	jnz	VST_nk1
	cmp	Key_Mode,2		; Is this a Key out?
	jnz	VST_nk1
	push	bx
	mov	bx,offset R_Tc.tcDUR
	call	_Entime_move
	mov	dx,Key_Trans
	mov	Sttime,dx
	mov	byte ptr Sttime + 2,0
	call	_timdif			; Entime - Sttime = Elaptm
	pop	dx			; Restore Preroll
	call	_mpbadd			; Add it on

VST_nk1:call	_VVV_compensateIN	; Compensate for preview advances
	call	_Sttime_move		; Move TC val to Sttime
	jz	VSTcx			; Bailout if null TC
	mov	dx,offset Atrans_Offset	; DX points to offset value
	cmp	byte ptr Atrans_Offset + 3,MINUS_ASCII	; Check for + or -
	jnz	VSTcpls
	call	_mpbsub			; Subtract if negative
	jmp	VSTcx
VSTcpls:call	_mpbadd			; Add if positive offset
VSTcx:
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;11-12-1992 Take care of delayed effects
	cmp	Trans_Type,'K'		; Is edit a KEY, so skip this
	jz	VST_cx1

	xchg	bx,dx			; Save address of time code
	mov	bx,Current_FRMbuf	; Get address of FROM VTR buffers
	add	bx,6			; Index over to duration
	xchg	bx,dx			; BX = R-VT offset, DX = delay
	call	_mpbadd			; Add in the delayed effect
VST_cx1:

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	mov	ax,[bx]
	mov	word ptr [si].VSW_OfstTime, ax
	mov	al,2[bx]
	mov	byte ptr [si+2].VSW_OfstTime, al
	call	Terminate_Swbuf
VST_ret:ret
_vlan_switcher_trigger	endp


;................................................................
; Send EDIT CUT Command
VST_Edit_Cut:
	mov	si,Vlan_Swbuf_PTR

	mov	al,Active_IOTYP
	mov	[si].VSW_IOTYP, al

; Byte 0 and 1 -- Transition duration in frames
	mov	bx,Trans_Length
	mov	[si].VSW_TransitionDur, bx

; Byte 2 -- Pattern # for wipes, or Memory address for Memory recall
	mov	bx,Trans_Code
	mov	[si].VSW_PatternNumber, bl

; Byte 3 -- Pattern Modifier
	call	 FAR PTR _VLAN_wipes		; pattern modifier
	mov	[si].VSW_PatternModifier, al

; Byte 4 -- Pattern replication factor / Preview channels (set 0, all channels)
	xor	al,al
	mov	[si].VSW_PatternReplicate, al

; Byte 5 -- Transition type / ME address
	mov	al,Effects_Address
	shl	al,1			; Move effects address
	shl	al,1			;  to upper nibble
	shl	al,1
	shl	al,1
	mov	[si].VSW_TransME, al

; Byte 6 -- Next program source

	; If preview switcher, set R for first cut
	xor	al,al
	cmp	Active_IOTYP, preview_IOTYP
	jz	VSTC_1
	;...

	mov	al,To_Machine		; Start withr To_Machine
	cmp	Trans_Type,'C'		; Use the TO settings
	jz	VSTC_1
	cmp	Trans_Type,'S'
	jz	VSTC_1

	mov	al,From_Machine		; Start with From_Machine
	cmp	Trans_Type,'D'
	jz	VSTC_1
	cmp	Trans_Type,'W'
	jz	VSTC_1

	mov	al,Keybkgnd_Src

VSTC_1:	cmp	Active_IOTYP, preview_IOTYP
	jnz	VST_1s
	mov	al, 1			; Set for record side
	jmp	VST_1t

VST_1s:	call	getxpt_FAR
VST_1t:	mov	[si].VSW_NextPgmSrc, al

; Byte 7 -- Next key Flags
	xor	al,al			; Preset KEY FlagS OFF
	cmp	Trans_Type,'K'		; Check for KEY
	jnz	VSTC_3			; Jump if not a KEY

	cmp	Key_Mode,1		; KEY IN?
	jz	VSTC_3			;  Start with key off

	mov	al,00010000b		; Set for PRIMARY KEYER

VSTC_3:	mov	[si].VSW_NextKeyFlags, al
	or	al,al			; Any key Flags?
	jz	VSTC_5

; Subrecord Byte 1, KEY FOREGROUND SOURCE
	mov	al,Keyfor_Src
	call	getxpt_FAR
	mov	[si].VSW_KeyFore, al

; Subrecord Byte 2, KEY SOURCE (PATTERN # IF A PATTERN LIMIT)
; SAME AS THE FOREGOUND SOURCE
	mov	[si].VSW_KeySrc, al

; Subrecord Byte 3, KEY MODIFIERS
	mov	al,0
	mov	[si].VSW_KeyMods, al

VSTC_5:	xor	ax,ax			; ZERO OFFSET FROM Preroll
	mov	word ptr [si].VSW_OfstTime, ax
	mov	byte ptr [si+2].VSW_OfstTime, al
	call	Terminate_Swbuf

	cmp	Active_IOTYP, preview_IOTYP
	jnz	VSTC_ret
	call	VST_Edit_PvwSplit
	call	VST_Edit_PvwOut

VSTC_ret:
	ret


;................................................................
; Send Preview Switcher Split Edit Command
VST_Edit_PvwSplit	proc	near
	; Exit if no split edit
	cmp	Trans_Type,'S'
	jnz	VSTEPRS

	mov	si,Vlan_Swbuf_PTR

	mov	al,Active_IOTYP
	mov	[si].VSW_IOTYP, al

	xor	bx,bx

; Byte 0 and 1 -- Transition duration in frames
	mov	[si].VSW_TransitionDur, bx

; Byte 2 -- Pattern # for wipes, or Memory address for Memory recall
	mov	[si].VSW_PatternNumber, bl

; Byte 3 -- Pattern Modifier
	mov	[si].VSW_PatternModifier, bl

; Byte 4 -- Set A/V mode flag for remainder of split
	mov	al, Mode_Flag
	call	Set_PreviewSw_Bits
	mov	[si].VSW_PatternReplicate, al

; Byte 5 -- Transition type / ME address
	mov	al,Effects_Address
	shl	al,1			; Move effects address
	shl	al,1			;  to upper nibble
	shl	al,1
	shl	al,1
	mov	[si].VSW_TransME, al

; Byte 6 -- Next program source

	; Set Rec for out point
	mov	al, 2			; Set for record side
	mov	[si].VSW_NextPgmSrc, al

; Byte 7 -- Next key Flags
	mov	[si].VSW_NextKeyFlags, bl

; Calculate preview switcher trigger time
	mov	bx,offset Preroll
	cmp	Vtr_Mult_Type,V_roll
	jnz	vsts1
	mov	bx,offset Timelineroll
vsts1:
	call	_Sttime_move
	push	bx			; save sttime
	mov	bx,offset Split_Delay
	call	_Entime_move
	mov	dx,bx			; bx -> sttime, dx -> entime
	pop	bx
	call	_mpbadd			; Add preroll to record duration

	call	_VVV_compensateSplit	; Compensate for split edits

	mov	ax,[bx]
	mov	word ptr [si].VSW_OfstTime, ax
	mov	al,2[bx]
	mov	byte ptr [si+2].VSW_OfstTime, al
	call	Terminate_Swbuf
VSTEPRS:ret
VST_Edit_PvwSplit	endp

;...........................





;................................................................
; Send Preview Switcher Out Command
VST_Edit_PvwOut	proc	near
	; Exit if open end edit
	mov	bx,offset R_Tc.tcDUR
	xor	ax,ax
	or	al,[bx]			; LSB, MSB
	or	ax,1[bx]		; MSB
	jz	VSTEPR

	mov	si,Vlan_Swbuf_PTR

	mov	al,Active_IOTYP
	mov	[si].VSW_IOTYP, al

	xor	bx,bx

; Byte 0 and 1 -- Transition duration in frames
	mov	[si].VSW_TransitionDur, bx

; Byte 2 -- Pattern # for wipes, or Memory address for Memory recall
	mov	[si].VSW_PatternNumber, bl

; Byte 3 -- Pattern Modifier
	mov	[si].VSW_PatternModifier, bl

; Byte 4 -- Pattern replication factor
	mov	[si].VSW_PatternReplicate, bl

; Byte 5 -- Transition type / ME address
	mov	al,Effects_Address
	shl	al,1			; Move effects address
	shl	al,1			;  to upper nibble
	shl	al,1
	shl	al,1
	mov	[si].VSW_TransME, al

; Byte 6 -- Next program source

	; Set Rec for out point
	mov	al, 1			; Set for record side
	mov	[si].VSW_NextPgmSrc, al

; Byte 7 -- Next key Flags
	mov	[si].VSW_NextKeyFlags, bl

; Calculate preview switcher trigger time
	mov	bx,offset Preroll
	cmp	Vtr_Mult_Type,V_roll
	jnz	vstp1
	mov	bx,offset Timelineroll
vstp1:
	call	_Sttime_move
	push	bx			; save sttime
	mov	bx,offset R_Tc.tcDUR
	call	_Entime_move
	mov	dx,bx			; bx -> sttime, dx -> entime
	pop	bx
	call	_mpbadd			; Add preroll to record duration

	call	_VVV_compensateOUT	; Compensate for preview advances

	mov	ax,[bx]
	mov	word ptr [si].VSW_OfstTime, ax
	mov	al,2[bx]
	mov	byte ptr [si+2].VSW_OfstTime, al
	call	Terminate_Swbuf
VSTEPR:	ret
VST_Edit_PvwOut	endp


; Terminate the switcher record buffer, increment to next
Terminate_Swbuf	proc	near
	add	si,VLANSW_LENGTH
	mov	Vlan_Swbuf_PTR,si
	add	Vlan_Swbuf_SIZ,VLANSW_LENGTH
	inc	Vlan_Swbuf_CNT
	mov	[si].VSW_TransitionDur,0ffffh
	ret
Terminate_Swbuf	endp

;-------------------------------------------------------------------
; Wipe Code Modifiers
;	0   -  99 Normal Wipe
;	100 - 199 Reverse Wipe
;	200 - 299 Soft Fwd wipe?
;	300 - 399 Soft Rev wipe?
;	400 - 499 border fwd wipe?
;	500 - 599 Border rev?
;	600 - 699 Sft Bdr Fwd wipe?
;	700 - 799 Sft Bdr Rev wipe?
;	800 - 899 
;	900 - 999 
_VLAN_wipes	proc	far
	mov	al,00000000b
	cmp	bx,100		; Just a normal wipe?
	jc	VWIPEx
	mov	al,00000001b
	sub	bx,100		; Reverse wipe?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000010b
	sub	bx,100		; Soft Fwd wipe?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000011b
	sub	bx,100		; Soft Rev wipe?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000100b
	sub	bx,100		; border fwd wipe?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000101b
	sub	bx,100		; Border rev?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000110b
	sub	bx,100		; Sft Bdr Fwd wipe?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000111b
	sub	bx,100		; Sft Bdr Rev wipe?
	cmp	bx,100
	jc	VWIPEx
	mov	al,00000000b
VWIPEx:	ret
_VLAN_wipes	endp


_EFXscreen	proc	far
	mov	Cursor,offset List_Scr
	mov	bx,offset ememopts_ovr
	call	_msg2screen
	ret
_EFXscreen	endp



_DispRampVtr	proc	far
	norm_VIDEO FALSE,FALSE
	call	_kbd_cln
	mov	al,Current_Source	; Display the source vtr
	call	_machine_disp
	call	_Space_Out
	ret
_DispRampVtr	endp

; Enter: BX -> msgseg message offset
;	 DX -> long value receiving the digits
;	 AL = # of digits to read
; Exit:	 AX:DX = number
_PromptForDecimal	proc	far
	push	si
	mov	si,dx
	push	ax
	call	_msgread
	mov	al,'['
	call	_ConOut
	mov	ax,[si]
	mov	dx,[si+2]
	call	 FAR PTR _DisplayAsciiDecimal
	mov	al,']'
	call	_ConOut
	call	_Space_Out
	pop	ax
	push	ax
	mov	Input_Flag, (INFL_ramp OR INFL_DECIMAL)
	call	dec_cimsg_FAR
	pop	ax
	jc	pdfcbad
	jz	pdfcold
	call	_dltoi
	clc
pdfcbad:pop	si
	ret

pdfcold:mov	ax,[si]
	mov	dx,[si+2]
	pop	si
	ret

_PromptForDecimal	endp



;================================================================
; MENU CARD
_RampSpeed_CARD	proc	far
	call	_DrawMenuBox
	mov	di,PointShootData.PQ_Cursor	; Screen position
	xor	cl,cl				; Clear number counter

	xor	si,si
	mov	dx,offset exitmenu_ovr
	call	INSTL_PQdisplay
	add	di,100h

	xor	si,si
	mov	dx,offset rampdialog_ovr
	call	INSTL_PQdisplay
	add	di,100h

	mov	ch,PointShootData.PQ_field
	sub	ch,3
	mov	bx,offset rampenabled_ovr
	mov	si,offset Ramp_Flags
	mov	ax,Enabled_MSBIT
	call	m20_dp

	mov	bx,di
	mov	Cursor,bx
	call	_dashit_cl
	mov	bx,offset rampstart_ovr
	call	_msgread
	norm_VIDEO FALSE,FALSE
	mov	ax,RampSpeedChange.SPEED_FROM
	mov	dx,RampSpeedChange.SPEED_FROM+2
	mov	bl,PointShootData.PQ_field
	mov	bh,0
	add	bx,di
	sub	bx,6
	mov	Cursor, bx
	call	 FAR PTR _DisplayAsciiDecimal

	add	di,100h
	mov	bx,di
	mov	Cursor,bx
	call	_dashit_cl
	mov	bx,offset rampend_ovr
	call	_msgread
	norm_VIDEO FALSE,FALSE
	mov	ax,RampSpeedChange.SPEED_TO
	mov	dx,RampSpeedChange.SPEED_TO+2
	mov	bl,PointShootData.PQ_field
	mov	bh,0
	add	bx,di
	sub	bx,6
	mov	Cursor, bx
	call	 FAR PTR _DisplayAsciiDecimal

	add	di,100h

	mov	si,offset RampSpeedChange.SPEED_TIME
	mov	dx,offset rampdur_ovr
	call	INSTL_PQdisplay

	mov	si,offset RampSpeedChange.SPEED_START
	mov	dx,offset ramptime_ovr
	call	INSTL_PQdisplay

	ret
_RampSpeed_CARD	endp


_DisplayAsciiDecimal	proc	far
	push	cx
	mov	bx,offset Ascii_Number
	call	_itoa100
	push	bx
	mov	cx,6
dadpdlp:cmp	byte ptr [bx],0
	jz	dadlpx
	dec	cx
	inc	bx
	jnz	dadpdlp
dadlpx:	jcxz	dadlpr
	mov	al,' '
	call	_ConOut
	dec	cx
	jmp	dadlpx
dadlpr:	pop	bx
	call	_comsg
	pop	cx
	ret
_DisplayAsciiDecimal	endp


; BX->TC, CL = FCM
_DispTcToShortString	proc	far
	mov	dx,offset Tcdispbuf
	call	_cnvt2tc_DS
dtslp:	mov	al,[bx]
	or	al,al
	jz	dtseos
	cmp	al,'0'
	jz	dtssn
	cmp	al,';'
	jz	dtssn
	cmp	al,':'
	jz	dtssn
	jmp	dtsxit

dtssn:	inc	bx
	jmp	dtslp

dtseos:	dec	bx
dtsxit:	call	_comsg
	ret
_DispTcToShortString	endp


; Draw box for edit speed fill and last tag information
_draw_EDITSPEEDS	proc	far
	mov	bx,offset List_Scr
	mov	dx,offset List_Scr + (MAX_MACHINES * 256) + 35
	dim_VIDEO FALSE,FALSE
	call	_DrawBox
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset List_Scr + 1
	mov	bx,offset Fillhdr_Msg
	call	_comsg
	ret
_draw_EDITSPEEDS	endp

; Draw box for speed change buffers
_draw_PMCBUFFERS	proc	far
	mov	bx,offset List_Scr + 36
	mov	dx,offset List_Scr + (8 * 256) + 80
	dim_VIDEO FALSE,FALSE
	call	_DrawBox
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset List_Scr + 37
	mov	bx,offset Speedhdr_Msg
	call	_comsg
	ret
_draw_PMCBUFFERS	endp


;................................................................
; Display the speed in %
_speed_percent	proc	far
	push	ax
	xor	ah,ah
	call	 FAR PTR _vpslmin

	MULTIPLY_BY 100, AX		; Multiply AX by 10 macro
	push	dx
	xor	dx,dx
	mov	cx,FPS
	div	cx
	pop	dx
	mov	bx,ax
	call	_DecOut_Pad
	mov	al,'%'
	call	_ConOut
	mov	bx,offset Ofspeed_Msg
	call	_comsg
	pop	ax
	ret
_speed_percent	endp

;................................................................
; Get the programmed Memory speed for the vtr in FRAMES/SECOND
_index2edspeed	proc	far
	cbw
	MULTIPLY_BY Vtrcb_length, AX
	mov	bx,offset Vtrcb.Vtrcb_PGM	; Adjust so that A-vtr=0
	add	bx,ax
	mov	al,[bx]
	ret
_index2edspeed	endp

;................................................................
; Convert from percentage of play speed to frames per second
; Enter AX = NUMBER FROM 0 - 999
; Exit: AX = frames/second
_motion_convert	proc	far
	push	cx
	push	dx
	mov	cx,ax
	mov	ax,FPS
	MULTIPLY_BY 10, AX		; Multiply AX by 10 macro
	xor	dx,dx
	mul	cx
	mov	cx,1000
	div	cx
	pop	dx
	pop	cx
	ret
_motion_convert	endp

;................................................................
; Convert from frames per second to percentage of play speed
; Enter AX = NUMBER FROM 0 - 999
; Exit: AX = % speed
_PercentPlaySpeed	proc	far
	push	cx
	push	dx
	MULTIPLY_BY 100, AX		; Multiply AX by 100 macro
	xor	dx,dx
	mov	cx,FPS
	div	cx
	pop	dx
	pop	cx
	ret
_PercentPlaySpeed	endp

;................................................................
; Check for active PMC.  Return NZ if any active
_check4pmc	proc	far
	push	ax
	push	cx
	push	bx
	mov	cx,MAX_SPEED_CHANGES
	mov	bx,offset Progmotion_Tbl
c4pmclp:cmp	byte ptr [bx],0ffh
	jnz	c4pmcx
	add	bx,SIZE VARSPEEDCHANGE
	loop	c4pmclp
	xor	ch,ch
c4pmcx:	pop	bx
	pop	cx
	pop	ax
	ret
_check4pmc	endp

;................................................................
_check4spd	proc	far
	push	ax
	push	cx
	push	bx
	mov	cx,MAX_MACHINES - 1
c4spdlp:mov	al,cl
	call	_index2edspeed
	cmp	al,FPS			; Check for play speed
	jnz	c4spdx
	loop	c4spdlp
	xor	ch,ch
c4spdx:	pop	bx
	pop	cx
	pop	ax
	ret
_check4spd	endp

;................................................................
; Check for negitive number
_vpslmin	proc	far
	mov	cl,PLUS_ASCII
	test	al,80h			; Negative number?
	jz	vngn1
	mov	cl,MINUS_ASCII
	push	ax
	jmp	vngn3

vngn1:	push	ax
	and	al,7fh
	cmp	al,FPS			; Check for full play speed
	jnz	vngn3
	call	_Space_Out
	jmps	vngn4
vngn3:	mov	al,cl
	call	_ConOut
vngn4:	pop	ax
	and	al,7fh			; Clear hi bit
	ret
_vpslmin	endp

;================================================================
; Sort GPI buffers in time order
_GPI_sort	proc	far
	mov	bx,offset Gpi0 		; Point to table
	mov	dx,offset Temp_Wrkspce	; Move it to temporary buffer
	mov	si,dx			; Get buffer address to SI
	mov	di,bx			; Get original buffer to DI
	mov	cx,MAX_GPI_REGISTERS * GPI_length
	push	cx
	call	_mmv16
	pop	cx
	mov	bx,di
GPI_srtclr:
	mov	byte ptr [bx],0
	inc	bx
	loop	GPI_srtclr


; Sort it:
; Scan speed table and reload the original buffer in sort order
; DO FOR NEGATIVE OFFSETS

gpisrt1:xor	ch,ch			; Indicate pass 0
gpisrt2:mov	bx,offset Tc_Format	; Find greater than 0
	or	ch,ch
	jz	gpisrt3
	mov	bx,offset Sort_Tcfmt	; Find less than 23:59:59:29
gpisrt3:mov	dx,offset Offset_Buffer
	call	_mmv3byt
	push	cx
	push	si
	mov	ah,MINUS_ASCII			; First pass for negative
	or	ch,ch
	jz	gpisrt5
	mov	ah,PLUS_ASCII			; Second pass for positive
gpisrt5:call	gp_srtr			; Make a pass
	or	bp,bp			; Done?
	jz	gpisrt_n

	mov	si,bp			; Get buffer address
	push	es			; Move bytes
	push	ds
	pop	es
	mov	cx,GPI_length
	rep movsb
	pop	es
	mov	byte ptr ds:[bp],0ffh ; Mark this as DONE.
	pop	si
	pop	cx
	jmps	gpisrt2

gpisrt_n:
	pop	si
	pop	cx
	or	ch,ch			; First pass for negative?
	jnz	gpisrt_p		; Exit if not
	dec	ch			; Indicate not first pass
	jmps	gpisrt2

gpisrt_x:
	pop	si
	pop	cx
gpisrt_p:
	ret

_GPI_sort	endp

;================================================================
; Make a pass at the registers
; SI points to first if buffers for this machine
; AH has + or -
; Exit: BP points to next highest time or 0 for nothing left
; If Negative number, find the greatest one
gp_srtr:push	cx
	mov	bp,0
	mov	cx,MAX_GPI_REGISTERS
gp_srtl:push	si			; Get SIGN

	test	byte ptr [si].gpiFLAGS,G_active_mask
	jz	gp_srt9

	lodsb				; Get VTR assignment byte
	cmp	al,0ffh			; Skip this buffer?
	jz	gp_srt9

	or	al,al
	jz	gp_srtp
	cmp	al,' '
	jnz	gp_srt1
gp_srtp:mov	al,PLUS_ASCII

gp_srt1:cmp	ah,al
	jnz	gp_srt9

	mov	bx,si			; BX points to value
	mov	dx,offset Offset_Buffer
	push	ax
	call	_cmp24b			; Is new <= old?
	pop	ax
	pushf
	cmp	ah,MINUS_ASCII			; Looking for greater?
	jnz	gp_srt2
	popf
	jae	gp_srt5
	jmps	gp_srt9

gp_srt2:popf
	jnc	gp_srt9

gp_srt5:push	ax
	call	_mmv3byt		;  Below or equal, copy it
	pop	ax

	pop	bp			; Save current address
	push	bp			;  as new buffer (from SI)

gp_srt9:pop	si
	add	si,GPI_length
	loop	gp_srtl
	pop	cx
	ret



;================================================================
; ENTER: AL has a relay number from 1-48
; Exit:  SI points to node control block
;	 AL = node offset from base Gpi_Node
;	 AH = relay number
;	 CL = AH = relay number
; 	 CH = actual node offset
_Relay_Index	proc	far
	mov	cl,al
	MULTIPLY_BY RTYPE_LENGTH, AX
	mov	si,ax
	add	si,offset Relaytype_Tbl
	mov	al,cl
	cmp	al,16			; Is it the first GPI box? (1-16)
	ja	rlyind2			; Jump and adjust node if above
	mov	ah,al			; Relay #
	xor	al,al			; No node offset
	jmps	rlyind3

rlyind2:mov	ah,0
	mov	cl,16
	div	cl			; AL = node offset from base
					; AH = remainder = relay#
rlyind3:mov	cl,ah			; Save relay # in CL
	mov	ch,al			; Get node offset from base
	add	ch,byte ptr Gpi_Node	; Index to real node number
	ret
_Relay_Index	endp

;================================================================
;	Check for active GPIs.  Return NZ if any active
;================================================================
_Check4GPIs	proc	far
	push	ax
	push	cx
	push	dx
	xor	dl,dl
	mov	cx,MAX_GPI_REGISTERS
c4g_2:	mov	al,dl			; Index to GPI
	cbw
	MULTIPLY_BY GPI_length, AX
	mov	bx,ax
	add	bx,offset Gpi0
	inc	dl
	test	byte ptr [bx].gpiFLAGS,G_active_mask ;gpi on?
	jnz	c4g_3
	loop	c4g_2
	xor	al,al
c4g_3:	pop	dx
	pop	cx
	pop	ax
	ret

_Check4GPIs	endp


;................................................................
_Draw_Relays	proc	far
	xor	dx,dx			; Use for relay number
	mov	di,0002h		; DI used for Cursor position
	mov	cx,2			; Do 2 columns
rlydlp:	push	cx
	mov	cx,24			; # to do
rlydlp1:mov	Cursor,di
	inc	dx
	mov	ax,dx
	push	cx
	push	dx
	call	rlyone			; Displays one relay's information
	pop	dx
	pop	cx
	add	di,100h
	loop	rlydlp1
	mov	cx,di			; Get Cursor
	mov	ch,0			; Back to first line
	add	cl,40			; Index over 41 columns
	mov	di,cx
	pop	cx
	loop	rlydlp
	ret
_Draw_Relays	endp

;----------------------------------------------------------------
; Display relay #AX
rlyone:	mov	dx,ax			; Save relay to DX
	MULTIPLY_BY RTYPE_LENGTH, AX	; Index to correct buffer
	mov	si,offset Relaytype_Tbl
	add	si,ax

	mov	Cursor,di
	mov	bx,dx			; Get relay # to BX
	norm_VIDEO FALSE,FALSE
	call	_DecOut_100_pad		; Print with leading 0s
	dim_VIDEO FALSE,FALSE
	call	_Space_Out
	call	_Space_Out

	test	byte ptr [si].Rly_ACTIVE,10000000b	; active relay?
	jnz	rlyone1			; Skip if active

	if	NOT DEVELOPMENT
	mov	bx,offset inactive_ovr	; Display "inactive" message
	jmp	rlyone6			; (returns thru _comsg)
	endif

rlyone1:mov	bx,si			; Get pointer to record

	mov	cx,8
rlycmg:	mov	al,[bx]
	inc	bx
	call	_ConOut
	loop	rlycmg

	call	_Space_Out
	call	_Space_Out
	mov	al,'P'			; Set for pulse
	mov	ah,[si].Rly_FLAGS
	test	ah,RTYPE_pulse		; Test for pulse type
	jnz	rlyone2			; Jump if pulse
	mov	al,'L'
rlyone2:call	_ConOut			; Display Pulse or Latch type
	jz	rlyone3			; Skip if not PULSE
	mov	al,ah			; Get Flags byte
	and	al,RTYPE_pwidth		; Mask out all but pulse timr
	mov	bl,al
	xor	bh,bh
	call	_DecOut_100_pad
	jmps	rlyone4

rlyone3:call	_Space_Out		; Two extra Spaces if LATCH
	call	_Space_Out
rlyone4:call	_Space_Out
	and	ah,(RTYPE_set+RTYPE_reset); Isolate set/reset bits
	mov	bx,offset tglmsg_ovr
	or	ah,ah			; If 0, its a toggle
	jz	rlyone6
	mov	bx,offset onmsg_ovr
	test	ah,RTYPE_set
	jnz	rlyone6
	mov	bx,offset offmsg_ovr
rlyone6:call	_msgread
	call	_Space_Out
	call	_Space_Out
	mov	al,'-'
	call	_ConOut
	mov	bx,si			; Get relay base
	add	bx,offset ZeroBase.Rly_OFFSET
	mov	dx,offset Tcdispbuf
	mov	cl,NDF_CHAR
	call	_cnvt2tc_DS
	call	_comsg
rlyonex:ret

;................................................................
; Display 3 vertical lines, dividing the screen into four tall quadrants
_Draw_Relay_Lines	proc	far
	mov	bx,39
	mov	al,179
	mov	cx,24
Drwrl2:	mov	Cursor,bx
	call	_ConOut
	add	bx,100h
	loop	Drwrl2
	ret
_Draw_Relay_Lines	endp


; vmdiag
;================================================================
; VTR summary
; Cursor Y = testbase_scrY + [Diag_Vtr_Number]
; Cursor X = testbase_scrX + (Diag_Test_Number * 6)
_VTR_Summary	proc	far
	norm_VIDEO FALSE,FALSE
	mov	di,offset Diagsum_Table
	mov	bx,offset testbase_scr	; Get base address of screen area
	mov	al,Diag_Test_Number	; Offset to correct column
	mov	ah,6
	mul	ah
	add	bl,al

	mov	cx,MAX_MACHINES

VTRsum2:push	cx
	mov	Cursor,bx
	push	bx

	mov	ax,ds:[di]
	cmp	ax,0ffffh
	jz	VTRsdx

; (100 * Diag_Error_Count) / Diag_Loop_Count = % errors
; AX = error Count
	mov	cx,100
	mov	bx,cx
	mul	cx
	mov	cx,Diag_Loop_Count
	or	cx,cx
	jz	VTRsdx

	div	cx
	sub	bx,ax

	cmp	bx,100
	jnc	TVTTC3o
	mov	al,' '
	call	_ConOut
	cmp	bx,10
	jnc	TVTTC3o
	mov	al,' '
	call	_ConOut
TVTTC3o:call	_DecOut
	mov	al,'%'
	call	_ConOut

VTRsdx:	inc	di
	inc	di
	pop	bx
	inc	bh
	pop	cx
	loop	VTRsum2
	ret
_VTR_Summary	endp

;================================================================
_Norm_Test	proc	far
	dim_VIDEO FALSE,FALSE
	jmps	shotest
_Norm_Test	endp

_Show_Test	proc	far
	blinkrev_VIDEO FALSE,FALSE
shotest:push	di
	push	dx
	push	cx
	push	es
	mov	dx,offset testbase_scr - 200h
	mov	al,Diag_Test_Number
	mov	ah,6
	mul	ah
	add	dl,al
	mov	Cursor,dx
	call	_sram_dx
	inc	di
	mov	cx,5
shotst:	mov	al,Video_Mode
	or	al,Color_BKG
	stosb
	inc	di
	loop	shotst
	pop	es
	pop	cx
	pop	dx
	pop	di
	ret
_Show_Test	endp

;................................................................
_Diag_Msgs	proc	far
	norm_VIDEO FALSE,FALSE
	push	bx
	mov	Cursor,offset testmsg_scr
	mov	bx,SpacePointer(18)
	call	_comsg
	mov	Cursor,offset testmsg_scr + 200h
	mov	bx, SpacePointer(18)
	call	_comsg
	mov	Cursor,offset testmsg_scr
	rev_VIDEO FALSE,FALSE
	pop	bx
	call	_comsg
	ret
_Diag_Msgs	endp

;................................................................
_Done_msgs	proc	far
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset testmsg_scr
	mov	bx, SpacePointer(18)
	call	_comsg
	mov	Cursor,offset testmsg_scr + 200h
	mov	bx, SpacePointer(18)
	call	_comsg
	mov	Cursor,offset testmsg_scr
	mov	bx,offset Testing_Msg
	call	_comsg
	mov	bx,offset Done_Msg
	call	_comsg
	ret
_Done_msgs	endp


BSEG	ends

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

