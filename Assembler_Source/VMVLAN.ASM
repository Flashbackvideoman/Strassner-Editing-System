; Last revised: 2-22-1995, 11:12:25   (C)1989-1995 Norman H. Strassner
; VMVLAN.ASM
; VLAN INTERFACE MODULE
;
%nolist
include vm.equ

extrn Vlan_Swbuf_CNT:byte,Active_IOTYP:byte,Effects_Address:byte
extrn Frame_Flag:byte,From_Machine:byte,Keybkgnd_Src:byte,Rtcf:byte
extrn Swvlan_IOTYP:byte,To_Machine:byte,Trans_Type:byte,Emem_Efxadr:byte

extrn Vlan_Swbuf:word
extrn Vlan_Swbuf_PTR:word,Vlan_Swbuf_SIZ:word,Atrans_Offset:word,Entime:word
extrn Key_Trans:word,Preroll:word,Sttime:word
extrn Tcdispbuf:word,Temp_Tc_Buf:word,Trans_Code:word,Trans_Length:word
extrn Triggers:word,Vlan_Emems:word

extrn getxpt:near,motion:near,Preroll_delayed:near
extrn set_vtrcmd:near,switch:near,vtr_answer:near,vtr_cmd:near
extrn vtr_opt:near,vtrcmdx:near

extrn _ConOut:FAR,_GetSXcb_SMPTEadr:far,_VLAN_wipes:far,_VSW_sort:far
extrn _GetSXcb_Flags:far,_Restore_Marktable:FAR,_VVV_compensateIN:far
extrn _add_store:far,_beeper:FAR,_blinkita:FAR,_Break_check:FAR
extrn _cnvt2tc_DS:far,_comsg:FAR,_default_val:FAR,_delfrm:FAR,_delms:FAR
extrn _dircur_lerase:FAR,_error_bell:FAR,_help_pos:FAR,_kbd_cln:FAR
extrn _kbd_clr:FAR,_lblocks:FAR,_machine_disp:far,_make_hexbyte:far
extrn _make_hexword:far,_mmv:far,_mpbadd:far,_mpbsub:far,_nblocks:FAR
extrn _Sttime_move:far,_hex2bn:far

%list

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

Public  SetVlanEfxAddress, switch_VLAN, VLAN_SwGPIs, VSG_2, VSW_SetKey, VSW_KEY
Public  VSGP_TRANS, VSGP_FTB, VSGP_EM, VSGP_EMW, VSGP_EMW1, VSG_4, VSG_4a
Public  VSG_5, VSG_6, VSG_done, VSGcpls, VSGcx, VSG_nk1, VSG_ret
Public  VLAN_clear_switcher_Triggers, VLAN_swclear, VCLRxit
Public  VLAN_switcher_write, VWV_lp, VWV_nau, VWV_cma, VWVnx, VWVnxc, VWVtc
Public  VWVnul, VWVsnd, VWVskp, VWV_xit, GetVlanEmemRegs, SetEMEMEfxAddress
Public  SetVlanEfxAdrTo_CH


GetVlanEmemRegs	proc	near
	CUTSONLY_TEST
	mov	al,Active_IOTYP
	push	ax
	mov	Active_IOTYP,video_IOTYP
	call	_GetSXcb_SMPTEadr

	mov	ch,bl
	cmp	cl,VX_DIGITch		; EXACT DIGIT in CH
	mov	ax,offset M_node_address
	call	vtr_cmd			; Select Node

	mov	ch,16			; Get #emems
	cmp	cl,VX_DIGITch		; EXACT DIGIT in CH
;;;	mov	cl,VX_ASCchNODEdl
	mov	ax,offset MSW_get_config
	call	vtr_cmd
	call	_hex2bn			; Translate from hex to binary
	mov	ah,0
	mov	Vlan_Emems,ax		; Save # emems
	pop	ax
	mov	Active_IOTYP,al
	ret
GetVlanEmemRegs	endp

; Select effects address indicated in CH
SetVlanEfxAdrTo_CH	proc	near
	CUTSONLY_TEST
	pusha
	mov	al,Active_IOTYP
	push	ax
	mov	Active_IOTYP,video_IOTYP

	call	_GetSXcb_Flags		; Get switcher Flags
	test	bx,SWbit_VLAN		; Check for VLAN switcher
	jz	sveatx

	call	_GetSXcb_SMPTEadr
	mov	dl,bl
	mov	ax,offset MSW_set_efxaddrs
	mov	cl,VX_HEXchNODEdl
	call	vtr_cmd
sveatx:	pop	ax
	mov	Active_IOTYP,al
	popa
	ret
SetVlanEfxAdrTo_CH	endp

