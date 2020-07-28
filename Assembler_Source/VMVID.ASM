; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner

; VMVID.ASM

include	vm.equ
include vmvid.equ

extrn VlanVideoPort:byte,VlanVideoPort2:byte,vidbase_ovr:word

extrn _make_dec:far,Vtr_Sndbuf:word,Audio_Effects_Address:byte
extrn Device_Enabled:byte,Device_Present:byte,EFX_Flag:byte,Active_IOTYP:byte
extrn Autotrans_Flag:byte,Dnstream_Keynumber:byte,Effects_Address:byte
extrn From_Machine:byte,Fullscreen_Flag:byte,Input_Flag:word,Key_Mode:byte
extrn Keybkgnd_Src:byte,Keyfor_Src:byte,Last_Preview_XPT:byte
extrn Preview_Mode:byte,Record_Flag:byte,To_Machine:byte,Trans_Type:byte
extrn Trim_Ci_Flag:byte,Vtr_Mult_Type:byte,upstream_keynumber:byte

extrn Ofspeed_Msg:word,Mcrosep:word
extrn Dsk_Trans:word, Ftb_Trans:word
extrn EMEMrdsw_ovr:word,dirbuff:word
extrn EMEMwrtsw_ovr:word,SX_Descriptor:word,SX_Rcvbuf:word,SX_Sndbuf:word
extrn VLAN_Flags:word,Am_xcmd:word,audcontrol_ovr:word,Code_Msg:word
extrn Cursor:word,dur_rqst:word,Elaptm:word,Emem_File_Msg:word
extrn ememopts_ovr:word,Gpi0:word,Key_Trans:word,Last_Duration:word
extrn List_Scr:word,Msg_Area:word,Nxptcom_Msg:word,Preview_Msg:word
extrn Rm_xcmd:word,Switcher_Flags:word,Swjstick_Table:word,Title2_Scr:word
extrn Trans_Code:word,Trans_Length:word,vidcontrol_ovr:word,Video_Header:word
extrn Vtrcb:word,Wipe_Msg:word,RunningCMD_Cnt:word

extrn EMEM_load:near,EMEM_save:near,vtr_cmd:near,vtr_sendcmd:near
extrn KeyCommand_EFXMEM:near,Preread:near,RealTime_Trigger:near
extrn SetVlanEfxAddress:near,A_Machine:near,all_cue:near,all_still:near
extrn all_stop:near,Audio1_Select:near,Audio2_Select:near,Audio3_Select:near
extrn Audio4_Select:near,Aux_Machine:near,Blk_Machine:near,bump_minus:near
extrn bump_plus:near,cue:near,dec_cimsg:near,eject:near,fastfwd:near
extrn gotoin:near,gotoout:near,Hardaud1:near,Hardaud2:near,Hardvid:near
extrn _Inout_init:far,MarkIn:near,Markout:near,mdmout:near,Modes_Off:near
extrn pause:near,play:near,R_Machine:near,rdchar:near,relay_trigger:near
extrn reverse:near,rewind:near,screen_init:near,send_Break:near
extrn set_vtrcmd:near,shell2switcher:near,shuttleback:near,shuttlefwd:near
extrn slowfwd:near,slowrev:near,sragn:near,srchfwd:near,srchrev:near
extrn still:near,stop:near,switch_VLAN:near,tc_cimsg:near,tc_parenth:near
extrn twicefwd:near,twicefwd:near,twicerev:near,video_files:near
extrn Video_Select:near,vtr_answer:near,vtr_opt:near,vtrcmdx:near
extrn GetVlanRecord:near,vtr_msgstore:near,vtr_cstore:near,vtr_msgstorecl:near
extrn SendVlanMsgCl:near,SetEMEMEfxAddress:near,SetVlanEfxAdrTo_CH:near
extrn devtype:near,get_appltype:near,keywait:near

extrn _ConOut:FAR,_error_bell:FAR,_EFXscreen:far,_hex2bn:far
extrn _GetSXcb_SMPTEadr:far,_GetSXcb_analogbits:far,_GetSXcb_commandtbl:far
extrn _GetSXcb_dskbits:far,_GetSXcb_Flags:far,_GetSXcb_masks:far,_macone:far
extrn _GetSXcb_pbltbl:far,_GetSXcb_xlatetbl:far,_Space_Out:far,_cntrtxt:FAR
extrn _comsg:FAR,_convert2bin:far,_convert2hex:far,_delms:far,_delfrm:far
extrn _dircur_lerase:FAR,_evnt_dispthis:far,_joy_convert:far,_jstick:far
extrn _kbd_cln:FAR,_kbd_message:far,_line_erase:far,_make_hexbyte:far
extrn _make_hexword:far,_mmv3byt:far,_mmv:far,_msg2screen:far,_msgread:far
extrn _time_value:far,_time_value:far,_vlan_switcher_trigger:far,_A_DecOut:far
extrn _kbd_cln:far

	ifdef Bm_xcmd
extrn Bm_xcmd:word
	endif
	ifdef Cm_xcmd
extrn Cm_xcmd:word
	endif
	ifdef Dm_xcmd
extrn Dm_xcmd:word
	endif
	ifdef Em_xcmd
extrn Em_xcmd:word
	endif
	ifdef Fm_xcmd
extrn Fm_xcmd:word
	endif

Public  Pushabutton, SW_nofunction, SetWriteBit, swb10xl, swbret, SW_allstop
Public  VLAN_allstop, read_all_analog, SW_alsx, efxSW_dsk_mix, efxSW_ftb_press
Public  AS_cut, AS_trans, AS_over, aPB_press, bPB_press, ASW_ftb_press, audret
Public  SW_trans, SW_dsk_mix, SW_ftb_press, SW_cut, SW_mix, SW_wipe, SW_key
Public  SW_bkgd, SW_keybkg, SW_KEY_test, SW_reverse_on, SW_reverse_off
Public  Std_AutoTrans, move_sxbufs, SW_preset_pattern, swppoff1, swppoff2
Public  swppoff3, swppoff4, SW_soft_on, SW_soft_off, SW_bdr_on, SW_bdr_off
Public  SW_aspect_tgl, SW_soft_up, swsun, SW_soft_dn, swsun1, SW_bdr_up
Public  SW_bdr_dn, SW_fader_fwd, SW_fader_rev, SW_position_Vup, SW_position_Vdn
Public  SW_position_Hup, SW_position_Hdn, SW_Symmetry_up, SW_Symmetry_dn
Public  SW_DSKclip_up, SW_DSKclip_dn, SW_DSKhue_up, SW_DSKhue_dn
Public  SW_DSKchroma_up, SW_DSKchroma_dn, SW_DSKlum_up, SW_DSKlum_dn
Public  SW_KEYclip_up, SW_KEYclip_dn, SW_KEYgain_up, SW_KEYgain_dn, HUE_up
Public  HUE_dn, CHROMA_up, CHROMA_dn, LUM_up, LUM_dn, MASK_up, MASK_dn
Public  BKG_HUE_up, BKG_HUE_dn, BKG_CHROMA_up, BKG_CHROMA_dn, BKG_LUM_up
Public  BKG_LUM_dn, CHROMAKEY_up, CHROMAKEY_dn, SW_positionerON, SW_read_fader
Public  SW_read_V, SW_read_H, SW_read_Sym, SW_read_soft, SW_read_bdr
Public  SW_read_KEYclip, SW_read_KEYgain, SW_read_HUE, SW_read_CHROMA
Public  SW_read_LUM, SW_read_MASK, SW_read_BKGHUE, SW_read_BKGCHROMA
Public  SW_read_BKGLUM, SW_read_CHROMAKEY, SW_read_DSKclip, SW_read_DSKhue
Public  SW_read_DSKchroma, SW_read_DSKlum, A_trans, A_trans_return
Public  a_trans_SMPTE, K_trans, DSK_press, FTB_press, PB_press, pbpres, PB_on
Public  PB_off, PB_cmd, PB_test, PB_analog_on, pbaonr, PB_analog_off, pbaoffr
Public  PB_analog, vbup, vbdown, vbdwn, vb_ud, pba1, PBAup, PBAdown, PBAdwn
Public  PBA_ud, PBA_bx, PBA_ea, PBA_ret, PB_read_analog, pbradsk, pbraup
Public  pbra_ng, PB_rd8, PB_rdret, PGM_press, PST_press, KEY_press, buspres
Public  buspres1, pst_switch, switch, aswitch, swtch, swtch1, swtchpp, swtchp
Public  swtchbs, swtchx, SendExtendedSwitcher, GetExtendedSwitcher
Public  Monitor_Switch, jms_doit, jms_esam, jms_xit, Mute_On, jmu_esam, jmu_xit
Public  PBindex, WPindex, WPnoidx, WPoutofrange, SWindex, SWindx, aswitch4edit
Public  switch4edit, s4ed, sw4ed1a, sw4ed0, sw4nas, sw4ed0a, sw4ed0b
Public  sw4ed1, s4ex, sw4ed2, sw4ed2aa, swed2a, swed2b, sw4key, swkeyon
Public  swkeyin, swkxit, switch_audio_video, sava, Wipe_Code, Wipe_fwd
Public  Wipe_rev, Wipe_sftfwd, Wipe_sftrev, Wipe_bdrfwd, Wipe_bdrrev
Public  Wipe_sftbdrfwd, Wipe_sftbdrrev, Wipe_Direct, wpdd, wpdr
Public  Toggle_Active_Bus, TAB_next, TAB_1st, ememopts, ememopt0, ememop1
Public  ememagn, emmnfs, emmevnt, ememprm, ememx, ememxr, emem1, emem_3
Public  emem_status_line, EFXscreen, READ_emem_FAR, READ_emem, reademx
Public  ReadEmemFromVlan, REFVlp1, REFVxit, WRITE_emem_FAR, WRITE_emem
Public  writemx, WriteEmemToVlan, WEFVlp1, WEFVlp2, WEFVxit, SW_learn, swlrnx
Public  SW_recall, swememx, SaveEmemToSwitcher, sets422, setsxit
Public  RecallEmemToSwitcher, rets422, retsxit, RqstEmemNumber, renx
Public  EFX_rehearse, EFX_xit, EFX_sethalfefx, EFX_halfefx, EFX_fader
Public  EFX_autotrans, EFX_dskrate, EFX_ftbrate, SetRate, GetEFX_rate, EFXrclr
Public  EFXat1, EFXat2, EFXrtx, Change_wipecode, chwcx, SW_long_write, SWlw1
Public  SW_analog_12bit_write, SW_analog_8bit_write, SW_read, SW_write, SW_cmd
Public  SW_cmdc, SW_cmdx, sw10xx, SW_cmdr, switch_10x, sw10xv, sw10xa, sw10xb
Public  sw10x9, sw10dly, sw10nfd, send2switcher, swagn, switchx, swspol
Public  swspole, swspolo, SX_send, sws2, swslp, swsxit, SX_receive, srsmpte
Public  sraccept, sr10xer, sr1, sr1a, sr2, srxto, srxitc, srxit, getxpt_FAR
Public  getxpt, getxpt1, getxptx, JMENU_rev, jmrev, jmrevx, JMENU_fwd, jmfwdx
Public  jmfwd, joymode_test, jytdsk, jytp, test_analog_present, swjoyret
Public  SWjoystick, swjoych1, swjoy_y, swjoych2, swjoy_z, swjoybutx
Public  JOYSTICK_DISPATCH_UP, JOYSTICK_DISPATCH_DOWN, JOYSTICK_DISPATCH_LEFT
Public  JOYSTICK_DISPATCH_RIGHT, JDSPR, triggerit, trigit1, TRIG_sw
Public  TRIG_at, TRIG_ata, trig_aud, TRIG_ds, trigds1, TRIG_em, trigxx
Public  joymode_msg, EFX_cmdtbl, ross_wipes
Public  SMPTE_commands, ESAM2_commands, gvg100_pba, gvg100_pbv, gvg_wipes
Public  pyxis_wipes, pegasus_wipes, JOYMODE_TBL, jmenusize, joynamesize
Public  JOYMODE_NAMES, activebus_msg, BUS_NAMES, busnamesize, JOYMODE
Public  FTB_STATE, SplitFader, FaderPosition, SjstickH, SjstickV, Symmetry
Public  Softness, BorderWidth, KEYclip, KEYgain, HUE, CHROMA, LUM, MASKPST
Public  BKGHUE, BKGCHROMA, BKGLUM, CHROMAKEY, DSKclip, DSKhue, DSKchroma
Public  DSKlum, iAnalogIncrement, ACD_fader_fwd, ACD_fader_rev
Public  ACD_position_Vup, ACD_position_Vdn, ACD_position_Hup, ACD_position_Hdn
Public  ACD_Symmetry_up, ACD_Symmetry_dn, ACD_soft_up, ACD_soft_dn, ACD_bdr_up
Public  ACD_bdr_dn, ACD_KEYclip_up, ACD_KEYclip_dn, ACD_KEYgain_up
Public  ACD_KEYgain_dn, ACD_HUE_up, ACD_HUE_dn, ACD_CHROMA_up, ACD_CHROMA_dn
Public  ACD_LUM_up, ACD_LUM_dn, ACD_MASK_up, ACD_MASK_dn, ACD_BKG_HUE_up
Public  ACD_BKG_HUE_dn, ACD_BKG_CHROMA_up, ACD_BKG_CHROMA_dn, ACD_BKG_LUM_up
Public  ACD_BKG_LUM_dn, ACD_CHROMAKEY_up, ACD_CHROMAKEY_dn, ACD_DSKclip_up
Public  ACD_DSKclip_dn, ACD_DSKhue_up, ACD_DSKhue_dn, ACD_DSKchroma_up
Public  ACD_DSKchroma_dn, ACD_DSKlum_up, ACD_DSKlum_dn, SW_autotrans
public SW_key_ON, SW_key_OFF, SwapVideoSwitcherPorts
public apst_switch,pswitch4edit, pswitch

%list

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:_DATA

;; Swap Vlan Video Switcher Control Ports
SwapVideoSwitcherPorts	proc	near

	mov	al,Active_IOTYP		; Save current IOTYP
	push	ax
	mov	Active_IOTYP,video_IOTYP
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	pop	ax
	mov	Active_IOTYP,al		; Restore IOTYP
	jz	svsper

	mov	al,VlanVideoPort
	mov	ah,VlanVideoPort2
	or	ah,ah			; Don't switch to a null port
	jz	svsper

	push	ax
	mov	al,ah
	call	get_appltype		; BX --> ASCII response from VLAN
	cmp	al,2			; Video switcher?
	pop	ax
	jnz	svsper

	mov	VlanVideoPort,ah
	mov	VlanVideoPort2,al
	cmp	RunningCMD_Cnt,0
	jnz	svspr
	call	_kbd_cln
	mov	bx,offset vidbase_ovr
	call	_msgread
	mov	bx,offset Ofspeed_Msg
	call	_comsg
	mov	al,VlanVideoPort
	call	_A_DecOut
	mov	bx,offset Mcrosep
	call	_comsg
	call	devtype
	call	_comsg
	call	keywait
	call	_macone
svspr:	ret

svsper:
	ERROR	noauxswitcher_error, ERET_Keyboard
;;	call	_error_bell
;;	ret

SwapVideoSwitcherPorts	endp

;================================================================
Pushabutton:
	call	SW_trans
	call	AS_trans
	ret

