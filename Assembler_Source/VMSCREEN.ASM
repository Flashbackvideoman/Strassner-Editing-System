; Last revised: 2-22-1995, 11:12:27   (C)1989-1995 Norman H. Strassner

;VMSCREEN.ASM
;Containes screen positioning/video routines
;And other screen-oriented subroutines
;-------------------------------------------
%nolist
include	VM.EQU
%nolist

extrn EVcmd_Flag:byte,Active_Bin:byte,Available_Bins:byte,Bottom_Bin:byte
extrn Current_Constant:byte,Current_Machine:byte,Diagnostics_Flag:byte
extrn Frame_Flag:byte,Fullscreen_Flag:byte,Record_Flag:byte,Rtcf:byte
extrn Scrl_Edlpage:byte,Seconds_Count:byte,Split_Bin:byte,Swap_Bin:byte
extrn Top_Bin:byte

extrn Edl_Seg:word,EDL_Window_Cursor:word,EDLoptions_Flags:word
extrn PointShootData:word,bin_ovr:word,Bin_Table:word,binlist_ovr:word
extrn Constants:word,Current_Event:word,Cursor:word,Editmode_Scr:word
extrn Edl_Formats:word,Edlscroll_Msg:word,Edmsg:word,Empty_Msg:word
extrn File_Title:word,Gpi0:word,hdr_ovr:word,Keyboard_Msg:word
extrn Keyboard_Scr:word,Last_Evnum:word,Lastplace:word,List_Scr:word
extrn Mode_Pntr:word,Msg_Area:word,Next_Avail_Num:word,Page_Position:word
extrn Page_Qry:word,Screen_Buffer:word,Screen_Seg:word
extrn Sounddisplay_Flags:word,Tcdispbuf:word,Temp_Tc_Buf:word,Title1_Scr:word
extrn Untitled_Msg:word,Videoram:word

extrn KeyCommand_SplitScreen:near,ramp_upd:near
extrn Pmc_Upd:near,Preread_UPD:near,Spd_Upd:near,Clean_Upd:near
extrn dec_cimsg:near,devstat_clr:near,Diskon_Upd:near,Gpi_Upd:near
extrn keywait:near,Machine_Change:near,match_RESET:near,position_query:near
extrn Print_Upd:near,rdchar:near,Sort_Upd:near,swap_bins:near
extrn SWenable_Upd:near,Tag_Upd:near,Trans_Upd:near,Vlan_Upd:near

extrn _ConOut:far
extrn _EDL2ASCII:far,_EDL_display:far,_MsgCntr:far,_Space_Out:far
extrn _active_machines:far,_add_store:far,_Break_check:FAR
extrn _check4edl:far,_clear_eop:far,_clear_screen:far,_cnvt2tc_DS:far
extrn _comsg:far,_const_upd:far,_convert2bin:far,_crlf:far,_Cursor_off:far
extrn _dashit_cl:far,_dec_Space_Out:far,_decpadt:far,_delfrm:FAR,_delms:FAR
extrn _dircur_lerase:far,_dixdly:FAR,_draw_machines:far,_draw_screen:far
extrn _event_display:far,_evnt_dispthis:far,_file_ttl_upd:far
extrn _find_edit_DX:far,_hl_lp:far,_index2bin:far,_index_storage:far
extrn _kbd_message:far,_line_dim:far,_line_erase:far,_line_reverse:far
extrn _listtype_upd:far,_lty_1:far,_macroindex:FAR,_macrotindex:FAR
extrn _make_dec:far,_msgread:far,_time_upd:far,_time_value:far
extrn _upd_getrel:far,_upd_getscr:far,Jogger_FAR:FAR,Keyboard:far

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg



