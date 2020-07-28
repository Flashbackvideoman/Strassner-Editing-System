; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner

;VMMANAG.ASM
;Edit Decision List management routines
;
include	VM.EQU

%nolist

extrn ERROR_ACTIVE:byte,Cimsgadd_Flag:byte,Copy_Flag:byte
extrn Current_Machine:byte,Current_Source:byte,Edl_Fcm:byte
extrn Evnt_Insert_Flag:byte,Evnt_Replace_Flag:byte,From_Machine:byte
extrn Fullscreen_Flag:byte,Key_Mode:byte,Keybkgnd_Src:byte,Keyfor_Src:byte
extrn Last_Machine:byte,Mode_Flag:byte,Preread_State:byte,Priority_Flag:byte
extrn Reelsum_Inprogress:byte,Reelsum_Lines:byte,Reelsum_TypeFlag:byte
extrn Ripple_Flag:byte,Rtcf:byte,Shift_Flag:byte,Sign_Flag:byte,Sortwhat:byte
extrn Split_Mode:byte,Tag_Flag:byte,To_Machine:byte,Tobin_Flag:byte
extrn Trans_Type:byte,Trim_Ci_Flag:byte,Record_Flag:byte,Assemble_Flag:byte

extrn Edl_Seg:word,MultRec_Flags:word,Ramp_Flags:word, RampSpeedChange:word
extrn Addtc_Buf:word,Anyway_Msg:word,Block_End:word,Block_Start:word
extrn clear_list_ovr:word,Cmt_Prmt:word,commentmsg_ovr:word
extrn copyevnts_ovr:word,Current_BKGbuf:word,Current_FRMbuf:word
extrn Current_TObuf:word,Current_Duration:word,Current_Event:word
extrn Current_Event_Adr:word,Current_Inbuf:word,Current_Outbuf:word
extrn Current_Reel_Adr:word,Cursor:word,delete_ovr:word
extrn delete_qry:word,deleting_ovr:word,delmrkd_ovr:word,dirbuff:word
extrn Edit_Flags:word,EdlSES:word,Edl_Dur:word,Edl_In:word,Edl_Out:word
extrn Ending_Number:word,Entime:word,Ev2ret2:word,Event_Storage:word
extrn Extras:word,File_Title:word,Filename_Ptr:word,Forreel_Msg:word
extrn Frombin_Seg:word,frommsg_ovr:word,Gpi_Flags:word,ins_ovr:word
extrn Key_Trans:word,Last_Recalled:word,Max_Lines:word,Mcrosep:word
extrn Move_Adr:word,movevnts_ovr:word,Mtbl_Length:word,Multrecord_Table:word
extrn Next_Avail_Num:word,Next_Edit:word,Offset_Buffer:word
extrn Operational_Flags:word,Pagend_Msg:word,Pmc_Flags:word,pointer_ovr:word
extrn Progmotion_Tbl:word,R_Tc:word,R_Reel_Num:word
extrn Reelsum_EDLev:word,Reelsum_Header:word,reelsum_ovr:word
extrn Reelsused_Msg:word,replace_ovr:word,ripple_ovr:word,Rvtr_Dur:word
extrn Rvtr_In:word,Rvtr_Out:word,Rvtr_Ripple:word,shift_frmto_ovr:word
extrn shift_ovr:word,Shiftend_Edit:word,shiftinput_rqst:word
extrn shiftplay_rqst:word,shiftrec_rqst:word,Shiftstart_Edit:word
extrn Slave_Flags:word,Slave_Table:word,Sort_Reeladr:word,Sortmatch_In:word
extrn Sortmatch_Out:word,Spd_Flags:word,Split_Delay:word
extrn Split_Pout:word,Split_Rout:word,Starspace_Msg:word,Starting_Number:word
extrn Sttime:word,Tags_Table:word,Temp_Event:word,Temp_Tc_Buf:word
extrn Temp_Wrkspce:word,Time_Start:word,Time_Total:word,tobin_ovr:word
extrn Tobin_Seg:word,toend_ovr:word,tomsg_ovr:word,Trans_Code:word
extrn Trans_Length:word,Vtrcb:word,Vtrs_In_Edit_Table:word,Where2_Number:word
extrn Where_Msg:word,Work_Event:word,Workspace_Flags:word,Orall_Msg:word
extrn MasterEditLineAdr:word

extrn Check_TrimLink:near,ramp_upd:near
extrn Pmc_Upd:near,Preread_UPD:near,Spd_Upd:near,SS_toggle:near
extrn all_locations:near,Areusure:near,cimsg_wrk:near,clear_spdtbl:near
extrn Cut_Dlg:near,dec_cimsg:near,get_range:near,get_ucase:near
extrn gpi_alloff:near,gpi_index:near,Gpi_Upd:near,Idx2tcf:near
extrn kbd_msgread:near,keythru:near,lcrlf:near,listmsg:near,lst_co:near
extrn lst_init:near,Machine_Change:near,Machine_Take:near,no_chos_msg:near
extrn norm_kbd:near,pos_yn_chos:near,rdchar:near,Renumber:near
extrn reset_editspeed:near,screen_init:near,switch:near,switch_bins:near
extrn tc_cimsg:near,Trans_Upd:near,vtr_e2e:near,vtr_inst:near,yn_chos:near

extrn _Check4MoreEvents:far,_Clear_WorkEvent:far,_ConOut:FAR,_DecOut:far
extrn _E1_flgs:far,_EDL2ASCII:far,_EDL_display:far,_ReCompute_CUT:far
extrn _ReCompute_EFX:far,_SaveWorkspace:far,_SaveSlavesToEditTable:far,_Space_Out:far
extrn _VTRinEdit_check:far,_advance2next:far,_advance:FAR,_Break_check:FAR
extrn _check4comment:far,_check4edl:far,_check4reel:far,_check_mode:far
extrn _clean_last:far,_clear_event:far,_clear_list:far,_clear_outs:far
extrn _clear_pdur:far,_clear_pin:far,_clear_pout:far,_clear_rdur:far
extrn _clear_rin:far,_clear_rout:far,_clear_screen:far,_clear_tc:far
extrn _cmp24b:far,_cmp24b_ESDS:far,_cmpchr:far,_cnvt2df:far,_compute:far
extrn _computer:far,_comsg:FAR,_convert2bin:far,_delete:far
extrn _draw_machines:far,_Elaptm_move:far,_elaptm_move_ES:far,_emclear:FAR
extrn _Entime_move:far,_entime_move_ES:far,_error_bell:FAR,_event_display:far
extrn _evnt_dispthis:far,_evnum:far,_find_edit_BX:far,_find_edit_DX:far
extrn _get_dur:far,_get_in:far,_get_out:far,_getlast_Flags:far
extrn _getlast_mode:far,_getlast_pin:far,_getlast_pout:far,_getlast_ptcd:far
extrn _getlast_reel:far,_getlast_rin:far,_getlast_rout:far,_getlast_rtcd:far
extrn _help_pos:FAR,_index2edspeed:FAR,_index_storage:far,_kbd_cln:FAR
extrn _kbd_clr:FAR,_kbd_message:far,_left_set_reel:far,_line_erase:FAR
extrn _line_first:far,_make_dec:far,_make_event:far,_make_room:far
extrn _make_ucase:far,_match4recall:far,_match_master:far,_match_reels:far
extrn _matchforcedrecall:far,_mmv3_ds2es:far,_mmv3_es2ds:far,_mmv3byt:far
extrn _mmv:far,_mmv_ESDS:far,_mode_upd:far,_msgread:far,_notate_Extras:far
extrn _savebin:far,_sort_match:far,_sort_reels:far,_Sttime_move:far
extrn _sttime_move_ES:far,_tc_negate:far,_timadd:far,_timdif:far
extrn _time_upd:far,_time_value:far,_up_out:far,_upd_getrel:far
extrn _upd_getscr:far,_upd_gettcf:far,_working:far,_write2disk:far
extrn Keyboard:far

%list

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

%nolist


Public  clear_workspace, clear_edit_FAR, clear_edit, cle4key, cle4efx, cle4cut
Public  clear_both, clear_one, Reel_Summary, DRS_page, DRS_add, DRS_print
Public  DRS_del, DRS_main, drs_lp, drs_done, drs_don1, drs_don2, ReelSx
Public  Rellsagn, DRS_edl, DRSE_lp, nicx, DRSE_1, DRS_p0, DRS_p1, DRS_p2
Public  DRS_p3, DRS_nxt, DRS_store, DRS_storx, DRS_output, drs_o2, drs_o2b
Public  drs_o2c, drs_o3, drs_o4, DRS_delete, DRS_dlp, DRS_delone, DRS_deldone
Public  DRS_delxit, DRS_dnf, Reel_Summary_Header, RSHttl, RSHttlx, RSHnoedl
Public  RSH_cnt, RSH_cntdone, RSH_nom, markon, markoff, markdc, markd, markx
Public  markset, marksx, replace_event, insert_event, ae_jmp, add_event, ae_0
Public  aev_1, ae_0a, ae_0b, ae_1, ae_3, ae_3a, ae_3b, ae_3c, ae_4, ae_4a
Public  ae_4b, ae_4c, put_cut, put_spl, psp_reg, put_key, pkey_IN, pkey_OUT
Public  pkey_ON, put_efx, adcomp, adcomp1, adcomp2, event2edl, evnt2edl1
Public  e2edl_0, e2edl_1, e2edl_2, e2edl_4, EDL_m1, EDL_m2, EDL_m3, EDL_m3a
Public  EDL_m3b, EDL_m4, EDL_m5, EDL_m8, EDL_m9, EDL_m9a, EDL_m9b, EDL_m10
Public  EDL_m11, event_no_term, entfcmg, evntxud, lstedit, lsted1, evntpud
Public  nolsted, lstline, add_gpis, adg_lp, adg_1, adg_x, gpi2edl, gpi2e2
Public  add_slaves, adl_1, adl_2, adlr, slv2edl, slv2e1s, slv2e1r, slv2e2
Public  slv2e3, slv2e5, slv2e6, add_rec, adr_1, adr_2, adrr, rec2edl, add_spd
Public  SPD_lp, SPD_1, SPD_xit, SPD2edl, add_PMC, PMC_lp, PMC_1, PMC_xit
Public  PMC2edl, PMC2e2, add_RAMP, RAMP_xit, RAMP2edl, RAMP2e2, EXslvs, EXrec
Public  EXgpis, EXspd, EXpmc, EXramp, Extras2EDL, ZL1015, EX2edl0, EX2edl1
Public  EX2edl2, EX2edl3, EX2edlx, move_events, movev_1, movev_2, movev_3
Public  movev_4, movev_5, movev_6, movev_8, mevok, mevok_1, mevok_2, mevok_3
Public  mevok_4, mevok_5, mevok_6, mevok_7, mevok_8, movcpy_switchbins, mcsb_1
Public  mcsb_2, reset2frombin, range_reset, movexit, movcpy_badparams, emvidx
Public  emvidx1, emvidx2, emvidx3, emvidx4, emvidx5, emvidx6, emvidx7, emvidx8
Public  emvidx9, clear_event_list, celx, celabrt, open_end, open_cut, open_z
Public  fevent_recall, fere1, fere2, fereret, event_recall, evtnadj
Public  evtned, evradj2, JL0955, JL0956, JL0957, JL0958, recalsx
Public  rclkmod, recalse, recalsk, recalx, recall_Extras, rclext1, rclext2
Public  rclext3, rclext4, rclext2a, rclext2b, rclext2c, rclext2d, rclextx
Public  recall_gpi, recall_rec, rclrec1, rclrec2, rclrec_error, recall_slaves
Public  rclslv1, rclslv2, rclslv5, rclslv_error, rclslv_CheckNoSet, rclcnsr
Public  rclcnsx, rclcnse, rclcnsk, recall_spd, rclspd1, recall_pmc, rclpmc1
Public  rclpmc2, rclpmc3, recall_ramp, split_recall, rcl_sv, recall_line
Public  JL0960, recall1, recall2a, recall2b, recall2c, JL0970, JL0980
Public  JL0981, priority_adjust, rgpret, recrclr, delete_event, de1, de2, de3
Public  dex, delnr, delnrA, delnr1, delnr2, JL1015, delnrpl, delete_gpislv
Public  dgpislv, dgsret, delete_range, delran2, delran3, delran4, delranl
Public  nodelr, delranx, delete_marked, delm_1, delm_1a, delm_lp, delm_3
Public  delm_4, delm_4a, delm_5, delm_r, Set4Ripple, s4rplx, Set4DelRipple
Public  s4dr2a, s4drx, ToRippleOrNot, tron_1, tron_x, SaveEDLDeleteValues
Public  s4dr2, Check4Ripple, c4r_insert, c4rron, c4rplx, shift_list, shftlx
Public  shift_p, shft_P1, shft_P2, shft_P3, shft_P4, shift_r, shftq, shftQ_0
Public  shftQ_1, shftQ_2, shift_select, ssel1, shft_1, shft_3, shft_5, shft_7
Public  shft_9, shft_11, sh_REC, sh_R_1, sh_R_2, sh_R_4, sh_R_5, sh_R_6, sh_R_8
Public  sh_R_9, sh_R_x, sh_SRC, sh_S_1, sh_S_2, sh_S_4, sh_S_5, sh_S_6, sh_S_8
Public  sh_S_9, sh_S_x, Shift_TC, shftTC1, shftTCx, Get_ShiftRange, GSR_1
Public  GSR_2, ripple, riplx, note, cmtmemok, no_note_copy, note_copy_ok
Public  cmtxit, cmtrtry, comment_ci, comment_after, cmtaf1, cmtaf2, comment_b4
Public  repl_comment, add_comment, JL1060, cmt_ins, cmt_lp1, cmt_lp2, cmt_lpx
Public  cmt_nlst, chk4lst, check_duration, CD_cut, CD_cut1, CD_spl, CD_spl1
Public  CD_efx, CD_efx1, CD_key, CD_key1, CD_xit, CD_err, check_ltrans, CL_spl
Public  CL_key, CL_efx, CL_efx1, CLefxe, CL_xit

%list


;clear the entire workspace to all null timecode
clear_workspace	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	push	es
	mov	cx,ds
	mov	es,cx
	mov	di,offset R_Tc.tcIN
	mov	cx,offset Mtbl_Length
	xor	al,al
	rep stosb
	pop	es
	call	Cut_Dlg
	call	_upd_getscr
	ret
clear_workspace	endp

clear_edit_FAR	proc	far
	call	clear_edit
	ret
clear_edit_FAR	endp

;================================================================
; Command to just clear the current edit situation, leaving the
;  rest of the workspace alone
clear_edit	proc	near
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	call	_clear_rin		; Clear out RECORD VTR
	call	_clear_rout
	call	_clear_rdur
	mov	al,Trans_Type
	cmp	al,'K'
	jz	cle4key
	cmp	al,'D'
	jz	cle4efx
	cmp	al,'W'
	jnz	cle4cut

cle4key:mov	al,Keyfor_Src		; Get key foreground
	mov	ah,Keybkgnd_Src		; Get key background
	jmp	clear_both

cle4efx:mov	al,From_Machine
	mov	ah,To_Machine
	jmp	clear_both

cle4cut:mov	al,Current_Machine
	jmp	clear_one

clear_both:
	push	ax
	mov	al,ah
	call	Machine_Change
	call	_clear_pin
	call	_clear_pout
	call	_clear_pdur
	pop	ax

clear_one:
	call	Machine_Change
	call	_clear_pin
	call	_clear_pout
	call	_clear_pdur
	call	Cut_Dlg
	call	_upd_getscr
	ret

clear_edit	endp


;================================================================
Reel_Summary	proc	near
	call	_check4edl
	JMP_Z	ReelSx
	call	_kbd_cln
	mov	bx,offset reelsum_ovr
	call	_msgread
	call	rdchar
	call	_Break_check
	JMP_Z	ReelSx
	cmp	ax,offset Enter_xcmd
	jz	DRS_page
	cmp	ax,offset Viewedl1_key
	jz	DRS_page
	cmp	ax,offset Viewedl2_key
	jz	DRS_page
	cmp	ax,offset InsEv_xcmd
	jz	DRS_add
	cmp	ax,offset Prntfil_xcmd
	jz	DRS_print
	cmp	ax,offset DelEv_xcmd
	jz	DRS_del
	call	keythru
	call	_error_bell
	jmp	Reel_Summary

DRS_page:
	mov	Fullscreen_Flag,0ffh
	call	_clear_screen
	mov	Reelsum_Lines,0
	mov	Reelsum_TypeFlag,1	; Set Flag for screen
	jmp	DRS_main

