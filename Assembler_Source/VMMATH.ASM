; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner

;VMMATH.ASM

include	VM.EQU

%nolist

extrn Calc_Flag:byte,Calcfunc:byte,Current_Constant:byte,Current_Source:byte
extrn Flag1:byte,Flag2:byte,Flag3:byte,Flag4:byte,Flag5:byte,Frame_Flag:byte
extrn From_Machine:byte,Keybkgnd_Src:byte,Keyfor_Src:byte
extrn Operational_Flags:word,Rtcf:byte,Sortwhat:byte,Swap_Bin:byte
extrn To_Machine:byte,Trans_Type:byte,MatchingTC_Fcm:byte
extrn MatchExtendFlag:byte

extrn Current_VTRS:word,Ascii_Line:word,mtchNoReel_ovr:word
extrn Bytstr1:word,Bytstr2:word,Bytstr3:word,Bytstr4:word,calc1_ovr:word
extrn Calcstor1:word,Calcstor2:word,Calcttl_Scr:word
extrn Clean_Offset:word,Cln_Evnt_End:word,Cln_Evnt_Strt:word,Constants:word
extrn Count:word,Current_BKGbuf:word,Current_FORbuf:word,Current_FRMbuf:word
extrn Current_TObuf:word,Current_Event:word,Current_Event_Adr:word
extrn Cursor:word,Dfbuf1:word,Dfbuf2:word,dirbuff:word,Dmin_Cnt:word
extrn Elaptm:word,Entime:word,function_ovr:word
extrn Hrs_Cnt:word,Hundredhrs:word
extrn matchfnd_ovr:word,Matchframe_From:word,MatchingTC_Buf:word
extrn MatchingTC_Event:word,Min_Cnt:word,Msg_Area:word,Next_Avail_Num:word
extrn Next_Edit:word,pointer_ovr:word
extrn R_Tc:word,searching_ovr:word,Sort_Cevent:word
extrn Sort_Iters:word,sort_ovr:word,Sort_Reeladr:word,sorting_ovr:word
extrn sortln_ovr:word,Sortmatch_In:word,Sortmatch_Out:word,sortreels_ovr:word
extrn Starting_Number:word,Sttime:word,Tcdispbuf:word,Temp_Event:word
extrn Temp_Tc_Buf:word,Transtyp_Scr:word,Twenty4hrs:word,Where2_Number:word
extrn Work_Event:word,Workspace_Flags:word,Twenty4hrs_N:word
extrn Find_Buffer:word,Find_Df:word,Find_Nd:word

extrn _NewDuration:far,_check4edl:far, _match_reels:far
extrn _clear_tc:far,_cnvt2tc_DS:far,_const_upd:far,dec_cimsg:near
extrn _Elaptm_move:far,_Entime_move:far,_get_dur:far
extrn _get_in:far,_get_out:far,_getlast_Flags:far,_getlast_ptcd:far
extrn _getlast_reel:far,_getlast_rin:far,_getlast_rout:far,_getprev_mode:far
extrn _getprev_pin:far,_getprev_rin:far,_getprev_rout:far,_getthis_mode:far
extrn _getthis_rin:far,_getthis_rout:far,_Inout_init:far,_kbd_message:far
extrn Machine_Change:near,_mmv3byt:far
extrn _mmv_ESDS:far,_mode_upd:far,Mtchvtr:near,_mvb2st3:far,_mvb2st4:far
extrn norm_kbd:near,norm_kbd:near,pos_yn_chos:near,rdchar:near
extrn Security_Return:near,_Sttime_move:far,_sttime_move_ES:far,tc_cimsg:near
extrn tcprty0:near,_time_value:far,Trans_Upd:near,_upd_getscr:far
extrn Match_Vtr_Ext:near,Machine_Change_Far:far

