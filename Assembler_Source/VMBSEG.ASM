; Last revised: 2-22-1995, 11:12:27   (C)1989-1995 Norman H. Strassner

;VMBSEG.ASM
;(C)Norman H. Strassner All rights reserved.

%nolist
	include	vm.equ
%nolist

extrn Last_Duration:word,_adv2chr:far
extrn Mark_In_FAR:far,_Save_Marktable:far,_mmv3byt:far,_get_dur:far,_get_in:far
extrn _get_out:far,_cmp24b:far,_up_in:far,_up_out:far

extrn CMDLINE_OPTS:word,EDL_Bin:byte,Error_Table_ovr:word,MultRec_Flags:byte
extrn SourceVTRa_Scr:word,_E_mod_l:far,_cnvt2tc_DS:far,_find_mode:far
extrn _mmv_ESDS:far,A_Reel_Num:word,Asmmode_Msg:word,bignumbers_ovr:word
extrn Blink_Time:byte,Byte_Store_1:word,Cimsg_Insert_Mode:byte
extrn Const0_Scr:word,Constant_Msg:word,Crlf_Msg:word
extrn Current_Source:byte,Current_Workspace:byte,descript_ovr:word
extrn Descript_Scr:word,Edit_Lnum_Scr:word,Max_Lines:word
extrn Next_Edit:word,From_Machine:byte,Goaway:far,Gpi_Msg:word
extrn Hardrecord_Flag:byte,Int1c_Adr:word,DTA:word
extrn joystick_FAR:far,Keybkgnd_Src:byte,Keyfor_Src:byte,Listttl_Msg:word
extrn Listttl_Scr:word,Listtype_Scr:word,littlenumbers_ovr:word
extrn locations_far:far,macro_ovr:word,Macro_Ttl:word,Mcrosep:word
extrn Mode_Flag:byte,Multrecord_Table:word,music_ovr:word,Network_Flags:word
extrn next_ovr:word,Noed_Msg:word,R_Tc:word,Recdur_Msg:word,Recout_Msg:word
extrn Rowtbl:word,Scr_Rm_In:word,screen_ovr:word,Slave_Flags:word
extrn Slave_Table:word,sound_ovr:word,Split_Aud_Msg:word
extrn Split_Type:word,Split_Vid_Msg:word,tc_disp_FAR:far,Tcf_Scr:word
extrn tcprty0_FAR:far,Time_Msg:word,Time_Scr:word,Time_Total:word
extrn Timeline_Scr:word,Title2_Scr:word,To_Machine:byte,Trans_Type:byte
extrn Trim_Table:word,used_ovr:word,Video_Scr:word,Without_Msg:word
extrn working_ovr:word,workspace_ovr:word

extrn BuiltInMacro:byte,EVcmd_Flag:byte,Current_Constant:byte
extrn Current_Machine:byte,Edl_Fcm:byte,Frame_Flag:byte,From_Flag:byte
extrn Fromwitch_Mach:byte,Fullscreen_Flag:byte,Input_Flag:word
extrn Mac2edit_Num:byte,Macedit_Choice:byte,Macscrn_Count:byte
extrn Record_Flag:byte,Rtcf:byte,Sign_Flag:byte,Swap_Bin:byte
extrn Trim_Ci_Flag:byte

extrn Ascii_Line:word,CommandFlag_Table:word,Edl_Seg:word
extrn EDL_Window_Cursor:word,EDLoptions_Flags:word,ERROR_Cursor:WORD
extrn ERROR_PROMPT:WORD,PointShootData:word,RunningCMD_Buf:word
extrn RunningCMD_Cnt:word,RunningCMD_Ptr:word,Ascii_Line:word,bin_ovr:word
extrn Cimsg_String:word,Cmdtbl1:word,Constants:word
extrn Current_Event:word,Cursor:word,Default_Command:word,Editmode_Scr:word
extrn Edl_Formats:word,Empty_Msg:word,File_Title:word,Frames_Area:word
extrn Frames_Msg:word,From_A_Msg:word,From_Area:word,From_Aux_Msg:word
extrn From_B_Msg:word,From_Blk_Msg:word,From_C_Msg:word,From_D_Msg:word
extrn From_E_Msg:word,From_F_Msg:word,From_R_Msg:word,frommsg_ovr:word
extrn Fwhat_Area:word,Gpi0:word,hdr_ovr:word,Kbd_Tc_Pos:word
extrn Keyboard_Msg:word,Keyboard_Scr:word,keys_ovr:word,Last_Command:word
extrn Lastplace:word,List_Scr:word,Macro0:word,Macro_File_Msg:word
extrn Macro_Ttls:word,macromsg_ovr:word,Mcd_Msg:word,Mode_Pntr:word
extrn Msg_Area:word,Msg_Seg:word,Next_Avail_Num:word,Screen_Buffer:word
extrn Seriel_Num:word,Sounddisplay_Flags:word,Tcdispbuf:word,Temp_Macro:word
extrn Temp_Wrkspce:word,Title1_Scr:word,Title_Header:word,Title_Msg:word
extrn Untitled_Msg:word,Videoram:word,Vtrcb:word

extrn joystick:near,locations:near
extrn rdchar:near
extrn _dhw:far,_dhb:far
extrn _EDL2ASCII:far,_all_machine_keys:far
extrn _cnvt2tc_DS:far,_delfrm:FAR,_delms:FAR,_dixdly:FAR
extrn _index_storage:far,_mmv16:far,_mmv:far
extrn _move_subdir:far,_set_trim_keys:far,cimsg_wrk_far:far,Jogger_FAR:FAR
extrn Keyboard:far,rdchar_FAR:far,_make_ucase:far

;_TEXT	segment word public 'CODE'
;	assume	cs:_TEXT,ds:_DATA,es:eseg
;_TEXT	ends

BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg


Public  _Inout_init, _kbd_message, _listtype_upd, _lty_upd, _lty_1, lty_2
Public  _file_ttl_upd, fttlux, _time_upd, _const_upd, constu1, _mode_upd, mu0
Public  mu1, mu2, mu3, mulp, mulp1, mux, _reel_rev, reel_dv, _iodtc_rev
Public  _machtc_norm, _machtc_dim, _machtc_nd, machtc_nd1, machtc_lp
Public  _active_machines, actm_ef, actmef0, actmef1, actmef2, actm_ky, actmck0
Public  actmck1, actmck2, actm_ct, actmct1, actmct2, _upd_getrel, upd_getrel1
Public  updgrr, _upd_gettcf, tcflp1, _upd_getscr, upd_w1, upd_wx, upd_w2
Public  upd_w3, upd_w4, upd_put, _menu_columns, mnucol1, mnucol2, mnucol4
Public  _constant_disp, const_edl, constant_lp, const4p, constpl, const_comsg
Public  cbcout0, cbcout1, _constant_prompt, _constant_index, _gpi_disp, gpi_edl
Public  gpi_lp, gpi4p, gpi4lp, gpi_comsg, gpiout1, gpiout0, gpoit0a, gpoit0b
Public  gpiout2, gpiout3, _macros_disp, macdsp1, mdspret, macdsp2, macdsp3
Public  macdsp4, macdsp8, macdsp5, macdsp6, macdsp7, _split_without, splitwo
Public  _ERRORS, ERRORS1, ERROR2, ERROR3, ERROR4, _blinkit, _blinkita, blmloc
Public  blmchx, blkbd, _error_display, _error_redisplay, blcols, blcolp
Public  blcolp1, blcolx, _evnt_dispthis, _event_display, _EDL_display, EVD_1
Public  EVD_2, EVD_3, EVD_4, EVD_5, EVD_xit, EDcnt, EDcnt_1, EDcnt_2, EDcnt_3
Public  EDbtm, EDbtm_1, EDbtm_2, EDbtm_x, EDcmdlin1, ED_4lin, ED_3lin, ED_2lin
Public  ED_1lin, ED_spln, ED_line, ED_lin1, ED_lend, _EDstats, xdstat1, xtstat2
Public  EDstat3, EDstat4, EDstat5, EDstatx, _line_dim, _line_reverse, lndr
Public  lrevlp, _kbd_clear, _emclear, emclrx, _dflts_disp, _working, _evnum
Public  _dashit_cl, dshitcl, _dec_Space_Out, _A_DecOut, _DecOut_Pad
Public  _DecOut_100_pad, _DecOut, declp, JL0500, _draw_screen, drawsx, _hl_lp
Public  hlinl2, _vl_lp, vlinl2, _kbd_cln, _kbd_clr, _crlf, _backspace, bk_ok
Public  _Cursor_On, curon1, _Cursor_off, cursorc, _cmdread, crres1, _msgread
Public  ms_lp, ms_lp1, ms_lp2, ms_lp3, ms_1, ms_xit, _comsg, ds_lp, ds_lp1
Public  ds_lp2, ds_lp3, ds_1, ds_xit, _ConOut, co_1, co_2, co_ncr, co_nlf, conl
Public  co_eop, coc_ok, noco, _screen_ram, _sram_dx, _Space_Out, soc_ok, noso
Public  scroll_screen, _timeline_erase, tlelp, _dircur_lerase, _line_erase
Public  _dircur_infarea, _help_pos, _clear_eop, _blank_screen, _clear_screen
Public  clrit, _msg2screen, scrnd0, scrnd1, m2s_3, m2s_4, scrnd2, _MsgCntr
Public  _cntrtxt, ftulp, ftulpb, ftsplp, JL0436, ftcoxit, _nblocks, nblock1
Public  nblock2, nblock3, nblock4, nblock5, nblockx, _lblocks, lblcks, lblcks1
Public  lblcks2, lblock1, lblock4, lbspace, lblockx
Public  _error_bell, _baderror_bell, beb1, bebx, _hibeep
Public  hb1, hbx, _chimes, _beeper, bepr1, beprx, ToneInt_SET, ToneIntBsy
Public  ToneIntok, Tone_Flag, ToneOff_interrupt, TOi_x, _music, dixagn, dixagn1
Public  ptchdly, musicx, pitchout, tone_on, tone_off, ul_char, ur_char, ll_char
Public  lr_char, hz_char, vt_char, _DrawBox, drawbx3, drawbx4, _DrawMenuBox
Public  _draw_machines, _draw_machttls, draw_machs, drawrd, dmachlp, dmachla
Public  dmachl1, dmachl2, dmachl3, _trim_draw_machines, tdm_lp, slave_check
Public  slvchk1, slvoff, multr_check, multrchk1, multroff, trim_check, trmchk1
Public  trmoff, _tcline_init, tcin1b, tcin1c, tcin1pt
Public  tcin1r, tcin1p1, _display_froms, from_iod1, _frommsgs, fmmg1, fmmg2
Public  _fwhatmsgs, _Move_Left, mvl_ab1, mvl_ab6, mvl_ab, _Move_Right, mvl_ab2
Public  move_right_loop, move_lr_ret, mvr_ab6, mvr_ab, decimal_left
Public  decimal_right, decrlp, declret, _Macro_Screen, Edm_nt1, Edm_d1, Edm_ntz
Public  Edm_ntd, Edm_ntn, Mscr1, Mscr2, Mscr3, _Edm_Disp, EdM_1a, Edm_2, Edm_3
Public  Edm_3aa, Edm_4, Edm_4a, Edm_4b, Edm_4c, Edm_3a, Edm_3b, Edm_3c, Edm_Dx
Public  Edm_Dxm, Edm_dxr, Edm_skp, Edm_6, mac_asciientry, macasc1, maelp
Public  Edm_COMMAND, Edm_C0, Edm_C1, Edm_C2, Edm_C3, Edm_C4, Edm_Cx
Public  KeyCommand_Flags, Edm_Kf1, Edm_Kf2, Edm_Kf3, _Edm_inschar, _Edm_delone
Public  _Edm_Position, EdM_Psx, _TitleTheMacro, mactl1, mactl2, mactl, mactx
Public  _macrosav, _macsaver, macsavx, _chrwait, _macone, maconex, insert
Public  _macroindex, macind1, macindx, macindr, _macrotindex, mactnx1, mactndx
Public  mactndr, _rdnum, _cknum, stcret, _Break_check, bcx, _Clear_Cimsg_Buffer
Public  ccb1, _Calc_EndOfString, cst1, cstx, cst3, _Keyboard_reset
Public  _Keyboard_caps, _Keyboard_on, _Keyboard_off, _Keyboard_set
Public  _NewDuration


;======================================================================
; Logic for setting of a new duration from the value pointed to by BX
;======================================================================
; VTR workspace Update truth table
; If Exists:	IN	OUT	THEN UPDATE:
;		0	0	OUT POINT
;		0	1	IN POINT
;		1	0	OUT POINT
;		1	1	OUT POINT

_NewDuration	proc	far
	mov	dx,offset Last_Duration	; Save new duration
	call	_mmv3byt			;  into Last_Duration
	call	_get_dur			; Get pointer to CURRENT DURATION
	xchg	bx,dx			; BX = LAST, DX = CURRENT
	call	_mmv3byt			; Move to destination DURATION buffer

	call	_get_in			; Get in point, test for 0
	jnz	NewDur4			; If and IN POINT exists, update OUT
	call	_get_out			; Get it and evaluateit for zero
	jz	NewDur3			; No IN, No OUT = Get in, update OUT

	mov	dx,bx			; DX has OUT POINT
	mov	bx,offset Last_Duration
	call	_cmp24b			;Test OUT point for < duration
	jae	NewDur4			;If Duration => OUT, update out point
	call	_up_in			; Update IN point
	ret

; No IN POINT, no OUT POINT
NewDur3:call	_get_in
	push	bx			; Save IN POINT address
	call	Mark_In_FAR		; FIX 5-16-1990 to use VTR_IN
	pop	dx			; Restore IN POINT address
	call	_mmv3byt
	call	_up_out
	call	_Save_Marktable		; Save Ins, Outs, Durs...
NewDur4:call	_up_out			; Mark IN POINT, compute out
	ret
_NewDuration	endp


