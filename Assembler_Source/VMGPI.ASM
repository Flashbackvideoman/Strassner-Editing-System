; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner

; VMGPI.ASM
;
%nolist
include vm.equ

extrn List_Scr:word,GPI_Type:byte,position_query_FAR:far,_help_pos:far
extrn _dashit_cl:far,_sram_dx:far,Video_Mode:byte

extrn relaymsg_ovr:word, videomsg_ovr:word,Badmode_Fill:word
extrn triggermsg_ovr:word,gpiinfmsg_ovr:word
extrn norm_kbd:near, Msg_Area:word,PS_GPI:word

extrn INIgpi_ovr:word,kbd_msgread:near
extrn PS_RELAYS:word,_SetPointAndShootParams:far

extrn Device_Present:byte,Fullscreen_Flag:byte,Gpi_Node:byte
extrn Gpi_Oldsign:byte,Input_Flag:word,Rtcf:byte,Sign_Flag:byte
extrn Trim_Ci_Flag:byte,VLAN_Flags:word,Network_Flags:word

extrn Cursor:word,INSTL_Choices:word,PointShootData:word
extrn commandqry_ovr:word,Gcmdtype_Msg:word,Gpi0:word
extrn Gpi_Flags:word,Gpi_Msg:word,gpiopts_ovr:word,inactive_ovr:word
extrn Key_Trans:word,Key_Trans:word,offmsg_ovr:word,Offset_Buffer:word
extrn onmsg_ovr:word,Preroll:word,pulsetime_ovr:word,relaymsg_ovr:word
extrn Relaytype_Tbl:word,rtype_ovr:word,setgpi_rqst:word,Sort_Tcfmt:word
extrn Sttime:word,Tc_Format:word,Tcdispbuf:word,Temp_Wrkspce:word
extrn tglmsg_ovr:word,Title_Msg:word,trigstate_ovr:word

extrn _add_store:far
extrn cimsg_wrk:near,_cnvt2tc_DS:far,dec_cimsg:near
extrn gpi_index:near,Gpi_Upd:near,_Inout_init:far,Machine_Change:near
extrn _make_dec:far,_mmv3byt:far,motion:near,position_query:near
extrn Preroll_delayed:near,rdchar:near,screen_init:near,set_vtrcmd:near
extrn tc_cimsg:near,tc_parenth:near,_time_value:far,triggerit:near
extrn vtr_opt:near,vtr_sendloc:near,vtr_sendnd:near,vtr_sl1:near
extrn VLAN_SwGPIs:near, vtr_cmd:near

extrn _A_DecOut:far,_ConOut:FAR,_DecOut:far,_DecOut_100_pad:far
extrn _GPIVLAN_compensate:far,_MsgCntr:FAR,_REVERSE_compensateIN:far
extrn _Space_Out:far,_Break_check:FAR,_clear_screen:FAR,_cmp24b:far
extrn _comsg:FAR,_convert2bin:far,_delfrm:FAR,_Elaptm_move:far
extrn _Elaptm_move:far,_error_bell:FAR,_evnt_dispthis:far,_gpi_disp:far
extrn _kbd_cln:FAR,_kbd_clr:far,_line_erase:FAR,_make_ucase:far,_mmv16:far
extrn _mmv:far,_mpbadd:far,_mpbsub:far,_msgread:far
extrn _tlinegpi_save:far,_CheckLegalOffset:far
extrn _Check4GPIs:far,_GPI_sort:far,_Relay_Index:far,_Draw_Relay_Lines:far
extrn _Draw_Relays:far,_clear_tc:far


%list

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

%nolist

Public  gpi, gpioff, gpitoff, gpina, gpi_1, gpi_1a, gpi_1b, gpi_1c, gpi_1d
Public  gpitplp, gpiret, gpitr, gpiclr, gpig, gpiv, gpivg, gpset1
Public  gpi_2, gpinm, gpinm1, gpinm2, gpinxt, gpinxt1, gpi_clearem
Public  ClearAll_gpis, gpi_cl1, gpi_AllTurnOn, gpiATO1, gpi_allon, gpi_alo
Public  gpi_aln, gpi_AllTurnOff, gpi_alloff, gpi_alf, gpi_calc, gc_1, gc_3
Public  gc_x, gpi_ready, gr_1, gr_3, gr_x, gr_vlan, gr_relays, Relay_init
Public  riniagn, rini1, rini2, rinix, relay_ready, rlyrdy2, rlyrdy6
Public  rlyrdy8, rlyrdy9, rlyrdyf, rlyrerr, rlyrdyx, pulser, relay_trigger
Public  rlytrS, rlytrg2, rlytrR, rlytrg3, rlytrg6, rlytrgo, rlytrgx
Public  clear_relays, clrrly1, clrrly2, clrrlyx, PsuedoRollGPIs
Public  test_nodetype, chk4relaybox_FAR, chk4relaybox, c4rlylp, c4rly1
Public  c4rlyr, c4rFlag, c4rflg, Program_Relays, PGM_Relays_main, grelay1
Public  grelay2, grelera, grelay3, grelsp, grelay4, grelay5, grelay6, grelayd
Public  grelayP, grelyp1, grelyp2, grelayL, grelayS, grelys1, grelagn
Public  relay_Exit, grelTC, greltc1, greltcx, vtr_relaycmd, gpi_FAR
public  Relay_Menu
%list

