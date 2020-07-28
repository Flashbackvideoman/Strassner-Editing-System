; Last revised: 2-22-1995, 11:12:28   (C)1989-1995 Norman H. Strassner

; SESMSG.ASM
;Title and message file for VM.ASM/COM
; April, 1992	Changed name to STRASSNER EDITING SYSTEM
; August 23, 1989	Now generates an equates file for use with VMHDR.ASM
; May    31, 1989	Changed name to the CMAX EDITING SYSTEM
; January 9, 1989	Converted CP/M assmebler source code into 8086 assembler
; July   21, 1988	Converted file to VIDEOMANager

include vmver.equ


;;cseg	segment	para public 'CODE'
;;	assume cs:cseg,ds:cseg,es:cseg,ss:cseg
_DATA	segment	para public 'DATA'

Public  checksum_dum1, checksum_ovr, checksum_dum2, whyohwhy, hdr_ovr
Public  title_ovr, screen_ovr, illegal_ovr, descript_ovr, NoOLM_ovr, nohelp_ovr
Public  dirhdr_ovr, eifhdr_ovr, tcmhdr_ovr, vmehdr_ovr, findwho_ovr, nokey_ovr
Public  tryagain_ovr, newdflts_ovr, macro_ovr, macromenu_ovr, macromsg_ovr
Public  assignment_ovr, asgnttl_ovr, vidcontrol_ovr
Public  audcontrol_ovr, gpibase_ovr, assign_ovr, comport_ovr
Public  comstats_ovr, setports_ovr, prior_ovr, gpiopts_ovr, otf_adjust_ovr
Public  slop_factor_ovr, retry_count_ovr, menu_ovr, hardrecord_ovr
Public  screengrid_ovr, pvwcontrol_ovr
Public  lastkey_ovr, disptype_ovr, cuetrack_ovr, audcuestat_ovr
Public  modetype_ovr, beltogl_ovr, errbell_ovr, timedisplay_ovr
Public  durfcm_ovr, brate_ovr, edltrack_ovr, editsync_ovr
Public  edsyncmsg_ovr, prepare4dos_ovr, retfromdos_ovr, shellwarn_ovr
Public  xterm_ovr, badftyp_ovr, badffcm_ovr, fext_ovr, fcmrqst_ovr, EnableVlan_ovr
Public  wildkeys_ovr, joykeys_ovr, wildline_ovr, lockout_ovr, vlanversion_ovr
Public  usejstick_ovr, jstickx_ovr, jsticky_ovr, jstickaxis_ovr, jsticklr_ovr
Public  setjstick_ovr, EMEMrdsw_ovr, EMEMwrtsw_ovr, MEMsave_ovr, wild_ovr
Public  joykey_ovr, rptoggle_ovr, pauseplay_ovr
Public  trigadjust_ovr, autodisable_ovr, slave_store_ovr
Public  gpi_store_ovr, SPD_store_ovr, PMC_store_ovr, asmmode_ovr, autoplay_ovr
Public  exitmenu_ovr, exitshort_ovr, matchfnd_ovr, diagselvtr_ovr, timeline_ovr
Public  tlprompt_ovr, evcmdst_ovr, evcmdsb_ovr, TCver_ovr, VTRtest_ovr
Public  VTRnames_ovr, ememopts_ovr, stathdr_ovr, autofile_ovr, diag_ovr
Public  MacEdI_ovr, MacEdA_ovr, MacEd_ovr, calc1_ovr, function_ovr, working_ovr
Public  searching_ovr, goto_ovr, fastswitch_ovr, yn_ovr, keyhelp_ovr
Public  findwhat_ovr, findtc_ovr, findtext_ovr, relsrch_ovr, relchg_ovr
Public  savebuf_ovr, restbuf_ovr, clrmrks_ovr, setmrks_ovr, INSTLcmd_ovr
Public  INSTLtgl_ovr, INSTLplus_ovr, INSTLmac_ovr, commandqry_ovr
Public  onetwoboth_ovr, binlist_ovr, next_ovr, used_ovr, freemem_ovr, bin_ovr
Public  workspace_ovr, preroll_rqst, postroll_rqst, recpost_rqst, tlineroll_rqst
Public  timestart_rqst, in_rqst, out_rqst, dur_rqst, const_rqst, location_rqst
Public  shiftinput_rqst, shiftplay_rqst, shiftrec_rqst
Public  setgpi_rqst, spdchange_rqst, DelayRoll_ovr, deleting_ovr, sorting_ovr
Public  write_ovr, read_ovr, punching_ovr, pointer_ovr, otf_qry, vvvIN_qry
Public  vvvOUT_qry, splitV_qry, splitA_qry, vbvIN_qry, vbvOUT_qry, bvbIN_qry
Public  bvbOUT_qry, atrans_qry, gtrans_qry,syncOUT_qry,syncIN_qry, badscript_ovr
Public  selasgn_ovr, frommsg_ovr, tomsg_ovr, autoasminf_ovr, commentmsg_ovr
Public  dirmore_ovr, trigstate_ovr, tglmsg_ovr, relaymsg_ovr, pulsetime_ovr
Public  rtype_ovr, inactive_ovr, onmsg_ovr, offmsg_ovr, set_timer_ovr
Public  stop_timer_ovr, colorframe_ovr, overwrite_ovr, resettt_ovr
Public  movevnts_ovr, copyevnts_ovr, movcpyrenum_ovr, starting_ovr, ending_ovr
Public  tobin_ovr, toend_ovr, mkdasm_ovr, withthis_ovr, matched_ovr, delete_qry
Public  delete_ovr, delmrkd_ovr, ripple_ovr, replace_ovr, ins_ovr, shift_ovr
Public  shift_frmto_ovr, sort_ovr, sortln_ovr, sortreels_ovr, Error_Table_ovr
Public  sound_ovr, wn, tn, hn, qn, en, sn, music_ovr, bignumbers_ovr
Public  littlenumbers_ovr, keys_ovr, demo_ovr
public	break_ovr,event_renum_ovr,clear_list_ovr, DelEdRoll_ovr
public	initializing_ovr,PMC_qry, lstfile_ovr,clrmacs_ovr,punchfile_ovr
Public	serial_ovr, REC_store_ovr, recripl_store_ovr, Node_Stat_ovr
Public  bump_msg,redit_ovr,redl_ovr,rdy_ovr,rdrfile_ovr,rdrrdy_ovr
public	realtime_ovr,realtimeok_ovr,RT_qry,recording_ovr,portbreak_ovr
public dirofs_ovr, dirofn_ovr, maxfiles_ovr,extmenu_ovr,ejectpage_ovr
public pausefortime_ovr, useJogger_ovr, ExactSpeed_ovr
public jogsense_ovr, joggerirq_ovr, shuttlesense_ovr
public lookahead_ovr, lookcount_ovr, selectedlf_ovr, recheck_ovr
public AutoConfig_ovr, SavedReceived_ovr, preread_ovr
public audefxadr_ovr,sortdirs_ovr
public INIjog_ovr, INIvln_ovr, INIser_ovr, INIxpt_ovr, INIgpi_ovr

;================================================================

checksum_dum1	db	'N'+'1','H'+'2','S'+'3'
checksum_ovr	dw	0
checksum_dum2	db	'C'+'3','M'+'2','A'+'1'
whyohwhy	db	'#^%&+^@('

hdr_ovr:
;;	if BETA_RELEASE
;;	db 'SES-PRO ',V1,'.',V2,V3,rt,'  Beta Test',0
;;	endif

	if DEMO_RELEASE
		db 'SES-PRO + ',V1,'.',V2,V3,rt,' Demonstrator',0
	endif

	if (NOT DEMO_RELEASE)
	db 'SES'

	if Allowed_VTRs EQ 7
	db '-PRO'
	endif

	db ' +'
	db ' Ver. ',v1,'.',v2,v3,rt

		if Allowed_VTRs LT 7
			if CUTS_ONLY
			db	'  Single Source'
			else
			db	'  Multiple Source'
			endif
		endif

	DB	0
	ENDIF