Public  switch_bins, swmb1, swmultbins, swbnsx, swbnsx1, swbnsx2, binswitch
Public  bswagn, binsw1, bsw_x, bsw_disp, bswd1, bswdt, bswdt1, bsw_ttl, bsw_t1
Public  bswx, bindclr, bindcll, SScreen_bin1_pos, Split_Screen, SS_1, SS_2
Public  SS_upda, SS_agn, SS_ret2, SS_xit, SS_toggle, SS_toggle2, SS_tx
Public  SS_active, SS_undo, Split_Screen_Update, ssarrows, ssbn, SSclearIfZero
Public  sscxz, page_dn, pgdn1, pgdn2, page_up, pgup1, pgup2, pgud, scroll_next
Public  JL0450, scroll_last, scrlx, scrld, scrlflx, evnt_Lastplace
Public  display_toggle, dtogset, dtoged, page_file, dfp_dfl, dfp_nmd, dfp_lp0
Public  dfp_lp1, dfp_lp2, dfp_lp4, dfp_ret, dfp_prm, dfp_agn, dfp_prr, dfp_swp
Public  dfpswp1, dfp_pr1, dfp_pl1, dfp_pl2, dfp_pr2, dfp_prz, dfp_pr3, dfp_pr4
Public  dfp_pl3, dfp_pl4, dfp_pop, tc_disp_FAR, tc_disp, tcprtty, tcprty0
Public  tcprtyr, tcprty0_FAR, tcprty1, tc_parenth, tcpar1, tcparx
Public  _screen_init_FAR, cancel_request, screen_init, all_update, allupdx
Public  scroll_constback, sccnst2, scroll_Constants, sccnst0, sccnst1
Public  gpi_index, space_2_out, re_kbd, norm_kbd, kbdispN, kbdisp_FAR, kbdisp
Public  trim_init, blmsg, kbd_msgs, kbd_msgread, emset, time_date, timdax
Public  timestamp_FAR, timestamp, timstp0, timstp1, timstp2, timstp3, timstpx
Public  timslsh, active_machines_FAR

%list


;================================================================
;		SWITCH BETWEEN BINS
;================================================================
switch_bins	proc	near
	cmp	Fullscreen_Flag,0ffh
	jz	swbnsx
	cmp	Available_Bins,maxbins
	jnz	swmultbins

	mov	cl,1
	cmp	Active_Bin,2
	jz	swmb1
	inc	cl
swmb1:	call	binsw1
	call	_file_ttl_upd
	call	_listtype_upd
	call	_evnt_dispthis
	ret

swmultbins:
	call	binswitch
	call	_file_ttl_upd
	call	_listtype_upd
	call	_evnt_dispthis
	ret

swbnsx:	call	binswitch
	mov	al,Active_Bin
	cmp	Split_Bin,0			; In bottom bin?
	jz	swbnsx1
	mov	Top_Bin,al
	jmp	swbnsx2
swbnsx1:mov	Bottom_Bin,al
	mov	ax,es:Current_Event
swbnsx2:call	Split_Screen_Update
	ret
switch_bins	endp

binswitch	proc	near
	mov	PointShootData.PQ_Flag,PQF_KEYTHRU
	mov	ax,EDL_Window_Cursor
	add	ax,200h
	mov	PointShootData.PQ_Cursor,ax
	mov	al,Available_Bins
	dec	al
	mov	PointShootData.PQ_rows,al
	mov	PointShootData.PQ_choices,al
	mov	PointShootData.PQ_cols,1
	mov	PointShootData.PQ_tab,80
	mov	PointShootData.PQ_field,80
	mov	PointShootData.PQ_exitkey,offset Bins_xcmd

	call	bindclr
	call	bsw_disp

bswagn:	mov	cl,Active_Bin
	call	position_query
	jc	bsw_x			; Carry set if exiting

; Al = BIN# 1-x
binsw1:	mov	Active_Bin,cl
	mov	al,cl
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es
bsw_x:	ret
binswitch	endp

