; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner

	title	'SES-PRO Edit Controller'

;VM.ASM
;
;	(C)1985, Norman H. Strassner, Strassner Video Enterprises
;--------------------------------------------------------------------------

; Tag/Clean/Sort/etc. Toggles data structure
TGDATA struc
	TGmsg	dw	?
	TGflags	dw	?
	TGbit	dw	?
	TGscr	dw	?
TGDATA ends

%nolist
	include	VM.EQU
%nolist
extrn Device_Enabled:byte,Device_Present:byte,EFX_Flag:byte,ERROR_ACTIVE:byte
extrn JoggerWheelMode:byte,MatchExtendFlag:byte,Active_Bin:byte
extrn AutoTrim_Flag:byte,Available_Bins:byte,Calc_Flag:byte
extrn Cimsg_Insert_Mode:byte,Cimsgadd_Flag:byte,Color_GRID:byte
extrn Constant_Flag:byte,Current_Machine:byte,Current_Source:byte
extrn Current_Workspace:byte,Cut_Type:byte,Device2set:byte
extrn Diagnostics_Flag:byte,Evnt_Insert_Flag:byte,Evnt_Replace_Flag:byte
extrn Find_Type:byte,Frame_Flag:byte,From_Flag:byte,From_Machine:byte
extrn Fullscreen_Flag:byte,Hardware_Delay:byte,In_Out_Flag:byte,in_rqst:byte
extrn Input_Flag:word,Key_Mode:byte,Keybkgnd_Src:byte,Keyfor_Src:byte
extrn Last_Trim_Flag:byte,Mode_Flag:byte,Preread_Immediate:byte
extrn Preread_State:byte,Preview_Mode:byte,Reference_Flag:byte,Rtcf:byte
extrn Sign_Flag:byte,Split_Mode:byte,Suspend_Flag:byte,Swap_Bin:byte
extrn Tag_Flag:byte,To_Machine:byte,Trans_Type:byte,Trim_Ci_Flag:byte
extrn Vtr_Mult_Type:byte,Color_ULINE:byte,Record_Flag:byte
extrn VlanVideoPort:byte,VlanAudioPort:byte,VlanVideoPort2:byte

extrn Ascii_Line:word,AUXVT_Cb:word,AVT_Cb:word,Ramp_Flags:word
extrn BLKVT_Cb:word,BVT_Cb:word,CVT_Cb:word,Current_VTRS:word,DOS_Flags:word
extrn DVT_Cb:word,Elaptm:word,Entime:word,ERROR_FLAGS:word,ERROR_MESSAGE:word
extrn EVT_Cb:word,FVT_Cb:word,Multr_Msg:word,MultRec_Flags:word
extrn RunningCMD_Buf:word,RunningCMD_Cnt:word,RunningCMD_Ptr:word,Sttime:word
extrn Areusure:word,Auenabl_Msg:word,Author:word,AutoTrim_Msg:word
extrn Avenabl_Msg:word,Badcrash_Msg:word,Bin_Table:word,Break_ovr:word
extrn Clean_Scr:word,Cln_Msg:word,Code_Msg:word,tlineroll_rqst:word
extrn const_rqst:word,Constants:word,Current_BKGbuf:word,Current_FORbuf:word
extrn Current_FRMbuf:word,Current_TObuf:word,Current_VT_Cb:word
extrn Current_Event:word,Current_Event_Adr:word,Current_Inbuf:word
extrn Current_Mach_Scr:word,Current_Reel_Adr:word,Current_Reel_Scr:word
extrn Cursor:word,Default_Command:word,demo_ovr:word
extrn Device_Stat_Tbl:word,Diskon_Msg:word,Diskon_Scr:word,Dissolve_Type:word
extrn dur_rqst:word,Edl_Seg:word,Edltrack_Msg:word
extrn Event_Renum_ovr:word,Event_Rple_Msg:word,Exchange_Regs:word
extrn Exchbuf1:word,Exchlen:word,Fcm_Header:word,Find_Buffer:word
extrn Find_Df:word,Find_Nd:word,findtc_ovr:word,findtext_ovr:word
extrn findwhat_ovr:word,Frame_Msg:word,frommsg_ovr:word
extrn Gpi_Flags:word,Gpi_Msg:word,Gpi_Scr:word,Hardware_Flags:word
extrn In_Msg:word,Inout_Adr:word,Int1c_Adr:word,Key_Trans:word,Key_Type:word
extrn Keybkgnd_Msg:word,Keyboard_Msg:word,Keyfor_Msg:word,Keyinout_Msg:word
extrn Keyover_Msg:word,Last_Command:word,Last_Duration:word
extrn Last_Mach_Scr:word,Last_Trim:word,Lastkey_Scr:word,Lastplace:word
extrn Link_Msg:word,Lockout_ovr:word,Lst_Msg:word,matched_ovr:word
extrn Matchframe_Diff:word,Matchframe_Fdur:word,Matchframe_From:word
extrn Msg_Seg:word,Mtbl_Length:word,Mtbl_Start:word,Multrecord_Table:word
extrn Multsync_Table:word,Network_Flags:word,Next_Avail_Num:word
extrn Next_Edit:word,nokey_ovr:word,Noref_Msg:word,Novlan_Msg:word,Nport:word
extrn Old_Inpoint:word,Operational_Flags:word,Otf_Adjust:word,Out_Msg:word
extrn out_rqst:word,Pmc_Flags:word,Pmc_Msg:word,Pmc_Scr:word,Port:word
extrn Postroll:word,Postroll_rqst:word,Preread_Msg:word,Preread_Scr:word
extrn Preroll:word,Preroll_rqst:word,Print_Scr:word,R_Tc:word
extrn Reel_Msg:word,Resetting_Msg:word,restbuf_ovr:word
extrn savebuf_ovr:word,Savemarks_Buf:word,Security_Return:word
extrn SeekFLE_Msg:word,Sfcm_Msg:word,Slave_Flags:word
extrn Slave_Table:word,Sounddisplay_Flags:word
extrn Spd_Flags:word,Spd_Msg:word,Spd_Scr:word,Split_Aud_Msg:word
extrn Split_Delay:word,Split_Dly_Msg:word,Split_Type:word,Split_Vid_Msg:word
extrn Split_What_Msg:word,Split_When_Msg:word,Srt_Msg:word,Srt_Scr:word
extrn Stacks:word,Swap_Table:word,Swapvtr_Msg:word,Swenabl_Msg:word
extrn Swenabl_Scr:word,Tag2_Msg:word,Tag_Msg:word,Tag_Scr:word,Tc_Format:word
extrn Temp_Event:word,Temp_Wrkspce:word,Timelineroll:word,tomsg_ovr:word
extrn Trans_Code:word,Trans_Length:word,Transtim_Scr:word,Transtof_Scr:word
extrn Transtyp_Scr:word,Trim_Msg:word,Trim_Store:word,Trim_Table:word
extrn tryagain_ovr:word,Undo_Buffer:word,Video_Seg:word,Videoram:word
extrn Vlan_Scr:word,Vtrcb:word,Wild1:word,Wild2:word,wildline_ovr:word
extrn Wipe_Msg:word,Ramp_Msg:word

extrn CheckForReference:near,EDL_Tracking:near,SetCurrentMachineActive:near
extrn KeyCommand_main:near,VLAN_init:near,all_update:near
extrn check_activator:near,cimsg_wrk:near,Color_clear:near,Color_init:near
extrn copywrite:near,cstat:near,dec_cimsg:near,get_vtr:near,get_Vtrcb:near
extrn get_Vtrcb_FCM:near,get_Vtrcb_pointer:near,jogger:near,joystick:near
extrn kbd_msgread:near,kbd_msgs:near,keythru:near,locations:near
extrn machine_init:near,motion:near,no_chos_msg:near,norm_kbd:near
extrn rdchar:near,read_VTR_time:near,relay_init:near,screen_init:near
extrn security_flag_test:near,switch:near,tc_cimsg:near,tc_disp:near
extrn tc_parenth:near,time_date:near,trim_init:near,vtr_STAT:near
extrn vtr_e2e:near,vtr_inst:near,vtr_mode:near,vtr_Postroll:near
extrn vtr_Preroll:near,SetActiveVtr_CH:near,Work_Event:near,yn_chos:near

extrn _A_DecOut:far,_CompleteCheck:far,_ConOut:FAR
extrn _Cursor_On:FAR,_DecOut:far,_DecOut_Pad:far,_E1_flgs:far
extrn _EDL_display:far,_ERRORS:far,_e_rel_l:far,_K_GetPort:far,_MsgCntr:FAR
extrn _PROGRAM_INIT:FAR,_ResetInterrupt_JOGGER:far,_RestoreWorkspace:far
extrn _SaveWorkspace:far,_Save_All_Marks:FAR,_Save_Marktable:FAR
extrn _Space_Out:far,__init_defaults:far,_active_machines:far,_adv2chr:FAR
extrn _all_machine_keys:far,_Break_check:FAR,_check4edl:far,_chimes:far
extrn _chrwait:FAR,_cknum:FAR,_clean_find:FAR,_clear_screen:FAR,_clear_tc:far
extrn _cmp24b:far,_cmp24b_DSES:far,_cnvt2nd:far,_compute:far,_computer:far
extrn _comsg:FAR,_const_upd:far,_constant_disp:far,_constant_index:far
extrn _constant_prompt:far,_convert2bin:far,_crlf:FAR,_Cursor_off:FAR
extrn _default_char:FAR,_dircur_infarea:FAR,_draw_machines:FAR
extrn _Elaptm_move:far,_Entime_move:far,_error_bell:FAR,_error_display:far
extrn _event_display:far,_evnt_dispthis:far,_find_edit_DX:far,_find_mode:far
extrn _get_dur:far,_get_in:far,_get_lpt_ports:far
extrn _get_out:far,_getlast_dur:far,_getlast_pin:far,_getlast_pout:far
extrn _getlast_rin:far,_getlast_rout:far,_help_pos:FAR,_index2bin:far
extrn _index2edspeed:FAR,_index_storage:FAR,_Inout_init:far,_instring:far
extrn _iodtc_rev:far,_kbd_cln:FAR,_kbd_clr:FAR,_kbd_message:far
extrn _Keyboard_on:far,_Keyboard_reset:FAR,_Keyboard_set:FAR
extrn _left_set_reel:far,_line_first:far,_line_next:far,_log2default:far
extrn _machine_disp:far,_machine_keys:far,_macone:FAR,_macsaver:FAR
extrn _make_ucase:far,_match_reels:far,_match_thisreel:far,_menu_find:far
extrn _mmv16:far,_mmv3_es2ds:far,_mmv3byt:far,_mmv:FAR,_mode_upd:far
extrn _mpbsub:far,_msg2screen:FAR,_msgread:FAR,_music:FAR,_no_critical:far
extrn _olm_find:far,_reel_rev:far,_stash_AUTOsubdir:FAR,_stash_EDLsubdir:FAR
extrn _stash_TCMsubdir:FAR,_stash_TMPsubdir:FAR,_stash_VMEsubdir:FAR
extrn _stash_homesubdir:FAR,_Sttime_move:far,_sttime_move_ES:far
extrn _tc_negate:far,_timadd:far,_timdif:far,_time_upd:far,_time_value:far
extrn _title_loop_ES:FAR,_trim_draw_machines:FAR,_up_in:far,_up_out:far
extrn _upd_getrel:far,_upd_getscr:far,_upd_gettcf:far,_yes_critical:far
extrn hackerishere:far, _NewDuration:far

;================================================================
_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg


Public Pgm_Start,Restart,Startit,Keyboard_Break,Keyboard,Play_Music,Wild_Key1
Public Wild_Key2,Lockout,UndoWorkspace,Break,Byebye,Exit,No_Security_Key
Public Goaway,Set_Preroll,Set_Postroll,set_Timelineroll,Ppostin,MarkIn
Public Mark_Inpoint,Mark_In,Markout,MarkOut_Onthefly,Mark_Outpoint,Markio
Public MarkCheckStat,In_Routine,Out_Routine,JL0125,I_Scrn,O_Scrn,D_Scrn
Public Multtrim_IN,Trim_In,Multtrim_OUT,Trim_Out,Trmio,MultTrim_Calc
Public MultTrimmer,MultRTrimmer,Trim_Multr,Trim_LINKS,Dur_Routine
Public Upd_Getscr_FarCall,Taggit,Tagthis_Vtr,Synctagext,Synctag,Synctg,Mtchvtr
Public Match_Vtr_Ext,AutoTrim,MultRec,LINKS,CheckVTR_Conflicts,Check_TrimLink
Public Swap_Vtrs,GetVtrTable,Machine_Take,Machine_Change,R_Machine
Public Aux_Machine,Aux_Mach,Blk_Machine,Blk_Mach
Public Machine_Select,Machine_Sel_Pr,Allreels,Reel_Change,Ask4FCM,Idxptcf
Public Idx2tcf_AL,Idx2tcf,Idxatcf,Set2timecode,Save_Marks,Last_Marks,Exchange
Public Constant_Menu,Clear_Constants,Frame_Toggle,Rp_Toggle,Tag_Toggle,Tag_Upd
Public Swenable,Auenable,Swenall,Swenset,Swenable_Upd,Diskon_Toggle
Public Sort_Toggle,Print_Toggle,Clean_Toggle,EDLtrak_Toggle,Diskon_Upd
Public Sort_Upd,Print_Upd,Clean_Upd,Gpi_Upd,Pmc_Upd,Spd_Upd,ramp_upd
Public EDLtrack_Upd,Vlan_Upd,Ref_UPD,Preread_UPD,Toggle_It,TG_Sort,TG_Print
Public TG_Clean,TG_Diskon,TG_Vlan,TG_EDLtrack,TG_Gpi,TG_Pmc,TG_Spd,TG_ramp
Public Make_Wipe,Make_Dissolve,Make_Efxs,Key_Cmd,Split_Cmd,Cut_Dlg,Wipe_Dlg
Public Disdlg,To_Prmt,Key_Upd,Split_Upd,Trans_Upd,Trans_Switch,Tog2dissolve
Public Tog2wipe,Tog2key,Tog2split,Efx_Disp,Cut_Disp,Length_Disp,Transup
Public Transition_Keys,Hardaud1,Hardaud2,Hardaud3,Hardaud4,Hardvid,Modes_Off
Public Audio1_Select,Audio2_Select,Audio3_Select,Audio4_Select,Video_Select
Public Vaas,Event_Change,Event_Renum,Renumber,seek_event,seek_first,seek_last
Public find,find_note,find_tc,seektc0,find_tcagn,SECURITY_TEST,realcheck
Public reset_leak,Badcrash_FAR,Mark_In_FAR,Tagthis_Vtr_FAR,Mtchvtr_FAR
Public Machine_Change_Far,Machine_Take_Far,Diskon_Upd_FAR,reset_leak
Public Data_Seg,new_leak

%list

;------------------------------------------------
;  P R O G R A M   I N I T I A L I Z A T I O N
;------------------------------------------------
; BX = dmseg
; CX = scrseg
; DX = eseg
; AX = _DATA

Pgm_Start	proc	near
	mov	cs:Data_Seg,ax
	mov	bp,cs
	call	_PROGRAM_INIT
	cmp	Available_Bins,MINIMUMBINS
	jnc	Pgmst1
	ERROR	NoBinMem_error, ERET_DOS

Pgmst1:
	call	_yes_critical
	call	Color_init
	call	__init_defaults
	mov	al,Mode_Flag
	mov	Preview_Mode,al
	mov	Current_Workspace,PRIMARYWORKSPACE	; Set to workspace #1
	call	Set2timecode		; Default control track table to TC
 	call	_Cursor_off
	norm_VIDEO FALSE,FALSE
	call	_menu_find
	call	_olm_find
	call	_clean_find

	if DEMO_RELEASE
	norm_VIDEO FALSE,FALSE
	mov	Fullscreen_Flag,0ffh	; Don't update the screen
	call	_clear_screen
	mov	bx,offset demo_ovr
	call	_msg2screen
	mov	ah,0
	int	16h
	endif

