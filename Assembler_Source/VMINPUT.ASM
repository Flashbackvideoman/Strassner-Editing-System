; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner

;================================================================
;VMINPUT.ASM
;User input modules for EM.ASM
;November 16, 1985
;(C)Norman H. Strassner
;All rights reserved.
;

%nolist
	include	vm.equ
%nolist

extrn Mcrosep:word
extrn Assemble_Flag:byte,Calc_Flag:byte,Cimsg_Fcm:byte,Cimsg_Insert_Mode:byte
extrn Cimsgadd_Flag:byte,Color_BKG:byte,Current_Constant:byte
extrn Current_Machine:byte,Decflg:byte,Device_Present:byte,Dirfiles:byte
extrn Dirpgtop:byte,Edl_Fcm:byte,Flag3:byte,Frame_Flag:byte,From_Flag:byte
extrn Fromwitch_Mach:byte,Fullscreen_Flag:byte,Mac2edit_Num:byte
extrn Mac2record2:byte,Macedit_Choice:byte,Macins_Flag:byte
extrn Macrecord_Flag:byte,OldframeFlag:byte,Record_Flag:byte,Sign_Flag:byte
extrn Suspend_Flag:byte,Trim_Ci_Flag:byte,Video_Mode:byte,Which_Type:byte

extrn Ascii_Line:word,Block_End:word,Block_Start:word,Calcstor1:word
extrn Cimsg_Cursor:word,Cimsg_Pntr:word,Cimsg_Spaces:word,Cimsg_String:word
extrn Cimsg_Tc:word,Cmdtbl1:word,Cmdtbl2:word,Cmdtbl3:word,Cmdtbl4:word
extrn Constant_Msg:word,Current_Duration:word,Current_Event:word
extrn Current_Event_Adr:word,Current_Inbuf:word,Current_Outbuf:word
extrn Cursor:word,Delay_Timer:word,EFX_cmdtbl:word,ERROR_Cursor:WORD
extrn ERROR_PROMPT:WORD,Ending_Number:word,Event_Msg:word,Execute_Msg:word
extrn Filename_Ptr:word,From_A_Msg:word,From_Aux_Msg:word,From_B_Msg:word
extrn From_Blk_Msg:word,From_C_Msg:word,From_D_Msg:word,From_E_Msg:word
extrn From_F_Msg:word,From_R_Msg:word,Fromcalc_Msg:word,Fromdur_Msg:word
extrn Fromin_Msg:word,Fromloc_Msg:word,Fromout_Msg:word,Fromtime_Msg:word
extrn INSTLcmd_ovr:word,INSTLmac_ovr:word,INSTLplus_ovr:word
extrn INSTLtgl_ovr:word,Input_Flag:word,Kbd_Tc_Pos:word,Last_Command:word
extrn Last_Key:word,Learnmac_Msg:word,MacEdA_ovr:word,MacEdI_ovr:word
extrn MacEd_ovr:word,Msg_Seg:word,Next_Avail_Num:word,Pagend_Msg:word
extrn PauseForTime_ovr:word,Pmc_Msg:word,PointShootData:word
extrn Position_Query_Table:word,R_Tc:word,Record_Macro:word
extrn RunningCMD_Buf:word,RunningCMD_Cnt:word,RunningCMD_Ptr:word
extrn SScreen_Cmdtbl:word,ScreenLineBuf:word,Select1to_Msg:word
extrn Selectfile_Msg:word,Starting_Number:word,Sttime:word,Tags_Table:word
extrn Tc_Format:word,Tcdispbuf:word,Temp_Event:word,Temp_Macro:word
extrn Temp_Tc_Buf:word,Temp_Tempbuf:word,Temp_Vidbuf:word,Temp_Wrkspce:word
extrn Time_Total:word,Vtrcb:word,Xlt_Tbl:word,ZeroBase:word,ending_ovr:word
extrn keys_ovr:word,macromenu_ovr:word,macromsg_ovr:word,starting_ovr:word
extrn yn_ovr:word

extrn Machine_Change:near,get_Vtrcb_FCM:near,jogger:near
extrn joystick:near,locations:near,re_kbd:near,read_DEVICE_time:near
extrn screen_init:near,time_date:near

extrn Badcrash_FAR:far,Keyboard:far
extrn _A_DecOut:far,_Break_check:far,_Calc_EndOfString:far
extrn _Clear_Cimsg_Buffer:far,_ConOut:FAR,_Cursor_On:far,_Cursor_off:far
extrn _DecOut:far,_Edm_Disp:far,_Edm_Position:far,_Edm_delone:far
extrn _Edm_inschar:far,_Inout_init:far,_Macro_Screen:far,_Move_Left:far
extrn _Move_Right:far,_Sttime_move:far,_TitleTheMacro:far
extrn _all_machine_keys:far,_backspace:far,_check4edl:far,_chimes:FAR
extrn _clear_screen:FAR,_clear_tc:far,_cmdread:far,_cntrtxt:far
extrn _cnvt2mp_DS:far,_cnvt2tc_DS:far,_comsg:FAR,_constant_disp:far
extrn _constant_index:far,_convert2bin:far,_delfrm:far,_dircur_lerase:FAR
extrn _display_froms:far,_draw_machines:far,_elaptm_move_ES:far
extrn _error_bell:FAR,_event_display:far,_evnt_dispthis:far,_find_edit_BX:far
extrn _frommsgs:far,_fwhatmsgs:far,_getlast_Flags:far,_getlast_dur:far
extrn _getlast_pin:far,_getlast_pout:far,_getlast_ptcd:far,_getlast_rin:far
extrn _getlast_rout:far,_getlast_rtcd:far,_help_pos:FAR,_hl_lp:far
extrn _index_storage:far,_kbd_clear:far,_kbd_cln:far,_kbd_clr:FAR
extrn _kbd_message:far,_line_erase:FAR,_mac_load:far,_mac_save:far
extrn _macone:far,_macro_clear:far,_macroindex:far,_macros_disp:far
extrn _macrosav:far,_macsaver:far,_make_dec:far,_make_ucase:far,_mmv16:far
extrn _mmv:far,_mod100hrs:far,_mod24hrs:far,_mode_upd:far,_msgread:far
extrn _rdnum:far,_screen_ram:far,_sram_dx:far,_sttime_move_ES:far
extrn _tcline_init:far,_timadd:far,_time_value:far,_upd_getscr:far

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg


Public  PauseForTime, ptf, ptfdone, Edit_Macro, Edm_1, Edm_Dfl, Edm_syc
Public  Edm_agn, Edm_10, Edm_Backspace, Edm_del, Edm_Add, Edm_ad1, Edm_ins
Public  Edm_ina, Edm_inagn, Edm_in1, Edm_in1a, Edm_in1aa, Edm_in1b, Edm_in2
Public  Edm_in3, Edm_Clear, Edm_Title, Title_Macro, Edm_xit, tc_cimsg, tcin_1
Public  tcin_2, tcin_4, tcin_4a, tcin_4b, tcin_5, tcin_5e, tcin_5f, tcin_6
Public  tcin_7, tcin_8, tcin_10, tcin_11, tcin_14, from_which, from_in
Public  from_out, from_dur, from_loc, from_time, from_CrntConst
Public  from_CrntConst0, from_PMC, from_iod, from_1, from_2, from_3, from_4
Public  from_4a, from_5, from_6, from_6a, from_7, from_8, from_9, from_Exit
Public  frmexa, from_ex1, from_evnt, fromng, from_event, fromrg, fromlp, from0
Public  fromsd, from1, fromx, from_gets, fgret, fger, glfg_dur, glfg_pin
Public  glfg_pout, glfg_rin, glfg_rout, read_clear, tccmg_brk, kbd_escape
Public  JL0636, read_enter, readen0, readen1, clear_read, readen2
Public  from_calculator, constant_select, from_select, JL0750, cnosel, frames
Public  cimsg_convert, cmvrtr2, cmvrt1, cmvrt2, cmvrtr, dbl_zeros, dblzr
Public  snglzro, snglz1, dblzx, cimsg_add_FAR, cimsg_add, dec_cimsg_FAR
Public  dec_cimsg, cimsg_wrk_FAR, cimsg_wrk, cimsg, cimsg1, rdloop, rdlncmd
Public  rdloopA, rdloopB, rdlpB1, rdloopC, rdloopD, rdpopstcret, rdloopE
Public  rdloopF, rdloopZ, rdl_TEXT, strch0, strch, exitrd, erdcst1, erdcstx
Public  rdloop_clear, rdloop_enter, rdloop_escape, rdloop_ctrlx, rdloop_sol
Public  rdloop_eol, rdloop_insert, rdloop_delete, rdloop_back, rdlbkx
Public  rdloop_forward, rdlfwx, rdloop_oldstring, olf1, olf2, olfx, olfer
Public  rdloop_dblzero, cimdbl0, rdloop_backspace, rd_delete, rddel1, rddel2
Public  rddel3, rdloop_display, rdlpdp1, rd_evnum, rdevnm1, cimstor, cimstr1
Public  cimster, rdchar_FAR, rdchar, rdchar0, rdchar1, rdchar2, rdchar3, JL0785
Public  rdchar1a, macro_record, mrtx, MacRec_term, Mrtnc, rdwait, macro_pause
Public  mcropsc, mcropsx, _cstat_FAR, cstat, keywait, keyhold_FAR, keyhold
Public  keyget, keytrans, keytrnl, keytrn1, keytrnx, backsp, backsp1, backspx
Public  get_ucase, get_range, getran1, JL0805, getran2, getabrt, getrngn
Public  getrnbd, idx2nxt, idx2lst, idx2nxtx, mac_setdflt, mac_goselect, mchxit
Public  _mac_savej, _mac_loadj, mac_clearj, macro_change, mchagn, mchagn1
Public  mchagn2, JL0245, learnmacro_message, kbdner1, clearmacro_message, xmac1
Public  xmac2, xmac3, xmac4, xmac5, xmac6, xmac7, xmac8, xmac9, xmac10
Public  macrosavr, macro_select, ML0280, msj7, msjx, msj_cmd, msj8, ML0285
Public  yn_chos_FAR, no_chos_msg_FAR, pos_yn_chos_FAR, no_chos_msg, pos_yn_chos
Public  yn_chos, yn_ch1, yn_ch2, yn_ch3, yn_ch4, yn_ch5, yn_ch6, JL0110, ynexit
Public  position_query_FAR, posbad, position_query, PQR_nc1, PQR_nt, PQR_nta
Public  PQR_agn, PQR_frs, PQR_sel, PQR_sled, PQR_sok, PQR_s1, PQR_ncm, PQR_yyn
Public  PQR_nyn, PQR_kfl, PQR_ktv, PQR_nlf, PQR_kth, PQR_xit, PQR_xt1, PQR_nm
Public  PQR_nm0, PQR_nm0a, PQR_nm1, PQR_nmp, PQR_nmr, PQR_nm2, PQR_hom, PQR_end
Public  PQR_dn, PQR_up, PQR_rht, PQR_lft, PQR_sela, PQR_sela1, PQR_selb
Public  PQR_selc, PQR_seld, PQR_rev, PQR_dlp, PQR_sav, PQR_sal, PQR_dim
Public  PQR_pos, PQR_pos1, PQR_pos4, keythru_FAR, keythru, kt_ok
Public  KeyCommand_main, KeyCommand_SplitScreen, KeyCommand_RepairEDL
Public  KeyCommand_EFXMEM, KeyCommand_Cmdtbl2, KeyCommand_rdloop
Public  KeyCommand_TcCimsg, KeyCommand_PQ, KeyCommand_Translate, KC_xlt
Public  KbdCmd1, KbdCmd2, KbdOut