_Inout_init	proc	far
	mov	Trim_Ci_Flag,0
	mov	Cursor,offset Keyboard_Scr
	call	 FAR PTR _line_erase
	push	bx
	mov	bx,offset Keyboard_Msg
	call	 FAR PTR _comsg
	pop	bx
	mov	Cursor,offset Msg_Area	; Pnd position on screen
	norm_VIDEO FALSE, FALSE
	call	 FAR PTR _msgread
	ret
_Inout_init	endp


_kbd_message	proc	far
	call	 FAR PTR _kbd_cln
	call	 FAR PTR _comsg
	ret
_kbd_message	endp

;================================================================
_listtype_upd	proc	far
	dim_VIDEO FALSE,FALSE
	mov	bx,offset Listtype_Scr
	call	 FAR PTR _dircur_infarea
	mov	bx,es:Mode_Pntr
	add	bx,offset ZeroBase.E_edl_Name
	call	 FAR PTR _comsg
	call	 FAR PTR _mode_upd
	ret
_listtype_upd	endp

_lty_upd	proc	far
	mov	Cursor,offset Listttl_Scr
_lty_upd	endp
_lty_1	proc	far
	rev_VIDEO FALSE,FALSE
	mov	bx,offset Listttl_Msg
	call	 FAR PTR _comsg
	mov	bx,offset Recdur_Msg
	test	EDLoptions_Flags,outdur_EDLBIT
	jnz	lty_2
	mov	bx,offset Recout_Msg
lty_2:	call	 FAR PTR _comsg
	ret
_lty_1	endp

;Update screen with EDL title
_file_ttl_upd	proc	far
	mov	bx,offset Title2_Scr
	call	 FAR PTR _dircur_lerase
	mov	bx,offset File_Title + 7
	mov	dx,offset Temp_Wrkspce
	mov	ch,80
	push	dx
	call	_mmv_ESDS
	pop	bx
	call	_adv2chr
	or	al,al
	jz	fttlux
	cmp	al,cr
	jz	fttlux
	norm_VIDEO FALSE,FALSE
	call	 FAR PTR _cntrtxt
fttlux:	ret
_file_ttl_upd	endp


;================================================================

_time_upd	proc	far
	dim_VIDEO FALSE,FALSE
	mov	Cursor,offset Time_Scr
	mov	bx,offset Time_Msg
	call	 FAR PTR _comsg
	call	 FAR PTR _Space_Out
	mov	bx,offset Time_Total
	mov	cl,DF_CHAR		;es:Edl_Fcm
	call	tc_disp_FAR
	ret
_time_upd	endp


_const_upd	proc	far
	dim_VIDEO FALSE,FALSE
	mov	Cursor,offset Const0_Scr
	mov	al,'C'
	call	 FAR PTR _ConOut
	mov	al,Current_Constant
	call	 FAR PTR _A_DecOut
	cmp	al,10
	jnc	constu1
	call	 FAR PTR _Space_Out
constu1:call	 FAR PTR _constant_index
	mov	ah,al
	mov	al,'='
	call	 FAR PTR _ConOut
	call	 FAR PTR _Space_Out
	call	 FAR PTR _Space_Out
	mov	dx,offset Tcdispbuf
	mov	cl,NDF_CHAR
	call	_cnvt2tc_DS
	call	tcprty0_FAR
	ret
_const_upd	endp

;================================================================
;		Update aa/v mode
_mode_upd	proc	far
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Video_Scr
	call	 FAR PTR _dircur_infarea
	add	Cursor,3
	cmp	Hardrecord_Flag,0ffh
	jnz	mu0
	rev_VIDEO FALSE,FALSE
	dec	Cursor
	mov	bx,offset Asmmode_Msg
	call	 FAR PTR _comsg
	dim_VIDEO FALSE,FALSE
	ret

mu0:	test	EDLoptions_Flags,modetype_EDLBIT
	jz	mu2

; Display type using EDL type
	call	_find_mode
	call	_E_mod_l			; Get length
	cbw
	mov	cx,ax
mu1:	mov	al,[bx]
	inc	bx
	call	 FAR PTR _ConOut
	loop	mu1
	ret

mu2:	mov	ah,Mode_Flag
	test	ah,video_Emode
	jz	mu3
	mov	al,'V'
	call	 FAR PTR _ConOut
mu3:	mov	al,ah
	and	al,audall_Emode
	or	al,al
	jz	mux
	mov	al,'A'
	call	 FAR PTR _ConOut
	clc
	mov	ch,4
	mov	al,1
mulp:	rcl	ah,1
	jnc	mulp1
	call	 FAR PTR _A_DecOut
mulp1:	inc	al
	dec	ch
	jnz	mulp
mux:	ret
_mode_upd	endp


;================================================================
; BX = screen Cursor position
; CL = machine number 0 - n
; [ CH = column offset ]
;
_reel_rev	proc	far
	rev_VIDEO FALSE,FALSE		; Reverse video

	push	cs
	mov	ax,offset reel_dv	; Return routine through
	push	ax			;  dim_vid
	mov	bh,offset r_line	; Point to record machine's line
	add	bh,Current_Machine	; Offset to machine line
	mov	dl,ch			; Offset to column
	mov	ax,reel_length		; 11 digits w/ colons
	jmp	machtc_nd1

reel_dv:dim_VIDEO TRUE,TRUE
	ret
_reel_rev	endp

_iodtc_rev	proc	far
	rev_VIDEO FALSE,FALSE			; Reverse video
	push	cs
	mov	ax,offset reel_dv	; Return routine through
	push	ax			;  dim_vid
	mov	bh,r_line		; Point to record machine's line
	add	bh,Current_Machine	; Offset to machine line
	mov	dl,ch			; Offset to column
	mov	ax,11			; 11 digits w/ colons
	jmp	machtc_nd1
_iodtc_rev	endp

_machtc_norm	proc	far
	norm_VIDEO FALSE,FALSE
	push	cs
	mov	ax,offset reel_dv	; Return routine through
	push	ax			;  dim_vid
	jmp	_machtc_nd
_machtc_norm	endp

_machtc_dim	proc	far
	dim_VIDEO FALSE,FALSE
_machtc_dim	endp

_machtc_nd	proc	far
	mov	ax,42
	mov	dl,reel_offset
	cmp	cl,aux_dev
	jc	machtc_nd1
	mov	ax,45
	mov	dl,mach_offset

machtc_nd1:
	mov	dh,bh			; Get line number
	push	es
	push	di
	push	cx
	mov	cx,ax			; CX = # of characters
	call	 FAR PTR _sram_dx
	mov	al,video_mode
	inc	di
	even
machtc_lp:
	stosb
	inc	di
	loop	machtc_lp
	pop	cx
	pop	di
	pop	es
	ret
_machtc_nd	endp

; Hilight active machines on screen
_active_machines	proc	far
	mov	bx,offset (r_line * 256) + mach_offset
	mov	cl,1			; Start with "A" machine
	call	_machtc_norm
	mov	ch,MAX_DEVICES+1	; # to do
	mov	al,Trans_Type
	cmp	al,'C'			; CUT?
	jz	actm_ct
	cmp	al,'K'
	jz	actm_ky
	cmp	al,'S'
	jz	actm_ct

; Update for Dissolves and Wipes
actm_ef:inc	bh			; Next machine screen line
	cmp	cl,From_Machine
	jz	actmef0
	cmp	cl,To_Machine
	jnz	actmef1
actmef0:call	_machtc_norm
	jmp	actmef2
actmef1:call	_machtc_dim
actmef2:inc	cl
	cmp	cl,ch
	jnz	actm_ef
	ret

; Update for KEY
actm_ky:inc	bh			; Next machine screen line
	cmp	cl,Keyfor_Src
	jz	actmck0
	cmp	cl,Keybkgnd_Src
	jnz	actmck1
actmck0:call	_machtc_norm
	jmp	actmck2
actmck1:call	_machtc_dim
actmck2:inc	cl
	cmp	cl,ch
	jnz	actm_ky
	ret

; Update for CUT
actm_ct:inc	bh			; Next machine screen line
	cmp	cl,Current_Source
	jnz	actmct1
	call	_machtc_norm
	jmp	actmct2
actmct1:call	_machtc_dim
actmct2:inc	cl
	cmp	cl,ch
	jnz	actm_ct
	ret
_active_machines	endp




;================================================================
; Display all reel assignments in workspace
	even
_upd_getrel	proc	far
	mov	si,offset Vtrcb + Vtrcb_length	; A VTR's Vtrcb
	mov	bx,offset SourceVTRa_Scr
	mov	dx,offset A_Reel_Num
	mov	cx,MAX_MACHINES - 1
	call	upd_getrel1
	mov	bl,mach_offset
	mov	cx,2
	call	upd_getrel1
	call	 FAR PTR _upd_gettcf
	ret
_upd_getrel	endp

upd_getrel1:
	or	cx,cx
	jz	updgrr
	dim_VIDEO FALSE,FALSE
	push	bx			; Save screen address
	push	dx			; Save the buffer address
	push	bx			; Save screen address
	mov	Cursor,bx		; And set the Cursor
	mov	bx,SpacePointer(6)
	call	 FAR PTR _comsg
	mov	al,' '
	mov	ah,[si.Vtrcb_CF]
	or	ah,ah
	jz	ugr1
	mov	al,135 ;21
ugr1:	call	 FAR PTR _ConOut
	pop	Cursor			; Re-position Cursor
	pop	bx			; H has current buffer to print
	call	_adv2chr		; advance to start of reel Name
	call	 FAR PTR _comsg			; Print it
	mov	dx,bx			; Next buffer address to DX
	pop	bx			; Restore screen address
	inc	bh			; Next line
	add	si,Vtrcb_length		; Next Vtrcb
	dec	cx			; One less to do
	jmp	upd_getrel1
updgrr:	ret

;Display time code format for each machine
_upd_gettcf	proc	far
	push	si
	dim_VIDEO FALSE,FALSE
	mov	bx,offset Tcf_Scr
	mov	si,offset Vtrcb.Vtrcb_FCM ; Offset for TCF indicators
	mov	cx,MAX_MACHINES	;(5)
	even
tcflp1:	mov	Cursor,bx
	mov	al,[si]			; 3 is the offset for TCF indicators
	add	si,Vtrcb_length
	call	 FAR PTR _ConOut
	inc	bh
	loop	tcflp1
	pop	si
	ret
_upd_gettcf	endp

;--------------------------------------------------------
;   U P D A T E   W O R K S P A C E   T I M E C O D E
;--------------------------------------------------------
	even
_upd_getscr	proc	far
	cmp	Fullscreen_Flag,0ffh
	jz	upd_wx
	push	si
	push	di
	push	bp
	mov	di,offset R_Tc.tcIN
	mov	si,offset Scr_Rm_In	; SI points to screen location tbl
	mov	bp,offset Vtrcb.Vtrcb_FCM	; BP points to the TCF table
	norm_VIDEO FALSE,FALSE
	call	upd_w2
	dim_VIDEO FALSE,FALSE
	mov	cx,MAX_DEVICES
	even
upd_w1:	push	cx
	call	upd_w2		; Do for all active VTRs, plus aux
	pop	cx
	loop	upd_w1
	pop	bp
	pop	di
	pop	si
upd_wx:	ret
_upd_getscr	endp

	even
upd_w2:	mov	cl,ds:[bp]
	call	upd_put			; IN
	mov	cl,ds:[bp]
	call	upd_put			; OUT
	test	Network_Flags,DFdur_NTBIT
	jnz	upd_w3
	mov	cl,ds:[bp]
	jmp	upd_w4
upd_w3:	mov	cl,DF_CHAR
upd_w4:	call	upd_put			; DUR
	add	bp,Vtrcb_length
	call	_active_machines
	ret

upd_put:cld
	lodsw				; Get next screen address
	mov	Cursor,ax		;  and make it current Cursor
	mov	bx,di			; Get next TC val address
	call	tc_disp_FAR		; Display it
	inc	di			; Point to next buffer
	inc	di
	inc	di
	ret


;................................................................
_menu_columns	proc	far
	call	 FAR PTR _help_pos
	mov	di,PointShootData.PQ_Cursor
	mov	si,di		; Save Cursor to SI
	dim_VIDEO FALSE,TRUE
	xor	dl,dl		; Use as counter
	push	es
	mov	es,Msg_Seg
	mov	cl,PointShootData.PQ_tab
	xor	ch,ch
	mov	bp,cx
	mov	cl,PointShootData.PQ_cols
mnucol1:push	ax
	push	cx
	mov	cl,PointShootData.PQ_rows	; 9 rows to do
	xor	ch,ch

mnucol2:cmp	es:byte ptr [bx],0
	jz	mnucol4

	push	cx
	mov	Cursor,di
	mov	cl,dl
	call	 FAR PTR _dashit_cl
	mov	dl,cl
	call	 FAR PTR _msgread
	pop	cx
	add	di,100h
	loop	mnucol2

	add	si,bp
	mov	di,si
	pop	cx
	pop	ax
	loop	mnucol1
	pop	es
	ret

mnucol4:pop	cx
	pop	ax
	pop	es
	ret
_menu_columns	endp

;---------------------------------------------------------------
; D I S P L A Y   T H E   C O N S T A N T   R E G I S T E R S
;---------------------------------------------------------------
;Display Constants
_constant_disp	proc	far
	mov	ax,es:Next_Avail_Num
	dec	ax
	jnz	const_edl
	call	 FAR PTR _help_pos
const_edl:
	mov	bx,offset List_Scr
	dim_VIDEO FALSE,FALSE
	xor	al,al
constant_lp:
	call	const4p		; Top line
	inc	bh
	call	const4p		; Second line
	inc	bh
	call	 FAR PTR _dircur_lerase	; Erase line 3
	inc	bh		; Skip Event line
	inc	bh		; skip second if there
	inc	bh
	call	 FAR PTR _dircur_lerase
	inc	bh
	call	const4p		; Sixth line
	inc	bh		; Fall through for last line
	call	const4p
	inc	bh
	call	 FAR PTR _dircur_lerase
	ret
_constant_disp	endp

const4p:call	 FAR PTR _dircur_lerase
	push	bx
	mov	cx,4
	mov	bl,3
