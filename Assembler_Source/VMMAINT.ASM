; Last revised: 2-22-1995, 11:12:26   (C)1989-1995 Norman H. Strassner

; VMMAINT.ASM 
;Menues and default settings

%nolist
include	VM.EQU

extrn title1_ovr:word,title2_ovr:word,title3_ovr:word,title4_ovr:word
extrn title5_ovr:word,title6_ovr:word,title7_ovr:word
extrn Preview_Switch:near

extrn PS_INSTALL:word,PS_INSTALL1:word,PS_INSTALL2:word,PS_INSTALL3:word
extrn PS_INSTALL6:word,PS_INSTALL7:word,PS_INSTALL8:word,PS_INSTALL11:word
extrn PS_INSTALL12:word,PS_INSTALL16:word,PS_INSTALL17:word
extrn PS_INSTALL19:word,PS_INSTALL20:word,PS_INSTALL21:word
extrn PS_INSTALL22:word,PS_INSTALL23:word,PS_INSTALL27:word

extrn pvwbase_ovr:word,VlanPreviewPort:byte

extrn vidbase_ovr:word,VlanVideoPort:byte,audbase_ovr:word,VlanAudioPort:byte
extrn vidbase2_ovr:word,VlanVideoPort2:byte

extrn AX_Type:byte,Device_Present:byte,DelEdRoll_Qrtrs:byte,INSTL_Chos:byte
extrn SX_Type:byte,ShuttleSensitivity:byte,Assembly_Mode:byte
extrn Available_Bins:byte,Available_Colors:byte,Blink_Time:byte
extrn Color_BKG:byte,Color_Pointer:byte,Emem_Efxadr:byte
extrn Current_Machine:byte,Default_Mode:byte,Device_Enabled:byte
extrn Dnstream_Keynumber:byte,Edl_Fcm:byte,Edltrack_Delay:byte
extrn Effects_Address:byte,Flag1:byte,Flag2:byte,Flag3:byte,Flag4:byte
extrn Flag5:byte,Fterr_Flg:byte,Fullscreen_Flag:byte,Hardrecord_Flag:byte
extrn Input_Flag:word,Mode_Flag:byte,Priority_Flag:byte,Retry_Count:byte
extrn Rtcf:byte,Sign_Flag:byte,System_Color_Frame:byte,Tcgen_Mode:byte
extrn Trim_Ci_Flag:byte,Upstream_Keynumber:byte,Video_Mode:byte
extrn Current_Source:byte,Audio_Effects_Address:byte

extrn AX_Switcher_Types:WORD,DOS_Flags:word,preread_ovr:word
extrn DelEdRollq_ovr:word,DelayRoll_ovr:word,EDLoptions_Flags:word
extrn INSTL_Choices:word,INSTL_Jmps:word,JoggerIRQ:word,MultRec_Flags:word
extrn Node_Stat_ovr:word,NumberOfEdlFormats:word,PMC_Offset:word,PMC_qry:word
extrn PMC_store_ovr:word,PointShootData:word,RT_Offset:word,RT_qry:word
extrn SPD_store_ovr:word,SX_Switcher_Types:WORD,Adjust_Msg:word
extrn Alreadyon_Msg:word,asmmode_ovr:word,Asyougo_Msg:word,Atrans_Offset:word
extrn atrans_qry:word,autodisable_ovr:word,beltogl_ovr:word,brate_ovr:word
extrn Button_Msg:word,BvbIN_Offset:word,bvbIN_qry:word,BvbOUT_Offset:word
extrn bvbOUT_qry:word,Bytstr1:word,Cancelauto_Msg:word
extrn Color_Table:word,colorframe_ovr:word,ememefxadr_ovr:word
extrn Current_Event:word,Cursor:word,EnableVlan_ovr:word,disptype_ovr:word
extrn dnstrkey_ovr:word,Dropframe_Msg:word,durfcm_ovr:word,Edit_Flags:word
extrn Edits_To_Look_Ahead:word,Edl_Ext:word,Edlis_Msg:word
extrn Edltrack_Cdelay:word,edltrack_ovr:word,efxadr_ovr:word
extrn ejectpage_ovr:word,Entime:word,errbell_ovr:word,exitmenu_ovr:word
extrn extmenu_ovr:word,fastswitch_ovr:word,fext_ovr:word,forcev3_ovr:word
extrn Frame_Msg:word,frommsg_ovr:word,Gpi_Flags:word,gpi_store_ovr:word
extrn gpibase_ovr:word,Gtrans_Offset:word,gtrans_qry:word,hardrecord_ovr:word
extrn JoggerIRQ_ovr:word,Joykey1:word,Joykey2:word,joykey_ovr:word
extrn joykeys_ovr:word,keyhelp_ovr:word,keys_ovr:word,lastkey_ovr:word
extrn List_Scr:word,lookahead_ovr:word,lookcount_ovr:word,Mcrosep:word
extrn menu_ovr:word,Mode_Msg:word,Mode_Pntr:word,modetype_ovr:word
extrn Network_Flags:word,Next_Avail_Num:word,Next_Edit:word,next_ovr:word
extrn Nondrop_Msg:word,on_msg:word,Operational_Flags:word,Otf_Adjust:word
extrn otf_qry:word,pauseplay_ovr:word,Pmc_Flags:word,Port:word,Postroll:word
extrn Postroll_rqst:word,Preroll:word,Preroll_rqst:word,prior_ovr:word
extrn realtime_ovr:word,REC_store_ovr:word,recheck_ovr:word,Recordpost:word
extrn recpost_rqst:word,recripl_store_ovr:word,relchg_ovr:word
extrn resettt_ovr:word,Retry_Count_ovr:word,Rm_xcmd:word,rptoggle_ovr:word
extrn screengrid_ovr:word,Security_Return:word,shuttlesense_ovr:word
extrn Slave_Flags:word,slave_store_ovr:word,Sounddisplay_Flags:word
extrn Spd_Flags:word,SplitA_Offset:word,splitA_qry:word,SplitV_Offset:word
extrn splitV_qry:word,stathdr_ovr:word,stripewarn_ovr:word,Sttime:word
extrn Surenuf_Msg:word,Switcher_Flags:word,syncIN_qry:word,syncOUT_qry:word
extrn Sync_Offset_In:word,Sync_Offset_Out:word,syscolorframe_ovr:word
extrn Tcdispbuf:word,Tcgen_Start:word,tcgenset_ovr:word,Time_Start:word
extrn Time_Total:word,timedisplay_ovr:word,timestart_rqst:word,title_ovr:word
extrn tomsg_ovr:word,trigadjust_ovr:word,upstrkey_ovr:word,useJogger_ovr:word
extrn usejstick_ovr:word,VbvIN_Offset:word,vbvIN_qry:word,VbvOUT_Offset:word
extrn vbvOUT_qry:word,VLAN_Flags:word,vlanversion_ovr:word
extrn Vtrcb:word,VvvIN_Offset:word,vvvIN_qry:word,VvvOUT_Offset:word
extrn vvvOUT_qry:word,Wild1:word,Wild2:word,Wild_Msg:word,wild_ovr:word
extrn wildkeys_ovr:word,wipemods_ovr:word, Timelineroll:word
extrn Timelineroll:word,tlineroll_rqst:word,Resetting_Msg:word
extrn audefxadr_ovr:word,sortdirs_ovr:word

extrn PST_switch:near,Program_Relays:near,SetVlanEfxAddress:near
extrn VLAN_init:near,Ask4FCM:near,chk4relaybox:near,cimsg_wrk:near
extrn context_help:near,cstat:near,dec_cimsg:near,devtype:near
extrn diagnostics:near,Diskon_Upd:near,get_appltype:near,get_ucase:near
extrn locations:near,Lockout:near,machine_init:near,motion:near
extrn pos_yn_chos:near,position_query:near,rdchar:near,screen_init:near
extrn security_test:near,setsync:near,space_2_out:near,stripe_tape:near
extrn switch:near,tc_cimsg:near,tc_parenth:near,tcprty0:near,Vlan_Upd:near
extrn yn_chos:near,Machine_Change:near