;................................................................
bsw_disp	proc	near
	mov	dx,EDL_Window_Cursor
	mov	Cursor,dx
	mov	bx,offset binlist_ovr
	call	_MsgCntr
	add	dx,100h
	mov	Cursor,dx
	mov	bx,dx
	mov	cx,80
	mov	al,196
	call	_hl_lp

	push	es
	mov	di,PointShootData.PQ_Cursor

	mov	si,offset Bin_Table
	mov	cl,1

bswd1:	cmp	cl,Available_Bins
	jae	bswx
	dec	cl
	mov	Cursor,di
	call	_dashit_cl
	lodsw
	mov	es,ax

	call	_check4edl
	jnz	bswdt
	mov	bx,offset Empty_Msg
	call	_comsg
	jmp	bsw_t1

bswdt:	mov	bx,offset File_Title + 7
	mov	al,es:[bx]
	or	al,al
	jz	bswdt1
	cmp	al,cr
	jnz	bsw_ttl
bswdt1:	mov	bx,offset Untitled_Msg
	call	_comsg
	jmp	bsw_t1

bsw_ttl:mov	al,es:[bx]
	inc	bx
	or	al,al
	jz	bsw_t1
	cmp	al,cr
	jz	bsw_t1
	call	_ConOut
	jmp	bsw_ttl

bsw_t1:	add	di,100h
	inc	cl
	jmp	bswd1

bswx:	pop	es
	ret
bsw_disp	endp

bindclr	proc	near
	mov	ax,EDL_Window_Cursor
	mov	Cursor,ax
	mov	cx,9
	push	Cursor
bindcll:call	_line_erase
	call	_crlf
	loop	bindcll
	pop	Cursor
	ret
bindclr	endp

;================================================================
;		SPLIT EDL SCREEN
;================================================================
SScreen_bin1_pos	equ	(3 * 256) + 0
Split_Screen	proc	near
	mov	al,Active_Bin		; Save bin from whence we came
	push	ax

	mov	Fullscreen_Flag,0ffh	; Signal no VTR location updates
	call	_clear_screen

	mov	Split_Bin,0		; Set for bottom bin

	mov	al,Active_Bin		; Make the active bin
	mov	Bottom_Bin,al		;  the bottom bin

	mov	ah,Top_Bin		; Get last top bin
	cmp	al,ah			; Are they the same
	jnz	SS_1			; Jump if not
	inc	ah
	cmp	ah,Swap_Bin		; Out of bins?
	jnz	SS_1
	xor	ah,ah
SS_1:	or	ah,ah
	jnz	SS_2
	inc	ah
SS_2:	mov	Top_Bin,ah

	dim_VIDEO FALSE,TRUE
	mov	Cursor,offset Title1_Scr; Display title
	mov	bx,offset hdr_ovr	;  message
	call	_MsgCntr

SS_upda:call	Split_Screen_Update

SS_agn:	call	norm_kbd
	call	rdchar
	call	_Break_check
	jz	SS_xit

	call	KeyCommand_SplitScreen
	push	ax			; Save command key
	jnz	SS_ret2
	call	[si]

SS_ret2:mov	al,Top_Bin
	cmp	al,Bottom_Bin
	pop	ax			; Restore command key
	jz	SS_upda
	cmp	ax,offset Move_xcmd	; Update for MOVE?
	jz	SS_upda
	jmp	SS_agn

SS_xit:	pop	ax
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es
	call	screen_init
	ret
Split_Screen	endp

;................................................................
; Switch between bins
SS_toggle	proc	near
	mov	dx,EDL_Window_Cursor
	dec	dx
	call	_line_dim

	cmp	Split_Bin,0			; Bottom Bin?
	jz	SS_toggle2
	mov	EDL_Window_Cursor,offset List_Scr
	mov	al,Bottom_Bin
	mov	Split_Bin,0
	jmp	SS_tx

SS_toggle2:
	mov	EDL_Window_Cursor,SScreen_bin1_pos
	mov	al,Top_Bin
	mov	Split_Bin,0ffh

