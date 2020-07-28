; Last revised: 2-22-1995, 11:12:26   (C)1989-1995 Norman H. Strassner

;VMLIBS.ASM
; Library files for THE SES EDITING SYSTEM
;

%nolist
include	VM.EQU
%list

extrn Assembly_Mode:byte,Clear_Flag:byte,Current_Machine:byte
extrn Current_Source:byte,Default_Mode:byte,Edl_Fcm:byte
extrn Evnt_Replace_Flag:byte,Frame_Flag:byte,From_Machine:byte
extrn Keybkgnd_Src:byte,Keyfor_Src:byte,Last_Fcm:byte,MatchingTC_Fcm:byte
extrn Mode_Flag:byte,Reelrecallvtr:byte,Rtcf:byte,Sortwhat:byte,Swap_Bin:byte
extrn Tag_Flag:byte,To_Machine:byte,Trans_Type:byte

extrn AXstd_Msg:word,Hdeptr:word
extrn A_Reel_Num:word,Alb_Pntr:word,Ascii_Line:word,Aux_Reel_Num:word
extrn Auxmmsg:word,BLstd_Msg:word,Badmode_Fill:word,Bin_Table:word
extrn Blk_Reel_Num:word,Blkmmsg:word,Bytstr1:word,Bytstr2:word,Bytstr3:word
extrn Bytstr4:word,Clean_Offset:word,Cln_Evnt_End:word,Cln_Evnt_Strt:word
extrn Count:word,Current_BKGbuf:word,Current_Duration:word,Current_Event:word
extrn Current_Event_Adr:word,Current_FORbuf:word,Current_FRMbuf:word
extrn Current_Inbuf:word,Current_Outbuf:word,Current_Reel_Adr:word
extrn Current_TObuf:word,Current_VTRS:word,Dfbuf1:word,Dfbuf2:word
extrn Dhours_Table:word,Dmin_Cnt:word,Dminutes_Table:word,Dropframe_Msg:word
extrn Dseconds_Table:word,EDL_Bin:word,EDLoptions_Flags:word,Edl_Formats:word
extrn Elaptm:word,Entime:word,Event_Storage:word,Exchbuf1:word,Exchlen:word
extrn Extras:word,Fcm_Header:word,File_Title:word,Framesec_Msg:word
extrn From_Aux_Msg:word,From_Blk_Msg:word,Gpi0:word,Gpi_Flags:word
extrn Gpi_Header:word,Hrs_Cnt:word,Hundredhrs:word,Machine_Lables:word
extrn Master_Msg:word,Matchframe_From:word,Max_Lines:word,Min_Cnt:word
extrn Mode_Pntr:word,Move_Adr:word,Mtbl_Length:word,MultRec_Flags:word
extrn Next_Avail_Num:word,Next_Edit:word,Nhours_Table:word
extrn Nminutes_Table:word,Nondrop_Msg:word,Nseconds_Table:word
extrn Offset_Buffer:word,Ofspeed_Msg:word,Oldgpis:word,Oldslave_Table:word
extrn Operational_Flags:word,Out_Msg:word,Pmc_Flags:word,Pmc_Header:word
extrn Port:word,R_Reel_Num:word,R_Tc:word,Ramp_Flags:word,Ramp_Header:word
extrn Rec_Header:word,Reel_Assignments:word,Reelrecallmsgptr:word
extrn Saved_Marks:word,Slave_Flags:word,Slave_Header:word,Slave_Table:word
extrn Sort_Iters:word,Sort_Reeladr:word,Sortmatch_In:word,Sortmatch_Out:word
extrn Spd_Flags:word,Spd_Header:word,Split_Aud_Msg:word,Split_Dly_Msg:word
extrn Split_Type:word,Split_Vid_Msg:word,Sttime:word,Tags_Table:word
extrn Tcdispbuf:word,Temp_Tc_Buf:word,Thousand:word,Title_EDLev:word
extrn Twenty4hrs:word,Twenty4hrs_N:word,Undo_Buffer:word,Vt_Msg:word
extrn Vtrcb:word,Vtrs_In_Edit_Table:word,Where2_Number:word,Work_Event:word
extrn Workspace_Flags:word,asmcontinue_ovr:word,dirbuff:word,enabled_msg:word
extrn newreel_ovr:word,newreelfirst_ovr:word,newreelsecond_ovr:word
extrn oldgpi_Flags:word,oldmultRec_Flags:word,oldpmc_Flags:word
extrn oldramp_Flags:word,oldslave_Flags:word,oldspd_Flags:word
extrn preread_header:word

extrn Machine_Change:near,Mtchvtr:near
extrn Progmotion_Tbl:near,norm_kbd:near

extrn Machine_Change_Far:far,get_vtrcb_FCM_FAR:far
extrn Machine_Take_Far:far,Mtchvtr_FAR:far,Tagthis_Vtr_FAR:far
extrn _Break_check:far,_ConOut:far,_DelayMilliseconds:far,_EDstats:far
extrn _NewDuration:far,_RqstNewRvtFCM:far,_SetNewRvtFCM:far,_advance:far
extrn _chimes:far,_cmp24b:far,_cmp24b_DSES:far,_cmp24b_ESDS:far,_cmpchr:far
extrn _comsg:FAR,_comsg_store:far,_emclear:far,_evnt_dispthis:far
extrn _help_pos:FAR,_index2edspeed:FAR,_kbd_cln:far,_make_ucase:far
extrn _mmv3_ds2es:far,_mmv3_es2ds:far,_mmv3byt:far,_mmv:far,_mmv_DSES:far
extrn _mmv_ESDS:far,_mpbadd:far,_mpbdiv:far,_mpbmul:far,_mpbsub:far
extrn _msgread:far,_mvb2st1_es:far,_mvb2st3:far,_mvb2st4:far,_space_store:far
extrn _split_without:far,_store_Spaces:far,_tcm_store:far,_title_loop_ES:far
extrn _upd_getrel:far,_upd_getscr:far,clear_edit_FAR:far,rdchar_FAR:far

BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg

Public  _EDL2ASCII, edlasc0, edlasc1, edl_asc1a, edl_asc1b, _PREREAD2ASCII
Public  edl_asc1c, edl_asc1d, edlasc2, edlasc3, edlasc4, edlrlf, edlrlg, edlrlc
Public  edlrok, edlasc5, edlasc6, edla6a, edlrs, edlrsr, edlasc7, tcemode
Public  tcemdlp, JL0507, tcekey, tcekey1, tcekey4, tcekey4a, tcekey5, tcekey5a
Public  tcenkey, NL0507, JL0507a, JL0507b, JL0508, tcco2, tcco3, tcco3n, tcco4
Public  tcco4a, tcco5, tcco6, _cmtcmsg, cmtcms1, cmtcms2, cmtmsgr, e2ax
Public  _GPI2ASCII, gpi2a3, gpi2a4, _SLV2ASCII, slv2a2, slv2a3, slv2a4, slv2a5
Public  slv2af, _REC2ASCII, _SPD2ASCII, _PMC2ASCII, _RAMP2ASCII
Public  StoreDecimalDigits, sddcmd1, _md_speed, _md_plsmin, mdgn1, mdgn3, mdgn4
Public  ExtraHdrAndReel, eharlp, _edl_ldisp, JL0510, _edl_ddisp, JL0512, edldd1
Public  _force_fcm, _wrt_fcm, _wrtfcm0
Public  _wrt_split, wrtspl1, wrtsplx, _splcap_mmv, splcapl
Public  _ALterm, _check4edl
Public  _clear_pin, _clear_pout, _clear_pdur, _clear_rin
Public  _clear_rout, _clear_rdur, _clear_tc, _clear_event, _edit_tagging
Public  clr4efx, clr4ef1, clr4key, clr4ke1, clr4cut, clr4all, _clear_outs
Public  clout1, _tag_varispeeds, _tagfrom_tagstable, tft_1, tag_from_tbl
Public  tagfrom_edl, _cnvt2dec, c2d_0, c2d_1, c2d_2, c2d_5
Public  _cnvt2mp_ES, _cnvt2mp_DS, cnvt2mpn, cnvt2mpb, prs24xx, cnvt2mpdec
Public  _cnvt2tc_ES, _cnvt2tc_DS, cnvt2t1, cnvt2t2
Public  cnvt_reduce, cnvt2t2a, cnvt2t3, c2tch_1, c2tch1a, c2tch_2, c2tc_minutes
Public  c2tcm_1, c2tcm1a, c2tcm_2, c2tc_seconds, c2tcs_1, c2tcs_2, c2tc_frames
Public  cnvt2tx, _big_DecOut, bigdec1, bigdec2, bdpad0, bdpad1, bdpad2, bdpad3
Public  _check4marked, c4mrk1, c4mrk2, c4mrkn, c4mrky, _getlast_reel
Public  _getlast_pin, _getlast_pout, _getlast_rin, _getlast_rout, _getlast_dur
Public  _getlast_mode, _getlast_ptcd, _getlast_rtcd, _getlast_gpi
Public  _getlast_extra, _getlast_Flags, _getlast_tc, _getprev_pin
Public  _getprev_pout, _getprev_rin, _getprev_rout, _getprev_mode, _getprev_tc
Public  _getthis_pin, _getthis_pout, _getthis_rin, _getthis_rout, _getthis_mode
Public  _getthis_tc, _delsec, _delhalf, _delqrtr, _delfrm, _delfld, _delms
Public  _deltick, _dixdly, _delbrk, _delhnd, _Set_AUXBLACK, CAXBL3, caxblx
Public  _index_storage, istor1, istor2, istor3, _index2bin
Public  _E_evn_l, _E_emn_p, _e_rel_l, _E_rel_p, _E_mod_l, _E_mod_p, _E_ab_p
Public  _E_rmrk, _E_flgs, _E1_flgs, getEflg, _left_set_reel, lsr_lp, lsr_pd
Public  _left_set2edl, rsr_lp, rsr_pd, _find_edit_DX, _find_edit_BX, fndelp
Public  fndelp1, fndnf, fndf, _check4comment, ckcmtx, _instring, instrl
Public  instrsx, instrl2, instrno, instrfn, _Save_All_Marks
Public  _Save_Marktable, _Restore_All_Marks, _Restore_Marktable, _get_in
Public  _get_out, _get_dur, getinoutdur, getinoutdur1, _Sttime_move
Public  _Entime_move, _Elaptm_move, _tmves, _sttime_move_ES, _entime_move_ES
Public  _elaptm_move_ES, mvesx
Public  _ReCompute_EFX, rcomp0, _rcomp1, DISS_rcomp, Dcomp1
Public  Dcomp1a, Dcomp2, Dcomp3, Dcomp3a, Dcomp4, Dcomp5, Dcomp5a, Dcomp5x
Public  Dcomp6, _Ncomp_done, _TOdur_eq_Rdur, _Rdur_eq_TOdur, _Rdur_eq_FRMplusTO
Public  _TOdur_equ_RminusFRM, _FRMdur_eq_null, _KEY_rcomp, Kcomp1, Kcomp1a
Public  Kcomp2, Kcomp2a, Kcomp3, Kcomp3a, Kcomp4, Kcomp5, Kcomp6, Kcomp7
Public  _BKGdur_eq_Rdur, _Rdur_eq_FORplusBKG, _BKGdur_equ_RminusFOR
Public  _FORdur_eq_null, _ReCompute_CUT, Ccomp1, Ccomp2, Ccomp3, Ccomp_Done
Public  _cnvt2nd_ES, _cnvt2nd, c2df, c2df1, c2dfx, _cnvt2df_ES, _cnvt2df_FAR
Public  _cnvt2df, c2nd, c2nd1, c2ndx, _calc_frames, clcfrnz, frmrmx, _div_tc
Public  _div_tcl, _div_tcx, _drop_calc, non_drop_calc, _nddcalc, ndclx
Public  _sort_match, srtb_1, srtb_2, srtxit, srtf_1, srtf_1a, srtf_1x, srtf_eol
Public  _compute, _computer, compu1, compu2, compu3, compux, _up_dur, _up_out
Public  _up_in, _update_out, _update_in, _timdif, timdifa, _timadd, _mod24hrs
Public  m24h1, _mod100hrs, modxit, _clean_last, cln001, cln003, cln004, clnexit
Public  cln005, cln005A, cln006, cln007, JL0830, cln008, clnxit, make_prev
Public  make_next, g_ofset, nrin_orout, orin_nrin, nrout_orout, nrout_orin
Public  mmv2wrkspce, mmv2w, _reel_match, srtr_1, srtr_2, srtrxit
Public  _compute_Flags, Ciod2, Ciod3, Ciod4, Ciod5, Ciodx, Ciod_chk
Public  Ciod_chkx, _sort_reels, SR_mnlp, SR_skp, SR_StoreReel, SRsr0, SRsr1
Public  SRsr2, SRsr5, SR_in1, SR_insert, SR_insx, SR_append, SR_term, SR_storit
Public  SR_stor, SR_cmpchr, SR_cmpch0, SR_cmpch1, SR_leftsets, SR_ls1, SR_ls2
Public  SRLsnxt, SRls_x, _srtbin2bin, sb2bx, _savebin, _binmmv, _bin3set
Public  _cnv2b_ES, _convert2bin, cnv2b, d16lp, d16x, _atoi, atoilp, atoix
Public  _dltoi, dltoilp, dltoix, _convert2hex, cnv2h, h16lp, h16lp1, h16lp2
Public  h16x, _make_hexword, _make_hexbyte, make_hexnib, make_hexnib1
Public  _calc_curdur, _calc_cdx, _calc_evdur, _cmp24b_ESES, c24bEEx, _find_mode
Public  _modfndr, modfnd1, modfndx, modfnde, _all_machine_keys, _machine_keys
Public  mkeyx, _set_trim_keys, stkeyx, _machine_disp, mach_disp2, mach_disp1
Public  machdx, _check_setkeys, cskx, _Bin_Hdr, _get_lpt_ports, _SaveWorkspace
Public  _RestoreWorkspace, _dec1000_pad, _decimal_pad, _decpad0, _decpadt
Public  _make_dec, _make_declp, JL1140, _itoa100, itl10, _itoa, _itoado
Public  _itoalp, JL1140a, _stor02b, _add_store, _notate_Extras, notexl, notexok
Public  notex1, _check_mode, chkmod1, chkmodx, _match4recall, m4rclf, mvrclt
Public  _matchforcedrecall, mframode, mfdr0, mfdr1, mfdr2, mfdrer, mfdrok
Public  _MoveReel_EDLtoMtbl, mretm0, mretm1, mretok, mretm2, _ContinueAutoAsm
Public  caalp, caax, _match_thisreel, _match_reels, _match_master, mtrl1, rlklp
Public  rlkx, rlkret, _Clear_WorkEvent, CWElp, _clear_list, _Check4reel
Public  crl_cut, crl_key, ck4rlx, ck4reel, ck4rlok, _make_event
Public  mkevfcm, c24bm, mkevnpm, _make_room, mkrmlp, mkrmxt, _delete, deletex
Public  _line_first, lfrstt, lfrstr, lfrstc, lfrstf, _line_next, lnxtlp, lnxtx
Public  _advance2next, _advance2line, adv2l1, adv2lx, checklast_edit, clp_1
Public  clp_3, _Check4MoreEvents, cme_1, cme_2, cme_3, index2next, inlist
Public  outoflist, _SaveSlavesToEditTable, sie_1, sie_xit, sie_clr, _SaveVtrInEditTable, vie_1
Public  _VTRinEdit_check, vec_1, vec_nf, vec_f, 

;================================================================
;	Convert a line from the EDL to an ASCII line
;================================================================
;ENTER:	BX points to EDL line
;Exit:	Carry=1 (set) if single line
;	BX points to ascii line
;	DX points to the EOL

_EDL2ASCII	proc	far
	mov	Alb_Pntr,offset Ascii_Line	; Save ascii line pointer
	mov	al,es:[bx].cmnt_lofst
	cmp	al,Editline_EDIT		; Valid EDIT?
	jz	edlasc2
	cmp	al,Editline_GPI			; Valid GPI?
	jnz	edlasc0
	call	FAR PTR _GPI2ASCII
	ret
edlasc0:cmp	al,Editline_SLAVE		; Valid SLAVE?
	jnz	edlasc1
	call	FAR PTR _SLV2ASCII
	ret
edlasc1:cmp	al,Editline_SPD			; Valid SPD?
	jnz	edl_asc1a
	call	 FAR PTR _SPD2ASCII
	ret
edl_asc1a:
	cmp	al,Editline_PMC			; Valid PMC?
	jnz	edl_asc1b
	call	 FAR PTR _PMC2ASCII
	ret
edl_asc1b:
	cmp	al,Editline_REC			; Multiple Record?
	jnz	edl_asc1c
	call	 FAR PTR _REC2ASCII
	ret
edl_asc1c:
	cmp	al,Editline_RAMP			; Multiple Record?
	jnz	edl_asc1d
	call	 FAR PTR _RAMP2ASCII
	ret
edl_asc1d:
	cmp	al,Editline_PREREAD			; Multiple Record?
	jnz	edl_asc1e
	call	 FAR PTR _PREREAD2ASCII
	ret
edl_asc1e:
	call	 FAR PTR _cmtcmsg
	ret

edlasc2:push	cx
	push	bx			; Save line position
	mov	dx,es:[bx].ednum_lofst	; Get line number
	mov	bx,Alb_Pntr		; Ascii_Line position

	call	 FAR PTR _E_evn_l		; Get length of event
	cmp	al,4
	jnz	edlasc3
	call	 FAR PTR _dec1000_pad		; Store line number
	jmps	edlasc4
edlasc3:call	 FAR PTR _decimal_pad
edlasc4:mov	Alb_Pntr,bx		; Store ascii position
	pop	bx			; Restore line position

	call	 FAR PTR _E_emn_p		; Get # of Spaces after
	mov	cx,ax
	call	_store_Spaces		;  event number

; Store REEL ASSIGNMENT
	push	bx			; Save line position
	add	bx,offset ZeroBase.reel_lofst		; Index to REEL number
	push	bx
	xor	cx,cx			; Clear a counter

edlrlf:	mov	al,es:[bx]
	cmp	al,' '			; Find next space (end of reel)
	jz	edlrlg
	inc	bx
	inc	cl
	cmp	cl,reel_length
	jc	edlrlf

; CL has length of reel Name
edlrlg:	pop	bx
	call	 FAR PTR _e_rel_l		; Get allowable length of reel
edlrlc:	cmp	cl,al			; Is length CL <= allowable len?
	jbe	edlrok			; Jump if so
	inc	bx			; If not, then adjust until
	dec	cl			;  ok.
	jmps	edlrlc

; Left set the reel to the line	---------------
edlrok:	mov	ch,cl			; CH = # of chars to write
	mov	cl,al			; CL = max length to pad to
	call	 FAR PTR _E_flgs			; Check for Left or Right set
	test	al,E_Flag_rightset
	jnz	edlrs

edlasc5:mov	al,es:[bx]
	inc	bx
	call	_tcm_store
	dec	cl
	dec	ch			; One less character
	jnz	edlasc5

edlasc6:pop	bx
	jcxz	edla6a			; Skip if reel complete
	call	_store_Spaces
edla6a:	jmps	edlasc7
; ---------------------------------------------

; Right set the reel to the line --------------
edlrs:	push	cx
	sub	cl,ch			; Get maxlength-length
	mov	ch,0
	call	_store_Spaces
	pop	cx			; CH has string length
edlrsr:	mov	al,es:[bx]
	inc	bx
	call	_tcm_store
	dec	cl
	dec	ch			; One less character
	jnz	edlrsr
	pop	bx

;----------------------------------------------
edlasc7:call	 FAR PTR _E_rel_p			; Get padding Spaces
	mov	cx,ax
	call	_store_Spaces		;  after reel

; Store edit mode
tcemode:push	bx			; Save line position
	mov	al,es:[bx].mode_lofst	; Get mode
	call	 FAR PTR _modfndr		; Find mode
	call	 FAR PTR _E_mod_l		; Get length
	mov	cx,ax			;  of mode to CX
tcemdlp:mov	al,[bx]
	call	_tcm_store
	inc	bx
	loop	tcemdlp
	pop	bx

	call	 FAR PTR _E_mod_p
	mov	cx,ax
	call	_store_Spaces

; Store Edit type and associated parameters (if any)

	mov	al,es:[bx].type_lofst
	call	_tcm_store
	cmp	al,'C'			; Just a cut?
	JMP_Z	tcenkey			; Fill with Spaces and continue

JL0507:	cmp	al,'K'
	jz	tcekey
	jmp	NL0507

; Store key parameters
tcekey:	test	es:byte ptr [bx].keyFlags_lofst,back_Kmask
	jz	tcekey4

; KEY FOREGROUND line proccessing
	call	_space_store		; Space after "K"
	mov	al,'B'			; "B"
	call	_tcm_store
	call	_space_store
	test	es:byte ptr [bx].keyFlags_lofst,ftb_Kmask
	jz	tcekey1
	call	_space_store
	mov	al,'('
	call	_tcm_store
	mov	al,'F'
	call	_tcm_store
	mov	al,')'
	call	_tcm_store
	call	_space_store
	jmp	JL0508

