; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner
; VMCT.ASM
; RS232 interfacing for VLAN VTR control nodes
;
%nolist
include vm.equ

extrn Gpi_Flags:word, EditStatus_Area:word, calcedit_ovr:word
extrn VlanVideoPort:byte,VlanAudioPort:byte,VlanPreviewPort:byte
extrn Rev_Msg:word,Per_Msg:word,Pvw_Msg:word
extrn AX_Type:byte,Device_Present:byte,RT_Vtr:byte,SX_Type:byte,PX_Type:byte
extrn TL_Rin_Flag:byte,TL_Rout_Flag:byte,TL_Sync_Flag_IN:byte
extrn TL_Sync_Flag_OUT:byte,Active_IOTYP:byte,Assemble_Flag:byte
extrn Device_Present:byte,Edit_Status:byte,OkToAdjustTC_Flag:byte
extrn Editout_Flag:byte,Editsync:byte,Frame_Flag:byte,Joybuttons:byte
extrn Last_Stickx:byte,Last_Stickx:byte,Openend_Flag:byte,Preview_Mode:byte
extrn COM_PRINTER:byte,Pvwout_Flag:byte,Record_Flag:byte,Rtcf:byte
extrn Setcom_Chos:byte,Split_Mode:byte,Syncbump_VTR:byte,Tline_Entries:byte
extrn Vtr_Mult_Type:byte

extrn AX_Switcher_Types:WORD,AX_Descriptor:word,Preroll:word,TimeLineRoll:word
extrn COM_AUDIOSW:word,AX_Types:word,COM_SES1010:word,PMC_Offset:word
extrn Pal_TruthTable:word,RT_Offset:word,SX_Switcher_Types:WORD,PX_Switcher_Types:word
extrn SX_Descriptor:word,COM_VIDEOSW:word,SX_Types:word,TCworkbuf_1:word
extrn TCworkbuf_2:word,VLAN_Flags:word,Atrans_Offset:word,PX_Descriptor:word
extrn Badjoystick_Msg:word,Badmode_Fill:word,bump_msg:word,PX_Types:word
extrn BvbIN_Offset:word,BvbOUT_Offset:word,Bvb_Msg:word
extrn COM_EDLIO:word,COM_VLAN:word,COM_XTERM:word,Elaptm:word
extrn comport_ovr:word,Comport_Scr:word,comstats_ovr:word
extrn Current_Event:word,Cursor:word,dirbuff:word,Edit_Flags:word
extrn Editstatus_Area:word,Frm_Cnt:word,Gpi0:word,Gtrans_Offset:word
extrn Hotswitch_Msg:word,JoggerIRQ:word,Jogint_Adr:word,Jstick_Top_X:word
extrn Jstick_Top_Y:word,Keyboard_Scr:word,Network_Flags:word
extrn Network_Flags:word,Offset_Buffer:word,Openend_Msg:word
extrn Port:word,Preview_Msg:word,R_Tc:word,PV_descriptor:word
extrn Record_Msg:word,Replay_Msg:word,setports_ovr:word,SplitA_Offset:word
extrn SplitV_Offset:word,Sttime:word,Temp_Event:word
extrn Temp_Event:word,Timeline_Buffer:word,Tline_Pointer:word,Twenty4hrs:word
extrn VbvIN_Offset:word,VbvOUT_Offset:word,Vbv_Msg:word,VLAN_Flags:word
extrn VvvIN_Offset:word,VvvOUT_Offset:word,Vvv_Msg:word
extrn earlygpi_ovr:word,earlygpi2_ovr:word,earlygpie_ovr:word
extrn earlygpit_ovr:word,earlygpip_ovr:word,editstatus_msgs:word
extrn calctrig_ovr:word

extrn jogger:near,get_Vtrcb_CF:near
extrn joystick:near,note:near,rdchar:near,scan:near,still:near,switch:near

extrn _ConOut:FAR,_PercentPlaySpeed:FAR
extrn _Restore_Marktable:FAR,_baderror_bell:FAR,_beeper:FAR,_blinkita:FAR
extrn _Break_check:FAR,_clear_screen:FAR,_cmp24b:far,_comsg:FAR,_crlf:FAR
extrn _default_val:FAR,_delbrk:FAR,_delfrm:FAR,_delhnd:FAR,_dhb:far,_dhw:far
extrn _dircur_lerase:FAR,_Elaptm_move:far,_error_bell:FAR,_help_pos:FAR
extrn _kbd_cln:FAR,_kbd_clr:FAR,_line_erase:FAR, _Entime_move:far
extrn _machine_disp:far,_make_ucase:far,_mmv3byt:far,_mmv:far,_mpbadd:far
extrn _mpbdiv:far,_mpbsub:far,_msgread:far,_nblocks:FAR,_Sttime_move:far
extrn _tc_negate:far,_timadd:far,_timdif:far,Keyboard:far,rdchar_far:FAR
extrn vtr_opt_FAR:far,_tc_negate:far,_Jogger_INTERRUPT:far
extrn get_Vtrcb_OFFSET_FAR:far,_time_value:far,get_Vtrcb_CF_FAR:far
extrn _Relay_Index:far,_DecOut:far,_chrwait:far,gpi_FAR:far
extrn _A_DecOut:far
extrn Current_Machine:byte, Current_VTRS:word
extrn Trans_Type:byte, From_Machine:byte, Keybkgnd_Src:byte
extrn Machine_Change_Far:far,_get_dur:far

%list

;================================================================
BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg


Public  _ColorFrame_Compensate, vtrstn1, _CFcomp_2fld, vtrstn4, vtrstad
Public  vtrstnl, TimeCode_MOD_FOUR, _tline_save, tlstd1, _tlinegpi_save
Public  GPItls1, GPItls2, _tlg_save, _tlinepmc_save, PMCtls1, _tlp_save
Public  _tline_terminate, tline_term2, _clear_timeline, _sort_timeline, srttllp
Public  srttl1, tlsrt, tlsrt1, tlsrt1a, tlsrt2, tlsrtx, _PMC_compensate
Public  _GPIVLAN_compensate, _REVERSE_compensateIN, REVERSEc1, REVERSEcpls
Public  REVERSEcx, _FrameStoreCompensate, _VVV_compensateIN, _VVV_compensateOUT
Public  _VVV_compensateSplit, _ATRANS_compensateIN, _Compensate_Real_Time
Public  _vvvc1, VVVcpls, VVVcx, _clear_Edit_Flags, _openend_update, opndux
Public  _edit_update, eupd1, eupd2, mpvvv, mprec, mrpld, mrvbvd, mrbvbd
Public  _getedcmd, gecdfl, gecx, _SetInterrupt_JOGGER, shftirq, nosirq, siq
Public  sijx, _ResetInterrupt_JOGGER, rstirq, norirq, rijx, riq, _GetSXcb_Flags
Public  _GetSXcb_emems, _GetSXcb_xlatetbl, _GetSXcb_SMPTEadr
Public  _GetSXcb_commandtbl, _GetSXcb_masks, _GetSXcb_analogbits
Public  _GetSXcb_dskbits, _GetSXcb_AnalogIncrement, _GetSXcb_pbltbl, _getstyp
Public  getstya, _GetSXcb_Name, getsw5a, _all_switcher_set, asst1
Public  _switcher_set, swrini3, _joy_convert, jcit, jc1, jc2, jerr
Public  _check4joystick, jsok, jnf, c4j, c4jagn, c4jnm, c4jdone, c4jbad, c4jx
Public  _jstick, jstick1, anal1, anal2, jnext, jsxit, _jbutton, _setcom, setcom
Public  scomscr, setcomd, setcoma, setcome, setcomf, setcom_Inout, setcom_xterm
Public  setcom_vtr, setcom_switcher, setcom_audio, setcom_jogger
Public  setcom_printer, setjmpd, setcomx, setcom_Port, setcom_baud
Public  setcom_parity, setcom_stop, setcom_char, setcom_set, setcom_set1
Public  setcom_disp, comp_disp, comp_find, compda, comp_fbd, comp_fok, dots
Public  dotslp, com_allreset, carst, setcom_prtc, setcom_prt0, setcom_prtd
Public  setcom_prt1, _Get_prerollToBX, _CheckLegalPreroll, _TriggerBeforePrerollError
Public  _DisplayEditStatus, _SayWereSettingUp, _CheckLegalOffset
Public	Baud_Table