;; Set default Video and Audio switcher ports
	cmp	VlanVideoPort,0
	jnz	Pgmst2
	mov	VlanVideoPort,21
Pgmst2:	cmp	VlanAudioPort,0
	jnz	Pgmst3
	mov	VlanAudioPort,23
Pgmst3:
;	cmp	VlanVideoPort2,0
;	jnz	Pgmst4
;	mov	VlanVideoPort2,22
Pgmst4:	jmps	Startit

Pgm_Start	endp

;================================================================
;****************************************************************
;================================================================
Badcrash_FAR	proc	far
	mov	sp,offset Stacks
	mov	bx,offset Badcrash_Msg
	call	_comsg
	call	rdchar
	jmps	Restart
Badcrash_FAR	endp

Wearehere	db	0
Data_Seg	dw	0

;================================================================
;		      Restart SES EDITOR
;================================================================
Restart	proc	near
	call	_kbd_cln
	blinkrev_VIDEO FALSE,FALSE			; Dim please.
	mov	bx,offset Resetting_Msg
	call	_comsg
	norm_VIDEO FALSE,FALSE			; Dim please.
Restart	endp

Startit	proc	near
	mov	sp,offset Stacks
	mov	ds,cs:Data_Seg
	mov	es,Edl_Seg

	mov	RunningCMD_Ptr,offset RunningCMD_Buf + 2

	if COPY_PROTECT
	call	check_activator
	jmp	reset_leak
	ENDIF ;COPY_PROTECT

	push	es			;  fill
	push	cs			;  to BADCRASH with
	pop	es			;  NOPs
	mov	al,90h
	xor	di,di
	mov	cx,offset Badcrash_FAR
	rep stosb
	mov	si,offset Author	; Save Name to top
	xor	di,di
	mov	cx,7
	rep movsb
	pop	es

;----------------------------------------------------------------
Nobeta:
	call	VLAN_init		; See if VLAN present
	call	vtr_inst		; Initialize VTR communication Port
	call	relay_init		; Init relays only on entry

	mov	al,To_Machine		; Save current TO machine
	mov	ah,Current_Machine	; Save default machine

	mov	Fullscreen_Flag,0ffh	; Don't update the screen
	push	ax
	call	machine_init		; Init all devices
	call	vtr_mode
	pop	ax
	push	ax

	mov	To_Machine,al		; Initiate TO machine
	call	Machine_Change
	xor	al,al			; Center on REC machine
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
	call	switch
	call	vtr_e2e

	call	screen_init

	call	_Keyboard_reset		; Set up Keyboard
	call	_check4edl
	jnz	Ncpywrt
	call	copywrite
Ncpywrt:mov	bx,offset Exchbuf1	;Init the Exchange area
	mov	dx,offset Exchange_Regs
	mov	cx,offset Exchlen
	push	bx			; Save source buffer
	push	cx			; and Count
	push	bx
	push	cx
	call	_mmv16			; Move the buffer to Exchange regs
	pop	cx			; Restore Count and
	pop	bx			; source buffer address
	mov	dx,offset Savemarks_Buf	; And point to new destination
	call	_mmv16			; Move the buffer
	pop	cx
	pop	bx
	mov	dx,offset Undo_Buffer	; And point to new destination
	call	_mmv16			; Move the buffer

; Check for default macro
Iniex1:	cmp	cs:Wearehere,0ffh
	jz	Iniex2

	mov	bx,offset Default_Command
	mov	al,[bx]
	or	al,al
Iniex2:	jz	Iniex3
	call	_macsaver		; Or, fall through to Keyboard
Iniex3:	mov	cs:Wearehere,0ffh	; Flag program successfully initiated
	jmps	Keyboard
Startit	endp

Keyboard_Break	proc	near
	cli
	mov	ax,_STACK
	mov	ss,ax
	mov	sp,offset Stacks
	sti
	mov	ds,cs:Data_Seg
	mov	es,Edl_Seg
	mov	ax,Video_Seg
	mov	Videoram,ax

	call	_Cursor_off
	call	screen_init

	xor	ax,ax
	mov	RunningCMD_Buf,ax		; Zero chars left in command
	mov	RunningCMD_Cnt,ax		; # of characters in buffer
	and	Network_Flags,not EDLtrak_NTBIT
Keyboard_Break	endp

;------------------------------
; MAIN Keyboard ENTRY ROUTINE |
;------------------------------
;wait for entry on Keyboard
	even
Keyboard	proc	near
	mov	sp,offset Stacks	; Fix stack
	mov	ds,cs:Data_Seg
	mov	es,Edl_Seg

	xor	al,al
	mov	Vtr_Mult_Type,V_nul
	mov	Calc_Flag,al		; Cancel any prev calc for TC_CIMSG
	mov	Evnt_Replace_Flag,al
	mov	Evnt_Insert_Flag,al
	mov	Cimsg_Insert_Mode,al
	mov	Diagnostics_Flag,al
	mov	Cimsgadd_Flag,0		; Cancel recall w/any periods

	and	EFX_Flag,01111111b	; Clear EFX MENU ACTIVE bit

	cmp	Fullscreen_Flag,al	; Coming back from full screen mode?
	jz	Kbdnfs
	call	screen_init		; Init screen if YES

Kbdnfs:	mov	ax,Input_Flag		; Mmmm where were we...
	test	ax,INFL_menu
	jnz	Kbdevnt
	test	ax,INFL_gpi
	jnz	Kbdevnt
	test	ax,INFL_const
	jnz	Kbdevnt
	test	ax,INFL_speed
	jz	Kbdnoev
Kbdevnt:call	_evnt_dispthis

Kbdnoev:xor	al,al
	mov	Input_Flag,0		; Cancel any input flags
	cmp	Suspend_Flag,0ffh	; Macro Input suspended?
	mov	Suspend_Flag,al
	jz	Kbdprg
	cmp	RunningCMD_Cnt,0	; Count of characters in buffer
	jz	Kbdprg
	mov	ERROR_ACTIVE,0		; Clear error information
	jmp	Kbdnloc			; Yes, so skip this
Kbdprg:	call	cstat
	JMP_NZ	Kbddoch

	call	_Keyboard_reset
	dim_VIDEO FALSE,FALSE			; Dim please.

	CMP	ERROR_ACTIVE,0FFH	; Returning from an error?
	jnz	Kbdner
	mov	ERROR_ACTIVE,0		; Clear error information
	jmp	Kbd_Wait1

Kbdner:	call	_kbd_clr		; Clear Keyboard line
	mov	bx,offset Keyboard_Msg	; And display
	call	_comsg			; Kbd prompt
	norm_VIDEO FALSE,FALSE
	test	DOS_Flags,Cursor_DOSBIT
	jnz	Kbd_Wait0
	call	_Cursor_off
	mov	al,'_'
	call	_ConOut
	jmp	Kbd_Wait00

Kbd_Wait0:
	call	_Cursor_On

Kbd_Wait00:
	test	Network_Flags,Jogger_NTBIT
	jz	Kbd_Wait1

	mov	bx,offset KnobMode_msg

	mov	dx,offset JogMode_msg
	mov	Cursor,1845h

	cmp	JoggerWheelMode,0	; Shift active?
	jnz	Kbd_Wait000

	mov	dx,offset ShuttleMode_msg
	mov	Cursor,1841h

Kbd_Wait000: ;Shift mode
	call	_comsg
	mov	bx,dx
	call	_comsg

	even
Kbd_Wait1:
	call	time_date
	call	locations
	call	joystick
	call	jogger
	call	EDL_Tracking
	call	CheckForReference
	call	_Keyboard_on
	call	Keyboard_Errors
	cmp	RunningCMD_Cnt,0
	jnz	Kbdnloc

	mov	ah,11h
	int	16h
	jz	Kbd_Wait1

Kbdnloc:call	rdchar			; Get a character inputted

Kbddoch:call	KeyCommand_main		; Look for command
	JMP_NZ	Keyboard

	test	Sounddisplay_Flags,lastkey_SDBIT
	jz	Kbcolnp

	push	ax
	push	cx
	mov	Cursor,offset Lastkey_Scr
	mov	bx,Last_Command
	push	es
	mov	es,Msg_Seg
	mov	cx,16
	test	Sounddisplay_Flags,border_SDBIT
	jz	Kbnogrd
	Color_GRID_video
	even
Kbcolp:	mov	al,es:[bx]
	inc	bx
	call	_ConOut
	loop	Kbcolp
	jmps	Kbcolp1

Kbnogrd:
	uline_VIDEO FALSE,FALSE
Kbnogr1:mov	al,es:[bx]
	cmp	al,80h
	jc	Kbnogr2
	mov	al,' '
Kbnogr2:inc	bx
	call	_ConOut
	loop	Kbnogr1
Kbcolp1:dim_VIDEO FALSE,FALSE
	pop	es
	pop	cx
	pop	ax
Kbcolnp:call	_Cursor_off
	mov	bx,offset Keyboard	; Everything returns
	push	bx
	jmp	[si]

;================================================================
Keyboard_Errors:
	cmp	ERROR_FLAGS,0
	jz	Kbderr3
	mov	ah,2			; Get Keyboard flags
	int	16h
	and	al,00000011b
	cmp	al,00000011b
	jnz	Kbderr3
	mov	bx,ERROR_MESSAGE
	call	_error_display
Kbderr2:mov	ah,2			; Get Keyboard flags
	int	16h
	and	al,00000011b
	cmp	al,00000011b
	jz	Kbderr2
Kbderr3:ret
Keyboard	endp


;================================================================
Play_Music	proc	near
	call	_music
	ret
Play_Music	endp

;================================================================
;			WILD KEYS
;================================================================
Wild_Key1	proc	near
	mov	ax,Wild1
	cmp	ax,offset Insert_key
	jnz	Wildok
	ret
Wild_Key1	endp

Wild_Key2	proc	near
	mov	ax,Wild2
	cmp	ax,offset Delete_key
	jnz	Wildok
	call	_kbd_cln
	mov	bx,offset wildline_ovr
	call	_MsgCntr
	call	_chrwait
	ret

Wildok:	pop	bx			; Get rid of return
	jmp	Kbddoch

Wild_Key2	endp

;================================================================
Lockout	proc	near
	call	_kbd_cln
	mov	bx,offset Lockout_ovr
	call	_msgread
	call	_error_bell
	call	_chrwait
	ret
Lockout	endp


;================================================================
;			UNDO WORKSPACE
;================================================================
UndoWorkspace	proc	near
	push	Current_VTRS		; Save current machine assignments
	call	_RestoreWorkspace
	pop	ax			; Restore all current
	push	ax			;  machine assignments
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
	call	all_update
	ret
UndoWorkspace	endp

;================================================================
;		ABORTS, EXITS, BREAKS
;================================================================
Break	proc	near
	mov	bx,offset Break_ovr
	call	no_chos_msg
	jz	Byebye
	jmp	Keyboard
Break	endp

Byebye	proc	near
	mov	ch,1
	mov	si,offset Bin_Table
Byechk:	lodsw				; Get bin address
	mov	es,ax
	call	_check4edl		; See if empty
	jnz	Byebye0
	inc	ch
	cmp	ch,Swap_Bin
	jnz	Byechk
	jmp	Exit

Byebye0:mov	al,ch
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es
	call	_evnt_dispthis
	call	_kbd_cln
	mov	bx,offset Break_ovr
	call	_msgread
	mov	al,'.'
	call	_ConOut
	call	_Space_Out
	mov	bx,offset Areusure
	call	_comsg
	mov	cl,NDF_CHAR
	call	yn_chos
	jz	Exit
	jmp	Keyboard
Byebye	endp

Exit	proc	near
	call	Color_clear
	dim_VIDEO FALSE,FALSE
	call	_log2default
	call	_Keyboard_set
	call	_clear_screen
	call	_Cursor_On
	xor	al,al			; Normal error
	jmp	Goaway
Exit	endp

No_Security_Key	proc	near
	call	Color_clear
	dim_VIDEO FALSE,FALSE
	call	_Keyboard_set
	call	_clear_screen
	call	_crlf
	call	_crlf
	call	_error_bell
	mov	bx,offset nokey_ovr
	call	_msgread
	call	_Cursor_On
	mov	al,2			; Make it a device error
No_Security_Key	endp

Goaway	proc	near
	push	ax
	call	_no_critical

	in	al,61h			; Shut off speaker
	and	al,11111100b
	out	61h,al

;; Reset beeper interrupt
	push	ds
	mov	dx,Int1c_Adr
	mov	ds,Int1c_Adr + 2
	mov	ax,2500H + BEEPERINT		; function to change vector
	int	DOS
	pop	ds

	call	_ResetInterrupt_JOGGER

	pop	ax
Bailout:mov	ah,4Ch
	int	DOS
	jmps	Bailout
Goaway	endp

;================================================================
;		     SET Preroll/Postroll
;================================================================
Set_Preroll	proc	near
	mov	dx,offset Preroll
Spr1:	mov	bx,offset Preroll_rqst	; Display prompt
	call	Ppostin
	jmp	vtr_Preroll
Set_Preroll	endp

Set_Postroll	proc	near
	mov	dx,offset Postroll
	mov	bx,offset Postroll_rqst	; Display prompt
	call	Ppostin
	jmp	vtr_Postroll
Set_Postroll	endp

set_Timelineroll	proc	near
	mov	dx,offset Timelineroll
	mov	bx,offset tlineroll_rqst	; Display prompt
	call	Ppostin
	ret
set_Timelineroll	endp

Ppostin	proc	near
	push	dx			; Save holding buffer
	push	dx
	call	_Inout_init
	pop	bx
	xor	cl,cl			; No + or -
	mov	ch,DF_CHAR ;Rtcf			; Use record's FCM
	call	tc_parenth
	mov	bx,offset Sttime	; Get start time
	mov	al,DF_CHAR ;Rtcf
	call	tc_cimsg		; From user
	pop	dx			; Restore holding buffer
	jc	Ppostng
	call	_time_value
	jz	Ppostng
	call	_mmv3byt		; Move from Sttime to buffer
	ret
Ppostng:pop	bx			; Loose last return
Ppostx:	ret
Ppostin	endp

;**************************************************************
;	 G E T	 I N / O U T / D U R A T I O N	 T I M E
;**************************************************************
Mark_In_FAR	proc	far
	call	Mark_In
	ret
Mark_In_FAR	endp

MarkIn	proc	near
	call	Mark_In
	call	MarkCheckStat
	jc	Msiret
	jnz	MarkIns
	mov	dx,offset Otf_Adjust	; User defined ON-THE-FLY adjustment
	call	_mpbsub			; Add in offset and return
MarkIns:jmp	JL0126
MarkIn	endp

Mark_Inpoint	proc	near
	call	Mark_In
	jmp	JL0126
Mark_Inpoint	endp

Mark_In	proc	near
	test	Device_Present,vlan_IOTYP
	jz	Msiret
	mov	al,Current_Machine
	call	vtr_STAT
	jz	Msiret
	mov	ax,offset M_mark_in
	call	motion			; Mark VTR IN

	call	_SaveWorkspace		; Save workspace for possible W/UNDO

	call	_get_in			; Get address of IN POINT
	mov	dx,offset Old_Inpoint	; Save old IN POINT for LINKS
	call	_mmv3byt
	mov	ax,offset M_read_in		; Get new VTR IN
	mov	ch,0
	jmps	Markio
Msiret:	mov	bx,offset Tc_Format
	ret
Mark_In	endp

;================================================================
Markout	proc	near
	call	Mark_Outpoint
	call	MarkCheckStat
	jc	Msiret
	jz	Markotf
	jmp	JL0126
Markout	endp

MarkOut_Onthefly	proc	near
	call	Markfly
Markotf:mov	dx,offset Otf_Adjust	; User defined ON-THE-FLY adjustment
	call	_mpbsub			; Add in offset and return
	jmp	JL0126
MarkOut_Onthefly	endp

Mark_Outpoint	proc	near
	test	Device_Present,vlan_IOTYP
	jz	Msiret
	mov	al,Current_Machine
	call	vtr_STAT
	jz	Msiret
	mov	ax,offset M_mark_out
	call	motion

	call	_SaveWorkspace		; Save workspace for possible W/UNDO

	call	_get_out
