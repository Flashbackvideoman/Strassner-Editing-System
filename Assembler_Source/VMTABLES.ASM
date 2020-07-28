; Last revised: 2-22-1995, 11:12:23   (C)1989-1995 Norman H. Strassner

; VMTABLES.ASM
; Storage module for SES.ASM and other related assembly files

include vm.equ


extrn Vlan_Patterns:word,ESAM2_commands:word,List_Scr:word
extrn SMPTE_commands:word,Vlan_Patterns:word,gvg100_pbv:word,gvg_wipes:word
extrn list_scr:word,pegasus_wipes:word,pyxis_wipes:word,gvg100_pba:word
extrn ross_wipes:word
extrn AUenable:near,SW_allstop:near
extrn A_Machine:near,Allreels:near,Audio1_Select:near,Audio2_Select:near
extrn Audio3_Select:near,Audio4_Select:near,AutoPmcMatch:near
extrn Aux_Machine:near,Blk_Machine:near,Break:near,Clean_Toggle:near
extrn Color_change:near,Constant_Menu:near,Cut_Dlg:near,Disdlg:near
extrn Diskon_Toggle:near,Dur_Routine:near,EDLtrak_Toggle:near
extrn EDLtrkone_toggle:near,Event_Change:near,ExactSpeed:near,Exchange:near
extrn Frame_Toggle:near,Hardaud1:near,Hardaud2:near,Hardvid:near,INSTL10:near
extrn INSTL11:near,INSTL12:near,INSTL13:near,INSTL14:near,INSTL15:near
extrn INSTL16:near,INSTL17:near,INSTL18:near,INSTL19:near,INSTL1:near
extrn INSTL20:near,INSTL21:near,INSTL22:near,INSTL23:near,INSTL24:near
extrn INSTL25:near,INSTL26:near,INSTL27:near,INSTL2:near,INSTL3:near
extrn INSTL4:near,INSTL5:near,INSTL6:near,INSTL7:near,INSTL8:near,INSTL9:near
extrn In_Routine:near,Install:near,Key_Cmd:near,Keyboard:near
extrn Keyboard_Break:near,LINKS:near,Last_Marks:near,Make_Dissolve:near
extrn Make_Wipe:near,MarkIn:near,Markout:near,Modes_Off:near
extrn MotionControlMenu:near,MultRec:near,Multtrim_IN:near,Multtrim_OUT:near
extrn Out_Routine:near,PQR_dn:near,PQR_end:near,PQR_hom:near,PQR_lft:near
extrn PQR_nm:near,PQR_rht:near,PQR_up:near,PQR_xit:near,PauseForTime:near
extrn Play_Music:near,PreReadOnOff:near,Preread:near,Print_Toggle:near
extrn R_Machine:near,RampVtrSpeed:near,ReCalcWorkspace:near,Reel_Change:near
extrn Reel_Summary:near,Restart:near,Rp_Toggle:near,SS_toggle:near
extrn SS_undo:near,SWenable:near,Save_Marks:near,Set_Postroll:near
extrn Set_Preroll:near,Sort_Toggle:near,Split_Cmd:near,Split_Screen:near
extrn Swap_Vtrs:near,Synctag:near,Synctagext:near,Tag_Toggle:near,Taggit:near
extrn Trans_Switch:near,Trim_In:near,Trim_Out:near,UndoWorkspace:near
extrn Video_Select:near,Wild_Key1:near,Wild_Key2:near,Wipe_Dlg:near
extrn add_event:near,all_cue:near,all_disable:near,all_enable:near
extrn all_still:near,all_stop:near,assemble:near,assemble_this:near
extrn bell_toggle:near,bump_minus:near,bump_plus:near,cancel_request:near
extrn clear_edit:near,clear_event_list:near,clear_read:near
extrn clear_workspace:near,constant_select:near,copywrite:near,cue:near
extrn dbl_zeros:near,delete_event:near,display_toggle:near,eject:near
extrn ememopts:near,enable_toggle:near,event_commands:near,event_recall:near
extrn evnt_Lastplace:near,fastfwd:near,fevent_recall:near,find:near
extrn frames:near,from_CrntConst0:near,from_CrntConst:near,from_PMC:near
extrn from_a:near,from_aux:near,from_b:near,from_blk:near,from_c:near
extrn from_calculator:near,from_d:near,from_dur:near,from_e:near
extrn from_evnt:near,from_f:near,from_in:near,from_loc:near,from_out:near
extrn from_r:near,from_time:near,gotoin:near,gotoout:near,gpi:near
extrn insert_event:near,kbd_escape:near,keyhelp:near,keylayout:near
extrn load_file:near,log_Drive_shortcut:near,macro_change:near
extrn macro_record:near,macro_select:near,markon:near,match:near
extrn matchext:near,move_events:near,newednum_cmd:near,note:near
extrn open_end:near,page_dn:near,page_file:near,page_up:near,pause:near
extrn play:near,print_file:near,rdloop_back:near,rdloop_backspace:near
extrn rdloop_ctrlx:near,rdloop_dblzero:near,rdloop_delete:near
extrn rdloop_enter:near,rdloop_eol:near,rdloop_escape:near
extrn rdloop_forward:near,rdloop_insert:near,rdloop_oldstring:near
extrn rdloop_sol:near,read:near,read_enter:near,receive:near
extrn replace_event:near,reverse:near,rewind:near,save_file:near
extrn scroll_Constants:near,scroll_constback:near,scroll_last:near
extrn scroll_next:near,search:near,seek_event:near,seek_first:near
extrn seek_last:near,send:near,setdflts_file:near,shell2cct:near
extrn shell2dos:near,shell2olm:near,shift_list:near,showdir:near
extrn shuttleback:near,shuttlefwd:near,slowfwd:near,slowrev:near,sortedl:near
extrn speed_fill:near,srchfwd:near,srchrev:near,still:near,stop:near
extrn stopwatch:near,switch_bins:near,switch_tc:near,tccalc:near
extrn timeline_stats:near,title_file:near,transmit:near,twicefwd:near
extrn twicerev:near,undo:near,varifwd:near,varirev:near,vtr_bv:near
extrn vtr_bvb:near,vtr_counter:near,vtr_record:near,vtr_rehearse:near
extrn vtr_review:near,vtr_vb:near,vtr_vbv:near,vtr_vv:near,xmac10:near
extrn xmac1:near,xmac2:near,xmac3:near,xmac4:near,xmac5:near,xmac6:near
extrn xmac7:near,xmac8:near,xmac9:near,xterm:near,SwapVideoSwitcherPorts:near


;================================================================
_DATA	segment para public 'DATA'
	assume ds:_DATA

public Scr_Rm_In,Locations_Scr,Diagloc_Scr,CommandFlag_Table
public Cmdtbl1, Cmdtbl2, Cmdtbl3, INSTL_Jmps
Public Cmdtbl4, Position_Query_Table, SScreen_Cmdtbl, Xlt_Tbl
Public AVT_Cb, BVT_Cb, CVT_Cb, DVT_Cb, EVT_Cb, FVT_Cb, AUXVT_Cb, BLKVT_Cb
public Color_Pointer,Color_Table,Available_Colors
public Vtrcmds,Vtrstat
public SX_Types,SX_Switcher_Types,AX_Types,AX_Switcher_Types,PX_Types,PX_Switcher_Types
public Machine_Lables,Auxmmsg,Blkmmsg
public Title_EDLev,Title_Header,Fcm_EDLev,Fcm_Header,Type_EDLev,Type_Header
public Split_EDLev,Split_Header,Gpi_EDLev,Gpi_Header,Slave_EDLev,Slave_Header
public Start_EDLev,Start_Header,Tstamp_EDLev,Tstamp_Header,Spd_EDLev,Spd_Header
public Pmc_EDLev,Pmc_Header,Rec_EDLev,Rec_Header,Reelsum_EDLev,Reelsum_Header
public efx_EDLev,efx_header,ramp_EDLev,ramp_header,Flag2,Cln_Msg
public Lst_Msg,Tag_Msg,Tag2_Msg,Srt_Msg,Gpi_Msg,Swenabl_Msg
public Auenabl_Msg,Avenabl_Msg,Master_Msg,Frames_Msg,Diskon_Msg,Novlan_Msg
public ramp_msg,noref_msg,Edltrack_Msg,Edlsrch_Msg,Preread_Msg,spaces
public Starspace_Msg,Badmode_Fill,From_R_Msg,From_A_Msg,From_B_Msg,From_C_Msg
public From_D_Msg,From_E_Msg,From_F_Msg,From_Aux_Msg,From_Blk_Msg,AXstd_Msg
public BLstd_Msg,Fromin_Msg,Fromout_Msg,Fromdur_Msg,Fromloc_Msg,Fromtime_Msg
public Fromcalc_Msg,Pmc_Msg,Spd_Msg,Editspeed_Msg,Spdchg_Msg,Speed_Msg
public Fps_Msg,Framesec_Msg,Ofspeed_Msg,Spdbufsel_Msg,Speedbuf_Msg,Speedbuf_Msg
public Spdkil_Msg,Spdall_Msg,Fillhdr_Msg,Speedhdr_Msg,Learnmac_Msg,Macro_File_Msg
public Emem_File_Msg,_Save_File_Msg,_Load_File_Msg,Kilfil_Msg,List_Msg,Button_Msg
public Nobutton_Msg,Vt_Msg,Mcrosep,Cmt_Prmt,Constant_Msg,Execute_Msg
public Empty_Msg,Untitled_Msg,Contents_Msg,Mcd_Msg,Page_Msg,Continued_Msg
public Pause_Msg,Threedots_Msg,File_Msg,Loaded_Msg,Saved_Msg,Killed_Msg
public editstatus_msgs,Openend_Msg,Synching_Msg,Record_Msg,Preview_Msg
public Replay_Msg,Bvb_Msg,Vbv_Msg,Vvv_Msg,Testing_Msg,Pvw_Msg
public Rev_Msg,Per_Msg,Noed_Msg,Hotswitch_Msg,Yes_Msg,No_Msg
public Disable_Msg,Enable_Msg,Selvtr_Msg,Cut_Type,Dissolve_Type,Wipe_Msg
public Key_Type,Keyfor_Msg,Keyover_Msg,Keybkgnd_Msg,Keyfade_Msg,Keyinout_Msg
public Split_Type,Split_What_Msg,Split_When_Msg,Split_Dly_Msg,Split_Vid_Msg,Split_Aud_Msg
public Without_Msg,Frame_Msg,Code_Msg,Flag3,Select1to_Msg,Selectfile_Msg
public Gcmdtype_Msg,Adjust_Msg,Done_Msg,Assemble_Msg,Asmmode_Msg,Assembly_Msg
public Asmcomplete_Msg,Asmaborted_Msg,Vtrsyncerr_Msg,Forreel_Msg,Reel_Msg,orall_msg
public Sfcm_Msg,SeekFLE_Msg,Where_Msg,Areusure,Surenuf_Msg,Event_Msg
public Cancelauto_Msg,Asyougo_Msg,Alreadyon_Msg,AutoTrim_Msg,Link_Msg,Multr_Msg
public Swapvtr_Msg,Printing_Msg,Endofprint_Msg,Edl_Msg,As_Msg,New_Dflts_Msg
public Dflt_File_Msg,Reelsused_Msg,Nopath_Msg,Dirpath_Msg,Logd_Msg,Logauto_Msg
public Logtcm_Msg,Logvme_Msg,Logtmp_Msg,Page_Qry,Title_Msg,Edlis_Msg
public Dropframe_Msg,Nondrop_Msg,Filename_Msg,Event_Rple_Msg,View_Msg,Viewsavlod_Msg
public Viewend_Msg,Pagend_Msg,Edlscroll_Msg,Tcval_Msg,Keyboard_Msg,Trim_Msg
public In_Msg,Out_Msg,Time_Msg,Port_Msg,Crosspoint_Msg,Resetting_Msg
public Listttl_Msg,Recout_Msg,Recdur_Msg,Nodos_Msg,Noovl_Msg,Badovl_Msg
public Videocard_Msg,Append_Msg,Badcrash_Msg,alreadyhere_msg,Badjoystick_Msg,Nxptcom_Msg
public CtrTable,Flag4,Memful,Nowild_Msg,Wild_Msg,Joggerkey_Msg
public Anyway_Msg,mode_msg,Crlf_Msg,Space_Msg,BadDOSfname_Msg,InDosFname_Msg
public Flag5,Port,Nport,Seloffset,ctr_CUTS,sel_CUTS
public ctr_DISSOLVE,sel_DISSOLVE,ctr_SES,sel_SES,Seloffset,ctr_DISSOLVE
public sel_DISSOLVE,ctr_CUTS,sel_CUTS,ctr_SES,sel_SES,Seloffset
public ctr_SES,sel_SES,ctr_DISSOLVE,sel_DISSOLVE,ctr_CUTS,sel_CUTS
public Tcdispbuf,Cimsg_Spaces,Cimsg_String
public Variable_Table,Jstickx_Table,Swjstick_Table,Rowtbl
public CASEID,SESID,Pathspec,Comspec,Dos_Cmd,Dos_Tail,PointShootTables
public Dir_Tail,Dir_Opts,Command_Runopt,Switcher_Tail,Olm_Cmd,Olm_Tail
public Olm_Manual,olm_kbdlayout,TMP_File,SES_file,Menu_File,Backup_File
public Editlist_File,Default_File,Ovrlay_File,Clean_File,Findme,EIF_Ext
public TCM_Ext,VME_Ext,Script_File,INI_Ext,Drive,Filename_Ptr
public Thousand,Dstart_Cnt,Dplay_Cnt,Dtest_Cnt,Hrs_Cnt,Min_Cnt
public Sec_Cnt,Frm_Cnt,Dmin_Cnt,Sort_Tcfmt,Twenty4hrs,Twenty4hrs_N
public Hundredhrs,Dhours_Table,Dminutes_Table,Dseconds_Table,Nseconds_Table,Nhours_Table
public Nminutes_Table,Hrs_Cnt,Min_Cnt,Sec_Cnt,Frm_Cnt,Dmin_Cnt
public Pal_TruthTable

