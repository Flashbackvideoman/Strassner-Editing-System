; Last revised: 2-22-1995, 11:12:27   (C)1989-1995 Norman H. Strassner

;VMFILES.ASM
; Link file for VM.ASM
; 1	EDL	edl file
; 2	EIF	defaults file
; 3	TCM	macro file
; 4	VME	video Memory effects

%nolist
include	VM.EQU
%nolist

extrn Edl_Fcm:byte,Frame_Flag:byte,Last_Fcm:byte,Loadxfr_Flags:byte
extrn Port_IO_Flag:byte,Readline_Length:byte,Rtcf:byte

extrn Ascii_Line:word
extrn DTA:word,As_Msg:word,Current_Event:word,Current_Event_Adr:word
extrn Cursor:word,Dirchoice:word,Edl_Formats:word,Edl_Msg:word
extrn Events_Iod:word,Fcb:word,File_Msg:word,File_Title:word,Last_Evnum:word
extrn Max_Lines:word,Mode_Pntr:word,Next_Avail_Num:word,Space_Msg:word
extrn Temp_Event:word,Temp_Wrkspce:word,Time_Start:word,write_ovr:word
extrn Xterm_Pntr:word

extrn INSTL60:near,cimsg_add:near,cimsg_wrk:near
extrn clear_event_list:near,cstat:near,dec_cimsg:near,init_w2d:near
extrn keythru:near,match_RESET:near,no_chos_msg:near,pos_yn_chos:near
extrn position_query:near,rcvlin:near,rdchar:near,read_ovr:near
extrn redit_rdy:near,yn_chos:near

extrn _ConOut:FAR,_DecOut:far,_e_rel_l:far
extrn _MsgCntr:FAR,_RqstNewRvtFCM:far,_adv2chr:FAR,_adv2spc:FAR,_advance:FAR
extrn _blank_screen:FAR,_Break_check:FAR,_cknum:FAR,_clear_screen:FAR
extrn _cntrtxt:FAR,_cnvt2mp_DS:far,_cnvt2mp_ES:far,_cnvt2tc_DS:far,_comsg:FAR
extrn _convert2bin:far,_crlf:FAR,_cstat_FAR:FAR,_dec1000_pad:far
extrn _dircur_lerase:FAR,_error_bell:FAR,_event_display:far,_evnum:far
extrn _fcmset:far,_file_ttl_upd:far,_force_fcm:far,_help_pos:FAR,_kbd_cln:FAR
extrn _kbd_clr:FAR,_listtype_upd:far,_mmv:far,_motion_convert:FAR
extrn _msgread:far,_screen_init_FAR:FAR,_time_value:far,cimsg_wrk_FAR:far
extrn Keyboard:far,position_query_FAR:FAR,rdchar_FAR:FAR,yn_chos_FAR:far


extrn _Check_4_fcm:far,_Check_4_format:far,_Check_4_gpi:far
extrn _Check_4_pmc:far,_Check_4_rec:far,_Check_4_slave:far
extrn _Check_4_spd:far,_Check_4_spl:far,_Check_4_starts:far
extrn _Check_4_title:far,_Check_4_tstamp:far,_EMEM_load:far
extrn _EMEM_save:far,_ReadEvent:far,_Room4Line:far,_context_help:far
extrn _gpi_xlate:far,_kbdlayout:far,_load_file:far,_pmc_xlate:far
extrn _re_cmt:far,_read_line:far,_read_pointer:far,_rec_xlate:far
extrn _save_file:far,_setdflts_file:far,_shell2cct:far,_shell2dir:far
extrn _shell2dos:far,_shell2olm:far,_shell2switcher:far,_showdir:far
extrn _slave_xlate:far,_spd_xlate:far,_title_file:far,_title_loop_ES:far
extrn _Check_4_ramp:far,_ramp_xlate:far,_Check_4_preread:far,_preread_xlate:far

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