Markfly:mov	ax,offset M_read_out
	mov	ch,0ffh
Mark_Outpoint	endp

; BX points to VTR IN or OUT point
; CH = 0FFH if OUT, 0 if IN
; AL has VLAN function number
Markio	proc	near
	mov	In_Out_Flag,ch		; Save IN/OUT flag
	mov	Inout_Adr,bx		; Save address of VTR IN/OUT
	jmp	read_VTR_time		; Get time to Sttime
Markio	endp

; Return with Z=1 if current machine is in PLAY
; C=1 of machine is off line
MarkCheckStat	proc	near
	mov	al,Current_Machine
	cmp	al,aux_dev
	jnc	MCS_Off

	cbw
	push	bx
	mov	bx,offset Device_Stat_Tbl
	add	bx,ax
	mov	al,[bx]
	pop	bx
	cmp	al,0ffh			; Off line?
	jz	MCS_Off
	or	al,al
	jz	MCS_Off
	cmp	al,86h			; Deck in play?
	clc
	ret
MCS_Off:stc
	ret
MarkCheckStat	endp

;===============================================================
;			SET IN POINT
;================================================================
;In_Out_Flag =	00h if In Point, 0FFh if Out Point
In_Routine	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	call	I_Scrn
	mov	bx,offset in_rqst	; Display prompt
	call	_Inout_init
	call	_get_in
	mov	dx,offset Old_Inpoint
	call	_mmv3byt
	xor	al,al
	jmps	Inout
In_Routine	endp

;================================================================
;			SET OUT POINT
;================================================================
Out_Routine	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	call	O_Scrn
	mov	bx,offset out_rqst
	call	_Inout_init
	call	_get_out			; Save address of out buffer
	mov	al,0ffh

Inout:	mov	In_Out_Flag,al
	mov	Inout_Adr,bx		; Save out buffer address

	mov	al,Current_Machine
	mov	Device2set,al		; Save device to set
	call	Idx2tcf			; Get FCM for device to AL
	mov	bx,offset Sttime	; Get end time
	call	tc_cimsg
	jnc	JL0125
	call	_get_in
	cmp	In_Out_Flag,0		; Check for In routine
	jz	JL0165
	call	_get_out
JL0165:	call	_clear_tc
	call	_get_dur
	call	_clear_tc
	call	_upd_getscr		; A good place to go when finished,
	ret
Out_Routine	endp

; Process for IN, OUT, DURATION
JL0125	proc	near
	call	_time_value
	jz	Inout_X
	mov	al,Device2set
	push	bx
	call	Machine_Change
	pop	bx
JL0126:	mov	dx,Inout_Adr		; Address proper In or Out buffer
	call	_mmv3byt
	call	_compute		; Compute for VTR

	test	MultRec_Flags,Enabled_MSBIT	; Is MULTIPLE RECORD on?
	jnz	JL0127

	test	Slave_Flags,Enabled_MSBIT	; Are slaves on?
	jz	Inout_R			;  Skip if NOT

; Find difference between old and new inpoints
JL0127:	mov	bx,Inout_Adr		; BX points to NEW INPOINT
	mov	dx,offset Old_Inpoint	; DX points to Old_Inpoint

	call	_cmp24b			; Is NEW < OLD?
	jz	Inout_R			; If equal, skip
	mov	cl,MINUS_ASCII
	jc	Lnkio1
	mov	cl,'+'

Lnkio1:	push	cx
	push	dx
	call	_Entime_move
	pop	bx
	call	_Sttime_move		; Else make it the Sttime
	call	_timdif			; Entime-Sttime = Elaptm
	pop	cx
	cmp	cl,MINUS_ASCII			; FIX 6-21-1990
	jnz	Lnkio2			;  for MARK/SET adjustment
	call	_tc_negate		;  for slave devices
Lnkio2:	push	cx
	push	bx
	call	Trim_LINKS
	pop	bx
	pop	cx
	call	Trim_Multr
	call	_upd_getscr

Inout_R:mov	bx,Inout_Adr
	ret

Inout_X:call	_upd_getscr
	ret
JL0125	endp

; In/out/dur reverse video
I_Scrn	proc	near
	mov	ch,in_offset
	call	_iodtc_rev
	ret
I_Scrn	endp
O_Scrn	proc	near
	mov	ch,out_offset
	call	_iodtc_rev
	ret
O_Scrn	endp
D_Scrn	proc	near
	mov	ch,dur_offset
	call	_iodtc_rev
	ret
D_Scrn	endp

;================================================================
;		     TRIM IN OR OUT POINT
;================================================================

Multtrim_IN	proc	near
	call	AutoTrim		; Set up auto trim devices
Multtrim_IN	endp
Trim_In	proc	near
	call	I_Scrn
	mov	al,0			; Signify IN
	mov	dx,offset In_Msg
	jmps	Trmio
Trim_In	endp

Multtrim_OUT	proc	near
	call	AutoTrim		; Set up auto trim devices
Multtrim_OUT	endp
Trim_Out	proc	near
	call	O_Scrn
	mov	al,0ffh			; Signify OUT
	mov	dx,offset Out_Msg
Trim_Out	endp

Trmio	proc	near
	mov	In_Out_Flag,al		; 0 = IN, 0FFH = OUT
	mov	Trim_Ci_Flag,0ffh	; Clear trim ci flag

	call	_SaveWorkspace		; Save workspace for possible W/UNDO

	mov	al,Current_Machine
	mov	Device2set,al		; Save device to set
	push	ax
	mov	bx,offset Trim_Msg	; "TRIM " message
	call	trim_init		; Initialize prompt line
	mov	bx,dx			; Get "IN" or "OUT" message
	call	_comsg			; display IN or OUT

	cmp	In_Out_Flag,0ffh	; If not "OUT" then
	jnz	Trmions			;  dont send a space
	call	_Space_Out
Trmions:pop	ax
	cmp	AutoTrim_Flag,0ffh	; Check for AutoTrim
	jnz	Trm1mch
	push	Cursor
	call	_trim_draw_machines
	pop	Cursor
	jmp	Trmmch

Trm1mch:call 	_machine_disp
	call	_Space_Out

Trmmch:	mov	cl,Last_Trim_Flag	; Get previous trim sign
	or	cl,cl			; Check for zero
	jnz	Trimio1			; Jump if non-zero
	mov	cl,'+'			; (Make sure we display something)
Trimio1:CALL	get_Vtrcb_FCM
	mov	ch,al
	mov	bx,offset Last_Trim	; Display
	call	tc_parenth		;  the last trim

	call	Idx2tcf			; Get FCM of current device
	mov	bx,offset Sttime	; Just a good starting buffer
	call	tc_cimsg		; Get a time code value
	jnc	Trmset1			; Carry set if clear request

	mov	bx,offset Tc_Format	; Tc_Format is always 000000
	mov	dx,offset Last_Trim
	mov	Last_Trim_Flag,'+'
	call	_mmv3byt		; Clear Last_Trim and return
	ret

; BX = 24BIT TIME CODE VALUE
Trmset1:call	_time_value		; Anthing there?
	mov	dx,bx			; Sttime = destination
	mov	bx,offset Last_Trim	;  for old value
	push	bx			; Save Last_Trim
	push	dx			; Save Sttime
	jnz	Trms1b
	cmp	From_Flag,0ffh		; If FROM A REGISTER,
	jnz	Trms1a			;  just move it
	pop	bx
	pop	dx
	jmps	Trmset2

Trms1a:	call	_mmv3byt			; Move Last_Trim to Sttime
Trms1b:	pop	bx			; Restore Sttime
	pop	dx			; Restore Last_Trim
	call	_mmv3byt
	mov	dx,offset Trim_Store	; Save to temporary buffer
	call	_mmv3byt

	mov	cl,Sign_Flag
	or	cl,cl			; Any change of sign?
	jnz	Trms1c
	mov	cl,Last_Trim_Flag
Trms1c:	mov	Last_Trim_Flag,cl	; Save new sign

;----------------------------------------------------------------
; BX points to trim value
; CL has flag
	cmp	AutoTrim_Flag,0ffh	; Auto trim on?
	jz	Trmset2

	mov	al,Device2set		; If AUTO TRIM is OFF
	mov	ah,0ffh			;  then trim only current
	mov	word ptr Trim_Table,ax	;  device.
	push	cx			; Save SIGN
	push	bx
	call	MultTrimmer		; Do a multiple trim (FOR 1 VTR ONY)
	pop	bx
	pop	cx			; Restore SIGN
	push	cx
	call	MultRTrimmer		; Do a multiple trim for MULT REC
	pop	cx
	mov	bx,offset Trim_Store	; Restore Trim_Store to
	mov	dx,offset Sttime	;  Sttime
	call	_mmv3byt
	jmp	TrmNAut

Trmset2:mov	bx,offset Trim_Store
	mov	dx,offset Sttime
	call	_mmv3byt
	mov	bx,dx

	push	cx			; Save SIGN
	push	bx
	call	MultTrimmer		; Do a multiple trim
	pop	bx
	pop	cx			; Restore SIGN
	call	MultRTrimmer		; Do a multiple trim for MULT REC

	mov	AutoTrim_Flag,0		; Turn off auto trim
	jmp	TrmAuto

TrmNAut:call	Trim_LINKS
TrmAuto:call	_compute
	ret
Trmio	endp


;----------------------------------------------------------------
; This routine saves the value pointed to by BX into the
; Trim_Store register, processes each successive byte at [SI]
; for a machine to update, and terminates when [SI] = 0ffh
;
; SI points to table of machines terminated by 0ffh byte
; BX points to trim value
; CL has sign
MultTrim_Calc	proc	near
	call	_Elaptm_move		; Elaptm = TRIM VALUE
	mov	dx,offset Trim_Store
	call	_mmv3byt

MltTrm1:mov	bx,offset Trim_Store	; Set up Sttime
	mov	dx,offset Sttime
	call	_mmv3byt

	lodsb				; Get slave link
	cmp	al,0ffh			; End of LINKS?
	jz	MltTrmx
	push	cx			; Save SIGN in CL
	call	Machine_Change		; Index to slave VTR

	cmp	Trim_Ci_Flag,0ffh	; 6-21-1990
	jz	MltTrm5			; Jump if TRIM operation
; Process for SLAVES
	call	_get_in
	jnz	MltTrm8
	pop	cx
	mov	dx,bx
	mov	bx,offset Sttime
	call	_mmv3byt
	push	cx
	call	_computer
	pop	cx
	jmp	MltTrm1

; Process for multiple TRIM
MltTrm5:call	_get_in
	cmp	In_Out_Flag,0		; Check for IN
	jz	MltTrm6			; Jump if for IN
	call	_get_out		; Else, get out
MltTrm6:call	_time_value
	jnz	MltTrm8			; Jump if IN or OUT is NOT NULL
	pop	cx
	mov	bx,offset Sttime

	push	si			; 6-15-1994 
	call	_NewDuration		; Else, use as duration
	pop	si			; 6-15-1994 
	jmp	MltTrm1

MltTrm8:pop	cx			; Restore SIGN in CL
	push	bx			; Save the buffer address
	call	_Elaptm_move		; Provide the start time
	mov	bx,offset Sttime	; Check for negated time code
	cmp	cl,MINUS_ASCII
	jnz	MltTrm9
	call	_tc_negate

MltTrm9:
	call	_timadd			; Sttime + Elaptm
	pop	dx			; Restore the buffer address
	call	_mmv3byt			; Move it there AND RETURN
	push	cx			; Must save FCM 9-17-1992 
	call	_computer		; Recompute the VTR. Added 3/90 nhs
	pop	cx			; Restore FCM  9-17-1992 
	jmp	MltTrm1

; CL has sign
MltTrmx:ret
MultTrim_Calc	endp

;===============================================================
; Using the Trim_Table trim all for value in BX, sign in CL
; ENTER: BX points to time code value
;	 CL has sign
MultTrimmer	proc	near
	push	Current_VTRS		; Save current machine assignments
	mov	si,offset Trim_Table
	jmp	Trim_MultLink
MultTrimmer	endp

MultRTrimmer	proc	near
	push	Current_VTRS		; Save current machine assignments
	mov	si,offset Multrecord_Table
	jmp	Trim_MultLink
MultRTrimmer	endp

; Check for MULTIPLE RECORD VTRS and
;  trim points accordingly with time code value in BX
; ENTER: BX points to time code value
;	 CL has sign
Trim_Multr	proc	near
	test	MultRec_Flags,Enabled_MSBIT	; Mult Record must be ON
	mov	si,offset Multrecord_Table
	mov	al,0				; Must be REC VTR
	jmp	Trim_Linkmult
Trim_Multr	endp

; Check for LINKS and trim points accordingly with time code value in BX
; ENTER: BX points to time code value
;	 CL has sign
Trim_LINKS	proc	near
	mov	si,offset Slave_Table
	lodsb				; Get Master, point to first slave
	test	Slave_Flags,Enabled_MSBIT	; Slaves must be ON
Trim_Linkmult:
	jz	Trmlnkr
	cmp	In_Out_Flag,0		; Trim type must be IN POINT
	jnz	Trmlnkr
	push	Current_VTRS		; Save current machine assignments

	cmp	al,0ffh			; End of table?
	jz	Trmlnkx
	cmp	al,Current_Machine	; Are we dealing with the MASTER?
	jnz	Trmlnkx			;  If not, then Exit

Trim_MultLink:
	call	MultTrim_Calc
Trmlnkx:pop	ax			; Restore all current
	push	ax			;  machine assignments
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
Trmlnkr:call	_draw_machines
	ret
Trim_LINKS	endp

;================================================================
;			SET DURATION
;================================================================
Dur_Routine	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	call	D_Scrn			; Hilight Current_Machine's duration
	mov	bx,offset dur_rqst	; Display prompt
	call	_Inout_init
	mov	al,Current_Machine
	mov	Device2set,al		; Save device to set

	mov	ch,DF_CHAR		; Default to real time durations
	mov	cl,0			; No + or -
	mov	bx,offset Last_Duration
	call	tc_parenth		; Display old trim
	mov	Trim_Ci_Flag,0

	mov	al,DF_CHAR
	mov	bx,offset Elaptm	; Get duration
	call	tc_cimsg		;  from user
	jnc	JL0150
	call	_get_dur
	call	_clear_tc
	call	_get_out
	mov	dx,bx
	call	_get_in
	call	_mmv3byt
	call	_upd_getscr
	ret

JL0150:	mov	dx,offset Upd_Getscr_FarCall; Set return address
	push	dx			; To screen update

	mov	al,Device2set		; Re-init for Current_Machine
	push	bx
	push	cx
	call	Machine_Change
	pop	cx
	pop	bx

	call	_time_value		; Check value of Elaptm
	jnz	Durr1			; Jump if zero
	mov	bx,offset Last_Duration	; Else, load up the
	call	_time_value		;  Last_Duration as the source
	jz	Durr2			; Jump of zero
Durr1:	call	_NewDuration		; If not zero, use it
Durr2:	ret				; Else, just update screen and return
Dur_Routine	endp

Upd_Getscr_FarCall	proc	near
	call	_upd_getscr
	ret
Upd_Getscr_FarCall	endp


;------------------------
; TAG REQUESTED MACHINE |
;------------------------
Taggit	proc	near
	call	Tagthis_Vtr
	call	_upd_getscr
	ret
Taggit	endp

Tagthis_Vtr_FAR	proc	far
	call	Tagthis_Vtr
	ret
Tagthis_Vtr_FAR	endp

;................................................................
; Tag edits from non-recorded, non-PMC, non-SPD event
Tagthis_Vtr	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	mov	ax,es:Current_Event	; Save current event
	call	_line_first
	push	ax

	mov	al,Current_Machine	; Get current machine
	or	al,al			; Is it the record?
	jnz	Ti_2			; Skip if not
	mov	ax,es:Current_Event	; Is this a double line event?
	call	_index_storage
	FLAGBITS dblline_Fmask
	jz	Ti_1
	inc	ax
	call	_index_storage
Ti_1:	jmp	Ti_6