SS_tx:	mov	Active_Bin,al
	call	_index2bin
 	mov	Active_Bin,al
	mov	Edl_Seg,es
SS_toggle	endp
SS_active	proc	near
	mov	dx,EDL_Window_Cursor
	dec	dx
	call	_line_reverse
	ret
SS_active	endp

SS_undo	proc	near
	call	swap_bins
	mov	ax,es:Current_Event
	call	_EDL_display
	ret
SS_undo	endp

;................................................................
; Update both EDL windows
Split_Screen_Update	proc	near
	push	EDL_Window_Cursor
	mov	al,Active_Bin
	push	ax

	mov	al,Top_Bin
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es
	mov	EDL_Window_Cursor,SScreen_bin1_pos
	call	SSclearIfZero

	mov	ax,es:Current_Event
	call	_EDL_display
	mov	Cursor,SScreen_bin1_pos - 100h; Display BIN number
	mov	bx,offset bin_ovr	; "BIN "
	call	_msgread
	mov	al,Top_Bin
	call	_dec_Space_Out
	call	ssarrows

	mov	al,Bottom_Bin
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es
	mov	EDL_Window_Cursor,offset List_Scr
	call	SSclearIfZero
	mov	ax,es:Current_Event
	call	_EDL_display
	mov	Cursor,offset List_Scr - 100h
	mov	bx,offset bin_ovr
	call	_msgread
	mov	al,Bottom_Bin
	call	_dec_Space_Out
	call	ssarrows

	pop	ax
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es
	pop	EDL_Window_Cursor
	call	SS_active
	ret

ssarrows:
	mov	cx,Cursor
	mov	ch,78
	sub	ch,cl
	mov	cl,ch
	mov	ch,0
	mov	al,1fh
ssbn:	call	_ConOut
	loop	ssbn
	ret

SSclearIfZero:
	call	_check4edl
	jnz	sscxz
	call	bindclr
sscxz:	ret
Split_Screen_Update	endp
	
;================================================================
; Rules governing FlagS:
; dblline_Fmask	is SET (1) if this is any kind of two line
;		event, dissolve, key, wipe, or split.
;		It is only set for the FIRST LINE of the
;		double line event.
;
; split_Fmask	is SET (1) on the SECOND LINE of the double
;		line event ONLY IF dblline_Fmask on the previous
;		line is SET (1). 
;================================================================
;================================================================
;	EDL SCROLLING ROUTINES
;================================================================
;
; Move display down one page
; ENTER: NOTHING
; Exit:  EDL PAGED DOWN
page_dn	proc	near
	mov	ax,es:Current_Event
	cmp	EVcmd_Flag,0ffh
	jnz	pgdn1
	add	ax,offset Scrl_Edlpage - 5
	jmp	pgdn2
pgdn1:	add	ax,offset Scrl_Edlpage
pgdn2:	cmp	ax,es:Next_Avail_Num
	jc	pgud
	mov	ax,es:Next_Avail_Num
	dec	ax
	jmp	pgud
page_dn	endp

; Move display up one page
; ENTER: NOTHING
; Exit:  EDL PAGED UP
page_up	proc	near
	mov	ax,es:Current_Event
	cmp	EVcmd_Flag,0ffh
	jnz	pgup1
	sub	ax,offset Scrl_Edlpage - 5
	jmp	pgup2
pgup1:	sub	ax,offset Scrl_Edlpage
pgup2:	ja	pgud
	mov	ax,1
pgud:	call	_EDL_display
	ret
page_up	endp

; Scroll EDL to next event line.  Skip 2nd line of double line event
; ENTER: NOTHING
; Exit:  EDL SCROLLED DOWN
scroll_next	proc	near
	mov	ax,es:Current_Event
	call	_index_storage
	jc	JL0450			; Skip comment and display next
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jz	JL0450
	inc	ax
JL0450:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jc	pgud
	ret
scroll_next	endp