constpl:mov	Cursor,bx
	add	bl,18
	call	const_comsg
	inc	al
	loop	constpl
	pop	bx
	ret

const_comsg:
	push	cx
	push	ax
	push	bx
	push	dx
	push	ax
	cmp	al,10
	jnc	cbcout0
	push	ax
	xor	al,al
	call	 FAR PTR _A_DecOut
	pop	ax
cbcout0:call	 FAR PTR _A_DecOut		; Display constant number
	call	 FAR PTR _Space_Out
	mov	al,MINUS_ASCII
	call	 FAR PTR _ConOut
	call	 FAR PTR _Space_Out
	pop	ax
	call	 FAR PTR _constant_index
	xor	ax,ax
	or	al,[bx]			; LSB, MSB
	or	ax,1[bx]		; MSB
	jz	cbcout1
	norm_VIDEO FALSE,FALSE
cbcout1:mov	dx,offset Tcdispbuf	; Ascii buffer
	mov	cl,NDF_CHAR		;Force Non-Drop TCF type
	call	 _cnvt2tc_DS
	call	 FAR PTR _comsg
	dim_VIDEO FALSE,FALSE
	pop	dx
	pop	bx
	pop	ax
	pop	cx
	ret


;----------------------------------------------------------------
; Display "CONST #
_constant_prompt	proc	far
	call	 FAR PTR _kbd_cln
	mov	bx,offset Constant_Msg
	call	 FAR PTR _comsg
	mov	al,'#'
	call	 FAR PTR _ConOut
	ret
_constant_prompt	endp

;----------------------------------------------------------------
; Index to a constant register
; AX has constant number from 0 - 15
_constant_index	proc	far
	cbw
	mov	bx,ax
	shl	bx,1			; Each constant is three bytes
	add	bx,ax			;  so multiply by 3
	add	bx,offset Constants
	ret
_constant_index	endp

;---------------------------------------------------------------
;	D I S P L A Y   T H E   G P I  R E G I S T E R S
;---------------------------------------------------------------
_gpi_disp	proc	far
	mov	ax,es:Next_Avail_Num
	dec	ax
	jnz	gpi_edl
	call	 FAR PTR _help_pos
gpi_edl:mov	bx,offset List_Scr
	dim_VIDEO FALSE,FALSE
	xor	ax,ax
gpi_lp:	call	 gpi4p		; Top line
	call	gpi4p		; Second line

	if ALLOWED_VTRS EQ 7
	call	gpi4p		; Third line
	else
	call	FAR PTR _dircur_lerase
	inc	bh
	endif

	inc	bh		; skip the edl lines
	inc	bh

	if ALLOWED_VTRS EQ 7
	call	gpi4p		; Sixth
	call	gpi4p		; Seventh
	else
	call	FAR PTR _dircur_lerase
	inc	bh
	endif

	call	gpi4p		; Eighth
	call	gpi4p		; Ninth
	mov	bx,offset Gpi_Msg
	call	 FAR PTR _kbd_cln
	call	 FAR PTR _comsg
	mov	al,':'
	call	 FAR PTR _ConOut
	call	 FAR PTR _Space_Out
	mov	al,'#'
	call	 FAR PTR _ConOut
	ret
_gpi_disp	endp

gpi4p:	call	 FAR PTR _dircur_lerase
	push	bx
	inc	bl			; Start at column 1
	mov	cx,4
gpi4lp:	mov	Cursor,bx
	add	bl,20
	call	 gpi_comsg
	inc	al
	loop	gpi4lp
	pop	bx
	inc	bh
	ret

gpi_comsg:
	push	cx
	push	ax
	push	bx

	push	ax
	MULTIPLY_BY GPI_length, AX
	mov	bx,ax
	add	bx,offset Gpi0
	mov	si,bx
	rev_VIDEO FALSE,FALSE
	test	[bx].gpiFLAGS, G_program_mask	; Establishing gpi program
	jnz	gpiout1
	norm_VIDEO FALSE,FALSE
	test	byte ptr [si].gpiFLAGS,G_active_mask; Get active Flag
	jnz	gpiout1
	dim_VIDEO FALSE,FALSE

gpiout1:pop	ax			; Restore GPI number
	cmp	al,10
	jnc	gpiout0
	push	ax
	mov	al,'0'
	call	 FAR PTR _ConOut
	pop	ax
gpiout0:call	 FAR PTR _A_DecOut		; Display gpi number
	call	 FAR PTR _Space_Out		; Character 3

	mov	al,byte ptr [si].gpiFLAGS		; Get type of GPI trigger
	and	al,7fh
	or	al,al
	jnz	gpoit0b
gpoit0a:mov	al,MINUS_ASCII
	jmp	gpiout2
gpoit0b:test	byte ptr [si].gpiFLAGS,G_swtrig_mask
	mov	al,'V'
	jnz	gpiout2
	mov	al,'G'
	test	byte ptr [si].gpiFLAGS,G_vltrig_mask
	jnz	gpiout2
	test	byte ptr [si].gpiFLAGS,G_machine_mask
	jz	gpoit0a
	mov	al,byte ptr [si].gpiFLAGS
	and	al,00000111b
	cmp	al,MAX_MACHINES
	jnc	gpoit0a
	add	al,'A'-1
gpiout2:call	 FAR PTR _ConOut			; Character 4
	call	 FAR PTR _Space_Out		; Character 5

	mov	bx,[si].gpiCMD
	call	 FAR PTR _DecOut_Pad
	mov	bx,si

	mov	al,[si]
	cmp	al,MINUS_ASCII
	jz	gpiout3
	mov	al,' '
gpiout3:call	 FAR PTR _ConOut			; Character 10
	inc	bx
	mov	dx,offset Tcdispbuf	; Ascii buffer
	mov	cl,Rtcf			;Force record TCF type
	call	 _cnvt2tc_DS
	add	bx,3			; Don't display the hours
	call	 FAR PTR _comsg			; Character 11 - 22
	dim_VIDEO FALSE,FALSE
	pop	bx
	pop	ax
	pop	cx
	ret

;---------------------------------------------------------------
; D I S P L A Y   A L L   T E N   M A C R O   R E G I S T E R S
;---------------------------------------------------------------
_macros_disp	proc	far
	call	 FAR PTR _help_pos
	rev_VIDEO FALSE,FALSE
	mov	bx,offset macro_ovr
	call	 FAR PTR _msgread
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Macro_Ttl
	call	 FAR PTR _cntrtxt
	call	 FAR PTR _crlf
	xor	ch,ch			; Start with macro 0

macdsp1:call	 macdsp2
	inc	ch
	call	macdsp2
	inc	ch
	call	 FAR PTR _crlf
	cmp	ch,9
 	jc	macdsp1
	mov	bx,offset Mcd_Msg	; Display default macro
	call	 FAR PTR _comsg
	mov	al,':'
	call	 FAR PTR _ConOut
	call	 FAR PTR _Space_Out
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Default_Command
	cmp	byte ptr [bx],0
	jz	mdspret
	add	bx,80h
	call	 FAR PTR _comsg
mdspret:ret
_macros_disp	endp

macdsp2:norm_VIDEO FALSE,FALSE
	mov	al,ch			; Macro #
	call	 FAR PTR _A_DecOut		; Display macro #
	dim_VIDEO FALSE,FALSE
	mov	bx,offset Mcrosep	; " - "
	call	 FAR PTR _comsg
	mov	al,ch			; Get macro # back
	call	 FAR PTR _macroindex
	cmp	byte ptr [bx],0
	jnz	macdsp3
	mov	bx,offset Empty_Msg
	jmp	macdsp4

macdsp3:norm_VIDEO FALSE,TRUE
	call	 FAR PTR _macrotindex		; Index to proper macro
	mov	bx,si

macdsp4:push	cx
	cmp	byte ptr [bx],0		; Any title there?
	jnz	macdsp8
	mov	bx,offset Untitled_Msg
macdsp8:mov	cx,macrotlen - 1
macdsp5:mov	al,[bx]
	call	 FAR PTR _ConOut
	inc	bx
	or	al,al
	loopnz	macdsp5
	add	cx,4
	mov	al,' '
macdsp6:call	 FAR PTR _ConOut
	loop	macdsp6
macdsp7:pop	cx
	ret


;================================================================

_split_without	proc	far
	push	ax			; Save mode
	call	 FAR PTR _kbd_cln
	blinkrev_VIDEO FALSE,FALSE
	call	 FAR PTR _Space_Out
	mov	bx,offset Split_Type	;  "Split "
	call	 FAR PTR _comsg
	mov	bx,offset Without_Msg	;  "without "
	call	 FAR PTR _comsg
	pop	ax			; Restore mode
	and	al,video_Emode		; Video present?
	or	al,al
	mov	bx,offset Split_Vid_Msg
	jz	splitwo
	mov	bx,offset Split_Aud_Msg
splitwo:call	 FAR PTR _comsg
	call	 FAR PTR _Space_Out
	call	 FAR PTR _error_bell
	call	 rdchar_FAR
	call	 FAR PTR _macone
	jmp	Keyboard
_split_without	endp


;enter with message pointer = BX
;blinks message for about one second
_ERRORS	proc	far

	mov	ERROR_ACTIVE,0FFH
	mov	ax,_DATA
	mov	ds,ax

	push	es
	mov	es,Msg_Seg
	mov	bx,ERROR_FlagS
	and	bx,0000000011111111b	; Mask for 0 - 255
	shl	bx,1
	add	bx,offset Error_Table_ovr
	mov	bx,es:[bx]
	pop	es
	mov	ERROR_MESSAGE,bx
	mov	ax,Last_Command
	mov	ERROR_COMMAND,ax

	call	 FAR PTR _Cursor_off
	cmp	RunningCMD_Cnt,0	; Error during macro?
	jz	ERRORS1
	xor	ax,ax
	mov	RunningCMD_Cnt,ax	; Clear macro out if error
	mov	RunningCMD_Buf,ax
	call	 FAR PTR _blinkit
	call	 rdchar_FAR
	call	 FAR PTR _macone
	jmp	Keyboard

ERRORS1:test	ERROR_FlagS,ERET_Quick
	jz	ERROR2
	call	 FAR PTR _error_bell
	call	 FAR PTR _error_display
	jmp	ERROR4

ERROR2:	call	 FAR PTR _blinkit
	mov	ax,ERROR_FlagS

	test	ax,ERET_Return
	jnz	ERROR4
	test	ax,ERET_Keyboard
	jz	ERROR3
	jmp	Keyboard

ERROR3:	test	ax,ERET_DOS
	jz	ERROR4
	mov	bx,offset Crlf_Msg
	call	 FAR PTR _comsg
	jmp	Goaway

ERROR4:	push	word ptr ERROR_SEG
	push	word ptr ERROR_OFFSET

; reset default DTA
	mov	dx,offset DTA		; Set default DMA
	mov	ah,1Ah			; Set DMA
	int	DOS

	ret

_ERRORS	endp

;================================================================
_blinkit	proc	far
	call	 FAR PTR _error_display
_blinkit	endp

_blinkita	proc	far
	mov	al,Blink_Time
	mov	ah,0
	mov	cl,15			; 15 frames = half second
	mul	cl
	mov	cx,ax	
	call	 FAR PTR _error_bell

	push	Cursor
blmloc:	push	cx
	call	 locations_far
	call	joystick_FAR
	call	Jogger_FAR
	call	_delfrm
	pop	cx
	mov	ah,11h			; Keyboard status AT
	int	16h			; Quit if key pressed
	jnz	blmchx
	loop	blmloc
	pop	Cursor
	ret

blmchx:	pop	Cursor
	mov	ah,10h			; Keyboard get
	int	16h
	call	 FAR PTR _Break_check
	jz	blkbd
	call	 FAR PTR _macone
	ret
blkbd:	jmp	Keyboard

_blinkita	endp

; BX has correct error message address in Msg_Seg
_error_display	proc	far
	call	 FAR PTR _emclear		; Clear any VTR edit messages
	call	 FAR PTR _kbd_cln		; Clear Keyboard line
_error_display	endp

_error_redisplay	proc	far
	mov	bx,ERROR_MESSAGE
	or	bx,bx
	jz	blcolx
	rev_VIDEO FALSE,FALSE
	call	 FAR PTR _msgread
	dim_VIDEO FALSE,FALSE
	call	 FAR PTR _Space_Out
	mov	al,'['
	call	 FAR PTR _ConOut

	mov	cx,16
	push	es
	mov	bx,ERROR_COMMAND
	or	bx,bx
	jz	blcolp1
	mov	es,Msg_Seg
blcols:	mov	al,es:[bx]
	cmp	al,205			; Current border character
	jnz	blcolp
	inc	bx
	loop	blcols
blcolp:	mov	al,es:[bx]
	cmp	al,205
	jz	blcolp1
	inc	bx
	call	 FAR PTR _ConOut
	loop	blcolp
blcolp1:pop	es
	call	 FAR PTR _Space_Out
	mov	bx,ERROR_SEG
	call	 FAR PTR _dhw
	mov	al,':'
	call	 FAR PTR _ConOut
	mov	bx,ERROR_OFFSET
	call	 FAR PTR _dhw
	call	 FAR PTR _Space_Out
	mov	al,']'
	call	 FAR PTR _ConOut
blcolx:	ret
_error_redisplay	endp

;================================================================
; Display the Current_Event in the EDL
; ENTER: Current event in Current_Event
; Exit:  EDL displayed
	even
_evnt_dispthis	proc	far
	Color_EDL_video		;dim_VIDEO
	mov	ax,es:Current_Event
_evnt_dispthis	endp

; Display the event in AX as the current event
; ENTER: AX = new Current_Event
; Exit:  EDL moved to event at AX
	even
_event_display	proc	far
	call	 FAR PTR _EDL_display
	call	 FAR PTR _EDstats
	ret
_event_display	endp

_EDL_display	proc	far
	mov	es, Edl_Seg
	mov	bx,es:Current_Event	; Save the last place
	mov	Lastplace,bx		;  we were

	push	es:Mode_Pntr		; Save EDL OUTPUT FORMAT
	test	EDLoptions_Flags,modedisp_EDLBIT ; Display = EDL FORMAT?
	jnz	EVD_1			; Jump if so
	mov	es:Mode_Pntr,offset Edl_Formats