tcekey1:call	_space_store
	call	_space_store
	call	_space_store
	call	_space_store
	call	_space_store
	jmp	JL0508

; Check for fade out
tcekey4:call	_space_store
	test	es:byte ptr [bx].keyFlags_lofst,fadeout_Kmask
	jnz	tcekey5
	test	es:byte ptr [bx].keyFlags_lofst,fadein_Kmask
	jz	tcekey4a
	mov	al,'I'
	jmp	tcekey5a
tcekey4a:
	call	_space_store
	call	_space_store
	jmp	tcekey1

tcekey5:mov	al,'O'
tcekey5a:
	call	_tcm_store
	call	_space_store
	call	_space_store
	jmps	JL0507b			; Fill in the duration

tcenkey:push	bx			; Else, fill with
	mov	bx,SpacePointer(8)
	call	_comsg_store	;  and skip to
	pop	bx			;  next
	jmps	JL0508

;----------------------------------------------------------------
; Store EFFECT NUMBER, if any
NL0507:	cmp	al,'W'			; Wipe?
	jz	JL0507a			;  display wipe# if so

	push	bx			; Else, fill with
	mov	bx,SpacePointer(4)	;  four Spaces
	call	_comsg_store	;  and skip to
	pop	bx			;  the dissolve duration
	jmps	JL0507b

; Store effect number
JL0507a:push	bx
	mov	dx,es:[bx].efxnum_lofst	; Get effect number
	mov	bx,Alb_Pntr
	call	 FAR PTR _decimal_pad
	mov	Alb_Pntr,bx
	call	_space_store
	pop	bx


; Store effect duration
JL0507b:mov	dx,es:[bx].efxdur_lofst	; Get effect duration
	mov	bx,Alb_Pntr
	call	 FAR PTR _decimal_pad
	mov	Alb_Pntr,bx
	call	_space_store

JL0508:	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pin
	push	ax
	call	 FAR PTR _edl_ldisp
	pop	ax
	call	 FAR PTR _getlast_pout
	call	 FAR PTR _edl_ldisp

	call	 FAR PTR _getlast_rtcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_rin
	push	ax
	call	 FAR PTR _edl_ldisp
	pop	ax
	test	EDLoptions_Flags,outdur_EDLBIT
	jz	tcco2
	call	 FAR PTR _getlast_dur
	call	 FAR PTR _edl_ddisp
	jmps	tcco3

tcco2:	call	 FAR PTR _getlast_rout
	call	 FAR PTR _edl_ldisp

tcco3:	call	 FAR PTR _E_flgs
	test	al,E_Flag_fcmtail
	jz	tcco3n

	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	_tcm_store
	inc	bx
	mov	al,es:[bx]
	call	_tcm_store
	call	_space_store

tcco3n:	mov	bx,Current_Event_Adr
	test	es:word ptr [bx].Flags_lofst,disabled_Fmask ; Check disabled
	jz	tcco4
	call	 FAR PTR _E_rmrk
	call	_tcm_store
	jmp	 tcco4a
tcco4:	call	_space_store
tcco4a:	xor	al,al			; Terminate line
	call	_tcm_store

; Return with carry set (C=1) if single line
	mov	bx,Current_Event_Adr
	mov	ax,es:[bx].Flags_lofst
	pop	cx
	mov	bx,offset Ascii_Line
	mov	dx,Alb_Pntr
	test	ax,split_Fmask		;Check for split
	jz	tcco5			; jump if not split
	stc
	ret				; return C=0, dbl line

tcco5:	test	ax,dblline_Fmask	; Check for DBL line
	clc
	jnz	tcco6			; Return C=0, dbl line
	stc				;  else, return C=1, single
tcco6:	ret
_EDL2ASCII	endp

_cmtcmsg	proc	far
	push	cx
	mov	cx,line_length
	call	 FAR PTR _E1_flgs			; Get EDL format Flags byte2
	mov	dl,al
cmtcms1:mov	al,es:[bx]
	or	al,al
	jz	cmtmsgr
	test	dl,E1Flag_allcaps	; Use all CAPS if set
	jz	cmtcms2
	call	 _make_ucase
cmtcms2:call	_tcm_store
	inc	bx
	loop	cmtcms1
cmtmsgr:xor	al,al
	call	_tcm_store
e2ax:	mov	bx,offset Ascii_Line
	mov	dx,Alb_Pntr
	pop	cx
	stc				; Set carry = single line
	ret
_cmtcmsg	endp


; Format:
;  1    2  3   4   5     6
; ___  __  _  ___  ____________
; GPI  01  V  000  +00:00:00:00
;
_GPI2ASCII	proc	far
	push	cx
	mov	bx,offset Gpi_Header
	call	_comsg_store
	call	_space_store
	push	si
	mov	si,Current_Event_Adr
	mov	al,es:[si]		; Get register number
	mov	ah,0

	push	Temp_Tc_Buf		; Save what is in Temp_Tc_Buf

	push	Alb_Pntr		; Transfer the Alb_Pntr to
	pop	Temp_Tc_Buf		;  the Temp_Tc_Buf

	mov	bx,ax			; Get number to BX
	call	 FAR PTR _decpadt			; Pad it with leading zeros
	push	Temp_Tc_Buf
	pop	Alb_Pntr

	pop	Temp_Tc_Buf

	call	_space_store
	call	_space_store

	add	si,offset ZeroBase.GPI_lofst		; Point to the GPI info
	mov	ah,byte ptr es:[si].gpiFLAGS	; Get Flags byte to AH
	mov	al,'V'
	test	ah,G_swtrig_mask	; Test for switcher type
	jnz	gpi2a3
	mov	al,'G'
	test	ah,G_vltrig_mask	; Test for VLAN trigger type
	jnz	gpi2a3
	mov	al,'?'
	test	ah,G_machine_mask	; Test for machine type
	jz	gpi2a3
	mov	al,ah			; Try to make it
	and	al,00000111b		;  a VTR
	cmp	al,MAX_MACHINES
	jnc	gpi2a3
	add	al,'A'-1
gpi2a3:	call	_tcm_store		; Store trigger type
	call	_space_store		;  and trailing space
	call	_space_store
	mov	bx,Alb_Pntr		; Setup destination address
	mov	dx,es:[si].gpiCMD	; Get the command number
	call	 FAR PTR _decimal_pad
	mov	Alb_Pntr,bx
	call	_space_store
	call	_space_store
	mov	al,es:[si]
	cmp	al,MINUS_ASCII
	jz	gpi2a4
	mov	al,PLUS_ASCII
gpi2a4:	call	_tcm_store		; Character 10
	mov	bx,si
	inc	bx
	mov	al,NDF_CHAR
	call	 FAR PTR _edl_ldisp
	pop	si
	xor	al,al
	call	_tcm_store		; Terminate line
	jmp	e2ax
_GPI2ASCII	endp

; Six fields
;  1      2         3         4       5         6
; ___  ______  ___________   ____  ______  ___________
; SLV     004  00:00:00:00   MSTR     001  00:00:00:00  
_SLV2ASCII	proc	far
	push	cx
	mov	bx,offset Slave_Header
	call	_comsg_store
	call	_space_store
	mov	cx,reel_length
	call	 FAR PTR _getlast_reel
	cmp	byte ptr es:[bx],0	; Record is the slave?
	jnz	slv2a2

; Set RECORD AS SLAVE
	mov	bx,offset R_Reel_Num	; Send RECORD Name as reel
	call	_comsg_store
	call	_space_store
	call	_space_store
	call	 FAR PTR _getlast_ptcd		; Get slave FCM
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pin		; Get slave time code
	jmp	slv2a4

; Set SOURCE AS SLAVE
slv2a2:	mov	al,es:[bx]
	call	_tcm_store
	inc	bx
	loop	slv2a2

slv2a3:	call	_space_store
	call	_space_store
	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pin


slv2a4:	call	 FAR PTR _edl_ldisp		; Display SLAVE time code
	call	_space_store
	call	_space_store

	mov	bx,offset Master_Msg	; Set 'MSTR' message
	call	_comsg_store
	call	_space_store
	call	_space_store
	mov	cx,reel_length
	call	 FAR PTR _getlast_reel
	add	bx,cx
	cmp	byte ptr es:[bx],0
	jnz	slv2a5

; Set RECORD AS MASTER
	mov	bx,offset R_Reel_Num	; Send RECORD Name as reel
	call	_comsg_store
	call	_space_store
	call	_space_store

	mov	al,Rtcf
	call	 FAR PTR _getlast_rin
	jmp	slv2af

; Set SOURCE AS MASTER
slv2a5:	mov	al,es:[bx]
	call	_tcm_store
	inc	bx
	loop	slv2a5

	call	_space_store
	call	_space_store

	mov	al,Rtcf

	call	 FAR PTR _getlast_rin
slv2af:	call	 FAR PTR _edl_ldisp
	call	_space_store
	xor	al,al
	call	_tcm_store
	jmp	e2ax
_SLV2ASCII	endp


; MULTIPLE RECORD LINES
; Six fields
;  1      2         3         4       5         6
; ___  ______  ___________   ____  ______  ___________
; REC     004  00:00:00:00   MSTR  RECORD  00:00:00:00  
_REC2ASCII	proc	far
	push	cx
	mov	bx,offset Rec_Header
	call	ExtraHdrAndReel

	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pin

	call	 FAR PTR _edl_ldisp		; Display SLAVE time code
	call	_space_store
	call	_space_store

	mov	bx,offset Master_Msg	; Set 'MSTR' message
	call	_comsg_store
	call	_space_store
	call	_space_store
	mov	cx,reel_length

; Set RECORD AS MASTER
	mov	bx,offset R_Reel_Num	; Send RECORD Name as reel
	call	_comsg_store
	call	_space_store
	call	_space_store

	mov	al,Rtcf
	call	 FAR PTR _getlast_rin
	call	 FAR PTR _edl_ldisp
	call	_space_store
	xor	al,al
	call	_tcm_store
	jmp	e2ax
_REC2ASCII	endp


;================================================================
;	even
_SPD2ASCII	proc	far
	push	cx

	push	bx			; Save ES:EDL pointer
	mov	bx,offset Spd_Header	; Store SPD:
	call	ExtraHdrAndReel
	pop	bx

	mov	al,es:byte ptr [bx].SPD_lofst
	call	 FAR PTR _md_speed

	mov	bx, SpacePointer(15)
	call	_comsg_store

	mov	bx,offset Out_Msg
	call	_comsg_store
	call	_space_store
	mov	al,'='
	call	_tcm_store
	call	_space_store
	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pout
	call	 FAR PTR _edl_ldisp

	xor	al,al
	call	_tcm_store
	jmp	e2ax
_SPD2ASCII	endp

_PMC2ASCII	proc	far
	push	cx

	push	bx			; Save ES:EDL pointer
	mov	bx,offset Pmc_Header	; Store SPD:
	call	ExtraHdrAndReel
	pop	bx
	mov	al,es:[si]		; Get register number
	add	bx,offset ZeroBase.SPD_lofst
	inc	bx			; Point to speed
	push	bx

	mov	al,es:[bx]		; Get speed
	call	 FAR PTR _md_speed
	call	_space_store

	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	pop	bx
	inc	bx			; Inc pointer to sign
	mov	al,es:[bx]
	call	_tcm_store
	inc	bx
	call	 FAR PTR _edl_ldisp
	call	_space_store

	mov	bx,offset Out_Msg
	call	_comsg_store
	call	_space_store
	mov	al,'='
	call	_tcm_store
	call	_space_store

	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pout
	call	 FAR PTR _edl_ldisp

	xor	al,al
	call	_tcm_store
	jmp	e2ax

_PMC2ASCII	endp

;Out_Msg
;RAMP: 001    +60.00 +30.00 00:00:01:00 +00:00:00;00 00:00:00:00
_RAMP2ASCII	proc	far
	push	cx

	mov	bx,offset Ramp_Header	; Store rmp:
	call	ExtraHdrAndReel

	call	 FAR PTR _getlast_extra
	mov	ch,es:[bx].SPEED_FROMDIR
	add	bx,offset ZeroBase.SPEED_FROM
	call	StoreDecimalDigits
	call	_space_store

	call	 FAR PTR _getlast_extra
	mov	ch,es:[bx].SPEED_TODIR
	add	bx,offset ZeroBase.SPEED_TO
	call	StoreDecimalDigits
	call	_space_store

	call	 FAR PTR _getlast_rtcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_extra
	add	bx,offset ZeroBase.SPEED_TIME
	call	 FAR PTR _edl_ldisp

	call	 FAR PTR _getlast_extra
	mov	cl,es:[bx].SPEED_DIRECTION
	call	 FAR PTR _md_plsmin

	call	 FAR PTR _getlast_rtcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_extra
	add	bx,offset ZeroBase.SPEED_START
	call	 FAR PTR _edl_ldisp

	call	 FAR PTR _getlast_ptcd
	mov	al,es:[bx]
	call	 FAR PTR _getlast_pout
	call	 FAR PTR _edl_ldisp

	xor	al,al
	call	_tcm_store
	jmp	e2ax

_RAMP2ASCII	endp

_PREREAD2ASCII	proc	far
	push	cx
	mov	bx,offset preread_header	; Set 'MSTR' message
	call	_comsg_store
	call	_space_store
	mov	bx,offset enabled_msg
	call	_comsg_store
	jmp	cmtmsgr
_PREREAD2ASCII	endp


; Store CH sign and (decimal) *ES:[BX]AX:DX to [Temp_Tc_Buf]
StoreDecimalDigits	proc	near
	cmp	ch,MINUS_ASCII				; Negative direction?
	mov	al,PLUS_ASCII
	jnz	sddcmd1
	mov	al,MINUS_ASCII
sddcmd1:call	_tcm_store			; Store + or -
	mov	ax,es:[bx]
	mov	dx,es:[bx+2]
	mov	bx,Alb_Pntr
	call	 FAR PTR _itoa100				; Set the speed
	mov	Alb_Pntr,bx
	ret
StoreDecimalDigits	endp



_md_speed	proc	far
	push	dx

	push	ax
	xor	ah,ah
	call	 FAR PTR _md_plsmin

	MULTIPLY_BY 10, AX	; Multiply AX by 10 macro

	xor	dx,dx
	mov	cx,3
	div	cx
	mov	dx,ax
	mov	bx,Alb_Pntr		; Setup destination address
	call	 FAR PTR _decimal_pad
	mov	Alb_Pntr,bx
	mov	al,'%'
	call	_tcm_store
	mov	bx,offset Ofspeed_Msg
	call	_comsg_store

	pop	ax
	call	 FAR PTR _md_plsmin
	mov	dl,al
	mov	dh,0

	mov	bx,Alb_Pntr		; Setup destination address
	call	 FAR PTR _decimal_pad
	mov	Alb_Pntr,bx

	call	_space_store
	mov	bx,offset Framesec_Msg
	call	_comsg_store
	call	_space_store
	pop	dx
	ret
_md_speed	endp

; Store + or - or space
_md_plsmin	proc	far
	mov	cl,PLUS_ASCII
	test	al,80h			; Negative number?
	jz	mdgn1
	mov	cl,MINUS_ASCII
	push	ax
	jmp	mdgn3

mdgn1:	push	ax
	and	al,7fh
	or	al,al			; Check for complete stop
	jnz	mdgn3
	call	_space_store
	jmps	mdgn4
mdgn3:	mov	al,cl
	call	_tcm_store
mdgn4:	pop	ax
	and	al,7fh			; Clear hi bit
	ret
_md_plsmin	endp

; Save header text and reel assignment to extra line
; Enter: BX->Header text
ExtraHdrAndReel	proc	near
	call	_comsg_store
	call	_space_store
	mov	cx,reel_length
	call	 FAR PTR _getlast_reel
eharlp:	mov	al,es:[bx]
	call	_tcm_store
	inc	bx
	loop	eharlp
	call	_space_store
	call	_space_store
	ret
ExtraHdrAndReel	endp

;================================================================
; Display EDL time code number in correct format
;================================================================
; ENTER: BX points to time code buffer
;	 AL = FCM
_edl_ldisp	proc	far
	push	ax
	push	cx
	mov	cl,al
	mov	dx,offset Tcdispbuf
	call	 FAR PTR _cnvt2tc_ES
	pop	cx
	pop	ax

	cmp	al,DF_CHAR		; See if drop frame
	jnz	JL0510
	call	 FAR PTR _E_flgs
	test	al,E_Flag_semicol	; Semicolons allowed?
	jz	JL0510
	cmp	byte ptr 8[bx],':'	; For the benifit of _big_DecOut 5/89
	jnz	JL0510
	mov	byte ptr 8[bx],';'
JL0510:	call	_comsg_store
	call	_space_store
	ret
_edl_ldisp	endp

_edl_ddisp	proc	far
	push	cx
	mov	cl,DF_CHAR		; Force non drop frame
	mov	dx,offset Tcdispbuf
	call	 FAR PTR _cnvt2tc_ES
	pop	cx

JL0512:	mov	al,[bx]
	or	al,al
	JMP_Z	_space_store
	cmp	al,'0'
	jz	edldd1
	cmp	al,':'
	jz	edldd1
	cmp	al,';'
	jz	edldd1
	call	_comsg_store
	call	_space_store
	ret

edldd1:	call	_space_store
	inc	bx
	jmps	JL0512
_edl_ddisp	endp


;================================================================
; Force FCM, return with Temp_Wrkspce w/FCM line
; Carry set if NO FCM to write
; Try FCM in following order:
; 1. Try for Edl_Fcm
; 2. Try for R-VTR FCM
; 3. Get manual entry

_force_fcm	proc	far
	IF NTSC
	mov	Last_Fcm,'C'		; Force a change
	mov	bx,offset Edl_Fcm
	cmp	byte ptr es:[bx],0
	jnz	_wrtfcm0
	push	bp
	call	 _SetNewRvtFCM
	pop	bp
	cmp	es:byte ptr Edl_Fcm,0
	jnz	_force_fcm
	mov	al,Rtcf
	or	al,al
	jnz	ffcm1
	call	 FAR PTR _getlast_rtcd
	mov	al,es:[bx]
	or	al,al
	jnz	ffcm1
	call	 _RqstNewRvtFCM
ffcm1:	mov	es:Edl_Fcm,al
	call	 _force_fcm
	ret
	ELSE
	stc
	ret
	ENDIF

_force_fcm	endp

; Check to see if we are checking for FCM change
; Carry set if NO FCM to write
_wrt_fcm	proc	far
	call	 FAR PTR _getlast_ptcd
_wrt_fcm	endp

_wrtfcm0	proc	far
	IF NTSC
	mov	dx,bx

; Enter with DX pointing to ES:FCM
wrtfcm1:mov	bx,offset Ascii_Line	; Save ascii line pointer
	mov	byte ptr [bx],0		; Pre-terminate w/null
	mov	Alb_Pntr,bx		; Save Memory-write pointer
	mov	bx,es:Mode_Pntr		; Check to see if we are writing FCM
	test	byte ptr [bx].E_Flags,E_Flag_fcmline
	jz	wrt_fcx			; Skip if NOT writing FCM lines

	mov	bx,dx			; Check for FCM change
	mov	al,Last_Fcm		;  from previous line
	cmp	al,es:[bx]
	jz	wrt_fcx			; Skip if no change	
	mov	al,es:[bx]

	mov	Last_Fcm,al		; Set new type
	push	ax
	mov	bx,offset Fcm_Header
	call	_comsg_store
	pop	ax
	mov	bx,offset Dropframe_Msg
	cmp	al,DF_CHAR
	jz	wrtfcm2
	mov	bx,offset Nondrop_Msg
wrtfcm2:call	_comsg_store
	mov	bx,Alb_Pntr
	call	 FAR PTR _ALterm			; terminate line
	clc
	ret

wrt_fcx:mov	bx,offset Ascii_Line
	ENDIF
	stc
	ret
_wrtfcm0	endp

; Carry set if NO FCM to write
_wrt_split	proc	far
	mov	bx,offset Ascii_Line	; Save ascii line pointer
	mov	byte ptr [bx],0		; Pre-terminate
	mov	Alb_Pntr,bx

	call	 FAR PTR _E1_flgs
	test	al,E1Flag_splline
	JMP_Z	wrtsplx

	mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	JMP_Z	wrtsplx

	add	bx,offset ZeroBase.rin_lofst		; Save this event's record in
	call	 FAR PTR _sttime_move_ES

	mov	ax,es:Current_Event
	push	ax			; Save current event
	inc	ax
	call	 FAR PTR _index_storage

	push	bx			; Save next line's record in
	add	bx,offset ZeroBase.rin_lofst
	call	 FAR PTR _entime_move_ES
	pop	bx

	pop	ax
	FLAGBITS split_Fmask		; Test for SPLIT EDIT (NZ)
	pushf
	call	 FAR PTR _index_storage
	popf
	jz	wrtsplx

	mov	dx,bx			; Save EDL address
	mov	bx,offset Split_Type
	call	 FAR PTR _splcap_mmv
	mov	al,':'
	call	_tcm_store
	call	_space_store
	mov	bx,dx
	test	es:byte ptr [bx].mode_lofst,video_Emode	; Audio delay?
	mov	bx,offset Split_Aud_Msg
	jnz	wrtspl1
	mov	bx,offset Split_Vid_Msg
