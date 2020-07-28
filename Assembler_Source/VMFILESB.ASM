; Last revised: 2-22-1995, 11:12:27   (C)1989-1995 Norman H. Strassner

;VMFILESB.ASM

%nolist
include	VM.EQU
%nolist

extrn Device_Present:byte,FileExists_Flag:byte,TMPwrite_Flag:byte
extrn Active_IOTYP:byte,Active_Bin:byte,Cimsgadd_Flag:byte,Default_Mode:byte
extrn Dirdisplayed:byte,Dirfiles:byte,Dirlines:byte,Dirpgtop:byte
extrn Dirtype:byte,Edl_Fcm:byte,Frame_Flag:byte,Fullscreen_Flag:byte
extrn Last_Fcm:byte,Maccrlf_Flag:byte,Maxfiles_Reached:byte,Port_IO_Flag:byte
extrn Readline_Length:byte,Rtcf:byte,Suspend_Flag:byte

extrn Cct_Tail:word,Ramp_EDLev:word,Vlan_Emems:word,ZeroBase:word
extrn Clean_Path:word,Switcher_Tail:word,Ascii_Line:word,CASEID:word
extrn AUTOFILE_Subdir:word,BadDOSfname_Msg:word,DOS_Flags:word,DTA:word
extrn EDL_Bin:word,Edl_Seg:word,EDL_Subdir:word,EDLoptions_Flags:word
extrn EIF_Ext:word,Emem_File_Msg:word,InDosFname_Msg:word,Macro_File_Msg:word
extrn NoOLM_ovr:word,OVRFILE_size:word,Psp_Seg:word,PointShootData:word
extrn SESID:word,SES_File:word,SavedMemSize:word,TCM_Ext:word,TMP_File:word
extrn TMP_Subdir:word,VME_Ext:word,_Load_File_Msg:word,_Save_File_Msg:word
extrn Areusure:word,Backup_File:word,Badovl_Msg:word,Bin_Table:word
extrn Byte_Store_1:word,Clean_File:word,clrmacs_ovr:word,Cmdtbl1:word
extrn Command_Runopt:word,Crlf_Msg:word,Current_EDL:word,Current_Event:word
extrn Current_Event_Adr:word,Cursor:word,Default_File:word
extrn Dflt_File_Msg:word,Dflts_Area:word,Dflts_Length:word,Dflts_Ttl:word
extrn Dir_Opts:word,Dir_Tail:word,dirbuff:word,Dirchoice:word
extrn Dirchoice_Adr:word,dirhdr_ovr:word,dirmore_ovr:word,dirofs_ovr:word
extrn dirofn_ovr:word
extrn Dirpath_Msg:word,Dirsub_Adr:word,Dos_Cmd:word,Dos_Tail:word,EdlSES:word
extrn Edl_Ext:word,Edl_Formats:word,eifhdr_ovr:word,Event_Storage:word
extrn Events_Iod:word,Fcb:word,Fcm_EDLev:word,File_Msg:word,File_Title:word
extrn Filename_Msg:word,Filename_Ptr:word,Findme:word,findwho_ovr:word
extrn Gpi_EDLev:word,Home_Path:word,Initfile_Retadr:word
extrn Keyboard_Scr:word,keys_ovr:word,Kilfil_Msg:word,Killed_Msg:word
extrn Last_Command:word,List_Scr:word,Loaded_Msg:word,Logauto_Msg:word
extrn Logd_Msg:word,Logtcm_Msg:word,Logtmp_Msg:word,Logvme_Msg:word
extrn Macro_Buffers:word,Macro_Length:word,Macro_Ttl:word,Max_Lines:word
extrn maxfiles_ovr:word,Menu_File:word,Menu_Path:word,Mode_Pntr:word
extrn Msg_Seg:word,New_Dflts_Msg:word,Next_Avail_Num:word,Next_Edit:word
extrn Noovl_Msg:word,Olm_Cmd:word,Olm_Kbdlayout:word,Olm_Manual:word
extrn Olm_Path:word,Olm_Tail:word,Operational_Flags:word
extrn overlay_checksum:word,overwrite_ovr:word,Ovrlay_File:word,Page_Qry:word
extrn Pagend_Msg:word,Paths:word,Pmc_EDLev:word,pointer_ovr:word
extrn prepare4dos_ovr:word,Rec_EDLev:word,retfromdos_ovr:word,Saved_Msg:word
extrn Saveload_EDL:word,Saveload_Handle:word,Seriel_Num:word
extrn shellwarn_ovr:word,Slave_EDLev:word,Sounddisplay_Flags:word
extrn Space_Msg:word,Spd_EDLev:word,Split_EDLev:word,Stacks:word
extrn Starspace_Msg:word,Start_EDLev:word,Start_Header:word,Tcdispbuf:word
extrn TCM_Subdir:word,tcmhdr_ovr:word,Temp_Event:word,Temp_Macro:word
extrn Temp_Tc_Buf:word,Temp_Wrkspce:word,Time_Start:word,Title2_Scr:word
extrn Title_EDLev:word,Tstamp_EDLev:word,Tstamp_Header:word,Type_EDLev:word
extrn Type_Header:word,Video_Header:word,View_Msg:word,Viewend_Msg:word
extrn Viewsavlod_Msg:word,VME_Subdir:word,vmehdr_ovr:word,withthis_ovr:word
extrn Work_Event:word,write_ovr:word,preread_EDLev:word,MasterEditLineAdr:word
extrn cimsg_add:near,cimsg_wrk:near,cstat:near
extrn dec_cimsg:near,init_w2d:near,keythru:near,List_Msg:near,Macro0:near
extrn match_RESET:near,no_chos_msg:near,pos_yn_chos:near,position_query:near
extrn rdchar:near,read_ovr:near,Title_Msg:near,yn_chos:near

extrn WRITE_emem_FAR:far,_Bin_Hdr:far,_ConOut:FAR,_Cursor_On:far,_DecOut:far
extrn _E1_flgs:far,_EDL2ASCII:far,_EFXscreen:far,_E_flgs:far,_E_mod_l:far
extrn _GetSXcb_emems:far,_GetSXcb_Name:far,_MsgCntr:FAR,_Space_Out:far
extrn _a_DecOut:far,_add_store:far,_adv2chr:FAR,_adv2spc:FAR,_advance:FAR
extrn _blank_screen:FAR,_Break_check:FAR,_calc_evdur:far,_check4comment:far
extrn _check4edl:far,_chrwait:far,_cknum:FAR,_clear_screen:FAR,_cmpchr:far
extrn _cntrtxt:FAR,_cnvt2mp_ES:far,_cnvt2tc_DS:far,_cnvt2tc_DS:far
extrn _comsg:FAR,_convert2bin:far,_crlf:FAR,_cstat_FAR:FAR,_dashit_cl:far
extrn _dec1000_pad:far,_delfrm:far,_dflts_disp:far,_dircur_lerase:FAR
extrn _error_bell:FAR,_event_display:far,_evnt_dispthis:far,_evnum:far
extrn _file_ttl_upd:far,_find_edit_BX:far,_force_fcm:far
extrn _help_pos:FAR,_index_storage:far,_kbd_cln:FAR,_kbd_clr:FAR
extrn _kbd_message:far,_Keyboard_reset:far,_Keyboard_set:far
extrn _left_set2edl:far,_macone:far,_macros_disp:far,_macsaver:far
extrn _make_ucase:far,_mmv16:far,_mmv:far,_mmv_ESDS:far,_motion_convert:FAR
extrn _msgread:far,_screen_init_FAR:FAR,_time_value:far,_wrt_fcm:far
extrn _wrt_split:far,Badcrash_FAR:far,cimsg_add_FAR:far,cimsg_wrk_FAR:far
extrn dec_cimsg_FAR:far,Diskon_Upd_FAR:far,Goaway:far,init_w2d_FAR:far
extrn kbdisp_FAR:far,Keyboard:far,keyhold_FAR:far,match_RESET_FAR:far
extrn no_chos_msg_FAR:far,pos_yn_chos_FAR:far,position_query_FAR:FAR
extrn rdchar_FAR:FAR,read_emem_FAR:far,Restart:far,running_time_FAR:far
extrn timestamp_FAR:far,yn_chos_FAR:far,_dltoi:far,get_checksum:far
extrn keythru_FAR:far,_time_value:far,Preread_EDLev:word
extrn loadxfr_FAR:far,loadxfr_FAR:far,_GetSXcb_Flags:far
extrn _move_subdir:far,_delete_backslash:far
extrn _add_backslash:far,_title_loop_DS:far,_title_loop_ES:far,_title_loop:far
extrn _path_extract:far,_get_checksum:far,_strlen:far

BSEG	segment word public 'CODE'
	assume	cs:BSEG,ds:_DATA,es:eseg


Public  iProgramFound, iLastMcbFound, wPspOwner, PSPSignature, PSPEnvironment
Public  Block_MCB, Last_MCB, Free_MCB, _FindRunningSoftware, show_mem, showm1
Public  bad_chain, done, donex, MCB_inf, mpgm1, mpgm2, mpgm3, Owner_Exit
Public  MCB_xit, _Room4Line, R4L1, _re_cmt, _remvl, remvl0, remvl1, stk_seg
Public  stk_ptr, _shell2olm, NoOLM, _kbdlayout, _context_help, _GetKeyName
Public  chlp1a, chlp1b, __SetOlmPgm, __MoveEsFcnName, bskip1, bskip2, bskip3
Public  bskip5, _shell2dir, shell2dirx, find_string_length, s2dir1, s2dir2
Public  _shell2cct, _shell2switcher, _shell2dos, DOSshel, DOSshlg, shelldos
Public  shellany, ShellToSelectedDrive, shellc2, s2d1, s2d_2, shell_Exit
Public  pgm_seg_ds, dce_offset, dce_seg, _yes_critical, _no_critical
Public  _Drive_critical_error, dce1, dce2, dce3, dcex, _fname_cheqr, fnchq0a
Public  fnchq0b, fnchq0, fnchq1, fnchq2, fnchq3, fnchqx, IllegalFilename
Public  ilglfn1, ilglfn2, _ASCII2EDL, A2E1, A2E2, A2E2_c1, A2E2_c2, A2E2_c3
Public  A2E2_c4, A2E2_c, A2E2_a, A2E3, A2E3_K2, A2E3_K3, A2E3_ok, A2E3_nn
Public  A2E3_cn, A2E4, prs2e0, prs2e1, prs2e3, prs_NoFcmTail, prs2ex, prs2ex1
Public  prs2ex2, rmarkck, set_rm, nset_rm, nset_rc, _read_convert, _evnttcp
Public  ettcp2, _aftrspc, JL0910, _red_parser, redplp, redrx, redprs1
Public  _Check_4_tstamp, _Check_4_starts, _Check_4_title, _Check_4_format
Public  _Check_4_spl, _Check_4_fcm, _Check_4_gpi, _Check_4_slave, _Check_4_spd
Public  _Check_4_pmc, _Check_4_rec, _c_4_pr, chk4x, chk4x1, c_4_x, _EDLevck
Public  edlevc0, edlevc1, _Check_4_record, _showdir, shd_1, shd_2, shd_3, shd_4
Public  shder, shdirs, _pointer_write, _read_pointer, sl_chos, sl_chs1
Public  file_Exit_2keyboard, dflts_chos, dflts_msgs, _log_TMPfile, _log_TCMfile
Public  _log_VMEfile, _log_autofile, _log_Drive, _logdrv1, logdrv2, logdx
Public  _log2edldrive, _log2default, _log2it, log2err, _log2itx, _valid_path
Public  vp1, vpaddbs, vpdelbs, vpxit, _log_immediate, logima, logimb, logim1
Public  logimx, _Set_AutoFile, inw2dw, _init_EDL, _init_KILL, _init_VME
Public  _init_MACRO, _init_DFLTS, _init_DIR, inidir1, _init_file, inisf_1
Public  inisf_2, inisf_3, inisf_4, iw2d_1, inifdir, inifdir1, _init_write
Public  inisfww, inisfwc, _init_header, ih3, ih4, StarSpace
Public  CapWrite_Ascii_Line, CWALlp, CWALN, output_line_ES, _write2disk
Public  w2d_err, w2d_2, w2d_2a, w2d_3, w2d_4, w2d_5, w2d_r, _edl_write
Public  _edl_read, edl_rwx, _save_file, savfilx, savetry, savetr1, savetr2
Public  WriteEdits_CX, savtx, writeone, wrtlin1, wrtlin2, wrtlin3, wrtlin5
Public  _load_file, loadf_1, loadf_2, loadf_3, _EMEM_save, efxwagn, efxsdon
Public  VS1222, _EMEM_load, VL1235, Wemeagn, EMloadd, NoValidEFX, video_files
Public  _mac_save, macsret, _mac_load, maclodd, _macro_clear, mclrret
Public  _setdflts_file, _load_defaults, loddok, ldfxit, _title_file
Public  _getvideo_ttl, _getdflts_ttl, _getmacro_ttl, ttlslop, ttlsret
Public  _getatitle, _MakeBatchFileCommand
Public  _file_messages, _SaveLoadFile_Close, _SaveLoadFile_AHfunc
Public  _SaveLoadFile_Open, SLFOerr, _read_line, rdeof, rdneof, rdlnc, rdnulb
Public  rdleol, rdleol1, _opn_ovl, opno2, badovl, noovler, nobadov
Public  _shdok, shdok0, shdok1, shdok1a, shdok2, shdok3
Public  shdok4, shdok5, gdtlp, gtdcont, gtdret, DirFile_Select, DFS_err
Public  DFS_rt0, DFS_rt1, DFS_rt2, DFS_rt2a, DFS_rt3, DFS_rt4, DFS_pq0, DFS_pq1
Public  DFS_pq2, DFS_pq3, DFS_pq4, DFS_pq5, DFS_pgup, DFS_pgdn, DFS_pg1
Public  view_edl, vedl2, vedllp, vedlrdc, vedlx, vedlxit, view_select
Public  view_title, view_slrqst, vslrq1, vslrq2, kill_file, JL1310, kilfx
Public  Dir_display_page, DDP_2, DDP_3, DDP_4, DDP_6, DDP_7, DDP_x, DDP_8
Public  FileTitle_Display, FTD_all, FTD_spcl, FTD_edl, FTDedl1, FTD_nul
Public  FTDedl0, FTDedl2, FTDcmcl, FTDedln, FTDclsf, Index2DirFname
Public  DirSearch_Set, DSS_1, DirScrn_Header, Dscr_h0, Dscr_h1, Dscr_h2
Public  Dscr_h3, Dscr_h4, Dscr_hp, DirFind_All, DFA_1, DFA_maxfiles, DFA_end
Public  DFA_x, DirectorySort, dirsrt1, dirsrtx, dirsrt_makeroom, dirsrt_done
Public  _TMP_save, TMPs0, TMPs1, tmps2, tmps3, tmpsvr, seg2disk_error
Public  _TMP_restore, tmpr1, tmpr2, d2bin1, d2bin3, tmpr3, tmprsr, TMPferr
Public  remaining_bins, rbins, build_TMPfilename, _Check_TMPspace, Ctsp, Ctsp1
Public  Ctsperr,  _check4path, c4p_1, c4p_2, c4p_x
Public  _stash_TMPsubdir, _stash_TCMsubdir, _stash_VMEsubdir, _stash_AUTOsubdir
Public  _stash_EDLsubdir, _stash_homesubdir, _stashit, _move_default, mvd1
Public  mvd2, mvdok, mvdmv, mvdxit, _find_file, fndagn, fndmore, file_found, file_notfound
Public  fil4dir, fndagn1, check_file_error, cfe_xit, _menu_find, mnufnd
Public  _clean_find, clnfnd, _olm_find, olmfnd, _SetEdlBinFormatPointer
Public  _dfltver_check, _baddfltver, __init_filewrite, inisf_5, _output_line
Public  _DiskOut, outlinx, _OutCRLF, _Dflts2Disk, _loadall_macros, NoValidMacro
Public  _init_READ, irerr, _gpi_xlate, gpi_x1, gpi_x2, _gpi_cmt, _slave_xlate
Public  _rec_xlate, recslv_xlate, recladv, _spd_xlate, spd_xl2
Public  spd_xl3, spd_xl4, spd_xlx, _pmc_xlate, pmc_xl2, pmc_xl3
Public  _pmcspd_xlate_ret, PMC_xlx, _ReadEvent, re_ret, re_1, re_2, re_3, MCBad
Public _Check_4_ramp,_ramp_xlate,_Check_4_preread,_preread_xlate

%list


;================================================================
; thread macros and equates
@type_BYTE macro arg
	cmp	byte ptr es:[di].TypeMCB,arg
	endm

@disstr	macro	arg
	mov	bx,offset arg
	call	comsg
	endm

mcb	struc
	TypeMCB		db	?
	OwnerMCB	dw	?
	SizeMCB		dw	?
mcb	ends

PSPSignature	equ	20cdh	; Valid PSP?
PSPEnvironment	equ	2ch	;
Block_MCB	equ	4dh	; Type of chained MCB
Last_MCB	equ	5ah	; type of last MCB
Free_MCB	equ	0000h	; Owner of free MCB

_FindRunningSoftware	proc	far
; Find start of the Memory block queue
	mov	byte ptr iProgramFound,0
	mov	iLastMcbFound,0
	push	es

	mov	ah,52h				; Get DOS "list of lists"
	int	21h				; Return pointer in ES:BX
	mov	ax,es:word ptr -2[bx]		; Get starting block
	mov	es,ax
	xor	di,di				; Clear index
	@type_BYTE Block_MCB
	jnz	bad_chain			; Exit if not start of chain

;................................................................
show_mem:
	call	MCB_inf				; Dump MCB contents
	cmp	byte ptr iProgramFound,00000010b	; Non-zero = TRUE
	jz	done

showm1:	@type_BYTE Last_MCB
	jz	done				; Exit if end of chain
	mov	ax,es				; Calculate next address
	add	ax,es:[di].SizeMCB		; add block size
	inc	ax				; plus one for ourselves
	mov	es,ax				; Start of new block
	@type_BYTE Last_MCB
	jz	show_mem			; Continued if proper type
	@type_BYTE Block_MCB
	jz	show_mem			; Continue if proper type

; Error in MCB chain
bad_chain:
	mov	dx,offset MCBad
	mov	ah,9
	int	21h
	jmp	Keyboard

done:	mov	al,iProgramFound
	or	al,al			; 0 = Not Found
	clc
	jz	donex
	stc				; Signal FOUND
donex:	pop	es
	ret
_FindRunningSoftware	endp