; Scroll EDL to previous event line, skip back 2nd line of dbl line evnt
; ENTER: NOTHING
; Exit:  EDL SCROLLED DOWN
scroll_last	proc	near
	mov	ax,es:Current_Event
	or	ax,ax
	jz	scrlflx
	dec	ax
	jz	scrlflx
	dec	ax
	jz	scrlx
	push	es:Current_Event
	call	_index_storage
	pop	es:Current_Event
	jc	scrlx			; Return to next and display
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	jnz	scrld
scrlx:	inc	ax
	cmp	ax,es:Next_Avail_Num
	jnc	scrlflx
scrld:	call	_EDL_display
scrlflx:ret
scroll_last	endp

;================================================================
; Move EDL pointer to previously displayed event before the
;  last EDL scrolling or seek
; ENTER: NOTHING
; Exit:  EDL MOVED TO PREVIOUSLY DISPLAYED EVENT
evnt_Lastplace	proc	near
	mov	ax,Lastplace
	call	_event_display
	ret
;;;;	jmp	dtoged
evnt_Lastplace	endp

; Toggle the OUT/DURATION display type
display_toggle	proc	near
	test	EDLoptions_Flags,outdur_EDLBIT
	jz	dtogset
	and	EDLoptions_Flags,not outdur_EDLBIT
	jmp	dtoged
dtogset:or	EDLoptions_Flags,outdur_EDLBIT
dtoged:	call	_evnt_dispthis
	ret
display_toggle	endp

;================================================================
;			PAGE EDL TO SCREEN
;================================================================
page_file	proc	near
	call	_check4edl
	JMP_Z	dfp_prr
	mov	bx,offset Page_Qry
	call	_kbd_message
	mov	al,4			; Get 1 to 4 digits
	call	dec_cimsg		;  for edit number
	mov	ax,es:Current_Event	; Save current event
	push	ax
	jz	dfp_dfl
	call	_convert2bin		; Convert user input to Edit #
	call	_find_edit_DX		; Go try and find it in the EDL
	jz	dfp_dfl			; Jump if found
	pop	ax
	ERROR	out_of_range, ERET_Keyboard

dfp_dfl:push	es:Mode_Pntr		; Save original mode pointer
	test	EDLoptions_Flags,modedisp_EDLBIT ; Display = EDL FORMAT?
	jnz	dfp_nmd			; Yes, use current format, or...
	mov	es:Mode_Pntr,offset Edl_Formats ; Yes, use standard display

dfp_nmd:call	_clear_screen		; Do what it says...
	mov	Fullscreen_Flag,0ffh
	mov	cx,ax			; CX has starting number
	dec	cx			;  minus 1

	xor	bx,bx			; DISPLAY EDL DISPLAY HEADER LINE
	call	_dircur_lerase
	rev_VIDEO FALSE,FALSE
	call	_lty_1
	dim_VIDEO FALSE,FALSE
	xor	si,si			; Use si as screen line counter
dfp_lp0:mov	Cursor,0100h		; Point to second line
	mov	Last_Evnum,cx		; Save start of page
	mov	es:Page_Position,cx

dfp_lp1:inc	cx			; Increment event counter
	mov	ax,es:Next_Avail_Num	; See if we
	cmp	ax,cx			; Reached the
	jz	dfp_ret			; End of the list
	mov	ax,cx			; If not, index
	call	_index_storage		; To the next event
	jc	dfp_lp2
	norm_VIDEO FALSE,TRUE
dfp_lp2:call	_Space_Out		; Performs the function of
	call	_index_storage		; Moved here on 12-09-1990 so 
	push	ax			;  that it would not have to be
	FLAGBITS sort_Fmask		;  a far call for other routines
	jz	dfp_lp4			;  to use ED_spln in the _TEXT
	rev_VIDEO FALSE,TRUE		;.