DRS_add:mov	Reelsum_TypeFlag,2	; Set Flag for ADD TO EDL
	call	DRS_delete
	mov	Copy_Flag,0		; Signal first line
	jmp	DRS_main

DRS_print:
	mov	Reelsum_TypeFlag,3	; Set Flag for PRINT
	jmp	DRS_main

DRS_del:
	mov	Reelsum_TypeFlag,4
	jmp	DRS_delete

;................
DRS_main:
	push	es:Current_Event

	mov	Sortwhat,2		; Signal reel type sort
	call	_sort_reels		; Get sorted reel list to DIRBUFF
	mov	bx,offset dirbuff
	mov	Sort_Reeladr,bx		; Init pointer to top of reel list

	call	Reel_Summary_Header

;................................................................
drs_lp:	mov	di,offset Temp_Wrkspce	; Storage buffer
	mov	bx,Sort_Reeladr		; Get next reel Name
	cmp	byte ptr [bx],0		; Check for done
	jz	drs_done
	call	DRS_edl
	add	word ptr Sort_Reeladr,reel_length + 1
	call	DRS_output
	jmp	drs_lp

drs_done:
	cmp	Reelsum_TypeFlag,3
	jnz	drs_don1
	mov	al,'L'-40h		; Send formfeed
	call	lst_co

drs_don1:
	pop	ax			; Get saved event number
	cmp	Reelsum_TypeFlag,2	; Sent to EDL?
	jnz	drs_don2
	xor	ax,ax
drs_don2:
	call	_index_storage
	cmp	Reelsum_TypeFlag,3	; Send to printer?
	jz	ReelSx			; Bail out if so

	cmp	Reelsum_TypeFlag,1	; Sent to screen?
	jnz	ReelSx
	call	rdchar
	jmp	Rellsagn
ReelSx:	call	_evnt_dispthis
	ret

Rellsagn:
	call	screen_init
	jmp	Reel_Summary

;................................................................
; Loop through the EDL and extract a summary line(s) for each reel
DRS_edl:mov	si,offset Starspace_Msg
	call	DRS_store
	mov	si,bx
	call	DRS_store		; Display reel Name
	mov	ax,'  '			; Store two Spaces
	mov	ds:[di],ax
	inc	di
	inc	di
	mov	cx,1			; Start with edit 1
DRSE_lp:mov	ax,cx			; Get next edit number
	call	_index_storage
	jc	DRS_nxt			; Skip if not EDIT

	test	es:word ptr [bx].Flags_lofst,split_Fmask
	jnz	DRS_nxt			; Skip split edit lines

	mov	ax,es:[bx]		; Get edit number
	push	ax

	add	bx,offset ZeroBase.reel_lofst	; BX = reel number address (EDL)
	mov	dx,Sort_Reeladr		; Get reel Name
	push	cx
	mov	ch,reel_length
	call	_cmpchr			; Try to match reel Name
	pop	cx
	pop	ax
	jnz	DRS_nxt

	cmp	di,offset Temp_Wrkspce + 64
	jb	DRSE_1

	push	ax
	call	DRS_output
	mov	di,offset Temp_Wrkspce
	mov	si,offset Starspace_Msg
	call	DRS_store
	mov	si, SpacePointer(8)
	call	DRS_store

	cmp	Reelsum_TypeFlag,2	; Sent to Screen?
	jnz	nicx
	inc	cx			;12-16-1992 Line Deleted nhs
nicx:	pop	bx			; Restore EDIT number to BX
	jmp	DRS_p0

DRSE_1:	mov	bx,Current_Event_Adr
	mov	bx,es:[bx]

; Pad with Spaces
DRS_p0:	mov	al,' '
	cmp	bx,999
	ja	DRS_p1
	mov	ds:[di],al
	inc	di
DRS_p1:	cmp	bx,99
	ja	DRS_p2
	mov	ds:[di],al
	inc	di
DRS_p2:	cmp	bx,9
	ja	DRS_p3
	mov	ds:[di],al
	inc	di
DRS_p3:	mov	Temp_Tc_Buf,di
	call	_make_dec
	mov	di,bx
	mov	al,' '
	mov	ds:[di],al
	inc	di

DRS_nxt:inc	cx
	cmp	cx,es:Next_Avail_Num
	JMP_C	DRSE_lp
	ret

; Store to line
DRS_store:
	lodsb
	or	al,al
	jz	DRS_storx
	mov	ds:[di],al
	inc	di
	jmp	DRS_store
DRS_storx:
	ret

DRS_output:
	push	cx
	push	bx
	mov	word ptr ds:[di],0a0dh
	mov	byte ptr ds:[di+2],0
	mov	bx,offset Temp_Wrkspce

;................................................................
	cmp	Reelsum_TypeFlag,1		; DISPLAY TO SCREEN?
	jnz	drs_o2

	call	_comsg
	inc	Reelsum_Lines
	mov	al,Reelsum_Lines
	cmp	al,maxlines			; # of lines in a screen page
	jc	drs_o4
	mov	Reelsum_Lines,0
	mov	bx,offset Pagend_Msg
	call	_comsg
	mov	al,cr
	call	_ConOut
	call	rdchar
	call	_Break_check
	jnz	drs_o4
	jmp	Keyboard

;................................................................
drs_o2:	cmp	Reelsum_TypeFlag,2		; SAVE TO EDL?
	jnz	drs_o3

	mov	Reelsum_Inprogress,0ffh
	push	es:Current_Event
	xor	ax,ax
	call	_index_storage
	cmp	Copy_Flag,0		; First line?
	jnz	drs_o2b
	call	comment_b4
	mov	Copy_Flag,1		; Cancel first line Flag
	jmp	drs_o2c

drs_o2b:call	comment_after
drs_o2c:mov	Reelsum_Inprogress,0
	pop	ax
	call	_index_storage
	jmp	drs_o4

;................................................................
drs_o3:	cmp	Reelsum_TypeFlag,3	; PRINT TO PRINTER?
	jnz	drs_o4
	call	listmsg
drs_o4:	pop	bx		; 12-16-1992 Corrected reversed
	pop	cx		;  pop of CX/BX
	ret

Reel_Summary	endp

;................................................................
DRS_delete	proc	near
	mov	ax,-1			; Initiate for first edit
DRS_dlp:inc	ax
	cmp	ax,es:Next_Avail_Num
	jz	DRS_dnf
	call	_index_storage
	jnc	DRS_dlp

	mov	dx,bx
	mov	bx,offset Reelsum_EDLev	; Find, increment and return
	mov	ch,[bx]
	inc	bx
	xchg	bx,dx			; BX = EDL, DX = REEL SUM hdr
	push	ax
	call	_cmpchr
	pop	ax
	jnz	DRS_dlp

DRS_delone:
	call	_index_storage
	jnc	DRS_deldone
	push	ax
	call	_delete
	pop	ax
	jmp	DRS_delone

DRS_deldone:
	mov	ax,0
	call	_event_display
DRS_delxit:
	ret

DRS_dnf:cmp	Reelsum_TypeFlag,2		; Delete before add?
	jz	DRS_delxit
	ERROR	noreelsum_error, ERET_Keyboard

DRS_delete	endp
;................................................................
Reel_Summary_Header	proc	near

	mov	di,offset Temp_Wrkspce	; Storage buffer pointer

	cmp	Reelsum_TypeFlag,2	; Sending to EDL?
	jz	RSHnoedl		; Skip if so

	mov	bx,offset File_Title
	cmp	es:byte ptr [bx + 7],cr
	jbe	RSHnoedl

	push	di			; Save temp_wkrspce address
RSHttl:	mov	al,es:[bx]
	inc	bx
	or	al,al
	jz	RSHttlx
	cmp	al,cr
	jz	RSHttlx
	mov	ds:[di],al
	inc	di
	jmp	RSHttl

RSHttlx:call	DRS_output		; Output line
	pop	di			; Restore Temp_Wrkspce address

RSHnoedl:
	mov	si,offset Reelsum_Header; REEL SUMMARY: string
	call	DRS_store

; Count number of reels found
	xor	cx,cx			; Clear counter
	mov	bx,offset dirbuff
RSH_cnt:cmp	byte ptr [bx],0		; Check for done counting
	jz	RSH_cntdone
	add	bx,reel_length + 1
	inc	cx
	jmp	RSH_cnt
RSH_cntdone:
	mov	bx,cx			; # of reels to CX
	mov	Temp_Tc_Buf,di		; Buffer pointer
	call	_make_dec		; Make decimal ascii
	mov	di,bx
	mov	si,offset Reelsused_Msg
	call	DRS_store

	cmp	Reelsum_TypeFlag,2	; Sending to EDL?
	jz	RSH_nom
	mov	si, SpacePointer(8)
	call	DRS_store
	mov	si,offset EdlSES
	call	DRS_store

RSH_nom:call	DRS_output		; Output line
	ret
Reel_Summary_Header	endp


;================================================================
markon	proc	near
	call	markset
	FLAGBITS sort_Fmask
	jnz	markoff
	or	es:word ptr [bx].Flags_lofst,sort_Fmask
	FLAGBITS dblline_Fmask
	jz	markd
	inc	ax
	call	_index_storage
	or	es:word ptr [bx].Flags_lofst,sort_Fmask
	jmps	markdc
markon	endp

markoff	proc	near
	and	es:word ptr [bx].Flags_lofst,not sort_Fmask
	FLAGBITS dblline_Fmask
	jz	markd
	inc	ax
	call	_index_storage
	and	es:word ptr [bx].Flags_lofst,not sort_Fmask
markdc:	dec	ax
markd:	call	_EDL_display
markx:	ret
markoff	endp

markset	proc	near
	call	_check4edl
	jz	marksx
	mov	ax,es:Current_Event
	call	_index_storage
	jnc	markx
marksx:	pop	bx			; Get rid of return
	ret
markset	endp

;=============================================
;	replace an event into the list
;=============================================
replace_event	proc	near
	mov	Evnt_Replace_Flag,0ffh
	mov	Evnt_Insert_Flag,0
	jmps	ae_jmp
replace_event	endp

;============================================
;	Insert an event into the list
;============================================
insert_event	proc	near
	mov	Evnt_Insert_Flag,0ffh
	mov	Evnt_Replace_Flag,0
ae_jmp:	call	_check4edl
	jnz	ae_0
	ret
insert_event	endp

;============================================
;	ADD EVENT TO LIST
;============================================
add_event	proc	near
	xor	al,al
	mov	Evnt_Insert_Flag,al
	mov	Evnt_Replace_Flag,al

ae_0:	cmp	Record_Flag, 0
	jnz	ae_00
	mov	al,Current_Machine	; Save return machine
	mov	Last_Machine,al

ae_00:	cmp	Mode_Flag,0		; Test for any Mode_Flag
	jnz	aev_1
	ERROR	mprse_error, ERET_Keyboard

aev_1:	call	_check4reel		; Check for existing reel assignments
	call	check_duration		;  and check that there is a duration

	call	_savebin		; Protect the bin to BIN3


	mov	byte ptr Vtrs_In_Edit_Table,0ffh
	call	_SaveSlavesToEditTable	; Save any slaves involved in edit
					; to Vtrs_In_Edit_Table

	mov	ax,es:Next_Avail_Num	; Check for more room
	mov	cx,es:Max_Lines		; in EDL
	cmp	Trans_Type,'C'
	jnz	ae_0a			; If not dbl line, then
	inc	cx			;  only 1 line is needed
ae_0a:	cmp	ax,cx			; Next < MAX [ or MAX + 1)
	jb	ae_0b
	ERROR	out_of_memory, ERET_Keyboard

ae_0b:	cmp	Trans_Type,'S'		; If SPLIT EDIT, check for valid modes
	jnz	ae_1
	call	_check_mode

ae_1:	cmp	Evnt_Insert_Flag,0ffh
	jnz	ae_3
	mov	bx,offset ins_ovr	; INSERT EVENT? prompt
	call	no_chos_msg
	jz	ae_4
	ret

ae_3:	cmp	Evnt_Replace_Flag,0ffh	;  only for REPLACE EVENT...
	jnz	ae_4

	mov	ax,Last_Recalled
	or	ax,ax
	jnz	ae_3a
	mov	ax,es:Current_Event
ae_3a:	call	_kbd_cln
	cmp	ax,es:Current_Event
	jz	ae_3b
	mov	bx,offset Anyway_Msg
	call	_comsg
ae_3b:	mov	bx,offset replace_ovr	; Prompt for confirmation
	call	_kbd_cln
	call	_msgread
	mov	cl,'N'
	push	ax
	call	yn_chos
	pop	ax
	jz	ae_3c
	ret

ae_3c:	mov	Last_Recalled,ax		; Set new last recalled number

; BRANCH ON EDIT TYPE TO APPROPRIATE ROUTINE
ae_4:	mov	al,Trans_Type
	cmp	al,'C'			; Straight cut?
	jnz	ae_4a
	jmp	put_cut

ae_4a:	cmp	al,'S'
	jnz	ae_4b
	jmp	put_spl

ae_4b:	cmp	al,'K'
	jnz	ae_4c
	jmp	put_key

ae_4c:	jmp	put_efx
add_event	endp

;================================
; ADD A CUT TO THE EDL
;================================
put_cut	proc	near
	mov	al,Current_Source
	mov	To_Machine,al
	call	_ReCompute_CUT
	mov	bx,offset Work_Event
	call	_make_event
	jmp	event2edl
put_cut	endp

;================================
; ADD A SPLIT EDIT TO THE EDL
;================================
put_spl	proc	near
	mov	al,Current_Machine	; FIX 4/24/90 nhs
	mov	To_Machine,al
	call	Machine_Change
	mov	Trans_Type,'C'		; Set CUT type
	call	_ReCompute_CUT		; Compute rest of workspace
	call	check_ltrans		; Check for legal transition
	mov	al,Mode_Flag
	push	ax			; Save Mode_Flag to restore later

; 1. Set mode type for first half of split
	mov	al,Mode_Flag		; Get mode Flag
	mov	ah,Split_Mode		; Get split type
	push	ax			; Save both
	and	al,ah			; Mask out unwanted bits
	mov	Mode_Flag,al

; 2. Save the record and play outpoints
	mov	bx,offset R_Tc.tcOUT
	mov	dx,offset Split_Rout
	call	_mmv3byt
	mov	bx,Current_Outbuf
	mov	dx,offset Split_Pout
	call	_mmv3byt

; 3. Compute first half of split edit

	call	_E1_flgs
	test	al,E1Flag_spltype	; Mach one type?
	jz	psp_reg

; The following for MACH I type splits, only
	call	_clear_outs		; Clear ROUT,POUT,RDUR,PDUR
	mov	bx,offset Split_Delay	; Set duration of this half
	mov	dx,offset R_Tc.tcDUR	;  to the RECORD VTR
	call	_mmv3byt
	xor	al,al
	call	Machine_Change		; Set to REC vtr
	call	_up_out			; Compute record out point
	call	_ReCompute_CUT		; Compute rest of workspace

; 4. Add this line to the list
psp_reg:mov	bx,offset Work_Event
	call	_make_event

; 5. Mark this line as first line of a two line event
	or	word ptr [bx].Flags_lofst,dblline_Fmask

; 6. Set mode type for second half of split
	pop	ax			; Restore mode and mask
	not	ah
	and	al,ah
	mov	Mode_Flag,al		; Set new mode

; 7. Compute new in points and replace old out points
; -- advance Rec IN = Rec IN + Split_Delay
	mov	bx,offset R_Tc.tcIN
	push	bx
	call	_Sttime_move
	mov	bx,offset Split_Delay
	call	_Elaptm_move
	call	_timadd
	pop	dx
	call	_mmv3byt

; -- advance P IN = P IN + Split_Delay
	mov	bx,Current_Inbuf
	push	bx			; Save for destination
	call	_Sttime_move
	mov	bx,offset Split_Delay
	call	_Elaptm_move
	call	_timadd
	pop	dx
	call	_mmv3byt

; -- Replace old out points
	mov	bx,offset Split_Rout
	mov	dx,offset R_Tc.tcOUT
	call	_mmv3byt
	mov	bx,offset Split_Pout
	mov	dx,Current_Outbuf
	call	_mmv3byt
	call	_clear_pdur
	call	_clear_rdur