extrn _A_DecOut:far,_BitCountReset:far,_BitCountSet:far
extrn _ConOut:FAR,_DecOut:far,_E1_flgs:far,_MsgCntr:FAR
extrn _SaveLoadFile_Close:far,_SetEdlBinFormatPointer:far,_Set_AUXBLACK:far
extrn _Set_AutoFile:far,_Space_Out:far,__init_filewrite:far,_adv2chr:FAR
extrn _Break_check:FAR,_check4edl:far,_check4joystick:far,_chimes:FAR
extrn _clear_screen:FAR,_clear_tc:far,_cntrtxt:FAR,_cnvt2df:far
extrn _cnvt2df_ES:far,_cnvt2nd:far,_cnvt2nd_ES:far,_cnvt2tc_DS:far,_comsg:FAR
extrn _convert2bin:far,_crlf:FAR,_dashit_cl:far,_delfrm:FAR,_delms:FAR
extrn _dflts_disp:far,_dhb:far,_dhw:far,_dircur_lerase:FAR,_Entime_move:far
extrn _error_bell:FAR,_event_display:far,_evnt_dispthis:far,_getlast_rin:far
extrn _getlast_rout:far,_getlast_rtcd:far,_help_pos:FAR,_index_storage:far
extrn _Inout_init:far,_kbd_cln:FAR,_kbd_clr:FAR,_kbd_message:far
extrn _line_erase:FAR,_listtype_upd:far,_log_TCMfile:far,_log_TMPfile:far
extrn _log_VMEfile:far,_log_autofile:far,_log_Drive:far,_machine_keys:far
extrn _menu_columns:far,_menu_find:far,_mmv3byt:far,_mmv:far,_mode_upd:far
extrn _mpbdiv:far,_msg2screen:FAR,_msgread:FAR,_setcom:far,_Sttime_move:far
extrn _timdif:far,_time_upd:far,_time_value:far,_upd_getrel:far,_working:far
extrn cimsg_wrk_FAR:far,Keyboard:far,rdchar_FAR:FAR,_M8_CARD:far

extrn _Change_Reel_Assignments:far,_FindModeFromPointer:far
extrn _INSTL_lrest:far,_INSTL_lsave:far,_M11_CARD:far,_M12_CARD:far
extrn _M19_CARD:far,_M1_CARD:far,_M20_CARD:far,_M22_CARD:far,_M23_CARD:far
extrn _M27_CARD:far,_M2_CARD:far,_M3_CARD:far,_PromptForDigits:far
extrn _SetNewRvtFCM:far,_StickItToEm:far,_VTR_Port_Assignment:far
extrn _bit_toggle_bx:far,_default_char:far,_default_val:far,_edltype_display:far
extrn _getmkey:far,_m16_dsp:far,_m16_prmpt:far,_m21_dsp:far,_m7_CARD:far
extrn _PromptForColorFrame:far,_active_machines:far,_SetPointAndShootParams:far

%list

_TEXT	segment	word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

Public  nhs2, Color_clear, Color_init, Color_change, cc0, cc1, bell_toggle
Public  Install, INSTLd4, msel1, INSTL_x, INSTL1, m1_agn, m1_xit, m1_2, m1_3
Public  m1_4, m1_5, m1_6, m1_der, m1_7, m1_8, INSTL_GetTC, mgtc_1
Public  mgtc_2, INSTL2, m2_agn, m2_r, m2_2, m2_3, m2_5, INSTL3, m3_agn, m3_1
Public  m3_2, init_w2d_FAR, init_w2d, inw2d1, inw2d_LOOP, inw2dx, inw2dr
Public  INSTL4, INSTL4x, INSTL5, INSTL5a, nprior, rprior, pprior, pprior1
Public  INSTL5x, INSTL60, INSTL6, mnt6a, mnt6b, mnt6x, INSTL7, m7_agn, m7_1
Public  m7_1agn, m7_2, m7_r, INSTL8, INSTL9, INSTL10, m10off, m10x
Public  INSTL11, m11_agn, m11_1, m11_2, m11_3, m11_4, m11_5, m11_6, m11_7
Public  m11_8, m11_9, INSTL12, m12_agn, m12_1, m12_2, m12_2agn, m12_err
Public  m12_setasmmode, m12_3, m12_4, m12_5, INSTL13, INSTL14, INSTL15, m15_1
Public  m15_2, m15b_1, running_time_FAR, running_time, m15bc, m15bx
Public  gethigh_out, ghigh_1, ghigh_2, ghigh_3, ghigh_5, ghigh_x, INSTL16
Public  m16_agn, m16_2, m16_3, m16_9, m16_rc, m16_xit, INSTL17, m17_agn, m17sel
Public  m17_xit, m17gtca, m17gtcb, m17get, m17get1, m17dsp, m17dspns, m17dsp1
Public  m17dsp1a, m17dsp1b, INSTL18, INSTL19, m19_agn, m19_1, m19_2, m19_3
Public  m19_4, m19x, INSTL20, m20_agn, m20_1, m20_2, m20_3, m20_4, m20_5
Public  m20_6, m20_7, m20_8, m20_9, m20_10, m20_11, m20_12, m20_13, m20_chs
Public  mtgl3n, mtgl2y, mtgl1, mtgl2, mtabrt, mtgl3, log_Drive_shortcut
Public  INSTL21, m21_agn, m21_1, m21_xit, m21_2, m21_3, m21_4, m21_5, m21_5a
Public  M21_6, m21_7, INSTL22, m22_agn, m22_1, m22_xit, m22_2, m22_3, m22_3a
Public  m22_4, m22_4a, m22_5, m22_5a, m22_6, m22_6a, m22_7, m22_prmpt, m22_key
Public  INSTL23, m23_agn, m23_1, m23_2, m23_3, m23_4, m23_5, m23_7, INSTL24
Public  INSTL25, INSTL26, Node_Stats_FAR, Node_Stats, nodstag, nodstlp, nodst1
Public  nodstn, nodstx, INSTL27, m27_agn, m27_r, m27_2, m27_3, m27_4, m27_5
Public  m27_6, m27_7, m27_8, m27_9, fastswitch, m27nd, m27sw, m27dly, m27dlyl
Public  m27dlyx, m27dlyr, keyhelp, copywrite, newednum_cmd, JL1545
Public  check_activator


	DB	'SESP  INSTL cs ',0

;----------------------------------------
;	Copywrite Identification #2
;----------------------------------------
nhs2	db	'N'+80h,'H'+80h,'S'+80h

;================================================================
Color_clear	proc	near
	mov	al,0
	jmp	cc1
Color_clear	endp

;================================================================
Color_init	proc	near
	mov	al,Color_Pointer
	jmp	cc1
Color_init	endp

;================================================================
Color_change	proc	near
	mov	al,Color_Pointer
	inc	al
	cmp	al,Available_Colors
	jc	cc0
	mov	al,0
cc0:	call	cc1
	jmp	screen_init

cc1:	mov	Color_Pointer,al
	cbw
	MULTIPLY_BY 16, AX
	mov	bx,ax
	add	bx,offset Color_Table
	mov	dx,offset Color_BKG
	mov	ch,16
	call	_mmv
	ret
Color_change	endp


;================================================================
bell_toggle	proc	near
	mov	ax,bell_SDBIT
	mov	bx,offset Sounddisplay_Flags
	call	_bit_toggle_bx
	call	_chimes
	ret
bell_toggle	endp

;----------------------------------------------------------------
;			INSTALL€MENUS
;----------------------------------------------------------------
;================================================================
;INSTL command menu and select
Install	proc	near
	mov	bx,offset PS_INSTALL
	call	_SetPointAndShootParams

	mov	Input_Flag,INFL_menu

	mov	bx,offset stathdr_ovr
	call	_menu_columns

	mov	cl,INSTL_Chos
	or	cl,cl
	jnz	INSTLd4
	inc	cl
INSTLd4:mov	ch,cl
	call	position_query
	mov	INSTL_Chos,cl		; Store last choice
	jc	INSTL_x			; Carry set if exiting

	mov	ch,cl
	mov	dl,cl
	mov	dh,0
	cmp	dl,PointShootData.PQ_choices
	jbe	msel1
	jmp	Install
msel1:	call	_help_pos
	add	dx,dx
	mov	bx,offset Install
	push	bx
	mov	bx,offset INSTL_Jmps
	add	bx,dx
	mov	bx,[bx]
	jmp	bx

INSTL_x:call	_evnt_dispthis
	ret
Install	endp

;================================================================
;
;================================================================
INSTL1	proc	near
	call	_help_pos

	mov	bx,offset PS_INSTALL1
	call	_SetPointAndShootParams

m1_agn:	call	_M1_CARD
	mov	cl,byte ptr INSTL_Choices + 1
	call	position_query
	jc	m1_xit
	mov	byte ptr INSTL_Choices + 1,cl
	cmp	cl,1
	jnz	m1_2
m1_xit:	call	_help_pos
	ret

m1_2:	cmp	cl,2
	jnz	m1_3
	mov	dx,offset Preroll
	mov	bx,offset Preroll_rqst	; Display prompt
	call	INSTL_GetTC
	jnz	m1_agn

m1_3:	cmp	cl,3
	jnz	m1_4
	mov	dx,offset Postroll
	mov	bx,offset Postroll_rqst	; Display prompt
	call	INSTL_GetTC
	jnz	m1_agn

m1_4:	cmp	cl,4
	jnz	m1_5
	mov	dx,offset Recordpost
	mov	bx,offset recpost_rqst	; Display prompt
	call	INSTL_GetTC
	jnz	m1_agn

