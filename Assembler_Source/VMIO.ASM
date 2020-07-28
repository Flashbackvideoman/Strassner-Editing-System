; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner

; VMIO.ASM
;
%nolist
	include	vm.equ
%list
extrn INIvln_ovr:word,INIjog_ovr:word,INIxpt_ovr:word
extrn Split_Vid_Msg:word,Split_Aud_Msg:word
extrn COM_PREVIEW:word,PX_Switcher_Types:word,PX_Type:byte,PX_Address:word

extrn AX_Type:byte,Device_Enabled:byte,EFX_Flag:byte,JogCmdAvailable:byte
extrn JoggerActive:byte,JoggerIteration:byte,JoggerModeChange:byte
extrn JoggerShiftKey:byte,JoggerWheelMode:byte,SX_Type:byte
extrn ShuttleIteration:byte,ShuttleSensitivity:byte,Active_IOTYP:byte
extrn Current_Source:byte,Device_Present:byte,Fullscreen_Flag:byte
extrn Joybuttons:byte,Joybuttons:byte,Last_Fcm:byte,Last_Stickx:byte
extrn Last_Stickx:byte,Papertape_Flag:byte,Port_IO_Flag:byte
extrn COM_PRINTER:byte

extrn Ascii_Line:word,AX_Switcher_Types:WORD
extrn AX_Address:word,COM_AUDIOSW:word,AutoConfig_ovr:word
extrn JoggerCommand:word,COM_SES1010:word
extrn SX_Switcher_Types:WORD,SX_Address:word,COM_VIDEOSW:word
extrn VLAN_Flags:word,_Save_File_Msg:word
extrn clear_list_ovr:word,xterm_address:word
extrn COM_EDLIO:word,COM_VLAN:word,COM_XTERM:word
extrn Current_Event:word,Current_Event_Adr:word,Cursor:word,Data_Seg:word
extrn Ev2ret2:word,Event_Storage:word,File_Title:word,illegal_ovr:word
extrn Jogger_Address:word,JoggerIRQ:word,Joykey1:word,Joykey2:word
extrn Jstickx_Table:word,Last_Evnum:word,Max_Lines:word,Mode_Pntr:word
extrn Network_Flags:word,Next_Avail_Num:word,pointer_ovr:word,Port:word
extrn Port_Addresses:word,portbreak_ovr:word
extrn punchfile_ovr:word,punching_ovr:word,rdrfile_ovr:word,rdrrdy_ovr:word
extrn rdy_ovr:word,redit_ovr:word,redl_ovr:word,serial_ovr:word
extrn Temp_Event:word,Type_Header:word,Vlan_Ver:word,xterm_ovr:word
extrn Xterm_Pntr:word,SavedReceived_ovr:word, Baud_Table:word

extrn KeyCommand_main:near,GetVlanEmemRegs:near,HighResShuttle:near
extrn SW_allstop:near,SWjoystick:near,SetVlanEfxAddress:near
extrn VLAN_allstop:near,VSS_fwd:near,VSS_rev:near,VTR_Reset:near
extrn cstat:near,get_appltype:near,kbd_msgread:near
extrn Machine_Change:near,no_chos_msg:near,note:near,rdchar:near,scan:near
extrn still:near,switch:near,sync2rec:near,vtr_answer:near,vtr_e2e:near
extrn vtr_sendcmd:near,yn_chos:near,vtr_nul:near

extrn _ConOut:FAR,_Cursor_On:far,_EDL2ASCII:far,_evnt_dispthis:far
extrn _E_flgs:far,_backspace:far,_baderror_bell:FAR,_Break_check:FAR
extrn _check4edl:far,_clear_list:far,_clear_screen:FAR, _delsec:far
extrn _convert2bin:far,_crlf:FAR,_delbrk:FAR,_delfld:far,_delfrm:FAR
extrn _delhnd:FAR,_delms:far,_deltick:far,_dhb:far,_dhw:far,_edl_read:far
extrn _edl_write:far,_error_bell:FAR,_event_display:far,_evnum:far
extrn _force_fcm:far,_help_pos:FAR,_index_storage:far,_kbd_cln:FAR
extrn _kbd_clr:FAR,_kbd_message:far,_Keyboard_caps:far,_line_erase:FAR
extrn _macone:far,_make_ucase:far,_mmv:far,_msgread:far,_save_file:far
extrn _wrt_fcm:far,_wrt_split:far,Keyboard:far,rdchar_far:FAR
extrn _switcher_set:far,_switcher_set:far,_GetSXcb_SMPTEadr:far
extrn _GetSXcb_SMPTEadr:far,_all_switcher_set:far,_ResetInterrupt_JOGGER:far
extrn _SetInterrupt_JOGGER:far,_switcher_set:far,_GetSXcb_Flags:far
extrn _GetSXcb_SMPTEadr:far,_check4joystick:far,_GetSXcb_Flags:far
extrn _GetSXcb_SMPTEadr:far,_jstick:far,_joy_convert:far,_jbutton:far
extrn _Space_Out:far,_comsg:far

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg


Public  AutoConfigure, AC_lp, AC_tryagain, AC_outofports, FindVlanSwitcher
Public  FVS_2, FVS_3, Jogger_far, Jogger, JoggerCheckAgain, jcmdok, jl_rev
Public  joggerkeys, jk1, jk2, jk3, jk4, jk5, jk6, jk7, jkshifted, jks2, jks3
Public  jks4, jks5, jks6, jks7, jogkeycommand, jogcommand, shuttlecommand
Public  shco1, jogret, CheckShuttleIteration, csix, _Jogger_INTERRUPT, jirq
Public  GetJoggerData, ji_nca, ji_secondchar, ji_Exit, receive, rcvpok, rcvlok
Public  rcvagn, rcvx, send, send_1, pfpok, sendxit, punch_file, pnchfl1
Public  pf_loop, pnchhdr, pnchtrm, pnchxit, transmit, transone, tranagn, tranm1
Public  xmitx, xmitr, pnch_event, pnlin1, pnlin2, pnlin3, pnlin5, pnch_til_null
Public  pnch_line_ES, pnch_crlf, pnchret, punch_command, punch_mdmout, pmdm_1
Public  pmdm_2, pnchmq, pnchmox, rcvchar, rcvchr0, rcvchr1, rvcto, rcvlin
Public  rcvlin1, rcvxt, rcv1, rcv2, rcv1a, rcvnxt, rcvnxt0, rcvnxt1, rcvnxt2
Public  rcvcmt, redit_rdy, redl_rdy, r_rdy, read, read_1, edlxfr2, read_2
Public  read_3, rcvlin_ES, rcvlin1_ES, rcv1_ES, rcvnxt_ES, rcvnxt1_ES, rcvnxto
Public  edlxwrt, edldrain, edlxwr0, edlxwr1, Port_unassigned, xterm, xtrmagn
Public  sndlp1, sndlpb, sndlpc, sndlpr, snddhw, sndlp2, sndlpes, sndlp3
Public  sndlp3a, sndlp3b, sndlpp, sndlp3c, sndlp3d, sndlp4d, sndlp5d, sndlp6d
Public  sndlp7d, sndlp8d, sndlp9d, sndout, sndout1, sndbk, vtr_inst, joginst
Public  vtrinstx, axptinit, vxptinit, swrini1, swrint_VLANsw, VLANswtchr_ok
Public  swrini2, xptinir, xptinix, VLAN_init, netnofnd, vlan_ID, tryid, tryid1
Public  getid, getidx, mdminst, saveportadr, mdminlp, mdmibad, mdminit, badinit
Public  mdmintinit, RS232_line_status, linst2, linstx, RS232_mdm_status, mdmst2
Public  mdmstx, mdmin, mdmixt, mdmout, mdmolp, mdmog, mdmox, PortIO_GetAddr
Public  PIOgax, PIOgar, SX_select, sxsel2, sxsel3, sxsel5, sxsel4, sxselx
Public  sragn, srm, srmx, send_Break, Port_Break, pb2, pb3, pb4, pb5, pb6, pb7
Public  pb8, pb9, pb10, pb11, pb12, pbc, lst_co, lst_init, lstinig, lstini1
Public  lst_io, lst_pio, lststx, joystick_far, joyret, joystick, joych0, joych1
Public  joy_y, joy_y1, joybut, joybut1, joybut2, joybut3, joykeys, joybutx