Public  EMEM_load, EMEM_save, title_file, setdflts_file, save_file, load_file
Public  showdir, shell2dos, shell2olm, shell2dir, context_help, shell2switcher
Public  shell2cct, keylayout, loadxfr_FAR, loadxfr, ReadEdlFileLoop, LxfrRnd
Public  Lxfr1, Lxfr2, Lxfr3, Lxfr3a, Lxfr3b, Lxfr3c, Lxfr4, Lxfr4a, Lxfr4b
Public  Lxfr5, Lxfr6, Lxfr7, Lxfr8, Lxfr8a, Lxfr8x, LxfrX1, LxfrX2, line_xlate
Public  lxl_0a, lxl_1, lxl_1a, lxl_1b, lxl_1c, lxl_1d, lxl_2, lxl_3, lxl_4
Public  lxl_5, readelp, readev1, readev2, readevx, ReceiveLine, rcv_old, rcvo1
Public  rcvret, listtype_parse, ltyprs0, ltyprs1, ltyprs2, ltyprsn, ltyprs3
Public  ltyprs4, ltypr2k

%list

EMEM_load:
	call	_EMEM_load
	ret
EMEM_save:
	call	_EMEM_save
	ret
title_file:
	call	_title_file
	ret
setdflts_file:
	call	_setdflts_file
	ret
save_file:
	call	_save_file
	ret
load_file:
	call	_load_file
	ret
showdir:
	call	_showdir
	ret
shell2dos:
	call	_shell2dos
	ret
shell2olm:
	call	_shell2olm
	ret
shell2dir:
	call	_shell2dir
	ret
context_help:
	call	_context_help
	ret
shell2switcher:
	call	_shell2switcher
	ret
shell2cct:
	call	_shell2cct
	ret

;================================================================
;		SUCCESSIVE HELP MENUES
;================================================================
keylayout	proc	near
	call	_kbdlayout
	ret
keylayout	endp


;================================================================
;		LOAD EDL FILE SUBROUTINE
;================================================================
; Read line logic:
;
; READ LINE UNTIL LINE STARTS WITH A NUMBER
; CHECK FOR:
; 	TITLE:
; 	[FCM:] 1st is for RECORD FCM
; 	FORMAT:
; 	STARTS:
; 	UPDATED:
; 	[FCM] 2nd is for FIRST SOURCE FCM
;
loadxfr_FAR	proc	far
	call	loadxfr
	ret
loadxfr_FAR	endp

loadxfr	proc	near
	xor	al,al
	mov	Port_IO_Flag,al		; Indicate file IO
	mov	Loadxfr_Flags,al	;
	call	clear_event_list
	mov	Events_Iod,0		; Events "I/O" counter
	mov	al,Rtcf			; Normalize to
	mov	Last_Fcm,al		;  record time code format
	mov	es:Edl_Fcm,al		;  for entire EDL

; Check to see if there is room for any more edits
	mov	bx,offset Next_Avail_Num
	mov	ax,es:[bx]
	mov	Temp_Event,ax
	cmp	ax,es:Max_Lines
	jb	ReadEdlFileLoop
	ERROR	out_of_memory, ERET_Keyboard
loadxfr	endp

;----------------------------------------------------------------
;	GET ALL EDL COMMENTS FROM TOP OF FILE
ReadEdlFileLoop	proc	near
	call	_read_line	; Get first line of file
	jc	LxfrRnd
	or	al,al			; Null line?
	jnz	Lxfr1
LxfrRnd:ret

Lxfr1:	or	ch,ch
	jz	ReadEdlFileLoop
	call	_advance	; Get first character
	cmp	al,cr			; Skip blank lines
	jz	ReadEdlFileLoop
	cmp	al,'*'			; Leading asterisk?
	jnz	Lxfr2
	inc	bx			; Skip over "*"
	dec	ch
	call	_advance	; Get next non-space
	or	ch,ch			; Was that it?
	jz	ReadEdlFileLoop		; Try, try again.