; 8. Compute the edit and store it
	call	_computer
	call	_ReCompute_CUT

	mov	bx,offset Work_Event + line_length
	call	_make_event
	or	word ptr [bx].Flags_lofst,split_Fmask ;Set split Flag, 2nd line

	pop	ax
	mov	Mode_Flag,al		; Return Mode_Flag to original value
	jmp	event2edl
put_spl	endp

;================================
; ADD A KEY EVENT TO THE EDL
;================================
put_key	proc	near
	mov	al,Keybkgnd_Src		; Set To_Machine=background
	mov	To_Machine,al
	call	Machine_Change
	mov	Trans_Type,'C'		; Compute as CUT
	call	_ReCompute_CUT
	mov	Trans_Type,'K'		; Reset as KEY
	call	check_ltrans		; Check for legal transition

; Add this line to the list
	mov	bx,offset Work_Event
	call	_make_event

; Mark this line as first line of a two line event
	or	word ptr [bx].Flags_lofst,dblline_Fmask

; Mark this line as a KEY line, background
	or	word ptr [bx].Flags_lofst,key_Fmask
	or	byte ptr [bx].keyFlags_lofst,back_Kmask

; Switch to FROM (background)  machine, calculate as cut
	mov	al,Keyfor_Src		; From machine = forground
	call	Machine_Change
	mov	Trans_Type,'C'		; Compute as CUT
	call	_ReCompute_CUT
	mov	Trans_Type,'K'		; Reset as KEY

; Add this line to the list
	mov	bx,offset Work_Event + line_length
	call	_make_event
	or	word ptr [bx].Flags_lofst,key_Fmask

; Save transition code and transition length
	cmp	Key_Mode,0		; 1=IN, 2=OUT, 0=KEY ON
	jz	pkey_ON
	xor	ax,ax
	mov	[bx].efxnum_lofst,ax
	mov	ax,Key_Trans
	mov	[bx].efxdur_lofst,ax
	cmp	Key_Mode,1
	jnz	pkey_OUT

; Mark this line as a KEY IN line
pkey_IN:or	byte ptr [bx].keyFlags_lofst,fadein_Kmask
	jmp	pkey_ON

; Mark this line as a KEY OUT line
pkey_OUT:
	or	byte ptr [bx].keyFlags_lofst,fadeout_Kmask

; Mark this line as a KEY ON line
pkey_ON:jmp	event2edl
put_key	endp

;================================
; ADD A DISSOLVE OR WIPE TO EDL
;================================
put_efx	proc	near
	call	_ReCompute_EFX
	call	check_ltrans		; Check for legal transition

	mov	al,To_Machine
	mov	ah,Trans_Type
	push	ax			; Save the TO machine

	mov	al,From_Machine		; And select the FROM machine
	call	Machine_Change
	mov	Trans_Type,'C'		; Set cut type for first line

;1. compute FROM event and add it
	test	Workspace_Flags,w_FRMdur_bit ; Check source duration for zero
	jnz	adcomp			; Else, do EXTENDED EFFECT

; (non-extended edit, RIN=ROUT)
	mov	bx,offset R_Tc.tcIN	; Cases of non-extended, non delayed
	mov	dx,offset R_Tc.tcOUT	; Effect transition
	call	_mmv3byt			; ROUT = RIN, RDUR = 0
	call	_clear_rdur
	jmps	adcomp1

adcomp:	call	_clear_rout		; Clear ROUT
	call	_clear_rdur		; Clear RDUR
	call	_ReCompute_CUT		; Compute FROM event using source

; Save the ROUT.  It will be 2nd line's RIN
adcomp1:mov	bx,offset R_Tc.tcOUT	; Save ROUT
	mov	dx,offset Addtc_Buf	;  to a buffer
	call	_mmv3byt

; Add this line to the list
	mov	bx,offset Work_Event
	call	_make_event

; Tag the FROM machine and clear POUT and PDUR
;  However, if tag Flag is off, erase it
	mov	bx,Current_Outbuf
	mov	dx,Current_Inbuf
	call	_mmv3byt

	cmp	Tag_Flag,0
	jnz	adcomp2
	call	_clear_pin
adcomp2:call	_clear_pout
	call	_clear_pdur

; Mark this line as first line of a two line event
	or	word ptr Work_Event.Flags_lofst,dblline_Fmask

; Switch back to TO machine
	pop	ax			; Restore TO machine
	mov	Trans_Type,ah
	call	Machine_Change
	mov	ah,From_Machine
	mov	al,To_Machine
	mov	From_Machine,al
	mov	To_Machine,ah

; Clear out record out and record duration
	call	_clear_rout
	call	_clear_rdur

; Restore RIN from the end of the first line's ROUT
	mov	bx,offset Addtc_Buf
	mov	dx,offset R_Tc.tcIN
	call	_mmv3byt

; Compute the edit
	call	_ReCompute_CUT

	mov	bx,offset Work_Event + line_length
	call	_make_event

; Save transition code and transition length
	mov	ax,Trans_Code
	mov	[bx].efxnum_lofst,ax
	mov	ax,Trans_Length
	mov	[bx].efxdur_lofst,ax
put_efx	endp

; Fall through to add the event

;================================================================
;		PUT ENTIRE EDIT INTO THE EDL
;================================================================
; ENTER: Work_Event has been setup with a one or two line event
;	 REPLACE/INSERT Flags set (or not)
; Exit:	 1 or 2 line event properly put in list
;
; 1. FIND OUT WHERE TO PUT THIS EDIT
event2edl	proc	near
	mov	ax,es:Current_Event
	or	ax,ax
	jnz	evnt2edl1
	inc	ax
evnt2edl1:
	call	_line_first		; Make sure we are on first line
	push	ax
	call	Set4Ripple		; Save current event's information
	pop	ax

	mov	bx,Current_Event_Adr
	mov	dx,es:[bx]		; Get current edit number

	cmp	Evnt_Replace_Flag,0ffh	; Replace?
	JMP_Z	EDL_m1
	cmp	Evnt_Insert_Flag,0ffh	; Insert?
	jnz	e2edl_0
	jmp	EDL_m3

;----------------------------------------------------------------
; Must be ADD_EVENT, check for SORT on
e2edl_0:test	Operational_Flags,sort_OPBIT ; 0ffh = sort is ON
	jz	e2edl_2
	call	_check4edl		; Is sort possible? any list?
	jz	e2edl_2			; Skip if not

	mov	Evnt_Insert_Flag,0ffh	; Set INSERT Flag TRUE

	mov	bx,offset R_Tc.tcIN
	mov	dx,offset Sortmatch_In
	call	_mmv3byt
	mov	bx,offset R_Tc.tcOUT
	mov	dx,offset Sortmatch_Out
	call	_mmv3byt

	call	_sort_match		; Find where to put it
	jnc	e2edl_1			; C=1 if NOT found, so jump if found
	mov	ax,1			; If not found, insert at top
	jmps	EDL_m1

e2edl_1:call	chk4lst			; Inx Current_Event and ckeoedl
	mov	es:Current_Event,ax	; C=1 if within list
	jnc	e2edl_2			; If above list, add it
	call	_index_storage		; Check to see if we should
	jc	e2edl_1			;  advance past cmt/slv/mem, etc.
	FLAGBITS split_Fmask		; Check for split edit
	jnz	e2edl_1			; Increment over second split line
	cmp	es:byte ptr [bx].type_lofst,'C'
	jnz	e2edl_1
	jmp	EDL_m3

; Add to bottom of EDL
e2edl_2:xor	al,al
	mov	Evnt_Insert_Flag,al	; Zero out INSERT and
	mov	Evnt_Replace_Flag,al	;  REPLACE Flags
	mov	ax,es:Next_Avail_Num

; Get next edit number, increment Next_Avail_Num for each line being added
e2edl_4:mov	dx,es:Next_Edit
	inc	es:Next_Edit
	inc	es:Next_Avail_Num
	test	word ptr Work_Event.Flags_lofst,dblline_Fmask
	jz	EDL_m1
	inc	es:Next_Avail_Num
event2edl	endp
	
;----------------------------------------------------------------
;	Delete current event if this is a REPLACE
; ENTER: AX = event to put edit at
EDL_m1	proc	near
	call	_index_storage
	call	_notate_Extras
	cmp	Evnt_Replace_Flag,0ffh	; Replace?
	jnz	EDL_m3

	push	dx			; Save edit number
	push	ax			; Save current event number
	mov	cx,es:[bx].Flags_lofst	; Get Flags
	push	cx
	call	_delete			; Delete current line
	pop	cx
	test	cx,dblline_Fmask	; Was it a dbl line edit?
	jz	EDL_m2			; Just one line if Z=1
	call	_delete
EDL_m2:	call	delete_gpislv		; Delete any following Extras
	pop	ax			; Restore current event number
	pop	dx			; Restore edit number
	call	_index_storage
	jmps	EDL_m3a			; Must insert after deletions

;----------------------------------------------------------------
;	Add blank events in EDL if this is an INSERT
EDL_m3:	cmp	Evnt_Insert_Flag,0ffh	; Insert?
	jnz	EDL_m4
	mov	dx,es:Next_Edit
	inc	es:Next_Edit

EDL_m3a:cmp	ax,es:Next_Avail_Num
	jnc	EDL_m3b
	call	_make_room
	test	word ptr Work_Event.Flags_lofst,dblline_Fmask
	jz	EDL_m4
	call	_make_room
	jmps	EDL_m4

EDL_m3b:inc	es:Next_Avail_Num
	test	word ptr Work_Event.Flags_lofst,dblline_Fmask
	jz	EDL_m4
	inc	es:Next_Avail_Num

;----------------------------------------------------------------
;	Put to the list at current event
EDL_m4:	call	_index_storage
	mov	si,offset Work_Event
	mov	[si],dx			; Save edit number
	mov	cx,line_length		; # of 1 line bytes to move
	test	word ptr [si].Flags_lofst,dblline_Fmask
	jz	EDL_m5
	mov	line_length[si],dx	; Save edit number
	add	cx,cx			; Double it if 2 line event
EDL_m5:	mov	si,offset Work_Event
	mov	di,bx
	cld
	rep movsb

;----------------------------------------------------------------
; Calculate the total time

; tt = R_Tc.tcOUT - Time_Start
; if TT > Time_Total then Time_Total = TT

	mov	bx,offset Time_Start
	call	_Sttime_move
	jz	EDL_m8			; Skip this if Time_Start is zero
	mov	bx,offset R_Tc.tcOUT	; Get the record out point
	call	_Entime_move
	call	_timdif			; BX points to difference
	mov	dx,offset Time_Total
	call	_cmp24b
	jbe	EDL_m8
	call	_mmv3byt

EDL_m8:	mov	ax,es:Current_Event	; Save the event
	push	ax			;  base address
	call	_index_storage
	FLAGBITS dblline_Fmask		; If double line event
	jz	EDL_m9			;  then to the
	inc	ax			;  next line

EDL_m9:	call	_index_storage
	push	ax
	call	Check4Ripple
	pop	ax

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; INSERT LOGIC TO DEAL WITH sort on and a replace!
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	test	Operational_Flags,sort_OPBIT
	jnz	EDL_m9b
	cmp	Ripple_Flag,0ffh	; RIPPLE PROCEEDURES IF ANY
	jnz	EDL_m9b
	push	ax
	mov	bx,offset ripple_ovr	; Ask operator Y/N?
	call	no_chos_msg
	pop	ax
	jnz	EDL_m9b

	push	ax			; Save event number
	inc	ax			; Go next event
	mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask
	jz	EDL_m9a
	inc	ax
EDL_m9a:mov	Shiftstart_Edit,ax	;  for ripple
	mov	ax,es:Next_Avail_Num
	dec	ax
	mov	Shiftend_Edit,ax
	mov	bx,offset Rvtr_Ripple
	mov	dx,offset Entime
	call	_mmv3byt
	mov	Shift_Flag,1		; Indicate record time changes

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 5-11-1992 Fix for ripple
;;;;	mov	cl,es:Edl_Fcm
	mov	cl,DF_CHAR	;Rtcf
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	call	shft_1
	pop	ax			; Restore event number
	call	_index_storage

	mov	MasterEditLineAdr,bx	; Save master line <> not used yet

EDL_m9b:mov	Ripple_Flag,0		; Turn ripple off

	call	add_gpis
	mov	ah,Current_Source
	mov	al,Current_Machine
	push	ax
	call	add_slaves
	call	add_rec
	call	add_spd
	call	add_PMC
	call	add_RAMP
	call	add_PREREAD
	pop	ax
	push	ax
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change

	pop	ax
	call	_index_storage

	push	ax
	call	_clear_event
	pop	ax

	and	Gpi_Flags,not Enabled_MSBIT
	and	Pmc_Flags,not Enabled_MSBIT	; Turn off PMC
	and	Spd_Flags,not Enabled_MSBIT	; Turn off SPD

	cmp	ax,1
	jz	EDL_m11
	dec	ax
	call	_index_storage
	jc	EDL_m10
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	EDL_m11
EDL_m10:inc	ax
	call	_index_storage
EDL_m11:push	ax
	call	_clean_last		; Clean the list if auto clean
	pop	ax
	call	_index_storage
EDL_m1	endp

;================================================================
; Clean up this mess...
; Afterthoughts and other miscreants of logic
event_no_term	proc	near
	cmp	es:Edl_Fcm,0
	jnz	entfcmg
	mov	al,Rtcf
	mov	es:Edl_Fcm,al

; Prevent screen updates during reel summary
entfcmg:xor	al,al			; These three lines were moved
	mov	Evnt_Insert_Flag,al	;  from just before _write2disk
	mov	Evnt_Replace_Flag,al	;  below.

	cmp	Reelsum_Inprogress,0ffh
	JMP_Z	nolsted

	call	_evnt_dispthis		; Display the event

	cmp	Record_Flag, 0
	jnz	entnosw
	mov	al,Last_Machine
	call	Machine_Change
	call	switch
	call	vtr_e2e			; VTR_E2E 4/27/89

entnosw:
	xor	al,al
	mov	Evnt_Insert_Flag,al
	mov	Evnt_Replace_Flag,al

	call	_write2disk

	test	Operational_Flags,lprint_OPBIT
	jz	evntxud
	call	lstedit			; Print the edit
evntxud:mov	Trans_Type,'C'
	call	_upd_getscr

	call	_time_upd
	call	Gpi_Upd
	CALL	Pmc_Upd
	CALL	Spd_Upd
	call	Preread_UPD
	call	ramp_upd
	jmp	Trans_Upd

; Send current edit w/ all Extras out to list device
lstedit:call	lst_init		; Init printer Port
	jc	nolsted			; Carry set if any error

	mov	ax,es:Current_Event
	push	ax			; Save current event

	call	lstline			; First line
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT ; Was it NOT an edit?
	jc	lsted1			; If NOT an edit, look for Extras

	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	lsted1
	inc	ax			; Next line
	call	lstline			; Do another line

lsted1:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jae	evntpud
	call	_index_storage
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT ; If we have reached another
	jz	evntpud				;  edit, we are done
	call	lstline
	jmps	lsted1

evntpud:call	lcrlf				; Separating crlf
	call	vtr_inst			; Re-install VLAN device
	pop	ax				; Restore original EDIT
	call	_index_storage			;  position in list
nolsted:ret					; And return
event_no_term	endp

; Send event in AX out to printer w/ crlf
; AX (line num) and BX (current event adr) are returned
lstline	proc	near
	call	_index_storage
	push	ax
	push	bx
	call	_EDL2ASCII
	call	listmsg
	pop	bx
	pop	ax
	call	lcrlf
	ret
lstline	endp



;================================================================
;		ADD Extras TO EVENT IN EDL
;================================================================
add_gpis	proc	near
	test	Gpi_Flags,Enabled_MSBIT
	jz	adg_x
	xor	cx,cx			; Start with GPI 0
adg_lp:	mov	al,cl			; Get GPI number
	cbw
	call	gpi_index		; Index to it
	test	byte ptr [bx].gpiFLAGS,G_active_mask ;gpi on?
	jz	adg_1			; Skip if not
	call	gpi2edl
adg_1:	inc	cl
	cmp	cl,MAX_GPI_REGISTERS
	jc	adg_lp
adg_x:	ret
add_gpis	endp

gpi2edl	proc	near
	push	bx
	push	cx
	push	di
	push	si
	mov	si,bx				; GPI control block to SI
	call	_Clear_WorkEvent
	mov	bx,offset Work_Event		; Where to build GPI line
	mov	[bx],cx				; Save GPI number
	mov	byte ptr [bx].cmnt_lofst,Editline_GPI	; Mark as GPI
	mov	cx,GPI_length