;; Attempt to auto-configure for VLAN com Port
; Return Carry=1 if VLAN cannot be found
AutoConfigure	proc	near
	call	_kbd_cln
	mov	bx,offset AutoConfig_ovr
	call	_msgread

	mov	Active_IOTYP,vlan_IOTYP
	mov	cx,0007h		; Start with 9600 baud
AC_lp:	push	cx

	call	_Break_check			; Exit if Break
	jz	AC_outofports

	mov	bx,offset COM_VLAN
	mov	si,offset Baud_Table
	mov	ax,8 ; size of a baud_table entry
	mul	cx
	add	si,ax
	mov	ax,[si]
	mov	[bx].cpBAUD,ax
	mov	ax,bx
	call	mdminit
	jc	AC_outofports
	call	saveportadr

	call	vtr_nul
	call	vtr_nul

	call	vlan_ID
	jc	AC_tryagain
	; Vlan found
	call	FindVlanSwitcher
	pop	cx
	mov	cx,COM_VLAN.cpBAUD
	mov	COM_XTERM.cpBAUD,cx
	clc
	ret

AC_tryagain:
	pop	cx
	inc	cx
	cmp	cx,10
	jb	AC_lp
	push	cx
AC_outofports:
	pop	cx
	stc
	ret

AutoConfigure	endp


FindVlanSwitcher	proc	near
	mov	ax,offset SX_Switcher_Types - 1
	mov	SX_Type, al
	call	_switcher_set
	call	vxptinit		; Initiate switcher
	test	Device_Present,	video_IOTYP
	jnz	FVS_2
	mov	SX_Type, 0

FVS_2:	mov	ax, offset AX_Switcher_Types - 1
	mov	AX_Type, al
	call	_switcher_set
	call	axptinit		; Initiate audio switcher
	test	Device_Present,	audio_IOTYP
	jnz	FVS_3
	mov	AX_Type, 0

FVS_3:	mov	ax, offset PX_Switcher_Types - 1
	mov	PX_Type, al
	call	_switcher_set
	call	pxptinit		; Initiate preview switcher
	test	Device_Present,	preview_IOTYP
	jnz	FVS_4
	mov	PX_Type, 0

FVS_4:	ret
FindVlanSwitcher	endp

;================================================================
;================================================================
;			JOGGER ROUTINES
;================================================================
;================================================================
Jogger_far	proc	far
	call	Jogger
	ret
Jogger_far	endp

Jogger	proc
	test	Network_Flags,Jogger_NTBIT
	JMP_Z	jogret

; Get current command (if any) and the # of bytes read
JoggerCheckAgain:
	cli
	mov	bx,JoggerCommand	; Jogger bytes (2)
	mov	cl,JogCmdAvailable	; Number of jogger bytes read
	sti
	cmp	cl,1
	jz	JoggerCheckAgain

	or	cl,cl			; If there is a pending command
	jnz	jcmdok			;  Go get it

	cmp	JoggerActive, 1		; If jogger is NOT active
	jnz	jcmdok			;  continue

; Check for timing
	cmp	byte ptr JoggerIteration,0
	JMP_NZ	jogret

; TEST FOR JOGGER PREVIOUSLY ACTIVATED. IF IT WAS, STOP VTR.
	xor	ax,ax
	mov	JoggerActive, al
	mov	ch,0
	mov	cl,PLUS_ASCII
	call	HighResShuttle
	jmp	jogret

jcmdok:	cmp	cl,2	; Number of jogger bytes read
	JMP_NZ	jogret

	mov	JogCmdAvailable,0	; Number of jogger bytes read

	; if BL = 80h then its a key, if BL = 81h then its the wheel
	cmp	bl,80h			; Process Keys?
	jz	joggerkeys

	;; if N >= 0x40  then go Forward, else go backward
	cmp	bh,40h
	jb	jl_rev

; Shuttle forward
	mov	cl,PLUS_ASCII
	mov	ch,bh
	neg	ch
	and	ch,7fh
	cmp	JoggerWheelMode,0

; Wheel mode is JOG
	JMP_NZ	jogcommand

; Wheel mode is SHUTTLE
	call	CheckShuttleIteration
	JMP_C	jogret
	mov	ax,offset Srchfwd_xcmd
	jmp	shuttlecommand

jl_rev:	;; Shuttle forward after sensitivity reached
	mov	cl,MINUS_ASCII
	mov	ch,bh
	cmp	JoggerWheelMode,0
; Wheel mode is JOG
	JMP_NZ	jogcommand	; Jog forward after sensitivity reached

; Wheel mode is SHUTTLE
	call	CheckShuttleIteration
	JMP_C	jogret
	mov	ax,offset Srchrev_xcmd
	jmp	shuttlecommand


;................................................................
; Process JOGGER KEYS
joggerkeys:
	cmp	bh,06h		; Shift key up?
	jnz	jk1
	mov	JoggerShiftKey,0

	cmp	JoggerModeChange, 1 ; =0 if any other key hit
	JMP_NZ	jogret

	mov	JoggerModeChange, 0
	mov	al,JoggerWheelMode
	not	al
	mov	JoggerWheelMode, al
	mov	ax,0f0f0h	; Send dummy command
	jmp	jogkeycommand

jk1:	cmp	bh,10h		; Other keys up?
	JMP_C	jogret

	cmp	JoggerShiftKey,1; Shift active?
	jz	jkshifted

; Normal Keys
	cmp	bh,40h		; Mark In
	jnz	jk2
	mov	ax, offset Markin_xcmd
	jmp	jogkeycommand
jk2:	cmp	bh,41h		; Mark Out
	jnz	jk3
	mov	ax, offset Markout_xcmd
	jmp	jogkeycommand
jk3:	cmp	bh,42h		; Scan Back
	jnz	jk4
	mov	ax, offset Shuttleback_xcmd
	jmp	jogkeycommand
jk4:	cmp	bh,43h		; Scan Fwd
	jnz	jk5
	mov	ax, offset Shuttlefwd_xcmd
	jmp	jogkeycommand