; Video switcher
Relay_Menu	proc	near
	mov	bx, offset Relaytype_Tbl
	mov	dx, offset List_Scr + 110h; Screen position
	mov	cx, MAX_RELAYS

	call	RelayMenu_Display
	jc	rmenx
	mov	cl,GPI_Type
	inc	cl
	call	position_query_FAR
	jc	rmenx
	dec	cl
	mov	GPI_Type,cl
	clc
rmenx:	ret
Relay_Menu	endp

RelayMenu_Display	proc	near
	call	 _help_pos

	push	bx
	mov	bx,offset PS_GPI
	call	_SetPointAndShootParams
	pop	bx

	mov	relaycounter,0

	xor	cl,cl				; Clear counter
	dec	cl
	mov	ch,PointShootData.PQ_rows
	dec	ch

	mov	di,PointShootData.PQ_Cursor	; Screen position
	mov	dx,di				; Save in DX
rmdisp1:cmp	cl,MAX_RELAYS
	jz	rmdispx

	mov	Cursor,di
	inc	cl

	mov	al,cl
	cmp	al,10
	jnc	rmdisp2
	call	_Space_Out
rmdisp2:dim_VIDEO FALSE,TRUE
	call	_A_DecOut
	mov	al,':'
	call	_ConOut

	push	bx

	test	byte ptr [bx].Rly_ACTIVE,10000000b	; active relay?
	jnz	rmdispk					; Skip if not active

	dim_VIDEO FALSE,FALSE
	mov	bx,offset Badmode_Fill
	call	_comsg
	jmp	rmdisp3

rmdispk:norm_VIDEO FALSE,FALSE
	mov	relaycounter,cl				; Save high count
	push	cx
	mov	cx,8
rlyncmg:mov	al,[bx]
	inc	bx
	call	_ConOut
	loop	rlyncmg
	pop	cx

rmdisp3:pop	bx
	add	bx,RTYPE_LENGTH
	cmp	cl,ch				; Is this column done?
	jnz	rmdisp4
	add	ch,PointShootData.PQ_rows	; For next column
	add	dl,PointShootData.PQ_tab
	mov	di,dx
	jmp	rmdisp1

rmdisp4:add	di,100h
	jmp	rmdisp1

rmdispx:mov	al,relaycounter
	inc	al
	mov	PointShootData.PQ_choices,al ;cl	; Save choices
	ret

RelayMenu_Display	endp


;================================================================
; SEND OUT A RELAY TRIGGER COMMAND (RT)
; IN THE FORM OF:	XX ##,[+/-]00:00:00:00
;================================================================
; ENTER: BX points to the GPI TRIGGER BASE
;	 CL has RELAY#
; NOTE: DL is used for division
;	Trigger offset is factored in
vtr_relaycmd	proc	near
	push	si
	test	Device_Present,vlan_IOTYP
	jz	gpicmdx

	call	relay_ready		; Returns SI as RELAY DESCRIPTOR
	jc	gpicmdx

; ADD IN TRIGGER OFFSET
	push	cx
	mov	cl,Rtcf
	call	Preroll_delayed		; BX has offset from PREROLL
	pop	cx

;... 2-14-1996   Fixed GPI number > 16
vrlc1:	cmp	cl,16
	jb	vrlc2
	sub	cl,16
	jmp	vrlc1	
vrlc2:
;...
	mov	dx,si
	add	dx,offset ZeroBase.Rly_OFFSET
	call	_mpbsub

	call	_REVERSE_compensateIN	; Compensate in for previews

	; Check for triggers < 0
	;  If found, offset them 2 frames from 0
	call	_CheckLegalOffset
	jnc	vrlc3
	mov	word ptr [bx],2
	mov	byte ptr [bx+2],0

; Send the actual RT ##,XX:XX command
vrlc3:	push	bx
	mov	ax,offset M_relay_trigger
	call	set_vtrcmd		; Set the command
	mov	bl,cl			; Get relay #
	xor	bh,bh
	call	_make_dec
	mov	al,','			; Separate with a comma
	call	_add_store
	pop	bx			; Restore TC buffer pntr
	call	vtr_sl1			; Send out time code
gpicmdx:pop	si
	ret

vtr_relaycmd	endp

gpi_FAR	proc	far
	call	gpi
	ret
gpi_FAR	endp

;================================================================
; Set coincidence interface to trigger
gpi	proc	near
	mov	Trim_Ci_Flag,0
	call	_kbd_cln

	call	ClearGpiPgm

	call	_gpi_disp		; Display GPI registers

	norm_VIDEO FALSE,FALSE
	push	Cursor
	mov	Cursor,180Dh
	mov	bx,offset gpiopts_ovr
	call	_msgread
	pop	Cursor