;................................................................
SW_nofunction:	ret

; Set SMPTE or ESAM2 write bit in AL
SetWriteBit:
	push	bx
	call	_GetSXcb_Flags
	test	bx,SWbit_GVG10XL
	jnz	swb10xl
	or	al,ESAM2_write		; Ok to preset bit 7 (used for both)
	test	bx,SWBIT_smpte		; SMPTE reqires bit 6, too.
	jz	swbret
swb10xl:or	al,X_write
swbret:	pop	bx
	ret	


;================================================================
SW_allstop	proc	near
	CUTSONLY_TEST
	mov	Active_IOTYP,audio_IOTYP
	call	allstopit
	mov	Active_IOTYP,video_IOTYP

allstopit:
	call	_GetSXcb_Flags

	test	bx,SWbit_VLAN		; Vlan switcher?
	jnz	VLAN_allstop

	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	JMP_NZ	SW_alsx

	test	bx,SWBIT_smpte		; Only SMPTE get allstop
	jz	SW_alsx

	mov	al,X_allstop
	mov	cx,000ffh		; Send dummy byte
	call	SW_write
	call	A_trans
	call	read_all_analog
	ret

;; Send all stop command to audio and video switcher
VLAN_allstop:
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	SW_alsx
	test	VLAN_Flags, swextended_VLNBIT
	jz	SW_alsx
	mov	al, V4SW_AllReset
	xor	bx,bx
	call	SendExtendedSwitcher
	ret
SW_allstop	endp

;================================================================
read_all_analog:
	test	byte ptr Active_IOTYP,video_IOTYP
	jz	SW_alsx

	call	_GetSXcb_Flags
	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jnz	SW_alsx
	test	bx,SWbit_VLAN		; Test for VLAN
	jnz	SW_alsx

	call	SW_read_soft
	call	SW_read_bdr
	call	SW_read_fader
	call	SW_read_V
	call	SW_read_H
	call	SW_read_Sym
	call	SW_read_DSKclip
	call	SW_read_DSKhue
	call	SW_read_DSKchroma
	call	SW_read_DSKlum
	call	SW_read_KEYclip
	call	SW_read_KEYgain
	call	SW_read_HUE
	call	SW_read_CHROMA
	call	SW_read_LUM
	call	SW_read_MASK
	call	SW_read_BKGHUE
	call	SW_read_BKGCHROMA
	call	SW_read_BKGLUM
	call	SW_read_CHROMAKEY
SW_alsx:ret


efxSW_dsk_mix:
	call	SW_dsk_mix
	ret
efxSW_ftb_press:
	call	SW_ftb_press
	call	ASW_ftb_press
	ret
;================================================================
;================================================================
;================================================================
;================================================================
mVlanSwitcherExtendedCommand macro command, parameter, addparam, lreg
local ?jx
	push	bx
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	?jx
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	?jx

	pop	bx

	IFB <addparam>
			mov	bx, parameter
	else
		IFB <lreg>
			mov	bx, parameter
			add	bx, addparam
		else
			mov	bl, parameter
			mov	bh, 0
		endif
	endif
	mov	al, command
	call	SendExtendedSwitcher
	ret
?jx:
	pop	bx
	endm


;================================================================
mVlanSwitcherExtendedTest macro command, parameter, addparam, lreg
local ?jx
	push	bx
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	?jx
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	?jx

	pop	bx

	IFB <addparam>
			mov	bx, parameter
	else
		IFB <lreg>
			mov	bx, parameter
			add	bx, addparam
		else
			mov	bl, parameter
			mov	bh, 0
		endif
	endif
	mov	al, command
	call	GetExtendedSwitcher
	or	al,al
	ret
?jx:
	pop	bx
	endm



;================================================================
AS_cut:		mov	al,ABTN_cut		; cut
		jmp	aPB_press

;11-09-1995 Fix for V-LAN control audio mixer
AS_trans:	mov	Active_IOTYP,audio_IOTYP
		mVlanSwitcherExtendedCommand V4SW_AutoTransPlusDuration, Trans_Length,  0001000000000000b

		call	_GetSXcb_masks
		mov	al,X_autorate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,ABTN_pst_trans	; trans (pst)
		jmp	aPB_press
;...

AS_over:	mov	al,ABTN_ovr_trans	; Over

aPB_press:	CUTSONLY_TEST
		mov	cl,audio_IOTYP
		mov	Active_IOTYP,cl
		call	_GetSXcb_Flags
		test	bx,SWBIT_smpte
		jnz	bPB_press
		mov	ch,0ffh			; Transition everybody
		mov	cl,0ffh			; Send out tail
		mov	al,29h			;  Write to it
		jmp	SW_write

bPB_press:	jmp	pbpres		; "Press" the button

ASW_ftb_press:	mov	Active_IOTYP,audio_IOTYP
		call	_GetSXcb_masks
		test	bx,SXspcl_FTB
		jz	audret

		mov	al,X_ftbrate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,ABTN_ftb		; FADE TO BLACK
		jmp	aPB_press

audret:		ret


;================================================================

SW_trans:	mov	Active_IOTYP,video_IOTYP
		mVlanSwitcherExtendedCommand V4SW_AutoTransition, 0,  0001000000000000b

		call	_GetSXcb_masks
		mov	al,X_autorate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,VBTN_autotrans	; trans
		jmp	PB_press

public KEY_autotrans
KEY_autotrans:	mov	Active_IOTYP,video_IOTYP

;5-01-1995 
;;		mVlanSwitcherExtendedCommand V4SW_AutoTransPlusDuration, Key_Trans,  0010000000000000b

		mov	cl,upstream_keynumber
		mov	ah,00010000b
		shl	ah,cl
		mov	al,0
		mVlanSwitcherExtendedCommand V4SW_AutoTransPlusDuration, Key_Trans, ax
;..

		call	_GetSXcb_masks
		mov	al,X_autorate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,VBTN_autotrans	; trans
		jmp	PB_press

SW_autotrans:	mov	Active_IOTYP,video_IOTYP
		mVlanSwitcherExtendedCommand V4SW_AutoTransPlusDuration, Trans_Length,  0001000000000000b

		call	_GetSXcb_masks
		mov	al,X_autorate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,VBTN_autotrans	; trans
		jmp	PB_press

SW_dsk_mix:	mov	Active_IOTYP,video_IOTYP
		mov	cl,Dnstream_Keynumber
		mov	ah,00010000b
		shl	ah,cl
		mov	al,0
		mVlanSwitcherExtendedCommand V4SW_AutoTransPlusDuration, Dsk_Trans, ax

		call	_GetSXcb_masks
		mov	al,X_dskrate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,VBTN_dsk_mix		; DSK_mix
		jmp	PB_press

SW_ftb_press:	mov	Active_IOTYP,video_IOTYP
		mVlanSwitcherExtendedCommand V4SW_FtbPlusDuration, Ftb_Trans

		call	_GetSXcb_masks
		mov	al,X_ftbrate
		test	bx,SXspcl_TRC
		JMP_NZ	Std_AutoTrans
		mov	al,VBTN_ftb		; FADE TO BLACK
		jmp	PB_press


SW_cut:		mVlanSwitcherExtendedCommand V4SW_SelectTransitionType, 01
		mov	al,VBTN_cut		; cut
		jmp	PB_press
SW_mix:		mVlanSwitcherExtendedCommand V4SW_SelectTransitionType, 02
		mov	al,VBTN_mix		; mix
		jmp	PB_press
SW_wipe:	mVlanSwitcherExtendedCommand V4SW_SelectTransitionType, 03
		mov	al,VBTN_wipe		; wipe
		jmp	PB_press
SW_key:		mVlanSwitcherExtendedCommand V4SW_SelectTransitionMode, 00000010b
		mov	al,X_transition		; key
		mov	ch,00000001b
		jmp	PB_cmd
SW_bkgd:	mVlanSwitcherExtendedCommand V4SW_SelectTransitionMode, 00000001b
		mov	al,X_transition		; bkgd
		mov	ch,00000100b
		jmp	PB_cmd
SW_keybkg:	mVlanSwitcherExtendedCommand V4SW_SelectTransitionMode, 00000011b
		mov	al,X_transition
		mov	ch,00000101b
		jmp	PB_cmd

SW_KEY_test:	mov	cl, upstream_keynumber
		shl	cl,4
		or	cl, V4SW_KeyOnOff
		mVlanSwitcherExtendedTest cl, 0

		mov	al,VBTN_key_test	; TEST STATE OF KEY
		jmp	PB_test

SW_reverse_on:	mVlanSwitcherExtendedCommand V4SW_WipeAttibutes, 00000001b
		mov	al,VBTN_wipe_rev	; Reverse
		jmp	PB_on

SW_reverse_off:	mVlanSwitcherExtendedCommand V4SW_WipeAttibutes, 00000000b
		mov	al,VBTN_wipe_rev
		jmp	PB_off

SW_key_ON:	mov	cl, upstream_keynumber
		shl	cl,4
		or	cl, V4SW_KeyOnOff
		mVlanSwitcherExtendedCommand cl, 1
		ret

SW_key_OFF:	mov	cl, upstream_keynumber
		shl	cl,4
		or	cl, V4SW_KeyOnOff
		mVlanSwitcherExtendedCommand cl, 0
		ret

;================================================================
; 11-10-1992 Read and Write auto transition
; AL = command
; CL = 0FFH if tail byte in CH
; CH = tail byte if CL 0ffh
Std_AutoTrans:
	CUTSONLY_TEST
	xor	cx,cx			; No tail
	call	SW_read
	call	move_sxbufs
	mov	bx,offset SX_Sndbuf
	or	byte ptr [bx + 3], 80h	; Set the high bit for trigger
	call	send2switcher
	ret

; Move all bytes from SX_Rcvbuf to SX_Sndbuf
move_sxbufs:
	push	si
	push	di
	push	es
	push	ds
	pop	es
	mov	si,offset SX_Rcvbuf
	mov	di,offset SX_Sndbuf
	mov	cl,[si]
	mov	ch,0
	inc	cl
	rep	movsb
	pop	es
	pop	di
	pop	si
	ret

;================================================================

SW_preset_pattern:
		mov	AL,VBTN_preset_pattern
		call	PB_test			; If preset pattern
		jz	swppoff1
		mov	AL,VBTN_keybus_source	; Select key bus
		jmp	PB_press

swppoff1:	mov	AL,VBTN_keybus_source
		call	PB_test			; If key bus
		jz	swppoff2
		mov	AL,VBTN_extkey_source	; Select external key bus
		jmp	PB_press

swppoff2:	mov	AL,VBTN_extkey_source
		call	PB_test			; If external key bus
		jz	swppoff3
		mov	AL,VBTN_chromakey_source; Select chroma key bus
		jmp	PB_press

swppoff3:	mov	AL,VBTN_chromakey_source
		call	PB_test			; If chroma key source
		jz	swppoff4
		mov	AL,VBTN_preset_pattern	; Select chroma key bus
		jmp	PB_press

swppoff4:	ret

;================================================================ 
;SW_soft_on:	mov	al,VBTN_softness	; PC3 SOFTNESS
;		jmp	PB_on
;
;SW_soft_off:	mov	al,VBTN_softness	; PC3 SOFTNESS
;		jmp	PB_off
;
SW_soft_on:
		mVlanSwitcherExtendedCommand V4SW_WipeAttibutes, 00000010b
		mov	al,VBTN_softness	; PC3 SOFTNESS
		call	PB_on
		mov	si,offset ACD_soft_up
		jmp	PB_analog_on

SW_soft_off:
		mVlanSwitcherExtendedCommand V4SW_WipeAttibutes, 00000000b
		mov	al,VBTN_softness	; PC3 SOFTNESS
		call	PB_off
		mov	si,offset ACD_soft_up
		mov	bx,-1
		jmp	PB_analog_off

SW_bdr_on:	mVlanSwitcherExtendedCommand V4SW_WipeAttibutes, 00000100b
		mov	si,offset ACD_bdr_up
		jmp	PB_analog_on

SW_bdr_off:	mVlanSwitcherExtendedCommand V4SW_WipeAttibutes, 00000000b
		mov	si,offset ACD_bdr_dn
		mov	bx,0
		jmp	PB_analog_off		; Turn it on

SW_aspect_tgl:	mov	al,VBTN_aspect
		jmp	PB_press


;================================================================ 
SW_soft_up:
		call	_GetSXcb_Flags
		test	bx,SWbit_PC3
		jz	swsun
		jmp	SW_soft_on	; PC3 SOFTNESS ON
swsun:		mov	si,offset ACD_soft_up
		jmp	PB_analog
SW_soft_dn:
		call	_GetSXcb_Flags
		test	bx,SWbit_PC3
		jz	swsun1
		jmp	SW_soft_off	; PC3 SOFTNESS ON
swsun1:		mov	si,offset ACD_soft_dn
		jmp	PB_analog

SW_bdr_up:	mov	si,offset ACD_bdr_up
		jmp	PB_analog
SW_bdr_dn:	mov	si,offset ACD_bdr_dn
		jmp	PB_analog
SW_fader_fwd:	mov	si,offset ACD_fader_fwd
		jmp	PB_analog
SW_fader_rev:	mov	si,offset ACD_fader_rev
		jmp	PB_analog
SW_position_Vup:mov	si,offset ACD_position_Vup
		jmp	PB_analog
SW_position_Vdn:mov	si,offset ACD_position_Vdn
		jmp	PB_analog
SW_position_Hup:mov	si,offset ACD_position_Hup
		jmp	PB_analog
SW_position_Hdn:mov	si,offset ACD_position_Hdn
		jmp	PB_analog
SW_Symmetry_up:	mov	si,offset ACD_Symmetry_up
		jmp	PB_analog
SW_Symmetry_dn:	mov	si,offset ACD_Symmetry_dn
		jmp	PB_analog
SW_DSKclip_up:	mov	si,offset ACD_DSKclip_up
		jmp	PB_analog
SW_DSKclip_dn:	mov	si,offset ACD_DSKclip_dn
		jmp	PB_analog
SW_DSKhue_up:	mov	si,offset ACD_DSKhue_up
		jmp	PB_analog
SW_DSKhue_dn:	mov	si,offset ACD_DSKhue_dn
		jmp	PB_analog
SW_DSKchroma_up:mov	si,offset ACD_DSKchroma_up
		jmp	PB_analog
SW_DSKchroma_dn:mov	si,offset ACD_DSKchroma_dn
		jmp	PB_analog
SW_DSKlum_up:	mov	si,offset ACD_DSKlum_up
		jmp	PB_analog
SW_DSKlum_dn:	mov	si,offset ACD_DSKlum_dn
		jmp	PB_analog
SW_KEYclip_up:	mov	si,offset ACD_KEYclip_up
		jmp	PB_analog
SW_KEYclip_dn:	mov	si,offset ACD_KEYclip_dn
		jmp	PB_analog
SW_KEYgain_up:	mov	si,offset ACD_KEYgain_up
		jmp	PB_analog
SW_KEYgain_dn:	mov	si,offset ACD_KEYgain_dn
		jmp	PB_analog

;....
HUE_up:		mov	si,offset ACD_HUE_up
		jmp	PB_analog
HUE_dn:		mov	si,offset ACD_HUE_dn
		jmp	PB_analog
CHROMA_up:	mov	si,offset ACD_CHROMA_up
		jmp	PB_analog