;================================================================
Color_Pointer	db	0
;			BKG	  GRID	    EDL	      CNTREDL	WRKSPCE	  DIM	    NORM      REV
Color_Table	db	00000000b,00000111b,00000111b,00001111b,00000111b,00000111b,00001111b,01110000b,00000001b,0,0,0,0,0,0,0;1 mono *
		db	00000000b,00001011b,00001011b,00001111b,00001011b,00001011b,00001111b,01110000b,00001110b,0,0,0,0,0,0,0;1 mono
		db	00000000b,00001001b,00001001b,00001111b,00001001b,00001001b,00001111b,01110000b,00001110b,0,0,0,0,0,0,0;1 mono
		db	00000000b,00001001b,00001011b,00001111b,00001011b,00001011b,00001111b,01110000b,00001110b,0,0,0,0,0,0,0;1 mono
		db	00000000b,00001110b,00001110b,00001111b,00001110b,00001110b,00001111b,01110000b,00001100b,0,0,0,0,0,0,0;1 mono
		db	00010000b,00000111b,00000111b,00001111b,00000111b,00000111b,00001111b,01110000b,00001100b,0,0,0,0,0,0,0;1 w/blue bkg *
		db	00010000b,00001011b,00001011b,00001111b,00001011b,00001011b,00001111b,01110000b,00001100b,0,0,0,0,0,0,0;1 w/blue bkg *
		db	00010000b,00001110b,00001110b,00001111b,00001110b,00001110b,00001111b,01110000b,00001100b,0,0,0,0,0,0,0;1 w/blue bkg *

;;		db	01110000b,01110000b,01110000b,01110000b,01110000b,01110000b,01110000b,00000111b,00010000b,0,0,0,0,0,0,0;1 mono *

Available_Colors	db	($ - Color_Table) / 16


;====================================================================
;	Keys command table (Starts at an event page address)
	align 16
Cmdtbl1	dw	Rm_xcmd			,R_Machine
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
	dw	VariFwd_xcmd		,varifwd
	dw	VariRev_xcmd		,varirev

	dw	Twicefwd_xcmd		,twicefwd
	dw	Twiceplay_xcmd		,twicefwd
	dw	Twicerev_xcmd		,twicerev
	dw	Reverse_xcmd		,reverse
	dw	Cue_xcmd		,cue
	dw	Search_xcmd		,search
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
	dw	Rehearse_xcmd		,vtr_rehearse
	dw	Record_xcmd		,vtr_record
	dw	Review_xcmd		,vtr_review
	dw	Vbv_xcmd		,vtr_vbv
	dw	Bvb_xcmd		,vtr_bvb

	dw	VV_xcmd			,vtr_vv
	dw	BV_xcmd			,vtr_bv
	dw	VB_xcmd			,vtr_vb

	dw	Assemble_xcmd		,assemble
	dw	Asmthis_xcmd		,assemble_this
	dw	Scrini_xcmd		,cancel_request
	dw	Status_xcmd		,Install
	dw	Const_xcmd		,Constant_Menu
	dw	Macch_xcmd		,macro_change
	dw	Macro_xcmd		,macro_select
	dw	Rptgl_xcmd		,Rp_Toggle
	dw	Tagit_xcmd		,Taggit
	dw	Tgtgl_xcmd		,Tag_Toggle
	dw	Snctg_xcmd		,Synctag
	dw	Ptgl_xcmd		,Print_Toggle
	dw	Clean_xcmd		,Clean_Toggle
	dw	Tglenable_xcmd		,enable_toggle
	dw	Sorttgl_xcmd		,Sort_Toggle
	dw	Rcmpt_xcmd		,ReCalcWorkspace
	dw	Rstrt_xcmd		,Restart
	dw	Title_xcmd		,title_file
	dw	Logdr_xcmd		,log_Drive_shortcut
	dw	Setdflts_xcmd		,setdflts_file
	dw	Shodr_xcmd		,showdir
	dw	Savfl_xcmd		,save_file
	dw	Lodfl_xcmd		,load_file
	dw	Inrtn_xcmd		,In_Routine
	dw	Outrt_xcmd		,Out_Routine
	dw	Durrt_xcmd		,Dur_Routine
	dw	Trimin_xcmd		,Trim_In
	dw	Trimout_xcmd		,Trim_Out
	dw	Vidsel_xcmd		,Video_Select
	dw	Au1sel_xcmd		,Audio1_Select
	dw	Au2sel_xcmd		,Audio2_Select
	dw	Swrcl_xcmd		,Audio3_Select
	dw	Emlrn_xcmd		,Audio4_Select
	dw	Cut_xcmd		,Cut_Dlg
	dw	Dis_xcmd		,Disdlg
	dw	Wip_xcmd		,Wipe_Dlg
	dw	Key_xcmd		,Key_Cmd
	dw	Split_xcmd		,Split_Cmd
	dw	Transw_xcmd		,Trans_Switch
	dw	Makdiss_xcmd		,Make_Dissolve
	dw	Makwipe_xcmd		,Make_Wipe
	dw	Scrconst_xcmd		,scroll_Constants
	dw	Scrconstb_xcmd		,scroll_constback
	dw	Scnxt_xcmd		,scroll_next
	dw	Sclst_xcmd		,scroll_last
	dw	Home_key		,seek_first
	dw	End_key			,seek_last
	dw	Pageup_key		,page_up
	dw	Pagedn_key		,page_dn
	dw	Opend_xcmd		,open_end
	dw	Erecal_xcmd		,event_recall
	dw	Reel_xcmd		,Reel_Change
	dw	ChgEv_xcmd		,Event_Change
	dw	ChgEvNum_xcmd		,newednum_cmd
	dw	Seeke_xcmd		,seek_event
	dw	Cmnt_xcmd		,note
	dw	Cllst_xcmd		,clear_event_list
	dw	Pagef_xcmd		,page_file
	dw	AddEv_xcmd		,add_event
	dw	DelEv_xcmd		,delete_event
	dw	InsEv_xcmd		,insert_event
	dw	RepEv_xcmd		,replace_event
	dw	Cledt_xcmd		,clear_edit
	dw	Shift_xcmd		,shift_list
	dw	Sort_xcmd		,sortedl
	dw	Exch_xcmd		,Exchange
	dw	Savemarks_xcmd		,Save_Marks
	dw	Lastmarks_xcmd		,Last_Marks
	dw	Match_xcmd		,match
	dw	Quit_xcmd		,Break
	dw	Keyhlp_xcmd		,keyhelp
	dw	Kbdhlp_xcmd		,keylayout
	dw	Clwrk_xcmd		,clear_workspace
	dw	Move_xcmd		,move_events
	dw	Cpywrt_xcmd		,copywrite
	dw	Receive_xcmd		,receive
	dw	Transmit_xcmd		,transmit
	dw	Send_xcmd		,send
	dw	Xterm_xcmd		,xterm
	dw	Read_xcmd		,read
	if DEBUGGER
	dw	Debug_xcmd		,debug
	endif
	dw	Preroll_xcmd		,Set_Preroll
	dw	Postroll_xcmd		,Set_Postroll
	dw	Shell_xcmd		,shell2dos
	dw	Bins_xcmd		,switch_bins
	dw	Olm_xcmd		,shell2olm
	dw	Display_xcmd		,display_toggle
	dw	Frecal_xcmd		,fevent_recall
	dw	Music_xcmd		,Play_Music
	dw	GPI_xcmd		,gpi
	dw	Links_xcmd		,LINKS
	if NOT CUTS_ONLY
	dw	Swenabl_xcmd		,SWenable
	dw	Auenabl_xcmd		,AUenable
	endif
	dw	Allenable_xcmd		,all_enable
	dw	Alldisable_xcmd		,all_disable
	dw	Prntfil_xcmd		,print_file
	dw	Allreels_xcmd		,Allreels
	if not CUTS_ONLY
	dw	Ememopts_xcmd		,ememopts
	endif
	dw	Undo_xcmd		,undo
	dw	Five_key		,evnt_Lastplace
	dw	Tccalc_xcmd		,tccalc
	dw	Insert_key		,Wild_Key1
	dw	Delete_key		,Wild_Key2
	dw	Framesw_xcmd		,Frame_Toggle
	dw	Find_xcmd		,find
	dw	Eject_xcmd		,eject
	dw	Diskon_xcmd		,Diskon_Toggle
	dw	Counter_xcmd		,vtr_counter
	dw	Thisevent_xcmd		,markon
	dw	Stopwatch_xcmd		,stopwatch
	dw	Switchtc_xcmd		,switch_tc
	dw	Hardvid_xcmd		,Hardvid
	dw	Hardaud1_xcmd		,Hardaud1
	dw	Hardaud2_xcmd		,Hardaud2
	dw	Modesoff_xcmd		,Modes_Off
	dw	MulttrimIN_xcmd		,Multtrim_IN
	dw	MulttrimOUT_xcmd	,Multtrim_OUT
	dw	RcmptEDL_xcmd		,INSTL15
	dw	EDLtrack_xcmd		,EDLtrak_Toggle
	dw	EDLtrkone_xcmd		,EDLtrkone_toggle
	dw	Progspeed_xcmd		,MotionControlMenu
	dw	MatchPMC_xcmd		,AutoPmcMatch
	dw	MatchExt_xcmd		,matchext
	dw	SncTgExt_xcmd		,Synctagext

	if ALLOWED_VTRS EQ 7
	dw	Fill_xcmd		,speed_fill
	dw	Ctrl_Astrck		,event_commands
	dw	F11_key			,timeline_stats
	dw	PrereadOnOff_xcmd	,PreReadOnOff
	if ALLOWRAMPSPEED
	dw	Rampspeed_xcmd		,RampVtrSpeed
	ENDIF
	endif

	dw	Splitscrn_xcmd		,Split_Screen
	dw	Xmac1_xcmd		,xmac1
	dw	Xmac2_xcmd		,xmac2
	dw	Xmac3_xcmd		,xmac3
	dw	Xmac4_xcmd		,xmac4
	dw	Xmac5_xcmd		,xmac5
	dw	Xmac6_xcmd		,xmac6
	dw	Xmac7_xcmd		,xmac7
	dw	Xmac8_xcmd		,xmac8
	dw	Xmac9_xcmd		,xmac9
	dw	Xmac10_xcmd		,xmac10
	dw	Clrrd_xcmd		,Keyboard
	dw	Frame_xcmd		,Keyboard
	dw	Ctrlbreak_xcmd		,Keyboard_Break
	dw	Suspend_key		,Keyboard
	dw	Color_xcmd		,Color_change
	dw	Bell_xcmd		,bell_toggle
	dw	Macterm_xcmd		,macro_record
	dw	Pausetime_xcmd		,PauseForTime
	dw	UndoWorkspace_xcmd	,UndoWorkspace
	if ALLOWED_VTRS EQ 7
	dw	MultRecord_xcmd		,MultRec
	endif
	dw	Preread_xcmd		,Preread
	dw	VtrSwap_xcmd		,Swap_Vtrs
	dw	Reelsum_xcmd		,Reel_Summary
	dw	CCT_xcmd		,shell2cct
	dw	ExactSpeed_xcmd		,ExactSpeed
	dw	Swlrn_xcmd		,SW_allstop
	dw	SwapVidSwitcher_xcmd	,SwapVideoSwitcherPorts
	dw	Escape_xcmd		,Keyboard

	dw	0ffffh,0ffffh

