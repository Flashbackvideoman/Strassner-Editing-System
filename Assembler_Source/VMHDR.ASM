; Last revised: 2-22-1995, 11:12:23   (C)1989-1995 Norman H. Strassner

; VMHDR.ASM
; Header file for equates

include vm.equ
include SESSUM.DAT

_TEXT	segment byte public 'CODE'
	assume	cs:_TEXT,ds:_DATA

Public  Scrl_Edlpage, Tag_Scr, Print_Scr, Clean_Scr, Diskon_Scr
Public  Srt_Scr, Gpi_Scr, Spd_Scr, Pmc_Scr, Swenabl_Scr, Vlan_Scr
Public  Countdown_Scr, Assign_Scr, Lastkey_Scr, Descript_Scr, Editmode_Scr
Public  Freemem_Scr, Binnum_Scr, Event_Lnum_Scr, Edit_Lnum_Scr, Frames_Area
Public  From_Area, Fwhat_Area, Kbd_Data_Pos, Kbd_Tc_Pos, Keyboard_Scr, List_Scr
Public  Listttl_Scr, Listtype_Scr, Msg_Area, Tcf_Scr, Title1_Scr, Title2_Scr
Public  Transtyp_Scr, Transtof_Scr, Transtim_Scr, Time_Scr, Const0_Scr
Public  Video_Scr, Lastline_Scr, Comport_Scr, Calcttl_Scr, Timeline_Scr
Public  Jsticklr_Scr, Jstickset_Scr, Jstickaxis_Scr, Jstickbutn_Scr
Public  Jstickxy_Scr, Jstickline_Scr, Editstatus_Area, SourceVTRa_Scr
Public  Preread_Scr

public OVRFILE_size,overlay_checksum

;----------------------------------------------------------------
; Scroll equates
Scrl_Edlpage	equ	(last_line - 1) - list_line

;================================================================
SourceVTRa_Scr	equ	(a_line * 256) + reel_offset
SourceAXBL_scr	equ	(a_line * 256) + mach_offset
Tag_Scr		equ	(Flag1_line * 256) + Flag1_offset
Print_Scr	equ	(Flag2_line * 256) + Flag2_offset
Clean_Scr	equ	(Flag3_line * 256) + Flag3_offset
Diskon_Scr	equ	(Flag6_line * 256) + Flag4_offset
Srt_Scr		equ	(Flag4_line * 256) + Flag5_offset
Gpi_Scr		equ	(Flag5_line * 256) + Flag6_offset
Spd_Scr		equ	(Flag7_line * 256) + Flag7_offset
Pmc_Scr		equ	(Flag8_line * 256) + Flag8_offset
Swenabl_Scr	equ	(Flag9_line * 256) + Flag9_offset
Vlan_Scr	equ	(Flag10_line * 256) + Flag10_offset

;;Countdown_Scr	equ	(aux_line * 256) + 65
Countdown_Scr	equ	(kbd_line * 256) + 65 - 12

Assign_Scr	equ	(assign_line * 256) + null_offset
Lastkey_Scr	equ	(lastkey_line * 256) + lastkey_offset
Descript_Scr	equ	(descript_line * 256) + dscript_offset
Editmode_Scr	equ	(editmode_line * 256) + editmode_offset
Freemem_Scr	equ	(freemem_line * 256) + frenum_offset	; freemem
Binnum_Scr	equ	(bin_line * 256) + bin_offset		;
Event_Lnum_Scr	equ	(evnt_lnumline * 256) + null_offset	; ok
Edit_Lnum_Scr	equ	(edlstats_line * 256) + null_offset
Frames_Area	equ	(kbd_line * 256) + frames_offset
From_Area	equ	(kbd_line * 256) + from_offset
Fwhat_Area	equ	(kbd_line * 256) + fwhat_offset
Kbd_Data_Pos	equ	(kbd_line * 256) + kbdat_offset
Kbd_Tc_Pos	equ	(kbd_line * 256) + kbdtc_offset
Keyboard_Scr	equ	(kbd_line * 256) + null_offset
List_Scr	equ	(list_line * 256) + null_offset
Listttl_Scr	equ	(listttl_line *	256) + null_offset
Listtype_Scr	equ	(listtype_line * 256) + listtype_offset
Msg_Area	equ	(kbd_line * 256) + msg_offset
Editstatus_Area	equ	(kbd_line * 256) + edstatus_offset
Tcf_Scr		equ	(r_line * 256) + fcmtyp_offset
Title1_Scr	equ	(top_line * 256) + null_offset
Title2_Scr	equ	(title_line * 256) + null_offset