title_ovr:
; db cr,lf
; db 'ษอออออออออออออออออออออออออออออออออออออออออออออป',cr,lf
; db 'บ  Professional Videotape Editing Controller  บ',cr,lf
; db 'บ       From Strassner Editing Systems        บ',cr,lf
; db 'บ       A Division of Videomedia, Inc.        บ',cr,lf
; db 'บ      (C)1988-1996, Norman H. Strassner      บ',cr,lf
; db 'ศอออออออออออออออออออออออออออออออออออออออออออออผ'
; db 0

public title1_ovr,title2_ovr,title3_ovr,title4_ovr,title5_ovr,title6_ovr,title7_ovr
title1_ovr db 'ษอออออออออออออออออออออออออออออออออออออออออออออป  ',0
title2_ovr db 'บ  Professional Videotape Editing Controller  บ ฐ',0
title3_ovr db 'บ       From Strassner Editing Systems        บ ฐ',0
title4_ovr db 'บ       A Division of Videomedia, Inc.        บ ฐ',0
title5_ovr db 'บ      (C)1988-1996, Norman H. Strassner      บ ฐ',0
title6_ovr db 'ศอออออออออออออออออออออออออออออออออออออออออออออผ ฐ',0
title7_ovr db ' ฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐฐ',0

; db cr,lf
; db 'ษอออออออออออออออออออออออออออออออออออออออออออออป',cr,lf
; db 'บ  Professional Videotape Editing Controller  บ',cr,lf
; db 'บ       From Strassner Editing Systems        บ',cr,lf
; db 'บ      (C)1988-1996, Norman H. Strassner      บ',cr,lf
; db 'บ            All rights reserved              บ',cr,lf
; db 'ศอออออออออออออออออออออออออออออออออออออออออออออผ'
; db 0

screen_ovr:
 db cr,lf,lf
if Allowed_VTRs LT 7
 db lf
endif
 db '            ณ',cr,lf
 db '            ฦอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ'
if Allowed_VTRs GT 6
 db '            ฐ',cr,lf
endif
 db '            ฐ',cr,lf
 db '            ฐ',cr,lf
 db '            ฐ',cr,lf
 db '            ฐ',cr,lf
 db '            ฐ',cr,lf
 db '            ฐ',cr,lf
 db '            ฐ                                               ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ'
 db '            ฐ                                               ณ',cr,lf
 db '            ณ                                               ณ',cr,lf
 db 'ออออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออฯอออออออออออออออออออ'
 db 0


illegal_ovr:
	db	cr,lf,lf,lf,lf
	db	'Incorrect V-LAN initialization response.',cr,lf
	db	cr,lf
	db	'Possible reasons:',cr,lf
	db	'- Using wrong or corrupted V-LAN firmware',cr,lf
	db	'- Loose cables or connectors',cr,lf
	db	'- Serial port parameters set incorrectly',cr,lf
	db	'- Computer hardware fault',cr,lf
	db	cr,lf
	db	'Try re-enabling the VLAN Network (INSTAL #24).',cr,lf
	db	'If error persists contact your SES representative.',cr,lf
	db	cr,lf
	db	'Press any key to continue...',0


initializing_ovr	db	'Initializing...',0

descript_ovr:
	db	'Reel       In          Out      Duration   Status   Location',0

NoOLM_ovr:
 db '        This software cannot find the necessary On-Line Manuals program.',cr,lf
 db cr,lf
 db '   On-Line Manuals (OLM) is available as an option to SES Editing Software.',cr,lf
 db cr,lf
 db 'OLM software will give you complete access to SES documentation and important',cr,lf
 db '   facts about your computer. Additionally, OLM software helps convert other',cr,lf
 db '             computer files for use as rapid access, on-line help.',cr,lf
 db cr,lf
 db '   For ordering information, contact your SES dealer or call (818)-508-6966.'
 db 0



nohelp_ovr:
	db 7,cr,lf,lf,lf
	db '        Selected key has no currently assigned function',0

dirofs_ovr	db '     Sorted Directory of ',0
dirofn_ovr	db '     Unsorted Directory of ',0
maxfiles_ovr	db '     WARNING! TOO MANY ',0
dirhdr_ovr	db 'EDIT DECISION LISTS On ',0
eifhdr_ovr	db 'PROGRAM CONFIGURATION FILES on ',0
tcmhdr_ovr	db 'KEYBOARD MACRO FILES on ',0
vmehdr_ovr	db 'VIDEO MEMORY (EMEM) FILES on ',0

findwho_ovr:
	db '<1> EDL files, <2> Default files, <3> Macro files, '
	db '<4> EFX files <5> All files',0

nokey_ovr:
	db	cr,lf,'*** Security key not found or printer not turned on ***',cr,lf
	db	'Program cannot be run if security key is not properly installed.'
	db	cr,lf,0

tryagain_ovr:
	db	cr,lf,lf,lf
	db	'The SECURITY KEY is no longer present or printer has been turned off!',cr,lf,lf
	db	'Please correct and press [ENTER] to continue.',cr,lf
	db	'Press [ESC] to abort SES and exit back to DOS.',cr,lf,0

AutoConfig_ovr:
	db	'Searching for the V-LAN Universal Control Network...',0

newdflts_ovr:
	db 'Creating DEFAULTS file',0

macro_ovr:
	db '                                '
	db 'Macro  Registers'
	db '                                '
	db 0


macromenu_ovr:
	db	'[XMACRO], <L>oad, <S>ave, <C>lear, <R>ecord or program '
macromsg_ovr:
	db	'Macro#',0


ExactSpeed_ovr:
	db	'Variable speed play [+][-]frames/second: ',0

;================================================================
assignment_ovr:
	db	'VTR Control Ports, Switcher Crosspoints and Peripheral Assignment Menu',0

asgnttl_ovr:
 db 'Device    Port Video Audio Offset   ID              Peripherals',cr,lf,0

vidcontrol_ovr	db	'VIDEO Switcher.........: ',0
audcontrol_ovr	db	'AUDIO Switcher.........: ',0
pvwcontrol_ovr	db	'PREVIEW Switcher.......: ',0
audcuestat_ovr	db	'Audio Cue Track Enabled: ',0
gpibase_ovr	db	'GPI Relay base port....: ',0

assign_ovr:
	db	' REC-VTR',cr,lf
	db	' A-VTR',cr,lf
	if Allowed_VTRs GT 2
	db	' B-VTR',cr,lf
	endif
	if Allowed_VTRs GT 3
	db	' C-VTR',cr,lf
	endif
	if Allowed_VTRs GT 4
	db	' D-VTR',cr,lf
	endif
	if Allowed_VTRs GT 5
	db	' E-VTR',cr,lf
	endif
	if Allowed_VTRs GT 6
	db	' F-VTR',cr,lf
	endif
	db	' AUX',cr,lf
	db	' BLK',0

comport_ovr:
 DB 'A=VTR NETWORK,  B=VIDEO XPTS,  C=AUDIO XPTS,  D=PRINTER,  E=EDL I/O,  F=XTERM   '
	 db 'G=SES-1010',cr,lf
 db 'Currently configuring for: ',0

comstats_ovr:
	db '1 - COM: Port..:',0
	db '2 - Baud Rate..:',0
	db '3 - Parity.....:',0
	db '4 - Stop Bits..:',0
	db '5 - Char Size..:',0

setports_ovr:
	db 'Select peripheral <A> - <G>, alter its settings with keys <1> - <5>',0

Node_Stat_ovr:
	db 'Port  Device      Type',0

;================================================================
prior_ovr	db	'Recall OUT POINT for: '
		db	'<R>=Record only, <S>=Source only, or <B>=Both: ',0

;gpiopts_ovr	db	17,' 97 Disables all GPIs, 98 Enables all GPIs, 99 Clears all GPIs ',16,0
gpiopts_ovr	db	17,' 96 Sort/Pack, 97 Disable all, 98 Enable all, 99 Clear all',16,0