; Commands allowed during Editing operations
Cmdtbl2	dw	Scrini_xcmd		,cancel_request
	dw	Tgtgl_xcmd		,Tag_Toggle
	dw	Ptgl_xcmd		,Print_Toggle
	dw	Clean_xcmd		,Clean_Toggle
	dw	Sorttgl_xcmd		,Sort_Toggle
	dw	Title_xcmd		,title_file
	dw	Scrconst_xcmd		,scroll_Constants
	dw	Scrconstb_xcmd		,scroll_constback
	dw	Scnxt_xcmd		,scroll_next
	dw	Sclst_xcmd		,scroll_last
	dw	Home_key		,seek_first
	dw	End_key			,seek_last
	dw	Pageup_key		,page_up
	dw	Pagedn_key		,page_dn
	dw	Cmnt_xcmd		,note
	dw	Match_xcmd		,match
	dw	Bins_xcmd		,switch_bins
	dw	Display_xcmd		,display_toggle
	dw	Tglenable_xcmd		,enable_toggle
	dw	Const_xcmd		,Constant_Menu
	dw	Search_xcmd		,search
	dw	Xmac1_xcmd		,xmac1
	dw	Xmac2_xcmd		,xmac2
	dw	Xmac3_xcmd		,xmac3
	dw	Xmac4_xcmd		,xmac4
	dw	Xmac5_xcmd		,xmac5
	dw	Xmac6_xcmd		,xmac6
	dw	Xmac7_xcmd		,xmac7
	dw	Xmac8_xcmd		,xmac8
	dw	Xmac9_xcmd		,xmac9
	dw	Xmac10_xcmd		,xmac10
	dw	0ffffh			,0ffffh

; tc_cimsg commands
Cmdtbl3	dw	Enter_xcmd	,read_enter
	dw	Clrrd_xcmd	,clear_read
	dw	Escape_xcmd	,kbd_escape
	dw	Search_xcmd	,kbd_escape
	dw	Space_xcmd	,kbd_escape
	dw	Scrini_xcmd	,kbd_escape
	dw	Const_xcmd	,constant_select
	dw	Dbl0_xcmd	,dbl_zeros
	dw	Frame_xcmd	,frames
	dw	Rm_xcmd		,from_r
	dw	Am_xcmd		,from_a
	if ALLOWED_VTRS GT 2
	dw	Bm_xcmd		,from_b
	endif
	if ALLOWED_VTRS GT 3
	dw	Cm_xcmd		,from_c
	endif
	if ALLOWED_VTRS GT 4
	dw	Dm_xcmd		,from_d
	endif
	if ALLOWED_VTRS GT 5
	dw	Em_xcmd		,from_e
	endif
	if ALLOWED_VTRS GT 6
	dw	Fm_xcmd		,from_f
	endif
	dw	Au_xcmd		,from_aux
	dw	Bl_xcmd		,from_blk
	dw	Thisevent_xcmd	,from_evnt
	dw	Inrtn_xcmd	,from_in
	dw	Outrt_xcmd	,from_out
	dw	Durrt_xcmd	,from_dur
	dw	Counter_xcmd	,from_loc
	dw	Markin_xcmd	,from_loc
	dw	Markout_xcmd	,from_loc
	dw	Vbv_xcmd	,from_time
	dw	Tccalc_xcmd	,from_calculator
	dw	Scrconst_xcmd	,from_CrntConst
	dw	Scrconstb_xcmd	,from_CrntConst0
	dw	Progspeed_xcmd	,from_PMC
;;	dw	MatchPMC_xcmd	,AutoPmcMatch
	dw	0ffffh		,0ffffh

; Commands used by line input routine
Cmdtbl4	dw	Enter_xcmd	,rdloop_enter
	dw	Escape_xcmd	,rdloop_escape
	dw	Ctrlx_xcmd	,rdloop_ctrlx
	dw	Bump_Minus_xcmd	,rdloop_sol
	dw	Ctrlhome_key	,rdloop_sol
	dw	Bump_Plus_xcmd	,rdloop_eol
	dw	Ctrlend_key	,rdloop_eol
	dw	Pause_xcmd	,rdloop_insert
	dw	Ctrlins_key	,rdloop_insert
	dw	Search_xcmd	,rdloop_delete
	dw	Ctrldel_key	,rdloop_delete
	dw	Srchrev_xcmd	,rdloop_back
	dw	Ctrlleft_key	,rdloop_back
	dw	Srchfwd_xcmd	,rdloop_forward
	dw	Ctrlright_key	,rdloop_forward
	dw	Rcmpt_xcmd	,rdloop_oldstring
	dw	Dbl0_xcmd	,rdloop_dblzero
	dw	Backspace_xcmd	,rdloop_backspace
	dw	0ffffh		,0ffffh


Position_Query_Table	equ	$
	dw	Home_key	,PQR_hom
	dw	End_key		,PQR_end
	dw	Scnxt_xcmd	,PQR_dn
	dw	Pause_xcmd	,PQR_dn
	dw	Sclst_xcmd	,PQR_up
	dw	Search_xcmd	,PQR_up
	dw	Yeskey_xcmd	,PQR_lft
	dw	Srchrev_xcmd	,PQR_lft
	dw	Nokey_xcmd	,PQR_rht
	dw	Srchfwd_xcmd	,PQR_rht
	dw	Colonplus_xcmd	,PQR_nm
	dw	Enter_xcmd	,PQR_xit
	dw	0ffffh		,0ffffh

SScreen_Cmdtbl	dw	Enter_xcmd	,SS_toggle
		dw	Scnxt_xcmd	,scroll_next
		dw	Sclst_xcmd	,scroll_last
		dw	Home_key	,seek_first
		dw	End_key		,seek_last
		dw	Pageup_key	,page_up
		dw	Pagedn_key	,page_dn
		dw	Thisevent_xcmd	,markon
		dw	Tglenable_xcmd	,enable_toggle
		dw	Allenable_xcmd	,all_enable
		dw	Alldisable_xcmd	,all_disable
		dw	Five_key	,evnt_Lastplace
		dw	DelEv_xcmd	,delete_event
		dw	Seeke_xcmd	,seek_event
		dw	Move_xcmd	,move_events
		dw	Undo_xcmd	,SS_undo
		dw	Ctrl_Astrck	,event_commands
		dw	Bins_xcmd	,switch_bins
		dw	Cmnt_xcmd	,note
		dw	0ffffh		,0ffffh


; Key translation table
Xlt_Tbl	dw	Nument_key	,Enter_xcmd	; Enter=Enter
	dw	Cancel_key	,Scrini_xcmd	; scrini=scrini
	dw	0FF2BH		,Colonplus_xcmd ; +
	dw	0FF2Fh		,Scrini_xcmd	; \
	dw	0ffffh		,0ffffh


;================================================================
;ME_Single	equ	00000001b
;ME_Enter	equ	00000010b
;ME_Range	equ	00000100b
;ME_TC		equ	00001000b
;ME_Digit	equ	00010000b
;ME_6		equ	00100000b
;ME_7		equ	01000000b
;ME_8		equ	10000000b
;ME_null	equ	00000000b