_SayWereSettingUp	proc	far
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Editstatus_Area
	call	_dircur_lerase
	mov	bx,offset calcedit_ovr
	call	_msgread
	test	Gpi_Flags, Enabled_MSBIT
	jz	swsuret
	mov	bx,offset calctrig_ovr
	call	_msgread
swsuret:ret
_SayWereSettingUp	endp

; Display the edit status
; Enter		AL = EDITSTSTIS_xxxxx
;		AH = Edit Status, all 7 bits
;		BX -> editstatus (unchanged)
_DisplayEditStatus	proc	far
	cmp	al,8
	ja	desx
	cmp	[bx],al			; Has it changed?
	jz	desx			; Exit if not changed
	push	ax
	push	bx
	mov	[bx],al			; Change it
	norm_VIDEO FALSE,TRUE
	mov	Cursor, offset Editstatus_Area
	mov	bx,SpacePointer(16)
	push	Cursor
	call	_comsg
	pop	Cursor
	cmp	al,7
	jnz	qq1q
	or	al,al
qq1q:
	; Check for editing
	cmp	al,0
	jnz	desnt
		rev_VIDEO FALSE,TRUE
		mov	bx,offset Rev_Msg
		test	ah, 10000000b
		jnz	desstat
		mov	bx,offset Per_Msg
		test	ah, 01000000b
		jnz	desstat
		mov	bx,offset Pvw_Msg
		test	ah, 00100000b
		jz	desnes
desstat:	call	_comsg

desnt:	mov	bl,al
	mov	bh,0
	MULTIPLY_BY 9, BX
	add	bx,offset editstatus_msgs
	call	_comsg
desnes:	pop	bx
	pop	ax
desx:	ret
_DisplayEditStatus	endp

; Display error for GPI that triggers earlier than the preroll point
; Enter SI->Timeline Record
_TriggerBeforePrerollError	proc	far
	call	_kbd_cln
	rev_VIDEO FALSE,FALSE
	mov	bx,offset earlygpi_ovr
	call	_msgread
	mov	al,cl
	call	_A_DecOut
	mov	bx,offset earlygpi2_ovr
	call	_msgread
	cmp	Vtr_Mult_Type,V_roll	; Just calculating?
	mov	bx,offset earlygpit_ovr
	jz	tbpe1
	mov	bx,offset earlygpie_ovr
tbpe1:	call	_msgread
	mov	bx,offset earlygpip_ovr
	call	_msgread
	call	_error_bell
	call	_chrwait
	norm_VIDEO FALSE,FALSE
	ret
_TriggerBeforePrerollError	endp

; Check to see if the earliest timeline trigger is
;  not less than the start of the preroll
; Return C=1 if a trigger greater than the preroll is found (ERROR)
;	CL = offending GPI#
_CheckLegalPreroll	proc	far
	clc
	ret

	xor	cl,cl
	call	far ptr _Get_prerollToBX
	mov	si,offset Gpi0
clplp:	test	[si].gpiFLAGS,G_active_mask	 ;gpi on?
	jz	clp1	
	cmp	[si].gpiSIGN, '-'
	jnz	clp1
	mov	dx,si
	add	dx,offset ZeroBase.gpiTRIGTIME
	call	_cmp24b			; Is Trigger <= Preroll
	jae	clp1
	stc
	ret
clp1:	add	si,GPI_length
	inc	cl
	cmp	cl,MAX_GPI_REGISTERS	; Increment Count
	jb	clplp
	clc
	ret

_CheckLegalPreroll	endp

;================================================================
; Check to see if timecode at [BX]..  is
;  not less than the start of the preroll
; Return timecode at [bx] == 0 if trigger greater than the preroll is found (ERROR)
_CheckLegalOffset	proc	far
	cmp	byte ptr [bx+2], 27h
	jc	clo1
	mov	word ptr [bx],0
	mov	byte ptr [bx+2],0
	stc
	ret
clo1:	clc
	ret

_CheckLegalOffset	endp



; Return proper preroll in BX
_Get_prerollToBX	proc	far
	mov	bx,offset Preroll	; Use Preroll
	cmp	Vtr_Mult_Type,V_roll	; Just calculating?
	jnz	gptbxx
	mov	bx,offset TimeLineRoll
gptbxx:	ret
_Get_prerollToBX	endp


_ColorFrame_Compensate	proc	far

	push	bx
	call	get_Vtrcb_CF_FAR
	pop	bx

	or	al,al
	JMP_Z	vtrstnl			; Jump if colorframe is off
	cmp	al,3
	jc	_CFcomp_2fld		; Jump if 4 FIELD COMPENSATION

; 8 field compensation
; I. Get frame position for RECORD IN
	push	bx			; Save the SOURCE TIME CODE
	mov	bx,offset R_Tc.tcIN	; Get the R-VTR IN POINT
	mov	dx,offset TCworkbuf_1	;  to a holding buffer
	push	dx
	call	_mmv3byt
	pop	bx			; BX --> holding buffer

	call	TimeCode_MOD_FOUR	; Get TC MOD 4

	mov	ch,[bx]			; Get remainder to CX
	pop	bx			; Restore source in point

; II. Get frame position of SOURCE IN
	push	bx			; Save the SOURCE TIME CODE

	mov	dx,offset TCworkbuf_1	;  to a holding buffer
	push	dx
	call	_mmv3byt
	pop	bx			; BX --> holding buffer

	call	TimeCode_MOD_FOUR		; Get TC MOD 4

	mov	cl,[bx]			; Get remainder to CX

; III. CH = R-VTR FRAME POS, CL = SOURCE VTR FRAME POS

	add	ch,ch			; *2
	add	ch,ch			; *4
	add	cl,ch			; Add with source frame pos offset
	xor	ch,ch
	mov	bx,offset Pal_TruthTable
	add	bx,cx
	mov	al,[bx]			; Get adjustment byte
	mov	byte ptr TCworkbuf_2,al	; Set 4 as a divisor
	mov	word ptr TCworkbuf_2 + 1,0
	mov	dx,offset TCworkbuf_2

	pop	bx			; Restore source in point
	push	dx			; Save TCworkbuf_2
	mov	dx,offset TCworkbuf_1	;  to a holding buffer
	push	dx			; Save holding buffer address
	call	_mmv3byt
	pop	bx			; BX --> TCworkbuf_1
	pop	dx			; DX --> TCworkbuf_2

	cmp	byte ptr TCworkbuf_2,80h
	jnc	vtrstn1

	call	_mpbadd
	ret

vtrstn1:neg	byte ptr TCworkbuf_2
	call	_mpbsub
	ret


_CFcomp_2fld:
	cmp	al,2			; Color frame inverted?
	jz	vtrstn4
	cmp	al,1			; Color frame even?
	jnz	vtrstnl			; Color frame off

	mov	al,byte ptr R_Tc.tcIN	; Get lsb of record time code
	mov	ah,[bx]			; Get lsb of source time code
	and	ax,0000000100000001b	; Mask out all but parity bits
	cmp	al,ah			; See if they match
	jz	vtrstnl			; ok if match (even even, odd odd)
	jmp	vtrstad