m1_5:	cmp	cl,5
	jnz	m1_6
	mov	dx,offset Timelineroll
	mov	bx,offset tlineroll_rqst
	call	INSTL_GetTC
	jmp	m1_agn

m1_6:	cmp	cl,6
	jnz	m1_7
	mov	bx,offset DelayRoll_ovr
	mov	dx,offset Edit_Flags
	mov	ax,delroll_EDBIT
	call	m20_chs
	jmp	m1_agn

m1_7:	cmp	cl,7
	jnz	m1_8
m1_7agn:mov	bx,offset DelEdRollq_ovr
	mov	dx,offset DelEdRoll_Qrtrs
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	jc	m1_7agn
m1_der:	jmp	m1_agn

;,,,
m1_8:	cmp	cl,8
	jnz	m1_9
	mov	bx,offset realtime_ovr
	mov	dx,offset Edit_Flags
	mov	ax,realtime_EDBIT
	call	m20_chs
	jmp	m1_agn

m1_9:	cmp	cl,9
	jnz	m1_10
	mov	bx,offset preread_ovr
	mov	dx,offset Edit_Flags
	mov	ax,prdoff_EDBIT
	call	m20_chs
	jmp	m1_agn

m1_10:	jmp	m1_agn

;================================================================
; BX points to request message
; DX points to 24bit time code buffer
INSTL_GetTC:
	call	_Inout_init
	push	dx
	mov	bx,offset Sttime	; Get start time
	mov	Trim_Ci_Flag,0ffh
	mov	al,NDF_CHAR		; Use non-drop frames
	call	tc_cimsg		; From user
	jnc	mgtc_1
	pop	bx			; Restore buffer
	call	_M1_CARD
	ret

mgtc_1:	call	_time_value
	pop	dx
	jz	mgtc_2
	call	_mmv3byt
	ret
mgtc_2:	call	_M1_CARD
	ret

INSTL1	endp

;================================================================
;		 Auxilliary functions
;================================================================
INSTL2	proc	near

	mov	bx,offset PS_INSTALL2
	call	_SetPointAndShootParams

m2_agn:	call	_M2_CARD
	mov	cl,byte ptr INSTL_Choices + 2
	call	position_query
	jc	m2_r
	mov	byte ptr INSTL_Choices + 2,cl
	cmp	cl,1
	jnz	m2_2
m2_r:	ret

m2_2:	cmp	cl,2
	jnz	m2_3
	mov	dx,offset Tcgen_Start
	mov	bx,offset tcgenset_ovr	; Display prompt
	call	INSTL_GetTC
	jmp	m2_agn

m2_3:	cmp	cl,3
	if NTSC
	jnz	m2_4
	call	_kbd_cln
	mov	al,byte ptr Tcgen_Mode
	call	Ask4FCM
	mov	byte ptr Tcgen_Mode,al
	jmp	m2_agn

m2_4:	cmp	cl,4
	ENDIF

	jnz	m2_5

	call	_help_pos
	mov	bx,offset stripewarn_ovr
	call	_msgread
	call	_kbd_cln
	call	_error_bell
	mov	cl,'N'
	mov	bx,offset Surenuf_Msg
	call	_comsg
	call	yn_chos
	jnz	m2_agn
	call	stripe_tape
	jmp	Keyboard

m2_5:	jmp	m2_agn

INSTL2	endp

;================================================================
;		AUTO SAVE TO DISK FILE
;================================================================
INSTL3	proc	near
	mov	bx,offset PS_INSTALL3
	call	_SetPointAndShootParams

m3_agn:	call	_M3_CARD
	mov	cl,byte ptr INSTL_Choices + 3
	call	position_query
	jnc	m3_1
	call	_help_pos
	ret

m3_1:	mov	byte ptr INSTL_Choices + 3,cl
	cmp	cl,1
	jnz	m3_2
	call	_help_pos
	ret

m3_2:	jmp	init_w2d	;<><>

init_w2d_FAR	proc	far
	call	init_w2d
	ret
init_w2d_FAR	endp

;................................................................
; INITIATE AUTOSAVE TO DISK
init_w2d:
	test	Operational_Flags,asyougo_OPBIT	; Auto output already on?
	jz	inw2d1			; Jump if NOT

	mov	bx,offset Asyougo_Msg	; Prompt for confirmation
	call	_kbd_message
	mov	bx,offset Alreadyon_Msg	; "Restart?" prompt
	call	_comsg
	mov	cl,'N'
	call	yn_chos
	jc	inw2dr
	jz	inw2d1

	mov	bx,offset Cancelauto_Msg; "Cancel Auto?" prompt
	call	_kbd_message
	mov	cl,'N'
	call	yn_chos
	jnz	inw2dr
	and	Operational_Flags,not (diskon_OPBIT or asyougo_OPBIT)
	jmp	inw2dx

inw2d1:	or	Operational_Flags,(diskon_OPBIT or asyougo_OPBIT)
	mov	cx,1				; Start with first bin

inw2d_LOOP:
	push	cx				; Save counter/bin #
	call	_Set_AutoFile			; Set filename
	call	__init_filewrite
	call	_SaveLoadFile_Close
	pop	cx
	inc	cx
	cmp	cl,Available_Bins
	jb	inw2d_LOOP
inw2dx:	call	Diskon_Upd
inw2dr:	ret

INSTL3	endp


;================================================================
;		Search for and Change Reels
;================================================================
INSTL4	proc	near
	call	_evnt_dispthis		; Display the list again
	call	_check4edl		; Is there really one?
	jz	INSTL4x			; Return if not
	call	_Change_Reel_Assignments
	pop	bx			; Get rid of return
INSTL4x:ret
INSTL4	endp

;================================================================
;		Set/Reset default parameters
;================================================================
INSTL5	proc	near
	call	_kbd_cln
	mov	bx,offset prior_ovr
	call	_msgread
	mov	al,Priority_Flag
	mov	ch,al
	or	ch,ch			; FE = none, FF = play, 0 = rec
	mov	al,'R'
	jz	INSTL5a
	inc	ch
	mov	al,'S'
	jz	INSTL5a
	mov	al,'B'
INSTL5a:call	_default_char
	call	rdchar
	call	_Break_check
	jz	INSTL5x
	cmp	al,cr
	jz	INSTL5x
	cmp	al,'r'
	jz	rprior
	cmp	ax,offset Rm_xcmd
	jz	rprior
	cmp	al,'s'
	jz	pprior
	cmp	al,'b'
	jz	nprior
	call	_machine_keys
	jz	pprior
	call	_error_bell
	jmp	INSTL5
nprior:
	mov	al,0feh
	jmp	pprior1
rprior:
	mov	al,r_priority
	jmp	pprior1
pprior:
	mov	al,p_priority
pprior1:mov	Priority_Flag,al
INSTL5x:ret
INSTL5	endp

;================================================================
;	No list type found, ask operator for input
;================================================================
INSTL60	proc	near
	push	bx
	call	_INSTL_lsave
	mov	al,0ffh			; Set file error type
	call	mnt6a
	call	_INSTL_lrest
	pop	bx
	ret
INSTL60	endp

; On INSTALL menu request:
INSTL6	proc	near
	xor	al,al			; Set user select type
mnt6a:	mov	Fterr_Flg,al		; Format type error Flag

	mov	bx,offset PS_INSTALL6
	call	_SetPointAndShootParams

	mov	bx, offset NumberOfEdlFormats
	inc	bl
	mov	PointShootData.PQ_choices, bl

	call	_edltype_display

	mov	bx,es:Mode_Pntr
	call	_FindModeFromPointer	; Return mode in AL
	mov	cl,al

;;;;	mov	cl,Default_Mode		; Set default type mode
	inc	cl			; Make it a choice
	inc	cl
	call	position_query		; Get input
	jc	mnt6x			; Bail out if Exit key pressed
	cmp	cl,1
	jbe	mnt6x
	mov	al,cl
	dec	al			; Make it 0-n
	dec	al
	mov	Default_Mode,al
	call	_SetEdlBinFormatPointer

	call	_E1_flgs
	test	al,E1Flag_aud34ok	; Audio 3/4 ok?
	jnz	mnt6b
	and	Mode_Flag,11001111b	; Mask out Audio 3 and 4 _Emode
mnt6b:	call	_Set_AUXBLACK
	call	_upd_getrel
	call	_listtype_upd		; Tell everybody what it is
mnt6x:	ret
INSTL6	endp


;================================================================
INSTL7	proc	near
	mov	bx,offset PS_INSTALL7
	call	_SetPointAndShootParams

m7_agn:	call	_m7_CARD
	mov	cl,byte ptr INSTL_Choices + 7
	call	position_query
	jc	m7_r
	mov	byte ptr INSTL_Choices + 7,cl
	cmp	cl,1
	jnz	m7_1