;================================================================
MCB_inf	proc	near
	mov	ax,es:[di].OwnerMCB	; Get Owner's PSP address
	cmp	ax,Free_MCB		; Is block free?
	jz	MCB_xit			; Yes, don't need Name
	push	es			; Save for MCB address
	push	di			; Save for "cleanup"
	mov	es,ax			; ES = Owner's PSP address
	cmp	es:[di],PSPSignature	; Valid PSP?
	jnz	Owner_Exit

	mov	wPspOwner,ax		; Save PSP address
	mov	bx,cs
	cmp	ax,bx			; Is it US, HERE, NOW?
	jz	Owner_Exit
	mov	es,ax
	mov	si,offset SES_File	; Get Name of program
	mov	bx,0100h		; Where to find comparison Name
					;  in data segment of program
mpgm1:	lodsb
	or	al,al
	jz	mpgm2
	cmp	al,es:[bx]
	jnz	Owner_Exit
	inc	bx
	jmp	mpgm1

mpgm2:	cmp	word ptr es:[bx],9090h	; Check for NOPs
	jnz	Owner_Exit
	cmp	iProgramFound,00000010b	; Already one found?
	jz	mpgm3
	mov	ax,es
	mov	iLastMcbFound,ax
	mov	iProgramFound,00000010b	; Set second bit if found first time
	jmp	Owner_Exit
mpgm3:	mov	ax,es
	cmp	ax,iLastMcbFound	; Same segment as before?
	jz	Owner_Exit
	or	byte ptr iProgramFound,00000001b ; Set first bit (found twice)
	mov	iLastMcbFound,ax
Owner_Exit:
	pop	di
	pop	es
MCB_xit:ret
MCB_inf	endp



;================================================================
; Make room for another line
_Room4Line	proc	far
	mov	ax,es:Next_Avail_Num	; Do we have room for this line?
	mov	cx,es:Max_Lines
	inc	cx
	cmp	ax,cx
	jb	R4L1			; Jump if room IS available
	call	_evnt_dispthis	; OUT OF Memory, BAIL OUT WITH ERROR
	ERROR	out_of_memory, ERET_Keyboard

; Memory OK, CONTINUE
R4L1:	push	bx			; Save pointer to Temp_Wrkspce
	call	_index_storage
	pop	bx
	ret
_Room4Line	endp

;----------------------------------------------------------------
; Make line at Temp_Wrkspce a comment in the EDL
_re_cmt	proc	far
	mov	di,Current_Event_Adr
	mov	bx,offset Temp_Wrkspce	; DX = destination
	mov	cx,line_length
_re_cmt	endp

_remvl	proc	far
	mov	al,[bx]
	cmp	al,cr
	jz	remvl0
	mov	es:[di],al
	inc	bx
	inc	di
	or	al,al
	loopnz	_remvl
remvl0:	mov	byte ptr es:[di],0
remvl1:	ret
_remvl	endp


;================================================================
;		   SHELL TO EXTERNAL PROGRAMS
;================================================================
; Stack storage for SHELL functions
stk_seg	dw	0
stk_ptr	dw	0
;================================================================
; Run ON LINE MANUALS
_shell2olm	proc	far
	test	DOS_Flags,useolm_DOSBIT
	jz	NoOLM
	mov	TMPwrite_Flag,0ffh	; Allow TMP file
	call	 FAR PTR _log2default
	mov	bx,offset Olm_Path
	mov	dx,offset Olm_Tail
	call	shellany
	jmp	shell_Exit

NoOLM:	call	_help_pos
	call	_error_bell
	mov	bx,offset NoOLM_ovr
	norm_VIDEO FALSE,FALSE
	call	_msgread
	dim_VIDEO FALSE,FALSE
	mov	Cursor,offset Keyboard_Scr
	call	kbdisp_FAR
	call	rdchar_FAR
	call	_macone
	call	_evnt_dispthis
	ret
_shell2olm	endp

;================================================================
_kbdlayout	proc	far
	mov	Last_Command, offset Olm_Kbdlayout
	mov	TMPwrite_Flag,0ffh	; Allow TMP file
	call	 FAR PTR _log2default
	call	__SetOlmPgm
	mov	si,offset Olm_Kbdlayout

	push	es
	push	ds
	pop	es
	mov	cx,-1
	call	__MoveEsFcnName
	pop	es

	mov	bx,offset Dos_Cmd
	call	shellany
	jmp	shell_Exit
_kbdlayout	endp

;================================================================
_context_help	proc	far
	call	 FAR PTR _GetKeyName
	mov	Last_Command,bx

	mov	TMPwrite_Flag,0ffh	; Allow TMP file
	call	 FAR PTR _log2default
	call	__SetOlmPgm

	push	es
	mov	es,Msg_Seg
	mov	si,Last_Command
	mov	cx,16
	call	__MoveEsFcnName
	pop	es

	mov	bx,offset Dos_Cmd
	call	shellany
	jmp	shell_Exit
_context_help	endp

;================================================================
; Enter AX has key
; Exit BX -> offset in Msg_Seg of key Name
; Z set if key not found
_GetKeyName	proc	far
	push	ax
	push	cx
	push	si
	mov	si,offset Cmdtbl1
	mov	bx,offset keys_ovr
	mov	cx,ax			; Save character in CX
	cld
chlp1a:	lodsw				; Get characters
	inc	si			; Point to next chars
	inc	si
	cmp	ax,cx
	jz	chlp1b			; Jump if match
	inc	ax			; Check for end of commands (0ffffh)
	jz	chlp1b
	add	bx,16
	jmp	chlp1a
chlp1b:	or	ax,ax			; Return Z if not found
	pop	si
	pop	cx
	pop	ax
	ret
_GetKeyName	endp


;================================================================
__SetOlmPgm	proc	near
	mov	bx,offset Ascii_Line + 1; Use as destination buffer
	mov	si,offset Command_Runopt; "/C "
	call	 FAR PTR _move_subdir

	mov	si,offset Olm_Cmd	; Move "OLM.COM"
	call	 FAR PTR _move_subdir	;  to buffer
	mov	byte ptr [bx],' '	; Insert space
	inc	bx
	mov	si,offset Olm_Manual	; Move MANUAL Name
	call	 FAR PTR _move_subdir	; to buffer
	mov	byte ptr [bx],' '	; Insert space
	inc	bx
	mov	byte ptr [bx],'"'	; Open quotes
	inc	bx
	mov	byte ptr [bx],'{'
	inc	bx
	ret
__SetOlmPgm	endp

;================================================================
; Enter: ES -> Segment with Name
; 	 SI -> Offset of Name
;	 CX = Max Name length
__MoveEsFcnName	proc	near

; Find the start of the last command text
bskip1:	mov	al,es:[si]		; Get a byte
	test	al,80h			; Hi bit character?
	jnz	bskip2
	cmp	al,' '
	jnz	bskip3
bskip2:	inc	si
	dec	cx
	jmps	bskip1			; Get another byte

bskip3:	mov	al,es:[si]		; Get byte
	test	al,80h
	jnz	bskip5
	or	al,al
	jz	bskip5
	mov	[bx],al
	inc	bx
	inc	si
	loop	bskip3

bskip5:	dec	bx			;  delete trailing Spaces
	cmp	byte ptr [bx],' '
	jz	bskip5
	inc	bx
	mov	byte ptr [bx],'}'
	inc	bx
	mov	word ptr [bx],000dh	; Terminate
	call	find_string_length
	ret
__MoveEsFcnName	endp

;================================================================
_shell2dir	proc	far
	mov	TMPwrite_Flag,0ffh	; Skip TMP file operations
	mov	bx,offset Dirpath_Msg
	call	_kbd_message
	mov	al,pathname_length
	call	cimsg_wrk_FAR
	jc	shell2dirx

	push	bx			; Save User Filespec
	mov	bx,offset Ascii_Line + 1; Use as destination buffer
	mov	si,offset Dir_Tail	; Move "DIR "
	call	 FAR PTR _move_subdir		;  to buffer
	pop	si			; Move user filespec
	call	 FAR PTR _move_subdir		;  to buffer
	mov	si,offset Dir_Opts	; Move tail
	call	 FAR PTR _stashit		;  and terminate

	call	find_string_length
	mov	Fullscreen_Flag,0ffh
	call	_blank_screen
	mov	bx,offset Dos_Cmd
	call	shellany
	mov	bx,offset Pagend_Msg
	call	_kbd_message
	call	rdchar_FAR
	jmp	shell_Exit
shell2dirx:	ret
_shell2dir	endp

; Find the length of the string at SI
; return DX = SI, [SI] has length byte
find_string_length	proc	near
	mov	si,offset Ascii_Line	; Point to destination buffer
	push	si
	inc	si
	xor	cl,cl			; Clear counter
s2dir1:	lodsb				; Find the end
	or	al,al			;  of the line.
	jz	s2dir2
	inc	cl
	jmps	s2dir1
s2dir2:	pop	si
	mov	[si],cl
	mov	dx,si
	ret
find_string_length	endp

;================================================================
_shell2cct	proc	far
	call	 FAR PTR _log2edldrive
	mov	bx,offset Clean_Path
	mov	dx,offset Cct_Tail
	call	 FAR PTR _MakeBatchFileCommand

	mov	TMPwrite_Flag,0ffh
	mov	bx,offset Dos_Cmd
	mov	dx,offset Cct_Tail
	call	ShellToSelectedDrive
	jmp	shell_Exit
_shell2cct	endp


;================================================================
_shell2switcher	proc	far
	mov	TMPwrite_Flag,0ffh
	mov	bx,offset Dos_Cmd
	mov	dx,offset Switcher_Tail
	call	shellany
	jmp	shell_Exit
_shell2switcher	endp

;================================================================
; Enter COMMAND.COM shell
_shell2dos	proc	far
	mov	TMPwrite_Flag,0ffh
	test	DOS_Flags,usemenu_DOSBIT
	jz	DOSshel
	mov	bx,offset Menu_Path
	jmp	shelldos
_shell2dos	endp

DOSshel	proc	near
	call	 FAR PTR _Check_TMPspace
	jnc	DOSshlg
	and	DOS_Flags,not virtual_DOSBIT ; Turn off virtual Memory
	ERROR	virtualmem_error, ERET_Keyboard
DOSshel	endp

DOSshlg	proc	near
	call	_blank_screen
	mov	Cursor,offset List_Scr
	norm_VIDEO FALSE,FALSE
	mov	bx,offset shellwarn_ovr
	call	_msgread
	mov	bx,offset Dos_Cmd
DOSshlg	endp

shelldos	proc	near
	mov	dx,offset Dos_Tail
	call	shellany
	jmp	shell_Exit
shelldos	endp

; RUN ANY DOS PROGRAM, INTERNAL OR EXTERNAL
; BX points to program Name to run
; DX points to tail command
shellany	proc	near
; Logs to home directory before shelling out.
	push	bx
	push	dx
	call	 FAR PTR _log2default
	pop	dx
	pop	bx

ShellToSelectedDrive:
	mov	si,offset DTA
	mov	byte ptr [si],0
	mov	si,offset Fcb
	mov	byte ptr [si],0
	call	_Keyboard_set
	call	 FAR PTR _TMP_save
	push	ds			; Save data segment
	push	es			; Save EDL segment
	call	_Cursor_On	; Turn the Cursor on
	push	bx			; Save address of program Name

; Set environment pointer
	mov	bx,2ch			; Environment block pointer
	mov	ax,[bx]			;  segment
	mov	bx,offset Temp_Wrkspce	; Use for parameter block
	mov	[bx],ax			; Use for parameter block

; Set default command to null
	or	dx,dx
	jnz	shellc2
	mov	dx,offset Dos_Tail
shellc2:mov	2[bx],dx		; Save command tail pointer
	pop	dx			; Restore program Name address

	mov	ax,offset DTA		; Give some FCBs to
	mov	6[bx],ax		;  then comming process
	mov	ax,offset Fcb
	mov	10[bx],ax

	mov	ax,ds			; We'll use our data seg
	mov	4[bx],ax
	mov	8[bx],ax
	mov	12[bx],ax

	mov	es,ax			; Parameter block segment

	mov	cs:stk_seg,ss		; Save stack
	mov	cs:stk_ptr,sp		; Save stack pointer

	mov	al,0			; Run program
	mov	ah,4bh			; EXEC function
	int	DOS			; Transfer to DOS
	cli
	mov	ss,cs:stk_seg
	mov	sp,cs:stk_ptr
	sti
	pop	es
	pop	ds

	pushf
	mov	dx,offset DTA		; Set default DMA
	mov	ah,1Ah			; Set DMA
	int	DOS
	popf

	jnc	s2d_2
	cmp	al,2
	jnz	s2d1
	ERROR	cantrun_error, ERET_Keyboard

s2d1:	cmp	al,8
	jnz	s2d_2
	ERROR	nodosmem_error, ERET_Keyboard

s2d_2:	call	 FAR PTR _TMP_restore
	call	_Keyboard_reset
	ret
shellany	endp

shell_Exit	proc	near
	jmp	_screen_init_FAR
shell_Exit	endp



;================================================================
; Patch our own critical error handler address to page 0
pgm_seg_ds	dw	0
dce_offset 	dw	0
dce_seg		dw	0
_yes_critical	proc	far
	push	es		; Save segment regs
	push	ds
	mov	cs:pgm_seg_ds,ds
	mov	ax,3524h	; Get old critical error address
	int	DOS		;  from DOS to ES:BX
	mov	cs:dce_offset,bx
	mov	cs:dce_seg,es
	mov	ax,2524h	; Set new critical error address
	push	cs
	pop	ds
	mov	dx,offset _Drive_critical_error
	int	DOS
	pop	ds		; Restore saved regs
	pop	es
	ret
_yes_critical	endp

; Put critical error address back to page 0
_no_critical	proc	far
	push	ds
	mov	ax,cs:dce_seg	; Put the critical error address
	mov	ds,ax		;  back for DOS to use for other
	mov	dx,cs:dce_offset;  errors
	mov	ax,2524h
	int	DOS
	pop	ds
	sti
	ret
_no_critical	endp

;================================================================
;			CRITICAL ERROR HANDLER
;================================================================
_Drive_critical_error	proc	far
; Re-fix stack information
	cli
	mov	cx,_STACK
	mov	ss,cx
	mov	sp,offset Stacks
	sti
	mov	cx,cs:pgm_seg_ds	; Restore our data and extra segments
	mov	ds,cx
	mov	es,Edl_Seg
	test	ah,80h			; Bit 7 set if disk error
	jnz	dcex			; Bail out if not disk error
	push	di			; 7-13-1990
	call	_screen_init_FAR
	pop	di

	or	di,di			; Write protect error?
	jnz	dce1
	ERROR	wrtprot_error, ERET_Keyboard
dce1:	cmp	di,2
	jnz	dce2
	ERROR	nodisk_error, ERET_Keyboard
dce2:	cmp	di,7
	jnz	dce3
	ERROR	badfmt_error, ERET_Keyboard
dce3:	cmp	di,0ch
	jnz	dcex
	ERROR	nonspec_error, ERET_Keyboard
dcex:	jmp	Badcrash_FAR

_Drive_critical_error	endp


;================================================================
;Display the save or load file prompt, and get a filename or abort.
; SI points to subdirectory
; DX points to message to use that prefixes "Filename: "
_fname_cheqr	proc	far
	push	dx
	mov	bx,dx
	call	_kbd_message
	call	_Space_Out
	mov	bx,offset Filename_Msg
	call	_comsg
	mov	bx,offset Temp_Wrkspce
	call	 FAR PTR _move_subdir
	call	 FAR PTR _add_backslash
	mov	al,pathname_length	; Characters allowed
	call	cimsg_add_FAR
	JMP2INITRET_IFCARRY
	jz	fnchqx			; Skip following if null string

	test	PointShootData.PQ_Flag,PQF_SAVE	; Test for SAVE FILE request
	jz	fnchq0

; Test for Spaces in filename
	push	di
	push	bx			; Save start of inputted string
	push	cx			; Save line length
	push	es			; Save ES
	push	ds			; Make ES = Data segment
	pop	es

	cld				; Scanning in forward direction
fnchq0a:mov	al,[bx]			; Get character
	call	_make_ucase	; Make uppercase
	mov	[bx],al			; Store it back as uppercase
	inc	bx			;  and point to next
	or	al,al			; End of line?
	jz	fnchq0b			;  Bailout if EOL
	mov	cx,53			; 53 characters to check
	mov	di,offset Fnchars_Table	; Point to filename characters table
	repnz scasb			; Look for character in table
	jcxz	IllegalFilename		; Error if CX = 0
	jmp	fnchq0a

fnchq0b:pop	es
	pop	cx
	pop	bx
	pop	di

fnchq0:	push	bx			; Save string start

	mov	bl,ch			; Get line length to BX
	mov	bh,0
	dec	bx
	add	bx,offset Temp_Wrkspce	; Point to end of line

fnchq1:	cmp	byte ptr [bx],' '
	jnz	fnchq2
	dec	bx
	jmp	fnchq1

fnchq2:	cmp	byte ptr [bx],'\'	; Ends with subdirectory?
	jz	fnchq3
	cmp	byte ptr [bx],':'	; Ends with Drive?
fnchq3:	pop	bx

fnchqx:	pop	dx
	clc
	ret

IllegalFilename:
	pop	es			; Restore stack
	pop	cx
	pop	bx
	pop	di
	call	_error_bell
	norm_VIDEO FALSE,FALSE
	mov	bx,offset BadDOSfname_Msg ; Display error message
	call	_kbd_message
	cmp	al,' '
	jnz	ilglfn1
	mov	bx,offset Space_Msg
	call	_comsg
	jmp	ilglfn2
ilglfn1:call	_ConOut
ilglfn2:mov	bx,offset InDosFname_Msg
	call	_comsg
	mov	bx,offset Pagend_Msg
	call	_comsg
	call	_Cursor_On
	call	keyhold_FAR		; Get keystroke only
	pop	dx			; Restore prompt message
	jmp	_fname_cheqr
_fname_cheqr	endp


;================================================================
;Translate ASCII line at BX to current event
_ASCII2EDL	proc	far
	mov	di,Current_Event_Adr		; DI gets destination address
	mov	es:byte ptr [di].cmnt_lofst,Editline_EDIT ; Indicate EDIT

; Convert ASCII line number to 16bit and store it
	call	_convert2bin		; Return with # in AX
	mov	es:[di],ax

;	*EXCEPTION*
; Occasionally, Convergence puts out a '?' in the edit number field
; If so, BX will probably be pointing to it
A2E1:	mov	al,[bx]
	cmp	al,'?'
	jnz	A2E2
	inc	bx
	jmps	A2E1