vtrstn4:mov	al,byte ptr R_Tc.tcIN	; Get lsb of record time code
	mov	ah,[bx]			; Get lsb of source time code
	and	ax,0000000100000001b	; Mask out all but parity bits
	cmp	al,ah			; See if they match
	jnz	vtrstnl			; ok if don't match
vtrstad:mov	dx,offset TCworkbuf_1
	call	_mmv3byt
	mov	bx,dx
	mov	dx,offset Frm_Cnt
	call	_mpbadd
vtrstnl:ret

_ColorFrame_Compensate	endp

;================================================================
; ENTER: BX --> TIME CODE POINTER
; Exit: BX --> MOD 4 result (remainder of divide by 4)
TimeCode_MOD_FOUR:
	mov	word ptr TCworkbuf_2,4	; Set 4 as a divisor
	mov	byte ptr TCworkbuf_2 + 2,0
	mov	dx,offset TCworkbuf_2
	call	_mpbdiv			; Divide by 4
	mov	bx,ax			; Address of remainder returns in AX
	ret


;================================================================
; Save to time line
; ENTER: AX = TLINE_xxxx type of tline
;	 BX = time code offset
;  (if AX = TFlag_INsplit or OUTsplit, then CL = first half mode Flag)
; TYPE  Sign <--time--> GPIflg GPIcmd
; xx xx  xx  xx  xx  xx  xx     xx     xx  xx  xx  xx  xx xx xx xx

_tline_save	proc	far
	push	ax
	push	di
	push	si
	push	es

	call	_CheckLegalOffset

	push	ds
	pop	es
	mov	di,Tline_Pointer	; Get current pointer in TLINE
	mov	dx,di
; XX XX xx xx xx xx xx xx xx xx xx xx xx xx xx xx
	stosw				; Save type
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; xx xx XX xx xx xx xx xx xx xx xx xx xx xx xx xx
	inc	di			; Increment over SIGN
	mov	si,bx
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; xx xx xx XX XX XX xx xx xx xx xx xx xx xx xx xx
	movsw				; Save Trigger Time
	movsb

	mov	di,dx
	add	di,offset ZeroBase.TLR_exectime ; Execution Time

	push	bx
	push	dx

	mov	dx,bx			; DX -> Trigger time
	call	_Get_prerollToBX	; BX -> Preroll
	call	_cmp24b
	; If Preroll <= trigger, sign = +, timeoffset = trigger - Preroll
	jbe	tlstd1

	; If Preroll > trigger, sign = -, timeoffset = Preroll - trigger

	push	dx
	call	_Entime_move		; Entime = preroll
	pop	bx
	call	_Sttime_move		; Sttime = trigger time
	call	_timdif
	mov	al,MINUS_ASCII
	jmps	tlstd2

tlstd1:	push	dx
	call	_Sttime_move		; Sttime = trigger time
	pop	bx
	call	_Entime_move		; Endtime = preroll
	call	_timdif
	mov	al,PLUS_ASCII

tlstd2:	stosb
	pop	dx
	mov	si,bx
	movsb				; Move SIGN, TC
	movsw
	pop	bx
	jmp	tline_term2
_tline_save	endp

;================================================================
; Save to time line
; ENTER:; BX points to GPI structure
;	  CL has GPI#
; GPI structure
; Byte 1	= Sign
; Byte 2, 3 & 4 = trigger time offset from record in
; Word 5	= Type byte 'V' or 'G'
; Word 7, 8	= Command
;
_tlinegpi_save	proc	far
	push	cx			; Save GPI# (CL)
	push	bx			; Save pointer to GPI
	push	si
	push	cx

	mov	si,bx			; Save GPI pointer to SI, too

	mov	ch,[bx]			; Get SIGN
	inc	bx			; Point to trigger offset time
	mov	dx,offset Offset_Buffer	; Move it to a buffer
	call	_mmv3byt
	mov	bx,dx			; BX = offset buffer

	cmp	ch,MINUS_ASCII			; Trigger early?
	jnz	GPItls1

	call	_tc_negate
GPItls1:call	_Sttime_move
	call	_Get_prerollToBX
	call	_Elaptm_move
	mov	cl,Rtcf
	call	_timadd

	cmp	byte ptr [si].gpiCMD, 0	; Is this GPI#0?
	jnz	GPItls2

		; Add in the offset for Gpi0, the coincidence trigger
		mov	bx,offset Gtrans_Offset	; Subtract trigger advance time
		call	_Sttime_move
		call	_timdif
		jmp	GPItlsx

; Add in the offset for GPI programmable Relays, 1-x
;;;; 1-31-1995 
GPItls2:test	byte ptr [si].gpiFLAGS,G_swtrig_mask	; Video type ?
	jnz	GPItls3
	jmp	GPItlsx

; Add in the offset for VIDEO GPI command
GPItls3:
	call	FAR PTR _ATRANS_compensateIN
;;	mov	bx,offset Atrans_Offset	; Subtract trigger advance time
;;	call	_Sttime_move
;;	call	_timdif

GPItlsx:pop	cx
	call	FAR PTR _tlg_save	; CL=GPI#, BX points to RECORD TC trigger time
	pop	si
	pop	bx
	pop	cx
	ret
_tlinegpi_save	endp

; Save the remainder of the GPI information to the timeline record
; BX -> timecode
_tlg_save	proc	far
	push	ax
	push	di
	push	si
	push	es
	push	ds
	pop	es

	call	_CheckLegalOffset

	mov	di,Tline_Pointer		; Get current pointer in TLINE
	mov	dx,di
	cld
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; XX XX xx xx xx xx xx xx xx xx xx xx xx xx xx xx
	mov	[di].TLR_type,TFlag_GPI		; Store TIMELINE TYPE type
	or	byte ptr [di].TLR_type,cl	; Factor in the GPI#
	inc	di
	inc	di

; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; xx xx XX xx xx xx xx xx xx xx xx xx xx xx xx xx
	mov	ch,[si].gpiSIGN
	mov	[di],ch			; Save sign
	inc	di

	xchg	si,bx			; SI->tc, bx->Gpi
;	inc	si
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; xx xx xx XX XX XX xx xx xx xx xx xx xx xx xx xx
	movsb				; Move calculated record trigger time
	movsw
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; xx xx xx xx xx xx XX XX XX XX xx xx xx xx xx xx
	mov	di,dx			; Get beginning of tline buffer
	mov	al,byte ptr [bx].gpiFLAGS
	mov	[di].TLR_gpiflags,al
	mov	ax,[bx].gpiCMD
	mov	[di].TLR_gpicmd,ax
	jmp	_tline_terminate
_tlg_save	endp

;================================================================
; Save to time line
; ENTER: BX Points to speed change buffer
; PMC structure:
; Byte 1	= VTR A,B,C or D
; Byte 2	= Speed in FPS (hi bit set if reverse)
; Byte 3	= Sign of trigger time
; Byte 4, 5 & 6 = trigger time offset from record in
_tlinepmc_save	proc	far
	push	ax
	push	bx			; Save pointer to PMC buffer

	inc	bx			; Increment to
	inc	bx			;  point to the SIGN
	mov	ch,[bx]			; Get SIGN
	inc	bx			; Point to trigger offset time
	mov	dx,offset Offset_Buffer	; Move it to a buffer
	call	_mmv3byt
	mov	bx,dx			; BX = offset buffer
	cmp	ch,MINUS_ASCII			; Trigger early?
	jnz	PMCtls1
	call	_tc_negate