EVD_1:	or	ax,ax			; Check for event 0
	jnz	EVD_2			; Skip if >0
	inc	ax			; If 0, make 1

;----------------------------------------------------------------
EVD_2:	mov	bx,offset Next_Avail_Num
	cmp	ax,es:[bx]		; Check for above list
	jc	EVD_3			; Ok if below
	mov	ax,es:[bx]		; Else, set to
	dec	ax			;  last event number
	jz	EVD_xit

EVD_3:	dec	ax			; Go back one event
	jz	EVD_4
	call	_index_storage
	jc	EVD_4
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	EVD_5
EVD_4:	inc	ax

EVD_5:	call	_index_storage
	mov	Byte_Store_1,ax		; Temporarily store event
	cmp	es:Next_Avail_Num,1	; Any list?
	jnz	EDcnt
EVD_xit:call	 FAR PTR _help_pos		; Erases screen
	jmp	EDbtm_x			; Restore and return

;================================================================
;display the current event on the center list line
EDcnt:	call	 FAR PTR _Cursor_off
	mov	ax,EDL_Window_Cursor
	mov	Cursor,ax
	push	Cursor
	Color_EDL_video
	mov	ax,es:Current_Event	; Get the current event
	sub	ax,4			; Subract 4 events
	call	ED_3lin			; Display top events
	inc	ax
	pop	Cursor
	add	Cursor,0300h		; Add in for center line position
	Color_CNTREDL_video
	push	ax
	mov	al,'>'			; Indicate current edit
	call	 FAR PTR _ConOut			; With a ">"
	pop	ax
	call	ED_line			; Display first line
	call	 FAR PTR _crlf			; W/crlf
	jc	EDcnt_1			; If single line, skip

; Display 2nd line of double event
	mov	ax,es:Current_Event	; DOUBLE LINE, point to current
	push	ax
	inc	ax			;  plus 1 (second line)
	Color_CNTREDL_video
	call	ED_spln			;  and display the line
	pop	es:Current_Event	; Number

; If SINGLE LINE, and next line is NOT an EDIT, display brightly
EDcnt_1:mov	ax,es:Current_Event
	push	ax
	call	_index_storage
	pushf
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jnc	EDcnt_3
	call	_index_storage
	jnc	EDcnt_3
	popf				; Restore Flags from first line
	Color_CNTREDL_video
	jnc	EDcnt_2
	Color_EDL_video
EDcnt_2:call	ED_spln
	pushf
EDcnt_3:popf
	pop	es:Current_Event
	call	 FAR PTR _line_erase		; If not dbl line, clear it

;display bottom events
EDbtm:	Color_EDL_video
	push	EDL_Window_Cursor
	pop	Cursor
	add	Cursor,0500h

	mov	ax,Byte_Store_1		; Get middle event number
	call	_index_storage
	jc	EDbtm_1
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	EDbtm_1
	inc	ax
	jmp	EDbtm_2

EDbtm_1:push	ax
	inc	ax
	call	_index_storage
	pop	ax
	jnc	EDbtm_2
	inc	ax
EDbtm_2:call	ED_4lin
EDbtm_x:pop	es:Mode_Pntr		; Restore mode pointer
	mov	ax,Byte_Store_1
	mov	es:Current_Event,ax
	call	_index_storage
	mov	EVcmd_Flag,0
	ret
_EDL_display	endp

;----------------------------------------------------------------
EDcmdlin1:
	inc	ax
	inc	ax
	call	 FAR PTR _crlf
	call	 FAR PTR _crlf
	jmp	ED_1lin

ED_4lin:call	ED_1lin			; Display 4 lines
	call	 FAR PTR _crlf
	cmp	EVcmd_Flag,0ffh
	jnz	ED_3lin
	ret
	
ED_3lin:cmp	EVcmd_Flag,0ffh
	jz	EDcmdlin1
	call	ED_1lin			; Display 3 lines
	call	 FAR PTR _crlf
ED_2lin:call	ED_1lin
	call	 FAR PTR _crlf
ED_1lin:inc	ax			; Display 1 line
	jz	ED_lend
	cmp	ax,es:Max_Lines
	ja	ED_lend
	cmp	ax,es:Next_Avail_Num
	jnc	ED_lend

ED_spln:call	 FAR PTR _Space_Out
ED_line:call	_index_storage
	push	ax
	FLAGBITS sort_Fmask
	jz	ED_lin1
	rev_VIDEO FALSE,TRUE
ED_lin1:call	_EDL2ASCII
	call	 FAR PTR _comsg
	Color_EDL_video
;	dim_VIDEO
	pop	ax
ED_lend:call	 FAR PTR _line_erase
	ret

;================================================================
;	Display EDL stats in EDL status window
_EDstats	proc	far
	cmp	Fullscreen_Flag,0ffh
	JMP_Z	EDstatx

	push	si

	dim_VIDEO FALSE,FALSE
	mov	si,offset Edit_Lnum_Scr		; Set Cursor to top
	mov	bx,si
	call	 FAR PTR _dircur_infarea			; Clear small area

;;	test	Sounddisplay_Flags,usedfree_SDBIT
;;	jnz	xdstat1
;;	add	si,100h
xdstat1:
;;	mov	bx,si
;;	call	_dircur_infarea			; Clear small area

	mov	bx,offset next_ovr		; NEXT EDIT NUMBER
	call	 FAR PTR _msgread
	mov	bx,es:Next_Edit
	call	 FAR PTR _DecOut


;;	test	Sounddisplay_Flags,usedfree_SDBIT
;;	jz	EDstat3

	add	si,100h				; Increment a screen line
	mov	bx,si				; Get next position
	call	 FAR PTR _dircur_infarea
	mov	bx,offset used_ovr
	call	 FAR PTR _msgread

	mov	bx,es:Next_Avail_Num
	or	bx,bx
	jz	xtstat2
	dec	bx
xtstat2:call	 FAR PTR _DecOut

EDstat3:add	si,100h				; Increment a screen line
	mov	bx,si				; Get next position
	pop	si

	call	 FAR PTR _dircur_infarea
	dim_VIDEO FALSE,FALSE
	mov	al,es:byte ptr EDL_Bin
	cmp	al,1
	jz	EDstat4
	rev_VIDEO FALSE,TRUE
EDstat4:mov	bx,offset bin_ovr
	call	 FAR PTR _msgread
	call	 FAR PTR _A_DecOut
	call	 FAR PTR _Space_Out

	mov	al,Current_Workspace
	dim_VIDEO FALSE,TRUE
	cmp	al,1
	jz	EDstat5
	rev_VIDEO FALSE,TRUE
EDstat5:mov	bx,offset workspace_ovr
	call	 FAR PTR _msgread
	mov	al,Current_Workspace
	call	 FAR PTR _A_DecOut
EDstatx:ret
_EDstats	endp

;================================================================
; Reverse line of from beginning of current Cursor line
; CX is used
_line_dim	proc	far
	dim_VIDEO FALSE,FALSE			; Reverse video
	jmp	lndr
_line_dim	endp

_line_reverse	proc	far
	rev_VIDEO FALSE,FALSE			; Reverse video
lndr:	push	es
	mov	dl,0
	call	 FAR PTR _sram_dx
	mov	cx,80
	mov	al,video_mode
	inc	di
	even
lrevlp:	stosb
	inc	di
	loop	lrevlp
	pop	es
	ret
_line_reverse	endp

_kbd_clear	proc	far
	push	Cursor
	push	bx
	mov	Cursor,offset Kbd_Tc_Pos
	mov	si, SpacePointer(11)
	call	 FAR PTR _comsg
	pop	bx
	pop	Cursor
	ret
_kbd_clear	endp

;================================================================
_emclear	proc	far
	cmp	Fullscreen_Flag,0ffh	; See if SplitScreen is active
	jz	emclrx
	dim_VIDEO FALSE,TRUE
	mov	Cursor,offset Editmode_Scr
	push	bx
	mov	bx,offset Noed_Msg
	call	 FAR PTR _comsg
	pop	bx
emclrx:	ret
_emclear	endp

;================================================================
;Display the clone title
_dflts_disp	proc	far
	dim_VIDEO FALSE,FALSE
	mov	bx,offset Title2_Scr
	mov	dx,offset Seriel_Num
	call	 FAR PTR _dircur_lerase
	mov	bx,dx
	call	 FAR PTR _cntrtxt
	ret
_dflts_disp	endp

;Blinks "_working" message
_working	proc	far
	push	bx
	push	ax
	call	 FAR PTR _Cursor_off
	blink_VIDEO FALSE,FALSE
	mov	bx,offset working_ovr
	mov	Cursor,offset Msg_Area	; Pnd position on screen
	call	 FAR PTR _msgread		; Print it, return
	pop	ax
	pop	bx
	norm_VIDEO FALSE,FALSE
	mov	ERROR_ACTIVE,0
	ret
_working	endp

;Display the current event on the extreme left of current line
	even
_evnum	proc	far
	push	bx
	push	ax
	push	ax
	mov	Cursor,offset Keyboard_Scr
	pop	bx
	call	 FAR PTR _DecOut
	pop	ax
	pop	bx
	call	 FAR PTR _Space_Out
	ret
_evnum	endp


;================================================================
; Print to screen CL+1 w/ space-dash-space
; Exit with CL=CL+1
_dashit_cl	proc	far
	inc	cl
	mov	al,cl
	cmp	al,10
	jnc	dshitcl
	call	 FAR PTR _Space_Out
dshitcl:norm_VIDEO FALSE,TRUE
	call	 FAR PTR _A_DecOut
	call	 FAR PTR _Space_Out
	mov	al,MINUS_ASCII
	call	 FAR PTR _ConOut
	dim_VIDEO FALSE,FALSE
	call	 FAR PTR _Space_Out
	ret
_dashit_cl	endp

;================================================================
_dec_Space_Out	proc	far
	call	 FAR PTR _A_DecOut
	call	 FAR PTR _Space_Out
	call	 FAR PTR _Space_Out
	ret
_dec_Space_Out	endp


;================================================================
;			PRINT AL IN DECIMAL
;================================================================
	even
_A_DecOut	proc	far
	push	bx
	mov	bl,al
	xor	bh,bh			; Place a in BX and make 16 bits
 	push	ax
	call	 FAR PTR _DecOut
	pop	ax
	pop	bx
	ret
_A_DecOut	endp

;================================================================
;			PRINT BX IN DECIMAL
;================================================================
_DecOut_Pad	proc	far
	cmp	bx,100			; Three Spaces required?
	jnc	_DecOut_100_pad
	mov	al,'0'
	call	 FAR PTR _ConOut
_DecOut_Pad	endp

_DecOut_100_pad	proc	far
	cmp	bx,10
	jnc	_DecOut
	mov	al,'0'
	call	 FAR PTR _ConOut
_DecOut_100_pad	endp

	even
_DecOut	proc	far
	push	bx			; Save everybody
	push	dx
	push	cx
	mov	cx,0fff6h		; Conversion radix
	mov	dx,0ffffh
declp:	inc	dx
	add	bx,cx
	jc	declp
	add	bx,10
	xchg	bx,dx
	or	bx,bx
	jz	JL0500
	call _DecOut	; This is recursive
JL0500:	mov	al,dl
	add	al,'0'
	call	 FAR PTR _ConOut
	pop	cx
	pop	dx
	pop	bx
	ret
_DecOut	endp


_draw_screen	proc	far
	call	 FAR PTR _clear_screen		; Clear Screen
	call	 FAR PTR _Cursor_off		; Cursor Off
	test	Sounddisplay_Flags,border_SDBIT
	jz	drawsx
	Color_GRID_video
	mov	bx,offset screen_ovr
	call	 FAR PTR _msgread
drawsx:	dim_VIDEO FALSE,FALSE
	mov	Cursor,offset Title1_Scr; Title
	mov	bx,offset hdr_ovr	; Message
	call	 FAR PTR _MsgCntr		; From overlay

	mov	Cursor,offset Descript_Scr
	mov	bx,offset descript_ovr	; Edit
	call	 FAR PTR _msgread		; Header
	ret

_draw_screen	endp

;................................................................
_hl_lp	proc	far
	mov	Cursor,bx
	even
hlinl2:	call	 FAR PTR _ConOut
	inc	bl
	loop	hlinl2
	ret
_hl_lp	endp

;................................................................
_vl_lp	proc	far
	mov	al,179
	even
vlinl2:	mov	Cursor,bx
	call	 FAR PTR _ConOut
	inc	bh
	loop	vlinl2
	ret
_vl_lp	endp



; Clear the Keyboard line and normal video
_kbd_cln	proc	far
	norm_VIDEO TRUE,TRUE			; Normal video and...
_kbd_cln	endp

_kbd_clr	proc	far
	mov	Cursor,offset Keyboard_Scr	; Clear Keyboard line
	call	 FAR PTR _line_erase
	ret
_kbd_clr	endp

_crlf	proc	far
	pushf
	inc	byte ptr Cursor+1
	mov	byte ptr Cursor,0
	popf
	ret
_crlf	endp


_backspace	proc	far
	pushf
	push	ax
	push	bx
	push	dx
	push	cx
	mov	dx,Cursor
	dec	dl
	jns	bk_ok			; Jump if not negative
	mov	dl,79
	dec	dh
bk_ok:	mov	Cursor,dx
	mov	al,' '
	call	 FAR PTR _ConOut
	mov	Cursor,dx
	mov	ah,2
	mov	bh,0
	int	10h
	pop	cx
	pop	dx
	pop	bx
	pop	ax
	popf
	ret
_backspace	endp


_Cursor_On	proc	far
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	mov	dx,Cursor		; Get Cursor
	mov	ah,2
	mov	bh,0
	int	10h
	mov	ah,1
	cmp	Cimsg_Insert_Mode,0ffh
	jnz	curon1
	mov	ch,0
	mov	cl,0dh
	jmp	cursorc