; Save the REEL ASSIGNMENT
A2E2:	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst	; Point to REEL #
	call	_adv2chr		; _adv2chr to next non-space
	call	_left_set2edl		; Move reel# + pad

; Save the EDIT MODE
	call	_adv2chr		; Index over to ASCII MODE
	call	_E_flgs			; Get Flags
	test	al,E_Flag_exactav
	jz	A2E2_c
	mov	al,[bx]
	cmp	al,'V'
	jz	A2E2_c
	cmp	al,'4'
	jz	A2E2_c1
	cmp	al,'3'
	jz	A2E2_c2
	cmp	al,'2'
	jz	A2E2_c3
	cmp	al,'1'
	jz	A2E2_c4
	jmp	A2E2_c

A2E2_c1:dec	bx
A2E2_c2:dec	bx
A2E2_c3:dec	bx
A2E2_c4:dec	bx
	jmp	A2E2_c

A2E2_c:	call	 FAR PTR _red_parser		; Parse out a MODE
	mov	es:[di].mode_lofst,al
	call	_E_mod_l		; Get mode length
	add	bx,ax			; Skip over ASCII mode

; Save the TRANSITION TYPE
	call	_adv2chr	; Get trans type
	mov	es:[di].type_lofst,al	; And store it
	inc	bx			; Increment source pointer
	cmp	al,'C'			; Is it a cut?
	jnz	A2E2_a
	jmp	prs2e1

A2E2_a:	cmp	al,'K'			; is it a key?
	jz	A2E3
	jmp	A2E4

;................................................................
; If a KEY, determine gender, etc...
; 1. advance to next character
; 2. If its a "B" then this is the first line
;    Anything else, its the second line
;
A2E3:	or	es:word ptr [di].Flags_lofst,key_Fmask ;Set key Flag
	call	_adv2chr	; Look for next character, # = effect
	cmp	al,'B'			; First line "Background?"
	jz	A2E3_nn			; Process rest of FIRST KEY LINE

; Gets here ONLY IF SECOND LINE OF KEY
	cmp	al,'O'			; Second line KEY OUT?
	jnz	A2E3_K2
	or	es:byte ptr [di].keyFlags_lofst,fadeout_Kmask ;Set key Flag
	inc	bx
	call	_adv2chr	; advance (hopefully) to efx dur
	jmp	A2E3_ok

; Gets here if second line of key an NO "O" (KEY OUT) found
A2E3_K2:cmp	byte ptr 2[bx],':'	; If its the play in then KEY_ON
	jz	A2E3_K3
	or	es:byte ptr [di].keyFlags_lofst,fadein_Kmask ;Set key Flag
	jmp	A2E3_ok
A2E3_K3:jmp	prs2e3			; If so, skip the rest

A2E3_ok:call	_convert2bin	; Get KEY effect duration
	mov	es:[di].efxdur_lofst,ax	; Save key effect duration
	jmp	prs2e3			; Save the ins and outs, etc.

; Save B (F) and O information to keyFlags
A2E3_nn:or	es:byte ptr [di].keyFlags_lofst,back_Kmask
	inc	bx			; Skip over "B"
	call	_adv2chr	; Go to next
	cmp	al,'('			; (F) fade?
	jnz	A2E3_cn
	inc	bx
	inc	bx			; Skip over (F)
	or	es:byte ptr [di].keyFlags_lofst,ftb_Kmask
A2E3_cn:jmps	prs2e3			; Get timecode in/out stuff, etc.

;----------------------------------------------------------------
; If not a CUT, then save EFFECT PARAMETERS
A2E4:	cmp	al,'D'
	mov	ax,0			; Set for no wipe number
	jz	prs2e0

	call	_adv2chr	; Index over to wipe number
	call	_convert2bin	; Get WIPE number

prs2e0:	mov	es:[di].efxnum_lofst,ax	; Save wipe number
	call	_adv2chr	; Index to effect dur
	call	_convert2bin	; Get WIPE number
	mov	es:[di].efxdur_lofst,ax	; Save effects duration
	jmps	prs2e3

; If CUT, zero effect number and effect duration
prs2e1:	xor	ax,ax
	mov	es:[di].efxnum_lofst,ax	; Save wipe number
	mov	es:[di].efxdur_lofst,ax	; Save effects duration

; Index to and save the PIN, POUT, RIN, ROUT
prs2e3:	call	_adv2chr	; Find the Play IN time code

;...	SECTION ADDED TO PREVENT BAD FCM INFORMATION FOR CONVERGENCE EDLS:
	push	bx		; save the Play IN time code position

	call	_E_flgs
	test	al,E_Flag_fcmtail
	jz	prs_NoFcmTail

	call	_adv2spc	; Move to Play Out
	call	_adv2chr
	jc	prs_NoFcmTail

	call	_adv2spc	; Move to Rec In
	call	_adv2chr
	jc	prs_NoFcmTail

	call	_adv2spc	; Advance to Rec Out
	call	_adv2chr
	jc	prs_NoFcmTail

	call	_adv2spc	; Advance to FCM
	call	_adv2chr
	jc	prs_NoFcmTail
	mov	Last_Fcm,al
	inc	bx

	call	_adv2chr
	jc	prs_NoFcmTail
	mov	es:Edl_Fcm,al

prs_NoFcmTail:
	pop	bx		; Restore the Play IN time code position
;...

	mov	dx,offset ZeroBase.pin_lofst
	mov	cl,Last_Fcm
	call	 FAR PTR _evnttcp			; Move TC from ds:BX to es:DX+SI

	mov	dx,offset ZeroBase.pout_lofst
	mov	cl,Last_Fcm
	call	 FAR PTR _evnttcp

	mov	es:[di].ptcd_lofst,cl

	mov	dx,offset ZeroBase.rin_lofst
	mov	cl,es:Edl_Fcm
	call	 FAR PTR _evnttcp

	mov	dx,offset ZeroBase.rout_lofst
	mov	cl,es:Edl_Fcm
	call	 FAR PTR _evnttcp

	mov	es:[di].rtcd_lofst,cl
	mov	es:Edl_Fcm,cl

	mov	dx,di
	add	dx,offset ZeroBase.rin_lofst
	call	_calc_evdur

; Check for R marks	----------------
	call	rmarkck
	jc	prs2ex

	call	_E_flgs
	test	al,E_Flag_fcmtail
	jz	prs2ex

	call	_adv2chr
	jc	prs2ex
	mov	es:[di].ptcd_lofst,al
	inc	bx

	call	_adv2chr
	jc	prs2ex
	mov	es:[di].rtcd_lofst,al
	inc	bx

	call	rmarkck

prs2ex:	mov	bx,di
	add	bx,offset ZeroBase.ptcd_lofst
	cmp	es:byte ptr [bx],0
	jnz	prs2ex1
	mov	al,Last_Fcm
	mov	es:[bx],al
prs2ex1:inc	bx
	cmp	es:byte ptr [bx],0
	jnz	prs2ex2
	mov	al,Rtcf
	mov	es:[bx],al
prs2ex2:clc
	ret

_ASCII2EDL	endp

; Check for R marks
rmarkck	proc	near
	call	_adv2chr	; Check for TCF indicators
	jc	nset_rc
	cmp	al,'+'			; R-mark?
	jz	set_rm
	cmp	al,'R'
	jz	set_rm
	cmp	al,'*'
	jnz	nset_rm
set_rm:	or	es:word ptr [di].Flags_lofst, disabled_Fmask
	inc	bx
nset_rm:clc
nset_rc:ret
rmarkck	endp

_read_convert	proc	far
	mov	al,Frame_Flag
	push	ax
	mov	Frame_Flag,0
	call	 FAR PTR _evnttcp
	pop	ax
	mov	Frame_Flag,al
	ret
_read_convert	endp


; Convert ASCII code into 24bits
; ENTER: DX = offset from DI for this time code number
;	 CL = default FCM setting
; CL returns with "D"rop or "N"ondrop
_evnttcp	proc	far
	call	 FAR PTR _aftrspc
	call	_E_flgs
	test	al,E_Flag_semicol	; Using colon/semicolon FCM?
	jz	ettcp2			; Skip if not.
	mov	al,8[bx]		; Else, get the colon or semicolon
	mov	cl,NDF_CHAR		; Prepare for nondrop
	cmp	al,':'			; Is it really nondrop?
	jz	ettcp2			; Yes, so jump
	mov	cl,DF_CHAR		; Else it is drop frame
ettcp2:	add	dx,di			; Get destination address
	push	bx			;Save source
	push	cx
	call	_cnvt2mp_ES		;Convert string to 24 bit number
	pop	cx
	pop	bx			;Restore source address
	add	bx,12			; and index to next TC
	ret
_evnttcp	endp

;-------------------------------------------------
;  M E M O R Y	 M O V E   S U B R O U T I N E S
;-------------------------------------------------
;Index to the next character after Spaces or a line feed
;Return with C=1 if CR, else A=character, BX=address

_aftrspc	proc	far
	mov	al,[bx]
	cmp	al,cr			; If CR, we are done
	jnz	JL0910
	stc
	ret
JL0910:	inc	bx			; Index to next, just in case
	cmp	al,lf			; If its a linefeed
	jz	_aftrspc		; Skip it
	cmp	al,' '			; If its a space
	jz	_aftrspc		; Skip it
	dec	bx			; Else index back,
	or	al,al			; Clear carry
	ret				; And were done.
_aftrspc	endp


;================================================================
; USED BY READ FILE / PARSE EDIT LINE ROUTINES
; Parses out a mode byte from the string at BX
; Enter: DS:BX points to first character in reel
; Exit:  BX unchanged
;	 AL = mode byte
_red_parser	proc	far
	push	bx			; Save pointer to edit mode
	mov	dx,bx			; Same pointer to DX
	call	_E_mod_l		; Retrieve current MODE LENGTH to AL
	mov	ch,al			; Number of characters to compare
	mov	cl,al
	mov	bx,es:Mode_Pntr		; Get current mode pointer
	mov	bx,[bx]			; Get pointer to mode types
redplp:	mov	al,[bx]			; End of modes?
	inc	al
	stc
	jz	redrx
	inc	bx			; Point past mode byte
	xchg	bx,dx
	push	es			; _cmpchr uses ES:
	push	ds			;  and we need to compare
	pop	es			;  two strings from within
	call	_cmpchr			;  the data segment.
	pop	es
	xchg	bx,dx
	jnz	redprs1
	dec	bx
	mov	al,[bx]
redrx:	pop	bx
	ret
redprs1:mov	al,cl
	cbw
	add	bx,ax
	jmps	redplp
_red_parser	endp


;================================================================
; Check for SPLIT: line
; Return with Z=1 if successful find, else Z=0
;================================================================
_Check_4_tstamp	proc	far
	mov	si,offset Tstamp_EDLev
	jmp	_EDLevck
_Check_4_tstamp	endp
_Check_4_starts	proc	far
	mov	si,offset Start_EDLev
	jmp	_EDLevck
_Check_4_starts	endp
_Check_4_title	proc	far
	mov	si,offset Title_EDLev
	jmp	_EDLevck			; Find and return
_Check_4_title	endp
_Check_4_format	proc	far
	mov	si,offset Type_EDLev
	jmp	_EDLevck
_Check_4_format	endp
_Check_4_spl	proc	far
	mov	si,offset Split_EDLev
	jmp	_EDLevck			; Find and return
_Check_4_spl	endp
_Check_4_fcm	proc	far
	mov	si,offset Fcm_EDLev
	jmp	_c_4_pr			; Find, increment and return
_Check_4_fcm	endp
_Check_4_gpi	proc	far
	mov	si,offset Gpi_EDLev	; Find, increment and return
	jmp	_c_4_pr
_Check_4_gpi	endp
_Check_4_slave	proc	far
	mov	si,offset Slave_EDLev	; Find, increment and return
	jmp	_c_4_pr
_Check_4_slave	endp
_Check_4_spd	proc	far
	mov	si,offset Spd_EDLev	; Find, increment and return
	jmps	_c_4_pr
_Check_4_spd	endp
_Check_4_pmc	proc	far
	mov	si,offset Pmc_EDLev	; Find, increment and return
	jmps	_c_4_pr
_Check_4_pmc	endp
_Check_4_rec	proc	far
	mov	si,offset Rec_EDLev	; Find, increment and return
	jmps	_c_4_pr
_Check_4_rec	endp
_Check_4_ramp	proc	far
	mov	si,offset Ramp_EDLev	; Find, increment and return
	jmps	_c_4_pr
_Check_4_ramp	endp
_Check_4_preread	proc	far
	mov	si,offset Preread_EDLev	; Find, increment and return
	jmps	_c_4_pr
_Check_4_preread	endp

;_Check_4_reelsum	proc	far
;	mov	si,offset Reelsum_EDLev	; Find, increment and return
;	jmps	_c_4_pr
;_Check_4_reelsum	endp

_c_4_pr	proc	far
	call	 FAR PTR _EDLevck
	jnz	c_4_x
chk4x:	add	bx,cx
	call	_adv2chr
chk4x1:	cmp	al,al
c_4_x:	ret
_c_4_pr	endp

		even
_EDLevck	proc	far
	push	bx
	call	_adv2chr
	cld
	lodsb				; Get length of template
	cbw
	mov	cx,ax
	push	cx
	even
edlevc0:cld
	lodsb
	cmp	al,[bx]
	jnz	edlevc1
	inc	bx
	loop	edlevc0
	or	cl,cl
edlevc1:pop	cx
	pop	bx
	ret
_EDLevck	endp

_Check_4_record	proc	far
	cmp	byte ptr [bx],'R'
	jnz	c_4_x
	cmp	byte ptr 1[bx],'E'
	jnz	c_4_x
	cmp	byte ptr 2[bx],'C'
	jnz	c_4_x
	cmp	byte ptr 3[bx],'O'
	jnz	c_4_x
	cmp	byte ptr 4[bx],'R'
	jnz	c_4_x
	cmp	byte ptr 5[bx],'D'
	jnz	c_4_x
	cmp	byte ptr 6[bx],' '
	jnz	c_4_x
	add	bx,6
	call	_adv2chr
	stc
	ret
_Check_4_record	endp


;================================================================
; Far call command interfaces interfaces
;---------------- 1. Get the type of directory
_showdir	proc	far
	call	_kbd_cln
	mov	bx,offset findwho_ovr	; Prompt user
	call	_msgread		;  for type of directory

shd_1:	call	rdchar_FAR		; Get a character
	call	_Break_check		; Check for Exit
	jz	shd_2
	cmp	ax,offset Enter_xcmd	; Exit on [ENTER]
	jnz	shd_3
shd_2:	call	_evnt_dispthis
	ret

shd_3:	mov	cx,ax
	sub	al,'0'			; Make decimal
	jz	shder
	cmp	al,6
	jnc	shder

shd_4:	cmp	al,5			; IS IT A DOS DIRECTORY REQUEST?
	jnz	shdirs
	call	_shell2dir		; If so, display dos directory
	jmps	_showdir

shder:	mov	ax,cx
	call	keythru_FAR
	call	_error_bell
	jmps	shd_1

	; Signal NO select, paging, viewing
shdirs:	mov	PointShootData.PQ_Flag,PQF_KILLFILE OR PQF_FILEVIEW OR PQF_PAGING
	;No SAVE/LOAD/KILL allowed
	and	PointShootData.PQ_Flag,NOT (PQF_LOAD OR PQF_SAVE OR PQF_KILLFILE)
	call	 FAR PTR _shdok			; Display all info
	jmps	_showdir		;  and loop for another request
_showdir	endp

;----------------------------------------------------------------
; Display "     <---" message and " Write ..."
_pointer_write	proc	far
	call	_kbd_clr
	norm_VIDEO TRUE,TRUE
	mov	bx,offset pointer_ovr
	call	_msgread
	mov	bx,offset write_ovr
	call	_msgread
	ret
_pointer_write	endp

; Display "    <--- Load..."
_read_pointer	proc	far
	push	bx
	mov	bx,offset pointer_ovr
	call	_kbd_cln
	call	_msgread
	mov	bx,offset read_ovr
	call	_msgread
	pop	bx
	ret
_read_pointer	endp


;================================================================
; Display utilities for saving and loading files
; Enters with BX pointing to SAVE FILE or LOAD FILE message
sl_chos	proc	near
	push	bx
	call	_kbd_cln
	mov	bx,offset Current_EDL
	cmp	byte ptr [bx],0
	jz	sl_chs1
	dim_VIDEO FALSE,FALSE
	mov	al,'['
	call	_ConOut
	call	_comsg
	mov	al,']'
	call	_ConOut
	call	_Space_Out
	norm_VIDEO FALSE,FALSE
sl_chs1:pop	bx
	call	_comsg
	mov	bx,offset List_Msg
	call	_comsg
	call	yn_chos_FAR
	ret
sl_chos	endp

;================================================================
file_Exit_2keyboard:
	mov	ERROR_ACTIVE,0		; Clear error Flags
	jmp	Keyboard


; Display defaults file function plus " new defaults" message
;  and get answer
dflts_chos	proc	near
	call	dflts_msgs
	mov	cl,'N'
	call	yn_chos_FAR
	ret
dflts_chos	endp

dflts_msgs	proc	near
	call	_kbd_message
	mov	bx,offset New_Dflts_Msg
	call	_comsg
	ret
dflts_msgs	endp


;================================================================
_log_TMPfile	proc	far
	mov	Filename_Ptr,offset TMP_Subdir
	mov	bx,offset Logtmp_Msg
	call	 FAR PTR _logdrv1
	JMP_Z	logdx
	call	 FAR PTR _stash_TMPsubdir
	ret
_log_TMPfile	endp

_log_TCMfile	proc	far
	mov	Filename_Ptr,offset TCM_Subdir
	mov	bx,offset Logtcm_Msg
	call	 FAR PTR _logdrv1
	jz	logdx
	call	 FAR PTR _stash_TCMsubdir
	ret
_log_TCMfile	endp

_log_VMEfile	proc	far
	mov	Filename_Ptr,offset VME_Subdir
	mov	bx,offset Logvme_Msg
	call	 FAR PTR _logdrv1
	jz	logdx
	call	 FAR PTR _stash_VMEsubdir
	ret
_log_VMEfile	endp

_log_autofile	proc	far
	mov	Filename_Ptr,offset AUTOFILE_Subdir
	mov	bx,offset Logauto_Msg
	call	 FAR PTR _logdrv1
	jz	logdx
	call	 FAR PTR _stash_AUTOsubdir
	ret