m7_r:	ret

m7_1:	cmp	cl,2
	jnz	m7_2

m7_1agn:mov	bx,offset syscolorframe_ovr
	mov	dx,offset System_Color_Frame
	mov	al,1
	if NTSC
	mov	ah,1
	else
	mov	ah,3
	endif
	call	_PromptForDigits
	jc	m7_1agn
	jmp	m7_agn

m7_2:	jmp	m7_agn

INSTL7	endp


;================================================================
;			VTR ballistics
;================================================================

INSTL8	proc	near
	mov	bx,offset PS_INSTALL8
	call	_SetPointAndShootParams

	mov	al,Current_Source
	inc	al
	mov	byte ptr INSTL_Choices + 8, al

m8_agn:	call	_M8_CARD
	mov	cl,byte ptr INSTL_Choices + 8
	call	position_query
	jc	m8_xit
	mov	byte ptr INSTL_Choices + 8,cl

	cmp	cl,1
	jz	m8_xit

m8_2:	cmp	cl,ALLOWED_VTRS + 1	;8
	jnz	m8_3
	mov	cl,1
	mov	ch,cl
m8_3:	mov	al,cl				; Point SI to
	dec	al
	cbw					;  the correct
	call	Machine_Change
	push	ax
	call	_active_machines
	pop	ax
	MULTIPLY_BY Vtrcb_length, AX		;   buffer
	mov	si,offset Vtrcb			; Start with A-vtr
	add	si,ax
	call	_PromptForColorFrame
	call	_upd_getrel
	call	_active_machines
	jmp	m8_rc

m8_rc:	call	_kbd_cln
	jmp	m8_agn

m8_xit:	ret
INSTL8	endp

;================================================================
;			Convert EDL
;================================================================
INSTL9	proc	near
	IF PAL
	RET
	ENDIF

	IF NTSC
	call	_check4edl
	JMP_Z	m9_ret
	pop	bx			; Get rid of return
	call	_evnt_dispthis		; Display list
	mov	bx,offset Edlis_Msg
	call	_kbd_message
	mov	bx,offset Dropframe_Msg
	cmp	es:Edl_Fcm,DF_CHAR
	jz	m9_1
	mov	bx,offset Nondrop_Msg
m9_1:	call	_comsg
	mov	al,'.'
	call	_ConOut
	mov	bx,offset relchg_ovr
	call	_msgread
	mov	bx,offset Nondrop_Msg
	cmp	es:Edl_Fcm,DF_CHAR
	jz	m9_2
	mov	bx,offset Dropframe_Msg
m9_2:	call	_comsg
	mov	al,'?'
	call	_ConOut
	call	_Space_Out
	mov	cl,'N'
	call	yn_chos
	jz	m9_sw
	ret
m9_sw:	mov	al,NDF_CHAR
	cmp	es:Edl_Fcm,DF_CHAR
	jz	m9_sw1
	mov	al,DF_CHAR
m9_sw1:	mov	es:Edl_Fcm,al

;----------------------------------------------------------------
; Alter list to new FCM format on RECORD side only
	call	_kbd_cln
	call	_working
	mov	ax,es:Current_Event
	push	ax
	mov	cx,1
m9_swlp:mov	ax,cx
	push	cx
	call	_index_storage
	jc	m9_sgn

	call	_getlast_rtcd
	mov	al,es:Edl_Fcm
	mov	es:[bx],al
	cmp	al,DF_CHAR		; Check type of conversion

	call	_getlast_rin
	jz	m9_cnv1

	call	_cnvt2df_ES
	call	_getlast_rout
	call	_cnvt2df_ES
	jmp	m9_sgn

m9_cnv1:call	_cnvt2nd_ES
	call	_getlast_rout
	call	_cnvt2nd_ES

m9_sgn:	pop	cx
	inc	cx
	cmp	cx,es:Next_Avail_Num
	jb	m9_swlp
	pop	ax
	call	_event_display
m9_ret:	ret
	ENDIF

INSTL9	endp

;================================================================
INSTL10	proc	near
	call	_kbd_cln
	mov	bx,offset hardrecord_ovr
	call	_msgread
	mov	cl,'N'
	call	yn_chos
	jc	m10x
	mov	al,0
	jnz	m10off
	mov	al,0ffh
m10off:
	mov	Hardrecord_Flag,al
	call	_mode_upd
m10x:	ret
INSTL10	endp

;================================================================
INSTL11	proc	near
	mov	bx,offset PS_INSTALL11
	call	_SetPointAndShootParams

m11_agn:call	_M11_CARD
	mov	cl,byte ptr INSTL_Choices + 11
	call	position_query
	jnc	m11_1
	call	_help_pos
	ret

m11_1:	mov	byte ptr INSTL_Choices + 11,cl

	cmp	cl,1
	jnz	m11_2
	call	_help_pos
	ret

;	AUTO DISABLE ON RECORD
m11_2:	cmp	cl,2
	jnz	m11_3
	mov	bx,offset autodisable_ovr
	mov	dx,offset EDLoptions_Flags
	mov	ax,autdsabl_EDLBIT
	call	m20_chs
	jmp	m11_agn

;	STORE MASTER/SLAVES TO EDL
m11_3:	cmp	cl,3
	jnz	m11_4
	mov	bx,offset slave_store_ovr
	mov	dx,offset Slave_Flags
	mov	ax,store_MSBIT ;slave 
	call	m20_chs
	jmp	m11_agn

;	RECORD RIPPLE UPDATES SLAVES
m11_4:	cmp	cl,4
	jnz	m11_5
	mov	bx,offset recripl_store_ovr
	mov	dx,offset Edit_Flags
	mov	ax,riplslave_EDBIT
	call	m20_chs
	jmp	m11_agn

;	STORE GPIS TO EDL
m11_5:	cmp	cl,5
	jnz	m11_6
	mov	bx,offset gpi_store_ovr
	mov	dx,offset Gpi_Flags
	mov	ax,store_MSBIT ;gpi 
	call	m20_chs
	jmp	m11_agn

;	STORE PMCS TO EDL
m11_6:	cmp	cl,6
	jnz	m11_7
	mov	bx,offset PMC_store_ovr
	mov	dx,offset Pmc_Flags
	mov	ax,store_MSBIT ;pmc 
	call	m20_chs
	jmp	m11_agn

;	STORE SPDS TO EDL
m11_7:	cmp	cl,7
	jnz	m11_8
	mov	bx,offset SPD_store_ovr
	mov	dx,offset Spd_Flags
	mov	ax,store_MSBIT
	call	m20_chs
	jmp	m11_agn

;	STORE MULTIPLE RECORDS TO EDL
m11_8:	cmp	cl,8
	jnz	m11_9
	mov	bx,offset REC_store_ovr
	mov	dx,offset MultRec_Flags
	mov	ax,store_MSBIT
	call	m20_chs
	jmp	m11_agn

m11_9:	jmp	m11_agn

INSTL11	endp

;================================================================
;		ASSEMBLY OPTIONS
;================================================================
INSTL12	proc	near
	mov	bx,offset PS_INSTALL12
	call	_SetPointAndShootParams

m12_agn:call	_M12_CARD
	mov	cl,byte ptr INSTL_Choices + 12
	call	position_query
	jnc	m12_1
	ret

m12_1:	mov	byte ptr INSTL_Choices + 12,cl
	cmp	cl,1
	jnz	m12_2
	ret

m12_2:	cmp	cl,2
	jnz	m12_3
m12_2agn:
	call	_kbd_cln
	mov	bx,offset asmmode_ovr
	call	_msgread
	dim_VIDEO FALSE,FALSE
	mov	al,'['
	call	_ConOut
	norm_VIDEO FALSE,FALSE
	mov	al,Assembly_Mode
	call	_ConOut
	mov	bx,offset Mode_Msg
	call	_comsg
	dim_VIDEO FALSE,FALSE
	mov	al,']'
	call	_ConOut
	norm_VIDEO FALSE,FALSE

	call	get_ucase
	call	_Break_check			; Exit if Break
	jz	m12_agn
	cmp	al,cr
	jz	m12_agn
	cmp	al,'A'
	jz	m12_setasmmode
	cmp	al,'B'
	jz	m12_setasmmode
m12_err:call	_error_bell
	jmp	m12_2agn

m12_setasmmode:
	mov	Assembly_Mode,al
	jmp	m12_agn

m12_3:	cmp	cl,3
	jnz	m12_4
	mov	bx,offset lookahead_ovr
	mov	dx,offset Operational_Flags
	mov	ax,lookahead_OPBIT
	call	m20_chs
	jmp	m12_agn

