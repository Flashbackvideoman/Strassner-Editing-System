; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner

;VMSTORS.ASM
; Storage module for VM.ASM and other related assembly files

.xlist
include vm.equ

;================================================================
_DATA	segment para public 'DATA'
	assume ds:_DATA
.xlist

public tc_format,hardware_delay,hardware_Flags,PSP_seg,msg_seg
public EDL_seg,screen_seg,video_seg,top_bin,bottom_bin
public available_bins,active_bin,split_bin,swap_bin,bin_table
public memory,VLAN_VER,sort_iters,sort_cevent,sort_reeladr
public block_start,block_end,starting_number,ending_number,where2_number
public lastplace,last_error,move_adr,temp_tc_buf,inout_adr
public current_event_adr,last_recalled,cimsg_pntr,cimsg_cursor,alb_pntr
public byte_store_1,old_inpoint,ev2ret2,last_assembled,last_command
public last_key,extras,edmsg,security_return,Initfile_Retadr
public matchingTC_event,matchingTC_fcm,MatchExtendFlag,reelrecallvtr,reelrecallmsgptr
public video_mode,sortwhat,mkdasm_Flag,find_type,cimsg_fcm
public cimsg_insert_mode,from_Flag,oldframeFlag,fromwitch_mach,which_type
public tobin_Flag,copy_Flag,cimsgadd_Flag,EVcmd_Flag,shiftstart_edit
public shiftend_edit,suspend_Flag,TMPwrite_Flag,reelsum_inprogress,seconds_count
public autotrim_Flag,decflg,evnt_insert_Flag,evnt_replace_Flag,clear_Flag
public ripple_Flag,shift_Flag,in_out_Flag,sign_Flag,last_trim_Flag
public trim_ci_Flag,fcmfmt_len,constant_Flag,fterr_flg,workspace_Flags
public device2set,last_fcm,port_IO_Flag,papertape_Flag,maxfiles_reached
public current_workspace,current_constant,inserr,mveidxstor,readline_length
public loadxfr_Flags,FileExists_Flag,xterm_pntr,temp_event,last_evnum
public events_iod,saveload_handle,cln_evnt_strt,cln_evnt_end,tobin_seg
public frombin_seg,fullscreen_Flag,diagnose_single,diagnostics_Flag,tracksngl_Flag
public EDLtracking_edit,syncbump_VTR,PreRead_immediate,PreRead_state,keyer_Flags
public SIO_vtrs,RollDelay_Flag,reelsum_typeFlag,reelsum_lines,ERROR_PROMPT
public ERROR_CURSOR,ERROR_OFFSET,ERROR_SEG,ERROR_FlagS,ERROR_MESSAGE
public ERROR_COMMAND,ERROR_ACTIVE,int1c_adr,jogint_adr,JoggerShiftKey
public JoggerModeChange,JoggerWheelMode,JoggerIteration,WheelIteration,ShuttleIteration
public JoggerActive,JogCmdAvailable,JoggerCommand,EDL_window_cursor,cursor
public videoram,port_addresses,VLAN_address,SX_Address,AX_Address,PX_Address
public Jogger_address,xterm_address,printer_address,readsend_address,active_IOTYP
public swvlan_IOTYP,last_preview_XPT,preview_mode,reference_Flag,Vlan_Emems
public last_mach_scr,last_machine,abort_Flag
public oldslave_Flags,oldgpi_Flags,oldpmc_Flags,oldspd_Flags
public oldramp_Flags,oldmultRec_Flags