Preread_Scr	equ	(preread_line * 256) + preread_offset

Transtyp_Scr	equ	(transtyp_line * 256) + trans_offset
Transtof_Scr	equ	(transtof_line * 256) + trans_offset
Transtim_Scr	equ	(transtim_line * 256) + trans_offset

Time_Scr	equ	(time_line * 256) + time_offset
Const0_Scr	equ	(const0_line * 256) + const0_offset

Video_Scr	equ	(mode_line * 256) + vdo_offset
Lastline_Scr	equ	(last_line * 256) + null_offset
Comport_Scr	equ	(comport_line * 256) + comport_offset

Calcttl_Scr	equ	(mode_line * 256) + 0
Timeline_Scr	equ	(timeline_line * 256) + null_offset

;================================================================
; Joystick screen equates
Jsticklr_Scr	equ	List_Scr + 0100h	; Left right query
Jstickset_Scr	equ	List_Scr + 0100h	; questions
Jstickaxis_Scr	equ	List_Scr + 0404h	; Center query
Jstickbutn_Scr	equ	List_Scr + 0024h	; Button
Jstickxy_Scr	equ	List_Scr + 0704h	; XY position (1st line)
Jstickline_Scr	equ	List_Scr + 0600h	; Horizontal line

;*********************************************************************
;   O V E R L A Y   M E S S A G E   R E C O R D   N U M B E R S

include	vmmsg.equ

;================================================================
;		MACROS
;================================================================
KEY	macro	Name,hb,lb
public Name
	Name	equ	(hb * 256) + lb
	endm

;*************************************************************************
;	K E Y B O A R D   K E Y S   A N D   T H E R E	C O M M A N D S
;*************************************************************************

;----------------------------------------------------------------
; Normal Function keys
	KEY	GPI_xcmd		,59 ,0		; F1
	KEY	Links_xcmd		,60 ,0		; F2
	KEY	Asmthis_xcmd		,61 ,0		; F3
	KEY	Opend_xcmd		,62 ,0		; F4
	KEY	Exch_xcmd		,63 ,0		; F5
	KEY	Bins_xcmd		,64 ,0		; F6
	KEY	InsEv_xcmd		,65 ,0		; F7
	KEY	DelEv_xcmd		,66 ,0		; F8
	KEY	Find_xcmd		,67 ,0		; F9
	KEY	Status_xcmd		,68 ,0		; F10
	KEY	Summary_xcmd		,133,0		; F11
	KEY	Progspeed_xcmd		,134,0		; F12
	KEY	Ctrlbreak_xcmd		,0  ,0

;----------------------------------------------------------------
; Shifted function KEYs
	KEY	Macch_xcmd		,84 ,0		; F1
	KEY	Ememopts_xcmd		,85 ,0		; F2
	KEY	Assemble_xcmd		,86 ,0		; F3
	KEY	ChgEv_xcmd		,87 ,0		; F4
	KEY	Move_xcmd		,88 ,0		; F5
	KEY	Clwrk_xcmd		,89 ,0		; F4
	KEY	Cledt_xcmd		,90 ,0		; F7
	KEY	Cllst_xcmd		,91 ,0		; F8
	KEY	Sort_xcmd		,92 ,0		; F9
	KEY	Setdflts_xcmd		,93 ,0		; F10
	KEY	Fill_xcmd		,136,0		; F12