Ti_2:	call	_match_thisreel		; Check to see if reel is here
	jz	Ti_5			; Jump if so

	mov	ax,es:Current_Event	; Is this a double line event?
	call	_index_storage
	FLAGBITS dblline_Fmask
	jz	Ti_3			; No reel match AND single line event
	inc	ax			; Go to next line
	call	_index_storage
	call	_match_thisreel
	jz	Ti_5

Ti_3:	pop	ax			; Restore original edit
	push	ax
	call	_line_first
	call	_match_reels		; Check to see if reel is here
	jz	Ti_5			; Jump if so

	mov	ax,es:Current_Event	; Is this a double line event?
	call	_index_storage
	FLAGBITS dblline_Fmask
	jz	Ti_3a			; No reel match AND single line event
	inc	ax			; Go to next line
Ti_3a:	call	_index_storage
	call	_match_reels
	jz	Ti_5

Ti_4:	pop	ax
	ERROR	canttag_error, ERET_Keyboard

Ti_5:	mov	al,cl
	call	Machine_Change

Ti_6:	mov	ax,es:Current_Event
	call	_index_storage
	cmp	Current_Machine,0	; Which machine?
	jnz	Ti_8
	call	_getlast_rout
Ti_8:	jz	Ti_9
	call	_getlast_pout
Ti_9:	mov	dx,offset R_Tc.tcIN
	jz	Ti_10
	mov	dx,Current_Inbuf
Ti_10:	call	_mmv3_es2ds
	call	_computer
	pop	ax
	call	_index_storage
	ret
Tagthis_Vtr	endp


;================================================================
;		CALCULATE SOURCE MATCHFRAME
;================================================================

; Extended matches
Synctagext	proc	near
	mov	MatchExtendFlag, TRUE
	jmp	Synctg
Synctagext	endp

;REAL TIME DIFFERENCE = CNRT REC IN - EVENT REC IN
;REAL PLAYBACK TIME   = CRNT PB  IN + REAL TIME DIFFERENCE
;1. get offset time of R_Tc.tcIN and EVENT R_Tc.tcOUT
;2. ADD offset time and return
Synctag	proc	near
	mov	MatchExtendFlag, FALSE
Synctag	endp

Synctg	proc	near
	call	_check4edl
	jz	Synctgx

	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	call	Match_Vtr_Ext	;Mtchvtr

	mov	MatchExtendFlag, FALSE	; Clear extend flag 9-28-1993 

	jnc	Synctg0
	ERROR	useextmatch_error, ERET_Keyboard
;;	ERROR	no_reel_match, ERET_Keyboard

Synctg0:mov	dx,Current_Inbuf	; Move matchframe value
	call	_mmv3byt		;  to current INbuffer
	call	_compute			; Compute the VTR
	call	_kbd_cln
	mov	bx,offset matched_ovr
	call	_MsgCntr
	call	_chrwait
Synctgx:ret
Synctg	endp

Mtchvtr_FAR	proc	far
	call	Mtchvtr
	ret
Mtchvtr_FAR	endp

;................................................................
; Get match frame for appropriate VTR in workspace
; Exit: BX points to 3 byte time code matchframe value
Mtchvtr	proc	near
	mov	MatchExtendFlag, FALSE
Mtchvtr	endp

Match_Vtr_Ext	proc	near
	mov	ax,es:Current_Event
	mov	Temp_Event,ax
	call	_line_first		; Get the first line of the edit
	cmp	es:byte ptr [bx].cmnt_lofst,0ffh
	JMP_C	Matchframe_Error	; Return if no edit

; Calculate the difference between R_VTR_IN and current event R_IN
; Move the answer to Matchframe_Diff buffer
	mov	bx,offset R_Tc.tcIN
	call	_Entime_move		; Z=1 if null time code
	call	_getlast_rin
	call	_sttime_move_ES
	call	_timdif			; Result to Elaptm
	mov	dx,offset Matchframe_Diff
	call	_mmv3byt

; Get the matchframe for the first half of the edit
; REGARDLESS of anything else
	mov	bx,offset Matchframe_From; Clear out buffer in case
	call	_clear_tc		 ;  of no reel match
	call	Mtchvt1
	jc	Mtchvt0			; Jump if no reel match
	mov	dx,offset Matchframe_From
	call	_mmv3byt

Mtchvt0:mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	Mtchvt1

; In case there is a DELAYED EFFECT, copy the duration of the FROM side
	call	_getlast_dur
	mov	dx,offset Matchframe_Fdur
	call	_mmv3_es2ds

	mov	ax,es:Current_Event	; Point to next event
	inc	ax
	call	_index_storage

; If second line of edit is a CUT OR KEY then this is a split edit requiring
;  no adjustment for delays
	cmp	es:byte ptr [bx].type_lofst,'K'	; Check for key
	jz	Mtchvt1

	cmp	es:byte ptr [bx].type_lofst,'C' ; (If second line of split)
	jnz	Mtchv1

	mov	bx,offset Matchframe_From
	jmp	Mtchvtx

; Not a split, add in any possible FROM DURATION to the calculated difference
Mtchv1:	mov	bx,offset Matchframe_Diff
	mov	dx,offset Matchframe_Fdur
	call	_mpbsub

Mtchvt1:
;... 9-28-1993 For extended matches
	cmp	MatchExtendFlag, TRUE
	jnz	Mtchvt2
	mov	cl,Current_Source
	jmp	Mtchvt3
Mtchvt2:
;...
	call	_match_reels		; CL = VTR if found
	jnz	Matchframe_Error

Mtchvt3:mov	al,cl
	call	Machine_Change
	cmp	Record_Flag,0
	jnz	Mtchvt4
	call	switch
	call	vtr_e2e
Mtchvt4:mov	al,cl
	mov	bx,offset Matchframe_Diff
	call	_Elaptm_move
	call	_getlast_pin		; Get old P_TC_IN
	call	_sttime_move_ES
	call	_timadd
Mtchvtx:push	bx
	call	Matchframe_Error
	pop	bx
	clc
	ret

Matchframe_Error:
	mov	ax,Temp_Event
	call	_index_storage
	stc
	ret
Match_Vtr_Ext	endp


;================================================================
AutoTrim	proc	near
	xor	cl,cl				; Clear counter
	mov	AutoTrim_Flag,0			; Turn off auto trim initially
	call	AutTrm_Msgs
	mov	si,offset Trim_Table		; SI points to table
	mov	di,si				; Save table pointer to DI
	mov	al,0ffh
	cmp	[si],al				; Empty table?
	jz	AutTrm1
	cmp	1[si],al			; Only one?
	jnz	AutTrmD				; Jump if more that one
	mov	[si],al

AutTrmD:mov	al,[si]
	cmp	al,0ffh				; End of buffer?
	jz	AutTrm1
	call	_machine_disp
	call	_Space_Out
	inc	si
	inc	cl
	jmp	AutTrmD

AutTrm1:call	rdchar				; Get a keypress
	call	_Break_check			; Exit if Break
	jz	AutTrmx
	cmp	ax,offset MulttrimIN_xcmd
	jz	AutTrmx
	cmp	ax,offset MulttrimOUT_xcmd
	jz	AutTrmx

	cmp	ax,offset Trimin_xcmd		; Toggle AutTrm enable?
	jz	Tgl_AutrmI
	cmp	ax,offset Trimout_xcmd		; Toggle AutTrm enable?
	jz	Tgl_AutrmO

	cmp	ax,offset Enter_xcmd		; All done?
	jz	AutTrmxit
	cmp	ax,offset Backspace_xcmd	; Backup one?
	jz	AutTrmBkp

	cmp	ax,offset Clrrd_xcmd		; Clear it and start again?
	jz	AutClr
	call	_all_machine_keys		; Try for machine match
	jnz	AutTrm1
	call	Check_TrimLink			; Check for already AutTrmed
	jc	AutTrm1

AutIni:	mov	ah,0ffh				; For pre-termination
	mov	[si],ax				; Save byte and termination
	inc	si
	call	_machine_disp
	inc	cl
	call	_Space_Out
	jmp	AutTrm1

AutTrmxit:
	mov	ax,0ffffh
	cmp	ds:[di],al			; Emtpy table?
	jnz	AutTrmxit1
	mov	si,di
	mov	al,Current_Machine		; Get device to trim
AutTrmxit1:
	mov	[si],ax				; Terminate line
	mov	AutoTrim_Flag,ah		; Turn AutoTrim ON
	clc
	ret

AutTrmx:mov	byte ptr Trim_Table,0ffh
	mov	AutoTrim_Flag,0
	clc
AutTrmr:ret

; Backspace
AutTrmBkp:
	or	cl,cl				; Already at top of table?
	jz	AutTrm1				;  then return
	dec	si
	mov	byte ptr [si],0ffh		; Re-terminate line
	call	AutTrm_Msgs
	mov	si,offset Trim_Table
	xor	cl,cl
	jmp	AutTrmD

; Exit with In_Out_Flag set to IN or OUT
Tgl_AutrmI:
	mov	al,0
	jmp	TglAut
Tgl_AutrmO:
	mov	al,0ffh
TglAut:	mov	In_Out_Flag,al
	call	AutTrmx				; Clear auto trim
	stc
	ret

; KEY CLEAR pressed, reset to start of Trim_Table
AutClr:	mov	si,offset Trim_Table		; SI points to table
	mov	byte ptr [si],0ffh		; Terminate it
	xor	cl,cl				; Clear counter
	call	AutTrm_Msgs
	jmp	AutTrm1

AutTrm_Msgs:
	mov	bx,offset AutoTrim_Msg		; Prompt for AutTrms
	call	_kbd_message
	ret

AutoTrim	endp


;================================================================
;		     SETUP MULTIPLE RECORD
;================================================================
MultRec	proc	near
	mov	VtrTableMessage,	offset Multr_Msg
	mov	VtrTablePointer,	offset Multrecord_Table
	mov	VtrAltTablePointer,	offset Slave_Table
	mov	VtrTableMaxCount,	ALLOWED_VTRS
	mov	VtrTableStart,		a_dev
	mov	VtrTableEnd,		f_dev
	mov	VtrTableKey,		offset MultRecord_xcmd
	mov	VtrTableFlagPointer, 	offset MultRec_Flags
	mov	VtrTableFlagBit,	Enabled_MSBIT
	mov	VtrTableError,		alreadylinked_error
	call	GetVtrTable
	ret
MultRec	endp

;================================================================
;		     SETUP MASTER / SLAVES
;================================================================
LINKS	proc	near
	mov	VtrTableMessage,	offset Link_Msg
	mov	VtrTablePointer,	offset Slave_Table
	mov	VtrAltTablePointer,	offset Multrecord_Table
	mov	VtrTableMaxCount,	ALLOWED_VTRS
	mov	VtrTableStart,		r_dev
	mov	VtrTableEnd,		f_dev
	mov	VtrTableKey,		offset Links_xcmd
	mov	VtrTableFlagPointer, 	offset Slave_Flags
	mov	VtrTableFlagBit,	Enabled_MSBIT
	mov	VtrTableError,		alreadymultr_error
	call	GetVtrTable
	ret
LINKS	endp

;================================================================
CheckVTR_Conflicts	proc	near
	test	MultRec_Flags,Enabled_MSBIT
	jz	Cconx
	mov	si,offset Multsync_Table	; Point to multsync table
Cconlp:	lodsb					; Get a mult REC vtr
	cmp	al,0				; End of table?
	jz	Cconx
	call	get_vtr
	mov	di,offset Multrecord_Table
	call	Check_TrimLink			; Check for already MultRed
	jnc	Cconlp
	ERROR	vtr_conflict_error,ERET_Keyboard
Cconx:	ret

CheckVTR_Conflicts	endp


;================================================================
; Check for an existing link or AutoTrim.
; Return with carry set if it already exists in the table
; ENTER: AL = DEVICE
;	 DI point to beginning of table

Check_TrimLink	proc	near
	push	di
Ctllp:	cmp	al,ds:[di]
	jz	Ctlfnd
	cmp	byte ptr ds:[di],0ffh
	jz	Ctlnfnd
	inc	di
	jmp	Ctllp
Ctlfnd:	stc
Ctlnfnd:pop	di
	ret
Check_TrimLink	endp


;; Swap VTRs
Swap_Vtrs	proc	near
	mov	VtrTableMessage,	offset Swapvtr_Msg
	mov	VtrTablePointer,	offset Swap_Table
	mov	VtrAltTablePointer,	0
	mov	VtrTableMaxCount,	2
	mov	VtrTableStart,		r_dev
	mov	VtrTableEnd,		aux_dev
	mov	VtrTableKey,		offset VtrSwap_xcmd
	mov	VtrTableFlagPointer, 	0	;offset GVTec_flags
	mov	VtrTableFlagBit,	0	;Enabled_MSBIT
	mov	VtrTableError,		cantswaptosame_error
	call	GetVtrTable
	jc	Swpvtrx

; Swap In Out Dur

; 1. Move VTR 1 in/out/dur to Temp_Wrkspce
	mov	al, byte ptr Swap_Table
	call	Machine_Change
	call	_get_in
	push	bx			; VTR 1 swap

	mov	dx, offset Temp_Wrkspce
	mov	ch, 9
	call	_mmv

; 2. Move VTR 1 Vtrcb to Work_Event
	call	get_Vtrcb_pointer
	push	bx

	mov	dx, offset Work_Event
	mov	ch, SIZE VTRCB_RECORD
	call	_mmv


; 2. Move VTR 2 Vtrcb to VTR 1 Vtrcb
	mov	al, byte ptr Swap_Table + 1
	call	Machine_Change

	call	get_Vtrcb_pointer
	pop	dx
	mov	ch, SIZE VTRCB_RECORD
	call	_mmv

; 2. Move VTR 2 in/out/dur to VTR 1 in/out/dur
	call	_get_in
	pop	dx			; pointer to VTR 1's in/out/dur
	mov	ch,9
	call	_mmv


; 4. Move workspace back to VTR 2
	mov	al, byte ptr Swap_Table + 1
	call	Machine_Change
	call	_get_in
	mov	dx,bx
	mov	bx,offset Temp_Wrkspce
	mov	ch,9
	call	_mmv

	call	get_Vtrcb_pointer
	mov	dx,bx
	mov	bx,offset Work_Event
	mov	ch, SIZE VTRCB_RECORD
	call	_mmv
	call	Restart
Swpvtrx:ret
Swap_Vtrs	endp


;================================================================
;		     SETUP MULTIPLE RECORD
;================================================================
GetVtrTable	proc	near
	mov	ERROR_ACTIVE,0		; Clear error information
	xor	cl,cl				; Clear counter
	call	GVT_Ttl
	mov	si,VtrTablePointer	; SI points to table
	mov	al,0ffh
	cmp	[si],al				; Empty table?
	jz	GVT_2

GVTD_1:	mov	al,[si]
	cmp	al,0ffh				; End of buffer?
	jz	GVT_2
	call	_machine_disp
	call	_Space_Out
	inc	si
	inc	cl
	cmp	cl, VtrTableMaxCount
	jb	GVTD_1

GVT_2:	call	rdchar				; Get a keypress
	call	_Break_check			; Exit if Break
	JMP_Z	GVT_Sx

	cmp	ax,word ptr VtrTableKey		; Toggle enable?
	JMP_Z	GVT_Tgl

	cmp	ax,offset Enter_xcmd		; All done?
	JMP_Z	GVT_Sxit

	cmp	ax,offset Backspace_xcmd	; Backup one?
	JMP_Z	GVTBkp

	cmp	ax,offset Clrrd_xcmd		; Clear it and start again?
	JMP_Z	GVT_Clr
	call	_all_machine_keys		; Try for machine match
	jz	GVT_3
	call	_chimes
	jmp	GVT_2

GVT_3:	cmp	al,VtrTableStart		; Legal machine?
	jb	GVT_2
	cmp	al,VtrTableEnd
	ja	GVT_2

	inc	cl
	cmp	cl, VtrTableMaxCount
	jbe	GVT_5
	dec	cl
	call	_error_bell
	jmp	GVT_2

GVT_5:	push	di
	mov	di, VtrAltTablePointer
	or	di,di
	jz	GVT_5a
	call	Check_TrimLink			; Check for already Linked
	pop	di
	jc	GVT_Err
	push	di