CommandFlag_Table	equ	$
	dw	ME_Single		; R_Machine
	dw	ME_Single		; A_Machine
	if ALLOWED_VTRS GT 2
	dw	ME_Single		; b_machine
	endif
	if ALLOWED_VTRS GT 3
	dw	ME_Single		; c_machine
	endif
	if ALLOWED_VTRS GT 4
	dw	ME_Single		; d_machine
	endif
	if ALLOWED_VTRS GT 5
	dw	ME_Single		; e_machine
	endif
	if ALLOWED_VTRS GT 6
	dw	ME_Single		; f_machine
	endif
	dw	ME_Single		; Aux_Machine
	dw	ME_Single		; Blk_Machine
	dw	ME_Single		; stop
	dw	ME_Single		; pause
	dw	ME_Single		; still
	dw	ME_Single		; play
	dw	ME_Single		; fastfwd
	dw	ME_Single		; rewind
	dw	ME_Single		; shuttlefwd
	dw	ME_Single		; shuttleback
	dw	ME_Single		; vari fwd
	dw	ME_Single		; vari rev
	dw	ME_Single		; twicefwd
	dw	ME_Single		; twicefwd
	dw	ME_Single		; twicerev
	dw	ME_Single		; reverse
	dw	ME_Single		; cue
	dw	ME_Enter AND ME_TC	; search
	dw	ME_Single		; srchfwd
	dw	ME_Single		; srchrev
	dw	ME_Single		; slowfwd
	dw	ME_Single		; slowrev
	dw	ME_Single		; MarkIn
	dw	ME_Single		; Markout
	dw	ME_Single		; all_still
	dw	ME_Single		; all_stop
	dw	ME_Single		; all_cue
	dw	ME_Single		; gotoin
	dw	ME_Single		; gotoout
	dw	ME_Single		; bump_plus
	dw	ME_Single		; bump_minus
	dw	ME_Single		; vtr_rehearse
	dw	ME_Single		; vtr_record
	dw	ME_Single		; vtr_review
	dw	ME_Single		; vtr_vbv
	dw	ME_Single		; vtr_bvb
	dw	ME_Single		; vtr_vv
	dw	ME_Single		; vtr_bv
	dw	ME_Single		; vtr_vb

	dw	ME_Enter		; assemble
	dw	ME_Single		; assemble_this
	dw	ME_Single		; cancel_request
	dw	ME_Enter		; Install
	dw	ME_Enter OR ME_TC	; Constant_Menu
	dw	ME_Enter		; macro_change
	dw	ME_Digit		; macro_select
	dw	ME_Single		; Rp_Toggle
	dw	ME_Single		; Taggit
	dw	ME_Single		; Tag_Toggle
	dw	ME_Single		; Synctag
	dw	ME_Single		; Print_Toggle
	dw	ME_Single		; Clean_Toggle
	dw	ME_Single		; enable_toggle
	dw	ME_Single		; Sort_Toggle
	dw	ME_Single		; ReCalcWorkspace
	dw	ME_Single		; Restart
	dw	ME_Enter		; title_file
	dw	ME_Enter		; log_Drive_shortcut
	dw	ME_Enter		; setdflts_file
	dw	ME_Enter		; showdir
	dw	ME_Enter		; save_file
	dw	ME_Enter		; load_file

	dw	ME_Enter OR ME_TC	; In_Routine
	dw	ME_Enter OR ME_TC	; Out_Routine
	dw	ME_Enter OR ME_TC	; Dur_Routine
	dw	ME_Enter OR ME_TC	; Trim_In
	dw	ME_Enter OR ME_TC	; Trim_Out

	dw	ME_Single		; Video_Select
	dw	ME_Single		; Audio1_Select
	dw	ME_Single		; Audio2_Select
	dw	ME_Single		; Audio3_Select
	dw	ME_Single		; Audio4_Select
	dw	ME_Single		; Cut_Dlg
	dw	ME_Enter		; Disdlg
	dw	ME_Enter		; Wipe_Dlg
	dw	ME_Enter		; Key_Cmd
	dw	ME_Enter		; Split_Cmd
	dw	ME_Single		; Trans_Switch
	dw	ME_Single		; Make_Dissolve
	dw	ME_Single		; Make_Wipe
	dw	ME_Single		; scroll_Constants
	dw	ME_Single		; scroll_constback
	dw	ME_Single		; scroll_next
	dw	ME_Single		; scroll_last
	dw	ME_Single		; seek_first
	dw	ME_Single		; seek_last
	dw	ME_Single		; page_up
	dw	ME_Single		; page_dn
	dw	ME_Single		; open_end
	dw	ME_Single		; event_recall
	dw	ME_Enter		; Reel_Change
	dw	ME_Enter		; Event_Change
	dw	ME_Enter		; newednum_cmd
	dw	ME_Enter		; seek_event
	dw	ME_Enter		; note
	dw	ME_Single		; clear_event_list
	dw	ME_Enter		; page_file
	dw	ME_Single		; add_event
	dw	ME_Enter		; delete_event
	dw	ME_Enter		; insert_event
	dw	ME_Single		; replace_event
	dw	ME_Single		; clear_edit
	dw	ME_Enter		; shift_list
	dw	ME_Enter		; sortedl
	dw	ME_Single		; Exchange
	dw	ME_Enter OR ME_Digit	; Save_Marks
	dw	ME_Enter OR ME_Digit	; Last_Marks
	dw	ME_Single		; match
	dw	ME_Single		; Break
	dw	ME_Single			; keyhelp
	dw	ME_Single			; keylayout
	dw	ME_Single			; clear_workspace
	dw	ME_Enter		; move_events
	dw	ME_Single		; copywrite
	dw	ME_Single			; receive
	dw	ME_Single			; transmit
	dw	ME_Single			; send
	dw	ME_Single			; xterm
	dw	ME_Single			; read
	if DEBUGGER
	dw	ME_Single			; debug
	endif
	dw	ME_Enter OR ME_TC	; Set_Preroll
	dw	ME_Enter OR ME_TC	; Set_Postroll
	dw	ME_Single			; shell2dos
	dw	ME_Enter		; switch_bins
	dw	ME_Single			; shell2olm
	dw	ME_Single		; display_toggle
	dw	ME_Single		; fevent_recall
	dw	ME_Single		; Play_Music
	dw	ME_Enter		; gpi
	dw	ME_Enter		; LINKS
	if ALLOWED_VTRS EQ 7
	dw	ME_Single		; SWenable
	dw	ME_Single		; AUenable
	endif
	dw	ME_Single			; all_enable
	dw	ME_Single			; all_disable
	dw	ME_Single			; print_file
	dw	ME_Single			; Allreels
	if ALLOWED_VTRS EQ 7
	dw	ME_Single			; ememopts
	endif
	dw	ME_Single		; undo
	dw	ME_Single		; evnt_Lastplace
	dw	ME_Enter		; tccalc
	dw	ME_Single		; Wild_Key1
	dw	ME_Single		; Wild_Key2
	dw	ME_Single		; Frame_Toggle
	dw	ME_Enter		; find
	dw	ME_Single		; eject
	dw	ME_Single		; Diskon_Toggle
	dw	ME_Single		; vtr_counter
	dw	ME_Single		; markon
	dw	ME_Enter		; stopwatch
	dw	ME_Single		; switch_tc
	dw	ME_Single		; Hardvid
	dw	ME_Single		; Hardaud1
	dw	ME_Single		; Hardaud2
	dw	ME_Single		; Modes_Off
	dw	ME_Enter		; Multtrim_IN
	dw	ME_Enter		; Multtrim_OUT
	dw	ME_Enter		; INSTL15
	dw	ME_Single		; EDLtrak_Toggle
	dw	ME_Single		; EDLtrkone_toggle
	dw	ME_Single		; MotionControlMenu
	dw	ME_Single		;AutoPmcMatch
	dw	ME_Single		;matchext
	dw	ME_Single		;Synctagext

	if ALLOWED_VTRS EQ 7
	dw	ME_Single		; speed_fill
	dw	ME_Single		; event_commands
	dw	ME_Single		; timeline_stats
	if ALLOWRAMPSPEED
	dw	ME_Enter		; RampVtrSpeed
	ENDIF
	endif

	dw	ME_Single		; Split_Screen
	dw	ME_Single		; xmac1
	dw	ME_Single		; xmac2
	dw	ME_Single		; xmac3
	dw	ME_Single		; xmac4
	dw	ME_Single		; xmac5
	dw	ME_Single		; xmac6
	dw	ME_Single		; xmac7
	dw	ME_Single		; xmac8
	dw	ME_Single		; xmac9
	dw	ME_Single		; xmac10
	dw	ME_Single		; Keyboard
	dw	ME_Single		; Keyboard
	dw	ME_Single		; Keyboard_Break
	dw	ME_Single		; UndoWorkspace
	dw	ME_Single		; Keyboard
	dw	ME_Single		; Color_change
	dw	ME_Single		; bell_toggle
	dw	ME_Single		; macro_record
	dw	ME_Enter AND ME_TC	; pausetime
	if ALLOWED_VTRS EQ 7
	dw	ME_Enter		; MultRec
	endif
	dw	ME_Single		; Preread
	dw	ME_Single		; Swap_Vtrs
	dw	ME_Single		; Reel_Summary

	dw	ME_Single		; CCT
	dw	ME_Enter		; ExactSpeed
	dw	ME_Single		; Escape


;================================================================
INSTL_Jmps	dw	Install,INSTL1,INSTL2,INSTL3,INSTL4,INSTL5
		dw	INSTL6,INSTL7,INSTL8,INSTL9,INSTL10,INSTL11
		dw	INSTL12,INSTL13,INSTL14,INSTL15,INSTL16,INSTL17
		dw	INSTL18,INSTL19,INSTL20,INSTL21,INSTL22,INSTL23
		dw	INSTL24,INSTL25,INSTL26,INSTL27,0ffffh

;**********************************************************************
;	S C R E E N   P O S I T I O N I N G   T A B L E S
;----------------------------------------------------------------------
; DO NOT CHANGE THE ORDER OF THESE POINTS IN THE FOLLOWING THREE TABLES.
;----------------------------------------------------------------------

;table of terminal points
Scr_Rm_In	equ	$
	VTR_IOD_locs
Locations_Scr	equ	$
	VTR_LOC_locs	0
Diagloc_Scr	equ	$
	if ALLOWED_VTRS LT 7
	VTR_LOC_locs	100h
	else
	VTR_LOC_locs	200h
	endif


;MACH#, REEL ID POINTER, REEL Cursor, MACHINE Cursor, IN ADR, OUT ADR, DUR ADR
cb = 1
AVT_Cb	equ	$
		VTRCBtables cb
		cb = cb + 1
BVT_Cb	equ	$
	if ALLOWED_VTRS GT 2
		VTRCBtables cb
		cb = cb + 1
	endif
CVT_Cb	equ	$
	if ALLOWED_VTRS GT 3
		VTRCBtables cb
		cb = cb + 1
	endif
DVT_Cb	equ	$
	if ALLOWED_VTRS GT 4
		VTRCBtables cb
		cb = cb + 1
	endif
EVT_Cb	equ	$
	if ALLOWED_VTRS GT 5
		VTRCBtables cb
		cb = cb + 1
	endif
FVT_Cb	equ	$
	if ALLOWED_VTRS GT 6
		VTRCBtables cb
		cb = cb + 1
	endif
AUXVT_Cb	equ	$
	VTRCBtablesAXBL cb
		cb = cb + 1
BLKVT_Cb	equ	$
	VTRCBtablesAXBL cb


vcmdnum = 0
VlanCmd	macro	cmd, extFlag, name
LOCAL vcmd
vcmd	db	&cmd&
	name	= vcmdnum
	if extFlag eq 1
	name = name OR 08000h		;; Set hibit for extended table
	endif
	vcmdnum = vcmdnum + (SIZE vcmd + LENGTH vcmd)
public name
endm

Vtrcmds	equ	$

