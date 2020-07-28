; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner
; VMCT.ASM
; RS232 interfacing for VLAN VTR control nodes
;
%nolist
include vm.equ

extrn _DisplayEditStatus:far,calcedit_ovr:word,_MsgCntr:far
extrn OkToAdjustTC_Flag:byte,VlanVideoPort:byte
extrn Device_Enabled:byte,Device_Present:byte,DelEdRoll_Qrtrs:byte
extrn JogCmdAvailable:byte,RT_Switches:byte,RT_Vtr:byte,RollDelay_Flag:byte
extrn TL_Rin_Flag:byte,TL_Rout_Flag:byte,TL_Sync_Flag_IN:byte
extrn TL_Sync_Flag_OUT:byte,Vlan_Swbuf_CNT:byte,Abort_Flag:byte
extrn Active_IOTYP:byte,Assemble_Flag:byte,Assembly_Mode:byte
extrn Autotrans_Flag:byte,Auxtcf:byte,Blktcf:byte,Color_BKG:byte
extrn Current_Device:byte,Current_Machine:byte,Current_Node:byte
extrn Current_Source:byte,Diagnostics_Flag:byte,Edit_Selected_Vtr:byte
extrn Edit_Trys:byte,Editout_Flag:byte,Editsync:byte,Frame_Flag:byte
extrn From_Machine:byte,From_Machine:byte,Fullscreen_Flag:byte
extrn Hardrecord_Flag:byte,Input_Flag:word,Key_Mode:byte,Keybkgnd_Src:byte
extrn Keyfor_Src:byte,Last_Machine:byte,Last_Stickx:byte,Loc_Count:byte
extrn Mkdasm_Flag:byte,Mode_Flag:byte,Openend_Flag:byte,RT_Firstvtr:byte
extrn Preread_Immediate:byte,Preread_State:byte,Preview_Mode:byte
extrn Record_Flag:byte,Reference_Flag:byte,Retry_Count:byte,Rtcf:byte
extrn Split_Mode:byte,Syncbump_VTR:byte,System_Color_Frame:byte
extrn Tcgen_Mode:byte,Tline_Entries:byte,To_Machine:byte,Tracksngl_Flag:byte
extrn Trans_Type:byte,Trim_Ci_Flag:byte,Video_Mode:byte,Vtr_Mult_Type:byte

extrn SX_Descriptor:word,Sort_Tcfmt:word
extrn Ascii_Number:word,Current_VTRS:word,EDLoptions_Flags:word
extrn EDLtracking_Edit:word,ExactSpeed_ovr:word,MultRec_Flags:word
extrn RT_Bufend:word,RT_Buffer:word,RT_Bufptr:word,RT_Finalout:word
extrn SIO_Vtrs:word,Vlan_Swbuf:word,Vlan_Swbuf_PTR:word,Vlan_Swbuf_SIZ:word
extrn VLAN_Address:word,Asmaborted_Msg:word,Asmcomplete_Msg:word
extrn Assemble_Msg:word,Atrans_Offset:word,Assembly_Msg:word
extrn autoasminf_ovr:word,clrmrks_ovr:word,Cmdtbl2:word
extrn Countdown_Scr:word,Current_Duration:word
extrn Current_Event:word,Current_Event_Adr:word,Current_Inbuf:word
extrn Current_Outbuf:word,Cursor:word,Device_Stat_Tbl:word,Diagloc_Scr:word
extrn Done_Msg:word,Edit_Flags:word,Edits_To_Look_Ahead:word
extrn Editstatus_Area:word,Editsync_ovr:word,Edlsrch_Msg:word,Edmsg:word
extrn edsyncmsg_ovr:word,Entime:word,Frm_Cnt:word,goto_ovr:word
extrn Gpi_Flags:word,Hrs_Cnt:word,Key_Trans:word
extrn Keyboard_Scr:word,Last_Assembled:word,Loc_Vtrcb:word,location_rqst:word
extrn Locations_Scr:word,Lookahead_Counter:word
extrn mkdasm_ovr:word,Marks_Table:word,Multrecord_Table:word,Multsync_Table:word
extrn Network_Flags:word,Next_Avail_Num:word,Operational_Flags:word
extrn Page_Qry:word,Per_Msg:word,Pmc_Flags:word,Postroll:word,Preroll:word
extrn Pvw_Msg:word,R_Tc:word,Rvtr_Dur:word
extrn realtimeok_ovr:word,recording_ovr:word,Recordpost:word,Rev_Msg:word
extrn rewinding_ovr:word,rewindit_ovr:word,Rowtbl:word,Rvtr_In:word
extrn Rvtr_Location:word,Rvtr_Out:word,Sec_Cnt:word,set_timer_ovr:word
extrn setmrks_ovr:word,shiftinput_rqst:word,Slave_Flags:word,Slave_Table:word
extrn Spd_Flags:word,Split_Delay:word,stop_timer_ovr:word,Sttime:word
extrn Sync_Offset_In:word,Sync_Offset_Out:word
extrn Tags_Table:word,Tc_Format:word
extrn Tcdispbuf:word,Tcgen_Start:word,Temp_Event:word,Temp_Tc_Buf:word
extrn Time_Count:word,TimeLineRoll:word,Tline_Pointer:word,Trans_Length:word
extrn Trans_Time:word,Triggers:word,Videoram:word,VLAN_Flags:word
extrn Vlan_Scr:word,Vtr_Rcvbuf:word,Vtr_Searchto_Table:word,Vtr_Sndbuf:word
extrn Vtrcb:word,Vtrcmds:word,Vtrstat:word,Vtrsyncerr_Msg:word
extrn Workspace_Flags:word

extrn AS_cut:near,AS_over:near,AS_trans:near,ramp_upd:near,LINKS:near
extrn CheckVTR_Conflicts:near,EDLtrack_Upd:near,GetJoggerData:near
extrn KeyCommand_Cmdtbl2:near,MarkOut_Onthefly:near,Monitor_Switch:near
extrn Mute_On:near,Pmc_Upd:near,Preread_UPD:near
extrn PortIO_GetAddr:near,Ref_UPD:near,Spd_Upd:near,Setup_TimeLine:near
extrn VLAN_clear_switcher_Triggers:near,VLAN_switcher_write:near
extrn WriteAllSpeeds:near,add_event:near,aswitch4edit:near,blmsg:near
extrn check_ltrans:near,chk4relaybox:near,clear_relays:near
extrn clear_tagstable:near,ClearAll_gpis:near,cstat:near,dec_cimsg:near
extrn emset:near,event_recall:near,gpi_calc:near,gpi_ready:near,Gpi_Upd:near
extrn jogger:near,joystick:near,keythru:near,Machine_Change:near
extrn Mark_Inpoint:near,mdmout:near,no_chos_msg:near,pos_yn_chos:near
extrn rdchar:near,rdwait:near,reset_varispeeds:near,SW_cut:near,sw_trans:near
extrn switch4edit:near,switch:near,tc_cimsg:near,Trans_Upd:near
extrn triggerit:near,SW_autotrans:near,Beep_Countdown:near
extrn PsuedoRollGPIs:near,KEY_autotrans:near, apst_switch:near
extrn pswitch4edit:near, Preview_Switch:near, pswitch:near

extrn _A_DecOut:far,_ConOut:FAR,_EDL_display:far,_sttime_move_ES:far
extrn _GetSXcb_Flags:far,_PercentPlaySpeed:FAR,_ReCompute_EFX:far
extrn _Restore_All_Marks:far,_Restore_Marktable:FAR,_Save_All_Marks:far
extrn _Save_Marktable:far,_Space_Out:far,_SaveVtrInEditTable:far,_add_store:far
extrn _all_machine_keys:far,_beeper:FAR,_blinkita:FAR,_Break_check:FAR
extrn _check4edl:far,_check4marked:far,_Check4Reel:far,_check_mode:far
extrn _check_setkeys:far,_chrwait:far,_cmp24b:far,_cmp24b_ESDS:far
extrn _cnvt2mp_DS:far,_cnvt2tc_DS:far,_compute_Flags:far,_computer:far
extrn _comsg:FAR,_convert2bin:far,_crlf:far,_default_val:FAR
extrn _delms:FAR,_delqrtr:far,_delsec:far,_dircur_lerase:FAR,_Elaptm_move:far
extrn _emclear:far,_Entime_move:far,_error_bell:FAR,_event_display:far
extrn _evnt_dispthis:far,_find_edit_BX:far,_get_dur:far,_get_in:far
extrn _get_out:far,_getlast_Flags:far,_getlast_rin:far,_getlast_rout:far
extrn _help_pos:FAR,_hibeep:far,_index_storage:far,_Inout_init:far
extrn _itoa100:far,_itoa:far,_kbd_cln:FAR,_kbd_clr:FAR,_kbd_message:far
extrn _Keyboard_off:far,_Keyboard_on:far,_lblocks:FAR,_line_erase:far
extrn _line_first:far,_machine_disp:far,_machine_disp:far,_make_dec:far
extrn _make_hexbyte:far,_match_reels:far,_matchforcedrecall:far
extrn _mmv3_es2ds:far,_mmv3byt:far,_mmv:far,_mode_upd:far,_mpbadd:far
extrn _mpbsub:far,_msgread:far,_nblocks:FAR,_savebin:far,_screen_ram:far
extrn _Sttime_move:far,_tc_negate:far,_timadd:far,_timdif:far,_time_upd:far
extrn _time_value:far,_upd_getscr:far,Keyboard:far,_FrameStoreCompensate:far
extrn _getlast_dur:far,_Get_PrerollToBX:far,_clear_tc:far,_CheckLegalPreroll:far
extrn _TriggerBeforePrerollError:far,_SayWereSettingUp:far


extrn _clear_Edit_Flags:far,_clear_timeline:far
extrn _tline_save:far,_getedcmd:far,_openend_update:far
extrn _edit_update:far,_VVV_compensateOUT:far
extrn _Compensate_Real_Time:far
extrn _ColorFrame_Compensate:far,_sort_timeline:far
extrn _VVV_compensateIN:far,_ATRANS_compensateIN:far
extrn _VVV_compensateSplit:far

%list

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

Public  GangVtrs, CheckForReference, cfrx, cfrxx, vtr_editcalc, vtr_rehearse
Public  vtr_record, vtr_review, vtrrevr, vtr_vbv, vtr_bvb, vtrbvbr, vtr_vv
Public  vtr_bv, vtr_vb, asm_record, vtr_mult, MainMult
Public  multagn, multnem, multrev1, multrev2, vtr_nrv
Public  vtr_nr4, vtr_mult2, vtr_mult2a, HighResShuttle
Public  vtr_mult4, vtr_mult5, vtr_mult5nok, vtr_mult5sok, rtset, vtr_mult5nbvb
Public  vtrml5e, vtr_mult6, multloc, multcue, multcl1, multcux, DelEdRoll
Public  NoDelEdRoll, WaitForRoll, sync_check, synchk, schk1, schk2, schk3
Public  schk4, schk5, schk6, schk7, schk8, schk9, schk10, MonitorEdit
Public  mlocam, mlocmlp, mloc_1, mloc1a, mloc_2, mloc_3, rcmd_1, rcmd_1rl
Public  rcmd_2rl, rcmd_1nr, rcmd_1a, rcmd_2, syncbump_available, rcmd_1l
Public  rcmd_1n, rcmd_1s, sync_bump_plus, sync_bump_minus, sync_bump, syncb1
Public  syncb2, mldone, mldonel, mlab0, mlab1, mldone1, mldone3
Public  mldone4, mldone8, mldone9, ent_nad, mldonex, mldone_addevents, abort
Public  saydone, saydon1, saydon2, ret2vtr, ret2_nopreread, ret2stx
Public  restore_edit_marks, error_restore_marks, eresta, erestb, check4sync
Public  c4s_1, c4s_2, c4s_xit, SetRVT_Active, SetCurrentMachineActive, SetActiveVtr_CH, vtr_RPx
Public  vtr_RPr, Tline_Monitor, Tline_Monitor_again
Public  TLM_6, TLM_8, TLM_9, tlmx, TL_pmc, TL_sync_in, TL_sync_out, TL_rin
Public  tl_rin1, TL_Rout, TL_PVWin, tl_spvw, tl_stdp, PVIvvv, PVIvbv, PVIbvb
Public  TL_PVWout, PVOvvv, PVObvb, PVOvbv, GPI_trig, gpi_ret
Public  TL_INsplit, TLins1, Trigger_If_Time
Public  vtr_counter, cntrx
Public  stripe_tape, stp_watch, stp_rec, stp_xit, set_timecode_generator, stgok
Public  vtr_nul, all_cue, alcue, alncu, alcuret, PreReadOnOff, proo1, proox
Public  PreRead, PC_preread_local, PC_preread_on, PC_preread_off, PCio, pause
Public  pausestill, pausx, ExactSpeed, varip1, variplc, varipld, ExactSpeedOld
Public  ExactSpeedx, eject_FAR, eject, stop, play, fastfwd, rewind, bump_plus
Public  bump_minus, SingleFrame, cue, cuenew, cueret, motrst, motrstx, reverse
Public  twicefwd, twicerev, twice, slowfwd, slowrev, slow, shuttlefwd
Public  shuttleback, vtr_shtl, scan, scanxit, srchfwd
Public  srf_1, srf_2, srchrev, srr_0, srr_1, srr_2, srfr_7, sfr_8, varifwd
Public  varifwdg, varirev, varirevg, VSS_fwd, vssf_0, vssf_1, VSS_rev, vssrr_0
Public  VSSrr_1, VSSrr_2, VSSrr_3, VSSr_8, VariShuttle, VarShtl, VariShuttlexit
Public  all_stop, alstl, allstpr, all_still, alstp, alstp1, alstlr, still
Public  playrec_still, plstil1, plstil2, plstil3, plrcstl, plrstlx, vtr_still
Public  vtr_stx, gotoin, gotoout, gotoio, gotoior, vtr_location, search
Public  searchx, vtr_Preroll, vtr_Postroll, record_Postroll, switch_tc, swtcset
Public  swtcclr, vtr_mode, vtr_moderet, vtr_modelp, vtr_mode1, vtr_mode_x
Public  vtrmod1, vtrmod2, vtr_tracks, vtr_modeagain, vtr_tmod, vtr_msgstorecl
Public  vtr_msgstore, vtrmslp, vtr_cstore, all_enable, all_disable, allenab
Public  alen1, alen2, alen3, alen4, alen5, allenax, alenxit, enable_toggle
Public  enables, enabx, enabt, enable, disable, wait_on, wait_off, wait_go
Public  machine_init_FAR, machine_init, sinitlp, sinitl1, sinila, sinitl2
Public  sinitx, sinilx, vtr_SetRollBegin, vtr_setin, vsetin, vsetin1
Public  vtr_setout, vtr_setdur, sync2rec, setsync, nsync, sser, ssync1, ssync
Public  ssyncr, assemble_this, asmthisr, asmths0, asmths0a, asmths1, asmths2
Public  assemble, asmnoth, asmret, asmft, asmft01, asmft02, asmbllp, asmfta
Public  asmftb, asmftc, asmft0, asmft0e, asmft1, asmft1a, asmft2, asmbskp
Public  asmbsk1, asmbx, asmbx1, asmbx2, asmmsg, asmmsgx, LookAheadAndCueVtrs
Public  laaincev, laadis, laakey, laapt, lac_nomore, lac_xit, ask4location
Public  a4l_1, vtrex0, vtrex, motion, vtr_opt_FAR, vtr_opt, vtr_cmd, vtr_answer
Public  vtr_ci, vtr_ci1, vtr_ci2, vtr_ci3, vtr_akc, GetVlanRecord, vtr_gb
Public  vtr_gb1, vtr_gb2, GetEditStatus, gesxit, vtr_STAT, ask4sok, a4sex
Public  devstat_clr, dsclp, devtype_FAR, devtype, devnone, get_appltype
Public  aplnone, clear_node, set_tctype, get_minmaxspeeds
Public  vtr_pmccmd, pmccmd1, pmccmdx, vtr_rmpcmd, rmpcmd1, rmpcmdx, vtr_sendnd
Public  vtr_sendloc, vtr_sendtime, vtr_sl1, vtr_sendcmd, vtrcc0, vtrcc1
Public  vtrmltr, vtrmrll, vtrcml, vtrcmll, vtrnul, vtrchar, vtrdlchn
Public  vtrdlchnhex, vtrdlch, vtrchhex, vtrpndsng, vtrcmdt, vtrcmdx, vcmsg
Public  vcmsglp, vcolp, vnorcv, vcog, vcoxit, SendVlanMsgCl, SVMmsg1, SVMoxit
Public  set_vtrcmd, set_vtrextcmd, get_Vtrcb, get_Vtrcb_pointer, get_Vtrcb_CF
Public  get_vtrcb_FCM_FAR, get_Vtrcb_FCM, get_Vtrcb_TCM, get_Vtrcb_PORT
Public  gvtrcbs, IndexToCurVtrControlBlock, get_vtr, getvtnl, getvtnx
Public  EDLtrkone_toggle, EDLtrox, EDLtrx, EDL_Tracking, EDLtr1, EDLtr2, EDLtrl
Public  EDLtrc, EDLtrcx, EDLtrgn, EDLtxit, clear_timer, read_vtrloc
Public  readthis_vtrloc, locate_record, lrec1, read_VTR_time, read_DEVICE_time
Public  rdvtrlx, Clear_VTR_FCMs, Clfcmlp, Clfcml2, clfcmx, all_locations, alocs
Public  alocx, stopwatch, stwagn, stwx, stw1, stblp, stblp1, stblp2, stblp3
Public  stt, stopw1, stopw2, stopw3, nblockd, stwdec, stwinc, stwget, stwini
Public  Preroll_delayed, vtr_gps, vtr_gp1, locations_far, locret, diaglocations
Public  locnode, locations, loc0, loc1, loc2, loc3, loc30, loc31, loc32, loc4
Public  loc6, loc7, loc9, loc910, loc_12, lsrev_1, lsrev1a, lsrevaaa, lsrev1aa
Public  lsrev1xx, lspad1, lspad2, lsShuttle, lsrev_a1, lsrev_2, lsrev_3
Public  lsrev_4, lsrev_5, lsfwd_1, lsfwd_1a, lsfwd_2, lsfwd_3, lsfwd_4, lsfwd_5
Public  lsnul, loc10, loc10a, loc10b, locscrn, locscrx, loccmsg, lcmglp
Public  lcmgxit, Binary_Status, bsex, RealTime_Trigger, TimerPreroll
Public  TimerDisplay, Tmrd1, Td2, VTR_Reset, vtr_e2e, vtr_nee
Public  vtr_eer, vtr_setinout, SetIO_1, SetIO_Sources, SetIO_CUT
Public  SetIO_Cut1, SetIO_Cut2, SetIO_EFX, SetIO_EFX1, SetIO_EFX2, SetIO_EFX3
Public  SetIO_EFX4, SetIO_EFX4A, SetIO_ndelroll, SetIO_OpnEnd_wFlags
Public  SetIO_OpnEnd_Dur, SetIO_OED1, SetIO_OED2, SetIO_ltrans, setiodw
Public  setkeyt, setior, Setup_SplitEdit, vtadly, vtvst, setmult, setm1, setmok
Public  setmrt, setmrr, Set_In_From_Vtr_Loc, sifvlx, SetIO_Multrecord, vtrmus
Public  vtrmusx, SetIO_Slaves, vtrsus, vtrsusx, SetIO_RVTR, SetIO_RVTR1
Public  SetIO_OpenEnd, SetOE1, clear_delay, SetVlanColorFrame
Public  get_Vtrcb_OFFSET_FAR,get_Vtrcb_CF_FAR


GangVtrs	proc	near
	ret

GangVtrs	endp


; Set reference Flag TRUE if present, FALSE if not
CheckForReference	proc	near
	mov	ax,offset M_sync_check
	call	motion
	mov	al,[bx]
	mov	ah,TRUE
	cmp	al,'Y'
	jz	cfrx
	mov	ah,FALSE
cfrx:	cmp	Reference_Flag,ah
	mov	Reference_Flag,ah
	jz	cfrxx
	call	Ref_UPD
cfrxx:	ret
CheckForReference	endp


;================================================================
;
;		    MULTI-VTR SYNCHRONIZATION
;
;================================================================

vtr_editcalc	proc	near
	mov	al,V_roll
	jmp	vtr_mult
vtr_editcalc	endp

vtr_rehearse	proc	near
	mov	al,V_pvw
	mov	bx,offset Pvw_Msg
	jmp	vtr_mult
vtr_rehearse	endp

vtr_record	proc	near
	mov	al,V_rec
	mov	bx,offset Per_Msg
	jmp	vtr_mult
vtr_record	endp

vtr_review	proc	near
	call	_check4edl
	jz	vtrrevr
	xor	al,al			; Select R-VTR
	call	Machine_Change
	mov	word ptr Multsync_Table,0 ; No machines to SYNC
	mov	al,V_rev		; AL = edit type Flag
	mov	bx,offset Rev_Msg	; "REPLAY" message
	jmp	vtr_mult
vtrrevr:ret
vtr_review	endp

vtr_vbv	proc	near
	mov	al,V_vbv
	mov	bx,offset Pvw_Msg
	jmp	vtr_mult
vtr_vbv	endp

vtr_bvb	proc	near
	test	Device_Present,video_IOTYP	; Video switcher present?
	jz	vtrbvbr
	mov	al,V_bvb
	mov	bx,offset Pvw_Msg
	jmp	vtr_mult
vtrbvbr:ret
vtr_bvb	endp


vtr_vv	proc	near
	mov	al,V_vv
	mov	bx,offset Pvw_Msg
	jmp	vtr_mult
vtr_vv	endp

vtr_bv	proc	near
	mov	al,V_bv
	mov	bx,offset Pvw_Msg
	jmp	vtr_mult
vtr_bv	endp

vtr_vb	proc	near
	mov	al,V_vb
	mov	bx,offset Pvw_Msg
	jmp	vtr_mult
vtr_vb	endp