GVT_5a:	pop	di
	push	di
	mov	di,VtrTablePointer
	call	Check_TrimLink			; Check for already Linked
	pop	di
	jnc	GVT_4

GVT_Err:mov	ax, VtrTableError
	or	ax, ERET_Return
	mov	ERROR_OFFSET, offset GetVtrTable
	mov	ERROR_SEG, cs
	mov	ERROR_FLAGS, ax
	jmp	FAR PTR _ERRORS

GVT_4:	mov	ah,0ffh				; For pre-termination
	mov	[si],ax				; Save byte and termination
	inc	si
	call	_machine_disp
	call	_Space_Out
	jmp	GVT_2

GVT_Sxit:
	mov	si, VtrTableFlagPointer
	or	si,si
	jz	GVT_Sr

	mov	al, VtrTableFlagBit
	or	byte ptr [si],al

;8-03-1994 next line screwed up the flag bits!!!
;;;;;	mov	byte ptr [si],0ffh		; Terminate line
	jmp	GVT_Sr

; Exit with In_Out_Flag set to IN or OUT
GVT_Tgl:cmp	VtrTableFlagPointer,0		; Skip if no flags to set
	jz	GVT_Sx

	mov	si, VtrTableFlagPointer
	mov	al, VtrTableFlagBit

	test	byte ptr [si], al
	jz	GVT_Set
	not	al
	and	byte ptr [si],al
	jmp	GVT_Sr
GVT_Set:or	byte ptr [si],al
	jmp	GVT_Sr

GVT_Sx:	mov	si, VtrTableFlagPointer
	not	al
	and	byte ptr [si],al
	call	GVT_Sr
	stc
	ret

GVT_Sr:	call	_draw_machines
	clc
	ret

; Backspace
GVTBkp:	or	cl,cl				; Already at top of table?
	JMP_Z	GVT_2				;  then return
	dec	si
	mov	byte ptr [si],0ffh		; Re-terminate line
	call	GVT_Ttl
	mov	si,VtrTablePointer
	xor	cl,cl
	jmp	GVTD_1

; KEY CLEAR pressed, reset to start of GVTecord_table
GVT_Clr:mov	si,VtrTablePointer		; SI points to table
	mov	byte ptr [si],0ffh		; Terminate it
	xor	cl,cl				; Clear counter
	call	GVT_Ttl
	jmp	GVT_2

GVT_Ttl:mov	bx, VtrTableMessage		; Prompt
	call	_kbd_message
	ret

GetVtrTable	endp


;================================================================
;		    CHANGE ACTIVE VTR/DEVICE
;================================================================
Machine_Change_Far	proc	far
	call	Machine_Change
	ret
Machine_Change_Far	endp

Machine_Take_Far	proc	far
	call	Machine_Take
	ret
Machine_Take_Far	endp

		even
Machine_Take	proc	near
		mov	ah,0ffh		; Use E2E routine
		dec	al
		jz	A_Machine
 	
	if  ALLOWED_VTRS GT 2
		dec	al
		jz	b_machine
	endif
	if  ALLOWED_VTRS GT 3
		dec	al
		jz	c_machine
	endif
	if  ALLOWED_VTRS GT 4
		dec	al
		jz	d_machine
	endif
	if  ALLOWED_VTRS GT 5
		dec	al
		jz	e_machine
	endif
	if  ALLOWED_VTRS GT 6
		dec	al
		JMP_Z	f_machine
	endif
		dec	al
		JMP_Z	Aux_Machine
		dec	al
		JMP_Z	Blk_Machine
		xor	al,al
		jmp	Machine_Select0
Machine_Take	endp

		even
Machine_Change	proc	near
		xor	ah,ah		; Don't use E2E routine
		dec	al
		jz	A_Mach

	if  ALLOWED_VTRS GT 2
		dec	al
		jz	b_mach
	endif
	if  ALLOWED_VTRS GT 3
		dec	al
		jz	c_mach
	endif
	if  ALLOWED_VTRS GT 4
		dec	al
		jz	d_mach
	endif
	if  ALLOWED_VTRS GT 5
		dec	al
		jz	e_mach
	endif
	if  ALLOWED_VTRS GT 6
		dec	al
		jz	f_mach
	endif
		dec	al
		jz	Aux_Mach
		dec	al
		jz	Blk_Mach
		xor	al,al
		jmp	Machine_Select0
Machine_Change	endp

;; Macro to return the machine selection through a switch and
;; a transition update
ReturnThrough_Machine_Sel_Pr macro
	mov	bx,offset Machine_Sel_Pr
	push	bx			; Update screen, switch XPTS
	mov	ah,0ffh
endm

R_Machine	proc	near
		mov	ax,0ff00h
		call	switch
		jmp	Machine_Select0
R_Machine	endp

A_Machine	proc	near
Public  A_Machine,A_Mach
		ReturnThrough_Machine_Sel_Pr
A_Machine	endp
A_Mach	proc	near
		mov	bx,offset AVT_Cb	; Change machine only
		jmp	Machine_Select
A_Mach	endp

	if  ALLOWED_VTRS GT 2
Public  b_machine,b_mach
b_machine	proc	near
		ReturnThrough_Machine_Sel_Pr
b_machine	endp
b_mach	proc	near
		mov	bx,offset BVT_Cb
		jmp	Machine_Select
b_mach	endp
	endif
	if  ALLOWED_VTRS GT 3
Public  c_machine,c_mach
c_machine	proc	near
		ReturnThrough_Machine_Sel_Pr
c_machine	endp
c_mach	proc	near
		mov	bx,offset CVT_Cb
		jmp	Machine_Select
c_mach	endp
	endif

	if  ALLOWED_VTRS GT 4
Public  d_machine,d_mach
d_machine	proc	near
		ReturnThrough_Machine_Sel_Pr
d_machine	endp
d_mach	proc	near
		mov	bx,offset DVT_Cb
		jmp	Machine_Select
d_mach	endp
	endif

	if  ALLOWED_VTRS GT 5
Public  e_machine,e_mach
e_machine	proc	near
		ReturnThrough_Machine_Sel_Pr
e_machine	endp
e_mach	proc	near
		mov	bx,offset EVT_Cb
		jmp	Machine_Select
e_mach	endp
	endif

	if  ALLOWED_VTRS GT 6
Public  f_machine,f_mach
f_machine	proc	near
		ReturnThrough_Machine_Sel_Pr
f_machine	endp
f_mach	proc	near
		mov	bx,offset FVT_Cb
		jmp	Machine_Select
f_mach	endp
	endif

Aux_Machine	proc	near
		ReturnThrough_Machine_Sel_Pr
Aux_Machine	endp
Aux_Mach	proc	near
		mov	bx,offset AUXVT_Cb
		jmp	Machine_Select
Aux_Mach	endp

Blk_Machine	proc	near
		ReturnThrough_Machine_Sel_Pr
Blk_Machine	endp
Blk_Mach	proc	near
		mov	bx,offset BLKVT_Cb
Blk_Mach	endp

; ENTER: DS:BX points to a vtr control block
; Exit: All pointers for selected machine initiated,
;	 screen updated if necessary.
Machine_Select	proc	near
	mov	al,[bx]			; Get machine number

Machine_Select0:
	push	si
	mov	si,offset Current_VT_Cb
	mov	cx,[si + 4]		; Get previous reel
	mov	Last_Mach_Scr,cx
	or	al,al
	jnz	Mst0a
	mov	Current_Mach_Scr,(r_line * 256) + mach_offset
	pop	si
	jmp	Mst5

Mst0a:	mov	cx,[bx + 2]		; reel
	mov	[si + 0],cx
	mov	cx,[bx + 4]		; reel screen position
	mov	[si + 2],cx
	mov	cx,[bx + 6]		; mach screen position
	mov	[si + 4],cx
	mov	cx,[bx + 8]		; in
	mov	[si + 6],cx
	mov	cx,[bx + 10]		; out
	mov	[si + 8],cx
	mov	cx,[bx + 12]		; duration
	mov	[si + 10],cx
	mov	cx,[si + 6]		; Get In point address
	pop	si

	cmp	al,To_Machine		; Also save the SOURCE INPUT
	jnz	Mst1			;  BUFFER address to the
	mov	Current_TObuf,cx	;  appropriate pointer buffer
	jmp	Mst2

Mst1:	cmp	al,From_Machine
	jnz	Mst2
	mov	Current_FRMbuf,cx

Mst2:	cmp	al,Keybkgnd_Src
	jnz	Mst3
	mov	Current_BKGbuf,cx
	jmp	Mst4

Mst3:	cmp	al,Keyfor_Src
	jnz	Mst4
	mov	Current_FORbuf,cx

Mst4:	mov	Current_Source,al

;.................
Mst5:	push	Cursor
	push	ax		; Save machine # and e2e flag

	cmp	Fullscreen_Flag,0ffh	; Check for full screen operation
	jz	Ms0x

	mov	bx,Last_Mach_Scr
	cmp	Diagnostics_Flag,0ffh
	jnz	Ms0d
	add	bh,diagline_offset
	mov	bl,1

Ms0d:	dec	bl			; Move Cursor back one
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	al,' '
	call	_ConOut
	mov	cx,Current_Mach_Scr

	cmp	Diagnostics_Flag,0ffh
	jnz	Ms0e
	add	ch,diagline_offset
	mov	cl,1

Ms0e:	dec	cl
	mov	Cursor,cx		; Set Cursor
	mov	al,'>'
	call	_ConOut
Ms0x:	pop	ax
	mov	Current_Machine,al	; Set current machine

	; Set VLAN nodes and set for E to E if necessary
	mov	ch,al
	cmp	ah,0ffh
	jnz	Ms0a
	call	vtr_e2e
Ms0a:	call	SetCurrentMachineActive
	pop	Cursor
	ret
Machine_Select	endp

; Switch and udate screen
Machine_Sel_Pr	proc	near
	cmp	Diagnostics_Flag,0ffh
	jz	Mspx
	call	switch
	call	Trans_Upd
	mov	al,Current_Machine	; Get old current machine
Mspx:	ret
Machine_Sel_Pr	endp

;================================================================
;		    ASSIGN NEW PLAYBACK REELS
;================================================================
Allreels	proc	near
	mov	al,Current_Machine
	push	ax
	mov	cl,1			; Start with VTR-1
Alrl1:	mov	al,cl
	push	cx
	call	Machine_Change
	call	Reel_Change
	pop	cx
	jc	Allrx
	inc	cl
	cmp	cl,MAX_DEVICES
	jbe	Alrl1
Allrx:	pop	ax
	jmp	Machine_Change
Allreels	endp

;================================================================
;	ALTER REEL ASSIGNMENTS FOR A SOURCE VTR
;================================================================
Reel_Change	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	mov	al,Current_Source
	call	Machine_Change
	push	ax
	mov	cl,al
	cmp	cl,aux_dev
	jc	Rch1
	mov	ch,mach_offset
	jmps	Rch2
Rch1:	mov	ch,reel_offset
Rch2:	call	_reel_rev

	call	_kbd_cln
	pop	ax
	call	_machine_disp
	call	_Space_Out
	mov	bx,offset Reel_Msg
	call	_comsg

	call	_e_rel_l		; Get current reel length
	call	cimsg_wrk		; Get new reel
	jnc	Rch3
	call	_upd_getrel
	call	_upd_gettcf		; Tc format info
	stc
	ret

Rch3:	mov	al,Current_Source
	mov	cl,ch			; Save the character Count

	cmp	al,aux_dev
	jc	Rch3a
	mov	dx,bx
	call	Idxatcf			; Index to 
	mov	al,Rtcf
	jmp	Rch7

Rch3a:

; PAL -- SKIP ASKING FOR REEL'S FCM ALTOGETHER
	if NTSC
	test	Device_Present,vlan_IOTYP;  Do we have to ask the operator
	jz	rch4			;  for the FCM type?

	push	cx
	call	vtr_STAT
	pop	cx
	jnz	Rtcfok

rch4:	call	Idxatcf			; Get FCM pointer to BX, FCM to AL
	mov	dx,bx			; Save address to FCM
	call	_Space_Out
	norm_VIDEO FALSE,TRUE
	mov	bx,offset Fcm_Header
	call	_comsg

	call	Ask4FCM			; Get "D"rop or "N"on drop
	jnc	rch5
	call	_upd_getrel
	ret

rch5:	mov	bx,dx
	ENDIF

Rch7:
	if NTSC
	mov	[bx],al			; Save new fcm
	endif
	push	cx			; Save line length 4/90
	call	_upd_gettcf
	call	_upd_getscr
	pop	cx			; Restore line length 4/90

Rtcfok:	or	cl,cl			; Any one home?
	jz	Rtcfok1
	mov	bx,offset Temp_Wrkspce	; Buffer for inputted reel
	mov	dx,Current_Reel_Adr	; Get current reel
	call	_left_set_reel

; Display reel information to screen
	mov	bx,Current_Reel_Scr
	mov	Cursor,bx
	push	Cursor
	mov	bx,SpacePointer(6)
	call	_comsg
	pop	Cursor

	norm_VIDEO FALSE,FALSE
	mov	bx,Current_Reel_Adr
	call	_adv2chr
	call	_comsg
	call	_upd_getrel
	call	_upd_gettcf		; Tc format info
	call	Trans_Upd
	clc
	ret

Rtcfok1:mov	bx,Current_Reel_Scr
	mov	Cursor,bx
	norm_VIDEO FALSE,FALSE
	mov	bx,Current_Reel_Adr
	call	_adv2chr
	call	_comsg
	call	_upd_getrel
	call	_upd_gettcf		; Tc format info
	clc
	ret
Reel_Change	endp

;================================================================
; DX points to the buffer address, AL has default FCM type
; Return C=1 if Break
Ask4FCM	proc	near
	mov	bx,offset Sfcm_Msg
	call	_comsg
	mov	ch,al			; Save old fcm in CH
	cmp	al,' '
	jnz	A4fcm4
	mov	al,NDF_CHAR
	mov	ch,al
A4fcm4:	call	_default_char
A4fcm5:	call	rdchar
	call	_Break_check
	jnz	A4fcm6
	stc
	ret

A4fcm6:	cmp	ax,offset Enter_xcmd	; Accept ENTER
	jz	A4fcm8

	cmp	ax,offset Clrrd_xcmd
	jnz	A4fcm7
	mov	al,' '
	jmp	A4fcm9

A4fcm7:	call	_make_ucase
	cmp	al,DF_CHAR		; Drop frame?
	jz	A4fcm9
	cmp	al,NDF_CHAR		; Non drop frame?
	jz	A4fcm9
	call	_error_bell
	jmps	A4fcm5

A4fcm8:	mov	al,ch
A4fcm9:	clc
	ret
Ask4FCM	endp


;----------------------------------------------------------------
; Index to the current FCM for the CURRENT SOURCE
	even
Idxptcf	proc	near
	push	bx
	mov	al,Current_Source
	call	Idxatcf
	pop	bx
	ret

Idxptcf	endp

;Index to the current FCM for current machine
; ENTER: Nothing
; Exit:  AL = FCM indicator
	even
Idx2tcf_AL	proc	near
	push	bx
	call	Idx2tcf
	pop	bx
	ret
Idx2tcf_AL	endp

;Index to the current FCM for current machine or source
; ENTER: Nothing
; Exit:  BX points to FCM pos in TCF table
;	 AL = FCM indicator
	even
Idx2tcf	proc	near
	mov	al,Current_Machine		;Current_Source
Idx2tcf	endp

Idxatcf	proc	near
	cbw
	MULTIPLY_BY Vtrcb_length, ax
	mov	bx,offset Vtrcb.Vtrcb_FCM	; Offset for TCF indicator
	add	bx,ax
	mov	al,[bx]
	ret
Idxatcf	endp

Set2timecode	proc	near
	xor	ax,ax			; 0 for first VTR
S2tclp:	push	ax			; Initiate pointers for
	call	Idxatcf
	mov	byte ptr 1[bx],1
	pop	ax
	inc	al
	cmp	al,blk_dev
	jb	S2tclp
	ret