extrn _ConOut:FAR,_tc_negate:far
extrn _Break_check:FAR,_cmpchr:far,_comsg:FAR,_constant_disp:far
extrn _constant_index:far,_constant_prompt:far,_delete:far
extrn _dircur_infarea:FAR,_error_bell:FAR,_event_display:far
extrn _evnt_dispthis:far,_evnum:far,_help_pos:FAR,_index2bin:far
extrn _index_storage:far,_kbd_clear:far,_kbd_cln:FAR,_line_first:far
extrn _macone:far,_make_room:far,_mmv:far,_msgread:far,_working:far
extrn _add_store:far,get_vtrcb_FCM_FAR:far

extrn _convert2bin:far,_mpbadd:far,_mpbsub:far,_mpbmul:far,_mpbdiv:far
extrn _mod100hrs:far,_bin3set:far,_sort_match:far,_srtbin2bin:far
extrn _sort_reels:far,_bin3set:far,_cmp24b:far,_cmp24b_DSES:far,_cnvt2df:far
extrn _ReCompute_EFX:far

%list

;Arithmetic and timecode evaluation/comparison/movement routines
_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

%nolist


Public  tccalc, tcalc2, tcalc2a, tcalcxr, tcalc3, tcalc3a, tcalc3b, tcalc4
Public  tcalc5, tcalc6, tcalcf, tcalf1, tcl_add, tcl_sub, tcl_mul, tcl_div
Public  tcalcd0, tcalcd, tcalcx, tcalct, tcalc1, tcalcdisp, tcdecd, sortedl
Public  sort_x, sort_1, sort_8, sort_14, sort_16, sort_18, sort_19, sort_20
Public  s2edl_1, s2edl_2, s2edl_5, sort_MoveEvent, sort_MoveExtras, sMC_x
Public  sort_done, sortdn1, sortdn2, sort_byreels, SBR_agn, SBR_1, SBR_2, SBR_3
Public  SBR_4, SBR_fnd, undo, swap_bins, swpbns, match_RESET_FAR, match_RESET
Public  matchx, matchext, match, matchit, match0, match1, mtchlp, mtchlp1
Public  mtchlp2, mtchnxt, mtchno, mtchfnd, mtchnoreel, mtchrok, mtchscd
Public  mtchfn1, mtchtwo, mtchtno, mtchone, mtchfok, mtchmac, mtchmc1
Public  SECURITY_Flag_TEST, CHK_FLG2, CHK_FLG3, CHK_FLG4, CHK_FLG5, secure_ret
Public  hackshere, hackerishere, nhs1, ReCalcWorkspace


ReCalcWorkspace	proc	near
	call	_ReCompute_EFX
	ret
ReCalcWorkspace	endp

;================================================================
;		TIME CODE CALCULATOR
;================================================================
tccalc	proc	near
	mov	Calc_Flag,0ffh		; Note calculator active
	mov	Cursor,offset Calcttl_Scr
	rev_VIDEO FALSE,FALSE
	mov	bx,offset calc1_ovr
	push	bx
	call	_msgread
	pop	bx
	norm_VIDEO FALSE,FALSE
	call	_Inout_init		;  Get from user
	mov	al,NDF_CHAR		;  a non-drop
	mov	bx,offset Calcstor1	;  time code value
	call	tc_cimsg
	call	_time_value		; Exit if null value
	jnz	tcalc2
	jmp	tcalcx
tcalc2:	call	tcalct			; Display first TC value

tcalc2a:norm_VIDEO FALSE,FALSE
	call	_kbd_cln
	mov	bx,offset calc1_ovr	; Get FUNCTION type
	call	_msgread		;  from user,
	mov	bx,offset function_ovr	;  /,*,-,+ or \
	call	_msgread
	call	rdchar
	cmp	ax,offset Escape_xcmd
	jz	tcalcxr
	cmp	ax,offset Space_xcmd
	jz	tcalcxr
	cmp	ax,offset Enter_xcmd
	jnz	tcalc3
tcalcxr:jmp	tcalcx

tcalc3:	cmp	ax,offset Calc2cnst_xcmd
	jnz	tcalc3a
	mov	al,Current_Constant
	mov	ah,0
	jmps	tcalc4