gpi2e2:	lodsb
	mov	byte ptr [bx].GPI_lofst,al		; Save GPI
	inc	bx
	loop	gpi2e2
	jmp	EXgpis
gpi2edl	endp

;----------------------------------------------------------------
; Rewritten 7-14-1990 NHS
; Slave format:
; REEL holds Name of reel to be slaved
; P_IN holds in point of slave
; R_IN holds in point of record
; P_OUT holds in point of MASTER
; REEL + 6 holds Name of reel to be MASTER
add_slaves	proc	near
	test	Slave_Flags,Enabled_MSBIT
	jz	adlr
	mov	bx,offset Slave_Table
	cmp	byte ptr [bx],0ffh	; No slaves?
	jz	adlr			;  then bail out.
	inc	bx			; Point to first slave
adl_1:	mov	cl,[bx]			; Get slave device
	cmp	cl,0ffh			; Check for end of table
	jz	adlr
	call	slv2edl			; Make a slave line
adl_2:	inc	bx
	jmp	adl_1
adlr:	ret
add_slaves	endp

;................................................................
slv2edl	proc	near
	push	bx			; Save slave table position
	push	cx			; Save machine number
	push	di
	push	si

	call	_Clear_WorkEvent
	mov	di,offset Work_Event
	mov	ds:byte ptr [di].cmnt_lofst,Editline_SLAVE ; Mark as slave

	mov	al,cl			; Switch to slave vtr
	call	Machine_Change
	or	al,al			; Check for record machine
	jnz	slv2e1s

; Process for RECORD MACHINE SLAVE
	mov	al,Rtcf			;  Save RECORD FCM
	mov	bx,offset R_Reel_Num
	jmp	slv2e1r

; Process for SOURCE MACHINE SLAVE
slv2e1s:call	Idx2tcf			; Get FCM
	mov	bx,Current_Reel_Adr

; DX points to reel Name
slv2e1r:mov	ds:byte ptr [di].ptcd_lofst,al
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Get REEL POINTER to DX
	mov	ch,reel_length
	call	_mmv

slv2e2:	mov	dx,di
	add	dx,offset ZeroBase.pin_lofst		; Save the slave in point
	call	_get_in
	call	_mmv3byt

	cmp	Current_Machine,0	; Is slave the RECORD VTR?
	jz	slv2e3
	call	_get_in			; 7-13-1990
	push	bx			; Save SLAVE IN POINT
	call	_Sttime_move		; Add slave offset to
	mov	bx,offset R_Tc.tcDUR	;  old in point
	call	_Elaptm_move
	call	_timadd
	pop	dx
	call	_mmv3byt

	call	_get_dur			; Clear out duration (6-25-1990)
	call	_clear_tc
	call	_computer		; And recompute VTR

slv2e3:	mov	dx,di			; Save the record point at slave IN
	add	dx,offset ZeroBase.rin_lofst		;  for reference as default link
	mov	bx,offset R_Tc.tcIN
	call	_mmv3byt

; Put MASTER information into slave line
	mov	al,byte ptr Slave_Table	; Get the master
	call	Machine_Change		; Point to MASTER

	mov	dx,di
	add	dx,offset ZeroBase.rin_lofst		; Where to put MASTER TIME CODE
	call	_get_in
	call	_mmv3byt

	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst + reel_length

	cmp	Current_Machine,0	; Record is master?
	jnz	slv2e5
	mov	bx,offset R_Reel_Num
	jmp	slv2e6
slv2e5:	mov	bx,Current_Reel_Adr
slv2e6:	mov	ch,reel_length
	call	_mmv

	mov	al,Current_Machine
	call	Idx2tcf			; Get FCM
	mov	bx,si
	add	bx,offset ZeroBase.rtcd_lofst
	mov	[bx],al
	jmp	EXslvs
slv2edl	endp

;----------------------------------------------------------------
; 11-01-1991
; Multiple Record
add_rec	proc	near
	test	MultRec_Flags,Enabled_MSBIT
	jz	adrr
	mov	bx,offset Multrecord_Table
adr_1:	mov	cl,[bx]			; Get slave device
	cmp	cl,0ffh			; Check for end of table
	jz	adrr
	call	rec2edl			; Make a slave line
adr_2:	inc	bx
	jmp	adr_1
adrr:	ret
add_rec	endp

;................................................................
rec2edl	proc	near
	push	bx			; Save slave table position
	push	cx			; Save machine number
	push	di
	push	si

	call	_Clear_WorkEvent
	mov	di,offset Work_Event
	mov	ds:byte ptr [di].cmnt_lofst,Editline_REC ; Mark as mult record

	mov	al,cl			; Switch to slave vtr
	call	Machine_Change
	call	Idx2tcf			; Get FCM
	mov	bx,Current_Reel_Adr

; DX points to reel Name
	mov	ds:byte ptr [di].ptcd_lofst,al
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Get REEL POINTER to BX
	mov	ch,reel_length
	call	_mmv

	mov	dx,di
	add	dx,offset ZeroBase.pin_lofst		; Save the slave in point
	call	_get_in
	call	_mmv3byt

	call	_get_in			; 7-13-1990
	push	bx			; Save SLAVE IN POINT
	call	_Sttime_move		; Add slave offset to
	mov	bx,offset R_Tc.tcDUR	;  old in point
	call	_Elaptm_move
	call	_timadd
	pop	dx
	call	_mmv3byt

	call	_get_dur			; Clear out duration (6-25-1990)
	call	_clear_tc
	call	_computer		; And recompute VTR

	mov	dx,di			; Save the record point at slave IN
	add	dx,offset ZeroBase.rin_lofst		;  for reference as default link
	mov	bx,offset R_Tc.tcIN
	call	_mmv3byt

; Put MASTER information into slave line
	mov	al,0			; Get the master
	call	Machine_Change		; Point to MASTER

	mov	dx,di
	add	dx,offset ZeroBase.rin_lofst		; Where to put MASTER TIME CODE
	call	_get_in
	call	_mmv3byt

	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst + reel_length
	mov	bx,offset R_Reel_Num
	mov	ch,reel_length
	call	_mmv

	mov	al,Current_Machine
	call	Idx2tcf			; Get FCM
	mov	bx,si
	add	bx,offset ZeroBase.rtcd_lofst
	mov	[bx],al
	jmp	EXrec
rec2edl	endp



;================================================================
; MOTION CONTROL
add_spd	proc	near
	test	Spd_Flags,Enabled_MSBIT
	jz	SPD_xit
	mov	cx,1			; Start with A-VTR
SPD_lp:	mov	al,cl			; Get SPD number

	call	_VTRinEdit_check	; Check if we should use the VTR
	jc	SPD_1

	call	_index2edspeed		; Index to it and get to AL
	cmp	byte ptr [bx],FPS	; 30fps?
	jz	SPD_1			; Skip if play speed

	mov	si,bx			; SI points to EDIT SPEED in Vtrcb
	mov	ax,cx			; Check for an outpoint
	dec	al			; in the Tags_Table
	mov	bx,offset Tags_Table
	add	bx,ax			; Index to the proper buffer
	add	bx,ax
	add	bx,ax

	push	cx			; Add it to the
	call	SPD2edl			;  EDL
	pop	cx
SPD_1:	inc	cl
	cmp	cl,MAX_MACHINES
	jc	SPD_lp
SPD_xit:ret
add_spd	endp

; SI points to EDIT SPEED in Vtrcb
; BX points to Tags_Table entry
; CL has VTR number
SPD2edl	proc	near
	push	bx
	push	cx
	push	di
	push	si

	call	_Clear_WorkEvent
	mov	di,offset Work_Event
	mov	ds:byte ptr [di].cmnt_lofst,Editline_SPD	; Mark as SPD
	mov	dx,di
	add	dx,offset ZeroBase.pout_lofst
	call	_mmv3byt

	mov	al,cl			; Switch to vtr
	call	Machine_Change

	mov	bx,Current_Reel_Adr
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Get REEL POINTER to BX
	mov	ch,reel_length
	call	_mmv

	call	Idx2tcf			; Get FCM
	mov	ds:byte ptr [di].ptcd_lofst,al

	lodsb				; Get speed
	mov	ds:byte ptr [di].SPD_lofst,al
	jmp	EXspd
SPD2edl	endp

;================================================================
;	PROGRAMMED MOTION LINE
add_PMC	proc	near
	test	Pmc_Flags,Enabled_MSBIT
	jz	PMC_xit
	mov	si,offset Progmotion_Tbl; Point to start of table
	mov	cx,0			; Start with buffer 0
PMC_lp:	mov	al,[si]
	cmp	al,0ffh			; Not active?
	jz	PMC_1			; Skip if NOT
	call	_VTRinEdit_check	; Check if we should use the VTR
	jc	PMC_1

	mov	al,cl			; Get PMC number
	cbw
	push	cx
	push	si
	call	PMC2edl
	pop	si
	pop	cx
PMC_1:	add	si,SIZE VARSPEEDCHANGE
	inc	cl
	cmp	cl,MAX_SPEED_CHANGES
	jc	PMC_lp
PMC_xit:ret
add_PMC	endp

PMC2edl	proc	near
	push	bx
	push	cx
	push	di
	push	si

	call	_Clear_WorkEvent
	mov	di,offset Work_Event
	mov	ds:byte ptr [di].cmnt_lofst,Editline_PMC	; Mark as PMC

	mov	al,[si]			; Get VTR
	dec	al
	cbw
	mov	bx,offset Tags_Table
	add	bx,ax			; Index to the proper buffer
	add	bx,ax
	add	bx,ax
	mov	dx,di
	add	dx,offset ZeroBase.pout_lofst
	call	_mmv3byt

	mov	al,[si]			; Get VTR
	call	Machine_Change
	mov	bx,Current_Reel_Adr
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Get REEL POINTER to BX
	mov	ch,reel_length
	call	_mmv
	call	Idx2tcf			; Get FCM

	mov	ds:byte ptr [di].ptcd_lofst,al
	mov	cx,SIZE VARSPEEDCHANGE	; Move the buffer
	mov	bx,di
	add	bx,offset ZeroBase.SPD_lofst
PMC2e2:	lodsb
	mov	[bx],al
	inc	bx
	loop	PMC2e2
	jmp	EXpmc

PMC2edl	endp

;================================================================
;	PROGRAMMED MOTION LINE
add_RAMP	proc	near
	test	Ramp_Flags,Enabled_MSBIT
	jz	RAMP_xit
	mov	si,offset RampSpeedChange
	call	RAMP2edl
RAMP_xit:
	ret
add_RAMP	endp


RAMP2edl	proc	near
	push	bx
	push	cx
	push	di
	push	si

	call	_Clear_WorkEvent
	mov	di,offset Work_Event
	mov	ds:byte ptr [di].cmnt_lofst,Editline_RAMP	; Mark as RAMP

	mov	al,[si].SPEED_VTR		; Get VTR
	dec	al
	cbw
	mov	bx,offset Tags_Table
	add	bx,ax				; Index to the proper buffer
	add	bx,ax
	add	bx,ax
	mov	dx,di
	add	dx,offset ZeroBase.pout_lofst
	call	_mmv3byt

	mov	al,[si].SPEED_VTR		; Get VTR
	call	Machine_Change
	mov	bx,Current_Reel_Adr
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Get REEL POINTER to BX
	mov	ch,reel_length
	call	_mmv
	call	Idx2tcf			; Get FCM

	mov	ds:byte ptr [di].ptcd_lofst,al

	mov	cx,SIZE RAMPSPEED		; Move the buffer
	mov	bx,di
	add	bx,offset ZeroBase.extra_lofst
RAMP2e2:lodsb
	mov	[bx],al
	inc	bx
	loop	RAMP2e2
	jmp	EXramp

RAMP2edl	endp

add_PREREAD	proc	near
	cmp	Preread_State,0
	jz	adprdx

	push	bx
	push	cx
	push	di
	push	si

	call	_Clear_WorkEvent
	mov	di,offset Work_Event
	mov	ds:byte ptr [di].cmnt_lofst,Editline_PREREAD ; Mark as Preread
	jmp	Extras2EDL
adprdx:	ret

add_PREREAD	endp

;----------------------------------------------------------------
EXslvs	proc	near
	test	Slave_Flags,store_MSBIT
	JMP_Z	EX2edlx
	jmp	Extras2EDL
EXslvs	endp

EXrec	proc	near
	test	MultRec_Flags,store_MSBIT
	JMP_Z	EX2edlx
	jmp	Extras2EDL
EXrec	endp

EXgpis	proc	near
	test	Gpi_Flags,store_MSBIT
	JMP_Z	EX2edlx
	jmp	Extras2EDL
EXgpis	endp

EXspd	proc	near
	test	Spd_Flags,store_MSBIT
	JMP_Z	EX2edlx
	jmp	Extras2EDL
EXspd	endp

EXpmc	proc	near
	test	Pmc_Flags,store_MSBIT
	jz	EX2edlx
	jmp	Extras2EDL
EXpmc	endp

EXramp	proc	near
	test	Ramp_Flags,store_MSBIT
	jz	EX2edlx
	jmp	Extras2EDL
EXramp	endp

Extras2EDL	proc	near
	mov	ax,es:Current_Event	; See if we need to "make room"
	inc	ax			;  to insert the slave in the

	cmp	ax,es:Max_Lines
	jbe	EX2edl0
	call	_line_first
	call	_notate_Extras		;  involved in this edit
	mov	dx,es:[bx].Flags_lofst	; Save the FlagS byte and
	call	_delete			; Delete current line
	test	dx,dblline_Fmask	; Was it a dbl line edit?
	jz	ZL1015			; Just one line if Z=1
	call	_delete
ZL1015:	call	delete_gpislv		; Delete any following Extras
	call	_evnt_dispthis
	ERROR	out_of_memory, ERET_Keyboard

EX2edl0:cmp	ax,es:Next_Avail_Num	;  EDL
	jae	EX2edl2
	call	_index_storage

EX2edl1:call	_make_room
	jmp	EX2edl3
EX2edl2:inc	es:Next_Avail_Num	; Adjust # of lines in the EDL
EX2edl3:call	_index_storage
	mov	si,offset Work_Event
	mov	cx,line_length		; # of 1 line bytes to move
	mov	di,bx
	cld
	rep movsb
EX2edlx:pop	si
	pop	di
	pop	cx
	pop	bx
	ret
Extras2EDL	endp


;================================================================
;	MOVE EVENTS ROUTINE
;================================================================
;
move_events	proc	near
	call	_check4edl		; Bail out if no EDL
	JMP_Z	movexit

	xor	ax,ax
	mov	Where2_Number,ax	; Initialize in case of empty bin

	mov	ax,es			; Get current BIN segment
	mov	Frombin_Seg,ax		; Set default FROM and
	mov	Tobin_Seg,ax		;  TO bin segments

	mov	bx,offset movevnts_ovr	; Move events?
	mov	dx,bx			; (duplicate message pointer)
	call	no_chos_msg
	mov	al,0			; Set Copy_Flag for MOVE
	jz	movev_1

	mov	bx,offset copyevnts_ovr	; Copy events?
	mov	dx,bx			; (duplicate message pointer)
	call	no_chos_msg
	JMP_NZ	movexit
	mov	al,0ffh			; Set Copy_Flag for COPY

movev_1:mov	Copy_Flag,al		; Save Flag for MOVE or COPY

	mov	bx,offset range_reset
	push	bx			; Set reset return

	mov	ax,es:Current_Event	; Save current event number
	mov	Ev2ret2,ax

	mov	bx,dx			; Get move/copy message
	call	get_range		; Get the range of events

	mov	dx,Starting_Number	; Starting number must be
	mov	bx,Ending_Number	; Less than Ending number
	cmp	bx,dx			; If DX < BX then error
	jnc	movev_2
	jmp	movcpy_badparams	; Event not found in list, Bailout!

movev_2:mov	Tobin_Flag,0		; Assume moving to same bin
	push	Cursor			; ARE WE MOVING TO A DIFFERENT BIN?
	norm_VIDEO FALSE,FALSE
	mov	al,','
	call	_ConOut
	call	_Space_Out
	mov	bx,offset tobin_ovr
	call	_msgread
	mov	cl,'Y'
	call	yn_chos
	pop	Cursor
	JMP_C	movexit
	jz	movev_5			; Jump if moving to SAME BIN

	mov	Tobin_Flag,0ffh		; Set Flag for BIN to BIN move/copy

	mov	al,es:Edl_Fcm		; Get current BIN's FCM
	push	ax			;  and save it
	call	movcpy_switchbins	; Switch bins
	mov	ax,es			; Get destination bin segment
	mov	Tobin_Seg,ax		; Save it as the TOBIN
	pop	ax			; Restore Source BIN's FCM
	cmp	al,es:Edl_Fcm		; Compare it against Dest. BIN's FCM
	jz	movev_4			; If they are the same, all is OK

	or	al,al			; Is there an FCM present at all?
	jz	movev_3			; If none, one will be copied

	cmp	es:Next_Avail_Num,1	; Is there a list present?
	jbe	movev_3			; If NOT, FCM will be duped from source