otf_adjust_ovr	db	'Trim on-the-fly out +: ',0

slop_factor_ovr	db	'Frame accuracy window, ',0

retry_count_ovr	db	'# of aborted edit retries: ',0
menu_ovr	db	'[DOS] runs MENU',0
hardrecord_ovr	db	'Enable ASSEMBLE EDIT mode ',0

freememory_ovr	db	' available EDL bins.',0
ejectpage_ovr	db	'Eject page before printing',0

; SCREEN/SOUND DEFAULTS MENU
screengrid_ovr	db	'Workspace line grids',0
lastkey_ovr	db	'Last command display',0
recheck_ovr	db	'Save/Load question recheck',0
disptype_ovr	db	'EDL window = EDL format',0
modetype_ovr	db	'AV mode = EDL mode format',0
beltogl_ovr	db	'Prompting bell',0
errbell_ovr	db	'Beep on errors',0
timedisplay_ovr	db	'Display time and date',0
durfcm_ovr	db	'Display all VTR durations DF',0
brate_ovr	db	'Error display blink, 1-9 ',0
edltrack_ovr	db	'EDLtrak delay, in ',171,' seconds ',0
sortdirs_ovr	db	'Sorted EDL Directories',0

editsync_ovr	db	'Edit SYNC> 1=Rec VTR, 2=Ampex 1"/External CF, 3=Source: ',0

edsyncmsg_ovr:
 db cr,lf
 db '   Select:',cr,lf
 db '   <1> Time base corrected source VTRs',cr,lf
 db '   <2> External color frame reference or AMPEX 1" Record VTR',cr,lf
 db '   <3> No source VTR time base correction',cr,lf,0


;================================================================
prepare4dos_ovr:
	db	'Saving editor memory...',0
retfromdos_ovr:
	db	'Restoring editor memory...',0
shellwarn_ovr:
	db cr,lf
	db '  Entering DOS command level.',cr,lf,lf
	db '  To return to SES-PRO, type "EXIT" (no quotes).',0

xterm_ovr:
	db '         XTERM Communications active.  '
	db '<ESC> returns to editor                 ',0

portbreak_ovr:
	db '*BREAK*',cr,lf,0

badftyp_ovr:
	db	'** EDL format cannot be detected by reading this EDL ** ',0
selectedlf_ovr:
	db	'Select EDL format:',0

badffcm_ovr:
	IF NTSC
	db	cr,lf,lf,7
	db	'     Drop/Non-Drop list type cannot be detected '
	db	'from the EDL.',cr,lf
	db	cr,lf,'       Please select the correct type.'
	db	0
	ENDIF

fext_ovr:
	db	'Default EDL extension: ',0

fcmrqst_ovr:
	IF NTSC
	db	'Off-Line Record FCM: <D>=Drop frame, <N>=Non-Drop frame: ',0
	ENDIF

public syscolorframe_ovr
syscolorframe_ovr:
	db	'System (Record VTR) color frame ',0

colorframe_ovr:
	db	'Color framing for ',0

EnableVlan_ovr:
	db	'Enable VLAN control ',0

wildkeys_ovr:
	db	'Next keystroke defines WILD KEY #',0

joykeys_ovr:
	db	'Next keystroke defines JOYSTICK KEY #',0

wildline_ovr:
;;	db	'Reality is only for those who lack imagination.',0
	db	'Illigitimi non carborundum est.',0
lockout_ovr:
	if DEMO_RELEASE
	db	'That feature has been intentionally LOCKED-OUT for '
	db	'this DEMO software release.',0
	ELSE
	db	'             '
	db	'This command is not available in your version of SES',0
	ENDIF

vlanversion_ovr:
	db	' VLAN Software Revision Level: ',0

usejstick_ovr:
	db	'Enable Joystick',0

useJogger_ovr:
	db	'Enable Serial Jogger',0
shuttlesense_ovr:
	db	'Shuttle Sensitivity',0
jogsense_ovr:
	db	'Jog Sensitivity',0
joggerirq_ovr:
	db	'Jogger IRQ Interupt',0

jstickx_ovr db 'JOYSTICK X-axis (',26,27,') ..............................................:',0
jsticky_ovr db 'JOYSTICK Y-axis (',24,25,') ..............................................:',0
jstickaxis_ovr db '-axis center value should be set to (approximately)................:',0
jsticklr_ovr:
	db	'     JOYSTICK:     Move JOYSTICK to lower right position and press [ENTER]',0

setjstick_ovr:
 db 'Release controls back to their normal positions.  Use trim adjustments on your',cr,lf
 db 'Joystick to approximate these values:    ([ENTER] when done)',0


EMEMrdsw_ovr	db 'Learn current switcher setup to an EMEM register #',0
EMEMwrtsw_ovr	db 'Setup the switcher from an EMEM register #',0
MEMsave_ovr 	db 'Save the SES EFX memory buffer to a disk file',0
wild_ovr	db 'Change definition for WILD KEY #',0
joykey_ovr	db 'Change definition for JOYSTICK Option Button #',0

rptoggle_ovr	db 'Enable RECORD/SOURCE toggle for ENTER key ',0
pauseplay_ovr	db 'Enable PAUSE/PLAY key (NO = PAUSE only) ',0

	if DEBUGGER
public debugkeys_ovr, dbgadr_ovr, dbgbyt_ovr
debugkeys_ovr:
	db	'F1/2 ๑1 F3/4 ๑16 F5/6 ๑256 F7/8 ๑4096 '
	db	'F9=Mod F10=Adr Home=Prv End=Nxt PageUp/Dn',0
dbgadr_ovr	db	'Display address [CS][DS][ES][SS]:xxxx  Defaultf=ES: (EDL)>',0
dbgbyt_ovr	db	'Modifing memory, advance pointer: ',0
	endif

trigadjust_ovr:
	 db '                Reaction time Adjustments and Trigger Advances                 ',0



;----------------------------------------------------------------

autodisable_ovr	db	'Auto-disable on RECORD ',0
slave_store_ovr	db	'Store Master/Slaves ',0
recripl_store_ovr db	'RECORD ripple updates SLAVES',0
gpi_store_ovr	db	'Store GPI ',0
PMC_store_ovr	db	'Store PMC ',0
SPD_store_ovr	db	'Store SPD ',0
REC_store_ovr	db	'Store Multiple Record VTRs ',0

asmmode_ovr	db	'Assembly mode "A" or "B" ',0
lookahead_ovr	db	'Enable VTR Look Ahead Cueing',0
lookcount_ovr	db	'Look Ahead Edit Count ',0

autoplay_ovr:
 db cr,lf
 db '        Enter the duration that each newly loaded video tape will play',cr,lf
 db '        while determining location time code.',cr,lf,lf
 db '        To defeat the AutoPlay Timer, use the CLEAR key.',0

exitmenu_ovr	db	16,'-- Exit This Menu --',17,0

exitshort_ovr	db	16,' Exit Menu ',17,0

matchfnd_ovr	db	'Matchframe stored to Constant 0 ',0

public mtchNoReel_ovr
mtchNoReel_ovr	db	'Reel not present. Use [ALT - MATCH] (extended match)',0

diagselvtr_ovr	db	'Select VTR: ',0

pausefortime_ovr db	'Pause for time',0

;================================================================

timeline_ovr:
 DB 'ออออออออออออออออออออออออออออออออ EVENT TIMELINE ออออออออออออออออออออออออออออออออ'
 db 0

tlprompt_ovr:
 db 'ออ Use YES/NO keys or UP/DOWN arrows to move TIMELINE display, [T] to preview ออ',0

;================================================================
; EDL Repair
evcmdst_ovr:
 db 'อออออออออออออออออออออออออออออออออ EDL FAST-FIX อออออออออออออออออออออออออออออออออ'
 db '   Use these commands with caution.  UNDO will restore EDL to one level only.   '
 db 0