public dflt_Flag,edit_trys,jstick_top_X,jstick_top_Y,last_stickx
public last_sticky,device_present,loc_count,loc_vtrcb,input_Flag
public joybuttons,gpi_oldsign,gpi_count,vtr_mult_type,edit_status
public editin_Flag,editout_Flag,pvwout_Flag,autotrans_Flag,assemble_Flag
public record_Flag,openend_Flag,current_device,current_node,edit_selected_vtr
public diag_test_number,diag_vtr_number,diag_loop_count,diag_error_count,lookahead_counter
public PointShootData,device_stat_tbl,diagsum_table,multsync_table,vtrs_in_edit_table
public vtr_searchto_table,oldslave_table,oldgpis,TL_sync_Flag_IN,TL_sync_Flag_OUT
public TL_rin_Flag,TL_rout_Flag,TLINE_entries,TLINE_pointer,tline_dpos
public tline_lines,tline_Flag,timeline_buffer
public calc_Flag,calcfunc,calcstor1,calcstor2
public time_count,time_total,sttime,entime,elaptm
public offset_buffer,clean_offset,cimsg_tc,addtc_buf,sortmatch_in
public sortmatch_out,matchingTC_buf,matchframe_diff,matchframe_fdur,matchframe_from
public bytstr1,bytstr2,bytstr3,bytstr4,disp_tcbuf
public dfbuf1,dfbuf2,edl_in,edl_out,edl_dur
public Rvtr_In,Rvtr_Out,Rvtr_Dur,rvtr_ripple,split_rout
public split_pout,find_df,find_nd,trim_store
public trans_time,tlstat_tcbuf,TCworkbuf_1,TCworkbuf_2
public rvtr_location,Delay_Timer,dirfiles
public dirdisplayed,dirpgtop,dirlines,dirchoice,dirchoice_adr
public dirtype,dirsub_adr,CMDLINE_OPTS,BuiltInMacro,macins_Flag
public macscrn_count,macrecord_Flag,mac2record2,mac2edit_num,maccrlf_Flag
public macptr,RunningCMD_Ptr,RunningCMD_cnt,temp_macro,record_macro
public SavedMemSize,menu_path,olm_path,home_path,clean_path
public cct_tail,paths,RunMacro_file,triggers,exchange_regs
public savemarks_buf,saved_marks,undo_buffer,find_buffer,RT_switches
public RT_vtr,RT_firstvtr,RT_bufptr,RT_buffer,RT_bufend
public RT_finalout,SX_descriptor,AX_descriptor,video_header,Vlan_Patterns
public INIfile_buf,EIFfile_buf,TCMfile_buf,SX_rcvbuf,SX_sndbuf
public vtr_sndbuf,vtr_rcvbuf,Ascii_Number,Ascii_Line,work_event
public temp_wrkspce,screen_buffer,ScreenLineBuf,temp_vidbuf,temp_tempbuf
public RunningCMD_buf,endofstors,memory_len,PX_descriptor

public Divdval,Dvend,Dvsor,Hdeptr,Odeptr,Count,tick_Count
public sync_count1,sync_count2,delay_count1,delay_count2
public synctime1,synctime2,wFrac,Hide1,Hide2,Calcstor3


.list
exchlen = size EXCHANGEBUFFER
mtbl_length = ALL_DEVICES * size VTRINOUTDUR
;================================================================

tc_format	db	0,0,0

; Hardware values
hardware_delay		db	16	; Speed in MHZ
hardware_Flags		dw	0	; Hardware Information
;.......

PSP_seg			dw	0	; PSP segment
msg_seg			dw	0	; OVR file segment
EDL_seg			dw	0	; EDL segment
screen_seg		dw	0	; Build screen segment
video_seg		dw	0	; System video segment

top_bin			db	0	; For split screen, bin# on top
bottom_bin		db	0	; Bottom bin, bin on bottom
available_bins		db	0	; # of available bins
active_bin		db	0	; Active primary bin#
split_bin		db	0	; Active bin for SPLIT SCREEN
swap_bin		db	0	; Active swap bin#

bin_table		dw	20 dup(0) ; Enough for 10 bins
			dw	0ffffh

;================================================================
memory		equ	$

		even
VLAN_VER		dw	0	; Vlan version level
sort_iters		dw	0	; Sort iterations
sort_cevent		dw	0
sort_reeladr		dw	0	; Used by SORT REELS

block_start		dw	0	; Used by
block_end		dw	0	;  DELETE EVENT(S)

starting_number		dw	0
ending_number		dw	0
where2_number		dw	0
lastplace		dw	0	; Previous position in EDL
last_error		dw	0
move_adr		dw	0
temp_tc_buf		dw	0
inout_adr		dw	0	; Pointer for in/out 24b buf adr
current_event_adr	dw	0
last_recalled		dw	0	; Last recalled event
cimsg_pntr		dw	0	; Used by line input
cimsg_cursor		dw	0	;  routine

alb_pntr		dw	0	; Pointer in ASCII line
byte_store_1		dw	0
old_inpoint		dw	0	; Used by trim_Links
ev2ret2			dw	0
last_assembled		dw	0	; Last assemble edit number
last_command		dw	0	; Address of last command lastkey
last_key		dw	0	; Last keypress
extras			dw	0	; # of lines following edit = GPISLV
edmsg			dw	0	; Record or other inf message address
security_return		dw	0
Initfile_Retadr		dw	0	; Used by _init_file
matchingTC_event	dw	0	; Used by MATCH

