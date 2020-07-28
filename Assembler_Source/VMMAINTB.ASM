; Last revised: 2-22-1995, 11:12:26   (C)1989-1995 Norman H. Strassner

; VMMAINTB.ASM 
;Menues and default settings

%nolist
include	VM.EQU
%list

PORTSXPT_HORIZ_SEP	equ	6
ASSIGN_HORIZ_OFFSET 	equ	20bh

ASSIGN_POS_VIDCONTROL	EQU	022Eh
ASSIGN_POS_AUDCONTROL	EQU	032Eh
ASSIGN_POS_PVWCONTROL	EQU	042Eh
ASSIGN_POS_GPIBASE	EQU	052Eh
ASSIGN_POS_AUDCUESTAT	EQU	062Eh

extrn pvwbase_ovr:word,VlanPreviewPort:byte

extrn colorfrmq_ovr:word,_msg2screen:far, cuetrack_ovr:word
extrn ememefxadr_ovr:word,Emem_Efxadr:byte
extrn audcuestat_ovr:word,vidbase_ovr:word,audbase_ovr:word,vidbase2_ovr
extrn AX_Type:byte,Device_Present:byte,DelEdRoll_Qrtrs:byte,SX_Type:byte
extrn ShuttleSensitivity:byte,Active_IOTYP:byte,Assembly_Mode:byte
extrn Auxtcf:byte,Blink_Time:byte,Blktcf:byte,available_bins:byte
extrn Dnstream_Keynumber:byte,Edl_Fcm:byte,Edltrack_Delay:byte
extrn Effects_Address:byte,Flag1:byte,Flag2:byte,Flag3:byte,Flag4:byte
extrn Flag5:byte,Fterr_Flg:byte,Fullscreen_Flag:byte,Gpi_Node:byte
extrn Hardware_Delay:byte,Retry_Count:byte,Rtcf:byte,System_Color_Frame:byte
extrn Tcgen_Mode:byte,Upstream_Keynumber:byte,Video_Mode:byte
extrn VlanVideoPort:byte,VlanAudioPort:byte,VlanVideoPort2:byte
extrn PX_Type:byte

extrn AX_Switcher_Types:WORD,AX_Types:word,CtrTable:word,DOS_Flags:word
extrn DelEdRoll_ovr:word,DelayRoll_ovr:word,EDL_Subdir:word
extrn EDLoptions_Flags:word,JoggerIRQ:word,MultRec_Flags:word
extrn NumberOfEdlFormats:word,PMC_store_ovr:word,Psp_Seg:word
extrn PointShootData:word,SelTable:word,SPD_store_ovr:word,PX_Types:word
extrn SX_Switcher_Types:WORD,SX_Types:word,TCM_Subdir:word,TMP_Subdir:word
extrn VME_Subdir:word,asgnttl_ovr:word,asmmode_ovr:word,assign_ovr:word
extrn Assign_Scr:word,assignment_ovr:word,audcontrol_ovr:word
extrn autodisable_ovr:word,autofile_ovr:word,AUTOFILE_Subdir:word
extrn badffcm_ovr:word,badftyp_ovr:word,beltogl_ovr:word,brate_ovr:word
extrn Button_Msg:word,colorframe_ovr:word,cputype_ovr:word
extrn Crosspoint_Msg:word,Current_Event:word,Cursor:word,disptype_ovr:word
extrn dnstrkey_ovr:word,durfcm_ovr:word,Edit_Flags:word,Input_Flag:word
extrn Edits_To_Look_Ahead:word,Edl_Ext:word,Edl_Formats:word,Edl_Seg:word
extrn edltrack_ovr:word,efxadr_ovr:word,eightfieldI_msg:word
extrn eightfield_msg:word,ejectpage_ovr:word,Entime:word,errbell_ovr:word
extrn exitmenu_ovr:word,exitshort_ovr:word,extmenu_ovr:word,fcmrqst_ovr:word
extrn fext_ovr:word,forcev3_ovr:word,fourfieldI_msg:word,fourfield_msg:word
extrn Frame_Msg:word,freememory_ovr:word,Gpi_Flags:word,gpi_store_ovr:word
extrn gpibase_ovr:word,Hardware_Flags:word,JoggerIRQ_ovr:word
extrn Joggerkey_Msg:word,Joykey1:word,Joykey2:word,Jstick_Top_X:word
extrn Jstick_Top_Y:word,jstickaxis_ovr:word,Jstickaxis_Scr:word
extrn Jstickbutn_Scr:word,Jstickline_Scr:word,jsticklr_ovr:word
extrn Jsticklr_Scr:word,Jstickset_Scr:word,jstickx_ovr:word,Jstickxy_Scr:word
extrn jsticky_ovr:word,keys_ovr:word,lastkey_ovr:word,Lastline_Scr:word
extrn List_Scr:word,Logauto_Msg:word,Logd_Msg:word,Logtcm_Msg:word
extrn Logtmp_Msg:word,Logvme_Msg:word,lookahead_ovr:word,lookcount_ovr:word
extrn menu_ovr:word,mhz_ovr:word,Mode_Msg:word,modetype_ovr:word,Msg_Seg:word
extrn Network_Flags:word,Next_Avail_Num:word,No_Msg:word,Nobutton_Msg:word
extrn Nowild_Msg:word,Nport:word,off_msg:word,on_msg:word
extrn Operational_Flags:word,pauseplay_ovr:word,Pmc_Flags:word,Port:word
extrn Port_Msg:word,Postroll:word,Postroll_rqst:word,Preroll:word
extrn Preroll_rqst:word,realtime_ovr:word,REC_store_ovr:word,recheck_ovr:word
extrn Recordpost:word,recpost_rqst:word,recripl_store_ovr:word
extrn relchg_ovr:word,relsrch_ovr:word,Retry_Count_ovr:word,Rm_xcmd:word
extrn rptoggle_ovr:word,screengrid_ovr:word,selasgn_ovr:word
extrn selectedlf_ovr:word,Seloffset:word,Selvtr_Msg:word,setjstick_ovr:word
extrn shuttlesense_ovr:word,Slave_Flags:word,slave_store_ovr:word
extrn slop_factor_ovr:word,Sounddisplay_Flags:word,Spd_Flags:word
extrn Split_Vid_Msg:word,stripetape_ovr:word,Sttime:word,Switcher_Flags:word
extrn swtgl_ovr:word,syscolorframe_ovr:word,Tcdispbuf:word,Tcgen_Start:word
extrn tcgenmode_ovr:word,tcgenset_ovr:word,Temp_Tc_Buf:word,Temp_Wrkspce:word
extrn Threedots_Msg:word,timedisplay_ovr:word,upstrkey_ovr:word
extrn useJogger_ovr:word,usejstick_ovr:word,vidcontrol_ovr:word
extrn VLAN_Flags:word,Vtrcb:word,Wild1:word,Wild2:word
extrn Wild_Msg:word,wipemods_ovr:word,Work_Event:word,Yes_Msg:word
extrn Timelineroll:word,tlineroll_rqst:word,shiftplay_rqst:word
extrn preread_ovr:word,audefxadr_ovr:word,Audio_Effects_Address:byte
extrn sortdirs_ovr:word,pentium_ovr:word,pvwcontrol_ovr:word
extrn PX_Switcher_Types:WORD
extrn cimsg_wrk:near,dec_cimsg:near,devtype:near
extrn machine_init:near,position_query:near,rdchar:near,screen_init:near
extrn Split_Aud_Msg:near,switch:near,tcprty0:near

extrn _A_DecOut:far,Node_Stats_FAR:far, yn_chos_FAR:far
extrn _BitCountReset:far,_ConOut:FAR,_DecOut:far,_DrawBox:far
extrn _DrawMenuBox:far,_GetKeyName:far,_GetSXcb_Name:far,_MsgCntr:FAR
extrn _Space_Out:far,_adv2chr:FAR,_big_DecOut:far,_Break_check:FAR
extrn _check4joystick:far,_chimes:FAR,_clear_screen:FAR,_cmpchr:far
extrn _cnvt2tc_DS:far,_cnvt2tc_DS:far,_comsg:FAR,_convert2bin:far
extrn _crlf:FAR,_Cursor_off:far,_dashit_cl:far,_delbrk:far,_delfrm:FAR
extrn _dhb:far,_dhw:far,_dircur_lerase:FAR,_error_bell:FAR
extrn _error_redisplay:far,_event_display:far,_evnt_dispthis:far
extrn _getlast_reel:far,_help_pos:FAR,_hl_lp:far,_index_storage:far
extrn _jbutton:far,_jstick:far,_kbd_cln:FAR,_kbd_clr:FAR,_left_set2edl:far
extrn _left_set_reel:far,_line_erase:FAR,_machine_disp:far,_machine_keys:far
extrn _make_ucase:far,_mmv:far,_mpbdiv:far,_msgread:FAR,_screen_init_FAR:far
extrn _sram_dx:far,_switcher_set:far,_upd_getscr:far,_upd_gettcf:far
extrn _working:far,chk4relaybox_FAR:far,cimsg_wrk_FAR:far,dec_cimsg_FAR:far
extrn devtype_FAR:far,hackerishere:far,Keyboard:far,machine_init_FAR:far
extrn position_query_FAR:far,rdchar_FAR:FAR,tcprty0_FAR:far,_vl_lp:far
extrn _mmv16:far
BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg

Public  _PromptForDigits, pfdx, PFDbad, _FindModeFromPointer, fmfplp, fmfpx
Public  _SetNewRvtFCM, snrfcmx, _RqstNewRvtFCM, _VTR_Port_Assignment, m26_agn
Public  m26_1, m26_2, m26_3, M26ret, vtravclear, vtrasgv, vtrasgvx, vtrasga
Public  vtrasgax, vtrasgg, vtrasvx, Switcher_Display, sdc1, swdisp1
Public  swdispl, swdisp4, swdispx, swdispr, swdr, m26_dsp, vtrasgn, m26dsp1
Public  m26dsp2, GetNewAssignment, asgndx, asgndsp, avswtype, vtramsg
Public  _StickItToEm, stk_rc, joystick_adjust, jsa_1, jsa_2, jsa_3, jsa_5
Public  jsa_6, jdigits, _bit_toggle_bx, _choose_fcm, _fcmset
Public  _Change_Reel_Assignments, relcaps, cra_xit, relcapx, relchl, relchl0
Public  relchl1, _edltype_display, edltd0, edltdlp, edltfin, M6_d1_1, M6_d1_x
Public  _INSTL_lsave, _INSTL_lrest, ml_sr, _m16_dsp, m16_dlp, m16_d1, m16d2
Public  _m16_prmpt, m16_p1, m16_p2, _m21_dsp, _getmkey, _getmkag, getmkc
Public  getmkp, getmkg, getmka, getmkv, getmkav, getmkr, getmk1, getmkz
Public  _default_val, _default_char, rhtbrkt, _M1_CARD, _M2_CARD, _M3_CARD
Public  _M7_CARD, mc7_1, _M11_CARD, _M12_CARD, _M19_CARD, _M20_CARD, _M22_CARD
Public  _M23_CARD, nocirq, _M27_CARD, m22_cmd, m22_1b, m22_1c, m22clp, m22erx
Public  m20_dp, m20_dpi, INSTL_PQdisplay
Public  INSTL_PQdisplayb, MPQd1, _K_GetPort, K_nextport, K_delay, Count_A
Public  K_another, K_done, _CompleteCheck, K_delay2, Count_A_, K_next, K_next1
Public  K_next2, Count_B_, K_next3, K_next4, Count_C_, K_next5, K_next6
Public  K_next7, K_next8, K_byte_test, K_tdly, K_byte_out, _HackerHere
Public  _M8_CARD, _m8_prmpt, _PromptForColorFrame, _hex2bn
Public  _SetPointAndShootParams

; Enter:	BX -> New record to save
_SetPointAndShootParams	proc	far
	mov	cx,SIZE POSITIONQUERYDATA
	mov	dx,offset PointShootData
	call	_mmv16
	ret
_SetPointAndShootParams	endp

_PromptForColorFrame	proc	far
	call	 _kbd_cln
	mov	bx,offset colorfrmq_ovr
	call	 _msg2screen

	mov	al,[si.Vtrcb_CF]
	cbw
	inc	ax
	mov	bx,ax
	call	 FAR PTR _default_val
	mov	al,1
	call	dec_cimsg_FAR
	jz	pfcfx
	call	 _convert2bin
	or	al,al
	jz	pfcfx

	IF PAL
	cmp	al,5
	ENDIF
	IF NTSC
	cmp	al,3
	ENDIF

	ja	pfcfx
	dec	al
	mov	[si.Vtrcb_CF],al
pfcfx:	ret
_PromptForColorFrame	endp


; Enter AL = color frame byte
; Return BX -> color frame type message
_GetColorFrameMsgAL	proc	far
	mov	bx,offset fourfield_msg
	dec	al
	jz	mc7_1
	mov	bx,offset fourfieldI_msg
	dec	al
	jz	mc7_1

	if PAL
	mov	bx,offset eightfield_msg
	dec	al
	jz	mc7_1
	mov	bx,offset eightfieldI_msg
	dec	al
	jz	mc7_1
	ENDIF

	mov	bx,offset off_msg

mc7_1:	call	 _msgread
	ret
_GetColorFrameMsgAL	endp

_m8_prmpt	proc	far
	mov	bx,offset colorframe_ovr
	call	 _msgread
	norm_VIDEO FALSE,FALSE
	mov	al,cl
	dec	al
	call	 _machine_disp
	dim_VIDEO FALSE,FALSE
	mov	al,':'
	call	 _ConOut
	call	 _Space_Out
	call	 _Space_Out
	ret
_m8_prmpt	endp



; Enter: BX -> msgseg message offset
;	 DX -> byte receiving the value
;	 AL = # of digits to read
; Exit:	 [DX] filled in or carry set if aborted
_PromptForDigits	proc	far
	call	 _kbd_cln
	push	si
	mov	si,dx
	push	ax
	call	 _msgread
	call	_Space_Out
	call	 _chimes
	mov	bl,[si]
	mov	bh,0
	call	 FAR PTR _default_val
	pop	ax
	push	ax
	call	dec_cimsg_FAR
	pop	ax
	jbe	pfdx
	push	ax
	call	 _convert2bin
	pop	dx
	cmp	al,dh
	ja	PFDbad
	mov	[si],al
pfdx:	clc
	pop	si
	ret

PFDbad:	call	 _error_bell
	stc
	pop	si
	ret

_PromptForDigits	endp


;================================================================
; Return mode number in AL for mode pointer in BX
_FindModeFromPointer	proc	far
	push	si
	mov	si,offset Edl_Formats	; Start of format tables
	mov	ax,offset NumberOfEdlFormats
	mov	ah,al
	xor	al,al
fmfplp:	cmp	bx,si
	jz	fmfpx
	add	si,SIZE EDLFORMAT
	inc	al
	dec	ah
	jnz	fmfplp
	xor	al,al
fmfpx:	pop	si
	ret

_FindModeFromPointer	endp

;================================================================
;		Select Drop/Non Drop format
;================================================================
_SetNewRvtFCM	proc	far

	if NTSC
	test	Device_Present,vlan_IOTYP
	jnz	snrfcmx
	call	 _kbd_cln
	jmp	SRfcmb
	endif

snrfcmx:ret
_SetNewRvtFCM	endp

_RqstNewRvtFCM	proc	far
	if NTSC
	call	 _help_pos
	mov	bx,offset badffcm_ovr
	call	 _msgread

SRfcmb:	call	 _kbd_cln
	mov	bx,offset fcmrqst_ovr
	call	 _msgread
	mov	al,Rtcf
	cmp	al,DF_CHAR
	jz	SRfcmd
	cmp	al,NDF_CHAR
	jz	SRfcmd
	mov	al,NDF_CHAR		; Default to NON-DROP
	mov	Rtcf,al
SRfcmd:	call	 FAR PTR _default_char
	call	rdchar_FAR
	cmp	ax,offset Enter_xcmd
	jnz	SRfcme
	mov	al,Rtcf
	jmp	SRfcmc

SRfcme:	call	 _make_ucase
	call	 _Break_check
	jnz	SRfcmc
	mov	al,Rtcf
	ret
SRfcmc:	cmp	al,DF_CHAR
	jz	SRfcmf
	cmp	al,NDF_CHAR
	jnz	_SetNewRvtFCM
SRfcmf:	call	 FAR PTR _choose_fcm
	endif ;NTSC
	ret
_RqstNewRvtFCM	endp

;****************************************************************
_VTR_Port_Assignment	proc	far
	mov	Fullscreen_Flag,0ffh
	call	 _clear_screen
	mov	bx,offset assignment_ovr
	call	 _MsgCntr

	dim_VIDEO FALSE,FALSE
	mov	bx,offset 0100h			; Draw line under assignment_ovr
	mov	cx,80
	mov	al,205
	call	 _hl_lp

	mov	bx,offset Assign_Scr + 0100h	; Draw line under asgnttl_ovr
	mov	cx,80
	mov	al,196
	call	 _hl_lp

	mov	bx,offset Assign_Scr + 0b00h	; Draw line under asgnttl_ovr
	mov	cx,80
	mov	al,196
	call	_hl_lp

	mov	bx,offset Assign_Scr + 022ah	; Draw line under asgnttl_ovr
	mov	cx,09h
	mov	al,196
	call	_vl_lp
	mov	Cursor,offset Assign_Scr + 012ah
	mov	al,'Â'
	call	_ConOut
	mov	Cursor,offset Assign_Scr + 0b2ah
	mov	al,'Á'
	call	_ConOut


	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Assign_Scr
	mov	bx,offset asgnttl_ovr
	call	 _msgread
	mov	Cursor,offset Assign_Scr + 200h
	mov	bx,offset assign_ovr	; Display VTR names
	call	 _msgread

	call	Node_Stats_FAR

m26_agn:call	m26_dsp

; Get a keypress
	call	 _kbd_cln
	mov	bx,offset selasgn_ovr
	call	 FAR PTR _getmkey	; Get a machine key (or abort)
	JMP_C	M26ret

	cmp	ax,offset Gotoin_xcmd	;
	JMP_Z	vtrasg_cuetrack

	mov	ah,0			; returns with AL=0ffh if VIDEO key
	mov	cx,ax
	cmp	al,0ffh			; Video?
	jnz	m26_1
	jmp	vtrasgv
m26_1:	cmp	al,0feh			; Audio?
	jnz	m26_2
	jmp	vtrasga
m26_2:	cmp	al,0fdh			; GPI
	jnz	m26_3
	jmp	vtrasgg
m26_3:	cmp	al,0fch			; VVV
	jnz	m26_4
	jmp	vtrasgp
m26_4:	cmp	al,0f1h			; Clear?
	JMP_Z	vtravclear

; Must be a MACHINE KEY
	cmp	al,MAX_DEVICES		; Legal device?
	ja	m26_agn
	mov	dl,al			; Save VTR in DL

	call	 _kbd_cln
	mov	bx,offset Selvtr_Msg	; " Device - "
	call	 _comsg
	call	 _machine_disp		; x-VT
	call	 _Space_Out
	mov	bx,offset Port_Msg	; "Port "
	call	 _comsg

	MULTIPLY_BY Vtrcb_length, AX	; Index to Port
	mov	si,offset Vtrcb
	add	si,ax

	mov	bx,offset ZeroBase.Vtrcb_PORT
	call	GetNewAssignment		; Display Port assignment

	mov	bx,offset Split_Vid_Msg
	call	 _comsg
	mov	bx,offset Crosspoint_Msg
	call	 _comsg
	mov	bx,offset ZeroBase.Vtrcb_VXPT
	call	GetNewAssignment		; Get Video Crosspoint

	mov	bx,offset Split_Aud_Msg
	call	 _comsg
	mov	bx,offset Crosspoint_Msg
	call	 _comsg
	mov	bx,offset ZeroBase.Vtrcb_AXPT
	call	GetNewAssignment		; Get Audio Crosspoint

	call	 _kbd_cln
	mov	al,dl			; Get VTR from DL
	call	 _machine_disp		; x-VT
	call	 _Space_Out
	mov	bx,offset shiftplay_rqst
	call	 _msgread
	call	 _Space_Out
	mov	bx,offset ZeroBase.Vtrcb_OFFSET
	call	GetNewAssignment		; Get Audio Crosspoint

	call	machine_init_FAR
	jmp	m26_agn