jk5:	cmp	bh,44h		; Still
	jnz	jk6
	mov	ax, offset Still_xcmd
	jmp	jogkeycommand
jk6:	cmp	bh,45h		; Play
	jnz	jk7
	mov	ax, offset Play_xcmd
	jmp	jogkeycommand
jk7:	cmp	bh,46h		; Shift
	jnz	jogret
	mov	JoggerShiftKey,1
	mov	JoggerModeChange, 1 ; Indicate switch down, and not up
	ret

; Shifted keys
jkshifted:
	cmp	bh,40h		; Edit
	jnz	jks2
	mov	ax, offset Record_xcmd
	jmp	jogkeycommand
jks2:	cmp	bh,41h		; VVV
	jnz	jks3
	mov	ax, offset Rehearse_xcmd
	jmp	jogkeycommand
jks3:	cmp	bh,42h		; Rewind
	jnz	jks4
	mov	ax, offset Rewind_xcmd
	jmp	jogkeycommand
jks4:	cmp	bh,43h		; Fast Forward
	jnz	jks5
	mov	ax, offset Fastfwd_xcmd
	jmp	jogkeycommand
jks5:	cmp	bh,44h		; Stop
	jnz	jks6
	mov	ax, offset Stop_xcmd
	jmp	jogkeycommand
jks6:	cmp	bh,45h		; Rec/Src Toggle
	jnz	jks7
	mov	ax, offset Rptgl_xcmd

jks7:
jogkeycommand:
	mov	JoggerModeChange, 0 ; =0 if any other key hit
	call	_macone
	ret

; Jogger command
jogcommand:
	call	HighResShuttle
	mov	JoggerActive, 1
	ret

; Shuttle command
shuttlecommand:
	mov	al,ch

	cmp	cl,PLUS_ASCII
	jnz	shco1
	call	VSS_fwd
	ret

shco1:	call	VSS_rev
jogret:	ret
Jogger	endp

CheckShuttleIteration:
	mov	si,offset ShuttleIteration
	inc	byte ptr [si]
	mov	al,[si]
	cmp	al, ShuttleSensitivity
	jc	csix
	mov	byte ptr [si], 0
csix:	ret

;================================================================
; Here is the interrupt routine
; First, find out type of interrupt:
_Jogger_INTERRUPT	PROC	FAR
	push	ax
	push	ds
	mov	al,20h
	mov	ds,cs:Data_Seg
	cmp	JoggerIRQ, 80h
	out	20h,al			; Clear first interrupt controller
	jb	jirq
	out	0A0h,al
jirq:
;;	cli
	call	GetJoggerData
;;	sti
	pop	ds
	pop	ax
	iret
_Jogger_INTERRUPT	ENDP

GetJoggerData	proc	near
	push	dx
	push	si

	test	Network_Flags,Jogger_NTBIT
	jz	ji_Exit

	cmp	byte ptr JogCmdAvailable, 2
	jz	ji_Exit

	mov	dx,Jogger_Address
	add	dx,5
	in	al,dx
	test	al,1
	jz	ji_Exit

	mov	si,offset JogCmdAvailable
	cmp	byte ptr [si], 2	; Check for data in buffer not read
	jnz	ji_nca
	mov	byte ptr [si], 0	; Delete data from unread buffer

ji_nca:	mov	dx,Jogger_Address
	in	al,dx			; Get character
	test	al,80h			; First character?
	jz	ji_secondchar
	mov	byte ptr JoggerCommand, al
	inc	byte ptr [si]		; Number of jogger bytes read
	jmp	ji_Exit

ji_secondchar:
	cmp	byte ptr [si],1
	jnz	ji_Exit
	mov	byte ptr JoggerCommand + 1, al
	inc	byte ptr [si]		; Number of jogger bytes read

ji_Exit:pop	si
	pop	dx
	ret
GetJoggerData	endp


;------------------------------------------------
;	T E R M I N A L   R O U T I N E S
;------------------------------------------------
;================================================================
;		RECEIVE SINGLE EVENT FROM Port
;================================================================
receive:mov	Active_IOTYP,readsend_IOTYP
	mov	ax,offset COM_EDLIO
	call	mdminst
	jnc	rcvpok
	call	Port_unassigned
	ret

rcvpok:	mov	Port_IO_Flag,0ffh

	mov	ax,es:Current_Event	; Save event to return to
	mov	Ev2ret2,ax

	mov	ax,es:Next_Avail_Num
	cmp	ax,es:Max_Lines
	jb	rcvlok
	pop	bx			; Get rid of return
	ERROR	out_of_memory, ERET_Keyboard

rcvlok:	mov	Temp_Event,ax		; Save the merge start
	call	_index_storage		; Index to merge address
	mov	Last_Evnum,0ffffh

rcvagn:	mov	bx,offset Ascii_Line
	mov	byte ptr [bx],0
	mov	Xterm_Pntr,bx
	jc	rcvx
	mov	ax,es:Current_Event	; Save event to return to
	mov	Ev2ret2,ax
	jmp	rcvagn
rcvx:	mov	ax,Ev2ret2
	call	_event_display
	ret


;*****************************
;  Send EDL to list device
;*****************************
send:	call	_check4edl
	jz	sendxit

	mov	bx,offset punchfile_ovr
	call	no_chos_msg
	mov	Papertape_Flag,0ffh
	jz	send_1

	mov	bx,offset serial_ovr
	call	no_chos_msg
	mov	Papertape_Flag,0
	jnz	sendxit

send_1:	call	_kbd_clr
	norm_VIDEO FALSE,FALSE
	mov	bx,offset pointer_ovr
	call	_msgread
	mov	bx,offset punching_ovr
	call	_msgread

	mov	Active_IOTYP,readsend_IOTYP
	mov	ax,offset COM_EDLIO
	call	mdminst
	jnc	pfpok
	call	Port_unassigned
	jmp	sendxit

pfpok:	mov	al,'R'-40h		; Issue DCE START PUNCH
	call	punch_command
	push	es:Current_Event
	call	punch_file
	pop	ax
	call	_event_display
	call	vtr_inst
sendxit:ret

;================================================================
punch_file:
	call	pnchhdr
	mov	ax,1
	push	ax
	call	_index_storage

	call	pnch_crlf		; pnch a leading CRLF
	mov	bx,offset File_Title
	call	pnch_line_ES
	call	_force_fcm
	jc	pnchfl1
	call	pnch_til_null
pnchfl1:mov	bx,offset Type_Header
	call	pnch_til_null

	mov	bx,es:Mode_Pntr
	add	bx,offset ZeroBase.E_edl_Name
	call	pnch_til_null
	call	pnch_crlf
	call	pnch_crlf

	pop	cx			; Start with edit #1
	mov	Last_Fcm,0		; Force new FCM:

pf_loop:mov	ax,cx
	push	cx			; Save edit line number
	call	_evnum			; Display line # being punched
	call	pnch_event		; Punch this line
	mov	ah,0bh			; Check for
	int	DOS			;  Control-Break
	pop	cx			; Restore line number
	inc	cx			; Point to next
	mov	ax,cx
	cmp	ax,es:Next_Avail_Num
	jc	pf_loop