; Transport motion commands:
VlanCmd 'AC', 0, M_autocal		; autocal
VlanCmd 'EJ', 0, M_eject		; eject
VlanCmd 'NE', 0, M_ee_off		; E to E OFF
VlanCmd 'YE', 0, M_ee_on		; E to E ON
VlanCmd 'FF', 0, M_fast_forward		; FAST FORWARD
VlanCmd 'RW', 0, M_fast_rewind		; FAST REWIND
VlanCmd 'HS', 0, M_highres_shuttle	; High Resolution Shuttle
VlanCmd 'JF', 0, M_jog_forward		; jog_forward
VlanCmd 'JR', 0, M_jog_reverse		; jog_reverse
VlanCmd 'PC', 0, M_vlan_pass		; VTR COMMAND PASS THRU
VlanCmd 'PS', 0, M_pause		; PAUSE
VlanCmd 'PY', 0, M_play			; PLAY
VlanCmd 'RC', 0, M_record		; record
VlanCmd 'SH', 0, M_shuttle_speed	; SHUTTLE SPEED (#= +/- 0-9)
VlanCmd 'ST', 0, M_stop			; STOP

; Variable Speed Transport Commands
VlanCmd 'CA', 0, M_test_speed		; Check Availability of speed. Returns closest speed
					; CA#  # is speed to check returns 3 bytes of speed data
VlanCmd 'TV', 0, M_test_variable	; Test if Variable speed Available returns "Y" or "N"
VlanCmd 'SV', 0, M_set_variable		; SV#	Set Variable speed - Sets speed used in edit.
					; where # is speed for edit
VlanCmd 'VS', 0, M_var_shttl		; Variable Shuttle machine over its speed range.
					; VS#	where # is between -31 and +31
VlanCmd 'VC', 0, M_change_speed		; VC speed,time Variable Speed Change
					; Change edit speed during a edit
					; change speed to 12 frames/sec after 10 seconds:
					; VC 12,10:00
VlanCmd 'VP', 0, M_var_play		; VP#	Variable speed commands for Vlan Master
					; where # is speed selected in frames per second
VlanCmd 'VR', 0, M_send_speed		; Send current speed. returns 3 bytes of speed data


; Transport Location Commands
VlanCmd 'SG', 0, M_set_tcgen		; set time code generator
VlanCmd 'SU', 0, M_set_userbits		; set user bits
VlanCmd 'CD', 0, M_set_gentctype	; set code type
VlanCmd 'CS', 0, M_code_mode		; Code select
VlanCmd 'TC', 0, M_switchtc		; switch_tc
VlanCmd 'SL', 0, M_set_location		; setlocation
VlanCmd 'GC', 0, M_get_code_mode	; Get Code Mode

; Transport Search Commands
VlanCmd 'GI', 0, M_goto_in		; GOTO IN
VlanCmd 'GO', 0, M_goto_out		; GOTO OUT
VlanCmd 'GP', 0, M_cue			; GOTO Preroll (CUE)
VlanCmd 'GT', 0, M_goto_location	; GOTO LOCATION (#=BCD VALUE)
VlanCmd 'GL', 0, M_lastout		; Goto to last out

; Editing Sequence Commands
VlanCmd 'AB', 0, M_edit_abort		; Abort edit sequence
VlanCmd 'CF', 0, M_gpi_off		; gpi_off
VlanCmd 'CO', 0, M_gpi_on		; gpi_on
VlanCmd 'CB', 0, M_Color_bump		; Color_bump
VlanCmd 'EE', 0, M_edit_error		; EDIT ERROR
VlanCmd 'SY', 0, M_edit_sync		; EDIT SYNC (#=0, 1, OR 2)
;;VlanCmd 'QL', 0, M_
;;VlanCmd 'QE', 0, M_
VlanCmd 'EC', 0, M_end_condition	; END CONDITION (DATA = NEXT COMMAND)
VlanCmd 'OF', 0, M_onthefly		; Outpoint on the fly
VlanCmd 'RH', 0, M_rehearse		; REHEARSE (#=OTHER NODES TO SYNC)
VlanCmd 'RB', 0, M_roll_begin		; Roll Begin
VlanCmd 'RE', 0, M_roll_end		; Roll End
VlanCmd 'PF', 0, M_perform		; PERFORM (#=OTHER NODES TO SYNC)
VlanCmd 'NR', 0, M_Record_nodes		; Record Node Select
;;VlanCmd 'QK', 0, M_
VlanCmd 'RV', 0, M_review		; REVIEW (#=OTHER NODES TO SYNC)
VlanCmd 'NS', 0, M_Source_nodes		; Source Node Select
VlanCmd 'SB', 0, M_sync_bump		; SYNC BUMP DURING PREVIEW
VlanCmd 'WG', 0, M_wait_go		; wait_go
VlanCmd 'WF', 0, M_wait_off		; wait_off
VlanCmd 'WO', 0, M_wait_on		; wait_on

; Edit Parameter Set-Up Commands
VlanCmd 'AT', 0, M_add_tracks		; add_tracks
VlanCmd 'AI', 0, M_auto_inc		; AUTO INCREMENT (#=BCD VALUE)
VlanCmd 'CL', 0, M_clear_node		; CLEAR NODE
VlanCmd 'EI', 0, M_mark_in		; ENTER IN
VlanCmd 'EO', 0, M_mark_out		; ENTER OUT
;;VlanCmd 'LT', 0, M_
VlanCmd 'NT', 0, M_track_change		; NT tracks,timeNew Track select
					; Select new track during an edit.
					; change tracks to Audio1 and Video after 23 seconds:
					; NT V1,23:00
VlanCmd 'PT', 0, M_Postroll_set		; Postroll SET (#=BCD VALUE)
VlanCmd 'PR', 0, M_Preroll_set		; Preroll SET (#=BCD VALUE)
VlanCmd 'RD', 0, M_read_duration	; READ DURATION
VlanCmd 'RI', 0, M_read_in		; READ IN
VlanCmd 'RO', 0, M_read_out		; READ OUT
VlanCmd 'SC', 0, M_gpi_time		; gpi_time
VlanCmd 'SD', 0, M_set_duration		; SET DURATION  (#=BCD VALUE)
; za
VlanCmd 'SI', 0, M_set_in		; SET IN (#=BCD VALUE)
VlanCmd 'SO', 0, M_set_out		; SET OUT (#=BCD VALUE)
VlanCmd 'SS', 0, M_split_time		; split_time
VlanCmd 'TS', 0, M_track_select		; TRACK SELECT (#=V,1,2,A)
VlanCmd 'TD', 0, M_trim_duration	; TRIM DURATION (#=BCD VALUE)
VlanCmd 'TI', 0, M_trim_in		; TRIM IN (#=BCD VALUE)
VlanCmd 'TO', 0, M_trim_out		; TRIM OUT (#=BCD VALUE)

; Status Commands
VlanCmd 'AP', 0, M_node_type		; Node type (Application Type)
					; 0 = offline		4 = Audio switcher
					; 1 = Transport		5 = Relay box
					; 2 = video switcher	6 = Universal serial control
					; 3 = keyboard
;qy
;qx
;qz
VlanCmd 'CV', 0, M_code_valid		; Code valid?
VlanCmd 'DT', 0, M_device_type		; DEVICE TYPE REQUEST
;qq
;qp
VlanCmd 'ES', 0, M_Edit_Status		; EDIT STATUS
;qa
;qw
VlanCmd 'ID', 0, M_id			; id
VlanCmd 'LC', 0, M_location_cont	; LOCATION CONTINUOUS
VlanCmd 'LR', 0, M_location_rqst	; LOCATION REQUEST (#=OPTIONAL NODE NUMBER)
VlanCmd 'LS', 0, M_location_stat	; LOCATION + STATUS (#=OPTIONAL NODE NUMBER)
;qv
;sq
VlanCmd 'SE', 0, M_status_encod		; STATUS ENCODED (#=OPTIONAL NODE NUMBER
VlanCmd 'SR', 0, M_status_rqst		; STATUS REQUEST (#=OPTIONAL NODE NUMBER)
VlanCmd 'SN', 0, M_sync_check		; Synch (Y or N) sent back
;ub

; Sync Play Commands
;er
VlanCmd 'RF', 0, M_readclock		; Read internal cloc
VlanCmd 'RL', 0, M_RollDevice		; Roll and sync to master clock
VlanCmd 'SF', 0, M_setclock		; Set internal clock frame Count

; GPU Node Commands
VlanCmd 'CR', 0, M_clear_relays		; Clear relay events.
VlanCmd 'RP', 0, M_relay_pulse		; Pulse relays RR#,#...
VlanCmd 'RA', 0, M_relay_read		; Read relays RR#,#... 0=all
VlanCmd 'RR', 0, M_relay_reset		; Reset relays RR#,#... 0=all
VlanCmd 'RS', 0, M_relay_set		; Set relays RS#,#... 0=all
VlanCmd 'RT', 0, M_relay_trigger	; Relay trigger RT#,time
VlanCmd 'SP', 0, M_pulse_time		; Set pulse time in frames

; Transmitter relay trigger commands
; pd
; pe

; System Commands
VlanCmd 'EF', 0, M_echo_off		; ECHO OFF
VlanCmd 'EH', 0, M_echo_on		; ECHO ON
VlanCmd 'ND', 0, M_node_address		; NODE ADDRESS (#=1-32)
VlanCmd 'ZZ', 0, M_VLAN_reset		; VLAN RESET TO POWER ON
VlanCmd 'XN', 0, M_Return_Node		; Get current node number

; Keyboard Commands
VlanCmd 'KG', 0, M_keyboard_type	; Get keyboard type
VlanCmd 'KI', 0, M_Init_keyboard	; Initialize keyboard
VlanCmd 'KQ', 0, M_Keyboard_quiet	; Keyboard quiet (poll mode)
; kr \  see
; ks /  KSR/KSS
VlanCmd 'KT', 0, M_Key_Type		; Specify key type
VlanCmd 'KP', 0, M_Keyboard_poll	; Keyboard poll
VlanCmd 'KA', 0, M_Keyboard_asynch	; Keyboard asynchronous
VlanCmd 'CU', 0, M_cruise		; Set shuttl eknob into the cruise mode
; NG - see NGR


; Switcher Node Commands
VlanCmd 'CW', 0, MSW_clear		;
VlanCmd 'MD', 0, MSW_mods_disable	; 
VlanCmd 'ME', 0, MSW_mods_enable	; 
VlanCmd 'WT', 0, MSW_trigger		; 
VlanCmd 'WS', 0, M_switcher_pass	; 
VlanCmd 'WP', 0, MSW_get_patterns	; 
VlanCmd 'WM', 0, MSW_switcher_mem	; 
VlanCmd 'WC', 0, MSW_get_config		; 
VlanCmd 'SW', 0, MSW_switch		; 

VlanCmd 'WX', 0, MSW_set_parameter	; 
VlanCmd 'WY', 0, MSW_read_parameter	; 
VlanCmd 'WE', 0, MSW_set_efxaddrs	; 
VlanCmd 'WU', 0, MSW_upload_emem	; 
VlanCmd 'WB', 0, MSW_read_packet	; 
VlanCmd 'WD', 0, MSW_download_emem	;

; Misc private commands
VlanCmd 'UI', 0, M_userid		; Send user ID string
VlanCmd 'bs', 0, M_Binary_Status	; Binary Status (5 bytes returned)
VlanCmd 'ek', 0, M_Edit_Clock		; Edit Clock from Preroll

; New Commands
VlanCmd 'FO', 0, M_SetColorFrame	; 0,1 NTSC, 0-3 PAL
VlanCmd 'CX', 0, M_GetColorFrame
VlanCmd 'SZ', 0, M_StopStandby		; 
VlanCmd 'ED', 0, M_EditField		; 0 = whatever is locally enabled
					; 1 = Select Field 1, 2 = field 2
VlanCmd 'PZ', 0, M_PreRead		; 0 = whatever is locally enabled
					; 1 = PreRead ON
					; 2 = PreRead OFF
VlanCmd 'DO', 0, M_DownloadOption
VlanCmd 'DR', 0, M_DownloadReady
VlanCmd 'ER', 0, M_EndRoll
VlanCmd 'SQ', 0, M_SequenceCheck


VlanCmd 'QY', 0, M_BinaryEditStatus

VlanCmd 'ÁB', 0, MSW_write_packet	; 

;VlanCmd 'KIP', 3, 1, XM_initalize_kbd	; Initialize keyboard to POLL mode
;VlanCmd 'XNS', 3, 1, XM_Return_source_node	; Return current source node
;VlanCmd 'XNR', 3, 1, XM_Return_record_node	; Return current record node
;VlanCmd 'NDS', 3, 1, XM_Set_source_node	; Set current source node
;VlanCmd 'NDR', 3, 1, XM_Set_record_node	; Set current record node
;VlanCmd 'NGS', 3, 1, XM_Set_source_group	; Set source node group
;VlanCmd 'NGR', 3, 1, XM_Set_record_group	; Set record node group
;VlanCmd 'KRI', 3, 1, XM_Set_initial_repeat	; Set initial repeat time
;VlanCmd 'KRS', 3, 1, XM_Set_sub_repeat	; Set subsequent repeat time (10nths of secs)
;VlanCmd 'KJS', 3, 1, XM_Set_source_jog	; Set source jog knob function
;VlanCmd 'KJR', 3, 1, XM_Set_record_jog	; Set record jog knob function
;VlanCmd 'KSS', 3, 1, XM_Set_source_shuttle	; Set source shuttle knob function
;VlanCmd 'KSR', 3, 1, XM_Set_record_shuttle	; Set record shuttle knob function

;================================================================
Vtrstat	db	80h,'      ',0
	db	81h,'PwrOff',0
	db	82h,' Stop ',0
	db	83h,'Thread',0
	db	84h,'Unthrd',0
	db	85h,' Wait ',0
	db	86h,' Play ',0
	db	87h,'Pause ',0
	db	88h,' Jog  ',0
	db	89h,'Shttle',0
	db	8ah,'Cruise',0
	db	8bh,'Brakng',0
	db	8ch,'Srchng',0
	db	8dh,'FstFwd',0
	db	8eh,'Rewind',0
	db	8fh,'Ready ',0
	db	90h,' Edit ',0
	db	91h,'Local ',0
	db	92h,'NoTape',0
	db	93h,'RECORD',0
	db	94h,'VarPla',0
	db	95h,'Calibr',0
	db	96h,'Rehrse',0
	db	97h,'Replay',0
	db	98h,'??????',0
	db	99h,' Tone ',0

	db	9ah,' Knob ',0

	db	1,' EXERR',0	;EXECER
	db	2,' CTERR',0	;CTERR
	db	3,' ABORT',0	;SABRT
	db	4,'BADCMD',0	;BADCMD
	db	5,'ISRQST',0	;ISRQ
	db	6,'SYNCER',0	;SYNCHER
	db	7,'SERVER',0	;SERVO
	db	8,'NOTRDY',0	;NOTRDY

	db	0ffh,'OffLin',0
;34 * 8 = 272

;================================================================
; Switcher types
;	Switcher name, 8 bytes
;	Word 1:	Switcher descriptor bits
;	Word 2: # of emem registers in lower 7 bits (127 max)
;	Word 3: Wipe translation table address
;	Word 4: Switcher SMPTE address / Port address for Internal switcher
;	Word 5: Command translate table
;	Word 6: MSB = WRITE MASK, LSB = READ MASK

;................................................................
SX_Type_Types = 0

SWF_GVG10XL = SWbit_GVG10XL OR SWbit_esccrc OR SWbit_singlebus OR SWbit_xptplus1 OR SWbit_frmdelay
SWF_AEC10x1 = SWbit_GVG10XL OR SWbit_esccrc OR SWbit_singlebus OR SWbit_xptplus1
SWF_GVG100  = SWBIT_smpte OR SWbit_EFXMEM OR SWbit_WipeMods
SWF_Other100 = SWBIT_smpte OR SWbit_EFXMEM OR SWbit_WipeMods
SWF_ALLADIN = SWBIT_smpte OR SWbit_EFXMEM OR SWbit_NoWakeUp
SWF_ECHODV7 = SWBIT_smpte OR SWbit_WipeMods
SWF_PYXIS   = SWBIT_smpte OR SWbit_singlebus OR SWbit_nozeroxpt OR SWbit_WipeMods
SWF_PEGASUS = SWBIT_smpte OR SWbit_WipeMods
SWF_PRODIGY = SWBIT_smpte OR SWbit_WipeMods
SWF_ECHOPC3 = SWBIT_smpte OR SWbit_WipeMods or SWbit_Polarity or SWbit_PC3
SWF_WJMX50  = SWBIT_smpte OR SWbit_EFXMEM
SWF_ROSS210 = SWBIT_smpte OR SWbit_WipeMods
SWF_VLAN    = SWbit_VLAN
SWF_VSA24II = SWbit_audio
SWF_ESAMII  = SWbit_audio OR SWBIT_monitor
SWF_JLCAV6  = SWbit_audio
SWF_AMX100  = SWbit_audio OR SWBIT_smpte OR SWbit_EFXMEM
SWF_AMX170  = SWbit_audio OR SWBIT_smpte OR SWBIT_monitor


SXana_GVG10XL = SXana_NONE
SXana_AEC10x1 = SXana_NONE
SXana_GVG100  = SXana_ALL
SXana_Other100  = SXana_NONE
SXana_ECHODV7 = SXana_ALL
SXana_PYXIS   = SXana_ALL
SXana_PEGASUS = SXana_ALL
SXana_PRODIGY = SXana_ALL
SXana_ECHOPC3 = SXana_Fader or SXana_Positioner or SXana_aspect or SXana_softness or SXana_key_clip or SXana_key_gain
SXana_WJMX50  = SXana_Fader or SXana_Positioner or SXana_aspect or SXana_key_clip or SXana_key_gain
SXana_ROSS210 = SXana_ALL
SXana_VLAN    = SXana_Fader or SXana_Positioner or SXana_aspect or SXana_key_clip or SXana_key_gain
SXana_VSA24II = SXana_NONE
SXana_ESAMII  = SXana_NONE
SXana_JLCAV6  = SXana_NONE
SXana_AMX100  = SXana_NONE
SXana_AMX170  = SXana_NONE
SXana_ALLADIN = SXana_NONE


SXspcl_GVG10XL = SXspcl_NONE
SXspcl_AEC10x1 = SXspcl_NONE
SXspcl_GVG100  = SXspcl_NONE
SXspcl_Other100 = SXspcl_NONE
SXspcl_ECHODV7 = SXspcl_NONE
SXspcl_PYXIS   = SXspcl_NONE
SXspcl_PEGASUS = SXspcl_NONE
SXspcl_PRODIGY = SXspcl_NONE
SXspcl_ECHOPC3 = SXspcl_NONE
SXspcl_WJMX50  = SXspcl_TRC or SXspcl_BCDwipe or SXspcl_AllStop
SXspcl_ROSS210 = SXspcl_NONE
SXspcl_VLAN    = SXspcl_NONE
SXspcl_VSA24II = SXspcl_NONE
SXspcl_ESAMII  = SXspcl_NONE
SXspcl_JLCAV6  = SXspcl_NONE
SXspcl_AMX100  = SXspcl_NONE
SXspcl_AMX170  = SXspcl_DSK or SXspcl_FTB
SXspcl_ALLADIN = SXspcl_SetLayers or SXspcl_ResetToStart or SXspcl_WaitField


SXdsk_GVG10XL = SXdsk_NONE
SXdsk_AEC10x1 = SXdsk_NONE
SXdsk_GVG100  = SXdsk_ALL
SXdsk_Other100 = SXdsk_ALL
SXdsk_ECHODV7 = SXdsk_ALL
SXdsk_PYXIS   = SXdsk_ALL
SXdsk_PEGASUS = SXdsk_ALL
SXdsk_PRODIGY = SXdsk_ALL
SXdsk_ECHOPC3 = SXdsk_dsk_clip
SXdsk_WJMX50  = SXdsk_NONE
SXdsk_ROSS210 = SXdsk_ALL
SXdsk_VLAN    = SXdsk_NONE
SXdsk_VSA24II = SXdsk_NONE
SXdsk_ESAMII  = SXdsk_NONE
SXdsk_JLCAV6  = SXdsk_NONE
SXdsk_AMX100  = SXdsk_NONE
SXdsk_AMX170  = SXdsk_NONE
SXdsk_ALLADIN = SXdsk_NONE

SX_Types	equ	$
SXcb <'NONE    ', 0000h,	0000h,	0000h,		0000h,	0000      , 0000h,		0000h,           0000h,		0000h, 16>
SXcb <'GVG 10XL', SWF_GVG10XL,	0000h,	0000h,		80A0h,	gvg100_pbv, SMPTE_commands,	SXspcl_GVG10XL,  SXana_GVG10XL,	SXdsk_GVG10XL, 16>
SXcb <'AEC 10x1', SWF_AEC10x1,	0000h,	0000h,		80A0h,	gvg100_pbv, SMPTE_commands,	SXspcl_AEC10x1,  SXana_AEC10x1,	SXdsk_AEC10x1, 16>
SXcb <'GVG 100 ', SWF_GVG100,	16,	gvg_wipes,	30h,	gvg100_pbv, SMPTE_commands,	SXspcl_GVG100,   SXana_GVG100,	SXdsk_GVG100, 16>
SXcb <'ECHO DV7', SWF_ECHODV7,	16,	0000h,		30h,	gvg100_pbv, SMPTE_commands,	SXspcl_ECHODV7,  SXana_ECHODV7,	SXdsk_ECHODV7, 16>
SXcb <'PYXIS   ', SWF_PYXIS,	5,	pyxis_wipes,	30h,	gvg100_pbv, SMPTE_commands,	SXspcl_PYXIS,    SXana_PYXIS,	SXdsk_PYXIS, 16>
SXcb <'PEGASUS ', SWF_PEGASUS,	10,	pegasus_wipes,	30h,	gvg100_pbv, SMPTE_commands,	SXspcl_PEGASUS,  SXana_PEGASUS,	SXdsk_PEGASUS, 16>
SXcb <'PRODIGY ', SWF_PRODIGY,	16,	0000H,		30h,	gvg100_pbv, SMPTE_commands,	SXspcl_PRODIGY,  SXana_PRODIGY,	SXdsk_PRODIGY, 16>
SXcb <'ECHO PC3', SWF_ECHOPC3,	4,	0000H,		30h,	gvg100_pbv, SMPTE_commands,	SXspcl_ECHOPC3,  SXana_ECHOPC3,	SXdsk_ECHOPC3, 16>
SXcb <'WJ MX50 ', SWF_WJMX50,	8,	0000H,		30h,	gvg100_pbv, SMPTE_commands,	SXspcl_WJMX50,   SXana_WJMX50,	SXdsk_WJMX50, 16>
SXcb <'ROSS 210', SWF_ROSS210,	0000H,	ross_wipes,	30h,	gvg100_pbv, SMPTE_commands,	SXspcl_ROSS210,  SXana_ROSS210,	SXdsk_ROSS210, 16>
SXcb <'ALLADIN ', SWF_ALLADIN,	16,	0000H,		0,	gvg100_pbv, SMPTE_commands,	SXspcl_ALLADIN,  SXana_ALLADIN,	SXdsk_ALLADIN, 16>
SXcb <'OTHER100', SWF_Other100,	16,	gvg_wipes,	30h,	gvg100_pbv, SMPTE_commands,	SXspcl_Other100, SXana_Other100, SXdsk_Other100, 16>
SXcb <'V-LAN   ', SWF_VLAN,	16,	Vlan_Patterns,	0015h,	0000,	    0000h,		0000h,	 	 SXana_VLAN,	SXdsk_VLAN, 255>
SXcb <'        ', 0ffffh,	0ffffh,	0ffffh,		0ffffh,	0ffffh,     0000h,		0000h,		 0ffffh,	0ffffh, 16>
SX_Switcher_Types	EQU	(($ - SX_Types) / SXcb_length) - 1

;................................................................
AX_Types	equ	$
SXcb <'NONE    ', 0000h,	0000h,	0000h,		0000h,	0000,        0000h,		0000h,		0000h,		0000h, 16>
SXcb <'GVG 10XL', SWF_GVG10XL,	0000h,	0000h,		80A0h,	gvg100_pba, SMPTE_commands,	SXspcl_GVG10XL,	SXana_GVG10XL,	SXdsk_GVG10XL, 16>
SXcb <'AEC 10x1', SWF_AEC10x1,	0000h,	0000h,		80A0h,	gvg100_pba, SMPTE_commands,	SXspcl_AEC10x1,	SXana_AEC10x1,	SXdsk_AEC10x1, 16>
SXcb <'AMX 100 ', SWF_AMX100 ,	16,	0000h,		30h,	gvg100_pba, SMPTE_commands,	SXspcl_AMX100 ,	SXana_AMX100 ,	SXdsk_AMX100 , 16>
SXcb <'AMX 170 ', SWF_AMX170 ,	16,	0000h,		30h,	gvg100_pba, SMPTE_commands,	SXspcl_AMX170 ,	SXana_AMX170 ,	SXdsk_AMX170 , 16>
SXcb <'VSA24 II', SWF_VSA24II,	0000h,	0000h,		88A6h,	gvg100_pba, ESAM2_commands,	SXspcl_VSA24II,	SXana_VSA24II,	SXdsk_VSA24II, 16>
SXcb <'ESAM II ', SWF_ESAMII ,	100,	0000h,		88A6h,	gvg100_pba, ESAM2_commands,	SXspcl_ESAMII ,	SXana_ESAMII ,	SXdsk_ESAMII , 16>
SXcb <'JLC AV6 ', SWF_JLCAV6,	3,	0000h,		88A6h,	gvg100_pba, ESAM2_commands,	SXspcl_JLCAV6 ,	SXana_JLCAV6 ,	SXdsk_JLCAV6 , 16>
SXcb <'GVG 100 ', SWF_GVG100 ,	16,	0000h,		30h,	gvg100_pba, SMPTE_commands,	SXspcl_GVG100 ,	SXana_GVG100 ,	SXdsk_GVG100 , 16>
SXcb <'V-LAN   ', SWF_VLAN   ,	0000h,	0000h,		0017h,	0000,        0000h,		0000h,          SXana_VLAN,	SXdsk_VLAN   , 16>
SXcb <'        ', 0ffffh,	0ffffh,	0ffffh,		0ffffh,	0ffffh     , 0000h,		0000h,		0ffffh,		0ffffh, 16>
AX_Switcher_Types	EQU	(($ - AX_Types) / SXcb_length) - 1

;................................................................
PX_Types	equ	$
SXcb <'NONE    ', 0000h,	0000h,	0000h,		0000h,	0000,        0000h,		0000h,		0000h,		0000h, 16>
SXcb <'V-LAN   ', SWF_VLAN   ,	0000h,	0000h,		0018h,	0000,        0000h,		0000h,          SXana_VLAN,	SXdsk_VLAN   , 16>
SXcb <'        ', 0ffffh,	0ffffh,	0ffffh,		0ffffh,	0ffffh     , 0000h,		0000h,		0ffffh,		0ffffh, 16>
PX_Switcher_Types	EQU	(($ - PX_Types) / SXcb_length) - 1


		even
Machine_Lables	db	'RABCDEF'
Auxmmsg		db	'AX',0
Blkmmsg		db	'BL',0

;----------------------------------------------------------------
; File line prefixes
Title_EDLev	db	6
Title_Header	db	'TITLE: ',0

Fcm_EDLev	db	4
Fcm_Header	db	'FCM: ',0

Type_EDLev	db	7
Type_Header	db	'FORMAT: ',0

Split_EDLev	db	6
Split_Header	db	'SPLIT:',0

Gpi_EDLev	db	4
Gpi_Header	db 	'GPI:',0

Slave_EDLev	db	4
Slave_Header	db	'SLV:',0

Start_EDLev	db	7
Start_Header	db	'STARTS: ',0

Tstamp_EDLev	db	8
Tstamp_Header	db	'UPDATED: ',0

Spd_EDLev	db	4
Spd_Header	db	'SPD:',0

Pmc_EDLev	db	4
Pmc_Header	db	'PMC:',0

Rec_EDLev	db	4
Rec_Header	db	'REC:',0

Reelsum_EDLev	db	14
Reelsum_Header	db	'REEL SUMMARY: ',0

efx_EDLev	db	4
efx_header	db	'EFX:',0

ramp_EDLev	db	5
ramp_header	db	'RAMP:',0

public preread_EDLev, preread_header
preread_EDLev	db	8
preread_header	db	'PREREAD:',0

Flag2		db	0

Cln_Msg		db	'CLN',0
Lst_Msg		db	'LST',0
Tag_Msg		db	'TAG',0
Tag2_Msg	db	'TG2',0
Srt_Msg		db	'SRT',0
Gpi_Msg		db	'GPI',0

Swenabl_Msg	db	'Voff ',0
Auenabl_Msg	db	'Aoff ',0
Avenabl_Msg	db	'AVoff',0
Master_Msg	db	'MSTR',0
Frames_Msg	db	'FRM',0
Diskon_Msg	db	'DSK',0
Novlan_Msg	db	'CommOff ',0
ramp_msg	db	' RAMP   ',0
noref_msg	db	'NoBlkRef',0
Edltrack_Msg	db	'EDLtrak ',0
Edlsrch_Msg	db	'Srching ',0
Preread_Msg	db	'*Pre-Read*',0

		db	'                  '
spaces		db	0

Starspace_Msg	db	'* ',0
Badmode_Fill	db	'******',0

From_R_Msg	db	'Rec',0
From_A_Msg	db	'A',0
From_B_Msg	db	'B',0
From_C_Msg	db	'C',0
From_D_Msg	db	'D',0
From_E_Msg	db	'E',0
From_F_Msg	db	'F',0
From_Aux_Msg	db	'AUX',0
From_Blk_Msg	db	'BLK',0
AXstd_Msg	db	'AX ',0
BLstd_Msg	db	'BL ',0
Fromin_Msg	db	' In',0
Fromout_Msg	db	' Out',0
Fromdur_Msg	db	' Duration',0
Fromloc_Msg	db	' Location',0
Fromtime_Msg	db	' StartTim',0
Fromcalc_Msg	db	' Calcultor',0

Pmc_Msg		db	'PMC',0
Spd_Msg		db	'SPD',0
Editspeed_Msg	db	'Source speed at IN POINT: ',0
Spdchg_Msg	db	' Speed change buffer #',0
Speed_Msg	db	', enter % of speed: ',0
Fps_Msg		db	' fps. ',0
Framesec_Msg	db	'FPS',0
Ofspeed_Msg	db	' = ',0
Spdbufsel_Msg	db	'[+] or [INSERT], [DELETE],'
		if ALLOWED_VTRS EQ 7
		db	' [FILL],'
		endif
		if ALLOWED_VTRS EQ 7
Speedbuf_Msg	db	' VTRs A-',63 + ALLOWED_VTRS,' or Speed Change 1-7: ',0
		else
Speedbuf_Msg	db	' Speed Change 1-7: ',0
		endif

Spdkil_Msg	db	' set to play speed at edit?',0
Spdall_Msg	db	' all programmed speed changes',0
Fillhdr_Msg	db	' VT Fill Speed       Last Out    ',0
Speedhdr_Msg	db	' PMC VTR    Speed change   Trigger Offset ',0

Learnmac_Msg	db	'Recording '
Macro_File_Msg	db	'Macro',0
Emem_File_Msg	db	'E-MEM',0		; EMEM files
_Save_File_Msg	db	'Save',0		; List
_Load_File_Msg	db	'Load',0		;  Input/Output
Kilfil_Msg	db	'Delete',0		;
List_Msg	db	' List',0		; ...

Button_Msg	db	'BUTTON ',0
Nobutton_Msg	db	'        ',0

Vt_Msg		db	'-VT',0
Mcrosep		db	' - ',0		; On-screen Macro seperator
Cmt_Prmt	db	'Note> ',0
Constant_Msg	db	'Constant ',0
Execute_Msg	db	'Execute ',0
Empty_Msg	db	'<empty>',0
Untitled_Msg	db	'<UNTITLED>',0
Contents_Msg	db	'Contents > ',0
Mcd_Msg		db	'Default',0
Page_Msg	db	'Page ',0
Continued_Msg	db	' (Continued from previous page)',0

Pause_Msg	db	'Press ENTER to continue'
Threedots_Msg	db	'...',0

File_Msg	db	' FILE ',0
Loaded_Msg	db	'LOADED ',0
Saved_Msg	db	'SAVED ',0
Killed_Msg	db	'DELETED. ',0

public enabled_msg
enabled_msg	db	'ENABLED',0

;editstatus_msgs	db	'  DONE  ',0
;		db	' CUEING ',0
;		db	'WAITING ',0
;		db	'LOCKING ',0
;		db	'SYNCHING',0
;		db	' LOCKED ',0
;		db	'EDITING ',0
;		db	'Postroll',0
;		db	'ABORTED ',0

editstatus_msgs	db	'  DONE  ',0
		db	'CUEING  ',0
		db	'WAITING ',0
Synching_Msg	db	'LOCKING ',0
		db	'SYNCHING',0
		db	'LOCKED  ',0
		db	'EDITING ',0
		db	'POSTROLL',0
Asmaborted_Msg	db	'ABORTED ',0

Openend_Msg	db	' OPEN END ',0
Record_Msg	db	' RECORD ',0
Preview_Msg	db	' PREVIEW ',0
Replay_Msg	db	' REPLAY ',0
Bvb_Msg		db	'BVB ',0
Vbv_Msg		db	'VBV ',0
Vvv_Msg		db	'VVV ',0
Testing_Msg	db	'Testing...',0
Pvw_Msg		db	'  PREVIEW  ',0
Rev_Msg		db	'  REPLAY   ',0
Per_Msg		db	'  PERFORM  ',0
Noed_Msg	db	'           ',0

Hotswitch_Msg	db	' HOT SWITCH RECORD ',0

No_Msg		db	'NO ',0
Yes_Msg		db	'YES',0
Disable_Msg	db	' Disable',0
Enable_Msg	db	' Enable ',0
Selvtr_Msg	db	' Device - ',0

Cut_Type	db	'Cut ',0
Dissolve_Type	db	'Dissolve ',0
Wipe_Msg	db	'Wipe',0
Key_Type	db	'Key ',0		;+In_Msg;Out_Msg
Keyfor_Msg	db	'foreground=',0
Keyover_Msg	db	'over ',0
Keybkgnd_Msg	db	'background=',0
Keyfade_Msg	db	'Fade ',0
Keyinout_Msg	db	'In or Out=',0

Split_Type	db	'Split ',0
Split_What_Msg	db	'Audio or Video? ',0
Split_When_Msg	db	'<= Delay for ',0
Split_Dly_Msg	db	'Delay ',0
Split_Vid_Msg	db	'Video',0
Split_Aud_Msg	db	'Audio',0
Without_Msg	db	'without ',0

Frame_Msg	db	'Frames ',0
Code_Msg	db	'Wipe# ',0

Flag3		db	0

;Select1to_Msg	db	'Select 1 - ',0
Select1to_Msg	db	'Select ',0
Selectfile_Msg	db	'Select file by number: ',0
Gcmdtype_Msg	db	'Command? ',0

Adjust_Msg	db	' adjust',0

Done_Msg	db	'  DONE  ',0
Assemble_Msg	db	' AUTO'
Asmmode_Msg	db	' ASSEMBLE ' ,0
Assembly_Msg	db	' ASSEMBLY ',0
Asmcomplete_Msg	db	'COMPLETE ',0
;Asmaborted_Msg	db	'ABORTED ',0
Vtrsyncerr_Msg	db	' frame error on ',0
Forreel_Msg	db	'Ripple for which Source '
Reel_Msg	db	'Reel> ',0
orall_msg	db	'(use asterisk "*" for ALL) ',0
Sfcm_Msg	db	'<D>rop or <N>on Drop ',0
SeekFLE_Msg	db	'Seek to event # ',0
Where_Msg	db	', above event ',0

;................................................................

Areusure	db	'<--- '

Surenuf_Msg	db	'Are you sure',0

Event_Msg	db	'THIS EVENT:',0

Cancelauto_Msg	db	'Cancel '
Asyougo_Msg	db	'Auto',0
Alreadyon_Msg	db	' AutoSave is active.  Restart?',0
AutoTrim_Msg	db	'Multiple trim devices: ',0
Link_Msg	db	'Link: ',0
Multr_Msg	db	'Multiple Recorders: ',0
Swapvtr_Msg	db	'Swap VTRs: ',0
Printing_Msg	db	'Printing... Control-Break to abort',0
Endofprint_Msg	db	'- end of file -',0
Edl_Msg		db	' EDL',0
As_Msg		db	' as ',0
New_Dflts_Msg	db	' New '
Dflt_File_Msg	db	'Defaults',0	; ...
Reelsused_Msg	db	' reels used',0
Nopath_Msg	db	'Path not found',0
Dirpath_Msg	db	'DIR '
Logd_Msg	db	'EDL path.............: ',0
Logauto_Msg	db	'AutoSave path........: ',0
Logtcm_Msg	db	'Macro Files Path ....: ',0
Logvme_Msg	db	'Effects Files Path...: ',0
Logtmp_Msg	db	'Virtual Memory Path..: ',0

Page_Qry	db	'Start with edit# ',0

Title_Msg	db	'Title ',0
Edlis_Msg	db	'EDL is ',0

Dropframe_Msg	db	'DROP FRAME',0
Nondrop_Msg	db	'NON-DROP FRAME',0
Filename_Msg	db	'File: ',0
Event_Rple_Msg	db	'Renumber to :',0

View_Msg	db	'[ESC] to exit, [ENTER] for next page ',0
Viewsavlod_Msg	db	', [LOAD], [SAVE] or [DELETE] EDL.',0
Viewend_Msg	db	'End EDL. [ENTER] return to file menu, [LOAD] or [SAVE] selects this EDL.',0
Pagend_Msg	db	'Press any key...',0
Edlscroll_Msg	db	'Use Home, End, Pg Up, Pg Dn, Arrows or Enter key...',0
Tcval_Msg	db	'Illegal Entry',87h
Keyboard_Msg	db	'Keyboard ',0
Trim_Msg	db	'Trim ',0
In_Msg		db	'IN ',0
Out_Msg		db	'OUT',0
Time_Msg	db	'Total ',0
Port_Msg	db	'Port ',0
Crosspoint_Msg	db	' crosspoint ',0
Resetting_Msg	db	'Resetting channels...',0

Listttl_Msg	db	' EVENT  REEL  MODE TRAN EFX   SOURCE IN   SOURCE OUT  RECORD IN   ',0

Recout_Msg	db	'RECORD OUT    ',0
Recdur_Msg	db	' DURATION     ',0

Nodos_Msg	db	'Must use MSDOS 3.xx or above',cr,lf,'$'
Noovl_Msg	db	cr,lf,'SESMSG.OVR NOT FOUND',7,'$'
Badovl_Msg	db	cr,lf,'SESMSG.OVR HAS BEEN ALTERED OR IS CORRUPT',cr,lf,7,'$'
Videocard_Msg	db	cr,lf,'Unrecognizable graphics board...',7,'$'

Append_Msg	db	'Append? ',0
Badcrash_Msg	db	7,'** INTERNAL ERROR **  PRESS RETURN, '
		db	'SAVE YOUR EDL, EXIT TO DOS AND RESTART',0

alreadyhere_msg	db	7,'Program already running.  Type "EXIT" to return to it.$'

Badjoystick_Msg	db	'BAD JOYSTICK DATA',0
Nxptcom_Msg	db	'BAD SWITCHER DATA ',0

CtrTable	DW	ctr_CUTS, ctr_DISSOLVE, ctr_SES
Flag4		db	0

Memful		db	'MEM FULL ',0
Nowild_Msg	db	'Undefined',0
Wild_Msg	db	'Wild key #',0
Joggerkey_Msg	db	'Joystick button #',0

Anyway_Msg	db	'Warning: Does not match last recalled event number. ',0

mode_msg	db	'-mode',0

Crlf_Msg	db	cr,lf,0

Space_Msg	db	'SPACE',0
BadDOSfname_Msg	db	'Illegal character "',0
InDosFname_Msg	db	'" in DOS filename. ',0

;================================================================
Flag5		db	0
Port		dw	0,0,0,0			; LPT1, 2, 3, and 4
Nport		dw	0			; Port the Activator is on

	if CUTS_ONLY
Seloffset	dw	0
ctr_CUTS	db	10, 41, 44, 0		; SVE Counters  A,B,C, and dummy
sel_CUTS	db	43, 45, 53, 47		; Cuts only A,B,C, and T
ctr_DISSOLVE	db	1			; Counters  A,B,C, and dummy
sel_DISSOLVE	db	2			; Dissolve  A,B,C, and T
ctr_SES		db	3			; SVE Counters  A,B,C, and dummy
sel_SES		db	4			; SVE Dissolve  A,B,C, and T

	ELSE
	IF ALLOWED_VTRS LT 7
Seloffset	dw	2
ctr_DISSOLVE	db	10, 41, 44, 0		; SVE Counters  A,B,C, and dummy
sel_DISSOLVE	db	56, 49, 44, 47		; Dissolve  A,B,C, and T
ctr_CUTS	db	1			; Counters  A,B,C, and dummy
sel_CUTS	db	2			; Cuts only A,B,C, and T
ctr_SES		db	3			; SVE Counters  A,B,C, and dummy
sel_SES		db	4			; SVE Dissolve  A,B,C, and T
	else
Seloffset	dw	4
ctr_SES		db	10, 41, 44, 0		; SVE Counters  A,B,C, and dummy
sel_SES		db	40, 41, 58, 48		; SVE Dissolve  A,B,C, and T
ctr_DISSOLVE	db	1			; SVE Counters  A,B,C, and dummy
sel_DISSOLVE	db	2			; Dissolve  A,B,C, and T
ctr_CUTS	db	3			; Counters  A,B,C, and dummy
sel_CUTS	db	4			; Cuts only A,B,C, and T
	ENDIF
	ENDIF ;CUTS_ONLY

		even
Tcdispbuf	db	'00:00:00:00',0
Cimsg_Spaces	db	'           ',0
Cimsg_String	db	'00:00:00:00',0


;----------------------------------------------------------------
		even

Variable_Table	db	0,0,0,0,1,1,1,1,2,2,2,3,3,3,4,4,4
		db	5,5,5,6,6,6,7,7,7,8,8,8,9,9,9
		db	9,9,9,8,8,8,7,7,7,6,6,6,5,5,5
		db	4,4,4,3,3,3,2,2,2,1,1,1,1,0,0,0,0

		even
Jstickx_Table	equ	$
	db -9,-9,-9
	db -8,-8,-8
	db -7,-7,-7
	db -6,-6,-6
	db -5,-5,-5,-5
	db -4,-4,-4,-4
	db -3,-3,-3,-3
	db -2,-2,-2,-2
	db -1,-1,-1,-1
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db -0,-0,-0,-0
	db +1,+1,+1,+1
	db +2,+2,+2,+2
	db +3,+3,+3,+3
	db +4,+4,+4,+4
	db +5,+5,+5,+6
	db +6,+6,+6
	db +7,+7,+7
	db +8,+8,+8
	db +9,+9,+9


Swjstick_Table	equ	$
 db -16,-15,-15,-15,-15,-14,-14,-14,-13,-13,-13,-12,-12,-12,-11,-11
 db -11,-10,-10,-10,-9,-9,-9,-8,-8,-8,-7,-7,-7,-6,-6,-6,-5,-5,-5,-4
 db -4,-4,-3,-3,-3,-2,-2,-2,-1,-1,-1,0,0,0,0,0,0,0,1,1,1,2,2,2,3,3
 db 3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,10,10,10,11,11,11,12,12
 db 12,13,13,13,14,14,14,15,15,15,16

; Row table
	even
Rowtbl	dw	0000H,00A0H,0140H,01E0H,0280H,0320H,03C0H,0460H,0500H
	dw	05A0H,0640H,06E0H,0780H,0820H,08C0H,0960H,0A00H,0AA0H
	dw	0B40H,0BE0H,0C80H,0D20H,0DC0H,0E60H,0F00H



PSMENUITEMS = 0
PSMENU macro name,cur,choices,rows,cols,tab,field,Flag,exitkey
&name	POSITIONQUERYDATA <cur,choices,rows,cols,tab,field,Flag,exitkey>
;	PSMENU_&name = PSMENUITEMS
	PSMENUITEMS = PSMENUITEMS + 1
public &name
	endm

;Position Query point and shoot menues
STDPSFL EQU PQF_KEYTHRU OR PQF_YESNOTGL
PointShootTables	equ	$
;		 cursor,  choices,rows,cols,tab,field, Flag,     exitkey, keypressed
PSMENU PS_INSTALL, list_scr, 27,     9,3,27, 26, PQF_KEYTHRU,  Status_xcmd
PSMENU PS_INSTALL1 <list_scr + 201h>,9,5,2,39,39,STDPSFL, Status_xcmd
if NTSC
PSMENU PS_INSTALL2 <list_scr + 213h>,4,4,1,44,43,STDPSFL, Status_xcmd
else
PSMENU PS_INSTALL2 <list_scr + 213h>,3,3,1,44,43,STDPSFL, Status_xcmd
ENDIF
PSMENU PS_INSTALL3 <list_scr + 213h>,2,2,1,44,43,STDPSFL,Status_xcmd
PSMENU PS_INSTALL6 <list_scr + 302h>,0,4,3,28,20,STDPSFL,Status_xcmd
PSMENU PS_INSTALL7 <list_scr + 213h>,2,2,1,44,43,STDPSFL,Status_xcmd
PSMENU PS_INSTALL8 <list_scr + 116h>,(MAX_SOURCES)+1,(MAX_SOURCES)+1,1,39,38,STDPSFL,Status_xcmd
PSMENU PS_INSTALL11 <list_scr + 201h>,8,4,2,39,39,STDPSFL,Status_xcmd
PSMENU PS_INSTALL12 <list_scr + 213h>,4,4,1,44,43,STDPSFL,Status_xcmd
PSMENU PS_INSTALL16 <list_scr + 00fh>,ALL_DEVICES,ALL_DEVICES,1,0,47,STDPSFL,Status_xcmd
PSMENU PS_INSTALL17 <list_scr + 100h>,16,8,2,41,39,STDPSFL,Status_xcmd
PSMENU PS_INSTALL19 <list_scr + 213h>,3,3,1,40,38,STDPSFL,Status_xcmd
if NTSC
PSMENU PS_INSTALL20 <list_scr + 100h>,13,7,2,42,38,STDPSFL,Status_xcmd
else
PSMENU PS_INSTALL20 <list_scr + 100h>,12,7,2,42,38,STDPSFL,Status_xcmd
ENDIF
PSMENU PS_INSTALL21 <list_scr + 10Ah>,7,7,1,0,58,STDPSFL,Status_xcmd
PSMENU PS_INSTALL22 <list_scr + 105h>,7,7,1,0,66,STDPSFL,Status_xcmd
PSMENU PS_INSTALL23 <list_scr + 213h>,5,5,1,42,38,STDPSFL,Status_xcmd
PSMENU PS_INSTALL27 <list_scr + 101h>,14,7,2,39,39,STDPSFL,Status_xcmd
PSMENU PS_RELAYS    <0001h>,48,24,2,40,37,PQF_YESNOTGL,Status_xcmd
PSMENU PS_RAMPSPEED <list_scr + 113h>,7,7,1,44,42,STDPSFL,Status_xcmd
PSMENU PS_DIAGNOSE  <list_scr + 217h>,3,3,1,37,36,0,Status_xcmd
PSMENU PS_GPI       <list_scr>,0,9,6,13,11,PQF_ALLOWZERO,Escape_xcmd

;================================================================
CASEID		db	0CAH,05EH
SESID		db	0C5H,0E5H
Pathspec	db	'PATH='
Comspec		db	'COMSPEC='
Dos_Cmd		db	(pathname_length+1) dup(0) ;'\COMMAND.COM',0
Dos_Tail	db	0,cr,0
Dir_Tail	db	'/C DIR ',0
Dir_Opts	db	'/W/P',0
Command_Runopt	db	'/C ',0

Switcher_Tail	db	15,'/C SWITCHER.BAT',cr,0
Olm_Cmd		db	'OLM.COM',0

Olm_Tail	db	8,'SES /E/X',cr,0
Olm_Manual	db	'SES /E/X/@',0

olm_kbdlayout	db	'Keyboard Layout',0

TMP_File	db	'SES',v1,v2,v3,'.TMP',0

SES_file	db	'SES.EXE',0
Menu_File	db	'MENU.COM',0
Backup_File	db	'BIN#0000',0
Editlist_File	db	'EDITLIST',0
Default_File	db	'DEFAULT',0
Ovrlay_File	db	'SESMSG.OVR',0
Clean_File	db	'CLEAN.BAT',0
Findme		db	'????????.',0
EIF_Ext		db	'SIF',0		; Defaults files
TCM_Ext		db	'SMF',0		; Macro files
VME_Ext		db	'SFX',0		; Video Memory

Script_File	db	'SES'
	if ALLOWED_VTRS EQ 7
		db	'-PRO.'
	endif
INI_Ext		db	'INI',0		; Script files

Drive		db	0		; Drive to search
Filename_Ptr	dw	0

Thousand	db	0E8H,003H,0	; 1,000

Dstart_Cnt	db	FPS * 5,0,0	; Five seconds
Dplay_Cnt	db	FPS * 5,0,0	; Five seconds
Dtest_Cnt	db	FPS * 2,0,0	; Two seconds

;================================================================
;		NTSC (you gotta love it) EQUATES
;================================================================
	IF  NTSC
Hrs_Cnt		db	0E0h,0A5h,1	; Frames / hour
Min_Cnt		db	8,7,0		; Frames / minute
Sec_Cnt		db	FPS,0,0		; Frames / sec
Frm_Cnt		db	1,0,0
Dmin_Cnt	db	1fh,23h,0	;6,7,0 ;1 non-drop min * 5

Sort_Tcfmt	db	0FFh,08Ch,027h	; 23:59:59:29
Twenty4hrs	db	000H,08Dh,027h	; 24:00:00:00
Twenty4hrs_N	db	0e0h,082h,027h	; 24 hrs, non drop
Hundredhrs	db	80h,0cbh,0a4h	;100:00:00:00

Dhours_Table	equ	$
	TimeTable	074h, 0A5h, 001h, 100, 3, FALSE
Dminutes_Table	equ	$
	TimeTable	006H, 007H, 000h,  60, 3, TRUE

Dseconds_Table	equ	$
Nseconds_Table	equ	$
	TimeTable	FPS, 000h, 000h,  60, 2, FALSE
Nhours_Table	equ	$
	TimeTable	0E0h, 0A5h, 001h, 100, 3, FALSE
Nminutes_Table	equ	$
	TimeTable	008H, 007H, 000H,  60, 3, FALSE
	ENDIF


	IF PAL
Hrs_Cnt		db	090h,0F5h,1	; Frames / hour
Min_Cnt		db	0DCH,005H,0	; Frames / minute
Sec_Cnt		db	FPS,0,0		; Frames / sec
Frm_Cnt		db	1,0,0
Dmin_Cnt	db	4CH,01DH,0	; 1 non-drop min * 5

Sort_Tcfmt	db	0ffh,08ch,027h	; 23:59:59:29
Twenty4hrs	db	0,8dh,27h	; 24:00:00:00
Twenty4hrs_N	db	0,8dh,027h	; 24 hrs, non drop
Hundredhrs	db	40h,054h,089h	;100:00:00:00

Dhours_Table	equ	$
	TimeTable	090h, 05Fh, 001h, 100, 3, FALSE
Dminutes_Table	equ	$
	TimeTable	0DCh, 005h, 000h,  60, 3, FALSE

Dseconds_Table	equ	$
Nseconds_Table	equ	$
	TimeTable	FPS, 000h, 000h,  60, 2, FALSE
Nhours_Table	equ	$
	TimeTable	090h, 05Fh, 001h, 100, 3, FALSE
Nminutes_Table	equ	$
	TimeTable	0DCh, 005h, 000h,  60, 3, FALSE

	ENDIF

	purge	TimeTable


; X = REC, Y = SOURCE
Pal_TruthTable	db	 0,-1,-2,-3
		db	-3, 0,-1,-2
		db	-2,-3, 0,-1
		db	-3,-2,-3, 0

_DATA	ends

	end