_log_autofile	endp

_log_Drive	proc	far
	mov	Filename_Ptr,offset EDL_Subdir ; Save pointer to filespec
	mov	bx,offset Logd_Msg
	call	 FAR PTR _logdrv1
	jz	logdx
	call	 FAR PTR _stash_EDLsubdir
	ret
_log_Drive	endp

_logdrv1	proc	far
	call	_kbd_message
	mov	al,pathname_length
	call	cimsg_wrk_FAR
	jz	logdx
logdrv2:mov	si,bx
	mov	bx,offset Ascii_Line
	push	bx
	call	 FAR PTR _move_subdir
	pop	bx
	mov	dx,bx			; Path Name to DX
	mov	si,bx			;  and SI
	call	 FAR PTR _log2it
	or	si,si
logdx:	ret
_logdrv1	endp


;================================================================
; Log "back" into the default drv:subdir
_log2edldrive	proc	far
	mov	dx,offset EDL_Subdir
	jmp	_log2it
_log2edldrive	endp

_log2default	proc	far
	mov	dx,offset Home_Path
_log2default	endp
_log2it	proc	far
	call	 FAR PTR _valid_path
	mov	ah,3bh			;Log to subdirectory
	int	DOS
	jnc	_log2itx
	mov	si,offset Home_Path	; If error, log back
	call	 FAR PTR _stash_EDLsubdir;  to our original dir
log2err:ERROR	nosubdir_error, ERET_Keyboard

_log2itx:ret
_log2it	endp

; Check for valid
_valid_path	proc	far
	push	si			; Save SI
	mov	si,dx			; Get ASCIIZ path to SI
vp1:	lodsb				; Locate end of line
	or	al,al
	jnz	vp1
	dec	si			; Check for NULL PATH
	dec	si
	cmp	si,dx
	jz	log2err
	mov	al,[si]			; Get character before 0
	cmp	al,':'			; Ends with Drive colon?
	jz	vpaddbs
	cmp	al,'\'			; Ends with backslash?
	jnz	vpxit
	dec	si			; If so, then check for Drive ':'
	lodsb
	cmp	al,':'
	jz	vpxit
	jmps	vpdelbs

vpaddbs:inc	si
	mov	byte ptr [si],'\'
	inc	si
vpdelbs:mov	byte ptr [si],0
vpxit:	pop	si
	ret
_valid_path	endp

; Directly log new EDL path
; BX points to source Name (if any)
_log_immediate	proc	far
	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di

; First see if the end character is a '\'
	cmp	byte ptr [bx],0
	jz	logimx

	mov	si,bx
logima:	cmp	byte ptr [si],0
	jz	logimb
	inc	si
	jmp	logima
logimb:	dec	si
	cmp	byte ptr [si],'\'
	jnz	logimx

	mov	si,bx		; SI points to the new subdirectory
	mov	bx,offset Ascii_Line
	push	bx
	call	 FAR PTR _move_subdir
	pop	bx
	mov	dx,bx			; Path Name to DX
	mov	si,bx			;  and SI
	call	_log2it
	jc	logimx

	mov	al,Dirtype
	mov	bx,offset EDL_Subdir
	cmp	al,1
	jz	logim1
	mov	bx,offset Home_Path
	cmp	al,2
	jz	logim1
	mov	bx,offset TCM_Subdir
	cmp	al,3
	jz	logim1
	mov	bx,offset VME_Subdir
	cmp	al,4
	jz	logim1
	mov	bx,offset EDL_Subdir

logim1:	call	 FAR PTR _move_subdir
	clc
logimx:	pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret
_log_immediate	endp

;................................................................
_Set_AutoFile	proc	far
	mov	bx,offset Backup_File + 4
	mov	dx,cx
	call	_dec1000_pad
	mov	bx,offset Ascii_Line
	mov	si,offset AUTOFILE_Subdir
	call	 FAR PTR _move_subdir
	call	 FAR PTR _add_backslash
	mov	si,offset Backup_File
	call	 FAR PTR _move_subdir
	jz	inw2dw			; NZ if '.' not found
	mov	byte ptr [bx],'.'
	inc	bx
	mov	si,offset Edl_Ext	; Move the "EIF" extension
	call	 FAR PTR _move_subdir
	mov	dx,offset Ascii_Line
inw2dw:	ret

_Set_AutoFile	endp


;================================================================
;	INITIATE SAVE TO DISK
;================================================================
; Enter with DX already pointing to a Save_ or _load_file message
_init_EDL	proc	far
	mov	bx,offset Current_EDL	; Default filename
	mov	di,offset Saveload_EDL	; Where to put Name
	mov	si,offset EDL_Subdir	; Where to get subdirectory
	mov	al,1			; EDL directory type
	jmp	_init_file
_init_EDL	endp

;================================================================
;	INITIATE FOR DELETE FILE FUNCTION
;================================================================
_init_KILL	proc	far
	mov	bx,offset Current_EDL	; Default filename
	mov	dx,offset Kilfil_Msg	; kill file message
	mov	di,offset Saveload_EDL	; Where to put Name
	mov	si,offset EDL_Subdir	; Where to get subdirectory
	mov	al,1			; EDL directory type
	jmp	_init_file
_init_KILL	endp

;================================================================
; 	INITIATE FOR A VME FILE READ OR WRITE
;================================================================
_init_VME	proc	far
	mov	bx,offset Current_EDL	; Default filename
	mov	dx,offset Emem_File_Msg	; EMEM file message
	mov	di,offset Saveload_EDL	; Where to put Name
	mov	si,offset VME_Subdir	; Where to get subdirectory
	mov	al,4			; E-MEM directory type
	jmp	_init_file		; Get and Find file
_init_VME	endp

;================================================================
; 	INITIATE FOR A MACRO FILE READ OR WRITE
;================================================================
_init_MACRO	proc	far
	mov	bx,offset Current_EDL	; Default filename
	mov	dx,offset Macro_File_Msg; Save file message
	mov	di,offset Saveload_EDL	; Where to put Name
	mov	si,offset TCM_Subdir	; Where to get subdirectory
	mov	al,3			; MACRO directory type
	jmp	_init_file		; Get and Find file
_init_MACRO	endp

;================================================================
; 	INITIATE FOR A DEFAULTS FILE READ OR WRITE
;================================================================
_init_DFLTS	proc	far
	mov	bx,offset Default_File	; Default filename
	mov	dx,offset Dflt_File_Msg; Save file message
	mov	di,offset Saveload_EDL	; Where to put Name
	mov	si,offset Home_Path	; Where to get subdirectory
	mov	al,2			; MACRO directory type
	jmp	_init_file		; Get and Find file
_init_DFLTS	endp

;================================================================
;	INITIATE FOR DIRECTORY READ
;================================================================
; Temp_Wrkspce must already have the filename
_init_DIR	proc	far
	mov	Initfile_Retadr,sp
	mov	dx,offset _Save_File_Msg	; Save file message
	mov	di,offset Saveload_EDL	; Where to put Name
	mov	al,Dirtype
	lea	si,EDL_Subdir
	cmp	al,1
	jz	inidir1
	lea	si,Home_Path
	cmp	al,2
	jz	inidir1
	lea	si,TCM_Subdir
	cmp	al,3
	jz	inidir1
	lea	si,VME_Subdir
	cmp	al,4
	jz	inidir1
	mov	si,offset Home_Path
inidir1:mov	Dirsub_Adr,si		; Save address of subdirectory Name
	mov	bx,di			; Destination to BX
	call	 FAR PTR _move_subdir		; SI points to subdirectory to move
	call	 FAR PTR _add_backslash
	jmps	inisf_3
_init_DIR	endp

;================================================================
;	FIND FILE FOR READ/WRITE/DELETE OPERATIONS
;================================================================
; ENTER: DX = screen message
;	 BX = pointer for default filename or ZERO if no default
;	 DI = buffer to put subdir and filename to
;	 SI = subdirectory path (if any)
;	 AL = directory type
; Exit:  Carry = 1 (set) if file could not be found
;		 else, carry is cleared
_init_file	proc	far
	mov	Dirtype,al
	mov	Initfile_Retadr,sp

	mov	Filename_Ptr,bx		; Save pointer to file Name/path
inisf_1:push	ax
	call	_fname_cheqr		; Log DIR, Get Fname
	pop	ax
	jz	inifdir

inisf_2:mov	bx,di			; Destination to BX
	call	 FAR PTR _check4path		; Is there a path involved?
	jz	inisf_3			; If so, don't move default subdir
	call	 FAR PTR _move_subdir		; SI points to subdirectory to move

	call	 FAR PTR _add_backslash		; Add backslash, if necessary
inisf_3:mov	si,offset Temp_Wrkspce	; Point to filename
	call	 FAR PTR _move_subdir		; Move filename
	jz	iw2d_1
	mov	byte ptr [bx],'.'
	inc	bx
	mov	si,offset Edl_Ext
	dec	al
	jz	inisf_4
	mov	si,offset EIF_Ext
	dec	al
	jz	inisf_4
	mov	si,offset TCM_Ext
	dec	al
	jz	inisf_4
	mov	si,offset VME_Ext

inisf_4:call	 FAR PTR _move_subdir
iw2d_1:	mov	byte ptr [bx],0
	mov	dx,di			; DS:DX points to ASCIIZ string
	xor	cx,cx			; "Normal" attributes
	mov	ah,4eh			; Search for first
	int	DOS
	ret
_init_file	endp

;	 BX = possible new path
;	 DI = buffer to put subdir and filename to
;	 SI = subdirectory path (if any)
inifdir	proc	near
	push	ax			; Display directory
	push	dx			;  and recycle
	push	si
	push	di

	cmp	byte ptr [bx],0		; Any thing there?
	jz	inifdir1
	call	_log_immediate
	jnc	inifdir1
	ERROR	file_not_found, ERET_Return	;Keyboard
	jmp	inisf_1
inifdir1:
	push	Initfile_Retadr
	call	 FAR PTR _shdok			;  for another
	pop	Initfile_Retadr
	pop	di
	pop	si
	pop	dx			;  filename prompt
	pop	ax
	jmp	inisf_1			; Recycle to start
inifdir	endp


;================================================================
;	CREATE OR TRUNCATE AN EDL FILE AND WRITE HEADER
;================================================================
; Enter: Carry = 1 (set) if we are making new file
;	 DI points to filename
;
; Exit:  Carry = 0 (clear) if file successfully created
;		 and the header was written
_init_write	proc	far
	jc	inisfww			; Jump if file not found
	mov	bx,offset overwrite_ovr
	mov	cl,'N'
	call	pos_yn_chos_FAR
	jnz	inisfwc
inisfww:mov	dx,di
	call	 FAR PTR __init_filewrite
	ret
inisfwc:stc				; Set carry
	ret				;  and Exit
_init_write	endp

; Write header
_init_header	proc	far
	call	 FAR PTR _OutCRLF	; Write a leading CRLF
	mov	bx,offset File_Title
	mov	dx,offset Ascii_Line
	mov	ch,80h
	call	 FAR PTR _title_loop_DS
	call	CapWrite_Ascii_Line	; Make line all caps and write it
	call	 FAR PTR _OutCRLF	; Add carriage return/line feed
	call	_force_fcm
	jc	ih3			; Carry set if NO fcm line to write
	call	 FAR PTR _output_line

; Write the format type
ih3:	call	StarSpace
	mov	bx,offset Type_Header
	call	 FAR PTR _output_line

	mov	bx,es:Mode_Pntr
	add	bx,offset ZeroBase.E_edl_Name
	call	 FAR PTR _output_line
	call	 FAR PTR _OutCRLF

; Write the start time
	mov	bx,offset Time_Start
	call	_time_value
	jz	ih4

	call	StarSpace
	mov	bx,offset Start_Header
	call	 FAR PTR _output_line
	mov	bx,offset Time_Start
	mov	dx,offset Tcdispbuf
	mov	cl,es:Edl_Fcm
	call	_cnvt2tc_DS
	call	 FAR PTR _output_line
	call	 FAR PTR _OutCRLF

ih4:	call	StarSpace
	mov	bx,offset Tstamp_Header
	call	 FAR PTR _output_line

	mov	bx,offset Ascii_Line	; Setup pointer for
	mov	Temp_Tc_Buf,bx		;  ASCII decimal bytes
	push	bx			; Save pointer for a later display
	mov	Cursor,0		; Set to upper left
	call	timestamp_FAR		; Get the time
	pop	bx			; Restore the pointer

	call	CapWrite_Ascii_Line	; Make line all caps
	mov	bx, SpacePointer(8)
	call	 FAR PTR _output_line

	mov	bx,offset EdlSES
	mov	dx,offset Ascii_Line
	mov	ch,40			; More that adequate
	call	 FAR PTR _title_loop
	call	CapWrite_Ascii_Line	; Make line all caps
	mov	bx,offset Ascii_Line
	push	bx

	mov	word ptr [bx],'NS'	; SN (serial number)
	inc	bx
	inc	bx

	mov	dx,bx
	mov	bx,offset Seriel_Num
	mov	ch,4
	call	_mmv
	mov	bx,dx
	mov	[bx],ch
	pop	bx
	call	 FAR PTR _output_line
	call	 FAR PTR _OutCRLF

	call	 FAR PTR _OutCRLF	; Add a blank line
	clc
	ret
_init_header	endp

StarSpace	proc	near
	mov	bx,offset Starspace_Msg
	call	 FAR PTR _output_line
	ret
StarSpace	endp

;================================================================
CapWrite_Ascii_Line	proc	near
	call	_E1_flgs	; Get EDL format Flags byte2
	mov	bx,offset Ascii_Line	;  TITLE line all caps
	test	al,E1Flag_allcaps	; Use all CAPS if set
	jz	CWALN			; Else, just output the line
	push	bx
CWALlp:	mov	al,[bx]
	call	_make_ucase
	mov	[bx],al
	inc	bx
	or	al,al
	jnz	CWALlp
	pop	bx
CWALN:	call	 FAR PTR _output_line
	ret
CapWrite_Ascii_Line	endp

;================================================================
;	WRITE ASCII LINE OUT TO OPEN FILE HANDLE
;================================================================
output_line_ES	proc	near
	mov	dx,offset Ascii_Line
	mov	ch,128
	push	dx
	call	_mmv_ESDS
	pop	bx
	call	 FAR PTR _output_line
	ret
output_line_ES	endp


;================================================================
;    WRITE EDL LINE TO FILE HANDLE FOR AUTO-OUTPUT TO DISK
;		autosave / auto backup / dsk
;================================================================
_write2disk	proc	far
	test	Operational_Flags,diskon_OPBIT	; Check for output on
	JMP_Z	w2d_r
	mov	cl,Active_Bin
	mov	ch,0
	call	_Set_AutoFile		; DS:DX points to ASCIIZ string

	mov	ax,3d02h		; Open file, read/write
	call	 FAR PTR _SaveLoadFile_AHfunc
	jc	w2d_err			; No carry of all ok

	push	es:Current_Event	; Save current event number
	mov	bx,ax			; BX = file handle
	xor	cx,cx			; Set CX and DX
	mov	dx,cx			;  to zero
	mov	ax,4202h		; Find end of file
	int	DOS			; Move to end of file
	jnc	w2d_2

; ERROR Exit
w2d_err:xor	al,al
	and	Operational_Flags,not (diskon_OPBIT or asyougo_OPBIT)
	call	Diskon_Upd_FAR		; Clear all AUTO DISK Flags
	call	 FAR PTR _SaveLoadFile_Close
	ERROR	file_error, ERET_Keyboard

w2d_2:	or	dx,ax			; Is file empty?
	jnz	w2d_2a
	call	_init_header		; Write file header (BX rets w/handle)
w2d_2a:	mov	ax,es:Current_Event	; Point to first line
	call	writeone		; Write a line
	call	_index_storage
	jc	w2d_3			; Look for other comments

	FLAGBITS dblline_Fmask
	jz	w2d_3			; NZ if double line
	inc	ax
	call	writeone		; Write second line

w2d_3:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jnc	w2d_5
	call	_index_storage
	jnc	w2d_5
	mov	Last_Fcm,0		; Force an FCM: line
	call	writeone
	jmps	w2d_3

w2d_4:	call	 FAR PTR _DiskOut		; Write to file
w2d_5:	call	 FAR PTR _SaveLoadFile_Close
	pop	ax			; Restore current event number
	call	_index_storage
w2d_r:	ret
_write2disk	endp

;================================================================
;	READ WRITE ROUTINES FOR RECEIVE EDL FUNCTION
;================================================================
; BX has address of last byte written to Memory (offset 100h)
_edl_write	proc	far
	push	bx			; Save address of last byte
	mov	dx,offset _Save_File_Msg	; Save file message
	call	_init_EDL
	RETURN_IFCARRY		; 7-11-1992 

	call	_init_write
	pop	cx			; CX = address of last byte
	mov	dx,offset Event_Storage	; Start of buffer
	sub	cx,dx			; Subtract offset of EDL base
	mov	ah,40h			; Write file function
	mov	bx,Saveload_Handle
	push	ds
	push	es
	pop	ds
	int	DOS
	pop	ds
	cmp	ax,cx
	jz	edl_rwx
	call	 FAR PTR _SaveLoadFile_Close
	ERROR	diskfull_error, ERET_Keyboard
_edl_write	endp

_edl_read	proc	far
	mov	ax,4200h		; Move file pointer (set it)
	xor	cx,cx			;  to beginning
	mov	dx,cx			;  of file.
	call	 FAR PTR _SaveLoadFile_AHfunc
	call	loadxfr_FAR
	call	 FAR PTR _SaveLoadFile_Close
edl_rwx:ret
_edl_read	endp


;===================================
;	SAVE EDL TO DISK FILE
;===================================
; 1/12/89 re-write
_save_file	proc	far
	call	_check4edl		; Skip if no EDL
	jz	savfilx

	test	Sounddisplay_Flags,recheck_SDBIT
	jz	savetry

	mov	bx,offset _Save_File_Msg	; Shall we save?
	mov	cl,'N'
	call	sl_chos
	jnz	savfilx
	call	 FAR PTR savetry
savfilx:ret
_save_file	endp