m12_4:	cmp	cl,4
	jnz	m12_5
	mov	bx,offset lookcount_ovr
	mov	dx,offset Edits_To_Look_Ahead
	mov	al,2
	mov	ah,99
	call	_PromptForDigits
	jmp	m12_agn

m12_5:	jmp	m12_agn

INSTL12	endp


;================================================================
INSTL13	proc	near
	call	Program_Relays
	ret
INSTL13	endp

;================================================================
INSTL14	proc	near
	call	diagnostics
	ret
INSTL14	endp

;=======================================================
;		Get new start time
;=======================================================
INSTL15	proc	near
	mov	bx,offset timestart_rqst; Display prompt
	call	_Inout_init
	mov	bx,offset Time_Start
	xor	cl,cl			; No + or -
	mov	ch,es:Edl_Fcm
	call	tc_parenth

	mov	bx,offset Sttime	; Get start time
	mov	al,es:Edl_Fcm
	call	tc_cimsg		; From user
	jnc	m15_1

	mov	dx,offset Time_Start	; ELSE, destination is in DX
	call	_mmv3byt
	jmp	m15bc			; Clear register

m15_1:	call	_time_value		; Anything there?
	jz	m15b_1			; Skip if not

m15_2:	mov	dx,offset Time_Start	; ELSE, destination is in DX
	call	_mmv3byt

m15b_1:	call	_check4edl		; Any list?
	jz	m15bx			; Skip if not

	call	_kbd_cln	; Reset and re-calculate running
	mov	bx,offset resettt_ovr	;  time counter?
	mov	cl,'Y'			; Default to YES
	call	pos_yn_chos
	jnz	m15bx
	call	running_time
	ret
INSTL15	endp

running_time_FAR	proc	far
	call	running_time
	ret
running_time_FAR	endp

running_time	proc	near
	mov	bx,offset Time_Total	; Clear out total time
	call	_clear_tc

	call	gethigh_out		; Get highest edit out in EDL
	call	_Entime_move
	jz	m15bc

	mov	bx,offset Time_Start
	call	_Sttime_move
	jz	m15bc
	call	_timdif			; BX points to difference
	mov	dx,offset Time_Total
	call	_mmv3byt
	jmp	m15bx

m15bc:	mov	bx,offset Time_Total
	xor	ax,ax
	mov	[bx],ax
	mov	2[bx],al
m15bx:	call	_time_upd
	ret

;----------------------------------------------------------------
; Get DS:BX pointing to the highest
gethigh_out:
	mov	bx,offset Bytstr1	; Clear out holding buffer
	call	_clear_tc

	call	_check4edl		; EDL present?
	jz	ghigh_x			; Skip if not

	mov	ax,es:Current_Event
	push	ax			; Save current event

; Loop through the EDL
	xor	ax,ax			; Start with first edit
ghigh_1:inc	ax			; Point to next edit
	cmp	ax,es:Next_Avail_Num	; Out of edits?
	jnb	ghigh_5			; Exit if so
	call	_index_storage
	jc	ghigh_1			; Skip comments, etc.

	push	ax
	add	bx,offset ZeroBase.rout_lofst	; BX points to ROUT
	mov	si,offset Bytstr1	; SI points to last highest

	mov	al,2[si]		; Is Highest < ROUT?
	cmp	al,es:2[bx]
	jc	ghigh_2
	mov	ax,[si]
	cmp	ax,es:[bx]
	jnc	ghigh_3

ghigh_2:mov	ax,es:[bx]		; Store new high number
	mov	[si],ax
	mov	al,es:2[bx]
	mov	2[si],al
ghigh_3:pop	ax			; Restore event number
	jmp	ghigh_1			; and loop for next

; All events done.
ghigh_5:pop	ax			; Restore current event
	call	_index_storage
	mov	bx,offset Bytstr1	; Clear out holding buffer
ghigh_x:ret
running_time	endp

;================================================================
;		Edit "slop" factor & retry Count
;================================================================
INSTL16	proc	near
	mov	bx,offset PS_INSTALL16
	call	_SetPointAndShootParams

m16_agn:call	_m16_dsp
	mov	cl,byte ptr INSTL_Choices + 16
	call	position_query
	jc	m16_xit
	mov	byte ptr INSTL_Choices + 16,cl

	cmp	cl,1
	jz	m16_xit

m16_2:	cmp	cl,ALLOWED_VTRS + 2	;9	; Retries?
	jz	m16_9
	cmp	cl,ALLOWED_VTRS + 1	;8
	jnz	m16_3
	mov	cl,1
	mov	ch,cl
m16_3:	mov	al,cl				; Point SI to
	dec	al
	cbw					;  the correct
	MULTIPLY_BY Vtrcb_length, AX		;  SLOP WINDOW buffer
	mov	si,offset Vtrcb.Vtrcb_WINDOW	; Start with A-vtr
	add	si,ax
	call	_kbd_cln
	call	_m16_prmpt
	mov	bl,[si]
	mov	bh,0
	call	_default_val
	mov	al,2
	call	dec_cimsg
	jz	m16_rc
	call	_convert2bin
	mov	[si],al
	jmp	m16_rc

m16_9:	mov	bx,offset Retry_Count_ovr	; Get retry Count
	mov	dx,offset Retry_Count
	mov	al,2
	mov	ah,99
	call	_PromptForDigits
	jmp	m16_rc

m16_rc:	call	_kbd_cln
	jmp	m16_agn

m16_xit:ret

INSTL16	endp

;================================================================
; Trigger delays
;================================================================
INSTL17	proc	near
	call	_help_pos
	mov	bx,offset PS_INSTALL17
	call	_SetPointAndShootParams

	norm_VIDEO FALSE,FALSE
	mov	bx,offset trigadjust_ovr
	call	_msgread
	call	m17dsp

m17_agn:mov	cl,byte ptr INSTL_Choices + 17
	call	position_query
	JMP_C	m17_xit
	mov	byte ptr INSTL_Choices + 17,cl

	cmp	cl,1
	JMP_Z	m17_xit
	push	cx
	dec	cl
	mov	dx,offset Otf_Adjust
	mov	bx,offset otf_qry
	dec	cl
	JMP_Z	m17sel
	mov	dx,offset VvvIN_Offset
	mov	bx,offset vvvIN_qry
	dec	cl
	JMP_Z	m17sel
	mov	dx,offset VvvOUT_Offset
	mov	bx,offset vvvOUT_qry
	dec	cl
	JMP_Z	m17sel
	mov	dx,offset SplitV_Offset
	mov	bx,offset splitV_qry
	dec	cl
	JMP_Z	m17sel
	mov	dx,offset SplitA_Offset
	mov	bx,offset splitA_qry
	dec	cl
	jz	m17sel
	mov	dx,offset VbvIN_Offset
	mov	bx,offset vbvIN_qry
	dec	cl
	jz	m17sel
	mov	dx,offset VbvOUT_Offset
	mov	bx,offset vbvOUT_qry
	dec	cl
	jz	m17sel
	mov	dx,offset BvbIN_Offset
	mov	bx,offset bvbIN_qry
	dec	cl
	jz	m17sel
	mov	dx,offset BvbOUT_Offset
	mov	bx,offset bvbOUT_qry
	dec	cl
	jz	m17sel
	mov	dx,offset Atrans_Offset
	mov	bx,offset atrans_qry
	dec	cl
	jz	m17sel
	mov	dx,offset Gtrans_Offset
	mov	bx,offset gtrans_qry
	dec	cl
	jz	m17sel
	mov	dx,offset Sync_Offset_In
	mov	bx,offset syncIN_qry
	dec	cl
	jz	m17sel
	mov	dx,offset Sync_Offset_Out
	mov	bx,offset syncOUT_qry
	dec	cl
	jz	m17sel
	mov	dx,offset PMC_Offset
	mov	bx,offset PMC_qry
	dec	cl
	jz	m17sel
	mov	dx,offset RT_Offset
	mov	bx,offset RT_qry
	dec	cl
	jz	m17sel
	jmp	m17_agn

m17sel:	call	m17gtca
	pop	cx
	jmp	m17_agn

m17_xit:call	_help_pos
	ret

m17gtca:call	_Inout_init
	mov	bx,offset Adjust_Msg
	call	_comsg
m17gtcb:mov	bx,dx
	mov	cl,3[bx]		; Get sign

; GET TIME CODE FROM USER
; ENTER: BX points to 4 byte buffer destination
;	 AL has TCF
;	 CL has sign, if any
m17get:	push	bx
	mov	bx,offset Sttime	; Get start time
	mov	Trim_Ci_Flag,0ffh
	mov	al,NDF_CHAR		; Use non-drop frames
	call	tc_cimsg		; From user
	jnc	m17get1
	pop	bx			; Restore buffer
	mov	byte ptr 3[bx],' '	; Clear sign
	call	_clear_tc
	jmp	m17dsp