evcmdsb_ovr:
 db ' <+1> Change A/V Edit Mode  <+4> Change Reel Name      <+7> Detach Split Edits  '
 db ' <+2> Change Source FCM     <+5> -                     <+8> Attach Effect Lines '
 db ' <+3> Change event number   <+6> -                     <+9> -                   '
 db 0


TCver_ovr:
 db '                    Time Code Verification -- % of time code found valid:',cr,lf
 db 'ฺฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ'
 db 'ณ  ณ       Forward Speeds        ณ      Reverse Speeds   ณ                     ณ'
 db 'รฤฤลฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤลฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤยฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด'
 db 'ณVTณPlay ณSlow ณMed. ณFast ณShttlณSlow ณMed. ณFast ณShttlณ                     ณ'
 db 'ภฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู'
 db 0

VTRtest_ovr:
;db 'VTR control --  Delays and cue-to-preroll time:',cr,lf
;db 'ฺฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ'
;db 'ณ  VTR  ณ  From STILL ณ  From PLAY  ณ  From Still ณ From FSTFWD ณ  PREROLL     ณ'
;db 'ณ       ณ  to PLAY    ณ  to STILL   ณ  to FASTFWD ณ to STILL    ณ  CUE TIME    ณ'
;db 'ภฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤู'
 db 0

VTRnames_ovr:
	db ' R',cr,lf
	db ' A',cr,lf
	if Allowed_VTRs GT 2
	db ' B'
	endif
	db cr,lf
	if Allowed_VTRs GT 3
	db ' C'
	endif
	db cr,lf
	if Allowed_VTRs GT 4
	db ' D'
	endif
	db cr,lf
	if Allowed_VTRs GT 5
	db ' E'
	endif
	db cr,lf
	if Allowed_VTRs GT 6
	db ' F'
	endif
	db cr,lf
	db 0


;================================================================
ememopts_ovr:
	if Allowed_VTRs EQ 7
B = 255
N = 254
 db 'ออออออออ Transition Control อออออออออัอออออออออออออออออออัอออ E-MEM Control ออออ'
 db B,'ThisEvnt',N,' AutoTransณ',B,'ShftKEY ',N,' Key Enbl ณ',B,'PgUp/Dn ',N,' Fader Arm ณ',B,'Num +/-',N,'ACTIVE MODE    '
 db B,'DISS    ',N,' Dissolve ณ',B,'ShftDISS',N,' BkgndEnblณ',B,'Home/End',N,' Softness  ณ',B,'VIDEO  ',N,'ACTIVE BUS     '
 db B,'WIPE    ',N,' Wipe     ณ',B,'ShftWIPE',N,' Wipe #   ณ',B,'<-Var-> ',N,' Border    ณ',B,'"T"    ',N,'PreviewTimeLine'
 db B,'CUT     ',N,' TAKE     ณ',B,'ShftCUT ',N,' Key&Bkgndณ',B,'MOVE    ',N,' Positionerณ',B,'REC    ',N,'to E-MEM       '
 db B,'"INS"   ',N,' DSK OnOffณ',B,'ShftINS ',N,' SetFTBTrnณ',B,'OPN END ',N,' Aspect    ณ',B,'RECALL ',N,'from E-MEM     '
 db B,'"DEL"   ',N,' FTB OnOffณ',B,'ShftDEL ',N,' SetDSKTrnณ',B,'CONST   ',N,' Key Sourceณ',B,'REPLAY ',N,'E-MEM AutoTrans'
 db B,'SPLIT   ',N,' 50% Faderณ',B,'SET DUR ',N,' Set Rate ณ',B,'        ',N,'           ณ',B,'SAVE   ',N,'EFX Files      '
 db B,'CLEAR   ',N,' Reset EFXณ',B,'ShfSplit',N,' Set50%Posณ',B,'        ',N,'           ณ',B,'LOAD   ',N,'EFX Files      '

 db 0
	else
 db 'ออออออออ Transition Control อออออออออัอออออออออออออออออออัอออ E-MEM Control ออออ'
 db 255,'ThisEvnt',254,' AutoTransณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'"T"    ',254,'PreviewTimeline'
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'FIND   ',254,'EFX File Finder'
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'       ',254,'               '
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'REC    ',254,'to E-MEM       '
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'VVV    ',254,'from E-MEM     '
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'REPLAY ',254,'E-MEM AutoTrans'
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'SAVE   ',254,'EFX Files      '
 db 255,'        ',254,'          ณ',255,'        ',254,'          ณ',255,'        ',254,'           ณ',255,'LOAD   ',254,'EFX Files      '
 db 0
	endif
;================================================================
;Status monitor and default menu HEADER.  Uses 8 records, max.
stathdr_ovr:
; Max string size:	'---------------------',0
		db	'Editing Parameters',0
		db	'Auxiliary Functions',0
autofile_ovr	db	'Auto-Save To Disk',0
		db	'Global reel Replace',0
		db	'Recall-OUT Priority',0
		db	'Select EDL Format',0
		db	'System Color Framing',0
		db	'Source Color Framing',0
		IF NTSC
		db	'Convert EDL DF/NDF',0
		ELSE
		DB	' ',0
		ENDIF
		db	'Insert/Assemble',0
		db	'EDL Storage Options',0
		db	'Auto Assembly Options',0
INIgpi_ovr	db	'GPI Relay Programming',0
		db	'System Diagnostics ',0
		db	'Record Start Time',0
		db	'Edit Accuracy/Retries',0
		db	'Mark / Trigger Adjust',0
		db	'Edit SYNC Reference',0
		db	'DOS Interface',0
		db	'Screen/Sound Defaults',0
		db	'Disk File Defaults',0
		db	'Key Definitions',0
INIjog_ovr	db	'Joystick/Serial Joggr',0
INIvln_ovr	db	'VLAN Network Control',0
INIser_ovr	db	'Serial Communications',0
INIxpt_ovr	db	'VTR Ports/Crosspoints',0
		db	'Switcher Options',0
		db 0

public stripetape_ovr,tcgenset_ovr,tcgenmode_ovr,stripewarn_ovr
tcgenset_ovr	db	'TC Generator start time',0
tcgenmode_ovr	db	'TC Generator code mode',0
stripetape_ovr	db	'Stripe Tape in R-VTR',0

public efxadr_ovr,wipemods_ovr,swtgl_ovr,forcev3_ovr
public upstrkey_ovr,dnstrkey_ovr,ememefxadr_ovr,vidbase_ovr,audbase_ovr
public vidbase2_ovr,pvwbase_ovr
efxadr_ovr	db	'Switcher M/E bank',0
upstrkey_ovr	db	'Upstream Keyer assignment',0
dnstrkey_ovr	db	'Downstream Keyer assignment',0
ememefxadr_ovr	db	'EMEM EFX address (0=Default)',0
wipemods_ovr	db	'Use wipe code modifiers',0
forcev3_ovr	db	'Force V-LAN timeline',0
extmenu_ovr	db	'Use external switcher menu',0
audefxadr_ovr	db	'Audio mixer effects address',0
vidbase_ovr	db	'Primary Video Switcher port',0
vidbase2_ovr	db	'Aux Video Switcher port',0
audbase_ovr	db	'Audio Mixer port',0
pvwbase_ovr	db	'Preview Switcher port',0
swtgl_ovr	db	'Crosspoint toggle',0

stripewarn_ovr:
 db cr,lf,'                                **** WARNING ****',cr,lf,lf
 db '      This function erases previously recorded material on your RECORD VTR.',0

diag_ovr:
	db	16,'-- Exit This Menu --',17,0
	db	'Run tests for ALL VTRs',0
	db	'Run tests for individual VTR',0
	db	0

MacEdI_ovr	db	'Insert mode:',0
MacEdA_ovr	db	'Append mode:',0
MacEd_ovr	db	' [BACKSPACE], [ESC] to edit, CTRL-ENTER to title and finish',0