; Restore the effects address to the current default
SetVlanEfxAddress	proc	near
	CUTSONLY_TEST
	pusha
	mov	al,Active_IOTYP
	push	ax
	mov	Active_IOTYP,video_IOTYP

	call	_GetSXcb_Flags		; Get switcher Flags
	test	bx,SWbit_VLAN		; Check for VLAN switcher
	jz	sveax

	call	_GetSXcb_SMPTEadr
	mov	dl,bl
	mov	ax,offset MSW_set_efxaddrs
	mov	ch,Effects_Address
	mov	cl,VX_HEXchNODEdl
	call	vtr_cmd
sveax:	pop	ax
	mov	Active_IOTYP,al
	popa
	ret
SetVlanEfxAddress	endp

SetEMEMEfxAddress	proc	near
	CUTSONLY_TEST
	pusha
	mov	al,Active_IOTYP
	push	ax
	mov	Active_IOTYP,video_IOTYP
	call	_GetSXcb_SMPTEadr
	mov	dl,bl
	mov	ax,offset MSW_set_efxaddrs
	mov	ch,Emem_Efxadr
	mov	cl,VX_HEXchNODEdl
	call	vtr_cmd
	pop	ax
	mov	Active_IOTYP,al
	popa
	ret
SetEMEMEfxAddress	endp


;================================================================
;
switch_VLAN:
	CUTSONLY_TEST
	push	dx
	push	ax
	call	getxpt
	mov	ch,al
	call	_GetSXcb_SMPTEadr
	mov	dl,bl
	mov	ax,offset MSW_switch
	mov	cl,VX_ASCchNODEdl ;VX_ASCchVTRdl sends (cmd) AX + (ascii) ch + "#" + (vtr) dl
	call	vtr_cmd
	pop	ax
	pop	dx
	ret


;================================================================
;================================================================
; 1-12-1992 
VLAN_SwGPIs	proc	near
	mov	Active_IOTYP,video_IOTYP
	push	bx
	call	_GetSXcb_Flags		; Get switcher Flags
	test	bx,SWbit_VLAN		; Check for VLAN switcher
	pop	bx
	JMP_Z	VSG_ret

	mov	di,bx			; GPI descriptor address to DI
	mov	si,Vlan_Swbuf_PTR	; Get next buffer pointer

;4-20-1994 
	mov	al,Active_IOTYP
	mov	[si].VSW_IOTYP, al
;...

; Byte 0 and 1 -- Transition duration in frames
	mov	bx,Key_Trans		; USE KEY TRANSITION
	cmp	Trans_Type,'K'		;  IF KEY
	jz	VSG_2
	mov	bx,Trans_Length		; USE MAIN TRANSITION
;3-08-1993 Fixed .VSW_TransitionDur for WORD length
VSG_2:	mov	[si].VSW_TransitionDur, bx

; Byte 2 -- Pattern # for wipes, or Memory address for Memory recall
;................
;		PAUSE TO PARSE THE GPI RECORD
;...
	mov	ax,ds:[di].gpiCMD	; Get the command word
	mov	cl,100
	div	cl			; Divide by 100
	mov	ch,al			; CH = EFFECTS BANK (Xxx)
	mov	cl,ah			; CL has command    (xXX)

;................................................................
; SET UP FOR:
;	CH = effects bank		CL = command
;	DL = Transition Type		DH = Key Flags
;	AX = Transition Code (i.e. Wipe Code)
;................................................................
	mov	ax,Trans_Code		; AX = Transition Code

	xor	dl,dl			; Clear Transition Type

; Retrieve the previous KEY FlagS
	mov	dh, [si - VLANSW_LENGTH] .VSW_NextKeyFlags

	cmp	cl,50			; <=EMEM, ==FTB, >=DSK
	jc	VSGP_EM			; 0 - 4 = emem register

	jz	VSGP_FTB		; Is it 50 (FADE TO BLACK)?

; No its greater than 50.  Is it less than 60?
	cmp	cl,59			; Larger than a keyer?
	ja	VSGP_TRANS
	or	ch,ch
	jnz	VSGP_TRANS

; Must be a down stream key
	mov	dl,2			; Set TRANSITION TYPE for DISSOLVE
	test	dh,01000000b		; Is DSK Already SET?
	jz	VSW_SetKey		; Yes, set it
	and	dh,10111111b		; Else reset it
	jmp	VSW_KEY
VSW_SetKey:
	or	dh,01000000b		; Set KEY FlagS for TITLE KEYER
VSW_KEY:jmp	VSGP_EMW
;...
; Greater than 59? Must be an auto transition
VSGP_TRANS:
	mov	dl,8			; Set TRANSITION TYPE for AUTO TRANS
	jmp	VSGP_EMW