; Request GPI #0-15
;  If GPI pressed again then toggle GPI mode on/off
	mov	Input_Flag,INFL_gpi
	mov	al,2
	call	dec_cimsg
	jc	gpioff
	jnz	gpi_1

;+++ 3-27-1991
	call	_kbd_clr
	call	_evnt_dispthis
	ret

gpioff:	call	_Check4GPIs		; Any gpis enabled?
	jz	gpitoff

	cmp	ax,offset GPI_xcmd
	jnz	gpina
	test	Gpi_Flags,Enabled_MSBIT
	jnz	gpitoff
	or	Gpi_Flags,Enabled_MSBIT	; Set to on
	jmps	gpina
gpitoff:and	Gpi_Flags,not Enabled_MSBIT	; Reset to off
gpina:	call	Gpi_Upd
	call	_evnt_dispthis
	ret

; Convert ASCII GPI number to binary and index to the
;  proper GPI registers
gpi_1:	call	_convert2bin
	cmp	ax,99			; Clear all?
	jnz	gpi_1a
	jmp	gpi_clearem
gpi_1a:	cmp	ax,98
	jnz	gpi_1b
	jmp	gpi_AllTurnOn
gpi_1b:	cmp	ax,97
	jnz	gpi_1c
	jmp	gpi_AllTurnOff
gpi_1c:	cmp	ax,96
	jnz	gpi_1d
	call	_GPI_sort
	jmp	gpi


gpi_1d:	cmp	ax,MAX_GPI_REGISTERS
	JMP_NC	gpi

	mov	relaynumber,ax
	call	gpi_index
	or	[bx].gpiFLAGS, G_program_mask	; Establishing gpi program
	call	_evnt_dispthis
	call	_gpi_disp		; Display GPI registers

gpitplp:
	mov	ax,relaynumber
	call	DisplayGpiIndexNumber
	mov	relayrecord,si			; Save pointer to relay rec.

	mov	bx,offset commandqry_ovr	; Request GPI type
	call	_msgread

	call	rdchar
	call	_Break_check
	jz	gpiret

	mov	byte ptr Cursor, 7
	call	_line_erase

	cmp	ax,offset Triggernow_xcmd
	jz	gpitr
	cmp	ax,offset Enter_xcmd
	jz	gpivg
	cmp	ax,offset Vidsel_xcmd
	jz	gpiv
	cmp	ax,offset GPI_xcmd
	jz	gpig
	cmp	ax,offset Clrrd_xcmd		; Clear GPI?
	jz	gpiclr
	cmp	ax,offset Nokey_xcmd
	jz	gpiclr
	cmp	ax,offset Yeskey_xcmd
	jz	gpienb
	call	_error_bell
	jmp	gpitplp

gpiret:	ret

gpitr:	call	triggerit			; GPI# in CL
	jmp	gpi

; Turn off this GPI
gpiclr:	and	byte ptr [SI].gpiFLAGS,not G_active_mask
	jmp	gpinxt

; Turn on this GPI
gpienb:	mov	al, [SI].gpiFLAGS
	and	al, G_swtrig_mask OR G_vltrig_mask
	or	al,al
	JMP_Z	gpinxt
	or	byte ptr [SI].gpiFLAGS, G_active_mask
	jmp	gpinxt

gpig:	and	[si].gpiFLAGS, NOT (G_swtrig_mask OR G_vltrig_mask OR G_machine_mask)
	or	byte ptr [SI].gpiFLAGS,G_vltrig_mask	; Relay
	jmps	gpivg

gpiv:	and	[si].gpiFLAGS, NOT (G_swtrig_mask OR G_vltrig_mask OR G_machine_mask)
	or	byte ptr [SI].gpiFLAGS,G_swtrig_mask	; Video


; If current command is not zero, the preset the menu to
;  the old gpi's cmd number
gpivg:	test	byte ptr [SI].gpiFLAGS,G_vltrig_mask	; Relay?
	jnz	gpivg0
	; check for no assignment at all
	test	byte ptr [SI].gpiFLAGS,G_swtrig_mask
	jnz	gpivg0a
	call	_error_bell
	jmp	gpitplp	;loop

gpivg0a:call	DisplayGpiType
	call	_Space_Out

	push	Cursor
	mov	byte ptr Cursor, 27
	mov	bx,offset gpiinfmsg_ovr
	call	_msgread
	pop	Cursor

	mov	al,3
	call	dec_cimsg
	JMP_C	gpiret
	jz	gpset1
	call	_convert2bin
	mov	[si].gpiCMD,dx
	jmp	gpivg2


; Get relay assignment
gpivg0:	mov	cx,[si].gpiCMD
	or	cx,cx
	jz	gpivg1
	mov	GPI_Type,cl

gpivg1:	call	Relay_Menu
	JMP_C	gpi
	mov	si,relayrecord
	mov	ax,relaynumber
	mov	ch,0
	mov	[si].gpiCMD,cx