dfp_lp4:call	_EDL2ASCII		;.
	call	_comsg			;.
	dim_VIDEO FALSE,FALSE		;.
	pop	ax			;.
	call	_line_erase		;...


	call	_crlf
	inc	si			; Increment counter
	cmp	si,maxlines		; Is its the
	jc	dfp_lp1			;  of the screen?
dfp_ret:xor	si,si			; Else clear counter
	call	dfp_prm			; And wait for next page
	mov	ax,es:Next_Avail_Num
	cmp	cx,ax
	jc	dfp_lp0
	mov	cx,ax
	dec	cx
	jmp	dfp_lp0

;---------------- End of page, prompt user for input
dfp_prm:mov	bx,offset Edlscroll_Msg
	call	_comsg
	call	_line_erase
	call	_clear_eop
dfp_agn:call	keywait
	call	_Break_check
	jz	dfp_pop			; Exit on Break
	cmp	ax,offset Enter_xcmd	; Next screen?
	jz	dfp_prr
	cmp	ax,offset Pagedn_key
	jz	dfp_prr
	cmp	ax,offset Bins_xcmd
	jz	dfp_swp
;----------------
	cmp	ax,offset Home_key	; Top of EDL?
	jnz	dfp_pr1
	xor	cx,cx
dfp_prr:ret

dfp_swp:call	binswitch
	call	_check4edl
	jz	dfp_prr

	mov	ax,es:Page_Position
	or	ax,ax
	jnz	dfpswp1
	mov	ax,es:Current_Event
	mov	es:Page_Position,ax
dfpswp1:mov	cx,ax
	xor	si,si
	ret

;----------------
dfp_pr1:cmp	ax,offset End_key	; End of EDL?
	jnz	dfp_pr2
	mov	cx,maxlines + 1
	mov	ax,es:Next_Avail_Num	; Get end of EDL + 1
dfp_pl1:dec	ax
	jz	dfp_pl2
	loop	dfp_pl1
dfp_pl2:mov	cx,ax
	ret
	
;----------------
dfp_pr2:cmp	ax,offset Scnxt_xcmd	; Down a line?
	jnz	dfp_pr3
	mov	cx,Last_Evnum
dfp_prz:inc	cx
	ret

;----------------
dfp_pr3:cmp	ax,offset Sclst_xcmd	; Up a line?
	jnz	dfp_pr4
	mov	cx,Last_Evnum
	dec	cx
	js	dfp_prz
	ret

;----------------
dfp_pr4:cmp	ax,offset Pageup_key
	jnz	dfp_agn

	mov	cx,maxlines
	mov	ax,Last_Evnum
	or	ax,ax
	jz	dfp_pl4
dfp_pl3:dec	ax
	jz	dfp_pl4
	loop	dfp_pl3
dfp_pl4:mov	cx,ax
	ret

dfp_pop:pop	bx
	pop	es:Mode_Pntr
	pop	ax
	call	_index_storage
	jmp	screen_init
page_file	endp

;================================================================
;	 Display time code number.
;      Do NOT display leading zeros.
;================================================================
; ENTER: BX = pointer to time code value
;	 CL = FCM type
tc_disp_FAR	proc	far
	call	tc_disp
	ret
tc_disp_FAR	endp

	even
tc_disp	proc	near
	mov	dx,offset Tcdispbuf
	call	_cnvt2tc_DS
	cmp	cl,DF_CHAR
	jnz	tcprty0
tc_disp	endp

tcprtty	proc	near
	cmp	Frame_Flag,0ffh		;Time code pretty print
	jz	tcprty0
	mov	byte ptr 8[bx],';'
tcprtty	endp

	even
tcprty0	proc	near
	mov	al,[bx]
	or	al,al
	jz	tcprtyr
	cmp	al,'0'
	jz	tcprty1
	cmp	al,':'
	jz	tcprty1
	cmp	al,';'
	jz	tcprty1
	call	_comsg
tcprtyr:ret
tcprty0	endp