;================================================================
; Moved messages

; Calculator messages
calc1_ovr	db	' Calculator ',0
function_ovr	db	' Functions: + - * /, [CLEAR], [CONST], [SHIFT CALC]',0

;messages to console (prompts) and other strings
working_ovr 	db	'  Working',0
searching_ovr	db	'Searching',0
goto_ovr	db	'Goto: ',0
fastswitch_ovr	db	'Switcher Toggle ',0

yn_ovr		db	' (Y/N) ',0
keyhelp_ovr	db	'Key Help (for next keypress)',0
findwhat_ovr	db	'FIND: <NOTE>, any <SET/MARK/TRIM> = '
		db	'source timecode search, <ENTER> = continue',0

findtc_ovr	db	'Find Time Code',0
findtext_ovr	db	'Find Text ',0
relsrch_ovr	db	'Find Reel ',0
relchg_ovr	db	' Change To ',0

savebuf_ovr	db	'Save marktable to buffer # (0-9) [ENTER=0]: ',0
restbuf_ovr	db	'Restore marktable from buffer #(0-9) [ENTER=0]: ',0

clrmrks_ovr	db	'[REC] disables all events, [THIS EVENT] MARKS all events',0
setmrks_ovr	db	'[REC] enables all events, [THIS EVENT] un-MARKS all events',0

Public reelsum_ovr
reelsum_ovr	db	'Reel Summary: [ENTER] or [PAGE], [INSERT] to or [DELETE] from EDL, or [PRINT]:',0

public newreel_ovr, newreelfirst_ovr, newreelsecond_ovr, asmcontinue_ovr
newreel_ovr		db	'New reel to be placed in ',0
newreelfirst_ovr	db	'New reel for FIRST EDIT LINE to be place in ',0
newreelsecond_ovr	db	'New reel for SECOND EDIT LINE to be place in ',0
asmcontinue_ovr		db	'Replace reel in VTR and press [ENTER] to resume...',0

INSTLcmd_ovr	db	'Point and [ENTER]',0
INSTLtgl_ovr	db	', "T" toggles',0
INSTLplus_ovr	db	', "+" selects by number',0
INSTLmac_ovr	db	', [INSERT], [DELETE], [BACKSPACE], [TITLE], [CLEAR], [+]',0

commandqry_ovr	db	'Type: [GPI], [VIDEO], <T>rigger now, NO = disable, YES = enable: ',0

public onetwo_ovr,entereqone_ovr

onetwo_ovr	db	'Line <1> or line <2>',0
onetwoboth_ovr	db	'Line <1>, <2>, or <B>oth'
entereqone_ovr	db	' (ENTER=1) ',0

binlist_ovr	db	'EDL Bin Selection',0

next_ovr	db	'Next  ',0
used_ovr	db	'Used  ',0
freemem_ovr	db	'Free  ',0
bin_ovr		db	'Bin ',0
workspace_ovr	db	'Wrk ',0

bump_msg	db	'Bump: ',0
public recording_ovr,rewinding_ovr,rewindit_ovr
rewindit_ovr	db	'Rewind RECORD VTR before striping ',0
rewinding_ovr	db	' REWINDING ',0
recording_ovr	db	' RECORDING ',0

preroll_rqst	db	'Preroll',0
postroll_rqst	db	'Preview Postroll',0
recpost_rqst	db	'Record Postroll',0
tlineroll_rqst	db	'Time Line Preroll',0
DelayRoll_ovr	db	'Delayed Roll Enable',0
DelEdRoll_ovr	db	'Preroll-to-edit delay',0
realtime_ovr	db	'Enable Hot Switch Mode',0
cuetrack_ovr	db	'Enable Cue-Track (Aud5)',0
preread_ovr	db	'Preread OFF after edit',0

public DelEdRollq_ovr
DelEdRollq_ovr	db	'Preroll-to-edit delay in ',172,' seconds',0

timestart_rqst	db	'Set Start Time',0
in_rqst		db	'Set In',0
out_rqst	db	'Set Out',0
dur_rqst	db	'Set Duration',0
const_rqst	db	'Set Constant',0
location_rqst	db	'Set Location',0
shiftinput_rqst	db	'Set Start Time',0
shiftplay_rqst	db	'Set Source Offset',0
shiftrec_rqst	db	'Set Record Offset',0
		db	0
setgpi_rqst	db	'Trigger Offset',0

spdchange_rqst	db	'Speed Change Delay',0

public rampstart_ovr,rampend_ovr,rampdur_ovr,ramptime_ovr, rampdialog_ovr
public rampenabled_ovr
rampenabled_ovr	db	'Ramp Enabled',0
rampdialog_ovr	db	'Run Ramp Dialog',0
rampstart_ovr	db	'Start Speed ',0
rampend_ovr	db	'End Speed ',0
rampdur_ovr	db	'Ramp Duration',0
ramptime_ovr	db	'Ramp Offset',0

deleting_ovr	db	'Deleting',0
sorting_ovr	db	'Sorting',0
write_ovr	db	'Saving',0
read_ovr	db	'Loading',0
punching_ovr	db	'Sending',0
pointer_ovr	db	'     <-- ',0


otf_qry		db	'Reaction Time',0
vvvIN_qry	db	'VVV IN Pvw',0
vvvOUT_qry	db	'VVV OUT Pvw',0
splitV_qry	db	'Split Vid Pvw',0
splitA_qry	db	'Split Aud Pvw',0
vbvIN_qry	db	'VBV IN Pvw',0
vbvOUT_qry	db	'VBV OUT Pvw',0
bvbIN_qry	db	'BVB IN Pvw',0
bvbOUT_qry	db	'BVB OUT Pvw',0
atrans_qry	db	'Auto trans',0
gtrans_qry	db	'GPI trigger',0
syncIN_qry	db	'Sync start',0
syncOUT_qry	db	'Sync end',0
PMC_qry		db	'PMC trigger',0
RT_qry		db	'Hot Switch',0

badscript_ovr	db	'Script file error in line ',0

selasgn_ovr	db	' [VTR-x], [AUX], [BLK], [GPI], [VVV], [VIDEO], [AUD1], or [CUE]: ',0

frommsg_ovr	db	'From ',0
tomsg_ovr	db	'To ',0
public formsg_ovr, atmsg_ovr
formsg_ovr	db	'For a duration of ',0
atmsg_ovr	db	'At offset ',0

public off_msg,on_msg
off_msg		db	'  Off ',0
on_msg		db	'  On  ',0

public fourfield_msg,eightfield_msg
public fourfieldI_msg,eightfieldI_msg
fourfield_msg	db	'4fld  ',0
fourfieldI_msg	db	'4fld/I',0
eightfield_msg	db	'8fld  ',0
eightfieldI_msg	db	'8fld/I',0


autoasminf_ovr	db	'Options: [THIS EVENT] = current, [ENTER] = from top',0

commentmsg_ovr	db	'Add Note: <ENTER>=After, <B>=Before, <A>=EDL bottom, <R>=Replace: ',0
dirmore_ovr	db	'Use [PgUp] and [PgDn] to display and select additional EDL files',0


public videomsg_ovr,triggermsg_ovr, gpiinfmsg_ovr
videomsg_ovr	db	'Video',0
triggermsg_ovr	db	' trigger #',0
gpiinfmsg_ovr	db	'(AutoTrans=151,251..., Dsk=51, Ftb=50, Emem#=xxx)',0

; Used by Install 13, relay assignments
trigstate_ovr	db	'Trigger state: 1=On (set), 2=Off (reset), 3=Toggle ',0
tglmsg_ovr	db	'Tgl',0
relaymsg_ovr	db	'Relay',0
pulsetime_ovr	db	'Pulse duration in frames: ',0
rtype_ovr	db	'<P>ulse or <L>atch ',0
inactive_ovr	db	'          --- N/A',0

onmsg_ovr	db	'On ',0
offmsg_ovr	db	'Off',0