; Initiate file
savetry	proc	far
	; Set for save file,paging,file view
	mov	PointShootData.PQ_Flag,PQF_SAVE OR PQF_KILLFILE OR PQF_KEYTHRU OR PQF_FILEVIEW OR PQF_PAGING
	mov	dx,offset _Save_File_Msg	; "SAVE" message
	call	_init_EDL		; Log to edl Drive, Get filename
	RETURN_IFCARRY		; 7-11-1992 
	lahf
	mov	FileExists_Flag,ah	; Save Flag

	mov	ax,es:Current_Event	; Save current event
	mov	Byte_Store_1,ax		;  to Byte_Store_1

	mov	bx,offset withthis_ovr
	mov	cl,'Y'
	call	pos_yn_chos_FAR
	JMP_C	file_Exit_2keyboard
	jz	savetr1

	mov	bx,offset Page_Qry
	call	_kbd_message
	mov	al,4
	call	dec_cimsg_FAR
	jz	_save_file		; Start from top if null
	call	_convert2bin
	mov	bx,ax
	call	_find_edit_BX
	jz	savetr2
	ERROR	out_of_range, ERET_Keyboard

savetr1:mov	ax,1			; Go to the top of the EDL

savetr2:push	ax
	mov	ah,FileExists_Flag
	sahf
	call	_init_write
	pop	ax
	jc	savetry

	push	ax
	call	 FAR PTR _move_default	; Save inputted filename w/[DI...]
	call	_init_header
	pop	ax

	mov	cx,ax
	call	_index_storage

	and	EDLoptions_Flags,not outdur_EDLBIT; Go back to using out points
	mov	Last_Fcm,0		; Force new FCM:

	push	cx
	call	_pointer_write		; Display "  <--"
	pop	cx
	call	WriteEdits_CX
	ret
savetry	endp

;----------------------------------------------------------------
; Mail loop for writing events to disk
WriteEdits_CX	proc	near
	mov	ax,cx			; CX has next line to write
	push	cx			;  save CX for next iteration
	call	_evnum			; Tell user which line on CRT
	call	writeone
	pop	cx			; Restore line number
	inc	cx			; Point to next
	mov	ax,cx
	cmp	ax,es:Next_Avail_Num
	jc	WriteEdits_CX
	call	 FAR PTR _SaveLoadFile_Close

	test	Operational_Flags,askdskclr_OPBIT
	jz	savtx
	test	Operational_Flags,asyougo_OPBIT	; Auto output already on?
	jz	savtx
	test	Operational_Flags,diskon_OPBIT	; Are we actually writing?
	jz	savtx
	call	init_w2d_FAR
savtx:	mov	ax,Byte_Store_1
	call	_event_display
	mov	bx,offset Saved_Msg
	call	 FAR PTR _file_messages
	ret
WriteEdits_CX	endp

;Write one whole event
writeone	proc	near
	mov	dx,Operational_Flags
	push	dx
	and	Operational_Flags,not frame_OPBIT; Set for TC formatted only
	and	EDLoptions_Flags,not outdur_EDLBIT; Set for normal out points

	push	ax			; Save event number
	call	_index_storage	; Index to it
	jc	wrtlin3			; Process comment
	push	bx			; Save line address
	call	_wrt_fcm		; Write any FCM: changes
	jc	wrtlin1
	call	 FAR PTR _output_line

wrtlin1:pop	bx
	push	bx
	call	_wrt_split		; Write any split edit info
	jc	wrtlin2
	call	 FAR PTR _output_line

wrtlin2:pop	bx			; Restore line address
wrtlin3:call	_EDL2ASCII
	call	 FAR PTR _output_line
	call	_E_flgs
	test	al,E_Flag_dblline
	jz	wrtlin5
	mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask
	jnz	wrtlin5
	call	 FAR PTR _OutCRLF
wrtlin5:call	 FAR PTR _OutCRLF
	pop	ax
	pop	dx
	mov	Operational_Flags,dx
	ret
writeone	endp

;================================================================
;			FILE LOAD ROUTINES
;================================================================
_load_file	proc	far
	test	Sounddisplay_Flags,recheck_SDBIT
	jz	loadf_2
	call	_check4edl		; Z=1 if no EDL
	mov	cl,'N'			; Default N if EDL
	jnz	loadf_1
	mov	cl,'Y'			; If no edl, default Y
loadf_1:mov	bx,offset _Load_File_Msg
	call	sl_chos
	jz	loadf_2
	ret

	; Set for load file,paging,file view
loadf_2:mov	PointShootData.PQ_Flag,PQF_LOAD OR PQF_KILLFILE OR PQF_KEYTHRU OR PQF_FILEVIEW OR PQF_PAGING
	mov	dx,offset _Load_File_Msg
	call	_init_EDL
	RETURN_IFCARRY		; 7-11-1992 
	mov	dx,di
	call	 FAR PTR _SaveLoadFile_Open ; Open file, read only, save handle
	jnc	loadf_3
	ERROR	file_not_found, ERET_Return
	jmp	_load_file

loadf_3:call	 FAR PTR _move_default	; Save inputted filename with [DI...]
	call	loadxfr_FAR	; Load the file
	call	 FAR PTR _SaveLoadFile_Close
	mov	ax,Temp_Event
	call	_event_display
	call	running_time_FAR
	call	match_RESET_FAR		; Reset match Flags
	mov	bx,offset Loaded_Msg
	call	 FAR PTR _file_messages
	ret
_load_file	endp

;================================================================
; Save all EMEM registers to disk files
_EMEM_save	proc	far
	mov	al, video_IOTYP
	test	Device_Present,al
	JMP_Z	VS1222
	mov	Active_IOTYP,al

	; Set for save file,paging
	mov	PointShootData.PQ_Flag,PQF_LOAD OR PQF_SAVE OR PQF_PAGING
	call	_init_VME
	cmp	ax,offset Escape_xcmd
	JMP_Z	VS1222

	call	_init_write		; Open for read/write
	jc	_EMEM_save
	call	 FAR PTR _move_default	; Save inputted filename w/[DI...]
	call	 FAR PTR _getvideo_ttl		; Title this file
	call	_EFXscreen
	call	_pointer_write
	mov	Active_IOTYP,video_IOTYP
	mov	dx,offset SESID	; Write SES Signature string
	mov	cx,2
	call	 FAR PTR _DiskOut

	mov	bx,offset Work_Event
	push	bx
	mov	byte ptr [bx],'['	; Place opening bracket
	inc	bx			; Point for next characters
	mov	dx,bx			; Destination to DX
	call	_GetSXcb_Name		; Get Name of switcher
	mov	ch,8			; 8 characters to move
	call	_mmv			; Move 'em
	mov	bx,dx			; Get destination
	mov	word ptr [bx],' ]'	; Close bracket, add space
	pop	dx
	mov	cx,11
	call	 FAR PTR _DiskOut

	mov	dx,offset Video_Header	; Write the header title
	mov	cx,MAXEMEMLENGTH-2-11	; Size of video header (less signature)
	call	 FAR PTR _DiskOut

;9-21-1994 Check for # of Vlan_Emems if necessary
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	efxwnvl
	mov	bx,Vlan_Emems
	jmp	efxwvl
efxwnvl:call	_GetSXcb_emems		; Get # of emem regs
efxwvl:
;...
	mov	dx,bx
	and	dx,07fh			; Mask out upper 9 bits
	xor	cx,cx
efxwagn:cmp	cx,dx			; All done?
	jz	efxsdon

	mov	Cursor,1800h
	mov	al,cl
	call	_a_DecOut

	push	cx
	push	dx
	call	read_emem_FAR		; Get a register
	mov	dx,bx			; Get EMEM buffer pointer to DX
	mov	cx,MAXEMEMLENGTH	; Length of buffer to write
	call	 FAR PTR _DiskOut
	pop	dx
	pop	cx
	inc	cx
	jmp	efxwagn

efxsdon:call	 FAR PTR _SaveLoadFile_Close
	mov	bx,offset Saved_Msg
	call	 FAR PTR _file_messages
VS1222:	ret
_EMEM_save	endp

;================================================================
_EMEM_load	proc	far
	mov	al, video_IOTYP
	test	Device_Present,al
	jz	VS1222
	mov	Active_IOTYP,al

	; Set for LOAD file, paging
	mov	PointShootData.PQ_Flag,PQF_LOAD OR PQF_KILLFILE OR PQF_PAGING
	call	_init_VME
	RETURN_IFCARRY		; 7-11-1992 
	call	 FAR PTR _init_READ
	call	 FAR PTR _move_default	; Save inputted filename w/[DI...]

	call	_EFXscreen
	call	_read_pointer
	mov	Active_IOTYP,video_IOTYP

VL1235:	mov	dx,offset Video_Header
	mov	cx,2			; Size of video header - SESID
	mov	ah,3fh			; Read file function
	push	dx
	call	 FAR PTR _SaveLoadFile_AHfunc
	pop	dx
	mov	bx,dx
	mov	ax,[bx]
	cmp	ax,SESID
	JMP_NZ	NoValidEFX

	mov	cx,11			; Eat up switcher Name
	mov	ah,3fh
	push	dx
	call	 FAR PTR _SaveLoadFile_AHfunc
	pop	dx

	mov	cx,MAXEMEMLENGTH-2-11	; Read in the rest of the header
	mov	ah,3fh			; Read file function
	call	 FAR PTR _SaveLoadFile_AHfunc

	xor	cl,cl			; Clear a counter
	push	bx

;9-21-1994 Check for # of Vlan_Emems if necessary
	call	_GetSXcb_Flags
	test	bx,SWbit_VLAN		; Vlan switcher?
	jz	efxlnvl
	mov	bx,Vlan_Emems
	jmp	efxlvl
efxlnvl:call	_GetSXcb_emems		; Get # of emem regs
efxlvl:
;...

	call	_GetSXcb_emems		; Get # of emem regs
	mov	ch,bl			;  to CH
	pop	bx

Wemeagn:push	cx			; Save the Count

	cmp	cl,ch
	jz	EMloadd

	mov	Cursor,1800h		; Set Cursor
	mov	al,cl			; Write out the
	call	_a_DecOut		;  E-MEM register we are getting

	mov	dx,offset dirbuff	; Destination buffer
	mov	cx,MAXEMEMLENGTH	; # to read
	mov	ah,3fh			; Read file function
	call	 FAR PTR _SaveLoadFile_AHfunc
	jc	EMloadd
	cmp	cx,ax			; Read successfull?
	jnz	EMloadd			; Bail out if eof
	mov	bx,dx
	pop	cx
	push	cx
	call	WRITE_emem_FAR
	pop	cx
	inc	cl
	jmp	Wemeagn

EMloadd:pop	cx			; Just get CX off of the stack
	call	 FAR PTR _SaveLoadFile_Close
	mov	bx,offset Title2_Scr	; Display title
	call	_dircur_lerase
	mov	bx,offset Video_Header
	call	_cntrtxt
	mov	bx,offset Loaded_Msg
	call	 FAR PTR _file_messages
	ret
_EMEM_load	endp

NoValidEFX	proc	near
	call	 FAR PTR _SaveLoadFile_Close
	ERROR	NoValidEFX_error, ERET_Return
	jmp	_EMEM_load
NoValidEFX	endp

video_files	proc	near
	mov	al,4			; Save directory request type
	; Allow paging only
	mov	PointShootData.PQ_Flag,PQF_KILLFILE OR PQF_PAGING
	call	 FAR PTR _shdok
	ret
video_files	endp

;==================================================================
; Called through "Z" defaults menu, Saves/loads macro to/from disk
_mac_save	proc	far
	; Set for save file,paging
	mov	PointShootData.PQ_Flag,PQF_SAVE OR PQF_KILLFILE OR PQF_PAGING
	call	_init_MACRO
	RETURN_IFCARRY		; 7-11-1992 
	call	_init_write
	jc	_mac_save
	call	 FAR PTR _move_default	; Save inputted filename w/[DI...]

	mov	dx,offset SESID	; Write SES ID string
	mov	cx,2
	call	 FAR PTR _DiskOut

	call	 FAR PTR _getmacro_ttl
	mov	dx,offset Macro_Buffers	; Write the header
	mov	cx,offset Macro_Length	; Write 128 byte
	call	 FAR PTR _DiskOut
	call	 FAR PTR _SaveLoadFile_Close
macsret:call	_macros_disp
	ret
_mac_save	endp

;================================================================
_mac_load	proc	far
	mov	PointShootData.PQ_Flag,PQF_LOAD OR PQF_KILLFILE OR PQF_PAGING
	call	_init_MACRO
	RETURN_IFCARRY		; 7-11-1992 
; DI points to filname
	call	 FAR PTR _init_READ
	call	 FAR PTR _move_default	; Save inputted filename w/[DI...]
	call	 FAR PTR _loadall_macros
	jnc	maclodd
	ERROR	NoValidMacro_error, ERET_Return
	jmp	_mac_load
maclodd:call	_macros_disp
	ret
_mac_load	endp

;================================================================
_macro_clear	proc	far
	mov	bx,offset clrmacs_ovr
	call	no_chos_msg_FAR
	jnz	mclrret
	mov	bx,offset Macro0
	mov	dx,offset Macro0 + 1
	mov	cx,offset ((macrolen+2) * 10) - 1 ;changed to offset
	mov	byte ptr [bx],0
	call	_mmv16
	mov	byte ptr Macro_Ttl,0
	call	_help_pos
	call	_evnt_dispthis
mclrret:ret
_macro_clear	endp


;================================================================
;Save the default settings to disk
_setdflts_file	proc	far
	call	_dflts_disp	; Display defaults title
	mov	bx,offset _Save_File_Msg	; Get a Y/N or abort,
	call	dflts_chos
	jnz	_load_defaults
	mov	PointShootData.PQ_Flag,PQF_SAVE OR PQF_KILLFILE OR PQF_PAGING
	call	_init_DFLTS
	RETURN_IFCARRY		; 7-11-1992 
	call	_init_write
	jc	_setdflts_file
	call	 FAR PTR _getdflts_ttl
	call	 FAR PTR _Dflts2Disk
	ret
_setdflts_file	endp


; Load default file from disk
_load_defaults	proc	far
	mov	bx,offset _Load_File_Msg	; Get a Y/N or abort,
	call	dflts_chos
	jnz	ldfxit
	mov	PointShootData.PQ_Flag,PQF_LOAD OR PQF_KILLFILE OR PQF_PAGING
	call	_init_DFLTS
	RETURN_IFCARRY		; 7-11-1992 
	call	 FAR PTR _init_READ
	call	 FAR PTR _dfltver_check	; Check for proper DEFAULT version
	jz	loddok
	ERROR	file_corrupt, ERET_Keyboard

loddok:	mov	dx,offset Dflts_Area + 80h ; Top of defaults area
	mov	cx,offset Dflts_Length - 80h
	mov	ah,3fh			; Read file function
	call	 FAR PTR _SaveLoadFile_AHfunc
	call	 FAR PTR _SaveLoadFile_Close
	call	 FAR PTR _SetEdlBinFormatPointer	; Calculate DEFAULT EDL TYPE
	jmp	Restart		; Fixed 4/10/90 for correct update
ldfxit:	ret
_load_defaults	endp

;================================================================
;			TITLE FILES
;================================================================
_title_file	proc	far
	mov	bx,offset File_Title + 7
	mov	dx,offset Work_Event
	mov	cx,7fh
	push	dx
	call	_mmv_ESDS
	pop	dx
	call	 FAR PTR _getatitle
	jz	ttlsret
	mov	dx,offset File_Title + 7
	call	 FAR PTR _title_loop_ES
	call	_file_ttl_upd
	ret
_title_file	endp

_getvideo_ttl	proc	far
	mov	dx,offset Video_Header	; Move title for video file
	jmps	ttlslop
_getvideo_ttl	endp
_getdflts_ttl	proc	far
	mov	dx,offset Dflts_Ttl	; Move title for defaults file
	jmps	ttlslop
_getdflts_ttl	endp
_getmacro_ttl	proc	far
	mov	dx,offset Macro_Ttl	; Move title for macro file
_getmacro_ttl	endp

ttlslop	proc	far
	push	dx
	call	 FAR PTR _getatitle
	pop	dx
	jz	ttlsret
	call	 FAR PTR _title_loop
ttlsret:ret
ttlslop	endp

;................................................................
;Get file title or defaults title from user
;Return with Z set if nothing inputted
_getatitle	proc	far
	mov	Filename_Ptr,dx
	mov	bx,offset Title_Msg
	call	_kbd_message
	mov	al,title_length
	mov	Cimsgadd_Flag,0ffh	; Get recall w/any periods
	call	cimsg_wrk_FAR
	mov	Cimsgadd_Flag,0		; Cancel recall w/any periods
	ret
_getatitle	endp



;;;;;;;;<><><><><>


_MakeBatchFileCommand	proc	far
	push	dx			; Save destination
;.
	push	bx			; Save source destination

	mov	bx,dx			; Destination to BX
	inc	bx			; Skip over length byte
	mov	si,offset Command_Runopt; Point to '/C'
	call	 FAR PTR _move_subdir

	pop	si			; Restore source
	call	 FAR PTR _move_subdir
;.
	mov	word ptr [bx],000dH	; Terminate line
	pop	bx			; Restore destination address
	push	bx
	inc	bx
	call	_strlen
	pop	bx
	mov	[bx],al
	ret
_MakeBatchFileCommand	endp

;================================================================
; Display FILE [LOADED] [SAVED]
_file_messages	proc	far
	push	bx
	call	_kbd_cln
	mov	bx,offset File_Msg
	call	_comsg
	pop	bx
	call	_comsg
	call	_chrwait
	ret
_file_messages	endp


_SaveLoadFile_Close	proc	far
	mov	ah,3eh
_SaveLoadFile_Close	endp

_SaveLoadFile_AHfunc	proc	far
	mov	bx,Saveload_Handle
	int	DOS
	ret
_SaveLoadFile_AHfunc	endp

_SaveLoadFile_Open	proc	far
	mov	ax,3d00h		; Open file, read only
	int	DOS
	jc	SLFOerr
	mov	Saveload_Handle,ax	; Save handle
SLFOerr:ret
_SaveLoadFile_Open	endp

;================================================================
; Read an ascii line from the file.
; Exit:	C=1 if EOF, Z=1 if null line
;	CH = # of bytes read (also saved in Readline_Length
_read_line	proc	far
	mov	ax,4201h		; Move file pointer function
	xor	cx,cx
	mov	dx,cx
	call	_SaveLoadFile_AHfunc
	push	dx			; Save MSB
	push	ax			; Save LSB

	mov	cx,82			; Read 80 character line (max) +crlf
	mov	dx,offset Temp_Wrkspce	; Point to buffer
	mov	si,dx
	mov	ah,3fh			; Read file function
	int	DOS
	or	ax,ax			; No bytes read?
	jnz	rdneof			; End of file if so
