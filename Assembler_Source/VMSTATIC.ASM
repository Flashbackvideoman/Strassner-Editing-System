; Last revised: 2-22-1995, 11:12:23   (C)1989-1995 Norman H. Strassner

;VMSTATIC.ASM
; Storage module for VM.ASM and other related assembly files

.xlist
include vm.equ
.xlist

extrn  sel_DISSOLVE:word , sel_SES:word,sel_CUTS:word

.list

;================================================================
_DATA	segment para public 'DATA'
	assume ds:_DATA
.xlist

public Fcb,Fcb2,DTA,Seriel_Num,Author,Authcr
public Flag1,SelTable,EdlSES,Dflts_Area,Dflts_Version,Dflts_Ttl
public Default_Command,Reel_Assignments,R_Reel_Num,Reelbuf_Length,A_Reel_Num,Aux_Reel_Num
public Blk_Reel_Num,Vtrcb,Rtcf,Auxtcf,Blktcf,Gpi_Node
public Switcher_Flags,Edit_Flags,Operational_Flags,EDLoptions_Flags,DOS_Flags,Sounddisplay_Flags
public Network_Flags,Slave_Flags,Gpi_Flags,Pmc_Flags,Spd_Flags,Ramp_Flags
public MultRec_Flags,VLAN_Flags,Color_BKG,Color_GRID,Color_EDL,Color_CNTREDL
public Color_WRKSPCE,Color_DIM,Color_NORM,Color_REV,Color_ULINE,Tag_Flag
public Priority_Flag,Blink_Time,Editsync,Editsync,Editsync,Retry_Count
public Assembly_Mode,Frame_Flag,Edltrack_Delay,Edltrack_Cdelay,DelEdRoll_Qrtrs,Hardrecord_Flag
public Device_Enabled,SX_Type,AX_Type,EFX_Flag,Effects_Address,emem_efxadr
public upstream_keynumber,dnstream_keynumber,Oddeven_Mask,JoggerIRQ,ShuttleSensitivity,JoggerSensitivity
public Dir_Chos,INSTL_Chos,INSTL_Choices,Macedit_Choice,Setcom_Chos,Default_Mode
public Wild1,Wild2,Joykey1,Joykey2,System_Color_Frame,Edits_To_Look_Ahead
public dsk_trans,ftb_trans,Exchbuf1,Mode_Flag,PX_Type
public Current_VTRS,Current_Source,Current_Machine,Current_VT_Cb,Current_Reel_Adr,Current_Reel_Scr
public Current_Mach_Scr,Current_Inbuf,Current_Outbuf,Current_Duration,Current_FRMbuf,Current_TObuf
public Current_BKGbuf,Current_FORbuf,Trans_Type,Trans_Code,Trans_Length,From_Machine
public To_Machine,Key_Trans,Split_Mode,Key_Mode,Keyfor_Src,Keybkgnd_Src
public Split_Delay,Marks_Table,R_Tc,a_tc,b_tc,c_tc
public d_tc,aux_tc,blk_tc,Exchbot
public Exchlen,Mtbl_Start,Mtbl_Length,Preroll,Postroll,Recordpost
public Time_Start,TimeLineRoll,Otf_Adjust,VvvIN_Offset,VvvOUT_Offset,SplitV_Offset
public SplitA_Offset,Atrans_Offset,VbvIN_Offset,VbvOUT_Offset,BvbIN_Offset,BvbOUT_Offset
public Gtrans_Offset,Sync_Offset_In,Sync_Offset_Out,PMC_Offset,RT_Offset,Last_Trim
public Last_Duration,Tcgen_Start,Tcgen_Mode,Constants,Gpi0,Slave_Table
public Trim_Table,Multrecord_Table,Swap_Table,Progmotion_Tbl,Tags_Table,Macro_Buffers
public Macro_Ttl,Macro0,Macro_Ttls,Macro_Bottom,Macro_Length,Edl_Ext
public EDL_Subdir,AUTOFILE_Subdir,VME_Subdir,TCM_Subdir,TMP_Subdir,Current_EDL
public Current_EIF,Current_TCM,Current_VME,Saveload_EDL,Relaytype_Tbl,RampSpeedChange
public Dflts_Bottom,Dflts_Length,Dflts_Pad
public ZeroBase,VlanPreviewPort