wrtspl1:call	 FAR PTR _splcap_mmv
	call	_space_store
	mov	bx,offset Split_Dly_Msg
	call	 FAR PTR _splcap_mmv
	mov	al,'='
	call	_tcm_store
	call	_space_store

	call	 FAR PTR _timdif			; Get the split difference

	mov	dx,Alb_Pntr
	push	dx
	push	cx
	mov	cl,Rtcf
	call	 FAR PTR _cnvt2tc_DS
	pop	cx
	pop	bx
	add	bx,11
	call	 FAR PTR _ALterm
	clc
	ret
wrtsplx:mov	bx,offset Ascii_Line
	stc
	ret
_wrt_split	endp

_splcap_mmv	proc	far
	mov	cx,5
splcapl:mov	al,[bx]
	call	 _make_ucase
	call	_tcm_store
	inc	bx
	loop	splcapl
	ret
_splcap_mmv	endp

; Terminate line and return pointing to Ascii_Line in BX
_ALterm	proc	far
	mov	word ptr [bx],0A0DH	; terminate line w/CRLF
	mov	byte ptr 2[bx],0
	mov	bx,offset Ascii_Line
	ret
_ALterm	endp


;================================================================
; Checs for presence of EDL file, return with LAST EVENT number
_check4edl	proc	far
	mov	ax,es:Next_Avail_Num
	dec	ax
	ret
_check4edl	endp

;------------------------------------------------------
;
;		M A T H   R O U T I N E S
;
;------------------------------------------------------


;timecode clear routines
_clear_pin	proc	far
	mov	bx,Current_Inbuf
	jmps	_clear_tc
_clear_pin	endp
_clear_pout	proc	far
	mov	bx,Current_Outbuf
	jmps	_clear_tc
_clear_pout	endp
_clear_pdur	proc	far
	mov	bx,Current_Duration
	jmps	_clear_tc
_clear_pdur	endp
_clear_rin	proc	far
	mov	bx,offset R_Tc.tcIN
	jmps	_clear_tc
_clear_rin	endp
_clear_rout	proc	far
	mov	bx,offset R_Tc.tcOUT
	jmps	_clear_tc
_clear_rout	endp
_clear_rdur	proc	far
	mov	bx,offset R_Tc.tcDUR
_clear_rdur	endp

;enter with destination in BX
_clear_tc	proc	far
	mov	word ptr [bx],0
	mov	byte ptr 2[bx],0
	ret
_clear_tc	endp


;================================================================
;this recycles from adding/replaceing/inserting an event to the list
;================================================================
_clear_event	proc	far
	cmp	Tag_Flag,0		; Clear out this edit?
	jnz	_edit_tagging
	call	clear_edit_FAR
	ret
_clear_event	endp

;================================================================
; Tags the event from the edl
_edit_tagging	proc	far
	mov	Clear_Flag,al
	mov	al,Current_Machine
	push	ax
	xor	al,al
	call	Machine_Change_Far
	call	Tagthis_Vtr_FAR
	mov	al,Trans_Type
	cmp	al,'K'
	jz	clr4key
	cmp	al,'D'
	jz	clr4efx
	cmp	al,'W'
	JMP_NZ	clr4cut

; This is tricky, because the from and to machines have already been swapped.
clr4efx:mov	al,From_Machine		; Get previous TO machine
	call	Machine_Change_Far
	call	 FAR PTR _clear_outs

	call	 FAR PTR _tag_varispeeds
	jc	clr4ef1

	call	Mtchvtr_FAR		; Calculate match frame
	mov	dx,Current_Inbuf	; Move matchframe value
	call	 _mmv3byt		;  to current INbuffer

clr4ef1:mov	al,To_Machine		; Get previous from machine
	call	 FAR PTR _clear_outs
	call	Machine_Change_Far

	call	 FAR PTR _tag_varispeeds
	jc	clr4all

	mov	bx,offset Matchframe_From
	mov	dx,Current_Inbuf	; Move matchframe value
	call	 _mmv3byt		;  to current INbuffer
	jmps	clr4all

; Tag a KEY forground line
clr4key:mov	al,Keyfor_Src		; Get key foreground
	call	Machine_Change_Far
	call	 FAR PTR _clear_outs

	call	 FAR PTR _tag_varispeeds
	jc	clr4ke1

	call	Tagthis_Vtr_FAR
	call	Mtchvtr_FAR		; Calculate match frame

clr4ke1:mov	al,Keybkgnd_Src		; Get key background
	call	Machine_Change_Far
	call	 FAR PTR _clear_outs

	call	 FAR PTR _tag_varispeeds
	jc	clr4all

	mov	bx,offset Matchframe_From
	mov	dx,Current_Inbuf	; Move matchframe value
	call	 _mmv3byt			;  to current INbuffer
	jmps	clr4all

; Clear edit for CUT
clr4cut:mov	al,Current_Source	; Get current source
	call	Machine_Change_Far
	call	 FAR PTR _clear_outs

	call	 FAR PTR _tag_varispeeds
	jc	clr4all

	call	Mtchvtr_FAR		; Calculate match frame
	mov	dx,Current_Inbuf	; Move matchframe value
	call	 _mmv3byt			;  to current INbuffer

clr4all:pop	ax
	call	Machine_Change_Far
	cmp	Tag_Flag,0
	jz	_clear_outs
	mov	bx,offset R_Tc.tcIN
	mov	dx,offset R_Tc.tcOUT
	call	 _mmv3byt
	mov	bx,Current_Inbuf
	mov	dx,Current_Outbuf
	call	 _mmv3byt
	cmp	Tag_Flag,0feh
	jnz	clout1

_edit_tagging	endp

_clear_outs	proc	far
	call	 _clear_rout
	call	 _clear_pout
clout1:	call	 _clear_rdur
	call	 _clear_pdur
	ret

_clear_outs	endp