; Check for valid "TITLE:"
Lxfr2:	test	byte ptr Loadxfr_Flags,LoadBit_title ;Signal title loaded
	jnz	Lxfr3
	call	_Check_4_title
	jnz	Lxfr3
	add	bx,6
	mov	ch,Readline_Length
	sub	ch,4			; Leave 2 extra for CRLF
	call	_advance
	mov	dx,offset File_Title + ttlfmt_length
	call	_title_loop_ES
	call	_file_ttl_upd		; Display EDL title
	or	byte ptr Loadxfr_Flags,LoadBit_title ;Signal title loaded
	jmp	ReadEdlFileLoop

; Check for FCM:
Lxfr3:	call	_Check_4_fcm
	jnz	Lxfr4

	if NTSC
	cmp	al,DF_CHAR		; Save record FCM at Rtcf
	jz	Lxfr3a
	cmp	al,NDF_CHAR
	jz	Lxfr3a
	call	_RqstNewRvtFCM
	else
	mov	al,' '
	ENDIF

Lxfr3a:	test	byte ptr Loadxfr_Flags,LoadBit_FCM ; Have FCM?
	jnz	Lxfr3b
	mov	es:Edl_Fcm,al		; Set EDL FCM

; To fix TurboTrace CMX340 Bug:
	mov	Last_Fcm,al		; Set default SOURCE FCM

	or	byte ptr Loadxfr_Flags,LoadBit_FCM ; Have FCM
	jmp	Lxfr3c
Lxfr3b:	mov	Last_Fcm,al
Lxfr3c:	call	_fcmset			; Set and update screen
	jmp	ReadEdlFileLoop

; Check for FORMAT:
Lxfr4:	test	byte ptr Loadxfr_Flags,LoadBit_format
	jnz	Lxfr5
	call	_Check_4_format		; Check for FORMAT:
	jnz	Lxfr5
	call	_adv2spc
	call	_advance
	mov	si,bx
	mov	bx,offset Temp_Wrkspce
Lxfr4a:	lodsb
	cmp	al,cr
	jz	Lxfr4b
	mov	[bx],al
	inc	bx
	jmps	Lxfr4a
Lxfr4b:	mov	byte ptr [bx],0		; Terminate and get
	dec	bx			;  rid of trailing blanks
	cmp	byte ptr [bx],' '
	jz	Lxfr4b
	call	listtype_parse
	or	byte ptr Loadxfr_Flags,LoadBit_format
	jmp	ReadEdlFileLoop

; Try to get STARTS:
Lxfr5:	test	byte ptr Loadxfr_Flags,LoadBit_starts ; Starts loaded?
	jnz	Lxfr6
	call	_Check_4_starts		; Check for STARTS: line
	jnz	Lxfr6
	call	_adv2spc
	call	_advance
	mov	dx,offset Time_Start
	mov	cl,es:Edl_Fcm
	call	_cnvt2mp_DS
	or	byte ptr Loadxfr_Flags,LoadBit_starts
	jmp	ReadEdlFileLoop

; Look for UPDATE: line
Lxfr6:	test	byte ptr Loadxfr_Flags,LoadBit_update ; Starts loaded?
	jnz	Lxfr7
	call	_Check_4_tstamp
	jnz	Lxfr7
	or	byte ptr Loadxfr_Flags,LoadBit_update
	jmp	ReadEdlFileLoop

; Fix to eliminate top split lines
Lxfr7:	call	_Check_4_spl		; Check for a split_line
	jnz	Lxfr8
	jmp	ReadEdlFileLoop

Lxfr8:	mov	al,[bx]			; Check for an EDIT
	cmp	al,'0'			;  which is the only line
	jc	Lxfr8a			;  allowed to start with
	cmp	al,'9'+1		;  a decimal number
	jc	LxfrX1

; No other type of line found, check for title, use it if no title
Lxfr8a:	test	byte ptr Loadxfr_Flags,LoadBit_title ; Title already loaded?
	jnz	Lxfr8x
	mov	ch,Readline_Length
	mov	dx,offset File_Title + ttlfmt_length
	call	_title_loop_ES
	call	_file_ttl_upd		; Display EDL title
	or	byte ptr Loadxfr_Flags,LoadBit_title ;Signal title loaded
	jmp	ReadEdlFileLoop