gpivg2:	call	_evnt_dispthis
	call	_gpi_disp		; Display GPI registers
	mov	si,relayrecord
	mov	ax,relaynumber

	call	DisplayGpiIndexNumber

	and	[si].gpiFLAGS, NOT G_program_mask	; Establishing gpi program

	push	Cursor
	mov	byte ptr Cursor, 27
	mov	bx,offset gpiinfmsg_ovr
	call	_msgread
	pop	Cursor


gpset1:	mov	bx,offset setgpi_rqst
	call	_Inout_init
	call	_Space_Out

	mov	Input_Flag,INFL_gpi

	mov	bx,si
	inc	bx			; Point to offset
	call	_time_value
	jz	gpi_2
	call	_Space_Out
	mov	cl,[si].gpiSIGN		; Get sign
	push	si
	mov	ch,Rtcf
	call	tc_parenth
	pop	si
gpi_2:	mov	cl,[si].gpiSIGN
	mov	Gpi_Oldsign,cl
	mov	[si].gpiSIGN,PLUS_ASCII
	mov	bx,offset Sttime	; Use Sttime for work area
	mov	al,Rtcf			; Use record side FCM 3/90 nhs *NOTATE*
 	call	tc_cimsg
	jnc	gpinm

; Carry is set, clear time code to zero
	mov	cl,Gpi_Oldsign
	mov	[si].gpiSIGN,cl
	xor	ax,ax
	mov	word ptr [si].ZeroBase.gpiTRIGTIME,ax
	mov	byte ptr [si].ZeroBase.gpiTRIGTIME + 2,al
	mov	bx,si
	inc	bx
	and	Gpi_Flags,not Enabled_MSBIT

gpinm:	call	_time_value
	jz	gpinm1
	mov	dx,si
	inc	dx
	call	_mmv3byt
	jmps	gpinm2

gpinm1:	mov	al,Gpi_Oldsign		; If zero TC, keep same sign
	mov	[si].gpiSIGN,al

;GPIs without any TYPE will be disabled
; Finish up the TC offset entry and see if we have a valid entry
gpinm2:	mov	al,byte ptr [si].gpiFLAGS
	and	al,not G_active_mask
	or	al,al
	jz	gpinxt
	or	byte ptr [si].gpiFLAGS,G_active_mask

	call	_Check4GPIs		; Any gpis enabled?
	jz	gpinxt
	or	Gpi_Flags,Enabled_MSBIT

;; Make zero values "+"
gpinxt:	mov	bx,si
	add	bx,offset ZeroBase.gpiTRIGTIME
	call	_time_value
	jnz	gpinxt0
	mov	[si].gpiSIGN,PLUS_ASCII

gpinxt0:mov	al,byte ptr [si].gpiFLAGS
	and	al,not G_active_mask
	or	al,al
	jnz	gpinxt1
	mov	byte ptr [si].gpiFLAGS,al
gpinxt1:mov	Input_Flag,0
	call	Gpi_Upd
	jmp	gpi

gpi_clearem:
	call	ClearAll_gpis
	and	Gpi_Flags,not Enabled_MSBIT
	jmp	gpinxt1


gpi_AllTurnOn:
	call	gpi_allon
	call	_Check4GPIs
	jz	gpiATO1
	or	Gpi_Flags,Enabled_MSBIT
gpiATO1:call	Gpi_Upd
	jmp	gpi

; Turn on all GPIs if there is anything in GPI_flgs
gpi_allon:
	mov	bx,offset Gpi0
	xor	ax,ax
	mov	cx,MAX_GPI_REGISTERS
gpi_alo:cmp	byte ptr [bx].gpiFLAGS,0
	jz	gpi_aln
	or	byte ptr [bx].gpiFLAGS,80h
gpi_aln:add	bx,GPI_length
	loop	gpi_alo
	ret

gpi_AllTurnOff:
	call	gpi_alloff
	jmp	gpi

gpi_alloff:
	mov	bx,offset Gpi0
	xor	ax,ax
	mov	cx,MAX_GPI_REGISTERS
gpi_alf:and	byte ptr [bx].gpiFLAGS,7fh
	add	bx,GPI_length
	loop	gpi_alf
	ret

gpi	endp


ClearAll_gpis	proc	near
	mov	bx,offset Gpi0
	xor	ax,ax
	mov	cx,MAX_GPI_REGISTERS
gpi_cl1:mov	[bx],ax
	mov	2[bx],ax
	mov	4[bx],ax
	mov	6[bx],ax
	add	bx,GPI_length
	loop	gpi_cl1
	ret
ClearAll_gpis	endp

; Display "Relay trigger #" or "Video Trigger #" and return
; ENTER: SI points to gpi record
; Uses BX, AX
DisplayGpiType	proc	near
	test	byte ptr [SI].gpiFLAGS,G_vltrig_mask	; Relay?
	jnz	dgpit_relay

	test	byte ptr [SI].gpiFLAGS,G_swtrig_mask	; Video?
	jnz	dgpit_video

	mov	al,'?'
	call	_ConOut
	ret

dgpit_relay:
	mov	bx,offset relaymsg_ovr
	call	_msgread
	jmp	dgpit_rv