tcalc3a:cmp	ax,offset Const_xcmd
	jnz	tcalc5

	call	_const_upd
	call	_constant_disp
	call	_constant_prompt

	mov	al,2
	call	dec_cimsg
	jnz	tcalc3b
	jmp	tcalc2a

tcalc3b:call	_convert2bin
	cmp	al,16
	jc	tcalc4
	call	_error_bell
	jmp	tcalc2a

tcalc4:	call	_constant_index
	mov	dx,bx
	mov	bx,offset Calcstor1
	call	_mmv3byt
	call	_const_upd
	call	_constant_disp
	call	_constant_prompt
	jmp	tcalc2a

tcalc5:	cmp	al,'+'
	jz	tcalcf
	cmp	al,'-'
	jz	tcalcf
	cmp	al,'*'
	jz	tcalcf
	cmp	al,'/'
	jz	tcalcf
	cmp	al,'\'
	jz	tcalc6
	jmp	tcalc2a
tcalc6:	jmp	tccalc

tcalcf:	mov	Calcfunc,al		; Store function type
	mov	bx,offset Calcstor1	; Display area init
	call	tcalct

	norm_VIDEO FALSE,TRUE
	mov	bx,offset calc1_ovr
	call	_Inout_init		; 10-05-1990
	mov	al,NDF_CHAR
	mov	bx,offset Calcstor2
	call	tc_cimsg
	call	_time_value
	jnz	tcalf1
	jmp	tcalcx

tcalf1:	rev_VIDEO FALSE,FALSE
	push	bx
	mov	Cursor,offset Transtyp_Scr + 100h
	mov	al,Calcfunc
	call	_ConOut
	pop	bx
	call	tcalcdisp

	mov	al,Calcfunc
	cmp	al,'+'
	jz	tcl_add
	cmp	al,'-'
	jz	tcl_sub
	cmp	al,'*'
	jz	tcl_mul
	cmp	al,'/'
	jz	tcl_div

tcl_add:mov	bx,offset Calcstor1
	mov	dx,offset Calcstor2
	call	_mpbadd
	jmp	tcalcd

tcl_sub:mov	bx,offset Calcstor1
	mov	dx,offset Calcstor2
	call	_cmp24b			;if BX < DX
	jae	tcl_sub1
	ERROR	resultbelowzero_error, ERET_Return
	jmp	tcalc2a
;;;;	jmp	tccalc

tcl_sub1:
	call	_mpbsub			; BX - DX
	jmp	tcalcd

tcl_mul:mov	bx,offset Calcstor1	; First move stor1 to 3
	mov	dx,offset Calcstor2
	call	_mpbmul
	jmp	tcalcd

tcl_div:mov	bx,offset Calcstor1
	mov	dx,offset Calcstor2
	call	_mpbdiv

; Display answer
tcalcd0:mov	bx,offset Calcstor1
tcalcd:	call	_mod100hrs
	rev_VIDEO FALSE,FALSE
	push	bx
	mov	Cursor,offset Transtyp_Scr + 200h
	mov	al,'='
	call	_ConOut
	pop	bx
	call	tcalcdisp
	call	tcdecd
	mov	dx,offset Calcstor1
	call	_mmv3byt
	jmp	tcalc2a

tcalcx:	call	_evnt_dispthis
	call	_mode_upd
	call	Trans_Upd
	ret

; Clear calc area and display first number
tcalct:	rev_VIDEO FALSE,FALSE
	push	bx
	push	cx
	mov	bx,offset Transtyp_Scr	; Clear out screen information
	mov	cx,4			;  area to blanks
tcalc1:	call	_dircur_infarea
	inc	bh
	loop	tcalc1
	pop	cx

	mov	Cursor,offset Transtyp_Scr + 1
	pop	bx

tcalcdisp:
	push	bx
	mov	dx,offset Tcdispbuf
	mov	cl,NDF_CHAR
	call	_cnvt2tc_DS
	call	tcprty0
	pop	bx
	ret

tcdecd:	mov	Cursor,offset Transtyp_Scr + 301h
	not	Frame_Flag
	call	tcalcdisp
	not	Frame_Flag
	ret
tccalc	endp