Lxfr8x:	call	_Room4Line
	call	_re_cmt
	inc	es:Next_Avail_Num
	jmp	ReadEdlFileLoop

LxfrX1:	test	byte ptr Loadxfr_Flags,LoadBit_format ; Any list type found?
	jnz	LxfrX2
	call	INSTL60
LxfrX2:	mov	Last_Evnum,0ffffh	; Set highest possible number
	call	_read_pointer
	mov	ch,Readline_Length

line_xlate:
	call	_Room4Line
	cmp	byte ptr [bx],cr	; Null line?
	JMP_Z	readev1
	mov	al,Frame_Flag
	push	ax
	mov	Frame_Flag,0

	call	_ReadEvent		; Else make an edit line

	pop	ax
	mov	Frame_Flag,al
	JMP_NC	lxl_2			; Proccess if not comment

	call	_Check_4_spl		; Check for a split_line
	JMP_Z	readev1
	call	_Check_4_fcm		; Check for change in FCM
	jnz	lxl_0a
	IF NTSC
	mov	Last_Fcm,al		; Save new TCF
	ELSE
	mov	Last_Fcm,' '		; Save new TCF
	ENDIF
	jmp	readev1			; Carry set if FCM line, get another

lxl_0a:	call	_Check_4_gpi		; Check for a GPI trigger
	jnz	lxl_1
	call	_gpi_xlate
	jmp	readelp			; Inc counts and continue
lxl_1:	call	_Check_4_slave
	jnz	lxl_1a
	call	_slave_xlate
	jmp	readelp			; Inc counts and continue
lxl_1a:	call	_Check_4_spd
	jnz	lxl_1b
	call	_spd_xlate
	jmp	readelp			; Inc counts and continue
lxl_1b:	call	_Check_4_pmc
	jnz	lxl_1c
	call	_pmc_xlate
	jmp	readelp			; Inc counts and continue
lxl_1c:	call	_Check_4_rec
	jnz	lxl_1d
	call	_rec_xlate
	jmp	readelp			; Inc counts and continue
lxl_1d:	call	_Check_4_ramp
	jnz	lxl_1e
	call	_ramp_xlate
	jmp	readelp			; Inc counts and continue
lxl_1e:	call	_Check_4_preread
	jnz	lxl_1f
	call	_preread_xlate
	jmp	readelp
lxl_1f:	call	_re_cmt			; Save comment
	jmp	readelp			; Inc counts and continue


; Check to see if this event number matches the previous event number
; If they do, set it up as a double line event
lxl_2:	mov	bx,offset Temp_Wrkspce
	call	_convert2bin		; Return with # in AX
	cmp	ax,Last_Evnum
	mov	Last_Evnum,ax
	jnz	readelp

; Event numbers match.  Check for double line event
	mov	di,Current_Event_Adr
	mov	bx,di
	sub	di,line_length
	mov	dx,di
	cmp	es:byte ptr [di].cmnt_lofst,Editline_EDIT; Is prev. evnt and edit?
	jnz	readelp
	or	es:word ptr [di].Flags_lofst,dblline_Fmask ;Set dbl line Flag
	cmp	es:byte ptr [bx].type_lofst,'C'
	jnz	readelp

; Possible split line, or possible repeat numbered event
; Check for split.
; If modes are the same, its no split
lxl_3:	mov	al,es:[di].mode_lofst	; Get previous mode
	cmp	al,es:[bx].mode_lofst	; Compare to current mode
	jz	lxl_5

; (If reels are different, its no split either)
	call	_e_rel_l	; Get reel length to AL
	cbw
	mov	cx,ax
	or	cx,cx
lxl_4:	mov	al,es:[di].reel_lofst	; Get previous reel byte
	cmp	al,es:[bx].reel_lofst
	jnz	lxl_5
	inc	di
	inc	bx
	loop	lxl_4

; Passes all tests, SET SPLIT Flag
	mov	bx,Current_Event_Adr
	or	es:word ptr [bx].Flags_lofst,split_Fmask ;Set current SPLIT Flag
	jmp	readelp