M26ret:	ret


vtrasg_cuetrack:
	call	_kbd_cln
	mov	bx,offset cuetrack_ovr
	call	_msgread
	mov	cl,'N'
	test	Edit_Flags, cuetrack_EDBIT
	jz	vctp1
	mov	cl,'Y'
vctp1:	call	yn_chos_FAR
	mov	bx,offset Edit_Flags
	jz	vcton
	and	word ptr [bx], NOT cuetrack_EDBIT
	jmp	vctxit
vcton:	or	word ptr [bx], cuetrack_EDBIT
vctxit:	call	_kbd_cln
	jmp	m26_agn

vtravclear:
	mov	AX_Type,0
	mov	SX_Type,0
	call	 _help_pos
	jmp	m26_agn

; Video switcher
vtrasgv:mov	bx,offset SX_Types
	mov	dx,offset Assign_Scr + ASSIGN_POS_VIDCONTROL
	mov	cx,offset SX_Switcher_Types
	call	Switcher_Display
	mov	cl,SX_Type
	inc	cl
	call	position_query_FAR
	or	cl,cl
	jz	vtrasgax
	dec	cl
	mov	Active_IOTYP,video_IOTYP
	mov	SX_Type,cl
	call	 _switcher_set
vtrasgvx:
	call	 _help_pos
	jmp	m26_agn

; Audio switcher
vtrasga:mov	bx,offset AX_Types
	mov	dx,offset Assign_Scr + ASSIGN_POS_AUDCONTROL
	mov	cx,offset AX_Switcher_Types
	call	Switcher_Display
	mov	cl,AX_Type
	inc	cl
	call	position_query_FAR
	or	cl,cl
	jz	vtrasgax
	dec	cl
	mov	Active_IOTYP,audio_IOTYP
	mov	AX_Type,cl
	call	 _switcher_set
vtrasgax:
	call	 _help_pos
	jmp	m26_agn


; Preview switcher
vtrasgp:mov	bx,offset PX_Types
	mov	dx,offset Assign_Scr + ASSIGN_POS_PVWCONTROL
	mov	cx,offset PX_Switcher_Types
	call	Switcher_Display
	mov	cl,PX_Type
	inc	cl
	call	position_query_FAR
	or	cl,cl
	jz	vtrasgpx
	dec	cl
	mov	Active_IOTYP,preview_IOTYP
	mov	PX_Type,cl
	call	 _switcher_set
vtrasgpx:
	call	 _help_pos
	jmp	m26_agn


;................................................................
; Set GPI BASE Port
vtrasgg:call	 _kbd_cln
	mov	bx,offset gpibase_ovr
	call	 _msgread
	mov	bl,Gpi_Node
	xor	bh,bh
	call	 FAR PTR _default_val
	mov	al,2
	call	dec_cimsg_FAR
	jz	vtrasvx
	call	 _convert2bin
	mov	Gpi_Node,al
	call	chk4relaybox_FAR
	jmp	vtrasvx

vtrasvx:jmp	m26_agn

_VTR_Port_Assignment	endp

Switcher_Display	proc	near
	push	dx			; Save switcher select type
	call	 _help_pos
	mov	PointShootData.PQ_Flag,00000000b
	mov	PointShootData.PQ_Cursor,offset List_Scr + 110h; Screen position
	mov	PointShootData.PQ_exitkey,offset Escape_xcmd
	mov	PointShootData.PQ_tab,15
	mov	PointShootData.PQ_field,14
	mov	PointShootData.PQ_rows,4

; CX has number of entries in table
	mov	ax,cx			; # of entries to ax
	mov	cl,4			; Divide by
	div	cl			;  # of rows
	or	ah,ah			; Increment if
	jz	sdc1			;  there is a remainder
	inc	al
sdc1:	mov	PointShootData.PQ_cols,al