PMCtls1:call	_Sttime_move
	call	_Get_prerollToBX
	call	_Elaptm_move

; Added FCM from Rtcf for for TIMADD routine
	push	cx
	mov	cl,Rtcf		; <---
	call	_timadd
	pop	cx

	pop	dx			; DX points to PMC buffer
	push	dx
	call	FAR PTR _tlp_save		; BX points to RECORD TC trigger time
	pop	bx
	pop	ax
	ret
_tlinepmc_save	endp

;----------------------------------------------------------------
; BX points to adjusted time code
; DX points to start of PMC buffer
_tlp_save	proc	far
	push	ax
	push	di
	push	si
	push	es
	push	ds
	pop	es

	call	_CheckLegalOffset

	mov	si,dx			; PMC buffer pointer to SI
	mov	di,Tline_Pointer	; Get current pointer in TLINE
	mov	dx,di
	cld
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; XX XX xx xx xx xx xx xx xx xx xx xx xx xx xx xx
;;	mov	ax,TFlag_PMC
;;	mov	[di].TLR_type,ax
	mov	[di].TLR_type,TFlag_PMC
; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; uu uu xx xx xx xx xx XX XX xx xx xx xx xx xx xx
	lodsb				; Get VTR
	mov	[di].TLR_vtr,al
	lodsb				; Get speed
	mov	[di].TLR_speed,al

	push	si			; Save pointer to SIGN,TC
	lodsb				; Get SIGN

; 0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
; uu uu XX XX XX XX xx uu uu xx xx xx xx xx xx xx
	inc	di			; Point to
	inc	di
	stosb

	mov	si,bx			; Get pointer to adjusted TC
	movsb				;  and move it
	movsw
	pop	bx			; Restore original offset time
	mov	ax,TFlag_PMC
_tlp_save	endp

;----------------------------------------------------------------
; ENTER: BX points to SIGN,TC
;
; 1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16
; xx xx xx xx xx xx xx xx xx xx xx xx XX XX XX XX
_tline_terminate	proc	far
	mov	di,dx
	add	di,offset ZeroBase.TLR_exectime ; Execution Time
	mov	si,bx
	movsw				; Move SIGN, TC
	movsw
tline_term2:
	add	dx,TLINE_size
	mov	Tline_Pointer,dx	; Update pointer
	inc	Tline_Entries		; Increment Count
	pop	es
	pop	si
	pop	di
	pop	ax
	ret
_tline_terminate	endp

;================================================================
; Clear out the time line
; AX used
_clear_timeline	proc	far
	push	di
	push	es
	push	ds
	pop	es
	mov	cx,(MAX_TIMELINES * TLINE_size)/2
	mov	di,offset Timeline_Buffer
	mov	Tline_Pointer,di
	xor	ax,ax
	rep	stosw
	mov	TL_Sync_Flag_IN,al
	mov	TL_Sync_Flag_OUT,al
	mov	TL_Rin_Flag,al
	mov	TL_Rout_Flag,al
	pop	es
	pop	di
	ret
_clear_timeline	endp

;================================================================
; Sort the time line for time code
;	
_sort_timeline	proc	far
	push	es
	push	ds
	pop	es

	mov	si,offset Timeline_Buffer ; Point to table
	mov	di,offset dirbuff	; Move it to temporary buffer
	push	si
	push	di
	mov	cx,(MAX_TIMELINES * TLINE_size)/2
	cld
	rep	movsw			; Move entire buffer

	call	_clear_timeline		; Clear original buffer

	mov	cl,Tline_Entries	; # to do
	xor	ch,ch
	pop	si			; Pop in reverse
	pop	di			;  order
	mov	ax,cx
	MULTIPLY_BY TLINE_size, AX
	sub	ax,TLINE_size		; Less one buffer
	add	si,ax			; Starting at TAIL

srttllp:push	cx			; Save # of entries
	push	si			; Save buffer pointer
	call	tlsrt			; Make a pass to sort one
	or	bp,bp			; Any found?
	jz	srttl1
	mov	si,bp
	mov	cx,TLINE_size
	rep	movsb
	mov	ds:word ptr [bp],TFlag_sorted ; Mark as used
srttl1:	pop	si
	pop	cx
	loop	srttllp
	mov	Tline_Pointer,offset Timeline_Buffer
	pop	es
	ret
_sort_timeline	endp

; Sort it:
tlsrt	proc	near
	xor	bp,bp
	mov	bx,0ffffh
	mov	Offset_Buffer,bx
	mov	byte ptr Offset_Buffer + 2,bl
tlsrt1:	mov	bx,si			; BX points to descriptor
	cmp	si,offset dirbuff
	jc	tlsrtx
	mov	ax,[bx]
	or	ax,ax			; End of list?
	jz	tlsrtx
	cmp	ax,TFlag_sorted		; Already used?
	jz	tlsrt2

	add	bx,offset ZeroBase.TLR_time ; Execution Time
;...
	mov	dx,[bx]			; LSB time code from time line
	mov	al,2[bx]		; MSB time code from time line

	mov	bx,offset Offset_Buffer

	cmp	al,2[bx]
	ja	tlsrt2
	jb	tlsrt1a
	cmp	dx,[bx]
	ja	tlsrt2			; Trig Time <= offset buffer?
					; If not, jump to next buffer
tlsrt1a:mov	[bx],dx
	mov	[bx+2],al		; Put new tc to Offset_Buffer
	mov	bp,si			; Save address to BP
tlsrt2:	sub	si,TLINE_size
	jmp	tlsrt1

tlsrtx:	ret
tlsrt	endp


;================================================================
; PMC COMPENSATION
; ENTER: DS:BX point to 24bit TC val
; Exit:  DS:BX points to new adjusted value
; DX saved and restored
;
_PMC_compensate	proc	far
	push	dx
	push	si
	mov	si,offset PMC_Offset
	jmp	_vvvc1
_PMC_compensate	endp

_GPIVLAN_compensate	proc	far
	push	dx
	push	si
	mov	si,offset Gtrans_Offset
	jmp	_vvvc1
_GPIVLAN_compensate	endp

_REVERSE_compensateIN	proc	far
	push	dx
	push	si
	mov	si,offset VvvIN_Offset
	cmp	Vtr_Mult_Type,V_pvw	; VVV Preview?
	jz	REVERSEc1
	mov	si,offset VbvIN_Offset
	cmp	Vtr_Mult_Type,V_vbv	; VVV Preview?
	jz	REVERSEc1
	mov	si,offset BvbIN_Offset
	cmp	Vtr_Mult_Type,V_bvb	; VVV Preview?
	jz	REVERSEc1
	jmp	REVERSEcx

REVERSEc1:
	call	_Sttime_move		; Move TC val to Sttime
	jz	REVERSEcx		; Bailout if null TC
	mov	dx,si			; DX points to offset value
	cmp	byte ptr [si + 3],MINUS_ASCII	; Check for + or -
	jz	REVERSEcpls
	call	_mpbsub			; Subtract if negative
	pop	si
	pop	dx
	ret
REVERSEcpls:
	call	_mpbadd			; Add if positive offset
REVERSEcx:
	pop	si
	pop	dx
	ret
_REVERSE_compensateIN	endp

;================================================================
; Add the constant offset in Vtrcb to the point at DX:BX
_FrameStoreCompensate	proc	far
	push	ax
	call	_Sttime_move		; Move TC val to Sttime
	jz	fscompr
	push	bx
	call	get_Vtrcb_OFFSET_FAR
	pop	bx
	add	byte ptr [bx],al
	adc	word ptr [bx + 1], 0
fscompr:pop	ax
	ret
_FrameStoreCompensate	endp