; THERE IS A LIST AND THEY HAVE DIFFERENT FCMs. DANGER WILL ROBINSON!
	call	reset2frombin
	ERROR	EDLFCM_error, ERET_Keyboard

movev_3:mov	es:Edl_Fcm,al		; Set as same

movev_4:mov	es,Tobin_Seg
	cmp	es:Next_Avail_Num,1	; Is there a list present?
	ja	movev_5			; If NOT, FCM will be duped from source
	mov	bx,offset Event_Storage ; Put to top of edl
	jmp	movev_8

;----------------------------------------------------------------
movev_5:call	_line_erase
	push	Cursor
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Where_Msg	; Ask user for DESTINATION
	call	_comsg
	mov	al,4
	call	dec_cimsg
	pop	Cursor
	jnz	movev_6			; Jump if not null

	push	Cursor
	call	_line_erase		; Add to bottom?
	norm_VIDEO FALSE,FALSE
	mov	bx,offset toend_ovr
	call	_msgread
	mov	cl,'N'
	call	yn_chos
	pop	Cursor
	JMP_C	movexit
	jnz	movev_5			; If not to bottom, loop for input
	mov	bx,offset Event_Storage	; Destination address
	jmp	movev_8

movev_6:call	_convert2bin
	mov	Where2_Number,dx
	call	_find_edit_DX
	jz	movev_8

	call	reset2frombin
	ERROR	out_of_memory, ERET_Keyboard

movev_8:mov	Move_Adr,bx		; Save destination address
	cmp	Tobin_Flag,0ffh
	jz	mevok

; If moving within the same bin, 
;  destination number may not be within the Starting and Ending number
;If D < S , ok.  If D > E, ok
;If A < B , ok.  If A > C, ok
;1. is TO edit < Start
	mov	bx,Where2_Number
	cmp	bx,Starting_Number
	jc	mevok
	cmp	bx,Ending_Number
	ja	mevok
	jmp	movcpy_badparams	; Event not found in list, Bailout!
move_events	endp

;----------------------------------------------------------------
mevok	proc	near
	mov	es,Tobin_Seg		; Set to DESTINATION BIN

	call	_kbd_cln
	call	_working

	call	_savebin			; Save the destination bin

	mov	bx,Where2_Number	; Find destination edit
	or	bx,bx			; Adding to a once empty bin?
	jnz	mevok_1			; Jump if NOT
	mov	ax,es:Next_Avail_Num	; Else, get next edit line
	jmps	mevok_2			; Continue

mevok_1:call	_find_edit_BX		; Find the convential existing edit
	mov	Ev2ret2,ax

	jz	mevok_2			; Z=1 if found
	jmp	movcpy_badparams	; Event not found in list, Bailout!

;================================================================
mevok_2:call	emvidx			;Index to the destination (AX)
					; event and make room to insert
					; an event there

	jcxz	mevok_5			; Jump if no lines to move

;Move CL number of lines (1 or 2) to the destination address
	mov	di,Move_Adr
	mov	si,Current_Event_Adr	; Get source edit address

	push	ds			; Save data segment
	mov	es,Tobin_Seg
	mov	ds,Frombin_Seg		; Set FROM and TO segment addresses

	push	cx
mevok_3:push	cx			; Save the "TO" event number
	mov	cx,(line_length / 2)
	cld
	rep movsw
	pop	cx
	loop	mevok_3
	pop	cx
	pop	ds

	mov	es,Frombin_Seg
mevok_4:cmp	Copy_Flag,0ffh		; Don't delete if COPYing
	jz	mevok_5
	call	_delete			; Delete old lines if MOVEing
	loop	mevok_4

mevok_5:mov	es,Tobin_Seg
	cmp	Tobin_Flag,0ffh		; Moving to another bin?
	jz	mevok_6			; Jump if so
	cmp	Copy_Flag,0ffh		; Renumber for COPY?
	jnz	mevok_7

mevok_6:mov	dx,es:Next_Edit
	inc	es:Next_Edit
	mov	bx,Move_Adr
	mov	es:[bx],dx
	FLAGBITS dblline_Fmask
	jz	mevok_7
	mov	es:line_length[bx],dx

mevok_7:mov	es,Frombin_Seg
	mov	dx,Ending_Number	; Check to see if we are done
	mov	bx,Starting_Number
	cmp	bx,dx			;BX=starting number, DX=ending number
	jz	mevok_8			; Is BX=DX
	inc	bx
	mov	Starting_Number,bx	; Increment source edit number
	jmp	mevok_2			; Move some more

mevok_8:cmp	Tobin_Flag,0ffh
	jnz	range_reset
mevok	endp

;................................................................
movcpy_switchbins	proc	near
	push	Cursor
	cmp	Fullscreen_Flag,0ffh	; If Fullscreen_Flag is FALSE,
	jnz	mcsb_1			; then switch bins, update screen
	call	SS_toggle		; Else, switch bins only
	jmp	mcsb_2
mcsb_1:	call	switch_bins
mcsb_2:	pop	Cursor
	ret
movcpy_switchbins	endp

reset2frombin	proc	near
	mov	es,Edl_Seg
reset2frombin	endp
range_reset	proc	near
	mov	bx,Ev2ret2
	call	_find_edit_BX
	call	_EDL_display
movexit:ret
range_reset	endp

; Jump here if event number specified not found
movcpy_badparams	proc	near
	call	reset2frombin
	ERROR	bad_parameters, ERET_Keyboard
movcpy_badparams	endp

;................................................................
;Index to the destination (AX) event and make room to insert an event there
emvidx	proc	near
	xor	cx,cx			; Set "lines to move" counter

	mov	es,Frombin_Seg
	mov	bx,Starting_Number	; See if we can find the source
	call	_find_edit_BX		;  event in the list
	jnz	emvidx9			; Exit if NOT FOUND

	inc	cx			; One line to move
	inc	ax			;  and pass over
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	emvidx2			; Dbl line if NZ
emvidx1:inc	cx			; Second line to move
	inc	ax			;  and pass over
emvidx2:cmp	ax,es:Next_Avail_Num	; End of list?
	jnc	emvidx3
	call	_index_storage
	jc	emvidx1

emvidx3:mov	es,Tobin_Seg
	mov	bx,Where2_Number	; Index to destination event
	or	bx,bx			; Adding to an empty BIN?
	jnz	emvidx6			; Skip if not
	mov	ax,es:Next_Avail_Num
	cmp	ax,es:Max_Lines
	jbe	emvidx4
	ERROR	out_of_memory, ERET_Keyboard

emvidx4:call	_index_storage
	mov	Move_Adr,bx
	push	cx
emvidx5:inc	es:Next_Avail_Num
	loop	emvidx5
	jmps	emvidx8

emvidx6:call	_find_edit_BX		;  and save the destination
	mov	Move_Adr,bx		;  address
	push	cx			; Save # of events to move
emvidx7:call	_make_room		; Make a place for
	loop	emvidx7			;  the proper number of lines

emvidx8:mov	es,Frombin_Seg
	pop	cx
	mov	bx,Starting_Number
	call	_find_edit_BX		; Index back to the source
emvidx9:ret
emvidx	endp

;================================================================
;Clear out the EDL
clear_event_list	proc	near
	call	_check4edl
	jz	celx
	mov	bx,offset clear_list_ovr
	call	no_chos_msg
	jc	celabrt
	jnz	celx
	call	_clear_list
celx:	ret
celabrt:mov	ERROR_ACTIVE,0
	jmp	Keyboard
clear_event_list	endp


;open end the edit
open_end	proc	near
	mov	al,Trans_Type
	cmp	al,'C'
	jz	open_cut
	cmp	al,'S'
	jz	open_cut

	mov	al,Current_Source
	mov	ah,Current_Machine
	push	ax			; Save current source & machine
	mov	al,To_Machine
	call	Machine_Change
	call	_clear_outs
	pop	ax
	push	ax
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
	jmps	open_z

open_cut:
	call	_clear_outs
open_z:	call	_compute
	jmp	Trans_Upd
open_end	endp

;================================================================
; Force recall of event
fevent_recall	proc	near
	call	_check4edl
	jz	fereret
	mov	ax,es:Current_Event
	call	_index_storage
	jc	fereret
	mov	al,Current_Source
	push	ax

	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	fere1
	call	_match4recall
	jmp	fere2
fere1:	call	_matchforcedrecall
fere2:	pop	ax
	jnc	event_recall
	call	Machine_Change
	mov	bx,Current_Event_Adr
	add	bx,offset ZeroBase.reel_lofst
	mov	dx,Current_Reel_Adr
	mov	ch,reel_length
	call	_mmv_ESDS
	call	_upd_getrel
	call	event_recall
fereret:ret
fevent_recall	endp

;================================================================
;recall event from list to active cell
event_recall	proc	near
	call	_check4edl
	jz	evtned
	call	_SaveWorkspace		; Save workspace for possible W/UNDO
	mov	ax,es:Current_Event
	call	_line_first
	call	_index_storage
	jc	evtned
	call	_evnt_dispthis

evtnadj:call	_match4recall
	jnc	evradj2
	ERROR	no_reel_match, ERET_Keyboard
evtned:	ret

evradj2:mov	ax,es:Current_Event
	call	_index_storage
	jc	evtned			; Can't recall a comment
	mov	Last_Recalled,ax
	call	recall_line		; Get a line

; Check for double line event, if NOT, we're done.
	mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	JL0955			; Double line if NZ

;4-01-1994 
	mov	al,Current_Source
	mov	To_Machine,al
;...
	jmp	recalx

; Recall second half of effect
JL0955:	mov	al,Current_Source

; If KEY, then set key background source
	cmp	Trans_Type,'K'
	jnz	JL0956
	mov	Keybkgnd_Src,al
	jmps	JL0957

; If NOT KEY, set from machine
JL0956:	mov	From_Machine,al

; Index to second event line of this edit
JL0957:	mov	ax,es:Current_Event
	push	ax
	inc	ax
	call	_index_storage

; Check for SPLIT EDIT
	FLAGBITS split_Fmask		; Test for SPLIT EDIT (NZ)
	jz	JL0958
	jmp	split_recall		; jump if split edit

; Save R_Tc.tcIN, recall next line, restore R_Tc.tcIN
JL0958:	mov	bx,offset R_Tc.tcIN	; Save line 1's in point
	mov	dx,offset Addtc_Buf
	push	bx			; Save R_Tc.tcIN
	push	dx			; Save Addtc_Buf
	push	ax			; Save event number
	call	_mmv3byt
	pop	ax			; Restore event number

	call	recall_line		; Get second line

	pop	bx			; Restore Addtc_Buf as source
	pop	dx			; Restore R_Tc.tcIN as destination
	call	_mmv3byt

recalsx:mov	al,Current_Source
	cmp	Trans_Type,'K'		; Check for key
	jnz	recalse
	mov	Keyfor_Src,al

; Determine Key_Mode type 0=KEY ON, 1=KEY IN, 2=KEY OUT
	mov	bx,Current_Event_Adr
	mov	al,1			; In case of KEY FADE IN
	test	es:byte ptr [bx].keyFlags_lofst,fadein_Kmask
	jnz	rclkmod
	mov	al,2			; In case of KEY FADE OUT
	test	es:byte ptr [bx].keyFlags_lofst,fadeout_Kmask
	jnz	rclkmod
	mov	al,0
rclkmod:mov	Key_Mode,al

	call	_clear_pout
	call	_clear_pdur
	jmps	recalsk
	
recalse:mov	To_Machine,al
recalsk:pop	ax
	call	_index_storage

recalx:
	call	_clear_rdur
	call	_clear_rout
	call	_ReCompute_EFX

	call	gpi_alloff
	call	recall_Extras

	call	_ReCompute_EFX

	call	priority_adjust
	call	all_locations
	call	_draw_machines

	call	_upd_getrel

	call	_mode_upd
	call	_upd_gettcf
	call	_upd_getscr
	call	_time_upd
	call	Gpi_Upd
	CALL	Pmc_Upd
	CALL	Spd_Upd
	call	Preread_UPD
	call	ramp_upd

	cmp	Assemble_Flag, 0
	jnz	eventrx
	mov	al,Current_Machine
	call	Machine_Take
eventrx:jmp	Trans_Upd
event_recall	endp

;----------------------------------------------------------------
recall_Extras	proc	near
	mov	ax,es:Current_Event	; Save current event
	push	ax
	mov	ch,Current_Machine
	mov	cl,Current_Source
	push	cx

	mov	Preread_State,0

	and	Pmc_Flags,not Enabled_MSBIT
	and	Spd_Flags,not Enabled_MSBIT
	and	MultRec_Flags,not Enabled_MSBIT
	call	clear_spdtbl
	call	reset_editspeed

	and	Gpi_Flags,not Enabled_MSBIT
	mov	bx,0ffffh
	mov	si,offset Slave_Table
	mov	[si],bx
	inc	si
	mov	di,offset Multrecord_Table
	mov	[di],bl

rclext1:mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	rclext2
	inc	ax
rclext2:inc	ax
	cmp	ax,es:Next_Avail_Num
	jae	rclextx
	call	_index_storage

	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT	;EDIT?
	jz	rclextx

; CHECK FOR SPECIAL EDIT LINES
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_GPI	;GPI?
	jnz	rclext3
	call	recall_gpi
	jmps	rclext1

rclext3:cmp	es:byte ptr [bx].cmnt_lofst,Editline_SLAVE	;Slave?
	jnz	rclext4
	call	recall_slaves
	jmps	rclext1

rclext4:cmp	es:byte ptr [bx].cmnt_lofst,Editline_SPD 	;SPD?
	jnz	rclext2a
	call	recall_spd
	jmp	rclext1
rclext2a:
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_PMC 	;PMC
	jnz	rclext2b
	call	recall_pmc
	jmp	rclext1
rclext2b:
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_REC 	;REC
	jnz	rclext2c
	call	recall_rec
	jmp	rclext1
rclext2c:
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_RAMP
	jnz	rclext2d
	call	recall_ramp
	jmp	rclext1
rclext2d:
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_PREREAD
	jnz	rclext2e
	call	recall_preread
	jmp	rclext1
rclext2e:

rclextx:pop	ax
	push	ax
	call	Machine_Change
	pop	ax
	mov	al,ah
	call	Machine_Change
	pop	ax
	call	_index_storage
	ret
recall_Extras	endp

recall_gpi	proc	near
	push	ax
	mov	al,es:[bx]		; Get the GPI number
	cbw
	call	gpi_index
	mov	dx,bx			; GPI address to DX
	mov	bx,Current_Event_Adr
	add	bx,offset ZeroBase.GPI_lofst
	mov	ch,GPI_length
	call	_mmv_ESDS
	or	Gpi_Flags,Enabled_MSBIT
	pop	ax
	ret
recall_gpi	endp

;================================================================
recall_rec	proc	near
	push	ax			; Save event number
	push	si
	mov	si,di
; Get multrecord DEVICE information
	call	_getlast_reel
	call	_match_master
	jnz	rclrec_error		; ERROR IF NO MATCH

	mov	al,cl
	push	di
	mov	di,offset Multrecord_Table
	call	Check_TrimLink
	pop	di
	jc	rclrec1
	mov	ch,0ffh			; Use MSB as terminator
	mov	ds:[si],cx		; Save multrecord DEVICE TO multrecord TABLE
	inc	si			; Increment pointer to multrecord table

rclrec1:mov	al,cl
	call	rclslv_CheckNoSet
	jz	rclrec2

	call	Machine_Change		; SET multrecord DEVICE
	call	_get_in			; Point to IN POINT
	mov	dx,bx			; Move the time code
	call	_getlast_pin		;  from EDL to multrecord IN
	call	_mmv3_es2ds
	call	_get_out
	call	_clear_tc
	call	_get_dur
	call	_clear_tc

rclrec2:or	MultRec_Flags,Enabled_MSBIT
	mov	di,si
	pop	si
	pop	ax
	ret

rclrec_error:
	ERROR	no_reel_match, ERET_Keyboard

recall_rec	endp