matchingTC_fcm		db	0	; Used by MATCH 10-10-1991 NHS

MatchExtendFlag		db	0	; Used by match for extended matches

reelrecallvtr		db	0	; Used by _MoveReel_EDLtoMtbl
reelrecallmsgptr	dw	0	; Used by _MoveReel_EDLtoMtbl

; Note: VIDEO_MODE is referenced as a BYTE
;	but is in the data area as a WORD for PUSHing and POPing easily
video_mode		dw	0	; Saved video mode

sortwhat		db	0

mkdasm_Flag		db	0	; If 0ffh, assemble marked edits
find_type		db	0	; Find type string search/tc search
cimsg_fcm		db	0
cimsg_insert_mode	db	0	; 0ffh = CIMSG insert ON
from_Flag		db	0	; From "active" Flag
oldframeFlag		db	0
fromwitch_mach		db	0
which_type		db	0
tobin_Flag		db	0	; Used by MOVE for bin 2 bin
copy_Flag		db	0	; Use by MOVE for copy

cimsgadd_Flag		db	0	; Used by ADD_EVENT for recalling w/ "."

EVcmd_Flag		db	0	; Used for event_commands screen updates

shiftstart_edit		dw	0	; Used by SHIFT/RIPPLE
shiftend_edit		dw	0	; routines for start/end events

suspend_Flag		db	0	; Used in macro executions
TMPwrite_Flag		db	0	; Signals TMP write OK. if 0ffh

reelsum_inprogress	db	0	; Reel summary in progress

seconds_count		db	0	; Used by time/date routine

autotrim_Flag		db	0	; Used by auto trim
decflg			db	0
evnt_insert_Flag	db	0
evnt_replace_Flag	db	0
clear_Flag		db	0	; Clear event or edit Flag
ripple_Flag		db	0
shift_Flag		db	0
in_out_Flag		db	0
sign_Flag		db	0	; Sign of time code entry
last_trim_Flag		db	0	; Has sign of last trim
trim_ci_Flag		db	0	; 0ffh if trim request
fcmfmt_len		db	0	; Length of EDL FCM: line if present
constant_Flag		db	0
fterr_flg		db	0	; Flag for bad FCM format
workspace_Flags		dw	0	; Computational Flags for INOUTDUR
device2set		db	0	; Device to set IN or OUT
last_fcm		db	0	; Last FCM written to file
port_IO_Flag		db	0	; 0ffh if reading from port

papertape_Flag		db	0

maxfiles_reached	db	0

current_workspace	db	0	; Used by EXCHANGE workspace
current_constant	db	0	; For Cn= display
inserr			db	0	; Used by STRING_INSERT
mveidxstor		db	0	; Used to save MOVE EVENT indexes
readline_length		db	0	; Length of last inputted line
loadxfr_Flags		db	0	; Signals TITLE Flags
FileExists_Flag		db	0	; Flag from file finds
xterm_pntr		dw	0	; port IO pointer for Ascii_Line
temp_event		dw	0
last_evnum		dw	0	; Last event number read from file
events_iod		dw	0	; Read/write events line counter
saveload_handle		dw	0	; Save and Load file handles

cln_evnt_strt		dw	0	; Used by SUPER CLEAN
cln_evnt_end		dw	0
tobin_seg		dw	0	; Used by MOVE
frombin_seg		dw	0	;  and COPY routines
fullscreen_Flag		db	0	; 0ffh if in full screen operations
diagnose_single		db	0	; 0ffh if diagnosing only 1 vtr
diagnostics_Flag	db	0	; 0ffh if diagnostics ON
tracksngl_Flag		db	0	; Tracking single
EDLtracking_edit	dw	0	; Last edl tracking edit number
syncbump_VTR		db	0	; Syncbump VTR

PreRead_immediate	db	0	; Immediate PreRead, on/off
PreRead_state		db	0	; PreRead on/off (0 = off)
keyer_Flags		db	0

SIO_vtrs		dw	0	; Current VTR and SOURCE saved
RollDelay_Flag		db	0	; Flag for delayed roll edit

reelsum_typeFlag	db	0	; Used for REEL SUMMARY
reelsum_lines		db	0

ERROR_PROMPT		dw	0	; Last prompt before error
ERROR_CURSOR		dw	0	; Last cursor before error