; PUNCH terminate
	mov	cx,10			; Punch 10 nulls
	mov	al,0
	call	pnchtrm
	mov	cx,5			; Punch 5 0ffh
	mov	al,0ffh
	call	pnchtrm
pnchhdr:mov	cx,50			; Punch trailer
	mov	al,0
pnchtrm:call	punch_command
	loop	pnchtrm
pnchxit:ret


;================================================================
transmit:
	call	_check4edl
	jz	xmitr

	mov	Active_IOTYP,readsend_IOTYP
	mov	ax,offset COM_EDLIO
	call	mdminst
	jnc	transone
	call	Port_unassigned
	ret

transone:
	mov	ax,es:Current_Event
	push	ax

tranagn:call	_index_storage
	jc	tranm1
	test	es:word ptr [bx].Flags_lofst,dblline_Fmask
	pushf
	push	ax
	mov	Last_Fcm,0		; Force FCM 6-22-1990
	call	pnch_event
	pop	ax
	inc	ax
	popf
	jnz	tranagn
	jmp	xmitx

tranm1:	call	pnch_event
xmitx:	pop	ax
	call	_index_storage
	call	vtr_inst
xmitr:	ret

;----------------------------------------------------------------
; Pnch event # AX
pnch_event:
	call	_index_storage
	push	bx			; Save line address
	call	_wrt_fcm			; pnch any FCM: changes
	jc	pnlin1
	call	pnch_til_null
pnlin1:	pop	bx
	push	bx
	call	_wrt_split		; pnch any split edit info
	jc	pnlin2
	call	pnch_til_null

pnlin2:	pop	bx			; Restore line address
pnlin3:	call	_EDL2ASCII
	call	pnch_til_null
	call	_E_flgs
	test	al,E_Flag_dblline
	jz	pnlin5
	mov	bx,Current_Event_Adr
	test	es:word ptr [bx].Flags_lofst,dblline_Fmask
	jnz	pnlin5
	call	pnch_crlf
pnlin5:	jmp	pnch_crlf


; Utility routines for punch
pnch_til_null:
	mov	al,[bx]
	or	al,al
	jz	pnchret
	call	punch_mdmout
	inc	ch
	inc	bx
	jmp	pnch_til_null

pnch_line_ES:
	mov	al,es:[bx]
	or	al,al
	jz	pnch_crlf
	call	punch_mdmout
	inc	bx
	jmp	pnch_line_ES

pnch_crlf:
	mov	al,cr
	call	punch_mdmout
	mov	al,lf
	call	punch_mdmout
pnchret:ret

punch_command:
	cmp	Papertape_Flag,0ffh
	jz	punch_mdmout
	ret

; Send a character to the punch.
; Check for XON XOFF handshakeing
punch_mdmout:
	push	ax

pmdm_1:	cmp	Papertape_Flag,0ffh
	jnz	pmdm_2
	mov	ah,al
	call	RS232_mdm_status
	mov	al,ah
	jnz	pmdm_2

	push	ax
	mov	ah,0bh
	int	DOS
	pop	ax
	jmp	pmdm_1

pmdm_2:	call	mdmout
	call	RS232_line_status	; <> THIS IS NOT NECESSARY
	jz	pnchmox
	call	mdmin
	cmp	al,'T'-40h
	jz	pnchmq
	cmp	al,'S'-40h
	jnz	pnchmox
pnchmq:	mov	ah,0bh
	int	DOS
	call	RS232_line_status
	jz	pnchmq
	call	mdmin
	cmp	al,'R'-40h
	jz	pnchmox
	cmp	al,'Q'-40h
	jnz	pnchmq
pnchmox:pop	ax
	ret

;================================================================
;Return a character, if any, from Port
; Time out after 65535 trys with C=1
rcvchar:xor	dx,dx			; Try "alot of times"
rcvchr0:call	mdmin			; Z=1 if no char
	jz	rcvchr1
	clc				; Clear timeout Flag
	ret
rcvchr1:dec	dx
	jz	rvcto
	jmp	rcvchr0
rvcto:	stc
	ret

;================================================================
; Get a line from the Port to DS:BX
; Exit: C=1 if TIMEOUT or Break
rcvlin:	mov	ah,0bh
	int	DOS			; Check for ctrl-Break
	call	RS232_line_status	; Check com Port
	jnz	rcv1			; Z=1 if no character waiting

; Check Keyboard for character waiting
; Return C=1 if Break
rcvlin1:call	cstat
	jz	rcvlin
	call	_make_ucase
	cmp	al,'C'
	jz	rcvcmt
	call	_Break_check
	jnz	rcvlin
	stc
rcvxt:	ret

; Get a character or a TIMOUT/Break
rcv1:	mov	al,'*'
	call	_ConOut
	call	rcvchar			; Get a character
	jc	rcvxt			; Return if any errors or Break
	or	al,al			; Null received?
	jz	rcv1			; Skip nulls
	cmp	al,0ffh			; End of this EDL?
	jz	rcvxt
	call	_backspace		; Erase "*"

; Check for end of line
rcv2:	cmp	al,cr			; EOL?
	jz	rcvnxt			; Yes, check for end of receive

; Store character, increment pointer and Count
rcv1a:	mov	[bx],al			; Else store character
	inc	bx			; Inx buffer pointer
	inc	cl
	jmp	rcv1

; Store CARRIAGE RETURN
rcvnxt:	mov	[bx],al
	inc	bx
	inc	cl

; Get line feed and store it
	call	rcvchar			; Get character after CR
	mov	[bx],al
	inc	bx
	inc	cl

; Check for any more chars
rcvnxt0:mov	dx,2000h
rcvnxt1:call	RS232_line_status			; Ret Z=1 if no char waiting
	jnz	rcvnxt2
	dec	dx
	jnz	rcvnxt1
	mov	byte ptr [bx],0		; Terminate line with null
	clc
	ret

; Get the next character and keep going
rcvnxt2:call	rcvchar
	jmp	rcv2

;
;Add a comment to the list during receive ready
rcvcmt:	push	bx
	push	dx
	push	cx
	call	note
	mov	Active_IOTYP,readsend_IOTYP
	call	redit_rdy
	pop	cx
	pop	dx
	pop	bx
	jmp	rcvlin

; Display RECEIVE READY message
redit_rdy:
	push	bx
	mov	bx,offset redit_ovr
	jmp	r_rdy

; Display RECEIVE EDL message
redl_rdy:
	push	bx
	mov	bx,offset redl_ovr

r_rdy:	call	_kbd_cln
	call	kbd_msgread
	mov	bx,offset rdy_ovr
	call	_msgread
	pop	bx
	ret

;----------------------------------------------------
; E x t e r n a l   T e r m i n a l   R o u t i n e
;----------------------------------------------------
read:	call	_check4edl
	jz	read_1			; No edl, so go

	call	_kbd_cln
	mov	bx,offset redl_ovr
	call	_msgread
	mov	bx,offset clear_list_ovr
	call	kbd_msgread
	mov	cl,'N'
	call	yn_chos
	jz	read_1
	jmp	_save_file