VSGP_FTB:
	xor	dh,dh			; Set all KEY FlagS OFF
	mov	dl,2			; Set TRANSITION TYPE for DISSOLVE
	jmp	VSGP_EMW

; Emem register requested
VSGP_EM:mov	al,cl			; Give AX the EMEM register #
	mov	ah,0
	mov	dl,10			; Set for SIMPLE Memory RECALL
	jmp	VSGP_EMW

; EMEM or Trans_Code write
VSGP_EMW:
	mov	bx,ax			; Save code for modifiers
	mov	[si] .VSW_PatternNumber, bl

; Byte 3 -- Pattern Modifier
	call	_VLAN_wipes		; pattern modifier
	mov	[si] .VSW_PatternModifier, al

; Byte 4 -- Pattern replication factor
	xor	al,al		;<><> pattern replication factor
	mov	[si] .VSW_PatternReplicate, al

; Byte 5 -- Transition type / ME address
	mov	al,ch
	or	al,al
	jnz	VSGP_EMW1
	mov	al,Effects_Address
VSGP_EMW1:
	shl	al,1			; Move effects address
	shl	al,1			;  to upper nibble
	shl	al,1
	shl	al,1
	or	al,dl
	mov	[si] .VSW_TransME, al

; Byte 6 -- Next program source
	xor	al,al			; Preset in case of...
	cmp	cl,50			;  Fade to black command?
	jz	VSG_4a

	mov	al,To_Machine
	cmp	Trans_Type,'K'
	jnz	VSG_4
	mov	al,Keybkgnd_Src
VSG_4:	call	getxpt
VSG_4a:	mov	[si] .VSW_NextPgmSrc, al

; Byte 7 -- Next key Flags
	mov	[si] .VSW_NextKeyFlags, dh

; Subrecord Byte 1, KEY FOREGROUND SOURCE
; Retrieve the previous KEY FOREGROUND SOURCE
	xor	al,al			; Preset in case of...
	cmp	cl,50			;  Fade to black command?
	jz	VSG_5
	mov	al, [si - VLANSW_LENGTH] .VSW_KeyFore
VSG_5:	mov	[si] .VSW_KeyFore, al