redit_ovr	db	'Receive Edit',0
redl_ovr	db	'Receive EDL',0
rdy_ovr		db	' Ready ',0
rdrfile_ovr	db	'Read from PAPER TAPE',0
rdrrdy_ovr	db	'Ready PAPER TAPE.  Press [ENTER] to start read...',0
SavedReceived_ovr db	'Saved received data',0

set_timer_ovr	db	'[ENTER] to START timer, any [SET] key sets clock',0
stop_timer_ovr	db	'[ENTER] to STOP/RESET/CONTINUE timer, [PAUSE] to HOLD',0
public colorfrmq_ovr
;;colorfrmq_ovr	db	'Color framing: 1 = Off, 2 = On, 3 = Invert.  Current=',0

colorfrmq_ovr	db	'Framing: ',254,'1',255,'= Off, ',254,'2',255,'= 4 fld, ',254,'3',255,'= 4 fld Invert'
		if PAL
		db	', ',254,'4',255,'= 8 fld, ',254,'5',255,'= 8 fld Invert'
		ENDIF
		db	'  ',0

overwrite_ovr	db	7,'File exists!  Overwrite? ',0
resettt_ovr	db	'Reset running time?',0

movevnts_ovr	db	'Move Events',0
copyevnts_ovr	db	'Copy Events',0
movcpyrenum_ovr	db	'Automatic renumbering',0
starting_ovr	db	': Start with event ',0
ending_ovr	db	', end with event ',0
tobin_ovr	db	'To this bin?',0
toend_ovr	db	'. Add to end?',0
mkdasm_ovr	db	'Marked events only? ',0
withthis_ovr	db	'Start at top of EDL?',0
matched_ovr	db	'Source Matchframe Calculated and Set In',0
delete_qry	db	'Block Delete',0
delete_ovr	db	'Delete: <Y>es / <A>ll / <B>lock / <M>arked',0
delmrkd_ovr	db	'Delete marked events?',0
ripple_ovr	db	'Ripple EDL',0
replace_ovr	db	'Replace Event',0
ins_ovr		db	'Insert above current event',0
shift_ovr	db	'   Select: <P>lay (source), <R>ecord, or <S>tart time: ',0
shift_frmto_ovr	db	'Shift',0
sort_ovr	db	'Sort by REC IN',0
sortln_ovr	db	'By event numbers',0
sortreels_ovr	db	'By reel names',0

break_ovr	db	'Exit to DOS',0

event_renum_ovr	db	'Renumber to end',0

clear_list_ovr	db	'Clear EDL',0

lstfile_ovr	db	'Output to PRINTER',0
clrmacs_ovr	db	'Clear All Macros',0
punchfile_ovr	db	'Output to PUNCH',0
serial_ovr	db	'ASCII output to serial port',0

realtimeok_ovr	db	'Save Hot Switch(es) to EDL?',0

public calcedit_ovr, calctrig_ovr
calcedit_ovr	db	'Setting up',0
calctrig_ovr	db	' triggers...',0
public earlygpi_ovr,earlygpi2_ovr,earlygpie_ovr,earlygpit_ovr,earlygpip_ovr
earlygpi_ovr 	db	' GPI register #',0
earlygpi2_ovr	db	' cannot be triggered before the specified ',0
earlygpie_ovr	db	'edit ',0
earlygpit_ovr	db	'TimeLine ',0
earlygpip_ovr	db	'preroll ',0


;================================================================
;
;
;			ERROR MESSAGES
;
;
;================================================================
; Error bits:	 8	7	6	5	4	3	2	1
;	    Dissappear Kbd/Dos  <---------- Error Number 0-64 ---------->
; 00 = Return with carry set
; 01 = 
; Error grouping:
;	Category	Error type
;	00000000	Non-Critical, return with carry set
;	01000000	Non-Critical, exit to KEYBOARD
;	10000000	Critical, exit directly to DOS
	even
Error_Table_ovr	equ	$
 DW ERROR_0,ERROR_1,ERROR_2,ERROR_3,ERROR_4,ERROR_5,ERROR_6,ERROR_7
 DW ERROR_8,ERROR_9,ERROR_10,ERROR_11,ERROR_12,ERROR_13,ERROR_14,ERROR_15
 DW ERROR_16,ERROR_17,ERROR_18,ERROR_19,ERROR_20,ERROR_21,ERROR_22,ERROR_23
 DW ERROR_24,ERROR_25,ERROR_26,ERROR_27,ERROR_28,ERROR_29,ERROR_30,ERROR_31
 DW ERROR_32,ERROR_33,ERROR_34,ERROR_35,ERROR_36,ERROR_37,ERROR_38,ERROR_39
 DW ERROR_40,ERROR_41,ERROR_42,ERROR_43,ERROR_44,ERROR_45,ERROR_46,ERROR_47
 DW ERROR_48,ERROR_49,ERROR_50,ERROR_51,ERROR_52,ERROR_53,ERROR_54,ERROR_55
 DW ERROR_56,ERROR_57,ERROR_58,ERROR_59,ERROR_60,ERROR_61,ERROR_62,ERROR_63
 DW ERROR_64

	if 1 eq 1	; Used to bypass PUBLIC.COM
; System errors:	0 to 8
ERROR_0		db	'No errors to report',0
ERROR_1		db	'Not enough memory',0
ERROR_2		db	'SES cannot calculate CPU speed.  Use /Sxx option',0
ERROR_3		db	'Communications port is not properly assigned. ',0
ERROR_4		db	'Printer not ready',0
ERROR_5		db	'No virtual memory. Cannot shell to DOS',0
ERROR_6		db	'Not enough memory, SES already running?',0
ERROR_7		db	0
ERROR_8		db	0

; VTR errors:		9 to 16
ERROR_9		db	'VTR(s) OFFLINE',0
ERROR_10	db	'VTR(s) not ready',0
ERROR_11	db	'No auxilliary switcher found',0
ERROR_12	db	0
ERROR_13	db	0
ERROR_14	db	'Cannot roll more than one source VTR',0
ERROR_15	db	'No auxilliary switcher available',0
ERROR_16	db	0

; File ERRORS:		17 to 32
ERROR_17	db	'Requested file is corrupt or unusable',0
ERROR_18	db	'File(s) not found on selected directory',0
ERROR_19	db	'Disk File Error',0
ERROR_20	db	'DISK IS FULL',0
ERROR_21	db	'DISK MAY NOT INITIALIZED',0
ERROR_22	db	'GENERAL FAILURE. Disk not formatted?',0
ERROR_23	db	'Disk drive not ready (drive door may be open)',0
ERROR_24	db	'Disk is write protected',0
ERROR_25	db	'Subdirectory cannot be found',0
ERROR_26	db	'Requested program cannot be found',0
ERROR_27	db	'Not a SES Effects file',0
ERROR_28	db	'Not a SES Macro file',0
ERROR_29	db	0
ERROR_30	db	0
ERROR_31	db	0
ERROR_32	db	0

; Workspace errors	33 to 48
ERROR_33	db	'Invalid reel assignment',0
ERROR_34	db	' Reel not found ',0
ERROR_35	db	'Can',39,'t tag from this edit',0
ERROR_36	db	'DURATION less than SPLIT DELAY',0
ERROR_37	db	'DURATION less than TRANSITION RATE',0
ERROR_38	db	'Can',39,'t make transition',0
ERROR_39	db	'No Video or Audio modes selected',0
ERROR_40	db	'Duration not defined for this edit',0
ERROR_41	db	'No Marks to restore (empty)',0
ERROR_42	db	'Multiple sources not allowed',0
ERROR_43	db	'Not Found',0
ERROR_44	db	'Warning: Changed R-VTR Frame Code Mode',0
ERROR_45	db	'R-VTR MUST be Master for Hot Switching',0
ERROR_46	db	'Result would be less than zero',0
ERROR_47	db	0
ERROR_48	db	0