;================================================================
;	Sort the EDL by RECORD IN POINT or EVENT number
;================================================================
sortedl	proc	near
	call	_check4edl		; Skip if no EDL
	jz	sort_x

	mov	bx,offset sort_ovr	; Ask: Sort by RECORD IN?
	mov	cl,'N'
	call	pos_yn_chos
	jc	sort_x
	mov	al,0			; Set Flag for RECORD IN
	jz	sort_1

	mov	bx,offset sortln_ovr	; Ask: Sort by event number?
	mov	cl,'N'
	call	pos_yn_chos
	jc	sort_x
	mov	al,1			; Set Flag for EVENT NUMBER
	jz	sort_1

	mov	bx,offset sortreels_ovr
	mov	cl,'N'
	call	pos_yn_chos
	jnz	sort_x
	jmp	sort_byreels
sort_x:	ret

sort_1:	mov	Sortwhat,al		; Save Flag sort type
	mov	bx,offset pointer_ovr
	call	_kbd_cln
	call	_msgread
	mov	bx,offset sorting_ovr
	call	_msgread
	call	_bin3set	; Set up bin #3 with a default header

	mov	ax,es:Next_Avail_Num	; Get # of lines + 1
	dec	ax
	mov	Sort_Iters,ax		; # of lines to sort + 1
	mov	Where2_Number,0		; Starting event # in destination bin

;----------------------------------------------------------------
; Check for comments at the top of the EDL.
; If found, move them to the swap bin
; and then delete them from the current bin
	mov	ax,1			; First event
	call	_index_storage
	jnc	sort_8
	mov	Sort_Cevent,ax
	call	sort_MoveEvent

;----------------------------------------------------------------
; Loop for sort
sort_8:	mov	ax,Sort_Iters		; Word size iteration counter
	or	ax,ax
	jnz	sort_14			; Jump if not zero
	jmp	sort_done
sort_14:call	_evnum			; Display the interation number

; Find the event with the lowest REC IN POINT
	mov	es:Current_Event,0	; Start with event 1 -1
	mov	Starting_Number,0ffffh	; Highest (and impossible) edit number

sort_16:mov	ax,es:Current_Event	; Check for end of list
	inc	ax			; Point to next event
	cmp	ax,es:Next_Avail_Num
	jnc	sort_18
	call	_index_storage		; Point to next event
	jc	sort_16			; Skip comments
	FLAGBITS sort_Fmask		; Test if already sorted...
	jnz	sort_16			;  and jump if so

	mov	bx,es:[bx].ednum_lofst	; Is new edit number (BX)
	cmp	bx,Starting_Number	;  < old edit number (DX)
	jnc	sort_16
	mov	Starting_Number,bx
	mov	ax,es:Current_Event
	mov	Sort_Cevent,ax
	jmps	sort_16

sort_18:push	es
	cmp	Sortwhat,1
	jz	sort_19

	mov	ax,Sort_Cevent
	call	_index_storage
; Move the record in and out to the sortmatch buffers
	add	bx,offset ZeroBase.rin_lofst		; Point to the RECORD IN
	mov	dx,offset Sortmatch_In	; Sortmatch_Out immediatly follows
	mov	ch,6			; Move all six bytes
	call	_mmv_ESDS

;----------------------------------------------------------------
; Switch bins to the DESTINATION bin.
; Use SORT_MATCH routine to locate correct placement
sort_19:mov	al,Swap_Bin
	call	_index2bin		; Get swap bin to ES

	cmp	Sortwhat,1		; Sort by event number?
	jz	sort_20

; IF SORTING BY RECORD IN
	call	_sort_match		; Rets w/ AX = event# in bin3 or C=1

	jnc	s2edl_1			; C=1 if NOT found, so jump if found
	mov	ax,1			; If not found, insert at top
	jmp	s2edl_5

;IF SORTING BY EVENT NUMBER
sort_20:mov	ax,Where2_Number

s2edl_1:inc	ax				; Inc event, check eol
	cmp	ax,es:Next_Avail_Num
	jbe	s2edl_2
	mov	ax,es:Next_Avail_Num
	jmp	s2edl_5