asm_record	proc	near
	mov	al,V_rec
	mov	bx,offset Per_Msg
	jmp	MainMult
asm_record	endp

;================================================================
;		MULTIPLE - VTR OPERATIONS
;================================================================
vtr_mult	proc	near
	test	Device_Present,vlan_IOTYP
	RETZ

	mov	OkToAdjustTC_Flag, TRUE

	call	_kbd_clr
	mov	Assemble_Flag,0

	mov	cl,Current_Machine	; Save the present
	mov	Last_Machine,cl		;  current machine number
	call	_Save_Marktable		; Save Ins, Outs, Durs...
vtr_mult	endp

MainMult	proc	near
	mov	Vtr_Mult_Type,al	; Set mult type
	mov	Edmsg,bx		; Save pointer to message

	mov	al,Retry_Count		; Set retry counts
	mov	Edit_Trys,al		;  for abort

; Clear out the edit status flag
	mov	editstatus,0ffh

; Set RECORD Postroll different from other postrolls
; 
	mov	bx,offset vtr_Postroll	; BX POINTS TO RECORD POST RTN
	cmp	Vtr_Mult_Type,V_rec	; Check if RECORD MODE
	jnz	mainok1			; Skip if NOT

	call	_Check4Reel		; Check for any reel Name present

; We are going to RECORD the edit, Check for MODE present
	cmp	Mode_Flag,0
	jnz	mainmok
	call	error_restore_marks	; Restore MARK TABLE
	call	_upd_getscr		; Redraw MARK TABLE
	ERROR	mprse_error, ERET_Keyboard ; Bail out

;................................................................
mainmok:mov	bx,offset record_Postroll ; BX POINTS TO PVW POST RTN
mainok1:call	bx			; Call PVW or REC POST RTN
	call	vtr_Preroll		; Set Preroll

	xor	al,al			; Center on REC machine
	call	Machine_Change
	call	switch
	call	vtr_e2e

MainMult	endp

multagn	proc	near

	call	_CheckLegalPreroll
	jnc	multlglgpis
	call	_TriggerBeforePrerollError
	ret

multlglgpis:
	
	cmp	Vtr_Mult_Type,V_roll	; Just calculating?
	jz	multnem

	call	reset_varispeeds	; Clear speed changes
	call	clear_tagstable		; Clear tags table

	call	emset			; Display what we are doing

multnem:call	_clear_Edit_Flags	; Reset all edit Flags
	call	_clear_timeline		; Clear out the time line
	xor	al,al
	mov	Tline_Entries,al	;  and its entry Count
	mov	Abort_Flag,al		; Show no aborts

	mov	bx,offset Rvtr_Location
	call	_clear_tc

; I. Set IN and OUT points
	cmp	Vtr_Mult_Type,V_rev	; Check for REVIEW
	JMP_NZ	vtr_nrv

	; ================ PROCESS FOR REVIEW (REPLAY) EDIT
	; * Fixed 11/20/89 to allow for review of dissolves, wipes, keys
	; If review, we have to use the in and out points
	; from the current edit
		xor	al,al			; <><> this may not be necessary
		call	Machine_Change
		call	SetRVT_Active		; Set for record machine
	
	; ---------------- Set IN POINT for review
		call	_getlast_rin
		mov	dx,offset Rvtr_In	; As good as any buffer to use
		call	_mmv3_es2ds
		mov	bx,dx
		call	vtr_setin

		call	_Get_PrerollToBX
		mov	dx,offset Rvtr_In	;  for a record Flag trigger
		call	_mmv3byt

		mov	ax,TFlag_RIN		; Save to tline
		call	_tline_save		; BX still = Rvtr_In
	
	; ---------------- Check for double line event
		call	_getlast_Flags
		test	word ptr es:[bx],dblline_Fmask
		jz	multrev1
	
	; ---------------- If double line event, go to 2nd line for R-VTR OUT POINT
		mov	ax,es:Current_Event
		inc	ax
		call	_index_storage
		call	_getlast_rout
		dec	ax
		push	bx
		call	_index_storage
		pop	bx
		jmp	multrev2
	
	; ---------------- If single line event, use current out point
	multrev1:
		call	_getlast_rout
	multrev2:
		mov	dx,offset Rvtr_Out	; As good as any buffer to use
		call	_mmv3_es2ds
		mov	bx,dx
		call	vtr_setout
	
		; Set the time line ROUT to R duration + Preroll
		call	_getlast_dur
		call	_sttime_move_ES
		mov	dx,offset Rvtr_Dur	; Save duration
		call	_mmv3byt
	
		mov	bx,offset Preroll
		call	_Elaptm_move
		call	_timadd
		mov	dx,offset Rvtr_Out	; As good as any buffer to use
		call	_mmv3byt
		mov	ax,TFlag_ROUT		; Save to tline
		call	_tline_save
	
		jmp	vtr_mult2
multagn	endp

;================================================================
; setup for a real edit
vtr_nrv	proc	near
	call	clear_relays		; Clear out relays

	call	vtr_setinout		; Set in and out points

	call	_Get_PrerollToBX
	mov	dx,offset Rvtr_In	;  for a record Flag trigger
	call	_mmv3byt

	mov	ax,TFlag_RIN		; Save to tline
	call	_tline_save		; BX still = Rvtr_In
	call	_VVV_compensateIN
	mov	ax,TFlag_PVWin
	call	_tline_save

	call	SetupEditTimeline	; Set GPIs and Switchers

	cmp	Vtr_Mult_Type,V_roll
	jnz	vtrnrv1

	;; Set up a psuedo edit to node 21

		mov	cl,VX_DIGITch
		mov	ch,VlanVideoPort	; Set to vid switcher
		mov	ax,offset M_node_address
		call	vtr_cmd

		mov	ax,offset M_clear_node
		call	motion

		mov	ax,offset M_set_in
		call	set_vtrcmd		;  at RVTR-IN minus
		mov	cl,Rtcf			;  the preroll
		call	_Get_PrerollToBX
		call	vtr_sl1

		cmp	Openend_Flag,0ffh	; Skip if not open end edit
		jnz	vtrnrv1

		; Set duration for 23:59:59:29
		mov	ax,offset M_set_duration
		call	set_vtrcmd
		mov	cl,Rtcf
		mov	bx,offset Sort_Tcfmt ;Hrs_Cnt
		call	vtr_sl1

vtrnrv1:
	cmp	Openend_Flag,0ffh	; Skip following if open end edit
	jz	vtr_nr4

		; Set the time line ROUT to R duration + Preroll
		mov	bx,offset R_Tc.tcDUR
		call	_Sttime_move
		call	_Get_PrerollToBX
		call	_Elaptm_move
		call	_timadd
		mov	dx,offset Rvtr_Out	;  for a record Flag trigger
		call	_mmv3byt

		mov	ax,TFlag_ROUT		; Save to tline
		call	_tline_save		; Returns with BX pointing to Rvtr_Out
		call	_VVV_compensateOUT
		mov	ax,TFlag_PVWout
		call	_tline_save

		cmp	Vtr_Mult_Type,V_roll
		jnz	vtr_nr4

		push	bx
		mov	ax,offset M_set_out
		call	set_vtrcmd			;  at RVTR-IN minus
		pop	bx
		mov	cl,Rtcf				;  a 2 second Preroll
		call	vtr_sl1

vtr_nr4:call	vtr_mode

;; Set all speed changes using the Multsync_Table
;; Must change the node numbers to machines
	push	Current_VTRS
	mov	si,offset Multsync_Table	; Point to multsync table
vtr_ms1:lodsb					; Get a mult REC vtr
	or	al,al				; End of table?
	jz	vtr_ms2
	call	get_vtr
	call	Machine_Change
	call	WriteAllSpeeds
	jmp	vtr_ms1
vtr_ms2:
	pop	Current_VTRS
	call	Machine_Change

; Set the sync_time check location
	call	_Get_PrerollToBX
	push	bx

	call	_Entime_move
	mov	bx,offset Sync_Offset_In
	call	_Sttime_move
	call	_timdif			; Entime - Sttime = Elaptm

	mov	ax,TFlag_SYNC_IN
	call	_tline_save
	pop	bx

	call	_Entime_move
	mov	bx,offset Sync_Offset_Out
	call	_Sttime_move
	call	_timdif			; Entime - Sttime = Elaptm
	mov	ax,TFlag_SYNC_OUT
	call	_tline_save



;----------------------------------------------------------------
; SET UP THE TIME LINE AND ROLL 'EM
vtr_mult2:
	cmp	Vtr_Mult_Type,V_roll		; Just calculating?
	jnz	vtr_mult2a

		; SET E-TO-E ON
		mov	cx,VX_DeviceCH		; Set to R_VTR
		mov	ax,offset M_node_address
		call	vtr_cmd			; Set From side on
		mov	ax,offset M_ee_on	; Turn e2e on
		call	motion

		call	wait_on

		mov	cl,VX_DIGITch
		mov	ch,VlanVideoPort	; Set to vid switcher
		mov	ax,offset M_node_address
		call	vtr_cmd
		jmp	vtrec1

;----------------------------------------------------------------
; Check for and setup BVB PREVIEW
vtr_mult2a:
	cmp	Vtr_Mult_Type,V_bvb	; BVB?
	jnz	vtr_mult4

		mov	cx,VX_DeviceCH		; Set to R_VTR
		mov	ax,offset M_node_address
		call	vtr_cmd			; Set From side on
		mov	ax,offset M_ee_on	; Turn e2e on
		call	motion

		mov	ch,To_Machine		; Set to playback machine
		mov	cl,VX_DeviceCH
		mov	ax,offset M_node_address
		call	vtr_cmd			; Set From side on
		jmp	vtr_mult5

;----------------------------------------------------------------
; Not BVB, rehearse or record
vtr_mult4:
	call	SetRVT_Active

	call	SetVlanColorFrame	;5-16-1994 

	mov	ax,offset M_ee_off
	call	motion

	cmp	Preread_State,0		; Is preread off?
	jz	vtr_mult5
	call	PC_preread_on
	jmp	vtr_mult5

;----------------------------------------------------------------
;----------------------------------------------------------------
;----------------------------------------------------------------
; Send the EDIT command
vtr_mult5:
	mov	al,Current_Source
	call	vtr_STAT
	jz	vtr_mult5nok
	cmp	al,MAX_SOURCES		; Is it a legal device?
	jbe	vtr_mult5sok		; Jump if ok
vtr_mult5nok:
	mov	al,0			; Default to record vtr
vtr_mult5sok:
	mov	Syncbump_VTR,al

	test	Edit_Flags, realtime_EDBIT
	jz	rtcontinue

	mov	RT_Bufptr,offset RT_Buffer ; Preset buffer pointer
	mov	RT_Switches,0		; Clear to no switches
	mov	ah,Trans_Type
	mov	al,Current_Source
	cmp	ah,'C'
	jz	rtset
	cmp	ah,'S'
	jz	rtset
	mov	al,From_Machine
rtset:	mov	RT_Vtr,al
	mov	RT_Firstvtr,al		; 8-03-1994 fix

	test	Slave_Flags,Enabled_MSBIT
	jz	rtcontinue
	cmp	byte ptr Slave_Table, 0	; Make sure that the R-VT is master
	jz	rtcontinue
	ERROR	badRTslaves_error, ERET_Return
	call	LINKS
	jmp	multagn
rtcontinue:

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	call	CheckVTR_Conflicts	; See if there are master/slave
					;  and multiple record conflicts

	call	Mute_On
	call	wait_on

	cmp	Vtr_Mult_Type,V_bvb	; BVB?
	jnz	vtr_mult5nbvb
	mov	al,To_Machine
	call	setmult			; Need something to sync to

vtr_mult5nbvb:
	mov	ax,offset M_Source_nodes	; SETUP SOURCE NODES
	mov	cl,VX_MULTsrcroll
	call	vtr_cmd

	mov	ax,offset M_Record_nodes	; SETUP RECORD NODES
	mov	cl,VX_MULTvtrs			; (and save them into
	call	vtr_cmd			;  the vtrmult_table)

vtrec1:
;;	call	SetupEditTimeline	; Set GPIs and Switchers

	call	_getedcmd
	xor	cl,cl
	call	vtr_cmd
	cmp	byte ptr [bx],cr	; All ok with VLAN?
	jz	vtr_mult6

;................................................................
; Report error
	mov	Abort_Flag,0ffh
	mov	ax,[bx]			; Get the first character in vtr_rvcbuf
	cmp	ax,'OC'			; COM ERROR?
	jz	vtrml5e
	cmp	ax,'UD'			; Duration error?
	jz	vtrml5e
	call	error_restore_marks
	call	_upd_getscr
	ERROR	offline_error, ERET_Keyboard

vtrml5e:call	blmsg			; Display error from VLAN
	call	_blinkita
	call	_kbd_cln
	ret

vtr_mult6:
	jmp	multloc
vtr_nrv	endp

;----------------------------------------------------------------
;		MONITOR EVENT
; Constantly monitor machine activity during event
; Return with Carry set (C=1) if error or abort

;Display status for current machine
multloc	proc	near
	call	_openend_update
	call	GetEditStatus		; Get edit status to AH
	call	_DisplayEditStatus
	cmp	Vtr_Mult_Type,V_roll		; Timeline?
	jz	multcue
	call	devstat_clr
	call	all_locations
	jmp	multcue
multloc	endp

;----------------------------------------------------------------
;		CUE ALL MACHINES,  SET UP SWITCHER
;----------------------------------------------------------------
; Wait until all decks have cued, set switcher
;  send WAIT GO.

multcue	proc	near
	call	locations
	call	cstat
	cmp	ax,offset Space_xcmd
	jnz	multcl1
	mov	Abort_Flag,0ffh			; Show abort
	jmp	abort

multcl1:call	GetEditStatus		; Get edit status to AH
	cmp	al,EDITSTATUSIS_READY
	jz	multcux
	cmp	al,EDITSTATUSIS_ABORTED
	jnz	multcue
	call	_DisplayEditStatus

	mov	Abort_Flag,0ffh			; Show abort
	call	error_restore_marks
	call	_upd_getscr
	ERROR	vtrs_notready, ERET_Keyboard

multcux:
;;	if ALLOW_VLAN3
;;	test	VLAN_Flags, forcever3_VLNBIT
;;	jnz	av3mcx0
;;	test	VLAN_Flags, swextended_VLNBIT
;;	jnz	av3mcx1
;;av3mcx0:mov	bx,offset Vlan_Swbuf
;;	mov	Vlan_Swbuf_PTR, bx
;;	xor	ax,ax
;;	mov	Vlan_Swbuf_SIZ,ax
;;	mov	Vlan_Swbuf_CNT,al
;;	dec	ax
;;	mov	[bx].VSW_TransitionDur,ax
;;av3mcx1:
;;	endif

;;;	call	SetupEditTimeline	; Set GPIs and Switchers

	xor	al,al				; Monitor R_VTR
	call	Monitor_Switch

	; Add programmed delay before roll n.h.s.
	mov	cl,DelEdRoll_Qrtrs
	or	cl,cl
	jz	NoDelEdRoll
	mov	ch,0
DelEdRoll:
	push	cx
	call	locations
	pop	cx
	call	_delqrtr
	loop	DelEdRoll

NoDelEdRoll:
	call	GetEditStatus		; Get edit status to AH
	call	_DisplayEditStatus

	mov	al,FALSE		; Sort by adjusted time
	call	_sort_timeline
	
	call	wait_go
WaitForRoll:
	call	GetEditStatus		; Get edit status to AH
	cmp	al,EDITSTATUSIS_READY
	jz	Wfr1
	jmp	sync_check
Wfr1:	call	_DisplayEditStatus
	call	locations
	call	cstat
	cmp	ax,offset Space_xcmd
	jnz	WaitForRoll
	mov	Abort_Flag,0ffh			; Show abort
	jmp	abort

multcue	endp

SetupEditTimeline	proc	near
	cmp	Vtr_Mult_Type,V_rev
	JMP_Z	MltMSw

	call	_SayWereSettingUp

	if ALLOW_VLAN3
;;	test	VLAN_Flags, forcever3_VLNBIT
;;	jnz	av3mcx0
;;	test	VLAN_Flags, swextended_VLNBIT
;;	jnz	av3mcx1
;;av3mcx0:
	mov	bx,offset Vlan_Swbuf
	mov	Vlan_Swbuf_PTR, bx
	xor	ax,ax
	mov	Vlan_Swbuf_SIZ,ax
	mov	Vlan_Swbuf_CNT,al
	dec	ax
	mov	[bx].VSW_TransitionDur,ax
;;av3mcx1:
	endif

	call	switch4edit			; Set up switcher
	call	aswitch4edit			; and audio

	; Set preveiw switcher if necessary
	mov	al, Vtr_Mult_Type
	cmp	al, V_pvw
	jz	setlpvw
	cmp	al, V_vbv
	jz	setlpvw
	cmp	al, V_bvb
	jz	setlpvw
	cmp	al, V_vv
	jz	setlpvw
	cmp	al, V_bv
	jz	setlpvw
	cmp	al, V_vb
	jnz	setlnpvw
setlpvw:call	pswitch4edit			; and preview sw

setlnpvw:
	mov	al,TRUE				; Set the relays up
	call	gpi_calc			; 
	call	gpi_ready			; Ready GPIs
	call 	VLAN_clear_switcher_Triggers

	cmp	Vtr_Mult_Type,V_roll
	jnz	av3mcx1b
	call	Beep_Countdown
av3mcx1b:

	if ALLOW_VLAN3
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	av3mcx1a
	test	VLAN_Flags, swextended_VLNBIT
	jnz	av3mcx2
av3mcx1a:
	mov	Active_IOTYP,video_IOTYP
	call	VLAN_switcher_write		; Setup VLAN video Switcher

	mov	Active_IOTYP,audio_IOTYP
	call	VLAN_switcher_write		; Setup VLAN audio Switcher
av3mcx2:
	mov	Active_IOTYP,preview_IOTYP
	call	VLAN_switcher_write		; Setup VLAN preview Switcher
	endif

	mov	bx,offset Editstatus_Area
	call	_dircur_lerase
MltMSw:
	ret
SetupEditTimeline	endp


;================================================================
;	      MONITOR Preroll FOR SYNC AND Triggers
;================================================================
sync_check	proc	near
	call	Tline_Monitor		; Monitor the TIME LINE
	cmp	TL_Rin_Flag,0ffh
	JMP_Z	schk10

	call	locations		; Display next VTR's location

	call	GetEditStatus		; Get edit status to AH
	call	_DisplayEditStatus

	cmp	Vtr_Mult_Type,V_roll	; Don't get on-the-fly out
	JMP_Z	schk6

	cmp	TL_Sync_Flag_OUT,0ffh
	JMP_Z	schk6

	cmp	TL_Sync_Flag_IN,0ffh
	JMP_NZ	schk6
	call	check4sync		; Check for SYNC OK
	JMP_NC	schk6

;................................................................
; RETURN: C=1 if any error, AL has error, AH has SIGN, CH has NODE #
	push	ax			; Save error and sign
	push	cx
	mov	al,ch			; Find the target device
	call	get_vtr			; VTR 0-n in AL, BX points to X_Vtrcb
	pop	cx			; Restore node number
	mov	cl,al			; Save VTR # in CL
	pop	ax			; Restore error and sign

	cmp	RollDelay_Flag,0ffh
	jnz	synchk
	cmp	cl,To_Machine
	jz	schk6

synchk:	cmp	al,[bx.Vtrcb_WINDOW]
	mov	[bx.Vtrcb_ERROR],ax	; Save error (AL) and sign (AH)
	jbe	schk3

	pushf				; Save Flags

; Motion control stuff
	or	cl,cl			; Check error on REC-VTR?
	jz	schk1

	test	Pmc_Flags,Enabled_MSBIT
	jnz	schk2
	test	Spd_Flags,Enabled_MSBIT
	jnz	schk2

schk1:	push	ax			;  and abort info
	push	cx			;  and +/- Flag
	call	abort
	pop	cx
	pop	ax
	popf
	jmp	schk3

schk2:	popf
	stc

schk3:	pushf				; Save Flags
	call	_kbd_cln
	xchg	ah,al
	call	_ConOut
	mov	al,ah
	call	_A_DecOut		; Display frames error
	mov	bx,offset Vtrsyncerr_Msg
	call	_comsg	
	mov	al,cl			; Get DEVICE #
	call	_machine_disp
	popf
	jbe	schk6			; Jump if within tolerance

	mov	bx,offset Asmaborted_Msg
	call	blmsg
	call	_blinkita
	call	_kbd_cln
	call	_openend_update
	call	asmmsg
	dec	Edit_Trys
	jnz	schk4
	mov	Abort_Flag,0ffh			; Show abort
	ret

schk4:	jmp	multagn

schk5:	popf			; Pop the Flags pushed while checking sync

; Count down timer
schk6:	call	TimerPreroll
	mov	ah,11h			; Keyboard status
	int	16h
	jnz	schk7
	jmp	sync_check

schk7:	call	rdchar
schk8:	cmp	ax,offset Space_xcmd	; Check for abort
	jz	schk9
	jmp	sync_check
schk9:	mov	Abort_Flag,0ffh		; Show abort
	jmp	abort

schk10:	call	_edit_update
sync_check	endp

;================================================================
;	MONITOR LOCATIONS DURING EDIT / CHECK FOR Triggers
;================================================================
MonitorEdit	proc	near
	call	Tline_Monitor

	call	GetEditStatus
	cmp	al,EDITSTATUSIS_ABORTED
	JMP_Z	abort

	cmp	TL_Rout_Flag,0ffh
	jnz	mloc_1

; Motion control: get all the source outs
	test	Pmc_Flags,Enabled_MSBIT
	jnz	mlocam
	test	Spd_Flags,Enabled_MSBIT
	JMP_Z	mldone

mlocam:	mov	si,offset Multsync_Table
	mov	bp,offset Tags_Table