read_1:	call	_clear_list		; Null out the EDL in Memory
	mov	Active_IOTYP,readsend_IOTYP
	mov	ax,offset COM_EDLIO
	call	mdminst
	jnc	edlxfr2
	call	Port_unassigned
	ret

edlxfr2:call	vtr_inst		; Re install networks
	mov	Papertape_Flag,0
	mov	bx,offset rdrfile_ovr	;'Read from PAPER TAPE'
	call	no_chos_msg
	jnz	read_2
	mov	Papertape_Flag,0ffh
	mov	bx,offset rdrrdy_ovr
	call	_kbd_cln
	call	kbd_msgread
	call	rdchar
	call	_Break_check
	jnz	read_2
	ret

read_2:	mov	bx,offset Event_Storage	; Point to EDL buffer

read_3:	call	redl_rdy		; Let user know we are ready

	mov	Active_IOTYP,readsend_IOTYP
	mov	ax,offset COM_EDLIO
	call	mdminst

	cmp	Papertape_Flag,0ffh
	jnz	rcvlin_ES
	mov	al,'Q'-40h		; Issue DCE START READER
	call	punch_command

;================================================================
; Receive EDL as ASCII.  Use BIN as buffer
rcvlin_ES:
	call	RS232_line_status			; Check com Port
	jnz	rcv1_ES

rcvlin1_ES:
	call	cstat			; Check for keypress
	jz	rcvlin_ES		; Skip if none
	call	_Break_check		; Check for breaks
	jnz	rcvlin_ES		; Loop back if not
	jmp	edlxwrt			; If Break, jump to file write

;Get all subsequent characters up to a carriage return
rcv1_ES:mov	al,'*'
	call	_ConOut
	call	rcvchar			; Loop
	jc	edlxwrt
	call	_backspace
	or	al,al
	jz	rcv1_ES
	cmp	al,0ffh			; End of list?
	jz	edlxwrt
	cmp	al,cr			; EOL?
	jz	rcvnxt_ES		; Yes, check for more
	mov	es:[bx],al		; Else store character
	inc	bx			; Inx buffer pointer
	mov	ah,0bh			; Check for
	int	DOS			;  Control-Break
	jmp	rcv1_ES

rcvnxt_ES:
	mov	es:[bx],al
	inc	bx
	call	rcvchar			; Get character after CR
	jc	rcvnxto			; Exit if timed out
	mov	es:[bx],al
	inc	bx			; Increment EDL pointer

	mov	dx,8000h
rcvnxt1_ES:
	call	RS232_line_status	; Check com Port
	jnz	rcv1_ES			; Jump if so
	dec	dx
	jnz	rcvnxt1_ES
rcvnxto:jmp	edlxwrt

;================================================================
;Write EDL to file
edlxwrt:cmp	Papertape_Flag,0ffh
	jnz	edlxwr0

edldrain:
	call	rcvchar
	jc	edlxwr0
	cmp	al,0ffh
	jz	edldrain
	mov	al,'S'-40h		; Issue DCE STOP READER
	call	punch_command

edlxwr0:mov	byte ptr es:[bx],1ah		; Terminate EDL
	push	bx				; Save end of list address
	call	vtr_inst
	mov	bx,offset SavedReceived_ovr
	call	no_chos_msg
	pop	bx
	jz	edlxwr1
	call	_evnt_dispthis
	call	vtr_inst
	ret
;;	jmp	read_3

edlxwr1:call	_edl_write
	call	_clear_list
	call	_edl_read
	mov	ax,1
	call	_event_display
	call	vtr_inst
	ret
;;	jmp	Keyboard

;................................................................
; ERROR: Port selected for this operation is not properly assigned
Port_unassigned:
	ERROR	BadPortAsgn, ERET_Return
	ret

;================================================================
;-----------------------------------------------
; T e r m i n a l   C o m m u n i c a t i o n s
;-----------------------------------------------
xterm:	mov	Active_IOTYP,xterm_IOTYP
	mov	ax,offset COM_XTERM
	call	mdminst			; Initiate VLAN

xtrmagn:mov	Fullscreen_Flag,0ffh
	call	_clear_screen
	rev_VIDEO FALSE,FALSE
	mov	bx,offset xterm_ovr
	call	_msgread
	norm_VIDEO FALSE,FALSE
	call	_crlf
	call	_crlf
	call	_Cursor_On
	call	_Keyboard_caps		; Turn on CAPS LOCK

; Check for Port character waiting
sndlp1:	call	RS232_line_status
	jz	sndlp2
sndlpb:	call	mdmin
	cmp	al,80h
	jae	snddhw
	cmp	al,cr
	jz	sndlpc
	cmp	al,lf
	jz	sndlpc
	cmp	al,9
	jz	sndlpc
	cmp	al,' '
	jc	snddhw
sndlpc:	call	_ConOut
;;	cmp	al,cr
;;	jnz	sndlpr
;;	mov	al,lf
;;	call	_ConOut
sndlpr:	call	RS232_line_status
	jnz	sndlpb
	mov	dx,Cursor		; Get Cursor
	mov	ah,2
	mov	bh,0
	int	10h
	jmps	sndlp1

snddhw:	push	ax
	mov	al,'<'
	call	_ConOut
	pop	ax
	call	_dhb
	mov	al,'>'
	call	_ConOut
	jmp	sndlpr

; Check for Keyboard character waiting
sndlp2:	sti
	mov	ah,11h
	int	16h
	jz	sndlp1
	mov	ah,10h
	int	16h

; Break out on escape.
	cmp	ax,offset Escape_xcmd
	jnz	sndlp3
sndlpes:call	vtr_inst
	ret

sndlp3:	cmp	ax,offset F2_key
	jnz	sndlp3a
	mov	bx,offset portbreak_ovr
	call	_msgread

;;	call	PortIO_GetAddr		;  in the table of
;;	mov	dx,[si]

	mov	dx,xterm_address
	mov	bx,COM_XTERM.cpBAUD
	call	Port_Break

	mov	al,'!'
	call	_ConOut
	jmp	sndlp1

sndlp3a:cmp	ax,offset F1_key
	jnz	sndlp3b
	jmp	xtrmagn

sndlp3b:cmp	ax,offset F3_key
	jnz	sndlp3c
	call	_GetSXcb_SMPTEadr
	inc	bl
sndlpp:	mov	al,bh
	call	mdmout
	mov	al,bl
	call	mdmout
	jmp	sndlp1

sndlp3c:cmp	ax,offset F4_key
	jnz	sndlp3d
	call	_GetSXcb_SMPTEadr
	jmp	sndlpp

sndlp3d:cmp	ax,offset F5_key
	jnz	sndlp4d
	mov	al,'S'
	call	sndout
	mov	al,'E'
	call	sndout
	mov	al,cr
	call	sndout
	jmp	sndlp1

sndlp4d:
sndlp5d:
sndlp6d:
sndlp7d:
sndlp8d:

sndlp9d:call	sndout
	jmp	sndlp1

sndout:	call	mdmout			; Send character
	cmp	al,8			; Backspace?
	jz	sndbk
	cmp	al,cr
	jnz	sndout1
	call	_ConOut
	mov	al,lf