%list
; 3-11-1993 NEW 5.0 FEATURE
PauseForTime	proc	near
	mov	bx,offset PauseForTime_ovr
	call	_Inout_init
	xor	cl,cl			; No + or -
	mov	bx,offset Delay_Timer	; Get start time
	mov	al,DF_CHAR
	call	tc_cimsg		; From user
	call	_kbd_cln

ptf:	call	_time_value
	jz	ptfdone
	push	bx

	call	locations
	mov	ah,0bh
	int	DOS
	call	_delfrm
	norm_VIDEO FALSE,FALSE
	mov	cl,DF_CHAR
	mov	bx,offset Delay_Timer	; Get start time
	mov	dx,offset Tcdispbuf	; Convert it
	call	_cnvt2tc_DS		;  to a string
	mov	Cursor,1800h
	call	_comsg			; Print TC value
	pop	bx

	sub	word ptr [bx],1
	sbb	word ptr 2[bx],0
	jmp	ptf
ptfdone:ret
PauseForTime	endp

;================================================================
;			EDIT MACROS
;================================================================
Edit_Macro	proc	near
	mov	Macedit_Choice,1	; Start at top of macro

	call	_kbd_cln
	mov	bx,offset macromsg_ovr	; Get macro number to edit
	call	_msgread
	call	_rdnum
	jnc	Edm_1

	mov	ax,dx			; Not a digit, check other commands
	call	_Break_check
	JMP_Z	Edm_xit
	call	keythru
	jmp	Edit_Macro

Edm_1:	mov	Mac2edit_Num,al
	mov	Fullscreen_Flag,0ffh	; Indicate full screen operation

Edm_Dfl:mov	al,Mac2edit_Num
	call	_macroindex		; Index to correct macro
	mov	si,offset Temp_Macro	; SI has temporary macro buffer
	mov	dx,si
	mov	cl,[bx]			; Copy the macro
	mov	ch,0
	inc	cx
	call	_mmv16

Edm_syc:call	_Macro_Screen

Edm_agn:call	_Edm_Disp
	cmp	byte ptr Temp_Macro,0	; Null macro?
	jz	Edm_Add

Edm_10:	call	_Edm_Position		; Adjust Macedit_Choice
	mov	cl,Macedit_Choice
	call	position_query		; Select macro position
	JMP_C	Edm_xit			; Exit if necessary

	mov	Macedit_Choice,cl	; Save position choice
	call	_kbd_cln
	call	_Break_check
	JMP_Z	Edm_xit

	cmp	ax,offset DelEv_xcmd
	jz	Edm_del
	cmp	ax,offset InsEv_xcmd
	jz	Edm_ins
	cmp	ax,offset Enter_xcmd
	jz	Edm_ins
	cmp	ax,offset Colonplus_xcmd
	jz	Edm_Add
	cmp	ax,offset Backspace_xcmd
	jz	Edm_Backspace
	cmp	ax,offset Clrrd_xcmd
	JMP_Z	Edm_Clear
	cmp	ax,offset Title_xcmd
	JMP_Z	Edm_Title
	cmp	ax,offset Cmnt_xcmd
	JMP_Z	Edm_Title
	jmp	Edm_10

Edm_Backspace:
	cmp	Macedit_Choice,1
	jbe	Edm_agn
	cmp	byte ptr Temp_Macro,0
	jz	Edm_agn
	dec	Macedit_Choice
	call	_Edm_delone
	jmp	Edm_agn

;................................................................
; DELETE MACRO
Edm_del:call	_Edm_delone
	call	_Edm_Position		; Adjust Macedit_Choice
	jmp	Edm_agn

;================================================================
;	APPEND COMMANDS INTO MACRO
Edm_Add:mov	Macins_Flag,0		; Not inserting
	mov	cl,byte ptr Temp_Macro
	shr	cl,1
	inc	cl
	cmp	cl,macrolen
	jbe	Edm_ad1
	mov	cl,macrolen

Edm_ad1:mov	Macedit_Choice,cl	; Append position=Current position+1
	mov	bx,offset MacEdA_ovr	; Prompt for INSERT COMMANDS
	jmp	Edm_ina

;================================================================
;	INSERT COMMANDS INTO MACRO
Edm_ins:mov	Macins_Flag,0ffh	; Inserting
	mov	bx,offset MacEdI_ovr	; Prompt for INSERT COMMANDS

Edm_ina:call	_kbd_cln
	mov	dx,offset Ascii_Line	; Place to gather titles
	push	dx
	call	_cmdread
	mov	dx,di
	dec	dx
	mov	bx,offset MacEd_ovr
	call	_cmdread
	pop	bx
	call	_cntrtxt

Edm_inagn:
	cmp	byte ptr Temp_Macro,macrolen	; Check room for more commands
	jc	Edm_in1
	call	_error_bell
	jmp	Edm_10

Edm_in1:mov	cl,Macedit_Choice
	call	PQR_rev

	call	rdchar			; Get new command to insert

	push	ax
	mov	cl,Macedit_Choice
	call	PQR_dim
	pop	ax

	cmp	ax,offset Escape_xcmd
	jnz	Edm_in1a
	cmp	byte ptr Temp_Macro,0
	JMP_Z	Edm_xit
	jmp	Edm_agn

;Edm_in1a:
;	cmp	ax,offset Macterm_xcmd
;	jz	Title_Macro
Edm_in1a:
	cmp	ax,offset ForcedESC_xcmd
	jnz	Edm_in1aa
	mov	ax,offset Escape_xcmd
Edm_in1aa:
	cmp	ax,offset Macterm_xcmd
	jz	Title_Macro

;................................................................
; Process backspace
	cmp	ax,offset Backspace_xcmd
	jnz	Edm_in2
	cmp	byte ptr Temp_Macro,0
	JMP_Z	Edm_Add

	cmp	Macins_Flag,0ffh	; Inserting?
	jnz	Edm_in1b
	dec	Macedit_Choice
	jnz	Edm_in1b
	inc	Macedit_Choice
Edm_in1b:
	call	_Edm_delone
	call	_Edm_Position		; Adjust Macedit_Choice
	cmp	byte ptr Temp_Macro,0
	jz	Edm_Clear
	call	_Edm_Disp
	cmp	Macins_Flag,0ffh
	JMP_Z	Edm_ins
	jmp	Edm_Add

;................................................................
; Make room in the current macro for the new string
; BX points to new string with BYTE length
Edm_in2:cmp	byte ptr Temp_Macro,macrolen
	jb	Edm_in3
	call	_error_bell
	mov	Macedit_Choice,macrolen
	jmp	Edm_10

Edm_in3:call	_Edm_inschar
	call	_Edm_Disp
	jmp	Edm_inagn

;----------------------------------------------------------------
Edm_Clear:
	mov	byte ptr Temp_Macro,0
	call	_Edm_Disp
	jmp	Edm_Add

;----------------------------------------------------------------
Edm_Title:
	mov	al,Mac2edit_Num
	call	_TitleTheMacro
	jmp	Edm_syc

;----------------------------------------------------------------
Title_Macro:
	mov	al,Mac2edit_Num
	call	_TitleTheMacro

;----------------------------------------------------------------
Edm_xit:mov	al,Mac2edit_Num
	call	_macroindex		; Index to correct macro
	mov	dx,bx			; Save pointer to macro
	mov	bx,offset Temp_Macro	; SI has temporary macro buffer
	mov	cl,[bx]			; Copy the macro
	mov	ch,0
	inc	cx
	call	_mmv16
	call	screen_init
	jmp	macro_change

Edit_Macro	endp

;************************************************
;	TIMECODE Keyboard ENTRY ROUTINE 	*
;************************************************
;Input formatted or decimal timecode value
;ENTER	DS:BX points to 3 byte buffer
;	AL has FCM
;Exit	DS:BX unchanged
;	C = 1 if CLEAR
tc_cimsg	proc	near

	; SAVE FCM
	mov	Cimsg_Fcm,al

	; Save 24bit TC buffer address
	mov	Cimsg_Pntr,bx

	; PRESET "FROM WHICH VTR" WITH CURRENT_MACHINE
	mov	al,Current_Machine
	mov	Fromwitch_Mach,al

	; CLEAR ROUTINE FLAGS
	call	read_clear		; Clear Flags

	mov	bx,offset Cimsg_Tc	; Clear out the buffer
	call	_clear_tc

	; Clear the CIMSG_STRING to 11 spaces
	mov	bx,offset Cimsg_Spaces
	mov	dx,offset Cimsg_String
	mov	ch,11
	push	dx
	call	_mmv
	pop	bx

	; If not dealing with frame numbers, format the TC string w/ colons
	cmp	Frame_Flag,0ffh
	jz	tcin_1
	mov	al,':'
	mov	[bx + 2],al
	mov	[bx + 5],al
	mov	[bx + 8],al

;----------------------------------------------------------------
; Display current TC string to screen at Kbd_Tc_Pos
tcin_1:	mov	From_Flag,0
	call	_tcline_init		; Clear and init prompt line