dgpit_video:
	mov	bx,offset videomsg_ovr
	call	_msgread

dgpit_rv:
	mov	bx,offset triggermsg_ovr
	call	_msgread
	ret
DisplayGpiType	endp

; AX = GPI#
; Exit: Display done
;	SI -> GPI
DisplayGpiIndexNumber	proc	near
	push	ax
	call	gpi_index
	mov	si,bx
	call	_kbd_cln
	norm_VIDEO FALSE,FALSE			; Display selected GPI number
	mov	bx,offset Gpi_Msg
	call	_comsg
	mov	al,'#'
	call	_ConOut
	pop	ax
	mov	cx,ax			; Save gpi# to CX
	call	_A_DecOut
	call	_Space_Out
	call	_Space_Out
	ret
DisplayGpiIndexNumber	endp

;================================================================
;	Calculate trigger times for all active VTR Triggers
;================================================================
; If gpis found, then set trigger offsets
; Enter	AL = TRUE if setting relays
;	AL = FALSE not to set relays
gpi_calc	proc	near
	test	Gpi_Flags,Enabled_MSBIT
	jz	gc_x

	mov	SetRelay_Flag,al
	xor	al,al
	call	Machine_Change		; Use the record's FCM type
	xor	cx,cx
gc_1:	push	cx			; Save GPI register Count
	mov	ax,cx			; Index to GPI
	call	gpi_index
	test	byte ptr [bx].gpiFLAGS,G_active_mask
	jz	gc_3			; Skip if not active
	call	_tlinegpi_save

	test	byte ptr [bx].gpiFLAGS,G_vltrig_mask
	jz	gc_1a

	mov	cl,byte ptr [bx].gpiCMD	; Get the actual relay number
	cmp	SetRelay_Flag, TRUE
	jnz	gc_3
	call	vtr_relaycmd
	jmp	gc_3
gc_1a:

	if ALLOW_VLAN3
	test	VLAN_Flags, forcever3_VLNBIT
	jnz	gc_2
	test	VLAN_Flags, swextended_VLNBIT
	jnz	gc_3
gc_2:	test	byte ptr [bx].gpiFLAGS,G_swtrig_mask
	jz	gc_3
	cmp	SetRelay_Flag, TRUE
	jnz	gc_3
	call	VLAN_SwGPIs		; Set VLAN gpis if necessary
	endif

gc_3:	pop	cx			; Restore GPI register Count
	inc	cl
	cmp	cl,MAX_GPI_REGISTERS		; Done?
	jnz	gc_1
gc_x:	ret

gpi_calc	endp

;================================================================
;		READY Triggers FOR EDIT
;================================================================
gpi_ready	proc	near
	test	Gpi_Flags,Enabled_MSBIT
	jz	gr_x

	xor	al,al			; <><> necessary?
	call	Machine_Change		; Use the record's FCM type

	xor	cx,cx
gr_1:	push	cx			; Save GPI register Count
	mov	ax,cx			; Index to GPI
	call	gpi_index
	test	byte ptr [bx].gpiFLAGS,G_active_mask
	jz	gr_3			; Skip if not active

	test	byte ptr [bx].gpiFLAGS,G_vltrig_mask
	jz	gr_3			; Skip if not GPI trigger

	cmp	word ptr [bx].gpiCMD,0	; Check relay number
	jz	gr_vlan			; 0 = transmitter relay
	cmp	word ptr [bx].gpiCMD,MAX_RELAYS
	jbe	gr_relays		; Otherwise, set relay trigger

gr_3:	pop	cx			; Restore GPI register Count
	inc	cl
	cmp	cl,MAX_GPI_REGISTERS		; Done?
	jnz	gr_1
gr_x:	ret

; VLAN TRANSMITTER COINCIDENCE TRIGGER
gr_vlan:
	call	Preroll_delayed
	call	_GPIVLAN_compensate
	call	_REVERSE_compensateIN

	mov	ax,offset M_gpi_time
	call	vtr_sendloc
	jmp	gr_3

; BX points to RELAY buffer
gr_relays:
	mov	cx,word ptr [bx].gpiCMD	; Get then relay number (CL)
	jmp	gr_3
gpi_ready	endp

;================================================================
; Clear all bits in RLY_ACTIVE to incdicate initial state of RESET
Relay_init	proc	near
;... INIT MESSAGES
	mov	bx,offset INIgpi_ovr
	call	kbd_msgread
;...
	or	Relaytype_Tbl.Rly_ACTIVE,10000000b ; Indicate VLAN-T here

	call	chk4relaybox
	test	Network_Flags, GPI_NTBIT
	jz	rinix
	mov	ch,Gpi_Node
	mov	cl,1			; 4 allowed

riniagn:push	cx			; Save node number in CH
	mov	al,Ntype_relays		; Must be a GPI box
	call	test_nodetype		; Make sure this is one 
	jnz	rini1
	mov	ax,offset M_node_address; CH has real node number
	call	vtr_opt			; Set the node address
	mov	ax,offset M_relay_reset
	mov	ch,0
	call	vtr_opt