CHROMA_dn:	mov	si,offset ACD_CHROMA_dn
		jmp	PB_analog
LUM_up:		mov	si,offset ACD_LUM_up
		jmp	PB_analog
LUM_dn:		mov	si,offset ACD_LUM_dn
		jmp	PB_analog
MASK_up:	mov	si,offset ACD_MASK_up
		jmp	PB_analog
MASK_dn:	mov	si,offset ACD_MASK_dn
		jmp	PB_analog
BKG_HUE_up:	mov	si,offset ACD_BKG_HUE_up
		jmp	PB_analog
BKG_HUE_dn:	mov	si,offset ACD_BKG_HUE_dn
		jmp	PB_analog
BKG_CHROMA_up:	mov	si,offset ACD_BKG_CHROMA_up
		jmp	PB_analog
BKG_CHROMA_dn:	mov	si,offset ACD_BKG_CHROMA_dn
		jmp	PB_analog
BKG_LUM_up:	mov	si,offset ACD_BKG_LUM_up
		jmp	PB_analog
BKG_LUM_dn:	mov	si,offset ACD_BKG_LUM_dn
		jmp	PB_analog
CHROMAKEY_up:	mov	si,offset ACD_CHROMAKEY_up
		jmp	PB_analog
CHROMAKEY_dn:	mov	si,offset ACD_CHROMAKEY_dn
		jmp	PB_analog



;================================================================
SW_positionerON:
		mov	al,VBTN_positioner
		jmp	PB_press

SW_read_fader:	mov	al,VANA_fader
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_Fader
		mov	bx,offset FaderPosition
		jmp	PB_read_analog

SW_read_V:	mov	al,VANA_position_V
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_Positioner
		mov	bx,offset SjstickV
		jmp	PB_read_analog

SW_read_H:	mov	al,VANA_position_H
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_Positioner
		mov	bx,offset SjstickH
		jmp	PB_read_analog

SW_read_Sym:	mov	al,VANA_aspect
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_aspect
		mov	bx,offset Symmetry
		jmp	PB_read_analog


SW_read_soft:	mov	al,VANA_softness
		mov	ah,0			; Use 8 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_softness
		mov	bx,offset Softness
		jmp	PB_read_analog


SW_read_bdr:	mov	al,VANA_border
		mov	ah,0			; Use 8 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_Border
		mov	bx,offset BorderWidth
		jmp	PB_read_analog

SW_read_KEYclip:mov	al,VANA_key_clip
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_key_clip
		mov	bx,offset KEYclip
		jmp	PB_read_analog

SW_read_KEYgain:mov	al,VANA_key_gain
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_key_gain
		mov	bx,offset KEYgain
		jmp	PB_read_analog

;................
SW_read_HUE:	mov	al,VANA_hue
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_hue
		mov	bx,offset HUE
		jmp	PB_read_analog

SW_read_CHROMA:	mov	al,VANA_chroma
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_chroma
		mov	bx,offset CHROMA
		jmp	PB_read_analog

SW_read_LUM:	mov	al,VANA_lumance
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_lumance
		mov	bx,offset LUM
		jmp	PB_read_analog

SW_read_MASK:	mov	al,VANA_mask_presetsize
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_mask_presetsize
		mov	bx,offset MASKPST
		jmp	PB_read_analog

SW_read_BKGHUE:	mov	al,VANA_background_hue
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_background_hue
		mov	bx,offset BKGHUE
		jmp	PB_read_analog

SW_read_BKGCHROMA:
		mov	al,VANA_bacground_chroma
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_bacground_chroma
		mov	bx,offset BKGCHROMA
		jmp	PB_read_analog

SW_read_BKGLUM:	mov	al,VANA_bacground_lum
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_bacground_lum
		mov	bx,offset BKGLUM
		jmp	PB_read_analog

SW_read_CHROMAKEY:
		mov	al,VANA_chroma_key_hue
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,Effects_Address
		mov	dx,SXana_chroma_key_hue
		mov	bx,offset CHROMAKEY
		jmp	PB_read_analog

SW_read_DSKclip:mov	al,VANA_dsk_clip
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,0			; Effects_Address
		mov	dx,SXdsk_dsk_clip
		mov	bx,offset DSKclip
		jmp	PB_read_analog

SW_read_DSKhue:	mov	al,VANA_dsk_hue
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,0			; Effects_Address
		mov	dx,SXdsk_dsk_hue
		mov	bx,offset DSKhue
		jmp	PB_read_analog

SW_read_DSKchroma:
		mov	al,VANA_dsk_chroma
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,0			; Effects_Address
		mov	dx,SXdsk_dsk_chroma
		mov	bx,offset DSKchroma
		jmp	PB_read_analog

SW_read_DSKlum:	mov	al,VANA_dsk_luminance
		mov	ah,0ffh			; Use 12 bit value
		mov	cl,0			; Effects_Address
		mov	dx,SXdsk_dsk_luminance
		mov	bx,offset DSKlum
		jmp	PB_read_analog


; Set auto transition rate
A_trans:	call	_GetSXcb_Flags
		test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
		jnz	A_trans_return
		test	bx,SWbit_VLAN		; Test for 10XL (NZ if so)
		jnz	A_trans_return
		test	bx,SWBIT_smpte		; SMPTE or ESAM2?
		jnz	a_trans_SMPTE
; Set ESAM channels:
		call	a_trans_SMPTE		;(first channel)
		mov	al,X_dskrate		; (second channel)
		mov	bx,Trans_Length
		call	SW_long_write
A_trans_return:	ret

; Do standard auto transition duration setting
a_trans_SMPTE:	mov	al,X_autorate
		mov	bx,Trans_Length
		jmp	SW_long_write

K_trans:	mov	al,X_autorate
		mov	bx,Key_Trans
		jmp	SW_long_write

DSK_press:	mov	al,X_dskrate
;		mov	bx,DSK_rate
		mov	bx,Trans_Length
		jmp	SW_long_write

FTB_press:	mov	al,X_ftbrate
;		mov	bx,FTB_rate
		mov	bx,Trans_Length
		jmp	SW_long_write


;================================================================

;................................................................
; "Press" any pushbutton
PB_press:
	mov	cl,video_IOTYP
pbpres:	mov	Active_IOTYP,cl

	CUTSONLY_TEST

	call	PBindex
	mov	ch,al
	mov	cl,0ffh				; Send out tail
	mov	al,X_pushbutton			;  Write to it
	jmp	SW_write

PB_on:	CUTSONLY_TEST
	mov	Active_IOTYP,video_IOTYP
	push	bx
	call	PBindex
	mov	ch,al
	mov	cl,0ffh
	mov	al,X_pbl_on
	call	SW_write
	pop	bx
	ret

PB_off:	CUTSONLY_TEST
	mov	Active_IOTYP,video_IOTYP
	push	bx
	call	PBindex
	mov	ch,al
	mov	cl,0ffh
	mov	al,X_pbl_off
	call	SW_write
	pop	bx
	ret

; AL = command 
; CH = byte to send
PB_cmd:	CUTSONLY_TEST
	mov	Active_IOTYP,video_IOTYP
	push	bx
	mov	cl,0ffh
	call	SW_write
	pop	bx
	ret


;Test status of pushbutton.
;Exit:	Z=1 (Z) if button OFF, Z=0 (NZ) if button ON
PB_test:CUTSONLY_TEST
	mov	Active_IOTYP,video_IOTYP
	call	PBindex
	mov	ch,al
	mov	cl,0ffh
	mov	al,X_pbl_on
	call	SW_read
	and	ah,not (X_read or X_write)
	cmp	ah,X_pbl_off
	ret


;================================================================
; Force analog control to its recorded setting
; ENTER: SI points to A_C_D descriptor
PB_analog_on:
	CUTSONLY_TEST
	mov	Active_IOTYP,video_IOTYP
	mov	al,[si].BTN		; Get button number
	call	PBindex
	call	_GetSXcb_Flags
	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jz	pbaonr
	mov	cx,bx			; Get SWITCHER BITS TO CX
	mov	bx,[si].CRNTVAL		; Get current value pointer
	jmp	PBA_ud
pbaonr:	ret

PB_analog_off:
	CUTSONLY_TEST
	push	bx
	mov	Active_IOTYP,video_IOTYP
	mov	al,[si].BTN		; Get button number
	call	PBindex
	call	_GetSXcb_Flags
	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	mov	cx,bx			; Get SWITCHER BITS TO CX
	pop	bx			; 9-17-1992 Moved this up
	jnz	pbaoffr
	jmp	PBA_bx
pbaoffr:ret


;================================================================
;ENTER: SI points to descriptor
PB_analog:
	CUTSONLY_TEST

	mov	Active_IOTYP,video_IOTYP

	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	pba1

; Process analog VLAN command
	mov	dx,SX_Descriptor.SXcb_AnalogIncrement

	mov	bx,[si].CRNTVAL		; Get current value pointer
	cmp	[si.UPDOWN],0		; Analog DOWN?
	jnz	vbdown
	test	cx,SWbit_Polarity
	jnz	vbdwn
vbup:	add	[bx],dx			; Add increment to current value
	jmp	vb_ud
vbdown:test	cx,SWbit_Polarity
	jnz	vbup
vbdwn:	sub	[bx],dx			; Subtract increment to current value
vb_ud:	mov	bx,[bx]			; Get new value
	mov	al, byte ptr [si].VLNCMD
	call	SendExtendedSwitcher
	ret

pba1:
	call	_GetSXcb_Flags
	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jnz	PBA_ret

	call	[si].READ_RTN		; Get read routine address

	mov	al,[si].BTN		; Get button number
	call	PBindex

	call	_GetSXcb_Flags
	mov	cx,bx			; Get SWITCHER BITS TO CX

	mov	dx,SX_Descriptor.SXcb_AnalogIncrement
	mov	bx,[si].CRNTVAL		; Get current value pointer

	cmp	[si].UPDOWN,0		; Analog DOWN?
	jnz	PBAdown

	test	cx,SWbit_Polarity
	jnz	PBAdwn
PBAup:	add	[bx],dx			; Add increment to current value
	jmp	PBA_ud

PBAdown:test	cx,SWbit_Polarity
	jnz	PBAup
PBAdwn:	sub	[bx],dx			; Subtract increment to current value


PBA_ud:	mov	bx,[bx]			; Get new value

PBA_bx:	mov	cl,0			; Set for DSK
	cmp	[si].EFXADR,0		; Check for DSK: 0=DSK
	jz	PBA_ea
	mov	cl,Effects_Address

PBA_ea:	mov	ah,al
	mov	al,X_analog		; Read analog signal

	cmp	[si].BITS,0		; Test for 8 or 12 bit value: 0 = 8
	JMP_NZ	SW_analog_12bit_write	; Get the response
	call	SW_analog_8bit_write	; Get the response
PBA_ret:ret


;================================================================
; Read Analog Value
;		AL = Analog Control Type VANA_xxxx
;		AH = 0ffh if Use 12 bit value, else 8 bit
;		CL = Effects_Address
;		DX = SXana_xxxx bit Flag for valid commands
;		BX = Pointer to analog value
PB_read_analog:
	CUTSONLY_TEST

; Test for availability of item
	push	bx
	cmp	cl,0		; Check for downstream stuff
	jz	pbradsk
	call	_GetSXcb_analogbits
	jmp	pbraup
pbradsk:call	_GetSXcb_dskbits
pbraup:	test	bx,dx
	pop	bx
	jz	PB_rdret
;...
	or	ah,ah			; Z=1 if 8 bit value
	pushf
	push	bx

	mov	bl,Effects_Address
	push	bx
	mov	Effects_Address,cl

	call	PBindex

;... 9-15-1993  Added to eliminate unsupported switcher functions
	cmp	al,0ffh
	jz	pbra_ng
;...
	mov	ch,al
	mov	al,X_analog		; Read analog signal
	mov	cl,0ffh			; Send control number in CH
	call	SW_read			; Get the response
	mov	ax,word ptr SX_Rcvbuf + 4
pbra_ng:
	pop	bx
	mov	Effects_Address,bl

	pop	bx
	popf
	jz	PB_rd8
	shr	ax,1
	shr	ax,1
	shr	ax,1
	shr	ax,1
	mov	[bx],ax
	ret

PB_rd8:	mov	al,ah
	xor	ah,ah
	mov	[bx],ax
PB_rdret:
	ret


;================================================================
; Enter with AL=button to press
PGM_press:
	mov	cl, V4SW_ProgramBussSource
	mov	ah,X_program_bus	; Get bus to write to
	jmp	buspres

PST_press:
	mov	cl, V4SW_PresetBussSource
	mov	ah,X_preset_bus		; Get bus to write to
	jmp	buspres

KEY_press:
;;	mov	cl, V4SW_KeyBussSource
	mov	cl, upstream_keynumber
	shl	cl,4
	or	cl, V4SW_KeySource

	mov	ah,X_key1_bus		; Get bus to write to
	jmp	buspres

KEY2_press:
;;	mov	cl, V4SW_Key2Source
	mov	cl, V4SW_KeySource + 20h
	mov	ah,X_key2_bus		; Get bus to write to
	jmp	buspres

buspres:
	CUTSONLY_TEST
	push	cx
	call	getxpt			; Get proper crosspoint
	pop	cx


;;	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	buspres1

	test	VLAN_Flags, forcever3_VLNBIT
	jnz	buspres1
	test	VLAN_Flags, swextended_VLNBIT
	jz	buspres1
	mVlanSwitcherExtendedCommand cl, al, 1, TRUE
buspres1:

	mov	ch,al
	mov	cl,0ffh			; Send out tail
	mov	al,ah
	jmp	SW_write

apst_switch:
	test	Device_Enabled,video_IOTYP ; Enabled?
	JMP_Z	swtchx
	push	ax			; Save the machine number
	mov	Active_IOTYP,audio_IOTYP
	call	PST_press
	pop	ax
	ret

pst_switch:
	test	Device_Enabled,video_IOTYP ; Enabled?
	JMP_Z	swtchx
	push	ax			; Save the machine number
	mov	Active_IOTYP,video_IOTYP
	call	PST_press
	pop	ax
	ret

pswitch:
	mov	cl,preview_IOTYP
	jmp	swtch			; Switch Video

switch:
	mov	cl,video_IOTYP
	call	swtch			; Switch Video

aswitch:
	mov	cl,audio_IOTYP

;................................................................
swtch:
	CUTSONLY_TEST

	mov	Active_IOTYP,cl
	test	Device_Enabled,cl	; Enabled?
	jz	swtchx

	call	_GetSXcb_Flags			; Get switcher Flags

	if ALLOW_VLAN3
		test	bx,SWbit_VLAN		; Check for VLAN switcher
		jz	swtch0
		test	VLAN_Flags, forcever3_VLNBIT
		jnz	swtch00
		test	VLAN_Flags, swextended_VLNBIT
		jnz	swtch0
	swtch00:call	switch_VLAN
		ret
	swtch0:
	endif

	push	ax			; Save machine number
	test	bx,SWbit_nozeroxpt	; Skip any zero crosspoints?
	jz	swtch1
	or	al,al
	jz	swtchbs