; EDL errors		49 to 56
ERROR_49	db	'Bins have different Frame Code Modes',0
ERROR_50	db	'Out of memory ',0
ERROR_51	db	'Edit not in list',0
ERROR_52	db	'No MARKED EVENTS found',0
ERROR_53	db	'No Reel Summary exists',0
ERROR_54	db	'Can',39,'t match to reel. Use ALT-MARK IN (extended match)',0
ERROR_55	db	0
ERROR_56	db	'Selected SOURCE has no variable speeds',0

; Specials		57 to 63
ERROR_57	db	'Motion-MEM N/A for this device',0
ERROR_58	db	'Fill speed out of range',0
ERROR_59	db	'Bad parameter(s)',0
ERROR_60	db	'VTR is already a Master/Slave device',0
ERROR_61	db	'VTR is already a Multiple Record device',0
ERROR_62	db	'Source/Multiple Record conflict',0
ERROR_63	db	'Cannot swap with same VTR',0
ERROR_64	db	'Ramp specifications illegal',0
	endif

;================================================================
; Sound table data.  Takes 2 records
sound_ovr:
	dw	17,18,20,21,22,23,25,26,28,29,31,33,35,37,39
	dw	41,44,46,49,52,55,58,62,65,69,73,78,82,87,92,98
	dw	104,110,117,123,131,139,147,156,165,175,185,196
	dw	208,220,233,247,262,277,294,311,330,349,370,392
	dw	415,440,466,494,523,554,587,622,659,698,740,784
	dw	831,880,932,988,1047,1109,1175,1245,1329,1397
	dw	1480,1568,1661,1760,1865,1976,2093,2217,2349
	dw	2489,2637,2794,2960,3136,3322,3520,3729,3951,4186
	dw	0ffffh

;================================================================
wn	equ	16	;Whole note
tn	equ	12	; 3/4 note
hn	equ	8	;half note
qn	equ	4	;quarter note
en	equ	2	;eigth note
sn	equ	1	;sixteenth
; music tune for whistling music Takes 1 record
music_ovr:
; c     d     e  f     g     a     b  c
;48 49 50 51 52 53 54 55 56 57 58 59 60

; dixie
	db	55,en,52,en
	db	48,en,0ffh,en,48,en,0ffh,en,48,en,50,en,52,en,53,en
	db	55,qn,55,qn,55,qn,52,en,0ffh,en
	db	57,qn ,57,qn ,57,qn+sn ,0ffh,sn,55,en
	db	57,qn ,0ffh,en,55,en ,57,en,59,en ,60,en ,62,en
	db	64,tn,60,en,55,en
	db	60,tn,55,en,52,en
	db	55,tn,50,en,52,en
	db	48,tn,0ffh,qn
	dw	0ffffh

;================================================================
bignumbers_ovr	equ	$
	db 'ÛÛÛÛ'
	db 'Û  Û'
	db 'Û  Û'
	db 'Û  Û'
	db 'ÛÛÛÛ'

	db ' ÛÛ '
	db '  Û '
	db '  Û '
	db '  Û '
	db ' ÛÛÛ'

	db ' ÛÛÛ'
	db '   Û'
	db '  Û '
	db ' Û  '
	db 'ÛÛÛÛ'

	db 'ÛÛÛÛ'
	db '   Û'
	db ' ÛÛÛ'
	db '   Û'
	db 'ÛÛÛÛ'

	db 'Û  Û'
	db 'Û  Û'
	db 'ÛÛÛÛ'
	db '   Û'
	db '   Û'

	db 'ÛÛÛÛ'
	db 'Û   '
	db 'ÛÛÛÛ'
	db '   Û'
	db 'ÛÛÛÛ'

	db 'ÛÛÛÛ'
	db 'Û   '
	db 'ÛÛÛÛ'
	db 'Û  Û'
	db 'ÛÛÛÛ'

	db 'ÛÛÛÛ'
	db '   Û'
	db '  Û '
	db ' Û  '
	db 'Û   '

	db 'ÛÛÛÛ'
	db 'Û  Û'
	db 'ÛÛÛÛ'
	db 'Û  Û'
	db 'ÛÛÛÛ'

	db 'ÛÛÛÛ'
	db 'Û  Û'
	db 'ÛÛÛÛ'
	db '   Û'
	db 'ÛÛÛÛ'

	db '    '
	db ' Ü  '
	db ' Ü  '
	db '    '
	db '    '

littlenumbers_ovr	equ	$
	db 'ษอป'
	db 'บ บ'
	db 'ศอผ'
	db ' ป '
	db ' บ '
	db ' ะ '
	db 'ษอป'
	db 'ษอผ'
	db 'ศอผ'
	db 'ษอป'
	db ' อน'
	db 'ศอผ'
	db 'ษ ป'
	db 'ศอน'
	db '  ะ'
	db 'ษออ'
	db 'ศอป'
	db 'ศอผ'
	db 'ษอป'
	db 'ฬอป'
	db 'ศอผ'
	db 'ษอป'
	db '  บ'
	db '  ะ'
	db 'ษอป'
	db 'ฬอน'
	db 'ศอผ'
	db 'ษอป'
	db 'ศอน'
	db 'ศอผ'
	db '   '
	db ' ๘ '
	db ' ๘ '
	db '   '
	db '   '
	db '   '

;----------------------------------------------------------------
;	KEY DEFINITIONS TABLE
;----------------------------------------------------------------
	even