s2edl_2:mov	es:Current_Event,ax	; C=1 if within list
	call	_index_storage		; Check to see if we should
	jc	s2edl_1			;  advance past cmt/slv/mem, etc.
	FLAGBITS split_Fmask		; Check for split edit
	jnz	s2edl_1			; Increment over second split line
	cmp	es:byte ptr [bx].type_lofst,'C'
	jnz	s2edl_1

; IF EITHER SORT BY RECORD IN OR EVENT NUMBER
s2edl_5:pop	es
	call	sort_MoveEvent
	jmp	sort_8
sortedl	endp

;................................................................
; Move evnet Sort_Cevent to edit OTHERBIN:AX
sort_MoveEvent	proc	near
	mov	Where2_Number,ax
	mov	ax,Sort_Cevent
	call	_index_storage
	pushf
	call	_srtbin2bin
	popf
	jc	sort_MoveExtras		; Continue if comment
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	sort_MoveExtras

	mov	ax,es:Current_Event	; Move second line of edit
	inc	ax
	call	_index_storage
	inc	Where2_Number
	call	_srtbin2bin
sort_MoveEvent	endp

;................................................................
; Move all attached comments and Extras
sort_MoveExtras	proc	near
	mov	ax,es:Current_Event
	inc	ax
	cmp	ax,es:Next_Avail_Num
	jnc	sMC_x
	call	_index_storage
	jnc	sMC_x
	inc	Where2_Number
	call	_srtbin2bin
	jnz	sort_MoveExtras
sMC_x:	ret
sort_MoveExtras	endp


;----------------------------------------------------------------
; Clear out all "sorted" bit Flags in the EDL and Exit
sort_done	proc	near
	mov	cx, NOT sort_Fmask	; ANDing bit for following routine
	mov	ax,es:Next_Avail_Num	;	CLEAR OUT ALL
sortdn1:dec	ax			;	HI BITS USED TO
	jz	sortdn2			;	INDICATE SORTED
	call	_index_storage		;	EVENTS...
	and	es:[bx].Flags_lofst,cx
	jmps	sortdn1

sortdn2:call	swap_bins
	mov	ax,1
	call	_event_display
	mov	ERROR_ACTIVE,0		; Signal file error
	ret
sort_done	endp

;================================================================
;		SORT EDL BY REELS ("C" MODE)
;================================================================
sort_byreels	proc	near
	mov	Sortwhat,2		; Signal reel type sort
	call	_sort_reels		; Get sorted reel list to DIRBUFF
	mov	Sort_Reeladr,offset dirbuff ; Init pointer to top of reel list

	call	_working

	call	_bin3set		; Set up bin #3 with a default header

	mov	Where2_Number,0		; Starting event # in destination bin

SBR_agn:mov	Sort_Iters,1		; Begin with first edit

SBR_1:	mov	ax,Sort_Iters
	call	_index_storage
	jc	SBR_3			; Skip the comments
	FLAGBITS sort_Fmask		; Test if already sorted...
	jnz	SBR_2			;  and jump if so

	call	_getlast_reel
	mov	dx,Sort_Reeladr		; Get current reel address
	mov	ch,reel_length
	call	_cmpchr			; Compare ES:reel, DS:reel
	jz	SBR_fnd

SBR_2:	mov	ax,Sort_Iters
	call	_index_storage
	inc	ax
	FLAGBITS dblline_Fmask
	jz	SBR_4
SBR_3:	inc	ax
SBR_4:	mov	Sort_Iters,ax
	cmp	ax,es:Next_Avail_Num
	jnz	SBR_1
	mov	bx,Sort_Reeladr		; Get current reel address
	add	bx,reel_length + 1
	mov	Sort_Reeladr,bx
	cmp	byte ptr [bx],0		; Out of names?
	jnz	SBR_agn
	jmp	sort_done