; Added more capability for efx mem bus switching
swtch1:	test	EFX_Flag,10000000b	; Check for effects menu active
	jz	swtchpp

	test	EFX_Flag,00000001b	; Preset switch?
	jnz	swtchp

	test	EFX_Flag,00000010b	; Program switch?
	jnz	swtchpp

	test	EFX_Flag,00000100b	; Insert bus switch?

	jz	swtchpp			; Bail out if other

	test	bx,SWbit_singlebus
	jnz	swtchpp
	test	bx,SWbit_GVG10XL
	jnz	swtchpp
	call	KEY_press
	pop	ax
	ret

swtchpp:call	PGM_press
	jmp	swtchbs

swtchp:	test	bx,SWbit_singlebus
	jnz	swtchpp
	test	bx,SWbit_GVG10XL
	jnz	swtchpp
	call	PST_press
swtchbs:pop	ax
swtchx:	ret


;================================================================
; AL = command
; BX = parameter
SendExtendedSwitcher	proc	near
	; Select switcher node
	push	word ptr Active_IOTYP

;; testing
;;	test	Active_IOTYP,video_IOTYP
;;	jnz	ses1
;;	test	Active_IOTYP,audio_IOTYP
;;	jnz	ses1
;;	db	0cch
;;ses1:
;;
;;;;	mov	Active_IOTYP,video_IOTYP
	push	cx

	push	ax
	push	bx
	mov	ax,offset MSW_set_parameter
	call	set_vtrcmd
	pop	bx
	pop	ax

	call	_make_hexbyte
	call	_make_hexword

	mov	al,'#'
	call	vtr_cstore
	call	_GetSXcb_SMPTEadr
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal

	call	vtrcmdx
	call	vtr_answer		; Get a response

	pop	cx
	pop	word ptr Active_IOTYP
	ret
SendExtendedSwitcher	endp

;================================================================
; AL = command
; return AX as the parameter read
GetExtendedSwitcher	proc	near
	; Select switcher node
	push	ax
	mov	Active_IOTYP,video_IOTYP

	mov	ax,offset MSW_read_parameter
	call	set_vtrcmd

	pop	ax
	call	_make_hexbyte

	mov	al,'#'
	call	vtr_cstore
	call	_GetSXcb_SMPTEadr
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal

	call	vtrcmdx
	call	vtr_answer		; Get a response
	call	_hex2bn			; Translate from hex to binary
	ret
GetExtendedSwitcher	endp


;================================================================
;		PREVIEW SWITCHER
; Monitor current machine
; AL = VTR to monitor
public Preview_Switch
Preview_Switch	proc	near
	CUTSONLY_TEST
	push	ax
	test	Device_Present,preview_IOTYP
	jz	jps_xit

	test	Device_Enabled,preview_IOTYP
	jz	jps_xit

	or	al,al	; Record VTR?
	mov	al, 1	; Record preview
	jz	pvws
	mov	al, 2	; Source preview
pvws:	call	pswitch

jps_xit:pop	ax
	ret


Preview_Switch	endp

;================================================================
;		ESAM SWITCH MONITOR
; Monitor current machine
; AL = VTR to monitor
Monitor_Switch:
	CUTSONLY_TEST

	push	ax
	test	Device_Present,audio_IOTYP
	jz	jms_xit

	test	Device_Enabled,audio_IOTYP
	jz	jms_xit

	mov	Active_IOTYP,audio_IOTYP
	call	_GetSXcb_Flags

	test	bx,SWBIT_monitor
	jz	jms_xit

;... 9-18-1993  AMX170 MONITOR MODE
	test	bx,SWBIT_smpte		; SMPTE or ESAM2?
	jz	jms_esam
	or	al,al			; Record vtr?
	mov	al,AX_monitor170
	mov	ch,0
	jnz	jms_doit
	mov	ch,1
jms_doit:
	call	SWindex
	mov	cl,0ffh
	call	SW_write
	jmp	jms_xit

jms_esam:
	call	getxpt		; Get crosspoint to AL
	mov	ch,al
	mov	al,X_MonitorVTR
	mov	cl,0ffh
	call	SW_write
jms_xit:pop	ax
	ret

Mute_On:
	CUTSONLY_TEST
	test	Device_Present,audio_IOTYP
	jz	jmu_xit

	test	Device_Enabled,audio_IOTYP
	jz	jmu_xit

	mov	Active_IOTYP,audio_IOTYP
	call	_GetSXcb_Flags
	test	bx,SWBIT_monitor
	jz	jmu_xit

;... 9-18-1993  AMX170 MONITOR MODE
	test	bx,SWBIT_smpte		; SMPTE or ESAM2?
	jz	jmu_esam
;	GET MUTE ON BY SELECTING SOURCE BLACK
	mov	al,AX_monitor170
	mov	ch,1
	call	SWindex
	mov	cl,0ffh
	call	SW_write		; Select source monitor
	mov	al,blk_dev
	call	aswitch
	jmp	jmu_xit

jmu_esam:
	mov	ch,0
	mov	cl,0ffh
	mov	al,X_MonitorVTR
	call	SW_write
jmu_xit:ret

;================================================================
; Index into the gvg100_pbv/gvg100_pba table and return
;  with the proper one byte pushbutton/lamp
; TABLE IS IN CODE SEGMENT
PBindex:call	_GetSXcb_pbltbl
	xlat
	ret

; Index into the gvg_wipes table and return
;  with the proper pattern assignment
WPindex:call	_GetSXcb_xlatetbl	; Get wipe table xlate address to BX
	or	bx,bx			; Test for translation needed
	jz	WPnoidx			; Jump if not
	cmp	al,[bx]			; See if its in range
	jae	WPoutofrange
	inc	al			; Increment over length byte
	xlat				; Get the proper translated code
WPnoidx:ret

WPoutofrange:
	xor	al,al
	ret

; Index for switcher command in AL
; BX is used
;	AL = COMMAND
SWindex:call	_GetSXcb_commandtbl			; Get command table address
	cmp	al,[bx]
	ja	SWindx
	xlat
SWindx:	ret


;================================================================
;		SETUP PHERIPHERALS FOR AN EDIT
;================================================================
pswitch4edit:
	mov	ah,preview_IOTYP
	jmp	s4ed
;;	xor	al,al
;;	call	pswitch
;;	ret

aswitch4edit:
	mov	ah,audio_IOTYP
	jmp	s4ed

;================================================================
switch4edit:
 	mov	ah,video_IOTYP

s4ed:	test	Device_Present,ah	; Switcher present?
	jz	s4ex

	mov	Active_IOTYP,ah

	call	_GetSXcb_masks
	test	bx,SXspcl_ResetToStart	; Mainly for the Alladin
	jz	sw4nas
	mov	al, X_goto_start
	mov	cx,000ffh		; Send dummy byte
	call	SW_write
sw4nas:
	mov	ah,Active_IOTYP
	test	Device_Enabled,ah	; Switcher enabled?
	jz	s4ex

	;If Preview switcher
	cmp	ah, preview_IOTYP
	jz	sw4ed1a
	;...

		call	_GetSXcb_Flags
		test	bx,SWbit_VLAN		; Check for VLAN switcher
		jz	sw4ed0
		call	SetVlanEfxAddress

		if ALLOW_VLAN3
		test	VLAN_Flags, forcever3_VLNBIT
		jnz	sw4ed1a
		endif

		test	VLAN_Flags, swextended_VLNBIT
		jnz	sw4ed0
sw4ed1a:call	_vlan_switcher_trigger
	ret
sw4ed0:
	cmp	Vtr_Mult_Type,V_vbv
	jnz	sw4ed0a
	mov	al,blk_dev
	jmp	switch_audio_video

sw4ed0a:cmp	Vtr_Mult_Type,V_bvb
	jnz	sw4ed0b
	mov	al,blk_dev
	jmp	switch_audio_video

sw4ed0b:mov	al,To_Machine
	cmp	Trans_Type,'C'		; Check for 
	jnz	sw4ed1
	jmp	switch_audio_video
sw4ed1:	cmp	Trans_Type,'S'		; Check for
	jnz	sw4ed2
	jmp	switch_audio_video

s4ex:	ret

; Process a Dissolve or Wipe by setting BOTH inpoints
sw4ed2:	call	read_all_analog
	cmp	Trans_Type,'K'
	jz	sw4key

	call	_GetSXcb_Flags
	test	bx,SWBIT_smpte		; SMPTE?
	jz	sw4ed2aa
	test	Active_IOTYP,video_IOTYP
	jz	sw4ed2aa
	call	SW_bkgd			; Turn on the bkg trans button
sw4ed2aa:
	mov	al,From_Machine		; Set in and out of from machine
	call	PGM_press
	mov	al,To_Machine
	call	PST_press
	cmp	Trans_Type,'D'
	jnz	swed2a

	call	_GetSXcb_masks
	test	bx,SXspcl_SetLayers	; Mainly for the Alladin
	jz	sw4nlr
	mov	al,0
	call	KEY_press
	mov	al,0
	call	KEY2_press

sw4nlr:	call	A_trans			; Set transition rate
	jmp	SW_mix

swed2a:	cmp	Trans_Type,'W'
	jnz	swed2b

	call	_GetSXcb_masks
	test	bx,SXspcl_SetLayers	; Mainly for the Alladin
	jz	sw4nlrw
	mov	al,From_Machine
	call	KEY_press
	mov	al,To_Machine
	call	KEY2_press
sw4nlrw:
	call	A_trans			; Set transition rate
	call	Wipe_Code
	jmp	SW_wipe
swed2b:	ret

; Set up key parameters
sw4key:	mov	al,Keybkgnd_Src		; Set the program source
	call	PGM_press
	mov	al,Keyfor_Src		; Set the key source
	call	KEY_press
	call	SW_key			; Turn on the KEY trans button

	;; Check for VLAN switcher
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	key_std
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	key_std
	test	VLAN_Flags, swextended_VLNBIT
	jz	key_std

;; VLAN DIRECT CONTROL SWITCHER KEYING SETUP
	cmp	Key_Mode,0		; Check mode type
	jz	svkeyon			; 0 = key already on at edit
	call	K_trans			; Set key transition
	cmp	Key_Mode,2		; Key out?
	jz	svkeyin

; Must be KEY IN, so turn off keyer if currently ON
	call	SW_key_OFF
	jmp	svkxit
svkeyon:mov	Autotrans_Flag,0	; Turn off autotrans
svkeyin:call	SW_key_ON
svkxit:	ret



;; STANDARD SWITCHER KEYING SETUP
key_std:cmp	Key_Mode,0		; Check mode type
	jz	swkeyon			; 0 = key already on at edit
	call	K_trans			; Set key transition
	cmp	Key_Mode,2		; Key out?
	jz	swkeyin


; Must be KEY IN, so turn off keyer if currently ON
	call	SW_KEY_test
	jz	swkxit			; Jump if button OFF
	call	SW_key_OFF
	jmp	SW_cut

swkeyon:mov	Autotrans_Flag,0	; Turn off autotrans

swkeyin:call	SW_KEY_test
	jnz	swkxit
	call	SW_key_ON
	jmp	SW_cut
swkxit:	ret

;................................................................
;................................................................
; Perform an audio or video switcher switch
switch_audio_video:
	mov	cl,Active_IOTYP
	test	cl, video_IOTYP
	jz	sava
	jmp	swtch			; Switch Video
sava:	jmp	aswitch


;;sava:	test	cl, audio_IOTYP
;;	jz	savb
;;	jmp	aswitch
;;savb:	jmp	pswitch