.list

;================================================================
; 100h to move PSP of program to here

ZeroBase	equ	$

	db	5ch dup(?)
Fcb	db	10h dup(?)
Fcb2	db	10h dup(?)
	align 16
DTA	db	128 dup(?)

;================================================================
; Program identification
	if ALLOWED_VTRS EQ 7
		db	'SES-PRO Edit Controller  '
	else
		db	'SES Edit Controller      '
	endif

	if DEMO_RELEASE
		db	' DEMO'
	ENDIF

	if BETA_RELEASE
		db	' Beta'
	ENDIF

Seriel_Num	db	'0000',rt,' '
		db	d1,d2,d3,d4,d5,d6
		db	'-',v1,v2,v3

	if (NOT DEMO_RELEASE) and (NOT BETA_RELEASE)
	IF NTSC
	db	' NTSC / '
	ENDIF

	IF PAL
	db	' PAL / '
	ENDIF

		if ALLOWED_VTRS EQ 7
		db	'"Pro" Edition'
		else
			if CUTS_ONLY
			db	'Single Source'
			else
			db	'Multiple Source'
			endif
		endif
	endif

	if DEMO_RELEASE
	 DB ' DEMONSTRATION VERSION'
	ENDIF

;;	if BETA_RELEASE
;;	DB ' [Beta Test]'
;;	ENDIF

		DB	0

;================================================================
; Author Identification
Author	db	'SES.EXE ',v1,'.',v2,v3,rt
	db	'  ',d1,d2,'/',d3,d4,'/',d5,d6
	db	' (C) 1988-1996, Norman H. Strassner'
Authcr	db	cr,lf,'$'

Flag1		db	0
SelTable	DW	sel_CUTS, sel_DISSOLVE , sel_SES

	if ALLOWED_VTRS EQ 7
EdlSES	db	'SES-PRO, Ver. ',v1,'.',v2,v3,rt,'  ',0
	else
EdlSES	db	'SES Editor, Ver. ',v1,'.',v2,v3,rt,'  ',0
	endif