; Edit tagging for variable speed events
; Exit: C=1 if correctly tagged
;	C=0 if not tagged (machine 0 or no PMC and no SPD
_tag_varispeeds	proc	far
	mov	al,Current_Machine	; = machine we are tagging
	or	al,al			; Record machine?
	jz	tagfrom_edl
	test	Pmc_Flags,Enabled_MSBIT	; Check for reasons to
	jnz	_tagfrom_tagstable	;  tag from the
	test	Spd_Flags,Enabled_MSBIT	;  PMC/SPD tags table
	jz	tagfrom_edl		; If no reason, tag from EDL
_tag_varispeeds	endp

; Tag edits from PMC or SPD event
_tagfrom_tagstable	proc	far
	push	ax			; Save machine number
	call	 _index2edspeed		; Returns AL = speed
	cmp	al,FPS			; 30 fps?
	pop	ax
	jnz	tag_from_tbl		; Not at 30fps, use table

	mov	bx,offset Progmotion_Tbl
tft_1:	mov	ah,[bx]			; Get vtr or terminator
	cmp	ah,0ffh			; End of table?
	jz	tagfrom_edl
	cmp	ah,al
	jz	tag_from_tbl
	add	bx,SIZE VARSPEEDCHANGE	; Point to next entry
	jmp	tft_1			; Look again

tag_from_tbl:
	mov	bx,offset Tags_Table
	dec	al			; Adjust for no record buffer in table
	cbw
	add	bx,ax			; Index to the appropriate tags buffer
	add	bx,ax			; (each is three bytes in length
	add	bx,ax
	mov	dx,Current_Inbuf
	call	 _mmv3byt
	mov	al,Current_Machine	; = machine we are tagging
	stc
	ret

tagfrom_edl:
	mov	al,Current_Machine	; = machine we are tagging
	clc
	ret
_tagfrom_tagstable	endp


;================================================================
; Convert decimal ascii to 24 bit number
; ENTER: DS:BX = Decimal ASCII string
; Exit:	 DS:BX points to 24bit buffer w/ value
_cnvt2dec	proc	far
	push	cx
	push	si
	push	di
c2d_0:	mov	al,[bx]			; Find last character
	or	al,al			; End of string?
	jz	c2d_1
	inc	bx			; Go to next character
	jmps	c2d_0

c2d_1:	dec	bx			; Point to last character
	mov	si,offset Multable	; Point SI to multiplication table
	mov	di,Temp_Tc_Buf
	xor	ax,ax
	mov	ds:[di],ax
	mov	ds:2[di],al
	mov	cx,8			; # of decimal "places" to do

c2d_2:	mov	al,[bx]			; Get digit
	dec	bx			; Point BX to previous one
	cmp	al,' '			; Is that it?
	jz	c2d_5			; Found start of string, so finished
	sub	al,'0'
	cbw

	push	bx
	push	cx
	mov	bx,offset Offset_Buffer	; Buffer for multiplication
	mov	[bx],ax			; Make this a 24 bit value
	mov	byte ptr 2[bx],0
	mov	dx,si			; Get a multiplier
	add	si,3			;  and index for next loop
	call	 FAR PTR _mpbmul			; BX.. = BX.. * DX..
	mov	dx,bx			; Answer to DX
	mov	bx,di			; Accumulator to BX
	call	 FAR PTR _mpbadd
	pop	cx
	pop	bx
	loop	c2d_2

c2d_5:	mov	bx,di
	pop	di
	pop	si
	pop	cx
	ret
_cnvt2dec	endp

;Total frames= (HOURS * 108000) + (MINS * 1800) + (SEC * 3)
; Drop Frames = minutes - (minutes/10)
; Drop 2 frames every minute, execpt every 10th minute
;-----------------------------------------------------------
;Convert TC string to multiple precision 3 byte array
;Enter	BX points to TC string in the form of HH:MM:SS:FF
;	DX points to 3 BYTE destination buffer
;	CL has Drop/non-drop indicator
;Exit	BX points to 3 byte binary number, lsb first
;-----------------------------------------------------------

cnvt2mpCALC	macro	t, m
local ca, cc
	and	ax,0f0fh		; Strip ascii offset
	shl	al,1			; MULTIPLY BY 10
	mov	ch,al
	shl	al,1
	shl	al,1
	add	al,ch
	add	al,ah			; Add the tens
	cbw

	if m gt 0
ca:	cmp	ax,m
	jc	cc
	sub	ax,m
	jmp short ca
cc:
	endif

	mov	si,ax
	if t eq 3
	shl	si,1
	add	si,ax
	endif
	if t eq 2
	shl	si,1
	endif
	endm

_cnvt2mp_ES	proc	far
	push	dx			; Save destination address
	push	bx			; Save source address
	mov	bx,dx			; Get TC value address
	call	_mvb2st1_es		; Move 24bit number to data segment
	pop	bx			; Restore source address
	mov	dx,offset Bytstr1
	call	 FAR PTR _cnvt2mp_DS		; Convert it to Bytstr1
	pop	dx			; Restore destination address
	call	 _mmv3_ds2es		; Put the tc value to ES:DX
	ret
_cnvt2mp_ES	endp

_cnvt2mp_DS	proc	far
	mov	Temp_Tc_Buf,dx		; Store the destination address
	push	si
	push	cx
	cmp	Frame_Flag,0ffh
	JMP_Z	cnvt2mpdec

	push	dx			; Save destination address
	xor	dx,dx
	cmp	cl,DF_CHAR
	mov	cl,dl			; Clear accumlator cl:DX
	jnz	cnvt2mpn

	mov	ax,[bx]			; Get hours
	cnvt2mpCALC 3, 100
	add	dx,[si + offset Dhours_Table]
	adc	cl,[si + offset Dhours_Table + 2]
	mov	ax,[bx + 3]		; Get minutes
	cnvt2mpCALC 3, 0
	add	dx,[si + offset Dminutes_Table]
	adc	cl,[si + offset Dminutes_Table + 2]
	mov	ax,[bx + 6]		; Get seconds
	cnvt2mpCALC 2, 0
	add	dx,[si + offset Dseconds_Table]
	adc	cl,0
	jmps	cnvt2mpb

cnvt2mpn:
	mov	ax,[bx]			; Get hours
	cnvt2mpCALC 3, 100
	add	dx,[si + offset Nhours_Table]
	adc	cl,[si + offset Nhours_Table + 2]
	mov	ax,[bx + 3]		; Get minutes
	cnvt2mpCALC 3, 0
	add	dx,[si + offset Nminutes_Table]
	adc	cl,[si + offset Nminutes_Table + 2]
	mov	ax,[bx + 6]		; Get seconds
	cnvt2mpCALC 2, 0
	add	dx,[si + offset Nseconds_Table]
	adc	cl,0

cnvt2mpb:
	mov	ax,[bx + 9]		; Get frames
	and	ax,0f0fh		; Strip ascii offset
	shl	al,1			; MULTIPLY BY 10
	mov	ch,al
	shl	al,1
	shl	al,1
	add	al,ch
	add	al,ah			; Add the tens
	cbw
	add	dx,ax
	adc	cl,0

	pop	bx
	mov	[bx],dx
	mov	[bx + 2],cl

prs24xx:mov	bx,Temp_Tc_Buf
	pop	cx
	pop	si
	ret

cnvt2mpdec:
	call	 _cnvt2dec
	jmp	prs24xx
_cnvt2mp_DS	endp

	purge	cnvt2mpCALC

;===========================================================
;-----------------------------------------------------------
;	MAKE 24 BITS (3BYTES) INTO TIMECODE STRING
;Enter	BX points to 3 byte buffer to convert
;	DX = where to put it
;	CL = Dropframe/Nondrop frame indication
;Exit	BX = buffer (where we put it)
;	DX now points to 3 byte buffer
;-----------------------------------------------------------
_cnvt2tc_ES	proc	far
	push	cx
	push	bx
	push	dx
	push	si
	mov	si,offset Bytstr1
	mov	ax,es:[bx]
	mov	[si],ax
	mov	al,es:[bx + 2]
	mov	[si + 2],al
	mov	bx,si
	jmps	cnvt2t1
_cnvt2tc_ES	endp

; Move bytes from data segment
_cnvt2tc_DS	proc	far
	push	cx
	push	bx
	push	dx
	push	si

	mov	si,offset Bytstr1
	mov	ax,[bx]
	mov	[si],ax
	mov	al,[bx + 2]
	mov	[si + 2],al

cnvt2t1:push	bp
	mov	bx,si
	mov	Temp_Tc_Buf,dx		; Store destination
	cmp	cl,DF_CHAR		; Convert for drop frame?
	jnz	cnvt2t2
	call	 FAR PTR _cnvt2df_FAR

cnvt2t2:cmp	Frame_Flag,0ffh
	jnz	cnvt2t3
	call	 FAR PTR _big_DecOut
	jmp	cnvt2tx

; 3-25-1991 Prevent Time Code over 99 hours. nhs
; 11-28-1991 Replaced call with in-line coding to save time. nhs
cnvt_reduce:
	mov	si,offset Twenty4hrs	; Compare it against
	mov	al,2[bx]		;  24 hours
	cmp	al,2[si]
	jnz	cnvt2t2a
	mov	ax,[bx]
	cmp	ax,[si]
	jnz	cnvt2t2a
	xor	al,al
cnvt2t2a:
	jc	cnvt2t3
	mov	ax,[si]			; Subtract 24 hours
	sub	[bx],ax
	mov	al,2[si]
	sbb 	2[bx],al
	jmp	cnvt_reduce		; Loop to make mod 24 hrs

cnvt2t3:mov	dx,[bx]			; Get time code to CL:DX
	mov	cl,[bx + 2]
	mov	si,offset Nhours_Table + (3 * 98) ;(3 * 23)
	mov	bx,98 ;23			; Init digit counter

	cmp	cl,[si + 2]		; Check for overflow
	ja	cnvt_reduce		;


c2tch_1:cmp	cl,[si + 2]
	jb	c2tch_2
	ja	c2tch1a
	cmp	dx,[si]
	jb	c2tch_2

c2tch1a:mov	bp,bx
	shl	bp,1
	add	bp,bx
	sub	dx,ds:[Nhours_Table + bp]			; Subtract hour value
	sbb	cl,ds:byte ptr [Nhours_Table + bp + 2]
	call	 FAR PTR _decpadt
	jmp	c2tc_minutes

c2tch_2:sub	si,3
	dec	bl
	jns	c2tch_1
	xor	bx,bx
	call	 FAR PTR _decpadt

c2tc_minutes:
	mov	bx,Temp_Tc_Buf
	mov	byte ptr [bx],':'
	inc	Temp_Tc_Buf

	mov	si,offset Nminutes_Table + (3 * 59)
	mov	bx,59			; Init digit counter
c2tcm_1:cmp	cl,[si + 2]
	jb	c2tcm_2
	ja	c2tcm1a
	cmp	dx,[si]
	jb	c2tcm_2
c2tcm1a:mov	bp,bx
	shl	bp,1
	add	bp,bx
	sub	dx,ds:[Nminutes_Table + bp]
	sbb	cl,ds:byte ptr [Nminutes_Table + bp + 2]
	call	 FAR PTR _decpadt
	jmp	c2tc_seconds
c2tcm_2:sub	si,3
	dec	bl
	jns	c2tcm_1
	xor	bx,bx
	call	 FAR PTR _decpadt

c2tc_seconds:
	mov	bx,Temp_Tc_Buf
	mov	byte ptr [bx],':'
	inc	Temp_Tc_Buf

	mov	si,offset Nseconds_Table + (2 * 59)
	mov	bx,59			; Init digit counter
c2tcs_1:cmp	dx,[si]
	jb	c2tcs_2
	mov	bp,bx
	shl	bp,1
	sub	dx,ds:[Nseconds_Table + bp]
	call	 FAR PTR _decpadt
	jmp	c2tc_frames
c2tcs_2:sub	si,2
	dec	bl
	jns	c2tcs_1
	xor	bx,bx
	call	 FAR PTR _decpadt

c2tc_frames:
	mov	bx,Temp_Tc_Buf
	mov	byte ptr [bx],':'
	inc	Temp_Tc_Buf

	mov	bx,dx
	call	 FAR PTR _decpadt

cnvt2tx:pop	bp

	pop	si
	pop	bx
	pop	dx
	pop	cx
	ret
_cnvt2tc_DS	endp


;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================


;================================================================
;		PRINT 24 BIT NUMBER AT BX IN DECIMAL
;================================================================
; Enter: DS:BX points to 24bit number
;	 DS:DX points to destination buffer
;
; Exit:  DS:BX points to ascii buffer with formatted number
;	 DS:DX points to original number
_big_DecOut	proc	far
	push	bx			; Save original number
	mov	dx,Temp_Tc_Buf		; Save starting position
	mov	Move_Adr,dx
	xor	al,al			; "pre-" terminate line
	call	 FAR PTR _add_store

	mov	dx,offset Offset_Buffer	; Move number to temporary buffer
	call	 _mmv3byt
	mov	bx,dx
	mov	dx,offset Thousand
	call	 FAR PTR _mpbdiv	; Divide by one Thousand
	mov	bx,[bx]			; Get thousands
	mov	cx,bx
	or	bx,bx			; Check for zero thousands
	jz	bigdec1			; Skip if zero thousands

	call	 FAR PTR _make_dec		; Make ascii thousands

bigdec1:mov	bx,Hdeptr		; address of remainder
	mov	dx,[bx]
	or	dx,cx			; Check for zero remainder
	jz	bigdec2			; Skip if zero thousands
	mov	bx,Temp_Tc_Buf
	call	 FAR PTR _decimal_pad

bigdec2:push	di
	push	si
	mov	si,Temp_Tc_Buf		; Get next position
	dec	si			; Point to last position
	mov	di,Move_Adr		; Point to end of string
	add	di,10

bdpad0:	mov	cx,3			; Three characters at a time
; Format the line
bdpad1:	mov	al,[si]			; Get a character
	or	al,al			; Beginning of string?
	jz	bdpad2			;  we are done if so
	mov	ds:[di],al		; Save character at last position
	dec	di			; Move back destination
	dec	si			; Move back source
	loop	bdpad1			; Do for three

	cmp	byte ptr [si],0		; Anything left?
	jz	bdpad2
	mov	byte ptr ds:[di],','
	dec	di
	jmps	bdpad0

bdpad2:	mov	byte ptr ds:[di],' '
	cmp	di,Move_Adr
	jz	bdpad3
	dec	di
	jmps	bdpad2

bdpad3:	pop	si
	pop	di
	pop	dx			; DX points to original number
	mov	bx,Move_Adr		; BX points to ascii buffer
	add	bx,11
	mov	Temp_Tc_Buf,bx
	ret
_big_DecOut	endp




; Check for marked edits.  Return C=1 if any exist in EDL
; AX is event to start checking with
; (although the search actually goes backwards from the
;  end of the list)
_check4marked	proc	far
	push	es:Current_Event	; Save current event
c4mrk1:	call	 FAR PTR _index_storage
	jc	c4mrk2			; Skip if not edit
	FLAGBITS sort_Fmask		; Is this baby marked?
	jnz	c4mrky
c4mrk2:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jnz	c4mrk1
c4mrkn:	pop	ax
	call	 FAR PTR _index_storage
	clc
	ret

c4mrky:	pop	ax
	call	 FAR PTR _index_storage
	stc
	ret
_check4marked	endp

;================================================================
;These routines will return the offsetted
;address of the requested variable in an event

_getlast_reel	proc	far
	mov	bl,offset ZeroBase.reel_lofst
	jmps	_getlast_tc
_getlast_reel	endp
_getlast_pin	proc	far
	mov	bl,offset ZeroBase.pin_lofst
	jmps	_getlast_tc
_getlast_pin	endp
_getlast_pout	proc	far
	mov	bl,offset ZeroBase.pout_lofst
	jmps	_getlast_tc
_getlast_pout	endp
_getlast_rin	proc	far
	mov	bl,offset ZeroBase.rin_lofst
	jmps	_getlast_tc
_getlast_rin	endp
_getlast_rout	proc	far
	mov	bl,offset ZeroBase.rout_lofst
	jmps	_getlast_tc
_getlast_rout	endp
_getlast_dur	proc	far
	mov	bl,offset ZeroBase.rdur_lofst
	jmps	_getlast_tc
_getlast_dur	endp
_getlast_mode	proc	far
	mov	bl,offset ZeroBase.mode_lofst
	jmps	_getlast_tc
_getlast_mode	endp
_getlast_ptcd	proc	far
	mov	bl,offset ZeroBase.ptcd_lofst
	jmps	_getlast_tc
_getlast_ptcd	endp
_getlast_rtcd	proc	far
	mov	bl,offset ZeroBase.rtcd_lofst
	jmps	_getlast_tc
_getlast_rtcd	endp
_getlast_gpi	proc	far
	mov	bl,offset ZeroBase.GPI_lofst
	jmps	_getlast_tc
_getlast_gpi	endp
_getlast_extra	proc	far
	mov	bl,offset ZeroBase.extra_lofst
	jmps	_getlast_tc
_getlast_extra	endp
_getlast_Flags	proc	far
	mov	bl,offset ZeroBase.Flags_lofst
_getlast_Flags	endp

_getlast_tc	proc	far
	pushf
	mov	bh,0
	add	bx,Current_Event_Adr
	mov	di,bx
	popf
	ret
_getlast_tc	endp


_getprev_pin	proc	far
	mov	al,offset ZeroBase.pin_lofst
	jmps	_getprev_tc
_getprev_pin	endp
_getprev_pout	proc	far
	mov	al,offset ZeroBase.pout_lofst
	jmps	_getprev_tc
_getprev_pout	endp
_getprev_rin	proc	far
	mov	al,offset ZeroBase.rin_lofst
	jmps	_getprev_tc
_getprev_rin	endp
_getprev_rout	proc	far
	mov	al,offset ZeroBase.rout_lofst
	jmps	_getprev_tc
_getprev_rout	endp
_getprev_mode	proc	far
	mov	al,offset ZeroBase.mode_lofst
_getprev_mode	endp

_getprev_tc	proc	far
	mov	ch,al
	mov	ax,Cln_Evnt_End
	call	 FAR PTR _index_storage
	mov	bl,ch
	jmps	_getlast_tc
_getprev_tc	endp


_getthis_pin	proc	far
	mov	al,offset ZeroBase.pin_lofst
	jmps	_getthis_tc
_getthis_pin	endp
_getthis_pout	proc	far
	mov	al,offset ZeroBase.pout_lofst
	jmps	_getthis_tc
_getthis_pout	endp
_getthis_rin	proc	far
	mov	al,offset ZeroBase.rin_lofst
	jmps	_getthis_tc
_getthis_rin	endp
_getthis_rout	proc	far
	mov	al,offset ZeroBase.rout_lofst
	jmps	_getthis_tc
_getthis_rout	endp
_getthis_mode	proc	far
	mov	al,offset ZeroBase.mode_lofst
_getthis_mode	endp

_getthis_tc	proc	far
	mov	ch,al
	mov	ax,Cln_Evnt_Strt
	call	 FAR PTR _index_storage
	mov	bl,ch
	call	 _getlast_tc
	ret
_getthis_tc	endp

;====================================
;	SYSTEM DELAY ROUTINES
;====================================
; 
DELAYMS	MACRO	Milliseconds
	push	ax
	push	dx
	mov	ax,Milliseconds MOD 0FFFFH
	mov	dx,Milliseconds / 0FFFFH
	call	FAR PTR _DelayMilliseconds
	pop	dx
	pop	ax
ENDM

_delsec	proc	far
	DELAYMS	10000
	ret
_delsec	endp
_delhalf	proc	far
	DELAYMS	5000
	ret
_delhalf	endp
_delqrtr	proc	far
	DELAYMS	2500
	ret
_delqrtr	endp
_delfrm	proc	far
	DELAYMS	333
	ret
_delfrm	endp
_delfld	proc	far
	DELAYMS	167
	ret
_delfld	endp
_delms	proc	far
	DELAYMS	10
	ret
_delms	endp
_deltick	proc	far
	DELAYMS	1
	ret
_deltick	endp
_dixdly	proc	far
	DELAYMS	525
	ret
_dixdly	endp
_delbrk	proc	far
	DELAYMS	6
	ret
_delbrk	endp
_delhnd	proc	far
	DELAYMS	2
	ret
_delhnd	endp

;================================================================
;	SET "AX" AND "BL" TO "AUX" AND "BLK" IF NECESSARY
_Set_AUXBLACK	proc	far
	call	 FAR PTR _E_flgs
	test	al,E_Flag_auxblk	; Flag: 3 byte AUX/BLK if set
	jnz	CAXBL3

; Set for 2 byte AX BL
	mov	ch,3
	mov	bx,offset AXstd_Msg
	mov	dx,offset Aux_Reel_Num
	call	 FAR PTR _mmv
	mov	bx,offset BLstd_Msg
	jmp	caxblx

CAXBL3:	mov	ch,3
	mov	bx,offset From_Aux_Msg
	mov	dx,offset Aux_Reel_Num
	call	 FAR PTR _mmv
	mov	bx,offset From_Blk_Msg

caxblx:	mov	ch,3
	mov	dx,offset Blk_Reel_Num
	call	 FAR PTR _mmv
	ret
_Set_AUXBLACK	endp



;================================================================
;--------------------------------------------------------
;	I N D E X   T O   E D I T   I N   E D L
;--------------------------------------------------------
;ENTER: AX = event number to index to
;Exit:	AX = returned unchanged,
;	Carry Flag set if Comment, C=0 otherwise
;	BX= Points to current event
;	Current event address is stored in Current_Event_Adr
;	Current event number stored in Current_Event
;WARNING: This routine WILL let you index beyond the end of the list
;	  AND to either line in a double line event
_index_storage	proc	far
	mov	bx,ax
	or	bx,bx			; Indexing to 0? Can't!
	jz	istor3
istor1:	cmp	bx,es:Next_Avail_Num	; Edit in the list or one beyond?
	jbe	istor2			; Jump if below or equal
	mov	bx,es:Current_Event
	cmp	bx,es:Next_Avail_Num	; Check for overflow above list
	jbe	istor2			; Its ok if less than next avail
	mov	bx,es:Next_Avail_Num	; Else point to the bottom of list
istor2:	mov	es:Current_Event,bx
	dec	bx
	push	cx
	MULTIPLY_BY line_length, bx
	pop	cx
	add	bx,offset Event_Storage
	mov	Current_Event_Adr,bx	; Get current event address
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT
	ret

istor3:	inc	bx			; Make it first event
	jmps	istor1

_index_storage	endp


; Index to BIN segment
; ENTER: AX = bin number
; Exit:	 ES = bin segment
;	 Edl_Seg = bin segment

_index2bin	proc	far
	push	ax
	push	si
	cbw
	dec	al
	shl	ax,1
	mov	si,offset Bin_Table
	add	si,ax
	mov	ax,[si]
	mov	es,ax
	pop	si
	pop	ax
	ret
_index2bin	endp

;================================================================
;	dw	offset ModeText_SES			; 2
;	db	'SES    ',0,0,0,0,0			; 12
;	db	4		; _E_evn_length		; 1
;	db	1		; _E_emn_pad		; 1
;	db	6		; E_reel_length		; 1
;	db	1		; E_reel_pad		; 1
;	db	6		; E_mode_length		; 1
;	db	2		; E_mode_pad		; 1
;	db	3		; E_aubx_pad		; 1
;	db	'*'		; E_r_mark		; 1
;	db	00000100b	; E_Flags		; 1
;	db	00000100b	; E1_Flags		; 1
;	db	0,0,0,0,0,0	; spares		; 6
;							; 30 BYTES
;
; Return appropiate byte in AX
_E_evn_l	proc	far
	mov	ax,offset ZeroBase.E_evn_length
	jmps	getEflg
_E_evn_l	endp
_E_emn_p	proc	far
	mov	ax,offset ZeroBase.E_emn_pad
	jmps	getEflg
_E_emn_p	endp
_e_rel_l	proc	far
	mov	ax,offset ZeroBase.E_reel_length
	jmps	getEflg
_e_rel_l	endp
_E_rel_p	proc	far
	mov	ax,offset ZeroBase.E_reel_pad
	jmps	getEflg
_E_rel_p	endp
_E_mod_l	proc	far
	mov	ax,offset ZeroBase.E_mode_length
	jmps	getEflg
_E_mod_l	endp
_E_mod_p	proc	far
	mov	ax,offset ZeroBase.E_mode_pad
	jmps	getEflg
_E_mod_p	endp
_E_ab_p	proc	far
	mov	ax,offset ZeroBase.E_axbl_pad
	jmps	getEflg
_E_ab_p	endp
_E_rmrk	proc	far
	mov	ax,offset ZeroBase.E_r_mark
	jmps	getEflg
_E_rmrk	endp
_E_flgs	proc	far
	mov	ax,offset ZeroBase.E_Flags
	jmps	getEflg
_E_flgs	endp
_E1_flgs	proc	far
	mov	ax,offset ZeroBase.E_Flags + 1
_E1_flgs	endp

getEflg	proc	far
	push	bx
	mov	bx,es:Mode_Pntr
	add	bx,ax
	mov	al,[bx]
	pop	bx
	ret
getEflg	endp


;================================================================
;================================================================
; Left set DS:BX reel to ES:DX reel buffer, pad w/Spaces
_left_set_reel	proc	far
	mov	cx,reel_length
lsr_lp:	mov	al,[bx]
	call	 _make_ucase
	xchg	bx,dx
	or	al,al
	jz	lsr_pd
	cmp	al,' '
	jz	lsr_pd
	mov	[bx],al
	xchg	bx,dx
	inc	bx
	inc	dx
	loop	lsr_lp
	ret
lsr_pd:	mov	byte ptr [bx],' '
	inc	bx
	loop	lsr_pd
	xchg	bx,dx
	ret
_left_set_reel	endp

;================================================================
; right set DS:BX reel to ES:DX reel buffer, pad w/Spaces
_left_set2edl	proc	far
	mov	cx,reel_length
rsr_lp:	mov	al,[bx]			; Get a character
	call	 _make_ucase
	xchg	bx,dx			; Destination address to BX
	or	al,al			; Null byte?
	jz	rsr_pd			; Pad if so
	cmp	al,' '			; Trailing space?
	jz	rsr_pd			; Pad if so

	mov	es:[bx],al		; Save character
	xchg	bx,dx			; Source address to BX
	inc	bx			; Inc source
	inc	dx			;  and destination
	loop	rsr_lp			; Loop for more
	ret
rsr_pd:	mov	byte ptr es:[bx],' '
	inc	bx
	loop	rsr_pd
	xchg	bx,dx
	ret
_left_set2edl	endp

;================================================================
;--------------------------------------------
; I N D E X   T O   C O R R E C T   E D I T
;	B Y   E D I T	N U M B E R
;--------------------------------------------
; Return with BX pointing to event, AX = event number
; or NZ if event not found
_find_edit_DX	proc	far
	mov	bx,dx
_find_edit_DX	endp

_find_edit_BX	proc	far
	push	di
	push	cx
	xor	ax,ax			; Start at edit 1 - 1
	mov	di,offset Event_Storage	; EDL start
	mov	cx,line_length

fndelp:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jz	fndnf
	cmp	es:byte ptr [di].cmnt_lofst,Editline_EDIT
	jnz	fndelp1
	cmp	bx,es:[di]
	jz	fndf
fndelp1:add	di,cx
	jmp	fndelp

fndnf:	pop	cx
	pop	di
	inc	ax
	ret

fndf:	pop	cx
	pop	di
	call	 _index_storage
	ret
_find_edit_BX	endp

;================================================================
; Check AL for '*', or non-digit ASCII character
;  If TRUE, return with C=1
_check4comment	proc	far
	and	al,7fh			; Clear any hi bits set
	cmp	al,'*'
	jz	ckcmtx
	cmp	al,'0'
	jc	ckcmtx
	cmp	al,':'
	jnc	ckcmtx
	clc
	ret
ckcmtx:	stc
	ret
_check4comment	endp

;================================================================
;Find a substring within a string (DX_BX)
;ENTRY: BX	= Base address of string to be searched
;	CH	= Length of string
;	ds:DX	= Base address of substring to look for
;	CL	= Length of substring
;Exit:	AL	= starting position of string,
;		  or 0 if substring not found in string
;
_instring	proc	far
	mov	string,bx	; Save string address
	mov	substg,dx	; Save substring address
	mov	sublen,cl	; Save substring length

;Number of searches = string length - substring length + 1
;If substring is longer than string, Exit immediately
; and indicate substring not found
	mov	al,ch
	sub	al,cl		; AL = string length - substring length
	jc	instrno		; Exit if string shorter than substring
	inc	al		; Count = difference inlengths + 1
	mov	cl,al		; CL gets Count
	mov	index,0		; Zero index reference

;Search until remaining string shorter than substring
instrl:	inc	index		; Increment starting index
	mov	ch,sublen	; CH = length of substring
	mov	dx,substg	; DX = starting address of string
	mov	bx,string	; BX = next address in string
				; CL = current value of Count

;Try to match substring starting at index
;Match imvolves comparing corresponding characters
; one at a time
instrsx:xchg	bx,dx
	mov	al,[bx]
	xchg	bx,dx		; Get a character of substring
	cmp	al,[bx]		; Compare to character of string
	jnz	instrl2		; Jumpif not the same
	dec	ch
	jz	instrfn		; Jump if substring found
	inc	bx		; Else, proceed to next character
	inc	dx
	jmps	instrsx

instrl2:
	inc	string		; Increment to next byte of string
	dec	cl		; CL = current value of Count
	jnz	instrl		; If enough string left

instrno:xor	al,al		; Not found, A = 0
	ret

instrfn:mov	al,index	; Get index, A = substring position
	ret
_instring	endp


;================================================================
_Save_All_Marks	proc	far
	push	ax
	push	cx
	push	es
	mov	ax,ds
	mov	es,ax
	mov	ax,Slave_Flags
	mov	oldslave_Flags,ax
	mov	ax,Gpi_Flags
	mov	oldgpi_Flags,ax
	mov	ax,Pmc_Flags
	mov	oldpmc_Flags,ax
	mov	ax,Spd_Flags
	mov	oldspd_Flags,ax
	mov	ax,Ramp_Flags
	mov	oldramp_Flags,ax
	mov	ax,MultRec_Flags
	mov	oldmultRec_Flags,ax

	mov	si,offset Gpi0
	mov	di,offset Oldgpis
	mov	cx,GPI_length * MAX_GPI_REGISTERS
	rep movsb
	mov	si,offset Slave_Table
	mov	di,offset Oldslave_Table
	mov	cx,ALL_DEVICES + 1
	rep movsb
	call	 FAR PTR _Save_Marktable
	pop	es
	pop	cx
	pop	ax
	ret
_Save_All_Marks	endp

_Save_Marktable	proc	far
	push	es
	push	ds
	pop	es
	mov	si,offset R_Tc.tcIN
	mov	di,offset Saved_Marks
	mov	cx,offset Mtbl_Length
	shr	cx,1
	rep movsw
	pop	es
	ret
_Save_Marktable	endp

;================================================================
_Restore_All_Marks	proc	far
	mov	ax,oldslave_Flags
	mov	Slave_Flags,ax
	mov	ax,oldgpi_Flags
	mov	Gpi_Flags,ax
	mov	ax,oldpmc_Flags
	mov	Pmc_Flags,ax
	mov	ax,oldspd_Flags
	mov	Spd_Flags,ax
	mov	ax,oldramp_Flags
	mov	Ramp_Flags,ax
	mov	ax,oldmultRec_Flags
	mov	MultRec_Flags,ax

	push	es
	mov	ax,ds
	mov	es,ax
	mov	si,offset Oldgpis
	mov	di,offset Gpi0
	mov	cx,GPI_length * MAX_GPI_REGISTERS
	rep movsb
	mov	si,offset Oldslave_Table
	mov	di,offset Slave_Table
	mov	cx,ALL_DEVICES + 1
	rep movsb
	call	 FAR PTR _Restore_Marktable
	pop	es
	ret
_Restore_All_Marks	endp

_Restore_Marktable	proc	far
	push	es
	push	ds
	pop	es
	mov	si,offset Saved_Marks
	mov	di,offset R_Tc.tcIN
	mov	cx,offset Mtbl_Length
	shr	cx,1
	rep movsw
	pop	es
	ret
_Restore_Marktable	endp

;-----------------------------------------------------------
;  Return In, Out, or Duration pointer for current machine
;-----------------------------------------------------------
_get_in	proc	far
	mov	ax,offset ZeroBase.tcIN

	jmp short	getinoutdur
_get_in	endp
_get_out	proc	far
	mov	ax,offset ZeroBase.tcOUT
	jmp short	getinoutdur
_get_out	endp
_get_dur	proc	far
	mov	ax,offset ZeroBase.tcDUR
getinoutdur:
	cmp	Current_Machine,0	; Record VTR?
	mov	bx,offset R_Tc.tcIN	; Ready to trim Rec In/Out/Dur
	jz	getinoutdur1
	mov	bx,Current_Inbuf
getinoutdur1:
	add	bx,ax
	xor	ax,ax
	or	al,[bx]			; LSB, MSB
	or	ax,1[bx]		; MSB
	ret
_get_dur	endp

;================================================================
;enter with BX pointing to source buffer
;Exit with BX pointing to the destination buffer
; z is set if buffer has no value
_Sttime_move	proc	far
	mov	dx,offset Sttime
	jmps	_tmves
_Sttime_move	endp
_Entime_move	proc	far
	mov	dx,offset Entime
	jmps	_tmves
_Entime_move	endp
_Elaptm_move	proc	far
	mov	dx,offset Elaptm
_Elaptm_move	endp
_tmves	proc	far
	push	si
	mov	si,dx
	mov	ax,[bx]
	mov	[si],ax
	mov	al,2[bx]
	mov	2[si],al
	pop	si
	mov	bx,dx	; Fall through to time value routine
	xor	ax,ax
	or	al,[bx]			; LSB, MSB
	or	ax,1[bx]		; MSB
	ret
_tmves	endp

;------------------------------------------------------
; Move 3 bytes from ES:BX to DS:...
; Enter: ES:BX points to source buffer
; Exit:	 DS:BX points to destination buffer
_sttime_move_ES	proc	far
	mov	dx,offset Sttime
	jmps	mvesx
_sttime_move_ES	endp

_entime_move_ES	proc	far
	mov	dx,offset Entime
	jmps	mvesx
_entime_move_ES	endp

_elaptm_move_ES	proc	far
	mov	dx,offset Elaptm
_elaptm_move_ES	endp

mvesx	proc	far
	push	si
	mov	si,dx
	mov	ax,es:[bx]
	mov	[si],ax
	mov	al,es:2[bx]
	mov	2[si],al
	pop	si
	mov	bx,dx
	ret
mvesx	endp


;================================================================
; Recompute specs for Wipe or Dissolve
;
;	RECORD IN	RECORD OUT	RECORD DUR
;	FROM IN		FROM OUT	FROM DUR
;	TO IN		TO OUT		TO DUR

;===============================================================
;time code arithmetic functions
;	TIMADD:	Entime = Sttime + Elaptm
;	TIMDIF:	Elaptm = Entime - Sttime
;----------------------------------------------------------------
;	M A T H E M A T I C A L   C O M P U T A T I O N S
;----------------------------------------------------------------
_ReCompute_EFX	proc	far		; Recompute the workspace
	mov	al,Trans_Type		; If its currently a CUT,
	cmp	al,'S'
	jz	rcomp0
	cmp	al,'C'			; Then just update
	jnz	_rcomp1
rcomp0:	call	 FAR PTR _ReCompute_CUT		; The appropriate values
	call	 _upd_getscr		; And update the screen
	ret
_ReCompute_EFX	endp

;----------------------------------------------------------------
; CASE: If RDUR>0 and FROMDUR>0 and TODUR=0
; Check FROMDUR for zero
_rcomp1	proc	far
	push	Current_VTRS
	xor	al,al			; Set for R-VTR
	call	Machine_Change_Far
	cmp	Trans_Type,'K'		; Check for KEY LOGIC processing
	jnz	DISS_rcomp
	jmp	_KEY_rcomp

DISS_rcomp:
	mov	al,From_Machine		; Select TO and FROM vtrs
	call	Machine_Change_Far		;  so buffers are properly
	mov	al,To_Machine		;  setup.
	call	Machine_Change_Far		;...
	call	 FAR PTR _compute_Flags		; Compute WORKSPACE VALUES = 0 Flags

;================================================================
; TESTED OK
;		Rin
;		FRMin	xx	xx
;		TOin
;
; Just return
	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_TOdur_bit
	or	ax,ax
	jnz	Dcomp1
	jmp	_Ncomp_done

;================================================================
;
;		Rin	Rout	Rdur
;		FRMin	FRMout	FRMdur
;		TOin
;
; If Rdur => FRMdur
; TOdur = Rdur - FRMdur
; ELSE
; TOdur = Rdur
; Rdur = FRMdur + TOdur
; RETURN
Dcomp1:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	cmp	ax,w_Rdur_BIT or w_FRMdur_bit
	jnz	Dcomp2

	mov	bx,offset R_Tc.tcDUR
	mov	dx,Current_FRMbuf
	add	dx,offset ZeroBase.tcDUR ;; CRNT_DUR_OFFSET	; Point to DUR
	call	 FAR PTR _cmp24b
	jnc	Dcomp1a

	call	 FAR PTR _TOdur_eq_Rdur
	call	 FAR PTR _Rdur_eq_FRMplusTO
	jmp	_Ncomp_done

Dcomp1a:call	 FAR PTR _TOdur_equ_RminusFRM
	jmp	_Ncomp_done


;================================================================
; TESTED OK
;		Rin	Rout	Rdur
;		FRMin
;		TOin	TOout	TOdur
;
; TOdur = Rdur
Dcomp2:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	cmp	ax,w_Rdur_BIT or w_TOdur_bit
	jnz	Dcomp3
	jmp	Dcomp3a

;================================================================
; TESTED OK
;		Rin	Rout	Rdur
;		FRMin	
;		TOin	
;
; TOdur = Rdur
; FRMdur = null duration
Dcomp3:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	cmp	ax,w_Rdur_BIT
	jnz	Dcomp4

Dcomp3a:call	 FAR PTR _TOdur_eq_Rdur
	call	 FAR PTR _FRMdur_eq_null
	jmp	_Ncomp_done

;================================================================
;
;		Rin
;		FRMin	FRMout	FRMin
;		TOin	TOout	TOdur
;
; Rdur = FRMdur + TOdur
Dcomp4:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	cmp	ax,w_FRMdur_bit or w_TOdur_bit
	jnz	Dcomp5
	call	 FAR PTR _Rdur_eq_FRMplusTO
	jmp	_Ncomp_done

;================================================================
;
;		Rin	Rout	Rdur
;		FRMin	FRMout	FRMin
;		TOin	TOout	TOdur
;
;;; Rdur = FRMdur + TOdur
;
; If RDUR <= FROM dur
;  delete RDUR before recalculation
; Endif
;
; If Rdur > FRMdur
; TOdur = Rdur - FRMdur
; Else
; Exit
; Endif
;================================================================
Dcomp5:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	cmp	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	jnz	Dcomp6

	mov	bx,offset R_Tc.tcDUR
	mov	dx,Current_FRMbuf
	add	dx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 FAR PTR _cmp24b
	jae	Dcomp5a			;????
	call	 FAR PTR _Rdur_eq_FRMplusTO
	jmp	Dcomp5x
Dcomp5a:call	 FAR PTR _TOdur_equ_RminusFRM

Dcomp5x:jmp	_Ncomp_done


;================================================================
;
;		Rin
;		FRMin
;		TOin	TOout	TOdur
;
; Rdur = FRMdur + TOdur
;================================================================
Dcomp6:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FRMdur_bit or w_TOdur_bit
	cmp	ax,w_TOdur_bit
	jnz	Dcomp6
	call	 FAR PTR _Rdur_eq_FRMplusTO
	call	 FAR PTR _FRMdur_eq_null
	jmp	_Ncomp_done

_rcomp1	endp

_Ncomp_done	proc	far
	pop	ax			; AL=source, AH=machine
	push	ax
	call	Machine_Change_Far
	pop	ax
	mov	al,ah
	call	Machine_Change_Far
	call	 FAR PTR _compute_Flags
	call	 _upd_getscr
	ret
_Ncomp_done	endp


;................................................................
_TOdur_eq_Rdur	proc	far
	mov	al,To_Machine
	call	Machine_Change_Far
	mov	bx,offset R_Tc.tcDUR
	call	 _NewDuration		; Set new R-VTR duration
	ret
_TOdur_eq_Rdur	endp

_Rdur_eq_TOdur	proc	far
	xor	al,al
	call	Machine_Change_Far
	mov	bx,Current_TObuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET
	call	 _NewDuration		; Set new R-VTR duration
	ret
_Rdur_eq_TOdur	endp


_Rdur_eq_FRMplusTO	proc	far
	xor	al,al
	call	Machine_Change_Far		; We'll be setting R-VTR duration
	mov	bx,Current_FRMbuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 _Sttime_move
	mov	bx,Current_TObuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 _Elaptm_move
	call	 FAR PTR _timadd
	call	 _NewDuration		; Set new R-VTR duration
	ret
_Rdur_eq_FRMplusTO	endp

_TOdur_equ_RminusFRM	proc	far
	mov	al,To_Machine
	push	dx			; Save FROM BUF
	push	bx			; Save REC BUF
	call	Machine_Change_Far
	pop	bx			; Move REC BUF
	call	 _Entime_move
	pop	bx			; Move FROM BUF
	call	 _Sttime_move
	call	 FAR PTR _timdif
	call	 _NewDuration		; Set new R-VTR duration
	ret
_TOdur_equ_RminusFRM	endp

_FRMdur_eq_null	proc	far
	mov	al,From_Machine		; Set NULL from duration
	call	Machine_Change_Far
	mov	bx,Current_FRMbuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET
	call	 _NewDuration		; Set new R-VTR duration
	ret
_FRMdur_eq_null	endp

;================================================================
;================================================================
;			COMPUTE FOR KEYS
;================================================================
;================================================================
_KEY_rcomp	proc	far
	mov	al,Keybkgnd_Src		; Select TO and FROM vtrs
	call	Machine_Change_Far		;  so buffers are properly
	mov	al,Keyfor_Src		;  setup.
	call	Machine_Change_Far		;...
	call	 FAR PTR _compute_Flags

;================================================================
;
;		Rin
;		FORin	xx	xx
;		BKGin
;
; RETURN
	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_BKGdur_bit
	or	ax,ax
	jnz	Kcomp1
	jmp	_Ncomp_done

;================================================================
;
;		Rin	Rout	Rdur
;		FORin	FORout	FORdur
;		BKGin
;
; If Rdur => FORdur
; BKGdur = Rdur - FORdur
; ELSE
; BKGdur = Rdur
; Rdur = FORdur + BKGdur
; RETURN
Kcomp1:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	cmp	ax,w_Rdur_BIT or w_FORdur_bit
	jnz	Kcomp2

	mov	bx,offset R_Tc.tcDUR
	mov	dx,Current_FORbuf
	add	dx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 FAR PTR _cmp24b
	jnc	Kcomp1a

	call	 FAR PTR _BKGdur_eq_Rdur
	call	 FAR PTR _Rdur_eq_FORplusBKG
	jmp	_Ncomp_done

Kcomp1a:call	 FAR PTR _BKGdur_equ_RminusFOR
	jmp	_Ncomp_done


;================================================================
;
;		Rin	Rout	Rdur
;		FORin
;		BKGin	BKGout	BKGdur
;
; If Rdur => BKGdur
; FORdur = Rdur - BKGdur
; else
; BKGdur = Rdur
Kcomp2:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	cmp	ax,w_Rdur_BIT or w_BKGdur_bit
	jnz	Kcomp3

	mov	bx,offset R_Tc.tcDUR
	mov	dx,Current_BKGbuf
	add	dx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 FAR PTR _cmp24b
	jb	Kcomp3a

Kcomp2a:mov	al,Keyfor_Src
	push	dx			; Save FROM BUF
	push	bx			; Save REC BUF
	call	Machine_Change_Far
	pop	bx			; Move REC BUF
	call	 _Entime_move
	pop	bx			; Move FROM BUF
	call	 _Sttime_move
	call	 FAR PTR _timdif			; _timdif: Elaptm = Entime - Sttime
	call	 _NewDuration		; Set new R-VTR duration
	jmp	_Ncomp_done


;================================================================
;
;		Rin	Rout	Rdur
;		FORin	
;		BKGin	
;
; BKGdur = Rdur
; FORdur = null duration
Kcomp3:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	cmp	ax,w_Rdur_BIT
	jnz	Kcomp4

Kcomp3a:call	 FAR PTR _BKGdur_eq_Rdur
	call	 FAR PTR _FORdur_eq_null
	jmp	_Ncomp_done

;================================================================
;
;		Rin
;		FORin	FORout	FORin
;		BKGin	BKGout	BKGdur
;
; Rdur = FORdur + BKGdur
Kcomp4:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	cmp	ax,w_FORdur_bit or w_BKGdur_bit
	jnz	Kcomp5
	call	 FAR PTR _Rdur_eq_FORplusBKG
	jmp	_Ncomp_done

;================================================================
;
;		Rin	Rout	Rdur
;		FORin	FORout	FORin
;		BKGin	BKGout	BKGdur
;
; Rdur = FORdur + BKGdur
;================================================================
Kcomp5:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	cmp	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	jnz	Kcomp6
	call	 FAR PTR _Rdur_eq_FORplusBKG
	jmp	_Ncomp_done


;================================================================
;
;		Rin
;		FORin
;		BKGin	BKGout	BKGdur
;
; Rdur = FORdur + BKGdur
;================================================================
Kcomp6:	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_FORdur_bit or w_BKGdur_bit
	cmp	ax,w_BKGdur_bit
	jnz	Kcomp7
	call	 FAR PTR _Rdur_eq_FORplusBKG
	call	 FAR PTR _FORdur_eq_null
	jmp	_Ncomp_done

Kcomp7:	jmp	_Ncomp_done	; FIX 4-08-1992 

_KEY_rcomp	endp

;................................................................
_BKGdur_eq_Rdur	proc	far
	mov	al,Keybkgnd_Src
	call	Machine_Change_Far
	mov	bx,offset R_Tc.tcDUR
	call	 _NewDuration		; Set new R-VTR duration
	ret
_BKGdur_eq_Rdur	endp

_Rdur_eq_FORplusBKG	proc	far
	xor	al,al
	call	Machine_Change_Far		; We'll be setting R-VTR duration
	mov	bx,Current_FORbuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 _Sttime_move
	mov	bx,Current_BKGbuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET	; Point to DUR
	call	 _Elaptm_move
	call	 FAR PTR _timadd
	call	 _NewDuration		; Set new R-VTR duration
	ret
_Rdur_eq_FORplusBKG	endp

_BKGdur_equ_RminusFOR	proc	far
	mov	al,Keybkgnd_Src
	push	dx			; Save FROM BUF
	push	bx			; Save REC BUF
	call	Machine_Change_Far
	pop	bx			; Move REC BUF
	call	 _Entime_move
	pop	bx			; Move FROM BUF
	call	 _Sttime_move
	call	 FAR PTR _timdif
	call	 _NewDuration		; Set new R-VTR duration
	ret
_BKGdur_equ_RminusFOR	endp

_FORdur_eq_null	proc	far
	mov	al,Keyfor_Src		; Set NULL from duration
	call	Machine_Change_Far
	mov	bx,Current_FORbuf
	add	bx,offset ZeroBase.tcDUR ;;CRNT_DUR_OFFSET
	call	 _NewDuration		; Set new R-VTR duration
	ret
_FORdur_eq_null	endp


;================================================================
; Re-compute workspace with out updating screen
_ReCompute_CUT	proc	far
	push	Current_VTRS
	mov	al,To_Machine
	mov	ah,From_Machine
	push	ax


	xor	al,al			; Set for R-VTR
	call	Machine_Change_Far
	mov	al,Current_Source
	mov	To_Machine,al
	call	Machine_Change_Far
	call	 FAR PTR _compute_Flags

;================================================================
;
;		Rin
;		TOin
;Just return
	mov	ax,Workspace_Flags
	and	ax,w_Rdur_BIT or w_TOdur_bit
	or	ax,ax
	jnz	Ccomp1
	jmp	Ccomp_Done

;================================================================
;
;		Rin
;		TOin	TOout	TOdur
;
; Rdur = TOdur
Ccomp1:	cmp	ax,w_TOdur_bit		; (AX has masked Rdur and TOdur bits)
	jnz	Ccomp2
	call	 _Rdur_eq_TOdur
	jmp	Ccomp_Done


;================================================================
;
;		Rin	Rout	Rdur
;		TOin
; TOdur = Rdur
Ccomp2:	cmp	ax,w_Rdur_BIT
	jnz	Ccomp3
	call	 _TOdur_eq_Rdur
	jmp	Ccomp_Done

;================================================================
;
;		Rin	Rout	Rdur
;		TOin	TOout	TOdur
; TOdur = Rdur
Ccomp3:	cmp	ax,w_Rdur_BIT or w_TOdur_bit
	jnz	Ccomp_Done
	call	 _TOdur_eq_Rdur

Ccomp_Done:
	pop	ax			; Restore TO and FROM 
	mov	To_Machine,al		; VTRs
	mov	From_Machine,ah
	jmp	_Ncomp_done

_ReCompute_CUT	endp

;================================================================
; Convert DROP FRAME CODE to NON DROP FRAME
; ENTER: BX points to TC Value (DROP FRAME)
; Exit:	 BX points to adjusted TC Value (NON DROP FRAME)
_cnvt2nd_ES	proc	far
	IF PAL
	RET
	ENDIF
	push	es
	jmps	c2df
_cnvt2nd_ES	endp

_cnvt2nd	proc	far
	IF PAL
	RET
	ENDIF
	push	es
	push	ds
	pop	es
c2df:	push	si			; Save SI register
	xor	ax,ax			; Skip if TC val = 0
	or	al,es:[bx]
	jnz	c2df1
	or	ax,es:1[bx]
	jz	c2dfx
c2df1:	call	 FAR PTR _drop_calc		; Calc Drop Frames [SI..]
	mov	ax,[si]			; Subtract ES:BX - ES:SI
	sub	es:[bx],ax		; BX=TC Val, DX & SI = Drop Frames
	mov	al,2[si]
	sbb 	es:2[bx],al
c2dfx:	pop	si
	pop	es
	ret
_cnvt2nd	endp

;================================================================
; Convert NON DROP FRAME time code to DROP FRAME code
; ENTER: BX points to TC Value
; Exit:	 BX points to adjusted TC Value (DROP FRAME)
_cnvt2df_ES	proc	far
	IF PAL
	RET
	ENDIF
	push	es
	jmps	c2nd
_cnvt2df_ES	endp

_cnvt2df_FAR	proc	far
	call	 FAR PTR _cnvt2df
	ret
_cnvt2df_FAR	endp

_cnvt2df	proc	far
	IF PAL
	RET
	ENDIF
	push	es
	push	ds
	pop	es
c2nd:	push	si
	xor	ax,ax			; Skip if TC val = 0
	or	al,es:[bx]
	jnz	c2nd1
	or	ax,es:1[bx]
	jz	c2ndx
c2nd1:	call	 FAR PTR non_drop_calc		; Calc Drop Frames [SI..]
	mov	ax,[si]			; BX=TC Val, DX & SI = Drop Frames
	add	es:[bx],ax
	mov	al,2[si]
	adc	es:2[bx],al

	call	 FAR PTR _calc_frames
	jnz	c2ndx

	sub	word ptr es:[bx],2	; :00 or :01 on even minute
	jnc	c2ndx			; execpt 10s minutes
	dec	byte ptr es:2[bx]	; so decrease by 2 frames

c2ndx:	pop	si
	pop	es
	ret
_cnvt2df	endp

;================================================================
; PURPOSE:
;  to find out if we are adjusting numbers like 1:01:00:00 for DF
;
; Calculate # of frames left
;  after subtacting all hours and minutes
; ENTER: BX points to DS:24bit TC value
; Exit: Z=0 there are remaining frames > 1
;	Z=0 if Minutes cannot be evenly divided evenly by 10
;	Z=1 if even minute with 0 or 1 frame and not divisible by 10
_calc_frames	proc	far
	push	bx			; Save address to original value
	call	_mvb2st3			; Save tc val to Bytstr3

	mov	dx,offset Hrs_Cnt	; Point to start of hrs,min,sec table
	call	 FAR PTR _div_tc			; Divide out hours
	call	 FAR PTR _div_tc			; Divide out minutes

	cmp	word ptr Bytstr3,2	; More than 1 remaining frame?
	jnc	clcfrnz			; Return Z=0 if any remaining frames

	mov	ax,cx			; AX = # of minutes
	mov	bl,10			; Are number of minutes evenly
	div	bl			;  divisible by 10?
	or	ah,ah			; If Not evenly divisible,
	jz	clcfrnz			;  skip it with Z=0
	xor	al,al
	pop	bx
	ret

clcfrnz:xor	al,al
	inc	al			; Return NZ (Z=0)
frmrmx:	pop	bx			; Restore address to orig TC value
	ret
_calc_frames	endp

; BX points to divisor
_div_tc	proc	far
	xor	cx,cx			; Clear 16bit result from division
	mov	bx,offset Bytstr3	; Point to the DIVIDEND
	call	_mvb2st4		; Save tc val to Bytstr4

	call	 FAR PTR _cmp24b	; Is the dividend < divisor?
	jb	_div_tcx
	call	 FAR PTR _mpbdiv	; BX Bytstr3 / DX (hrs,min,or sec)
	mov	cx,[bx]			; Get 16bit result from division
	mov	bx,offset Bytstr4	; BX points to prev tc value
	call	 _mvb2st3		; Restore to division accumulator

	mov	bx,offset Bytstr3
	jcxz	_div_tcx
	push	cx			; Save 16bit divide factor
	mov	si,dx
_div_tcl:mov	ax,[si]			; Bytstr4 = Bytstr4 - Divdval
	sub	[bx],ax
	mov	al,2[si]
	sbb 	2[bx],al
	loop	_div_tcl
	pop	cx			; Restore 16bit divide result
_div_tcx:inc	dx
	inc	dx
	inc	dx
	ret
_div_tc	endp

;----------------------------------------------------------------
; Drop frame adjust: Calculate drop frames for time code
; ENTER: ES:BX points to number
; Exit: BX points to original number
;	SI point to Dfbuf1 = dropframe Count (24bits)
;	(Dfbuf2 has 10s of minutes)
_drop_calc	proc	far
	push	bx			; Save address to number

	mov	si,offset Dfbuf1	; Orig TC val --> Dfbuf1
	mov	ax,es:[bx]
	mov	[si],ax
	mov	al,es:2[bx]
	mov	2[si],al

	mov	dx,offset Min_Cnt	; Use full non-drop minute
	jmp	_nddcalc
_drop_calc	endp

;----------------------------------------------------------------
; Non drop frame adjust: Calculate drop frames for non-drop code
; ENTER: ES:BX points to number
; Exit: BX points to original number
;	SI point to Dfbuf1 = dropframe Count (24bits)
;	(Dfbuf2 has 10s of minutes)
non_drop_calc	proc	far
	push	bx			; Save address to number

	mov	dx,es:[bx]		; Multiply tc value by 5
	mov	al,es:2[bx]
	add	dx,dx
	adc	al,al
	add	dx,dx
	adc	al,al
	add	dx,es:[bx]
	adc	al,es:2[bx]
	mov	si,offset Dfbuf1	; Store TC*5 to Dfbuf1
	mov	[si],dx
	mov	2[si],al
	mov	dx,offset Dmin_Cnt	; Use drop-frame minute
non_drop_calc	endp

;----------------------------------------------------------------
_nddcalc	proc	far
	mov	bx,si			; BX points to Dfbuf1
	call	 FAR PTR _mpbdiv	; TC/MIN --> dbuf1
	xor	dx,dx			; Clear DX for a 16 bit divide
	mov	ax,[si]			; Get # of minutes
	mov	bx,10			; Divide by 10
	div	bx

; Get # of even 10 minutes (MIN/10)
	mov	bx,offset Dfbuf2	; Point to Dfbuf2
	mov	[bx],ax			; Save 10s of minutes
	mov	byte ptr 2[bx],0	;  to Dfbuf2

	mov	dx,bx			; Dfbuf2 to DX
	mov	bx,si			; Dfbuf1 to BX
	call	 FAR PTR _mpbsub	; Dfbuf1 = mins-10mins
	mov	dx,bx			; BX and DX points to Dfbuf1
	call	 FAR PTR _mpbadd	; Double it

ndclx:	pop	bx			; Restore pointer to original number
	mov	si,dx			; SI points to drop frame buffer
	ret
_nddcalc	endp


;================================================================
; Return C=1 if not successful (put at top of list)
;
; Go backwards in EDL until:
;  The NEW RECORD IN is greater than the OLD RECORD IN
_sort_match	proc	far
	call	 _check4edl		; Get last event number
	jz	srtxit			; Ret, if no EDL
srtb_1:	call	 _index_storage
	jc	srtb_2			; Skip the comments
	call	 _getlast_rin
	mov	dx,offset Sortmatch_In
	call	 FAR PTR _cmp24b_ESDS		; NRIN <= ORIN
	jbe	srtf_1
srtb_2:	mov	ax,es:Current_Event
	dec	ax
	jnz	srtb_1
	jmp	srtf_1a
srtxit:	ret

; Found.
; Go forward in EDL WHILE:
; The New record OUT is less than the old record OUT
; and
; The New record OUT is less than the old record IN
srtf_1:
	mov	ax,es:Current_Event
srtf_1a:inc	ax
	cmp	ax,es:Next_Avail_Num
	jz	srtf_eol
	call	 _index_storage
	jc	srtf_1			; Skip the comments

	call	 _getlast_rout
	mov	dx,bx
	mov	bx,offset Sortmatch_Out
	call	 FAR PTR _cmp24b_DSES		; NROUT < OROUT
	jae	srtf_1

	call	 _getlast_rin
	mov	dx,bx
	mov	bx,offset Sortmatch_Out
	call	 FAR PTR _cmp24b_DSES		; NROUT < ORIN
	ja	srtf_1

	mov	ax,es:Current_Event
	dec	ax
srtf_1x:mov	es:Current_Event,ax
	clc
	ret

; Put at end of list
srtf_eol:
	mov	ax,es:Next_Avail_Num
	dec	ax
	clc
	ret
_sort_match	endp


;================================================================
_compute	proc	far
	call	 FAR PTR _computer		; Compute In/Out/Duration
	call	 _upd_getscr		; And update the screen
	ret
_compute	endp

;================================================================
;	Compute workspace for given machine
;================================================================
_computer	proc	far
	call	 _get_in			; If the IN
	mov	dx,bx			;  is greater than
	call	 _get_out		;  or equal to
	call	 FAR PTR _cmp24b			;  the OUT
	jnc	compu1			;  then,
	call	 _get_dur		; Clear duration
	xor	ax,ax
	call	 _clear_tc
	jmp	compux

;IF IN out dur THEN Exit
;IF in OUT dur THEN Exit
;IF in out DUR THEN CALULATE OUT
compu1:	call	 _get_out		; See if out and dur = 0
	jnz	compu2
	call	 _get_dur
	jz	compux
compu2:	call	 _get_in			; See if in and dur = 0
	jnz	compu3
	call	 _get_dur
	jz	compux
compu3:	call	 FAR PTR _up_dur
compux:	call	 FAR PTR _compute_Flags
	ret
_computer	endp

;update the duration
_up_dur	proc	far
	VTRFCM
	call	 _get_in
	jz	_up_in			; If no IN, calculate it
	call	 _Sttime_move		; Else make it the start time
	call	 _get_out
	jz	_up_out
	call	 _Entime_move		; And call it the endtime
	call	 FAR PTR _timdif			; DUR = out - in
	mov	dx,bx
	call	 _get_dur
	xchg	bx,dx
	call	 _mmv3byt		; Put it there and return
	ret
_up_dur	endp

;update the outpoint
_up_out	proc	far
	VTRFCM
	call	 _get_in
	call	 _Sttime_move
	call	 _get_dur
	call	 _Elaptm_move
	call	 FAR PTR _timadd			; OUT = in + dur
	mov	dx,bx
	call	 _get_out
	xchg	bx,dx
	call	 _mmv3byt		; Put it there and return
	ret
_up_out	endp

;update the in point
_up_in	proc	far
	VTRFCM
	call	 _get_dur
	call	 _Sttime_move
	call	 _get_out
	call	 _Entime_move
	call	 FAR PTR _timdif			; IN = out - dur
	mov	dx,bx
	call	 _get_in
	xchg	bx,dx
	call	 _mmv3byt		; Put it there and return
	ret
_up_in	endp

;update the outpoint, no  matter what
_update_out	proc	far
	VTRFCM
	call	 _get_in
	call	 _Sttime_move
	call	 _get_dur
	call	 _Elaptm_move
	call	 FAR PTR _timadd			; OUT = in + dur
	mov	dx,bx
	call	 _get_out
	xchg	bx,dx
	call	 _mmv3byt		; Put it there and return
	ret
_update_out	endp

;update the in point
_update_in	proc	far
	VTRFCM
	call	 _get_dur
	call	 _Sttime_move
	call	 _get_out
	call	 _Entime_move
	call	 FAR PTR _timdif			; IN = out - dur
	mov	dx,bx
	call	 _get_in
	xchg	bx,dx
	call	 _mmv3byt		; Put it there and return
	ret
_update_in	endp



;---------------------------------------------
; Find * DURATION * from start and end times |
;---------------------------------------------

;Find the duration existing between the Start time and End time, or:
;TIMDIF  ====>	Entime - Sttime = Elaptm (duration)
;If Entime < Sttime then Elaptm = 24:00:00:00 - (Sttime - Entime)

_timdif	proc	far
	mov	bx,offset Entime
	mov	dx,offset Sttime
	call	 FAR PTR _cmp24b
	jnc	timdifa
	mov	bx,offset Twenty4hrs
	call	 _Elaptm_move

	mov	bx,offset Sttime
	mov	dx,offset Bytstr1
	push	dx
	call	 _mmv3byt
	mov	bx,offset Entime
	mov	dx,offset Bytstr2
	call	 _mmv3byt
	pop	bx
	call	 FAR PTR _mpbsub
	mov	dx,bx
	mov	bx,offset Elaptm
	call	 FAR PTR _mpbsub
	ret

timdifa:mov	bx,offset Entime
	mov	dx,offset Elaptm
	call	 _mmv3byt
	mov	bx,dx
	mov	dx,offset Sttime
	call	 FAR PTR _mpbsub
	ret
_timdif	endp

_timadd	proc	far
	mov	bx,offset Sttime
	mov	dx,offset Entime
	call	 _mmv3byt
	mov	bx,dx
	mov	dx,offset Elaptm
	call	 FAR PTR _mpbadd
_timadd	endp

;Make timecode number MOD 23:59:59:29
;BX returns with same address.	DX destroyed, and points to Twenty4hrs
_mod24hrs	proc	far
;;	mov	dx,offset Twenty4hrs_N
;;	cmp	cl,'D'
;;	jz	m24h1
	mov	dx,offset Twenty4hrs
m24h1:	call	 FAR PTR _cmp24b			; Is Elaptm < Twenty4hrs?
	jc	modxit
	call	 FAR PTR _mpbsub
	jmps	_mod24hrs
_mod24hrs	endp

_mod100hrs	proc	far
	mov	dx,offset Hundredhrs
	call	 FAR PTR _cmp24b
	jc	modxit
	call	 FAR PTR _mpbsub
	jmps	_mod100hrs
modxit:	ret
_mod100hrs	endp


;----------------------------------------------------
; C L E A N   L A S T	E V E N T   I N   L I S T
;----------------------------------------------------
;HOW TO CLEAN A LIST IN 10 MILLION EASY STEPS

_clean_last	proc	far
	test	Operational_Flags,clean_OPBIT
	jz	clnexit

;;;;	call	 _savebin		; Save the bin before cleaning
	mov	ax,es:Current_Event	; Start with current event

;Skip cleaning dbl line events and comments
cln001:	call	 _index_storage
	jnc	cln003
	inc	ax				; Inc event, check eol
	mov	bx,offset Next_Avail_Num
	cmp	ax,es:[bx]
	jnz	clnexit

cln003:	mov	Cln_Evnt_Strt,ax	; "CLEAN REFERENCE EDIT" CLNREF
cln004:	dec	ax			; Index to event being cleaned
	jz	clnexit

	call	 _index_storage		; Set pointers to event
	jc	cln004			; Loop past comments
	cmp	es:byte ptr [bx].type_lofst,'C'	; Get type of event
	jz	cln005
	dec	ax
	jnz	cln004

clnexit:ret

cln005:	mov	Cln_Evnt_End,ax		; "EVENT TO BE CLEANED" TOBECLN


; **** Reference edit must begin BEFORE the TOBECLN edit ENDS
; if not, there is nothing to clean
; So, abort if TOBECLN R_IN = > CLNREF R_OUT
	call	nrin_orout		; NEW R IN must be less than OLD R OUT
	jc	cln005A
	jmp	clnxit			; Else abort

; **** !! AND !! Reference edit must end AFTER the TOBECLN edit BEGINS
; So, abort if CLNREF R_OUT < = TOBECLN R_IN
cln005A:
	call	nrout_orin		; Compare NEW R OUT to OLD R IN
	ja	cln006
	jmp	clnxit			; Else abort


;We can only clean edits of same modes
;so, CLNREF MODE must equal TOBECLN MODE
cln006:	call	 _getthis_mode		; -- Check out modes
	mov	dl,es:[bx]
	call	 _getprev_mode
	cmp	dl,es:[bx]		; Are modes equal?
	jz	cln007
	jmp	clnxit	; Pass line up if no mode match

;If the CLNREF edit begins earlier than the TOBECLN edit
; then a separate edit must be made for the duration =
;
cln007:	call	orin_nrin		; Is OLD R IN < NEW R IN
	jnc	JL0830
	call	make_prev		; Must make a previous event
JL0830:	call	nrout_orout		; Is NEW R OUT < OLD R OUT
	jnc	cln008
	call	make_next	; Must make another edit after current one
	ret

cln008:	mov	ax,Cln_Evnt_End
	call	 _index_storage

	call	 FAR PTR _delete			; Delete the event thats left over

	mov	ax,Cln_Evnt_End
	jmp	cln003

clnxit:	mov	ax,es:Current_Event
	inc	ax
	call	 _index_storage
	ret

_clean_last	endp


;Make previous
;OLD R IN  = unchanged
;OLD R OUT = NEW R IN
;OLD P IN  = unchanged
;OLD P OUT = (OLD P IN) + (R DUR)
;To make previous event:
;Copy prev event to workspace, alter r/p in/out points,
;insert into list at (Cln_Evnt_End) - 1, increment pointers to
;start and end
make_prev	proc	near

;Get the previous edit to the work space for modification
	mov	ax,Cln_Evnt_End
	call	 _index_storage
	call	mmv2wrkspce

;Shave off the record and play out points
; so there are no overlaps
	call	 _getthis_rin		; New record in becomes
	push	bx			; Save RIN position for calc
	mov	dx,offset Work_Event.rout_lofst ; The old record out
	call	 _mmv3_es2ds

	mov	bx,offset Work_Event.rin_lofst ; Get duration
	call	g_ofset			; Get Prev R duration (Elaptm)
	call	 _getprev_pin
	call	 _sttime_move_ES
	call	 _timadd			; Sttime + Elaptm = Entime
	mov	dx,offset Work_Event.pout_lofst
	call	 _mmv3byt
	pop	dx			; Restore RIN position
	call	 FAR PTR _calc_evdur

;Insert it back in the list just before CURRENT EVENT
	mov	ax,Cln_Evnt_End
	call	 _index_storage
	push	bx
	call	 FAR PTR _make_room		; AX=blank event
	pop	dx
	mov	bx,offset Work_Event

	push	dx
	mov	ch,line_length
	call	_mmv_DSES
	pop	dx
	call	 FAR PTR _calc_cdx

;Increment the reference and to-be-cleaned edit pointers
	inc	Cln_Evnt_End
	inc	Cln_Evnt_Strt
	ret
make_prev	endp

;Make next
;OLD R IN  = NEW R OUT
;OLD R OUT = unchanged
;OLD P IN  = (OLD P OUT) - (R DUR)
;OLD P OUT = unchanged
;To make the next event:
;Copy prev event to workspace, alter r/p in/out points,
;and replace in the list at Cln_Evnt_Strt.
make_next	proc	near

; Get the TOBECL edit in the workspace for modification
	mov	ax,Cln_Evnt_End
	call	 _index_storage
	call	mmv2wrkspce

; Adjust the
	call	 _getthis_rout
	mov	dx,offset Work_Event.rin_lofst ; R In
	call	 _mmv3_es2ds
	mov	bx,dx
	mov	dx,offset Work_Event.rout_lofst ; R out
	call	g_ofset			; Get duration
	mov	bx,offset Clean_Offset
	mov	dx,offset Work_Event.pout_lofst ; P out
	push	bx
	call	g_ofset			; Subtract it from old p out
	pop	bx
	mov	dx,offset Work_Event.pin_lofst ; P in
	call	 _mmv3byt

	call	 FAR PTR _calc_curdur

	mov	ax,Cln_Evnt_End
	call	 _index_storage

	mov	ax,es:Next_Edit
	mov	Work_Event,ax		; Store edit number
	inc	es:Next_Edit

	mov	dx,bx
	mov	bx,offset Work_Event
	mov	ch,line_length
	call	_mmv_DSES

	call	 FAR PTR _calc_curdur

	mov	ax,es:Current_Event
	inc	ax
	call	 _index_storage
	ret
make_next	endp

;Get the offset between two timecodes
;ENTER: BX points to TC1
;	DX points to TC2
;DO:	TC2 - TC1
;Exit:	Offset stored in Clean_Offset
;	BX points to Clean_Offset
;	DX/CX/PSW destroyed
;	Offset	= old R_Tc.tcOUT - R_Tc.tcIN
;	Elaptm	= Entime - Sttime
;	(BX = R_Tc.tcIN, DX = old R_Tc.tcOUT)
g_ofset	proc	near
	push	dx			; Save the old out
	call	 _Sttime_move		; Put it to the Sttime
	pop	bx			; Restore the out
	call	 _Entime_move		; It goes to the Entime
	call	 _timdif			; Entime - Sttime = Elaptm
	mov	dx,offset Clean_Offset	; Move the offset to a holding buffer
	call	 _mmv3byt		; Clean_Offset = task 1.
	ret
g_ofset	endp

;--------------------------------------------
;List time code compare subroutines
nrin_orout	proc	near	; Compare NEW R IN to OLD R OUT
	call	 _getprev_rout
	mov	dx,bx
	call	 _getthis_rin
	call	 FAR PTR _cmp24b_ESES
	ret
nrin_orout	endp

orin_nrin	proc	near	; Compare OLD R IN to NEW R IN
	call	 _getthis_rin
	mov	dx,bx
	call	 _getprev_rin
	call	 FAR PTR _cmp24b_ESES
	ret
orin_nrin	endp

nrout_orout	proc	near	; Compare NEW R OUT to OLD R OUT
	call	 _getprev_rout
	mov	dx,bx
	call	 _getthis_rout
	call	 FAR PTR _cmp24b_ESES
	ret
nrout_orout	endp

nrout_orin	proc	near	; Compare NEW R OUT to OLD R IN
	call	 _getprev_rin
	mov	dx,bx
	call	 _getthis_rout
	call	 FAR PTR _cmp24b_ESES
	ret
nrout_orin	endp

;================================================================
; Move line from EDL to workspace
mmv2wrkspce	proc	near
	push	si
	mov	si,offset Work_Event
	mov	cx,line_length
mmv2w:	mov	al,es:[bx]
	mov	[si],al
	inc	bx
	inc	si
	loop	mmv2w
	pop	si
	ret
mmv2wrkspce	endp




;================================================================
; Return C=1 if not successful (put at top of list)
;
; Go backwards in EDL until:
;  Reel matched
_reel_match	proc	far
	mov	ax,es:Next_Avail_Num
	dec	ax			; Get last event number
	jz	srtrxit			; Ret, if no EDL
srtr_1:	call	 _index_storage
	jc	srtr_2			; Skip the comments
	FLAGBITS sort_Fmask		; Test if already sorted...
	jnz	srtr_2			;  and jump if so
	call	 _getlast_reel
	mov	dx,Sort_Reeladr		; Get current reel address
	mov	ch,reel_length
	call	 _cmpchr			; Compare ES:reel, DS:reel
	jz	srtrxit
srtr_2:	mov	ax,es:Current_Event
	dec	ax
	jnz	srtr_1
	mov	bx,Sort_Reeladr		; Get current reel address
	add	bx,reel_length + 1
	cmp	byte ptr [bx],0		; Out of names?
	jnz	_reel_match
	stc
srtrxit:mov	ax,es:Current_Event
	ret
_reel_match	endp


;================================================================
;Compute Flags for current machine
; Set bits TRUE (1) if NON-ZERO time code
;
; Bits: 1	2	3	4	5	6	7	8
;      Rin     Rout   Rdur            TOin    TOout   TOdur
;
;	9	10	11	12	13	14	15	16
;    FROMin  FROMout  FROMdur  
;
_compute_Flags	proc	far
	push	bx
	push	cx
	push	dx
	xor	ax,ax
	mov	dx,w_Rin_BIT

	mov	bx,offset R_Tc.tcIN
	call	Ciod_chk
	call	Ciod_chk
	call	Ciod_chk
Ciod2:	mov	bx,Current_TObuf
	call	Ciod_chk
	call	Ciod_chk
	call	Ciod_chk
Ciod3:	mov	bx,Current_FRMbuf
	call	Ciod_chk
	call	Ciod_chk
	call	Ciod_chk
Ciod4:	mov	bx,Current_BKGbuf
	call	Ciod_chk
	call	Ciod_chk
	call	Ciod_chk
Ciod5:	mov	bx,Current_FORbuf
	call	Ciod_chk
	call	Ciod_chk
	call	Ciod_chk

Ciodx:	mov	Workspace_Flags,ax
	pop	dx
	pop	cx
	pop	bx
	ret
_compute_Flags	endp

Ciod_chk:
	xor	cx,cx
	or	cl,[bx]			; LSB, MSB
	or	cx,1[bx]		; MSB
	jz	Ciod_chkx
	or	ax,dx
Ciod_chkx:
	inc	bx
	inc	bx
	inc	bx
	shl	dx,1
	ret



;================================================================
; Sort all reels names into the DIRBUFF
; NOTE: Too many names will cause buffer overflow into the SCREEN SEGMENT
; Its ok if screen segment is not used for the period that sorted reel names
; will be used.
_sort_reels	proc	far
	push	es:Current_Event	; Save the current event

	mov	di,offset dirbuff	; Where to put reel names
	mov	Temp_Tc_Buf,di		; Init pointer to start of buffer
	mov	ds:word ptr [di],0	; Zero out buffer

	mov	ax,1			; Start with event #1

; This routine is the main loop for initially storing all reel names
;  into the DIRBUFF holding buffer.
; Note that if the names overflow the DIRBUFF buffer, they will just
;  drop into the screen write shadow buffer and cause no problems.
SR_mnlp:push	ax
	call	 _index_storage
	jc	SR_skp
	call	SR_StoreReel		; Search for and store reel
SR_skp:	pop	ax
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jb	SR_mnlp
	xor	al,al			; Make sure buffer is
	call	 FAR PTR _add_store		; terminated
	call	SR_leftsets		; Re-left-set reels
	pop	ax			; Restore event number
	call	 _index_storage		;  and set it as current
	ret

_sort_reels	endp
;----------------------------------------------------------------
; Save reel at edit ES:BX into the Ascii_Line buffer
; Reel names are stored initially in a RIGHT-SET mode for proper sorting
; After all reels are stored, they are left-set

SR_StoreReel:

; Move reel, set length, terminate with nul byte...
	add	bx,offset ZeroBase.reel_lofst		; Index over to reel
	mov	si,offset Ascii_Line
	mov	cx,reel_length
	mov	[si],cl			; Set length
	inc	si			; Point to start of Name position
	push	si
SRsr0:	mov	al,es:[bx]		; Move reel Name
	mov	[si],al
	inc	bx
	inc	si
	loop	SRsr0
	mov	[si],cl			; Terminate with null byte
	pop	si			; Restore start of Name position

SRsr1:	cmp	byte ptr reel_length - 1 [si],' '
	jnz	SRsr5

;Shift five character to the right, insert space at top
	push	si
	mov	bx,offset Ascii_Line + 5
	mov	cx,5
SRsr2:	mov	al,[bx]
	mov	[bx + 1],al
	dec	bx
	loop	SRsr2
	pop	si
	mov	byte ptr [si],' '
	jmp	SRsr1

;................................................................
SRsr5:	mov	si,offset Ascii_Line
	mov	ch,[si]			; Get length of string
	inc	si

	mov	bx,offset dirbuff

SR_in1:	cmp	byte ptr [bx],0		; End of list of names?
	jz	SR_append
	call	SR_cmpchr		; Found or not, returns start of
					;  search location in DX
	jz	SR_insx
	jc	SR_insert
	add	bx,reel_length + 1	; Look at next reel
	jmp	SR_in1

;................................................................
; Item found at DS:BX
; End of buffer pointer = [Temp_Tc_Buf] - 1
SR_insert:
	mov	si,Temp_Tc_Buf		; Get end of buffer pointer
	mov	cx,si			; # of bytes to move =
	sub	cx,bx			; End of buffer - position

	dec	si
	mov	di,si			; Destination = end of buffer position
	add	di,reel_length + 1	;  plus length of Name (w/nul term byte)

	push	es
	push	ds
	pop	es
	std
	rep movsb
	cld
	pop	es
	push	Temp_Tc_Buf
	mov	Temp_Tc_Buf,bx
	call	SR_storit
	pop	Temp_Tc_Buf
	add	Temp_Tc_Buf,reel_length + 1
	jmp	SR_term

SR_insx:ret				; Return if no match

SR_append:
	call	SR_storit

SR_term:mov	al,0
	call	 FAR PTR _add_store		; Double terminate line
	dec	Temp_Tc_Buf		; Adjust DIRBUFF position pointer
	ret

;................................................................
; Store to the end of the list
SR_storit:
	mov	si,offset Ascii_Line
	lodsb				; Get length byte
	cbw
	mov	cx,ax
SR_stor:lodsb
	call	 FAR PTR _add_store
	loop	SR_stor
	xor	al,al
	call	 FAR PTR _add_store
	ret

;================================================================
;SR_cmpchr - compare strings es:BX : ds:SI len in CH
SR_cmpchr:
	push	bx
	push	cx
	push	si
	even
SR_cmpch0:
	lodsb
	cmp	al,[bx]
	jnz	SR_cmpch1
	inc	bx
	dec	ch
	jnz	SR_cmpch0
SR_cmpch1:
	pop	si
	pop	cx
	pop	bx
	ret

;................................................................
SR_leftsets:
	mov	bx,offset dirbuff

SR_ls1:	cmp	byte ptr [bx],0		; End of buffer?
	jz	SRls_x

SR_ls2:	cmp	byte ptr [bx],' '	; Leading space?
	jnz	SRLsnxt			; If no more, move on to next Name
	push	bx
	mov	dx,bx
	inc	bx
	mov	ch,reel_length - 1
	call	 _mmv
	mov	bx,dx
	mov	byte ptr [bx],' '
	pop	bx
	jmp	SR_ls2

SRLsnxt:add	bx,reel_length + 1
	jmp	SR_ls1

SRls_x:	ret

;================================================================
; SORT SUBROUTINE: _srtbin2bin (Sort Bin to Bin)
; Move BINn:BX to next edit in BIN3
; Mark moved edit as MOVED (set a bit)
; Decrease Count to be moved in [Sort_Iters]
_srtbin2bin	proc	far
	push	ds			; Save DATA segment
	push	es			; Save BINn segment
	push	es
	push	bx			; Save BINn source address
	mov	al,Swap_Bin
	call	 _index2bin
	mov	ax,Where2_Number
	mov	es:Current_Event,ax
	call	 FAR PTR _make_room		; Make room in bin 3
	mov	di,bx			; Move destination address do DI
	pop	bx			; Get source address
	mov	si,bx
	pop	ds			; DS = BINn segment
	mov	cx,(line_length / 2)
	rep movsw
	pop	es			; Restore BINn
	pop	ds			; Restore Data segment
	or	es:word ptr [bx].Flags_lofst,sort_Fmask	; Mark it as used
	cmp	Sortwhat,2
	jz	sb2bx
	dec	Sort_Iters		; Decrease Count to be moved
	ret

; Exit NZ when used by SORT BY REELS routines
sb2bx:	inc	cx
	ret

_srtbin2bin	endp


_savebin	proc	far
	push	ax
	push	cx
	push	si
	push	di
	mov	cx,7fffh
	call	 FAR PTR _binmmv
	pop	di
	pop	si
	pop	cx
	pop	ax
	ret
_savebin	endp

_binmmv	proc	far
	push	ds
	push	es
	push	es
	mov	al,Swap_Bin
	call	 _index2bin
	pop	ds
	mov	di,2
	mov	si,di
	rep	movsw
	pop	es
	pop	ds
	ret
_binmmv	endp

; Set up OTHER BIN with information from our original bin
_bin3set	proc	far
	mov	cx,3fh			; Just move the header
	call	 _binmmv
	push	es
	mov	al,Swap_Bin
	call	 _index2bin
	xor	ax,ax
	mov	es:Current_Event,ax	;Current event = 0
	inc	ax
	mov	es:Next_Avail_Num,ax	;Next avail event = 1
	pop	es
	call	 _help_pos
	ret
_bin3set	endp


; CONVERT ASCII DIGIT STRING INTO 16 BIT NUMBER
;ENTER: BX points to buffer containing a 3 byte ascii number
;Exit:	decimal value in reg A		Z=1 if number = 0
;	DX has binary total
;	BX is used, CX is saved
_cnv2b_ES	proc	far
	push	ds
	push	es
	pop	ds
	jmps	cnv2b
_cnv2b_ES	endp

_convert2bin	proc	far
	push	ds

cnv2b:	push	cx
	push	si
	mov	si,bx
	xor	dx,dx
d16lp:	lodsb
	sub	al,30h
	jl	d16x
	cmp	al,9
	jg	d16x
	cbw
	push	ax
	mov	ax,dx
	MULTIPLY_BY 10, AX
	pop	dx
	add	dx,ax
	jmps	d16lp

d16x:	mov	bx,si
	mov	ax,dx			; Low bite to A
	or	ax,ax
	pop	si
	pop	cx
	pop	ds
	ret

_convert2bin	endp

; Enter: BX->start of string
; Exit:  AX = DX = Binary number
;	 CL = PLUS_ASCII or MINUS_ASCII
_atoi	proc	far

	push	si
	mov	si,bx
	xor	dx,dx
	mov	cl,[si]
	inc	si
	cmp	cl,PLUS_ASCII
	jz	atoilp
	cmp	cl,MINUS_ASCII
	jz	atoilp
	dec	si
	mov	cl,PLUS_ASCII
atoilp:	lodsb
	sub	al,30h
	jl	atoix
	cmp	al,9
	jg	atoix
	cbw
	push	ax
	mov	ax,dx
	MULTIPLY_BY 10, AX
	pop	dx
	add	dx,ax
	jmps	atoilp

atoix:	mov	bx,si
	mov	ax,dx			; Low bite to A
	or	ax,ax
	pop	si
	ret

_atoi	endp

; Decimal Ascii ###.## to long integer (###.## * 100)
; Enter: BX->start of string
; Exit:  AX:DX Long number
;	 CL = PLUS_ASCII or MINUS_ASCII
_dltoi	proc	far
	push	cx

	xor	dx,dx
	mov	cl,[bx]
	inc	bx
	cmp	cl,PLUS_ASCII
	jz	dltoilp
	cmp	cl,MINUS_ASCII
	jz	dltoilp
	dec	bx
	mov	cl,PLUS_ASCII

dltoilp:
	call	 _convert2bin		; Get digits before "."
	xor	dx,dx
	mov	cx,100
	mul	cx
	cmp	byte ptr [bx-1],'.'	; Decimal too?
	jnz	dltoix

	push	dx			; Save 32 bit result
	push	ax
	call	 _convert2bin
	xor	dx,dx
	pop	cx
	add	ax,cx
	pop	cx
	adc	dx,cx

dltoix:	or	ax,dx			; Return Z=1 if result = 0
	pop	cx
	ret

_dltoi	endp


_convert2hex	proc	far
	push	ds

cnv2h:	push	cx
	push	si
	mov	si,bx
	xor	dx,dx
h16lp:	lodsb
	cmp	al,'A'		; Check for A-F
	jb	h16lp1
	sub	al,'A'
	add	al,10
	cmp	al,15
	jmp	h16lp2

h16lp1:	sub	al,30h
	jl	h16x
	cmp	al,9
h16lp2:	jg	h16x
	cbw
	push	ax
	mov	ax,dx
	MULTIPLY_BY 16, AX
	pop	dx
	add	dx,ax
	jmps	h16lp

h16x:	mov	bx,si
	mov	ax,dx			; Low bite to A
	or	ax,ax
	pop	si
	pop	cx
	pop	ds
	ret

_convert2hex	endp

;================================================================
_make_hexword	proc	far
	mov	al,bl		; Send low order first
	call	 FAR PTR _make_hexbyte
	mov	al,bh
	call	 FAR PTR _make_hexbyte
	ret
_make_hexword	endp

_make_hexbyte	proc	far
	push	ax
	ror	al,1
	ror	al,1
	ror	al,1
	ror	al,1
	call	make_hexnib
	pop	ax
	call	make_hexnib
	ret
_make_hexbyte	endp

make_hexnib:
	and	al,0fh
	cmp	al,10
	jnc	make_hexnib1
	add	al,'0'
	call	 FAR PTR _add_store
	ret
make_hexnib1:
	add	al,'A'-10
	call	 FAR PTR _add_store
	ret


;----------------------------------------------------------------
;Calculate current event's duration
_calc_curdur	proc	far
	mov	dx,Current_Event_Adr
_calc_curdur	endp
_calc_cdx	proc	far
	add	dx,offset ZeroBase.rin_lofst		; Index to record in
_calc_cdx	endp

; DX points to R_Tc.tcIN position
_calc_evdur	proc	far
	push	bx
	mov	bx,dx			; BX points to R_Tc.tcIN
	mov	dx,offset Sttime	; Put to Sttime
	call	 _mmv3_es2ds
	add	bx,3			; Point to next ES:BX TC val
	mov	dx,offset Entime	; Put to Entime
	call	 _mmv3_es2ds
	add	bx,3			; Point to next ES:BX TC val
	push	bx			; Save r duration position
	call	 _timdif			; Get the duration
	pop	dx			; Restore r duration position
	call	 FAR PTR _mmv3_ds2es	; Put the duration there
	pop	bx			; Restore BX
	ret
_calc_evdur	endp

;Compare ES:BX to ES:DX
_cmp24b_ESES	proc	far
	push	si
	mov	si,dx
	mov	al,es:2[bx]
	cmp	al,es:2[si]
	jnz	c24bEEx
	mov	ax,es:[bx]
	cmp	ax,es:[si]
	jnz	c24bEEx
	xor	al,al
c24bEEx:pop	si
	ret
_cmp24b_ESES	endp


_find_mode	proc	far
	mov	al,Mode_Flag
_find_mode	endp
_modfndr	proc	far
	push	ax			; Save mode byte in AL
	call	 _E_mod_l			; Get length of mode string
	cbw
	mov	cx,ax			; Save it to CX
	inc	cx			; Add in bit map byte
	pop	ax			; Restore mode byte

	mov	bx,es:Mode_Pntr		; Get pointer from descriptor
	mov	bx,[bx]			; Get pointer to table
modfnd1:cmp	byte ptr [bx],0ffh	; End of table?
	jz	modfnde
	cmp	al,[bx]			; Check for matching mode
	jz	modfndx
	add	bx,cx
	jmp	modfnd1
modfndx:inc	bx
	ret

modfnde:mov	bx,offset Badmode_Fill
	ret
_modfndr	endp

;================================================================
;returns with machine number 0 - maxdevices, in AL
; NZ if not found
_all_machine_keys	proc	far
	mov	ch,0
	cmp	ax,offset Rm_xcmd
	jz	mkeyx
_all_machine_keys	endp

_machine_keys	proc	far
	mov	ch,1
	cmp	ax,offset Am_xcmd
	jz	mkeyx
	inc	ch

	if  ALLOWED_VTRS GT 2
	cmp	ax,offset Bm_xcmd
	jz	mkeyx
	inc	ch
	endif
	if  ALLOWED_VTRS GT 3
	cmp	ax,offset Cm_xcmd
	jz	mkeyx
	inc	ch
	endif
	if  ALLOWED_VTRS GT 4
	cmp	ax,offset Dm_xcmd
	jz	mkeyx
	inc	ch
	endif
	if  ALLOWED_VTRS GT 5
	cmp	ax,offset Em_xcmd
	jz	mkeyx
	inc	ch
	endif
	if  ALLOWED_VTRS GT 6
	cmp	ax,offset Fm_xcmd
	jz	mkeyx
	inc	ch
	endif
	cmp	ax,offset Au_xcmd
	jz	mkeyx
	inc	ch
	cmp	ax,offset Bl_xcmd
	jz	mkeyx
	ret
mkeyx:	mov	al,ch
	ret
_machine_keys	endp

_set_trim_keys	proc	far
	cmp	ax,offset Inrtn_xcmd
	jz	stkeyx
	cmp	ax,offset Outrt_xcmd
	jz	stkeyx
	cmp	ax,offset Durrt_xcmd
	jz	stkeyx
	cmp	ax,offset Trimin_xcmd
	jz	stkeyx
	cmp	ax,offset Trimout_xcmd
	jz	stkeyx
	cmp	ax,offset Const_xcmd
	jz	stkeyx
	cmp	ax,offset Tccalc_xcmd
	jz	stkeyx
	cmp	ax,offset Progspeed_xcmd
	jz	stkeyx
stkeyx:	ret

_set_trim_keys	endp



;display the Name of the machine
;enter with value of device in AL, Exit with a successful print
;and return with the original value in a
_machine_disp	proc	far
	push	ax
	mov	bx,offset Machine_Lables
	or	al,al			; Rec
	jz	mach_disp1
	inc	bx
	dec	al			; A
	jz	mach_disp1

	if  ALLOWED_VTRS GT 2
	inc	bx
	dec	al			; B
	jz	mach_disp1
	endif
	if  ALLOWED_VTRS GT 3
	inc	bx
	dec	al			; C
	jz	mach_disp1
	endif
	if  ALLOWED_VTRS GT 4
	inc	bx
	dec	al			; D
	jz	mach_disp1
	endif
	if  ALLOWED_VTRS GT 5
	inc	bx
	dec	al			; E
	jz	mach_disp1
	endif
	if  ALLOWED_VTRS GT 6
	inc	bx
	dec	al			; F
	jz	mach_disp1
	endif
	mov	bx,offset Auxmmsg
	dec	al			; Aux
	jz	mach_disp2
	mov	bx,offset Blkmmsg
	dec	al			; Blk
	jnz	machdx
mach_disp2:
	call	 _comsg
	jmps	machdx

mach_disp1:
	mov	al,[bx]
	call	 _ConOut
	mov	bx,offset Vt_Msg
	call	 _comsg
machdx:	pop	ax
	ret
_machine_disp	endp

_check_setkeys	proc	far
	cmp	ax,offset Trimin_xcmd
	jz	cskx
	cmp	ax,offset Trimout_xcmd
	jz	cskx
	cmp	ax,offset Const_xcmd
	jz	cskx
	cmp	ax,offset Inrtn_xcmd
	jz	cskx
	cmp	ax,offset Outrt_xcmd
	jz	cskx
	cmp	ax,offset Durrt_xcmd
	jz	cskx
	cmp	ax,offset Markin_xcmd
	jz	cskx
	cmp	ax,offset Markout_xcmd
cskx:	ret

_check_setkeys	endp


_Bin_Hdr	proc	far
	push	cx
	mov	bl,cl
	mov	ax,edl_lines
	mov	cx,(line_length / 2) + 4; +4 for then header
	mul	cx
	mov	cx,ax			; # of words to clear
	mov	ax,0			; Use AX=0
	mov	di,ax			; DI points to bottom of segment
	rep stosw
	mov	es:byte ptr EDL_Bin,bl	; Set bin number
	mov	es:Max_Lines,edl_lines	; Save # of allowed lines
	mov	ax,1
	mov	es:Next_Avail_Num,ax
	mov	es:Next_Edit,ax
	mov	Default_Mode,0		; Offset to top of Edl_Formats
	mov	es:Mode_Pntr,offset Edl_Formats
	mov	bx,offset Title_EDLev	; Set up default file title
	mov	ch,[bx]
	inc	ch
	inc	bx
	mov	dx,offset File_Title
	call	 _title_loop_ES
	mov	es:word ptr [bx - 1],0a0dh
	mov	es:byte ptr [bx + 1],0
	pop	cx
	ret
_Bin_Hdr	endp


;================================================================
; Security
;================================================================
_get_lpt_ports	proc	far
		push	es
		push	ds			;save data segment
		push	ds
		pop	es
		mov	ax,40h			; Set to base segment
		mov	ds,ax
		mov	si,8			;LPT1 ROM BIOS location
		mov	cx,3			;3 Parallel ports
		mov	di,offset Port		;Port is an array of words
		rep	movsw			;move the Port addresses in
		pop	ds			;restore data segment
		pop	es
		ret
_get_lpt_ports	endp

_SaveWorkspace	proc	far
	push	es
	push	si
	push	di
	push	cx
	push	ds
	pop	es
	mov	si,offset Exchbuf1	;Init the Exchange area
	mov	di,offset Undo_Buffer
	mov	cx,offset Exchlen
	rep movsb
	pop	cx
	pop	di
	pop	si
	pop	es
	ret
_SaveWorkspace	endp

_RestoreWorkspace	proc	far
	push	es
	push	si
	push	di
	push	cx
	push	ds
	pop	es
	mov	si,offset Undo_Buffer
	mov	di,offset Exchbuf1	;Init the Exchange area
	mov	cx,offset Exchlen
	rep movsb
	pop	cx
	pop	di
	pop	si
	pop	es
	ret
_RestoreWorkspace	endp


;================================================================
;Enter: DX contains number
;	BX contains address to where to put it
_dec1000_pad	proc	far
	mov	Temp_Tc_Buf,bx
	xchg	bx,dx
	cmp	bx,1000
	jnc	_make_dec
	call	 FAR PTR _stor02b
	jmps	_decpad0
_dec1000_pad	endp

_decimal_pad	proc	far
	mov	Temp_Tc_Buf,bx		; Save address pointer
	xchg	bx,dx			; DX has number, put to BX
_decimal_pad	endp
_decpad0	proc	far
	cmp	bx,100			; Three Spaces required?
	jnc	_make_dec
	call	 FAR PTR _stor02b	; If BX<100, at least one space
_decpad0	endp
_decpadt	proc	far
	cmp	bx,10
	jnc	_make_dec
	call	 FAR PTR _stor02b	; If BX<10, another space
_decpadt	endp

;enter with BX=decimal number to make ascii
; Temp_Tc_Buf has destination address
_make_dec	proc	far
	push	bx			; Save everybody
	push	dx
	push	cx
	mov	cx,0fff6h		; Conversion radix
	mov	dx,0ffffh
_make_declp:
	inc	dx
	add	bx,cx
	jc	_make_declp
	add	bx,10
	xchg	bx,dx
	or	bx,bx
	jz	JL1140
	call	 _make_dec	; This is recursive
JL1140:	mov	al,dl
	add	al,'0'
	mov	bx,Temp_Tc_Buf
	mov	[bx],al
	inc	Temp_Tc_Buf
	pop	cx
	pop	dx
	pop	bx
	mov	bx,Temp_Tc_Buf
	ret
_make_dec	endp

; Same as _itoa, except:
;	value is 32 bit number DX:AX
;	string is returned with two decimal places
_itoa100	proc	far
	push	bx
	push	ax
	push	dx
	push	cx
	mov	cx,100
	div	cx			; AX = quotient, DX = remainder
	call	 FAR PTR _itoado
	mov	byte ptr [bx],'.'
	inc	bx
	mov	ax,dx
	call	 FAR PTR _itoado
	cmp	dx,10
	jae	itl10
	mov	byte ptr [bx],'0'
	inc	bx
itl10:	mov	byte ptr [bx],0
	pop	cx
	pop	dx
	pop	ax
	pop	bx
	ret
_itoa100	endp

; Enter: AX=decimal number
; 	 BX -> ASCII buffer
; Exit:	 BX -> ASCII buffer
;
_itoa	proc	far
	push	bx
	call	 FAR PTR _itoado
	mov	byte ptr [bx],0
	pop	bx
	ret
_itoa	endp
 
_itoado	proc	far
	push	ax			; Save everybody
	push	dx
	push	cx
	mov	cx,0fff6h		; Conversion radix
	mov	dx,0ffffh
_itoalp:inc	dx
	add	ax,cx
	jc	_itoalp
	add	ax,10
	xchg	ax,dx
	or	ax,ax
	jz	JL1140a
	call	 _itoado	; This is recursive
JL1140a:mov	[bx],dl
	add	byte ptr [bx],'0'
	inc	bx
	pop	cx
	pop	dx
	pop	ax
	ret
_itoado	endp


; Store a '0' to Memory at [Temp_Tc_Buf]
_stor02b	proc	far
	mov	al,'0'
_stor02b	endp

;place an ascii character to Memory, and increment pointer
;at temp_tc_adr
_add_store	proc	far
	push	bx
	mov	bx,Temp_Tc_Buf
	mov	[bx],al
	inc	bx
	mov	Temp_Tc_Buf,bx
	pop	bx
	ret
_add_store	endp


; Find the number of extra elements, notes, GPI, SLV, etc.
; and store that number at Extras
; If Evnt_Replace_Flag is ON (0ffh) then stop short of comments
_notate_Extras	proc	far
	push	ax
	mov	Extras,0		; Clear out Extras counter
	FLAGBITS dblline_Fmask
	jz	notexl
	inc	ax
notexl:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jae	notex1
	call	 _index_storage
	jnc	notex1
	cmp	Evnt_Replace_Flag,0ffh	; Stopping at comments?
	jnz	notexok
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_BASE
	jc	notex1
notexok:inc	Extras
	jmp	notexl
notex1:	pop	ax
	call	 _index_storage
	ret
_notate_Extras	endp


;================================================================
_check_mode	proc	far
	mov	al,Mode_Flag		; Get our mode Flag
	test	al,video_Emode		; Video present?
	jz	chkmodx			; Error, no video
chkmod1:push	ax
	and	al,audall_Emode		; Check for any audio channels
	or	al,al
	pop	ax
	jz	chkmodx
	ret
chkmodx:call	 _emclear		; Clear any VTR edit messages
	jmp	_split_without		; Goes back to Keyboard
_check_mode	endp

;----------------------------------------------------------------
; Match reels for BOTH lines of either a one or two line edit
; Exit	C=1 if no match on either of the lines
_match4recall	proc	far
	call	 FAR PTR _match_reels		; Check for a reel match
	jnz	m4rclf			; Return if not found
	mov	bx,Current_Event_Adr	; Check for second line reel match
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	mvrclt			; Return successfull if no dbl line

	mov	ax,es:Current_Event	; Save the first line
	push	ax
	inc	ax			; Get next line
	call	 _index_storage		;  of double line
	call	 FAR PTR _match_reels		; Look for reel
	pop	ax			; Restore original line
	pushf
	call	 _index_storage
	popf
	jz	mvrclt			; Ok if found
m4rclf:	stc
	ret
mvrclt:	clc
	ret
_match4recall	endp

;----------------------------------------------------------------
; Match reels for BOTH lines of either a one or two line edit
; Exit	C=1 if no match on either of the lines
_matchforcedrecall	proc	far
	;Return with Z set (Z=1) if match, and CL = machine of match
	call	 FAR PTR _match_reels		; Check for a reel match
	jz	mfdr1

;................
	;; Check for A or B mode
	cmp	Assembly_Mode,'A'	; Error if A mode
	jz	mframode
	stc
	ret
mframode:
;................

	mov	ax,es:Current_Event	; Save the first line
	call	 _evnt_dispthis

	mov	bx,Current_Event_Adr	; Check for second line exists
	FLAGBITS dblline_Fmask
	mov	bx,offset newreel_ovr
	jz	mfdr0
	mov	bx,offset newreelfirst_ovr
mfdr0:	mov	Reelrecallvtr,0		; (no prev VTR choice)
	call	 FAR PTR _MoveReel_EDLtoMtbl	; Request new machine
	jc	mfdrer			; Return on ESCape

	mov	bx,Current_Event_Adr	; Check for second line reel match
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	mfdr1
	call	 FAR PTR _ContinueAutoAsm
	jmp	mfdrok			; Return successfull if no dbl line

mfdr1:	mov	bx,Current_Event_Adr	; Check for second line reel match
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	mfdrok			; Return successfull if no dbl line

	call	 _evnt_dispthis

	mov	al,Current_Source
	mov	Reelrecallvtr,al	; Prev VTR choice for "FROM" vtr

	mov	ax,es:Current_Event	; Save the first line
	push	ax
	inc	ax			; Get next line
	call	 _index_storage		;  of double line
	call	 FAR PTR _match_reels		; Look for reel
	pop	ax
	clc
	jz	mfdr2
	push	ax
	mov	bx,offset newreelsecond_ovr
	call	 FAR PTR _MoveReel_EDLtoMtbl	; Request new machine
	pop	ax
	jc	mfdr2
	call	 FAR PTR _ContinueAutoAsm
mfdr2:	pushf
	call	 _index_storage
	popf
	jnc	mfdrok		; Ok if found
mfdrer:	stc
	ret
mfdrok:	clc
	ret
_matchforcedrecall	endp

; Notify user that reel was not found.  Request new VTR
;  If VTR specified, copy reel Name to VTR
;  If ESCAPE, return with C=1
_MoveReel_EDLtoMtbl	proc	far
	mov	Reelrecallmsgptr,bx
	mov	al,Current_Source
	cmp	al,Reelrecallvtr
	jnz	mretm0
	inc	al
	cmp	al,MAX_DEVICES
	jbe	mretm0
	mov	al,1
mretm0:	call	Machine_Take_Far
mretm1:	call	 _kbd_cln
	norm_VIDEO FALSE,FALSE
	mov	bx,Reelrecallmsgptr
	call	 _msgread
	mov	al,Current_Source
	call	 _machine_disp
	call	 _chimes
	call	rdchar_FAR
	cmp	ax,offset Enter_xcmd
	jz	mretok
	call	 _Break_check		; Exit if Break
	jz	mretm2
	call	 _machine_keys
	call	Machine_Take_Far
	jmp	mretm1
mretok:	call	 _getlast_reel		; ES:BX -> EDL reel
	mov	dx,Current_Reel_Adr
	mov	ch,reel_length
	call	 _mmv_ESDS
	call	 _upd_getrel
	call	 _kbd_cln
	clc
	ret
mretm2:	call	 _kbd_cln
	stc
	ret
_MoveReel_EDLtoMtbl	endp

_ContinueAutoAsm	proc	far
	mov	al,Current_Source
	call	Machine_Take_Far
caalp:	call	 _chimes
	call	 _kbd_cln
	norm_VIDEO FALSE,FALSE
	mov	bx,offset asmcontinue_ovr
	call	 _msgread
	call	rdchar_FAR
	call	 _kbd_cln
	call	 _Break_check		; Exit if Break
	stc
	jz	caax
	cmp	ax,offset Enter_xcmd
	jnz	caalp
	clc
caax:	ret
_ContinueAutoAsm	endp

; See if there is a match for the reel of the current source
_match_thisreel	proc	far
	call	 _getlast_reel
	mov	dx,Current_Reel_Adr
	mov	ch,reel_length
	call	 _cmpchr			; Compare ES:reel, DS:reel
	mov	cl,Current_Source
	ret
_match_thisreel	endp

;Look for the reel match
;Return with Z set (Z=1) if match, and CL = machine of match
_match_reels	proc	far
	call	 _getlast_reel		; BX = reel number address (EDL)
	mov	dx,offset A_Reel_Num	; A machine reel number
	mov	cl,1			; Init machine number
	jmp	mtrl1
_match_reels	endp

; Look for RECORD reel match, too.
_match_master	proc	far
	mov	dx,offset R_Reel_Num	; A machine reel number
	mov	cl,0			; Init machine number
mtrl1:	mov	ch,reel_length		; # of chars to match
rlklp:	call	 _cmpchr			; Compare the characters
	jz	rlkret
	inc	cl
	cmp	cl,MAX_DEVICES + 1
	jz	rlkx
	add	dx,reel_length + 1
	jmp	rlklp

rlkx:	xor	al,al			; Reel not found
	dec	al			; Clear Z Flag, set carry
rlkret:
	pushf
	call	 _getlast_ptcd		; Get source FCM
	mov	al,es:[bx]
	mov	MatchingTC_Fcm,al
	popf
	ret
_match_master	endp



_Clear_WorkEvent	proc	far
	push	bx
	push	cx
	mov	bx,offset Work_Event
	mov	cx,line_length
CWElp:	mov	[bx],ch			; Zero out byte using CH
	inc	bx
	loop	CWElp
	pop	cx
	pop	bx
	ret
_Clear_WorkEvent	endp

;================================================================
; Clear out the EDL
_clear_list	proc	far
	call	 _savebin			; Protect the bin to BIN3
	mov	ax,es:Max_Lines
	mov	cx,(line_length / 2)
	mul	cx
	mov	cx,ax
	xor	ax,ax
	mov	di,offset Event_Storage
	push	ds
	push	es
	pop	ds
	cld
	rep stosw
	pop	ds
	mov	es:Current_Event,cx	;Current event = 0
	inc	cx
	mov	es:Next_Avail_Num,cx	;Next avail event = 1
	mov	es:Next_Edit,cx		;Next edit = 0
	call	 _help_pos		; Clear the screen list
	call	 _EDstats
	ret
_clear_list	endp

;================================================================
; Date: 7-06-1990
; Check for an existing reel assignments for this type of edit
_Check4reel	proc	far
	push	ax
	push	bx
	push	cx
	cmp	Trans_Type,'C'
	jz	crl_cut
	cmp	Trans_Type,'S'
	jz	crl_cut
	cmp	Trans_Type,'K'
	jz	crl_key

	mov	al,From_Machine		; Check for FROM machine reel
	call	ck4reel
	mov	al,To_Machine		; Check for TO machine reel
	call	ck4reel
	jmp	ck4rlx

crl_cut:mov	al,Current_Source
	call	ck4reel
	jmp	ck4rlx
crl_key:mov	al,Keyfor_Src
	call	ck4reel
	mov	al,Keybkgnd_Src
	call	ck4reel
ck4rlx:	pop	cx
	pop	bx
	pop	ax
	ret
_Check4reel	endp

ck4reel	proc	near
	cbw
	mov	cl,reel_length + 1	; Reel length + terminating null
	mul	cl			; Index to correct reel assignment
	lea	bx,Reel_Assignments
	add	bx,ax
	mov	ch,reel_length
	call	 _advance
	or	ch,ch
	jnz	ck4rlok
	ERROR	NoReelAssigned, ERET_Keyboard
ck4rlok:ret
ck4reel	endp

;----------------------------------------------------
;	       M A K E	 E V E N T
;
;Makes a complete event at the the Work_Event buffer,
;except for the event number which depends upon
;whether the event is added/inserted or replaced
;----------------------------------------------------
; ENTER: BX = start address of work line
; Exit: BX = start address of work line
_make_event	proc	far

	mov	al,Current_Source	; Save current source
	call	 FAR PTR _SaveVtrInEditTable	;  to VTRS-IN-EDIT table

	push	es			; Save original extra segment
	push	ds			;  and make
	pop	es			;  ES=DS

	xor	ax,ax			; Clear out line
	mov	cx,(line_length / 2)
	mov	di,bx
	cld
	rep stosw

	mov	si,Current_Reel_Adr	;1. Put reel number in
	mov	di,bx
	add	di,offset ZeroBase.reel_lofst
	mov	cx,reel_length
	cld
	rep movsb
	mov	al,Mode_Flag		;2. Put audio/video mode in
	mov	[bx].mode_lofst,al
	mov	al,Trans_Type		;3. Put transition type in,
	mov	[bx].type_lofst,al

; Zero out efxnum and exfdur
	xor	ax,ax
	mov	[bx].efxnum_lofst,ax
	mov	[bx].efxdur_lofst,ax

	mov	al,Current_Source		;4. Put in Time Code Formats
	cbw
	MULTIPLY_BY Vtrcb_length, AX
	mov	si,ax

	mov	ax,[si + (offset Vtrcb.Vtrcb_CF)]
	and	ax, cfbits_Fmask	; Mask out lower three bits
	or	[bx].Flags_lofst, ax

	mov	al,[si + (offset Vtrcb.Vtrcb_FCM)]
	cmp	al,DF_CHAR
	jz	mkevfcm
	mov	al,NDF_CHAR
mkevfcm:mov	[bx].ptcd_lofst,al
	mov	al,Rtcf
	mov	[bx].rtcd_lofst,al

	mov	di,bx			;5. Put the INs and OUTs in the event
	add	di,offset ZeroBase.pin_lofst
	mov	si,Current_Inbuf
	cld
	movsw
	movsb
	mov	si,Current_Outbuf
	movsw
	movsb
	mov	si,offset R_Tc.tcIN
	movsw
	movsb
	mov	si,offset R_Tc.tcOUT
	movsw
	movsb
	mov	si,offset R_Tc.tcDUR
	movsw
	movsb

; If motion control
	push	bx
	mov	al,Current_Source	; Get current source
	cmp	al,MAX_DEVICES - 1	; Is it less than BLACK and AUX?
	ja	mkevnpm
	dec	al			; Adjust for no R-VT in table
	cbw				; Make word
	mov	bx,offset Tags_Table	; BX = top of table
	add	bx,ax			; BX + (AX*3) = offset
	add	bx,ax
	add	bx,ax
	xor	ax,ax			; Check for null time code
	or	al,[bx]
	or	ax,1[bx]
	jz	mkevnpm

	cmp	si,Current_Outbuf	; Is it the same as the stated out?
	mov	al,2[bx]
	cmp	al,2[si]
	jnz	c24bm
	mov	ax,[bx]
	cmp	ax,[si]
	jnz	c24bm
	xor	al,al
c24bm:	jz	mkevnpm
	mov	si,bx
	movsw
	movsb
mkevnpm:pop	bx

	mov	dx,es:Next_Edit		; Use Next_Edit number, for now
	mov	[bx],dx			;  to store edit number
	mov	byte ptr [bx].cmnt_lofst,Editline_EDIT ; Mark as an edit
	pop	es			; Restore edit pointer
	ret

_make_event	endp


;================================================================
;make room for a daddy in the middle
;Insert at current event, moving everything down one
_make_room	proc	far
	mov	ax,es:Current_Event	; Insert event at this number
	push	ax
	push	cx
	push	dx
	push	si
	push	di

	mov	bx,offset Next_Avail_Num
	mov	cx,es:[bx]		; Get # of events to move
	sub	cx,ax			; (NEXT_AVAIL - CURRENT)
	mov	ax,es:[bx]		; Index over to last event
	inc	word ptr es:[bx]	; Increment # of events in list
	jcxz	mkrmxt
	call	 _index_storage		; Get address of destination
	mov	di,bx
	mov	dx,line_length		; Used througout

	push	ds			; Move within
	push	es			;  EDL segment
	pop	ds
mkrmlp:	mov	si,di
	sub	si,dx			; Subtract offset for source
	push	cx
	mov	cx,dx
	cld
	rep movsb
	pop	cx
	sub	di,dx
	sub	di,dx
	loop	mkrmlp
	pop	ds

mkrmxt:	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	ax
	call	 _index_storage
	ret
_make_room	endp


;----------------------------------------------------------------
;    D E L E T E   A N	 E D I T   F R O M   T H E   E D L
;----------------------------------------------------------------
;Delete event #Current_Event, and pull up the list.
;Exit: BX = Current_Event_Adr
; AX, BX, DI, SI are used
_delete	proc	far
	mov	ax,es:Next_Avail_Num	; See if there
	dec	ax			;  are any events
	jz	deletex			;  to delete...
	push	cx
	push	dx
	mov	ax,es:Current_Event
	mov	cx,ax			; Save the current event
	call	 _index_storage		; Index to event to be deleted
	mov	ax,es:Next_Avail_Num	; Last event - this event =
	sub	ax,cx			;  number of events to move
	mov	cx,line_length / 2	; Number of words to move =
	mul	cx			;  (# events * event length) / 2
	mov	cx,ax
	mov	di,bx			; DI = destination
	add	bx,line_length		; add offset to source
	mov	si,bx
	push	ds
	push	es
	pop	ds
	cld
	repnz	movsw
	mov	ax,cx			; AX=0
	mov	cx,line_length		; Length of line
	sub	di,cx			; Move DI to point to next avail
	rep	stosb			; Null out the last line
	pop	ds
	pop	dx
	pop	cx
	mov	bx,offset Next_Avail_Num
	dec	word ptr es:[bx]
	mov	ax,es:Current_Event
	cmp	ax,es:[bx]
	jc	deletex
	dec	ax
	call	 _index_storage
	ret

deletex:mov	bx,Current_Event_Adr
	ret

_delete	endp


;================================================================
; Position EDL pointer to the first line of an event,
;  going backwards over COMMENTS, GPIs, SLAVEs, etc.
; ENTER: AX = current event
; Exit:	AX = event
;	C=0 if first line of event
;	C=1 if no list or edits present other than comments
_line_first	proc	far
	call	 _index_storage
	jnc	lfrstc			; OK if this is an edit line
	dec	ax			; Go to previous line
	jnz	_line_first
lfrstt:	inc	ax
	call	 _index_storage
	stc
lfrstr:	ret

; Now check for double line. IF TRUE, go back one more
lfrstc:	dec	ax
	jz	lfrstt			; Top of EDL?
	call	 _index_storage
	jc	lfrstf			; Go forward if a comment
	FLAGBITS dblline_Fmask		; Double line?
	jz	lfrstf
	ret
lfrstf:	inc	ax
	call	 _index_storage
	ret
_line_first	endp

; Index to next line.  return C=1 if none left
_line_next	proc	far
	mov	ax,es:Current_Event
lnxtlp:	inc	ax
	cmp	ax,es:Max_Lines
	ja	lnxtx
	call	 _index_storage
	jc	lnxtlp
	FLAGBITS dblline_Fmask
	jnz	lnxtlp
	clc
	ret
lnxtx:	stc
	ret
_line_next	endp


;================================================================
; Advance to next edit, skip all other types of edl lines & dbl line
; Exit	AX = next valid edit line number
;	Z  = 1 if end of list
_advance2next	proc	far
	push	bx			; Save BX register
	mov	ax,es:Current_Event	; Get the current line
	call	 _index_storage
	jc	adv2l1			; Skip if comment
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	adv2l1
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jz	adv2lx
	jmp	adv2l1
_advance2next	endp

; Advance to next line, skipping all other types of edl lines
; Exit	AX = current event #
;	Z  = 1 if end of list
_advance2line	proc	far
	push	bx			; Save BX register
	mov	ax,es:Current_Event	; Get the current line
adv2l1:	inc	ax			; Go to next event
	cmp	ax,es:Next_Avail_Num
	jz	adv2lx
	call	 _index_storage
	jc	adv2l1
	or	ax,ax			; Ret NZ if ok
adv2lx:	pop	bx
	ret
_advance2line	endp

; Are there any more edits in the list after this one?
; Carry = 1 if NOT last edit
checklast_edit:
	mov	ax,es:Current_Event
	push	ax
clp_1:	call	 _index_storage		; Index to current event
	jc	clp_3			; Check next line if NOTE
	FLAGBITS dblline_Fmask		; If double line,
	jz	clp_3			;  point past
	inc	ax			;  first line
clp_3:	inc	ax			; Go to next line
	cmp	ax,es:Next_Avail_Num	; Carry set if in bounds
	pop	ax
	pushf
	call	 _index_storage
	popf
	ret

; Carry = 1 if there are more edits in the list
; Carry = 0 if there are no edits in list
; Comments are not counted as edits for this purpose
_Check4MoreEvents	proc	far
	mov	ax,es:Current_Event
	push	ax
	call	index2next		; Jump if there are
	jnc	cme_2			;  no more edits in list
cme_1:	call	 _index_storage
	jnc	cme_3
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jc	cme_1
cme_2:	pop	ax			; Return showing NO more
	call	 _index_storage		;  edit in the EDL
	clc
	ret
cme_3:	pop	ax			; Return showing that there
	call	 _index_storage		;  ARE more edits in the EDL
	stc
	ret
_Check4MoreEvents	endp

; Index to the next edit line in the EDL
; AX = place to start from
; Return C=0 if NO more edits
index2next:
	cmp	ax,es:Next_Avail_Num
	jnc	outoflist
	call	 _index_storage		; Index to line
	FLAGBITS dblline_Fmask		; Double line?
	jz	inlist
	inc	ax
inlist:	inc	ax
	stc
	ret
outoflist:
	clc
	ret

;================================================================
; Save any slaves involved in edit
_SaveSlavesToEditTable	proc	far
	mov	si,offset Vtrs_In_Edit_Table
	test	Slave_Flags,Enabled_MSBIT	; Check for slaves active
	jz	sie_clr			; Skip if NOT
	mov	bx,offset Slave_Table
sie_1:	mov	al,[bx]			; Get byte from Slave_Table
	mov	[si],al			; Save it to Vtrs_In_Edit_Table
	inc	bx			; Increment to
	inc	si			;  next bytes
	cmp	al,0ffh			; End of table?
	jnz	sie_1			;  Continue if not
sie_xit:ret
sie_clr:mov	byte ptr [si],0ffh
	ret

_SaveSlavesToEditTable	endp

;================================================================
; Save VTR in Vtrs_In_Edit_Table, terminate table with 0ffh
; ENTER: AL = VTR
_SaveVtrInEditTable	proc	far
	push	ax
	push	si
	mov	si,offset Vtrs_In_Edit_Table - 1
	mov	ah,0ffh
vie_1:	inc	si
	cmp	[si],ah		; Find end of the existing table
	jnz	vie_1
	mov	[si],ax		; Save VTR and terminator
	pop	si
	pop	ax
	ret
_SaveVtrInEditTable	endp

;Check for presence of machine in AL in the Vtrs_In_Edit_Table
; Return C=0 if found in table, C=1 if not found
_VTRinEdit_check	proc	far
	push	bx
	mov	bx,offset Vtrs_In_Edit_Table
vec_1:	cmp	byte ptr [bx],0ffh
	jz	vec_nf
	cmp	[bx],al
	jz	vec_f
	inc	bx
	jmp	vec_1
vec_nf:	stc
	pop	bx
	ret
vec_f:	clc
	pop	bx
	ret

_VTRinEdit_check	endp



BSEG	ends

_DATA	segment byte public 'DATA'

string	dw	0
substg	dw	0
sublen	db	0
index	db	0
;;Hdeptr	dw	0

Multable	db	01h,0,0		; 1
		db	0ah,0,0		; 10
		db	064h,0,0	; 100
		db	0e8h,03h,0	; 1,000
		db	10h,27h,0	; 10,000
		db	0a0h,86h,01	; 100,000
		db	40h,42h,0fh	; 1,000,000
		db	80h,96h,98h	; 10,000,000

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends


	end