; Get a keypress...
tcin_2:	call	rdchar

;Try to execute FROMs, Constants, CLEAR, INs, and OUTs
tcin_4:	push	si
	call	KeyCommand_TcCimsg	; Look for a FROM, CONSTANT or CLEAR
	mov	dx,[si]
	pop	si
	jnz	tcin_4a
	call	dx
	ret

tcin_4a:
	test	Input_Flag,INFL_gpi
	jnz	tcin_5

	cmp	Trim_Ci_Flag,0ffh	; If non-zero, its trim time
	jnz	tcin_7

	cmp	ax,offset Trimin_xcmd	; Check for trim commands
	jz	tcin_4b
	cmp	ax,offset Trimout_xcmd
	jnz	tcin_5
tcin_4b:jmp	tccmg_brk

; Check for + and -
tcin_5:	cmp	al,'+'				; Trim + ?
	jz	tcin_5f
tcin_5e:cmp	al,MINUS_ASCII			; Trim - ?
	jnz	tcin_7
tcin_5f:mov	Sign_Flag,al
	cmp	Trim_Ci_Flag,0ffh
	jz	tcin_6
	test	Input_Flag,INFL_gpi
	jz	tcin_6
	mov	[si],al	; Save GPI sign
tcin_6:	mov	Cursor,offset Kbd_Tc_Pos - 1	; Address +/- screen position
	call	_ConOut				;Display + or -

tcin_7:	cmp	ax,offset Backspace_xcmd	; Check for backspace
	jnz	tcin_8
	call	_Move_Right
	jmp	tcin_1

tcin_8:	cmp	al,'0'				; Check for NUMERAL
	jc	tcin_2
	cmp	al,'9'+1
	jc	tcin_10
	jmp	tcin_2

; Store NUMERAL
tcin_10:cmp	Sign_Flag,0			; If no sign has yet been
	jnz	tcin_11				;  stored, then default
	mov	Sign_Flag,'+'			;  to a positive trim value
tcin_11:cmp	byte ptr Cimsg_String,' '
	jz	tcin_14
	cmp	byte ptr Cimsg_String,'0'
	JMP_NZ	tcin_2
tcin_14:call	_Move_Left
	mov	byte ptr Cimsg_String + 10,al
	jmp	tcin_1

tc_cimsg	endp

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
public from_r, from_a, from_b, from_c, from_d, from_e, from_f, from_aux, from_blk
fromwhat_mac	macro
local mach
mach = 0
from_r:
	mov	ch,mach
	mov	bx,offset From_R_Msg
	jmp	from_which
mach = mach + 1
from_a:
	mov	ch,mach
	mov	bx,offset From_A_Msg
	jmp	from_which
mach = mach + 1
from_b:
	if ALLOWED_VTRS GT 2
	mov	ch,mach
	mov	bx,offset From_B_Msg
	jmp	from_which
mach = mach + 1
	endif
from_c:
	if ALLOWED_VTRS GT 3
	mov	ch,mach
	mov	bx,offset From_C_Msg
	jmp	from_which
mach = mach + 1
	endif
from_d:
	if ALLOWED_VTRS GT 4
	mov	ch,mach
	mov	bx,offset From_D_Msg
	jmp	from_which
mach = mach + 1
	endif
from_e:
	if ALLOWED_VTRS GT 5
	mov	ch,mach
	mov	bx,offset From_E_Msg
	jmp	from_which
mach = mach + 1
	endif
from_f:
	if ALLOWED_VTRS GT 6
	mov	ch,mach
	mov	bx,offset From_F_Msg
	jmp	from_which
mach = mach + 1
	endif

from_aux:
	mov	ch,mach
	mov	bx,offset From_Aux_Msg
	jmp	from_which
mach = mach + 1
from_blk:
	mov	ch,mach
	mov	bx,offset From_Blk_Msg
endm

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!



;----------------------------------------------------------------
; Set FROM_WHICH_MACH as to appropriate machine
	fromwhat_mac
from_which	proc	near
	mov	Fromwitch_Mach,ch	; Save the last "from which"
	call	_frommsgs
	mov	From_Flag,0ffh		; Set FROM "active"
	jmp	tcin_2			; Go get another character
from_which	endp

;----------------------------------------------------------------
; Get the FROM IN, OUT, DURATION information
from_in	proc	near
	mov	dh,1
	mov	bx,offset Fromin_Msg
	jmp	from_iod
from_in	endp

from_out	proc	near
	mov	dh,2
	mov	bx,offset Fromout_Msg
	jmp	from_iod
from_out	endp

from_dur	proc	near
	mov	dh,3
	mov	bx,offset Fromdur_Msg
	jmp	from_iod
from_dur	endp

from_loc	proc	near
	mov	dh,4
	mov	bx,offset Fromloc_Msg
	jmp	from_iod
from_loc	endp

from_time	proc	near
	mov	dh,5
	mov	bx,offset Fromtime_Msg
	jmp	from_iod
from_time	endp

from_CrntConst	proc	near
	mov	dh,6
	mov	bx,offset Constant_Msg
	jmp	from_iod
from_CrntConst	endp

from_CrntConst0	proc	near
	mov	dh,7
	mov	bx,offset Constant_Msg
	jmp	from_iod
from_CrntConst0	endp

from_PMC	proc	near
	mov	dh,8
	mov	bx,offset Pmc_Msg
	jmp	from_iod
from_PMC	endp

;................................................................
from_iod	proc	near
	mov	From_Flag,0ffh		; Set FROM "active"

	mov	al,Current_Machine
	push	ax
	mov	dl,Fromwitch_Mach
	mov	al,dl			; Index to the FROM machine
	push	dx
	push	bx
	call	Machine_Change
	pop	bx
	pop	dx

from_1:	cmp	dh,1
	jnz	from_2
	call	_display_froms		; display from message
	call	_fwhatmsgs
	mov	bx,offset R_Tc.tcIN
	or	dl,dl			; Record?
	JMP_Z	from_Exit
	mov	bx,Current_Inbuf
	jmp	from_Exit

from_2:	cmp	dh,2
	jnz	from_3
	call	_display_froms		; display from message
	call	_fwhatmsgs
	mov	bx,offset R_Tc.tcOUT
	or	dl,dl			; Record?
	JMP_Z	from_Exit
	mov	bx,Current_Outbuf
	jmp	from_Exit

from_3:	cmp	dh,3
	jnz	from_4
	call	_display_froms		; display from message
	call	_fwhatmsgs
	mov	bx,offset R_Tc.tcDUR
	or	dl,dl
	JMP_Z	from_Exit
	mov	bx,Current_Duration
	jmp	from_Exit

from_4:	cmp	dh,4
	jnz	from_5
	call	_display_froms		; display from message
	call	_fwhatmsgs
	test	Device_Present,vlan_IOTYP
	jz	from_4a
	mov	cl,VX_PoundNum
	mov	ch,dl
	mov	ax,offset M_location_rqst	; Get new VTR IN
	call	read_DEVICE_time
	jnc	from_ex1
from_4a:mov	bx,offset Tc_Format	; Return with null
	jmp	from_ex1

from_5:	cmp	dh,5
	jnz	from_6
	call	_display_froms		; display from message
	mov	bx,offset Time_Total
	mov	cl,DF_CHAR		;es:Edl_Fcm
	jmp	from_ex1

from_6:	cmp	dh,6
	jnz	from_7
	call	_display_froms		; display from message
	mov	al,Current_Constant
from_6a:call	_constant_index		; Index BX to the proper constant
	mov	cl,NDF_CHAR
	jmp	from_ex1

from_7:	cmp	dh,7
	jnz	from_8
	call	_display_froms		; display from message
	xor	al,al			; Use constant 0
	jmp	from_6a

from_8:	cmp	dh,8
	jnz	from_9
	call	_display_froms
	mov	al,dl
	dec	al
	cbw
	mov	bx,offset Tags_Table
	add	bx,ax
	add	bx,ax
	add	bx,ax
	jmp	from_Exit

from_9:	ret

from_Exit:
	push	bx			; Pointer to SOURCE (FROM) TIME CODE
	mov	al,dl			; Get FROM MACHINE
	call	get_Vtrcb_FCM		; Get FCM
	mov	cl,al			;  to CL
	cmp	dh,3
	jnz	frmexa
	mov	Cimsg_Fcm,cl		; FIX 9-10-1990
frmexa:	pop	bx			; Restore SOURCE TIME CODE pointer

from_ex1:
	call	cimsg_convert		; Convert to string at Cimsg_String
	pop	ax			; Restore current machine
	call	Machine_Change
	jmp	read_enter
from_iod	endp

;================================================================
from_evnt	proc	near
	push	ax
	call	_check4edl			; Can we, really?
	jz	fromng
	mov	bx,Current_Event_Adr
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT
	pop	ax
	jz	from_event
	jmp	tcin_2

fromng:	pop	ax
	jmp	tcin_1		; was tcin_2
from_evnt	endp

from_event	proc	near
	mov	From_Flag,0ffh
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Event_Msg
	call	_frommsgs
	call	_rdnum			; get number
	jnc	from0
	mov	ax,dx
	call	_all_machine_keys
	jz	fromrg
	call	_Break_check
	jnz	fromlp
	jmp	tcin_1
fromrg:	mov	Fromwitch_Mach,ch
	call	_display_froms
	jmp	tcin_4
fromlp:	call	_error_bell
	jmp	from_event

from0:	or	al,al			; Check for DURATION request
	jnz	fromsd

; Process for THIS EVENT'S DURATION request
	mov	bx,Current_Event_Adr	; Check for double line
	test	es:word ptr [bx].Flags_lofst,dblline_Fmask
	mov	al,0			; Re-init DURATION byte=0
	jz	fromsd			; Jump if not double line

; Get BOTH durations
	add	bx,offset ZeroBase.rdur_lofst
	push	bx
	call	_sttime_move_ES		; Move it to a DS: buffer
	pop	bx
	add	bx,offset line_length	; Add a line
	call	_elaptm_move_ES
	call	_timadd
	call	_Sttime_move
	jmp	from_select

fromsd:	mov	dl,al			; Get number to DL
	call	from_gets
	jz	from1

	call	_getlast_Flags		; Check for double line
	test	word ptr es:[bx],dblline_Fmask
	jz	fromx

	mov	ax,es:Current_Event
	push	ax
	inc	ax
	call	_index_storage
	call	from_gets
	pop	ax
	push	bx			; Save address of TC from EDL
	pushf
	call	_index_storage
	popf
	pop	bx
	jnz	fromx