; Failed a test for SPLIT edit, reset dblline_Fmask in previous line
lxl_5:	mov	bx,dx
	and	es:word ptr [bx].Flags_lofst,not dblline_Fmask

readelp:inc	es:Next_Avail_Num
	cmp	Port_IO_Flag,0ffh
	jnz	readev1
	mov	bx,Xterm_Pntr
	cmp	byte ptr [bx],0
	jnz	readev1
	dec	ax
	call	_event_display

;================================================================
;Read the events in to Memory
; Loop for all file lines...
readev1:cmp	Port_IO_Flag,0ffh	; Port IO?
	jnz	readev2
	call	redit_rdy
	call	ReceiveLine
	jc	readevx
	jmp	line_xlate		; If EOF, C=1
readev2:call	_read_line	; Get a line from the file
	jc	readevx
	or	al,al
	JMP_NZ	line_xlate
	stc
readevx:ret

ReadEdlFileLoop	endp

;================================================================
; Pull a line out of the Ascii_Line, or read a new one 
ReceiveLine	proc	near
	mov	bx,Xterm_Pntr
	mov	al,[bx]
	or	al,al			; None left?
	jnz	rcv_old
	mov	bx,offset Ascii_Line	; Check for more
	mov	Xterm_Pntr,bx
	mov	Last_Evnum,0ffffh
	push	bx
	call	rcvlin
	pop	bx
	jc	rcvret
rcv_old:push	si
	mov	si,offset Temp_Wrkspce
	push	si
rcvo1:	mov	al,[bx]
	mov	[si],al
	inc	bx
	inc	si
	cmp	al,lf
	jnz	rcvo1
	mov	Xterm_Pntr,bx
	pop	bx
	pop	si
rcvret:	ret
ReceiveLine	endp


;----------------------------------------------------------------
; Determines list type from line in Temp_Wrkspce
listtype_parse	proc	near
	mov	dx,offset Edl_Formats	; Start of format tables
	xor	cl,cl			; Clear a counter
ltyprs0:push	dx			; Save Mode_Pntr
	add	dx,offset ZeroBase.E_edl_Name	; Index DX to format Name string
	mov	bx,offset Temp_Wrkspce
ltyprs1:xchg	bx,dx
	mov	al,[bx]			; Get a byte from the table
	xchg	bx,dx
	cmp	al,[bx]			; Does it match temp_wrkspc?
	jnz	ltyprs2
	or	al,al			; Check for matching null terminators
	jz	ltyprs3			; Found it
	inc	bx
	inc	dx
	jmps	ltyprs1

;If no match, check next edl format type...
ltyprs2:pop	dx			; Restore original mode pointer
	xchg	bx,dx
	add	bx,edlfmt_hdrlen	; Index to the next table
	mov	ax,[bx]			; Mmmmm.  if its the
	xchg	bx,dx
	inc	ax			; End of the list, MAJOR PROBLEM
	jnz	ltyprs0			; Continue until end of list
ltyprsn:call	INSTL60			; Go to the error routines

ltyprs3:pop	bx			; Restore the mode pointer
	mov	es:Mode_Pntr,bx		; And make it current
	call	_listtype_upd		; And show the Name
	or	byte ptr Loadxfr_Flags,00000010b ; List type found
	mov	bx,offset read_ovr
	call	_kbd_cln
	call	_msgread

	mov	bx,offset As_Msg
	call	_comsg
	mov	bx,es:Mode_Pntr
	add	bx,offset ZeroBase.E_edl_Name
	call	_adv2chr
	call	_comsg
	mov	bx,offset Edl_Msg
	call	_comsg
	mov	al,'?'
	call	_ConOut
	mov	cl,'Y'
	call	yn_chos
	jc	ltypr2k
	jz	ltyprs4
	call	INSTL60
ltyprs4:call	_read_pointer
	ret

ltypr2k:mov	ERROR_ACTIVE,0		; Clear error Flags
	jmp	Keyboard

listtype_parse	endp


_TEXT	ends
;================================================================
;================================================================
;================================================================

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