rdeof:	pop	ax
	pop	dx
	xor	cx,cx
	mov	Readline_Length,ch	; Save length of read line
	mov	bx,offset Temp_Wrkspce
	mov	byte ptr [bx],1ah
	stc
	ret

rdneof:	cmp	byte ptr [si],1ah	; End of file?
	jz	rdeof
	xor	cx,cx			; CH counts bytes, CL counts term(s)
rdlnc:	lodsb				; Get next character
	inc	ch			; Increment read byte counter
	or	al,al
	jz	rdnulb
	cmp	al,lf
	jz	rdnulb
	cmp	al,cr
	jnz	rdlnc
	inc	cl			; Increment term counter

	cmp	byte ptr[si],lf
	jnz	rdnulb

	jmps	rdlnc

rdnulb:	inc	cl			; Increment term counter

rdleol:	mov	byte ptr [si],0		; Terminate line with null byte
	mov	al,ch
	xor	ah,ah
	pop	dx			; Restore LSB pointer
	add	dx,ax			; Add in line length
	pop	ax			; Restore MSB
	push	cx			; Save CH and CL
	mov	cx,ax
	jnc	rdleol1
	inc	cx			; Adjust if carry
rdleol1:mov	ax,4200h		; Reposition file pointer
	int	DOS
	mov	bx,dx
	pop	cx			; Restore counters
	sub	ch,cl			; Adjust Count
	or	ch,ch
	mov	Readline_Length,ch	; Save length of read line
	mov	bx,offset Temp_Wrkspce
	mov	al,[bx]
	ret
_read_line	endp


;================================================================
;Open the Overlay .OVL file and return with Flags blazin'
_opn_ovl	proc	far
	mov	bx,offset Ovrlay_File
	call	 FAR PTR _find_file
	jnc	opno2
	jmp	noovler

opno2:	mov	ax,Msg_Seg		; Load overlay to Memory
	mov	bx,offset Temp_Wrkspce	; Use as parameter block
	mov	[bx],ax			; Segment to load at
	mov	word ptr 2[bx],0	; Does not apply, zero it
	mov	dx,offset Ascii_Line
	push	es
	push	ds
	push	ds
	pop	es
	mov	ax,4b03h		; EXEC function, overlay load
	int	DOS
	pop	ds
	pop	es
	jc	noovler

	mov	dx,Msg_Seg		; DX has segment
	mov	bx,16			; Starting offset
	mov	cx,offset OVRFILE_size	; Get length
	sub	cx,bx			; Subtract starting offset length
	call	_get_checksum		; to BX (filesize in BP)

	cmp	bx,offset overlay_checksum
	jnz	badovl
	ret

badovl:	mov	dx,offset Badovl_Msg
	jmps	nobadov
noovler:mov	dx,offset Noovl_Msg
nobadov:mov	ah,9
	int	DOS
	mov	al,1			; Make it a normal error
	jmp	Goaway

_opn_ovl	endp



;-------------------------------------------------------------------
; D I R E C T O R Y  O F   E D L s   O N   C U R R E N T   D R I V E
;-------------------------------------------------------------------
;================================================================
;		DIRECTORY PROCESSING
;================================================================
; ENTER: AL = DIRECTORY TYPE
_shdok	proc	far
	call	shdok0
	ret
_shdok	endp

shdok0:	mov	Dirtype,al		; Save directory type number (1-5)
	call	DirSearch_Set		; Setup filename and DIRBUFF pointers
	call	DirFind_All		; Find all of the files, store to DIRBUF
	or	cl,cl			; CL has Count of files found
	jnz	shdok1			; If there ARE files, show them
	jmp	DirFile_Select		; Else go directly to selections menu

; Index to proper page and offset for file display
shdok1:	call	DirScrn_Header		; Setup the screen

	mov	Dirfiles,cl		; Save Count of files

	lea	bx,Dirchoice		; Point to start of choices table
	mov	al,Dirtype		; Get directory type
	dec	al			; Index from base of 1
	cbw
	shl	ax,1			; Double it and add it to the
	add	bx,ax			;  base offset of Dirchoice table
	mov	Dirchoice_Adr,bx	; Save address.
	cmp	cl,1[bx]		; Has length of directory changed?
	jz	shdok1a			; Jump if it hasn't
	mov	byte ptr [bx],1		;  Else, set to first file
shdok1a:mov	1[bx],cl		; Save new file choices
	mov	al,[bx]			; Get the last choice
	or	al,al			; Is there any?
	jnz	shdok2			; Jump if there IS
	inc	al			; Default to choice #1
	mov	[bx],al			; Set choice #1 for position_query_FAR

shdok2:	cmp	al,Dirfiles		; Is choice > available files?
	jbe	shdok3			;  Jump if NOT
	xor	al,al			;  Else, start with first file

; Find page
shdok3:	xor	cl,cl
shdok4:	cmp	al,maxlines		; Is it on this page?
; Fix for redisplay of first page if the last selection
;		was for the last file on the page
	jbe	shdok5

	sub	al,maxlines
	add	cl,maxlines
	jmp	shdok4

shdok5:	mov	Dirpgtop,cl		; Initialize top of page
	mov	Dirdisplayed,cl
	call	Index2DirFname		; Index into the DIRBUFF

;================================================================
gdtlp:	mov	cl,Dirpgtop		; Get top of screen
	mov	Dirdisplayed,cl		; Set as first file to display
	call	Dir_display_page	; Display a page
	jc	gtdret

	mov	al,Dirdisplayed
	cmp	al,Dirfiles
	jae	gtdcont
	mov	Cursor,1700h
	mov	bx,offset dirmore_ovr
	call	_MsgCntr
gtdcont:jmp	DirFile_Select
gtdret:	ret
;----------------------------------------------------------------
DirFile_Select:
	mov	al,Dirlines		; Any files on screen?
	or	al,al
	jnz	DFS_rt0

DFS_err:call	_screen_init_FAR
	ERROR	file_not_found,ERET_Return ;ERET_Keyboard	;ERET_Return
	ret

DFS_rt0:mov	PointShootData.PQ_Cursor,offset 100h
	mov	PointShootData.PQ_rows,al
	mov	PointShootData.PQ_cols,1
	mov	PointShootData.PQ_tab,0
	mov	PointShootData.PQ_field,80
	mov	PointShootData.PQ_choices,al
	mov	PointShootData.PQ_exitkey,offset Escape_xcmd

	cmp	Dirfiles,maxlines
	jbe	DFS_rt1
	mov	Cursor,1700h
	norm_VIDEO FALSE,FALSE
	mov	bx,offset dirmore_ovr
	call	_MsgCntr

DFS_rt1:mov	bx,Dirchoice_Adr	; Point to correct choice buffer
	mov	cl,[bx]			; Get the last choice
	cmp	cl,Dirfiles		;  Are there less files in the
	jbe	DFS_rt2			;  new one?  We don't want to point
	mov	cl,1			;  past the ones we have now.

DFS_rt2:sub	cl,Dirpgtop		; Adjust for screen range
	call	position_query_FAR	; Returns w/ CL = choice
	pushf

	mov	bx,Dirchoice_Adr
	mov	ch,[bx]		; Get last choice
	mov	[bx],cl
	popf
	JMP_C	DFS_pq5

	cmp	cl,Dirfiles
	jbe	DFS_rt2a
	mov	[bx],ch			; Resave last choice
	call	_error_bell
	jmp	DirFile_Select

DFS_rt2a:
	call	view_slrqst		; Returns Z=1 if SAVE or LOAD key
	jnz	DFS_rt3
	jmp	view_select

DFS_rt3:cmp	ax,offset Pageup_key
	JMP_Z	DFS_pgup
	cmp	ax,offset Pagedn_key
	JMP_Z	DFS_pgdn

	dec	cl
	cmp	ax,offset Viewedl1_key
	JMP_Z	view_edl
	cmp	ax,offset Viewedl2_key
	JMP_Z	view_edl

	cmp	ax,offset DelEv_xcmd
	jnz	DFS_rt4
	call	DFS_rt4
	call	kill_file
	jmp	Keyboard

DFS_rt4:call	Index2DirFname		; Index to correct filename in DIRBUFF
	mov	ax,PointShootData.PQ_Flag
	and	ax,PQF_SAVE OR PQF_LOAD OR PQF_KILLFILE
	or	ax,ax
	jz	DFS_pq5

; Insert filename information to the MACRO COMMAND BUFFER
;  for automatic entry into the command line
DFS_pq0:mov	si,offset Temp_Macro + 1; Point to temporary buffer
	xor	cl,cl			; Clear a length counte
	mov	ah,0ffh			; Insure character will be ASCII
DFS_pq1:mov	al,[bx]			; Get character
	inc	bx			; Point for next
	or	al,al			; End of string?
	jz	DFS_pq2			; Jump if so

; Prevent extensions
	cmp	al,'.'
	jz	DFS_pq2

	mov	[si],ax			; Store character
	add	si,2
	add	cl,2
	jmps	DFS_pq1

DFS_pq2:cmp	Maccrlf_Flag,0ffh
	jnz	DFS_pq3
	mov	word ptr [si],offset Enter_xcmd
	add	si,2
	add	cl,2
	mov	Maccrlf_Flag,0

DFS_pq3:cmp	Suspend_Flag,0ffh
	jnz	DFS_pq4
	mov	word ptr [si],offset Suspend_key
	add	si,2
	add	cl,2
	mov	word ptr [si],offset Macro_xcmd
	add	si,2
	add	cl,2
	mov	Suspend_Flag,0
DFS_pq4:mov	bx,offset Temp_Macro
	mov	[bx],cl
	call	_macsaver

DFS_pq5:call	_screen_init_FAR
	ret

;................................................................
; Go back a page
DFS_pgup:
	cmp	Dirpgtop,0	; Already at beginning file?
	JMP_Z	DirFile_Select	;  then bail out

	call	DirScrn_Header
	mov	cl,Dirpgtop
	sub	cl,maxlines	; maxlines = 22
	mov	bx,Dirchoice_Adr
	sub	byte ptr [bx],maxlines	; Adjust selection
	jmp	DFS_pg1

; Go forward a page
DFS_pgdn:
	mov	cl,Dirdisplayed		; Get the last displayed file number
	cmp	cl,Dirfiles		; See if we are at the end of list
	JMP_AE	DirFile_Select

	call	DirScrn_Header
	mov	bx,Dirchoice_Adr
	add	byte ptr [bx],maxlines	; Adjust selection
	mov	cl,Dirdisplayed
DFS_pg1:mov	Dirpgtop,cl
	call	Index2DirFname		; Index into the DIRBUFF
	jmp	gdtlp

;................................................................
; View EDL file
view_edl:
	test	PointShootData.PQ_Flag,PQF_FILEVIEW
	JMP_Z	DFS_rt1

	call	_clear_screen	; Clear screen, home Cursor
	push	cx
	mov	si,offset EDL_Subdir
	mov	bx,offset Temp_Wrkspce
	call	 FAR PTR _move_subdir
	call	 FAR PTR _add_backslash
	pop	cx
	push	bx
	call	Index2DirFname		; Index BX to correct filename in DIRBUFF
	mov	si,bx
	pop	bx
	call	 FAR PTR _move_subdir
	mov	bx,offset Temp_Wrkspce
	call	view_title
	call	_SaveLoadFile_Open	; Open file, read only, save handle
	jnc	vedl2
	ERROR	file_error, ERET_Keyboard

vedl2:	xor	cl,cl
vedllp:	push	cx
	call	_read_line
	pop	cx
	jc	vedlx


; Fix for 1) bypassing null lines, 2) dealing with lines > 80 chars
	jz	vedllp			; Skip null lines

	push	Cursor
	call	_comsg
	pop	Cursor
	inc	byte ptr Cursor + 1

	inc	cl
	cmp	cl,maxlines
	jc	vedllp

	mov	bx,offset View_Msg
	call	_comsg
	mov	ax,PointShootData.PQ_Flag
	and	ax,PQF_SAVE OR PQF_LOAD OR PQF_KILLFILE

	or	ax,ax			; File SAVE/LOAD/KILL allowed?
	jz	vedlrdc
	mov	bx,offset Viewsavlod_Msg
	call	_comsg

vedlrdc:call	rdchar_FAR
	call	_Break_check
	jz	vedlxit

	call	view_slrqst		; Returns Z=1 if save or load key
	jz	view_select

	cmp	ax,offset Enter_xcmd	; Display next page?
	jnz	vedlrdc
	call	_clear_screen
	jmp	vedl2			; Go for another page
vedlx:	blink_VIDEO FALSE,FALSE
	mov	bx,offset Viewend_Msg
	call	_comsg
	norm_VIDEO FALSE,FALSE
	call	rdchar_FAR
	call	_Break_check
	jz	vedlxit
	call	view_slrqst		; Returns Z=1 if save or load key
	jz	view_select

vedlxit:call	_SaveLoadFile_Close	; Close file
	call	DirScrn_Header		; Setup the screen
	mov	cl,Dirpgtop		; Get top of screen
	call	Index2DirFname		; Index into the DIRBUFF
	jmp	gdtlp			; Go back to the full screen file disp.

view_select:
	call	_SaveLoadFile_Close	; Close file
	mov	bx,Dirchoice_Adr	; Get current choice
	mov	cl,[bx]
	dec	cl
	call	Index2DirFname		; Index to correct filename in DIRBUFF
	mov	Maccrlf_Flag,0ffh	; Signal cr append
	jmp	DFS_pq0			; Append Name to INPUT COMMAND BUFFER

view_title:
	push	bx
	mov	dx,bx
	rev_VIDEO FALSE,FALSE
	mov	bx,offset Filename_Msg
	call	_comsg
	mov	bx,dx
	call	_comsg
	pop	bx
	norm_VIDEO FALSE,FALSE
	call	_crlf
	ret

; Save/Load request?
view_slrqst:
	test	PointShootData.PQ_Flag,PQF_LOAD
	jz	vslrq1
	cmp	ax,offset Lodfl_xcmd	; Load this file?
	ret

vslrq1:	test	PointShootData.PQ_Flag,PQF_SAVE
	jz	vslrq2
	cmp	ax,offset Savfl_xcmd	; Save this file?
	ret

vslrq2:	mov	bx,Dirchoice_Adr
	mov	cl,[bx]
	or	cl,cl			; Set NZ
	ret


;------------------------------------
; K I L L   F I L E   R O U T I N E
;------------------------------------
kill_file:
	call	_init_KILL
	norm_VIDEO FALSE,FALSE
	mov	bx,offset Keyboard_Scr
	call	_dircur_lerase
	mov	bx,offset Kilfil_Msg
	call	_comsg
	call	_Space_Out

	mov	bx,offset Saveload_EDL
	call	_comsg
	call	_Space_Out
	mov	bx,offset Areusure
	call	_comsg
	mov	cl,'N'
	call	yn_chos_FAR
	jnz	kilfx
	mov	dx,offset Saveload_EDL	; ASCIIZ string
	mov	ah,41h			; Delete file function
	int	DOS
	jnc	JL1310
	ERROR	file_not_found, ERET_Return
	jmp	kill_file

JL1310:	mov	bx,offset File_Msg
	call	_kbd_cln
	call	_comsg
	mov	bx,offset Saveload_EDL
	call	_comsg
	call	_Space_Out
	mov	bx,offset Killed_Msg
	call	_comsg
	mov	bx,offset Pagend_Msg
	call	_comsg
	call	rdchar_FAR
	call	_macone
kilfx:	ret


;================================================================
;	SUPPORT ROUTINES FOR DIRECTORY DISPLAYS
;================================================================
;................................................................
; Display a page of filenames and titles
; Return C=1 (SET) if Break key pressed
Dir_display_page:
	call	Index2DirFname		; Index to correct filename in DIRBUFF
	cmp	byte ptr [bx],0		; Any filenames left?
	jz	DDP_x			; Exit if not
	call	_cstat_FAR		; Check for keypress
	jz	DDP_2			; Continue if none, or
	call	_Break_check		; Check for Break
	jz	DDP_8			; Return carry set if Break

DDP_2:	push	cx

	mov	cl,Dirdisplayed
	call	_dashit_cl
	mov	Dirdisplayed,cl
	mov	si,bx
	dim_VIDEO FALSE,FALSE		; Display the FILE Name
	mov	cx,10			; Add two Spaces
DDP_3:	lodsb
	cmp	al,'.'
	jz	DDP_4
	call	_ConOut
	loop	DDP_3
DDP_4:	add	Cursor,cx		; Add in leftover Spaces
	norm_VIDEO FALSE,FALSE
	push	bx
	call	FileTitle_Display	; Get the title
	pop	bx
DDP_6:	mov	al,[bx]			; Index over to next
	inc	bx
	or	al,al			;  filename in table
	jz	DDP_7
	inc	al			; Test for end of list
	jnz	DDP_6
DDP_7:	inc	Dirlines
	cmp	Dirlines,maxlines
	pop	cx
	inc	cl
	jc	Dir_display_page
DDP_x:	ret
DDP_8:	stc
	ret

;................................................................
; BX points to next filename in buffer
FileTitle_Display:
	mov	dx,offset Temp_Wrkspce	; Buffer to send filename
	mov	ch,13
	call	_mmv
	call	_init_DIR	; Find this file
	call	 FAR PTR _init_READ	;  and open for read
	mov	al,Dirtype
	cmp	al,1			; EDL FILE?
	jz	FTD_edl
	cmp	al,2			; EIF FILE?
	jnz	FTD_all

	mov	cx,128
	mov	dx,offset DTA
	mov	ah,3fh
	call	_SaveLoadFile_AHfunc	; Get first record
	mov	ah,3fh			; Get next record
	int	DOS
	mov	bx,dx
	cmp	byte ptr [bx],0
	jz	FTDedln
	jmp	FTDcmcl

FTD_all:mov	bx,offset Temp_Wrkspce
	call	_read_line
	jz	FTDedln
	cmp	Dirtype,3		; Macro file?
	jz	FTD_spcl
	cmp	Dirtype,4		; EFX file?
	jnz	FTDcmcl
FTD_spcl:
	inc	bx			; Increment over
	inc	bx			;  SES Signature
	jmp	FTDcmcl

; Use for any file having a title line
FTD_edl:call	_read_line	;C=1 if eof, Z=1 if null line
	jc	FTD_nul
	jz	FTD_edl
	mov	al,[bx]
	cmp	al,cr			; Empty line?
	jz	FTD_edl			; Loop for next
	cmp	al,'*'			; CMX/CONV type title?
	jz	FTDedl1
	or	al,al
	jz	FTD_nul
	jmp	FTDedl0

FTDedl1:call	_adv2spc
	call	_advance
	jmp	FTDedl2