from1:	call	_sttime_move_ES		; Move it to a DS: buffer
	jmp	from_select		;  and return BX pointer

fromx:	jmp	tcin_1
from_event	endp

; Called from THIS_EVENT routine.
; Enter: DL = User request of 0 - 8 in binary
; Exit:	 ES:BX = Pointer to event time code
;	 Z = 1 if legal
from_gets	proc	near
	call	_getlast_rtcd
	mov	cl,es:[bx]
	mov	bx,offset glfg_dur
	or	dl,dl				; Duration (0)
	jz	fgret

	call	_getlast_ptcd
	mov	cl,es:[bx]
	mov	bx,offset glfg_pin
	dec	dl				; Play IN (1)
	jz	fgret

	mov	bx,offset glfg_pout
	dec	dl				; Play out (2)
	jz	fgret

	call	_getlast_rtcd
	mov	cl,es:[bx]
	mov	bx,offset glfg_rin
	dec	dl				; Record IN (3)
	jz	fgret

	mov	bx,offset glfg_rout
	dec	dl				; Record OUT (4)
	jnz	fger
fgret:	call	bx
	xor	al,al
fger:	ret
from_gets	endp

glfg_dur	proc	near
	call	_getlast_dur
	ret
glfg_dur	endp
glfg_pin	proc	near
	call	_getlast_pin
	ret
glfg_pin	endp
glfg_pout	proc	near
	call	_getlast_pout
	ret
glfg_pout	endp
glfg_rin	proc	near
	call	_getlast_rin
	ret
glfg_rin	endp
glfg_rout	proc	near
	call	_getlast_rout
	ret
glfg_rout	endp

;----------------------------------------------------------------
;		tccimsg Exit routines
;----------------------------------------------------------------

read_clear	proc	near
	mov	al,Frame_Flag		; Save the
	mov	OldframeFlag,al		;  frame Flag
	xor	al,al			; Clear Flags for:
	mov	From_Flag,al		; From "active"
	mov	Which_Type,al		; which type
	mov	Sign_Flag,al		; +/- sign Flag
	ret
read_clear	endp

; Return to caller from secondary TRIMIN or TRIMOUT mult request
tccmg_brk	proc	near
	call	_upd_getscr
	jmp	Keyboard
tccmg_brk	endp

;----------------------------------------------------------------
kbd_escape	proc	near
	call	read_enter
	call	read_clear
	cmp	Record_Flag,0ffh
	jnz	JL0636
	pop	bx			; Get rid of return
	ret				; Return to caller of caller
JL0636:	call	readen2
	call	_draw_machines
	call	_upd_getscr
	call	_evnt_dispthis
	call	_mode_upd
	jmp	Keyboard
kbd_escape	endp

;================================================================
read_enter	proc	near
	cmp	From_Flag,0ffh
	jnz	readen0
	cmp	Sign_Flag,0
	jnz	readen0
	mov	Sign_Flag,'+'

readen0:mov	dx,Cimsg_Pntr		; DX ==> 3 byte buffer
	mov	bx,offset Cimsg_String	; BX ==> ASCII TC string
	mov	cl,Cimsg_Fcm		; FCM to use
	call	_cnvt2mp_DS		; Convert from ASCII to BINARY

; MOD 100hrs or 24hrs
	cmp	Calc_Flag,0ffh
	jnz	readen1
	call	_mod100hrs
	jmp	readen2

readen1:call	_mod24hrs

	cmp	From_Flag,0ffh		; Skip if from
	jz	readen2
	call	_time_value		; Skip if not zero
	jnz	readen2

	cmp	byte ptr Cimsg_String + 10,' '
	jz	readen2
	call	readen2
	call	clear_read
	ret	

readen2:push	ax
	mov	al,OldframeFlag
	mov	Frame_Flag,al
	pop	ax
	or	al,al
	ret
read_enter	endp

clear_read	proc	near
	mov	al,OldframeFlag
	mov	Frame_Flag,al
	stc
	ret
clear_read	endp

;================================================================
from_calculator	proc	near
	mov	bx,offset Fromcalc_Msg
	call	_frommsgs
	mov	bx,offset Calcstor1
	mov	cl,NDF_CHAR
	jmp	from_select
from_calculator	endp


;================================================================
;Select a constant for loading to the Keyboard register
;
constant_select	proc	near
	call	_constant_disp
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Constant_Msg
	call	_frommsgs
	mov	al,2
	call	dec_cimsg
	jz	cnosel
	call	_convert2bin
	cmp	al,16
	ja	constant_select
	call	_constant_index		; Index BX to the proper constant
	push	bx
	call	_evnt_dispthis
	pop	bx
	mov	cl,NDF_CHAR		; Force non-drop

	cmp	Trim_Ci_Flag,0ffh	; If non-zero, its trim time
	jnz	from_select
	mov	al,Sign_Flag
	or	al,al
	jnz	from_select
	mov	byte ptr Sign_Flag,'+'
constant_select	endp


; Enter with BX pointing to a 24bit time code value
from_select	proc	near
	mov	From_Flag,0ffh
	call	cimsg_convert		; Convert to string at Cimsg_String
	cmp	Trim_Ci_Flag,0		; Is this a trim request?
	jnz	JL0750
	jmp	read_enter
JL0750:	jmp	tcin_1

cnosel:	call	_event_display		; Reset screen
	call	_kbd_clear
	call	re_kbd
	jmp	tcin_1
from_select	endp


;================================================================
frames	proc	near
	mov	dx,offset Cimsg_Tc	; Convert current
	mov	bx,offset Cimsg_String	;  string to a TC value
	mov	cl,NDF_CHAR		;(was Cimsg_Fcm)
	push	cx
	call	_cnvt2mp_DS
	pop	cx			; Restore FCM
	not	Frame_Flag		; Reverse Frame_Flag
	mov	bx,offset Cimsg_Tc
	call	cimsg_convert
	jmp	tcin_1
frames	endp


; Delete all commas from line after converting to a TC or DECIMAL string
cimsg_convert	proc	near
	mov	dx,offset Cimsg_String
	call	_cnvt2tc_DS
	cmp	Frame_Flag,0ffh		; Get rid of commas?
	jz	cmvrtr2
	mov	al,':'
	mov	[bx + 2],al
	mov	[bx + 5],al
	mov	[bx + 8],al
	ret

cmvrtr2:push	si
	add	bx,10			; Point to end of string
	mov	si,bx
	mov	cx,11			; # of characters to do
	std				; Go backwards
cmvrt1:	lodsb				; Get a byte, SI=SI-1
	cmp	al,','
	jnz	cmvrt2
	lodsb				; Get a byte, SI=SI-1
	dec	cx
cmvrt2:	mov	[bx],al
	dec	bx
	loop	cmvrt1
	pop	si
	cld
cmvrtr:	ret
cimsg_convert	endp

;================================================================
dbl_zeros	proc	near
	call	snglzro
	jnz	dblzr
	call	snglzro
dblzr:	jmp	tcin_1
dbl_zeros	endp

snglzro	proc	near
	mov	al,byte ptr Cimsg_String
	cmp	al,' '
	jz	snglz1
	cmp	al,'0'
	jnz	dblzx
snglz1:	call	_Move_Left
	mov	al,'0'
	mov	byte ptr Cimsg_String + 10,al
	xor	al,al
dblzx:	ret
snglzro	endp


;================================================================
;	CHARACTER OR NUMERIC LINE IN FROM CONSOLE
;================================================================
;ENTER:	AL = max line length
;
;Exit:	CH and AL = Line length
;	BX points to start of ascii line
;
cimsg_add_FAR	proc	far
	call	cimsg_add
	ret
cimsg_add_FAR	endp

cimsg_add	proc	near
	mov	bx,Cursor
	mov	Cimsg_Cursor,bx
	call	_Calc_EndOfString
	mov	Decflg,0
	jmp	cimsg1
cimsg_add	endp

;----------------
dec_cimsg_FAR	proc	far
	call	dec_cimsg
	ret
dec_cimsg_FAR	endp

dec_cimsg:
	mov	cl,al			; C=buffer length
	mov	Decflg,0ffh
	jmp	cimsg

;----------------
cimsg_wrk_FAR	proc	far
	call	cimsg_wrk
	ret
cimsg_wrk_FAR	endp

;================================================================
;		LINE INPUT FROM USER
; AL = Buffer length
cimsg_wrk	proc	near
	mov	cl,al			; CL = buffer length
	mov	Decflg,0		; Inicate ALPHANUMERIC
cimsg_wrk	endp

cimsg	proc	near
	mov	bx,Cursor
	mov	Cimsg_Cursor,bx
	xor	ch,ch			; Character Count = 0
	call	_Clear_Cimsg_Buffer

	mov	decimal_Count,0

cimsg1:	mov	ax,offset Temp_Wrkspce	; save top of buffer
	push	ax
	mov	Cimsg_Insert_Mode,0	; Clear flat
	call	rdloop_display
cimsg	endp

;................................................................
; Get Keyboard character
;  If requesting numbers only, Exit on SPACE, or CANCEL
rdloop	proc	near
	call	rdchar			; Get Keyboard character
	push	cx
	push	si
	push	Last_Command
	call	KeyCommand_rdloop	; Try for special command key
	pop	Last_Command
	mov	bp,[si]			; Get jump address
	pop	si
	pop	cx
	jnz	rdlncmd
	push	bp
	ret

rdlncmd:cmp	Decflg,0ffh		; Requesting number?
	JMP_NZ	rdl_TEXT		; No, so skip

	cmp	ax,offset Space_xcmd
	JMP_Z	rdloop_clear
	cmp	ax,offset Scrini_xcmd
	jz	rdloopA
	cmp	ax,offset Cancel_key
	jz	rdloopA

; 8-22-1994 
; Check for decimal
	test	Input_Flag, INFL_DECIMAL
	jz	rdlncmdc

	cmp	ax,offset Frame_xcmd	; "." 
	jz	rddecc
	cmp	ax,offset Dbl0_xcmd
	jnz	rdlncmdc
rddecc:	cmp	decimal_Count, 0
	jz	rddecd
	call	_chimes
	jmp	rdloop