sndout1:call	_ConOut
	mov	dx,Cursor		; Get Cursor
	mov	ah,2
	mov	bh,0
	int	10h
	ret

; Backspace proc
sndbk:	call	_backspace
	ret


;================================================================
;		Port-INSTALL EDITOR PERIPHERALS
;================================================================
vtr_inst:
;;	call	_delfrm			; FIX 6-22-1990
;;					; To allow characters in line
;					;  to complete transmission
	mov	Active_IOTYP,vlan_IOTYP
	mov	ax,offset COM_VLAN
	call	mdminst			; Initiate VLAN
	call	_all_switcher_set
	if NOT CUTS_ONLY

;... INIT MESSAGES
	mov	bx,offset INIxpt_ovr
	call	kbd_msgread
	push	Cursor
	mov	al,':'
	call	_ConOut
	call	_Space_Out
	mov	bx,offset Split_Vid_Msg
	push	Cursor
	call	_comsg
	pop	Cursor
	call	vxptinit		; Initiate switcher
	mov	bx,offset Split_Aud_Msg
	call	_line_erase
	call	_comsg
;...
	call	axptinit		; Initiate audio switcher
	call	pxptinit		; Initiate preview switcher
	pop	Cursor
	call	_line_erase
	endif

; INITIATE JOGGER DEVICE
	call	_ResetInterrupt_JOGGER
	test	Network_Flags,Jogger_NTBIT
	jz	vtrinstx

joginst:mov	Active_IOTYP,Jogger_IOTYP
	mov	ax,offset COM_SES1010
	call	mdmintinit
	jc	vtrinstx
	call	saveportadr
	call	_SetInterrupt_JOGGER
vtrinstx:
	ret


;======================================================================
; Initiate the switcher Port, try to get an ACK from switcher,
;  set Device_Present Flag to TRUE or FALSE

pxptinit:
	mov	bl,preview_IOTYP
	mov	ax,offset COM_PREVIEW
	mov	si,offset PX_Address
	jmps	swrini1

axptinit:
	mov	bl,audio_IOTYP
	mov	ax,offset COM_AUDIOSW
	mov	si,offset AX_Address
	jmps	swrini1
vxptinit:
	mov	bl,video_IOTYP
	mov	ax,offset COM_VIDEOSW
	mov	si,offset SX_Address

swrini1:mov	Active_IOTYP,bl
	call	_switcher_set
	call	_GetSXcb_Flags
	or	bx,bx
	jz	xptinir

;...
	test	bx,SWbit_VLAN		; Check for VLAN switcher
	jz	swrini2

; Check for SWITCHER:
swrint_VLANsw:
	mov	al,Active_IOTYP
	push	ax
	call	_GetSXcb_SMPTEadr	; Get switcher node address
	mov	al,bl			;  to al
	call	get_appltype		; BX --> ASCII response from VLAN
	cmp	al,2			; Video switcher?
	jz	VLANswtchr_ok
	cmp	al,4			; Audio switcher?
	jz	VLANswtchr_ok
	pop	ax
	ret
VLANswtchr_ok:
	pop	ax
	or	Device_Present,al	; Device present?
	call	VLAN_allstop
	call	SetVlanEfxAddress
	call	GetVlanEmemRegs
	ret

swrini2:call	mdminit
	mov	[si],dx
	or	dx,dx			; Check for null Port
	jz	xptinir
	mov	al,Active_IOTYP
	or	Device_Present,al	; Set switcher present to TRUE
	call	SX_select
	jnc	xptinix

xptinir:mov	al,Active_IOTYP
	not	al
	and	Device_Present,al	; Reset switcher present to FALSE
	ret

xptinix:jmp	SW_allstop


;================================================================
; Check for presence of control networks
VLAN_init:
	if DEMO_RELEASE
	mov	al,vlan_IOTYP
	not	al
	and	Device_Present,al		; just not here!
	and	Device_Enabled,al
	jmp	netnofnd
	ELSE

;... INIT MESSAGES
	mov	bx,offset INIvln_ovr
	call	kbd_msgread
;...
	mov	Active_IOTYP,vlan_IOTYP
	mov	ax,offset COM_VLAN
	call	mdminst			; Initiate VLAN

	mov	al,vlan_IOTYP
	test	Device_Enabled,al	; Enabled?
	JMP_Z	netnofnd
	or	Device_Present,vlan_IOTYP ; Enable, at least temporarily

	call	Vlan_Reset

	call	vlan_ID
	jnc	netfnd

	call	AutoConfigure
	jnc	netfnda

	mov	al,vlan_IOTYP
	not	al
	and	Device_Present,al		; just not here!
	and	Device_Enabled,al
	jmps	netnofnd

netfnda:call	vlan_ID
netfnd:	mov	al,[bx]
	cmp	al,'V'
	jnz	illegal

netfnd0:add	bx,4
	call	_convert2bin
	mov	Vlan_Ver,ax
	cmp	ax,LEGAL_ROM
	jb	illegal
	mov	bx, swextended_VLNBIT
	not	bx
	and	VLAN_Flags, bx
	cmp	ax,EXTENSIONS_ROM;	Allow extensions?
	jb	netfnd1
	or	VLAN_Flags, swextended_VLNBIT

netfnd1:call	sync2rec	; Set record sync options
;;	call	GetVlanColorFrame
	call	VTR_Reset	; Zero joystick and E to E parameters

	test	Network_Flags,joystick_NTBIT
	jz	netfnd2

;... INIT MESSAGES
	mov	bx,offset INIjog_ovr
	call	kbd_msgread
;...

	call	_check4joystick	; Check for joystick, align if present

netfnd2:jmps	netnofnd

illegal:call	_clear_screen
	norm_VIDEO FALSE,FALSE
	mov	bx,offset illegal_ovr
	call	_msgread
	call	_Cursor_On
	call	_error_bell
	mov	al,vlan_IOTYP
	not	al
	and	Device_Present,al		; just not here!
	and	Device_Enabled,al
	call	rdchar
	ENDIF
netnofnd:ret


;================================================================
; Check five times for a valid ID string
; Return with BX pointing to ID string or Carry set if timeout
vlan_ID:mov	cx,3			; Try for 3 times
tryid:	call	getid			;  to get ID
	jc	getidx
	cmp	word ptr [bx],'RE'	; Check for "ERROR"
	clc
	jnz	getidx
tryid1:	loop	tryid
	stc				; If error, Exit with C=1
	ret

getid:	push	cx
	mov	ax,offset M_id
	xor	cx,cx
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	pop	cx
getidx:	ret

Vlan_Reset	proc	near
	mov	ax, offset M_VLAN_reset
	mov	ch,'X'
	mov	cl,0f1h
	call	vtr_sendcmd		; Send out a command
	call	vtr_answer
	call	_delsec
	call	_delsec
	call	vtr_nul
	call	vtr_nul
	ret
Vlan_Reset	endp

;----------------------------------------------------------------
; CX = Port word
; AX = baud rate
; Exit: DX has Port
;	C = 1 (set) if Port address = 0
mdminst:call	mdminit			; Init modem Port
	jc	mdmibad