keys_ovr:
	db	'ออ Record VTR ออ'
	db	'ออออ A VTR อออออ'
	if Allowed_VTRs GT 2
	db	'ออออ B VTR อออออ'
	endif
	if Allowed_VTRs GT 3
	db	'ออออ C VTR อออออ'
	endif
	if Allowed_VTRs GT 4
	db	'ออออ D VTR อออออ'
	endif
	if Allowed_VTRs GT 5
	db	'ออออ E VTR อออออ'
	endif
	if Allowed_VTRs GT 6
	db	'ออออ F VTR อออออ'
	endif
	db	'อออออ AUX ออออออ'
	db	'ออออ BLACK อออออ'
	db	'ออออ STOP ออออออ'
	db	'ออ PAUSE/PLAY ออ'
	db	'ออออ STILL อออออ'
	db	'ออออ PLAY ออออออ'
	db	'อ Fast Forward อ'
	db	'อ Fast Rewind ออ'
	db	' Fast-Scan Fwd อ'
	db	' Fast-Scan Rev อ'
	db	'อ Variable Fwd อ'
	db	'อ Variable Rev ='
	db	' Twice Speed Fwd'
	db	'Twice Speed Play'
	db	' Twice Speed Rev'
	db	'อ Reverse-Play อ'
	db	'อCue to Prerollอ'
	db	'อออ Search อออออ'
	db	'อ Scan Forward อ'
	db	'อ Scan Backward '
	db	'อ Slow Forward อ'
	db	'อ Slow Backward '
	db	'อ Mark In Point '
	db	' Mark Out Point '
	db	' All Still/Abrt '
	db	'อออ All Stop อออ'
	db	'อออ All Cue ออออ'
	db	'อ Return to IN อ'
	db	'อ Return to OUT '
	db	' One Frame Fwd อ'
	db	' One Frame Back '
	db	' Rehearse Edit อ'
	db	'ออ Record Edit อ'
	db	'ออ Review Edit อ'
	db	'อ Preview VBV ออ'
	db	'อ Preview BVB ออ'

	db	'ออ Preview VV ออ'
	db	'ออ Preview BV ออ'
	db	'ออ Preview VB ออ'

	db	' Auto Assembly อ'
	db	'อออ Assemble อออ'
	db	'Cancel/Draw Scrn'
	db	' Install/Utils อ'
	db	'อออ Constants ออ'
	db	'อ Macro Change อ'
	db	'ออ Call Macro ออ'
	db	'ออออ Enter อออออ'
	db	'ออ Recall Out ออ'
	db	'ออ AutoTag Tgl อ'
	db	'ออ MatchFrame ออ'
	db	'อ Print On/Off อ'
	db	'อ AutoClean Tgl '
	db	' Enable/Disable '
	db	'อ Sort On/Off ออ'
	db	'อออ Recompute ออ'
	db	' Channel Resets '
	db	'อออออ Title ออออ'
	db	'Log to Directory'
	db	'อ Set Defaults อ'
	db	'อ EDL Directory '
	db	'อออ Save File ออ'
	db	'อออ Load File ออ'
	db	'อ Set In Point อ'
	db	'อ Set Out Point '
	db	'อ Set Duration อ'
	db	'อ Trim In Point '
	db	' Trim Out Point '
	db	'อ Video On/Off อ'
	db	' Audio 1 On/Off '
	db	' Audio 2 On/Off '
	db	' Audio 3 On/Off '
	db	' Audio 4 On/Off '
	db	'อออออ CUT ออออออ'
	db	'อออ DISSOLVE อออ'
	db	'ออออ WIPE ออออออ'
	db	'อออออ KEY ออออออ'
	db	'ออออ SPLIT อออออ'
	db	' Effects Toggle '
	db	' Auto-Dissolve อ'
	db	' Auto Make Wipe '
	db	'Scroll Consts + '
	db	'Scroll Consts - '
	db	' Scroll Forward '
	db	'ออ Scroll Back อ'
	db	'ออ First Event อ'
	db	'ออ Last Event ออ'
	db	' Page Backward อ'
	db	'อ Page Forward อ'
	db	'อ Open-End edit '
	db	'ออ Recall Edit อ'
	db	'อออ New Reel อออ'
	db	' Renumber Edits '
	db	' Change Edit # อ'
	db	'อ Seek to event '
	db	'ออ Enter Note ออ'
	db	'อออ Clear EDL ออ'
	db	'อออ Page EDL อออ'
	db	'อออ Add event ออ'
	db	'อ Delete event อ'
	db	'อ Insert event อ'
	db	' Replace event อ'
	db	'ออ Clear Edit ออ'
	db	'อ Shift/Ripple อ'
	db	'อออ SRT EDL ออออ'
	db	'ออออ EX WRK ออออ'
	db	'ออออ SMARKS ออออ'
	db	'ออออ RMARKS ออออ'
	db	'Find Match Frame'
	db	'อ Exit to DOS ออ'
	db	'อออ Keys Help ออ'
	db	' Keyboard Layout'
	db	' Clear Workspace'
	db	'อ Move Edit(s) อ'
	db	'อออ Copyright ออ'
	db	'อ Edit Receive อ'
	db	'ออ Edit Send อออ'
	db	'ออ EDL Send ออออ'
	db	'ออออ XTERM อออออ'
	db	'ออ EDL Receive อ'
	if DEBUGGER
	db	' Debug/Monitor อ'
	endif
	db	'อ Set Preroll ออ'
	db	'อ Set Postroll อ'
	db	'Run DOS Programs'
	db	' Switch EDL Bin '
	db	'ON-LINE MANUALS '
	db	' Out/Dur Toggle '
	db	'อ Force Recall อ'
	db	'ออออ Dixie อออออ'
	db	'อ GPI Trigger ออ'
	db	'Set/Reset Slaves'
	if NOT CUTS_ONLY
	db	'VID XPTS On/Off '
	db	'AUD XPTS On/Off '
	endif
	db	'อ All Enable อออ'
	db	'อ All Disable ออ'
	db	'อ Print EDL ออออ'
	db	'Enter All Reels '
	if not CUTS_ONLY
	db	' EMEM Options ออ'
	endif
	db	'ออ UNDO EDL ออออ'
	db	' Previous Event '
	db	'ออ Calculator ออ'
	db	'อ Wild Key #1 ออ'
	db	'อ Wild Key #2 ออ'
	db	'Frames/TC toggle'
	db	'Find Notes or TC'
	db	'ออออ EJECT อออออ'
	db	'Auto-Save On/Off'
	db	'Set VTR Location'
	db	'ออ This Event ออ'
	db	'ออ Stopwatch อออ'
	db	' Timer Toggle ออ'
	db	' VIDEO MODE ON อ'
	db	'AUDIO 1 MODE ON '
	db	'AUDIO 2 MODE ON '
	db	'ออ Modes Off อออ'
	db	'อ Mult Trim IN อ'
	db	' Mult Trim OUT อ'
	db	'Compute EDL Time'
	db	' EDLtrak ON/OFF '
	db	' EDLtrak Single '
	db	'อMotion Memoryออ'
	db	'อ AutoPMC Matchอ'
	db	'อExtended Matchอ'
	db	'อExtended Sync อ'
	if Allowed_VTRs EQ 7
	db	'ออSpeed Fillออออ'
	db	'ออEDL FAST-FIXออ'
	db	'อออ TimeLine อออ'
	db	'อ PreRead OnOffอ'
	if ALLOWRAMPSPEED
	db	'อRamp VTR Speedอ'
	ENDIF
	endif

	db	'EDL Split Screen'
	db	'Execute Macro 1 '
	db	'Execute Macro 2 '
	db	'Execute Macro 3 '
	db	'Execute Macro 4 '
	db	'Execute Macro 5 '
	db	'Execute Macro 6 '
	db	'Execute Macro 7 '
	db	'Execute Macro 8 '
	db	'Execute Macro 9 '
	db	'Execute Macro 0 '
	db	'อออ Clear ออออออ'
	db	'อออ Frames อออออ'
	db	'อ Ctrl-Break อออ'
	db	'อ Suspend Macro '
	db	'อ Color Toggle อ'
	db	'ออ Bell Toggle อ'
	db	'อ Macro Record อ'
	db	'อ Macro Delay ออ'
	db	' UNDO WORKSPACEอ'
	if Allowed_VTRs EQ 7
	db	'อ Mult  Record อ'
	endif
	db	'อ Pre-Read Tgl อ'
	db	'ออ Swap VTRs อออ'
	db	'อ Reel Summary อ'
	db	'อ EDL Cleaning อ'
	db	'ออ VariSpeed อออ'
	db	'อSwitcher Clearอ'
	db	'Swap VidSw Ports'
	db	'ออออ ESCape ออออ'
;;	db	'อ    ',17,' ?? ',16,'    อ'
	db	0

;	db	'ออออออออออออออออ'

;----------------------------------------------------------------
;	FULL PAGE KEYBOARD LAYOUTS
;----------------------------------------------------------------
;<MENU>

demo_ovr	equ	$

	IF DEMO_RELEASE

 db '                                        '
 db '                                        '
 db 'ษอออออออออออออออออออออออออออออออออออออออ'
 db 'อออออออออออออออออออออออออออออออออออออออป'
 db 'บ ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ'
 db 'ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ บ'
 db 'บ ณ                                     '
 db '                                     ณ บ'
 db 'บ ณ                       STRASSNER EDIT'
 db 'ING SYSTEMS                          ณ บ'
 db 'บ ณ                                     '
 db '                                     ณ บ'
 db 'บ ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ'
 db 'ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู บ'
 db 'ศอออออออออออออออออออออออออออออออออออออออ'
 db 'อออออออออออออออออออออออออออออออออออออออผ'
 db '                                        '
 db '                                        '
 db '                                        '
 db '                                        '
 db '                Demonstration Release of'
 db ' the SES Edit Controller                '
 db '                                        '
 db '                                        '
 db 255
 db '       Some features of the original sof'
 db 'tware have been disabled or removed.    '
 db '                                        '
 db '                                        '
 db '   Keyboard layout diagrams are displaye'
 db 'd by holding down the SHIFT and ? keys. '
 db '                                        '
 db '                                        '
 db '                                        '
 db '                                        '
 db '       For information, call Strassner V'
 db 'ideo Enterprises,  (818) 508-6966       '
 db '                                        '
 db '                                        '
 db 252
 db '        ****************  Press any key '
 db 'to enter SES  ****************          '

	ENDIF	; DEMO_RELEASE

	db 0

_DATA	ends

 end