rddecd:	inc	decimal_Count
	jmp	rdl_TEXT
;...

rdlncmdc:
	cmp	al,'0'			; Check for number
	jc	rdloopB
	cmp	al,'9'
	ja	rdloopB

	test	Input_Flag, INFL_DECIMAL
	jz	rdl_TEXT
	cmp	decimal_Count, 0
	jz	rdl_TEXT
	cmp	decimal_Count, 3
	jb	rdlncmdd
	call	_chimes
	jmp	rdloop
rdlncmdd:
	inc	decimal_Count
	jmp	rdl_TEXT


rdloopA:jmp	rdloop_escape

rdloopB:cmp	ax,offset Thisevent_xcmd; Check for THIS_EVENT and, if so,
	jnz	rdloopC			;  place as ASCII decimal in buffer
	cmp	Assemble_Flag,0ffh
	jnz	rdlpB1
	pop	bx
	or	al,al			; Clear Z Flag and Carry
	ret
rdlpB1:	cmp	es:Next_Avail_Num,1	; Check for EDL present
	JMP_BE	rdloop			;  and skip if NO EDL
	jmp	rd_evnum

;...
rdloopC:test	Input_Flag,INFL_gpi	; GPI Request?
	jz	rdloopD
	cmp	ax,offset GPI_xcmd
	jnz	rdloopD
	jmps	rdpopstcret

rdloopD:test	Input_Flag,INFL_const	; Constant?
	jz	rdloopE
	cmp	ax,offset Const_xcmd
	jnz	rdloopE
rdpopstcret:
	pop	bx			; Restore buffer pointer
	stc				; Set carry
	ret

rdloopE:test	Input_Flag,INFL_speed	; SPD Request?
	jz	rdloopF
	cmp	al,'+'
	jz	rdl_TEXT
	cmp	al,MINUS_ASCII
	jz	rdl_TEXT

rdloopF: ;Spare

rdloopZ:call	keythru
	jmp	rdloop

rdl_TEXT:
	cmp	ch,cl
	jc	strch
strch0:	call	_error_bell
	jmp	rdloop

;buffer not full, store character if legal
strch:	cmp	al,' '
	jc	strch0
	cmp	al,127
	ja	strch0
	call	cimstor
	jmp	rdloop

exitrd:	call	_Cursor_off
	dim_VIDEO FALSE,FALSE

	mov	al,ch			; Get line length to a
	pop	bx			; Restore buffer pointer
	push	bx
	mov	ch,0			; CH is counter, CL is max length
erdcst1:cmp	byte ptr [bx],0		; Find end of line
	jz	erdcstx
	inc	ch
	inc	bx
	dec	cl			; Can't do more than max length
	jnz	erdcst1
erdcstx:mov	word ptr [bx],0		; Make sure its terminated
	pop	bx
	mov	cl,ch
	mov	al,ch
	or	al,al			; Clear carry/set z if n line
	ret

;----------------------------------------------------------------
;----------------------------------------------------------------
;		LINE INPUT ACTION KEY ROUTINES
rdloop_clear:
	call	_Clear_Cimsg_Buffer
	mov	ch,0
	or	ch,ch			; Set Z
	stc				; Set C
	pop	bx
	ret

rdloop_enter:
	jmp exitrd

rdloop_escape:
	or	ch,ch			; If there are characters in line
	jnz	rdloop_ctrlx		;  clear them out
	mov	ERROR_ACTIVE,0		; Signal file error
	jmp	rdloop_clear

;	call	_evnt_dispthis
;	mov	ERROR_ACTIVE,0		; Signal file error
;	jmp	Keyboard

rdloop_ctrlx:
	call	_Clear_Cimsg_Buffer
	mov	ch,0
	call	rdloop_display
	jmp	rdloop

rdloop_sol:
	mov	ch,0
	mov	bx,offset Temp_Wrkspce
	call	rdloop_display
	jmp	rdloop

rdloop_eol:
	mov	al,cl
	call	_Calc_EndOfString
	call	rdloop_display
	jmp	rdloop

rdloop_insert:
	not	Cimsg_Insert_Mode
	jmp	rdloop

rdloop_delete:
	call	rd_delete
	call	rdloop_display
	jmp	rdloop

rdloop_back:
	cmp	ch,0
	JMP_Z	rdlbkx
	dec	ch
	dec	bx
	call	rdloop_display
	jmp	rdloop

rdloop_forward:
	cmp	ch,cl
	jz	rdlfwx
	cmp	byte ptr [bx],0
	jz	rdlfwx
	inc	bx
	inc	ch
	call	rdloop_display
rdlfwx:	jmp	rdloop

rdloop_oldstring:
	push	si
	mov	si,Filename_Ptr
	or	si,si
	jz	olfx
olf1:	lodsb
	or	al,al			; End of string?
	jz	olfx
	cmp	al,cr
	jz	olfx
; Allow for periods in notes
	cmp	Cimsgadd_Flag,0ffh
	jz	olf2
	cmp	al,'.'
	jz	olfx

olf2:	cmp	ch,cl
	jnc	olfer
	mov	[bx],al
	call	_ConOut
	inc	bx
	inc	ch
	jmp	olf1
olfx:	pop	si
	jmp	rdloop
olfer:	pop	si
	call	_error_bell
	jmp	rdloop

rdloop_dblzero:
	push	ax
	mov	al,cl
	sub	al,ch
	cmp	al,2			; Error if not at least 2 chars remain
	pop	ax
	jnc	cimdbl0
	call	_error_bell
	jmp	rdloop

cimdbl0:mov	al,'0'
	push	ax
	call	cimstor
	pop	ax
	call	cimstor
	jmp	rdloop

rdloop_backspace:
	call	backsp
	cmp	decimal_Count,0
	jz	rdlbkx
	dec	decimal_Count
rdlbkx:	jmp	rdloop

;................................................................
rd_delete:
	cmp	ch,cl			; At end of buffer?
	jz	rddel3
	cmp	byte ptr [bx],0		; At end of string?
	jz	rddel3
	push	bx
	push	cx
	push	si
	sub	cl,ch			; Remaining bytes in buffer = 
	mov	ch,0			;  buffer length - current position
	mov	si,bx
	inc	si			; SI points to buffer position
rddel1:	lodsb
	mov	[bx],al
	inc	bx
	or	al,al
	jz	rddel2
	loop	rddel1
rddel2:	pop	si
	pop	cx
	pop	bx
rddel3:	ret
rdloop	endp

;................................................................
rdloop_display	proc	near
	push	cx
	mov	ax,Cimsg_Cursor
	mov	Cursor,ax

	rev_VIDEO FALSE,FALSE
	mov	bx,offset Temp_Wrkspce

	push	bx
	call	_comsg
	dec	bx
	pop	cx
	sub	bx,cx			; BX = length of line

	pop	cx			; Get CX values
	push	cx			;  and resave them
	mov	ch,0			; Dont want the string position
	sub	cx,bx
	jz	rdlpdp1

	mov	al,' '
	mov	bx,Cursor		; Get Cursor
	call	_hl_lp
rdlpdp1:pop	cx
	mov	bx,Cimsg_Cursor		; Get start Cursor
	mov	al,ch			; Get character position
	mov	ah,0
	add	bx,ax			; Adjust position
	mov	Cursor,bx
	mov	bx,offset Temp_Wrkspce
	add	bx,ax
	ret
rdloop_display	endp

;................................................................
; Return ASCII equivalent of this event number
rd_evnum	proc	near
	cmp	ch,cl
	jc	rdevnm1
	call	_error_bell
	jmp	rdloop

rdevnm1:mov	Temp_Tc_Buf,bx		; Set pointer
	mov	bx,Current_Event_Adr
	mov	bx,es:[bx]		; Get event number

	push	bx			; Put ASCII event number
	call	_make_dec		;  to Temp_Wrkspce
	pop	bx

	call	_DecOut			; Display number

	mov	bx,Temp_Tc_Buf		; Calculate
	push	bx			;  the length
	sub	bx,offset Temp_Wrkspce	;  of the string
	mov	ch,bl			;  = end position - start position
	pop	bx			; Restore current string pointer
	jmp	exitrd
rd_evnum	endp

;................................................................
cimstor	proc	near
	cmp	Cimsg_Insert_Mode,0ffh	; Insert ON?
	jnz	cimstr1
	cmp	byte ptr [bx],0		; Appending to end of string?
	jz	cimstr1

	push	cx
	push	bx
	mov	ch,0
	mov	bx,offset Temp_Wrkspce
	add	bx,cx
	cmp	byte ptr -1[bx],0	; String full?
	pop	bx
	pop	cx
	jnz	cimster

	push	cx
	push	si
	push	di
	push	es
	push	ds
	pop	es

	sub	cl,ch			; Remaining bytes in buffer = 
	mov	ch,0			;  buffer length - current position

	mov	si,bx
	add	si,cx
	mov	di,si
	dec	si
	std
	rep	movsb
	cld
	pop	es
	pop	di
	pop	si
	pop	cx
	mov	[bx],al
	inc	bx
	inc	ch
	call	rdloop_display
	ret

cimstr1:mov	[bx],al
	inc	bx
	inc	ch
	call	_ConOut
	push	bx
	push	dx
	mov	dx,Cursor
	mov	ah,2
	mov	bh,0
	int	10h
	pop	dx
	pop	bx
	ret

cimster:call	_error_bell
	ret
cimstor	endp

;================================================================
rdchar_FAR	proc	far
	call	rdchar
	ret
rdchar_FAR	endp

rdchar	proc	near
	push	bx
	push	dx
	push	cx
rdchar0:xor	ah,ah

	if COPY_PROTECT
	CHECKFORKEY	Flag3,1
	ENDIF

	cmp	Suspend_Flag,0ffh	; Suspend on?
	jz	rdchar3			; If ON, don't get macro character

	mov	dx,RunningCMD_Cnt	; Get the Count of characters in buffer
	or	dx,dx			; Any there?
	jz	rdchar3			; No, get one from the console
	mov	ah,0bh			; Check for CONTROL-Break
	int	DOS			; 5/16/88

	dec	dx			; Decrement available char Count
	dec	dx
	mov	RunningCMD_Cnt,dx	; Save the new char Count
	mov	bx,RunningCMD_Ptr	; Get the current
	mov	cx,[bx]			; Character to C
	inc	bx			; Increment pointer in command buffer
	inc	bx
	mov	RunningCMD_Ptr,bx

	or	dx,dx			; Any chars left after this one
	jnz	rdchar1			; If not zero, skip next two lines
	mov	RunningCMD_Cnt,dx
	mov	bx,offset RunningCMD_Buf
	mov	[bx],dx
	inc	bx
	inc	bx
	mov	RunningCMD_Ptr,bx