; Subrecord Byte 2, KEY SOURCE (PATTERN # IF A PATTERN LIMIT)
; Retrieve the previous KEY FOREGROUND SOURCE
	mov	al, [si - VLANSW_LENGTH] .VSW_KeySrc
	mov	[si] .VSW_KeySrc, al

; Subrecord Byte 3, KEY MODIFIERS
	mov	al, [si - VLANSW_LENGTH] .VSW_KeyMods
	mov	[si] .VSW_KeyMods, al

;;	and	dh,01010000b
;;	cmp	dh,01010000b
;;	jnz	VSG_done

;..........................................................
; Second Subrecord Byte 1, Title FOREGROUND SOURCE
; Retrieve the previous Title FOREGROUND SOURCE
	xor	al,al			; Preset in case of...
	cmp	cl,50			;  Fade to black command?
	jz	VSG_6
	mov	al, [si - VLANSW_LENGTH] .VSW_TitleFore
VSG_6:	mov	[si] .VSW_TitleFore, al

; Subrecord Byte 2, Title SOURCE (PATTERN # IF A PATTERN LIMIT)
; Retrieve the previous Title FOREGROUND SOURCE
	mov	al, [si - VLANSW_LENGTH] .VSW_TitleSrc
	mov	[si] .VSW_TitleSrc, al

; Subrecord Byte 3, Title MODIFIERS
	mov	al, [si - VLANSW_LENGTH] .VSW_TitleMods
	mov	[si] .VSW_TitleMods, al

VSG_done:
	mov	bx,di
	call	Preroll_delayed
	call	_Sttime_move		; Move TC val to Sttime
	jz	VSGcx			; Bailout if null TC
	mov	dx,offset Atrans_Offset	; DX points to offset value
	cmp	byte ptr Atrans_Offset + 3,MINUS_ASCII	; Check for + or -
	jnz	VSGcpls
	call	_mpbsub			; Subtract if negative
	jmp	VSGcx
VSGcpls:call	_mpbadd			; Add if positive offset
VSGcx:

VSG_nk1:call	_VVV_compensateIN	; Compensate for preview advances
	mov	ax,[bx]
	mov	word ptr [si] .VSW_OfstTime, ax
	mov	al,2[bx]
	mov	byte ptr [si+2] .VSW_OfstTime, al
	add	si,VLANSW_LENGTH
	mov	Vlan_Swbuf_PTR,si
	add	Vlan_Swbuf_SIZ,VLANSW_LENGTH
	inc	Vlan_Swbuf_CNT
	mov	[si].VSW_TransitionDur, 0ffffh
	call	_VSW_sort
VSG_ret:ret

VLAN_SwGPIs	endp



;================================================================
VLAN_clear_switcher_Triggers	proc	near
	mov	Active_IOTYP,video_IOTYP
	call	VLAN_swclear
	mov	Active_IOTYP,audio_IOTYP
	call	VLAN_swclear
	mov	Active_IOTYP,preview_IOTYP

VLAN_swclear:
	call	_GetSXcb_Flags		; Get switcher Flags
	test	bx,SWbit_VLAN		; Check for VLAN switcher
	jz	VCLRxit

	call	_GetSXcb_SMPTEadr	; Get switcher node address
	mov	ch,bl			;  to CH
	mov	ax,offset M_node_address
	call	vtr_opt			; Select SWITHER NODE
	mov	ax,offset MSW_clear
	call	motion			; Clear Switcher Triggers
VCLRxit:ret
VLAN_clear_switcher_Triggers	endp

;================================================================
;
;		WRITE TO VLAN SWITCHER 
;
;================================================================
VLAN_switcher_write:
;;2-05-1994 
	mov	al,Active_IOTYP
	mov	Swvlan_IOTYP,al
;..
; 2-14-1994 Moved routine to VLAN_swclear
	call	VLAN_swclear
;..
	mov	si,offset Vlan_Swbuf

VWV_lp:	cmp	[si].VSW_TransitionDur,0ffffh ;Terminate
	JMP_Z	VWV_xit

;; Check to see if this is the right device
;; If not, skip this line
	mov	al,[si].VSW_IOTYP
	cmp	Swvlan_IOTYP,al
	JMP_NZ	VWVskp

	push	si
	mov	ax,offset MSW_trigger
	call	set_vtrcmd		; Set in prefix

;3-08-1993 Fixed .VSW_TransitionDur for WORD length
	mov	bx,[si].VSW_TransitionDur
	call	_make_hexword		; Send hex word TRANS DUR

; Check for audio switcher processing
	cmp	[si].VSW_IOTYP, audio_IOTYP
	jnz	VWV_nau

		mov	al,[si].VSW_TransME
		and	al,0Fh		;low nibble is transition type
		call	_make_hexbyte
		mov	al,[si].VSW_NextPgmSrc
		call	_make_hexbyte
		jmp	VWV_cma

;... Continue with video switcher records
VWV_nau:mov	al,[si].VSW_PatternNumber
	call	_make_hexbyte
	mov	al,[si].VSW_PatternModifier
	call	_make_hexbyte
	mov	al,[si].VSW_PatternReplicate
	call	_make_hexbyte

	mov	al,[si].VSW_TransME
	call	_make_hexbyte
	mov	al,[si].VSW_NextPgmSrc
	call	_make_hexbyte
	mov	al,[si].VSW_NextKeyFlags
	call	_make_hexbyte

	mov	al,[si].VSW_KeyFore
	call	_make_hexbyte
	mov	al,[si].VSW_KeySrc
	call	_make_hexbyte
	mov	al,[si].VSW_KeyMods
	call	_make_hexbyte

	mov	al,[si].VSW_TitleFore
	call	_make_hexbyte
	mov	al,[si].VSW_TitleSrc
	call	_make_hexbyte
	mov	al,[si].VSW_TitleMods
	call	_make_hexbyte

VWV_cma:mov	al,','
	call	_add_store

	push	Temp_Tc_Buf
	mov	dx,offset Tcdispbuf
	mov	bx,si
	add	bx,VSW_OfstTime
	mov	al,Frame_Flag
	push	ax
	mov	Frame_Flag,0
	call	_cnvt2tc_DS
	pop	ax
	mov	Frame_Flag,al
	pop	Temp_Tc_Buf

VWVnx:	mov	al,[bx]
	or	al,al
	jz	VWVnul

	cmp	al,'0'
	jz	VWVnxc
	cmp	al,':'
	jz	VWVnxc
	cmp	al,';'
	jnz	VWVtc
VWVnxc:	inc	bx
	jmp	VWVnx

VWVtc:	mov	al,[bx]
	inc	bx
	or	al,al
	jz	VWVsnd
	cmp	al,':'
	jz	VWVtc
	cmp	al,';'
	jz	VWVtc
	call	_add_store
	jmp	VWVtc

VWVnul:	mov	al,'0'
	call	_add_store

VWVsnd:	call	vtrcmdx
	call	vtr_answer
	pop	si
VWVskp:	add	si,VLANSW_LENGTH
	jmp	VWV_lp
VWV_xit:ret

_TEXT	ends

_DATA	segment byte public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end