; Reel match is GOOD
SBR_fnd:mov	ax,es:Current_Event	; Get current event number
	mov	Sort_Cevent,ax		;  and make it the one to move

	push	es			; Save current bin#
	mov	al,Swap_Bin
	call	_index2bin
	mov	ax,es:Next_Avail_Num	; Get dest bin's next edit #
	pop	es
	call	sort_MoveEvent
	jmp	SBR_1
sort_byreels	endp

;================================================================
;			UNDO EDL
;================================================================
; Swap current edl with edl in BIN3
undo	proc	near
	mov	ax,es:Current_Event
	push	ax
	call	swap_bins
	pop	ax
	call	_event_display
	ret
undo	endp

;----------------------------------------------------------------
;		BIN SWAPPING / MOVING
;----------------------------------------------------------------
; Swap currnet BIN with BIN3.  Used by UNDO and by SORT
swap_bins	proc	near
	push	ds
	push	es

	push	es
	mov	al,Swap_Bin
	call	_index2bin
	mov	ax,es
	mov	ds,ax
	pop	es

	mov	cx,7ffeh
	mov	di,2
	mov	si,di
swpbns:	mov	ax,[si]			; Get byte from BINn
	mov	dx,es:[di]		; Get word from BIN3
	stosw				; Save AX to ES:DI, DI=DI+2
	mov	[si],dx
	inc	si
	inc	si
	loop	swpbns
	pop	es
	pop	ds
	ret
swap_bins	endp


;================================================================
;		SEARCH EDL FOR MATCHING TIMECODE
;================================================================
; Start at bottom of EDL, search backward
match_RESET_FAR	proc	far
	call	match_RESET
	ret
match_RESET_FAR	endp

match_RESET	proc	near

	mov	byte ptr Find_Buffer,0	; Clear for FIND
	mov	bx,offset Find_Df
	call	_clear_tc
	mov	bx,offset Find_Nd
	call	_clear_tc

	mov	MatchingTC_Event,0
	mov	bx,offset MatchingTC_Buf; Reset for next match
	call	_clear_tc
matchx:	ret
match_RESET	endp


; Extended matches
matchext:
	mov	MatchExtendFlag, TRUE
	jmp	matchit

;Attempt to locate the R_Tc.tcIN in the list
;Start with the last event in the list,
;If EDL R IN < R_Tc.tcIN < EDL R OUT, display event
match:	mov	MatchExtendFlag, FALSE

matchit:mov	bx,offset R_Tc.tcIN	; Use R_Tc.tcIN for search TC val
	call	_time_value		; Dont search if R_Tc.tcIN=0
	jz	match_RESET
	call	_check4edl
	jz	match_RESET		; Ret, if no EDL, or just 1 event

	mov	dx,offset MatchingTC_Buf
	call	_cmp24b
	jz	match0
	push	bx
	call	match_RESET
	mov	dx,bx			; MatchingTC_Buf is destination
	pop	bx			; R_Tc.tcIN is source
	call	_mmv3byt

; MatchingTC_Event has starting position. If 0, start from bottom
match0:	mov	cx,MatchingTC_Event	; See if there was previos match
	or	cx,cx
	jz	match1			; Start at END of EDL if CX=0
	mov	ax,cx			; Else begin at current event
	jmps	mtchlp

match1:	mov	ax,es:Next_Avail_Num	; Use last edit
	dec	ax

mtchlp:	call	_line_first		; Get first line
	mov	MatchingTC_Event,ax
	call	_index_storage
	jc	mtchnxt			; Skip the comments

	push	ax			; Save event number

; See if R_Tc.tcIN => this event's R_IN.  Skip if not
	call	_getlast_rin
	mov	dx,bx
	mov	bx,offset R_Tc.tcIN	; R_Tc.tcIN to BX
	call	_cmp24b_DSES		; Is R_Tc.tcIN => R IN?
	pop	cx			; Restore event number
	jc	mtchnxt			; NO, less than

; See if R_Tc.tcIN <= this event's R_OUT.  Skip if not
	call	_getlast_Flags		; Lets check for dbl line
	test	word ptr es:[bx],dblline_Fmask
	jz	mtchlp1
	mov	ax,cx			; Get event number
	inc	ax			; Go to next line
	call	_index_storage
	call	_getlast_rout
	mov	ax,cx
	push	bx
	call	_index_storage
	pop	bx
	jmps	mtchlp2