;................................................................
Wipe_Code:
	mov	Active_IOTYP,video_IOTYP

	call	_GetSXcb_Flags
	test	bx,SWbit_WipeMods ; Force wipe modifiers?
	mov	bx,Trans_Code	  ; (Save some bytes, get set up for anything
	JMP_Z	Wipe_Direct	  ; Jump if NOT
	test	Switcher_Flags,wipemods_SWBIT
	JMP_Z	Wipe_Direct

	cmp	bx,100		; Just a normal wipe?
	jc	Wipe_fwd
	sub	bx,100		; Reverse wipe?
	cmp	bx,100
	jc	Wipe_rev
	sub	bx,100		; Soft Fwd wipe?
	cmp	bx,100
	jc	Wipe_sftfwd
	sub	bx,100		; Soft Rev wipe?
	cmp	bx,100
	jc	Wipe_sftrev
	sub	bx,100		; border fwd wipe?
	cmp	bx,100
	jc	Wipe_bdrfwd
	sub	bx,100		; Border rev?
	cmp	bx,100
	jc	Wipe_bdrrev
	sub	bx,100		; Sft Bdr Fwd wipe?
	cmp	bx,100
	jc	Wipe_sftbdrfwd
	sub	bx,100		; Sft Bdr Rev wipe?
	cmp	bx,100
	jc	Wipe_sftbdrrev
	ret

Wipe_fwd:
	push	bx
	call	SW_reverse_off
	call	SW_soft_off
	call	SW_bdr_off
	pop	bx
	call	Wipe_Direct
	ret

Wipe_rev:
	push	bx
	call	SW_soft_off
	call	SW_bdr_off
	call	SW_reverse_on
	pop	bx
	call	Wipe_Direct
	ret

Wipe_sftfwd:
	push	bx
	call	SW_reverse_off
	call	SW_bdr_off
	call	SW_soft_on
	pop	bx
	call	Wipe_Direct
	ret

Wipe_sftrev:
	push	bx
	call	SW_bdr_off
	call	SW_soft_on
	call	SW_reverse_on
	pop	bx
	call	Wipe_Direct
	ret

Wipe_bdrfwd:
	push	bx
	call	SW_reverse_off
	call	SW_soft_off
	call	SW_bdr_on
	pop	bx
	call	Wipe_Direct
	ret

Wipe_bdrrev:
	push	bx
	call	SW_soft_off
	call	SW_bdr_on
	call	SW_reverse_on
	pop	bx
	call	Wipe_Direct
	ret

Wipe_sftbdrfwd:
	push	bx
	call	SW_reverse_off
	call	SW_soft_on
	call	SW_bdr_on
	pop	bx
	call	Wipe_Direct
	ret

Wipe_sftbdrrev:
	push	bx
	call	SW_soft_on
	call	SW_bdr_on
	call	SW_reverse_on
	pop	bx
	call	Wipe_Direct
	ret

; BL has wipe code
Wipe_Direct:			; Send out exact wipe code to switcher
	mov	al,bl
	mov	ah,0
wpdd:	cmp	ax,100
	jb	wpdr
	sub	ax,100
	jmp	wpdd

wpdr:	or	al,al		; Check for zero wipe code
	jnz	wpdr1		; Skip if > 0
	inc	al		;  Else, default to 1
wpdr1:	mVlanSwitcherExtendedCommand V4SW_WipdPatternNumber, ax
	mov	al,bl
	call	WPindex
	mov	ch,al
	mov	al,X_pattern
	mov	cl,0ffh
	call	SW_write
	ret


Toggle_Active_Bus:
	mov	al,EFX_Flag		; Get Flag
	mov	ah,al
	and	ah,11111000b

	test	al,00000001b		; Check for preset bus
	jnz	TAB_next
	test	al,00000010b		; Check for program bus
	jnz	TAB_next
	mov	al,00000001b
	jmp	TAB_1st			; Check for insert bus
TAB_next:
	shl	al,1
TAB_1st:or	al,ah
	mov	EFX_Flag,al
	ret


;================================================================
;		EMEM REGISTER LOADING AND RETRIEVING
;================================================================

ememopts:
	test	Switcher_Flags,extmenu_SWBIT
	jz	ememopt0
	jmp	shell2switcher
ememopt0:	
	CUTSONLY_TEST

	if (NOT DEMO_RELEASE) AND (NOT DEVELOPMENT)
	test	Device_Present,video_IOTYP
	jz	ememxr
	endif

	mov	Active_IOTYP,video_IOTYP
	call	_GetSXcb_Flags
	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jnz	ememxr

	mov	Input_Flag,INFL_menu

	or	EFX_Flag,10000000b	; Tell all who care we're active


	call	A_trans			; Reset auto trans
;;;	call	SW_positionerON

	mov	bx,offset Video_Header
	cmp	byte ptr [bx],0
	jz	ememop1
	mov	Cursor,offset Title2_Scr
	call	_line_erase
	call	_cntrtxt
ememop1:call	_EFXscreen
	jmp	ememprm

ememagn:xor	al,al
	cmp	Fullscreen_Flag,al	; Coming back from full screen mode?
	jz	emmnfs
	mov	Fullscreen_Flag,al
	call	screen_init		; Init screen if YES
	jmp	ememop1

emmnfs:	mov	ax,Input_Flag		; Mmmm where were we...
	test	ax,INFL_menu
	jnz	emmevnt
	test	ax,INFL_speed
	jz	ememprm
emmevnt:call	_EFXscreen

ememprm:call	emem_status_line

	call	rdchar
	cmp	ax,offset Ememopts_xcmd
	jz	ememx
	cmp	ax,offset Escape_xcmd
	jnz	emem1
ememx:	call	_evnt_dispthis
	MOV	ERROR_ACTIVE,0
ememxr:	ret

emem1:
	call	KeyCommand_EFXMEM
	jz	emem_3
	jmp	ememagn

emem_3:	mov	Active_IOTYP,video_IOTYP
	call	[si]
	jmp	ememagn

;----------------------------------------------------------------
emem_status_line:
	if ALLOWED_VTRS EQ 7
	call	_kbd_cln
	dim_VIDEO FALSE,FALSE
	mov	bx,offset joymode_msg
	call	_comsg

	norm_VIDEO FALSE,FALSE
	mov	al,JOYMODE
	mov	cl,joynamesize
	mul	cl
	mov	bx,offset JOYMODE_NAMES
	add	bx,ax
	call	_comsg

	dim_VIDEO FALSE,FALSE
	call	_Space_Out
	mov	bx,offset activebus_msg
	call	_comsg

	mov	al,EFX_Flag
	mov	bx,offset BUS_NAMES
	test	al,00000001b	; Preset switch?
	jnz	esldisp
	add	bx,busnamesize
	test	al,00000010b	; Program switch?
	jnz	esldisp
	add	bx,busnamesize
	test	al,00000100b	; Insert bus switch?
	jnz	esldisp
	add	bx,busnamesize
esldisp:norm_VIDEO FALSE,FALSE
	call	_comsg
	ENDIF	; if ALLOWED_VTRS EQ 7

	ret


;================================================================
EFXscreen:
	call	_EFXscreen
	ret

;================================================================
; Read emems from switcher and store them
; ENTER: CL = EMEM# 0-xx
; Exit: BX points to SX_Rcvbuf which holds the EMEM register
READ_emem_FAR	proc	far
	call	READ_emem
	ret
READ_emem_FAR	endp

READ_emem:
	mov	al,video_IOTYP
	test	Device_Present,al
	jz	reademx
	mov	Active_IOTYP,al

	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Test for VLAN
	jnz	ReadEmemFromVlan

	; CLEAR OUT BUFFERS -- USED MAINLY FOR TESTING PURPOSES
	call	ClearDirbuf
	call	ClearSxRcvBuf

	mov	ch,cl				; Register # to CH
	mov	cl,0ffh
	mov	al,X_xferemem
	call	SW_read				; Read EMEM

	call	CopyRcvToDirbuf
	mov	bx,offset dirbuff
reademx:ret

; Copy the contents of SX_Rcvbuf to DIRBUFF
CopyRcvToDirbuf	proc	near
	push	ax
	push	cx
	push	si
	push	di
	push	es
	push	ds
	pop	es
	mov	si,offset SX_Rcvbuf	; DI is pointer to buffer start
	mov	di,offset dirbuff
	mov	cx,sx_buf_len / 2
	rep movsw
	pop	es
	pop	di
	pop	si
	pop	cx
	pop	ax
	ret
CopyRcvToDirbuf	endp

ClearSxRcvBuf	proc	near
	push	ax
	push	cx
	push	si
	push	di
	push	es
	push	ds
	pop	es
	mov	di,offset SX_Rcvbuf	; DI is pointer to buffer start
	mov	cx,sx_buf_len / 2
	xor	ax,ax
	rep stosw
	pop	es
	pop	di
	pop	si
	pop	cx
	pop	ax
	ret
ClearSxRcvBuf	endp

ClearDirbuf	proc	near
	push	cx
	push	es
	push	ds
	pop	es
	mov	di,offset dirbuff
	mov	cx,MAXEMEMLENGTH / 2
	xor	ax,ax
	rep stosw
	pop	es
	pop	cx
	ret
ClearDirbuf	endp

ReadEmemFromVlan:
	push	es
	push	ds
	pop	es
	push	cx

	call	ClearDirbuf
	mov	di,offset dirbuff

	call	_GetSXcb_SMPTEadr
	mov	ch,bl
	mov	cl,VX_DIGITch		; Use exact digit in CH
	mov	ax,offset M_node_address
	call	vtr_cmd
	pop	cx

	mov	dl,bl			; Node number to DL
	mov	ch,cl			; EMEM register number to CH
	mov	cl,VX_HEXch		; Send two byte hex data
	mov	ax,offset MSW_upload_emem
	call	vtr_cmd
REFVlp1:
	mov	ax,offset MSW_read_packet
	xor	cx,cx
	call	vtr_sendcmd
	mov	cl,70
	call	GetVlanRecord
	mov	si,bx

	cmp	[si.VSE_escape], 1bh	; Check for a proper VLAN record
	jnz	REFVxit

	cmp	[si.VSE_type], 20h	; Check for correct packet type
	jnz	REFVxit

	mov	ax,[si.VSE_sequence]	; Get sequence number

	push	cx
	mov	cx,64/2
	add	si,OFFSET ZeroBase.VSE_data
	rep movsw
	pop	cx

	cmp	ax, 0ffffh
	jnz	REFVlp1

REFVxit:mov	bx,offset dirbuff
	pop	es	
	ret

;================================================================
; Write emem back two switcher
; ENTER: BX points to buffer to write to switcher
WRITE_emem_FAR	proc	far
	call	WRITE_emem
	ret
WRITE_emem_FAR	endp

WRITE_emem:
	mov	al,video_IOTYP
	test	Device_Present,al
	jz	writemx
	mov	Active_IOTYP,al

	push	bx
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Test for VLAN
	pop	bx
	jnz	WriteEmemToVlan

	call	SX_send
	call	SX_receive		; Get ACK
writemx:ret

WriteEmemToVlan:
	push	cx
	push	es
	push	ds
	pop	es

	push	cx
	mov	si,bx			; Save source buffer pointer
	call	_GetSXcb_SMPTEadr
	mov	ch,bl
	mov	cl,VX_DIGITch		; Use exact digit in CH
	mov	ax,offset M_node_address
	call	vtr_cmd
	pop	cx

	mov	ch,cl			; EMEM register number to CH
	mov	cl,VX_HEXch		; Send two byte hex data
	mov	ax,offset MSW_download_emem
	call	vtr_cmd

	mov	di,0001h		; Record counter
	mov	dl,[si]			; Get length
WEFVlp1:mov	ax,offset MSW_write_packet
	call	set_vtrcmd
	mov	bx,di
	mov	al,bl
	call	vtr_cstore
	mov	al,bh
	call	vtr_cstore
	inc	di
	mov	bx,si
	mov	cl,64
	call	vtr_msgstorecl
	mov	al,cr
	call	vtr_cstore
	mov	si,bx
	sub	dl,64
	mov	bx, offset Vtr_Sndbuf
	jns	WEFVlp2
	mov	word ptr [bx + 3], 0ffffh
	call	WriteOneEmem
	jmp	WEFVxit
WEFVlp2:call	WriteOneEmem
	jmp	WEFVlp1

WEFVxit:pop	es
	pop	cx
	ret

WriteOneEmem:
	mov	cl,70
	call	SendVlanMsgCl
	call	vtr_answer
	cmp	byte ptr [bx],'0'	; Zero means write was ok
	jz	woer
	call	_error_bell
woer:	ret

;================================================================
; Get and store switcher setup
SW_learn	proc	near
	mov	dx,offset EMEMrdsw_ovr
	call	RqstEmemNumber
	jc	swlrnx
	call	SaveEmemToSwitcher
swlrnx:	ret
SW_learn	endp

;================================================================
SW_recall	proc	near
	push	cx
	mov	dx,offset EMEMwrtsw_ovr
	call	RqstEmemNumber
	jc	swememx
	mov	cl,al
	call	RecallEmemToSwitcher
swememx:pop	cx
	ret
SW_recall	endp

; CX = EMEM trigger
SaveEmemToSwitcher	proc	near
	mov	Active_IOTYP,video_IOTYP

	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	sets422
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	setsxit
	test	VLAN_Flags, swextended_VLNBIT
	jz	sets422


	call	SetEMEMEfxAddress
	mVlanSwitcherExtendedCommand V4SW_SaveEmem, AX
	call	SetVlanEfxAddress

sets422:mov	ch,al			; Get emem digit
	mov	al,X_lrnemem
	mov	cl,0ffh
	mov	Active_IOTYP,video_IOTYP
	call	SW_write
setsxit:ret

SaveEmemToSwitcher	endp

; Enter: CL = EMEM Register, CH = effects bank, AH = command type
RecallEmemToSwitcher	proc	near
	push	cx			; Save CX in case of CH=9 trig

	mov	Active_IOTYP,video_IOTYP

	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	rets422
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	retsxit
	test	VLAN_Flags, swextended_VLNBIT
	jz	rets422
	pop	cx
	call	SetEMEMEfxAddress
	mVlanSwitcherExtendedCommand V4SW_recallEmem, cx
	call	SetVlanEfxAddress

rets422:mov	ch,cl			; Get emem digit
	mov	al,X_rclemem
	mov	cl,0ffh
	mov	Active_IOTYP,video_IOTYP
	call	SW_write

retsxit:pop	cx
	ret
RecallEmemToSwitcher	endp


; Prompt user with BX string for a number
; Carry set if input aborted, else number returned >= 0 in AX and DX
RqstEmemNumber	proc	near
	call	_kbd_cln
	mov	bx,dx
	call	_msgread
	mov	al,2
	call	dec_cimsg
	stc
	jz	renx
	call	_convert2bin
	clc
renx:	ret
RqstEmemNumber	endp

EFX_rehearse:
	mov	bx,offset Preview_Msg
	call	_kbd_message
	mov	bx,offset Emem_File_Msg
	call	_comsg
	call	_Space_Out
	mov	al,'#'
	call	_ConOut
	mov	al,2
	call	dec_cimsg
	jz	EFX_xit
	mov	Active_IOTYP,video_IOTYP
	call	_convert2bin
	mov	ch,1			; Trigger now command
	mov	cl,al
	jmp	TRIG_em
EFX_xit:ret

EFX_sethalfefx:
	call	SW_read_fader
	call	SW_read_bdr
	call	SW_read_soft
	call	SW_read_H
	call	SW_read_V
	mov	bx,FaderPosition
	mov	SplitFader,bx
	ret

EFX_halfefx:
; BX has binary number 0 - 4047
; AL has the correct command
; AH has control nuber
; CL has effects address
	mov	Active_IOTYP,video_IOTYP
	mov	bx,SplitFader		; 50% lever arm
EFX_fader:
	mov	FaderPosition,bx
	mov	al,5			; Write analog
	mov	ah,0			; Lever arm
	mov	cl,Effects_Address
	jmp	SW_analog_12bit_write

; SET AUTO TRANSITION RATE
EFX_autotrans:
	mov	bx,offset Trans_Length
	call	GetEFX_rate
	mov	al,X_autorate
	jmp	SetRate

;;Dsk_Trans
;;Ftb_Trans
EFX_dskrate:
	mov	bx,offset Dsk_Trans
	call	GetEFX_rate
	mov	al,X_dskrate
	jmp	SetRate

EFX_ftbrate:
	mov	bx,offset Ftb_Trans
	call	GetEFX_rate
	mov	al,X_ftbrate
	jmp	SetRate

SetRate:mov	bx,[bx]
	mov	Active_IOTYP,video_IOTYP
	jmp	SW_long_write

;================================================================
; Get a transition rate and return with BX pointing to 16 bit value
; Enter BX->(WORD) destination buffer
; Exit pointing to rate
GetEFX_rate:
	push	di
	mov	di,bx			; Save destination
	mov	ax,[bx]			; Get the WORD duration
	mov	bx,offset Last_Duration	; and store it in Last_Duration
	mov	[bx],ax	
	mov	byte ptr 2[bx],0
	mov	bx,offset dur_rqst	; Display prompt
	call	_Inout_init
	mov	cl,0			; No + or -
	mov	ch,DF_CHAR		; Use real time
	mov	bx,offset Last_Duration	; Use requested buffer
	call	tc_parenth		; Display old trim
	mov	Trim_Ci_Flag,0
	mov	al,NDF_CHAR
	mov	bx,offset Elaptm	; Get duration
	call	tc_cimsg		; From user
	jnc	EFXat1
EFXrclr:mov	bx,di
	mov	word ptr [bx],0
	jmp	EFXrtx

EFXat1:	call	_time_value
	jnz	EFXat2
	mov	bx,di
EFXat2:	mov	dx,di			; Save the value...
	mov	ax,[bx]
	xchg	bx,dx
	mov	[bx],ax
EFXrtx:	pop	di
	ret

;================================================================
Change_wipecode:
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Wipe_Msg
	call	_kbd_message
	call	_Space_Out
	mov	bx,offset Code_Msg
	call	_comsg
	mov	al,3
	call	dec_cimsg
	jz	chwcx
	call	_convert2bin
	mov	Trans_Code,dx
	call	Wipe_Code
chwcx:	ret

;================================================================
;================================================================
;
;		SWITCHER I/O ROUTINES
;
;================================================================
;================================================================
; Send a three digit command to switcher (trans rate, etc)
; or, if ESAM switcher, send binary WORD out, MSB, LSB order
; BX has binary number 1 - 999
; AL has the correct command
SW_long_write:
	push	bx
	call	SWindex			; Get command
	call	_GetSXcb_Flags
	test	bx,SWBIT_smpte		; SMPTE or ESAM2?
	jnz	SWlw1

;ESAM Proceedures ................
	or	al,ESAM2_write
	pop	bx
	push	es			; Set extra seg = data seg
	mov	di,ds
	mov	es,di
	mov	di,offset SX_Sndbuf	; DI is pointer to buffer start
	mov	byte ptr [di],4		; Set command length to 4 bytes
	inc	di			; DI points to start of message buffer
	mov	cl,Audio_Effects_Address	; EFFECTS ADDRESS
	mov	[di],cl
	inc	di
	stosb				; Store command byte
	mov	al,bh
	stosb
	mov	[di],bl
	pop	es
	jmp	send2switcher


SWlw1:	call	SetWriteBit		; Or in write bit
	pop	bx
	push	es			; Set extra seg = data seg
	mov	di,ds
	mov	es,di
	mov	di,offset SX_Sndbuf	; DI is pointer to buffer start
	mov	byte ptr [di],5		; Set command length to 5 bytes
	inc	di			; DI points to start of message buffer
	mov	cl,Effects_Address	; EFFECTS ADDRESS
	mov	[di],cl
	inc	di
	stosb				; Store command byte
	mov	ax,bx			; Get binary number
	mov	cl,100
	div	cl
	stosb				; Xxx
	mov	al,ah
	xor	ah,ah
	mov	cl,10
	div	cl
	stosb				; xXx
	mov	al,ah
	stosb				; xxX
	pop	es
	jmp	send2switcher

;================================================================
; SEND A FIVE (5) BYTE ANALOG COMMAND, ROTATE 16BITS INTO UPPER 12
; Send an analog value, 0 - 4047, to switcher
; BX has binary number 0 - 4047
; AL has the correct command
; AH has control number
; CL has effects address
SW_analog_12bit_write:
	push	bx
	call	SWindex			; Get command
	call	SetWriteBit		; Or in write bit
	pop	bx
	push	es			; Set extra seg = data seg
	mov	di,ds
	mov	es,di
	mov	di,offset SX_Sndbuf	; DI is pointer to buffer start
	mov	byte ptr [di],5		; Set command length to 5 bytes
	inc	di			; DI points to start of message buffer
	mov	[di],cl			; STORE EFFECTS ADDRESS
	inc	di
	stosb				; Store command byte
	mov	al,ah
	stosb				; Store control number
	mov	ax,bx			; Get binary number
	shl	ax,1			; Rotate to the
	shl	ax,1			;  upper 12 bits
	shl	ax,1
	shl	ax,1
	stosw				; Xxx
	pop	es
	jmp	send2switcher

;================================================================
; SEND A FIVE (5) BYTE ANALOG COMMAND, ROTATE 16BITS INTO UPPER 12
; Send an analog value, 0 - 4047, to switcher
; BX has binary number 0 - 4047
; AL has the correct command
; AH has control number
; CL has effects address
SW_analog_8bit_write:
	push	bx
	call	SWindex			; Get command
	call	SetWriteBit		; Or in write bit
	pop	bx
	push	es			; Set extra seg = data seg
	mov	di,ds
	mov	es,di
	mov	di,offset SX_Sndbuf	; DI is pointer to buffer start
	mov	byte ptr [di],5		; Set command length to 5 bytes
	inc	di			; DI points to start of message buffer
	mov	[di],cl			; STORE EFFECTS ADDRESS
	inc	di
	stosb				; Store command byte
	mov	al,ah
	stosb				; Store control number
	mov	ah,bl			; Use upper 8 bits
	mov	al,0
	stosw				; Xxx
	pop	es
	jmp	send2switcher

;================================================================
; AL = command
; CL = 0FFH if tail byte in CH
; CH = tail byte if CL 0ffh
SW_read:call	SWindex			; Get command
	or	al,X_read		; Or in READ bit
	jmps	SW_cmd

SW_write:
	call	SWindex			; Get command
	call	SetWriteBit		; Set correct write bits

SW_cmd:	push	es
	cmp	al,0ffh
	jz	sw10xx

	mov	di,ds
	mov	es,di

	mov	dl,Active_IOTYP
	test	Device_Present,dl	; Switcher present?
	jz	SW_cmdr

	mov	di,offset SX_Sndbuf	; DI is pointer to buffer start
	xor	dh,dh			; Use DH as character counter
	mov	[di],dh			; Zero character Count
	inc	di			; DI points to start of message buffer
	call	_GetSXcb_Flags		; Get switcher descriptor byte 1 to BX

	test	bx,SWbit_VLAN		; Check for VLAN switcher
	jnz	sw10xx

	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jnz	switch_10x

	test	dl,audio_IOTYP
	mov	dl,Effects_Address	; EFFECTS ADDRESS
	jz	SW_cmdefx
	mov	dl,Audio_Effects_Address
SW_cmdefx:
	mov	[di],dl
	inc	di
	inc	dh
	stosb				; Store command to buf
	inc	dh
	cmp	cl,0ffh
	jnz	SW_cmdc
	mov	[di],ch
	inc	dh
SW_cmdc:mov	byte ptr SX_Sndbuf,dh
	pop	es
SW_cmdx:jmp	send2switcher

sw10xx:	clc
SW_cmdr:pop	es
	ret

; Do for a 10XL switcher
; Audio is high nibble, video is low nibble
switch_10x:
	cmp	al,0c1h			; Write commands only
	jnz	sw10xx
	stosb				; Store write command to buf
	inc	dh
	mov	al,ch			; Get crosspoint

	mov	ah,Preview_Mode		; Get type of switcher
	test	ah,video_Emode		; Video switch?
	jz	sw10xa			; No, do audio
	and	ah,audall_Emode		; Isolate audio bits
	or	ah,ah			; Audio, too?
	jnz	sw10xb			; Do both

; Send last high nibble and new low nibble
sw10xv:	mov	ah,Last_Preview_XPT	; Use last video crosspoint
	and	ah,audall_Emode		; Mask out last audio
	jmp	sw10x9

; Send last low nibble and new high nibble
sw10xa:	mov	ah,Last_Preview_XPT	; Use last audio crosspoint
	and	ah,not audall_Emode	; Mask out old audio
	shl	al,1			;  Rotate into 
	shl	al,1			;  Audio bits
	shl	al,1
	shl	al,1
	jmp	sw10x9

; Send new high and low nibble
sw10xb:	mov	ah,al			; Duplicate it
	shl	ah,1			;  and send
	shl	ah,1			;  it off as
	shl	ah,1			;  both video
	shl	ah,1			;  and audio

sw10x9:	or	al,ah			; Combine old and new
	stosb
	mov	Last_Preview_XPT,al	; Last crosspoint selected
	inc	dh
	mov	byte ptr SX_Sndbuf,dh
	pop	es
	call	send2switcher
	test	bx,SWbit_frmdelay	; Test for FRAME DELAY
	jz	sw10nfd
	push	cx
	mov	cx,75
sw10dly:call	_delms
	loop	sw10dly
	pop	cx
sw10nfd:ret

;================================================================
; Send the entire line at SX_Sndbuf out to the switcher and
;  attempt to get an ACK
send2switcher:
	push	bx
	mov	cx,2			; Attempt message these many times
swagn:	mov	bx,offset SX_Sndbuf
	call	SX_send
	call	SX_receive		; Get ACK
	jc	swspol			; Select again if timeout
switchx:pop	bx
	mov	ah,byte ptr SX_Rcvbuf + 2
	ret

swspol:	push	ax
	mov	ah,0bh
	int	DOS
	pop	ax
	test	al,00010000b		; COMMAND NOT EXECUTED? (PRODIGY only)
	jnz	switchx			; Just return
	loop	swagn

	push	bx
	mov	bx,offset Msg_Area
	call	_dircur_lerase
	mov	al,Active_IOTYP
	mov	bx,offset audcontrol_ovr
	test	al,audio_IOTYP
	jnz	swspole
	mov	bx,offset vidcontrol_ovr
	test	al,video_IOTYP
	jnz	swspolo

swspole:call	_msgread
swspolo:mov	bx,offset Nxptcom_Msg
	call	_comsg
	mov	al,']'
	call	_ConOut
	pop	bx
	mov	al,Active_IOTYP
	not	al
	and	Device_Present,al		; Disable switcher present Flag
	call	rdchar
	jmp	switchx

;================================================================
SX_send:push	bx			; Save command buffer address
	call	_GetSXcb_Flags			; Get descriptor
	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jz	sws2

; 10X Switcher prefix messages
	push	bx
	call	send_Break		;Send Break 
	call	_GetSXcb_SMPTEadr
	mov	al,bh			; msb address
	call	mdmout
	mov	al,bl			; lsb address
	call	mdmout
	pop	bx
	test	bx,SWbit_esccrc		; Send escape character?
	jz	sws2
	mov	al,3			; Send ESCAPE
	call	mdmout

; GVG 100 switchers
sws2:	mov	dx,bx			; Save switcher descriptor
	pop	bx			; Get buffer address
	mov	cl,[bx]			; Get length of message
	or	cl,cl
	jz	swsxit
	inc	cl			; Include the length byte, too
	xor	ch,ch			; Clear checksum counter
swslp:	mov	al,[bx]
	adc	ch,al
	call	mdmout
	inc	bx
	dec	cl
	jnz	swslp
	test	dx,SWbit_esccrc		; Send checksum?
	jz	swsxit
	neg	ch			; Calculate CHECKSUM
	mov	al,ch
	jmp	mdmout			;  and send CHECKSUM
swsxit:	ret


;================================================================
;		Receive Switcher information
;================================================================
; Exit:	BX points to SX_Rcvbuf
; Carry set (1) if any error
; AL Bits have errors:
;	Bit 7	Command accepted
;	Bit 6	Protocol Error (timeout error or NAK received)
;	Bit 5	Buffer Warning
;	Bit 4	Command not executed (PRODIGY switchers only)
; AL = 0ffh if local timeout
SX_receive:
	call	_GetSXcb_Flags		; Get descriptor
	mov	dx,bx			;  to dx

	mov	bx,offset SX_Rcvbuf
	mov	byte ptr [bx],0

	test	dx,SWBIT_smpte		; Check for SMPTE Ack/Nack
	jnz	srsmpte

; Process ESAM information
	call	sragn			; Get response
	jc	srxto
	cmp	al,2			; Data follows?
	jz	sr1			; Get data
	jmp	sraccept


; Do GVG 10XL type switcher
srsmpte:test	dx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jz	sr1			; Skip if not
	call	sragn			; Get ACK/NACK from switcher
	jc	srxto
	cmp	al,5			; Check for protocol error
	jz	sr10xer
sraccept:
	mov	al,80h			; Set "command accepted" bit
	mov	byte ptr [bx],1		; Else save as
	mov	1[bx],al		;  a one byte string
	clc
	jmp	srxit
sr10xer:xor	al,al
	jmp	srxitc
	
;----------------------------------------------------------------
; Try for byte Count or status byte
sr1:	call	sragn			; Get byte Count
	jc	srxto
	test	al,10000000b	;84h	; Ack?
	jz	sr1cnt
	mov	byte ptr [bx],1
	inc	bx
	jmp	sr1stat

sr1cnt:	mov	[bx],al			; Save byte Count
	inc	bx
	cmp	al,1			; Is it a possible status byte?
	jnz	sr1a			; No, get more
	call	sragn			; Get status byte
;;;;	jc	srxto
sr1stat:
	mov	[bx],al
	test	al,10000000b		; Command accepted?
	jnz	srxit
	jmp	srxitc

; Get more bytes
sr1a:	mov	cl,al			; Count to CL
	xor	ch,ch			;  and make a word
sr2:	call	sragn
	jc	srxto
	mov	[bx],al
	inc	bx
	loop	sr2
srxto:	mov	al,0ffh			; Timeout error
srxitc:	call	srxit
	stc
	ret

srxit:	call	_GetSXcb_masks
	test	bx,SXspcl_WaitField	; Mainly for the Alladin
	jz	srxit1
	call	_delfrm
srxit1:	mov	bx,offset SX_Rcvbuf
	ret


;----------------------------------------------------------------
; Return with crosspoint in AL for machine in AL
getxpt_FAR	proc	far
	call	getxpt
	ret
getxpt_FAR	endp

getxpt:	push	ax
	cbw
	MULTIPLY_BY Vtrcb_length, AX	;Index to correct crosspoint
	mov	bx,ax
	pop	ax
	test	Active_IOTYP,audio_IOTYP
	mov	al,byte ptr [bx + Vtrcb.Vtrcb_AXPT]	; Get crosspoint to AL
	jnz	getxpt1
	mov	al,byte ptr [bx + Vtrcb.Vtrcb_VXPT]
getxpt1:call	_GetSXcb_Flags
	test	bx,SWbit_xptplus1			; If NZ, Black = 1
	jz	getxptx
	inc	al
getxptx:ret


;================================================================

JMENU_rev:
	call	test_analog_present
	jz	jmrevx
	cmp	JOYMODE, 0
	jnz	jmrev
	mov	JOYMODE,jmenusize
	ret
jmrev:	dec	JOYMODE
	call	joymode_test
	jz	JMENU_rev
jmrevx:	ret

JMENU_fwd:
	call	test_analog_present
	jz	jmfwdx
	cmp	JOYMODE,jmenusize
	jnz	jmfwd
	mov	JOYMODE,0
jmfwdx:	ret
jmfwd:	inc	JOYMODE
	call	joymode_test
	jz	JMENU_fwd
	ret

joymode_test:
	mov	ax,1
	mov	cl,JOYMODE
	cmp	cl,14
	ja	jytdsk
	call	_GetSXcb_analogbits
	jmp	jytp

jytdsk:	sub	cl,15
	call	_GetSXcb_dskbits
jytp:	shl	ax,cl
	test	bx,ax
	ret

test_analog_present:
	call	_GetSXcb_analogbits
	mov	ax,bx
	call	_GetSXcb_dskbits
	or	ax,bx
	ret

;================================================================
swjoyret:	ret
	even
SWjoystick:
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	push	iAnalogIncrement

	call	_jstick		; Get X to BX, Y to DX
	call	_joy_convert
	mov	si,offset Swjstick_Table
	mov	al,[bx+si]
	or	al,al
	jz	swjoy_y		; If not, jump

	mov	Active_IOTYP,video_IOTYP
	mov	ah,0
	cmp	al,80h
	jc	swjoych1
	neg	al
	mul	al
	mov	iAnalogIncrement,ax
	push	dx
	push	si
	call	JOYSTICK_DISPATCH_RIGHT
	pop	si
	pop	dx
	jmp	swjoy_y

swjoych1:
	mul	al
	mov	iAnalogIncrement,ax
	push	dx
	push	si
	call	JOYSTICK_DISPATCH_LEFT
	pop	si
	pop	dx

; Accept Y coordinate parameters
	even
swjoy_y:
	mov	bx,dx
	mov	al,[bx+si]
	or	al,al
	jz	swjoy_z		; If not, jump

	mov	Active_IOTYP,video_IOTYP
	mov	ah,0
	cmp	al,80h
	jc	swjoych2
	neg	al
	mul	al
	mov	iAnalogIncrement,ax
	push	dx
	push	si
	call	JOYSTICK_DISPATCH_UP
	pop	si
	pop	dx
	jmp	swjoy_z

swjoych2:
	mul	al
	mov	iAnalogIncrement,ax
	push	dx
	push	si
	call	JOYSTICK_DISPATCH_DOWN
	pop	si
	pop	dx

swjoy_z:

swjoybutx:
	pop	iAnalogIncrement
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret

; Dispatch to the appropriate command
JOYSTICK_DISPATCH_UP:
	mov	dx,0
	jmp	JDSPR

JOYSTICK_DISPATCH_DOWN:
	mov	dx,2
	jmp	JDSPR

JOYSTICK_DISPATCH_LEFT:
	mov	dx,4
	jmp	JDSPR

JOYSTICK_DISPATCH_RIGHT:
	mov	dx,6
	jmp	JDSPR

JDSPR:	mov	al,JOYMODE
	cbw
	MULTIPLY_BY 8, AX
	mov	bx,ax
	add	bx,DX
	mov	ax,[bx + JOYMODE_TBL]
	push	ax
	ret


;================================================================
;================================================================
; Trigger GPI register #CL
triggerit:
	mov	bl,cl
	xor	bh,bh
	MULTIPLY_BY GPI_length, BX
	add	bx,offset Gpi0
	test	byte ptr [bx].gpiFLAGS,G_vltrig_mask	; Skip any action if VLAN trigger
	jz	trigit1			; Jump if NOT a VLAN TRIGGER

;;	cmp	Vtr_Mult_Type,V_roll
;;	jz	trigxx
	cmp	Vtr_Mult_Type,V_nul
	jnz	trigxx
	jmp	relay_trigger

trigit1:test	byte ptr [bx].gpiFLAGS,G_swtrig_mask	; Test for switcher trigger
	jz	trigxx

; 000 - 049	Load EMEM register
; 050		Downstream FTB
; 051 - 059	Downstream auto trans (usually for Keyers 1-9)
; 151 - 151	Triggers auto trans mix or wipe ME 1
; 251 - 251	ME 2
; 351 - 351	ME 3
; 451 - 451	ME 4
; 161 - 161	Video only auto trans mix or wipe ME 1
; 261 - 261	ME 2
; 361 - 361	ME 3
; 461 - 461	ME 4
; 171 - 171	Audio only auto trans mix ME 1
; 271 - 271	ME 2
; 371 - 371	ME 3
; 471 - 471	ME 4

; Commands: x1x2x3 for VIDEO (switcher)
;	x1 = Effects bank
;		0 = DSK/FTB or EMEM LOAD
;		1 = EMEM LOAD AND EXECUTE if X2 < 5
;		1 - 4 = Effects bank 
;	X2 = Effects Type
;		0 - 4 = EMEM Bank
;		5 = Auto Trans Video and Audio
;		6 = Video only command
;		7 = Audio only command
;	X3 = Command Type/emem bank
;		0 = DSK auto trans ( if X1=0 and X2=5 )
;		1 = Auto trans on ME X1 if X2=5
;		x = If X1=0 and X2<5 then load EMEM. Load and trigger if X1=1

TRIG_sw:mov	ax,[bx].gpiCMD		; Get the command word
	mov	cl,100
	div	cl
	mov	ch,al			; CH = EFFECTS BANK (Xxx)
	mov	cl,ah			; CL has command

	mov	al,ah			; Get Remainder (xXX)
	mov	ah,0			; Calculate 10s digit
	push	cx			; Save CH (effects bank)
	mov	cl,10
	div	cl
	pop	cx			; Restore effects bank in CH
	cmp	al,5
	jc	TRIG_em			; 0 - 4 = emem register
	jnz	TRIG_at			; If NOT 5 then skip this

	or	ch,ch			; Check for downstream
	jz	TRIG_ds			; Trigger DSK VIDEO ONLY

	call	SetVlanEfxAdrTo_CH
	call	SW_trans
	call	SetVlanEfxAddress

	call	AS_trans
	ret

; CH = effects bank, CL = command
TRIG_at:or	ch,ch			; Effects bank 0 = DSK/FTB
	jz	TRIG_ds			; Trigger down stream if eff=0
	cmp	al,7			; Audio only?
	jz	TRIG_ata
	push	ax
	call	SW_trans
	pop	ax
TRIG_ata:
	cmp	al,6			; Video only?
	jz	trigxx
	jmp	AS_trans

; Audio only Triggers
trig_aud:
	jmp	AS_trans		; Trigger PST transition

TRIG_ds:or	ah,ah			; Trigger DSK if cmd type = 0
	jnz	trigds1
	call	SW_ftb_press
	call	ASW_ftb_press
	ret
trigds1:
	call	SW_dsk_mix
	ret

; CH = non-zero to trigger immediatly, AH = command type
TRIG_em:call	RecallEmemToSwitcher
	or	ch,ch			; Auto trigger now?
	jz	trigxx
	jmp	SW_trans
trigxx:	ret

_TEXT	ends

_DATA	segment word public 'DATA'
	assume cs:_DATA

joymode_msg	db	'ACTIVE MODE: ',0

EFX_cmdtbl	equ	$
	dw	Enter_xcmd,	EFXscreen
	dw	Thisevent_xcmd,	Pushabutton
	dw	Record_xcmd,	SW_learn
	dw	Rehearse_xcmd,	SW_recall
	dw	Erecal_xcmd,	SW_recall
	dw	Review_xcmd,	EFX_rehearse
	dw	Load_xcmd,	EMEM_load
	dw	Save_xcmd,	EMEM_save
	dw	Find_xcmd,	video_files

	dw	Vbv_xcmd,	RealTime_Trigger

	if ALLOWED_VTRS EQ 7
	dw	Dis_xcmd,	SW_mix
	dw	Wip_xcmd,	SW_wipe
	dw	Cut_xcmd,	SW_cut

	dw	Pageup_key,	SW_fader_fwd
	dw	Pagedn_key,	SW_fader_rev
	dw	Home_key,	SW_soft_up
	dw	End_key,	SW_soft_dn
	dw	Srchfwd_xcmd,	SW_bdr_up
	dw	Srchrev_xcmd,	SW_bdr_dn
	dw	Clrrd_xcmd,	SW_allstop

	dw	Key_xcmd,	SW_key
	dw	Makdiss_xcmd,	SW_bkgd
	dw	Transw_xcmd,	SW_keybkg
	dw	Makwipe_xcmd,	Change_wipecode
	dw	Insert_key,	efxSW_dsk_mix
	dw	Delete_key,	efxSW_ftb_press

	dw	Shftdel_key,	EFX_ftbrate
	dw	Shftins_key,	EFX_dskrate

	dw	Durrt_xcmd,	EFX_autotrans
	dw	Split_xcmd,	EFX_halfefx

	dw	Scnxt_xcmd,	JOYSTICK_DISPATCH_DOWN
	dw	Sclst_xcmd,	JOYSTICK_DISPATCH_UP
	dw	Nokey_xcmd,	JOYSTICK_DISPATCH_LEFT
	dw	Yeskey_xcmd,	JOYSTICK_DISPATCH_RIGHT

	dw	Shiftsplit_xcmd,EFX_sethalfefx

	dw	SymUp_xcmd,	SW_Symmetry_dn
	dw	SymDn_xcmd,	SW_Symmetry_up

	dw	Macro_xcmd,	JMENU_rev
	dw	Colonplus_xcmd,	JMENU_fwd

	dw	Vidsel_xcmd,	Toggle_Active_Bus


	ENDIF ;	if ALLOWED_VTRS EQ 7

	dw	Rm_xcmd			,R_Machine
	dw	Am_xcmd			,A_Machine
	if ALLOWED_VTRS GT 2
	dw	Bm_xcmd			,b_machine
	endif
	if ALLOWED_VTRS GT 3
	dw	Cm_xcmd			,c_machine
	endif
	if ALLOWED_VTRS GT 4
	dw	Dm_xcmd			,d_machine
	endif
	if ALLOWED_VTRS GT 5
	dw	Em_xcmd			,e_machine
	endif
	if ALLOWED_VTRS GT 6
	dw	Fm_xcmd			,f_machine
	endif
	dw	Au_xcmd			,Aux_Machine
	dw	Bl_xcmd			,Blk_Machine
	dw	Stop_xcmd		,stop
	dw	Pause_xcmd		,pause
	dw	Still_xcmd		,still
	dw	Play_xcmd		,play
	dw	Fastfwd_xcmd		,fastfwd
	dw	Rewind_xcmd		,rewind
	dw	Shuttlefwd_xcmd		,shuttlefwd
	dw	Shuttleback_xcmd	,shuttleback
	dw	Twicefwd_xcmd		,twicefwd
	dw	Twiceplay_xcmd		,twicefwd
	dw	Twicerev_xcmd		,twicerev
	dw	Reverse_xcmd		,reverse
	dw	Cue_xcmd		,cue
;;	dw	Search_xcmd		,search
	dw	Srchfwd_xcmd		,srchfwd
	dw	Srchrev_xcmd		,srchrev
	dw	Slowfwd_xcmd		,slowfwd
	dw	Slowrev_xcmd		,slowrev
	dw	Markin_xcmd		,MarkIn
	dw	Markout_xcmd		,Markout
	dw	Space_xcmd		,all_still
	dw	All_Stop_xcmd		,all_stop
	dw	All_Cue_xcmd		,all_cue
	dw	Gotoin_xcmd		,gotoin
	dw	Gotoout_xcmd		,gotoout
	dw	Bump_Plus_xcmd		,bump_plus
	dw	Bump_Minus_xcmd		,bump_minus

	dw	Vidsel_xcmd		,Video_Select
	dw	Au1sel_xcmd		,Audio1_Select
	dw	Au2sel_xcmd		,Audio2_Select
	dw	Swrcl_xcmd		,Audio3_Select
	dw	Emlrn_xcmd		,Audio4_Select
;	dw	Scrconst_xcmd		,scroll_Constants
;	dw	Scrconstb_xcmd		,scroll_constback
;	dw	Exch_xcmd		,Exchange
;	dw	Savemarks_xcmd		,Save_Marks
;	dw	Lastmarks_xcmd		,Last_Marks
;	dw	Tccalc_xcmd		,tccalc
	dw	Eject_xcmd		,eject
	dw	Hardvid_xcmd		,Hardvid
	dw	Hardaud1_xcmd		,Hardaud1
	dw	Hardaud2_xcmd		,Hardaud2
	dw	Modesoff_xcmd		,Modes_Off

	dw	Const_xcmd		,SW_preset_pattern
	dw	Opend_xcmd		,SW_aspect_tgl
	dw	Move_xcmd		,SW_positionerON
	dw	Preread_xcmd		,Preread

	dw	0ffffh			,0ffffh

SMPTE_commands	equ	 $
	db	24 + 5	; # of choices in this table, plus extensions
	db	1	; X_program_bus		1
	db	2	; X_preset_bus		2
	db	3	; X_key1_bus		3
	db	4	; X_key2_bus		4
	db	5	; X_analog		5
	db	6	; X_pbl_on		6
	db	7	; X_pbl_off		7
	db	8	; X_pattern		8
	db	9	; spare1		9
	db	0Ah	; X_transition		10
	db	0Ch	; X_autorate		11
	db	0Dh	; X_dskrate		12
	db	3Dh	; X_ftbrate		13
	db	13h	; X_keyermem		14
	db	1Ah	; X_lrnemem		15
	db	1Bh	; X_rclemem		16
	db	2Ch	; X_version		17
	db	2Dh	; X_fldmode		18
	db	2Eh	; X_statupd		19
	db	32h	; X_allstop		20
	db	38h	; X_lampstat		21
	db	3Bh	; X_pushbutton		22
	db	3Eh	; X_xferemem		23
	db	21h	; AX_monitor170		24

;; Alladin extensions
	db	16h	; goto start		25
	db	17h	; goto end		26
	db	14h	; step fwd		27
	db	15h	; step rev		28
	db	18h	; goto frame		29

ESAM2_commands	equ	 $
	db	25	; # of choices in this table
	db	34h	; X_program_bus		1
	db	35h	; X_preset_bus		2
	db	0ffh	; X_key1_bus		3
	db	0ffh	; X_key2_bus		4
	db	0ffh	; X_analog		5
	db	0ffh	; X_pbl_on		6
	db	0ffh	; X_pbl_off		7
	db	0ffh	; X_pattern		8
	db	0ffh	; spare1		9
	db	29h	; X_transition		10
	db	27h	; X_autorate		11 (channel 1)
	db	28h	; X_dskrate		12 (Channel 2)
	db	0ffh	; X_ftbrate		13
	db	0ffh	; X_keyermem		14
	db	0ffh	; X_lrnemem		15
	db	0ffh	; X_rclemem		16
	db	0ffh	; X_version		17
	db	0ffh	; X_fldmode		18
	db	0ffh	; X_statupd		19
	db	0ffh	; X_allstop		20
	db	0ffh	; X_lampstat		21
	db	0ffh	; X_pushbutton		22
	db	0ffh	; X_xferemem		23

	db	2ah	; Monitor Mode		24
	db	36h	; Monitor Machine	25

; Switcher command tables:
gvg100_pba:
	VBUTTON100A	ABTN_enable,		4fh
	VBUTTON100A	ABTN_cut,		4ah
	VBUTTON100A	ABTN_pst_trans,		0bh
	VBUTTON100A	ABTN_ovr_trans,		0ch
	VBUTTON100A	ABTN_LINE,		1bh
	VBUTTON100A	ABTN_PST,		1ch
	VBUTTON100A	ABTN_Over_mix,		1dh
	VBUTTON100A	ABTN_Over_tally,	0dh
	VBUTTON100A	ABTN_ftb,		1fh

gvg100_pbv:
	VBUTTON100V	VBTN_enable,		4fh
	VBUTTON100V	VBTN_cut,		4ah
	VBUTTON100V	VBTN_autotrans,		0bh
	VBUTTON100V	VBTN_mix,		0fh
	VBUTTON100V	VBTN_wipe,		0eh
	VBUTTON100V	VBTN_key,		49h
	VBUTTON100V	VBTN_bkgd,		48h
	VBUTTON100V	VBTN_dsk_mix,		0ch
	VBUTTON100V	VBTN_dsk,		0dh
	VBUTTON100V	VBTN_ftb,		1fh
	VBUTTON100V	VBTN_key_test,		52h
	VBUTTON100V	VBTN_wipe_rev,		1dh
	VBUTTON100V	VBTN_DSK_KEY_invert,	40h
	VBUTTON100V	VBTN_EFFECTS_KEY_invert,44h
	VBUTTON100V	VBTN_softness,		53h
	VBUTTON100V	VBTN_aspect,		1bh
	VBUTTON100V	VBTN_positioner,	1ch
	VBUTTON100V	VBTN_preset_pattern,	4BH
	VBUTTON100V	VBTN_keybus_source,	4CH
	VBUTTON100V	VBTN_extkey_source,	4DH
	VBUTTON100V	VBTN_chromakey_source,	4EH

;(VANAlog subfunctions)
	VBUTTON100V	VANA_fader,		00h
	VBUTTON100V	VANA_dsk_clip,		08H
	VBUTTON100V	VANA_key_clip,		0AH
	VBUTTON100V	VANA_key_gain,		0BH
	VBUTTON100V	VANA_dsk_hue,		0AH
	VBUTTON100V	VANA_dsk_chroma,	0BH
	VBUTTON100V	VANA_dsk_luminance,	0CH
	VBUTTON100V	VANA_position_V,	11h
	VBUTTON100V	VANA_position_H,	12h
	VBUTTON100V	VANA_background_hue,	14h
	VBUTTON100V	VANA_mask_presetsize,	15h
	VBUTTON100V	VANA_chroma_key_hue,	17h
	VBUTTON100V	VANA_hue,		18h
	VBUTTON100V	VANA_chroma,		19h
	VBUTTON100V	VANA_lumance,		1ah
	VBUTTON100V	VANA_bacground_lum,	1bh
	VBUTTON100V	VANA_aspect,		1ch

	VBUTTON100V	VANA_softness,		1dh
	VBUTTON100V	VANA_border,		1eh
	VBUTTON100V	VANA_bacground_chroma,	1fh



;================================================================
;;; Returned from SWITCHER: 0A 01 02 15 16 29 04 03 51 63 52
gvg_wipes	db	10	; # OF AVAILABLE WIPES
		db	0ah	;Horizontal		10
		db	00h	;Vertical		0
		db	1eh	;Horizontal split	30
		db	14h	;Vertical split		20
		db	04h	;Diagonal		4
		db	0bh	;Right corner		11
		db	01h	;Left corner		1
		db	17h	;Box			23
		db	03h	;Circle			3
		db	21h	;Diamond		33

; Table changed 7-01-1993 
pyxis_wipes	db	31	; # OF AVAILABLE WIPES
		db	10	; Horizontal Wipe
		db	0	; Vertical Wipe
		db	1	; Upper left corner
		db	11	; Upper right corner
		db	21	; Lower right corner
		db	31	; Lower left corner
		db	40	; Push on digital
		db	41	; Push off digital
		db	42	; Pull off digital
		db	43	; AB split
		db	30	; Horizontal Split
		db	20	; Vertical Split
		db	44	; Cross
		db	23	; Window (box)
		db	45	; Cut
		db	46	; Dissolve
		db	47	; Fade to Black
		db	60	; Horizontal Wipe w/ Dissolve
		db	50	; Vertical Wipe w/ Dissolve
		db	51	; Horizontal Snake #
		db	61	; Horizontal Snake #
		db	71	; Horizontal Snake #
		db	81	; Horizontal Snake #
		db	90	; Vertical Snake #
		db	91	; Vertical Snake #
		db	92	; Vertical Snake #
		db	93	; Vertical Snake #
		db	80	; Horizontal Split w/ Dissolve
		db	70	; Vertical Split w/ Dissolve
		db	94	; Cross Split w/ Dissolve
		db	73	; Square Split w/ Dissolve


pegasus_wipes	db	28
		db	0	; Vertical Wipe
		db	0	; Vertical Wipe
		db	6	; Horizontal
		db	15	; Top/Bottom shutter
		db	5	; Left/Right shutter
		db	1	; UL corner
		db	11	; UR corner
		db	21	; LR corner
		db	42	; LL corner
		db	43	; Top box wipe
		db	44	; Right box wipe
		db	46	; Bottom box wipe
		db	45	; Left box wipe
		db	27	; Diamond
		db	3	; Circle
		db	23	; Center Box
		db	24	; Quad split
		db	47	; Ellipse (center)
		db	52	; Bowl wipe
		db	0	; ???????????
		db	4	; Diagonal
		db	2	; "V" wipe
		db	18	; Left arrow
		db	7	; Inverted "V" wipe
		db	12	; Right arrow
		db	48	; Top Ellipse
		db	50	; Bottom Ellipse
		db	51	; Dome wipe

ross_wipes	db	24	; 
		db	0Ah	; Horizontal
		db	00h	; Vertical
		db	1Eh	; H Split
		db	14h	; V split
		db	17h	; Box
		db	21h	; Diamond
		db	01h	; Left Upper Corder
		db	1Fh	; Left Lower Corner
		db	15h	; Right Lower Corner
		db	0Bh	; Right Upper Corner
		db	27h	; Diagonal
		db	03h	; Circle
				; Shifted wipes..........
		db	02h	; Upward V
		db	0Ch	; Left facing V
		db	28h	; Downward V
		db	16h	; Right Facing V
		db	18h	; Cross
		db	22h	; Double Triangle
		db	29h	; Upper side insert
		db	2Ah	; Left side insert
		db	2Bh	; Lower side insert
		db	2Ch	; Right side insert
		db	04h	; Diagonal
		db	2Dh	; Programable


;================================================================

;modes: UP DOWN LEFT RIGHT

JOYMODE_TBL	dw SW_fader_fwd,SW_fader_rev,SW_fader_rev,SW_fader_fwd
		dw SW_position_Vup,SW_position_Vdn,SW_position_Hdn,SW_position_Hup
		dw SW_Symmetry_up,SW_Symmetry_dn,SW_Symmetry_dn,SW_Symmetry_up
		dw SW_soft_up,SW_soft_dn,SW_soft_dn,SW_soft_up
		dw SW_bdr_up,SW_bdr_dn,SW_bdr_dn,SW_bdr_up
		dw SW_KEYclip_up, SW_KEYclip_dn, SW_KEYclip_dn, SW_KEYclip_up
		dw SW_KEYgain_up, SW_KEYgain_dn, SW_KEYgain_dn, SW_KEYgain_up

		dw HUE_up,	 HUE_dn,	HUE_dn,		HUE_up
		dw CHROMA_up,	 CHROMA_dn,	CHROMA_dn,	CHROMA_up
		dw LUM_up,	 LUM_dn,	LUM_dn,		LUM_up
		dw MASK_up,	 MASK_dn,	MASK_dn,	MASK_up
		dw BKG_HUE_up,	 BKG_HUE_dn,	BKG_HUE_dn,	BKG_HUE_up
		dw BKG_CHROMA_up,BKG_CHROMA_dn,	BKG_CHROMA_dn,	BKG_CHROMA_up
		dw BKG_LUM_up,	 BKG_LUM_dn,	BKG_LUM_dn,	BKG_LUM_up
		dw CHROMAKEY_up, CHROMAKEY_dn,	CHROMAKEY_dn,	CHROMAKEY_up

		dw SW_DSKclip_up, SW_DSKclip_dn, SW_DSKclip_dn, SW_DSKclip_up
		dw SW_DSKhue_up, SW_DSKhue_dn, SW_DSKhue_dn, SW_DSKhue_up
		dw SW_DSKchroma_up, SW_DSKchroma_dn, SW_DSKchroma_dn, SW_DSKchroma_up
		dw SW_DSKlum_up, SW_DSKlum_dn, SW_DSKlum_dn, SW_DSKlum_up
jmenusize equ (($ - JOYMODE_TBL) / 8) - 1



joynamesize	equ	11
JOYMODE_NAMES	db 'FADER ARM ',0
		db 'POSITIONER',0
		db 'SYMMETRY  ',0
		db 'SOFTNESS  ',0
		db 'BORDER    ',0
		db 'KEY CLIP  ',0
		db 'KEY GAIN  ',0
		db 'BDR HUE   ',0
		db 'BDR CHROMA',0
		db 'BDR LUM   ',0
		db 'MASK PST  ',0
		db 'BKG HUE   ',0
		db 'BKG CHROMA',0
		db 'BKG LUM   ',0
		db 'CHROMA-KEY',0

		db 'DSK CLIP  ',0
		db 'DSK HUE   ',0
		db 'DSK CHROMA',0
		db 'DSK LUM   ',0



activebus_msg	db 'ACTIVE BUS: ',0
BUS_NAMES	db 'PRESET ',0
busnamesize equ ($ - BUS_NAMES)
		db 'PROGRAM',0
		db 'KEYER  ',0
		db '       ',0



;================================================================

	even
JOYMODE		db	0
FTB_STATE	db	0

SplitFader	dw	0800h

FaderPosition	dw	0800h
SjstickH	dw	0800h
SjstickV	dw	0800h
Symmetry	dw	0800h
Softness	dw	0800h
BorderWidth	dw	0800h
KEYclip		dw	0800h
KEYgain		dw	0800h
HUE		dw	0800h
CHROMA		dw	0800h
LUM		dw	0800h
MASKPST		dw	0800h
BKGHUE		dw	0800h
BKGCHROMA	dw	0800h
BKGLUM		dw	0800h
CHROMAKEY	dw	0800h
DSKclip		dw	0800h
DSKhue		dw	0800h
DSKchroma	dw	0800h
DSKlum		dw	0800h

iAnalogIncrement	dw	16

;				Read Routine		BTN#	        VLNCMD		    BITS   EFX   UPDN     CRNTVAL
ACD_fader_fwd:		A_C_D	SW_read_fader,	  VANA_fader,		V4SW_LeverArmPosition, 0ffh, 0ffh, 0   , FaderPosition
ACD_fader_rev:		A_C_D	SW_read_fader,	  VANA_fader,		V4SW_LeverArmPosition, 0ffh, 0ffh, 0ffh, FaderPosition
ACD_position_Vup:	A_C_D	SW_read_V,	  VANA_position_V,	V4SW_PosVPosition,  0ffh, 0ffh, 0   , SjstickV
ACD_position_Vdn:	A_C_D	SW_read_V,	  VANA_position_V,	V4SW_PosVPosition,  0ffh, 0ffh, 0ffh, SjstickV
ACD_position_Hup:	A_C_D	SW_read_H,	  VANA_position_H,	V4SW_PosHPosition,  0ffh, 0ffh, 0   , SjstickH
ACD_position_Hdn:	A_C_D	SW_read_H,	  VANA_position_H,	V4SW_PosHPosition,  0ffh, 0ffh, 0ffh, SjstickH
ACD_Symmetry_up:	A_C_D	SW_read_Sym,	  VANA_aspect,		V4SW_WipeSymmetry,  0ffh, 0ffh, 0   , Symmetry
ACD_Symmetry_dn:	A_C_D	SW_read_Sym,	  VANA_aspect,		V4SW_WipeSymmetry,  0ffh, 0ffh, 0ffh, Symmetry
ACD_soft_up:		A_C_D	SW_read_soft,	  VANA_softness,	V4SW_WipeSoftness,  0	, 0ffh,    0, Softness
ACD_soft_dn:		A_C_D	SW_read_soft,	  VANA_softness,	V4SW_WipeSoftness,  0	, 0ffh, 0ffh, Softness
ACD_bdr_up:		A_C_D	SW_read_bdr,	  VANA_border,		V4SW_WipeBorder,    0	, 0ffh,    0, BorderWidth
ACD_bdr_dn:		A_C_D	SW_read_bdr,	  VANA_border,		V4SW_WipeBorder,    0	, 0ffh, 0ffh, BorderWidth
ACD_KEYclip_up:		A_C_D	SW_read_KEYclip,  VANA_key_clip,	V4SW_KeyClip+10h,   0ffh, 0ffh, 0   , KEYclip
ACD_KEYclip_dn:		A_C_D	SW_read_KEYclip,  VANA_key_clip,	V4SW_KeyClip+10h,   0ffh, 0ffh, 0ffh, KEYclip
ACD_KEYgain_up:		A_C_D	SW_read_KEYgain,  VANA_key_gain,	V4SW_KeyGain+10h,   0ffh, 0ffh, 0   , KEYgain
ACD_KEYgain_dn:		A_C_D	SW_read_KEYgain,  VANA_key_gain,	V4SW_KeyGain+10h,   0ffh, 0ffh, 0ffh, KEYgain

ACD_HUE_up:		A_C_D	SW_read_HUE,	  VANA_hue,		V4SW_Me1MatteHueR,  0ffh, 0ffh, 0   , HUE
ACD_HUE_dn:		A_C_D	SW_read_HUE,	  VANA_hue,		V4SW_Me1MatteHueR,  0ffh, 0ffh, 0ffh, HUE
ACD_CHROMA_up:		A_C_D	SW_read_CHROMA,	  VANA_chroma,		V4SW_Me1MatteSatB,  0ffh, 0ffh, 0   , CHROMA
ACD_CHROMA_dn:		A_C_D	SW_read_CHROMA,	  VANA_chroma,		V4SW_Me1MatteSatB,  0ffh, 0ffh, 0ffh, CHROMA
ACD_LUM_up:		A_C_D	SW_read_LUM,	  VANA_lumance,		V4SW_Me1MatteLumG,  0ffh, 0ffh, 0   , LUM
ACD_LUM_dn:		A_C_D	SW_read_LUM,	  VANA_lumance,		V4SW_Me1MatteLumG,  0ffh, 0ffh, 0ffh, LUM
ACD_MASK_up:		A_C_D	SW_read_MASK,	  VANA_mask_presetsize,	V4SW_KeyPstPatSize+10h,0ffh, 0ffh, 0   , MASKPST
ACD_MASK_dn:		A_C_D	SW_read_MASK,	  VANA_mask_presetsize,	V4SW_KeyPstPatSize+10h,0ffh, 0ffh, 0ffh, MASKPST
ACD_BKG_HUE_up:		A_C_D	SW_read_BKGHUE,	  VANA_background_hue,	V4SW_BkgMatteHueR,  0ffh, 0ffh, 0   , BKGHUE
ACD_BKG_HUE_dn:		A_C_D	SW_read_BKGHUE,	  VANA_background_hue,	V4SW_BkgMatteHueR,  0ffh, 0ffh, 0ffh, BKGHUE
ACD_BKG_CHROMA_up:	A_C_D	SW_read_BKGCHROMA,VANA_bacground_chroma,V4SW_BkgMatteSatB,  0ffh, 0ffh, 0   , BKGCHROMA
ACD_BKG_CHROMA_dn:	A_C_D	SW_read_BKGCHROMA,VANA_bacground_chroma,V4SW_BkgMatteSatB,  0ffh, 0ffh, 0ffh, BKGCHROMA
ACD_BKG_LUM_up:		A_C_D	SW_read_BKGLUM,	  VANA_bacground_lum,	V4SW_BkgMatteLumG,  0ffh, 0ffh, 0   , BKGLUM
ACD_BKG_LUM_dn:		A_C_D	SW_read_BKGLUM,	  VANA_bacground_lum,	V4SW_BkgMatteLumG,  0ffh, 0ffh, 0ffh, BKGLUM
ACD_CHROMAKEY_up:	A_C_D	SW_read_CHROMAKEY,VANA_chroma_key_hue,	0ffh,		    0ffh, 0ffh, 0   , CHROMAKEY
ACD_CHROMAKEY_dn:	A_C_D	SW_read_CHROMAKEY,VANA_chroma_key_hue,	0ffh,		    0ffh, 0ffh, 0ffh, CHROMAKEY

ACD_DSKclip_up:		A_C_D	SW_read_DSKclip,  VANA_dsk_clip,	V4SW_KeyClip+20h,	    0ffh, 0  ,  0   , DSKclip
ACD_DSKclip_dn:		A_C_D	SW_read_DSKclip,  VANA_dsk_clip,	V4SW_KeyClip+20h,	    0ffh, 0  ,  0ffh, DSKclip
ACD_DSKhue_up:		A_C_D	SW_read_DSKhue,	  VANA_dsk_hue,		V4SW_Me2MatteHueR,  0ffh, 0  ,  0   , DSKhue
ACD_DSKhue_dn:		A_C_D	SW_read_DSKhue,	  VANA_dsk_hue,		V4SW_Me2MatteHueR,  0ffh, 0  ,  0ffh, DSKhue
ACD_DSKchroma_up:	A_C_D	SW_read_DSKchroma,VANA_dsk_chroma,	V4SW_Me2MatteSatB,  0ffh, 0  ,  0   , DSKchroma
ACD_DSKchroma_dn:	A_C_D	SW_read_DSKchroma,VANA_dsk_chroma,	V4SW_Me2MatteSatB,  0ffh, 0  ,  0ffh, DSKchroma
ACD_DSKlum_up:		A_C_D	SW_read_DSKlum,	  VANA_dsk_luminance,	V4SW_Me2MatteLumG,  0ffh, 0  ,  0   , DSKlum
ACD_DSKlum_dn:		A_C_D	SW_read_DSKlum,	  VANA_dsk_luminance,	V4SW_Me2MatteLumG,  0ffh, 0  ,  0ffh, DSKlum

;;V4SW_Key2Gain,
;;V4SW_Key2Gain,

_DATA	ends

	end