FTD_nul:mov	word ptr [bx],0a0dh	; Terminate
	mov	byte ptr 2[bx],0	; Line

FTDedl0:call	_cknum		; First line an edit?
	jnc	FTDedln
	push	cx
	call	_Check_4_title
	pop	cx			; TITLE:?
	jnz	FTDedl2
	add	bx,6			; Index past 'TITLE:'
FTDedl2:call	_adv2chr	; _adv2chr to line
FTDcmcl:push	Cursor			; Save Cursor
	call	_comsg		; Display title
	pop	bx
	inc	bh
	mov	bl,0
	mov	Cursor,bx
	jmp	FTDclsf			; Close and return

FTDedln:call	_crlf
FTDclsf:call	_SaveLoadFile_Close
	ret


;................................................................
; Find the correct filename in the DIRBUFF
; ENTER: CL = # of file
; Exit: BX points to filename
; Uses AX, BX
Index2DirFname:
	mov	ax, MAX_FILENAME_LENGTH
	mul	cl
	mov	bx,offset dirbuff
	add	bx,ax
	ret

;................................................................
; Move the '????????.' to the file find buffer
; ENTER: AX has directory type
DirSearch_Set:
	mov	Fullscreen_Flag,0ffh	; Indicate NO VTR LOCATION display
	mov	Dirfiles,0		; Zero out available "found" edls

	mov	bx,offset dirbuff	; Pre terminate DIRBUFF
	mov	word ptr [bx],0		;  for no "found" edl files
	mov	Temp_Tc_Buf,bx		; Set _add_store destination buffer adr.

	mov	cl,al			; Save directory type to CL
	mov	bx,offset Findme	; Move '????????.'
	mov	dx,offset Temp_Wrkspce	; Buffer to send filename
	mov	ch,9
	call	_mmv
	or	PointShootData.PQ_Flag,PQF_FILEVIEW OR PQF_PAGING
	mov	bx,offset Edl_Ext
	dec	cl
	jz	DSS_1
	and	PointShootData.PQ_Flag,NOT PQF_FILEVIEW
	mov	bx,offset EIF_Ext
	dec	cl
	jz	DSS_1
	mov	bx,offset TCM_Ext
	dec	cl
	jz	DSS_1
	mov	bx,offset VME_Ext
DSS_1:	mov	ch,4
	call	_mmv
	ret

;................................................................
; Display screen header on first line of CRT
DirScrn_Header:
	mov	Dirlines,0
	call	_clear_screen
	norm_VIDEO FALSE,FALSE

;5-18-1995 Allows for optional EDL sorting
	mov	bx,offset dirofn_ovr
	test	Sounddisplay_Flags, sortedls_SDBIT
	jz	dshuns
	mov	bx,offset dirofs_ovr
dshuns:
;...
	cmp	Maxfiles_Reached,FALSE
	jz	Dscr_h0
	call	_error_bell
	mov	bx,offset maxfiles_ovr
Dscr_h0:call	_msgread

	mov	al,Dirtype
	dec	al			;EDLs?
	jnz	Dscr_h1
	mov	bx,offset dirhdr_ovr
	jmps	Dscr_hp
Dscr_h1:dec	al			;EIFs?
	jnz	Dscr_h2
	mov	bx,offset eifhdr_ovr
	jmps	Dscr_hp
Dscr_h2:dec	al			; TCM file?
	jnz	Dscr_h3
	mov	bx,offset tcmhdr_ovr
	jmps	Dscr_hp
Dscr_h3:dec	al			; Must be VME effects file
	jz	Dscr_h4
	jmp	Keyboard		; Else there trouble!!
Dscr_h4:mov	bx,offset vmehdr_ovr
Dscr_hp:call	_msgread		; Display screen header
	mov	bx,Dirsub_Adr		; Get address of subdirectory Name
	call	_comsg
	call	_crlf
	ret

;================================================================
; Move filenames to the DIRBUFF, terminate with null
; Exit: CL = # of files found
DirFind_All	proc	near

	mov	dx,offset Ascii_Line	; Set DMA to input/output buffer
	mov	ah,1Ah			; Set DMA
	int	DOS

	call	_init_DIR		; Search for first
	mov	cl,0			; Clear file Count counter
	mov	Maxfiles_Reached,cl
	mov	Dirlines,cl		; Clear screen display Count
	mov	ERROR_ACTIVE,0FFH	; Signal file error
	jc	DFA_x			; Return if none found

DFA_1:	cmp	cl,MAX_FILENAMES
	jae	DFA_maxfiles

	mov	dx,offset Ascii_Line + 30 ;Point to filename

	push	cx			; Save CL Count of found filename

;5-18-1995 Allows optional EDL sorting
	test	Sounddisplay_Flags, sortedls_SDBIT
	jz	DFA_2
	call	DirectorySort		; Returns with CL = position
DFA_2:
;...
	call	Index2DirFname		; Index to CL position in dirbuff
	xchg	bx,dx			; BX -> Source filename
					; DX -> Destination in dirbuff
	mov	ch, MAX_FILENAME_LENGTH
	call	_mmv

	pop	cx			; Restore Count of found filenames
	inc	cl			; Increment Count of files found

	mov	ah,4fh			; Search for next file
	int	DOS
	jnc	DFA_1
	jmp	DFA_end

DFA_maxfiles:
	call	DFA_end
	mov	Maxfiles_Reached,TRUE
	ret

DFA_end:call	Index2DirFname		; Index to CL position in dirbuff
	mov	byte ptr [bx],0

DFA_x:	mov	dx,offset DTA		; Set default DMA
	mov	ah,1Ah			; Set DMA
	int	DOS
	ret
DirFind_All	endp


;================================================================
; Sort Name pointed to by BX into DIRBUFF
; Enter: DX -> filename
;	 CL = #of filenames in buffer
; Exit:	 CL = Position to put filename to
DirectorySort	proc	near
	push	dx
	push	es

	push	ds			; Make ES = DS
	pop	es

	or	cl,cl			; First entry?
	jz	dirsrtx
	
	xor	ch,ch			; Clear our own counter
dirsrt1:
	push	cx
	mov	cl,ch			; Next filename to check
	call	Index2DirFname		; Index to CL position in dirbuff
	cmp	byte ptr [bx],0
	jz	dirsrtx

	mov	cl, MAX_FILENAME_LENGTH - 1
	call	_cmpchr			; Compare the strings
	pop	cx

	jb	dirsrt_makeroom

	inc	ch
	cmp	ch,cl
	jb	dirsrt1

dirsrtx:pop	es
	pop	dx
	ret

; CH is where it is going, CL is how many there are
dirsrt_makeroom:
	call	Index2DirFname		; Get the address of where to move to
	mov	di,bx			; DI -> last entry
	mov	si,di			; SI will point to end of char pos
	dec	si			;  less one byte
	add	di, MAX_FILENAME_LENGTH - 1	; Point to last char position

	push	cx

	mov	al,cl
	sub	al,ch
	jz	dirsrt_done

	mov	cl, MAX_FILENAME_LENGTH
	mul	cl
	mov	cx,ax
	std
	rep movsb
	cld

dirsrt_done:
	pop	cx			; Restore position information
	mov	cl,ch
	jmp	dirsrtx
	
DirectorySort	endp


;================================================================
;	SAVE AND RESTORE Msg_Seg AND ALL BINS TO DISK FILES
;================================================================
; Save all TMP registers to disk file
_TMP_save	proc	far
	test	DOS_Flags,virtual_DOSBIT
	JMP_Z	tmpsvr
	cmp	TMPwrite_Flag,0ffh
	JMP_NZ	tmpsvr
	push	bx
	push	dx
	push	es

	call	 FAR PTR _Check_TMPspace
	jnc	TMPs0			; Jump if there is enough disk space
	and	DOS_Flags,not virtual_DOSBIT ; Turn off virtual Memory
	ERROR	virtualmem_error, ERET_Keyboard

TMPs0:	call	_kbd_cln
	mov	bx,offset prepare4dos_ovr
	call	_msgread
	call	build_TMPfilename
	mov	ah,3ch			; Make file
	xor	cx,cx			; "Normal" attributes
	int	DOS
	jnc	TMPs1
	ERROR	file_error, ERET_Keyboard

TMPs1:	mov	Saveload_Handle,ax		; Save file handle

	push	si
	mov	si,offset Bin_Table
tmps2:	lodsw
	or	ax,ax
	jz	tmps3

	mov	es,ax			; Get BIN segment to ES
	cmp	es:Next_Avail_Num,1	; Any edits here?
	jbe	tmps2			; Skip if no edits

; Write an entire bin to disk
; Returns NZ if write not successfull
	mov	bx,Saveload_Handle
	push	ds
	mov	ds,ax
	mov	ah,40h			; Write file function
	mov	cx,0ffffh
	xor	dx,dx
	int	DOS
	mov	ah,40h
	mov	cx,1
	mov	dx,0ffffh
	int	DOS
	pop	ds
	cmp	ax,cx
	jz	tmps2

	pop	si
	jmp	seg2disk_error

tmps3:	pop	si
	call	_SaveLoadFile_Close

; Trim Memory requirements to the top of the DATA segment
	mov	ax,Psp_Seg		; PSP address to Psp_Seg
	mov	es,ax
	mov	bx,Msg_Seg		; Message seg = bottom of DATA seg
	sub	bx,ax			; Length = Edl_Seg - psp
	mov	ah,4ah			; Modify Memory allocation
	int	DOS			; Carry set if failed

	pop	es
	pop	dx
	pop	bx
tmpsvr:	ret

seg2disk_error:
	call	_SaveLoadFile_Close
	ERROR	diskfull_error, ERET_Keyboard

_TMP_save	endp


;================================================================
; Restore all TMP registers from disk file
_TMP_restore	proc	far
	test	DOS_Flags,virtual_DOSBIT
	JMP_Z	tmprsr
	cmp	TMPwrite_Flag,0ffh
	JMP_NZ	tmprsr

	push	bx
	push	dx
	push	es

; Trim Memory requirements to the top of the last EDL segment
	mov	ax,Psp_Seg		; PSP address to Psp_Seg
	mov	es,ax

; Get last bin from Bin_Table and allococate Memory
	mov	si,offset Bin_Table
tmpr1:	lodsw
	or	ax,ax
	jnz	tmpr1
	sub	si,4			; Move back to last bin

	mov	bx,[si]			; Get start addres of LAST SEGMENT
	add	bx,1000h		; Add in room for last segment
	mov	ax,es			; Get PSP segment
	sub	bx,ax			; Get the number of paragraps needed

	mov	ah,4ah			; Modify Memory allocation
	int	DOS			; Carry set if failed

	call	_opn_ovl

	call	_kbd_cln
	mov	bx,offset retfromdos_ovr
	call	_msgread

	call	build_TMPfilename

	mov	ax,3d00h		; Open file, read only
	int	DOS
	jc	TMPferr

;................................................................
	mov	si,offset Bin_Table
	mov	cx,0			; Starting with BIN #1 - 1
tmpr2:	inc	cx			; Next bin number
	lodsw				; Get bin segment
	or	ax,ax			; End of table?
	jz	tmpr3			; Jump if so


;Load/Restore BINs
;	 CX = bin number 1-n
;	 AX = bin segment
;	 SI = Bin Table Pointer

	mov	es,ax			; ES = BIN segment

	push	cx			; Save BIN#

; Read first two bytes of BIN and see if it is next
	mov	bx,Saveload_Handle	; Get handle from data segment
	push	ds
	push	es
	pop	ds
	mov	ah,3fh			; Read file function
	mov	cx,2			; Read the next two bytes
	xor	dx,dx			; Read to TOP OF BIN segment
	int	DOS
	mov	BP,es:EDL_Bin		; Get the BIN# just read from file
	pop	ds

	jc	remaining_bins
	cmp	ax,cx			; End of file?
	jnz	remaining_bins

	pop	cx			; Restore BIN# (to BE read)

d2bin1:	cmp	cx,bp			; Is this the right bin?
	jz	d2bin3			; Jump if BIN numbers MATCH
	call	_Bin_Hdr	; Format this empty BIN

	inc	cx			; Increment bin number
	lodsw				; Get next bin segment
	or	ax,ax			; No more BINS?
	jz	tmpr3			;  (close and return)
	mov	es,ax			; New bin segment to ES
	jmp	d2bin1
	

d2bin3:	mov	ax,bp			; Get the correct BIN#
	mov	es:EDL_Bin,ax		; Store it to BIN

	mov	bx,Saveload_Handle
	push	cx			; Save BIN#
	push	ds
	push	es
	pop	ds
	mov	ah,3fh			; read file function
	mov	cx,0fffeh		; Read in rest of bin
	mov	dx,2			;  just after bin number
	int	DOS
	pop	ds
	cmp	ax,cx
	pop	cx			; Restore BIN#
	jnz	TMPferr
	jmp	tmpr2

tmpr3:	call	_SaveLoadFile_Close
	mov	dx,offset Temp_Wrkspce	; Point to filename
	mov	ah,41h			; Delete file
	int	DOS
	pop	es
	pop	dx
	pop	bx
tmprsr:	ret

TMPferr:ERROR	file_error, ERET_Keyboard

remaining_bins:
	pop	cx			; Restores the BIN#

rbins:	call	_Bin_Hdr	; Format this empty BIN
	inc	cx			; Increment bin number
	lodsw				; Get next bin segment
	or	ax,ax			; No more BINS?
	jz	tmpr3			;  (close and return)
	mov	es,ax			; New bin segment to ES
	jmp	rbins

_TMP_restore	endp


;................................................................
; Build the .TMP filename to the Temp_Wrkspce 
; Return Temp_Wrkspce pointer in DX
build_TMPfilename	proc	near
	mov	bx,offset TMP_File
	mov	Filename_Ptr,bx		; Save pointer to file Name/path
	mov	bx,offset Temp_Wrkspce
	push	bx			; Save buffer address
	mov	si,offset TMP_Subdir
	call	 FAR PTR _move_subdir		; SI points to subdirectory to move
	call	 FAR PTR _add_backslash		; Add backslash, if necessary
	mov	si,Filename_Ptr
	call	 FAR PTR _move_subdir		; SI source, BX destination
	mov	byte ptr [bx],0
	pop	dx			; DX points to Temp_Wrkspce
	ret
build_TMPfilename	endp

;================================================================
; Check the space on the TMP_Subdir Drive and make sure it can contain
;  all of the Memory we want to save.
; Upon Exit Sttime = # of free bytes on Drive
_Check_TMPspace	proc far
	mov	bx,offset TMP_Subdir	; Point to destination for save
	mov	al,[bx]			; Get what may be a Drive
	or	al,al			; No Drive? use current
	jz	Ctsp
	cmp	al,'\'
	jz	Ctsp
	cmp	byte ptr [bx + 1],':'	; Make sure its a legal Drive
	jnz	Ctsp
	call	_make_ucase
	sub	al,'@'			; 1=a, 2=b, etc
	jmp	Ctsp1

Ctsp:	mov	al,0			; Check current disk
Ctsp1:	mov	dl,al
	mov	ah,36h			; Get disk free space
	int	DOS
	cmp	ax,0ffffh		; No disk?
	jz	Ctsperr

; ax = SECTORS PER CLUSTER	bx = AVAILABLE CLUSTERS
; cx = BYTES PER SECTOR		dx = TOTAL CLUSTERS ON THE DISK
; Free space = AX * BX * CX
	mul	cx
	mul	bx		; DX:AX = free space
	cmp	dx,word ptr SavedMemSize + 2
	jc	Ctsperr
	cmp	ax,word ptr SavedMemSize
	jz	Ctsperr
	clc
	ret

Ctsperr:stc
	ret
_Check_TMPspace	endp


;----------------------------------------------------------------
; Check string in Temp_Wrkspce for Drive or path information
; ENTER: Temp_Wrkspce has filename
; Exit:  Z=1 if Drive or path present
_check4path	proc	far
	push	ax
	push	si
	mov	si,offset Temp_Wrkspce
c4p_1:	lodsb
	or	al,al
	jnz	c4p_2
	inc	al			; Return NZ if EOS
	jmps	c4p_x
c4p_2:	cmp	al,':'
	jz	c4p_x
	cmp	al,'\'
	jnz	c4p_1
c4p_x:	pop	si
	pop	ax
	ret				; Ret Z if Drive/path found
_check4path	endp

;================================================================
; Save DS:SI ASCIIZ string as CRNT_SUBDIR
_stash_TMPsubdir	proc	far
	mov	bx,offset TMP_Subdir
	jmps	_stashit
_stash_TMPsubdir	endp

_stash_TCMsubdir	proc	far
	mov	bx,offset TCM_Subdir
	jmps	_stashit
_stash_TCMsubdir	endp

_stash_VMEsubdir	proc	far
	mov	bx,offset VME_Subdir
	jmps	_stashit
_stash_VMEsubdir	endp

_stash_AUTOsubdir	proc	far
	mov	bx,offset AUTOFILE_Subdir
	jmps	_stashit
_stash_AUTOsubdir	endp

_stash_EDLsubdir	proc	far
	mov	bx,offset EDL_Subdir
	jmps	_stashit
_stash_EDLsubdir	endp

; Save DS:SI ASCIIZ string as Home_Path
_stash_homesubdir	proc	far
	mov	bx,offset Home_Path
	jmps	_stashit
_stash_homesubdir	endp

_stashit	proc	far
	push	si
	call	_move_subdir
	pop	si
	mov	byte ptr [bx],0
	ret
_stashit	endp


;----------------------------------------------------------------
; Save the default filename
_move_default	proc	far
	push	si
	mov	si,di
mvd1:	cld				; Forward
	lodsb				; Find end of line
	or	al,al
	jnz	mvd1
mvd2:	std
	lodsb
	cmp	al,'\'
	jz	mvdok
	cmp	al,':'
	jz	mvdok
	cmp	si,di
	jnc	mvd2
mvdok:	cld
	inc	si
	inc	si
	cmp	byte ptr [si],0
	jz	mvdxit
	push	bx
	mov	bx,Filename_Ptr
mvdmv:	lodsb
	mov	[bx],al
	inc	bx
	or	al,al
	jnz	mvdmv
	pop	bx
mvdxit:	pop	si
	ret

_move_default	endp


;================================================================
;================================================================
; Searches for file using DOS PATH= specs
; Enter with BX pointing to program Name
; Exit C=0 if successfull, BX points to full path and fiklename
;      C=1 if unsuccessfull
; Uses WORKPATH