m17get1:call	_time_value
	pop	dx
	jz	m17dsp
	call	_mmv3byt

m17dsp:	mov	cl,Sign_Flag
	or	cl,cl
	jz	m17dspns
	mov	si,dx
	mov	3[si],cl

m17dspns:
	mov	di,PointShootData.PQ_Cursor			; Screen position
	xor	cl,cl				; Clear number counter

	xor	si,si
	mov	dx,offset exitmenu_ovr
	call	m17dsp1
	add	di,100h
	mov	si,offset Otf_Adjust
	mov	dx,offset otf_qry
	call	m17dsp1
	mov	si,offset VvvIN_Offset
	mov	dx,offset vvvIN_qry
	call	m17dsp1
	mov	si,offset VvvOUT_Offset
	mov	dx,offset vvvOUT_qry
	call	m17dsp1
	mov	si,offset SplitV_Offset
	mov	dx,offset splitV_qry
	call	m17dsp1
	mov	si,offset SplitA_Offset
	mov	dx,offset splitA_qry
	call	m17dsp1
	mov	si,offset VbvIN_Offset
	mov	dx,offset vbvIN_qry
	call	m17dsp1
	mov	si,offset VbvOUT_Offset
	mov	dx,offset vbvOUT_qry
	call	m17dsp1

	mov	di,PointShootData.PQ_Cursor
	add	di,0029h		; 40th column

	mov	si,offset BvbIN_Offset
	mov	dx,offset bvbIN_qry
	call	m17dsp1
	mov	si,offset BvbOUT_Offset
	mov	dx,offset bvbOUT_qry
	call	m17dsp1
	mov	si,offset Atrans_Offset
	mov	dx,offset atrans_qry
	call	m17dsp1
	mov	si,offset Gtrans_Offset
	mov	dx,offset gtrans_qry
	call	m17dsp1
	mov	si,offset Sync_Offset_In
	mov	dx,offset syncIN_qry
	call	m17dsp1
	mov	si,offset Sync_Offset_Out
	mov	dx,offset syncOUT_qry
	call	m17dsp1
	mov	si,offset PMC_Offset
	mov	dx,offset PMC_qry
	call	m17dsp1
	mov	si,offset RT_Offset
	mov	dx,offset RT_qry

m17dsp1:mov	al,3[si]		; Get sign
m17dsp1a:
	push	ax
	mov	Cursor,di
	mov	bx,dx
	call	_dashit_cl
	or	si,si
	jnz	m17dsp1b
	pop	ax
	call	_msgread
	ret

m17dsp1b:
	call	_msgread
	mov	bx,offset Adjust_Msg
	call	_comsg
	norm_VIDEO FALSE,FALSE
	mov	bx,di
	add	bl,26
	mov	Cursor,bx
	pop	ax			; Restore sign
	call	_ConOut

	push	cx
	push	di
	mov	bx,si
	mov	cl,NDF_CHAR
	mov	dx,offset Tcdispbuf
	call	_cnvt2tc_DS
	call	_comsg
	pop	di
	add	di,100h
	pop	cx
	ret
INSTL17	endp

;================================================================
INSTL18	proc	near
	jmp	setsync			; Set new VLAN edit sync
INSTL18	endp

;================================================================
; DOS interface
INSTL19	proc	near
	mov	bx,offset PS_INSTALL19
	call	_SetPointAndShootParams

m19_agn:call	_M19_CARD
	mov	cl,byte ptr INSTL_Choices + 19
	call	position_query
	jnc	m19_1
	call	_help_pos
	ret

m19_1:	mov	byte ptr INSTL_Choices + 19,cl
	cmp	cl,1
	jnz	m19_2
	call	_help_pos
	ret

m19_2:	cmp	cl,2
	jnz	m19_3
	mov	bx,offset menu_ovr
	mov	dx,offset DOS_Flags
	mov	ax,usemenu_DOSBIT
	call	m20_chs
	test	DOS_Flags,usemenu_DOSBIT
	jz	m19_agn
	call	_menu_find
	jmp	m19_agn

m19_3:	cmp	cl,3
	jnz	m19_4
	mov	bx,offset ejectpage_ovr
	mov	dx,offset DOS_Flags
	mov	ax,ejectpg_DOSBIT
	call	m20_chs
m19_4:	jmp	m19_agn

m19x:	ret

INSTL19	endp


;================================================================
;			Screen/Sound Prefs
;================================================================
INSTL20	proc	near
	mov	bx,offset PS_INSTALL20
	call	_SetPointAndShootParams

m20_agn:call	_M20_CARD
	mov	cl,byte ptr INSTL_Choices + 20
	call	position_query
	jnc	m20_1
	call	_help_pos
	ret

m20_1:	mov	byte ptr INSTL_Choices + 20,cl
	dec	cl
	jnz	m20_2
	call	_help_pos
	ret

m20_2:	dec	cl
	jnz	m20_3
	mov	bx,offset screengrid_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,border_SDBIT
	call	m20_chs
	push	cx
	call	screen_init
	pop	cx
	jmp	m20_agn

; Lastkey display
m20_3:	dec	cl
	jnz	m20_4
	mov	bx,offset lastkey_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,lastkey_SDBIT
	call	m20_chs
	jmp	m20_agn

m20_4:	dec	cl
	jnz	m20_5
	mov	bx,offset recheck_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,recheck_SDBIT
	call	m20_chs
	jmp	m20_agn

; Ask user if we are to display list in MANAGER I format (default)
;  or selected format
m20_5:	dec	cl
	jnz	m20_6
	mov	bx,offset disptype_ovr
	mov	dx,offset EDLoptions_Flags
	mov	ax,modedisp_EDLBIT
	call	m20_chs
	jmp	m20_agn

m20_6:	dec	cl
	jnz	m20_7
	mov	bx,offset modetype_ovr
	mov	dx,offset EDLoptions_Flags
	mov	ax,modetype_EDLBIT
	call	m20_chs
	jmp	m20_agn

; Bell toggle
m20_7:	dec	cl
	jnz	m20_8
	mov	bx,offset beltogl_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,bell_SDBIT
	call	m20_chs
	jmp	m20_agn

; Error bells
m20_8:	dec	cl
	jnz	m20_9
	mov	bx,offset errbell_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,errbell_SDBIT
	call	m20_chs
	jmp	m20_agn

m20_9:	dec	cl
	jnz	m20_10
	mov	bx,offset timedisplay_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,timedate_SDBIT
	call	m20_chs
	call	screen_init
	jmp	m20_agn

m20_10:
	if NTSC
	dec	cl
	jnz	m20_11
	mov	bx,offset durfcm_ovr
	mov	dx,offset Network_Flags
	mov	ax,DFdur_NTBIT
	call	m20_chs
	call	screen_init
	jmp	m20_agn
	endif

; Bell rate
m20_11:	dec	cl
	jnz	m20_12
	mov	bx,offset brate_ovr
	mov	bx,offset Retry_Count_ovr	; Get retry Count
	mov	dx,offset Blink_Time
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	jmp	m20_agn

m20_12:	dec	cl
	jnz	m20_13
	mov	bx,offset edltrack_ovr
	mov	dx,offset Edltrack_Delay
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	JMP_C	m20_agn
	mov	al,Edltrack_Delay
	cbw
	mov	cx,500
	mul	cx
	mov	Edltrack_Cdelay,ax
	jmp	m20_agn

m20_13:	dec	cl
	jnz	m20_14
	mov	bx,offset sortdirs_ovr
	mov	dx,offset Sounddisplay_Flags
	mov	ax,sortedls_SDBIT
	call	m20_chs
	jmp	m20_agn

m20_14:	jmp	m20_agn

m20_chs:call	_kbd_cln
	push	dx
	call	_msgread
	pop	bx
	cmp	PointShootData.PQ_keypressed,'N'
	jz	mtgl3n
	cmp	PointShootData.PQ_keypressed,'Y'
	jz	mtgl2y
	cmp	PointShootData.PQ_keypressed,'T'
	jnz	mtgl1
	call	_bit_toggle_bx
	ret

mtgl3n:	not	al
	and	[bx],al
	not	al
	ret

mtgl2y:	or	[bx],al
	ret

;...
; BX points to Flag
mtgl1:	push	cx
	mov	cl,'N'
	test	[bx],al
	jz	mtgl2
	mov	cl,'Y'
mtgl2:	push	ax
	call	yn_chos
	pop	ax
	jc	mtabrt
	jnz	mtgl3
	or	[bx],al
mtabrt:	pop	cx
	ret

mtgl3:	not	al
	and	[bx],al
	pop	cx
	ret

INSTL20	endp


;================================================================
log_Drive_shortcut	proc	near
	mov	Input_Flag,INFL_menu
log_Drive_shortcut	endp