curon1:	mov	ch,0bh			;10
	mov	cl,0dh			;10
	jmp	cursorc
_Cursor_On	endp

_Cursor_off	proc	far
	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	mov	dx,1900h		; Line 25 + 1
	mov	ah,2
	mov	bh,0
cursorc:int	10h
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret
_Cursor_off	endp


;===============================================================
;================================================================
;RANDOM READ TO CMD FILE
;Enter with message record number in BX, and destination in DX
_cmdread	proc	far
	push	es
	push	ds
	mov	si,bx			; SI = source
	mov	di,dx			; DI = destination
	push	ds
	pop	es
	mov	ds,Msg_Seg
crres1:	lodsb
	stosb
	or	al,al
	jnz	crres1
	pop	ds
	pop	es
	ret
_cmdread	endp

;================================================================
; Direct display of line at [Msg_Seg]:[BX] to screen RAM
	even
_msgread	proc	far
; Screen position = row * 80 + (col)
	pushf
	push	ax
	push	si
	push	di
	push	cx
	push	dx
	push	bp
	push	es			; Save ES

	push	bx			; Save string pointer
	call	 FAR PTR _screen_ram		; offset DI to screen, DX = Cursor
	pop	si

	mov	ch,video_mode
	or	ch,Color_BKG
	mov	bp,ds
	mov	ax,Msg_Seg
	mov	ds,ax

	even
ms_lp:	lodsb				; Get next character, SI=SI+1
	or	al,al			; Zero?
	jz	ms_xit			; Exit if so
	cmp	al,cr			; Carriage return?
	jnz	ms_lp1			; Skip if not
	mov	al,dl			; Go to beginning
	cbw				;  of line
	sub	di,ax
	sub	di,ax
	mov	dl,ah
	jmp	ms_lp			; Loop de loop

	even
ms_lp1:	cmp	al,lf			; Just ignore
	jnz	ms_lp2			;  line feeds

	add	di,160			; Index to next col/row pos
	inc	dh			; Inc Cursor
	cmp	dh,25
	jc	ms_lp
	mov	dh,25
	jmp	ms_lp

	even
ms_lp2:	cmp	al,7
	jnz	ms_lp3
	push	ds
	mov	ds,bp
	call	 FAR PTR _error_bell
	pop	ds
	jmp	ms_lp

	even
ms_lp3:	mov	ah,ch
	stosw
	inc	dl			; Increment Cursor
	cmp	dl,80			; End of line?
	jc	ms_lp
	mov	dl,0
	inc	dh
	cmp	dh,25
	jc	ms_1
	mov	dh,25
	mov	di,0f00h
ms_1:	jmp	ms_lp

	even
ms_xit:	mov	ds,bp
	mov	Cursor,dx
	mov	bx,si
	pop	es
	pop	bp
	pop	dx
	pop	cx
	pop	di
	pop	si
	pop	ax
	popf
	ret

_msgread	endp

;================================================================
; Direct display of line at DS:[BX] to screen RAM
	even
_comsg	proc	far
; Screen position = row * 80 + (col)
	pushf
	push	ax
	push	si
	push	di
	push	dx
	push	es			; Save ES

	push	bx			; Save string pointer
	call	 FAR PTR _screen_ram		; offset DI to screen, DX = Cursor
	pop	si

	even
ds_lp:	lodsb				; Get next character, SI=SI+1
	or	al,al			; Zero?
	jz	ds_xit			; Exit if so
	cmp	al,cr			; Carriage return?
	jnz	ds_lp1			; Skip if not
	mov	al,dl			; Go to beginning
	cbw				;  of line
	sub	di,ax
	sub	di,ax
	mov	dl,ah
	jmp	ds_lp			; Loop de loop

	even
ds_lp1:	cmp	al,lf			; Just ignore
	jnz	ds_lp2			;  line feeds

	add	di,160			; Index to next col/row pos
	inc	dh			; Inc Cursor
	cmp	dh,25
	jc	ds_lp
	dec	dh
	call	scroll_screen
	mov	di,0f00h
	jmp	ds_lp

	even
ds_lp2:	cmp	al,7
	jnz	ds_lp3
	call	 FAR PTR _error_bell
	jmp	ds_lp

	even
ds_lp3:	mov	ah,video_mode
	or	ah,Color_BKG
	stosw
	inc	dl			; Increment Cursor
	cmp	dl,80			; End of line?
	jc	ds_lp
	mov	dl,0
	inc	dh
	cmp	dh,25
	jc	ds_1
	dec	dh
	call	scroll_screen
	mov	di,0f00h
ds_1:	jmp	ds_lp

	even
ds_xit:	mov	Cursor,dx
	mov	bx,si
	pop	es
	pop	dx
	pop	di
	pop	si
	pop	ax
	popf
	ret

_comsg	endp

;================================================================
;character in register a output to console
	even
_ConOut	proc	far
	pushf
	push	ax
	push	dx
co_1:	cmp	al,7
	jnz	co_2
	call	 FAR PTR _error_bell
	jmp	noco

	even
co_2:	cmp	al,cr
	jnz	co_ncr
	mov	dx,Cursor		; Get Cursor
	mov	dl,0
	jmp	coc_ok

	even
co_ncr:	cmp	al,lf
	jnz	co_nlf
	mov	dx,Cursor		; Get Cursor
	jmp	conl

	even
co_nlf:	push	es
	push	di
	push	ax
	call	 FAR PTR _screen_ram
	pop	ax
	mov	ah,video_mode
	or	ah,Color_BKG
	mov	es:[di],ax
	pop	di
	pop	es

	inc	dl
	cmp	dl,80
	jc	coc_ok
	mov	dl,0
conl:	inc	dh
	cmp	dh,25
	jc	coc_ok
	call	scroll_screen
	jmp	noco

co_eop:	dec	dl
	even
coc_ok:	mov	Cursor,dx
	even
noco:	pop	dx
	pop	ax
	popf
	ret

_ConOut	endp

; Index to ram position in DI, return Cursor in DX
	even
_screen_ram	proc	far
	mov	dx,Cursor		; Get Cursor
_screen_ram	endp

	even
_sram_dx	proc	far
	mov	di,bx			; Save BX in DI
	mov	bl,dh			; Get row
	xor	bh,bh
	mov	ah,bh
	shl	bx,1
	mov	bx,Rowtbl[bx]
	mov	al,dl
	shl	ax,1
	add	bx,ax
	xchg	bx,di
	mov	es,Videoram		; Set ES to point to Display RAM
	ret
_sram_dx	endp

;================================================================
;character in register a output to console
	even
_Space_Out	proc	far
	pushf
	push	ax
	push	dx
	push	di
	push	es
	call	_screen_ram
	mov	ah,video_mode
	or	ah,Color_BKG
	mov	al,' '
	mov	es:[di],ax
	inc	dl
	cmp	dl,80
	jc	soc_ok
	mov	dl,0
	inc	dh
	cmp	dh,25
	jc	soc_ok
	call	scroll_screen
	jmp	noso
soc_ok:	mov	Cursor,dx
noso:	pop	es
	pop	di
	pop	dx
	pop	ax
	popf
	ret
_Space_Out	endp


	even
scroll_screen:
	push	si
	push	di
	push	cx
	push	es
	push	ds
	mov	ax,Videoram
	mov	es,ax
	mov	ds,ax
	mov	si,160			; Move from line 1 to line 0, etc
	xor	di,di
	mov	cx,(24 * 80)
	cld
	rep	movsw
	mov	ax,0F20h		; Space, with normal attibutes
	mov	cx,80
	rep	stosw
	pop	ds
	pop	es
	mov	Cursor,1800h
	pop	cx
	pop	di
	pop	si
	ret

;================================================================
_timeline_erase	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	mov	Cursor,0004h
	mov	cx,7
tlelp:	call	 FAR PTR _line_erase
	add	Cursor,100h
	loop	tlelp
	mov	Cursor,offset Timeline_Scr
	call	_screen_ram
	mov	cx,11 * 80		;cx = line length

	mov	ah,Color_BKG
	mov	al,' '
	rep	stosw
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
_timeline_erase	endp

	even
_dircur_lerase	proc	far
	mov	Cursor,bx
_dircur_lerase	endp

	even
_line_erase	proc	far
	pushf
	push	ax
	push	cx
	push	dx
	push	di
	push	es
	mov	dx,Cursor
	call	_screen_ram

	mov	ah,video_mode
	and	ah,00001111b
	or	ah,Color_BKG
	mov	al,' '
	mov	cx,80
	sub	cl,dl
	rep stosw
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	ax
	popf
	ret
_line_erase	endp

_dircur_infarea	proc	far
	mov	Cursor,bx
	push	bx
	mov	bx,SpacePointer(12)
	call	_comsg
	pop	bx
	mov	Cursor,bx
	ret
_dircur_infarea	endp

	even
_help_pos	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset List_Scr
	call	_screen_ram
	mov	cx,9 * 80		;cx = line length
	jmp	clrit
_help_pos	endp

;================================================================
; Clear to end of page (screen) from Cursor
_clear_eop	proc	far
	push	ax
	push	cx
	push	dx
	push	di
	push	es
	call	_screen_ram	; Get position to DI, Cursor to DX
	mov	cx,0f00h	; Max position
	sub	cx,di		; # to fill = end - start
	mov	ah,video_mode
	and	ah,00001111b
	or	ah,Color_BKG
	mov	al,' '
	shr	cx,1
	rep stosw
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	ax
	ret
_clear_eop	endp

_blank_screen	proc	far
	push	ax
	mov	al,Color_BKG
	mov	Color_BKG,07h		; Blank screen to dim video
	call	 FAR PTR _clear_screen
	mov	Color_BKG,al
	pop	ax
	ret
_blank_screen	endp

_clear_screen	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	di
	push	es
	mov	Cursor,0
	call	_screen_ram
	mov	cx,(80 * 25)
clrit:	mov	ah,video_mode
	and	ah,00001111b
	or	ah,Color_BKG
	mov	al,' '
	rep	stosw
	pop	es
	pop	di
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
_clear_screen	endp

;================================================================
; Send a message directly to the screen from the msg segment.
; ENTER: BX points to message offset "_ovr" equate
; Exit: BX points to start of next message.
; AX, CH, SI, DI ARE USED
_msg2screen	proc	far
	push	si
	push	es
	push	ds
	dim_VIDEO FALSE,FALSE			; Initiate to dim video
	call	_screen_ram		; Get Cursor
	mov	ah,video_mode		; Get video mode
	mov	ds,Msg_Seg
	mov	si,bx			; Source offset to SI
scrnd0:
scrnd1:	lodsb				; Get byte, inc si
	or	al,al
	jz	scrnd2
	cmp	al,252
	jb	m2s_4

	pop	ds
	mov	ch,video_mode
	rev_VIDEO FALSE,TRUE
	cmp	al,253
	jz	m2s_3
	dim_VIDEO FALSE,TRUE
	cmp	al,254
	jz	m2s_3
	norm_VIDEO FALSE,TRUE
	cmp	al,255
	jz	m2s_3
	blink_VIDEO FALSE,TRUE
	cmp	al,252
	jz	m2s_3
	mov	ah,ch
	mov	video_mode,ch
	push	ds
	mov	ds,Msg_Seg
	jmp	m2s_4

m2s_3:	mov	ah,video_mode
	push	ds
	mov	ds,Msg_Seg
	jmp	scrnd1

m2s_4:	stosw
	inc	dx
	jmp	scrnd1
scrnd2:	mov	bx,si
	pop	ds
	pop	es
	pop	si
	mov	Cursor,dx
	ret
_msg2screen	endp


;================================================================
;		enter text line on screen
;================================================================

;RANDOM MESSAGE READER
;Enter with the message number in BX
; Exit with BX pointing to the next message in overlay file
_MsgCntr	proc	far
	push	dx
	push	si
	push	di
	mov	dx,offset Screen_Buffer
	call	_cmdread
	push	si
	mov	bx,dx
	call	 FAR PTR _cntrtxt
	pop	bx
	pop	di
	pop	si
	pop	dx
	ret
_MsgCntr	endp

_cntrtxt	proc	far
	xor	ch,ch
	cmp	byte ptr [bx],ch	; Null line?
	jz	ftcoxit			; Exit if null line

	push	Cursor
	push	bx			; Save start of line
ftulp:	mov	al,[bx]
	cmp	al,cr			; CR end of line?
	jz	ftulpb
	or	al,al			; Null end of line?
	jz	ftulpb
	inc	ch			; Increment Count
	inc	bx			;  and position
	jmp	ftulp			;  and loop

ftulpb:	mov	al,81			; Pad = (80 - length) / 2
	sub	al,ch
	jz	JL0436
	js	JL0436
	rcr	al,1
ftsplp:	dec	al
	jz	JL0436
	push	ax
	mov	al,' '
	call	_ConOut
	pop	ax
	jmp	ftsplp
JL0436:	pop	bx
	call	_comsg
	dim_VIDEO FALSE,FALSE
	pop	Cursor
ftcoxit:ret
_cntrtxt	endp

;================================================================
; Display Time Code Values in Block Numbers
; Enter with BX pointing to time code string
_nblocks	proc	far
	mov	di,offset List_Scr + 208h
	call	_adv2chr
	mov	si,bx

nblock1:lodsb			; Get next digit
	or	al,al
	jz	nblockx
	mov	bx,offset bignumbers_ovr ; Top of big numbers
	sub	al,30h		; Make decimal
	mov	cx,10
nblock2:jz	nblock3
	add	bx,20
	dec	al
	loop	nblock2
nblock3:push	es
	mov	es,Msg_Seg
	mov	Cursor,di
	push	di
	mov	cx,5
nblock4:push	cx
	mov	cx,4
nblock5:mov	al,es:[bx]
	inc	bx
	call	_ConOut
	loop	nblock5
	add	di,100h
	mov	Cursor,di
	pop	cx
	loop	nblock4
	pop	di
	add	di,6
	pop	es
	jmp	nblock1
nblockx:ret
_nblocks	endp