;================================================================
; If VVV Preview, add in the VVV_adjustments.
; ENTER: DS:BX point to 24bit TC val
; Exit: If VVV preview, and TC val <> null,
;	DS:BX points to new adjusted value
; DX saved and restored
_VVV_compensateIN	proc	far
	push	dx
	push	si
	mov	si,offset VvvIN_Offset
	cmp	Vtr_Mult_Type,V_pvw	; VVV Preview?
	jz	_vvvc1
	mov	si,offset VbvIN_Offset
	cmp	Vtr_Mult_Type,V_vbv	; VVV Preview?
	jz	_vvvc1
	mov	si,offset BvbIN_Offset
	cmp	Vtr_Mult_Type,V_bvb	; VVV Preview?
	jz	_vvvc1
	jmp	VVVcx
_VVV_compensateIN	endp

_VVV_compensateOUT	proc	far
	push	dx
	push	si
	mov	si,offset VvvOUT_Offset
	cmp	Vtr_Mult_Type,V_pvw	; VVV Preview?
	jz	_vvvc1
	mov	si,offset VbvOUT_Offset
	cmp	Vtr_Mult_Type,V_vbv	; VVV Preview?
	jz	_vvvc1
	mov	si,offset BvbOUT_Offset
	cmp	Vtr_Mult_Type,V_bvb	; VVV Preview?
	jz	_vvvc1
	jmp	VVVcx
_VVV_compensateOUT	endp


_VVV_compensateSplit	proc	far
	push	dx
	push	si
	cmp	Vtr_Mult_Type,V_pvw	; VVV Preview?
	jnz	VVVcx
	mov	al,Split_Mode		; Get split mask
	and	al,video_Emode		; If no bits in common, its VIDEO
	mov	si,offset SplitV_Offset
	jz	_vvvc1
	mov	si,offset SplitA_Offset
	jmp	_vvvc1
_VVV_compensateSplit	endp


;Added for ATRANS
_ATRANS_compensateIN	proc	far
	push	dx
	push	si
	mov	si,offset Atrans_Offset
	cmp	OkToAdjustTC_Flag, TRUE
	jz	_vvvc1
	jmp	VVVcx
;;	jmp	_vvvc1

_ATRANS_compensateIN	endp

; Used by HOT KEY routines to add in the offset for real time switches
_Compensate_Real_Time	proc	far
	push	dx
	push	si
	mov	si,offset RT_Offset
_Compensate_Real_Time	endp

_vvvc1	proc	far
	call	_Sttime_move		; Move TC val to Sttime
	jz	VVVcx			; Bailout if null TC
	mov	dx,si			; DX points to offset value
	cmp	byte ptr [si + 3],MINUS_ASCII	; Check for + or -
	jnz	VVVcpls
	call	_mpbsub			; Subtract if negative
	pop	si
	pop	dx
	ret
VVVcpls:call	_mpbadd			; Add if positive offset
VVVcx:	pop	si
	pop	dx
	ret
_vvvc1	endp

; 8-27-1994 
public _Delay_Vtr_Function
_Delay_Vtr_Function	proc	far
	cmp	Current_Machine,0	; Skip processing for r-vtr
	jz	svtcutr

	cmp	Trans_Type,'C'
	jz	svtcutr
	cmp	Trans_Type,'S'
	jz	svtcutr

	push	cx
	push	Current_VTRS

	call	_Sttime_move		; Copy time code into adder buffer1
	mov	al,From_Machine
	cmp	Trans_Type,'K'
	jnz	svte1
	mov	al,Keybkgnd_Src
svte1:	cmp	al,Current_Machine
	jz	svtcut

	call	Machine_Change_Far
	call	_get_dur
	call	_Elaptm_move
	call	_timadd
svtcut:
;...
	pop	ax
	push	bx
	mov	al,ah
	call	Machine_Change_Far
	pop	bx
	pop	cx
svtcutr:ret

_Delay_Vtr_Function	endp

_clear_Edit_Flags	proc	far
	xor	al,al
	mov	Edit_Status,al		; Reset edit status
	mov	Record_Flag,al
	mov	Editout_Flag,al
	mov	Pvwout_Flag,al
	mov	TL_Sync_Flag_IN,al
	mov	TL_Sync_Flag_OUT,al
	mov	TL_Rin_Flag,al
	mov	TL_Rout_Flag,al
	; Default preview mode to VA1234
	mov	Preview_Mode,audall_Emode OR video_Emode
	ret
_clear_Edit_Flags	endp

_openend_update	proc	far
	cmp	Openend_Flag,0		; Check for open end edit
	jz	opndux
	cmp	Vtr_Mult_Type,V_rev
	jz	opndux
	mov	bx,offset Keyboard_Scr	; Display " OPENEND "
	call	_dircur_lerase
	rev_VIDEO FALSE,FALSE
	mov	bx,offset Openend_Msg
	call	_comsg
opndux:	ret
_openend_update	endp

; Update screen at msg area for type of edit
_edit_update	proc	far
	cmp	Vtr_Mult_Type,V_rec
	jz	eupd1

	cmp	Vtr_Mult_Type,V_roll
	jz	eupd2

	mov	Cursor,1845h
	norm_VIDEO FALSE,FALSE
	mov	bx,offset bump_msg
	call	_msgread
	rev_VIDEO FALSE,FALSE
	mov	al,Syncbump_VTR
	call	_machine_disp
	jmp	eupd2

; Update HOT SWITCH information
eupd1:	test	Edit_Flags,realtime_EDBIT ; Allowed?
	jz	eupd2
	cmp	Assemble_Flag,0ffh
	jz	eupd2

	rev_VIDEO FALSE,FALSE
	mov	al,RT_Vtr
	mov	Cursor,1845h
	call	_machine_disp
	mov	Cursor,offset Editstatus_Area
	mov	bx,offset Hotswitch_Msg
	call	_comsg
eupdret:ret

eupd2:	mov	Cursor,offset Editstatus_Area
	mov	al,Vtr_Mult_Type
	cmp	al,V_rec			; 2?
	jz	mprec
	cmp	al,V_pvw			; 1?
	jz	mpvvv
	cmp	al,V_roll
	jz	mpnul
	cmp	al,V_rev			; 3?
	jz	mrpld
	cmp	al,V_vbv			; 4?
	jz	mrvbvd
	cmp	al,V_bvb			; 5?
	jz	mrbvbd
	mov	bx,offset Badmode_Fill
	jmp short euxit

mpnul:	mov	bx,offset Preview_Msg
	jmp short euxit
mpvvv:	mov	bx,offset Preview_Msg
	call	_comsg
	mov	bx,offset Vvv_Msg
	jmp short euxit
mprec:	rev_VIDEO FALSE,FALSE
	mov	bx,offset Record_Msg
	jmp short euxit
mrpld:	mov	bx,offset Replay_Msg
	jmp short euxit
mrvbvd:	mov	bx,offset Preview_Msg
	call	_comsg
	mov	bx,offset Vbv_Msg
	jmp short euxit
mrbvbd:	mov	bx,offset Preview_Msg
	call	_comsg
	mov	bx,offset Bvb_Msg
euxit:	call	_comsg
	ret

_edit_update	endp

;================================================================
; Return the appropriate VLAN command for edits
_getedcmd	proc	far
	mov	cl,Vtr_Mult_Type
gecdfl:	cmp	cl,V_pvw
	mov	ax,offset M_rehearse
	jz	gecx
	cmp	cl,V_rec
	mov	ax,offset M_perform
	jz	gecx
	cmp	cl,V_rev
	mov	ax,offset M_review
	jz	gecx
	mov	cl,V_pvw		; Default to rehearse
	jmp	gecdfl