rini1:	pop	cx
	inc	ch
	inc	cl
	cmp	cl,4
	jb	riniagn

	mov	bx,offset Relaytype_Tbl
;;	or	byte ptr [bx].Rly_ACTIVE,10000000b ; Relay is present
	add	bx,RTYPE_LENGTH

	mov	cx,MAX_RELAYS		; 48 total relays
rini2:	and	byte ptr [bx].Rly_ACTIVE,10000000b ; Indicate all RESET
	add	bx,RTYPE_LENGTH
	loop	rini2
	call	clear_relays
rinix:	ret
Relay_init	endp


;================================================================
;	Clear the program flag from GPI registers
;================================================================
ClearGpiPgm	proc	near
	push	ax
	push	cx
	push	dx
	xor	dx,dx
	mov	cx,MAX_GPI_REGISTERS
c4g_2:	mov	ax,dx			; Index to GPI
	call	gpi_index
	and	[bx].gpiFLAGS, NOT G_program_mask
	inc	dx
	loop	c4g_2
c4g_3:	pop	dx
	pop	cx
	pop	ax
	ret
ClearGpiPgm	endp


;================================================================
; Standby the relay in CX
; Exit: C=1 if relay does not exist
;	SI points to relay buffer
relay_ready	proc	near
	push	cx
	push	bx

	mov	ax,cx			; Get relay number
	call	_Relay_Index		; Index to control block, get node#
					; On return, SI points to relay buffer
					; AL = node offset
					; AH = relay number at node
	push	ax			; Save relay number in AH

	mov	al,Ntype_relays		; Must be a GPI box
	call	test_nodetype		; Make sure this is one 

	pop	ax			; Restore relay number to CH
	jnz	rlyrerr

	push	ax
	mov	ax,offset M_node_address	; CH has real node number
	call	vtr_opt			; Set the node address
	pop	cx

	mov	al,[si].Rly_FLAGS	; Get Flag

	test	al,RTYPE_pulse		; Pulse type relay?
	jnz	rlyrdy6			;  Jump if so

; Setup for latch type relay
	test	al,RTYPE_set		; Put latch on?
	jz	rlyrdy2
	mov	ax,offset M_relay_reset
	and	byte ptr [si].Rly_ACTIVE,11111110b	; Inicate reset
	call	motion
	jmp	rlyrdyf

rlyrdy2:test	al,RTYPE_reset		; Put latch off?
	jz	rlyrdyf
	mov	ax,offset M_relay_set
	or	byte ptr [si].Rly_ACTIVE,00000001b	; Inicate set
	call	motion
	jmp	rlyrdyf


; Setup for pulse type relay
rlyrdy6:test	al,RTYPE_set
	jz	rlyrdy8

	mov	ax,offset M_relay_reset
	and	byte ptr [si].Rly_ACTIVE,11111110b	; Inicate reset
	jmp	rlyrdy9

rlyrdy8:mov	ax,offset M_relay_set
	or	byte ptr [si].Rly_ACTIVE,00000001b	; Inicate set

rlyrdy9:call	pulser
rlyrdyf:clc
	jmp	rlyrdyx

rlyrerr:stc
rlyrdyx:pop	bx
	pop	cx
	ret

; Send out pulse info
pulser:	push	ax			; Save Set/Reset command
	push	cx
	call	vtr_opt
	mov	ax,offset M_relay_pulse	; Send pulse info
	call	motion
	mov	ch,[si].Rly_FLAGS
	and	ch,RTYPE_pwidth		; Mask for time
	mov	ax,offset M_pulse_time
	call	vtr_opt			; Set pulse time
	pop	cx
	pop	ax			; Restore Set/Reset command
	ret
relay_ready	endp

;================================================================
;		Trigger a GPI Relay
;================================================================
; ENTER: BX points to GPI descriptor
relay_trigger	proc	near
	mov	cx,[bx].gpiCMD		; Get command word
	or	cl,cl			; Relay 0?
	jz	rlytrgx			; Can't do relay 0 (Transmitter)

	mov	ax,cx			; Get relay number

	call	_Relay_Index		; Index to control block, get node#
					; On return, SI points to relay buffer
					; AL = node offset
					; AH = relay number at node

	push	ax			; Save relay number in AH
	mov	ax,offset M_node_address	; CH has real node number
	call	vtr_opt			; Set the node address
	pop	cx			; Restore relay number to CH

	mov	al,[si].Rly_FLAGS	; Get Flag

	test	al,RTYPE_pulse		; Pulse type relay?
	jnz	rlytrg6			;  Jump if so

; Setup for latch type relay
	test	al,RTYPE_set		; Put latch on?
	jz	rlytrg2
rlytrS:	mov	ax,offset M_relay_set
	or	byte ptr [si].Rly_ACTIVE,00000001b	; Inicate set
	jmp	rlytrgo

rlytrg2:test	al,RTYPE_reset		; Put latch off?
	jz	rlytrg3
rlytrR:	mov	ax,offset M_relay_reset
	and	byte ptr [si].Rly_ACTIVE,11111110b	; Inicate reset
	jmp	rlytrgo