;****************************************************************
;
;	  Defaults area (saved/loaded as ????????.EIF
;
;****************************************************************
		org	200h

Dflts_Area	equ	$
		db	v1,v2,v3,d1,d2,d3,d4,d5,d6

Dflts_Version	db	rt
		db	ALLOWED_VTRS
		dw	NTSC
		dw	CUTS_ONLY
		dw	DEBUGGER
		DW	ALLOWRAMPSPEED	
		DW	ALLOW_VLAN3	
		DW	DEBUGGER	
		DW	DEBUGGING	
		dw	0

		org	280h

Dflts_Ttl	db	'[Default startup]',cr,lf,0



;----------------------------------------
;	  Default Command Block
;----------------------------------------
		org	 300h

Default_Command		dw	0		; Command to execute at start up time


;----------------------------------------
;	  VTR DATA TABLES
;----------------------------------------
		org	400h

Reel_Assignments	equ	$
R_Reel_Num	db	'RECORD',0
Reelbuf_Length	equ	($ - Reel_Assignments)
A_Reel_Num	db	'001   ',0
	if ALLOWED_VTRS GT 2
		db	'002   ',0
	endif
	if ALLOWED_VTRS GT 3
		db	'003   ',0
	endif
	if ALLOWED_VTRS GT 4
		db	'004   ',0
	endif
	if ALLOWED_VTRS GT 5
		db	'005   ',0
	endif
	if ALLOWED_VTRS GT 6
		db	'006   ',0
	endif
Aux_Reel_Num	db	'AX    ',0
Blk_Reel_Num	db	'BL    ',0
		db	0ffh


;================================================================
;VTR Control blocks: VTRs RECORD, A-F, Aux, Black
;                                                 Edit Err
;__Port_VXPTS_AXPTS_FCM__TCM_SPD_DIR_PGM__Window__ValueSign________________________________
;db  1,   0,   0,   ' ',  1,  0,  0,  30,   0,   0,    0,   0,  0,  0,  0,  0
Vtrcb	equ	 $
	VTRCB_RECORD	<1,0,0, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	VTRCB_RECORD	<2,1,1, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	if ALLOWED_VTRS GT 2
	VTRCB_RECORD	<3,2,2, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	endif
	if ALLOWED_VTRS GT 3
	VTRCB_RECORD	<4,3,3, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	endif
	if ALLOWED_VTRS GT 4
	VTRCB_RECORD	<5,4,4, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	endif
	if ALLOWED_VTRS GT 5
	VTRCB_RECORD	<6,5,5, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	endif
	if ALLOWED_VTRS GT 6
	VTRCB_RECORD	<7,6,6, ' ',1,0,'+',FPS,0,0,0,0,'+',0,'+'>
	endif
	VTRCB_RECORD	<0,8,8>
	VTRCB_RECORD	<0,0,0>

; Often used address Constants in Vtrcb
Rtcf		equ	(r_dev   * Vtrcb_length) + Vtrcb + Vtrcb_FCM
Auxtcf		equ	(aux_dev * Vtrcb_length) + Vtrcb + Vtrcb_FCM
Blktcf		equ	(blk_dev * Vtrcb_length) + Vtrcb + Vtrcb_FCM


; This is addressed by MAX_DEVICES + 1 in the Vtrcb
Gpi_Node	db	25		; Assignment of first GPI node.

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;  Wipe Mods  extmenu
Switcher_Flags		dw	0 OR wipemods_SWBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
; Use Delayed Ripple RealTime Wipe-  Use Cue
;   Rolls      Slaves  Mode    Mods   track
Edit_Flags		dw	0

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;      sort    clean   frames  lprint askclr asyougo  DISK   LookAhead
Operational_Flags	dw	0

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Mode =   Window=                                Out/Dur   Auto
;EDL format  EDL format                              Display  Disable
;
EDLoptions_Flags	dw	0

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;   Use Menu Use OLM PrntScrn                 EjectPg       Virtual MEM
DOS_Flags		dw	0 OR virtual_DOSBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;   Border  Lastkey           Bell  ErrBell          Q-Recheck TIMEDATE
Sounddisplay_Flags	dw	border_SDBIT OR lastkey_SDBIT OR bell_SDBIT OR errbell_SDBIT OR timedate_SDBIT OR sortedls_SDBIT


;----------------------------------------------------------------
;	15	14	13	12	11	10	9	8
; 							   GPI Available
;	7	6	5	4	3	2	1	0
;   R/P tgl Paus/Play _delhalf         DFdur  EDLtrak  Jogger Joystick
Network_Flags		dw 	rptoggle_NTBIT OR pauseplay_NTBIT OR delhalf_NTBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Enable  Store    Disp
Slave_Flags		dw	store_MSBIT OR disp_MSBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Enable  Store    Disp
Gpi_Flags		dw	store_MSBIT OR disp_MSBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Enable  Store    Disp
Pmc_Flags		dw	store_MSBIT OR disp_MSBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Enable  Store    Disp
Spd_Flags		dw	store_MSBIT OR disp_MSBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Enable  Store    Disp
Ramp_Flags		dw	store_MSBIT OR disp_MSBIT

;----------------------------------------------------------------
;	7	6	5	4	3	2	1	0
;    Enabled
MultRec_Flags		dw	store_MSBIT OR disp_MSBIT

;----------------------------------------------------------------
;VLNBIT
;	7	6	5	4	3	2	1	0
;  swextended ForceV3
VLAN_Flags		dw	0000000000000000b

;================================================================

Color_BKG		db	00000000b
Color_GRID		db	00000111b
Color_EDL		db	00000111b
Color_CNTREDL		db	00001111b
Color_WRKSPCE		db	00000111b
Color_DIM		db	00000111b
Color_NORM		db	00001111b
Color_REV		db	01110000b
Color_ULINE		db	00000001b	;red
			db	0
			db	0
			db	0
			db	0
			db	0
			db	0
			db	0

Tag_Flag		db	0feh	; TAG, TG2, or tag off
Priority_Flag		db	priority; Recall out point priority

Blink_Time		db	3	; # of error blinks

		if NTSC
			if CUTS_ONLY
Editsync		db	2	; 0=Rec, 1=Ampex 1", 2=Source
			else
Editsync		db	0	; 0=Rec, 1=Ampex 1", 2=Source
			endif
		else
Editsync		db	1	; 0=Rec, 1=Ampex 1", 2=Source
		endif

Retry_Count		db	3	; For edit re-trys
Assembly_Mode		db	'A'	; Assembly mode
Frame_Flag		db	0	; 0 = TC, 0ffh = FRAMES
			db	0	; Makes PUSHable word out of Frame_Flag

Edltrack_Delay		db	2
Edltrack_Cdelay		dw	1000

DelEdRoll_Qrtrs		db	0	; Delay before edit roll

Hardrecord_Flag		db	0	; Assembly edit mode if 0ffh
Device_Enabled		db	0ffh	; See xxxx_IOTYP   Bit set = enabled

SX_Type			db	0	; Offset byte in
AX_Type			db	0	;  tables for
PX_Type			db	0	;  tables for

EFX_Flag		db	1	; Flags for EFX menu

Effects_Address		db	1	; Effects bank address
emem_efxadr		db	6	; EMEM effects address

upstream_keynumber	db	1	; Upstream Key
dnstream_keynumber	db	2	; Downstream Key


Oddeven_Mask		db	1	; Use for interrupt 9 sync counter
JoggerIRQ		dw	8	; Irq mask
ShuttleSensitivity	db	10
JoggerSensitivity	db	50

Dir_Chos		db	1
INSTL_Chos		db	1	; Default to first INSTL question
INSTL_Choices		db	28 dup(1) ; Room for 28 menu selections

Macedit_Choice		db	1

Setcom_Chos		db	'A'	; Default to RECEIVE

Default_Mode		db	0	; Default list type address

Wild1			dw	Insert_key
Wild2			dw	Delete_key
Joykey1			dw	Pause_xcmd
Joykey2			dw	Rptgl_xcmd

System_Color_Frame	db	0
Edits_To_Look_Ahead	dw	10

; these two pools can be used to add storage and not require users
; to trash their .SIF files.
;; 8 Extra initialization byte pool
public GPI_Type, Audio_Effects_Address,VlanVideoPort,VlanAudioPort,VlanVideoPort2
GPI_Type		db	0
Audio_Effects_Address	db	1
VlanVideoPort		db	21
VlanAudioPort		db	23
VlanVideoPort2		db	22
VlanPreviewPort		db	24	
			db	0
			db	0

;; 8 Extra initialization word pool
dsk_trans		dw	FPS
ftb_trans		dw	FPS
			dw	0
			dw	0
			dw	0
			dw	0
			dw	0
			dw	0

	if DEBUGGER
public debug_pntr,debug_seg
debug_pntr		dw	0	; Default debug pointer
debug_seg		dw	0	; Segment for debug_pntr
	endif

;================================================================
; Communications parameters
public COM_EDLIO,COM_VLAN,COM_VIDEOSW,COM_AUDIOSW,COM_PRINTER,COM_XTERM,COM_SES1010,COM_PREVIEW

COM_VLAN	COMPORT	< 2, 03h, 03h, 'V-LAN' >
COM_VIDEOSW	COMPORT	< 0, 1bh, 03h, 'VIDEO SW' >
COM_AUDIOSW	COMPORT	< 1, 1bh, 03h, 'AUDIO SW' >
COM_PRINTER	COMPORT	< 8, 03h, 03h, 'PRINTER' >
COM_EDLIO	COMPORT	< 3, 03h, 03h, 'EDL I/O' >
COM_XTERM	COMPORT	< 2, 03h, 03h, 'XTERM' >
COM_SES1010	COMPORT	< 1, 03h, 0ch, 'SES1010' >
COM_PREVIEW	COMPORT	< 3, 03h, 0ch, 'PVW SW' >

;================================================================
		even

Exchbuf1 		equ	$

Mode_Flag		db	11001000b	; AAV

		even
Current_VTRS	EQU	$
Current_Source		db	1		; LSB of Current_VTRS word
Current_Machine		db	0		; MSB or Current_VTRS word

Current_VT_Cb		equ	$
Current_Reel_Adr	dw	0
Current_Reel_Scr	dw	0
Current_Mach_Scr	dw	0
Current_Inbuf		dw	0
Current_Outbuf		dw	0
Current_Duration	dw	0

Current_FRMbuf		dw	0		; These point to the
Current_TObuf		dw	0		;  IN POINT buffer
Current_BKGbuf		dw	0		;  of the appropriate
Current_FORbuf		dw	0		;  VTR for the EFFECT type.


Trans_Type		db	'C'
Trans_Code		dw	0
Trans_Length		dw	FPS
From_Machine		db	6
To_Machine		db	1
Key_Trans		dw	FPS

Split_Mode		db	0	; Split AV mode
Key_Mode		db	0	; Key in (1) or out (2) or none (0)
Keyfor_Src		db	5	; Key forground machine
Keybkgnd_Src		db	6	; Key background machine

Split_Delay		db	3 dup(0)	; Split edit delay

;Machine Register Storage
		even
Marks_Table	equ	$
R_Tc	VTRINOUTDUR <>
a_tc	VTRINOUTDUR <>
b_tc	VTRINOUTDUR <>
	if ALLOWED_VTRS GT 3
public c_tc
c_tc	VTRINOUTDUR <>
	endif
	if ALLOWED_VTRS GT 4
public d_tc
d_tc	VTRINOUTDUR <>
	endif
	if ALLOWED_VTRS GT 5
public e_tc
e_tc	VTRINOUTDUR <>
	endif
	if ALLOWED_VTRS GT 6
public f_tc
f_tc	VTRINOUTDUR <>
	endif
public aux_tc, blk_tc
aux_tc	VTRINOUTDUR <>
blk_tc	VTRINOUTDUR <>

	even
Exchbot		equ	$
Exchlen		equ	Exchbot - Exchbuf1
Mtbl_Start	equ	Marks_Table - Exchbuf1
Mtbl_Length	equ	Exchbot - Marks_Table - 1	; Used for MARKTABLE exchange

		align 16
Preroll			db	FPS * 5,0,0	;5 second
Postroll		db	FPS,0,0		;1 second
Recordpost		db	FPS/2,0,0	;10 frames
Time_Start		db	0,0,0		;
TimeLineRoll		db	FPS * 5,0,0	; 2 Second time line roll

; In order INSTAL MENU questions:
Otf_Adjust		db	0,0,0,' '	; Mark On-the-fly adjustment
VvvIN_Offset		db	0,0,0,'-'	; Preview IN offset
VvvOUT_Offset		db	0,0,0,'-'	; Preview OUT offset
SplitV_Offset		db	0,0,0,'-'
SplitA_Offset		db	0,0,0,'-'
Atrans_Offset		db	2,0,0,'-'	; Trigger delay for autotrans

VbvIN_Offset		db	0,0,0,'-'	; Trigger delay for VBV
VbvOUT_Offset		db	0,0,0,'-'	; Trigger delay for VBV
BvbIN_Offset		db	0,0,0,'-'	; Trigger delay for BVB
BvbOUT_Offset		db	0,0,0,'-'	; Trigger delay for BVB
Gtrans_Offset		db	2,0,0,'-'	; Trigger delay for GPI
Sync_Offset_In		db	20,0,0,'-'	;10 frames
Sync_Offset_Out		db	10,0,0,'-'	;2 frames
PMC_Offset		db	2,0,0,'-'	; PMC adjustments
RT_Offset		db	1,0,0,'+'	; Real Time adjustment

Last_Trim		db	3 dup(0)
Last_Duration		db	3 dup(0)

Tcgen_Start		db	3 dup(0)
Tcgen_Mode		db	NDF_CHAR

;================================================================
;	CONSTANT STORAGE AREA
Constants		db	3*16 dup(0)

;================================================================
; 	GPI REGISTERS
; Byte 1	= Sign
; Byte 2, 3 & 4 = trigger time offset from record in
; Word 5	= Type byte 'V' or 'G'
; Word 7, 8	= Command
;
Gpi0	GPIrec MAX_GPI_REGISTERS dup(<0>)
;Gpi0		db	GPI_length * MAX_GPI_REGISTERS dup(0)

;================================================================
;	SLAVE TABLE
Slave_Table	db	0ffh
		db	ALL_DEVICES dup(0)	; Master/Slave table

;================================================================
;	MULTIPLE TRIM TABLE
Trim_Table	db	0ffh
		db	ALL_DEVICES dup(0)	; Multiple trim table


Multrecord_Table db	0ffh
		db	ALL_DEVICES dup(0) ; Table of multiple record devices

;================================================================
Swap_Table	db	0ffh,0,0	; Swap these vtrs

;================================================================
;	PROGRAMMED MOTION TABLES
; FORMAT: 1 byte speed, 3 bytes offset
; Leave room for seven commands per machine
;	FORMAT:	1 BYTE VTR A=1, B=2, C=3, D=4
;		1 BYTE SPEED IN FRAMES/SECOND
;		1 BYTE SIGN (+ OR -) OF FOLLOWING OFFSET
;		3 BYTE TIME CODE OFFSET FROM Preroll
;;Progmotion_Tbl	db	MAX_SPEED_CHANGES dup(0ffh,0ffh,'+',0,0,0)

Progmotion_Tbl	VARSPEEDCHANGE	MAX_SPEED_CHANGES dup (<>)

Tags_Table	db	3 dup(0)	; a-vtr
		if ALLOWED_VTRS GT 2
		db	3 dup(0)	; b-vtr
		endif
		if ALLOWED_VTRS GT 3
		db	3 dup(0)	; c-vtr
		endif
		if ALLOWED_VTRS GT 4
		db	3 dup(0)	; d-vtr
		endif
		if ALLOWED_VTRS GT 5
		db	3 dup(0)	; e-vtr
		endif
		if ALLOWED_VTRS GT 6
		db	3 dup(0)	; f-vtr
		endif


;================================================================
; Macro storage
Macro_Buffers	equ	$
Macro_Ttl	db	line_length + 1 dup(0)
Macro0		db	10 * (macrolen + 2) dup(0)	; Macro #0 - 9
Macro_Ttls	db	10 * macrotlen dup(0)
Macro_Bottom	equ	$
Macro_Length	equ	Macro_Bottom - Macro_Buffers

;================================================================

Edl_Ext		db	'EDL',0

EDL_Subdir	db	pathname_length+1 dup(0) ; For EDL files
AUTOFILE_Subdir	db	pathname_length+1 dup(0) ; For AutoSave files
VME_Subdir	db	pathname_length+1 dup(0) ; For SFX files
TCM_Subdir	db	pathname_length+1 dup(0) ; For TCM files
TMP_Subdir	db	pathname_length+1 dup(0) ; For TMP file

Current_EDL	db	pathname_length+1 dup(0) ; Previous EDL filename
Current_EIF	db	pathname_length+1 dup(0) ; Previous Default filename
Current_TCM	db	pathname_length+1 dup(0) ; Previous Macro filename
Current_VME	db	pathname_length+1 dup(0) ; Previous Effect filename

Saveload_EDL	db	pathname_length+1 dup(0) ; Used for save and load

; Relay trigger information table
RELAYDEFAULTS	equ	RTYPE_pulse OR RTYPE_set OR 2
Relaytype_Tbl	RELAYstruc <'VLAN-T  ',0,0,0>
		RELAYstruc 48 dup(<'Untitled',0,RELAYDEFAULTS, 0>)

RampSpeedChange	RAMPSPEED <>

Dflts_Bottom	equ	$
Dflts_Length	equ	Dflts_Bottom - Dflts_Area
Dflts_Pad	db	1ah

_DATA	ends

	end