mtchlp1:call	_getlast_rout

mtchlp2:mov	dx,bx
	mov	bx,offset R_Tc.tcIN
	call	_cmp24b_DSES		; Is R_Tc.tcIN <= R OUT?
	jbe	mtchfnd

mtchnxt:dec	MatchingTC_Event
	mov	ax,MatchingTC_Event
	jnz	mtchlp

mtchno:	xor	ax,ax
	mov	MatchingTC_Event,ax	; Init Count of matches
	call	match_RESET
	mov	ax,Temp_Event
	call	_event_display
	ERROR	out_of_range, ERET_Keyboard

; R_Tc.tcIN is contained within this edit.  Calculate match frames
mtchfnd:call	Match_Vtr_Ext	;Mtchvtr
	mov	MatchExtendFlag, FALSE	; Clear extend Flag 9-28-1993 
	jnc	mtchrok
mtchnoreel:
	call	_evnt_dispthis
	dec	MatchingTC_Event
	call	_kbd_cln
	mov	bx,offset mtchNoReel_ovr
	call	_msgread
	call	rdchar
	call	_macone
	ret

mtchrok:dec	MatchingTC_Event
	push	bx
	mov	bx,Current_Event_Adr
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	pop	bx
	jnz	mtchfn1			; If double line, get second line
mtchscd:call	mtchone			; Else get one line
	call	rdchar
	jmp	mtchmac

	
mtchfn1:call	mtchone			; Get first
	call	rdchar
	cmp	ax,offset Match_xcmd	; Get first line, too?
	jz	mtchtwo
	jmp	mtchmac

mtchtwo:mov	bx,Current_Event_Adr	; TEST FOR SPLIT EDIT
	test	es:word ptr [bx + line_length].Flags_lofst,split_Fmask
	jnz	mtchtno

	call	_match_reels
	JMP_NZ	mtchnxt
	mov	bx,offset Matchframe_From
	jmp	mtchscd

mtchtno:cmp	MatchingTC_Event,0
	JMP_Z	match1
	dec	MatchingTC_Event
	jmp	mtchmac


mtchone:
	cmp	MatchingTC_Fcm,DF_CHAR
	jnz	mtchfok
	call	_cnvt2df
mtchfok:mov	Current_Constant,0
	mov	dx,offset Constants	; Index to constant 0
	call	_mmv3byt
	call	_const_upd
	call	_evnt_dispthis
	call	_kbd_cln
	mov	bx,offset matchfnd_ovr
	call	_msgread
	ret

mtchmac:cmp	ax,offset Scrini_xcmd	; Check for a cancel
	jnz	mtchmc1
	jmp	match_RESET
mtchmc1:call	_macone
	ret

;==========================
; Check Hacker Flags
; AL = value to check for, 0 or 1
;==========================
SECURITY_Flag_TEST	proc	near
	cmp	Flag1,al
	jnz	hackshere
SECURITY_Flag_TEST	endp
CHK_FLG2	proc	near
	cmp	Flag2,al
	jnz	hackshere
CHK_FLG2	endp
CHK_FLG3	proc	near
	cmp	Flag3,al
	jnz	hackshere
CHK_FLG3	endp
CHK_FLG4	proc	near
	cmp	Flag4,al
	jnz	hackshere
CHK_FLG4	endp
CHK_FLG5	proc	near
	cmp	Flag5,al
	jnz	hackshere
CHK_FLG5	endp
secure_ret	proc	near
	ret
secure_ret	endp

hackshere	proc	near
hackshere	endp

hackerishere	proc	far
	mov	sp,bp
	pop	bx
	lea	bx,Security_Return
hackerishere	endp
	jmp	[bx]

;----------------------------------------
;	Copywrite Identification
;----------------------------------------
nhs1	db	'N'+80h,'H'+80h,'S'+80h

_TEXT	ends

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
;	