saveportadr:
	push	si			; Index to the
	push	dx			;  correct position
	call	PortIO_GetAddr		;  in the table of
	pop	dx			;  Port addresses
	mov	[si],dx			;  and save the
	pop	si			;  Port address to table
	or	dx,dx
	jz	mdmibad

	mov	cx,255			; For garbage characters
mdminlp:mov	ah,0bh			; Check for CTRL-Brk
	int	DOS
	call	mdmin
	loopnz	mdminlp			; Gobble up garbage characters
	or	dx,dx
	ret

mdmibad:xor	dx,dx
	stc
	ret

;================================================================
mdminit:push	bx
	push	si

	mov	bx,ax			; COMPORT pointer to BX

	mov	al,[bx].cpPORT
	cbw

	push	ds
	mov	si,ax
	add	si,si
	mov	dx,40h
	mov	ds,dx
	mov	si,[si]			; dx=3f8 ro 2f8
	or	si,si			; Zero?
	pop	ds
	stc
	jz	badinit

	mov	dx,si
	add	dx,3			; index to line control reg
	mov	al,80h			; ATTENTION
	out	dx,al

	dec	dx
	dec	dx
	mov	al,byte ptr [bx].cpBAUD + 1
	out	dx,al			; MSB baudrate divisor
	dec	dx
	mov	al,byte ptr [bx].cpBAUD
	out	dx,al			; LSB baudrate divisor

	add	dx,3
	mov	al,[bx].cpOPTS		; Set parity, etc.
	out	dx,al
	dec	dx
	dec	dx
	mov	al,0
	out	dx,al

	add	dx,3
	mov	al,00000011b		; Disable interrupts, DTR RTS ON
	out	dx,al

	mov	dx,si			; Return with Port base in DX
	clc
badinit:pop	si
	pop	bx
	ret

;================================================================
mdmintinit:
	push	bx
	push	si

	mov	bx,ax			; COMPORT pointer to BX

	mov	al,[bx].cpPORT
	cbw

	push	ds
	mov	si,ax
	add	si,si
	mov	dx,40h
	mov	ds,dx
	mov	si,[si]			; dx=3f8 ro 2f8
	or	si,si			; Zero?
	pop	ds
	stc
	jz	badinit

	mov	dx,si
	add	dx,3			; index to line control reg
	mov	al,80h			; ATTENTION
	out	dx,al

	dec	dx
	dec	dx
	mov	al,byte ptr [bx].cpBAUD + 1
	out	dx,al			; MSB baudrate divisor (3f9)
	dec	dx
	mov	al,byte ptr [bx].cpBAUD
	out	dx,al			; LSB baudrate divisor (3f8)

	add	dx,3			; Line control register (3fb)
	mov	al,[bx].cpOPTS		; Set parity, etc.
	out	dx,al

	inc	dx			; Modem control register (3fc)
 	mov	al,00001011b		; Enable interrupts
	out	dx,al

	sub	dx,3
	mov	al,00000001b		; Enable receive (3f9)
	out	dx,al
	
	mov	dx,si			; Return with Port base in DX
	clc
	jmp	badinit


; Returns:
;	if byte available: NZ
;	if none available: Z, al is meaningless
RS232_line_status:
	push	si
	push	dx
	call	PortIO_GetAddr		; Get Port IO address to AX
	jz	linstx
linst2:	mov	dx,[si]
	add	dx,5
	in	al,dx
	test	al,1
linstx:	pop	dx
	pop	si
	ret

; Returns:
;	Z=0 (NZ) if BIT SET (1)
;	Z=1 (Z) if BIT NOT SET (0)
RS232_mdm_status:
	push	si
	push	dx
	call	PortIO_GetAddr		; Get Port IO address to AX
	jz	mdmstx
mdmst2:	mov	dx,[si]
	add	dx,6
	in	al,dx
	test	al,00010000b		; Check CLEAR TO SEND
mdmstx:	pop	dx
	pop	si
	ret


; Returns:
;	if byte available: NZ, char in al
;	if none available: Z, al is meaningless
	even
mdmin:	push	si
	push	dx
	call	PortIO_GetAddr		; Get Port IO address to AX
	jz	mdmixt
	mov	dx,[si]
	add	dx,5
	cli
	in	al,dx
	test	al,1
	jz	mdmixt
	mov	dx,[si]
	in	al,dx
mdmixt:	sti
	pop	dx
	pop	si
	ret

; Send a character out to the VLAN (mdm) or the switcher (SWR)
	even
mdmout:	push	si
	push	dx
	push	cx

	call	PortIO_GetAddr		; Get Port IO address to AX
	jz	mdmox
	xor	cx,cx
	cli				;<>Interrupts Disabled
	even
mdmolp:	mov	dx,[si]
	add	dx,5
	mov	ah,al
	in	al,dx
	test	al,00100000b
	mov	al,ah
	jnz	mdmog
	loop	mdmolp		; try again
	stc
	jmps	mdmox
mdmog:	mov	dx,[si]
	out	dx,al
	clc
mdmox:	sti
	pop	cx
	pop	dx
	pop	si
	ret

;................................................................
; Return with correct Port address at [SI]
; Carry SET (1) if Port is OK
; Z SET (1) if Port address at [SI] = 0
PortIO_GetAddr:
	mov	si,offset Port_Addresses
	mov	dl,Active_IOTYP
	ror	dl,1
	jc	PIOgax		; Vlan
	inc	si
	inc	si
	ror	dl,1
	jc	PIOgax		; Video
	inc	si
	inc	si
	ror	dl,1
	jc	PIOgax		; Audio
	inc	si
	inc	si
	ror	dl,1
	jc	PIOgax		; Jogger address
	inc	si
	inc	si
	ror	dl,1
	jc	PIOgax		; XTERM address
	inc	si
	inc	si
	ror	dl,1
	jc	PIOgax		; Printer
	inc	si
	inc	si
	ror	dl,1
	jc	PIOgax		; Read/Send
	inc	si
	inc	si
PIOgax:	cmp	word ptr [si],0
	jz	PIOgar
	stc
PIOgar:	ret

;================================================================
;		SEND Break/SELECT TO SWITCHER
;================================================================
SX_select:
	mov	al,Active_IOTYP
	test	Device_Present,al	; Switcher present?
	jz	sxselx
	push	bx
	push	cx
	push	bp
	call	_GetSXcb_Flags		; Get descriptor Flags
	mov	bp,bx			;  to DX

	test	bp,SWbit_NoWakeUp	; Skip Break/address?
	jnz	sxsel4

	mov	cx,2			; Try twice
sxsel2:	push	cx
	call	send_Break
	call	_GetSXcb_SMPTEadr
	or	bh,bh
	jz	sxsel3
	mov	al,bh
	call	mdmout
; 2-18-1993 nhs Eliminated swbit_poll
	test	bp,SWbit_GVG10XL	; Send select or poll?
	jz	sxsel3			; Jump if not poll address
	inc	bl			; Send a poll address
sxsel3:	mov	al,bl
	call	mdmout

	test	bp,SWBIT_smpte		; SMPTE or ESAM?
	jnz	sxsel5			; Jump if SMPTE
	mov	al,3			; Send escape for ESAM2
	call	mdmout