tcprty0_FAR	proc	far
	call	tcprty0
	ret
tcprty0_FAR	endp

	even
tcprty1	proc	near
	mov	al,' '
	call	_ConOut
	inc	bx
	jmp	tcprty0
tcprty1	endp

; Display time code at BX in parentheses
tc_parenth	proc	near
	call	_time_value
	jz	tcparx
	call	_Space_Out
	mov	al,'('
	call	_ConOut
	or	cl,cl
	jz	tcpar1
	mov	al,cl
	call	_ConOut
tcpar1:	mov	dx,offset Tcdispbuf
	mov	cl,Rtcf
	call	_cnvt2tc_DS
	call	_comsg
	mov	al,')'
	call	_ConOut
tcparx:	ret
tc_parenth	endp

;----------------------
; REFRESH/INIT SCREEN |
;----------------------
_screen_init_FAR	proc	far
	call	screen_init
	ret
_screen_init_FAR	endp

cancel_request	proc	near
	call	match_RESET
cancel_request	endp
screen_init	proc	near
	push	Videoram
	mov	ax,Screen_Seg
	mov	Videoram,ax

	mov	EDL_Window_Cursor,offset List_Scr

	call	_draw_screen
	call	_draw_machines
	call	all_update

	pop	ax		; Get and resave
	push	ax		;  original screen segment
	push	es
	push	ds
	mov	es,ax
	mov	ax,Screen_Seg
	mov	ds,ax
	xor	si,si
	xor	di,di
	mov	cx,2000
	rep movsw
	pop	ds
	pop	es

	pop	Videoram
	ret
screen_init	endp

all_update	proc	near
	xor	al,al
	mov	Fullscreen_Flag,al
	mov	Diagnostics_Flag,al
	mov	Seconds_Count,0ffh
	call	_Cursor_off
	call	time_date
	call	_file_ttl_upd
	call	_listtype_upd
	call	_upd_getrel
	call	_upd_getscr
	call	Trans_Upd		; Does GPI, too
	call	_const_upd
	call	Print_Upd		; Print Flag
	call	Tag_Upd			; Auto tag Flag
	call	Clean_Upd		; Auto clean Flag
	call	Sort_Upd		; Auto sort Flag
	call	Diskon_Upd
	call	SWenable_Upd		; Switcher on/off
	call	Vlan_Upd

	call	_time_upd
;;	norm_VIDEO FALSE,FALSE
	call	Gpi_Upd
	CALL	Pmc_Upd
	CALL	Spd_Upd
	call	Preread_UPD
	call	ramp_upd

	call	_evnt_dispthis
	cmp	Record_Flag,0ffh	; Leave machines alone
	jz	allupdx			;  If recording
	call	devstat_clr
	mov	al,Current_Machine
	call	Machine_Change
allupdx:ret
all_update	endp

scroll_constback	proc	near
	mov	al,Current_Constant
	or	al,al
	jz	sccnst2
	dec	al
	jmp	sccnst1
sccnst2:mov	al,0fh
	jmp	sccnst1
scroll_constback	endp

scroll_Constants	proc	near
	mov	al,Current_Constant
	inc	al
	cmp	al,10h
	jb	sccnst1
sccnst0:xor	al,al
sccnst1:mov	Current_Constant,al
	call	_const_upd
	ret
scroll_Constants	endp


; Index to a GPI register
; ENTER: AX = gpi# 0 - MAX_GPI_REGISTERS
; Exit:  BX = pointer to 8 byte gpi register
gpi_index	proc	near
	MULTIPLY_BY GPI_length, AX
	mov	bx,ax
	add	bx,offset Gpi0
	ret
gpi_index	endp

;================================================================

	even
space_2_out	proc	near
	call	_Space_Out
	call	_Space_Out
	ret
space_2_out	endp

;================================================================
re_kbd	proc	near
	mov	Cursor,offset Keyboard_Scr
	jmp	kbdispN