rdchar1:mov	ax,cx			; Get the characters
	call	keytrans
	cmp	ax,offset Suspend_key	; Suspend input?
	jnz	rdchar2
	mov	Suspend_Flag,0ffh	; Set suspend ON
	jmp	rdchar3

rdchar2:or	ax,ax			; And check it out
	jnz	JL0785

rdchar3:call	_Cursor_On
	call	rdwait			; If no chars, get from console
	call	_Cursor_off
	cmp	Macrecord_Flag,0ffh
	jnz	JL0785
	cmp	ax,offset Macterm_xcmd
	jz	MacRec_term
	cmp	byte ptr Record_Macro,macrolen
	jz	MacRec_term
	call	macro_record
JL0785:	cmp	ax,offset Enter_xcmd
	jnz	rdchar1a
	cmp	Suspend_Flag,0ffh	; Suspend on?
	jnz	rdchar1a
	mov	Suspend_Flag,0
	jmp	rdchar0
rdchar1a:
	pop	cx
	pop	dx
	pop	bx
	ret
rdchar	endp

;================================================================
macro_record	proc	near
	pushf
	cmp	Macrecord_Flag,0ffh
	jnz	mrtx
	cmp	ax,offset Macterm_xcmd
	jz	MacRec_term
	cmp	byte ptr Record_Macro,macrolen
	jz	MacRec_term
	push	si
	push	cx
	mov	si,offset Record_Macro	; Point to temporary buffer
	mov	cl,[si]
	inc	byte ptr [si]
	inc	byte ptr [si]
	inc	si
	mov	ch,0
	add	si,cx
	mov	[si],ax			; Store character
	pop	cx
	pop	si
mrtx:	popf
	ret
macro_record	endp

MacRec_term	proc	near
	mov	Macrecord_Flag,0
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di

	call	clearmacro_message

	mov	al,Decflg		; Save decFlag
	mov	ah,Video_Mode
	push	ax
	push	Cursor

	push	es
	push	ds
	mov	dx,1800h
	call	_sram_dx
	mov	si,di
	mov	di,offset Temp_Vidbuf
	mov	cx,80
	push	es
	push	ds
	pop	es
	pop	ds
	rep movsw
	pop	ds
	pop	es

	mov	bx,offset Temp_Wrkspce
	mov	dx,offset Temp_Tempbuf
	mov	cx,128
	call	_mmv16

	mov	al,Mac2record2
	call	_macroindex
	mov	dx,bx
	mov	bx,offset Record_Macro
	mov	cl,[bx]
	mov	ch,0
	inc	cx
	call	_mmv16
	mov	al,Mac2record2
	call	_TitleTheMacro

	mov	bx,offset Temp_Tempbuf
	mov	dx,offset Temp_Wrkspce
	mov	cx,128
	call	_mmv16

	push	es
	mov	dx,1800h
	call	_sram_dx
	mov	si,offset Temp_Vidbuf
	mov	cx,80
	rep movsw
	pop	es

	pop	Cursor
	pop	ax
	mov	Decflg,al		; Save decFlag
	mov	Video_Mode,ah
	call	_Cursor_off
;;	cmp	Cursor,1800h		; Are we on the bottom line?
;;	jc	Mrtnc
;;	call	_Cursor_on
Mrtnc:	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	jmp	rdchar3
MacRec_term	endp

;================================================================
; Get (wait for) character from Keyboard
rdwait	proc	near
	mov	ah,11h
	int	16h
	jnz	keyget
	cmp	Fullscreen_Flag,0ffh
	jz	rdwait
	push	Cursor
	push	word ptr Video_Mode
	push	bx
	push	cx
	push	dx
	push	si
	push	di
	call	time_date
	call	locations
	call	joystick
	call	jogger
	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	word ptr Video_Mode
	pop	Cursor
	jmp	rdwait
rdwait	endp

;================================================================
; Programmed Pause.  Just waits for a keypress.
;  Automatically aborts running macro if CTRL-Break or ESCAPE
; Else just returns and continues.
; Keypress is NOT interpreted for command
macro_pause	proc	near
	mov	bx,offset Pagend_Msg
	call	_kbd_message
	call	keyhold
	or	ax,ax			; Check for CTRL-Break
	jz	mcropsc
	cmp	ax,offset Escape_xcmd
	jnz	mcropsx
mcropsc:mov	RunningCMD_Cnt,0		; Clear out macro command reg.
	jmp	Keyboard
mcropsx:ret
macro_pause	endp


;================================================================
_cstat_FAR	proc	far
	call	cstat
	ret
_cstat_FAR	endp

;check console status, and
;return with z set if no character ready
cstat	proc	near
	mov	ah,11h			; Keyboard status AT
	int	16h
	jnz	keyget
	xor	ax,ax
	ret
cstat	endp

keywait	proc	near
	mov	ah,11h
	int	16h
	jnz	keyget
	call	joystick
	call	jogger
	jmp	keywait
keywait	endp

keyhold_FAR	proc	far
	call	keyhold
	ret
keyhold_FAR	endp

keyhold	proc	near
	call	_Cursor_On
	call	keyget
	call	_Cursor_off
	ret
keyhold	endp

keyget	proc	near
	pushf
	mov	ah,10h
	int	16h
	call	keytrans
	popf
	ret
keyget	endp

keytrans	proc	near
	push	cx
	push	si
	mov	si,offset Xlt_Tbl
	mov	cx,ax
keytrnl:lodsw
	cmp	ax,cx
	jz	keytrn1
	inc	ax
	jz	keytrnx
	inc	si
	inc	si
	jmp	keytrnl
keytrn1:lodsw
	mov	cx,ax
keytrnx:mov	ax,cx
	pop	si
	pop	cx
	ret
keytrans	endp

; Backspace and pull up
backsp	proc	near
	or	ch,ch
	jz	backspx
	cmp	byte ptr [bx],0
	jz	backsp1
	dec	ch
	dec	bx
	call	rd_delete
	call	rdloop_display
	ret

backsp1:dec	bx
	mov	byte ptr [bx],0
	call	_backspace
	dec	ch
	push	Cursor
	mov	al,' '
	call	_ConOut
	pop	Cursor
backspx:ret
backsp	endp

get_ucase	proc	near
	call	rdchar
	call	_make_ucase
	ret
get_ucase	endp

;****************************************************************
;Get a range of edit lines.
;User enters start and end line, or optionally gets the current
;and the last line respectively as a default.
;Exit:	Starting_Number = Starting line number
;	Ending_Number	= Ending line number
;****************************************************************
get_range	proc	near
	push	bx
	mov	ERROR_PROMPT,bx
	mov	bx,Cursor
	mov	ERROR_Cursor,bx
	pop	bx

	call	_kbd_cln
	call	_msgread
	mov	ax,es:Current_Event
	mov	Temp_Event,ax
	call	idx2nxt

	mov	bx,Cursor
	mov	ERROR_Cursor,bx
	mov	bx,offset starting_ovr
	call	getrngn
	JMP_C	getabrt
	jnz	getran1

	mov	bx,Current_Event_Adr
	mov	dx,es:[bx]		; Get edit number
	xchg	bx,dx
	call	_DecOut
	xchg	bx,dx

getran1:xchg	bx,dx
	mov	Starting_Number,bx
	call	_find_edit_BX
	mov	Block_Start,ax		; 10-08-1990
	jz	JL0805
	ERROR	out_of_range, ERET_Return
	mov	bx,ERROR_Cursor
	mov	Cursor,bx
	call	_line_erase
	mov	bx,ERROR_PROMPT
	jmp	get_range

JL0805:	mov	bx,offset ending_ovr
	call	getrngn
	jc	getabrt
	jnz	getran2

	push	es:Current_Event
	mov	ax,es:Next_Avail_Num
	dec	ax
	call	idx2lst
	mov	dx,es:[bx]		; Get edit number
	xchg	bx,dx
	call	_DecOut
	xchg	bx,dx
	pop	ax
	call	_index_storage
getran2:xchg	bx,dx
	mov	Ending_Number,bx
	call	_find_edit_BX
	mov	Block_End,ax		; 10-08-1990
	mov	ax,Temp_Event
	jz	getrnbd
	call	_index_storage
	ERROR	out_of_range, ERET_Return
	mov	bx,ERROR_Cursor
	mov	Cursor,bx
	call	_line_erase
	mov	bx,ERROR_PROMPT
	jmp	get_range

getabrt:jmp	Keyboard

; Get a range number, message in BX
getrngn:norm_VIDEO FALSE,FALSE
	call	_msgread
	mov	al,4
	call	dec_cimsg
	jz	getrnbd
	call	_convert2bin
getrnbd:ret
get_range	endp

;Index to the next event in the list.
;If the next event is a comment, then skip on
;until an edit is found.
;If no edits exist, go backwards
idx2nxt	proc	near
	call	_index_storage
	jnc	idx2nxtx
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jc	idx2nxt
	dec	ax
idx2lst:call	_index_storage
	jnc	idx2nxtx
	dec	ax
	jnz	idx2lst
	inc	ax
idx2nxtx:
	ret
idx2nxt	endp

;**********************************
; M A C R O   O P E R A T I O N S
;**********************************
;Let operator alter one of the 10 macro registers, or the default macro
mac_setdflt	proc	near
	call	_clear_screen
	mov	Fullscreen_Flag,0ffh
	mov	Macedit_Choice,1	; Start at top of macro
	mov	Mac2edit_Num,0ffh
	jmp	Edm_Dfl
mac_setdflt	endp

;................................................................
mac_goselect	proc	near
		jmp	macro_select
mac_goselect	endp

mchxit	proc	near
		call	_evnt_dispthis
		MOV	ERROR_ACTIVE,0
		ret
mchxit	endp

_mac_savej	proc	near
		call	_mac_save
		jmp	macro_change
_mac_savej	endp
_mac_loadj	proc	near
		call	_mac_load
		jmp	macro_change
_mac_loadj	endp