ERROR_OFFSET		dw	0	;
ERROR_SEG		dw	0	;
ERROR_FlagS		dw	0	;
ERROR_MESSAGE		dw	0
ERROR_COMMAND		dw	0
ERROR_ACTIVE		db	0	;

int1c_adr		dw	0,0
jogint_adr		dw	0,0
JoggerShiftKey		db	0
JoggerModeChange	db	0
JoggerWheelMode		db	0
JoggerIteration		db	0
WheelIteration		db	0
ShuttleIteration	db	0
JoggerActive		db	0

JogCmdAvailable	db	0	; Number of Jogger bytes read
JoggerCommand	dw	0	; Jogger bytes (2)

EDL_window_cursor	dw	0	; Where to put EDL

cursor			dw	0	; Current cursor position
videoram		dw	0	; Address of video DMA

; These eight words must be in this order.  They are associated with
; the bit assignments in active_IOTYP
		even
port_addresses	equ	$
VLAN_address		dw	0	; Vlan master node address
SX_Address		dw	0	; Video switcher address
AX_Address		dw	0	; Audio switcher address
Jogger_address		dw	0	; Spare address
xterm_address		dw	0	; Address of READ port
printer_address		dw	0	; Address of printer port
readsend_address	dw	0	; Address of WRITE port
PX_Address		dw	0	; Preview switcher address
;...

;================================================================
active_IOTYP		db	0	; Active switcher type. xxx_IOTYP
swvlan_IOTYP		db	0	; Active Video or active Audio IOTYP
last_preview_XPT	db	0	; Last crosspoint selected
preview_mode		db	0	;

reference_Flag		db	0	; non-zero if reference present

Vlan_Emems		dw	0	; Number of available vlan emems

oldslave_Flags		dw	0	; Holding area for ASSEMBLEs
oldgpi_Flags		dw	0
oldpmc_Flags		dw	0
oldspd_Flags		dw	0
oldramp_Flags		dw	0
oldmultRec_Flags	dw	0

last_mach_scr		dw	0	; Use only in machine change 4-05-1991
last_machine		db	0	; VTR return after EDL add or REC/PVW
					; Also use by diagnostics routine
abort_Flag		db	0	; Edit aborted if 0ffh
dflt_Flag		db	0	; Defaults present
edit_trys		db	0	; Countdown to total abort

jstick_top_X		dw	0	; Joystick center XY coordinates
jstick_top_Y		dw	0
last_stickx		db	0	; Last X coordinate of stick
last_sticky		db	0	; Last Y coordinate of stick

device_present		db	0	; See xxxx_IOTYP table in equates file

loc_count		db	0 	; Which machine to display location for
loc_vtrcb		dw	0	; VTRCB address for LOCATIONS routine

input_Flag		dw	0	; Set when requesting GPI trigger

joybuttons		db	0	; Last joystick button pressed
gpi_oldsign		db	0
gpi_count		db	0	; # of active GPI's <><> NOT USED
vtr_mult_type		db	0	; REC, PVW, RPLY
edit_status		db	0	; Current edit status
editin_Flag		db	0	; Signifies in point reached
editout_Flag		db	0	; Signifies out point reached
pvwout_Flag		db	0	; Signifys PVW_out already reached
autotrans_Flag		db	0	; Autotrans already pressed if 0ffh
assemble_Flag		db	0	; Assemble ON/OFF
record_Flag		db	0	; Recording status
openend_Flag		db	0	; Open end indicator
current_device		db	0	; Current device for status rqst
current_node		db	0	; Current node for VTR IO

edit_selected_vtr	db	0	; Used in GOTO while editing

diag_test_number	db	0
diag_vtr_number		db	0
diag_loop_count		dw	0
diag_error_count	dw	0

lookahead_counter	dw	0

public OkToAdjustTC_Flag
OkToAdjustTC_Flag	db	0

public MasterEditLineAdr
MasterEditLineAdr	dw	0	; Keeps track of last edit line read

; Install selection POINT AND SHOOT (PAS) menues
PointShootData	POSITIONQUERYDATA 1 dup(<>)

; Only one status byte needed for VLAN operation
	even
device_stat_tbl		db	MAX_DEVICES dup(0) ; status table for VTRs

diagsum_table		dw	MAX_MACHINES dup(0)

	even
multsync_table		db	MULT_DEVICES dup(0) ; Table of devices to sync w/record