Set2timecode	endp

;================================================================
;		SAVE AND RESTORE MARK TABLES
;================================================================
Save_Marks	proc	near
	call	_kbd_cln
	mov	bx,offset savebuf_ovr
	call	_msgread
Smragn:	call	rdchar				; Get a character
	call	_Break_check			; Check for quick Exit
	jz	Smrxit
	cmp	ax,offset Enter_xcmd
	jnz	Smragn1
	mov	al,'0'
Smragn1:cmp	al,'0'				; Check for digit 0-9
	jc	Smragn				; Loop for another key
	cmp	al,'9'				;  if not a digit
	ja	Smragn

	and	al,0fh				; Convert to binary number
	mov	bl,al
	mov	ax,offset Exchlen
	mul	bl				; Calculate buffer start offset

	mov	dx,offset Savemarks_Buf		; Point to top of buffers
	add	dx,ax				; Add in calculated index value

	mov	bx,offset Exchbuf1		; BX = source pointer
	jmp	Slmarks

Smrxit:	ret
Save_Marks	endp

Last_Marks	proc	near
	call	_kbd_cln
	mov	bx,offset restbuf_ovr
	call	_msgread
Lmragn:	call	rdchar				; Get a character
	call	_Break_check			; Check for quick Exit
	jz	Smrxit
	cmp	ax,offset Enter_xcmd
	jnz	Lmragn1
	mov	al,'0'
Lmragn1:cmp	al,'0'				; Check for digit 0-9
	cmp	al,'0'				; Check for digit 0-9
	jc	Lmragn				; Loop for another key
	cmp	al,'9'				;  if not a digit
	ja	Lmragn

	and	al,0fh				; Convert to binary number
	mov	bl,al
	mov	ax,offset Exchlen
	mul	bl				; Calculate buffer start offset

	mov	bx,offset Savemarks_Buf		; Point to top of buffers
	add	bx,ax				; Add in calculated index value
	mov	si,bx

	call	_SaveWorkspace		; Save workspace for possible W/UNDO

	add	si,offset Mtbl_Start
	mov	cx,offset Mtbl_Length
Lmarks1:lodsb
	or	al,al
	jnz	Lmarks3
	loop	Lmarks1
	ERROR	nomarks_error,ERET_Return
	mov	al,Current_Machine
	push	ax
	jmp	Excxit

Lmarks3:mov	dx,offset Exchbuf1

Slmarks:mov	al,Current_Machine
	push	ax
	mov	cx,offset Exchlen
	call	_mmv16
	jmp	Excxit
Last_Marks	endp


;================================================================
;		Exchange WORKSPACE WITH BACKPAGE
;================================================================
;================================================================
;		Exchange WORKSPACE WITH BACKPAGE
;================================================================
Exchange	proc	near
	mov	al,Current_Machine	; Save current machine indicator
	push	ax
	mov	si,offset Exchbuf1
	mov	di,offset Exchange_Regs
	mov	cx,offset Exchlen
	shr	cx,1
	even
	push	es
	push	ds
	pop	es
Exch1:	lodsw				; AH gets current
	mov	dx,[di]			; AL gets Exchange
	mov	-2[si],dx		; Put Exchange to current
	stosw				; Put current to Exchange
	loop	Exch1
	pop	es
	mov	al,Current_Workspace	; Get the current workspace number
	cmp	al,1			; Is it workspace 1?
	mov	al,2			; Then toggle it to 2
	jz	Exch2
	dec	al			;  else, toggit to 1
Exch2:	mov	Current_Workspace,al
	
Excxit:	pop	ax			; Restore old machine indicator
	mov	cl,Current_Machine	; Get the current machine
	push	cx			; Save new machine
	call	Machine_Change
	pop	ax
	call	Machine_Change		; Clear out the old
	call	all_update
	ret
Exchange	endp

;================================================================
;		GET/SET CONSTANT REGISTERS
;================================================================
;display constant menu
Constant_Menu	proc	near
	call	_const_upd
	call	_constant_disp
	call	_constant_prompt
	mov	Input_Flag,INFL_const
	mov	al,2
	call	dec_cimsg
	jz	Cnstxit
	call	_convert2bin
	cmp	al,99
	jz	Clear_Constants

	cmp	al,16
	jb	JL0295
	call	_error_bell
	jmps	Constant_Menu

JL0295:	call	_constant_index		; Index to the proper constant
	push	bx
	push	ax

	mov	al,0ffh
	mov	Constant_Flag,al
	inc	al			; Clear flag used by TC_CIMSG
	mov	Trim_Ci_Flag,al		; To check for TRIM input
	mov	In_Out_Flag,al

	call	norm_kbd
	mov	bx,offset const_rqst	; Display prompt
	call	_Inout_init
	mov	al,'#'
	call	_ConOut
	call	_Space_Out
	pop	ax
	call	_A_DecOut

	mov	bx,offset Sttime	; Use Sttime for work area
	mov	al,NDF_CHAR		; Force non-drop
	call	tc_cimsg
	pop	dx			; Restore destination
	mov	al,0
	mov	Constant_Flag,al	; Clear constant flag
	jnc	Nclrcnst
	mov	bx,offset Tc_Format
	jmps	Clrcnst
Nclrcnst:
	call	_time_value		; Anything there?
	jz	Cnstxit
Clrcnst:call	_mmv3byt			; Move it there from Sttime
	jmp	Constant_Menu
Cnstxit:call	_const_upd
	call	_evnt_dispthis
	ret
Constant_Menu	endp

Clear_Constants	proc	near
	mov	bx,offset Constants
	mov	cx,3 * 16
	xor	al,al
Clr16c:	mov	[bx],al
	inc	bx
	loop	Clr16c
	jmp	Constant_Menu
Clear_Constants	endp

;-----------------------------------------------------
; USER DEFINED TOGGLES AND TOGGLE UPDATES FOR SCREEN |
;-----------------------------------------------------
Frame_Toggle	proc	near
	not	Frame_Flag
	test	Operational_Flags,frame_OPBIT
	jz	Ft_Set
	and	Operational_Flags,not frame_OPBIT
	jmps	Ft_Xit
Ft_Set:	or	Operational_Flags,frame_OPBIT
Ft_Xit:	jmp	all_update
Frame_Toggle	endp

;================================================================
;toggle rec/play machines
Rp_Toggle	proc	near
	test	Network_Flags,rptoggle_NTBIT
	jz	Rptglx
	mov	al,Current_Machine
	or	al,al
	jz	JL0305
	xor	al,al
	jmps	JL0306
JL0305:	mov	al,Current_Source
JL0306:	call	Machine_Change
	call	switch
	call	vtr_e2e
Rptglx:	ret
Rp_Toggle	endp

; Tag flag, 0 = off, 0ffh=ins, 0ffe=both
Tag_Toggle	proc	near
	mov	al,Tag_Flag			; Get flag type
	inc	al				; INs?
	jz	Tagrc1
	cmp	al,0ffh
	jz	Tagrc1
	mov	al,0feh
Tagrc1:	mov	Tag_Flag,al
Tag_Toggle	endp

Tag_Upd	proc	near
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Tag_Scr
	mov	al,Tag_Flag			; Get flag type
	mov	bx,offset Tag2_Msg
	inc	al
	jz	Tagup1
	mov	bx,offset Tag_Msg
	inc	al
	jz	Tagup1
	mov	bx, SpacePointer(4)
Tagup1:	call	_comsg
	ret
Tag_Upd	endp

;================================================================
;		Display video/audio off
Swenable	proc	near
		mov	al,video_IOTYP		; Bit #1 for VIDEO
		jmps	Swenall
Swenable	endp
Auenable	proc	near
		mov	al,audio_IOTYP		; Bit #2 for AUDIO
Auenable	endp
Swenall	proc	near
		test	Device_Enabled,al	; Check for bit set (enabled)
		jz	Swenset			; Jump if bit not set
		not	al
		and	Device_Enabled,al	; Clear the bit
		jmp	Swenable_Upd
Swenall	endp
Swenset	proc	near
		or	Device_Enabled,al	; Set the bit

Swenset	endp
Swenable_Upd	proc	near
		mov	bx, SpacePointer(4)
		mov	al,Device_Enabled	; Get flag
		mov	ah,al			; Save it
		and	al,video_IOTYP or audio_IOTYP
		cmp	al,video_IOTYP or audio_IOTYP
		jz	Swendsp
		mov	bx,offset Avenabl_Msg	; both disabled
		or	al,al
		jz	Swendsp
		mov	bx,offset Swenabl_Msg	; Video only
		test	al,video_IOTYP
		jz	Swendsp
		mov	bx,offset Auenabl_Msg	; Audio only
Swendsp:	norm_VIDEO TRUE,TRUE
		mov	Cursor,offset Swenabl_Scr
		call	_comsg
		ret
Swenable_Upd	endp

;Toggle auto tag function on/off
Diskon_Toggle	proc	near
		test	Operational_Flags,asyougo_OPBIT
		jz	Dskontgx
		call	TG_Diskon
		jmp	Toggle_It
Dskontgx:	ret
Diskon_Toggle	endp

Sort_Toggle	proc	near
		call	TG_Sort
		jmp	Toggle_It
Sort_Toggle	endp
Print_Toggle	proc	near
		call	TG_Print
		jmp	Toggle_It
Print_Toggle	endp
Clean_Toggle	proc	near
		call	TG_Clean
		jmp	Toggle_It
Clean_Toggle	endp
EDLtrak_Toggle	proc	near
		call	_check4edl
		JMP_Z	Vlan_Upd
		call	TG_EDLtrack
		call	Toggle_It
		jmp	Vlan_Upd
EDLtrak_Toggle	endp

Diskon_Upd_FAR	proc	far
	call	Diskon_Upd
	ret
Diskon_Upd_FAR	endp

Diskon_Upd	proc	near
		call	TG_Diskon
		jmp	Tagsupd
Diskon_Upd	endp
Sort_Upd	proc	near
		call	TG_Sort
		jmp	Tagsupd
Sort_Upd	endp
Print_Upd	proc	near
		call	TG_Print
		jmp	Tagsupd
Print_Upd	endp
Clean_Upd	proc	near
		call	TG_Clean
		jmp	Tagsupd
Clean_Upd	endp
Gpi_Upd	proc	near
		call	TG_Gpi
		jmp	Tagsupd
Gpi_Upd	endp
Pmc_Upd	proc	near
		call	TG_Pmc
		jmp	Tagsupd
Pmc_Upd	endp
Spd_Upd	proc	near
		call	TG_Spd
		jmp	Tagsupd
Spd_Upd	endp
ramp_upd	proc	near
		test	Device_Present, vlan_IOTYP
		jz	Vlan_Upd
		call	TG_ramp
		norm_VIDEO FALSE,TRUE
		mov	Cursor,cx
		test	[bx],al		; Present?
		mov	bx,dx		; Get screen message
		jnz	ramp_upd2
		mov	bx,SpacePointer(8)
ramp_upd2:	call	_comsg
ramp_updx:	ret
ramp_upd	endp

EDLtrack_Upd	proc	near
		cmp	Reference_Flag, FALSE
		jz	Ref_UPD

		call	_check4edl
		jnz	EDLtu
		and	Network_Flags,not EDLtrak_NTBIT
		jmp	Vlan_Upd1
EDLtu:		call	TG_EDLtrack
		mov	Cursor,cx
		test	Network_Flags,EDLtrak_NTBIT
		mov	bx,dx
		rev_VIDEO TRUE,TRUE
		jnz	Trackupd
		dim_VIDEO TRUE,TRUE
		mov	bx,SpacePointer(7)
Trackupd:	call	_comsg
		ret
EDLtrack_Upd	endp

Vlan_Upd	proc	near
		test	Device_Present,vlan_IOTYP
		jnz	EDLtrack_Upd
Vlan_Upd1:	call	TG_Vlan
		norm_VIDEO FALSE,TRUE
		mov	Cursor,cx
		test	[bx],al		; Present?
		mov	bx,dx		; Get screen message
		jz	Vlan_Upd2
		mov	bx,SpacePointer(8)
Vlan_Upd2:	call	_comsg
Vlan_Updx:	ret
Vlan_Upd	endp

Ref_UPD	proc	near
	test	Device_Present,vlan_IOTYP
	jz	Refupdx
	mov	Cursor,offset Vlan_Scr
	mov	bx,offset Noref_Msg
	cmp	Reference_Flag, FALSE
	jz	Refupd1
	mov	bx,SpacePointer(8)
	test	Ramp_Flags,Enabled_MSBIT
	jz	Refupd1
	jmp	ramp_upd
Refupd1:norm_VIDEO FALSE,FALSE
	call	_comsg
Refupdx:ret
Ref_UPD	endp

Preread_UPD	proc	near
	mov	bx,SpacePointer(10)
	mov	al,Preread_Immediate
	mov	ah,al
	or	al,Preread_State
	jz	Prupdx
	mov	bx,offset Preread_Msg
	or	ah,ah
	jz	Prupdx
	rev_VIDEO FALSE,FALSE
	jmp	Prudx1	
Prupdx:	norm_VIDEO FALSE,FALSE
Prudx1:	mov	Cursor,offset Preread_Scr
	call	_comsg
	norm_VIDEO FALSE,FALSE
	ret
Preread_UPD	endp

Toggle_It	proc	near
	test	[bx],ax
	jnz	Rst_Tag
	or	[bx],ax
	jmps	Tagsupd

Rst_Tag:not	ax
	and	[bx],ax
	not	ax
Tagsupd:xchg	bx,cx			; Get screen address
	mov	Cursor,bx
	norm_VIDEO FALSE,TRUE
	mov	bx,cx
	test	[bx],ax
	mov	bx,dx			; Get msg address
	jnz	JL0315
	mov	bx, SpacePointer(4)
JL0315:	call	_comsg
	ret
Toggle_It	endp

TG_Sort	proc	near
	mov	bx,offset DTG_Sort
	jmp short	TG_set
TG_Sort	endp
TG_Print	proc	near
	mov	bx,offset DTG_Print
	jmp short	TG_set
TG_Print	endp
TG_Clean	proc	near
	mov	bx,offset DTG_Clean
	jmp short	TG_set
TG_Clean	endp
TG_Diskon	proc	near
	mov	bx,offset DTG_Diskon
	jmp short	TG_set
TG_Diskon	endp
TG_Vlan	proc	near
	mov	bx,offset DTG_Vlan
	jmp short	TG_set
TG_Vlan	endp
TG_EDLtrack	proc	near
	mov	bx,offset DTG_EDLtrack
	jmp short	TG_set
TG_EDLtrack	endp
TG_Gpi	proc	near
	mov	bx,offset DTG_Gpi
	jmp short	TG_set
TG_Gpi	endp
TG_Pmc	proc	near
	mov	bx,offset DTG_Pmc
	jmp short	TG_set
TG_Pmc	endp
TG_Spd	proc	near
	mov	bx,offset DTG_Spd
	jmp short	TG_set
TG_Spd	endp
TG_ramp	proc	near
	mov	bx,offset DTG_Ramp
	jmp short	TG_set
TG_ramp	endp

TG_set	proc	near
	mov	dx,[bx].TGmsg
	mov	ax,[bx].TGbit
	mov	cx,[bx].TGscr
	mov	bx,[bx].TGflags
	ret
TG_set	endp

;================================================================
;
;		 TRANSITION SELECTION AND TOGGLES
;
;================================================================
Make_Wipe	proc	near
	mov	al,'W'
	jmps	Make_Efxs
Make_Wipe	endp
Make_Dissolve	proc	near
	mov	al,'D'
Make_Dissolve	endp
Make_Efxs	proc	near
	push	ax
	call	_check4edl		; No EDL, no make effect
	pop	ax
	jz	Mkdisr

	call	_SaveWorkspace		; Save workspace for possible W/UNDO

	cmp	Trans_Type,'C'		; Check for an already 
	jz	Mkefx1			;  existing wipe or
	cmp	Trans_Type,'K'		;  dissolve
	jz	Mkefx1			; (not C or K)

	push	ax
	mov	al,To_Machine
	call	Machine_Change
	pop	ax