mac_clearj	proc	near
		call	_macro_clear
mac_clearj	endp

macro_change	proc	near
	mov	Input_Flag,INFL_menu

	call	_macros_disp		; Display the macros
	call	_kbd_cln
	mov	bx,offset macromenu_ovr
	call	_msgread

mchagn:	call	_rdnum
	jnc	JL0245

	call	_Break_check
	jz	mchxit
	cmp	ax,offset Enter_xcmd
	jz	mchxit
	cmp	ax,offset Macch_xcmd
	jz	mchxit
	cmp	dx,offset Macro_xcmd	; Execute macro?
	jz	mac_goselect
	call	_make_ucase
	cmp	al,'D'
	jz	mac_setdflt
	cmp	al,'S'
	jz	_mac_savej
	cmp	al,'L'
	jz	_mac_loadj
	cmp	al,'C'
	jz	mac_clearj

	cmp	al,'R'
	jnz	mchagn2
; Select macro to record to
	call	_kbd_cln
	mov	bx,offset macromsg_ovr	; Get macro number to edit
	call	_msgread
	call	_rdnum
	jnc	mchagn1
	mov	ax,dx
	call	_Break_check
	jz	mchagn
	jmp	mchagn2

mchagn1:mov	Macrecord_Flag,0ffh
	mov	Mac2record2,al
	mov	byte ptr Record_Macro,0
	call	learnmacro_message
	jmp	mchxit

mchagn2:call	keythru

	call	_error_bell
	jmp	mchagn

JL0245:	mov	Macedit_Choice,1	; Start at top of macro
	jmp	Edm_1
macro_change	endp


learnmacro_message	proc	near
	cmp	Macrecord_Flag,0ffh
	jnz	kbdner1
	push	Cursor
	mov	al,Video_Mode
	push	ax
	mov	Cursor,0040h
	blink_VIDEO FALSE,FALSE
	mov	bx,offset Learnmac_Msg
	call	_comsg
	pop	ax
	mov	Video_Mode,al
	pop	Cursor
kbdner1:ret
learnmacro_message	endp

clearmacro_message	proc	near
	push	bx
	push	Cursor
	mov	bx,0040h
	call	_dircur_lerase
	pop	Cursor
	pop	bx
	ret
clearmacro_message	endp

;================================================================
; Macro execution

xmac1	proc	near
	mov	al,1
	jmp	macrosavr
xmac1	endp
xmac2	proc	near
	mov	al,2
	jmp	macrosavr
xmac2	endp
xmac3	proc	near
	mov	al,3
	jmp	macrosavr
xmac3	endp
xmac4	proc	near
	mov	al,4
	jmp	macrosavr
xmac4	endp
xmac5	proc	near
	mov	al,5
	jmp	macrosavr
xmac5	endp
xmac6	proc	near
	mov	al,6
	jmp	macrosavr
xmac6	endp
xmac7	proc	near
	mov	al,7
	jmp	macrosavr
xmac7	endp
xmac8	proc	near
	mov	al,8
	jmp	macrosavr
xmac8	endp
xmac9	proc	near
	mov	al,9
	jmp	macrosavr
xmac9	endp
xmac10	proc	near
	mov	al,0
	jmp	macrosavr
xmac10	endp

macrosavr	proc	near
	call	_macrosav
	ret
macrosavr	endp

macro_select	proc	near
	cmp	RunningCMD_Cnt,0
	jnz	ML0280

	mov	Input_Flag,INFL_menu
	call	_macros_disp

	mov	bx,offset Execute_Msg
	call	_kbd_message
	mov	bx,offset macromsg_ovr	; And display
	call	_msgread		; MACRO prompt

ML0280:	call	_rdnum			; Get a number and return
	jnc	msj_cmd
	call	_Break_check
	jz	msjx
	cmp	dx,offset Macch_xcmd	; Goto the programming menu?
	jz	ML0285
	call	keythru
	jmp	macro_select

msj7:	jmp	ML0280
msjx:	call	_evnt_dispthis
	ret
macro_select	endp

msj_cmd	proc	near
	call	_macroindex
	push	ax
	push	bx
	mov	al,[bx]			; Get length
	mov	ah,0
	add	bx,ax
	cmp	word ptr [bx],offset Macro_xcmd
	jz	msj8
	call	_evnt_dispthis
msj8:	pop	bx
	pop	ax
	call	_macsaver
	ret

ML0285:	jmp	macro_change
msj_cmd	endp

;================================================================
; CL has default answer
; Return Z if YES, NZ if NO
; Carry SET if Break key used
yn_chos_FAR	proc	far
	call	yn_chos
	ret
yn_chos_FAR	endp

no_chos_msg_FAR	proc	far
	call	no_chos_msg
	ret
no_chos_msg_FAR	endp

pos_yn_chos_FAR	proc	far
	call	pos_yn_chos
	ret
pos_yn_chos_FAR	endp


no_chos_msg	proc	near
	mov	cl,'N'
no_chos_msg	endp

pos_yn_chos	proc	near
	call	_kbd_cln
	call	_msgread
pos_yn_chos	endp

yn_chos	proc	near
	dim_VIDEO FALSE,FALSE
	push	bx
	mov	bx,offset yn_ovr
	call	_msgread
	pop	bx
	mov	al,'['
	call	_ConOut
	norm_VIDEO FALSE,FALSE
	push	Cursor
	mov	al,cl
	call	_ConOut
	dim_VIDEO FALSE,FALSE
	mov	al,']'
	call	_ConOut
	pop	Cursor

yn_ch1:	call	_chimes

yn_ch2:	call	rdchar			; Get operator response
	call	_Break_check
	jz	ynexit
	cmp	ax,offset Enter_xcmd
	jz	yn_ch5

	cmp	ax,offset Yeskey_xcmd
	jz	yn_ch3
	cmp	ax,offset Nokey_xcmd
	jz	yn_ch4

	call	_make_ucase
	cmp	al,'Y'
	jz	yn_ch3

	cmp	al,'N'
	jz	yn_ch4
	call	_chimes
	jmp	yn_ch2

yn_ch3:	mov	al,'Y'
	jmp	yn_ch6

yn_ch4:	mov	al,'N'
	jmp	yn_ch6

yn_ch5:	mov	al,cl			; Move default
yn_ch6:	call	_make_ucase
	cmp	al,'Y'			; Affirmative?
	jnz	JL0110
	rev_VIDEO TRUE,TRUE
	call	_ConOut
	dim_VIDEO TRUE,TRUE
JL0110:	clc
	ret

; Abort Fix...
ynexit:	or	ax,ax			; Return NZ
	stc
	ret
yn_chos	endp

;================================================================
;================================================================
;			POSITION QUERY
;================================================================
position_query_FAR	proc	far
	call	position_query
	ret
position_query_FAR	endp

posbad	proc	near
		jmp	Badcrash_FAR
posbad	endp
position_query	proc	near
	cmp	byte ptr PointShootData.PQ_rows,0	;Some protection (against what?)
	jz	posbad
	cmp	byte ptr PointShootData.PQ_field,0
	jz	posbad

;...
	call	_kbd_cln

	mov	dx,offset Ascii_Line	; Place to gather titles

	mov	bx,offset INSTLcmd_ovr
	call	_cmdread
	mov	dx,di
	dec	dx

	test	PointShootData.PQ_Flag,PQF_MACRO	; Special for edit_macro
	jz	PQR_nc1
	mov	bx,offset INSTLmac_ovr
	call	_cmdread
	mov	dx,di
	dec	dx

	jmp	PQR_nta

PQR_nc1:test	PointShootData.PQ_Flag,PQF_YESNOTGL	; Allow toggle and Y/N?
	jz	PQR_nt
	mov	bx,offset INSTLtgl_ovr
	call	_cmdread
	mov	dx,di
	dec	dx

PQR_nt:	mov	bx,offset INSTLplus_ovr
	call	_cmdread

PQR_nta:mov	bx,offset Ascii_Line
	call	_cntrtxt

	mov	ch,cl
	jmp	PQR_frs

PQR_agn:xchg	ch,cl
	call	PQR_dim	; Normal previous
	mov	cl,ch
PQR_frs:call	PQR_rev	; Display in reverse
	norm_VIDEO FALSE,FALSE

PQR_sel:call	rdchar
	call	_Break_check
	jz	PQR_sled
	cmp	ax,PointShootData.PQ_exitkey
	jnz	PQR_sok
PQR_sled:
	mov	PointShootData.PQ_keypressed,ax
	stc
	ret

PQR_sok:test	PointShootData.PQ_Flag,PQF_MACRO	; Special for edit_macro
	jz	PQR_s1
	cmp	ax,offset DelEv_xcmd
	JMP_Z	PQR_xit
	cmp	ax,offset InsEv_xcmd
	JMP_Z	PQR_xit
	cmp	ax,offset Colonplus_xcmd
	JMP_Z	PQR_xit
	cmp	ax,offset Backspace_xcmd
	JMP_Z	PQR_xit
	cmp	ax,offset Clrrd_xcmd
	JMP_Z	PQR_xit
	cmp	ax,offset Title_xcmd
	JMP_Z	PQR_xit
	cmp	ax,offset Cmnt_xcmd
	JMP_Z	PQR_xit

PQR_s1:	push	cx
	call	KeyCommand_PQ
	pop	cx
	jnz	PQR_ncm
	jmp	[si]

PQR_ncm:cmp	ax,offset Enter_xcmd
	jz	PQR_xit

; 10-05-1990 Added "y" and "n" return, if desired
	test	PointShootData.PQ_Flag,PQF_YESNOTGL	; Check for Yes/No allowed as YN
	jz	PQR_nyn
	cmp	al,'y'
	jz	PQR_yyn
	cmp	al,'n'
	jz	PQR_yyn
	cmp	al,'t'
	jnz	PQR_nyn
PQR_yyn:call	_make_ucase
	xor	ah,ah
	jmp	PQR_xit

PQR_nyn:test	PointShootData.PQ_Flag,PQF_PAGING	; Check for paging bit in Flag
	jz	PQR_kfl
	cmp	ax,offset Pageup_key
	jz	PQR_xit
	cmp	ax,offset Pagedn_key
	jz	PQR_xit
PQR_kfl:test	PointShootData.PQ_Flag,PQF_KILLFILE	; Kill file alloweed?
	jz	PQR_ktv
	cmp	ax,offset DelEv_xcmd
	jz	PQR_xit