;================================================================
; Display Time Code Values in Block Numbers
; Enter with BX pointing to time code string
; PRESET Cursor TO CORRECT LOCATION
_lblocks	proc	far
	push	es
	mov	di,Cursor

	call	_adv2chr
	mov	si,bx

lblcks:	mov	al,[bx]
	or	al,al
	jz	lblock1
	cmp	al,'0'
	jz	lblcks2
	cmp	al,':'
	jz	lblcks1
	cmp	al,';'
	jnz	lblock1
lblcks1:mov	byte ptr [bx],0ffh
	inc	bx
	jmp	lblcks
lblcks2:mov	byte ptr [bx],' '
	inc	bx
	jmp	lblcks

lblock1:lodsb			; Get next digit
	or	al,al
	jz	lblockx
	cmp	al,':'
	jz	lblock2
	cmp	al,';'
	jnz	lblock3
lblock2:mov	al,':'

lblock3:cmp	al,' '
	jnz	lblock4
	mov	al,':'+1

lblock4:cmp	al,0ffh
	jz	lbspace
	mov	bx,offset littlenumbers_ovr ; Top of big numbers
	sub	al,30h		; Make decimal
	cbw
	MULTIPLY_BY 9, AX
	add	bx,ax
	mov	es,Msg_Seg
	mov	Cursor,di
	push	di
	mov	cx,3
lblock5:mov	al,es:[bx]
	inc	bx
	call	_ConOut
	mov	al,es:[bx]
	inc	bx
	call	_ConOut
	mov	al,es:[bx]
	inc	bx
	call	_ConOut
	add	di,100h
	mov	Cursor,di
	loop	lblock5
	pop	di
lbspace:add	di,3
	jmp	lblock1

lblockx:pop	es
	ret
_lblocks	endp

;================================================================
; Dual tone error bell
_error_bell	proc	far
	test	Sounddisplay_Flags,errbell_SDBIT
	jnz	_baderror_bell
	ret
_error_bell	endp

_baderror_bell	proc	far
	push	bx
	push	dx
	push	cx

	test	CMDLINE_OPTS,MSWINcompat_BIT
	jz	beb1
	mov	ah,2
	mov	dl,7
	int	DOS
	call	_delfrm
	mov	ah,2
	mov	dl,7
	int	DOS
	jmp	bebx

beb1:	mov	dx,60
	call	ToneInt_SET
	mov	bx,440
	call	pitchout
	mov	dx,75
	call	ToneInt_SET
	mov	bx,267
	call	pitchout
bebx:	pop	cx
	pop	dx
	pop	bx
	ret
_baderror_bell	endp

_hibeep	proc	far
	push	bx
	push	dx
	push	cx

	test	CMDLINE_OPTS,MSWINcompat_BIT
	jz	hb1
	mov	ah,2
	mov	dl,7
	int	DOS
	jmp	hbx
hb1:	mov	dx,15
	call	ToneInt_SET
	mov	bx,880 * 2
	call	pitchout
hbx:	pop	cx
	pop	dx
	pop	bx
	ret
_hibeep	endp

_chimes	proc	far
	test	Sounddisplay_Flags,bell_SDBIT
	jnz	_beeper
	ret
_chimes	endp

_beeper	proc	far
	push	bx
	push	dx
	push	cx

	test	CMDLINE_OPTS,MSWINcompat_BIT
	jz	bepr1
	mov	ah,2
	mov	dl,7
	int	DOS
	jmp	beprx

bepr1:	mov	dx,60
	call	ToneInt_SET
	mov	bx,880
	call	pitchout
beprx:	pop	cx
	pop	dx
	pop	bx
	ret
_beeper	endp

ToneInt_SET:
	push	si
	push	es

	push	cs
	pop	es
	mov	bx,offset Tone_Flag	; ES:BX = tone Flag
	mov	ax,dx
	mov	cx,1000			; Convert to milliseconds
	mul	cx
	mov	cx,dx			; CX:DX = # of milliseconds
	mov	dx,ax
ToneIntBsy:
	cmp	byte ptr cs:Tone_Flag,0
	jz	tibok

	mov	ax,8301h		; Kill timer
	int	15h			; Set timer
	in	al,61h			; Turn tone off
	and	al,11111100b
	out	61h,al

tibok:	call	far ptr _Clear_Tone_Flag		; 6-24-1996
	mov	ax,8300h
	int	15h			; Set timer
	jnc	ToneIntok
	mov	ah,0bh
	int	DOS
	jmp	ToneIntBsy
ToneIntok:
	mov	cs:byte ptr Tone_Flag,0
	pop	es
	pop	si
	ret

Tone_Flag	db	0

_Clear_Tone_Flag	proc	far
	mov	byte ptr cs:Tone_Flag,0	; Clear flag 6-24-1996
	ret
_Clear_Tone_Flag	endp


	even
ToneOff_interrupt	proc	far
	push	ax
	push	ds
	mov	ax,SEG Int1c_Adr
	mov	ds,ax
	pushf
	call	dword ptr Int1c_Adr
	cmp	byte ptr cs:Tone_Flag,0
	jz	TOi_x
	in	al,61h			; Turn tone off
	and	al,11111100b
	out	61h,al
	mov	byte ptr cs:Tone_Flag,0
TOi_x:	pop	ds
	pop	ax
	iret
ToneOff_interrupt	endp

_music	proc	far
	push	es
	mov	es,Msg_Seg
	mov	si,offset music_ovr
	call	tone_on
dixagn:	push	si
	push	es
	call	locations_far
	pop	es
	pop	si
	mov	ah,11h		; Check for any key pressed
	int	16h
	jz	dixagn1
	call	 FAR PTR _Break_check
	jz	musicx
dixagn1:mov	ax,es:[si]
	inc	si
	inc	si
	cmp	ax,0ffffh
	jz	musicx
	mov	cl,ah		; Count factor to CX
	mov	ch,0
	cmp	al,0ffh
	jz	ptchdly
	mov	ah,ch
	cmp	ax,97		; # of table entries + 1
	jnc	musicx
	mov	bx,ax
	add	bx,bx
	add	bx,offset sound_ovr
	mov	bx,es:[bx]
	or	bx,bx
	jz	musicx
	call	pitchout
	even
ptchdly:call	_dixdly
	loop	ptchdly
	call	tone_off
	jmp	dixagn

musicx:	call	tone_off
	pop	es
	ret
_music	endp


; Play BX frequency
pitchout:
	push	dx			;freq = 1,193,182/note
	mov	dx,12
	mov	ax,34deh
	div	bx			; Set freq
	mov	bx,ax
	pop	dx
	mov	al,10110110b	;set 1/pitch into timer, then turn on tone
	out	43h,al
	mov	ax,bx
	out	42h,al
	mov	al,ah
	out	42h,al
tone_on:in	al,61h
	or	al,3
	out	61h,al
	ret

tone_off:
	in	al,61h
	and	al,11111100b
	out	61h,al
	ret

;================================================================
;	Draw a box.  Upper left Cursor in BX, lower left in DX
ul_char	equ	201
ur_char	equ	187
ll_char	equ	200
lr_char	equ	188
hz_char	equ	205
vt_char	equ	186

_DrawBox	proc	far
	push	cx
	push	si
	push	di
	push	es
	xchg	bx,dx
	call	_sram_dx
	xchg	bx,dx
	mov	ah,video_mode
	or	ah,Color_BKG
	mov	al,ul_char	; Upper left
	stosw
	mov	cl,dl		; Get ending col
	sub	cl,bl		; Get # of columns
	dec	cl		; Adjust for upper left corner char
	dec	cl		; and for lower corner
	mov	ch,0
	mov	al,hz_char	; Horizontal line character

	push	cx
	cld
	rep stosw
	mov	al,ur_char
	stosw

	push	bx		; Save upper left coord
	mov	cl,dh
	sub	cl,bh		; Get # of rows
	add	bh,cl		; BH points to bottom row
	xchg	bx,dx
	call	_sram_dx
	xchg	bx,dx

	pop	bx		; Restore BX
	pop	cx		; Restore length of horizontal line
	mov	ah,video_mode
	or	ah,Color_BKG
	mov	al,ll_char
	stosw
	mov	al,hz_char	; Horizontal line character
	rep	stosw
	mov	al,lr_char
	stosw
	inc	bh
	dec	dh
	xchg	bx,dx
	call	_sram_dx
	xchg	bx,dx

	mov	cl,dh		; Get ending col
	sub	cl,bh		; Get # of columns
	mov	ch,0
	inc	cl
	mov	ah,video_mode
	or	ah,Color_BKG
	mov	al,vt_char	; Vertical line character
	push	cx

drawbx3:mov	es:[di],ax
	add	di,160
	loop	drawbx3

	mov	bl,dl
	dec	bl
	xchg	bx,dx
	call	_sram_dx
	xchg	bx,dx
	pop	cx		; Restore length of horizontal line

	mov	ah,video_mode
	or	ah,Color_BKG
	mov	al,vt_char		; Vertical line character
drawbx4:mov	es:[di],ax
	add	di,160
	loop	drawbx4
	pop	es

	pop	di
	pop	si
	pop	cx
	ret
_DrawBox	endp

;================================================================
;		Draw a box around a menu
;	PQ values must have been previously set
;<------------ field --------------->
;_x1_-_xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
_DrawMenuBox	proc	far
	push	ax
	push	bx
	push	cx
	push	dx

	mov	al,PointShootData.PQ_tab	; Cols * Tab = width
	mov	cl,PointShootData.PQ_cols
	mul	cl		; AL = Breadth of entire menu after MUL
	mov	ah,81
	sub	ah,al
	shr	ah,1		; AH = margin value

	mov	bx,PointShootData.PQ_Cursor	; Get Cursor
	mov	dx,bx		;  to BX and DX
	mov	bl,ah		; left margin
	dec	bh		; Adjust upper right start row with buffer space
	dec	bl
	add	dh,PointShootData.PQ_rows
	add	dl,al
	inc	dl
	dim_VIDEO FALSE,FALSE
	call	_DrawBox
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
_DrawMenuBox	endp

;================================================================
;Display the Record and play lables, incuding AUX and BLACK.
_draw_machines	proc	far
	mov	dx,(r_line * 256) + mach_offset
	jmp	draw_machs
_draw_machines	endp

_draw_machttls	proc	far
	xor	dx,dx
draw_machs:
	mov	Cursor,dx
	dim_VIDEO FALSE,FALSE
	xor	cl,cl
	call	slave_check		; Check if R-VTR is LINKED
	jnc	drawrd
	rev_VIDEO FALSE,FALSE
drawrd:	mov	bx,offset From_R_Msg
	call	_comsg
	mov	al,'A'
	mov	ch,MAX_MACHINES - 1
	dim_VIDEO FALSE,TRUE

	even
dmachlp:push	ax
	inc	dh			; Increment screen position
	inc	cl			; Increment DEVICE #
	mov	Cursor,dx
	call	slave_check		; Set video mode, INC CL
	jnc	dmachl1

	rev_VIDEO FALSE,TRUE
	call	_ConOut
	mov	al,'s'
	cmp	byte ptr Slave_Table,cl	; Master?
	jnz	dmachla
	mov	al,'+'
dmachla:call	_ConOut
	call	_Space_Out
	jmp	dmachl3

dmachl1:call	multr_check
	jnc	dmachl2
	norm_VIDEO FALSE,FALSE
	pop	ax
	push	ax
	call	_ConOut
	rev_VIDEO FALSE,FALSE
	mov	al,'\'
	call	_ConOut
	mov	al,'r'
	call	_ConOut
	jmp	dmachl3

dmachl2:pop	ax
	push	ax
	call	_ConOut
	call	_Space_Out
	call	_Space_Out
dmachl3:pop	ax
	inc	al
	dec	ch
	dim_VIDEO TRUE,TRUE
	jnz	dmachlp
	ret
_draw_machttls	endp


;Display the MULTIPLE TRIM VTRS
_trim_draw_machines	proc	far
	mov	dx,(r_line * 256) + mach_offset
	mov	cl,0
	call	trim_check
	mov	Cursor,dx
	mov	bx,offset From_R_Msg
	call	_comsg

	mov	al,'A'
	mov	ch,MAX_MACHINES - 1
	even
tdm_lp:	inc	dh
	inc	cl
	call	trim_check
	mov	Cursor,dx
	call	_ConOut
	call	_Space_Out
	call	_Space_Out
	inc	al
	dec	ch
	jnz	tdm_lp
	call	trmoff
	ret
_trim_draw_machines	endp


;................
slave_check:
	test	Slave_Flags,Enabled_MSBIT
	jz	slvoff
	mov	si,offset Slave_Table
slvchk1:mov	ah,[si]
	inc	si
	cmp	ah,0ffh
	jz	slvoff
	cmp	ah,cl
	jnz	slvchk1
	stc
	ret
slvoff:	clc
	ret


;................
; ENTER:	CL = 0FFH
; Exit:		C=1, reverse video ON if found
;		C=0, dim video ON if not found
multr_check:
	test	MultRec_Flags,Enabled_MSBIT
	jz	multroff
	lea	si,Multrecord_Table	; Point to head of table
multrchk1:
	mov	ah,[si]			; Get DEVICE
	inc	si			; Increment table pointer
	cmp	ah,0ffh			; Check for end of table
	jz	multroff		; Return if end of table
	cmp	ah,cl			; Check for match
	jnz	multrchk1		; Loop if no match with this byte
	stc
	ret
multroff:
	clc
	ret

;................
trim_check:
	mov	si,offset Trim_Table
trmchk1:mov	ah,[si]
	inc	si
	cmp	ah,0ffh
	jz	trmoff
	cmp	ah,cl
	jnz	trmchk1
	blinkrev_VIDEO TRUE,TRUE
	ret
trmoff:	dim_VIDEO TRUE,TRUE
	ret


;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;		VMINPUT.ASM Support Routines
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
; Clear and init line
_tcline_init	proc	far

	mov	bx,offset Frames_Area
	call	_dircur_lerase
	cmp	Frame_Flag,0ffh
	mov	bx,SpacePointer(3)
	jnz	tcin1b
	mov	bx,offset Frames_Msg
	rev_VIDEO FALSE,FALSE