Mkefx1:	mov	ah,Current_Source
	mov	To_Machine,ah
	push	ax
	call	Mtchvtr			; Get matchframe
	pop	ax
	jnc	Mkdis1
	ERROR	no_reel_match, ERET_Keyboard

Mkdis1:	mov	ah,Current_Source
	cmp	ah,To_Machine
	jz	Mkdis2
	push	ax
	mov	dx,Current_Inbuf	; Move matchframe value
	call	_mmv3byt			;  to current INbuffer
	call	_compute			; Compute the VTR
	pop	ax
	mov	From_Machine,ah
	mov	Trans_Type,al		; Save "D" or "W"
	mov	al,To_Machine
	call	Machine_Change
	call	switch
	call	vtr_e2e
	call	Trans_Upd
Mkdisr:	ret
Mkdis2:
	ERROR	nodiss_error, ERET_Keyboard
Make_Efxs	endp

;----------------------------------------------------------------
Key_Cmd	proc	near
	cmp	Trans_Type,'K'		; Is KEY the current mode?
	jnz	Keycmd1			; If NOT, then full dialog
	mov	al,Key_Mode		; If so, is KEY IN/OUT
	or	al,al			;  active?
	jz	Keycmd1			; Jump for full dialog if not
	dec	al			; If 0 then KEY_IN
	jz	Kinjp
	jmp	Keyout
Kinjp:	jmp	Keyin

Keycmd1:mov	bx,offset Key_Type
	call	_kbd_message
	mov	bx,offset Keybkgnd_Msg
	call	_comsg
Keymlp:	call	rdchar
	call	_Break_check
	jz	Key2cut			; Break return thru CUT/Keyboard
	call	Transition_Keys		; Check for other AV modes
	cmp	al,cr
	jnz	Keymlp0
	mov	al,Keybkgnd_Src
	jmps	Keymlp1

Keymlp0:call	_machine_keys
	jnz	Keymlp
	mov	Keybkgnd_Src,al
Keymlp1:call	_machine_disp
	call	_Space_Out
	mov	bx,offset Keyfor_Msg
	call	_comsg
Keymlp2:call	rdchar
	call	_Break_check
	jz	Key2cut			; Break return thru CUT/Keyboard
	call	Transition_Keys		; Check for other AV modes
	cmp	al,cr
	jnz	Keymlp3
	mov	al,Keyfor_Src
	jmps	Keymlp4

Keymlp3:call	_machine_keys
	jnz	Keymlp2
	mov	Keyfor_Src,al

Keymlp4:call	_machine_disp
	call	_Space_Out
	mov	bx,offset Keyinout_Msg
	call	_comsg
Keykbd:	call	rdchar
	call	_Break_check
	jnz	Keykbd0
Key2cut:jmp	Ftkbdx			; Break return thru CUT/Keyboard

Keykbd0:cmp	ax,offset Clrrd_xcmd		; Clear to cut?
	jnz	Keykbd1
	jmp	Cut_Dlg

Keykbd1:cmp	ax,offset Inrtn_xcmd
	jz	Keyin
	cmp	ax,offset Outrt_xcmd
	jz	Keyout
	cmp	ax,offset Enter_xcmd
	jz	Keynf
	call	_make_ucase
	cmp	al,'I'
	jz	Keyin
	cmp	al,'O'
	jz	Keyout
	cmp	al,NDF_CHAR
	jz	Keynf
	jmps	Keykbd

Keynf:	mov	Key_Mode,0		; No key fade in or out
	jmps	Key_Iox

Keyin:	mov	dx,offset In_Msg
	mov	al,1
	jmps	Key_Io

Keyout:	mov	dx,offset Out_Msg
	mov	al,2

Key_Io:	mov	Key_Mode,al		;1=in, 2=out, 0=no fade
	call	_kbd_cln
	mov	bx,offset Key_Type
	call	kbd_msgs
	mov	bx,dx
	call	_comsg

	mov	al,'('
	call	_ConOut
	mov	bx,Key_Trans
	call	_DecOut_Pad
	mov	al,')'
	call	_ConOut
	call	_Space_Out

Key_Io1:mov	al,3
	call	dec_cimsg
	jz	Key_Iox
	call	_convert2bin
	mov	Key_Trans,dx
Key_Iox:mov	Trans_Type,'K'
	jmp	Trans_Upd
Key_Cmd	endp

;----------------------------------------------------------------
; Split Edit
Split_Cmd	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	cmp	Trans_Type,'S'
	jnz	Splns
	mov	al,Split_Mode		; Get current split mode
	test	al,video_Emode		; Check for video
	jnz	Splaud
	jmp	Splvid

Splns:	mov	bx,offset Split_Dly_Msg
	call	_kbd_message
	mov	bx,offset Split_What_Msg
	call	_comsg
Splkbd:	call	rdchar
	call	_Break_check
	jnz	Splkbd0
	jmp	Ftkbdx			; Break return thru CUT/Keyboard

Splkbd0:call	Transition_Keys		; Check for other AV modes
	cmp	ax,offset Clrrd_xcmd	; Clear to cut?
	jnz	Splkbd1
	jmp	Cut_Dlg
Splkbd1:cmp	ax,offset Vidsel_xcmd
	jz	Splvid
	cmp	ax,offset Au1sel_xcmd
	jz	Splaud
	cmp	ax,offset Au2sel_xcmd
	jz	Splaud
	cmp	ax,offset Enter_xcmd
	jz	Splold
	call	_make_ucase
	cmp	al,'V'
	jz	Splvid
	cmp	al,'A'
	jz	Splaud
	jmps	Splkbd

Splold:	mov	al,Split_Mode
	test	al,video_Emode
	jnz	Splaud

Splvid:	mov	al,aud1_Emode OR aud2_Emode	; Audio becomes first half
	mov	dx,offset Split_Vid_Msg
	jmps	Splva

Splaud:	mov	al,video_Emode		; Video becomes first half
	mov	dx,offset Split_Aud_Msg

Splva:	mov	Split_Mode,al		; Save mask

	mov	Trans_Type,'S'		; Indicate SPLIT

Splitd:	call	norm_kbd		; Display prompt
	mov	bx,offset Split_When_Msg;  to select which
	call	kbd_msgs		;  to delay, audio
	mov	bx,dx
	call	_comsg

	mov	bx,offset Split_Delay
	mov	cl,0			; No + or -
	mov	ch,Rtcf
	call	tc_parenth

	mov	bx,offset Sttime	; Holding buffer
	mov	al,Rtcf
	call	tc_cimsg
	jc	Cut_Dlg			; Clear to cut if carry set
	call	_time_value
	jz	Splup			; Use old split time
	mov	dx,offset Split_Delay	; 3 byte delay buffer
	call	_mmv3byt			; Transfer split delay

Splup:	mov	bx,offset Split_Delay
	call	_time_value
	jz	Cut_Dlg
	jmp	Trans_Upd
Split_Cmd	endp

;----------------------------------------------------------------
; Get CUT information
Cut_Dlg	proc	near
	mov	Trans_Type,'C'
	call	Transup
	call	Tog2cut
	mov	al,Current_Machine
	push	ax
	mov	al,Current_Source
	mov	To_Machine,al
	call	Machine_Change
	pop	ax
	jmp	Machine_Take
Cut_Dlg	endp

;----------------------------------------------------------------
; Get WIPE information
Wipe_Dlg	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	cmp	Trans_Type,'W'
	jnz	Wipdlga
	call	_kbd_cln
	jmp	Disdur

Wipdlga:call	Transup
	mov	Trans_Type,'W'
	call	Tog2wipe
	call	_kbd_cln
	mov	bx,offset Wipe_Msg
	jmp	Disdlg0
Wipe_Dlg	endp

;----------------------------------------------------------------
; Get dissolve or wipe info
Disdlg	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	cmp	Trans_Type,'D'
	jnz	Disdlga
	call	_kbd_cln
	jmp	Disdur

Disdlga:call	Transup
	mov	Trans_Type,'D'
	call	Tog2dissolve
	call	_kbd_cln

	mov	bx,offset Dissolve_Type
Disdlg0:call	_comsg
	call	_Space_Out
	mov	bx,offset frommsg_ovr
	call	_msgread
Disci:	call	rdchar
	call	_Break_check
	jnz	Disci0
	jmp	Ftkbdx			; Break return thru CUT/Keyboard

Disci0:	call	Transition_Keys		; Check for other AV modes
	cmp	al,cr
	jz	Disci1
	call	_machine_keys
	jz	Disdlg1
	jmp	Disci
Disci1:	mov	al,From_Machine
Disdlg1:call	_machine_disp
	call	_Space_Out
	mov	From_Machine,al

Disdlg1a:
	push	Cursor			; Save Cursor in case of error
	call	To_Prmt
	jz	Disdlg2
	mov	al,To_Machine
Disdlg2:cmp	al,From_Machine		; Is TO mach = FROM mach?
	pop	bx			; Get Cursor
	jnz	Disdlg2a
	mov	Cursor,bx
	call	_error_bell
	jmps	Disdlg1a

Disdlg2a:
	call	_machine_disp
	call	_Space_Out
	mov	To_Machine,al

; Get duration only
Disdur:	mov	bx,offset Frame_Msg
	call	_comsg

	mov	al,3
	call	dec_cimsg
	jz	Disdlg3
	call	_convert2bin
	mov	Trans_Length,dx
Disdlg3:mov	al,Current_Machine
	push	ax
	mov	al,Trans_Type
	cmp	al,'W'
	jnz	JL0336
	call	_Space_Out
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Code_Msg
	call	_comsg
	mov	al,3
	call	dec_cimsg
	jz	JL0336
	call	_convert2bin
	mov	Trans_Code,dx
JL0336:	mov	ah,From_Machine		; Set from
	mov	al,To_Machine
	cmp	Trans_Type,'D'
	jz	JL0337
	mov	ah,Keyfor_Src
	mov	al,Keybkgnd_Src
JL0337:	push	ax
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
	pop	ax
	call	Machine_Take
	jmp	Trans_Upd
Disdlg	endp


;Get "TO" machine information
To_Prmt	proc	near
	mov	bx,offset tomsg_ovr
	call	_msgread
To_Prm1:call	rdchar
	call	_Break_check
	jnz	JL0340
;
Ftkbdx:	mov	bx,offset Keyboard	; Insure return
	push	bx			;  through Keyboard
	jmp	Cut_Dlg			;  and re-toggle to CUT

JL0340:	call	Transition_Keys		; Check for other AV modes
	cmp	al,cr
	jz	To_Prm2
	call	_machine_keys
	jz	To_Prm3
	call	_error_bell
	jmp	To_Prm1
To_Prm2:or	al,al
To_Prm3:ret
To_Prmt	endp

;----------------------------------------------------------------
Key_Upd	proc	near
	mov	bx,offset Key_Type
	call	_comsg
	cmp	Key_Mode,0
	jz	Kupd2
	mov	bx,offset In_Msg
	cmp	Key_Mode,1
	jz	Kupd1
	mov	bx,offset Out_Msg
Kupd1:	call	_comsg
	call	_Space_Out
	mov	bx,Key_Trans
	call	_DecOut_Pad

Kupd2:	mov	Cursor,offset Transtof_Scr
	mov	al,Keyfor_Src
	call	_machine_disp
	mov	Cursor,offset Transtim_Scr
	mov	bx,offset Keyover_Msg
	call	_comsg
	mov	al,Keybkgnd_Src
	call	_machine_disp
	ret
Key_Upd	endp

;----------------------------------------------------------------
Split_Upd	proc	near
	mov	bx,offset Split_Type
	call	_comsg
	mov	al,Current_Source
	call	_machine_disp

	mov	Cursor,offset Transtof_Scr
	mov	bx,offset Split_Dly_Msg
	call	_comsg
	mov	al,Split_Mode
	and	al,aud1_Emode OR aud2_Emode
	mov	bx,offset Split_Vid_Msg
	jnz	Splupdv
	mov	bx,offset Split_Aud_Msg
Splupdv:call	_comsg
	mov	Cursor,offset Transtim_Scr
	mov	bx,offset Split_Delay
	mov	cl,Rtcf				; Use R's tcf
	jmp	tc_disp				; Display delay and return
Split_Upd	endp

;----------------------------------------------------------------
Trans_Upd	proc	near
	call	_active_machines
	call	Transup			; Init transition area, get type

	cmp	al,'S'
	jz	Split_Updj
	cmp	al,'D'			; Is it a dissolve?
	jz	Tog2dissolve
	cmp	al,'W'			; Is it a wipe?
	JMP_Z	Tog2wipe
	cmp	al,'K'
	jz	Key_Updj
	jmp	Tog2cut

;*Following jump provided to prevent jump out of range error*
Split_Updj:
	jmp	Split_Upd
Key_Updj:
	jmp	Key_Upd

Trans_Upd	endp

;toggle transition modes
Trans_Switch	proc	near
	call	Transup			; Init transition area, get type
	cmp	al,'C'			; IF CUT, TOGGLE TO DISSOLVE
	jnz	Tsw1
	call	Tog2dissolve
	call	_active_machines
	ret
Tsw1:	cmp	al,'D'			; IF DISSOLVE, TOGGLE TO WIPE
	jnz	Tsw2
	call	Tog2wipe
	call	_active_machines
	ret
Tsw2:	cmp	al,'W'
	jnz	Tsw3
	call	Tog2split
	call	_active_machines
	ret
Tsw3:	cmp	al,'S'
	jnz	Tsw4
	call	Tog2key
	call	_active_machines
	ret

Tsw4:	call	Tog2cut
	call	_active_machines
	ret

Tog2cut:mov	byte ptr [bx],'C'	; Default to CUT
	mov	bx,offset Cut_Type
	call	_comsg
	mov	Cursor,offset Transtof_Scr
	mov	al,Current_Source
	jmp	Cut_Disp
Trans_Switch	endp

Tog2dissolve	proc	near
	mov	byte ptr [bx],'D'
	mov	bx,offset Dissolve_Type
	call	_comsg
	mov	Cursor,offset Transtof_Scr
	call	Efx_Disp
	mov	Cursor,offset Transtim_Scr
	jmp	Length_Disp

Tog2dissolve	endp

Tog2wipe	proc	near
	mov	byte ptr [bx],'W'
	mov	bx,offset Wipe_Msg
	call	_comsg
	call	_Space_Out
	mov	al,'#'
	call	_ConOut
	mov	bx,Trans_Code
	call	_DecOut_Pad
	call	Efx_Disp
	mov	Cursor,offset Transtim_Scr
	jmp	Length_Disp

Tog2wipe	endp

Tog2key	proc	near
	mov	byte ptr [bx],'K'
	jmp	Key_Upd

Tog2key	endp

Tog2split	proc	near
	mov	byte ptr [bx],'S'
	jmp	Split_Upd

Tog2split	endp

Efx_Disp	proc	near
	mov	Cursor,offset Transtof_Scr
	mov	al,From_Machine
	call	_machine_disp
	call	_Space_Out
	mov	al,To_Machine
Efx_Disp	endp

Cut_Disp	proc	near
	mov	bx,offset tomsg_ovr
	call	_msgread
	call	_machine_disp
	ret
Cut_Disp	endp

Length_Disp	proc	near
	mov	bx,Trans_Length
	call	_DecOut_Pad
	call	_Space_Out
	mov	bx,offset Frame_Msg
	call	_comsg
	ret
Length_Disp	endp

; Initialize transition area of screen, return with Cursor
; pointing to Transtyp_Scr, AL = trans type
	even
Transup	proc	near
	norm_VIDEO FALSE,FALSE
	mov	cx,4
	mov	bx, offset Transtyp_Scr		; Erase old transition type
Trnslp:	call	_dircur_infarea
	add	bx, 100h
	loop	Trnslp
	mov	Cursor, offset Transtyp_Scr
	mov	bx,offset Trans_Type
	mov	al,[bx]
	ret
Transup	endp