;----------------------------------------------------------------
; Alt function KEYs
	KEY	Tgtgl_xcmd		,104,0		; ALT F1
	KEY	Ptgl_xcmd		,105,0		; ALT F2
	KEY	Clean_xcmd		,106,0		; Alt F3
	KEY	Diskon_xcmd		,107,0		; Alt F4

	KEY	Color_xcmd		,113, 0		; Alt f10
	KEY	MatchPMC_xcmd		,140, 0		; Alf f12

;----------------------------------------------------------------
; Ctrl function KEYs
	KEY	Xmac1_xcmd		,94 ,0		; 
	KEY	Xmac2_xcmd		,95 ,0		; 
	KEY	Xmac3_xcmd		,96 ,0		; 
	KEY	Xmac4_xcmd		,97 ,0		; 
	KEY	Xmac5_xcmd		,98 ,0		; 
	KEY	Xmac6_xcmd		,99 ,0		; 
	KEY	Xmac7_xcmd		,100,0		; 
	KEY	Xmac8_xcmd		,101,0		; 
	KEY	Xmac9_xcmd		,102,0		; 
	KEY	Xmac10_xcmd		,103,0		; 

;----------------------------------------------------------------
; Normal TOP ROW
	KEY	ChgEvNum_xcmd		,41 ,96		; `
	KEY	Reel_xcmd		,2  ,49		; 1
	KEY	Match_xcmd		,3  ,50		; 2
	KEY	Savemarks_xcmd		,4  ,51		; 3
	KEY	Erecal_xcmd		,5  ,52		; 4
	KEY	RepEv_xcmd		,6  ,53		; 5
	KEY	Cmnt_xcmd		,7  ,54		; 6
	KEY	Pagef_xcmd		,8  ,55		; 7
	KEY	Lodfl_xcmd		,9  ,56		; 8
	KEY	Savfl_xcmd		,10 ,57		; 9
; Same as above
	KEY	Load_xcmd		,9  ,56		; 8
	KEY	Save_xcmd		,10 ,57		; 9

	KEY	Rstrt_xcmd		,11 ,48		; 0
	KEY	KEYhlp_xcmd		,12 ,45		; -
	KEY	Seeke_xcmd		,13 ,61		; =
	KEY	Backspace_xcmd		,14 ,8		; Backspace

;----------------------------------------------------------------
; Shifted TOP ROW
	KEY	Sorttgl_xcmd		,41 ,126	; ~
	KEY	Allreels_xcmd		,2  ,33		; !
	KEY	Tagit_xcmd		,3  ,64		; @
	KEY	Lastmarks_xcmd		,4  ,35		; #
	KEY	Frecal_xcmd		,5  ,36		; $
	KEY	Undo_xcmd		,6  ,37		; %
	KEY	Title_xcmd		,7  ,94		; ^
	KEY	Prntfil_xcmd		,8  ,38		; &
	KEY	Read_xcmd		,9  ,42		; *
	KEY	Send_xcmd		,10 ,40		; (
	KEY	Shell_xcmd		,11 ,41		; )
	KEY	Olm_xcmd		,12 ,95		; _
	KEY	Shift_xcmd		,13 ,43		; =


;----------------------------------------------------------------
; ALT TOP ROW
	KEY	Eject_xcmd		,120 ,0		; ALT 1
	KEY	MatchExt_xcmd		,121 ,0		; ALT 2
	KEY	Receive_xcmd		,123 ,0		; ALT 4
	KEY	Transmit_xcmd		,124 ,0		; ALT 5
	KEY	Shodr_xcmd		,127 ,0		; ALT 8
	KEY	Logdr_xcmd		,128 ,0		; ALT 9
	KEY	Xterm_xcmd		,129 ,0		; ALT 0
	KEY	Quit_xcmd		,131 ,0		; ALT =

;----------------------------------------------------------------
; CTRL top row (2,6,_ only
	KEY	Debug_xcmd		,12 ,31		; CTRL-_
	KEY	Cpywrt_xcmd		,7  ,30		; CTRL-6

;----------------------------------------------------------------
; qwertyuiop[]\
	KEY	Rcmpt_xcmd		,15 ,9		; tab
	KEY	RcmptEDL_xcmd		,15 ,0		; Shift-Tab

	KEY	Record_xcmd		,16 ,113	; q
	KEY	Review_xcmd		,17 ,119	; w
	KEY	Rehearse_xcmd		,18 ,101	; e
	KEY	Bvb_xcmd		,19 ,114	; t
	KEY	Vbv_xcmd		,20, 116	; r
	KEY	Vidsel_xcmd		,21 ,121	; Y
	KEY	Au1sel_xcmd		,22 ,117	; U
	KEY	Au2sel_xcmd		,23 ,105	; I
	KEY	Split_xcmd		,24 ,111	; O
	KEY	Cut_xcmd		,25 ,112	; P
	KEY	Dis_xcmd		,26 ,91		; [
	KEY	Wip_xcmd		,27 ,93		; ]

;----------------------------------------------------------------
; CTRL QWERTYUIOP[]
	KEY	AddEv_xcmd		,16 ,17		; ^Q
	KEY	Tglenable_xcmd		,17 ,23		; ^W
	KEY	Allenable_xcmd		,18 ,5		; ^E
	KEY	Alldisable_xcmd		,19 ,18		; ^R

	KEY	Hardvid_xcmd		,21 ,25		; ^Y
	KEY	Hardaud1_xcmd		,22 ,21		; ^U
	KEY	Hardaud2_xcmd		,23 ,9		; ^I
	KEY	Modesoff_xcmd		,24 ,15		; ^O
;;	KEY	macroPause_xcmd		,25 ,16		; ^P
	KEY	PrereadOnOff_xcmd	,25, 16

;----------------------------------------------------------------
; SHIFT QWERTYUIOP[]
	KEY	VV_xcmd			,18 ,69
	KEY	VB_xcmd			,19 ,82
	KEY	BV_xcmd			,20 ,84
	KEY	Swenabl_xcmd		,21 ,89		; Shift-Y
	KEY	Auenabl_xcmd		,22 ,85		; Shift-U
	KEY	Makdiss_xcmd		,26 ,123	; Shift {
	KEY	Makwipe_xcmd		,27 ,125	; Shift }
	KEY	Transw_xcmd		,25 ,80		; Shift P
	KEY	KEY_xcmd		,43 ,124	; Shift \

;----------------------------------------------------------------
	KEY	MultRecord_xcmd		,16, 0		; Alt Q
	KEY	UndoWorkspace_xcmd	,17, 0		; Alt W
	KEY	Reelsum_xcmd		,19, 0		; Alt R
	KEY	Preread_xcmd		,25, 0		; Alt P
;----------------------------------------------------------------
; asdfghjkl;'
	KEY	Rm_xcmd			,30 ,97		; a

	KEY	Am_xcmd			,31 ,115	; s

	if ALLOWED_VTRS EQ 2
	KEY	Au_xcmd			,32 ,100	; d
	KEY	Bl_xcmd			,33 ,102	; f
	endif

	if ALLOWED_VTRS EQ 3
	KEY	Bm_xcmd			,32 ,100	; d
	KEY	Au_xcmd			,33 ,102	; f
	KEY	Bl_xcmd			,34 ,103	; g
	endif

	if ALLOWED_VTRS EQ 4
	KEY	Bm_xcmd			,32 ,100	; d
	KEY	Cm_xcmd			,33 ,102	; f
	KEY	Au_xcmd			,34 ,103	; g
	KEY	Bl_xcmd			,35 ,104	; g
	endif

	if ALLOWED_VTRS EQ 5
	KEY	Bm_xcmd			,32 ,100	; d
	KEY	Cm_xcmd			,33 ,102	; f
	KEY	Dm_xcmd			,34 ,103	; g
	KEY	Au_xcmd			,35 ,104	; g
	KEY	Bl_xcmd			,36, 106
	endif

	if ALLOWED_VTRS EQ 6
	KEY	Bm_xcmd			,32 ,100	; d
	KEY	Cm_xcmd			,33 ,102	; f
	KEY	Dm_xcmd			,34 ,103	; g
	KEY	Em_xcmd			,35 ,104	; g
	KEY	Au_xcmd			,36, 106
	KEY	Bl_xcmd			,37 ,107	; h
	endif

	if ALLOWED_VTRS EQ 7
	KEY	Bm_xcmd			,32 ,100	; d
	KEY	Cm_xcmd			,33 ,102	; f
	KEY	Dm_xcmd			,34 ,103	; g
	KEY	Em_xcmd			,35 ,104	; g
	KEY	Fm_xcmd			,36, 106
	KEY	Au_xcmd			,37 ,107	; h
	KEY	Bl_xcmd			,38 ,108	; j
	endif

	KEY	Tccalc_xcmd		,39 ,59		; ;

	KEY	Calc2cnst_xcmd		,39 ,58		; : (shift)

	KEY	Scrconst_xcmd		,40 ,39		; '
	KEY	Rptgl_xcmd		,28 ,13		; cr

;----------------------------------------------------------------
; SHFT ASDFGHJKL;'

	KEY	Stopwatch_xcmd		,38 ,76		; L
	KEY	Scrconstb_xcmd		,40 ,34		; "

;----------------------------------------------------------------
; CTRL ASDFGHJKL;'
	KEY	EDLtrkone_xcmd		,30 ,1		; ^A
	KEY	Splitscrn_xcmd		,31 ,19		; ^S
	KEY	Display_xcmd		,32 ,4		; ^D
	KEY	Postroll_xcmd		,38 ,12		; ^L
	KEY	Preroll_xcmd		,37 ,11		; ^K
	KEY	Switchtc_xcmd		,36 ,10		; ^J
;----------------------------------------------------------------
; ALT ASDFGHJKL

	KEY	EDLtrack_xcmd		,30 ,0		; Alt A
	KEY	VtrSwap_xcmd		,31 ,0		; Alt S

	if ALLOWED_VTRS LT 7
	KEY	SwapVidSwitcher_xcmd	,35 ,0		; Alt aux
	else
	KEY	SwapVidSwitcher_xcmd	,37 ,0		; 
	endif

	KEY	Music_xcmd		,33 ,0		; Alt F
	KEY	Counter_xcmd		,38 ,0		; Alt L

;----------------------------------------------------------------
; ZXCVBNM,./
	KEY	Shuttlefwd_xcmd		,45 ,120	; x
	KEY	Shuttleback_xcmd	,44 ,122	; z
	KEY	Play_xcmd		,46 ,99		; c
	KEY	Still_xcmd		,47 ,118	; v
	KEY	Reverse_xcmd		,48 ,98		; ^B
	KEY	Gotoin_xcmd		,49 ,110	; N
	KEY	Markin_xcmd		,50 ,109	; m
	KEY	Markout_xcmd		,51 ,44		; , 
	KEY	Frame_xcmd		,52 ,46		; .
	KEY	Scrini_xcmd		,53 ,47		; /

;----------------------------------------------------------------
; SHIFT ZXCVBNM<>?
	KEY	Rewind_xcmd		,44 ,90 	; Z
	KEY	Fastfwd_xcmd		,45 ,88 	; X
	KEY	Twiceplay_xcmd		,46 ,67		; C

	KEY	Stop_xcmd		,47 ,86		; V
	KEY	Cue_xcmd		,49 ,78		; N

	KEY	Markput_xcmd		,50 ,77		; m
	KEY	Markget_xcmd		,51 ,60		; , 

	KEY	Kbdhlp_xcmd		,53 ,63		; ?
	KEY	Framesw_xcmd		,52 ,62		; >

	KEY	Markon_xcmd		,50 ,77		; M
	KEY	Markoff_xcmd		,51 ,60		; ,

;----------------------------------------------------------------
; CTRL ZXCVBNM
	KEY	Twicefwd_xcmd		,45 ,24		; ^X
	KEY	Twicerev_xcmd		,44 ,26		; ^Z
	KEY	Gotoout_xcmd		,49 ,14		; ^N
	KEY	Snctg_xcmd		,50 ,13		; ^M (ctrl mark in)


;----------------------------------------------------------------
; ALT ZXCVBNM

	KEY	Slowfwd_xcmd		,45 ,0		; Alt-X
	KEY	Slowrev_xcmd		,44 ,0		; Alt-Z
	KEY	ExactSpeed_xcmd		,46 ,0		; Alt-C
	KEY	All_Stop_xcmd		,47 ,0		; Alt-V
	KEY	Bell_xcmd		,48 ,0		; Alt-B
	KEY	All_Cue_xcmd		,49 ,0		; Alt-N
	KEY	SncTgExt_xcmd		,50 ,0		; Alt-M (mark in)


;----------------------------------------------------------------
; Number pad block
 	KEY	Dbl0_xcmd		,83 ,46		; Shift del
	KEY	Scnxt_xcmd		,80 ,50		; down arrow
	KEY	Sclst_xcmd		,72 ,56		; up arrow
	KEY	Avail9_xcmd		,72,0		; left arrow
	KEY	Avail10_xcmd		,72,0		; right arrow
	KEY	End_KEY			,79 ,49		;
	KEY	Home_KEY		,71 ,55		;
	KEY	Pageup_KEY		,73 ,57		;
	KEY	Pagedn_KEY		,81 ,51		;
	KEY	Five_KEY		,76 ,53		; Numpad 5

	KEY	Macro_xcmd		,74 ,45		; Numpd -
	KEY	Thisevent_xcmd		,55 ,42		;   ""   " ""
	KEY	Colonplus_xcmd		,78 ,43		; +/:

	KEY	Insert_key		,82, 48		; INS num pad
	KEY	Delete_key		,83 ,46		; DEL num pad

;----------------------------------------------------------------
; 6 KEY block
	KEY	Trimin_xcmd		,82 ,224	; Trim IN (insert)
	KEY	Trimout_xcmd		,71 ,224	; Trim OUT (high rev)
	KEY	Const_xcmd		,73 ,224	; Constants (High fwd)
	KEY	Inrtn_xcmd		,83 ,224	; Delete
	KEY	Outrt_xcmd		,79 ,224	; Slow rev
	KEY	Durrt_xcmd		,81 ,224	; Slow fwd


; 4 KEY block
	KEY	Pause_xcmd		,80 ,224	; STILL
	KEY	Search_xcmd		,72 ,224	; "Exit Shtl"
	KEY	Bump_Plus_xcmd		,116,224	; Ctrl-right arrow
	KEY	Bump_Minus_xcmd		,115,224	; Ctrl-left arrow
	KEY	Srchfwd_xcmd		,77 ,224	; left arrow
	KEY	Srchrev_xcmd		,75 ,224	; right arrow

	KEY	VariFwd_xcmd		,157,0		; Alt right arrow
	KEY	VariRev_xcmd		,155,0		; Alt left arrow
;----------------------------------------------------------------
;MISC KEYS

	KEY	SymUp_xcmd		,72  ,0
	KEY	SymDn_xcmd		,80  ,0

	KEY	MulttrimIN_xcmd		,162 ,0		; Alt IN
	KEY	MulttrimOUT_xcmd	,151 ,0		; Alt OUT

	KEY	Suspend_KEY		,160 ,0		; Alt PAUSE/PLAY
	KEY	Pausetime_xcmd		,152 ,0		;3-10-1993 

	KEY	Viewedl1_KEY		,8  ,55		; View [page]
	KEY	Viewedl2_KEY		,47 ,118	; View [page]

	KEY	Enter_xcmd		,28 ,13		; enter
	KEY	Space_xcmd		,57 ,32		; space bar
	KEY	Escape_xcmd		,1  ,27		; Escape

	KEY	ForcedESC_xcmd		,148,0		; Ctrl RECALC

	KEY	Shiftsplit_xcmd		,24 ,79		; Shift O

	KEY	Rampspeed_xcmd		,138, 0		; ramp speed

	KEY	Plus2_xcmd		,13 ,61		; = alternate for +

	KEY	Plus3_xcmd		,55 ,42		;

	KEY	Clrrd_xcmd		,43 ,92		; \
	KEY	CtrlKEY_xcmd		,43 ,28		; ^\

	KEY	Ctrlx_xcmd		,45 ,24		; ^X
	KEY	Macterm_xcmd		,28,10		; ^<cr>

	KEY	Swlrn_xcmd		,21 ,0		;Alt Y (video)
	KEY	Swrcl_xcmd		,22 ,0		;Alt U (A1)
	KEY	Emlrn_xcmd		,23 ,0		;Alt I (A2)
	KEY	Emrcl_xcmd		,24 ,0		;Alt O (Split)

	KEY	Triggernow_xcmd		,20 ,116	; T
	KEY	F1_KEY			,59 ,0		;
	KEY	F2_KEY			,60 ,0		;
	KEY	F3_KEY			,61 ,0		;
	KEY	F4_KEY			,62 ,0		;
	KEY	F5_KEY			,63 ,0		;
	KEY	F6_KEY			,64 ,0		;
	KEY	F7_KEY			,65 ,0		;
	KEY	F8_KEY			,66 ,0		;
	KEY	F9_KEY			,67 ,0		;
	KEY	F10_KEY			,68 ,0		;
	KEY	F11_KEY			,133,0		;
	KEY	F12_KEY			,134,0		;
	KEY	YesKEY_xcmd		,75 ,52		;
	KEY	NoKEY_xcmd		,77 ,54		;
	KEY	Ctrlc_xcmd		,46 ,3		; ^C

	KEY	Sf1_KEY			,84 ,0		; Shift F1
	KEY	Sf2_KEY			,85 ,0		; Shift F2
	KEY	Sf3_KEY			,86 ,0		; Shift F3
	KEY	Sf4_KEY			,87 ,0		; Shift F4
	KEY	Sf5_KEY			,88 ,0		; Shift F5
	KEY	Sf6_KEY			,89 ,0		; Shift F4
	KEY	Sf7_KEY			,90 ,0		; Shift F7
	KEY	Sf8_KEY			,91 ,0		; Shift F8
	KEY	Sf9_KEY			,92 ,0		; Shift F9
	KEY	Sf10_KEY		,93 ,0		; Shift F10
	KEY	Sf11_KEY		,135,0		; Shift F11
	KEY	Sf12_KEY		,136,0		; Shift F12

	KEY	Ctrlhome_KEY		,119,0
	KEY	Ctrlend_KEY		,117,0
	KEY	Ctrlright_KEY		,116,0
	KEY	Ctrlleft_KEY		,115,0
	KEY	Ctrlins_KEY		,146,0
	KEY	Ctrldel_KEY		,147,0
	KEY	Ctrlpgup_KEY		,132,0
	KEY	Ctrlpgdn_KEY		,118,0

	KEY	Shfthome_KEY		,71 ,0
	KEY	Shftend_KEY		,79 ,0
	KEY	Shftpgup_KEY		,73 ,0
	KEY	Shftpgdn_KEY		,81 ,0
	KEY	Shftins_KEY		,82 ,0
	KEY	Shftdel_KEY		,83 ,0

;================================================================
; Translation KEYs
	KEY	Nument_KEY		,224 ,13	;
	KEY	Cancel_KEY		,224 ,47	;
	KEY	Ctrl_Bkslsh		,149 ,0		;

	KEY	Ctrl_Astrck		,150 ,0		;

	KEY	Ctrl_Dash		,142 ,0		;
	KEY	Ctrl_Plus		,144 ,0		;
	KEY	Ctrl_Enter		,224 ,10	;

	KEY	CCT_xcmd		,135,0		; Shift F11

_TEXT	ends

_DATA	segment byte public 'DATA'

_DATA	ends

	end