;================================================================
recall_slaves	proc	near
	push	ax			; Save event number
	push	di			; Save Multrecord_Table pointer
; Get SLAVE DEVICE information
	call	_getlast_reel
	call	_match_master
	jnz	rclslv_error		; ERROR IF NO MATCH

	mov	al,cl
	mov	di,offset Slave_Table
	call	Check_TrimLink
	jc	rclslv1
	mov	ch,0ffh			; Use MSB as terminator
	mov	[si],cx			; Save SLAVE DEVICE TO SLAVE TABLE
	inc	si			; Increment pointer to slave table

rclslv1:mov	al,cl
	call	rclslv_CheckNoSet
	jz	rclslv2

	call	Machine_Change		; SET SLAVE DEVICE
	call	_get_in			; Point to IN POINT
	mov	dx,bx			; Move the time code
	call	_getlast_pin		;  from EDL to SLAVE IN
	call	_mmv3_es2ds
	call	_get_out
	call	_clear_tc
	call	_get_dur
	call	_clear_tc

; Get MASTER DEVICE information
rclslv2:call	_getlast_reel
	add	bx,reel_length
	call	_match_master
	jnz	rclslv_error		; ERROR IF NO MATCH

	mov	byte ptr Slave_Table,cl	; Save device
	mov	al,cl
	call	rclslv_CheckNoSet
	jz	rclslv5

	call	Machine_Change		; SET SLAVE DEVICE
	call	_get_in			; Point to IN POINT
	mov	dx,bx			; Move the time code
	call	_getlast_rin		;  from EDL to SLAVE IN
	call	_mmv3_es2ds
rclslv5:or	Slave_Flags,Enabled_MSBIT
	pop	di
	pop	ax
	ret

rclslv_error:
	ERROR	no_reel_match, ERET_Keyboard


; See if this is a legal slave
; Z=1 if NOT legal slave device
rclslv_CheckNoSet:
	cmp	Trans_Type,'D'
	jz	rclcnse
	cmp	Trans_Type,'W'
	jz	rclcnse
	cmp	Trans_Type,'K'
	jz	rclcnsk
	cmp	al,Current_Source	;To_Machine 11-20-1991 nhs
rclcnsr:jz	rclcnsx			; Return right away if already found
	or	al,al			; else, is it the Record machine?
rclcnsx:ret

rclcnse:cmp	al,From_Machine
	jz	rclcnsr
	cmp	al,To_Machine
	jmp	rclcnsr

rclcnsk:cmp	al,Keyfor_Src
	jz	rclcnsr
	cmp	al,Keybkgnd_Src
	jmp	rclcnsr
recall_slaves	endp


;================================================================
recall_spd	proc	near
	push	si			; SI is used elsewhere for slave table
	push	ax			; Save event number
	push	bx			; Save event address
	call	_match_reels		; Returns CL = VTR#
	jz	rclspd1
	ERROR	no_reel_match, ERET_Keyboard

rclspd1:mov	al,cl
	call	_index2edspeed		; Index to Vtrcb speed table
	mov	si,bx
	pop	bx
	mov	al,es:[bx].SPD_lofst
	mov	[si],al			; Save speed
	pop	ax
	pop	si
	or	Spd_Flags,Enabled_MSBIT
	ret
recall_spd	endp

;================================================================
recall_pmc	proc	near
	push	si			; SI is used elsewhere for slave table
	push	ax			; Save event number

	push	bx			; Save event address
	call	_match_reels		; Returns CL = VTR#
	jz	rclpmc1
	ERROR	no_reel_match, ERET_Keyboard

rclpmc1:mov	ch,MAX_SPEED_CHANGES	; Max number of buffers
	mov	si,offset Progmotion_Tbl
rclpmc2:cmp	byte ptr [si],0ffh
	jz	rclpmc3
	add	si,SIZE VARSPEEDCHANGE
	dec	ch
	jnz	rclpmc2
	call	_error_bell
	jmp	Keyboard

rclpmc3:pop	bx			; ES:BX is line
	mov	[si],cl			; Save machine
	inc	si
	add	bx,offset ZeroBase.SPD_lofst + 1	; Point to rest of descriptor
	mov	dx,si			; Destination buffer pointer
	mov	ch,SIZE VARSPEEDCHANGE - 1
	call	_mmv_ESDS
	or	Pmc_Flags,Enabled_MSBIT
	pop	ax
	pop	si
	ret
recall_pmc	endp


;================================================================
recall_ramp	proc	near
	push	si			; SI is used elsewhere for slave table
	push	ax			; Save event number

	push	bx			; Save event address
	call	_match_reels		; Returns CL = VTR#
	jz	rclrmp
	ERROR	no_reel_match, ERET_Keyboard

rclrmp:	pop	bx			; ES:BX is line
	add	bx,offset ZeroBase.extra_lofst	; Point to rest of descriptor
	mov	dx,offset RampSpeedChange ; Destination buffer pointer
	mov	ch, SIZE RAMPSPEED
	call	_mmv_ESDS
	or	Ramp_Flags,Enabled_MSBIT
	pop	ax
	pop	si
	ret
recall_ramp	endp

;================================================================
recall_preread	proc	near
	mov	Preread_State,0ffh
	ret
recall_preread	endp


;================================================================
split_recall	proc	near
	xor	al,al
	call	Machine_Change
	call	_clear_pdur
	call	_clear_pout

; Split delay = last in - [Current_Inbuf]
	call	_getlast_pin
	call	_entime_move_ES
	mov	bx,Current_Inbuf
	call	_Sttime_move
	call	_timdif		;TIMDIF  ====>	Entime - Sttime = Elaptm
	mov	dx,offset Split_Delay
	call	_mmv3byt

; Duration = last out - [Current_Inbuf]
	call	_getlast_pout
	call	_entime_move_ES
	mov	bx,Current_Inbuf
	call	_Sttime_move
	call	_timdif		;TIMDIF  ====>	Entime - Sttime = Elaptm

; Move to record duration
	mov	dx,offset R_Tc.tcDUR
	call	_mmv3byt

; R_Tc.tcOUT = R_Tc.tcIN + duration
	mov	bx,offset R_Tc.tcIN
	call	_Sttime_move
	call	_timadd		;TIMEADD ====>	Sttime + Elaptm = Entime
	mov	dx,offset R_Tc.tcOUT
	call	_mmv3byt

	call	_ReCompute_CUT

	mov	al,Mode_Flag		; Get and save
	mov	Split_Mode,al		;  the non-delayed portion
	call	_getlast_mode
	mov	al,es:[bx]
	mov	Mode_Flag,al

	mov	Trans_Type,'S'		; Set for split edit
	mov	al,Split_Mode		; Combine the
	or	Mode_Flag,al		;  edit modes
	test	al,video_Emode		; Test for delayed video
	mov	al,not video_Emode	; Set, in case of video delay
	jz	rcl_sv
	mov	al,not audall_Emode	; Set for delayed audio
rcl_sv:	mov	Split_Mode,al		; Set correct split mode
	call	_mode_upd
	mov	al,Current_Source
	call	Machine_Change
	jmp	recalsx
split_recall	endp

;================================================================
; "Pull" an edit out of the list into the workspace
;  Return Carry set if comment
recall_line	proc	near
	call	_index_storage
	jnc	JL0960
	ret				; Carry set if comment

; Check for existence of proper reel, error if not found
JL0960:	call	_match_reels
	jz	recall1
	ERROR	no_reel_match, ERET_Keyboard

recall1:mov	al,cl			; Switch to proper machine
	call	Machine_Change

; Have BX point to current event
	mov	bx,Current_Event_Adr

; Recall the color frame Flag information for source VTRs
	or	al,al
	jz	recall2
	push	si
	cbw
	MULTIPLY_BY Vtrcb_length, AX
	mov	si,offset Vtrcb
	add	si,ax
	mov	ax,es:[bx].Flags_lofst
	and	ax, cfbits_Fmask	; Mask out for lower three bits
	mov	[si.Vtrcb_CF],al
	pop	si

; Recall and save the edit mode
recall2:mov	al,es:[bx].mode_lofst	; Get mode
	mov	Mode_Flag,al		; Save mode

; Recall and save transition type
	mov	al,es:[bx].type_lofst
	mov	Trans_Type,al

	cmp	al,'K'
	jz	recall2a
	cmp	al,'W'
	jnz	recall2b
; Save effect/wipe code
recall2a:
	mov	ax,es:[bx].efxnum_lofst	; Get wipe code
	mov	Trans_Code,ax		; Save wipe code

recall2b:
; Save effect duration
	mov	ax,es:[bx].efxdur_lofst	; Get duration
	cmp	Trans_Type,'C'		; check for cut
	jz	JL0980

; Save KEY trans information
recall2c:
	mov	Key_Trans,ax

JL0970:	mov	Trans_Length,ax		; Save duration

JL0980:	call	Idx2tcf
	push	bx
	call	_getlast_ptcd
	mov	al,es:[bx]
	pop	bx
	mov	[bx],al

	call	_getlast_rtcd
	mov	al,es:[bx]
	cmp	Rtcf,al			; Change in RECORD-VT FCM?
	jz	JL0981
	cmp	Rtcf,' '		; Just beginning?
	mov	Rtcf,al
	jz	JL0981
	ERROR	RVTR_FCM_change, ERET_Quick

JL0981:

;Move the In and Out points to the appropriate workspace registers
	mov	dx,Current_Inbuf
	call	_getlast_pin
	call	_mmv3_es2ds
	mov	dx,Current_Outbuf
	call	_getlast_pout
	call	_mmv3_es2ds

	call	_getlast_rin
	mov	dx,offset R_Tc.tcIN
	call	_mmv3_es2ds
	call	_getlast_rout
	mov	dx,offset R_Tc.tcOUT
	call	_mmv3_es2ds

	mov	bx,offset R_Tc.tcOUT
	call	_Entime_move
	mov	bx,offset R_Tc.tcIN
	call	_Sttime_move
	call	_timdif
	mov	dx,offset R_Tc.tcDUR
	call	_mmv3byt

	mov	bx,Current_Outbuf
	call	_Entime_move
	mov	bx,Current_Inbuf
	call	_Sttime_move
	call	_timdif
	mov	dx,Current_Duration
	call	_mmv3byt
	ret
recall_line	endp


; Adjust for priority recall
priority_adjust	proc	near
	mov	al,Priority_Flag	; FE = none, FF = play, 0 = rec
	inc	al			; Play priority?
	jz	recrclr
	inc	al			; No priority?
	jz	rgpret
	call	_clear_pout		; Record priority
	call	_clear_pdur
rgpret:	ret
recrclr:call	_clear_rout
	call	_clear_rdur
	ret
priority_adjust	endp

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; 10-08-1990 fixed delete with ripple
;================================================================
;delete an event from the list
delete_event	proc	near
	call	_check4edl
	jz	dex

	mov	bx,offset delete_ovr	; Prompt for confirmation
	call	_kbd_cln
	call	_msgread
	call	rdchar			; Get response
	cmp	ax,offset Thisevent_xcmd; Delete THISEVENT?
	jz	delnr			;  DO IT!

	cmp	ax,offset Yeskey_xcmd	; YES, YES, YES?
	jz	delnr			;  DO IT!

	call	_make_ucase	; Make ASCII character it upper case

;----------
	cmp	al,'B'			; Block delete?
	jnz	de1
	jmp	delete_range
de1:	cmp	al,'M'			; Marked events delete?
	jnz	de2
	jmp	delete_marked
de2:	cmp	al,'A'			; Delete All?
	jnz	de3
	jmp	clear_event_list
de3:	cmp	al,'Y'			; Confirm delete this edit?
	jz	delnr
dex:	ret				; Return if not

;================================================================
; DELETE THE CURRENT EVENT
delnr:	call	_savebin			; Protect the bin to BIN3

; Check for valid edit.
;  If not and edit, immediatly delete the line and Exit
	mov	bx,Current_Event_Adr
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_EDIT ; Check for valid EDIT line
	jz	delnrA
	call	_delete			; Delete one comment
	call	_evnt_dispthis
	ret

; Must be an edit:
delnrA:	mov	ax,es:Current_Event
	mov	Block_Start,ax
	mov	Block_End,ax
	call	Set4DelRipple		; Store this R_DUR for ripple
	or	al,al			; AL=0 if ripple off
	jz	delnr1

	call	_Check4MoreEvents	; Is this the last event?
	jnc	delnr1			; Jump if LAST EVENT

	mov	bx,offset ripple_ovr	; Ask operator Y/N?
	call	no_chos_msg
	jz	delnr2

delnr1:	mov	Ripple_Flag,0		; Turn ripple off

delnr2:	mov	ax,es:Current_Event	; Keep tabs on all lines
	call	_index_storage
	call	_notate_Extras		;  involved in this edit

	mov	dx,es:[bx].Flags_lofst	; Save the FlagS byte and

	call	_delete			; Delete current line
	test	dx,dblline_Fmask	; Was it a dbl line edit?
	jz	JL1015			; Just one line if Z=1
	call	_delete
JL1015:	call	delete_gpislv		; Delete any following Extras

	cmp	Ripple_Flag,0
	jz	delnrpl

	push	ax			; Save event number
	mov	ax,es:Current_Event	; Set up parameters
	mov	Shiftstart_Edit,ax	;  for ripple
	mov	ax,es:Next_Avail_Num
	dec	ax
	mov	Shiftend_Edit,ax
	mov	dl,MINUS_ASCII			; Set negative trim
	mov	bx,offset Rvtr_Ripple
	call	ripple			; Ripple list
	pop	ax			; Restore event number

delnrpl:call	_event_display
	ret
delete_event	endp

;----------------------------------------------------------------
delete_gpislv	proc	near
	mov	cx,Extras
	jcxz	dgsret
dgpislv:call	_delete
	loop	dgpislv
dgsret:	ret
delete_gpislv	endp


;================================================================
;		BLOCK EDIT DELETE
;================================================================
delete_range	proc	near
	mov	bx,offset delete_qry
	call	get_range
	push	ax			; Save current event

delran2:mov	bx,offset delete_qry
	call	_kbd_cln
	call	_msgread
	mov	al,':'
	call	_ConOut
	call	_Space_Out
	mov	bx,offset frommsg_ovr
	call	_msgread
	mov	bx,Starting_Number
	call	_DecOut
	call	_Space_Out
	mov	bx,offset tomsg_ovr
	call	_msgread
	mov	bx,Ending_Number
	call	_DecOut
	call	_Space_Out
	mov	bx,offset Areusure	; Last Chance
	mov	cl,'N'
	call	_comsg
	call	yn_chos
	JMP_NZ	delranx

	call	Set4DelRipple		; Store this R_DUR for ripple
	or	al,al			; AL=0 if ripple off
	jz	delran3

	call	_Check4MoreEvents	; Is this the last event?
	jnc	delran3			; Jump if LAST EVENT

	mov	bx,offset ripple_ovr	; Ask operator Y/N?
	call	no_chos_msg
	jz	delran4

delran3:mov	Ripple_Flag,0		; Turn ripple off

delran4:call	_kbd_clr
	mov	bx,offset pointer_ovr
	call	_msgread
	mov	bx,offset deleting_ovr
	call	_msgread
	call	_savebin	; Protect the bin to BIN3

delranl:mov	bx,Starting_Number
	push	bx			; Save starting number
	mov	ax,bx
	call	_evnum

	call	_find_edit_BX	; Find the edit,
	jnz	nodelr			; Error if not found

	call	_notate_Extras

	mov	dx,es:[bx].Flags_lofst	;  Get Flags
	call	_delete			; Delete event
	test	dx,dblline_Fmask	; Check for dbl line
	jz	nodelr			;  Skip if not
	call	_delete			; Delete second line

nodelr:	call	delete_gpislv		; Delete any following Extras
	pop	dx			; Restore starting number
	inc	dx			; Increment it
	mov	Starting_Number,dx	; And put it back.
	mov	bx,Ending_Number	; Number of last event to delete
	cmp	bx,dx			; Is Last event < current?
	jnc	delranl			; If no less, continue

	cmp	Ripple_Flag,0
	jz	delranx

	push	ax			; Save event number
	mov	ax,es:Current_Event	; Set up parameters
	mov	Shiftstart_Edit,ax	;  for ripple
	mov	ax,es:Next_Avail_Num
	dec	ax
	mov	Shiftend_Edit,ax
	mov	dl,MINUS_ASCII			; Set negative trim
	mov	bx,offset Rvtr_Ripple
	call	ripple			; Ripple list
	pop	ax			; Restore event number