mlocmlp:mov	ch,[si]			; Get node
	or	ch,ch			; End of table?
	JMP_Z	mldone

	mov	cl,VX_PoundNum
	mov	ax,offset M_Binary_Status
	call	vtr_sendcmd
	mov	cl,6
	call	GetVlanRecord

	lodsb				; Get node number again, inc SI
	mov	di,bx			; Save pointer to time code
	call	get_vtr			; Get device number to AL
	mov	bx,di			; Restore pointer to time code

	dec	al			; Adjust for no record buffer in table
	cbw

	mov	di,bp			; Get Tags_Table address
	add	di,ax			; Index to the appropriate tags buffer
	add	di,ax			; (each is three bytes in length
	add	di,ax
	mov	ax,[bx]
	mov	ds:[di],ax
	mov	al,2[bx]
	mov	ds:2[di],al
	jmp	mlocmlp

;................................................................
mloc_1:	call	locations		; Display machine location
	call	TimerDisplay
	mov	ah,11h			; Check for Keyboard input
	int	16h
	JMP_Z	MonitorEdit			; JMP if NO KEYPRESS

; Process keypress
	call	rdwait			; Get keypress
mloc1a:	cmp	ax,offset Space_xcmd
	jnz	mloc_2
	mov	Abort_Flag,0ffh		; Show abort
	jmp	abort

mloc_2:	cmp	Vtr_Mult_Type,V_rev	; Don't get on-the-fly out
	jz	rcmd_1			;  if this is a review
	cmp	Vtr_Mult_Type,V_bvb	; Don't get on-the-fly out
	jz	rcmd_1			;  if this is a BVB
	cmp	Vtr_Mult_Type,V_roll	; Don't get on-the-fly out
	jz	rcmd_1			;  if this is a BVB
	cmp	ax,offset Record_xcmd	; Check ON-THE-FLY
	jz	mloc_3
	cmp	ax,offset Srchfwd_xcmd
	JMP_Z	sync_bump_plus
	cmp	ax,offset Srchrev_xcmd
	JMP_Z	sync_bump_minus
	jmp	rcmd_1

mloc_3:	call	SetRVT_Active
	mov	ax,offset M_onthefly		; Get on the fly
	call	motion

	mov	al,1			; Switch preview switcher back to R
	call	pswitch

	xor	al,al
	call	Machine_Change
	mov	bx,offset R_Tc.tcOUT
	call	MarkOut_Onthefly
	mov	dx,offset Rvtr_Out
	call	_mmv3byt
	call	TL_PVWout
	call	_Save_Marktable		; Save Ins, Outs, Durs...
;;	mov	Openend_Flag,0
	mov	TL_Rout_Flag,0ffh
	jmp	MonitorEdit

rcmd_1:	call	_all_machine_keys
	mov	Edit_Selected_Vtr,al	; Save selection

	JMP_NZ	rcmd_2

	cmp	Vtr_Mult_Type,V_rec	; Recording?
	jnz	rcmd_1nr		; 
	cmp	Assemble_Flag,0ffh	; Assembling?
	jz	rcmd_2rl

	test	Edit_Flags,realtime_EDBIT ; Allowed?
	jz	rcmd_2rl
	or	al,al			; RVTR?
	jz	rcmd_2rl
	cmp	al,RT_Vtr		; Same VTR as current?
	jz	rcmd_2rl

	mov	RT_Vtr,al		; Store switch-to vtr
	call	Machine_Change
	call	switch

	call	Tline_Monitor		; Monitor TIME LINE, Get R-VTR Location

;...9-08-1995 Since Tline_Monitor no longer returns the R-VTR location
;		(it returns the edit clock), get the record location.
	call	locate_record
;...
	mov	si,RT_Bufptr		; Is there
	cmp	si,offset RT_Bufend	;  any more room?
	jae	rcmd_1rl		;  Jump if not

	mov	ax,[bx]			; Save the out and the VTR
	mov	WORD PTR [SI].RTout, AX
	mov	al,[bx + 2]
	mov	BYTE PTR [SI+2].RTout, AL
	mov	al,RT_Vtr
	mov	BYTE PTR [SI].RTvtr, AL	; Save the CUT TO vtr
	add	si,4			; Increment to next buffer
	xor	ax,ax			; Terminate buffer
	mov	[si],ax
	mov	[si+2],al
	mov	RT_Bufptr,si		; Update buffer pointer
	inc	RT_Switches		; Increment number of switches

	call	_edit_update
	jmp	MonitorEdit

rcmd_1rl:
	call	_error_bell
rcmd_2rl:
	jmp	MonitorEdit

rcmd_1nr:
	cmp	al,MAX_SOURCES		; Only VTRs can bump
	JMP_A	MonitorEdit

	or	al,al			; RVTR?
	jz	rcmd_1a
	mov	ch,al			; Machine # to CH
	call	get_Vtrcb		; Returns CH = Node#
	or	ch,ch			; 3-22-1993 fixed "or al,al"
	JMP_Z	MonitorEdit			;  then jump outahere.

	call	syncbump_available
	JMP_C	MonitorEdit

rcmd_1a:mov	Syncbump_VTR,al
	call	_edit_update
	jmp	MonitorEdit

rcmd_2:	call	KeyCommand_Cmdtbl2
	JMP_NZ	MonitorEdit
	call	[si]
	call	_openend_update
	call	_edit_update
	jmp	MonitorEdit
MonitorEdit	endp

;................................................................
; Try to find this source vtr in the Multsync_Table
; Enter: CH is VTR to look for
syncbump_available:
	mov	si,offset Multsync_Table
rcmd_1l:mov	cl,[si]			; Get a node number from table
	or	cl,cl			; All done?
	jz	rcmd_1n
	cmp	cl,ch			; Look for a match
	jz	rcmd_1s			; Jump if a match
	inc	si
	jmp	rcmd_1l
rcmd_1n:stc
rcmd_1s:ret

;................................................................
sync_bump_plus:
	mov	cl,PLUS_ASCII
	jmp	sync_bump
sync_bump_minus:
	mov	cl,MINUS_ASCII
sync_bump:
	cmp	Vtr_Mult_Type,V_rec
	JMP_Z	rcmd_1

	mov	ch,Syncbump_VTR
	push	cx
	call	SetActiveVtr_CH			; Set to node
	pop	cx
	push	cx
	mov	ch,1
	mov	ax,offset M_sync_bump
	call	vtr_cmd
	pop	cx

	mov	bl,ch			; Get vtr
	mov	bh,0			; make word
	MULTIPLY_BY INOUTDUR_length, BX
	add	bx,offset Marks_Table	; Point to correct buffer
	mov	dx,offset Frm_Cnt
	cmp	cl,MINUS_ASCII
	jnz	syncb1
	call	_mpbsub
	jmp	syncb2
syncb1:	call	_mpbadd
syncb2:	call	_Save_Marktable		; Save Ins, Outs, Durs...
	call	_upd_getscr	
	jmp	rcmd_1

;================================================================
;			WAIT FOR DONE
;================================================================
; Record STATUS check
mldone	proc	near
	mov	Editout_Flag,0ffh
	mov	bx,offset Editstatus_Area
	call	_dircur_lerase
	cmp	Openend_Flag,0
	mov	Openend_Flag,0
	jz	mldonel
	call	_kbd_cln

mldonel:call	Tline_Monitor
	mov	ah,11h				; Check for Keyboard input
	int	16h
	jz	mlab1				; JMP if NO KEYPRESS
	call	rdwait				; Get keypress
mlab0:	cmp	ax,offset Space_xcmd
	jnz	mlab1
	jmp	abort

mlab1:	call	locations
	call	GetEditStatus			; Get edit status to AH
	cmp	al,EDITSTATUSIS_ABORTED
	jz	mldone1
	cmp	al,EDITSTATUSIS_DONE
	jnz	mldonel

mldone1:cmp	Assemble_Flag,0
	jz	mldone3
	call	saydone
	ret

mldone3:cmp	Vtr_Mult_Type,V_rec
	jnz	mldonex

	; add multiple switched events
	cmp	RT_Switches,0
	jz	mldone9

	mov	bx,offset realtimeok_ovr	; Is it ok?
	mov	cl,'Y'				; Default to YES
	call	pos_yn_chos			; Get response
	jnz	mldonex				; Bail out if refused
	call	_kbd_cln

	mov	bx,offset R_Tc.tcOUT		; Save the final
	mov	dx,offset RT_Finalout		;  edit outpoint
	call	_mmv3byt

;8-03-1994 
	mov	al,RT_Firstvtr
	call	Machine_Change
;...

public test
test:

; Add in the events
	mov	bx,offset RT_Buffer		; BX points to buffer
mldone4:call	_time_value			; See if done
	jz	mldone8				; Jump if done
	push	bx
	push	bx
	call	mldone_addevents
	call	add_event			; Add this event
	pop	bx
	mov	al,[bx].RTvtr
	call	Machine_Change
	pop	bx				; Restore pointer
	add	bx,4
	jmp	mldone4

mldone8:mov	bx,offset RT_Finalout		; Do the final edit
	call	mldone_addevents
mldone9:call	add_event

	test	EDLoptions_Flags,autdsabl_EDLBIT
	jz	ent_nad
	call	enables
	call	_evnt_dispthis
ent_nad:and	Gpi_Flags,not Enabled_MSBIT	; Turn off current GPI
	and	Pmc_Flags,not Enabled_MSBIT	; Turn off PMC
	and	Spd_Flags,not Enabled_MSBIT	; Turn off SPD
mldonex:call	saydone
	cmp	Vtr_Mult_Type,V_roll
	jnz	mldx1
	call	Erase_Timeline_Counter
	ret	

mldx1:	call	_chrwait
	ret
mldone	endp

Erase_Timeline_Counter:
	cmp	Vtr_Mult_Type,V_roll
	jnz	etcx
	mov	bx,offset 152eh
	mov	Cursor,bx
	call	_line_erase
	inc	bh
	mov	Cursor,bx
	call	_line_erase
	inc	bh
	mov	Cursor,bx
	call	_line_erase
	cmp	Abort_Flag,0ffh
	jnz	etcx
	call	_kbd_cln
etcx:	ret	


;................................................................
mldone_addevents:
	call	_Compensate_Real_Time
	mov	dx,offset R_Tc.tcOUT
	call	_mmv3byt
	xor	al,al				; Switch to the record vtr
	call	Machine_Change
	call	_computer
	ret
;................................................................

; ABORT the edit
abort	proc	near
	mov	ax,offset M_edit_abort		; Send edit abort to V-LAN
	call	motion

	cmp	Assemble_Flag,0ffh	; If an assemble abort, (3/90 nhs)
	jz	ret2vtr			;  don't restore the marktable

	mov	Openend_Flag,0

	cmp	Vtr_Mult_Type,V_roll
	jz	ret2vtr

	call	restore_edit_marks
	jmp	ret2vtr
abort	endp

saydone	proc	near
	mov	al,Vtr_Mult_Type
	cmp	al,V_roll
	jz	saydon2
	cmp	al,V_rec		; record?
	jz	saydon2
	cmp	al,V_rev		; review
	jz	saydon2

saydon1:call	restore_edit_marks	; Print msg at BX and reset marks

saydon2:call	GetEditStatus		; Get edit status to AH
	call	_DisplayEditStatus
saydone	endp


ret2vtr	proc	near
	call	clear_relays		; Clear out relays
;... 5-06-1996 Reset audio preset to black
	mov	ax,0
	call	apst_switch
;...

	call	_emclear
	call	wait_off

	cmp	Vtr_Mult_Type,V_rec
	jnz	ret2_nopreread

	cmp	Preread_State,0		; If preread is ON, turn if off
	jz	ret2_nopreread
	test	Edit_Flags,prdoff_EDBIT ; Turn preread off?
	jz	ret2_nopreread
	call	PC_preread_off
	call	PreRead			; Toggle it off

ret2_nopreread:
	call	all_locations
	call	_clear_Edit_Flags
	cmp	Assemble_Flag,0ffh	; If an assemble abort, (3/90 nhs)
	jz	ret2stx
	mov	al,Last_Machine
	call	Machine_Change
	call	switch
	call	vtr_e2e
	cmp	Vtr_Mult_Type,V_roll
	jnz	ret2stx
	call	Erase_Timeline_Counter
ret2stx:ret
ret2vtr	endp

;----------------------------------------------------------------
restore_edit_marks	proc	near
	call	error_restore_marks	; Restore marks if error
	call	Trans_Upd		; Does const, time, and GPI, too
	call	_mode_upd
	call	_evnt_dispthis
	call	Gpi_Upd
	CALL	Pmc_Upd
	CALL	Spd_Upd
	call	Preread_UPD
	call	ramp_upd
	call	_upd_getscr
	ret
restore_edit_marks	endp

;================================================================
; Restore mark table from error condition
error_restore_marks	proc	near
	cmp	Assemble_Flag,0		; Assemble in progress?
	jz	eresta
	call	_Restore_All_Marks
	jmp	erestb
eresta:	call	_Restore_Marktable
erestb:	ret
error_restore_marks	endp

;================================================================
;			CHECK FOR SYNC ERRORS
;================================================================
; RETURN: C=1 if any error
;	  AL has error
;	  AH has SIGN
;	  CH has NODE #
check4sync	proc	near
	mov	si,offset Multsync_Table - 1
	mov	ch,byte ptr Vtrcb	; Get record NODE address
	jmp	c4s_2

c4s_1:	mov	ch,[si]			; Get a node
	or	ch,ch
	jz	c4s_xit
c4s_2:	push	cx
	mov	ax,offset M_edit_error	; Request edit error for this node
	mov	cl,VX_PoundNum		; Append #node number
	call	vtr_cmd

	pop	cx
	mov	al,1[bx]		; Get tens
	and	al,0fh			; Strip ascii offset
	shl	al,1			; Multiply by 10
	mov	ah,al
	shl	al,1
	shl	al,1
	add	al,ah
	mov	ah,2[bx]		; Get units
	and	ah,0fh			; Same treatment
	add	al,ah			; Add the tens
	mov	ah,[bx]			; Get sign of error
	inc	si
	or	al,al
	jz	c4s_1
	stc
c4s_xit:ret
check4sync	endp


; Set node R (1) for upcoming command
SetRVT_Active	proc	near
	xor	ch,ch			; Select record machine
	jmp	SetActiveVtr_CH
SetRVT_Active	endp

; If node not R. switch it back to play node
SetCurrentMachineActive	proc	near
	mov	ch,Current_Machine
SetCurrentMachineActive	endp

; Switch to machine in CH
SetActiveVtr_CH	proc	near
	push	ax
	call	get_Vtrcb
	or	ch,ch
	jz	vtr_RPx
	mov	Current_Node,ch		; Save current node #
	mov	ax,offset M_node_address
	call	vtr_opt
vtr_RPx:pop	ax
vtr_RPr:ret
SetActiveVtr_CH	endp



;================================================================
;			TIME LINE
;================================================================
Tline_Monitor	proc	near
	xor	cx,cx
	mov	ax,offset M_Edit_Clock	;M_Binary_Status
	call	vtr_sendcmd
	mov	cl,4
	call	GetVlanRecord
	cmp	byte ptr [bx+2],0ffh
	jnz	TLM_2
	jmps	Tline_Monitor_again

TLM_2:	mov	si,offset Rvtr_Location
	mov	ax,[bx]
	mov	[si],ax
	mov	al,2[bx]
	mov	2[si],al

Tline_Monitor_again:
TLM_3:	mov	bx,offset Rvtr_Location	; Get location to
	mov	si,Tline_Pointer	; Get pointer to next time in line
	mov	ax,[si]			; Get first byte
	or	ax,ax			; End of list?
	jz	tlmx
	mov	cl,2[bx]		; Have we reached the point?
	cmp	cl,byte ptr [si].TLR_time + 2
	jc	tlmx
	mov	cx,[bx]
	cmp	cx,word ptr [si].TLR_time
	jc	tlmx
	add	Tline_Pointer,TLINE_size
	test	ax,TFlag_GPI
	jz	TLM_6
	jmp	GPI_trig

TLM_6:	test	ax,TFlag_ATRANS
	jz	TLM_8
	jmp	Trigger_If_Time

TLM_8:	test	ax,TFlag_INsplit
	jz	TLM_9
	jmp	TL_INsplit

TLM_9:	test	ax,TFlag_SYNC_IN
	jnz	TL_sync_in
	test	ax,TFlag_SYNC_OUT
	jnz	TL_sync_out
	test	ax,TFlag_RIN
	jnz	TL_rin
	test	ax,TFlag_PMC
	jnz	TL_pmc
	test	ax,TFlag_PVWin
	jnz	TL_PVWin
	test	ax,TFlag_PVWout
	jnz	TL_PVWout
	test	ax,TFlag_ROUT
	jnz	TL_Rout
	test	ax,TFlag_Beeper
	jnz	TL_Beeper
tlmx:	ret

;================================================================
TL_pmc:	ret

TL_Beeper:
	call	_hibeep
	jmp	Tline_Monitor_again

TL_sync_in:
	mov	TL_Sync_Flag_IN,0ffh
	ret

TL_sync_out:
	mov	TL_Sync_Flag_OUT,0ffh
	ret

TL_rin:	mov	Record_Flag,0ffh
	cmp	Vtr_Mult_Type,V_bvb
	jnz	tl_rin1
	mov	al,To_Machine
	call	switch
tl_rin1:mov	TL_Rin_Flag,0ffh
	jmp	Tline_Monitor_again

TL_Rout:mov	TL_Rout_Flag,0ffh
	ret

;================
TL_PVWin:
	cmp	Trans_Type,'S'		; Split?
	jz	tl_spvw
	call	tl_stdp
	jmp	Tline_Monitor_again

tl_spvw:mov	al,Preview_Mode		; Adjust for split mode
	push	ax
	mov	al,Split_Mode		; Has first half of split
	mov	Preview_Mode,al
	call	tl_stdp
	pop	ax
	mov	Preview_Mode,al
	jmp	Tline_Monitor_again

tl_stdp:mov	al,Vtr_Mult_Type
	cmp	al,V_pvw
	jz	PVIvvv
	cmp	al,V_bvb
	jz	PVIbvb
	cmp	al,V_vbv
	jz	PVIvbv
	ret

PVIvvv:
PVIvbv:	jmp	Tline_Monitor_again
PVIbvb:	mov	al,To_Machine
	call	switch
	jmp	Tline_Monitor_again

;================
TL_PVWout:
	mov	al,Vtr_Mult_Type
	cmp	al,V_pvw
	jz	PVOvvv
	cmp	al,V_bvb
	jz	PVObvb
	cmp	al,V_vbv
	jz	PVOvbv
	ret

PVOvvv:	jmp	Tline_Monitor_again
PVObvb:	mov	al,blk_dev
	jmp	switch
PVOvbv:	jmp	Tline_Monitor_again

;................................................................
; Execute GPI
GPI_trig:
	test	Gpi_Flags,Enabled_MSBIT
	jz	gpi_ret
	and	al,01111111b		;Mask out for GPI #
	mov	cl,al
	call	triggerit
gpi_ret:jmp	Tline_Monitor_again


TL_INsplit:
	cmp	Vtr_Mult_Type,V_bvb
	jz	TLins1
	mov	al,To_Machine
	jmp	switch
TLins1:	ret

Tline_Monitor	endp

;................................................................
; Execute Auto Transition
Trigger_If_Time	proc	near
	cmp	Autotrans_Flag,0ffh	; Press AUTOTRANS?
	jnz	tit1
	call	Trigger_Video
	call	Trigger_Audio
tit1:	test	Edit_Flags,realtime_EDBIT ; Allowed?
	jz	tit2
	mov	al,To_Machine
	mov	RT_Vtr,al
	call	_edit_update
tit2:	jmp	Tline_Monitor_again
Trigger_If_Time	endp

;................................................................
Trigger_Video	proc	near
	mov	ah,video_IOTYP
	test	Device_Enabled,ah		; Video enabled?
	jz	ttrigx

	mov	Active_IOTYP,ah
	call	_GetSXcb_Flags			; Get switcher Flags

	if ALLOW_VLAN3
	test	bx,SWbit_VLAN			; Check for VLAN switcher
	jz	tifnv
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	tifnvx
	test	VLAN_Flags, swextended_VLNBIT
	jnz	tifnv
tifnvx:	ret

tifnv:
	endif

	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jz	ttrign
	mov	al,To_Machine
	call	switch
	jmp	ttrigd

ttrign:	cmp	Trans_Length,0
	jz	ttrigc
	cmp	Trans_Type,'K'
	jnz	ttriga
	call	KEY_autotrans
	jmp	ttrigd
ttriga:	call	SW_autotrans			; Trigger w/ duration
	jmp	ttrigd

ttrigc:	call	SW_cut
ttrigd:	mov	Autotrans_Flag,0ffh
ttrigx:	ret
Trigger_Video	endp


;................................................................
Trigger_Audio	proc	near
	mov	ah,audio_IOTYP
	test	Device_Enabled,ah	; Video enabled?
	jz	ttaigx

	mov	Active_IOTYP,ah
	call	_GetSXcb_Flags		; Get switcher Flags

	test	bx,SWbit_GVG10XL	; Test for 10XL (NZ if so)
	jz	ttaign
	mov	al,To_Machine
	call	switch
	jmp	ttaigd

ttaign:	cmp	Trans_Length,0
	jz	ttaigf
	cmp	Trans_Type,'K'
	jnz	ttaige
	call	AS_over
	jmp	ttaigd
ttaige:	call	AS_trans
	jmp	ttaigd
ttaigf:	call	AS_cut
ttaigd:	mov	Autotrans_Flag,0ffh
ttaigx:	ret
Trigger_Audio	endp

;...



;================================================================
;
;		GENERAL VTR COMMAND ROUTINES
;
;================================================================
vtr_counter	proc	near
	test	Device_Present,vlan_IOTYP
	jz	cntrx

	mov	bx,offset location_rqst
	call	_Inout_init

	call	get_Vtrcb_FCM		; To AL
	mov	bx,offset Sttime	; Use Sttime for work area
 	call	tc_cimsg
	jc	cntrx
	call	_time_value
	jz	cntrx
	mov	ax,offset M_set_location
	call	vtr_sendloc
cntrx:	ret
vtr_counter	endp


;================================================================
stripe_tape:
	call	_help_pos
	call	_kbd_cln

	xor	al,al
	call	Machine_Change
	call	SetRVT_Active

	mov	bx,offset rewindit_ovr
	mov	cl,'Y'				; Default to YES
	call	pos_yn_chos			; Get response
	jnz	stp_rec


	call	rewind
	call	_kbd_cln
	blinkrev_VIDEO FALSE,FALSE
	mov	bx,offset rewinding_ovr
	call	_msgread
	call	_delsec
stp_watch:
	mov	ah,0bh			; Check for Break
	int	DOS
	call	all_locations		; Display all locations
	call	cstat
	cmp	ax,offset Space_xcmd
	jz	stp_xit

	mov	al,byte ptr Device_Stat_Tbl
	cmp	al,82h			; Check if R-VTR stopped
	jz	stp_rec
	cmp	al,87h			; Check if R-VTR stopped
	jz	stp_rec
	jmp	stp_watch

stp_rec:
	call	SetRVT_Active
	call	set_timecode_generator
	mov	ax,offset M_record
	call	motion

	call	_kbd_cln
	blinkrev_VIDEO FALSE,FALSE
	mov	bx,offset recording_ovr
	call	_msgread
	dim_VIDEO FALSE,FALSE
	call	rdchar
stp_xit:ret

;================================================================
set_timecode_generator:
	mov	ax,offset M_set_tcgen	; Send out
	mov	bx,offset Tcgen_Start	;  the starting number
	call	vtr_sendnd		;  for the tc generator

	mov	ax,offset M_set_gentctype	; Set the
	cmp	Tcgen_Mode,DF_CHAR	;  frame code mode
	mov	ch,1			; Prepare for DROP FRAME
	jz	stgok
	dec	ch			; Set for non drop
stgok:	call	vtr_opt
	ret

;================================================================
;		SEND A NULL LINE OUT TO VLAN
;================================================================
vtr_nul	proc	near
	xor	ax,ax			; No command
	mov	cx,VX_CR		; Send out null line
	call	vtr_sendcmd		; Send out a command
	jmp	vtr_answer
vtr_nul	endp

;================================================================
all_cue	proc	near
	test	Device_Present,vlan_IOTYP
	jz	alcuret
	call	VTR_Reset
	mov	al,Current_Source
	mov	ah,Current_Machine
	push	ax
	xor	al,al			; Start with record machine
alcue:	push	ax
	call	Machine_Change
	call	vtr_STAT		; Z=1 of offline or non-existent
	jz	alncu
	call	Set_In_From_Vtr_Loc
	pop	ax
	push	ax
	mov	ch,al
	call	SetActiveVtr_CH
	call	gotoin
alncu:	pop	ax
	inc	al			; Point to next machine
	cmp	al,MAX_MACHINES
	jnz	alcue			; Do for all VTRs
	pop	ax
	push	ax
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
	call	_upd_getscr
alcuret:ret
all_cue	endp


;================================================================
;		VTR PASS THROUGH COMMANDS
;================================================================
PreReadOnOff	proc	near
	cmp	Preread_Immediate,0
	jnz	proo1
	call	PC_preread_on
	jmp	proox
proo1:	call	PC_preread_off
proox:	not	Preread_Immediate
	call	Preread_UPD
	ret
PreReadOnOff	endp

PreRead	proc	near
	not	Preread_State
	call	Preread_UPD
	ret
PreRead	endp

PC_preread_local:
	mov	ch,0
	jmp short PCio

PC_preread_on:
	mov	ch,1
	jmp short PCio

PC_preread_off:
;;	cmp	Preread_State,0		; Is edit preread enabled?
;;	jnz	PC_preread_on
	mov	ch,2

PCio:	mov	ax, offset M_PreRead
	mov	cl,VX_ASCchVTRdl	; CMD + (ascii) ch + "#" + (vtr) dl
	mov	dl,r_dev
	call	vtr_cmd
	ret

;================================================================
;
;			VTR MOTION COMMANDS
;
;================================================================
pause	proc	near
	test	Network_Flags,pauseplay_NTBIT
	jz	pausestill
	mov	al,Current_Machine
	call	vtr_STAT		; Z=1 if offline or non-exist
	jz	pausx
	cmp	cl,82h		;Stop
	jz	play
	cmp	cl,87h		; Pause
	jz	play
pausestill:
	jmp	still
pausx:	ret
pause	endp

;================================================================
ExactSpeed	proc	near
	mov	ch,Current_Machine
	call	SetActiveVtr_CH

	call	_kbd_cln
	mov	bx,offset ExactSpeed_ovr
	call	_msgread

	mov	al,Current_Machine
	call	get_Vtrcb_pointer
	mov	si,bx

	or	Input_Flag,INFL_speed	; Speed +/- Request
	mov	bl,[bx].Vtrcb_EXACTSPEED
	xor	bh,bh
	call	_default_val

	mov	al,4
	call	dec_cimsg
	jc	ExactSpeedx

	mov	ch, byte ptr [si].Vtrcb_EXACTSPEED
	jz	ExactSpeedOld

	mov	cl,[bx]
	cmp	cl,PLUS_ASCII
	jnz	varip1
	inc	bx
	jmp	variplc

varip1:	cmp	cl,MINUS_ASCII
	jnz	variplc
	inc	bx

variplc:call	_convert2bin
	cmp	al,99
	jbe	varipld
	call	_error_bell
	jmp	ExactSpeed

varipld:mov	byte ptr [si].Vtrcb_EXACTSPEED, al
	mov	ch,al
ExactSpeedOld:
	mov	ax,offset M_var_play
	call	vtr_cmd
ExactSpeedx:
	ret
ExactSpeed	endp

;================================================================
eject_FAR	proc	far
	call	eject
	ret
eject_FAR	endp

;================================================================
eject	proc	near
	mov	ax,offset M_eject		;	EJECT
	jmp	motrst
eject	endp
stop	proc	near
	mov	ax,offset M_stop		;	STOP
	jmp	motrst
stop	endp
play	proc	near
	mov	ax,offset M_play		;	PLAY
	jmp	motrst
play	endp
fastfwd	proc	near
	mov	ax,offset M_fast_forward	;	FAST FORWARD
	jmp	motrst
fastfwd	endp
rewind	proc	near
	mov	ax,offset M_fast_rewind	;	FAST REWIND
	jmp	motrst
rewind	endp

bump_plus	proc	near
	mov	ax,offset M_jog_forward	;	JOG ONE FRAME
	jmp	SingleFrame
bump_plus	endp
bump_minus	proc	near
	mov	ax,offset M_jog_reverse	;	JOG ONE FRAME
	jmp	SingleFrame
bump_minus	endp

;================================================================
SingleFrame:
	push	ax			; Save jog command
	call	IndexToCurVtrControlBlock
	mov	al,0
	mov	ah,PLUS_ASCII
	mov	word ptr [bx].Vtrcb_SPD,ax
	mov	word ptr [bx].Vtrcb_VARISPD ,ax
	mov	word ptr [bx].Vtrcb_VSSSPD ,ax
	pop	ax
	jmp	motrst

;================================================================
cue	proc	near
	mov	al,Current_Machine
	call	vtr_STAT
	jz	cueret

	call	Machine_Change
;;<><>	call	WriteAllSpeeds
	call	_get_in
	jz	cuenew
	call	vtr_setin
;;	jmp	cueret

cuenew:	mov	ax,Slave_Flags		; FIX 6-21-1990
	push	ax
	and	Slave_Flags,not Enabled_MSBIT
	call	Mark_Inpoint
	pop	ax
	mov	Slave_Flags,ax
	call	_Save_Marktable		; Save Ins, Outs, Durs...
	call	_ReCompute_EFX
	call	_get_in
	mov	ax,offset M_cue
	call	motrst
cueret:	ret
cue	endp

;================================================================
motrst	proc	near
	test	Device_Present,vlan_IOTYP
	jz	motrstx
	push	ax
	call	VTR_Reset
	mov	al,Current_Machine
	call	vtr_STAT		; Z=1 if offline or non-exist
	pop	ax
	jz	motrstx
	jmp	motion
motrstx:ret
motrst	endp


;================================================================
reverse	proc	near
	mov	cl,MINUS_ASCII
	mov	ch,5
	jmp	scan
reverse	endp

;================================================================
twicefwd	proc	near
	mov	cl,PLUS_ASCII
	jmp	twice
twicefwd	endp
twicerev	proc	near
	mov	cl,MINUS_ASCII
twicerev	endp
twice	proc	near
	mov	ch,20
	call	HighResShuttle

	ret
twice	endp

slowfwd	proc	near
	mov	cl,PLUS_ASCII			; Slowest forward
	jmp	slow
slowfwd	endp
slowrev	proc	near
	mov	cl,MINUS_ASCII			; Slowest reverse
slowrev	endp
slow	proc	near
	mov	ch,3
	jmp	scan
slow	endp

;================================================================
shuttlefwd	proc	near		; Fast shuttle forward
	mov	cl,PLUS_ASCII
	jmp	vtr_shtl
shuttlefwd	endp
shuttleback	proc	near		; Fast shuttle reverse
	mov	cl,MINUS_ASCII
shuttleback	endp
vtr_shtl	proc	near
	mov	ch,9
vtr_shtl	endp

;================================================================
scan	proc	near
	test	Device_Present,vlan_IOTYP
	jz	scanxit
	push	cx
	mov	al,Current_Machine
	call	vtr_STAT
	pop	cx
	jz	scanxit

	call	IndexToCurVtrControlBlock
	mov	[bx].Vtrcb_VARISPD ,0
	mov	[bx].Vtrcb_VARIDIR ,PLUS_ASCII
	mov	[bx].Vtrcb_VSSSPD ,0
	mov	[bx].Vtrcb_VSSDIR ,PLUS_ASCII
	mov	[bx].Vtrcb_SPD ,ch	; Save speed for this machine
	mov	[bx].Vtrcb_DIR ,cl	; Save direction for this machine
	mov	ax,offset M_shuttle_speed
	call	vtr_cmd
scanxit:ret
scan	endp

HighResShuttle	proc	near
	test	Device_Present,vlan_IOTYP
	jz	HighResShuttlexit
	push	cx
	mov	al,Current_Machine
	call	vtr_STAT
	pop	cx
	jz	HighResShuttlexit

	push	cx
	mov	ch,Current_Machine
	call	SetActiveVtr_CH
	pop	cx

	call	IndexToCurVtrControlBlock
	mov	[bx].Vtrcb_VARISPD ,ch	; Save speed for this machine
	mov	[bx].Vtrcb_VARIDIR ,cl	; Save direction for this machine
	mov	[bx].Vtrcb_VSSSPD ,0
	mov	[bx].Vtrcb_VSSDIR ,PLUS_ASCII
	mov	[bx].Vtrcb_SPD ,0
	mov	[bx].Vtrcb_DIR ,PLUS_ASCII

	mov	ax,offset M_highres_shuttle
	call	vtr_cmd
HighResShuttlexit:
	ret
HighResShuttle	endp


;================================================================
; VARIABLE SPEED FORWARD AND REVERSE
srchfwd	proc	near

	call	IndexToCurVtrControlBlock
	mov	ch, [bx].Vtrcb_SPD	; Get last speed for this VTR
	mov	cl, [bx].Vtrcb_DIR	; Get last sign, too
	cmp	cl,MINUS_ASCII
	jnz	srf_1
	dec	ch			; If reverse then REDUCE REV SPD
	jmp	srf_2

srf_1:	inc	ch			; INCREASE FWD SPEED
srf_2:	jnz	srfr_7			; Jump if not 0
	inc	ch			; If 0, go in other direction
	mov	cl,PLUS_ASCII			; Set Forward direction
	jmp	srfr_7
srchfwd	endp

srchrev	proc	near
	call	IndexToCurVtrControlBlock
	mov	ch, [bx].Vtrcb_SPD	; Get last speed for this VTR
	mov	cl, [bx].Vtrcb_DIR	; Get last sign, too

	cmp	cl,PLUS_ASCII
	jnz	srr_1
	or	ch,ch
	jz	srr_0
	dec	ch			; If FORWARD then REDUCE FWD SPD
	jmp	srr_2

srr_0:	mov	cl,MINUS_ASCII
srr_1:	inc	ch			; INCREASE REV SPEED
srr_2:	jnz	srfr_7			; Jump if not 0
	inc	ch			; If 0, go in other direction
	mov	cl,MINUS_ASCII			; Set REVERSE direction

srfr_7:	cmp	ch,10
	jb	sfr_8
	mov	ch,9
sfr_8:	jmp	scan
srchrev	endp

;================================================================
varifwd	proc	near
	call	IndexToCurVtrControlBlock
	cmp	[bx].Vtrcb_VARIDIR,MINUS_ASCII
	jnz	varifwdg
	cmp	[bx].Vtrcb_VARISPD, 1
	jnz	varifwdg
	dec	[bx].Vtrcb_VARISPD
varifwdg:
	mov	al,1
	call	VSS_fwd
	ret
varifwd	endp
;================================================================
varirev	proc	near
	call	IndexToCurVtrControlBlock
	cmp	[bx].Vtrcb_VARIDIR,PLUS_ASCII
	jnz	varirevg
	cmp	[bx].Vtrcb_VARISPD, 1
	jnz	varirevg
	dec	[bx].Vtrcb_VARISPD
varirevg:
	mov	al,1
	call	VSS_rev
	ret
varirev	endp

;================================================================
;================================================================
; VARIABLE SPEED SHUTTLE COMMAND "VS"
VSS_fwd	proc	near
	call	IndexToCurVtrControlBlock
	mov	ch, [bx].Vtrcb_VSSSPD	; Get last speed for this VTR
	mov	cl, [bx].Vtrcb_VSSDIR	; Get last sign, too
	cmp	cl,MINUS_ASCII
	jnz	vssf_1

; Set motion slower or reverse
	or	ch,ch
	jnz	vssf_0
	mov	cl,PLUS_ASCII
	jmp	vssf_1
vssf_0:	sub	ch,al			; REDUCE REV SPD
	jnc	VSSrr_2
	mov	ch,0
	jmp	VSSrr_2

vssf_1:	add	ch,al			; INCREASE FWD SPEED
	jmp	VSSrr_2
VSS_fwd	endp

VSS_rev	proc	near
	call	IndexToCurVtrControlBlock
	mov	ch, [bx].Vtrcb_VSSSPD	; Get last speed for this VTR
	mov	cl, [bx].Vtrcb_VSSDIR	; Get last sign, too
	cmp	cl,PLUS_ASCII
	jnz	VSSrr_1

; Set motion slower or reverse
	or	ch,ch
	jnz	vssrr_0
	mov	cl,MINUS_ASCII
	jmp	VSSrr_1

vssrr_0:sub	ch,al			; If FORWARD then REDUCE FWD SPD
	jnc	VSSrr_2
	mov	ch,0
	jmp	VSSrr_2

VSSrr_1:add	ch,al			; INCREASE REV SPEED

VSSrr_2:cmp	ch,31
	jbe	VSSr_8

	mov	al,8			; Base fast shuttle ops on 7
	cmp	ch,32
	jbe	VSSrr_3
	inc	al
	mov	ch,33

VSSrr_3:mov	[bx].Vtrcb_VSSSPD ,ch	; Save speed for this machine
	mov	[bx].Vtrcb_VSSDIR ,cl	; Save direction for this machine
	mov	[bx].Vtrcb_SPD ,al	; Save speed for this machine
	mov	[bx].Vtrcb_DIR ,cl	; Save direction for this machine
	mov	ch,al
	mov	ax,offset M_shuttle_speed
	call	vtr_cmd
	ret

VSSr_8:	call	VariShuttle
	ret
VSS_rev	endp

; Variable Shuttle "VS" command
VariShuttle	proc	near
	test	Device_Present,vlan_IOTYP
	jz	VariShuttlexit
	push	cx
	mov	al,Current_Machine
	call	vtr_STAT
	pop	cx
	jz	VariShuttlexit

	push	cx
	mov	ch,Current_Machine
	call	SetActiveVtr_CH
	pop	cx

	call	IndexToCurVtrControlBlock

	mov	[bx].Vtrcb_VARISPD ,0
	mov	[bx].Vtrcb_VARIDIR ,PLUS_ASCII
	mov	[bx].Vtrcb_VSSSPD ,ch	; Save speed for this machine
	mov	[bx].Vtrcb_VSSDIR ,cl	; Save direction for this machine
	mov	[bx].Vtrcb_SPD ,0
	mov	[bx].Vtrcb_DIR ,PLUS_ASCII

	or	ch,ch
	jnz	VarShtl

	cmp	JogCmdAvailable, 2	; Number of jogger bytes read
	jz	VariShuttlexit

	call	still
	ret

VarShtl:mov	ax,offset M_var_shttl
	call	vtr_cmd
VariShuttlexit:
	ret
VariShuttle	endp


;----------------------------------------------------------------
; ALL VTR STOP
all_stop	proc	near
	test	Device_Present,vlan_IOTYP
	jz	allstpr
	xor	al,al			; Start with record machine
	mov	si,offset Vtrcb.Vtrcb_SPD
alstl:	mov	word ptr [si],0		; Clear out speed
	add	si,Vtrcb_length
	mov	ch,al
	call	SetActiveVtr_CH
	push	ax
	mov	ax,offset M_stop
	call	motion
	pop	ax			; Restore node #
	inc	al			; Point to next machine
	cmp	al,MAX_MACHINES
	jnz	alstl			; Do for all VTRs
	call	VTR_Reset
allstpr:ret
all_stop	endp

; ALL VTR STILL
all_still	proc	near
	test	Device_Present,vlan_IOTYP
	jz	alstlr
	mov	cx,MAX_MACHINES		; Machines to do

	xor	al,al			; Start with record machine
alstp:	push	ax
	mov	ch,al
	call	SetActiveVtr_CH
	call	vtr_STAT		; Z=1 if offline or non-exist
	jz	alstp1

;;;; Taken out for Atlantic Post
;;;;	cmp	cl,87h			; Deck is already paused?
;;;;	jz	alstp1

	mov	ax,offset M_shuttle_speed
	xor	ch,ch
	call	vtr_opt
alstp1:	pop	ax
	inc	al			; Point to next machine
	cmp	al,MAX_MACHINES
	jnz	alstp			; Do for all VTRs
	call	VTR_Reset
alstlr:	ret
all_still	endp

; STILL CURRENT MACHINE
still	proc	near
	call	vtr_still
	call	VTR_Reset
	ret
still	endp

;================================================================
; STILL RECORD AND PLAYBACK
; NOTE: This alters Current_Machine
; FIXED 5-11-1990 NHS to do ALL machines involved in edit
playrec_still	proc	near
	mov	bx,offset Multsync_Table
	mov	ch,byte ptr Vtrcb.Vtrcb_PORT ; Do record VTR first
	jmp	plstil2

plstil1:mov	ch,[bx]			; Get a node from Multsync_Table
	or	ch,ch			; Check for end of table
	jz	plrstlx			; Jump if end of table
	inc	bx			; Increment pointer in table
plstil2:call	plrcstl			; Still the VTR
	jmp	plstil1			; Loop for another

plstil3:call	plrcstl
	mov	ax,offset M_ee_off	; Turn E2E off in R-VTR
	jmp	motion

;Select node in CH, still VTR
plrcstl:push	bx
	mov	ax,offset M_node_address	; Select NODE in CH
	call	vtr_opt
	mov	ax,offset M_shuttle_speed	; Still NODE
	xor	ch,ch
	call	vtr_opt
	pop	bx
plrstlx:ret
playrec_still	endp

;................................................................
; STILL VTR
;ENTER:	nothing
;Exit:	[Current_Machine] is stilled
vtr_still	proc	near
	test	Device_Present,vlan_IOTYP
	jz	vtr_stx
	mov	al,Current_Machine
	call	vtr_STAT		; Z=1 if offline or non-exist
	jz	vtr_stx
	mov	ax,offset M_shuttle_speed
	xor	ch,ch
	jmp	vtr_opt
vtr_stx:ret
vtr_still	endp

; GOTO IN POINT
gotoin	proc	near
	call	_get_in
	jmp	gotoio
gotoin	endp

; GOTO OUT POINT
gotoout	proc	near
	call	_get_out
gotoio:	jz	gotoior
	mov	ax,offset M_goto_location
	call	vtr_sendloc
gotoior:ret
gotoout	endp


;================================================================
;	SET VTR LOCATION REGISTER
;================================================================
vtr_location	proc	near
	test	Device_Present,vlan_IOTYP
	jnz	search
	ret
vtr_location	endp

;================================================================
;	SEARCH TO TIME CODE
;================================================================
search	proc	near
	test	Device_Present,vlan_IOTYP
	jz	searchx

	mov	Trim_Ci_Flag,0

	call	_kbd_cln
	mov	al,Current_Machine
	call	_machine_disp
	call	_Space_Out
	mov	bx,offset goto_ovr
	call	_msgread

	call	get_Vtrcb_FCM		; To AL

	mov	bx,offset Sttime	; Use Sttime for work area
 	call	tc_cimsg
	jc	searchx
	call	_time_value
	jz	searchx

	push	bx
	mov	al,Current_Machine
	call	vtr_STAT
	pop	bx
	jz	searchx
	mov	ax,offset M_goto_location
	call	vtr_sendloc
	call	_evnt_dispthis
searchx:ret
search	endp

;================================================================
;
;	     SPECIAL COMMANDS TO AND FROM VLAN NETWORK
;
;================================================================

; Set VTR Preroll
vtr_Preroll	proc	near
	mov	ax,offset M_preroll_set
	call	set_vtrcmd

	call	_Get_PrerollToBX
;;	mov	bx,offset Preroll
	jmp	PrePostSet
vtr_Preroll	endp

; Set VTR Postroll
vtr_Postroll	proc	near
	mov	ax,offset M_postroll_set
	call	set_vtrcmd
	mov	bx,offset Postroll
	jmp	PrePostSet
vtr_Postroll	endp

record_Postroll	proc	near
	mov	ax,offset M_postroll_set	; NEW (FIX) 6-21-1990
	call	set_vtrcmd
	mov	bx,offset Recordpost
	jmp	PrePostSet
record_Postroll	endp

PrePostSet	proc	near
	mov	cl,DF_CHAR
	call	vtr_sl1
	ret
PrePostSet	endp

switch_tc	proc	near
	call	get_Vtrcb_TCM		; To AL
	or	al,al
	jz	swtcset
	mov	byte ptr [bx],0
	jmp	swtcclr
swtcset:mov	byte ptr [bx],1
swtcclr:mov	ax,offset M_code_mode
	mov	ch,[bx]
	call	vtr_opt
	ret
switch_tc	endp

;================================================================
;			SET INSERT MODE
;================================================================
; Send mode information to record vtr (V12A)
vtr_mode	proc	near
	test	Device_Present,vlan_IOTYP
	jz	vtr_moderet

	push	si
	mov	si,offset Multrecord_Table
	mov	ch,0			; Start with RECORD VTR
	jmp	vtr_mode1

vtr_moderet:
	ret

vtr_modelp:
	mov	ch,[si]			; Get next DEVICE
	inc	si
	cmp	ch,0ffh			; End of buffer
	jz	vtr_mode_x		; Leave if so

vtr_mode1:
	mov	cl,VX_DeviceCH		; Change CH to NODE#
	mov	ax,offset M_node_address
	call	vtr_cmd			; Select Node

	mov	ax,offset M_track_select
	cmp	Hardrecord_Flag,0ffh	; Hard record?
	jnz	vtrmod1
	call	set_vtrcmd		; Set the command prefix to buffer
	mov	al,'A'
	call	vtr_cstore
	xor	ax,ax
	call	vtr_cstore
	call	vcmsg
	call	vtr_modeagain
	jmp	vtr_modelp

vtr_mode_x:
	pop	si
	call	SetCurrentMachineActive
	ret

vtrmod1:cmp	Trans_Type,'S'
	jnz	vtrmod2
	call	_check_mode			; We need video AND audio
	call	Setup_SplitEdit			; Setup the split times
	jmp	vtr_modelp

vtrmod2:mov	cl,Mode_Flag
	call	vtr_tracks
	jmp	vtr_modelp

vtr_mode	endp

; Enter with CL = mode byte
vtr_tracks	proc	near
	call	set_vtrcmd		; Set command prefix
	mov	al,'V'
	mov	ch,video_Emode
	call	vtr_tmod
	mov	al,'4'
	mov	ch,aud4_Emode
	call	vtr_tmod
	mov	al,'3'
	mov	ch,aud3_Emode
	call	vtr_tmod
	mov	al,'2'
	mov	ch,aud2_Emode
	call	vtr_tmod
	mov	al,'1'
	mov	ch,aud1_Emode
	call	vtr_tmod

;2-10-1995 Select cue track, if necessary
	test	Edit_Flags, cuetrack_EDBIT
	jz	vttrknc
	mov	al,cl
	and	al,audall_Emode
	or	al,al
	jz	vttrknc
	mov	al,'5'
	call	vtr_cstore
;...
vttrknc:call	vtrcmdx
vtr_modeagain:
	call	vtr_answer
	ret

vtr_tracks	endp

vtr_tmod	proc	near
	mov	ah,cl
	and	ah,ch
	test	ah,ch
	jnz	vtr_cstore
	ret
vtr_tmod	endp

; Append msg pointed to by BX to the Temp_Tc_Buf
; First message byte is length of string (length byte is not moved)
vtr_msgstorecl	proc	near
	push	cx
	jmp	vtrmslp
vtr_msgstorecl	endp

vtr_msgstore	proc	near
	push	cx
	mov	cl,[bx]
vtrmslp:mov	al,[bx]
	call	vtr_cstore
	inc	bx
	dec	cl
	jnz	vtrmslp
	pop	cx
	ret
vtr_msgstore	endp

vtr_cstore	proc	near
	push	bx
	mov	bx,Temp_Tc_Buf
	mov	[bx],al
	inc	Temp_Tc_Buf
	pop	bx
	ret
vtr_cstore	endp

;================================================================
; TOGGLE EVENT ENABLE/DISABLE

all_enable	proc	near
	xor	dx,dx
	mov	di,offset setmrks_ovr
	jmp	allenab
all_enable	endp

all_disable	proc	near
	mov	dx, sort_Fmask OR disabled_Fmask	;10000001b
	mov	di,offset clrmrks_ovr
allenab:call	_check4edl
	JMP_Z	alenxit
alen1:	mov	bx,di			; Get message address
	call	_kbd_cln
	call	_msgread
	call	rdchar
	call	_Break_check
	jz	alenxit
	mov	enabletype,0ffh			; Set to enable all
	cmp	ax,offset Record_xcmd
	jz	alen2
	mov	enabletype,0			; Set for CLEAR MARKS only
	cmp	ax,offset Thisevent_xcmd
	jz	alen2
	call	keythru
	call	_error_bell
	jmp	alen1

alen2:	call	_savebin
	mov	ax,es:Current_Event
	push	ax
	mov	cx,1
alen3:	mov	ax,cx
	call	_index_storage
	jc	alen5
	add	bx,offset ZeroBase.Flags_lofst		; Point BX to edit Flags
	cmp	enabletype,0
	jz	alen4
	and	dx, disabled_Fmask
	and	es:word ptr [bx], NOT disabled_Fmask
	or	es:word ptr [bx],dx
	jmp	alen5
alen4:	and	dx,sort_Fmask
	and	es:word ptr [bx],not sort_Fmask
	or	es:word ptr [bx],dx
alen5:	inc	cx
	cmp	cx,es:Next_Avail_Num
	jnz	alen3
allenax:pop	ax
	call	_EDL_display
alenxit:ret
all_disable	endp

enable_toggle	proc	near
	call	enables
	call	_EDL_display
	ret
enable_toggle	endp

enables	proc	near
	mov	ax,es:Current_Event
	call	_index_storage
	jc	enabx			; Just return if comment
	push	bx
	push	ax
	call	enabt
	pop	ax
	pop	bx
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	enabx
	push	ax
	inc	ax
	call	_index_storage
	call	enabt
	pop	ax
enabx:	ret

enabt:	add	bx,offset ZeroBase.Flags_lofst
	test	es:word ptr [bx], disabled_Fmask	; Test for disabled
	jz	disable			; If bit=0, set it
enable:	and	es:word ptr [bx], NOT disabled_Fmask
	mov	ax,es:Current_Event
	call	_EDL_display
	ret
disable:or	es:word ptr [bx], disabled_Fmask
	ret
enables	endp

;================================================================
wait_on	proc	near
	mov	ax,offset M_wait_on
	jmp	motion
wait_on	endp
;================================================================
wait_off	proc	near
	mov	ax,offset M_wait_off
	jmp	motion
wait_off	endp
;================================================================
wait_go	proc	near
	mov	ax,offset M_wait_go
	jmp	motion
wait_go	endp

;================================================================
;	INITIATE ALL MACHINE POINTERS, CLEAR NODES
;================================================================
machine_init_FAR	proc	far
	call	machine_init
	ret
machine_init_FAR	endp

machine_init	proc	near
	test	Device_Present,vlan_IOTYP
	jz	sinilx

	xor	al,al
	mov	di,offset Device_Stat_Tbl + aux_dev
sinitlp:push	ax			; Initiate pointers for
	call	Machine_Change		; All playback machines
	push	ax
	dec	di

	cbw
	MULTIPLY_BY Vtrcb_length, AX
	mov	si,offset Vtrcb
	add	si,ax
	pop	ax
	call	vtr_STAT
	mov	ds:[di],cl
	jnz	sinitl1

	test	Device_Enabled,vlan_IOTYP
	jz	sinitl2
	mov	byte ptr [ si.Vtrcb_PORT ],0		; Zero out unused Port
	jmp	sinitl2

sinitl1:mov	dl,NDF_CHAR
	cmp	byte ptr 9[bx],'.'
	jnz	sinila
	mov	dl,DF_CHAR
sinila:	mov	[si.Vtrcb_FCM],dl
	push	si			; Save Vtrcb address
	call	clear_node
	call	set_tctype		; Set the time code type
	call	get_minmaxspeeds	; CL = maxfwd, CH = maxrev
	pop	si			; Restore Vtrcb address
	mov	byte ptr [si.Vtrcb_MAXFWDSPD], cl
	mov	byte ptr [si.Vtrcb_MAXREVSPD], ch
;;	call	PC_preread_local
sinitl2:pop	ax
	inc	al
	cmp	al,MAX_MACHINES
	jb	sinitlp

	call	chk4relaybox

	mov	ax,offset M_gpi_off		; Turn the GPI trigger off
	call	motion

sinitx:	mov	al,Rtcf
	mov	Blktcf,al
	mov	Auxtcf,al
	cmp	Fullscreen_Flag,0ffh
	jz	sinilx
	call	all_locations
sinilx:	ret
machine_init	endp

;================================================================
; SET VTR IN POINT TO 24 BIT TC NUM LOCATED AT BX, BX+1, BX+2
vtr_SetRollBegin	proc	near
	mov	ax,offset M_roll_begin
	jmp	vsetin
vtr_SetRollBegin	endp

vtr_setin	proc	near
	mov	ax,offset M_set_in
vsetin:	push	ax
	cmp	Current_Machine,0	; 6-22-1990 SKIP RECORD VTR
	jz	vsetin1
	call	_ColorFrame_Compensate	; 2-02-1992 PAL/NTSC ColorFraming
vsetin1:pop	ax			; Restore VLAN command
	call	vtr_sendloc
	ret
vtr_setin	endp

;----------------------------------------------------------------
; SET VTR OUT POINT TO 24 BIT TC NUM LOCATED AT BX, BX+1, BX+2
vtr_setout	proc	near
	mov	ax,offset M_set_out
	jmp	vtr_sendloc
vtr_setout	endp

vtr_setdur	proc	near
	mov	ax,offset M_set_duration
	jmp	vtr_sendloc
vtr_setdur	endp

; Set sync reference to record machine
sync2rec	proc	near
	mov	ch,Editsync
	jmp	ssync
sync2rec	endp

; Set sync to 1, 2, or 3
; 0 locks sources to recorder
; 1 is for Ampex 1" machines, only
; 2 uses the source as the edit sync reference
setsync	proc	near
	test	Device_Present,vlan_IOTYP
	jz	ssyncr

	mov	bx,offset edsyncmsg_ovr
	call	_msgread

	call	_kbd_cln
	mov	bx,offset Editsync_ovr
	call	_msgread
	mov	bl,Editsync
	inc	bl
	xor	bh,bh
	call	_default_val

	mov	al,1
	call	dec_cimsg
	jnz	nsync
	ret
nsync:	call	_convert2bin
	or	dl,dl
	jnz	ssync1
sser:	mov	al,7
	call	_ConOut
	jmp	setsync

ssync1:	cmp	dl,4
	jnc	sser
	mov	ch,dl
	dec	ch
ssync:	mov	Editsync,ch
	mov	ax,offset M_edit_sync
	call	vtr_opt
ssyncr:	ret
setsync	endp

;================================================================
;
;			ASSEMBLE EDITING
;
;================================================================

; ASSEMBLE CURRENT EVENT
assemble_this	proc	near
	test	Device_Present,vlan_IOTYP
	jz	asmthisr
	mov	al,Current_Machine	; Save the present
	mov	Last_Machine,al		;  current machine number
	call	_Save_All_Marks
	call	ClearAll_gpis
	and	Slave_Flags,not Enabled_MSBIT
	and	Gpi_Flags,not Enabled_MSBIT	; Turn off current GPI
	mov	Assemble_Flag,0ffh
	call	asmmsg
	mov	ax,es:Current_Event
	call	_line_first		; Get the first line of the edit
	cmp	es:byte ptr [bx].cmnt_lofst,0ffh
	jc	asmthisr
	mov	Last_Assembled,ax	; Save last assembled event num
	push	bx			; Save event address
	call	_matchforcedrecall
	jnc	asmths0
	pop	bx
	ERROR	no_reel_match, ERET_Return
	jmp	asmbx

asmthisr:
	ret

asmths0:call	event_recall		; Get event from list
	cmp	ERROR_ACTIVE,0
	jz	asmths0a
	jmp	Keyboard
asmths0a:
	call	asm_record		; Make the edit
	pop	bx			; Restore event address
	cmp	Abort_Flag,0ffh		; Check for hard abort
	jnz	asmths1
	jmp	asmbx
asmths1:and	es:word ptr [bx].Flags_lofst, NOT disabled_Fmask ;Set Enabled
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	asmths2
	and	es:word ptr line_length [bx].Flags_lofst, NOT disabled_Fmask
asmths2:call	enables			;  then toggle it to disabled
	jmp	asmbx
assemble_this	endp

;================================================================
; AUTO-ASSEMBLE
assemble	proc	near
	test	Device_Present,vlan_IOTYP
	JMP_Z	asmret

	call	_check4edl
	jz	asmret

	mov	al,Current_Machine	; Save the present
	mov	Last_Machine,al		;  current machine number
	call	_Save_All_Marks
	call	ClearAll_gpis
	and	Gpi_Flags,not Enabled_MSBIT	; Turn off current GPI
	and	Slave_Flags,not Enabled_MSBIT
	xor	al,al
	mov	Mkdasm_Flag,al
	dec	al
	mov	Assemble_Flag,al

	mov	bx,offset Page_Qry
	call	_kbd_message
	push	Cursor
	mov	bx,SpacePointer(6)
	call	_comsg
	mov	bx,offset autoasminf_ovr
	call	_msgread
	pop	Cursor

	mov	al,4
	call	dec_cimsg
	jc	asmret
	jz	asmft			; Start from top if null
	cmp	ax,offset Thisevent_xcmd
	jnz	asmnoth
	mov	ax,es:Current_Event
	jmp	asmft01

asmnoth:call	_convert2bin
	mov	bx,ax
	call	_find_edit_BX
	jz	asmft01
	ERROR	out_of_range, ERET_Keyboard

asmret:	ret

asmft:	mov	ax,1			; Set to start from top
	call	_index_storage

asmft01:push	ax			; Save start event number
	call	_check4marked		; Any marked edits?
	jc	asmft02
	pop	ax
	jmp	asmbllp

asmft02:mov	bx,offset mkdasm_ovr	; Prompt for Marked edits
	call	no_chos_msg		; Default to NO
	pop	ax			; Restore starting event number
	jnz	asmbllp			; Bail out if NOT to
	mov	Mkdasm_Flag,0ffh	;  assemble marked edits.

asmbllp:cmp	ax,es:Next_Avail_Num	; Any more lines to do?
	jc	asmfta
	jmp	asmbx

asmfta:	push	ax			; Save event line number
	call	cstat			; Check for operator Break
	jnz	asmftb
	pop	ax
	jmp	asmftc
asmftb:	call	_Break_check
	pop	ax
	jnz	asmftc
	jmp	asmbx
asmftc:	call	asmmsg			; Display ASSEMBLE message

	call	_index_storage
	JMP_C	asmbskp			; Skip if comment

	FLAGBITS disabled_Fmask		; Check disabled Flag
	JMP_NZ	asmbskp			; Skip if disabled

	cmp	Mkdasm_Flag,0ffh	; Doing only marked edits?
	jnz	asmft0			; Jump if NOT
	FLAGBITS sort_Fmask		; Check for marked edit
	jz	asmbskp

asmft0:	push	ax			; Save event
	push	bx			; Save event address
	call	_matchforcedrecall
	jnc	asmft1
	pop	bx
	pop	ax
	cmp	Assembly_Mode,'A'	; Error if A mode
	jz	asmft0e
	jmp	asmbskp			; Skip edit if A mode

; Reel Not Found error
asmft0e:
	mov	Abort_Flag,0ffh		; Signal abort
	mov	Last_Assembled,ax	; Park it on error event
	call	_event_display
	ERROR	no_reel_match, ERET_Return
	jmp	asmbx
;..[bx].
asmft1:	call	_evnt_dispthis
	call	event_recall		; Get event from list
asmft1a:call	_evnt_dispthis

	call	LookAheadAndCueVtrs

	call	asm_record		; Make the edit

	pop	bx			; Restore event address
	pop	ax
	cmp	Abort_Flag,0ffh		; Check for an abort
	jz	asmbx			; Abort

	mov	Last_Assembled,ax	; Save last assembled edit
	and	es:word ptr [bx].Flags_lofst, NOT disabled_Fmask ;Set Enabled
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	asmft2
	and	es:word ptr line_length [bx].Flags_lofst, NOT disabled_Fmask
asmft2:	call	enables			;  then toggle it to disabled
	mov	ax,Last_Assembled

; Index to the next edit to be assembled
; ENTER: AX has the just assembled event
asmbskp:call	_index_storage		; Index BX to es:event
	FLAGBITS dblline_Fmask		; Check for double line
	jz	asmbsk1			; If not, just inc event by 1
	inc	ax			; If so, inc event by 2
asmbsk1:inc	ax
	cmp	ax,es:Next_Avail_Num	; Out of list?
	jnc	asmbx
	call	_index_storage
	jc	asmbsk1
	jmp	asmbllp			;  and do more edits

asmbx:	mov	ax,Last_Assembled
	call	_index_storage
	call	_evnt_dispthis
	mov	bx,offset Keyboard_Scr		; Display " ASSEMBLE "
	call	_dircur_lerase
	rev_VIDEO FALSE,FALSE
	mov	bx,offset Assembly_Msg
	call	_comsg
	cmp	Abort_Flag,0ffh
	jnz	asmbx1
	mov	bx,offset Asmaborted_Msg
	jmp	asmbx2
asmbx1:	mov	bx,offset Asmcomplete_Msg
asmbx2:	call	_comsg
	mov	Assemble_Flag,0
	norm_VIDEO FALSE,FALSE
	call	_Restore_All_Marks

	call	Trans_Upd		; Does const, time, and GPI, too
	call	_mode_upd
	call	_evnt_dispthis
	call	_upd_getscr
	call	_time_upd
	call	Gpi_Upd
	CALL	Pmc_Upd
	CALL	Spd_Upd
	call	Preread_UPD
	call	ramp_upd

	mov	al,Last_Machine
	call	Machine_Change
	call	switch
	call	vtr_e2e
	call	_chrwait
	ret
assemble	endp

;================================================================
; ASMMSG
; Displays ASSEMBLE in reverse video (if assemble Flag is TRUE)
; BX used
asmmsg	proc	near
	cmp	Assemble_Flag,0ffh
	jnz	asmmsgx
	push	ax				; Save whatever is in AX
	mov	bx,offset Keyboard_Scr		; Display " ASSEMBLE "
	call	_dircur_lerase
	rev_VIDEO FALSE,FALSE
	mov	bx,offset Assemble_Msg
	call	_comsg
	norm_VIDEO FALSE,FALSE
	pop	ax
asmmsgx:ret
asmmsg	endp


;================================================================
LookAheadAndCueVtrs	proc	near
; Clear out the Vtr_Searchto_Table
	test	Operational_Flags,lookahead_OPBIT
	JMP_Z	lac_xit

	push	es
	push	ds
	pop	es
	mov	cx, MAX_MACHINES * 3
	mov	di, offset Vtr_Searchto_Table
	xor	al,al
	cld
	rep stosb
	pop	es

; Loop for events
	mov	Lookahead_Counter,0	; Clear a loop counter
	mov	ax,es:Current_Event	; Get current event
	push	ax			; Save current event for return
laaincev:
	inc	ax			; Increment to next
	cmp	ax,es:Next_Avail_Num	; No more?
	JMP_AE	lac_nomore
	call	_index_storage		; Get Edit
	jc	laaincev
	FLAGBITS dblline_Fmask		; Skip second lines
	jnz	laaincev

	; Check for no more to do...
	mov	bx, Lookahead_Counter
	inc	bx
	cmp	bx, Edits_To_Look_Ahead
	JMP_A	lac_nomore
	mov	Lookahead_Counter, bx

	;Look for the reel match
	;Return with Z set (Z=1) if match, and CL = machine of match
	push	ax
	call	_match_reels
	pop	ax
	jnz	laaincev

	mov	bl,Trans_Type
	cmp	bl,'D'
	jz	laadis
	cmp	bl,'W'
	jz	laadis
	cmp	bl,'K'
	jz	laakey

	cmp	cl, To_Machine
	jz	laaincev
	jmp	laapt
laadis:	cmp	cl, From_Machine
	jz	laaincev
	cmp	cl, To_Machine
	jz	laaincev
	jmp	laapt
laakey:	cmp	cl, Keyfor_Src
	jz	laaincev
	cmp	cl, Keybkgnd_Src
	jz	laaincev
laapt:

	mov	ch,cl
	call	get_Vtrcb
	or	ch,ch
	jz	laaincev

	mov	bl,[bx].Vtrcb_FCM
	mov	lookaheadfcm,bl

	; Get index into the searchto_table
	mov	bl,cl
	mov	bh,0
	MULTIPLY_BY 3, BX
	add	bx,Vtr_Searchto_Table
	push	ax
	call	_time_value
	pop	ax
	JMP_Z	laaincev

	push	ax		; Save event number
	push	bx		; Save location in Vtr_Searchto_Table

	mov	ax,offset M_node_address
	call	vtr_opt
	mov	bx,Current_Event_Adr
	add	bx,offset ZeroBase.pin_lofst
	mov	dx,offset Sttime
	push	dx
	call	_mmv3_es2ds
	pop	bx

	; Get index into the searchto_table
	pop	dx		; Restore location in Vtr_Searchto_Table
	call	_mmv3byt		; Save to Vtr_Searchto_Table

;;	mov	ax,offset M_goto_location
	mov	ax,offset M_set_in
	push	bx
	call	set_vtrcmd
	pop	bx
	mov	cl,lookaheadfcm
	call	vtr_sl1

	mov	ax,offset M_cue
	call	motion

	pop	ax
	jmp	laaincev
	
lac_nomore:
	pop	ax			; Restore current event
	call	_index_storage
lac_xit:ret
LookAheadAndCueVtrs	endp


;================================================================
; LOCATION OF VTR RETURNED IN Vtr_Rcvbuf
; NODE # MUST HAVE BEEN PRE-SELECTED
; CARRY SET (C=1) IF TIME CODE STRING IS NOT IN PROPER FORMAT
;================================================================
;Get a location into the Vtr_Rcvbuf
; Returns with al=MINUS_ASCII if negative number
;	CL has Drop/Non drop indicator (if CH not 0)
;	BX points to input buffer
; USES CX,DX,AX
ask4location	proc	near
	push	ax			; Save command
	push	cx			; Save options
	mov	ax,offset M_get_code_mode
	call	vtr_cmd
	pop	cx
	pop	ax
	mov	dl,[bx]			; Get code mode

	push	dx
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	pop	dx

	mov	cl,'N'
	cmp	dl,'0'
	jz	vtrex
	
	mov	cl,9[bx]		; Return with Drop/Non-drop indicator
	cmp	cl,'.'
	jnz	a4l_1
	mov	cl,DF_CHAR
a4l_1:	mov	al,[bx]
	cmp	al,' '
	jz	vtrex
	cmp	al,MINUS_ASCII
	jnz	vtrex0
	clc
	ret
vtrex0:	stc
vtrex:	ret
ask4location	endp

;================================================================
;	SELECT NODE ADDRESS AND SEND OUT A MOTION COMMAND
;	FOR THE Current_Machine
;
; ENTER: AL = Command type
; Exit:  AL = CR if successful, C=0
;             Carry set (C=1) if not successful
;================================================================
motion	proc	near
	xor	cx,cx
	jmp	vtr_cmd
motion	endp

; SEND COMMAND WITH EXACT DIGIT IN CH (NO NODE NUMBER CONVERSION)

vtr_opt_FAR	proc	far
	call	vtr_opt
	ret
vtr_opt_FAR	endp

vtr_opt	proc	near
	mov	cl,VX_DIGITch
vtr_opt	endp

;================================================================
; SEND COMMAND IN AL AND OPTION (IF ANY) IN CH.
;  RETURN ACKNOWLEDGED OR CARRY SET IF ERROR
vtr_cmd	proc	near
	test	Device_Present,vlan_IOTYP
	jz	vtr_akc
	call	vtr_sendcmd
vtr_cmd	endp

;================================================================
; Get an answer from VTR to BX
vtr_answer	proc	near
	test	Device_Present,vlan_IOTYP
	jz	vtr_akc

;;	push	si

	mov	bx,offset Vtr_Rcvbuf
	push	dx
	mov	dx,VLAN_Address

	call	_Keyboard_off
	cli
vtr_ci:
	xor	cx,cx			; Clear counters
;;	mov	cx,offset 8000h
;;	mov	si,2			; Wait factor
; Get the FIRST CHARACTER
vtr_ci1:add	dx,5
	in	al,dx
	sub	dx,5
	test	al,1
	jz	vtr_ci2
	in	al,dx
	mov	[bx],al
	inc	bx
	cmp	bx,offset Vtr_Rcvbuf + vtr_buf_len
	ja	vtr_ci3
	cmp	al,cr
	jnz	vtr_ci			;  returned information and continue
	sti
	mov	byte ptr [bx],0		; Terminate with null
	call	_Keyboard_on
	mov	bx,offset Vtr_Rcvbuf
	pop	dx
;;	pop	si

	if DEBUGGING
	cmp	word ptr [bx], 'OC'
	jz	vtcdbg
	cmp	word ptr [bx], 'RE'
	jz	vtcdbg
	jmp	vtcndbg
vtcdbg:	db	0cch
vtcndbg:
	endif

	clc
	ret

vtr_ci2:call	GetJoggerData
	loop	vtr_ci1			; Keep trying to get a character
;;	dec	si
;;	jnz	vtr_ci1

vtr_ci3:sti
	call	_Keyboard_on
	mov	bx,offset Vtr_Rcvbuf
	pop	dx
;;	pop	si
vtr_akc:stc
	ret

vtr_answer	endp

;================================================================
; Get an answer from VTR to Vtr_Rcvbuf for CL bytes
GetVlanRecord	proc	near
	call	_Keyboard_off
	mov	bx,offset Vtr_Rcvbuf
	mov	ah,cl
	push	dx
	mov	dx,VLAN_Address
	cli
vtr_gb:	xor	cx,cx			; Try alot
vtr_gb1:add	dx,5
	in	al,dx
	sub	dx,5
	test	al,1
	jz	vtr_gb2
	in	al,dx
	mov	[bx],al
	inc	bx
	dec	ah			; Decrement Count
	jnz	vtr_gb			;  returned information and continue
	sti

	mov	bx,offset Vtr_Rcvbuf
	clc
	pop	dx
	call	_Keyboard_on
	ret

vtr_gb2:loop	vtr_gb1			; Keep trying to get a character
	call	_Keyboard_on
	sti
	stc
	pop	dx
	mov	bx,offset Vtr_Rcvbuf
	ret
GetVlanRecord	endp


;================================================================
;EDIT STATUS RETUNS
;================================================================
; Return NZ if no edit status characters found
; Return	AL = EDITSTSTIS_xxxxx
;		AH = Edit Status, all 7 bits
;		BX -> editstatus (unchanged)
GetEditStatus	proc	near
	push	cx
	mov	ax,offset M_BinaryEditStatus
	xor	cx,cx
	call	vtr_sendcmd
	mov	cl,5
	call	GetVlanRecord
	mov	al,[bx].ES_msg
	mov	ah,al
	and	al,00001111b	; Mask out high nibble
gesxit:	mov	bx,offset editstatus
	pop	cx
	ret
GetEditStatus	endp

;================================================================
;		GET STATUS ENCODED (Time code + status code)
; Enter with AL = machine number 0-6
; Exit: CL=status byte, Z set if OFFLINE
;================================================================
vtr_STAT	proc	near
	push	ax			; Save machine number
	mov	ch,al
	call	get_Vtrcb		; Check for node exist
	mov	cl,0ffh			; Off line signal
	or	ch,ch
	jz	a4sex

	mov	cl,VX_DIGITch		; Set node # request
	mov	ax,offset M_status_encod;(#=optional node number)
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	jnc	ask4sok
	mov	cl,0ffh
	cmp	cl,cl
	pop	ax
	ret

ask4sok:mov	ch,al			; Save - or space
	mov	cl,13[bx]		; Get status byte
a4sex:	cmp	cl,0ffh			; Check for off-line
	pop	ax			; Restore device
	ret
vtr_STAT	endp

; Clear device status for all machines
devstat_clr	proc	near
	push	bx
	push	cx
	mov	bx,offset Device_Stat_Tbl
	mov	cx,MAX_DEVICES
	xor	al,al
dsclp:	mov	[bx],al
	inc	bx
	loop	dsclp
	pop	cx
	pop	bx
	ret
devstat_clr	endp

;================================================================
;		GET DEVICE TYPE AND VERSION
;================================================================
; Enter:	AL = NODE number
; Exit:		BX points to ASCII response from VLAN
devtype_FAR	proc	far
	call	devtype
	ret
devtype_FAR	endp

devtype	proc	near
	or	al,al
	jz	devnone
	test	Device_Present,vlan_IOTYP
	jz	devnone
	push	cx
	mov	ch,al
	mov	ax,offset M_device_type
	mov	cl,VX_PoundNum
	call	vtr_cmd			; Send out a command
	pop	cx
	ret
devnone:mov	bx,SpacePointer(6)
	ret
devtype	endp

;================================================================
;		GET APPLICATION TYPE 
;================================================================
; Enter:	AL = NODE number
; Exit:		BX points to ASCII response from VLAN
; CX is saved, AX, BX used
get_appltype	proc	near
	push	cx
	or	al,al
	jz	aplnone
	test	Device_Present,vlan_IOTYP
	jz	aplnone
	mov	ch,al
	mov	cl,VX_PoundNum
	mov	ax,offset M_node_type
	call	vtr_cmd
	call	_convert2bin
aplnone:pop	cx
	ret
get_appltype	endp

;================================================================
;		CLEAR CURRENT NODE
;================================================================
clear_node	proc	near
	mov	ax,offset M_clear_node	; Clear out IN, OUT and DUR
	call	motion			;  points for each machine
	ret
clear_node	endp

;================================================================
;		GET VLAN COLOR FRAME
;================================================================
;GetVlanColorFrame	proc	near
;	mov	ax, offset M_SetColorFrame
;	xor	cx,cx
;	call	vtr_cmd
;	call	_convert2bin
;	mov	System_Color_Frame, al
;	ret
;GetVlanColorFrame	endp


;================================================================
;		SET VLAN COLOR FRAME
;================================================================
SetVlanColorFrame	proc	near
	mov	ch,System_Color_Frame
	mov	ax, offset M_SetColorFrame
	call	vtr_opt_FAR
	ret
SetVlanColorFrame	endp


;================================================================
;		SET TC TYPE
;================================================================
set_tctype	proc	near
	call	get_Vtrcb_TCM		; To AL
	mov	ch,al
	mov	ax,offset M_code_mode
	call	vtr_opt
	ret
set_tctype	endp

; Return CL = max forward speed, CH = max reverse speed
get_minmaxspeeds	proc	near
	mov	cl,PLUS_ASCII
	mov	ch,99
	mov	ax,offset M_test_speed
	call	vtr_cmd
	inc	bx
	call	_convert2bin
	mov	cl,al
	push	cx

	mov	cl,MINUS_ASCII
	mov	ch,99
	mov	ax,offset M_test_speed
	call	vtr_cmd
	inc	bx
	call	_convert2bin
	pop	cx
	mov	ch,al
	ret
get_minmaxspeeds	endp


;================================================================
; SENDOUT A COMMAND PREFIX AND A TIME CODE STRING COMMAND
; ENTER: BX points to a 3 byte time code value
;================================================================
;================================================================
; SEND OUT A PROGRAMMED MOTION CONTROL COMMAND
; IN THE FORM OF:	XX [+/-]##,00:00:00:00
;================================================================
; ENTER: BX points to 3 byte buffer containing TC
;	 CL has FCM
;	 CH has SPEED in FRAMES/SECOND
;	 AX has VLAN command type
; Routine provides its own + or - depending on high bit set in CH
vtr_pmccmd	proc	near
	test	Device_Present,vlan_IOTYP
	jz	pmccmdx
	push	bx				; Save pointer to buffer
	call	set_vtrcmd			; Set the command
	mov	al,PLUS_ASCII
	test	ch,80h				; Negative direction?
	jz	pmccmd1
	and	ch,7fh
	mov	al,MINUS_ASCII
pmccmd1:call	_add_store			; Store + or -
	mov	bl,ch
	xor	bh,bh
	call	_make_dec			; Set the speed
	mov	al,','				; Separate with a comma
	call	_add_store
	pop	bx
	call	vtr_sendtime
pmccmdx:ret
vtr_pmccmd	endp

;================================================================
; ENTER: BX points to 3 byte buffer containing TC
;	 CL has FCM
;	 CH DIRECTION +/-
;	 DX points to (LONG) SPEED as FRAMES/SECOND * 100
;	 AX has VLAN command type
; Routine provides its own + or - depending on high bit set in CH
vtr_rmpcmd	proc	near
	test	Device_Present,vlan_IOTYP
	jz	rmpcmdx
	push	bx				; Save pointer to buffer
	call	set_vtrcmd			; Set the command
	cmp	ch,MINUS_ASCII				; Negative direction?
	mov	al,PLUS_ASCII
	jnz	rmpcmd1
	mov	al,MINUS_ASCII
rmpcmd1:call	_add_store			; Store + or -
	mov	bx,dx
	mov	ax,[bx]
	mov	dx,[bx+2]
	mov	bx,Temp_Tc_Buf
	call	_itoa100				; Set the speed
	mov	Temp_Tc_Buf,bx
	mov	al,','				; Separate with a comma
	call	_add_store
	pop	bx
	call	vtr_sendtime
rmpcmdx:ret
vtr_rmpcmd	endp


;================================================================
;
; SENDOUT A COMMAND PREFIX AND A TIME CODE STRING COMMAND
; ENTER: BX points to a 3 byte time code value
;================================================================
vtr_sendnd	proc	near
	push	bx
	call	set_vtrcmd
	pop	bx
	mov	cl,NDF_CHAR
	jmp	vtr_sl1
vtr_sendnd	endp

vtr_sendloc	proc	near
	push	bx
	call	set_vtrcmd
	call	get_Vtrcb_FCM			; For Current_Machine To AL
	mov	cl,al
	pop	bx
	jmp	vtr_sl1
vtr_sendloc	endp

vtr_sendtime	proc	near
	push	bx
	call	get_Vtrcb_FCM			; For Current_Machine To AL
	mov	cl,al
	pop	bx
vtr_sendtime	endp

vtr_sl1	proc	near
	mov	dx,Temp_Tc_Buf
	mov	al,Frame_Flag
	push	ax
	mov	Frame_Flag,0
	call	_cnvt2tc_DS
	pop	ax
	mov	Frame_Flag,al
	call	vtrcmdx
	call	vtr_answer
	ret
vtr_sl1	endp


;================================================================
; SEND OUT PRESELECTED COMMAND SEQUENCE TO VLAN NETWORK
;
; ENTER: AX = COMMAND # TO BE ISSUED
;	 CL = 0 if no command tail
;	      0f0h if sending a lone carriage return
;	      0f1h if using exact CHARACTER in CH
;	      0f2h sends "#" + node number
;	      0f3h sends (cmd) AX + (ascii) ch + "#" + (vtr) dl
;	      0f4h sends (cmd) AX + (ascii) ch + "#" + (node) dl
;	      0f5h sends (cmd) AX + (2 byte ascii hex) ch + "#" + (node) dl
;	      0f6h sends (cmd) AX + (2 byte ascii hex) ch
;	      0fch if sending out multiple vtr info
;	      0fdh if using an EXACT digit in CH
;	      0feh if this is a multi-source roll
;	      0ffh if CH has a binary number
;	       + to send out a + and a number (CH)
;	       - to send out a - and a number (CH)
;	 CH = Data
; ================================================================
vtr_sendcmd	proc	near		; Set the command prefix to buffer
	call	set_vtrcmd

	or	cl,cl			; Check for no command tail
	JMP_Z	vtrcmdx

	cmp	cl,VX_DIGITch		; Check for EXACT DIGIT in CH
	JMP_Z	vtrcmdt
	cmp	cl,VX_MULTsrcroll	; Multi-sync?
	JMP_Z	vtrcml
	cmp	cl,VX_MULTvtrs		; Mult-Record?
	JMP_Z	vtrmltr
	cmp	cl,VX_CR
	JMP_Z	vtrnul
	cmp	cl,VX_PoundNum
	JMP_Z	vtrpndsng
	cmp	cl,VX_ASCchVTRdl
	JMP_Z	vtrdlch		; (cmd) AX + (ascii) ch + "#" + (vtr) dl
	cmp	cl,VX_ASCchNODEdl
	JMP_Z	vtrdlchn	; (cmd) AX + (ascii) ch + "#" + (node) dl
	cmp	cl,VX_HEXchNODEdl
	JMP_Z	vtrdlchnhex	; (cmd) AX + (2 byte ascii hex) ch + "#" + (node) dl
	cmp	cl,VX_HEXch
	JMP_Z	vtrchhex	; 0f6h sends (cmd) AX + (2 byte ascii hex) ch
	cmp	cl,VX_CharCh
	JMP_Z	vtrchar

	cmp	cl,VX_DeviceCH		; Send machine number in CH?
	jnz	vtrcc0

; Index to a control Port
	mov	al,ch
	MULTIPLY_BY Vtrcb_length, AX
	mov	bx,ax
	mov	ch,[bx + offset Vtrcb]
	or	ch,ch
	JMP_NZ	vtrcmdt
	mov	cl,0ffh
	cmp	cl,cl
	stc
	ret

vtrcc0:	cmp	cl,PLUS_ASCII
	jnz	vtrcc1
	mov	bx,Temp_Tc_Buf
	mov	[bx],cl
	inc	Temp_Tc_Buf

vtrcc1:	cmp	cl,MINUS_ASCII
	JMP_NZ	vtrcmdt
	mov	bx,Temp_Tc_Buf
	mov	[bx],cl
	inc	Temp_Tc_Buf
	jmp	vtrcmdt


;................................................................
; Process to roll more than one machine...
vtrmltr:test	MultRec_Flags,Enabled_MSBIT
	JMP_Z	vtrcmdx
	mov	bx,offset Multrecord_Table
vtrmrll:mov	al,[bx]			; Get a node number
	inc	bx
	cmp	al,0ffh			; None left?
	JMP_Z	vtrcmdx

	push	bx
	call	setmult			; Save into Multsync_Table
	mov	ch,al
	call	get_Vtrcb
	mov	bl,ch			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal

	pop	bx
	cmp	byte ptr [bx],0ffh	; Last one?
	JMP_Z	vtrcmdx
	mov	al,','			; Separate with a comma
	call	_add_store
	jmp	vtrmrll


vtrcml:	mov	bx,offset Multsync_Table
vtrcmll:mov	al,[bx]			; Get a node number
	inc	bx
	or	al,al			; None left?
	JMP_Z	vtrcmdx
	push	bx
	mov	bl,al			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal
	pop	bx
	cmp	byte ptr [bx],0		; Last one?
	JMP_Z	vtrcmdx
	mov	al,','			; Separate with a comma
	call	_add_store
	jmp	vtrcmll

;................................................................
vtrnul:	mov	bx,offset Vtr_Sndbuf	; Use this buffer for IO
	mov	Temp_Tc_Buf,bx		; Save start address
	jmp	vtrcmdx

vtrchar:mov	al,ch
	call	vtr_cstore
	jmp	vtrcmdx

;sends (cmd) AX + (ascii) ch + "#" + (node) dl
vtrdlchn:
	mov	bl,ch			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal
	mov	al,'#'
	call	vtr_cstore
	mov	bl,dl			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal
	jmp	vtrcmdx

vtrdlchnhex:
	mov	al,ch			; Make a decimal character
	call	_make_hexbyte
	mov	al,'#'
	call	vtr_cstore
	mov	bl,dl			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal
	jmp	vtrcmdx

;sends (cmd) AX + (ascii) ch + "#" + (vtr) dl
vtrdlch:mov	bl,ch			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal
	mov	al,'#'
	call	vtr_cstore
	mov	ch,dl
	call	get_Vtrcb
	mov	bl,ch			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal
	jmp	vtrcmdx


vtrchhex:
	mov	al,ch			; Make a decimal character
	call	_make_hexbyte
	jmp	vtrcmdx

; Send out a command with a "#"+node number appended
vtrpndsng:
	mov	al,'#'
	call	vtr_cstore

;................................................................
; Send out command tail
vtrcmdt:mov	bl,ch			; Make a decimal character
	xor	bh,bh			;  to send as node number
	call	_make_dec		; Convert to decimal

vtr_sendcmd	endp
;================================================================
; TERMINATE LINE IN Vtr_Sndbuf WITH CR AND A NULL AND SEND IT
; OUT TO THE VLAN
;================================================================
vtrcmdx	proc	near
	mov	bx,Temp_Tc_Buf
	mov	word ptr [bx],000dh	; CR,0
vtrcmdx	endp

;================================================================
;	SEND AN ENTIRE STRING TERMINATED BY A CR AND A NULL
;	OUT TO THE VLAN
;
; ENTER: BX points to message to be send
;
;================================================================
vcmsg	proc	near
	push	si
	push	dx
	push	cx

	mov	al,Active_IOTYP
	push	ax

	mov	Active_IOTYP,vlan_IOTYP
	call	PortIO_GetAddr		; Get Port IO address to AX
	jz	vcoxit
	mov	bx,offset Vtr_Sndbuf

vcmsglp:cmp	byte ptr [bx], 0	; Reached the end of the string?
	jz	vcoxit

	xor	cx,cx			; Try for 65535 times
vcolp:	mov	dx,[si]			; Get Port
	add	dx,5
	in	al,dx

	; Test for and, if found, discard incoming character
	test	al,00000001b
	jz	vnorcv
	mov	dx,[si]
	in	al,dx
	jmp	vcolp

vnorcv:	test	al,00100000b	; Test for transmit ready
	jnz	vcog
	loop	vcolp		; try again
	stc
	jmps	vcoxit

vcog:	mov	dx,[si]
	mov	al,[bx]
	out	dx,al
	inc	bx
	jmp	vcmsglp

vcoxit:	pop	ax
	mov	Active_IOTYP, al

	pop	cx
	pop	dx
	pop	si
	ret

vcmsg	endp

;================================================================
;	SEND AN ENTIRE STRING TERMINATED BY A CR AND A NULL
;	OUT TO THE VLAN
;
; ENTER: BX points to message to be send
;
;================================================================
SendVlanMsgCl	proc	near
	push	cx
	mov	Active_IOTYP,vlan_IOTYP
SVMmsg1:mov	al,[bx]		; Get next character to send
	call	mdmout
	inc	bx
	dec	cl
	jnz	SVMmsg1
SVMoxit:pop	cx
	ret
SendVlanMsgCl	endp


;================================================================
;
;	SET COMMAND PREFIX INTO TOP OF Vtr_Sndbuf
;
; ENTER: AL = COMMAND PREFIX OFFSET NUMBER
; Exit:	 AL unchanged
;	 BX points to beginning of command to be sent
;	 _add_store routine set for next character
;
; Set the command prefix indexed by AL into a buffer
;================================================================
set_vtrcmd	proc	near
	test	ah,80h			; Extended 3 byte command?
	jnz	set_vtrextcmd
	mov	bx,ax
	mov	bx,[bx + offset Vtrcmds]; Get command from table
	mov	Vtr_Sndbuf,bx		; Use this buffer for IO string
	mov	Temp_Tc_Buf,offset Vtr_Sndbuf + 2; Save start address
	ret

set_vtrextcmd:
	and	ah,07Fh			; Clear hi bit
	mov	bx,ax
	mov	ax,[bx + offset Vtrcmds]; Get command from table
	mov	Vtr_Sndbuf,ax		; Use this buffer for IO string
	mov	al,[bx + offset Vtrcmds + 2]
	mov	byte ptr Vtr_Sndbuf + 2,al
	mov	Temp_Tc_Buf,offset Vtr_Sndbuf + 3; Save start address
	ret

set_vtrcmd	endp

; Get node number from the Vtrcb
; ENTER: CH = machine number
; Exit:	 CH = node number
; 	BX is used
get_Vtrcb	proc	near
	mov	bl,ch
	xor	bh,bh
	MULTIPLY_BY Vtrcb_length, BX
	mov	ch,[bx + offset Vtrcb]
	ret
get_Vtrcb	endp

get_Vtrcb_pointer	proc	near
	mov	bx,0	
	jmp	gvtrcbs
get_Vtrcb_pointer	endp

get_vtrcb_FCM_FAR	proc	far
	call	get_Vtrcb_FCM
	ret
get_vtrcb_FCM_FAR	endp

get_Vtrcb_OFFSET_FAR	proc	far
	call	get_Vtrcb_OFFSET
	ret
get_Vtrcb_OFFSET_FAR	endp


get_Vtrcb_OFFSET	proc	near
	mov	bx,offset ZeroBase.Vtrcb_OFFSET
	jmp	gvtrcbs
get_Vtrcb_OFFSET	endp

; Gets the FCM from vtr's Vtrcb to AL
get_Vtrcb_FCM	proc	near
	mov	bx,offset ZeroBase.Vtrcb_FCM		; Offset for FCM indicator
	jmp	gvtrcbs
get_Vtrcb_FCM	endp

; Gets the TCM from vtr's Vtrcb to AL
get_Vtrcb_TCM	proc	near
	mov	bx,offset ZeroBase.Vtrcb_TCM		; Offset for TCM indicator
	jmp	gvtrcbs
get_Vtrcb_TCM	endp


get_Vtrcb_CF_FAR	proc	far
	call	get_Vtrcb_CF
	ret
get_Vtrcb_CF_FAR	endp

get_Vtrcb_CF	proc	near
	mov	bx,offset ZeroBase.Vtrcb_CF		; Offset for COLOR FRAME
	jmp	gvtrcbs
get_Vtrcb_CF	endp

get_Vtrcb_PORT	proc	near
	mov	bx,offset ZeroBase.Vtrcb_PORT
get_Vtrcb_PORT	endp

gvtrcbs	proc	near
	mov	al,Current_Machine
	cbw
	MULTIPLY_BY Vtrcb_length, AX
	add	bx,ax
	add	bx,offset Vtrcb
	mov	al,[bx]
	ret
gvtrcbs	endp

IndexToCurVtrControlBlock	proc	near
	push	ax
	mov	al,Current_Machine
	cbw
	MULTIPLY_BY Vtrcb_length, AX
	mov	bx,ax
	add	bx,offset Vtrcb
	pop	ax
	ret
IndexToCurVtrControlBlock	endp

;================================================================
; 	CONVERT NODE NUMBER TO MACHINE NUMBER
;
; ENTER: AL = NODE NUMBER
; Exit:  AL = DEVICE NUMBER / CL = DEVICE NUMBER
;	 CH = NODE NUMBER
; BX used, CL altered
get_vtr	proc	near
	mov	bx,offset Vtrcb
	xor	cl,cl
getvtnl:cmp	[bx],al				; Do Port numbers match?
	jz	getvtnx
	add	bx,Vtrcb_length
	inc	cl
	cmp	cl,MAX_MACHINES
	jbe	getvtnl
	xor	cl,cl
getvtnx:mov	ch,al
	mov	al,cl
	ret
get_vtr	endp

;===============================================================
EDLtrkone_toggle	proc	near
	cmp	es:Next_Avail_Num,1
	jbe	EDLtrx
	test	Device_Present,vlan_IOTYP
	jz	EDLtrx

	mov	ax,Network_Flags
	push	ax
	or	Network_Flags,EDLtrak_NTBIT
	mov	Tracksngl_Flag,0ffh

	mov	Cursor,offset Vlan_Scr
	blinkrev_VIDEO FALSE,FALSE
	mov	bx,offset Edlsrch_Msg
	call	_comsg
	xor	al,al
	call	vtr_STAT
	jz	EDLtrox
	call	EDLtr1
	pop	ax
	mov	Network_Flags,ax
	call	_evnt_dispthis
	jmp	EDLtrack_Upd
EDLtrkone_toggle	endp

EDLtrox:pop	ax
EDLtrx:	ret

; Track EDL to R-VTR location
EDL_Tracking	proc	near
	test	Network_Flags,EDLtrak_NTBIT
	jz	EDLtrx
	cmp	es:Next_Avail_Num,1
	jbe	EDLtrx
	xor	al,al
	mov	Tracksngl_Flag,al
	call	vtr_STAT
	jz	EDLtrx

	cmp	cl,86h			; PLAY
	jz	EDLtr1
	cmp	cl,88h			; Jog
	jz	EDLtr1
	cmp	cl,89h			; Shuttle
	jz	EDLtr1
	cmp	cl,9Ah			; "Knob"
	jz	EDLtr1
	cmp	cl,8ch			; Searching
	jz	EDLtr1
	cmp	cl,8dh			; FF
	jz	EDLtr1
	cmp	cl,8eh			; RW
	jz	EDLtr1
	ret

EDLtr1:	mov	ax,es:Current_Event
	mov	Temp_Event,ax

	inc	ax
	cmp	ax,EDLtracking_Edit
	jz	EDLtr2
	mov	EDLtracking_Edit,1

EDLtr2:	inc	bx
	mov	dx,offset Sttime	; Use Sttime for location buffer
	push	word ptr Frame_Flag
	mov	Frame_Flag,0
	mov	cl,Rtcf			; Use R-VT fcm
	call	_cnvt2mp_DS		; CONVERT LOCATION TO 24BIT NUMBER
	pop	word ptr Frame_Flag

	mov	ax,EDLtracking_Edit	; Get last found edit
	or	ax,ax			; Check for zero
	jnz	EDLtrl
	mov	ax,1

EDLtrl:	push	ax			; Save edit #
	push	ax
	call	locations
	pop	ax
	call	_index_storage
	jc	EDLtrgn			; Skip comments

	add	bx,offset ZeroBase.rin_lofst
	mov	dx,offset Sttime	; Skip if RIN => LOCATION
	call	_cmp24b_ESDS
	jae	EDLtrgn
	add	bx,3			; Point to ROUT
	call	_cmp24b_ESDS		; Skip if ROUT < LOCATION
	jc	EDLtrgn

; Edit is found, display it
	pop	ax
	inc	ax
	mov	EDLtracking_Edit,ax
	dec	ax
	mov	Temp_Event,ax
	call	_event_display
	cmp	Tracksngl_Flag,0ffh
	jz	EDLtrcx

	mov	cx,150			;a second and a half
EDLtrc:	push	cx
	call	locations
	call	joystick
	call	jogger
	call	_delms
	mov	ah,11h
	int	16h
	pop	cx
	jnz	EDLtxit
	loop	EDLtrc
EDLtrcx:ret

EDLtrgn:mov	ah,11h
	int	16h
	pop	ax
	jnz	EDLtxit
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jc	EDLtrl
	mov	EDLtracking_Edit,1	; Init for Restart
EDLtxit:mov	ax,Temp_Event
	call	_event_display
	ret
EDL_Tracking	endp


; Set VLAN timer to zero
clear_timer	proc	near
	mov	ax,offset M_setclock
	xor	ch,ch
	jmp	vtr_opt
clear_timer	endp

read_vtrloc	proc	near
	call	SetCurrentMachineActive		; Set node
read_vtrloc	endp
readthis_vtrloc	proc	near
	mov	ax,offset M_location_rqst
	jmp	read_VTR_time
readthis_vtrloc	endp

; GET RECORD VTR LOCATION
locate_record	proc	near
	mov	cx,VX_DeviceCH
	cmp	Vtr_Mult_Type,V_bvb
	jnz	lrec1
	mov	ch,To_Machine
lrec1:	mov	ax,offset M_location_rqst
	jmps	read_DEVICE_time
locate_record	endp

; Sends the command in AL out w/ no tail, gets time code value back
; for CURRENT NODE
; C=1 if error
read_VTR_time	proc	near
	xor	cx,cx			; Clear CX
read_VTR_time	endp

; Sends the command in AL out w/ no tail, gets time code value back
; for device (VTR) specified in CH
; C=1 if error
read_DEVICE_time	proc	near
	call	ask4location
	jc	rdvtrlx
	inc	bx
	mov	dx,offset Sttime	; Use Sttime for location buffer
	push	word ptr Frame_Flag
	mov	Frame_Flag,0
	call	_cnvt2mp_DS
	pop	word ptr Frame_Flag
	clc
rdvtrlx:ret
read_DEVICE_time	endp

; Clear out all VTR FCMs to blanks.
; This will force LOCATIONs routines to display the current FCM
Clear_VTR_FCMs	proc	near
	test	Device_Present,vlan_IOTYP
	jz	clfcmx
	xor	al,al
Clfcmlp:push	ax			; Initiate pointers for
	call	Machine_Change		; All playback machines
	push	ax
	cbw
	MULTIPLY_BY Vtrcb_length, AX
	mov	si,offset Vtrcb
	add	si,ax
	pop	ax
	call	vtr_STAT
	jz	Clfcml2
	mov	byte ptr [si.Vtrcb_FCM],' '
Clfcml2:pop	ax
	inc	al
	cmp	al,aux_dev
	jc	Clfcmlp
clfcmx:	ret
Clear_VTR_FCMs	endp

all_locations	proc	near
	test	Device_Present,vlan_IOTYP
	jz	alocx
	push	bx
	push	cx
	push	si
	push	di
	mov	cx,MAX_MACHINES		; was ALL_DEVICES
alocs:	push	cx
	call	locations
	pop	cx
	loop	alocs
	pop	di
	pop	si
	pop	cx
	pop	bx
alocx:	ret
all_locations	endp

;================================================================
;		STOPWATCH FACILITIES
;================================================================
; ENTER: NOTHING
; Exit:  JUST AS MUCH

stopwatch	proc	near
	test	Device_Present,vlan_IOTYP
	jz	stwx
	call	_help_pos
	call	clear_timer

stwagn:	call	_kbd_cln
	mov	bx,offset set_timer_ovr
	call	_msgread
	call	rdchar
	call	_Break_check
	jz	stwx

	cmp	ax,offset Enter_xcmd	; Start forward timer?
	mov	bx,offset Tc_Format
	JMP_Z	stt			; Jump if forward timer
	call	_check_setkeys		; Set for Count-down?
	jz	stw1			; Jump if Count down
	call	keythru
	call	_error_bell
	jmp	stwagn

stwx:	call	_evnt_dispthis		; Exit, restoring EDL
	ret

; Set timer for Count down
stw1:	mov	bx,offset shiftinput_rqst
	call	_Inout_init
	mov	al,DF_CHAR
	mov	bx,offset Sttime	; Use Sttime for work area
 	call	tc_cimsg
	jc	stwx
	call	_time_value
	jz	stwx
	mov	dx,offset Time_Count
	call	_mmv3byt
	mov	bx,dx
	mov	dx,offset Sec_Cnt
	call	_mpbadd
	call	stwini			; Init counter
	call	_kbd_cln

stblp:	call	cstat
	jz	stblp2
	call	_Break_check
	jnz	stblp1
	call	_evnt_dispthis
	ret

stblp1:	cmp	ax,offset Enter_xcmd
	JMP_Z	stwagn
stblp2:	call	stwdec
	mov	dx,offset Sec_Cnt
	call	_cmp24b
	pushf
	jnz	stblp3
	mov	bx,offset Tc_Format
stblp3:	call	nblockd			; Display in block numerics
	popf
	jnz	stblp
	call	_beeper
	jmp	stwagn

;----------------------------------------------------------------
; Set timer for Count up
stt:	mov	dx,offset Time_Count
	call	_mmv3byt
	call	stwini
	call	_kbd_cln
	mov	bx,offset stop_timer_ovr
	call	_msgread

stopw1:	call	cstat
	jz	stopw3
	call	_Break_check
	jnz	stopw2
	call	_evnt_dispthis
	ret

stopw2:	cmp	ax,offset Enter_xcmd
	jnz	stopw3
	jmp	stwagn
stopw3:	call	stwinc
	call	nblockd			; Display in block numerics
	jmp	stopw1

nblockd:mov	cl,DF_CHAR
	mov	dx,offset Tcdispbuf
	call	_cnvt2tc_DS
	call	_nblocks
	ret

stwdec:
	call	stwget
	call	_mpbsub
	ret

stwinc:	call	stwget
	call	_mpbadd
	ret

stwget:	push	word ptr Video_Mode
	call	locations
	pop	word ptr Video_Mode
	mov	ax,offset M_readclock
	call	read_VTR_time
	mov	dx,offset Entime
	call	_cmp24b
	jz	stwget
	call	_mmv3byt
	mov	bx,offset Time_Count
	mov	dx,offset Frm_Cnt
	ret

stwini:	mov	ax,offset M_readclock
	call	read_VTR_time
	mov	dx,offset Entime
	call	_mmv3byt
	ret
stopwatch	endp

;================================================================
;		Adjust for offset from Preroll
;================================================================
; ENTER: BX points to 4 byte buffer: SIGN,TC
; Exit:  BX points to 3 byte adjusted value
Preroll_delayed	proc	near
	push	dx
	mov	al,[bx]			; Get sign
	inc	bx			; Point to offset
	push	ax
	call	_Sttime_move
	pop	ax
	cmp	al,MINUS_ASCII
	jnz	vtr_gps
	call	_tc_negate
vtr_gps:call	_Get_PrerollToBX
vtr_gp1:call	_Elaptm_move
	call	_timadd
	pop	dx
	ret
Preroll_delayed	endp

;================================================================
;
;	 GET AND DISPLAY LOCATIONS FOR ALL VALID VTRS
;
;================================================================
; 838ns TICKS = 13200 for active node, averaged over 25 passes	6/89
;		 0033 for inactive nodes			6/89
locations_far	proc	far
	call	locations
	ret
locations_far	endp

locret:	pop	ax
	mov	Active_IOTYP,al
	pop	es
locxit:	ret

diaglocations	proc	near
	mov	di,offset Diagloc_Scr
	jmps	loc0
diaglocations	endp

locations	proc	near
	cmp	Diagnostics_Flag,0ffh
	jz	diaglocations
	cmp	Fullscreen_Flag,0ffh
	jz	locxit
	mov	di,offset Locations_Scr	; DX points to the SCREEN loc table

loc0:	push	es
	mov	al, Active_IOTYP
	push	ax

	test	Device_Present,vlan_IOTYP	; Check for net present
	jz	locret			;  and bail out if NOT

	mov	bx,offset Loc_Count	; BX points to
	mov	al,[bx]			;  next VTR # to update
	cmp	al,MAX_MACHINES		; Is it legal?
	jc	loc1			; Jump if OK
	xor	al,al			; Else, recycle to DEV0 (REC)

loc1:	cbw
	add	di,ax			; Index over to the right word
	add	di,ax			;  in the locations table

	mov	[bx],al			; Save current device number
	inc	byte ptr [bx]		;  and increment it by one
	mov	Current_Device,al	; But, AL still = current device

	MULTIPLY_BY Vtrcb_length, AX
	mov	si,offset Vtrcb
	add	si,ax
	mov	Loc_Vtrcb,si		; Save Vtrcb address
	mov	cl,[si]			; Get node number
	or	cl,cl
	jz	locret			; Exit if off line

	mov	locnode,cl

	mov	dx,ds:[di]
	mov	bl,dh			; Get row
	xor	bh,bh
	mov	ah,bh
	shl	bx,1
	mov	di,Rowtbl[bx]
	mov	al,dl
	shl	ax,1
	mov	dx,di
	add	di,ax
	mov	es,Videoram		; Set ES to point to Display RAM

; ES:DI = Cursor, ES:DX = START OF Cursor LINE

; Get status encoded
	mov	ch,cl
	mov	cl,VX_DIGITch		; Set node # request
	mov	ax,offset M_status_encod	;(#=optional node number)
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	jc	locret			; Return if com error

	mov	cl,13[bx]		; Get status byte
	cmp	cl,0ffh			; Check for off-line
	JMP_Z	locret			; Z means it Offline or ERROR

loc2:	mov	ah,'C'
	cmp	byte ptr [ si.Vtrcb_TCM ],0	; Time code mode?
	jz	loc3
	mov	ah,NDF_CHAR
	cmp	byte ptr 9[bx],'.'
	jnz	loc3
	mov	ah,DF_CHAR
	mov	byte ptr 9[bx],';'

loc3:	cmp	ah,[ si.Vtrcb_FCM ]
	mov	[ si.Vtrcb_FCM ],ah
	pushf
	mov	ch,byte ptr 12[bx]	; Get status byte
	mov	byte ptr 12[bx],0	; Terminate line
	inc	bx			; Point past space or -
	norm_VIDEO FALSE,FALSE		; Display brightly
	mov	ah,Video_Mode

loc30:	mov	al,[bx]
	or	al,al
	jz	loc32
	cmp	al,'0'
	jz	loc31
	cmp	al,':'
	jz	loc31
	cmp	al,';'
	jz	loc31
	call	locscrn
	jmp	loc32

loc31:	mov	al,' '
	stosw
	inc	bx
	jmps	loc30

loc32:	popf
	jz	loc4			; Skip rest if no change

	push	di
	mov	al,' '
	stosw
	dim_VIDEO FALSE,FALSE
	mov	ah,Video_Mode
	mov	al,[ si.Vtrcb_FCM ]
	stosw
	pop	di

	cmp	si,offset Vtrcb		; Record machine?
	jnz	loc4
	mov	Blktcf,al
	mov	Auxtcf,al

loc4:	cmp	byte ptr [si.Vtrcb_TCM],0 ; Control track mode?
	jz	loc6
	cmp	ch,'*'
loc6:	mov	al,' '
	jz	loc7
	mov	al,0fh			;'*'
loc7:	stosw

	mov	al,Current_Device	; Check for change in device status
	cbw
	mov	bx,ax
	mov	si,offset Device_Stat_Tbl
	cmp	cl,[si + bx]		; No change since last?
	jz	loc_12			; Check variable speed
	mov	[si + bx],cl		; Save new status byte

	cmp	cl,89h			; Shuttling?
	jz	lsrev_1

;;	cmp	cl,9Ah			; "Knob"
;;	jz	lsrev_1

	cmp	cl,94h			; "VariPlay"
	jz	lsrev_1

loc9:	mov	di,dx
	add	di,spd_offset * 2
	dim_VIDEO FALSE,FALSE
	cmp	cl,80h			; Hi bit is non-critical error
	jae	loc910
	blink_VIDEO FALSE,FALSE
loc910:	call	loc10
	dim_VIDEO FALSE,FALSE
	jmp	locret

;...
loc_12:	cmp	cl,89h			; Shuttle?
	JMP_Z	lsShuttle
	cmp	cl,9Ah			; "Knob"
	jz	lsrev_1
	cmp	cl,94h			; "VariPlay"
	jz	lsrev_1
	jmp	locret

lsrev_1:push	dx
	dim_VIDEO FALSE,FALSE
	mov	ax,offset M_send_speed
	mov	ch,locnode
	mov	cl,VX_PoundNum		; Set node # request
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	pop	dx
	JMP_C	locret			; Return if com error
	cmp	byte ptr [bx],' '
	jnz	lsrev1a
	mov	byte ptr [bx],PLUS_ASCII
lsrev1a:
	mov	di,dx
	mov	dh,ah
	add	di,(spd_offset + 0) * 2
	mov	ah,Video_Mode

	cmp	word ptr [bx + 1], '00'
	jnz	lsrevaaa
	mov	cl,88h
	jmp	loc910

lsrevaaa:
	push	bx
lsrev1aa:
	mov	al,[bx]
	cmp	al,cr
	jz	lsrev1xx
	stosw
	inc	bx
	jmps	lsrev1aa

lsrev1xx:
	mov	al,'/'
	stosw
	pop	bx
	inc	bx
	call	_convert2bin
	call	_PercentPlaySpeed
	mov	bx,offset Ascii_Number
	call	_itoa
	cmp	ax,9
	ja	lspad1
	mov	byte ptr es:[di],'0'
	inc	di
	inc	di
lspad1:	cmp	ax,99
	ja	lspad2
	mov	byte ptr es:[di],'0'
	inc	di
	inc	di
lspad2:	mov	ah,Video_Mode
	call	locscrn
	jmp	locret

lsShuttle:
	mov	bx,Loc_Vtrcb		; Get Vtrcb address FIX 5-23-1990 nhs
	mov	cl,[bx].Vtrcb_SPD 	; Get current speed

;5-24-1994  Trap for errors of speed > 9
	cmp	cl,9
	jbe	lss1
	mov	cl,9
	mov	[bx].Vtrcb_SPD,cl 	; Set max speed

lss1:	xor	ch,ch
	or	cl,cl
	JMP_Z	lsnul
	shr	cl,1			; Half it
	mov	ah,6			; Subtract 6 from it
	sub	ah,cl			; AH = relative speed inidicator len
	cmp	byte ptr [bx.Vtrcb_DIR] ,MINUS_ASCII ; Check direction
	jnz	lsfwd_1

; Do for reverse
	mov	di,dx
	mov	dh,ah
	add	di,(spd_offset + 6) * 2
	dim_VIDEO FALSE,FALSE
	mov	ah,Video_Mode

	mov	al, ' '
	mov	es:[di],ax
	sub	di,2

	mov	al,'<'
	cmp	byte ptr [bx].Vtrcb_SPD, 9
	jz	lsrev_a1
	mov	al,174
lsrev_a1:mov	es:[di],ax
	inc	cx
lsrev_2:sub	di,2
	jcxz	lsrev_3
	mov	es:[di],ax
	loop	lsrev_2
lsrev_3:mov	al,'<'
	mov	es:[di],ax
	mov	cl,dh
	xor	ch,ch
	mov	al,' '
	sub	di,2
	dec	cl
lsrev_4:jcxz	lsrev_5
	mov	es:[di],ax
	sub	di,2
	loop	lsrev_4
lsrev_5:jmp	locret

;================================================================
lsfwd_1:mov	di,dx
	mov	dh,ah
	add	di,(spd_offset) * 2
	dim_VIDEO FALSE,FALSE
	mov	ah,Video_Mode

	mov	al,'>'
	cmp	byte ptr [bx].Vtrcb_SPD, 9
	jz	lsfwd_1a
	mov	al,175
lsfwd_1a:
	inc	cl			; 3-26-1991
lsfwd_2:jcxz	lsfwd_3
	stosw
	loop	lsfwd_2
lsfwd_3:mov	al,'>'
	stosw
	mov	cl,dh
	xor	ch,ch
	mov	al,' '
	jcxz	lsfwd_5
	dec	cl
lsfwd_4:jcxz	lsfwd_5
	stosw
	loop	lsfwd_4
lsfwd_5:jmp	locret


; Display blanks
lsnul:	mov	cl,9ah
	jmp	loc9
;	mov	di,dx
;	add	di,(spd_offset) * 2
;	mov	ah,Video_Mode
;	mov	al,' '
;	mov	cx,6
;	rep stosw
;	jmp	locret

; Find status information and display it
loc10:	mov	si,offset Vtrstat
loc10a:	mov	ah,[si]
	cmp	cl,ah
	jz	loc10b
	inc	ah
	jz	loc10b
	add	si,8
	jmp	loc10a
loc10b:	mov	bx,si
	inc	bx
	mov	ah,Video_Mode
	or	ah,Color_BKG
	call	locscrn
	mov	al,' '
	stosw
	ret

locscrn:mov	al,[bx]
	inc	bx
	or	al,al			; Zero?
	jz	locscrx			; Exit if so
	stosw
	jmp	locscrn
locscrx:ret
locations	endp

;================================================================
; FAST COMSG ROUTINE USED FOR LOCATIONS
loccmsg	proc	near
	push	es
	push	di
	push	si
	mov	si,bx
	call	_screen_ram		; offset DI to screen, DX = Cursor
	mov	ah,Video_Mode
	or	ah,Color_BKG
lcmglp:	lodsb				; Get next character, SI=SI+1
	or	al,al			; Zero?
	jz	lcmgxit			; Exit if so
	cmp	al,cr
	jz	lcmgxit
	stosw
	inc	dl			; Increment Cursor
	jmp	lcmglp
lcmgxit:mov	Cursor,dx
	pop	si
	pop	di
	pop	es
	ret
loccmsg	endp

;================================================================
; +0  +1  +2    +3    +4    +5
; LSB MSB HSB STATUS FlagS  CR
; Enter: AL = vtr
; Exit: BX points to 24bit TC value
;	CL has status byte
;	CH has Flags, bit 0 for code valid, bit 1 if drop frame
Binary_Status	proc	near
	push	ax			; Save machine number
	mov	ch,al
	call	get_Vtrcb		; Check for node exist
	or	ch,ch
	jz	bsex
	mov	cl,VX_PoundNum
	mov	ax,offset M_Binary_Status
	call	vtr_sendcmd
	mov	cl,6
	call	GetVlanRecord
	mov	cx,[bx + 3]		; CL = status, CH = Flags
bsex:	pop	ax
	ret
Binary_Status	endp

;;; Enter: Nothing
;;; Exit:	BX points to 24bit timer value
;;Edit_Clock	proc	near
;;	mov	ax,offset M_Edit_Clock
;;	call	vtr_sendcmd
;;	mov	al,4
;;	call	GetVlanRecord
;;	ret
;;Edit_Clock	endp

;================================================================
; Create and trigger a GPI time line.
; Called from either EFX menu or TIMELINE display
RealTime_Trigger	proc	near
	call	vtr_editcalc
	call	_clear_Edit_Flags
	ret
RealTime_Trigger	endp


TimerPreroll	proc	near
	mov	dx,word ptr Rvtr_In
	mov	cl,byte ptr Rvtr_In + 2
	add	dx,FPS				;Sec_Cnt
	adc	cl,0				;byte ptr Sec_Cnt + 2
	sub	dx,Rvtr_Location
	sbb	cl,byte ptr Rvtr_Location + 2
	mov	bx,offset Sttime
	mov	[bx],dx
	mov	[bx + 2],cl
	mov	cl,Rtcf
	mov	dx,offset Tcdispbuf	; Convert it
	call	_cnvt2tc_DS		;  to a string
	jmp	Tmrd1
TimerPreroll	endp

; Count down timer
TimerDisplay	proc	near
	mov	bx,offset Rvtr_Location
	mov	dx,offset Rvtr_In
	call	_mpbsub
	mov	dx,offset Tcdispbuf	; Convert it
	mov	cl,Rtcf
	call	_cnvt2tc_DS		;  to a string
Tmrd1:	norm_VIDEO FALSE,FALSE
	cmp	Fullscreen_Flag,0ffh	; Are we in TIMLINE mode?
	jnz	Td2
	mov	Cursor,152eh
	call	_lblocks
	ret
Td2:	mov	Cursor,offset Countdown_Scr
	jmp	loccmsg			; Print TC value
TimerDisplay	endp

;================================================================
; Reset parameters for routine Exit
VTR_Reset	proc	near
	call	IndexToCurVtrControlBlock
	mov	al,0
	mov	[bx].Vtrcb_SPD,al
	mov	[bx].Vtrcb_DIR,PLUS_ASCII
	mov	[bx].Vtrcb_VARISPD,al
	mov	[bx].Vtrcb_VARIDIR,PLUS_ASCII
	mov	[bx].Vtrcb_VSSSPD,al
	mov	[bx].Vtrcb_VSSDIR,PLUS_ASCII
	mov	Last_Stickx,al
	mov	al,Current_Machine
	mov	ch,al
VTR_Reset	endp

;================================================================
; TOGGLE RECORD E-E ACCORDING TO CURRENT MACHINE
vtr_e2e	proc	near
	cmp	Record_Flag,0ffh	; Skip this if recording
	jz	vtr_eer

	push	ax
	push	cx

	call	SetRVT_Active
	mov	ax,offset M_ee_off	; TURN E2E OFF
	cmp	Current_Machine,0	; Is this the RECORD MACHINE?
	jz	vtr_nee			; If record, cancel E-E
	mov	ax,offset M_ee_on	; TURN E2E ON
vtr_nee:call	motion
	pop	cx
	pop	ax
	call	SetActiveVtr_CH
vtr_eer:call	Monitor_Switch
	call	Preview_Switch
	ret
vtr_e2e	endp

;================================================================

;================================================================
;	SET SOURCE AND RECORD IN AND OUT POINTS TO VMIO
vtr_setinout:
	mov	ax,Current_VTRS		; MSB = crnt machine, LSB = crnt source
	mov	SIO_Vtrs,ax

	xor	al,al
	mov	Openend_Flag,al		; Reset open end Flag
	mov	byte ptr Multsync_Table,al

	cmp	Vtr_Mult_Type,V_bvb		; Check for BVB
	jz	SetIO_Sources

	cmp	Vtr_Mult_Type,V_vbv		; Check for VBV
	jz	SetIO_1

	call	_ReCompute_EFX		; Recompute workspace
	call	_upd_getscr		; Redraw screen

;4-30-1995 
	; Stash the record duration into Rvtr_Dur
	mov	bx,offset R_Tc.tcDUR
	mov	dx,offset Rvtr_Dur
	call	_mmv3byt
;...

	call	SetIO_Slaves		; Setup SLAVE IN POINTS (if SLAVE on)
	call	SetIO_Multrecord	; Setup MULT RECORD IN POINTS

SetIO_1:call	SetIO_RVTR		; Setup R-VTR in/out points

	cmp	Vtr_Mult_Type,V_vbv	; If VBV then 
	JMP_Z	SetIO_OpnEnd_Dur	;  Skip the SOURCE parameters


;................................................................
; Set the SOURCE MACHINE PARAMETERS
SetIO_Sources:
	mov	ax,SIO_Vtrs		;Get Current_VTRS
	cmp	Trans_Type,'C'
	jz	SetIO_CUT
	cmp	Trans_Type,'S'		; Check for
	jnz	SetIO_EFX		;  a split

; Process for a CUT
SetIO_CUT:
	mov	To_Machine,al
	cmp	al,MAX_MACHINES
	jnc	SetIO_Cut2

	cmp	Vtr_Mult_Type,V_bvb	; Check for BVB
	jz	SetIO_Cut1
	call	setmult
SetIO_Cut1:
	call	Machine_Change

; 3-31-1994 Don't process phantom machines
	push	ax
	call	get_Vtrcb_PORT
	or	al,al
	pop	ax
	jz	SetIO_Cut2
;...

	call	clear_delay
;;<><>	call	WriteAllSpeeds
	call	Set_In_From_Vtr_Loc
	jc	SetIO_Cut2

	call	_VVV_compensateIN
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_setin

	call	_get_out
	call	_VVV_compensateOUT
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_setout
SetIO_Cut2:
	jmp	SetIO_OpnEnd_wFlags

; Process a Dissolve or Wipe by setting BOTH inpoints
; FIXED 5-15-1990 NHS.  Wasn't using key foreground
;  at all and background machines
SetIO_EFX:
	mov	al,From_Machine		; Set in and out of from machine
	cmp	Trans_Type,'K'
	jnz	SetIO_EFX1
	mov	al,Keybkgnd_Src
SetIO_EFX1:
	call	Machine_Change
	cmp	al,MAX_MACHINES
	jnc	SetIO_EFX2

; 3-31-1994 Don't process phantom machines
	push	ax
	call	get_Vtrcb_PORT
	or	al,al
	pop	ax
	jz	SetIO_EFX2
;...

	call	setmult			; AL to Multsync_Table
	call	clear_delay
;;<><>	call	WriteAllSpeeds
	call	Set_In_From_Vtr_Loc
	call	_VVV_compensateIN	; Compensate w/ offset if Preview
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_setin

; CHECK FOR EXTENDED EDIT
SetIO_EFX2:
	call	_get_dur			; Get duration (see if extended)

	mov	al,To_Machine
	cmp	Trans_Type,'K'
	jnz	SetIO_EFX3
	mov	al,Keyfor_Src
SetIO_EFX3:
	cmp	al,MAX_MACHINES
	jnc	SetIO_OpnEnd_wFlags

	push	bx			; Save duration pointer
	cmp	Vtr_Mult_Type,V_bvb		; Check for BVB
	jz	SetIO_EFX4
	call	setmult

SetIO_EFX4:
	call	Machine_Change		; Set to To_Machine or Keyfor_Src

; 3-31-1994 Don't process phantom machines
	push	ax
	call	get_Vtrcb_PORT
	or	al,al
	pop	ax
	jnz	SetIO_EFX4A
	pop	bx
	jmp	SetIO_OpnEnd_wFlags
SetIO_EFX4A:
;...
	call	clear_delay
;;<><>	call	WriteAllSpeeds
	call	Set_In_From_Vtr_Loc	; Set the IN point
	call	_VVV_compensateIN	; Compensate w/ offset if Preview
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_setin

	pop	bx			; Restore the edit duration

; No delayed roll for keys
	cmp	Trans_Type,'K'		; Is this a KEY?
	jz	SetIO_OpnEnd_wFlags	; If no, no roll delay needed

	call	_time_value		; Duration > 0?
	jz	SetIO_OpnEnd_wFlags	; If no, no roll delay needed

	test	Edit_Flags,delroll_EDBIT; Check for delayed roll OK
	jz	SetIO_ndelroll

	call	_VVV_compensateIN	; Compensate w/ offset if Preview
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_SetRollBegin
	mov	RollDelay_Flag,0ffh	; Set for Roll Delay = TRUE
	jmp	SetIO_OpnEnd_wFlags

SetIO_ndelroll:
	call	_Sttime_move
	call	_get_in			; Restore the out
	call	_Entime_move		; It goes to the Entime
	call	_timdif			; Entime - Sttime = Elaptm
	call	_VVV_compensateIN	; Compensate w/ offset if Preview
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_setin

SetIO_OpnEnd_wFlags:
	call	_compute_Flags
	mov	ax,Workspace_Flags
	and	ax,(w_TOdur_bit or w_Rdur_BIT)
	or	ax,ax			; Check for no R/P Dur&Out
	jz	SetIO_OED2

; And, one last check for an open end edit...
SetIO_OpnEnd_Dur:
	mov	bx,offset R_Tc.tcDUR
	cmp	Vtr_Mult_Type,V_bvb
	jnz	SetIO_OED1
	mov	bx,Current_Duration
SetIO_OED1:
	call	_time_value
	jnz	SetIO_ltrans

SetIO_OED2:
	call	SetIO_OpenEnd

SetIO_ltrans:
	call	check_ltrans		; Check for BX duration => EFXtrans
	mov	Autotrans_Flag,0	; Disable trigger if CUT

	cmp	Vtr_Mult_Type,V_vbv		; Check for VBV
	JMP_Z	setior

	cmp	Trans_Type,'C'
	JMP_Z	setior
	cmp	Trans_Type,'S'
	JMP_Z	setior

; Mmmm. Must be a D, W, or K.
	mov	Autotrans_Flag,0ffh	; Enable trigger

	cmp	Trans_Type,'K'		; Key?
	jnz	setiodw
	cmp	Key_Mode,0		; Key on at edit? (no auto trans)
	jz	setior

; Process for KEY IN or OUT
	cmp	Key_Mode,1		; Key IN?
	jz	setiodw			; Yes, set trigger time normally

; Must be KEY OUT...
; (Note: Don't forget to check for an OPEN END EDIT special case @ R-VTR IN)
;KEY OUT mode: Autotrans trigger = RECORD OUT - EFFECT DURATION
	mov	bx,offset Rvtr_Dur
	call	_Entime_move
	mov	dx,Key_Trans
	mov	Sttime,dx
	mov	byte ptr Sttime + 2,0
	call	_timdif			; Entime - Sttime = Elaptm

;4-30-1995 
	call	_Get_PrerollToBX
	call	_Sttime_move
	call	_timadd
;...

;;;;	call	_Entime_move		; Prepare for next calculation
	jmp	setkeyt

; If an EFFECT, check set the autotrans trigger
setiodw:
	call	_Get_PrerollToBX
	call	_Sttime_move
	mov	al,From_Machine
	call	Machine_Change

	call	get_Vtrcb_FCM
	mov	cl,al

	call	_get_dur
	call	_Elaptm_move
	call	_timadd			; BX points to Entime

setkeyt:
; Subtract the trigger advance time
	call	_ATRANS_compensateIN

	mov	ax,TFlag_ATRANS
	call	_tline_save

setior:	mov	ax,SIO_Vtrs		; Restore original machine
	push	ax
	call	Machine_Change
	pop	ax
	cmp	al,ah
	jz	siorx
	mov	al,ah
	call	Machine_Change
siorx:	ret

;================================================================
; SPLIT EDIT ADD-TRACKS ESTABLISHED HERE
; Check for VIDEO DELAY (audio happens first as per Flag)
Setup_SplitEdit:
	mov	al,Split_Mode		; Get split mask
	and	al,video_Emode		; If no bits in common, Z=1
	jnz	vtadly

; Video delay
; 1. Set AUDIO as primary mode
; 2. Set VIDEO as add-tracks
	mov	cl,Mode_Flag
	and	cl,audall_Emode		; Mask out all but audio
	mov	ax,offset M_track_select
	call	vtr_tracks
	mov	cl,Mode_Flag
	and	cl,video_Emode		; Mask out all but video
	jmps	vtvst

; Audio delay
; 1. Set VIDEO as primary mode
; 2. Set AUDIO as add-tracks
vtadly:	mov	cl,Mode_Flag
	and	cl,video_Emode
	mov	ax,offset M_track_select
	call	vtr_tracks
	mov	cl,Mode_Flag
	and	cl,audall_Emode
vtvst:	mov	ax,offset M_add_tracks
	call	vtr_tracks

; Compute split time
	xor	al,al
	call	Machine_Change		; Address the record machine's FCM
	mov	bx,offset R_Tc.tcIN
	call	_Sttime_move
	mov	bx,offset Split_Delay
	call	_Elaptm_move
	call	_timadd

	call	_VVV_compensateSplit
	call	_FrameStoreCompensate	; Compensate for frame stores<><>??

	mov	ax,offset M_split_time
	call	vtr_sendloc

	call	_Get_PrerollToBX
	call	_Sttime_move
	mov	bx,offset Split_Delay
	call	_Elaptm_move
	call	_timadd
	mov	ax,TFlag_INsplit	; Signal inpoint split
	call	_tline_save

	ret


;================================================================
;	SUPPORT ROUTINES FOR ABOVE PROCEEDURES
;================================================================

;----------------------------------------------------------------
; Put machine number (AL) to the next position AS A NODE NUMBER
;  in Multsync_Table
setmult:push	ax
	push	cx
	mov	ch,al			; Device number to CH
	call	get_Vtrcb		; CH = node number
	mov	al,ch			; Get node number
	or	al,al
	jz	setmrt
	mov	bx,offset Multsync_Table
	mov	cx,MULT_DEVICES		; Maximum allowed devices
setm1:	cmp	byte ptr [bx],0
	jz	setmok
	cmp	[bx],al			; Already exists?
	jz	setmrt
	inc	bx
	loop	setm1		;<> Needs error routine after here<?>
setmok:
	if CUTS_ONLY
	cmp	cx,MULT_DEVICES - 1
	ja	setmok1
	ERROR	cutsonly_error, ERET_Keyboard
setmok1:
	endif ;cuts_only

	mov	[bx],al
	mov	byte ptr 1[bx],0
setmrt:	pop	cx
	pop	ax
	cmp	Vtr_Mult_Type,V_roll	; Check for timeline
	jnz	setmrr
	call	_SaveVtrInEditTable
setmrr:	ret


;================================================================
;	Set machine #AL in point to VLAN and recompute
;================================================================
Set_In_From_Vtr_Loc:
	call	vtr_STAT
	stc
	jz	sifvlx
	call	_get_in
	jnz	sifvlx
	call	Mark_Inpoint
	call	_Save_Marktable		; Save Ins, Outs, Durs...
	call	_ReCompute_EFX
	call	_upd_getscr
	call	_get_in
	or	al,al
sifvlx:	ret


;================================================================
;  Set all multiple record IN points and VTR to MULT_TABLE
SetIO_Multrecord:
	test	MultRec_Flags,Enabled_MSBIT
	jz	vtrmusx
	mov	bx,offset Multrecord_Table
vtrmus:	mov	al,[bx]
	inc	bx
	cmp	al,0ffh
	jz	vtrmusx
	or	al,al			; Don't set record machine
	jz	vtrmus
	push	bx
	call	Machine_Change
	call	Set_In_From_Vtr_Loc
	call	_VVV_compensateIN
	call	vtr_setin
	pop	bx
	jmp	vtrmus
vtrmusx:ret


;================================================================
; If SLAVES ARE ON,
;  Set all slave IN points and VTR to MULT_TABLE
SetIO_Slaves:
	test	Slave_Flags,Enabled_MSBIT
	jz	vtrsusx
	mov	bx,offset Slave_Table
vtrsus:	mov	al,[bx]
	inc	bx
	cmp	al,0ffh
	jz	vtrsusx
	or	al,al			; Don't set record machine
	jz	vtrsus
	push	bx
	call	setmult
	call	Machine_Change
	call	Set_In_From_Vtr_Loc
	call	_VVV_compensateIN
	call	_FrameStoreCompensate	; Compensate for frame stores
	call	vtr_setin
	pop	bx
	jmp	vtrsus
vtrsusx:ret

; Set the RECORD machine parameters
SetIO_RVTR:
	xor	al,al
	call	Machine_Change		; Switch to R-VTR
	call	_get_in
	jnz	SetIO_RVTR1
	call	Mark_Inpoint		; Mark in INPOINT
	call	_Save_Marktable		; Save Ins, Outs, Durs...
	call	_upd_getscr		; Redraw the screen
	call	_get_in			; Retrieve the marked inpoint
SetIO_RVTR1:
	call	_VVV_compensateIN	; Compensate w/ offset if Preview
	call	vtr_setin		; Set the inpoint
	call	_get_out		; Get the outpoint
	call	_VVV_compensateOUT	; Compensate w/ offset if Preview
	call	vtr_setout		; Set the outpoint
	ret

;================================================================
; Set proper VTR for OPEN END EDIT
; Set Openend_Flag to TRUE
SetIO_OpenEnd:
	xor	al,al			; Prepare for R-VTR if BVB
	cmp	Vtr_Mult_Type,V_bvb		; Check for BVB
	jnz	SetOE1
	mov	al,To_Machine
SetOE1:	call	Machine_Change
	mov	Openend_Flag,0ffh
;;;	mov	bx,offset Hrs_Cnt	; If open end edit,
;;;	call	vtr_setdur		;  = in point + 1 hour
	mov	bx,offset Sort_Tcfmt ;Hrs_Cnt
	mov	ax,offset M_set_duration
	call	vtr_sendnd		;  for the tc generator

	ret

;................................................................
; Set VLAN timer to zero
clear_delay:
	push	ax
	push	bx
	push	cx
	mov	ax,offset M_roll_begin
	mov	ch,0
	call	vtr_opt
	mov	ax,offset M_roll_end
	mov	ch,0
	call	vtr_opt
	pop	cx
	pop	bx
	pop	ax
	ret

_TEXT	ends


_DATA	segment byte public 'DATA'
locnode		db	0
enabletype	db	0
editstatus	dw	0
lookaheadfcm	db	0
_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