gecx:	ret
_getedcmd	endp



;****************************************************************

;----------------------------------------------------------------
; Set interrupt JOGGER
_SetInterrupt_JOGGER	proc	far
	mov	ax,Jogint_Adr		; Test for presense of interrupt
	or	ax,Jogint_Adr + 2	; Test for presense of interrupt
	jnz	sijx
	mov	dx,JoggerIRQ	; Get IRQ Interrupt table address
	or	dx,dx
	jz	sijx

	mov	al,8		; Assume lower 8 interupts
	or	dl,dl		; Is the interupt line > 8?
	jnz	shftirq
	mov	al,70h		; Use upper interupts	
	mov	dl,dh

shftirq:shr	dl,1
	jc	nosirq
	inc	al
	jmp	shftirq
nosirq:	push	es
	push	ds

	push	ax
	mov	ah,35h		; Get old critical error address
	int	DOS		;  from DOS to ES:BX
	pop	ax
	mov	Jogint_Adr,bx
	mov	Jogint_Adr + 2,es

	mov	dx,seg _Jogger_INTERRUPT
	mov	ds,dx
	mov	dx,offset _Jogger_INTERRUPT
	mov	ah,25h
	int	DOS
	pop	ds		; Restore saved regs
	pop	es

	mov	ax,JoggerIRQ	; Get IRQ Interrupt table address
	mov	dx,21h		; Assume first controller
	or	al,al		; Lower 8 interupts?
	jnz	siq		; Jump if lower 8 irq
	mov	al,ah		; Get the higher mask
	mov	dx,0A1h		; Use the second interrupt controller
siq:	mov	ah,al		; Get mask to AH
	not	ah		; Invert bits
	in	al,dx		; Get current mask
	and	al,ah		; Enable the interupt
	out	dx,al		; Send it back out
sijx:	ret
_SetInterrupt_JOGGER	endp

; Reset jogger interrupt
_ResetInterrupt_JOGGER	proc	far
	mov	ax,Jogint_Adr		; Test for presense of interrupt
	or	ax,Jogint_Adr + 2	; Test for presense of interrupt
	jz	rijx

	mov	dx,JoggerIRQ	; Get IRQ Interrupt table address
	or	dx,dx
	jz	rijx

	mov	al,8		; Assume lower 8 interupts
	or	dl,dl		; Is the interupt line > 8?
	jnz	rstirq
	mov	al,70h		; Use upper interupts	
	mov	dl,dh

rstirq:	shr	dl,1
	jc	norirq
	inc	al
	jmp	rstirq

norirq:	push	ds
	mov	dx,Jogint_Adr
	mov	ds,Jogint_Adr + 2
	mov	ah,25h			; function to change vector
	int	DOS
	pop	ds
rijx:	mov	Jogint_Adr,0		; Clear interrupt address
	mov	Jogint_Adr + 2,0	; Clear interrupt address

	mov	ax,JoggerIRQ	; Get IRQ Interrupt table address
	mov	dx,21h		; Assume first controller
	or	al,al		; Lower 8 interupts?
	jnz	riq		; Jump if lower 8 irq
	mov	al,ah		; Get the higher mask
	mov	dx,0A1h		; Use the second interrupt controller
riq:	mov	ah,al		; Get mask to AH
	in	al,dx		; Get current mask
	or	al,ah		; Disable the interupt
	out	dx,al		; Send it back out
	ret
_ResetInterrupt_JOGGER	endp


;================================================================
;		Get VIDEO switcher descriptor words
;================================================================
_GetSXcb_Flags	proc	far
	mov	bx,offset ZeroBase.SXcb_Flags	; Get switcher descriptor 1
	jmps	_getstyp
_GetSXcb_Flags	endp
_GetSXcb_emems	proc	far
	mov	bx,offset ZeroBase.SXcb_emems	; Get switcher descriptor 2
	jmps	_getstyp
_GetSXcb_emems	endp
_GetSXcb_xlatetbl	proc	far
	mov	bx,offset ZeroBase.SXcb_xlatetbl	; Get wipe translation table address
	jmps	_getstyp
_GetSXcb_xlatetbl	endp
;;_GetSXcb_SMPTEadr	proc	far
;;	mov	bx,offset ZeroBase.SXcb_smpteadr	; Get switcher address
;;	jmps	_getstyp
;;_GetSXcb_SMPTEadr	endp
_GetSXcb_commandtbl	proc	far
	mov	bx,offset ZeroBase.SXcb_commandtbl; Get command translateion table address
	jmps	_getstyp
_GetSXcb_commandtbl	endp
_GetSXcb_masks	proc	far
	mov	bx,offset ZeroBase.SXcb_masks	; Get read/write masks
	jmps	_getstyp
_GetSXcb_masks	endp
_GetSXcb_analogbits	proc	far
	mov	bx,offset ZeroBase.SXcb_analogbits; Analog availabilities. See SXana_...
	jmps	_getstyp
_GetSXcb_analogbits	endp
_GetSXcb_dskbits	proc	far
	mov	bx,offset ZeroBase.SXcb_dskbits	; DSK availabilities. See SXana_...
	jmps	_getstyp
_GetSXcb_dskbits	endp

_GetSXcb_AnalogIncrement	proc	far
	mov	bx,offset ZeroBase.SXcb_AnalogIncrement
	jmps	_getstyp
_GetSXcb_AnalogIncrement endp	

_GetSXcb_pbltbl	proc	far
	mov	bx,offset ZeroBase.SXcb_pbltbl
_GetSXcb_pbltbl	endp

_getstyp	proc	far
	push	dx
	mov	dx,offset AX_Descriptor
	test	byte ptr Active_IOTYP,audio_IOTYP
	jnz	getstya

	mov	dx,offset PX_Descriptor
	test	byte ptr Active_IOTYP,preview_IOTYP
	jnz	getstya

	mov	dx,offset SX_Descriptor
getstya:add	bx,dx
	mov	bx,[bx]		; Get switcher inf. to BX
	pop	dx
	ret
_getstyp	endp


_GetSXcb_SMPTEadr	proc	far
	call	FAR PTR _GetSXcb_Flags	; Get switcher Flags
	test	bx,SWbit_VLAN		; Check for VLAN switcher
	jz	gsxcbs2

	mov	bh,0

	mov	bl,VlanVideoPort
	test	byte ptr Active_IOTYP,video_IOTYP
	jnz	gsxcbs1

	mov	bl,VlanAudioPort
	test	byte ptr Active_IOTYP,audio_IOTYP
	jnz	gsxcbs1

	;; must be preview switcher
	mov	bl,VlanPreviewPort

gsxcbs1:ret

gsxcbs2:mov	bx,offset ZeroBase.SXcb_smpteadr	; Get switcher address
	jmps	_getstyp
_GetSXcb_SMPTEadr	endp


_GetSXcb_Name	proc	far
	mov	bx,offset SX_Descriptor
	add	bx,offset ZeroBase.SXcb_name
	test	byte ptr Active_IOTYP,video_IOTYP
	jnz	getsw5a

	mov	bx,offset PX_Descriptor
	add	bx,offset ZeroBase.SXcb_name
	test	byte ptr Active_IOTYP,preview_IOTYP
	jnz	getsw5a

	mov	bx,offset AX_Descriptor
	add	bx,offset ZeroBase.SXcb_name
;	test	byte ptr Active_IOTYP,audio_IOTYP
;	jnz	getsw5a
getsw5a:ret
_GetSXcb_Name	endp