;3-27-1991
vtrs_in_edit_table	db	MULT_DEVICES  dup(0); Table of VTRs involved in edit.

vtr_searchto_table	db	MAX_MACHINES * 3 dup(0) ; cue to locations

; Used for assemble edits to save the current slave table
oldslave_table		db	ALL_DEVICES + 1 dup(0)	; Master/Slave table
oldgpis			db	GPI_length * MAX_GPI_REGISTERS dup(0)

TL_sync_Flag_IN		db	0
TL_sync_Flag_OUT	db	0
TL_rin_Flag		db	0
TL_rout_Flag		db	0
TLINE_entries		db	0
TLINE_pointer		dw	0
tline_dpos		dw	0
tline_lines		db	0
tline_Flag		db	0

timeline_buffer		TIMELINEREC MAX_TIMELINES dup(<0>)

;
;------------------------------------------------------------------------
;

; Calculator storage
calc_Flag	db	0
calcfunc	db	0
calcstor1	db	3 dup(0)
calcstor2	db	3 dup(0)

time_count	db	3 dup(0)	; Used for STOPWATCH
time_total	db	3 dup(0)	; Total running time

sttime		db	3 dup(0)
entime		db	3 dup(0)
elaptm		db	3 dup(0)
offset_buffer	db	3 dup(0)
clean_offset	db	3 dup(0)	; Used by CLEAN_LAST
cimsg_tc	db	3 dup(0)
addtc_buf	db	3 dup(0)	; Used by two line events

; Keep these together, in this order.
sortmatch_in	db	3 dup(0)	; Used by SORT_MATCH routine
sortmatch_out	db	3 dup(0)	; Used by SORT_MATCH routine

matchingTC_buf	db	3 dup(0)	; Used by MATCH routine

matchframe_diff	db	3 dup(0)	; Used by SYNCTAG (Marks_Table.tcIN - R_in)
matchframe_fdur	db	3 dup(0)	;  duration of possible delayed efx
matchframe_from	db	3 dup(0)	; Matchframe for FROM VTR

bytstr1		db	3 dup(0)	; Storage
bytstr2		db	3 dup(0)	; For 24 bit numbers
bytstr3		db	3 dup(0)	; Used for nondrop->dropframe
bytstr4		db	3 dup(0)	; calculations

disp_tcbuf	db	3 dup(0)	; Used for FCM
dfbuf1		db	3 dup(0)	; Used for FCM
dfbuf2		db	3 dup(0)	; Used for FCM

edl_in		db	3 dup(0)	; Used by ripple
edl_out		db	3 dup(0)	;
edl_dur		db	3 dup(0)	;
Rvtr_In		db	3 dup(0)	; Used for VTR control
Rvtr_Out	db	3 dup(0)	;  and for Ripple
Rvtr_Dur	db	3 dup(0)	; (this one ripple only)
rvtr_ripple	db	3 dup(0)	; Ripple buffer for add events

split_rout	db	3 dup(0)	; Split edit r point save
split_pout	db	3 dup(0)	; Split edit p point save

find_df		db	3 dup(0)	; Find value for DROP FRAME
find_nd		db	3 dup(0)	; Find value for NON DROP FRAME

trim_store	db	3 dup(0)	; Used for TRIM operations
		even
trans_time	db	3 dup(0)	; When to start transition

tlstat_tcbuf	db	3 dup(0)	; Used by TLstat

TCworkbuf_1	db	3 dup(0)	; Various
TCworkbuf_2	db	3 dup(0)	; Various

rvtr_location	db	3 dup(0)	; Used by LOCATE RECORD

Delay_Timer	db	3 dup(0)

;----------------------------
;	 B U F F E R S
;----------------------------

;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
;... VALUES USED BY ROUTINS IN THE VMUTILS.LIB LIBRARY
Divdval		dw	0	; Data for 24 bit computations
Dvend		dw	0	; Address of dividend
Dvsor		dw	0	; Address of divisor
Hdeptr		dw	0	; Address of current high dividend array
Odeptr		dw	0	; Address of other hight dividend array
Count		dw	0	; Temporary for loop counter

tick_Count	dd	0
sync_count1	dd	0
sync_count2	dd	0
delay_count1	dd	0
delay_count2	dd	0
synctime1	dd	0
synctime2	dd	0
wFrac		dw	0

Hide1		db	3 dup(0); High dividend buffer 1
Hide2		db	3 dup(0); High dividend buffer 2
Calcstor3	db	3 dup(0)
;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