tcin1b:	call	_comsg
	norm_VIDEO FALSE,FALSE
	cmp	From_Flag,0ffh
	jnz	tcin1c
	call	 FAR PTR _display_froms

tcin1c:	mov	Cursor,offset Kbd_Tc_Pos
	mov	bx,offset Cimsg_String
tcin1pt:mov	al,[bx]
	or	al,al
	jz	tcin1r
	cmp	al,' '
	jz	tcin1p1
	cmp	al,'0'
	jz	tcin1p1
	cmp	al,':'
	jz	tcin1p1
	cmp	al,';'
	jz	tcin1p1
	call	_comsg
tcin1r:	ret
tcin1p1:call	_Space_Out
	inc	bx
	jmp	tcin1pt

_tcline_init	endp

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

frommsg_mac	macro
local mach
mach = 0
	mov	bx,offset From_R_Msg
	cmp	dl,mach
mach = mach + 1

	jz	from_iod1
	mov	bx,offset From_A_Msg
	cmp	dl,mach
mach = mach + 1

	if ALLOWED_VTRS GT 2
	jz	from_iod1
	mov	bx,offset From_B_Msg
	cmp	dl,mach
mach = mach + 1
	endif

	if ALLOWED_VTRS GT 3
	jz	from_iod1
	mov	bx,offset From_C_Msg
	cmp	dl,mach
mach = mach + 1
	endif

	if ALLOWED_VTRS GT 4
	jz	from_iod1
	mov	bx,offset From_D_Msg
	cmp	dl,mach
mach = mach + 1
	endif

	if ALLOWED_VTRS GT 5
	jz	from_iod1
	mov	bx,offset From_E_Msg
	cmp	dl,mach
mach = mach + 1
	endif

	if ALLOWED_VTRS GT 6
	jz	from_iod1
	mov	bx,offset From_F_Msg
	cmp	dl,mach
mach = mach + 1
	endif

	jz	from_iod1
	mov	bx,offset From_Aux_Msg
	cmp	dl,mach
mach = mach + 1

	jz	from_iod1
	mov	bx,offset From_Blk_Msg

endm

;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Display any active FROMs
_display_froms	proc	far
	push	bx			; Save IN,OUT,DUR msgs
	mov	dl,Fromwitch_Mach	; DH = type, DL = machine
	cmp	dh,5
	jnc	from_iod1

	frommsg_mac

from_iod1:
	call	 FAR PTR _frommsgs
	pop	bx			; Restore from IN, OUT, DUR msgs
	ret
_display_froms	endp

;----------------------------------------------------------------
_frommsgs	proc	far
	push	bx
	norm_VIDEO FALSE,FALSE
	mov	Cursor,offset Kbd_Tc_Pos - 1 ; Address +/- screen position
	cmp	Trim_Ci_Flag,0ffh
	jnz	fmmg2
	mov	al,Sign_Flag		; If TRIM request, then
	or	al,al			;  automatically display + or -.
	jnz	fmmg1			; Default to + if there is
	mov	al,PLUS_ASCII			;  no specifically requested
fmmg1:	call	_ConOut			;  sign.

fmmg2:	mov	bx,offset From_Area
	call	_dircur_lerase
	mov	bx,offset frommsg_ovr
	call	_msgread
	pop	bx
	call	_comsg
	ret
_frommsgs	endp

_fwhatmsgs	proc	far
	push	bx
	mov	bx,offset Fwhat_Area
	call	_dircur_lerase
	pop	bx
	call	_comsg
	ret
_fwhatmsgs	endp


;================================================================
;move buffer back a character
_Move_Left	proc	far
	cmp	Frame_Flag,0ffh
	jnz	mvl_ab1
	jmps	decimal_left

mvl_ab1:push ax
	push	bx
	push	cx
	mov	bx,offset Cimsg_String
	push	bx
	pop	dx			; Get current buffer adr+1 to DX
	inc	bx
; move the characters			;12:34:56:78  (start)
	call	mvl_ab6			; 23:45:67:_8
	mov	al,[bx]			; 23:45:67:8_ (ETC)
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
	inc	dx
	xchg	bx,dx
	jmp	move_lr_ret
_Move_Left	endp

mvl_ab6:call	mvl_ab			; Move 2
	call	mvl_ab			; Move 4
mvl_ab:	mov	al,[bx]			; (this will move 2)
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
	inc	bx
	inc	bx
	inc	dx
	mov	al,[bx]
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
	inc	bx
	inc	dx
	inc	dx
	ret

;move foward a character
_Move_Right	proc	far
	cmp	Frame_Flag,0ffh
	jnz	mvl_ab2
	jmp	decimal_right

mvl_ab2:push	ax
	push	bx
	push	cx
	mov	bx,offset Cimsg_String + 10
	push	bx
	pop	dx			; Get current buffer adr+1 to DX
	dec	bx

move_right_loop:	; Move the characters. 12:34:56:78  (start)
	call	mvr_ab6
	mov	al,[bx]			; _1:23:45:67
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
move_lr_ret:
	mov	byte ptr [bx],' '	; Terminate with space
	pop	cx
	pop	bx
	pop	ax
	ret
_Move_Right	endp

mvr_ab6:call	mvr_ab			; Move 2
	call	mvr_ab			; Move 4
mvr_ab:	mov	al,[bx]			; (this will move 2)
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
	dec	bx
	dec	bx
	dec	dx
	mov	al,[bx]
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
	dec	bx
	dec	dx
	dec	dx
	ret

decimal_left	proc	far
	push	ax
	push	bx
	push	cx
	mov	cx,11
	mov	bx,offset Cimsg_String
	mov	dx,bx
	inc	bx
	mov	ch,11
	call	_mmv
	jmp	declret
decimal_left	endp

decimal_right	proc	far
	push	ax
	push	bx
	push	cx
	mov	cx,10
	mov	bx,offset Cimsg_String + 9	; Point to last char - 1
	mov	dx,bx
	inc	dx

decrlp:	mov	al,[bx]				; Move a character
	xchg	bx,dx
	mov	[bx],al
	xchg	bx,dx
	dec	bx
	dec	dx
	loop	decrlp
	mov	byte ptr Cimsg_String,' '
declret:pop	cx
	pop	bx
	pop	ax
	ret
decimal_right	endp

;================================================================
; Draw the macro screen, display macro title
_Macro_Screen	proc	far
	mov	PointShootData.PQ_rows,16		; POINT AND SHOOT menu
	mov	PointShootData.PQ_tab,20
	mov	PointShootData.PQ_field,20
	mov	PointShootData.PQ_exitkey,offset Escape_xcmd
	mov	Input_Flag,INFL_menu

	call	_clear_screen
	mov	Cursor,0100h
	norm_VIDEO FALSE,FALSE

	cmp	byte ptr Temp_Macro,0	; Any Macro?
	jnz	Edm_nt1
	mov	bx,offset Empty_Msg
	jmp	Edm_ntz

Edm_nt1:mov	al,Mac2edit_Num
	call	 FAR PTR _macrotindex		; SI points to MACRO TITLE
	cmp	byte ptr [si],0		; Any title?
	jnz	Edm_d1
	mov	bx,offset Untitled_Msg
	jmp	Edm_ntz

Edm_d1:	push	si
	mov	bx,offset Ascii_Line
	mov	si,offset Macro_File_Msg
	call	_move_subdir
	mov	byte ptr [bx],' '
	inc	bx
	mov	si,offset Title_Msg
	call	_move_subdir
	mov	byte ptr [bx - 1],':'
	mov	byte ptr [bx],' '
	inc	bx
	pop	si
	push	si
	call	_move_subdir
	pop	bx
	mov	bx,offset Ascii_Line

Edm_ntz:call	_cntrtxt		; Display macro Name
	mov	byte ptr Cursor,0	; Go to beginning of line
	mov	bx,offset macromsg_ovr
	call	_msgread
	call	_Space_Out
	mov	al,Mac2edit_Num
	cmp	al,0ffh			; Default macro?
	jz	Edm_ntd
	call	_A_DecOut
	jmp	Edm_ntn
Edm_ntd:mov	bx,offset Mcd_Msg
	call	_comsg
Edm_ntn:dim_VIDEO FALSE,FALSE
	mov	bx,0300h
	mov	cx,80
	mov	al,'Ü'
	call	_hl_lp

	mov	di,0403h		; Cursor start
Mscr1:	mov	cx,4			; 4 columns
Mscr2:	mov	bx,di			; BX has Cursor
	push	cx
	mov	cl,PointShootData.PQ_rows
	mov	ch,0
Mscr3:	mov	Cursor,bx
	mov	al,'Æ'			; Separator
	call	_ConOut
	inc	bh
	loop	Mscr3
	mov	cl,PointShootData.PQ_tab
	mov	ch,0
	add	di,cx
	pop	cx
	loop	Mscr2

	mov	bx,1400h
	mov	cx,80
	mov	al,'ß'
	call	_hl_lp
	norm_VIDEO FALSE,FALSE
	ret
_Macro_Screen	endp

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;		FULL SCREEN MACRO DISPLAY
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
_Edm_Disp	proc	far
	norm_VIDEO FALSE,FALSE
	mov	PointShootData.PQ_Flag,PQF_MACRO
	mov	di,0400h		; Cursor start
	mov	PointShootData.PQ_Cursor,di

	mov	Macscrn_Count,macrolen / 2

;................................................................
; Set choices and columns
	mov	si,offset Temp_Macro
	mov	al,[si]
	shr	al,1			; Get char Count
	mov	PointShootData.PQ_choices,al
	mov	ah,0
	mov	ch,16
	div	ch			; AL = cols, AH = lines left over
	or	ah,ah			; Any left over?
	jnz	EdM_1a
	inc	al
	cmp	al,5
	jb	EdM_1a
	mov	al,4
EdM_1a:	mov	PointShootData.PQ_cols,al
	lodsb				; Get length again, inc SI
	mov	cl,al
	mov	ch,0
	shr	cx,1			; Half the byte Count
	or	cx,cx
	jnz	Edm_2
	jmp	Edm_Dx			; Return if nothing to display

;................................................................
; Display PRIMARY COMMANDS
Edm_2:	lodsw				; Get PRIMARY COMMAND
	dec	Macscrn_Count		; Adjust screen Count

	push	cx
	call	KeyCommand_Flags	; Returns with BP = Flags
	pop	cx

	call	Edm_COMMAND		; Display the PRIMARY COMMAND
	jz	Edm_Dx			; Exit if DONE

	or	bp,bp
	jz	Edm_2

	test	bp,ME_Single		; Single command?
	jnz	Edm_2			; Yes, jump

	cmp	ax,offset Enter_xcmd
	jz	Edm_2

;................................................................
; Display ASCII COMMANDS
Edm_3:	lodsw				; Get next Keyboard WORD
	dec	Macscrn_Count		; Adjust screen Count

;----------------------------------------------------------------
; If ENTER, TERMINATE COMMAND AND RECYCLE FOR NEXT PRIMARY COMMAND
	cmp	ax,offset Escape_xcmd
	jz	Edm_3aa
	cmp	ax,offset Enter_xcmd	; Enter?
	jnz	Edm_4
Edm_3aa:call	Edm_COMMAND		; Display the PRIMARY COMMAND
	jz	Edm_Dx			; Exit if DONE
	jmp	Edm_2

;----------------------------------------------------------------
; CHECK TIME CODE ENTRY?
Edm_4:	test	bp,ME_TC		; Entering time code?
	jz	Edm_4c			; Skip if NOT
	cmp	al,'0'			; Check for number
	jc	Edm_4a			; Display char.
	cmp	al,'9'+1
	jc	Edm_4a			; Display char.

Edm_4a:	push	cx
	push	ax
	call	_all_machine_keys	; Check for "FROM" machine keys
	pop	ax
	pop	cx
	jz	Edm_4b			; Z if found


	call	_set_trim_keys		; Check for FROM IN/OUT/DUR, etc
	jnz	Edm_4c
	call	Edm_COMMAND		; Display the PRIMARY COMMAND
	jz	Edm_Dx			; Exit if DONE
	jmp	Edm_2			; GET NEXT PRIMARY COMMAND

Edm_4b:	call	Edm_COMMAND		; Display the PRIMARY COMMAND
	jz	Edm_Dx			; Exit if DONE
	jmp	Edm_3			; Loop for more ASCII

;----------------------------------------------------------------
Edm_4c:	push	ax			; Save command word
	cmp	al,' '			; Control char?
	jb	Edm_3a
	cmp	al,80h
	jb	Edm_3b
Edm_3a:	jmp	Edm_3c
Edm_3b:	call	mac_asciientry
	pop	ax			; Restore command word
	jz	Edm_Dx

;----------------------------------------------------------------
; CHECK SINGLE DIGIT?
	test	bp,ME_Digit
	jnz	Edm_2
	jmp	Edm_3			; Get next PRIMARY COMMAND

Edm_3c:	pop	ax
	call	Edm_COMMAND		; Display the PRIMARY COMMAND
	jz	Edm_Dx			; Exit if DONE
	jmp	Edm_3			; Loop for more ASCII

; Exit from routine
Edm_Dx:	mov	cl,Macscrn_Count	; Get remaining screen Count
	mov	ch,0
	jcxz	Edm_dxr
Edm_Dxm:mov	al,' '			; Display space
	call	mac_asciientry
	jnz	Edm_Dxm
	mov	si,offset Temp_Macro	; SI has temporary macro buffer
Edm_dxr:ret
_Edm_Disp	endp


;................................................................
; Skip off to next line and return
Edm_skp:push	ax
	mov	bx,di			; Get Cursor
	inc	bh			; Increment row
	mov	al,byte ptr PointShootData.PQ_Cursor + 1
	add	al,PointShootData.PQ_rows
	cmp	bh,al			; Good row?
	jc	Edm_6			; Continue if so
	mov	bh,byte ptr PointShootData.PQ_Cursor + 1
	add	bl,20
Edm_6:	mov	di,bx
	dec	cx
	pop	ax
	ret