_find_file	proc	far
	mov	si,offset Home_Path
	call	fil4dir
	jnc	file_found
	call	check_file_error
	jnz	file_notfound

	mov	si,offset Paths

fndagn:	cmp	byte ptr [si],0ffh
	jz	file_notfound
	call	fil4dir
	jnc	file_found
	call	check_file_error
	jz	fndmore
	jmp	file_notfound

fndmore:lodsb
	cmp	al,0ffh
	jz	file_notfound
	or	al,al
	jz	fndagn
	jmps	fndmore

file_found:
	mov	bx,offset Ascii_Line
	clc
	ret

file_notfound:
	stc
	ret
_find_file	endp

;................................................................
fil4dir:push	dx			; Save DX 10-04-1990
	push	bx			; Save pointer to program Name
	push	bx
	mov	bx,offset Ascii_Line
	call	_move_subdir	; SI = source, BX = destination
	cmp	byte ptr -1[bx],'\'
	jz	fndagn1
	mov	byte ptr [bx],'\'
	inc	bx
fndagn1:pop	dx			; Restor pointer to program Name
	push	si			; Save pointer to Paths
	mov	si,dx
	call	_stashit
	pop	si
	mov	dx,offset Ascii_Line
	mov	ah,4eh
	xor	cx,cx
	int	DOS
	pop	bx
	pop	dx
	ret

check_file_error:
	cmp	al,2			; File not found
	jz	cfe_xit
	cmp	al,3			; Path not found
	jz	cfe_xit
	cmp	al,12h
cfe_xit:ret

;================================================================
; Ask DOS to search for MENU.COM
_menu_find	proc	far
	test	DOS_Flags,usemenu_DOSBIT
	jz	mnufnd
	mov	bx,offset Menu_File
	call	_find_file
	and	DOS_Flags,not usemenu_DOSBIT	; (If NOT found)
	jc	mnufnd
	or	DOS_Flags,usemenu_DOSBIT	; Found. Move the
	mov	dx,offset Menu_Path		;  entire pathname
	mov	ch,pathname_length		;  to our buffer
	call	_title_loop
mnufnd:	ret
_menu_find	endp

;================================================================
; Ask DOS to search for MENU.COM
_clean_find	proc	far
	mov	bx,offset Clean_File
	call	_find_file
	jc	clnfnd
	mov	dx,offset Clean_Path		;  entire pathname
	mov	ch,pathname_length		;  to our buffer
	call	_title_loop
clnfnd:	ret
_clean_find	endp


;================================================================
_olm_find	proc	far
	and	DOS_Flags,not useolm_DOSBIT	; (If NOT found)
	mov	bx,offset Olm_Cmd
	call	_find_file
	jc	olmfnd
	mov	dx,offset Olm_Path	;  entire pathname
	mov	ch,pathname_length	;  to our buffer
	call	_title_loop
	mov	ax,3d00h		; Open file, Read only
	int	DOS
	jc	olmfnd
	mov	bx,ax			; Handle to BX
	mov	dx,offset Ascii_Line	; Set DMA to input/output buffer
	mov	cx,16			; Get first 16 bytes
	mov	ah,3fh			; Read file
	int	DOS
	mov	ah,3eh			; Close file
	int	DOS
	mov	bx,dx
	mov	ax,CASEID
	cmp	word ptr [bx + 4],ax
	jz	olmok
	mov	ax,SESID
	cmp	word ptr [bx + 4],ax
	jnz	olmfnd
olmok:	or	DOS_Flags,useolm_DOSBIT	; Found. Move the
olmfnd:	ret
_olm_find	endp


; Set up default EDL type pointers
_SetEdlBinFormatPointer	proc	far
	push	cx
	mov	al,Default_Mode
	mov	cx,edlfmt_hdrlen
	mul	cl
	mov	bx,offset Edl_Formats
	add	bx,ax
	mov	es:Mode_Pntr,bx
	xor	al,al
	inc	al
	pop	cx
	ret
_SetEdlBinFormatPointer	endp

; Check for proper default file version
_dfltver_check	proc	far
	mov	dx,offset DTA		;Work_Event
	mov	cx,3			; Get three bytes (the version number)
	mov	ah,3fh			; Read file function
	call	_SaveLoadFile_AHfunc	; Read the bytes

	mov	bx,offset DTA
	mov	byte ptr [bx + 3], 0
	call	_convert2bin
	cmp	dx,NEW_DEFAULTS_VERSION
	jc	_baddfltver

	;; Pass up the date, six bytes
	mov	dx,offset DTA		;Work_Event
	mov	cx,6
	mov	ah,3fh			; Read file function
	call	_SaveLoadFile_AHfunc	; Read the bytes

	;; Get rt, ALLOWED_VTRS, NTSC and CUTS_ONLY and the balance of 80h
	mov	dx,offset DTA		;Work_Event
	mov	cx,119
	mov	ah,3fh			; Read file function
	call	_SaveLoadFile_AHfunc	; Read the bytes

	mov	bx,offset DTA
	cmp	byte ptr [bx + 0], rt
	jnz	_baddfltver
	cmp	byte ptr [bx + 1], ALLOWED_VTRS
	jnz	_baddfltver
	cmp	byte ptr [bx + 2], NTSC
	jnz	_baddfltver
	cmp	byte ptr [bx + 4], CUTS_ONLY
	jnz	_baddfltver
	cmp	byte ptr [bx + 6], DEBUGGER
	jnz	_baddfltver
	cmp	byte ptr [bx + 8], ALLOWRAMPSPEED	
	jnz	_baddfltver
	cmp	byte ptr [bx + 10], ALLOW_VLAN3	
	jnz	_baddfltver
	cmp	byte ptr [bx + 12], DEBUGGER	
	jnz	_baddfltver
	cmp	byte ptr [bx + 14], DEBUGGING	
	jnz	_baddfltver

	xor	al,al
	ret

_baddfltver:
	stc
	ret

_dfltver_check	endp

__init_filewrite	proc	far
	mov	ah,3ch			; Make file
	xor	cx,cx			; "Normal" attributes
	int	DOS
	jnc	inisf_5			; No carry of all ok
	ERROR	file_error, ERET_Keyboard
inisf_5:mov	Saveload_Handle,ax	; Save file handle
	ret
__init_filewrite	endp

_output_line	proc	far
	push	di
	mov	di,bx
	mov	cx,80h		; 128 characters, max
	xor	al,al		; Search for null
	push	es
	push	ds
	pop	es
	repnz scasb
	pop	es
	dec	di		; SI = eol+1, BX = start of line
	sub	di,bx
	mov	cx,di
	mov	dx,bx
	pop	di
	jcxz	outlinx		; Fall through if CX NE 0
_output_line	endp

_DiskOut	proc	far
	mov	ah,40h
	call	_SaveLoadFile_AHfunc
	cmp	ax,cx
	jz	outlinx
	call	_SaveLoadFile_Close
	ERROR	diskfull_error, ERET_Keyboard
outlinx:ret
_DiskOut	endp

;----------------------------------------------------------------
; OUTPUT CRLF TO FILE HANDLE
_OutCRLF	proc	far
	pushf				; Save Flags
	mov	dx,offset Crlf_Msg
	mov	cx,2
	call	_DiskOut
	popf				; Restore Flags
	ret
_OutCRLF	endp


;----------------------------------------------------------------
_Dflts2Disk	proc	far
	mov	dx,offset Dflts_Area	; Write entire area
	mov	cx,offset Dflts_Length	; Write # byte
	call	_DiskOut
	call	_SaveLoadFile_Close
	ret
_Dflts2Disk	endp


_loadall_macros	proc	far
	mov	dx,offset Macro_Buffers	; Point to buffer start
	push	dx			; Save buffer address
	mov	cx,2			; Get first two bytes
	mov	ah,3fh			; Read file function
	call	_SaveLoadFile_AHfunc
	pop	dx			; Restore buffer address
	mov	bx,dx			; Check for SES ID
	mov	ax,[bx]
	cmp	ax,SESID
	jnz	NoValidMacro
	mov	cx,offset Macro_Length	; Read 128 byte
	mov	ah,3fh			; Read file function
	call	_SaveLoadFile_AHfunc
	call	_SaveLoadFile_Close
	clc
	ret

NoValidMacro:
	call	_SaveLoadFile_Close
	stc
	ret
_loadall_macros	endp

;================================================================
;		SET FILE FOR READ ONLY
;================================================================
_init_READ	proc	far
	mov	dx,di
	call	_SaveLoadFile_Open	; Open file, read only, save handle
	jc	irerr
	ret
irerr:	ERROR	file_not_found, ERET_Keyboard
_init_READ	endp




;----------------------------------------------------------------
; BX points to next character after "GPI "
; Current_Event_Adr has event address
; If any error, make it a comment with a preceding "*"
_gpi_xlate	proc	far
	mov	di,Current_Event_Adr
	call	_convert2bin
	mov	es:[di],ax			; Save GPI number
	call	_adv2chr
	mov	al,[bx]
	mov	ah,G_swtrig_mask
	cmp	al,'V'
	jz	gpi_x1
	mov	ah,G_vltrig_mask
	cmp	al,'G'
	jz	gpi_x1
	sub	al,'A'-1			; Try for machine
	jc	_gpi_cmt
	cmp	al,MAX_MACHINES
	jnc	_gpi_cmt
	mov	ah,al
	or	ah,G_machine_mask
gpi_x1:	or	ah,G_active_mask
	mov	byte ptr es:[di].gpiFLAGS.GPI_lofst,ah
	inc	bx
	call	_adv2chr
	call	_convert2bin
	mov	es:word ptr [di].gpiCMD.GPI_lofst,ax
	call	_adv2chr
	call	_cknum		; Carry set if NOT ASCII number
	jnc	gpi_x2			; No + or -, just time code, so jump
	mov	byte ptr es:[di].GPI_lofst,al
	inc	bx
	call	_adv2chr
gpi_x2:	mov	dx,offset ZeroBase.GPI_lofst.gpiTRIGTIME
	mov	cl,es:byte ptr [di].rtcd_lofst
	call	_read_convert
	mov	es:byte ptr [di].cmnt_lofst,Editline_GPI	; Mark as GPI
	ret
_gpi_xlate	endp

_gpi_cmt	proc	far
	mov	byte ptr es:[si],'*'
	inc	si
	mov	di,si
	mov	bx,offset Temp_Wrkspce	; DX = destination
	mov	cx,line_length
	call	_remvl
	ret
_gpi_cmt	endp

;----------------------------------------------------------------
_slave_xlate	proc	far
	mov	di,Current_Event_Adr
	mov	es:byte ptr [di].cmnt_lofst,Editline_SLAVE
	jmp	recslv_xlate
_slave_xlate	endp

;----------------------------------------------------------------
_rec_xlate	proc	far
	mov	di,Current_Event_Adr
	mov	es:byte ptr [di].cmnt_lofst,Editline_REC

recslv_xlate:
	call	_adv2chr		; _adv2chr to next non-space
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Point to REEL #
	call	_left_set2edl		; Move reel# + pad
	call	_adv2chr

	mov	dx,offset ZeroBase.pin_lofst
	mov	cl,Last_Fcm
	call	_read_convert
	mov	es:byte ptr [di].ptcd_lofst,cl

	call	_adv2chr
	cmp	al,'M'			; Master?
	jnz	_gpi_cmt
recladv:inc	bx
	mov	al,[bx]
	or	al,al
	jz	_gpi_cmt
	cmp	al,' '
	jnz	recladv
	call	_adv2chr

	mov	di,Current_Event_Adr
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst + reel_length
	call	_left_set2edl
	call	_adv2chr
	mov	cl,Last_Fcm
	mov	dx,offset ZeroBase.rin_lofst		; Where to put MASTER'S time code
	call	_read_convert
	mov	es:byte ptr [di].rtcd_lofst,cl
	ret
_rec_xlate	endp


;----------------------------------------------------------------
; BX points to next character after "SPD:"
; Current_Event_Adr has event address
; If any error, make it a comment with a preceding "*"
_spd_xlate	proc	far
	call	 FAR PTR _pmcspd_xlate_init
	call	_convert2bin	; Get speed %
	call	_motion_convert	; Convert it to FPS
	cmp	cl,MINUS_ASCII
	jnz	spd_xl2
	or	al,80h			; Set hi bit if negative

; Save speed
spd_xl2:mov	es:byte ptr [di].SPD_lofst,al
	mov	es:byte ptr [di].cmnt_lofst,Editline_SPD	; Mark as SPD

spd_xl3:call	_adv2chr	; Go to '=' before FPS
	or	al,al
	jz	spd_xlx
	cmp	al,'O'			; Check for OUT =
	jz	spd_xl4
	inc	bx
	jmp	spd_xl3

spd_xl4:jnz	spd_xlx
	jmp	_pmcspd_xlate_ret

spd_xlx:ret
_spd_xlate	endp


;----------------------------------------------------------------
_pmc_xlate	proc	far
	call	 FAR PTR _pmcspd_xlate_init
	call	_convert2bin		; Get speed %
	call	_motion_convert		; Convert it to FPS
	cmp	cl,MINUS_ASCII
	jnz	pmc_xl2
	or	al,80h			; Set hi bit if negative

; Save speed
pmc_xl2:mov	es:byte ptr 1[di].SPD_lofst,al ; Save speed

pmc_xl3:mov	al,[bx]
	inc	bx
	cmp	al,'S'			; Look for FP"S"
	jnz	pmc_xl3
	call	_adv2chr		; advance to TIME
	mov	es:byte ptr 2[di].SPD_lofst,al ; Save Sign
	inc	bx

	mov	dx,offset ZeroBase.SPD_lofst + 3
	mov	cl,Last_Fcm		; Use Last_Fcm
	call	_read_convert
	mov	es:byte ptr [di].cmnt_lofst,Editline_PMC	; Mark as PMC

	call	_adv2chr
	cmp	al,'O'			; Check for OUT =
	JMP_NZ	PMC_xlx

	call	_adv2chr
	cmp	al,'O'			; Check for OUT =
	JMP_NZ	PMC_xlx
	jmp	_pmcspd_xlate_ret

_pmc_xlate	endp

;================================================================
_ramp_xlate	proc	far
	call	 FAR PTR _pmcspd_xlate_init
	call	_dltoi			; AX:DX

	mov	es:[di].extra_lofst + offset ZeroBase.SPEED_FROM, AX
	mov	es:[di].extra_lofst + offset ZeroBase.SPEED_FROM+2, DX

	call	_adv2chr
	call	_dltoi

	mov	es:[di].extra_lofst + offset ZeroBase.SPEED_TO, AX
	mov	es:[di].extra_lofst + offset ZeroBase.SPEED_TO+2, DX

	mov	dx, offset ZeroBase.extra_lofst
	add	dx, offset ZeroBase.SPEED_TIME
	mov	cl,Last_Fcm		; Use Last_Fcm
	call	_read_convert

	mov	al,[bx]
	cmp	al,PLUS_ASCII
	jz	rmp_xld
	cmp	al,MINUS_ASCII
	jz	rmp_xld
	mov	al,PLUS_ASCII
rmp_xld:mov	es:[di].extra_lofst + offset ZeroBase.SPEED_DIRECTION, al

	inc	bx
	mov	dx, offset ZeroBase.extra_lofst 
	add	dx, offset ZeroBase.SPEED_START
	mov	cl,Last_Fcm		; Use Last_Fcm
	call	_read_convert

	mov	dx,offset ZeroBase.pout_lofst
	mov	cl,Last_Fcm
	call	_read_convert

	mov	es:byte ptr [di].cmnt_lofst,Editline_RAMP	; Mark as RAMP

rmp_xlx:ret
_ramp_xlate	endp


_pmcspd_xlate_ret	proc	far
	call	_adv2spc		; Get next space
	call	_adv2chr		; Get possible "="
	cmp	al,'='
	jnz	PMC_xlx
	inc	bx
	call	_adv2chr
	mov	dx,offset ZeroBase.pout_lofst
	mov	cl,Last_Fcm
	call	_read_convert
PMC_xlx:ret
_pmcspd_xlate_ret	endp

; Index to event, store reel, get sign of first speed
_pmcspd_xlate_init	proc	far
	push	ax
	push	bx
	mov	ax,es:Current_Event
	call	_index_storage
	mov	di,bx
	pop	bx
	pop	ax

	call	_adv2chr	; _adv2chr to next non-space
	mov	dx,di
	add	dx,offset ZeroBase.reel_lofst		; Point to REEL #
	call	_left_set2edl	; Move reel# + pad
	call	_adv2chr

	inc	bx			; Point to number
	mov	cl,al			; Get sign ot CL
	cmp	cl,MINUS_ASCII			; Negative?
	jz	xlir
	cmp	cl,PLUS_ASCII			; Positive?
	jz	xlir
	dec	bx			; Must be number w/out sign
xlir:	ret
_pmcspd_xlate_init	endp

;================================================================
_preread_xlate	proc	far
	mov	di,Current_Event_Adr
	mov	es:byte ptr [di].cmnt_lofst,Editline_PREREAD	; Mark as GPI
	ret
_preread_xlate	endp


;================================================================
; Using the _ASCII2EDL translator routine, place the line read
;  from the file into the EDL at the current event
;
_ReadEvent	proc	far
	cmp	Readline_Length,65	; If length < 65, make comment
	jc	re_ret
	mov	bx,offset Temp_Wrkspce	; DX = destination
	mov	al,[bx]
	call	_check4comment
	jnc	re_1
re_ret:	ret

; Get line number and save it as NEXT if greater than others
re_1:	mov	dx,Current_Event_Adr	;2-20-1995 Save address of master
	mov	MasterEditLineAdr, dx	; edit line

	push	bx			; Save source
	call	_convert2bin		; DX = current line number
	cmp	es:Next_Edit,ax		; Is OLD => CURRENT?
	ja	re_2
	inc	ax
	mov	es:Next_Edit,ax
; Count lines read and display to the screen
re_2:	inc	Events_Iod
	mov	ax,Events_Iod
	cmp	Port_IO_Flag,0ffh
	jz	re_3
	call	_evnum
; Restore source and destination, PROCESS LINE, and return
re_3:	pop	bx
	call	_ASCII2EDL
	ret
_ReadEvent	endp


BSEG	ends

_STACK	segment word stack 'STACK'

_STACK	ends

_DATA	segment byte public 'DATA'

; 53 acceptable characters for DOS filenames
Fnchars_Table	db	'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789:.\$%',39,'-@{}~`!#()&'

MCBad		db	'MBC Error. Aborting',cr,lf,'$'
iProgramFound	db	0
iLastMcbFound	dw	0
wPspOwner	dw	0

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