PQR_ktv:cmp	ax,offset Viewedl1_key
	jz	PQR_xit
	cmp	ax,offset Viewedl2_key
	jz	PQR_xit

; Test for LOAD FILE REQUEST FlagS AND KEY
	test	PointShootData.PQ_Flag,PQF_LOAD		; Load file request?
	jz	PQR_nlf
	cmp	ax,offset Lodfl_xcmd
	jz	PQR_xit
	jmp	PQR_sel

; Test for SAVE FILE REQUEST FlagS AND KEY
PQR_nlf:test	PointShootData.PQ_Flag,PQF_SAVE		; Save file request?
	jz	PQR_kth
	cmp	ax,offset Savfl_xcmd
	jz	PQR_xit

PQR_kth:test	PointShootData.PQ_Flag,PQF_KEYTHRU	; Keythru allowed?
	JMP_Z	PQR_sel
	call	keythru
	jmp	PQR_sel

PQR_xit:push	ax
	call	PQR_dim
	pop	ax
	mov	PointShootData.PQ_keypressed,ax
	; Normal selection of multi page file directories
	test	PointShootData.PQ_Flag,PQF_PAGING	; Check for paging
	jz	PQR_xt1
	add	cl,Dirpgtop		; Offset to correct file
PQR_xt1:clc
	ret

PQR_nm:	call	PQR_dim	; Normal previous

; Fix for numerical input of multi page file directories
	mov	bx,offset Select1to_Msg
	test	PointShootData.PQ_Flag,PQF_PAGING	; Check for paging
	jz	PQR_nm0
	mov	bx,offset Selectfile_Msg
PQR_nm0:call	_kbd_message

	test	PointShootData.PQ_Flag,PQF_ALLOWZERO	; Check for 0 ALLOWED
	mov	al,0
	jnz	PQR_nm01
	inc	al
PQR_nm01:
	call	_A_DecOut
PQR_nm02:
	mov	bx,offset Mcrosep
	call	_comsg

	mov	al,PointShootData.PQ_choices
	test	PointShootData.PQ_Flag,PQF_ALLOWZERO	; Check for 0 ALLOWED
	jz	PQR_nm03
	dec	al
PQR_nm03:
	test	PointShootData.PQ_Flag,PQF_PAGING	; Check for paging
	jnz	PQR_nm0a
	call	_A_DecOut
	mov	al,':'
	call	_ConOut
PQR_nm0a:
	mov	al,3
	push	cx
	call	dec_cimsg
	pop	cx
	jnz	PQR_nm1

	test	PointShootData.PQ_Flag,PQF_ALLOWZERO	; Check for 0 ALLOWED
	jnz	PQR_nm2

	jmp	position_query	; loop for another keystroke

PQR_nm1:call	_convert2bin

	test	PointShootData.PQ_Flag,PQF_ALLOWZERO
	jnz	PQR_nm2

	or	al,al
	jz	PQR_nmr

; Fix for numerical input of multi page file directories
	test	PointShootData.PQ_Flag,PQF_PAGING	; Check for paging
	jz	PQR_nmp
	cmp	cl,Dirfiles		;  Are there less files in the
	jbe	PQR_nm2

PQR_nmp:cmp	dl,PointShootData.PQ_choices
	jbe	PQR_nm2
PQR_nmr:jmp	position_query
PQR_nm2:xor	ax,ax
	mov	cl,dl
	clc
	ret

; Enter with CL having last choice number.
PQR_hom:mov	cl,1
	jmp	PQR_sela
PQR_end:mov	cl,PointShootData.PQ_choices
	jmp	PQR_sela
PQR_dn:	inc	cl
	jmp	PQR_sela
PQR_up:	dec	cl
	jmp	PQR_sela
PQR_rht:add	cl,PointShootData.PQ_rows	;9
	jmp	PQR_sela
PQR_lft:sub	cl,PointShootData.PQ_rows	;9
	jns	PQR_sela
	add	cl,PointShootData.PQ_choices	;27

PQR_sela:
	or	cl,cl		; If choice = 0
	jz	PQR_selc	;  then go to last position
	mov	al,PointShootData.PQ_choices	; Get # of available choices
	inc	al		; Increment the value
	cmp	cl,al		; Is it less than max choices + 1?
	jc	PQR_seld	; Ok if so
	dec	al
	cmp	cl,PointShootData.PQ_choices	; Is it the last position?
	jz	PQR_selb	;  then move to first position
PQR_sela1:
	sub	cl,PointShootData.PQ_rows
	mov	al,PointShootData.PQ_rows
	inc	al
	cmp	cl,al
;;;	jnc	PQR_sela1
	jnc	PQR_selb
	jmp	PQR_sela

PQR_selb:
	mov	cl,1		; Index to first selection
	jmp	PQR_seld
PQR_selc:
	mov	cl,PointShootData.PQ_choices	; Index to last selection
PQR_seld:
	jmp	PQR_agn

PQR_rev:rev_VIDEO FALSE,FALSE
	call	PQR_pos
	push	es
	push	di
	push	cx
	call	_screen_ram
	mov	cl,PointShootData.PQ_field
	xor	ch,ch
	call	PQR_sav
	mov	al,Video_Mode
	or	al,Color_BKG
	inc	di
PQR_dlp:stosb
	inc	di
	loop	PQR_dlp
	pop	cx
	pop	di
	pop	es
	ret

PQR_sav:push	di
	push	cx
	mov	si,offset ScreenLineBuf
PQR_sal:mov	ax,es:[di]
	mov	[si],ax
	inc	si
	inc	si
	inc	di
	inc	di
	loop	PQR_sal	
	pop	cx
	pop	di
	ret

PQR_dim:call	PQR_pos
	push	es
	push	di
	push	cx
	call	_screen_ram
	mov	cl,PointShootData.PQ_field
	xor	ch,ch
	mov	si,offset ScreenLineBuf
	rep movsw
	pop	cx
	pop	di
	pop	es
	ret

; Position Cursor to cl
PQR_pos:push	cx
	mov	bx,PointShootData.PQ_Cursor
	mov	al,PointShootData.PQ_rows	; Get # of rows
PQR_pos1:
	cmp	cl,al		; In this column?
	jbe	PQR_pos4
	add	bl,PointShootData.PQ_tab	; Add in 1 column tab offset
	add	al,PointShootData.PQ_rows	; Add in another rows worth
	jmp	PQR_pos1

; Found column, AL has end choice in column, CL has choice
PQR_pos4:
	sub	al,PointShootData.PQ_rows	; Index to the top of the row
	sub	cl,al		; Get row offset to AL
	dec	cl
	add	bh,cl		; Add in row offset
	pop	cx
	mov	Cursor,bx	; Set Cursor
	ret
position_query	endp

;================================================================
;		CHECK FOR IMPORTANT KEYS
keythru_FAR	proc	far
	call	keythru
	ret
keythru_FAR	endp

keythru	proc	near
	push	ax
	push	cx
	push	dx
	push	si
	call	KeyCommand_main
	jz	kt_ok
	pop	si
	pop	dx
	pop	cx
	pop	ax
	ret

kt_ok:	call	_macone
	jmp	Keyboard
keythru	endp

;================================================================
; Enter SI points to table in the form of
;  dw	Keyboard Scancode and Character,  offset address in _TEXT

KeyCommand_main	proc	near
	mov	si,offset Cmdtbl1
	jmp	KeyCommand_Translate
KeyCommand_main	endp

KeyCommand_SplitScreen	proc	near
	mov	si,offset SScreen_Cmdtbl
	jmp	KeyCommand_Translate
KeyCommand_SplitScreen	endp

KeyCommand_RepairEDL	proc	near
	mov	si,offset Cmdtbl1
	jmp	KeyCommand_Translate
KeyCommand_RepairEDL	endp

KeyCommand_EFXMEM	proc	near
	mov	si,offset EFX_cmdtbl
	jmp	KeyCommand_Translate
KeyCommand_EFXMEM	endp

; Commands allowed while previewing and editing
KeyCommand_Cmdtbl2	proc	near
	mov	si,offset Cmdtbl2
	jmp	KeyCommand_Translate
KeyCommand_Cmdtbl2	endp

KeyCommand_rdloop	proc	near
	mov	si,offset Cmdtbl4
	jmp	KeyCommand_Translate_nl
KeyCommand_rdloop	endp


; FROMs, Constants, CLEAR, INs, and OUTs
KeyCommand_TcCimsg	proc	near
	mov	si,offset Cmdtbl3
	jmp	KeyCommand_Translate_nl
KeyCommand_TcCimsg	endp

KeyCommand_PQ	proc	near
	mov	si,offset Position_Query_Table
	jmp	KeyCommand_Translate_nl
KeyCommand_PQ	endp


; Enter with AX having Keyboard INPUT WORD
; Exit: Z=1 if KEY FOUND
;	[SI] has offset in _TEXT to routine
;	[Last_Command] points to Msg_Seg routine title
;	[Last_Key] has the keystroke
;
;	Z=0 If KEY NOT FOUND
KeyCommand_Translate	proc	near
	push	di
	mov	di,offset keys_ovr - 16
KC_xlt:	mov	cx,ax			; Save character in CX
KbdCmd1:add	di,16
	lodsw				; Get Scan code
	cmp	ax,cx
	jz	KbdCmd2			; Jump if match
	inc	si			; Point to next chars
	inc	si
	inc	ax			; Check for end of commands (0ffffh)
	jnz	KbdCmd1
	add	ax,cx			; Move CX to AX, set Z=0
	jmp	KbdOut

KbdCmd2:mov	Last_Key,cx
KbdOut:	mov	Last_Command,di
	pop	di
	ret
KeyCommand_Translate	endp

KeyCommand_Translate_nl	proc	near
	mov	cx,ax			; Save character in CX
Kbdnl1:	lodsw				; Get Scan code
	cmp	ax,cx
	jz	Kbdnl2			; Jump if match
	inc	si			; Point to next chars
	inc	si
	inc	ax			; Check for end of commands (0ffffh)
	jnz	Kbdnl1
	add	ax,cx			; Move CX to AX, set Z=0
	ret
Kbdnl2:	mov	Last_Key,cx
	ret
KeyCommand_Translate_nl	endp

_TEXT	ends

_DATA	segment byte public 'DATA'

decimal_Count	db	0

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