;...............................................................
dirfiles	db	0		; # of directory entries
dirdisplayed	db	0		; # of file to display
dirpgtop	db	0		; # of file on top of screen
dirlines	db	0		; # of files on screen
dirchoice	dw	5 dup(0)	; LSB =# of last filename selected
					; MSB =# of directory entries
dirchoice_adr	dw	0
dirtype		db	0
dirsub_adr	dw	0

CMDLINE_OPTS	DW	0		; Used in init phase

BuiltInMacro	db	0		; Used to avoid KEYWAIT functions

macins_Flag	db	0		; 0ffh if INSERTING chars in macro
macscrn_count	db	0
macrecord_Flag	db	0
mac2record2	db	0
mac2edit_num	db	0
maccrlf_Flag	db	0
macptr		dw	0
RunningCMD_Ptr	dw	0		; Pointer to macro buffer
RunningCMD_cnt	dw	0		; # of characters in buffer
temp_macro	db	(macrolen + 2) dup(0) ; Insert commands in a running macro
record_macro	db	(macrolen + 2) dup(0) ; Insert commands in a running macro

SavedMemSize	dw	0,0		; Used by TMP_save

	if ALLOW_VLAN3
; Old style buffers
public VLAN_SWBUF_PTR,VLAN_SWBUF_SIZ,VLAN_SWBUF_CNT
VLAN_SWBUF_PTR	dw	0
VLAN_SWBUF_SIZ	dw	0
VLAN_SWBUF_CNT	db	0
	endif

menu_path	db	pathname_length + 1 dup(0) ; Where to find menu.com
olm_path	db	pathname_length + 1 dup(0) ; Where to find OLM
home_path	db	pathname_length + 1 dup(0) ; Where we came from
clean_path	db	pathname_length + 1 dup(0) ; Where to find CLEAN.bat
cct_tail	db	pathname_length + 1 dup(0)
paths		db	128 dup(0)		; Environment PATH

RunMacro_file	db	pathname_length + 1 dup(0)

triggers	db	(16 * 3) dup(0)		; Trigger table

		even
exchange_regs	db 	exchlen dup(0)
		even
savemarks_buf	db	10 * exchlen dup(0)		; Saved mark tables
		even
saved_marks	db	mtbl_length dup(0)
undo_buffer	db	exchlen dup(0)		; Undo buffer for marktable

find_buffer	db	line_length + 2 dup(0) ;Len, string, null

RT_switches	db	0
RT_vtr		db	0
RT_firstvtr	db	0
		even
RT_bufptr	dw	0
RT_buffer cutbuf realtimebuffers dup(<0>)
RT_bufend	equ	$ - 4
RT_finalout	db	3 dup(0)		; Final outpoint of edit

SX_descriptor	dw	SXcb_length dup(0)	; Video switcher descriptor
AX_descriptor	dw	SXcb_length dup(0)	; Audio switcher descriptor
PX_descriptor	dw	SXcb_length dup(0)	; Preview switcher descriptor

video_header	db	128 dup(0)

Vlan_Patterns	db	128 dup(0)	; VLAN swtchr's wipe pattern tble
;;VLAN_SWCONFIG	db	128 dup(0)	; VLAN swtchr's config parameters

INIfile_buf	equ	$			; Used for command line options
EIFfile_buf	equ	$ + 40h			; Used for command line options
TCMfile_buf	equ	$ + 80h			; Used for command line options
SX_rcvbuf	db	sx_buf_len dup(0)
SX_sndbuf	db	sx_buf_len dup(0)

vtr_sndbuf	db	vtr_buf_len dup(0)
vtr_rcvbuf	db	vtr_buf_len dup(0)

Ascii_Number	db	8 dup(0)
		align 16
Ascii_Line	db	128 dup(0)
work_event	db	128 dup(0)
temp_wrkspce	db	128 dup(0)
screen_buffer	db	128 dup(0)

ScreenLineBuf	db	160 dup(0)
temp_vidbuf	db	160 dup(?)
temp_tempbuf	db	128 dup(?)

RunningCMD_buf	db	(macrolen + 2) * 10 dup(0)

	if ALLOW_VLAN3
public VLAN_SWBUF
VLAN_SWBUF	VLANSW 32 dup(<>)
	endif

endofstors	equ	$
memory_len	equ	(endofstors - memory) / 2

_DATA	ends

	end