delranx:pop	ax			; Restore current event
	call	_event_display
	ret
delete_range	endp

;================================================================
;		DELETE MARKED EVENTS
;================================================================
delete_marked	proc	near
	mov	bx,offset delmrkd_ovr
	mov	cl,'N'
	call	pos_yn_chos
	JMP_NZ	delm_r

	call	_savebin			; Protect bin
	push	es:Current_Event	; Save the current event number
	xor	ax,ax			; Use AX as event counter
	mov	cx,ax			; Use CX as a #deletes counter
	inc	ax			; Start at first event

; Find the first occurance of a marked edit
delm_1:	call	_index_storage
	jc	delm_1a
	FLAGBITS sort_Fmask
	jnz	delm_lp
delm_1a:inc	ax
	cmp	ax,es:Next_Avail_Num
	jc	delm_1
	pop	ax
	call	_event_display
	ERROR	nomarked_error, ERET_Keyboard

delm_lp:push	ax			; Save event number
	push	cx			;  and counter
	call	_index_storage		; Index to edit in AX
	FLAGBITS sort_Fmask
	jz	delm_4
	call	_notate_Extras
	mov	dx,es:[bx].Flags_lofst	;  Get Flags
	call	_delete			; Delete event
	test	dx,dblline_Fmask	; Check for dbl line
	jz	delm_3			;  Skip if not
	call	_delete			; Delete second line

delm_3:	call	delete_gpislv		; Delete any following Extras
	pop	cx
	pop	ax
	jmp	delm_4a

delm_4:	pop	cx
	pop	ax
	inc	ax
delm_4a:inc	cx
	cmp	ax,es:Next_Avail_Num
	jc	delm_lp

delm_5:	pop	ax			; Restore current event
	call	_event_display
delm_r:	ret
delete_marked	endp


;================================================================
;		SETUP FOR POSSIBLE RIPPLE
; Set parameters up for an INSERT ripple
;  R_Tc.tcIN	 -> Rvtr_In
;  R_Tc.tcOUT	 -> Rvtr_Out
;  R_Tc.tcDUR -> Rvtr_Dur
;
;  edl RIN	 -> Edl_In
;  edl ROUT	 -> Edl_Out
;  edl RDUR	 -> Edl_Dur
; AX,BX,CX,DX are used
; Exit: AL = ripple Flag, 0 or 0ffh
;	ES:BX points to current event
Set4Ripple	proc	near
	mov	ax,es:Current_Event	; Get and save current event
	push	ax
	call	ToRippleOrNot		; Check for no edits to ripple
	jnc	s4rplx

	mov	ch,9			; Nine bytes (24 bits * 9) to move
	mov	bx,offset R_Tc.tcIN
	mov	dx,offset Rvtr_In
	call	_mmv

; Save the record IN, OUT and DUR points from current event
	mov	si,offset Edl_In
	call	SaveEDLDeleteValues

s4rplx:	pop	ax
	call	_index_storage
	mov	al,Ripple_Flag
	ret
Set4Ripple	endp