_all_switcher_set	proc	far
	mov	cx,offset AX_Types
	mov	al,AX_Type
	mov	dx,offset AX_Descriptor
	call	asst1

	mov	cx,offset SX_Types
	mov	al,SX_Type
	mov	dx,offset SX_Descriptor
	call	asst1

	mov	cx,offset PX_Types
	mov	al,PX_Type
	mov	dx,offset PX_Descriptor
	call	asst1

	ret
_all_switcher_set	endp

asst1:	cbw
	MULTIPLY_BY SXcb_length, AX
	mov	bx,ax
	add	bx,cx
	mov	ch,SXcb_length		; 16 bytes to move
	call	_mmv
	ret


_switcher_set	proc	far
	push	ax
	push	bx
	push	cx
	mov	al,Active_IOTYP		; Active_IOTYP to AL

	mov	cx,offset AX_Types
	mov	bl,AX_Type
	mov	dx,offset AX_Descriptor
	test	al,audio_IOTYP
	jnz	swrini3

	mov	cx,offset PX_Types
	mov	bl,PX_Type
	mov	dx,offset PX_Descriptor
	test	al,preview_IOTYP
	jnz	swrini3

	mov	cx,offset SX_Types
	mov	bl,SX_Type
	mov	dx,offset SX_Descriptor
;	test	al,video_IOTYP
;	jnz	swrini3

swrini3:mov	al,bl
	cbw
	MULTIPLY_BY SXcb_length, AX
	mov	bx,ax
	add	bx,cx
	mov	ch,SXcb_length		; 16 bytes to move
	call	_mmv
	pop	cx
	pop	bx
	pop	ax
	ret

_switcher_set	endp

;================================================================
; Enter with BX = stick data XY
; Exit with BX = 1 - 100%
	even
_joy_convert	proc	far
	mov	ax,dx			; Convert Y
	mov	cx,Jstick_Top_Y
	call	jcit			; Converit it
	mov	dx,ax
	mov	ax,bx			; Convert X
	mov	cx,Jstick_Top_X
	call	jcit
	mov	bx,ax
	ret
_joy_convert	endp

jcit:	push	dx
	mov	dx,100
	mul	dx
	div	cx			; ax = X coord / max stick
	pop	dx
	cmp	ax,199			; =>200%(?)
	ja	jerr
jc1:	cmp	ax,100
	jnc	jc2
	ret
jc2:	mov	ax,99
	ret

jerr:	mov	bx,offset Badjoystick_Msg
	call	_kbd_cln
	call	_comsg
	call	_baderror_bell
	and	Network_Flags,not joystick_NTBIT ; Cancel joystick
	mov	ah,10h
	int	16h
	jmp	Keyboard



;================================================================
; Check for the presence of a joystick
_check4joystick	proc	far
	call	c4j
	jnc	jsok
	and	Network_Flags,not joystick_NTBIT
	ret
jsok:	or	Network_Flags,joystick_NTBIT
	call	FAR PTR _jstick
	add	bx,bx
	add	dx,dx
	mov	Jstick_Top_X,bx
	mov	Jstick_Top_Y,dx
jnf:	ret
_check4joystick	endp

c4j:	mov	cl,20		; Check 5 times
	mov	ch,10		; Check for 3 matches
c4jagn:	push	cx
	call	FAR PTR _jstick
	cmp	bx,1000
	jnc	c4jbad
	cmp	bx,10
	jc	c4jbad
	cmp	dx,1000
	jnc	c4jbad
	cmp	dx,10
	jc	c4jbad

	and	bx,0ff00h
	and	dx,0ff00h
	push	bx
	push	dx
	call	FAR PTR _jstick
	and	bx,0ff00h
	and	dx,0ff00h
	pop	ax		; Restore Y coord
	cmp	ax,dx		; Test it against new one
	pop	ax		; Restore X coord
	pop	cx		; Restore counters
	jnz	c4jnm		; Jump if Y1<>Y2
	cmp	ax,bx		; Test for X1=X2
	jnz	c4jnm		; Jump if not equal

	dec	ch		; Indicate match
	jz	c4jdone
c4jnm:	dec	cl
	jnz	c4jagn
c4jdone:or	ch,ch
	jnz	c4jx
	ret
c4jbad:	pop	cx
c4jx:	stc
	ret


; Get joystick XY coordinates
; Enter: ----
; Exit with BX = X coordinate, DX = Y coordinate
; AX used
	even
_jstick	proc	far
	mov	ah,2
	call	jstick1
	mov	dx,bx		; DX = Y
	call	_delbrk
	mov	ah,1
	call	jstick1		; BX = X
	call	_delbrk
	call	jstick1		; BX = X
	ret
_jstick	endp

jstick1:push	cx
	push	dx
	xor	cx,cx
; Wait for stable state
	mov	dx,201h		; Set Port address
	cli
anal1:	in	al,dx
	test	al,ah
	jz	anal2
	loop	anal1
anal2:	sti
	xor	cx,cx
	mov	bx,cx
	mov	al,cl		; Make it unstable
	cli
	out	dx,al
jnext:	in	al,dx
	test	al,ah
	jz	jsxit
	inc	bx
	loop	jnext
jsxit:	sti
	pop	dx
	pop	cx
	ret

; Return JBUTTON status in AL and in AH
;  Also save it to Joybuttons
	even
_jbutton	proc	far
	mov	dx,201h
	in	al,dx
	not	al
	mov	ah,al
	ret
_jbutton	endp


;================================================================
; Setup communication Port parameters
_setcom	proc	far
	call	setcom
	ret
_setcom	endp

setcom:	call	_kbd_cln
	mov	bx,offset setports_ovr
	call	_msgread
	call	_help_pos		; Clear bottom of screen
	mov	bx,offset comport_ovr	;  and display
	call	_msgread		;   comport display header
	mov	dx,Cursor
	mov	bp,dx			; Save Cursor in BP

	mov	bx,offset Comport_Scr
	mov	bl,38
	mov	Cursor,bx
	mov	cx,5
	mov	bx,offset comstats_ovr
scomscr:push	Cursor
	call	_msgread
	pop	Cursor
	add	Cursor,100h
	loop	scomscr

	mov	al,Setcom_Chos		; Get default selection
	jmp	setcomf

setcomd:mov	Cursor,bp		; Get Cursor
	mov	bx,di			; Get TABLE base
	add	bx,offset ZeroBase.cpNAME		; Increment to Name
	rev_VIDEO FALSE,FALSE
	call	_comsg			; Display Name
	norm_VIDEO FALSE,FALSE
	call	_line_erase

setcoma:call	setcom_disp		; Display current parameters
	mov	Cursor,183ch		; Set Cursor
	call	rdchar_far
	call	_Break_check
	jz	setcomx
	cmp	ax,offset Clrrd_xcmd
	jnz	setcome
	jmp	com_allreset

setcome:cmp	ax,offset Enter_xcmd
	jz	setcomx
	call	_make_ucase
	mov	bx,offset Comport_Scr
	cmp	al,'1'
	jz	setcom_Port
	inc	bh
	cmp	al,'2'
	jz	setcom_baud
	inc	bh
	cmp	al,'3'
	jz	setcom_parity
	inc	bh
	cmp	al,'4'
	jz	setcom_stop
	inc	bh
	cmp	al,'5'
	jz	setcom_char

setcomf:cmp	al,'A'
	jz	setcom_vtr
	cmp	al,'B'
	jz	setcom_switcher
	cmp	al,'C'
	jz	setcom_audio
	cmp	al,'D'
	jz	setcom_printer
	cmp	al,'E'
	jz	setcom_Inout
	cmp	al,'F'
	jz	setcom_xterm
	cmp	al,'G'
	jz	setcom_jogger
	mov	al,7
	call	_ConOut
	jmp	setcoma