rlytrg3:test	byte ptr [si].Rly_ACTIVE,00000001b	; Is it SET?
	jnz	rlytrR
	jmp	rlytrS

; Setup for pulse type relay
rlytrg6:mov	ax,offset M_relay_pulse
rlytrgo:call	vtr_opt			; Set pulse time
rlytrgx:ret
relay_trigger	endp


;================================================================
; Clear all relays for all GPI boxes on line
clear_relays	proc	near
	test	Network_Flags, GPI_NTBIT
	jz	clrrlyx
	mov	ch,Gpi_Node		; Get base node
	mov	cl,4			; Three potential boxes
clrrly1:push	cx			; Save node number
	mov	al,Ntype_relays		; Is this a relay box?
	call	test_nodetype		; Z=1 if ok
	jnz	clrrly2
	push	cx
	mov	ax,offset M_clear_relays; Clear all relay Triggers
	mov	cl,VX_PoundNum
	call	vtr_cmd
	pop	cx
	mov	ax,offset M_clear_node	; Clear in/out
	mov	cl,VX_PoundNum
	call	vtr_cmd

clrrly2:pop	cx
	inc	ch
	dec	cl
	jnz	clrrly1
clrrlyx:
	mov	ax,offset M_gpi_time
	mov	bx,offset Sort_Tcfmt	; 23:59:59:29
	call	vtr_sendnd		; Send it non-drop
	ret
clear_relays	endp

;================================================================
; Test the actual node type for this VLAN node
; ENTER: AL = node type to match
;	 CH = node number
; Exit:	 Z = 1 (set) if match OK
test_nodetype	proc	near
	push	cx
	push	bx
	push	ax			; Save the node type to match
	mov	ax,offset M_node_type
	mov	cl,VX_PoundNum
	call	vtr_cmd
	pop	ax
	cmp	al,byte ptr [bx]
	pop	bx
	pop	cx
	ret
test_nodetype	endp

;================================================================
chk4relaybox_FAR	proc	far
	call	chk4relaybox
	ret
chk4relaybox_FAR	endp

chk4relaybox	proc	near
	mov	ch,Gpi_Node
	or	ch,ch
	jz	c4rlyr
	or	Network_Flags, GPI_NTBIT
	mov	cl,0			; Set for # of found GPI nodes
	mov	di,1			; Set for relay 1
c4rlylp:push	cx			; Save RELAY NODE #
;;	mov	ax,offset M_node_address; CH has real node number
;;	call	vtr_opt			; Set the node address
	mov	al,Ntype_relays		; Must be a GPI box
	call	test_nodetype		; Make sure this is 
	pushf				; Save Flags
	mov	ax,di			; Get relay number
	call	_Relay_Index		; Index to control block
	popf
	pop	cx

	mov	al,0			; Set as inactive
	jnz	c4rly1			; Jump if this aint a GPI box
	mov	al,10000000b		; Ready for active
	inc	cl
c4rly1:	call	c4rFlag
	inc	ch			; Go to next node
	add	di,16			; Increment for next box
	cmp	di,49
	jc	c4rlylp

	or	cl,cl
	jnz	c4rlyr
	and	Network_Flags, NOT GPI_NTBIT
c4rlyr:	ret


; Set relay as inactive or active with byte in AL
c4rFlag:push	cx
	mov	cx,16
c4rflg:	mov	byte ptr [si].Rly_ACTIVE,al
	add	si,RTYPE_LENGTH
	loop	c4rflg
	pop	cx
	ret
chk4relaybox	endp


; "Roll" all on-line GPI boxes
PsuedoRollGPIs proc near
	mov	ch,Gpi_Node
	or	ch,ch
	jz	Psrglyr
	mov	cl,0			; Set for # of found GPI nodes
Psrglylp:
	push	cx			; Save RELAY NODE #
;;	mov	ax,offset M_node_address; CH has real node number
;;	call	vtr_opt			; Set the node address
	mov	al,Ntype_relays		; Must be a GPI box
	call	test_nodetype		; Make sure this is 
	pop	cx
	jnz	Psrgly1			; Jump if this aint a GPI box
	push	cx
	mov	ax,offset M_RollDevice
	mov	cl,VX_PoundNum
	call	vtr_cmd
	pop	cx
Psrgly1:inc	ch			; Go to next node
	inc	cl
	cmp	cl,(MAX_RELAYS / MAX_RLYS_PERBOX)
	jc	Psrglylp
Psrglyr:ret
PsuedoRollGPIs endp


;================================================================
;================================================================
;			RELAY PROGRAMMING
;================================================================
;================================================================
; Program individual relays
Program_Relays	proc	near
	mov	Fullscreen_Flag,0ffh
	call	_clear_screen
	call	_Draw_Relay_Lines

; Program relay trigger
; Request Relay #0-MAX_RELAYS
	mov	Input_Flag,INFL_relay

	mov	bx,offset PS_RELAYS
	call	_SetPointAndShootParams