;================================================================
;		SETUP FOR POSSIBLE DELETE RIPPLE
; (NOTE: no need to check for comment.
;	 Already checked for prior to entry to this routine
;
; Set parameters up for a ripple:
; FROM EVENT TO BE DELETED
;  EDL RIN	 -> Rvtr_In
;  EDL ROUT	 -> Rvtr_Out
;  EDL RDUR	 -> Rvtr_Dur
;
; FROM EVENT AFTER DELETED EVENT(S)
;  edl RIN	 -> Edl_In
;  edl ROUT	 -> Edl_Out
;  edl RDUR	 -> Edl_Dur
; AX,BX,CX,DX are used
; Exit: AL = ripple Flag, 0 or 0ffh
;	ES:BX points to current event
Set4DelRipple	proc	near
	mov	Ripple_Flag,0		; Default to NO ripple
	mov	ax,es:Current_Event	; Get and save current event
	push	ax

	mov	ax,Block_Start
	call	ToRippleOrNot		; Check for no edits to ripple
	jnc	s4drx

; GET INFORMATION FROM THE FIRST EVENT(S) TO BE DELETED
	mov	si,offset Rvtr_In
	call	SaveEDLDeleteValues

;----------------------------------------------------------------
; GET INFORMATION FROM THE EVENT AFTER THE LAST EVENT TO BE DELETED
	mov	ax,Block_End		; Get last edit to be deleted
	call	_index_storage
	call	_advance2next		; Find next edit after it (if any)
	jnz	s4dr2a			; NZ if edit FOUND

	mov	Ripple_Flag,0		; Bail out if no more edits
	jmp	s4drx

s4dr2a:	call	_index_storage

; Save the record IN, OUT and DUR points from current event
; GET INFORMATION FROM THE FIRST EVENT(S) TO BE DELETED
	mov	si,offset Edl_In
	call	SaveEDLDeleteValues

; Set Rvtr_Ripple to ñ(Edl_In - Rvtr_In)
	mov	bx,offset Edl_In	; Set Rvtr_Ripple to
	call	_Entime_move		;  ñ (Edl_In - Rvtr_In)
	mov	bx,offset Rvtr_In
	call	_Sttime_move
	call	_timdif

	mov	dx,offset Rvtr_Ripple
	call	_mmv3byt

s4drx:	pop	ax
	call	_index_storage
	mov	al,Ripple_Flag
	ret
Set4DelRipple	endp

;................................................................
;Check for no edits to ripple
; ENTER: AX = first event to be deleted
; Return with C=1 (SET) if OK to ripple
; Ripple_Flag is set to TRUE if C=1
ToRippleOrNot	proc	near
	mov	Ripple_Flag,0		; Default to NO ripple
	call	_index_storage		; Check for
	FLAGBITS dblline_Fmask		;  double line
	jz	tron_1			; And check
	inc	ax			;  if this
tron_1:	inc	ax			;  is the
	cmp	ax,es:Next_Avail_Num	;  last event?
	jnc	tron_x			; Don't bother if last event
	call	_Check4MoreEvents	; Carry = 1 if more edits
	jnc	tron_x			; Jump if no more real edits
	mov	Ripple_Flag,0ffh	; ELSE, Lets RIPPLE, BABY!
tron_x:	ret
ToRippleOrNot	endp


;................................................................
; Save	Rvtr_In, _OUT, and _DUR,
;	or Edl_In, _OUT, and _DUR
;
; ENTER: SI points to DS: buffer for IN, OUT and DURATION
; Exit: EDL values moved to DS: buffer, EDIT duration calculated
SaveEDLDeleteValues	proc	near
	call	_getlast_rin
	mov	dx,si			; DX points to Rvtr_In or Edl_In
	push	dx			;  put it on stack
	call	_mmv3_es2ds		; Save value to DS: buffer

	mov	bx,Current_Event_Adr	;  point from record
	FLAGBITS dblline_Fmask		;  even if its an effect
	jz	s4dr2
	add	bx,line_length		; Point to same position, next line

s4dr2:	add	bx,offset ZeroBase.rout_lofst	; Get out from last line
	mov	dx,si			;  of the event
	add	dx,3			; DX points to Rvtr_Out or Edl_Out
	push	dx			;  put it on stack
	call	_mmv3_es2ds

	pop	bx			; Pop off Rvtr_Out or Edl_Out
	call	_Entime_move		; Calculate duration of this edit
	pop	bx			; Pop off Rvtr_In or Edl_In
	call	_Sttime_move
	call	_timdif
	mov	dx,si
	add	dx,6			; Point to Rvtr_Dur or Edl_Dur
	call	_mmv3byt
	ret
SaveEDLDeleteValues	endp


;================================================================
; IF REPLACE
;	if Rvtr_Dur == Edl_Dur
;		NO RIPPLE
;	if Rvtr_In == Edl_In
;		Set Rvtr_Ripple to ñ (Rvtr_Out - Edl_Out)
; 
; IF INSERT
;	if Rvtr_In == Edl_In
;		Set Rvtr_Ripple to ñ(Rvtr_Out - Edl_In)

; Exit: Z=1 if NOT TO RIPPLE (ripple Flag=0)
Check4Ripple	proc	near
	mov	Ripple_Flag,0		; Normal to NO ripple
	call	_Check4MoreEvents	; Returns C=0 if last edit
	jnc	c4rplx

	cmp	Evnt_Insert_Flag,0ffh	; Inserting?
	jz	c4r_insert
	cmp	Evnt_Replace_Flag,0ffh	; Replaceing?
	jnz	c4rplx

;________ REPACE EVENT RIPPLE
	mov	bx,offset Rvtr_Dur
	mov	dx,offset Edl_Dur
	call	_cmp24b
	jz	c4rplx			; No ripple if durations are same
	mov	bx,offset Rvtr_In
	mov	dx,offset Edl_In
	call	_cmp24b
	jnz	c4rplx			; No ripple if INs are different

	mov	bx,offset Rvtr_Out	; Set Rvtr_Ripple to
	call	_Entime_move		;  ñ (Rvtr_Out - Edl_Out)
	mov	bx,offset Edl_Out
	call	_Sttime_move
	call	_timdif
	mov	dx,offset Rvtr_Ripple
	call	_mmv3byt
	jmp	c4rron
	Check4Ripple	endp

c4r_insert	proc	near
	mov	bx,offset Rvtr_In
	mov	dx,offset Edl_In
	call	_cmp24b
	jnz	c4rplx			; No ripple if INs are different

; Set Rvtr_Ripple to ñ(Rvtr_Out - Edl_In)
	mov	bx,offset Rvtr_Out	; Set Rvtr_Ripple to
	call	_Entime_move		;  ñ (Rvtr_Out - Edl_In)
	mov	bx,offset Edl_In
	call	_Sttime_move
	call	_timdif
	mov	dx,offset Rvtr_Ripple
	call	_mmv3byt

c4rron:	mov	Ripple_Flag,0ffh	; Turn in on
c4rplx:	mov	al,Ripple_Flag
	or	al,al
	ret
c4r_insert	endp






;	TIMADD:	Entime = Sttime + Elaptm
;	TIMDIF:	Elaptm = Entime - Sttime

;================================================================
;			S H I F T   E D L
;================================================================
;to ripple the list, first get the new start time
;then get the first start time to be changed
;develop an offset between the old and new start times
;offset= old start - new start
;i.e.	1:00:00:00(old start) -  59:55:00(new start = 5:00 (offset)
;next, get then new start time by adding the oldstart to the offset

shift_list	proc	near
	call	_check4edl
	jz	shftlx

	mov	ERROR_ACTIVE,0

	call	Get_ShiftRange

	mov	bx,offset shift_ovr	; Prompt for SHIFT TYPE
	call	_msgread
	call	get_ucase
	call	_Break_check
	jz	shftlx

	mov	Shift_Flag,1		; Set for RECORD SHIFT
	cmp	al,'R'
	JMP_Z	shift_r

	mov	Shift_Flag,2		; Set for SOURCE SHIFT
	cmp	al,'P'
	jz	shift_p

	cmp	al,'S'
	jnz	shftlx
	mov	dx,offset shiftinput_rqst
	xor	al,al
	mov	Shift_Flag,al		; Set for NEW START TIME
	mov	Trim_Ci_Flag,al		; Turn off +/- input enable

;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; 5-21-1992 <>	Must use drop frame calculations for start times
	mov	al,DF_CHAR
;;;;	mov	al,es:Edl_Fcm		; Use EDL FCM for record side
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	jmp	shftq
shftlx:	ret
shift_list	endp

;----------------------------------------------------------------
;________________ SHIFT SOURCE SIDE
shift_p	proc	near
	mov	bx,offset Forreel_Msg	; Get source reel assignment
	call	_kbd_message		;  to shift for
	mov	bx,offset Orall_Msg
	call	_comsg
	mov	al,reel_length
	call	cimsg_wrk
	jz	shftlx			; Bailout if NO INPUT

	mov	cl,al			; Get length of input line to CL
	mov	dx,offset Work_Event	; Convient place to save
	call	_left_set_reel		;  the reel

; Find first occurance of reel in EDL
	push	es:Current_Event
	mov	ax,Shiftstart_Edit	; Start with requested event
shft_P1:call	_index_storage
	mov	si,bx			; Save edit line pointer to SI
	jnc	shft_P2			; OK if edit

	cmp	es:byte ptr [si].cmnt_lofst,Editline_REC
	jz	shft_P2

	cmp	es:byte ptr [si].cmnt_lofst,Editline_SLAVE
	jnz	shft_P3

shft_P2:
	mov	cl,es:byte ptr [si].ptcd_lofst ; Prepare for source side FCM
	cmp	byte ptr Work_Event, '*'; Shift all?
	jz	shft_P4

	call	_getlast_reel		; Last reel pointer to BX and DI
	mov	dx,offset Work_Event	; REEL TO CHANGE
	mov	ch,reel_length
	call	_cmpchr			; Look at SOURCE / SLAVE reel
	mov	cl,es:byte ptr [si].ptcd_lofst ; Prepare for source side FCM
	jz	shft_P4			; Jump if found

	add	bx,reel_length		; Point to MASTER REEL POSITION
;;;	cmp	es:byte ptr [si].cmnt_lofst,Editline_SLAVE ; Slave line?
	call	_cmpchr
	mov	cl,es:byte ptr [si].rtcd_lofst ; Prepare for MASTER side FCM
	jz	shft_P4			; Jump if found

shft_P3:mov	ax,es:Current_Event
	inc	ax
	cmp	ax,Shiftend_Edit	;es:Next_Avail_Num
	jbe	shft_P1
	pop	ax
	call	_event_display
	ERROR	no_reel_match, ERET_Keyboard

; CL has fcm
shft_P4:pop	ax			; Get rid of original edit
	push	cx			; Save CL, it has the FCM
	call	_evnt_dispthis
	pop	ax			; Restore FCM to AL
	mov	dx,offset shiftplay_rqst
	jmp	shftq
shift_p	endp

;________________ SHIFT RECORD SIDE
shift_r	proc	near
	mov	dx,offset shiftrec_rqst
	mov	al,es:Edl_Fcm			; Get record TCF
shift_r	endp

;................................................................
;________________ SHIFT SOURCE OR RECORD SIDE
shftq	proc	near
	call	norm_kbd		; Clear msgs area
	xchg	bx,dx
	call	kbd_msgread		; Display appropriate prompt

	mov	bx,offset Entime	; Buffer for the new ripple time

	call	tc_cimsg		; AL has FCM

	call	_time_value		; Anything there?
	JMP_Z	shftlx			; Bailout if NULL line

	call	_savebin		; Protect EDL before shifting

	cmp	Shift_Flag,0		; No plus/minus if new start time
	jnz	shftQ_1

; If NON-DROP FCM, convert to drop frame
	cmp	es:Edl_Fcm,'N'
	jnz	shftQ_0
	push	cx
	call	_cnvt2df
	pop	cx

shftQ_0:call	shft_1
	jmp	shftQ_2

shftQ_1:mov	al,Sign_Flag
	call	shift_select
shftQ_2:mov	ax,Temp_Event		; Restore the current event
	call	_event_display		; And return
	ret
shftq	endp

;----------------------------------------------------------------
; Test for + or - shift Entime
shift_select	proc	near
	cmp	al,MINUS_ASCII
	jnz	shft_1
	mov	bx,offset Entime
	call	_tc_negate

;	cmp	cl,NDF_CHAR
	jnz	ssel1
;	call	_cnvt2df
	mov	cl,DF_CHAR
ssel1:

shift_select	endp

;================================================================
;Begin shifting proceedure.  Entime contains offset
shft_1	proc	near
	mov	ax,Shiftstart_Edit	; Get starting edit

shft_3:	call	_index_storage
	jnc	shft_7

	cmp	es:byte ptr [bx].cmnt_lofst,Editline_SLAVE ; Slave line?
	jz	shft_7
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_REC
	jz	shft_7
	inc	ax			; Bypass comments
	cmp	ax,Shiftend_Edit
	jbe	shft_3
shft_5:	ret

shft_7:	mov	Shiftstart_Edit,ax	; Save (new?) starting edit

	cmp	Shift_Flag,0		; Check for new START TIME
	jz	shft_9			; Jump if new START TIME
	mov	bx,offset Entime	; Index to offset
	call	_Elaptm_move
	jmp	shft_11

;Set up for new start time shift
shft_9:	call	_getlast_rin
	call	_sttime_move_ES
	call	_timdif			; Returns with Sttime

shft_11:push	bx
	call	_Sttime_move
	pop	bx
	mov	dx,offset Offset_Buffer	; Point to buffer
	call	_mmv3byt			; Get offset to offset buffer

	cmp	Shift_Flag,2		; Check for SOURCE SIDE
	JMP_Z	sh_SRC
shft_1	endp

;................................................................
; SHIFT RECORD SIDE
;................................................................
sh_REC	proc	near
	mov	ax,es:Current_Event
	call	_index_storage

	cmp	es:byte ptr [bx].cmnt_lofst,Editline_REC
	jz	sh_R_1

; Try for MASTER/SLAVE line
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_SLAVE	; Slave?
	jnz	sh_R_4

sh_R_1:	add	bx,offset ZeroBase.reel_lofst		; Point to the reel Name
	mov	dx,offset R_Reel_Num	; Try for "RECORD" match SLAVE
	mov	ch,reel_length
	call	_cmpchr
	jnz	sh_R_2
	call	_getlast_pin
	call	Shift_TC		; Adjust SLAVE
	jmp	sh_R_5

sh_R_2:	add	bx,reel_length
	call	_cmpchr			; Try for "RECORD" match, MASTER
	jnz	sh_R_6
	call	_getlast_rin
	call	Shift_TC		; Adjust MASTER
	test	Edit_Flags,riplslave_EDBIT
	jz	sh_R_5
	call	_getlast_pin
	call	Shift_TC		; Adjust slave to MASTER
	jmp	sh_R_5

; SHIFT NORMAL EDIT LINE
sh_R_4:	call	_getlast_rin
	call	Shift_TC		; Adjust RECORD IN point
	call	_getlast_rout
	call	Shift_TC		; Adjust RECORD OUT point

sh_R_5:	mov	bx,Current_Event_Adr	; FIX NEW 6-22-1990
	and	es:word ptr [bx].Flags_lofst, NOT disabled_Fmask ; Clear disable Flags

sh_R_6:	mov	ax,es:Current_Event	; Get the current line
sh_R_8:	inc	ax			; Go to next event
	cmp	ax,es:Next_Avail_Num
	jz	sh_R_x
	cmp	ax,Shiftend_Edit
	ja	sh_R_x
	call	_index_storage
	jnc	sh_R_9
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_REC
	jz	sh_R_9
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_SLAVE	; Slave?
	jnz	sh_R_8
sh_R_9:	jmp	sh_REC
sh_R_x:	ret

sh_REC	endp

;================================================================
; SHIFT SOURCE SIDE
sh_SRC	proc	near
	mov	ax,es:Current_Event
	call	_index_storage

	cmp	es:byte ptr [bx].cmnt_lofst,Editline_REC
	jz	sh_S_1
; Try for MASTER/SLAVE line
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_SLAVE	; Slave?
	jnz	sh_S_4

sh_S_1:
	cmp	byte ptr Work_Event, '*'; Shift all?
	jz	sh_S_1a

	add	bx,offset ZeroBase.reel_lofst		; Point to the reel Name
	mov	dx,offset Work_Event	; Try for SOURCE REEL as SLAVE
	mov	ch,reel_length
	call	_cmpchr
	jnz	sh_S_2

sh_S_1a:
	call	_getlast_pin
	call	Shift_TC		; Adjust SLAVE
	jmp	sh_S_5

sh_S_2:	add	bx,reel_length
	call	_cmpchr			; Try for SOURCE REEL as MASTER
	jnz	sh_S_6
	call	_getlast_rin
	call	Shift_TC		; Adjust MASTER
	test	Edit_Flags,riplslave_EDBIT
	jz	sh_S_5
	call	_getlast_pin
	call	Shift_TC		; Adjust slave to MASTER
	jmp	sh_S_5

; SHIFT NORMAL EDIT LINE
sh_S_4:
	cmp	byte ptr Work_Event, '*'; Shift all?
	jz	sh_S_4a

	add	bx,offset ZeroBase.reel_lofst		; Point to the reel Name
	mov	dx,offset Work_Event	; Try for source reel match
	mov	ch,reel_length
	call	_cmpchr
	jnz	sh_S_6

sh_S_4a:call	_getlast_pin
	call	Shift_TC		; Adjust RECORD IN point
	call	_getlast_pout
	call	Shift_TC		; Adjust RECORD OUT point

sh_S_5:	mov	bx,Current_Event_Adr	; FIX NEW 6-22-1990
	and	es:word ptr [bx].Flags_lofst, NOT disabled_Fmask ; Clear disable Flags

sh_S_6:	mov	ax,es:Current_Event	; Get the current line
sh_S_8:	inc	ax			; Go to next event
	cmp	ax,es:Next_Avail_Num
	jz	sh_S_x
	cmp	ax,Shiftend_Edit
	ja	sh_S_x
	call	_index_storage
	jnc	sh_S_9
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_REC
	jz	sh_S_9
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_SLAVE	; Slave?
	jnz	sh_S_8
sh_S_9:	jmp	sh_SRC
sh_S_x:	ret
sh_SRC	endp


;................................................................
; Shift the 24bit TC value at BX
Shift_TC	proc	near

; If Ripple_Flag is TRUE, then check for reasons not to ripple this event
	cmp	Ripple_Flag,0ffh
	jnz	shftTC1
	cmp	Evnt_Insert_Flag,0ffh	; Skip if this is an insert ripple
	jz	shftTC1

	mov	dx,offset Rvtr_In
	call	_cmp24b_ESDS
	jc	shftTCx

shftTC1:push	bx
	call	_elaptm_move_ES
	call	_timadd
	pop	dx
	call	_mmv3_ds2es
shftTCx:ret
Shift_TC	endp

;................................................................
; Get SHIFT RANGE from operator
Get_ShiftRange	proc	near
	push	es:Current_Event
	mov	bx,offset shift_frmto_ovr
	call	get_range
	mov	bx,Starting_Number
	call	_find_edit_BX
	mov	Shiftstart_Edit,ax
	mov	bx,Ending_Number
	call	_find_edit_BX
	FLAGBITS dblline_Fmask		; Does last edit have two lines?
	jz	GSR_1
	inc	ax			; Include second line

; In case of slaves, etc., continue on to find next edit
GSR_1:	inc	ax			; Point to next edit
	cmp	ax,es:Next_Avail_Num	; Check for end of EDL
	jnc	GSR_2
	call	_index_storage
	jc	GSR_1
GSR_2:	dec	ax
	mov	Shiftend_Edit,ax
	mov	Ripple_Flag,0		; Turn off ripple functions
	mov	Trim_Ci_Flag,0ffh	; Turn on +/- input enable

	mov	bx,offset shift_frmto_ovr
	call	_kbd_cln
	call	_msgread
	call	_Space_Out
	mov	bx,Starting_Number
	call	_DecOut
	mov	bx,offset Mcrosep
	call	_comsg
	mov	bx,Ending_Number
	call	_DecOut
	pop	es:Current_Event
	ret
Get_ShiftRange	endp


;================================================================
; Ripple the RECORD SIDE of the EDL
;  from the current edit down +/- [bx]buf
; ENTER:	DL contains '+' or '-'
;		AX has current event number
;
ripple	proc	near
	push	bx
	push	cx
	push	dx
	mov	dx,offset Entime	; Move to buffer
	push	ax
	call	_mmv3byt
	pop	ax
	pop	dx
	mov	Shift_Flag,1		; Set record type shift
	jz	riplx
	mov	al,dl			; Get +/- to AL
	call	shift_select
	mov	Ripple_Flag,0
riplx:	pop	cx
	pop	bx
	ret
ripple	endp


;================================================================
;		COMMENT/NOTE PROCESSING
;================================================================
;Get a comment from the operator
note	proc	near
	mov	ax,es:Next_Avail_Num	; Check for more room
	mov	cx,es:Max_Lines		; in EDL
	inc	cx			;  only 1 line is needed
	cmp	ax,cx			; Next < MAX [ or MAX + 1)
	jb	cmtmemok
	ERROR	out_of_memory, ERET_Keyboard
note	endp

cmtmemok	proc	near
	; Added to be able to edit current note
	call	_check4edl
	jz	no_note_copy

	mov	ax,es:Current_Event
	call	_index_storage
	cmp	es:byte ptr [bx].cmnt_lofst,Editline_BASE
	jnc	no_note_copy
	mov	dx,offset Work_Event
	mov	Filename_Ptr,dx
	mov	ch,line_length
	call	_mmv_ESDS
	jmp	note_copy_ok

no_note_copy:
	mov	bx,offset Work_Event
	mov	byte ptr [bx],0
	mov	Filename_Ptr,bx
note_copy_ok:
	mov	bx,offset Cmt_Prmt
	call	_kbd_message		; Display prompt
	mov	Cimsgadd_Flag,0ffh	; Get recall w/any periods
	mov	al,line_length
	call	cimsg_wrk		; Get comment
	jnz	cmtrtry
cmtxit:	ret				; No, return
cmtmemok	endp

cmtrtry	proc	near
	mov	bx,offset commentmsg_ovr
	call	_kbd_cln
	call	_msgread
cmtrtry	endp

comment_ci	proc	near
	call	get_ucase
	call	_Break_check
	jz	cmtxit
	cmp	ax,offset Enter_xcmd	; After
	jz	comment_after
	cmp	al,'B'			; Before
	jz	comment_b4
	cmp	al,'A'			; Add to bottom
	jz	add_comment
	cmp	al,'R'
	jz	repl_comment
	call	_error_bell
	jmps	comment_ci
comment_ci	endp

comment_after	proc	near
	call	_check4edl
	jz	add_comment
	call	chk4lst			; Is this the last event?
	jz	add_comment

	mov	ax,es:Current_Event
	call	_index_storage
	jc	cmtaf1			; If comment, put this comment after
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	cmtaf1
	inc	ax
cmtaf1:	inc	ax
cmtaf2:	cmp	ax,es:Next_Avail_Num
	jnc	add_comment
	call	_index_storage
	jc	cmtaf1
comment_after	endp

comment_b4	proc	near
	call	_check4edl
	jz	add_comment
	call	_savebin			; Protect the bin to BIN3
	mov	ax,es:Current_Event
	call	_make_room
	jmps	cmt_ins
comment_b4	endp

repl_comment	proc	near
	call	_check4edl
	jz	add_comment
	mov	ax,es:Current_Event
	call	_index_storage
	JMP_NC	cmtrtry
	call	_savebin			; Protect the bin to BIN3
	mov	ax,es:Current_Event
	jmps	cmt_ins
repl_comment	endp

;================================================================
;		ADD A NOTE OR COMMENT TO THE EDL
;================================================================
add_comment	proc	near
	mov	ax,es:Next_Avail_Num
	inc	ax
	cmp	ax,es:Max_Lines
	jbe	JL1060
	ERROR	out_of_memory, ERET_Keyboard

JL1060:	call	_savebin			; Protect the bin to BIN3
	mov	es:Next_Avail_Num,ax
	dec	ax
add_comment	endp

;----------------------------------------------------------------
cmt_ins	proc	near
	call	_index_storage		; Index to event

; Check to make sure that comment does not start with a DECIMAL
	push	si
	mov	si,offset Temp_Wrkspce	; Get source to DX
	mov	cx,line_length
	mov	al,[si]
	call	_check4comment
	jc	cmt_lp1
	dec	cx
	mov	byte ptr es:[bx],'*'
	inc	bx

; Move the comment from the workspace to the event
cmt_lp1:lodsb				; Get byte, SI=SI+1
	or	al,al			;Null termination?
	jz	cmt_lp2
	cmp	al,cr			;CR term?
	jz	cmt_lp2
	cmp	al,lf			;LF term?
	jz	cmt_lp2
	mov	es:[bx],al
	inc	bx
	loop	cmt_lp1
cmt_lp2:jcxz	cmt_lpx
	mov	es:byte ptr [bx],0	; Terminate line
	inc	bx
	loop	cmt_lp2
cmt_lpx:pop	si
	call	_evnt_dispthis		; Display the event
	call	_write2disk

	test	Operational_Flags,lprint_OPBIT
	jz	cmt_nlst
	call	lstedit			; Print the edit
cmt_nlst:
	call	_kbd_cln
	ret
cmt_ins	endp


;Check for this event=last event
chk4lst	proc	near
	mov	ax,es:Current_Event
	inc	ax				; Inc event, check eol
	mov	bx,offset Next_Avail_Num
	cmp	ax,es:[bx]
	ret
chk4lst	endp


;================================================================
;Abort Add/Insert/Replace if edit in workspace is of zero duration
check_duration	proc	near
	mov	al,Current_Machine
	push	ax

	mov	al,Trans_Type
	cmp	al,'S'
	jz	CD_spl
	cmp	al,'W'
	jz	CD_efx
	cmp	al,'D'
	jz	CD_efx
	cmp	al,'K'
	jz	CD_key

; Check for ANY CUT DURATION
CD_cut:	mov	bx,offset R_Tc.tcDUR	; See if there is a REC tc
	call	_time_value
	jnz	CD_cut1			; Jump if RDUR > 0
	mov	al,Current_Source
	call	Machine_Change
	mov	bx,Current_Duration	; Check SOURCE DURATION
	call	_time_value
	jz	CD_err			; Jump if SOURCE DUR > 0
CD_cut1:jmp	CD_xit

; Check for split duration	
CD_spl:	mov	bx,offset R_Tc.tcDUR	; See if there is a REC tc
	call	_time_value
	jnz	CD_spl1		; Jump if RDUR > 0
	mov	al,To_Machine
	call	Machine_Change
	mov	bx,Current_Duration	; Check SOURCE DURATION
	call	_time_value
	jz	CD_err			; Jump if SOURCE DUR > 0
CD_spl1:jmp	CD_xit

; Check for dissolve duration
CD_efx:	mov	bx,offset R_Tc.tcDUR	; See if there is a REC tc
	call	_time_value
	jnz	CD_efx1		; Jump if RDUR > 0
	mov	al,To_Machine
	call	Machine_Change
	mov	bx,Current_Duration	; Check SOURCE DURATION
	call	_time_value
	jz	CD_err			; Jump if SOURCE DUR > 0
CD_efx1:jmp	CD_xit

; Check for dissolve duration
CD_key:	mov	bx,offset R_Tc.tcDUR	; See if there is a REC tc
	call	_time_value
	jnz	CD_key1		; Jump if RDUR > 0
	mov	al,Keybkgnd_Src
	call	Machine_Change
	mov	bx,Current_Duration	; Check SOURCE DURATION
	call	_time_value
	jz	CD_err			; Jump if SOURCE DUR > 0
CD_key1:jmp	CD_xit

CD_xit:	pop	ax
	call	Machine_Change
	ret

CD_err:	pop	ax
	call	Machine_Change
	ERROR	undef_dur, ERET_Keyboard
check_duration	endp

;================================================================
;Abort edit or list add/insert/replace if EFX transition
; is greater than then edit duration
; ENTER: BX points to edit duration
; Exit: ERROR Exit IF TRANS > DURATION
check_ltrans	proc	near
	cmp	Trans_Type,'C'		; Skip the whole thing if CUT
	JMP_Z	CL_xit
	mov	bx,offset R_Tc.tcDUR
	call	_time_value		; Open end edit?
	JMP_Z	CL_xit

	mov	al,Trans_Type
	cmp	al,'W'
	jz	CL_efx
	cmp	al,'D'
	jz	CL_efx
	cmp	al,'K'
	jz	CL_key

; Check split delay
CL_spl:	mov	bx,offset R_Tc.tcDUR
	mov	dx,offset Split_Delay
	call	_cmp24b			; is duration > split delay
	ja	CL_xit			; Jump if above
	call	_upd_getscr
	ERROR	splitdur_error, ERET_Keyboard

; Check Dissolves and Wipes
;Is the effect duration > edit duration
CL_key:	cmp	Key_Mode,0
	jz	CL_xit
	mov	dx,Key_Trans
	mov	bx,Current_BKGbuf
	jmp	CL_efx1

CL_efx:	mov	bx,offset R_Tc.tcDUR
	mov	dx,Current_FRMbuf
	add	dx,6
	call	_cmp24b
	jbe	CLefxe
	mov	dx,Trans_Length
	mov	bx,Current_TObuf

CL_efx1:add	bx,6
	push	bx
	mov	bx,offset Sttime
	mov	[bx],dx
	mov	byte ptr [ bx + 2 ],0
	pop	dx
	call	_cmp24b			; Is duration < transition?
	jbe	CL_xit
CLefxe:	call	_upd_getscr
	ERROR	efxtrans_error, ERET_Keyboard

CL_xit:	ret
check_ltrans	endp


_TEXT	ends

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