sxsel5:	call	sragn			; Get ACK from poll address
	pop	cx
	jnc	sxsel4
	loop	sxsel2

sxsel4:	pop	bp
	pop	cx
	pop	bx
sxselx:	ret

;================================================================
; USED FOR SWITCHER READS
sragn:	push	cx
	xor	cx,cx
srm:	call	mdmin
	jnz	srmx
	loop	srm
	mov	al,cl
	pop	cx
	stc
	ret
srmx:	pop	cx
	clc
	ret

;================================================================
;			SMPTE Break
;================================================================
send_Break:
	mov	dx,AX_Address
	mov	bx,COM_AUDIOSW.cpBAUD
	test	byte ptr Active_IOTYP,audio_IOTYP
	jnz	Port_Break
	mov	dx,SX_Address
	mov	bx,COM_VIDEOSW.cpBAUD
;	test	byte ptr Active_IOTYP,video_IOTYP
;	jnz	Port_Break

Port_Break:
	add	dx,3			; to MSB
	cli
	in	al,dx
	or	al,01000000b
	out	dx,al

	cmp	bx,1
	jnz	pb2
	call	_deltick
	jmp	pbc
pb2:	cmp	bx,2
	jnz	pb3
	call	_delhnd
	jmp	pbc
pb3:	cmp	bx,3
	jnz	pb4
	call	_delbrk
	jmp	pbc
pb4:	cmp	bx,6
	jnz	pb5
	call	_delms
	jmp	pbc
pb5:	cmp	bx,0ch
	jnz	pb6
	call	_delms
	call	_delms
	jmp	pbc
pb6:	cmp	bx,18h
	jnz	pb7
	call	_delms
	call	_delms
	call	_delms
	call	_delms
	jmp	pbc
pb7:	cmp	bx,30h
	jnz	pb8
	call	_delms
	call	_delms
	call	_delms
	call	_delms
	call	_delms
	call	_delms
	call	_delms
	call	_delms
	jmp	pbc
pb8:	cmp	bx,60h
	jnz	pb9
	call	_delfld
	jmp	pbc
pb9:	cmp	bx,0C0h
	jnz	pb10
	call	_delfrm
	jmp	pbc
pb10:	cmp	bx,180h
	jnz	pb11
	call	_delfrm
	call	_delfrm
	jmp	pbc
pb11:	cmp	bx,300h
	jnz	pb12
	call	_delfrm
	call	_delfrm
	call	_delfrm
	call	_delfrm
pb12:

pbc:	in	al,dx
	and	al,10111111b
	out	dx,al

	call	_delhnd
	call	_delhnd

	sti
	ret


;================================================================
;================================================================
;			PRINTER OUTPUT
;================================================================
;================================================================
;character in register a output to console
lst_co:	pushf
	push	ax
	push	bx
	push	cx
	push	dx
	and	al,7fh
	mov	ah,0
	call	lst_io
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	popf
	ret

lst_init:
	cmp	COM_PRINTER.cpPORT,8	; Using list device =>8
	jae	lstini1			; Init parallel Port
	mov	Active_IOTYP,printer_IOTYP
	mov	ax,offset COM_PRINTER
	call	mdminst
	jc	lstinig
	call	RS232_line_status
	test	al,80h			; Test for time-out
	jz	lstinig
	stc				; Set carry if time-out
lstinig:ret

lstini1:mov	ah,1			; Initialize printer
	mov	dl,8
	sub	dl,COM_PRINTER.cpPORT
	ror	dl,1
	mov	dh,0
	int	17h
	ret

; Check status of printer.  Return NZ and C=1 if off line
lst_io:	push	ax
	mov	ah,0bh			; Check for CONTROL Break
	int	DOS
	mov	dl,COM_PRINTER.cpPORT	; Determine if we are
	sub	dl,8			;  using an LSTn: or
	js	lst_pio			;  COMn: Port
	ror	dl,1
	mov	dh,0
	mov	ah,2			; Get printer status
	int	17h
	and	ah,00100001b		; No Paper, or Timed out
	or	ah,ah
	jnz	lststx
	pop	ax
	mov	ah,0
	int	17h
	clc
	ret
lst_pio:pop	ax
	mov	Active_IOTYP,printer_IOTYP
	jmp	mdmout
lststx:	pop	ax
	stc
	ret


;================================================================
;================================================================
;			JOYSTICK ROUTINES
;================================================================
;================================================================
joystick_far	proc	far
	call	joystick
	ret
joystick_far	endp

joyret:	ret

; 838ns TICKS:	7460 if idling
;		14824 on average for movements
	even
joystick:
	test	Device_Present,vlan_IOTYP
	jz	joyret
	test	Network_Flags,joystick_NTBIT
	jz	joyret
	test	EFX_Flag,10000000b	; Check for EFX MENU ACTIVE
	jz	joych0
	jmp	SWjoystick

joych0:	push	ax
	push	bx
	push	cx
	push	dx
	push	si
	push	di

	call	_jstick		; Get X to BX, Y to DX
	call	_joy_convert
	mov	si,offset Jstickx_Table
	mov	cl,Last_Stickx
	mov	ch,[bx+si]
	cmp	ch,cl		; Any change in %?
	jz	joy_y		; If not, jump

	mov	Last_Stickx,ch
	cmp	ch,80h
	mov	cl,PLUS_ASCII
	jc	joych1
	not	ch
	inc	ch
	mov	cl,MINUS_ASCII
joych1:	push	cx
	push	dx
	call	scan
	pop	dx
	pop	cx

; Accept Y coordinate parameters
	even
joy_y:	or	ch,ch			; Is X% = 0?
	jnz	joybut			; If not, skip Y stuff
	cmp	dx,20			; Joystick 25% or less
	mov	al,0
	jbe	joy_y1
	cmp	dx,80			; Joystick 75% or greater
	jb	joybut
	mov	al,Current_Source
joy_y1:	call	Machine_Change
	call	switch
	call	vtr_e2e
	jmps	joybutx

; Check for JOYSTICK KEY #2 (Defines joystick button #1
	even
joybut:	cmp	Fullscreen_Flag,0ffh
	jz	joybutx
	call	_jbutton
	mov	dl,Joybuttons		; Get last button
	cmp	al,dl
	jz	joybutx
	mov	Joybuttons,al

	test	ah,01000000b
	jz	joybut1
	test	dl,01000000b
	jnz	joybut1
	mov	ax,offset Markin_xcmd
	jmps	joykeys

joybut1:test	ah,10000000b
	jz	joybut2
	test	dl,10000000b
	jnz	joybut2
	mov	ax,offset Markout_xcmd
	jmps	joykeys

joybut2:test	ah,00100000b
	jz	joybut3
	test	dl,00100000b
	jnz	joybut3
	mov	ax,Joykey2
	jmps	joykeys

; Check for JOYSTICK KEY #1
joybut3:test	ah,00010000b
	jz	joybutx
	test	dl,00010000b
	jnz	joybutx
	mov	ax,Joykey1
joykeys:call	KeyCommand_main
	jnz	joybutx
	call	[si]
joybutx:pop	di
	pop	si
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	ret

_TEXT	ends

_DATA	segment byte public 'DATA'
_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