re_kbd	endp
norm_kbd	proc	near
	mov	Cursor,offset Keyboard_Scr
	call	_line_erase
kbdispN:norm_VIDEO TRUE,TRUE
	jmp	kbdisp
norm_kbd	endp

kbdisp_FAR	proc	far
	call	kbdisp
	ret
kbdisp_FAR	endp

kbdisp	proc	near
	push	bx
	mov	bx,offset Keyboard_Msg
	call	_comsg
	pop	bx
	ret
kbdisp	endp

trim_init	proc	near
	call	norm_kbd		; Ready screen for input
	mov	Cursor,offset Msg_Area	; Pnd position on screen
	call	_comsg
	ret
trim_init	endp

; Blink message in BX
blmsg	proc	near
	blink_VIDEO TRUE,TRUE
blmsg	endp

kbd_msgs	proc	near
	mov	Cursor,offset Msg_Area	; Pnd position on screen
	call	_comsg		; Print it, return
	ret
kbd_msgs	endp

kbd_msgread	proc	near
	mov	Cursor,offset Msg_Area
	call	_msgread
	ret
kbd_msgread	endp

emset	proc	near
	mov	Cursor,offset Editmode_Scr
	mov	bx,Edmsg
	rev_VIDEO FALSE,FALSE
	call	_comsg			; Display function
	norm_VIDEO FALSE,FALSE
	ret
emset	endp



time_date	proc	near
	test	Sounddisplay_Flags,timedate_SDBIT ; Check for Flag
	jz	timdax			; Exit if not on
	mov	ah,2			; Get the time
	int	1ah
	cmp	dh,Seconds_Count	; Compare seconds
	mov	Seconds_Count,dh
	jz	timdax

	mov	bx,offset Screen_Buffer	; Setup pointer for
	mov	Temp_Tc_Buf,bx		;  ASCII decimal bytes
	push	bx			; Save pointer for a later display
	mov	Cursor,0		; Set to upper left
	call	timestamp		; Get the time
	pop	bx			; Restore the pointer
	dim_VIDEO FALSE,FALSE
	call	_comsg			; Display to screen
	call	space_2_out
timdax:	ret
time_date	endp

timestamp_FAR	proc	far
	call	timestamp
	ret
timestamp_FAR	endp

;================================================================
; Temp_Tc_Buf must already setup to be a buffer pointer
timestamp	proc	near
	mov	ah,2ch
	int	DOS
	xor	bh,bh
	mov	bl,ch
	or	bl,bl
	jnz	timstp0
	mov	bl,12		; Special case: Midnight
	stc			; Make C=1
	jmp	timstp1

timstp0:cmp	bl,12
	jz	timstp1
	cmp	bl,13
	jb	timstp1
	sub	bl,12
timstp1:pushf			;Save Flag for AM/PM
	call	_make_dec		; Hour
	mov	al,':'
	call	_add_store
	xor	bh,bh
	mov	bl,cl
	call	_decpadt		; Minute
	popf

	mov	al,'a'
	jb	timstp2
	mov	al,'p'
timstp2:call	_add_store
	mov	al,'m'
	call	_add_store
	mov	al,' '
	call	_add_store
	mov	ah,2ah		; Get date
	int	DOS
	mov	bl,dh		; Get month
	call	timslsh
	mov	bl,dl		; Get day
	call	timslsh
	mov	bx,cx
	cmp	bx,1980
	jae	timstp3
	mov	al,'?'
	call	_add_store
	call	_add_store
	jmp	timstpx
timstp3:sub	bx,1900
	call	_make_dec
timstpx:xor	al,al
	call	_add_store		; Terminate line
	ret

timslsh:xor	bh,bh
	call	_make_dec
	mov	al,'/'
	call	_add_store
	ret
timestamp	endp


active_machines_FAR	proc	far
	call	_active_machines
	ret
active_machines_FAR	endp

_TEXT	ends

_DATA	segment word public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