INSTL21	proc	near
	call	_help_pos
	mov	bx,offset PS_INSTALL21
	call	_SetPointAndShootParams

m21_agn:call	_m21_dsp
	mov	cl,byte ptr INSTL_Choices + 21
	call	position_query
	jc	m21_xit
	mov	byte ptr INSTL_Choices + 21,cl

	cmp	cl,1
	jnz	m21_1
	call	_help_pos
	ret

m21_1:	cmp	cl,2
	jnz	m21_2
	call	_log_Drive		; Check for new Drive/dir
	jmp	m21_agn

m21_xit:call	_help_pos
	ret

m21_2:	cmp	cl,3
	jnz	m21_3
	call	_log_autofile
	jmp	m21_agn

m21_3:	cmp	cl,4
	jnz	m21_4
	call	_log_TCMfile
	jmp	m21_agn

m21_4:	cmp	cl,5
	jnz	m21_5
	call	_log_VMEfile
	jmp	m21_agn

m21_5:	cmp	cl,6
	jnz	M21_6
	push	cx
	call	_kbd_cln
	mov	bx,offset fext_ovr
	call	_msgread
	mov	al,3
	call	cimsg_wrk
	jz	m21_5a
	mov	dx,offset Edl_Ext
	call	_mmv3byt
m21_5a:	pop	cx
	jmp	m21_agn

M21_6:	cmp	cl,7
	jnz	m21_7
	call	_log_TMPfile
	jmp	m21_agn

m21_7:	jmp	m21_agn

INSTL21	endp

;================================================================
; Keyboard prefrences
; Define wild keys 1 and 2
INSTL22	proc	near
	mov	bx,offset PS_INSTALL22
	call	_SetPointAndShootParams

m22_agn:call	_M22_CARD
	mov	cl,byte ptr INSTL_Choices + 22
	call	position_query
	jc	m22_xit
	mov	byte ptr INSTL_Choices + 22,cl

	cmp	cl,1
	jz	m22_xit
m22_1:	cmp	cl,2
	jnz	m22_2
	call	_kbd_cln

	mov	bx,offset rptoggle_ovr
	mov	dx,offset Network_Flags
	mov	ax,rptoggle_NTBIT
	call	m20_chs
	jmp	m22_agn

m22_xit:call	_help_pos
	ret

m22_2:	cmp	cl,3
	jnz	m22_3
	call	_kbd_cln
	mov	bx,offset pauseplay_ovr
	mov	dx,offset Network_Flags
	mov	ax,pauseplay_NTBIT
	call	m20_chs
	jmp	m22_agn

; Set / Reset wild keys
m22_3:	cmp	cl,4
	jnz	m22_4
	mov	bx,offset wild_ovr
	mov	al,'1'
	call	m22_prmpt
	jnz	m22_3a
	mov	bx,offset wildkeys_ovr
	mov	si,offset Wild1
	mov	al,'1'
	call	m22_key				; Get new keystroke
m22_3a:	jmp	m22_agn

m22_4:	cmp	cl,5
	jnz	m22_5
	mov	bx,offset wild_ovr
	mov	al,'2'
	call	m22_prmpt
	jnz	m22_4a
	mov	bx,offset wildkeys_ovr
	mov	si,offset Wild2
	mov	al,'2'
	call	m22_key				; Get new keystroke
m22_4a:	jmp	m22_agn

; Set / Reset jogger keys
m22_5:	cmp	cl,6
	jnz	m22_6
	mov	bx,offset joykey_ovr
	mov	al,'1'
	call	m22_prmpt
	jnz	m22_5a
	mov	bx,offset joykeys_ovr
	mov	si,offset Joykey1
	mov	al,'1'
	call	m22_key				; Get new keystroke
m22_5a:	jmp	m22_agn

m22_6:	cmp	cl,7
	jnz	m22_7
	mov	bx,offset joykey_ovr
	mov	al,'2'
	call	m22_prmpt
	jnz	m22_6a
	mov	bx,offset joykeys_ovr
	mov	si,offset Joykey2
	mov	al,'2'
	call	m22_key				; Get new keystroke
m22_6a:
	jmp	m22_agn

m22_7:
	jmp	m22_agn

;================================================================
m22_prmpt:
	push	ax			; Save # 1 or 2
	call	_kbd_cln
	call	_msgread
	pop	ax
	call	_ConOut
	mov	cl,'N'
	jmp	yn_chos

m22_key:push	ax
	call	_kbd_cln
	call	_msgread
	pop	ax
	call	_ConOut
	call	_Space_Out
	call	rdchar
	mov	[si],ax
	ret

INSTL22	endp

;================================================================
;		JOYSTICK SELECT AND CALIBRATE
;================================================================

INSTL23	proc	near
	mov	bx,offset PS_INSTALL23
	call	_SetPointAndShootParams

m23_agn:call	_M23_CARD
	mov	cl,byte ptr INSTL_Choices + 23
	call	position_query
	jnc	m23_1
	call	_help_pos
	ret

m23_1:	mov	byte ptr INSTL_Choices + 23,cl
	cmp	cl,1
	jnz	m23_2
	call	_help_pos
	ret

m23_2:	cmp	cl,2
	jnz	m23_3
	call	_help_pos
	call	_kbd_cln
	mov	bx,offset usejstick_ovr
	mov	dx,offset Network_Flags
	mov	ax,joystick_NTBIT
	call	m20_chs
	test	Network_Flags,joystick_NTBIT
	jz	m23_agn
	call	_check4joystick
	call	_StickItToEm
	jmp	m23_agn

m23_3:	cmp	cl,3
	jnz	m23_4
	mov	bx,offset useJogger_ovr
	mov	dx,offset Network_Flags
	mov	ax,Jogger_NTBIT
	call	m20_chs
	jmp	m23_agn

m23_4:	cmp	cl,4
	jnz	m23_5
	mov	bx,offset shuttlesense_ovr
	mov	dx,offset ShuttleSensitivity
	mov	al,3
	mov	ah,255
	call	_PromptForDigits
	jmp	m23_agn

m23_5:	cmp	cl,5
	jnz	m23_7
	call	_kbd_cln
	mov	bx,offset JoggerIRQ_ovr
	call	_msgread
	call	_Space_Out
	mov	al,'['
	call	_ConOut
	mov	ax,JoggerIRQ
	call	_BitCountReset
	call	_A_DecOut
	mov	al,']'
	call	_ConOut
	call	_Space_Out
	mov	al,2
	call	dec_cimsg
	JMP_Z	m23_agn
	call	_convert2bin
	call	_BitCountSet	; Get AL bit # set to AL
	mov	JoggerIRQ,ax
	jmp	m23_agn

m23_7:	jmp	m23_agn

INSTL23	endp


;================================================================
; VLAN enable
INSTL24	proc	near
	if DEMO_RELEASE
	jmp	Lockout
	else

	call	_kbd_cln
	mov	ax,offset M_id
	call	motion
	mov	cl,'N'			; Set for NO
	jc	M24_1
	mov	cl,'Y'			; Set for YES
	mov	si,bx
	cmp	byte ptr [si],' '
	jbe	M24_1
	mov	bx,offset vlanversion_ovr
	call	_msgread
M24_co:	lodsb
	cmp	al,cr
	jz	M24_cox
	or	al,al
	jz	M24_cox
	call	_ConOut
	jmp	M24_co
M24_cox:call	space_2_out

M24_1:	mov	bx,offset EnableVlan_ovr
	call	_msgread
	call	yn_chos
	jc	M24ret
	mov	al,vlan_IOTYP			; Set for enabled (1)
	jnz	M24dabl
M24enb:	or	Device_Enabled,al		; Enable it
	call	_kbd_cln
	blinkrev_VIDEO FALSE,FALSE		; Dim please.
	mov	bx,offset Resetting_Msg
	call	_comsg
	norm_VIDEO FALSE,FALSE			; Dim please.
	call	VLAN_init			; Try to Initiate it
	test	Device_Enabled,vlan_IOTYP
	JMP_NZ	Vlan_Upd
	call	screen_init
	call	Vlan_Upd			; Update screen and return
	ret

M24dabl:and	Network_Flags,not EDLtrak_NTBIT
	not	al
	and	Device_Enabled,al		; Disable it,
	and 	Device_Present,al		;  and forget about it
	call	Vlan_Upd

	if NTSC
	call	_SetNewRvtFCM
	endif

M24ret:	ret
	endif
INSTL24	endp


;================================================================
; COM and LST setup
INSTL25	proc	near
	call	_setcom
	ret
INSTL25	endp

;================================================================
; Switcher setups
INSTL26	proc	near
	call	_VTR_Port_Assignment
	ret
INSTL26	endp


;================================================================
; Automatically get node status for all nodes on line
Node_Stats_FAR	proc	far
	call	Node_Stats
	ret
Node_Stats_FAR	endp