Transition_Keys	proc	near
	mov	bx,offset Cut_Dlg
	cmp	ax,offset Cut_xcmd
	jz	Tk_Jmp
	mov	bx,offset Disdlg
	cmp	ax,offset Dis_xcmd
	jz	Tk_Jmp
	mov	bx,offset Wipe_Dlg
	cmp	ax,offset Wip_xcmd
	jz	Tk_Jmp
	mov	bx,offset Key_Cmd
	cmp	ax,offset Key_xcmd
	jz	Tk_Jmp
	mov	bx,offset Split_Cmd
	cmp	ax,offset Split_xcmd
	jz	Tk_Jmp
	ret
Tk_Jmp:	mov	sp,offset Stacks	; Set stack
	mov	ax,offset Keyboard
	push	ax			; Set return
	call	bx			; Jump to routine
	ret
	mov	al,[bx]
	ret

Transition_Keys	endp

;================================================================
;		     SELECT EDITING MODES
;================================================================
Hardaud1	proc	near
	and	byte ptr Mode_Flag,NOT aud1_Emode
	jmps	Audio1_Select
Hardaud1	endp
Hardaud2	proc	near
	and	byte ptr Mode_Flag,NOT aud2_Emode
	jmps	Audio2_Select
Hardaud2	endp
Hardaud3	proc	near
	and	byte ptr Mode_Flag,NOT aud3_Emode
	jmps	Audio1_Select
Hardaud3	endp
Hardaud4	proc	near
	and	byte ptr Mode_Flag,NOT aud4_Emode
	jmps	Audio2_Select
Hardaud4	endp
Hardvid	proc	near
	and	byte ptr Mode_Flag,NOT video_Emode
	jmps	Video_Select
Hardvid	endp

Modes_Off	proc	near
	mov	cl,0
	mov	Mode_Flag,cl
	jmps	Vaas

Modes_Off	endp

Audio1_Select	proc	near
	mov	cl,aud1_Emode
	jmps	Vaas

Audio1_Select	endp
Audio2_Select	proc	near
	mov	cl,aud2_Emode
	jmps	Vaas

Audio2_Select	endp
Audio3_Select	proc	near
	call	_E1_flgs
	test	al,E1Flag_aud34ok	; Audio 3/4 ok?
	jz	Vaasx
	mov	cl,aud3_Emode
	jmps	Vaas

Audio3_Select	endp
Audio4_Select	proc	near
	call	_E1_flgs
	test	al,E1Flag_aud34ok	; Audio 3/4 ok?
	jz	Vaasx
	mov	cl,aud4_Emode
	jmps	Vaas

Audio4_Select	endp
Video_Select	proc	near
	mov	cl,video_Emode
Video_Select	endp

Vaas	proc	near
	push	ax
	push	bx
	mov	al,Mode_Flag
	test	al,cl			; Is bit set
	jnz	Vaas1			;
	or	al,cl			; Set the bit
	jmps	Vaas2
Vaas1:	not	cl
	and	al,cl
Vaas2:	mov	Mode_Flag,al
	call	_find_mode
	call	_mode_upd
	pop	bx
	pop	ax
Vaasx:	ret
Vaas	endp


;================================================================
;			Renumber EVENTS
;================================================================
Event_Change	proc	near
	call	_check4edl
	jz	Evntrmx
	mov	ax,es:Current_Event
	call	_index_storage
	jnc	Evchng1
	call	_line_first
	jnc	Evchng1
	call	_line_next
	jc	Evntrmx

Evchng1:call	_evnt_dispthis
	mov	bx,offset Event_Rple_Msg
	call	_kbd_message
	mov	al,4
	call	dec_cimsg
	jz	Event_Renum
	call	_convert2bin		; Get the number
	call	Renum1
	call	_evnt_dispthis
	jmp	Event_Renum

Renum1:	mov	bx,Current_Event_Adr
	cmp	es:byte ptr [bx].cmnt_lofst,0ffh
	jnz	Evntrmx
	mov	es:[bx],dx		; Store edit number

	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	Evntrmx
	mov	ax,es:Current_Event
	push	ax
	inc	ax
	call	_index_storage
	mov	es:[bx],dx		; Store edit number
	pop	ax
	call	_index_storage
Event_Change	endp

;Renumber EVENTS FROM CURRENT ON DOWN TO FOLLOW CURRENT'S NUMBER
Event_Renum	proc	near
	mov	bx,offset Event_Renum_ovr
	call	no_chos_msg
	jnz	Evntrmx
	call	Renumber
	call	_evnt_dispthis
Evntrmx:ret
Event_Renum	endp

;================================================================
;Renumber the EDL from the current event on down
Renumber	proc	near
	mov	ax,es:Current_Event
	push	ax			; Save the current event
	call	_index_storage
	mov	dx,es:[bx]		; Get edit number
	mov	es:Next_Edit,dx		;  Save it
Edlnum1:cmp	ax,es:Next_Avail_Num	; Any more lines to do?
	jz	Edlnumx
	call	_index_storage
	jc	Edlnum3			; Skip if comment
	mov	dx,es:Next_Edit
Edlnum2:mov	es:[bx],dx
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	Edlnum3
	inc	es:Next_Edit
Edlnum3:inc	ax
	jmp	Edlnum1

Edlnumx:pop	ax
	call	_index_storage
	ret
Renumber	endp

;================================================================
;		SEEK TO AN EVENT NUMBER
;================================================================
seek_event	proc	near
	call	_check4edl
	jz	seekxit
	mov	bx,offset SeekFLE_Msg
	call	_kbd_message
	mov	al,4
	call	dec_cimsg
	jz	seekxit
	call	_convert2bin
	jz	seekxit
	call	_find_edit_DX
	jz	JL0400
	ERROR	out_of_range, ERET_Return
	jmp	seek_event
seek_event	endp

seek_first	proc	near
	mov	ax,1
JL0400:	push	Lastplace
	call	_EDL_display
	pop	Lastplace
seekxit:ret
seek_first	endp

seek_last	proc	near
	call	_check4edl
	jmp	JL0400
seek_last	endp

;...
;================================================================
;			FIND TEXT IN EDL
;================================================================
find	proc	near
	call	_check4edl
	JMP_Z	fndxit

	call	_kbd_cln
	mov	bx,offset findwhat_ovr
	call	_msgread
	call	rdchar
	call	_Break_check
	JMP_Z	fndxit

	cmp	ax,offset Find_xcmd
	jz	find_old
	cmp	ax,offset Cmnt_xcmd
	jz	find_note
	cmp	ax,offset Enter_xcmd
	jz	find_old
	cmp	ax,offset Inrtn_xcmd
	jz	findntc
	cmp	ax,offset Outrt_xcmd
	jz	findntc
	cmp	ax,offset Durrt_xcmd
	jz	findntc
	cmp	ax,offset Trimin_xcmd
	jz	findntc
	cmp	ax,offset Trimout_xcmd
	jz	findntc
	cmp	ax,offset Markin_xcmd
	jz	findntc
	cmp	ax,offset Markout_xcmd
	jz	findntc
	cmp	ax,offset Clrrd_xcmd
	jz	find_new
	call	keythru
	call	_error_bell
	jmps	find

findntc:jmp	find_tc


find_new:
	mov	byte ptr Find_Buffer,0
	mov	bx,offset Find_Df
	call	_clear_tc
	mov	bx,offset Find_Nd
	call	_clear_tc
	jmp	find

find_old:
	cmp	Find_Type,0ffh		; TC find?
	jnz	find_note
	jmp	find_tcagn
find	endp


find_note	proc	near
	mov	Find_Type,0
	mov	bx,offset Find_Buffer	; Check for existing string
	mov	cl,[bx]			;  by getting its length
	or	cl,cl
	jz	find_1
	inc	bx			; Point to start of string
	mov	dx,bx			; DX = start of string
	jmps	find_3

find_1:	mov	bx,offset findtext_ovr
	call	_kbd_cln
	call	_msgread
	mov	al,line_length
	call	cimsg_wrk		; Get comment
	jnz	find_2
fndxit:	ret


find_2:	mov	si,offset Find_Buffer	; Where to put this string
	mov	[si],al			; Save length
	inc	si			; Increment to string
	push	si

	cbw				; Make the length a word
	mov	cx,ax			;  and move it to cx
	push	cx
	even
fcaps:	mov	al,[bx]			; Make all caps
	call	_make_ucase
	mov	[si],al			; Save to Find_Buffer
	inc	bx
	inc	si
	or	al,al
	loopnz	fcaps
	pop	cx			; CX has length of string
	pop	dx			; DX points to string

; Search for string in EDL
find_3:	mov	ax,es:Current_Event	; Save event to return to
	push	ax

fs_1lp:	inc	ax			; Increment to next
	cmp	ax,es:Next_Avail_Num
	jnc	fs_done
	call	_index_storage
	jnc	fs_1lp

	push	ax
	push	dx
	push	cx
	call	fs_save
	call	_instring
	pop	cx
	pop	dx
	or	al,al
	pop	ax
	jz	fs_1lp

	pop	ax
	call	_evnt_dispthis
	ret

fs_nfnd:call	_error_bell
fs_done:pop	ax			; Restore original event
	mov	byte ptr Find_Buffer,0	; Null out string buffer
	call	_event_display		; Display and Exit
	ERROR	txtnofnd_error, ERET_Keyboard

; Move a comment from ES:[BX] to Ascii_Line, making all caps
;  and terminating it with a null byte
; Exit: CH has length of target string
;	BX has address of target string
fs_save:push	cx
	mov	cx,line_length
	mov	si,offset Ascii_Line
	push	si
	xor	ah,ah
	even
fs_svlp:mov	al,es:[bx]
	call	_make_ucase
	mov	[si],al
	inc	si
	inc	bx
	inc	ah
	or	al,al
	loopnz	fs_svlp
	mov	byte ptr [si],0
	pop	bx
	pop	cx
	dec	ah
	mov	ch,ah
	ret
find_note	endp

;================================================================
find_tc	proc	near
	call	norm_kbd		; Display prompt
	mov	bx,offset findtc_ovr	;  to select which
	call	kbd_msgread		;  to delay, audio

; GET TIME CODE VALUE FROM OPERATOR
	mov	bx,offset Find_Nd	; Holding buffer
	mov	al,NDF_CHAR		; Get code as Non-Drop
	call	tc_cimsg
	jc	seektcc
	call	_time_value
	jz	seektcx
find_tc	endp

; STORE DROP FRAME EQUIVALENT (we will use both, DF and NDF)
seektc0	proc	near
	mov	dx,offset Find_Df	; Move TC
	call	_mmv3byt			;  to drop frame buffer
	mov	bx,dx			; Convert destination
	call	_cnvt2nd			;  to drop frame
seektc0	endp

find_tcagn	proc	near
	mov	bx,offset Find_Nd
	call	_time_value
	jnz	ftca1
	jmps	find_tc

ftca1:	mov	Find_Type,0ffh
	mov	ax,es:Current_Event
	push	ax
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jc	ftcaok
	mov	ax,1
ftcaok:	dec	ax
	push	ax
	jmps	seektcl

seektcc:mov	bx,offset Find_Df
	call	_clear_tc
	mov	bx,offset Find_Nd
	call	_clear_tc
	ret

seektc1:push	ax
	call	_index_storage		; Index to EDIT
	jc	seektcl			; Skip if not edit
	mov	dx,offset Find_Df	; Default for drop frame
	cmp	es:byte ptr [bx].ptcd_lofst,DF_CHAR
	jz	seektc2			; Jump if useing drop frame
	mov	dx,offset Find_Nd	;  else use non-drop code type

seektc2:call	_getlast_pin
	xchg	bx,dx			; BX = this TC, DX = last pin
	call	_cmp24b_DSES		; Is this number < last pin
	jc	seektcl			; If so, skip
	mov	dx,bx			; DX = this tc
	call	_getlast_pout
	xchg	bx,dx			; BX = this tc, DX = last pout
	call	_cmp24b_DSES		; Is this number <= last pin
	ja	seektcl			; If so, skip
	pop	ax			; Restore saved old event number
	pop	ax			; Restore loop event pointer
	call	_evnt_dispthis		;  and display this event
seektcx:ret

seektcl:pop	ax			; Restore loop event pointer
	inc	ax			; Increment it
	cmp	ax,es:Next_Avail_Num
	jb	seektc1
	pop	ax
	call	_event_display
	ERROR	txtnofnd_error, ERET_Keyboard

find_tcagn	endp


;================================================================
SECURITY_TEST	proc	near
		call	_get_lpt_ports		; Get LPT ports to local buf
		mov	al,0			; Flags should be zero
		call	security_flag_test	; Check for hackers!
		call	_K_GetPort		;Get Port the Activator is on
		cmp	Nport,0			;Did we get a Port address
		jne	realcheck		;We have a good Port address
		jmp	hackerishere
SECURITY_TEST	endp
realcheck	proc	near
		call	_CompleteCheck		;Lets really test it
		mov	al,1			; Flags should be one
		call	security_flag_test	; Check for hackers!
		pop	ax
		pop	bx
		inc	bx
		add	bx,1
		push	bx
		mov	bx,ax
		jmp	bx
realcheck	endp

; Jumped too directly after a SECURITY KEY NOT FOUND error
reset_leak	proc	near
		mov	bp,sp			; Get the return address
		mov	bx,[bx]
		sub	bx,3
reset_leak	endp
; Same as above, but return address is in BX
new_leak	proc	near
		push	bx			; Save error return on stack
		call	_help_pos		; Tell operator that
		call	_Cursor_On
		mov	dx,offset Author
		mov	ah,9
		int	DOS
		mov	bx,offset tryagain_ovr	;  SECURITY KEY cannot
		call	_msgread			;  be found.
		call	_kbd_cln
		call	_Cursor_On
		call	_error_bell		; Ring his chimes
		call	_error_bell		; 2x
leakagn:	mov	ah,10h
		int	16h
		cmp	ax,offset Escape_xcmd
		jz	leakgone
		cmp	ax,offset Enter_xcmd
		jnz	leakagn
		pop	ax
		mov	bx,Security_Return	; Get return address
		sub	bx,3			; Set it to go back and try
		cmp	bx,ax			; again, make sure its legal
		jz	leakok
		mov	bx,ax			; Use caller's return
leakok:		push	bx			; Push return address on stack
		ret

leakgone:	jmp	No_Security_Key		; Thats it, folks, go home
new_leak	endp

_TEXT	ends

_STACK	segment word stack 'STACK'

_STACK	ends

_DATA	segment byte public 'DATA'
KnobMode_msg	db	'[Knob=',0
ShuttleMode_msg	db	'Shuttle]',0
JogMode_msg	db	'Jog]',0


VtrTableMessage		dw	0
VtrTablePointer		dw	0
VtrAltTablePointer	dw	0
VtrTableMaxCount	db	0
VtrTableStart		db	0
VtrTableEnd		db	0
VtrTableFlagBit		db	0
VtrTableFlagPointer 	dw	0
VtrTableKey		dw	0
VtrTableError		dw	0


DTG_Sort	dw	offset Srt_Msg,     offset Operational_Flags, sort_OPBIT,    offset Srt_Scr
DTG_Print	dw	offset Lst_Msg,     offset Operational_Flags, lprint_OPBIT,  offset Print_Scr
DTG_Clean	dw	offset Cln_Msg,     offset Operational_Flags, clean_OPBIT,   offset Clean_Scr
DTG_Diskon	dw	offset Diskon_Msg,  offset Operational_Flags, diskon_OPBIT,  offset Diskon_Scr
DTG_Vlan	dw	offset Novlan_Msg,  offset Device_Present,    vlan_IOTYP,    offset Vlan_Scr
DTG_EDLtrack	dw	offset Edltrack_Msg,offset Network_Flags,     EDLtrak_NTBIT, offset Vlan_Scr

DTG_Gpi		dw	offset Gpi_Msg,     offset Gpi_Flags,         Enabled_MSBIT, offset Gpi_Scr
DTG_Pmc		dw	offset Pmc_Msg,     offset Pmc_Flags,         Enabled_MSBIT, offset Pmc_Scr
DTG_Spd		dw	offset Spd_Msg,     offset Spd_Flags,         Enabled_MSBIT, offset Spd_Scr
DTG_Ramp	dw	offset Ramp_Msg,    offset Ramp_Flags,        Enabled_MSBIT, offset Vlan_Scr

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