; Left pad = (80 - (PointShootData.PQ_field * #col)) / 2
	cbw
	mov	cl,PointShootData.PQ_tab
	mul	cl
	mov	ah,al
	mov	al,80
	sub	al,ah
	mov	ah,1			; Add a row
	shr	al,1			; half the pad
	add	ax,offset List_Scr
	mov	PointShootData.PQ_Cursor,ax
	
	xor	cl,cl			; Clear counter
	mov	ch,4			; # of rows for each column

	mov	di,PointShootData.PQ_Cursor		; Screen position
	mov	dx,di			; Save in DX
swdisp1:cmp	word ptr [bx],'  '	; End of table?
	jz	swdispx
	mov	Cursor,di
	call	 _dashit_cl
	mov	si,bx
	push	cx
	mov	cx,8
swdispl:lodsb
	call	 _ConOut
	loop	swdispl
	pop	cx
	add	bx,SXcb_length
	cmp	cl,ch			; Is this column done?
	jnz	swdisp4
	add	ch,4			; For next column
	add	dl,PointShootData.PQ_tab
	mov	di,dx
	jmp	swdisp1

swdisp4:add	di,100h
	jmp	swdisp1

swdispx:mov	PointShootData.PQ_choices,cl		; Save choices

swdispr:pop	dx
	push	es
	call	 _sram_dx
	mov	cx,24
	rev_VIDEO FALSE,FALSE
	mov	al,Video_Mode
swdr:	inc	di
	stosb
	loop	swdr
	pop	es
	ret
Switcher_Display	endp

;================================================================
;================================================================
;================================================================
;----------------------------------------------------------------
; Display ports/crosspoints
m26_dsp	proc	near
	dim_VIDEO FALSE,FALSE
	mov	di,offset Assign_Scr + ASSIGN_HORIZ_OFFSET
	mov	si,offset Vtrcb
	mov	cx,ALL_DEVICES		; For all machines
vtrasgn:push	di
	push	si
	push	cx
	mov	bx,offset ZeroBase.Vtrcb_PORT
	call	asgndsp			; Get Port assignment
	push	ax			; Save Port assignment
	mov	bx,offset ZeroBase.Vtrcb_VXPT
	call	asgndsp			; Get video crosspoint assignment
	mov	bx,offset ZeroBase.Vtrcb_AXPT
	call	asgndsp			; Get audio crosspoint assignment
	mov	bx,offset ZeroBase.Vtrcb_OFFSET
	call	asgndsp			; 
	pop	ax			; Restore Port assignment
	call	devtype_FAR		; Get device type
	mov	Cursor,di
m26dsp1:mov	al,[bx]
	cmp	al,cr
	jz	m26dsp2
	or	al,al
	jz	m26dsp2
	call	 _ConOut
	inc	bx
	jmp	m26dsp1

m26dsp2:pop	cx
	pop	si
	pop	di
	add	si,Vtrcb_length
	add	di,100h
	loop	vtrasgn

;----------------------------------------------------------------
; Name of video switcher
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Assign_Scr + ASSIGN_POS_VIDCONTROL
	mov	bx,offset vidcontrol_ovr
	call	 _msgread
	dim_VIDEO FALSE,FALSE
	mov	Active_IOTYP,video_IOTYP
	call	 _GetSXcb_Name			; Index to Name of switcher
	call	avswtype

	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Assign_Scr + ASSIGN_POS_AUDCONTROL
	mov	bx,offset audcontrol_ovr
	call	 _msgread
	dim_VIDEO FALSE,FALSE
	mov	Active_IOTYP,audio_IOTYP
	call	 _GetSXcb_Name			; Index to Name of switcher
	call	avswtype


	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Assign_Scr + ASSIGN_POS_PVWCONTROL
	mov	bx,offset pvwcontrol_ovr
	call	 _msgread
	dim_VIDEO FALSE,FALSE
	mov	Active_IOTYP,preview_IOTYP
	call	 _GetSXcb_Name			; Index to Name of switcher
	call	avswtype


	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Assign_Scr + ASSIGN_POS_GPIBASE
	mov	bx,offset gpibase_ovr
	call	 _msgread
	dim_VIDEO FALSE,FALSE
	mov	al,Gpi_Node
	call	 _A_DecOut

	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Assign_Scr + ASSIGN_POS_AUDCUESTAT
	mov	bx,offset audcuestat_ovr
	call	 _msgread
	dim_VIDEO FALSE,FALSE
	mov	bx,offset Yes_Msg
	test	Edit_Flags, cuetrack_EDBIT
	jnz	m26dsp3
	mov	bx,offset No_Msg
m26dsp3:call	_comsg
	ret
m26_dsp	endp

;................................................................
; Get quantity at DS:[SI+BX], display it, get input
GetNewAssignment	proc	near
	push	bx
	mov	bl,[si + bx]
	mov	bh,0
	call	 FAR PTR _default_val
	mov	al,2
	call	dec_cimsg_FAR
	jz	asgndx
	call	 _convert2bin
	pop	bx
	mov	[si + bx],al
	push	bx
asgndx:	pop	bx
	call	 _Space_Out
	norm_VIDEO TRUE,TRUE
	ret
GetNewAssignment	endp

;................................................................
; Display parameter, move Cursor (di) 15 Spaces over
asgndsp	proc	near
	mov	Cursor,di
	add	di,PORTSXPT_HORIZ_SEP
	mov	al,[si+bx]
	call	 _A_DecOut
	call	 _Space_Out
	ret
asgndsp	endp

;................................................................
avswtype	proc	near
	mov	cx,8			; 8 characters to print
vtramsg:mov	al,[bx]
	call	 _ConOut
	inc	bx
	loop	vtramsg
	ret
avswtype	endp

;================================================================
;================================================================
;================================================================
;================================================================
_StickItToEm	proc	far
; I. Set up the screen with first JOYSTICK/CRUISE CNTRL menu
	call	 _kbd_clr			; Clear prompt away
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Jsticklr_Scr
	mov	bx,offset jsticklr_ovr		; Tell 'em to put stick
	call	 _msgread			;  at lower right position
	call	joystick_adjust			; Display current position
	JMP_C	stk_rc				; Check for an ABORT
	call	 _jstick				; Get current values
	shr	bx,1				; Find half way
	shr	dx,1				;  positions
	mov	Jstick_Top_X,bx			; Save half way
	mov	Jstick_Top_Y,dx			;  positions
	push	bx
	push	dx

; II. Reset the screen for center point input
	call	 _help_pos			; Clear window
	norm_VIDEO FALSE,FALSE
	mov	di,offset Jstickset_Scr
	mov	bx,di
	mov	Cursor,bx
	mov	bx,offset setjstick_ovr
	call	 _msgread

	dim_VIDEO FALSE,FALSE
	mov	di,offset Jstickaxis_Scr
	mov	Cursor,di
	mov	al,'X'
	call	 _ConOut
	mov	bx,offset jstickaxis_ovr
	call	 _msgread
	push	Cursor
	add	di,100h
	mov	Cursor,di
	mov	al,'Y'
	call	 _ConOut
	mov	bx,offset jstickaxis_ovr
	call	 _msgread
	pop	di
	inc	di
	mov	Cursor,di
	pop	dx				; Restore half way
	pop	bx				;  values
	call	jdigits

	call	joystick_adjust
	jc	stk_rc
	call	 _check4joystick
	ret

stk_rc:	and	Network_Flags,not joystick_NTBIT
	ret
_StickItToEm	endp

;================================================================
joystick_adjust	proc	near
	mov	bx,offset Jstickline_Scr
	dim_VIDEO FALSE,FALSE
	mov	al,196
	mov	cx,80
	call	 _hl_lp

	mov	di,offset Jstickxy_Scr
	mov	Cursor,di
	norm_VIDEO FALSE,FALSE
	mov	bx,offset jstickx_ovr
	call	 _msgread
	push	Cursor
	add	di,100h
	mov	Cursor,di
	mov	bx,offset jsticky_ovr
	call	 _msgread
	pop	di			; restore Cursor
	inc	di
	mov	Cursor,di

jsa_1:	mov	ah,11h			; Keyboard status AT
	int	16h
	jz	jsa_3
	mov	ah,10h
	int	16h
	call	 _Break_check
	jnz	jsa_2
	stc
	ret
jsa_2:	cmp	ax,offset Enter_xcmd
	clc
	ret

jsa_3:	call	 _jbutton
	mov	al,1
	test	ah,00010000b
	jnz	jsa_5
	inc	al
	test	ah,00100000b
	jnz	jsa_5
	inc	al
	test	ah,01000000b
	jnz	jsa_5
	inc	al
	test	ah,10000000b
	jnz	jsa_5

	mov	Cursor,offset Jstickbutn_Scr
	mov	bx,offset Nobutton_Msg
	call	 _comsg
	jmp	jsa_6

jsa_5:	mov	Cursor,offset Jstickbutn_Scr
	mov	bx,offset Button_Msg
	call	 _comsg
	call	 _A_DecOut

jsa_6:	call	 _jstick
	call	jdigits
	call	 _delfrm
	jmp	jsa_1
joystick_adjust	endp

;...
jdigits	proc	near
	norm_VIDEO FALSE,FALSE
	mov	cx,di
	mov	Cursor,cx
	call	 _DecOut
	call	 _Space_Out
	call	 _Space_Out
	mov	cx,di
	add	cx,100h
	mov	Cursor,cx
	xchg	bx,dx
	call	 _DecOut
	xchg	bx,dx
	call	 _Space_Out
	call	 _Space_Out
	ret
jdigits	endp


;================================================================
_bit_toggle_bx	proc	far
	push	dx
	mov	dx,[bx]
	and	dx,ax			; Mask out bit
	not	dx
	and	dx,ax
	not	ax
	and	[bx],ax
	not	ax
	or	[bx],dx
	pop	dx
	ret
_bit_toggle_bx	endp

;================================================================
_choose_fcm	proc	far
	push	ax
	call	 FAR PTR _fcmset
	call	 _upd_getscr
	pop	ax
	mov	es:Edl_Fcm,al
	ret
_choose_fcm	endp

_fcmset	proc	far
	mov	Rtcf,al
	mov	Blktcf,al
	mov	Auxtcf,al
	call	 _upd_gettcf
	ret
_fcmset	endp

;================================================================
; Used for GLOBAL REEL CHANGE 
_Change_Reel_Assignments	proc	far
	mov	bx,offset relsrch_ovr	; Request REEL TO CHANGE
	call	 _kbd_cln
	call	 _msgread
	mov	al,reel_length		; Get input from user
	call	cimsg_wrk_FAR
	jz	cra_xit			; Just return if no input


; Move REEL TO CHANGE into Work_Event
	mov	cl,ch
	mov	dx,offset Work_Event	; Convient place to save
	call	 _left_set_reel		; The reel

; Prompt for NEW REEL assignment
	mov	bx,offset relchg_ovr
	call	 _msgread
	mov	al,reel_length
	call	cimsg_wrk_FAR
	jz	cra_xit

;;;;	push	bx
relcaps:mov	al,[bx]
	or	al,al
	jz	relcapx
	call	 _make_ucase
	mov	[bx],al
	inc	bx
	jmp	relcaps

cra_xit:ret

; Tell the folks that we're busy
relcapx:call	 _working

;Change all reels found to match [Work_Event] to [Temp_Wrkspce]
	mov	ax,es:Current_Event
	push	ax
	mov	ax,1			; Start with first event
relchl:	call	 _index_storage
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT
	jz	relchl0
	cmp	es:byte ptr cmnt_lofst[bx],Editline_REC
	jb	relchl1			; Skip other types of lines

relchl0:call	 _getlast_reel		; (CX destroyed by this
	mov	dx,offset Work_Event	; REEL TO CHANGE
	mov	ch,reel_length
	call	 _cmpchr
	jnz	relchl1

	mov	dx,bx			; DX points to destination
	mov	bx,offset Temp_Wrkspce	; point to NEW REEL
	call	 _left_set2edl		; Put it there

relchl1:mov	bx,offset Current_Event
	inc	word ptr es:[bx]
	mov	ax,es:[bx]
	mov	bx,offset Next_Avail_Num
	cmp	ax,es:[bx]
	jc	relchl
	pop	ax			; Restore event number
	call	 _event_display
	ret
_Change_Reel_Assignments	endp



;................................................................
_edltype_display	proc	far
	push	si
	push	di
	call	 _help_pos
	norm_VIDEO FALSE,FALSE
	cmp	Fterr_Flg,0ffh
	jnz	edltd0
	mov	bx,offset badftyp_ovr
	call	 _MsgCntr
	call	 _error_bell

edltd0:	mov	Cursor, offset List_Scr + 100h
	mov	bx,offset selectedlf_ovr
	call	 _MsgCntr

	mov	bx,offset List_Scr + 200h
	mov	dx,offset List_Scr + 750h
	dim_VIDEO FALSE,FALSE
	call	 _DrawBox

	mov	di,offset List_Scr + 302h

	xor	cl,cl
	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset exitshort_ovr
	call	 _msgread

	mov	si,offset Edl_Formats	; SI has table position
	mov	bx,offset NumberOfEdlFormats
	mov	ch,bl
	mov	dx,0001h	; DH = column counter, DL = line counter

	push	di
	add	di,100h
edltdlp:call	M6_d1_1
	dec	ch
	jz	edltfin
	inc	dl
	cmp	dl,4
	jb	edltdlp
	pop	di
	add	di,28
	push	di
	inc	dh
	xor	dl,dl
	jmp	edltdlp
edltfin:pop	di
	pop	di
	pop	si
	ret
_edltype_display	endp

M6_d1_1	proc	near
	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,si
	add	bx,offset ZeroBase.E_edl_Name
	call	 _comsg
	add	si,edlfmt_hdrlen	; Go to next listing
	add	di,100h
	or	di,di			; Set NZ
M6_d1_x:ret
M6_d1_1	endp

; Save and restore line in Temp_Wrkspce
_INSTL_lsave	proc	far
	mov	bx,offset Temp_Wrkspce
	mov	dx,offset Work_Event
	jmp	ml_sr
_INSTL_lsave	endp
_INSTL_lrest	proc	far
	mov	dx,offset Temp_Wrkspce
	mov	bx,offset Work_Event
ml_sr:	mov	ch,96
	call	 _mmv
	ret
_INSTL_lrest	endp





; Displays menu for altering frame accuracy windows
_m16_dsp	proc	far
	push	cx
	call	 _help_pos
	mov	di,PointShootData.PQ_Cursor
	xor	cl,cl

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset exitmenu_ovr
	call	 _msgread
	add	di,100h

	mov	ch,MAX_MACHINES			; Do for 4 VTRs and RECORD
	mov	si,offset Vtrcb + Vtrcb_length	; Start with A-vtr

m16_dlp:mov	Cursor,di
	call	 _dashit_cl
	call	 FAR PTR _m16_prmpt
	cmp	ch,1				; down to record?
	jnz	m16_d1
	mov	si,offset Vtrcb			; For record machine
m16_d1:	mov	al,[si.Vtrcb_WINDOW]
	cmp	al,10
	jnc	m16d2
	call	 _Space_Out
m16d2:	norm_VIDEO FALSE,TRUE
	call	 _A_DecOut
	call	 _Space_Out
	dim_VIDEO FALSE,FALSE
	mov	bx,offset Frame_Msg
	call	 _comsg
	add	di,100h
	add	si,Vtrcb_length
	dec	ch
	jnz	m16_dlp

	mov	bx,offset Retry_Count_ovr ; Message
	mov	si,offset Retry_Count	; Byte storage pointer
	mov	al,6			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

	pop	cx
	ret
_m16_dsp	endp

_m16_prmpt	proc	far
	mov	bx,offset slop_factor_ovr
	call	 _msgread
	norm_VIDEO FALSE,FALSE
	cmp	ch,1
	jnz	m16_p1
	xor	al,al
	jmp	m16_p2
m16_p1:	mov	al,cl
	dec	al
m16_p2:	call	 _machine_disp
	dim_VIDEO FALSE,FALSE
	mov	al,':'
	call	 _ConOut
	inc	Cursor
	inc	Cursor
	mov	al,241				; +/-
	call	 _ConOut
	call	 _Space_Out
	ret
_m16_prmpt	endp


_m21_dsp	proc	far
	call	 _help_pos
	xor	cl,cl
	mov	di,offset List_Scr + 10ah

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset exitmenu_ovr
	call	 _msgread
	add	di,100h

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset Logd_Msg
	call	 _comsg
	norm_VIDEO FALSE,FALSE
	mov	bx,offset EDL_Subdir
	call	 _comsg
	add	di,100h

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset Logauto_Msg
	call	 _comsg
	norm_VIDEO FALSE,FALSE
	mov	bx,offset AUTOFILE_Subdir
	call	 _comsg
	add	di,100h

;...
	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset Logtcm_Msg
	call	 _comsg
	norm_VIDEO FALSE,FALSE
	mov	bx,offset TCM_Subdir
	call	 _comsg
	add	di,100h

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset Logvme_Msg
	call	 _comsg
	norm_VIDEO FALSE,FALSE
	mov	bx,offset VME_Subdir
	call	 _comsg
	add	di,100h

;...

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset fext_ovr
	call	 _msgread
	mov	bx,di
	add	bl,28
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Edl_Ext
	call	 _comsg
	add	di,100h

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset Logtmp_Msg
	call	 _comsg
	norm_VIDEO FALSE,FALSE
	mov	bx,offset TMP_Subdir
	call	 _comsg
	ret
_m21_dsp	endp




;================================================================
; Get and display machine key, Carry set if Break
; Enter: BX points to request message for screen
; Exit with: AL=
;		0ffh	video
;		0feh	audio
;		0fdh	gpi
;		0fch	VVV
; Also returns on and with:
;		Cue_xcmd
_getmkey	proc	far
	call	 _msgread
_getmkey	endp

_getmkag	proc	far
	call	rdchar_FAR		; Get a keypress
	cmp	ax,offset Vidsel_xcmd	; Check for a video request
	jz	getmkv
	cmp	ax,offset Au1sel_xcmd	; Check for a audio request
	jz	getmka
	cmp	ax,offset Au2sel_xcmd	; Check for a audio request
	jz	getmka
	cmp	ax,offset Clrrd_xcmd
	jz	getmkc
	cmp	ax,offset GPI_xcmd	; Check for GPI request
	jz	getmkg
	cmp	ax,offset Rehearse_xcmd	; Check for PREV switcher
	jz	getmkp

	cmp	ax,offset Gotoin_xcmd	;
	jz	getmkzx

	cmp	ax,offset Rm_xcmd	; Record machine:
	jz	getmkr			; Jump if so (R not recognized
	call	 _Break_check		;  by the _machine_keys routine
	jz	getmkz
	cmp	ax,offset Enter_xcmd
	jz	getmkz
	call	 _machine_keys
	jz	getmk1
	call	 _chimes
	jmps	_getmkag

getmkc:	mov	al,0f1h			; Signal CLEAR
	ret

getmkp:	mov	al,0fch			; Signal VVV
	ret

getmkg:	mov	al,0fdh			; Signal GPI
	ret

getmka:	mov	bx,offset Split_Aud_Msg
	mov	al,0feh			; Signal Audio
	jmp	getmkav
getmkv:	mov	bx,offset Split_Vid_Msg
	mov	al,0ffh			; Signal Video
getmkav:call	 _comsg
	clc
getmkzx:ret

getmkr:	xor	al,al
getmk1:	call	 _machine_disp
	call	 _Space_Out
	clc
	ret

getmkz:	call	 _screen_init_FAR
	stc
	ret
_getmkag	endp


;================================================================
; Display default (current) BX setting as [xx]
_default_val	proc	far
	dim_VIDEO FALSE,FALSE
	mov	al,'['
	call	 _ConOut
	norm_VIDEO FALSE,FALSE
	call	 _DecOut
	call	rhtbrkt
	ret
_default_val	endp

_default_char	proc	far
	push	ax
	push	ax
	dim_VIDEO FALSE,FALSE
	mov	al,'['
	call	 _ConOut
	norm_VIDEO FALSE,FALSE
	pop	ax
	call	 _ConOut
	call	rhtbrkt
	pop	ax
	ret
_default_char	endp


rhtbrkt:dim_VIDEO FALSE,FALSE
	mov	al,']'
	call	 _ConOut
	norm_VIDEO FALSE,FALSE
	mov	al,' '
	call	 _ConOut
	call	 _ConOut
	ret

;================================================================
; INSTALL 1 MENU CARD
_M1_CARD	proc	far
	call	 _DrawMenuBox
	mov	di,PointShootData.PQ_Cursor	; Screen position
	xor	cl,cl				; Clear number counter

	xor	si,si
	mov	dx,offset exitmenu_ovr
	call	INSTL_PQdisplay
	add	di,100h
	mov	si,offset Preroll
	mov	dx,offset Preroll_rqst
	call	INSTL_PQdisplay
	mov	si,offset Postroll
	mov	dx,offset Postroll_rqst		; Display prompt
	call	INSTL_PQdisplay
	mov	si,offset Recordpost
	mov	dx,offset recpost_rqst		; Display prompt
	call	INSTL_PQdisplay

	mov	si,offset Timelineroll
	mov	dx,offset tlineroll_rqst
	call	INSTL_PQdisplay

	call	MoveCursorToNextColumn

	mov	ch,PointShootData.PQ_field	; Get field length
	sub	ch,7	;10
	mov	bx,offset DelayRoll_ovr
	mov	si,offset Edit_Flags
	mov	ax,delroll_EDBIT
	call	m20_dp

	mov	bx,di
	mov	Cursor,bx
	call	 _dashit_cl
	mov	bx,offset DelEdRoll_ovr
	call	 _msgread

	mov	bx,di
	add	bl,PointShootData.PQ_field	; Get field length
	sub	bl,7	;10
	mov	Cursor,bx

	norm_VIDEO FALSE,FALSE
	mov	al,DelEdRoll_Qrtrs
	call	 _A_DecOut

	add	di,100h
	mov	bx,di

	mov	ch,PointShootData.PQ_field	; Get field length
	sub	ch,7	;10
	mov	bx,offset realtime_ovr
	mov	si,offset Edit_Flags
	mov	ax,realtime_EDBIT
	call	m20_dp

	mov	ch,PointShootData.PQ_field	; Get field length
	sub	ch,7
	mov	bx,offset preread_ovr
	mov	si,offset Edit_Flags
	mov	ax,prdoff_EDBIT
	call	m20_dp
	ret


_M1_CARD	endp

;================================================================
; INSTALL 2 MENU CARD
_M2_CARD	proc	far
	call	 _help_pos
	call	 _DrawMenuBox
	mov	di,PointShootData.PQ_Cursor	; Screen position
	xor	cl,cl				; Clear number counter

	xor	si,si
	mov	dx,offset exitmenu_ovr
	call	INSTL_PQdisplay
	add	di,100h

	mov	si,offset Tcgen_Start
	mov	dx,offset tcgenset_ovr
	call	INSTL_PQdisplay
	mov	Cursor,di

	if NTSC
	call	 _dashit_cl
	mov	bx,offset tcgenmode_ovr
	call	 _msgread
	call	 _Space_Out
	mov	bx,di
	add	bl,39
	mov	Cursor,bx
	mov	al,Tcgen_Mode
	call	 _default_char
	add	di,100h
	endif

	xor	si,si
	mov	dx,offset stripetape_ovr
	call	INSTL_PQdisplay
	ret

_M2_CARD	endp

;================================================================
; INSTALL 3 MENU CARD
_M3_CARD	proc	far
	call	 _DrawMenuBox
	xor	cl,cl
	mov	ch,39				;Tab value for YES/NO
	mov	di,PointShootData.PQ_Cursor
	dim_VIDEO FALSE,FALSE
	mov	bx,offset exitmenu_ovr
	xor	si,si
	call	m20_dp

	mov	bx,offset autofile_ovr
	mov	si,offset Operational_Flags
	mov	ax,diskon_OPBIT
	call	m20_dp
	ret
_M3_CARD	endp


;================================================================
; INSTALL 2 MENU CARD
_M7_CARD	proc	far
	call	 _help_pos
	call	 _DrawMenuBox
	mov	di,PointShootData.PQ_Cursor	; Screen position
	xor	cl,cl				; Clear number counter

	xor	si,si
	mov	dx,offset exitmenu_ovr
	call	INSTL_PQdisplay
	add	di,100h

	mov	bx,offset syscolorframe_ovr	; Message
	mov	si,offset System_Color_Frame	; Byte storage pointer
	mov	al,39			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#
	ret

_M7_CARD	endp

; Displays menu for altering frame accuracy windows
_M8_CARD	proc	far
	push	cx

	call	 _help_pos
	call	 _DrawMenuBox

	mov	di,PointShootData.PQ_Cursor
	xor	cl,cl

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset exitmenu_ovr
	call	 _msgread
	add	di,100h

	mov	ch,MAX_SOURCES			; Do for 4 VTRs and RECORD
	mov	si,offset Vtrcb + Vtrcb_length	; Start with A-vtr

m8_dlp:mov	Cursor,di
	call	 _dashit_cl
	call	 _m8_prmpt
	mov	al,[si.Vtrcb_CF]
	call	 _GetColorFrameMsgAL
	dim_VIDEO FALSE,FALSE
	add	di,100h
	add	si,Vtrcb_length
	dec	ch
	jnz	m8_dlp
	pop	cx
	ret
_M8_CARD	endp



;================================================================
; INSTALL 11 MENU CARD
_M11_CARD	proc	far
	mov	bx,offset List_Scr + 100h
	mov	dx,offset List_Scr + 650h
	dim_VIDEO FALSE,FALSE
	call	 _DrawBox
	mov	cx,2300h			; 35 cols for YES/NO
	mov	di,PointShootData.PQ_Cursor
	dim_VIDEO FALSE,FALSE
	mov	bx,offset exitmenu_ovr
	xor	si,si
	call	m20_dp
	mov	bx,offset autodisable_ovr
	mov	si,offset EDLoptions_Flags
	mov	ax,autdsabl_EDLBIT
	call	m20_dp
	mov	bx,offset slave_store_ovr
	mov	si,offset Slave_Flags
	mov	ax,store_MSBIT ;slave
	call	m20_dp
	mov	bx,offset recripl_store_ovr
	mov	si,offset Edit_Flags
	mov	ax,riplslave_EDBIT
	call	m20_dp

	call	MoveCursorToNextColumn

	mov	bx,offset gpi_store_ovr
	mov	si,offset Gpi_Flags
	mov	ax,store_MSBIT ;gpi
	call	m20_dp
	mov	bx,offset PMC_store_ovr
	mov	si,offset Pmc_Flags
	mov	ax,store_MSBIT ;PMC
	call	m20_dp
	mov	bx,offset SPD_store_ovr
	mov	si,offset Spd_Flags
	mov	ax,store_MSBIT ;SPD
	call	m20_dp
	mov	bx,offset REC_store_ovr
	mov	si,offset MultRec_Flags
	mov	ax,store_MSBIT
	call	m20_dp
	ret
_M11_CARD	endp


;================================================================
; INSTALL 11 MENU CARD
_M12_CARD	proc	far
	call	 _help_pos
	call	 _DrawMenuBox
	mov	di,PointShootData.PQ_Cursor		; Screen position
	xor	cl,cl			; Clear number counter
	mov	ch,39				;Tab value for YES/NO
	mov	bx,offset exitmenu_ovr
	xor	si,si
	call	m20_dp

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset asmmode_ovr
	call	 _msgread
	call	 _Space_Out
	mov	bx,di
	add	bl,37
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	al,Assembly_Mode
	call	 _ConOut
	mov	bx,offset Mode_Msg
	call	 _comsg
	add	di,100h

	mov	bx,offset lookahead_ovr
	mov	si,offset Operational_Flags
	mov	ax,lookahead_OPBIT
	call	m20_dp

	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset lookcount_ovr
	call	 _msgread
	mov	bx,di
	add	bl,39	;50
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	bx,Edits_To_Look_Ahead
	call	 _DecOut
	ret
_M12_CARD	endp



;================================================================
; INSTALL 19 MENU CARD
_M19_CARD	proc	far
	call	 _help_pos
	dim_VIDEO FALSE,FALSE
	xor	cl,cl
	mov	di, PointShootData.PQ_Cursor

	mov	bx,offset exitmenu_ovr
	xor	si,si
	mov	ch,34
	call	m20_dp

	mov	bx,offset menu_ovr
	mov	si,offset DOS_Flags
	mov	ax,usemenu_DOSBIT
	call	m20_dp
	mov	bx,offset ejectpage_ovr
	mov	si,offset DOS_Flags
	mov	ax,ejectpg_DOSBIT
	call	m20_dp
	ret
_M19_CARD	endp

;================================================================
; INSTALL 20 MENU CARD
; Display all options for SCREEN/SOUND DEFAULTS
_M20_CARD	proc	far
	call	 _help_pos
	dim_VIDEO FALSE,FALSE
	xor	cl,cl
	mov	di, PointShootData.PQ_Cursor
;1
	mov	bx,offset exitmenu_ovr
	xor	si,si
	mov	ch,34
	call	m20_dp
;2
	mov	bx,offset screengrid_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,border_SDBIT
	call	m20_dp
;3
	mov	bx,offset lastkey_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,lastkey_SDBIT
	call	m20_dp
;4
	mov	bx,offset recheck_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,recheck_SDBIT
	call	m20_dp
;5
	mov	bx,offset disptype_ovr
	mov	si,offset EDLoptions_Flags
	mov	ax,modedisp_EDLBIT
	call	m20_dp

;6
	mov	bx,offset  modetype_ovr
	mov	si,offset EDLoptions_Flags
	mov	ax,modetype_EDLBIT
	call	m20_dp

;7
	mov	bx,offset beltogl_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,bell_SDBIT
	call	m20_dp

	mov	di, PointShootData.PQ_Cursor
	mov	bl,PointShootData.PQ_tab
	mov	bh,0
	add	di,bx

;8
	mov	bx,offset errbell_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,errbell_SDBIT
	call	m20_dp
;9
	mov	bx,offset timedisplay_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,timedate_SDBIT
	call	m20_dp

;10
	if NTSC
	mov	bx,offset durfcm_ovr
	mov	si,offset Network_Flags
	mov	ax,DFdur_NTBIT
	call	m20_dp
	ENDIF

;11
	mov	bx,offset brate_ovr	; Message
	mov	si,offset Blink_Time	; Byte storage pointer
	mov	al,36			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;12
	mov	bx,offset edltrack_ovr	; Message
	mov	si,offset Edltrack_Delay; Byte storage pointer
	mov	al,36			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;13
	mov	bx,offset sortdirs_ovr
	mov	si,offset Sounddisplay_Flags
	mov	ax,sortedls_SDBIT
	call	m20_dp

	ret
_M20_CARD	endp

;================================================================
; INSTALL 22 MENU CARD 
_M22_CARD	proc	far
	xor	cl,cl
	dim_VIDEO FALSE,FALSE
	mov	ch,50

	mov	di,offset List_Scr + 105h
	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset exitmenu_ovr
	call	 _msgread
	add	di,100h

	mov	bx,offset rptoggle_ovr
	mov	si,offset Network_Flags
	mov	ax,rptoggle_NTBIT
	call	m20_dp
	mov	bx,offset pauseplay_ovr
	mov	si,offset Network_Flags
	mov	ax,pauseplay_NTBIT
	call	m20_dp

	mov	bp,Wild1
	mov	si,offset Wild_Msg
	mov	dl,1
	call	m22_cmd
	mov	bp,Wild2
	mov	dl,2
	call	m22_cmd
	mov	bp,Joykey1
	mov	si,offset Joggerkey_Msg
	mov	dl,1
	call	m22_cmd
	mov	bp,Joykey2
	mov	dl,2
	call	m22_cmd
	ret

_M22_CARD	endp


;================================================================
; INSTALL 23 MENU CARD
; Display all options for JOGGER
_M23_CARD	proc	far
	call	 _help_pos
	dim_VIDEO FALSE,FALSE
	xor	cl,cl
	mov	di,offset List_Scr + 213h

	mov	bx,offset exitmenu_ovr
	xor	si,si
	mov	ch,34
	call	m20_dp

	mov	bx,offset usejstick_ovr
	mov	si,offset Network_Flags
	mov	ax,joystick_NTBIT
	call	m20_dp

	mov	bx,offset useJogger_ovr
	mov	si,offset Network_Flags
	mov	ax,Jogger_NTBIT
	call	m20_dp

	mov	bx,offset shuttlesense_ovr	; Message
	mov	si,offset ShuttleSensitivity	; Byte storage pointer
	mov	al,34			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#


	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,offset JoggerIRQ_ovr
	call	 _msgread
	mov	bx,di
	add	bl,34
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	ax,JoggerIRQ	; Get IRQ Interrupt table address
	call	 _BitCountReset
nocirq:	call	 _A_DecOut
	add	di,100h

	ret

_M23_CARD	endp


;================================================================
; INSTALL 2 MENU CARD
_M27_CARD	proc	far
	call	 _help_pos
	call	 _DrawMenuBox
	mov	di,PointShootData.PQ_Cursor	; Screen position
	xor	cl,cl				; Clear number counter
	mov	ch,34

;1
	xor	si,si
	mov	dx,offset exitmenu_ovr
	call	INSTL_PQdisplay
	add	di,100h
;2
	mov	bx,offset efxadr_ovr	; Message
	mov	si,offset Effects_Address	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;3
	mov	bx,offset upstrkey_ovr	; Message
	mov	si,offset Upstream_Keynumber	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#
;4
	mov	bx,offset dnstrkey_ovr	; Message
	mov	si,offset Dnstream_Keynumber	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#
;5
	mov	bx,offset ememefxadr_ovr; Message
	mov	si,offset Emem_Efxadr	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#
;6
	mov	bx,offset wipemods_ovr
	mov	si,offset Switcher_Flags
	mov	ax,wipemods_SWBIT
	call	m20_dp

;7
	mov	bx,offset forcev3_ovr
	mov	si,offset VLAN_Flags
	mov	ax,forcever3_VLNBIT
	call	m20_dp

;Go to next column
	call	MoveCursorToNextColumn

;8
	mov	bx,offset extmenu_ovr
	mov	si,offset Switcher_Flags
	mov	ax,extmenu_SWBIT
	call	m20_dp

;9
	mov	bx,offset audefxadr_ovr	; Message
	mov	si,offset Audio_Effects_Address	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;10
	mov	bx,offset vidbase_ovr	; Message
	mov	si,offset VlanVideoPort	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;11
	mov	bx,offset vidbase2_ovr	; Message
	mov	si,offset VlanVideoPort2; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;12
	mov	bx,offset audbase_ovr	; Message
	mov	si,offset VlanAudioPort	; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;13
	mov	bx,offset pvwbase_ovr	; Message
	mov	si,offset VlanPreviewPort ; Byte storage pointer
	mov	al,ch			; Offset of status
	call	DisplayPromptsDigits	; DI also has cursor, CL has selection#

;14
	mov	bx,di
	mov	Cursor,bx
	call	 _dashit_cl
	mov	bx,offset swtgl_ovr
	call	 _msgread
	ret

_M27_CARD	endp

; DI HAS Cursor
m22_cmd	proc	near
	push	si
	mov	Cursor,di
	call	 _dashit_cl
	mov	bx,si
	call	 _comsg
	mov	al,dl
	call	 _A_DecOut
	mov	bx,di
	add	bl,50
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	ax,bp
	call	 _GetKeyName
	jnz	m22_1b

	mov	bx,offset Nowild_Msg
	call	 _comsg
	push	cx		; 6-02-1992  Fixed crash situation
	jmp	m22erx

m22_1b:	push	cx
	mov	cx,16
	push	es
	mov	es,Msg_Seg
m22_1c:	mov	al,es:[bx]
	cmp	al,' '
	jnz	m22clp
	inc	bx
	loop	m22_1c
	pop	cx
	pop	si
	ret

m22clp:	mov	al,es:[bx]
	inc	bx
	call	 _ConOut
	loop	m22clp
	pop	es
m22erx:
	add	di,100h
	pop	cx
	pop	si
	ret
m22_cmd	endp

;================================================================
; Display option request menu item
; ENTER:	cl = Choice number
;		di = Cursor
;		si = pointer to byte Flag
;		al = bit mask
;		bx = pointer to prompt message
m20_dp	proc	near
	mov	Cursor,di
	push	ax
	call	 _dashit_cl
	call	 _msgread
	pop	ax
	mov	bx,di
	add	bl,ch
	mov	Cursor,bx
	norm_VIDEO FALSE,TRUE
	mov	bx,offset Threedots_Msg
	or	si,si
	jz	m20_dpi
	mov	bx,offset No_Msg
	test	[si],al
	jz	m20_dpi
	mov	bx,offset Yes_Msg
m20_dpi:add	di,100h
	call	 _comsg
	ret
m20_dp	endp

;================================================================
; Display PQ type choice,
; DI = Cursor
; DX = menu/prompting string terminated with null byte
; SI = pointer to 24bit time code value
INSTL_PQdisplay	proc	near
	mov	Cursor,di			; Set Cursor
	mov	bx,dx
	call	 _dashit_cl
	or	si,si
	jnz	INSTL_PQdisplayb
	call	 _msgread
	ret

INSTL_PQdisplayb:
	call	 _msgread
	norm_VIDEO FALSE,FALSE
	mov	bx,di
	add	bl,PointShootData.PQ_field		; Get field length
	sub	bl,12
	mov	Cursor,bx

MPQd1:	push	di
	push	cx
	mov	bx,si
	mov	cl,NDF_CHAR		; Changed from DF_CHAR 4-05-1991
	mov	dx,offset Tcdispbuf
	call	 _cnvt2tc_DS
	call	tcprty0_FAR
	pop	cx
	pop	di
	add	di,100h
	ret

INSTL_PQdisplay	endp


MoveCursorToNextColumn proc	near
	mov	di,PointShootData.PQ_Cursor
	mov	al,PointShootData.PQ_tab
	mov	ah,0
	add	di,ax
	ret
MoveCursorToNextColumn endp

; Enter:
;	bx	Pointer to Message
;	si	Byte storage pointer
;	al	Offset of status
;	DI	has cursor
;	CL	has selection #
DisplayPromptsDigits	proc	near
	push	ax
	mov	Cursor,di
	call	 _dashit_cl
	call	 _msgread
	mov	bx,di
	pop	ax
	add	bl,al
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	al,[si]
	call	 _A_DecOut
	add	di,100h
	ret
DisplayPromptsDigits	endp



;================================================================
	if DEBUGGER
_Debugger	proc	far
	call	 _help_pos
	mov	es,Edl_Seg

debuger:mov	bx,offset Lastline_Scr
	call	 _dircur_lerase
	rev_VIDEO FALSE,FALSE
	mov	bx,offset debugkeys_ovr
	call	 _msgread

debugl0:mov	bx,Debug_Pntr
	call	debugl1

debugl3:push	es
	call	rdchar_FAR
	pop	es
	call	 _make_ucase
	call	 _Break_check
	jz	dbg_Exit
	cmp	al,cr
	jz	dbg_Exit

	cmp	ax,offset End_key
	jz	dbg_next
	cmp	ax,offset Home_key
	jz	dbg_last
	cmp	ax,offset F2_key
	jz	dgb_p0001
	cmp	ax,offset F4_key
	jz	dgb_p0010
	cmp	ax,offset Pagedn_key
	jz	dgb_p0080
	cmp	ax,offset F6_key
	jz	dgb_p0100
	cmp	ax,offset F8_key
	jz	dgb_p1000
	cmp	ax,offset F1_key
	jz	dgb_m0001
	cmp	ax,offset F3_key
	jz	dgb_m0010
	cmp	ax,offset Pageup_key
	jz	dgb_m0080
	cmp	ax,offset F5_key
	jz	dgb_m0100
	cmp	ax,offset F7_key
	jz	dgb_m1000
	cmp	ax,offset F9_key		; Modify
	jnz	debugl4
	jmp	dgbmod
debugl4:cmp	ax,offset F10_key		; Set address
	jnz	debugl3
	call	dbgadr
	jmp	debuger

dbg_Exit:
	mov	es,Edl_Seg
	call	 _help_pos
	call	 _evnt_dispthis
	ret

dbg_next:
	mov	dx,line_length
	jmp	dbgplus
dgb_p0001:
	mov	dx,1
	jmp	dbgplus
dgb_p0010:
	mov	dx,10h
	jmp	dbgplus
dgb_p0080:
	mov	dx,80h
	jmp	dbgplus
dgb_p0100:
	mov	dx,100h
	jmp	dbgplus
dgb_p1000:
	mov	dx,1000h
	jmp	dbgplus
dbg_last:
	mov	dx,line_length
	jmp	dbgminus
dgb_m0001:
	mov	dx,1
	jmp	dbgminus
dgb_m0010:
	mov	dx,10h
	jmp	dbgminus
dgb_m0080:
	mov	dx,80h
	jmp	dbgminus
dgb_m0100:
	mov	dx,100h
	jmp	dbgminus
dgb_m1000:
	mov	dx,1000h
dbgminus:
	mov	bx,Debug_Pntr
	sub	bx,dx
	jmp	debugrc
dbgplus:mov	bx,Debug_Pntr
	add	bx,dx

debugrc:mov	Debug_Pntr,bx
	jmp	debugl0


;Modify
dgbmod:	mov	bx,offset List_Scr		;Lastline_Scr
	add	bl,10			;Offset to first byte
	mov	Cursor,bx
	push	bx
	call	hilight_two
	pop	bx
	add	bl,49
	mov	Cursor,bx
	call	hilight_one

	mov	bx,offset Lastline_Scr
	call	 _dircur_lerase
	mov	bx,offset dbgbyt_ovr
	call	 _msgread
	mov	al,2			; BX = address
	call	cimsg_wrk_FAR
	cmp	al,2
	jnc	JL1450
	jmp	_Debugger

JL1450:	call	 _hex2bn
	mov	bx,Debug_Pntr
	mov	es:[bx],al
	inc	bx
	mov	Debug_Pntr,bx
	call	debugl1
	jmp	dgbmod
_Debugger	endp

;----------------------------------------------------------------
; Display a hex line
debugl1	proc	near
	call	 _Cursor_off
	mov	Debug_Pntr,bx
	mov	Cursor,offset List_Scr			;Lastline_Scr
	mov	cx,8
dbgmlp:	push	cx
	call	debug_line
	call	 _crlf
	pop	cx
	loop	dbgmlp
	call	 _line_erase
	call	 _error_redisplay
	ret
debugl1	endp

debug_line	proc	near
	push	bx
	dim_VIDEO FALSE,FALSE
	push	bx
	mov	bx,es
	call	 _dhw
	mov	al,':'
	call	 _ConOut
	pop	bx
	call	 _dhw
	call	 _Space_Out
	norm_VIDEO FALSE,FALSE
	pop	bx
	push	bx
	mov	ch,16
debugl2:mov	al,es:[bx]
	inc	bx
	call	 _dhb
	call	 _Space_Out
	dec	ch
	jnz	debugl2

	call	 _Space_Out
	pop	bx
	mov	ch,16
debuga1:mov	al,es:[bx]
	inc	bx
	cmp	al,80h
	jnc	debuga2
	cmp	al,' '
	jnc	debuga3
debuga2:mov	al,'.'
debuga3:call	 _ConOut
	dec	ch
	jnz	debuga1
	call	 _Space_Out
	call	 _line_erase
	ret
debug_line	endp

;Enter	H = ASCII MSB
;	L = ASCII LSB
;Set new debug address
dbgadr	proc	near
	mov	bx,offset Lastline_Scr
	call	 _dircur_lerase
	mov	bx,offset dbgadr_ovr
	call	 _msgread
	mov	al,7		;SS:AAAA
	call	cimsg_wrk_FAR
	cmp	al,3
	jnc	dbgadra
	ret

dbgadra:mov	al,2[bx]	;Get third character
	cmp	al,':'		; Do we have a colon?
	jnz	dbgadr1		;Skip if not

	mov	al,[bx]
	call	 _make_ucase
	cmp	al,'C'
	jz	dbg_CS
	cmp	al,'D'
	jz	dbg_DS
	cmp	al,'E'
	jz	dbg_ES
	cmp	al,'S'
	jz	dbg_SS
	ret

dbg_ES:	mov	dx,Edl_Seg
	jmp	dbgadr0

dbg_DS:	mov	dx,ds
	jmp	dbgadr0

dbg_CS:	mov	dx,cs
	jmp	dbgadr0

dbg_SS:	mov	dx,ss
	mov	Debug_Pntr,sp

dbgadr0:mov	es,dx			; Set new pointer
	inc	bx
	inc	bx
	inc	bx
	mov	al,[bx]
	call	 _make_ucase
	or	al,al
	jnz	dbgaa
	ret
dbgaa:	cmp	al,cr
	jnz	dbgadr1
	ret

dbgadr1:call	 _hex2bn
	mov	dh,al
	call	 _hex2bn
	mov	dl,al
	mov	Debug_Pntr,dx
	ret
dbgadr	endp

hilight_two:
	push	bx
	call	place_Cursor
	mov	ah,8
	mov	bh,0
	int	10h
	mov	ch,al			; Save first character
	call	 _Space_Out
	call	place_Cursor
	mov	ah,8
	mov	bh,0
	push	cx
	int	10h
	pop	cx
	mov	cl,al			; Save second char
	pop	bx
	mov	Cursor,bx
	rev_VIDEO FALSE,FALSE
	mov	al,ch
	call	 _ConOut
	mov	al,cl
	call	 _ConOut
	ret

hilight_one:
	call	place_Cursor
	mov	ah,8
	mov	bh,0
	int	10h
	rev_VIDEO FALSE,TRUE
	call	 _ConOut
	ret

place_Cursor:
	push	bx			; Update Cursor position
	push	dx
	mov	dx,Cursor
	mov	bh,0
	mov	ah,2
	int	10h
	pop	dx
	pop	bx
	ret

	endif

_hex2bn	proc	far
	inc	bx
	mov	al,[bx]
	call	 _make_ucase
	call	a2hex
	mov	ch,al
	dec	bx
	mov	al,[bx]
	call	 _make_ucase
	inc	bx
	inc	bx
	call	a2hex
	rol	al,1
	rol	al,1
	rol	al,1
	rol	al,1
	or	al,ch
	ret
_hex2bn	endp

a2hex	proc	near
	sub	al,'0'
	cmp	al,10
	jc	a2hexr
	sub	al,7
a2hexr:	ret
a2hex	endp

;================================================================
; Security
;============================================
; Quick OR mode check just to get the Port
;============================================
_K_GetPort	proc	far
	mov	bx, offset Port		;load base address
	mov	dx,[bx]			;dx now = LPT1 ROM pointer

; Power up the Activator
K_nextport:
	mov	Nport,dx		;get K_next Port value
	mov	al,128			;Power with reset
	out	dx,al			;Power up Activator

	call	 _delbrk		; Approx 5 ms delay
K_delay:xor	cx,cx			;zero out counter
	mov	al,192			;Power w/o reset
	out	dx,al			;out the Port

	;================================
	; Count Counter A down to zero
	;================================

	push	bx			;save base pointer

	mov	bx,offset CtrTable	;load the counters
	add	bx,Seloffset
	mov	bx,[bx]
	mov	cl,[bx]			;load counter A to cx low

	pop	bx			;restore base pointer

Count_A:mov	si,offset SelTable
	add	si,Seloffset		;load the selectors
	mov	si,[si]
	mov	al,[si]			;Count counter A to zero
	xor	al,32			;exclusive or selector A
	call	K_byte_out
	loop	Count_A			;do it again

	;================================
	; Check for Acknowledge
	;
	; Counter A = 0 in DOWN dir
	; Mode = AND
	;
	; Activator should not be found:
	; yet !!
	;================================
	call	K_byte_test
	jz	K_another		;we have FALSE Ack !!!!!!!

	;================================
	; Toggle to OR mode
	;================================
	mov	al,[si+3]
	xor	al,32			;exclusive or selector T
	call	K_byte_out

	;================================
	; Check for Acknowledge
	; Counter A = 0 in DOWN dir, Mode = OR
	;================================
	call	K_byte_test
	jz	K_done			;Yes, we have found it !
K_another:
	mov	Nport,0			;did'nt find it
	add	bx,2			;K_next Port
	mov	dx, word ptr [bx]	;load K_next Port address
	cmp	dx,0			;is it a valid Port ?
	je	K_done			;no it's not !
	jmp	K_nextport		;We have a valid Port address
K_done:	ret
_K_GetPort	endp

; Security
;============================================
; This routine will stop them !!
;============================================
_CompleteCheck	proc	far
	mov	dx,Nport		;Port the Activator is on
	mov	bx,offset CtrTable	;load the counters
	add	bx,Seloffset		;load the counters
	mov	bx,[bx]
	mov	si,offset SelTable	;load the selectors
	add	si,Seloffset		;load the selectors
	mov	si,[si]

; Power up the Activator
	mov	al,128			;Power no reset
	out	dx,al			;Power up Activator
	call	 _delbrk
K_delay2:
	xor	cx,cx			;zero out counter
	mov	al,192			;Power w/o reset
	out	dx,al			;out the Port

	mov	cl,[bx]			;load counter A to cx low

; Count Counter A down to zero
Count_A_:
	mov	al,[si]			;Count counter A to zero
	xor	al,32			;exclusive or selector A
	call	K_byte_out
	loop	Count_A_		;do it again

	;================================
	;   Activator NOT Found
	;
	; Counter A = 0   DOWN
	; Counter B = 7   DOWN
	; Counter C = 11  DOWN
	;
	;     Mode = AND
	;================================

	call	K_byte_test
	jnz	K_next			;If Ack then Exit
	jmp	_HackerHere

K_next:	add	Flag1,1			;Set Flag1 to TRUE

; Toggle to OR mode
	mov	al,[si+3]
	xor	al,32			;exclusive or selector T
	call	K_byte_out

	;================================
	;   Activator Found
	;
	; Counter A = 0   DOWN
	; Counter B = 7   DOWN
	; Counter C = 11  DOWN
	;
	;     Mode = OR
	;================================

	call	K_byte_test
	jz	K_next1			;If no Ack then Exit
	jmp	_HackerHere

; Toggle ctr A to UP Direction
K_next1:mov	al,[si]
	call	K_byte_out

	;================================
	;   Activator NOT Found
	;
	; Counter A = 0   UP
	; Counter B = 7   DOWN
	; Counter C = 11  DOWN
	;
	;     Mode = AND
	;================================
	call	K_byte_test
	jnz	K_next2			;If Ack then Exit
	jmp	_HackerHere

K_next2:add	Flag2,1			;Set Flag2 to TRUE

	;================================
	; Toggle ctr B to UP Direction
	;================================

	mov	al,[si+1]		;selector B
	call	K_byte_out

; Count Counter B UP to 63
	xor	ax,ax			;zero out accumulator
	xor	cx,cx			;zero out counter
	mov	al,[bx+1]		;load counter B to cx low
	mov	cl,63
	sub	cl,al			;number of times to 63

Count_B_:
	mov	al,[si+1]		;Count counter A to zero
	xor	al,32			;exclusive or selector A
	call	K_byte_out
	loop	Count_B_		;do it again

	;================================
	;   Activator Found
	;
	; Counter A = 0   UP
	; Counter B = 63  UP
	; Counter C = 11  DOWN
	;
	;     Mode = OR
	;================================

	call	K_byte_test
	jz	K_next3			;If no Ack then Exit
	jmp	_HackerHere

K_next3:
	add	Flag3,1			;Set Flag3 to TRUE

; Toggle ctr B to DOWN Direction
	mov	al,[si+1]		;selector B
	call	K_byte_out

	;================================
	;   Activator NOT Found
	;
	; Counter A = 0   UP
	; Counter B = 63  DOWN
	; Counter C = 11  DOWN
	;
	;     Mode = AND
	;================================

	call	K_byte_test
	jnz	K_next4			;If Ack then Exit
	jmp	_HackerHere


; Toggle ctr C to DOWN Direction
K_next4:
	mov	al,[si+2]		;selector C
	call	K_byte_out

; Count Counter B UP to 63
	xor	ax,ax			;zero out accumulator
	xor	cx,cx			;zero out counter
	mov	al,[bx+2]		;load counter C to al low
	mov	cl,63
	sub	cl,al			;number of times to 63

Count_C_:
	mov	al,[si+2]		;Count counter A to zero
	xor	al,32			;exclusive or selector A
	call	K_byte_out
	loop	Count_C_		;do it again

	add	Flag4,1			;Set Flag4 to TRUE

	;================================
	;   Activator Found
	;
	; Counter A = 0   UP
	; Counter B = 63  DOWN
	; Counter C = 63  UP
	;
	;     Mode = OR
	;================================

	call	K_byte_test
	jz	K_next5			;If no Ack then Exit
	jmp	_HackerHere

; Toggle back to AND mode
K_next5:mov	al,[si+3]
	xor	al,32			;exclusive or selector T
	call	K_byte_out

	;================================
	;   Activator NOT Found
	;
	; Counter A = 0   UP
	; Counter B = 63  DOWN
	; Counter C = 63  UP
	;
	;     Mode = AND
	;================================

	call	K_byte_test
	jnz	K_next6			;If Ack then Exit
	jmp	_HackerHere

	;==================================
	; Toggle ctr A to DOWN Direction
	;==================================

K_next6:mov	al,[si]
	call	K_byte_out

; Toggle ctr B to UP	Direction
	mov	al,[si+1]
	call	K_byte_out

	;================================
	;   Activator Found
	;
	; Counter A = 0   DOWN
	; Counter B = 63  UP
	; Counter C = 63  UP
	;
	;     Mode = AND
	;================================

	call	K_byte_test
	jz	K_next7			;If no Ack then Exit
	jmp	_HackerHere

; Toggle ctr B to DOWN Direction
K_next7:mov	al,[si+1]
	call	K_byte_out

	;================================
	;   Activator NOT Found
	;
	; Counter A = 0   UP
	; Counter B = 63  DOWN
	; Counter C = 63  UP
	;
	;     Mode = AND
	;================================

	call	K_byte_test
	jnz	K_next8			;If Ack then Exit
	jmp	_HackerHere

K_next8:add	Flag5,1			;Set Flag5 to TRUE
	ret
_CompleteCheck	endp

;................................................................
; Utility routines
K_byte_test:
	mov	al,224			;Power w/o reset
	out	dx,al			;clock it in
	inc	dx			;Port + 1 = Status

	call	 _delbrk
K_tdly:	in	al,dx			;read status (Port+1)
	push	ax			;save status
	dec	dx			;restore Port
	mov	al,192			;remove ack
	out	dx,al			;send it out the Port
	pop	ax			;pop off status
	and	al,64			;bitwise AND the Ack signal
	ret

; Send AL byte out to activator
K_byte_out:
	add	al,192			;add power w/o reset
	out	dx,al			;decrement counter A by one
	mov	al,192			;Power w/o reset
	out	dx,al			;clock it in
	ret

_HackerHere	proc	far
	jmp	hackerishere
_HackerHere	endp

BSEG	ends

_DATA	segment	byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