PGM_Relays_main:
grelay1:call	_Draw_Relays
	mov	cl,byte ptr  INSTL_Choices + 13
	call	position_query
	mov	byte ptr  INSTL_Choices + 13,cl
	jnc	grelay2
	jmp	relay_Exit

grelay2:mov	al,cl
	or	al,al
	jz	grelera
	cmp	al,MAX_RELAYS + 1
	jc	grelay3
grelera:call	_error_bell
	jmps	grelay1

grelay3:cbw
	mov	dx,ax			; Save relay #
	MULTIPLY_BY RTYPE_LENGTH, AX	; Index to correct buffer
	mov	si,offset Relaytype_Tbl
	add	si,ax

	if	NOT DEVELOPMENT
	test	byte ptr [si].Rly_ACTIVE,10000000b	; active relay?
	jz	grelay1
	ENDIF

	mov	bx,offset relaymsg_ovr	; "Relay #" message
	call	_kbd_cln
	call	_msgread
	call	_Space_Out
	mov	al,'#'
	call	_ConOut
	mov	bx,dx			; Get relay number
	call	_DecOut			; Display relay number
	call	_Space_Out
	mov	bx,offset Title_Msg
	call	_comsg
	mov	al,8
	call	cimsg_wrk		; Get the relay number from user
	jz	grelay4
	mov	dx,si
	add	dx,offset ZeroBase.Rly_NAME
	mov	cl,8			; CL = Max length of Name
	sub	cl,ch			; Calculate padding Spaces
	call	_mmv			; Move Name to buffer, returns CH = 0
	mov	bx,dx			; Get next destination address
	jcxz	grelay4			; Jump if no Spaces to pad
grelsp:	mov	byte ptr [bx],' '	; Pad with Spaces
	inc	bx
	loop	grelsp
grelay4:call	_Space_Out
	norm_VIDEO FALSE,FALSE
	mov	bx,offset rtype_ovr
	call	_msgread
grelay5:call	rdchar
	call	_Break_check
	jnz	grelay6
	jmp	relay_Exit
grelay6:cmp	ax,offset Enter_xcmd
	jz	grelayd			; Skip this if ENTER
	call	_make_ucase
	cmp	al,'P'			; Check for Pulse
	jz	grelayP
	cmp	al,'L'
	jz	grelayL
	call	_error_bell
	jmp	grelay5

grelayd:test	byte ptr [si].Rly_FLAGS,RTYPE_pulse
	jnz	grelyp1
	jmps	grelayS

grelayP:or	byte ptr [si].Rly_FLAGS,RTYPE_pulse
grelyp1:push	Cursor
	call	_Space_Out
	norm_VIDEO FALSE,FALSE
	mov	bx,offset pulsetime_ovr
	call	_msgread
	mov	Input_Flag,INFL_relay
	mov	al,2
	call	dec_cimsg
	pop	Cursor
	jc	relay_Exit
	jz	grelayS

	call	_convert2bin
	cmp	ax,32			; >31 frames?
	jc	grelyp2
	call	_error_bell
	jmps	grelyp1

grelyp2:and	byte ptr [si].Rly_FLAGS,not RTYPE_pwidth ; Clear out duration
	or	byte ptr [si].Rly_FLAGS,al	; Set the bits
	jmps	grelayS

grelayL:and	byte ptr [si].Rly_FLAGS,not RTYPE_pulse

grelayS:call	_kbd_cln
	mov	bx,offset trigstate_ovr
	call	_msgread
	call	rdchar
	call	_Break_check
	jz	relay_Exit
	cmp	ax,offset Enter_xcmd
	jz	grelagn
	mov	ah,RTYPE_set
	cmp	al,'1'
	jz	grelys1
	mov	ah,RTYPE_reset
	cmp	al,'2'
	jz	grelys1
	mov	ah,0
	cmp	al,'3'
	jz	grelys1
	call	_error_bell
	jmps	grelayS
grelys1:and	byte ptr [si].Rly_FLAGS,not (RTYPE_set OR RTYPE_reset)
	or	byte ptr [si].Rly_FLAGS,ah
grelagn:mov	bx,offset setgpi_rqst
	mov	dx,si
	add	dx,offset ZeroBase.Rly_OFFSET
	call	grelTC
	jmp	PGM_Relays_main

relay_Exit:
	mov	Input_Flag,0
	jmp	screen_init		; Returns through screen_init

;================================================================
; BX points to request message
; DX points to 24bit time code buffer
grelTC:	call	_Inout_init
	push	dx
	mov	bx,offset Sttime	; Get start time
	mov	Trim_Ci_Flag,0h		; Don't use +/-
	mov	al,NDF_CHAR		; Use non-drop frames
	call	tc_cimsg		; From user
	jnc	greltc1
	pop	bx			; Restore buffer
	call	_clear_tc
	ret
greltc1:call	_time_value
	pop	dx
	jz	greltcx
	call	_mmv3byt
greltcx:ret
Program_Relays	endp

_TEXT	ends

_DATA	segment byte public 'DATA'
SetRelay_Flag	db	FALSE
relaycounter	db	0
relaynumber	dw	0
relayrecord	dw	0
_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