setcom_Inout:	mov	di,offset COM_EDLIO
		jmps	setjmpd
setcom_xterm:	mov	di,offset COM_XTERM
		jmps	setjmpd
setcom_vtr:	mov	di,offset COM_VLAN
		jmps	setjmpd
setcom_switcher:mov	di,offset COM_VIDEOSW
		jmps	setjmpd
setcom_audio:	mov	di,offset COM_AUDIOSW
		jmps	setjmpd
setcom_jogger:	mov	di,offset COM_SES1010
		jmps	setjmpd

setcom_printer:	mov	di,offset COM_PRINTER
setjmpd:	mov	Setcom_Chos,al
		jmp	setcomd

; Set proper Port/baud and return
setcomx:ret

; BX has Cursor position for proper query
setcom_Port:
	mov	si,offset Comport_Table
	mov	al,ds:[di].cpPORT
	mov	ah,0
	mov	cx,di
	call	setcom_prtc
	mov	ds:[di].cpPORT,al
	jmp	setcomd

setcom_baud:
	mov	si,offset Baud_Table
	mov	ax,ds:[di].cpBAUD
	call	setcom_prt0
	mov	ds:[di].cpBAUD,ax
	jmp	setcomd

setcom_parity:
	mov	ah,00011000b
	mov	si,offset Parity_Table
	jmp	setcom_set
setcom_stop:
	mov	ah,00000100b
	mov	si,offset Stopbit_Table
	jmp	setcom_set
setcom_char:
	mov	ah,00000011b
	mov	si,offset Charsize_Table

setcom_set:
	mov	dx,si			; Save start of table address
	mov	al,ds:[di].cpOPTS	; Get current setting
	and	al,ah			; Mask out appropriate bits
	push	ax
	mov	ah,0			; this is for lsb only
	call	comp_disp		; Index to current
	add	si,8			; Get next setting
	mov	ax,[si]			; Get the byte from the table
	inc	ax			; End of list?
	pop	ax
	jnz	setcom_set1
	mov	si,dx			; Point to top of list if so
setcom_set1:
	mov	al,ds:[di].cpOPTS	; Get existing byte
	not	ah			; Invert the mask
	and	al,ah			; Clear appropriate bits
	add	al,[si]			; Add in new info
	mov	ds:[di].cpOPTS,al	; Save new byte
	jmp	setcomd

; Display current COM Port settings
setcom_disp:
	mov	bx,offset Comport_Scr	;Cursor position
	mov	Cursor,bx
	mov	cx,di			; Save table base to CX
	mov	al,ds:[di].cpPORT	; Get Port number
	cbw				; Make 16 bits
	mov	si,offset Comport_Table
	call	comp_find		; Display Port
	mov	ax,ds:[di].cpBAUD
	mov	si,offset Baud_Table
	call	comp_disp		; Display BAUD
	mov	al,ds:[di].cpOPTS
	cbw
	and	al,00011000b
	mov	si,offset Parity_Table
	call	comp_disp		; Display PARITY
	mov	al,ds:[di].cpOPTS
	cbw
	and	al,00000100b
	mov	si,offset Stopbit_Table
	call	comp_disp		; Display STOP BITS
	mov	al,ds:[di].cpOPTS
	cbw
	and	al,00000011b
	mov	si,offset Charsize_Table; Fall through for WORD LENGTH

; AX = current parameter
; SI points to table (last entry = 0ffh)
; BX has Cursor position
; Each entry in table is 6 bytes
; DX returns pointing to setting
; BX still has Cursor position

comp_disp:
	mov	Cursor,bx
	xchg	bx,cx
	cmp	byte ptr [bx],8		; LST Port?
	xchg	bx,cx
	jc	comp_find
	jmp	dots

comp_find:
	push	cx
	mov	cx,si			; Save top of table
	push	dx
compda:	mov	dx,[si]
	cmp	ax,dx			; Match?
	jz	comp_fok		; Yes, display it
	inc	dx
	jz	comp_fbd		; End of table, value not found
	add	si,8			; Else offset to next entry
	jmp	compda

comp_fbd:
	mov	si,cx			; Use first entry if not found
comp_fok:
	push	si
	inc	si			; Point to Name
	inc	si
	rev_VIDEO FALSE,FALSE
	push	bx
	mov	bx,si
	call	_comsg			; Display it and return
	pop	bx
	norm_VIDEO FALSE,FALSE
	pop	si			; Restore pointer to setting
	mov	ax,[si]			; Get byte

	inc	bh			; Increment Cursor LINE
	pop	dx
	pop	cx
	ret

dots:	push	ax
	push	cx
	mov	cx,5
	mov	al,'.'
dotslp:	call	_ConOut
	loop	dotslp
	pop	cx
	pop	ax
	inc	bh
	ret

; Reset com ports to start of all tables
com_allreset:
	push	si
	mov	si,offset COM_EDLIO
	call	carst
	mov	si,offset COM_EDLIO
	call	carst
	mov	si,offset COM_XTERM
	call	carst
	mov	si,offset COM_VLAN
	call	carst
	mov	si,offset COM_VIDEOSW
	call	carst
	pop	si
	jmp	setcomd

carst:	mov	al,byte ptr Comport_Table
	mov	[si].cpPORT,al			; Com Port 1
	mov	al,byte ptr Parity_Table
	or	al,byte ptr Stopbit_Table
	or	al,byte ptr Charsize_Table
	mov	[si].cpOPTS,al			; Set 7 bit word, nothing else
	mov	ax,Baud_Table
	mov	[si].cpBAUD,ax			; Set 110 baud
	ret

setcom_prtc:
	mov	dx,si
	mov	Cursor,bx
	call	comp_find
	jmps	setcom_prtd
setcom_prt0:
	mov	dx,si
	call	comp_disp
setcom_prtd:
	add	si,8			; Get next setting
	mov	ax,[si]
	cmp	ax,0ffffh		; End of list?
	jnz	setcom_prt1
	mov	si,dx			; Point to top of list if so
setcom_prt1:
	mov	ax,[si]
	ret

BSEG	ends

_DATA	segment byte public 'DATA'
;================================================================
Comport_Table	db	0,0,'COM1 ',0
		db	1,0,'COM2 ',0
		db	2,0,'COM3 ',0
		db	3,0,'COM4 ',0
		db	8,0,'LPT1 ',0
		db	9,0,'LPT2 ',0
		db	10,0,'LPT3 ',0
		db	11,0,'LPT4 ',0
		dw	0ffffh

Baud_Table	dw	0417h		;0
		db	'110  ',0
		dw	0300h		;1
		db	'150  ',0
		dw	0180h		;2
		db	'300  ',0
		dw	00c0h		;3
		db	'600  ',0
		dw	0060h		;4
		db	'1200 ',0
		dw	0030h		;5
		db	'2400 ',0
		dw	0018h		;6
		db	'4800 ',0
		dw	000ch		;7 auto
		db	'9600 ',0
		dw	0006h		;8 auto
		db	'19200',0
		dw	0003h		;9 auto
		db	'38400',0
		dw	0002h		;10
		db	'57600',0
		dw	0001h		;11
		db	'115KB',0
		dw	0ffffh

;...xx... parity code
;.....x.. stop bit code
;......xx character size code
Parity_Table	db	00000000b,0,'None ',0
		db	00001000b,0,'Odd  ',0
		db	00011000b,0,'Even ',0
		dw	0ffffh

Stopbit_Table	db	00000000b,0,'One  ',0
		db	00000100b,0,'Two  ',0
		dw	0ffffh

Charsize_Table	db	00000010b,0,'7 Bit',0
		db	00000011b,0,'8 Bit',0
		dw	0ffffh

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