Node_Stats	proc	near
	test	Device_Present,vlan_IOTYP
	JMP_Z	nodstx

	call	_help_pos
	mov	di,offset List_Scr
	mov	si,di
	mov	al,1			; Start with node 1

nodstag:mov	Cursor,di
	dim_VIDEO FALSE,TRUE
	mov	bx,offset Node_Stat_ovr
	call	_msgread
	norm_VIDEO FALSE,TRUE
	add	di,101h
	mov	ch,1
nodstlp:mov	Cursor,di
	push	ax
	mov	cl,al
	call	get_appltype
	or	al,al
	jz	nodstn
	xchg	al,cl
	cmp	al,9
	ja	nodst1
	call	_Space_Out
nodst1:	call	_A_DecOut
	mov	al,cl
	mov	bx,offset Mcrosep
	call	_comsg
	mov	cl,12
	mul	cl
	mov	bx,offset Application_Types
	add	bx,ax
	call	_comsg
	call	_Space_Out
	pop	ax
	push	ax
	call	devtype			; Get device type
	call	_comsg
	add	di,100h
	inc	ch
	cmp	ch,8	;7
	jbe	nodstn
	add	si,26
	mov	di,si
	mov	ch,0
nodstn:	pop	ax			; Restore node#
	inc	al			; Increment to next
	cmp	al,32			; Check for done
	jnc	nodstx
	cmp	ch,0
	jnz	nodstlp
	jmp	nodstag			; Loop if not done

nodstx:	ret
Node_Stats	endp

;================================================================
; CMX INSTL 4 type switching
INSTL27	proc	near
m27_agn:
	mov	bx,offset PS_INSTALL27
	call	_SetPointAndShootParams

	call	_M27_CARD
	mov	cl,byte ptr INSTL_Choices + 27
	call	position_query
	jc	m27_r
	mov	byte ptr INSTL_Choices + 27,cl
	cmp	cl,1
	jnz	m27_2
m27_r:	ret

m27_2:	cmp	cl,2
	jnz	m27_3
	mov	bx,offset efxadr_ovr
	mov	dx,offset Effects_Address
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	call	SetVlanEfxAddress
	jmp	m27_agn

m27_3:	cmp	cl,3
	jnz	m27_4
	mov	bx,offset upstrkey_ovr
	mov	dx,offset Upstream_Keynumber
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	jmp	m27_agn

m27_4:	cmp	cl,4
	jnz	m27_5
	mov	bx,offset dnstrkey_ovr
	mov	dx,offset Dnstream_Keynumber
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	jmp	m27_agn


m27_5:	cmp	cl,5
	jnz	m27_6
	mov	bx,offset ememefxadr_ovr
	mov	dx,offset Emem_Efxadr
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	jmp	m27_agn


m27_6:	cmp	cl,6
	jnz	m27_7
	mov	bx,offset wipemods_ovr
	mov	dx,offset Switcher_Flags
	mov	ax,wipemods_SWBIT
	call	m20_chs
	jmp	m27_agn

m27_7:	cmp	cl,7
	jnz	m27_8
	mov	bx,offset forcev3_ovr
	mov	dx,offset VLAN_Flags
	mov	ax,forcever3_VLNBIT
	call	m20_chs
	jmp	m27_agn

m27_8:	cmp	cl,8
	jnz	m27_9
	mov	bx,offset extmenu_ovr
	mov	dx,offset Switcher_Flags
	mov	ax,extmenu_SWBIT
	call	m20_chs
	jmp	m27_agn


m27_9:	cmp	cl,9
	jnz	m27_10
	mov	bx,offset audefxadr_ovr
	mov	dx,offset Audio_Effects_Address
	mov	al,1
	mov	ah,9
	call	_PromptForDigits
	jmp	m27_agn


m27_10:	cmp	cl,10
	jnz	m27_11
	mov	bx,offset vidbase_ovr
	mov	dx,offset VlanVideoPort
	mov	al,2
	mov	ah,31
	call	_PromptForDigits
	jmp	m27_agn

m27_11:	cmp	cl,11
	jnz	m27_12
	mov	bx,offset vidbase2_ovr
	mov	dx,offset VlanVideoPort2
	mov	al,2
	mov	ah,31
	call	_PromptForDigits
	jmp	m27_agn

m27_12:	cmp	cl,12
	jnz	m27_13
	mov	bx,offset audbase_ovr
	mov	dx,offset VlanAudioPort
	mov	al,2
	mov	ah,31
	call	_PromptForDigits
	jmp	m27_agn

m27_13:	cmp	cl,13
	jnz	m27_14
	mov	bx,offset pvwbase_ovr
	mov	dx,offset VlanPreviewPort
	mov	al,2
	mov	ah,31
	call	_PromptForDigits
	jmp	m27_agn

m27_14:	cmp	cl,14
	jnz	m27_15
	call	fastswitch
	jmp	m27_agn

m27_15:	jmp	m27_agn
INSTL27	endp


;...
fastswitch	proc	near
	mov	bx,offset fastswitch_ovr
	call	_kbd_cln
	call	_msgread
	mov	bx,offset frommsg_ovr
	call	_getmkey
	jc	m27dlyr
	cmp	al,0f0h
	jnc	m27dlyr
	mov	cl,al
	mov	bx,offset tomsg_ovr
	call	_getmkey
	jc	m27dlyr
	cmp	al,0f0h
	jnc	m27dlyr			; Do not allow VIDEO request
	mov	ch,al
	push	cx

	mov	bx,offset Frame_Msg
	call	_comsg
	mov	al,2
	call	dec_cimsg
	call	_convert2bin
	jnz	m27nd
	mov	ax,2			; Default to two frames

; AX = # of frames to delay, CL=from, CH=to
m27nd:	mov	bp,ax
	pop	cx

m27sw:	mov	al,cl
	push	cx
	call	PST_switch
	call	Preview_Switch
	call	switch
	call	m27dly
	pop	cx
	mov	al,ch
	push	cx
	call	PST_switch
	call	Preview_Switch
	call	switch
	call	m27dly
	pop	cx
	jmp	m27sw

m27dly:	push	cx
	mov	cx,bp
m27dlyl:call	_delfrm
	call	cstat
	jnz	m27dlyx
	loop	m27dlyl
	pop	cx
	ret

m27dlyx:pop	cx			; Restore CX
	pop	cx			;  twice
	pop	bx			; Restore return address
	mov	al,Current_Machine
	call	switch
	clc
m27dlyr:ret
fastswitch	endp

;----------------------------------
; INDIVIDUAL HELP SCREENS FOR KEYS
;----------------------------------
keyhelp	proc	near
	mov	bx,offset keyhelp_ovr
	call	_kbd_cln
	call	_msgread
	call	rdchar			; Get a character inputted
	jmp	context_help
keyhelp	endp

;================================================================
copywrite	proc	near
	call	_dflts_disp
	call	_help_pos
;;;	call	_crlf
	call	_crlf
	mov	bx,offset title1_ovr
	call	cpytlp
	mov	bx,offset title2_ovr
	call	cpytlp
	mov	bx,offset title3_ovr
	call	cpytlp
	mov	bx,offset title4_ovr
	call	cpytlp
	mov	bx,offset title5_ovr
	call	cpytlp
	mov	bx,offset title6_ovr
	call	cpytlp
	mov	bx,offset title7_ovr
cpytlp:	norm_VIDEO FALSE,FALSE
	call	_MsgCntr
	call	_crlf
	ret
copywrite	endp


;================================================================
; Select new NEXT edit number
newednum_cmd	proc	near
	mov	bx,offset next_ovr
	call	_kbd_cln
	call	_msgread
	mov	bx,es:Next_Edit
	call	_default_val

	mov	al,4
	call	dec_cimsg
	jz	JL1545
	call	_convert2bin
	mov	es:Next_Edit,dx
JL1545:	call	_evnt_dispthis
	ret
newednum_cmd	endp


;================================================================
	if DEBUGGER
debug	proc	near
	call	_Debugger
	ret
debug	endp
	ENDIF


;================================================================
check_activator	proc	near
	mov	bp,sp
	xor	al,al			; Clear out test Flags
	mov	Flag1,al
	mov	Flag2,al
	mov	Flag3,al
	mov	Flag4,al
	mov	Flag5,al
	mov	bx,[bp]
	mov	Security_Return,bx
	inc	word ptr [bp]
	call	security_test
	ret
check_activator	endp

_TEXT	ends

_DATA	segment	byte public 'DATA'

Application_Types	db	'Off Line   ',0	; 0
			db	'Transport  ',0	; 1
			db	'Vid Swtchr ',0	; 2
			db	'Keyboard   ',0	; 3
			db	'Aud Swtchr ',0	; 4
			db	'GPI Relays ',0	; 5
			db	'Universal  ',0	; 6

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