;................................................................
mac_asciientry:
	mov	Cursor,di
	inc	Cursor			; Display leading SPACE
	cmp	al,' '
	jae	macasc1
	rev_VIDEO FALSE,TRUE
	add	al,'@'
macasc1:call	_ConOut			; DISPLAY ASCII CHARACTER
	norm_VIDEO FALSE,FALSE
	inc	Cursor			; Display another SPACE
	inc	Cursor
	push	cx
	mov	cx,16
	mov	al,' '
maelp:	call	_ConOut
	loop	maelp
	pop	cx
	call	Edm_skp			; Skip to next line, DEC cx
	ret

;................................................................
; Display a PRIMARY COMMAND
Edm_COMMAND:
	push	ax
	push	cx

	push	bp
	call	KeyCommand_Flags	; Returns with BP = Flags
	pop	bp
	jz	Edm_C0

; Display ASCII command not found
	pop	cx
	call	mac_asciientry
	pop	ax
	ret

; Display ASCII command
Edm_C0:	mov	Cursor,di		; Set Cursor
	inc	Cursor
	mov	al,' '
	call	_ConOut
	add	Cursor,2

	mov	bx,Last_Command
	mov	cx,16
	mov	dx,cx

	push	es
	mov	es,Msg_Seg
Edm_C1:	mov	al,es:[bx]
	cmp	al,205			; Current border character
	jnz	Edm_C2
	inc	bx
	loop	Edm_C1
Edm_C2:	mov	al,es:[bx]
	cmp	al,205
	jz	Edm_C3
	inc	bx
	call	_ConOut
	dec	dx
	loop	Edm_C2
Edm_C3:	pop	es
	mov	cx,dx
Edm_C4:	call	_Space_Out
	jcxz	Edm_Cx
	loop	Edm_C4
Edm_Cx:	pop	cx
	call	Edm_skp			; Skip to next line
	pop	ax
	ret

;----------------------------------------------------------------
; Get description to Last_Command, Flag to bp
KeyCommand_Flags:
	push	si
	push	di
	mov	si,offset Cmdtbl1
	mov	di,offset keys_ovr - 16
	mov	bx,offset CommandFlag_Table
	mov	cx,ax			; Save character in CX
Edm_Kf1:add	di,16
	lodsw				; Get Scan code
	cmp	ax,cx
	jz	Edm_Kf2			; Jump if match
	inc	bx
	inc	bx
	inc	si			; Point to next chars
	inc	si
	inc	ax			; Check for end of commands (0ffffh)
	jnz	Edm_Kf1
	mov	bp,ax			; Clear Flags
	mov	di,ax			; Zero out command
	add	ax,cx			; Move CX to AX, set Z=0
	jmp	Edm_Kf3

Edm_Kf2:mov	bp,[bx]			; Get Flags
Edm_Kf3:mov	Last_Command,di
	pop	di
	pop	si
	ret


;----------------------------------------------------------------
_Edm_inschar	proc	far
	mov	cl,Macedit_Choice
	mov	ch,0
	dec	cx
	shl	cx,1			; CX has position of command

	push	cx			; Save position
	push	ax			; Save character

	mov	ax,offset macrolen	; Get length of macro (less length byte)
	sub	ax,cx			; AX = # bytes to move
	mov	cx,ax

	inc	cx
	inc	cx
	mov	di,offset Temp_Macro
	inc	di
	add	di,offset macrolen	; SI points to end of macro
	mov	si,di
	inc	di
	inc	di
	push	es
	push	ds
	pop	es
	std
	rep movsb
	cld
	pop	es
	pop	ax			; Restore character
	pop	cx			; Restore position
	inc	cl			; Increment position

	mov	ds:[di],ax		; Save character
	inc	Macedit_Choice		; Increment position

	mov	si,offset Temp_Macro
	inc	byte ptr [si]		; Increase size of macro
	inc	byte ptr [si]
	ret
_Edm_inschar	endp
;----------------------------------------------------------------
; Delete current character (or backspace) in macro
_Edm_delone	proc	far
	mov	cl,Macedit_Choice
	mov	ch,0
	dec	cx
	shl	cx,1			; CX has position of command

	mov	si,offset Temp_Macro	; Get macro pointer
	mov	dx,si			; Get macro pointer
	inc	dx
	add	dx,cx			; DX points to char to delete
	mov	bx,dx
	inc	bx
	inc	bx
	mov	ax,offset macrolen - 1	; Get length of macro (less length byte)
	sub	ax,cx			; AX = # bytes to move
	mov	cx,ax
	call	_mmv16
	dec	byte ptr [si]		; Reduce size of macro
	dec	byte ptr [si]
	ret
_Edm_delone	endp

;----------------------------------------------------------------
; Adjust position
_Edm_Position	proc	far
	mov	cl,Macedit_Choice	; Get position, 1 to MacroLen
	mov	ch,0
	dec	cx			; Adjust for offset from 0
	shl	cx,1			; Two bytes per keystroke
	cmp	cl,byte ptr Temp_Macro
	jb	EdM_Psx			; Jump if 2*position > length
	dec	Macedit_Choice
	jnz	EdM_Psx
	mov	Macedit_Choice,1
EdM_Psx:ret
_Edm_Position	endp

;================================================================
; AL = macro to title
_TitleTheMacro	proc	far
	cmp	al,0ffh
	jnz	mactl1
	mov	si,offset Default_Command + 80h
	jmp	mactl2
mactl1:	call	 FAR PTR _macrotindex		; Index to the macro title in SI
mactl2:	call	_kbd_cln
	mov	bx,offset Title_Header	;  Name of this macro
	call	_comsg
	mov	al,macrotlen - 1
	call	cimsg_wrk_far
	or	al,al
	jz	mactx
	mov	cx,macrotlen
mactl:	mov	al,[bx]
	mov	[si],al
	inc	bx
	inc	si
	or	al,al
	loopnz	mactl
mactx:	ret
_TitleTheMacro	endp



;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;Save macro to buffer
_macrosav	proc	far
	call	 FAR PTR _macroindex		; Index to the proper macro
_macrosav	endp

;................................................................
;Enter with BX pointing to a string.
;String = length byte, string...
_macsaver	proc	far
	cmp	RunningCMD_Buf,0	; Check for previous macro installed
	jnz	insert			; Insert line into buffer
	mov	cl,[bx]
	or	cl,cl
	jz	macsavx
	mov	ch,0
	mov	RunningCMD_Cnt,cx
	mov	RunningCMD_Buf,cx
	inc	bx				; Point to macro commands
	mov	dx,offset RunningCMD_Buf +  2
	call	_mmv16
	mov	RunningCMD_Ptr,offset RunningCMD_Buf + 2
macsavx:ret
_macsaver	endp

_chrwait	proc	far
	cmp	BuiltInMacro,0		; Built in macro running?
	jnz	maconex
	cmp	RunningCMD_Buf,0	; Any macro running?
	jnz	maconex
	mov	Cursor,offset Keyboard_Scr
	call	rdchar_FAR
_chrwait	endp

;Put one character in to the command buf (EXCEPT FOR Break CHARACTERS)
_macone	proc	far
	call	 FAR PTR _Break_check
	jz	maconex
	mov	bx,offset Temp_Wrkspce
	mov	byte ptr [bx],2		; Length of command
	mov	[bx + 1],ax		; Command
	call	_macsaver
maconex:ret
_macone	endp

;================================================================
;Insert a substring into a string
;Entry: BX = address of macro substring string
;Exit:	Carry = 0 if no errors.
;	Position in new string = position in old string
;	RunningCMD_Cnt in new string = RunningCMD_Cnt in old string + new string length
;
insert	proc	far
	push	si
	push	di
	push	es

	push	ds
	pop	es			; ES = DS

; Clean up the running macro. e.g. get rid of already executed commands
; # of chars already used = RunningCMD_Buf+2 - [RunningCMD_Ptr]
	mov	si,RunningCMD_Ptr		; Get current pointer
	mov	ax,si
	sub	ax,offset RunningCMD_Buf + 2	; Subtract start of command buffer
						;  so CX = number of commands used

	mov	di,offset RunningCMD_Buf	; Get char Count in buffer
	mov	cx,[di]
	sub	cx,ax				; CX = Count of remaining commands
	mov	[di],cx				; Put it back
	add	di,2
	cld
	rep movsb
	mov	RunningCMD_Ptr,offset RunningCMD_Buf + 2 ; Re-ini pointer

; Make room in the current macro for the new string
; BX points to new string with BYTE length
	mov	cl,[bx]				; Get length of substring
	mov	ch,0
	mov	si,offset RunningCMD_Buf
	mov	ax,[si]				; Get length of CMD
	add	si,ax				; Point to last command in buf
	mov	di,si
	add	di,cx				; Index to where to move bytes
	push	cx				; Save Count of command bytes
	add	cx,ax				; Add in # of bytes to insert
	add	si,2
	add	di,2
	std
	rep movsb				; Make room
	pop	cx

	mov	di,offset RunningCMD_Buf + 2	; Destination for substring
	mov	si,bx				; Source string address
	inc	si				; Skip over length byte

	push	cx
	cld
	rep movsb
	pop	cx

	add	ax,cx
	mov	RunningCMD_Buf,ax
	mov	RunningCMD_Cnt,ax

	pop	es
	pop	di
	pop	si
	ret
insert	endp

;................................................................
;Index to macro number (AL) macro address
; Exit with BX pointing to macro
; AX, CX are saved
_macroindex	proc	far
	push	ax
	push	cx
	cmp	al,0ffh
	jnz	macind1
	mov	bx,offset Default_Command
	jmp	macindr
macind1:cbw
	mov	cx,ax			; Macro number 0 - 9 to CX
	mov	bx,offset Macro0	; BX=Start of macros
	mov	dx,macrolen + 2		; DX=Length of macros (plus length byte)
	or	al,al			; Check for macro 0
	jz	macindr
macindx:add	bx,dx			; Else index to
	loop	macindx			; The correct macro number
macindr:pop	cx
	pop	ax
	ret
_macroindex	endp

;................................................................
; Get the pointer to the macro Name in SI
_macrotindex	proc	far
	push	ax
	push	cx
	push	bx
	cmp	al,0ffh
	jnz	mactnx1
	mov	bx,offset Default_Command + 80h
	jz	mactndr
mactnx1:cbw
	mov	cx,ax			; Macro number 0 - 9 to CX
	mov	bx,offset Macro_Ttls	; BX=Start of macro titles
	mov	dx,macrotlen		; DX=Length of titles
	or	al,al			; Check for macro 0
	jz	mactndr
mactndx:add	bx,dx			; Else index to
	loop	mactndx			; The correct macro number
mactndr:mov	si,bx
	pop	bx
	pop	cx
	pop	ax
	ret
_macrotindex	endp




;================================================================
; Get number from operator, carry set upon return if not number.
;================================================================
; Exit: If C=0 then AL = binary digit, DX = ASCII Keystroke
;	If C=1 then AX and DX both have ASCII Keystroke
_rdnum	proc	far
	call	rdchar_FAR
	mov	dx,ax
_rdnum	endp

_cknum	proc	far
	cmp	al,'0'
	jc	stcret
	cmp	al,'9'+1
	jnc	stcret
	sub	al,'0'
	clc
	ret
stcret:	stc
	ret
_cknum	endp

;================================================================
_Break_check	proc	far
	or	ax,ax
	jz	bcx
	cmp	ax,offset Scrini_xcmd
	jz	bcx
	cmp	ax,offset Space_xcmd
	jz	bcx
	cmp	ax,offset Escape_xcmd
bcx:	ret
_Break_check	endp


;================================================================
; BX points to buffer, CL has length
_Clear_Cimsg_Buffer	proc	far
	mov	bx,offset Temp_Wrkspce
	push	bx
	push	cx
	xor	ch,ch
	cmp	cl,80h
	jz	ccb1
	inc	cl
ccb1:	mov	[bx],ch
	inc	bx
	loop	ccb1
	pop	cx
	pop	bx
	ret

_Clear_Cimsg_Buffer	endp

; Calculate the string length of string in Temp_Wrkspce
; ENTER: AL = max length of string
_Calc_EndOfString	proc	far
	mov	bx,offset Temp_Wrkspce
	mov	cl,al			; Max length to CL
	xor	ch,ch
cst1:	cmp	byte ptr [bx],0		; Find end of line
	jz	cstx
	cmp	byte ptr [bx],cr
	jz	cstx
	inc	ch			; Increment position
	inc	bx
	dec	al			; Can't do more than max length
	jnz	cst1
cstx:	push	bx			; Make sure its terminated
	push	cx
	inc	ch			; Add termination byte
cst3:	mov	byte ptr [bx],0
	inc	bx
	inc	ch
	cmp	ch,cl
	jb	cst3
	pop	cx
	pop	bx
	ret
_Calc_EndOfString	endp

;================================================================
_Keyboard_reset	proc	far
	push	ds
	push	bx
	mov	ax,40h
	mov	ds,ax
	mov	bx,17h
	and	byte ptr [bx],10111111b	; Set capslock off
	or	byte ptr [bx],00100000b	; Set numlock on
	pop	bx
	pop	ds
	ret
_Keyboard_reset	endp

_Keyboard_caps	proc	far
	push	ds
	push	bx
	mov	ax,40h
	mov	ds,ax
	mov	bx,17h
	or	byte ptr [bx],01000000b	; Set capslock on
	pop	bx
	pop	ds
	ret
_Keyboard_caps	endp

_Keyboard_on	proc	far
	push	ax
	in	al,21h
	and	al,not IRQ_keyboard; Turn Keyboard back on
	out	21h,al
	pop	ax
	ret
_Keyboard_on	endp

_Keyboard_off	proc	far
	push	ax
	in	al,21h
	or	al,IRQ_keyboard		; Clear Keyboard interrupt mask
	out	21h,al
	pop	ax
	ret
_Keyboard_off	endp

_Keyboard_set	proc	far
	push	ds
	push	bx
	mov	ax,40h
	mov	ds,ax
	mov	bx,17h
	and	byte ptr [bx],11011111b	; Set numlock off
	pop	bx
	pop	ds
	ret
_Keyboard_set	endp


BSEG	ends

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
