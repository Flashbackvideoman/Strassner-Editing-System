; Last revised: 2-22-1995, 11:12:28   (C)1989-1995 Norman H. Strassner

;VMEXTRAS.ASM

%nolist
include VM.EQU

extrn Reel_Msg:word,_e_rel_l:far,cimsg_wrk:near

extrn onetwo_ovr:word,entereqone_ovr:word
extrn OkToAdjustTC_Flag:byte
extrn EVcmd_Flag:byte,Color_BKG:byte,Current_Machine:byte,Current_Source:byte
extrn Fullscreen_Flag:byte,Input_Flag:word,Mode_Flag:byte,Rtcf:byte
extrn Tline_Entries:byte,Tline_Flag:byte,Tline_Lines:byte,To_Machine:byte
extrn Video_Mode:byte,Vtr_Mult_Type:byte,_cmp24b:far,_mmv3_DS2ES:far

extrn Current_Event_Adr:word,_left_set2edl:far
extrn EDL_Window_Cursor:word,Swapvtr_Msg:word,Swap_Table:word
extrn atrans_qry:word,Ctrl_Astrck:word,Current_VTRS:word,Current_Event:word
extrn Cursor:word,Elaptm:word,evcmdsb_ovr:word,evcmdst_ovr:word
extrn Fps_Msg:word,Fromin_Msg:word,Fromout_Msg:word,Gcmdtype_Msg:word
extrn Gpi_Msg:word,Next_Avail_Num:word,Next_Edit:word,Nowild_Msg:word
extrn Offset_Buffer:word,onetwoboth_ovr:word,R_Tc:word,Sec_Cnt:word
extrn Record_Msg:word,Relaytype_Tbl:word,Split_Vid_Msg:word
extrn Timeline_Buffer:word,timeline_ovr:word,Timeline_Scr:word
extrn Tline_Dpos:word,tlprompt_ovr:word,Vtrs_In_Edit_Table:word,Wild_Msg:word

extrn KeyCommand_RepairEDL:near,KeyCommand_SplitScreen:near
extrn _ReCompute_EFX:far,RealTime_Trigger:near,SS_toggle:near,_check4edl:far
extrn _clear_timeline:far,_cnvt2df:far,_cnvt2df_ES:far
extrn _cnvt2nd:far,_cnvt2nd_ES:far,_Elaptm_move:far,_Entime_move:far
extrn Event_Change:near,_get_in:far,gpi_calc:near,Idx2tcf:near,kbdisp:near
extrn keythru:near,locations:near,locations:near,Machine_Change:near
extrn _mmv3byt:far,_mpbadd:far,_mpbsub:far,rdchar:near,screen_init:near
extrn _sort_timeline:far,_Sttime_move:far,switch:near,switch_bins:near
extrn tc_disp:near,_time_value:far,_tline_save:far,vtr_setinout:near
extrn clear_relays:near

extrn _A_DecOut:far,_ConOut:FAR,_DecOut:far,_EDL_display:far
extrn _Restore_Marktable:FAR,_Save_Marktable:FAR,_Space_Out:far
extrn _VTRinEdit_check:far,_Break_check:FAR,_clear_screen:FAR,_comsg:FAR
extrn _crlf:FAR,_draw_machttls:far,_evnt_dispthis:far,_index_storage:far
extrn _kbd_cln:FAR,_line_erase:FAR,_machine_disp:far,_macone:far
extrn _make_ucase:far,_mmv:far,_msgread:far,_rdnum:FAR,_savebin:far
extrn _sram_dx:FAR,_timeline_erase:FAR, _Get_prerollToBX:far
extrn _clear_tc:far,_CheckLegalPreroll:far,_TriggerBeforePrerollError:far
extrn _SaveSlavesToEditTable:far,_SayWereSettingUp:far

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg


Public  timeline_stats, TLS1, tlstat_top, TLS_again, tlstat, TLS_a, TLS_b
Public  TLS_lp, TLS_x, tlstat_TriggerTime, tlst1, tlst1a, tlst2, tlst3
Public  tlstat_AllTriggers, tlstat2, tlstatr, tlstat5, tlstat6, tlstx, tlstg
Public  tlstg1, tlstri, tlstro, tlstgv, tlstgr, tlstgrl, tlstgp, tlstga
Public  tlstat_ins_outs, tlsiolp, tlsiolr, tlsiond, tlsiopl, tlsiod, tlsio2
Public  tlstat_select, tls_cmd, tlsc_4, tls_trigger, tlstatm, tlstatx, tls_fwd
Public  tls_fw0, tls_fw1, tls_rev, tls_rv1, tls_ltx, tlstat_bottom, tls_bt0
Public  tls_nexttime, tls_nt1, tls_nt9, tls_lt1, tls_lt2, tls_lt3, tls_lt9
Public  tl_top_of_buf, tl_end_of_buf, tltvert, tleob, tleobl, Setup_TimeLine
Public  tlstnodur, Beep_Countdown, bcntlp, bcntx, event_commands, evcmds
Public  evcmds0, evcmds1, evcmds2, evcmds3, evcmds4, evcmds5, evcmds6, evcmdsj
Public  ecmdsx, ecmdnum, ecmd1, ecmd2, ecmd3, ecmd4, ecmd5, ecmd6, ecmd7, ecmd8
Public  ecmd9, ecmdx, ecmdbin, ecmdbn1, event_attach, eatt1, eatax, eatac
Public  event_detach, event_chmode, evchmagn, evchm2, evcm_b, evcm_2, evcm_2a
Public  evchmit, evchm, evchmx, event_chfcm, evchagn, evchf2, evc_b, evc_2
Public  evc_2a, evchit, evchf, evchf9, evchfn, evchfx, onetwoboth
Public  event_clrmrks, evclmr1, evclmr2, repair_display, BeepTimeBuf
Public  Fix_Reel_Change

%list

Fix_Reel_Change	proc	near

;----- Test for double line event
	mov	bx,Current_Event_Adr	; Get the edit
	FLAGBITS dblline_Fmask		; Test for dbl line (NZ)
	mov	cl,1
	jz	frchm1

;----- Prompt for line one or line two?
	call	_kbd_cln
	mov	bx,offset onetwo_ovr	;  Line 1, 2 or Both
	call	_msgread
	mov	bx,offset entereqone_ovr
	call	_msgread
	call	_rdnum
	mov	cl, al
	cmp	ax,offset Enter_xcmd		; Enter = 1
	jz	frchm1

	call	_Break_check
	jz	frcret

;----- Get a reel name
frchm1:	call	_kbd_cln
	mov	bx,offset Reel_Msg
	call	_comsg
	push	cx
	call	_e_rel_l		; Get current reel length
	call	cimsg_wrk		; Get new reel
	pop	cx
	mov	dx,bx			; DX->reel name
	jbe	frcret			; Nothing to change to

;---- Store reel in line one or line two
frchm2:	cmp	cl,2
	jnz	frchm3
	mov	bx,Current_Event_Adr	; Get the edit
	add	bx,offset line_length
	jmp	frchma

frchm3:	mov	bx,Current_Event_Adr	; Get the edit
frchma:	add	bx,offset ZeroBase.reel_lofst
	xchg	dx,bx
	call	_left_set2edl
frcret:	ret
Fix_Reel_Change	endp



;================================================================
timeline_stats	proc	near

	call	_SayWereSettingUp

	call	_Save_Marktable			; Save the mark table
	call	_ReCompute_EFX			; Recompute the workspace


	push	Current_VTRS

;________________ SETUP THE TIME LINE
	mov	Vtr_Mult_Type,V_roll
	mov	byte ptr Vtrs_In_Edit_Table,0ffh

	mov	OkToAdjustTC_Flag,FALSE

	call	Setup_TimeLine

	call	_CheckLegalPreroll
	jnc	TLS1
	call	_TriggerBeforePrerollError
;	ERROR	earlyTline_error, ERET_Return
	jmp	tlstatx

TLS1:

;________________ SETUP SCREEN
	mov	Fullscreen_Flag,0ffh
	mov	Input_Flag,INFL_timeline
	call	_clear_screen
	call	_draw_machttls		; Draw machine lables
	mov	Cursor,offset Timeline_Scr - 0100h
	norm_VIDEO FALSE,FALSE
	mov	bx,offset timeline_ovr
	call	_msgread
	mov	Cursor,offset Timeline_Scr + 0B00H
	rev_VIDEO FALSE,FALSE
	mov	bx,offset tlprompt_ovr
	call	_msgread


;----------------------------------------------------------------
; START WITH TOP OF Timeline_Buffer
tlstat_top:
	mov	Tline_Flag,0		; Clear continuation Flag
	mov	si,offset Timeline_Buffer
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1;  TC offset into
	mov	dx,offset Offset_Buffer
	call	_mmv3byt

;----------------------------------------------------------------
; FIND FIRST TRIGGER TIME TO INIT Offset_Buffer
TLS_again:
	cmp	word ptr [si].TLR_type,0 ; Check for no more timeline records
	JMP_Z	tlstatx

; Setup screen
tlstat:	mov	Tline_Dpos,si		; Save start of buffer
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1;  TC offset into
	mov	dx,offset Offset_Buffer
	call	_mmv3byt

	call	_timeline_erase
	cmp	si,offset Timeline_Buffer
	jnz	TLS_a
	call	tl_top_of_buf
	jmp	TLS_b

TLS_a:
;	cmp	si,offset Timeline_Buffer + (MAX_TIMELINES * TLINE_size)
	push	si
	call	tls_nexttime
	pop	si
	jc	TLS_a1
	call	tl_more_to_go
	jmp	TLS_b

TLS_a1:	call	tl_end_of_buf
TLS_b:	mov	dx,offset Timeline_Scr	; Init Cursor position
	mov	Tline_Lines,dh		; Useing a line counter
	mov	di,dx

TLS_lp:	call	tlstat_ins_outs
	call	tlstat_TriggerTime	; Display HEADER  in reverse video
	call	tlstat_AllTriggers	; Display all associated Triggers
	jc	TLS_x

	mov	dx,di		; Get Cursor to DX
	mov	dh,Tline_Lines	; Get # of lines
	add	dl,20		; Go to next column
	mov	di,dx		; Set DI with new Cursor
	cmp	dl,61		; Out of screen columns?
	jc	TLS_lp

TLS_x:	jmp	tlstat_select
timeline_stats	endp

;****************************************************************
; DISPLAY TRIGGER TIME HEADER
;  with SIGN using Timeline_Buffer entry at SI
;****************************************************************
; DI has Cursor
; SI points to entry in Timeline_Buffer
tlstat_TriggerTime	proc	near

	rev_VIDEO FALSE,FALSE
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1
	mov	dx,di
	mov	dh,Tline_Lines	; Get Cursor
	add	dl,4		; Inc to TC position
	mov	Cursor,dx
	mov	al,[si].TLR_sign	; AL has SIGN +/-
	or	al,al
	jnz	tlst1
	mov	al,PLUS_ASCII
tlst1:	push	ax
	call	_time_value
	pop	ax
	jnz	tlst2
	call	_Space_Out
	mov	cx,10
	mov	al,'#'
tlst1a:	call	_ConOut
	loop	tlst1a
	call	_Space_Out
	jmp	tlst3
tlst2:	call	_ConOut
	mov	cl,Rtcf
	call	tc_disp		; Display time code offset
tlst3:	ret
tlstat_TriggerTime	endp


;................................................................
; DISPLAY THE TRIGGERS FOR THE OFFSET TIME SHOWN ABOVE THEM
tlstat_AllTriggers	proc	near
	mov	ax,[si]			; Get type of trigger
	or	ax,ax			; End of Triggers?
	jnz	tlstat2
	stc
	ret

tlstat2:test	ax,TFlag_GPI		; Test for GPI register
	jnz	tlstat5
	test	ax,TFlag_PMC		; Test for PMC/SPD
	jnz	tlstat5
	test	ax,TFlag_RIN
	jnz	tlstat5
	test	ax,TFlag_ROUT
	jnz	tlstat5
	test	ax,TFlag_ATRANS		; Test for AUTOTRANS
	jnz	tlstat5
tlstatr:add	si,TLINE_size
	jmp	tlstat_AllTriggers

tlstat5:mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1;  TC offset into
	mov	dx,offset Offset_Buffer
	call	_cmp24b
	jz	tlstat6
	call	_mmv3byt
	clc
	ret	

tlstat6:mov	dx,di
	inc	dh		; Increment row
	cmp	dh,13h		; Allows for 10 subentries <><>
	jc	tlstx
	ret

tlstx:	mov	di,dx
	add	dl,3		; Inc to TC position
	mov	Cursor,dx
	dim_VIDEO FALSE,FALSE

; Display GPI information
	mov	ax,[si].TLR_type
	test	ax,TFlag_GPI		; Test for GPI register
	jnz	tlstg
	test	ax,TFlag_PMC		; Test for PMC/SPD
	JMP_NZ	tlstgp
	test	ax,TFlag_RIN
	jnz	tlstri
	test	ax,TFlag_ROUT
	jnz	tlstro
	test	ax,TFlag_ATRANS		; Test for AUTOTRANS
	JMP_NZ	tlstga
	mov	bx,offset Nowild_Msg
	call	_comsg
	jmp	tlstatr

tlstg:	mov	bx,offset Gpi_Msg
	call	_comsg
	and	ax,TFlag_regmask	; Clear Flag bit
	call	_A_DecOut		; Display GPI#
	cmp	al,10
	jnc	tlstg1
	call	_Space_Out
tlstg1:	call	_Space_Out
	mov	al,byte ptr [si].TLR_gpiflags	; Get the Flags
	test	al,byte ptr G_vltrig_mask	; Test for VLAN trigger
	jnz	tlstgr
	test	al,byte ptr G_swtrig_mask	; Test for switcher trigger
	jnz	tlstgv
	mov	bx,offset Nowild_Msg
	call	_comsg
	jmp	tlstatr

tlstri:	norm_VIDEO FALSE,FALSE
	mov	bx,offset Record_Msg
	call	_comsg
	mov	bx,offset Fromin_Msg
	call	_comsg
	clc
	jmp	tlstatr

tlstro:	norm_VIDEO FALSE,FALSE
	mov	bx,offset Record_Msg
	call	_comsg
	mov	bx,offset Fromout_Msg
	call	_comsg
	jmp	tlstatr

;................................................................
;VIDEO_TRIGGER
tlstgv:	mov	bx,offset Split_Vid_Msg
	call	_comsg
	call	_Space_Out
	mov	bl,byte ptr [si].TLR_gpicmd
	mov	bh,0
	call	_DecOut
	jmp	tlstatr

;RELAY TRIGGER
tlstgr:	mov	bl,byte ptr [si].TLR_gpicmd
	mov	bh,0
	MULTIPLY_BY RTYPE_LENGTH,BX
	add	bx,offset Relaytype_Tbl
	push	cx
	mov	cx,8
tlstgrl:mov	al,[bx]
	inc	bx
	call	_ConOut
	loop	tlstgrl
	pop	cx
	jmp	tlstatr

;PMC TRIGGER
tlstgp:	call	_Space_Out
	mov	al,[si].TLR_vtr
	call	_machine_disp
	call	_Space_Out
	mov	al,[si].TLR_speed
	call	_A_DecOut
	mov	bx,offset Fps_Msg
	call	_comsg
	jmp	tlstatr

;AUTOTRANS TRIGGER
tlstga:	norm_VIDEO FALSE,FALSE
	call	_Space_Out
	mov	bx,offset atrans_qry
	call	_msgread
	jmp	tlstatr

tlstat_AllTriggers	endp

;................................................................
tlstat_ins_outs	proc	near
	push	di
	mov	al,[si].TLR_sign	; AL has SIGN +/-
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1	;  TC offset into
	mov	ch,al			; Save sign in CH
	xor	cl,cl			; Start with record machine
	call	_Elaptm_move		; Save offset TC in Elaptm
	mov	dx,di
	mov	dh,cl			; Set to top of page
	add	dl,4
	mov	di,dx
tlsiolp:push	cx

	mov	al,cl			; Get Machine #
	or	cl,cl			; Record VTR?
	jz	tlsiolr			; Do it fur-sure
	call	_VTRinEdit_check	; Check involvement in edit
	jc	tlsio2			; Skip it if not involved

tlsiolr:call	Machine_Change
	call	_get_in
	jz	tlsio2
	call	_Sttime_move
	push	bx
	mov	bx,offset Elaptm
	call	_Entime_move
	mov	dx,bx
	pop	bx
tlsiond:pop	cx
	push	cx
	cmp	ch,MINUS_ASCII
	jnz	tlsiopl
	call	_mpbsub
	jmp	tlsiod
tlsiopl:call	_mpbadd
tlsiod:	mov	Cursor,di
	call	_Space_Out
	push	bx
	call	Idx2tcf
	pop	bx
	mov	cl,al
	norm_VIDEO FALSE,FALSE
	call	tc_disp
tlsio2:	pop	cx
	add	di,100h
	inc	cl
	cmp	cl,MAX_MACHINES
	jc	tlsiolp
	pop	di
	ret
tlstat_ins_outs	endp


;================================================================
; 		User commands for TIMELINE_STATS
;================================================================
tlstat_select	proc	near
;;	call	tl_end_of_buf
tls_cmd:mov	Cursor,1800h
	call	rdchar
	call	_Break_check
	jz	tlstatx
	cmp	ax,offset Home_key		;Top
	JMP_Z	tlstat_top
	cmp	ax,offset End_key		;Bottom
	JMP_Z	tlstat_bottom
	cmp	ax,offset Summary_xcmd
	jz	tlstatx
	cmp	ax,offset GPI_xcmd
	jz	tlstatm
	cmp	ax,offset Progspeed_xcmd
	jz	tlstatm
	cmp	ax,offset Status_xcmd
	jz	tlstatm
	cmp	ax,offset Yeskey_xcmd		;Rev
	jz	tls_rev
	cmp	ax,offset Sclst_xcmd
	jz	tls_rev
	cmp	ax,offset Nokey_xcmd		;Fwd
	jz	tls_fwd
	cmp	ax,offset Scnxt_xcmd		
	jz	tls_fwd
	cmp	ax,offset Vbv_xcmd		; Trigger?
	jz	tls_trigger

	call	keythru

tlsc_4:	jmp	tls_cmd

tls_trigger:
	call	RealTime_Trigger
	jmp	tls_cmd

tlstatm:call	_macone
tlstatx:pop	ax			; Restore machines
	push	ax
	call	Machine_Change		; Set Current_Source
	pop	ax
	mov	al,ah
	call	Machine_Change		; Set Current_Machine
	call	_Restore_Marktable
	call	screen_init
	call	clear_relays
	ret

tls_fwd:
;;	mov	Tline_Dpos,si		; Save start of buffer
;;	test	Tline_Flag,1		; Continuation?
;;	jnz	tls_fw0
	mov	si,Tline_Dpos
	call	tls_nexttime
	jc	tls_fw1
tls_fw0:and	Tline_Flag,11111110b	; Clear continuation Flag
	jmp	TLS_again
tls_fw1:jmp	tls_cmd

tls_rev:mov	si,Tline_Dpos
	cmp	si,offset Timeline_Buffer ; If already at top of buffer
	jz	tls_fw1			  ;  then don't do anything

	call	tls_lt1		; Find previos change
	jc	tls_ltx		; Go if top of list
	call	tls_lt1		; Find previous change again
	jc	tls_ltx
	add	si,TLINE_size
tls_rv1:jmp	TLS_again

tls_ltx:jmp	tlstat_top

tlstat_bottom:
	mov	Tline_Dpos,si		; Save start of buffer
	test	Tline_Flag,1		; Continuation?
	jnz	tls_bt0
	call	tls_nexttime
	jnc	tlstat_bottom
tls_bt0:sub	si,TLINE_size		; Move back to last line
	and	Tline_Flag,11111110b	; Clear continuation Flag
	jmp	TLS_again


; Find the next different offset time in Timeline_Buffer
; Use SI as the starting point to look
; Return either with SI pointing to the next line, or
; C = 1 if no more found
tls_nexttime:
	mov	si,Tline_Dpos
	mov	ax,[si]		; Try to get next Flag
	or	ax,ax		; Any more?
	jz	tls_nt9		; Return with Carry set
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1
	mov	dx,offset Offset_Buffer
	call	_mmv3byt
tls_nt1:add	si,TLINE_size
	mov	ax,[si]
	or	ax,ax
	jz	tls_nt9
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1
	call	_cmp24b
;;	jae	tls_nt1
	jz	tls_nt1
	clc
	ret
tls_nt9:stc
	ret

; Go backwards looking for new match
tls_lt1:cmp	si,offset Timeline_Buffer	; Alread at top of buffer?
	jz	tls_lt9				; Return with Carry set
	mov	bx,si				; Move current line's
	add	bx,offset ZeroBase.TLR_exectime + 1		;  TC offset into
	mov	dx,offset Offset_Buffer		;  the Offset_Buffer
	call	_mmv3byt
tls_lt2:sub	si,TLINE_size			; Index to previous line
	mov	bx,si
	add	bx,offset ZeroBase.TLR_exectime + 1
	call	_cmp24b
	jnz	tls_lt3
	cmp	si,offset Timeline_Buffer
	jz	tls_lt9
	jmp	tls_lt2
tls_lt3:clc
	ret
tls_lt9:stc
	ret

tl_top_of_buf:
	mov	dx,offset Timeline_Scr
	mov	al,16
	jmp	tltvert

tl_more_to_go:
	mov	dx,offset Timeline_Scr
	mov	dl,79
	mov	al,16
	jmp	tltvert

tl_end_of_buf:
	mov	dx,offset Timeline_Scr
	mov	dl,79
	mov	al,17

tltvert:rev_VIDEO FALSE,TRUE
	mov	cx,11
tleob:	push	es
	push	si
	push	ax
	call	_sram_dx
	pop	ax
	mov	ah,Video_Mode
	or	ah,Color_BKG
tleobl:	mov	es:[di],ax
	add	di,160
	loop	tleobl
	dim_VIDEO FALSE,TRUE
	pop	si
	pop	es
	ret
tlstat_select	endp


;================================================================
Setup_TimeLine	proc	near
	call	_clear_timeline		; Clear out the time line
	mov	Tline_Entries,0		;  and its entry Count
	call	_Get_prerollToBX
	mov	ax,TFlag_RIN
	call	_tline_save

	mov	bx,offset R_Tc.tcDUR
	call	_time_value
	jz	tlstnodur

	call	_Elaptm_move
	call	_Get_prerollToBX
	mov	dx,bx
	mov	bx,offset Elaptm
	call	_mpbadd
	mov	ax,TFlag_ROUT
	call	_tline_save
tlstnodur:
	call	vtr_setinout		; Also calls WriteAllSpeeds
	call	clear_relays
	mov	al,FALSE		; Don't really set the relays up
	call	gpi_calc
	mov	al,To_Machine
	mov	al,TRUE			; Sort by unadjusted time
	call	_sort_timeline
	ret
Setup_TimeLine	endp

Beep_Countdown	proc	near
	; Start beeping at one second
	mov	bx,offset Sec_Cnt
	mov	dx,offset BeepTimeBuf
	call	_mmv3byt

bcntlp:	call	_Get_prerollToBX	; Get preroll
	mov	dx,offset Elaptm	; Holding buffer for Preroll
	call	_mmv3byt
	mov	dx,bx
	mov	bx,offset BeepTimeBuf
	call	_cmp24b			; BX -> timer, DX -> preroll
	ja	bcntx			; If timer  > Preroll, exit

	push	bx			; Save BeepTimeBuf pointer
	mov	dx,bx
	mov	bx,offset Elaptm
	call	_mpbsub
	; Set time as the preroll - BeepTimeBuf
	mov	ax,TFlag_Beeper		; Add this beep to the countdown
	call	_tline_save
	pop	bx
	mov	dx,offset Sec_Cnt
	call	_mpbadd			; Add a second to Elaptm

	jmp	bcntlp			; If Elaptm < Preroll, do again
bcntx:	ret

Beep_Countdown	endp

;================================================================
;================================================================
;			EVENT COMMANDS
;================================================================
;================================================================
; User commands for special EDL repair
event_commands	proc	near
	mov	al,Mode_Flag
	push	ax			; Save current mode Flag

	call	_check4edl		; Is there really one?
	JMP_Z	ecmdsx

evcmds:	rev_VIDEO FALSE,FALSE
	mov	bx,EDL_Window_Cursor
	mov	Cursor,bx
	mov	bx,offset evcmdst_ovr
	call	_msgread

	mov	bx,EDL_Window_Cursor
	add	bx,600h
	mov	Cursor,bx
	mov	bx,offset evcmdsb_ovr
	call	_msgread

evcmds0:call	_kbd_cln
	dim_VIDEO FALSE,FALSE
	call	kbdisp
	call	rdchar
	cmp	ax,offset Escape_xcmd
	jnz	evcmds1
	jmp	ecmdsx

evcmds1:cmp	ax,offset Colonplus_xcmd
	jnz	evcmds2
	jmp	ecmdnum
evcmds2:cmp	ax,offset Ctrl_Astrck
	jnz	evcmds3
	jmp	ecmdsx
evcmds3:cmp	ax,offset Enter_xcmd
	jnz	evcmds4
	jmp	ecmdsx
evcmds4:cmp	ax,offset Bins_xcmd
	jnz	evcmds5
	jmp	ecmdbin
evcmds5:cmp	Fullscreen_Flag,0ffh	;
	jnz	evcmds6

	call	KeyCommand_SplitScreen
	jz	evcmdsj
	jmp	ecmdx

evcmds6:call	KeyCommand_RepairEDL
	jnz	ecmdx

evcmdsj:mov	EVcmd_Flag,0ffh
	call	[si]
	jmp	evcmds

ecmdsx:	pop	ax
	mov	Mode_Flag,al		; Restore mode pointer
	mov	ax,es:Current_Event
	call	_EDL_display
	ret

ecmdnum:call	_kbd_cln
	mov	bx,offset Gcmdtype_Msg
	call	_comsg
	call	_rdnum			; Get a character inputted
	JMP_C	evcmds

ecmd1:	cmp	al,1
	jnz	ecmd2
	call	event_chmode		; Alter mode
	jmp	ecmdx

ecmd2:	cmp	al,2
	jnz	ecmd3
	call	event_chfcm		; Alter Source FCM
	jmp	ecmdx

ecmd3:	cmp	al,3
	jnz	ecmd4
	call	Event_Change
	jmp	ecmdx

ecmd4:	cmp	al,4
	jnz	ecmd5
	call	Fix_Reel_Change
	jmp	ecmdx

ecmd5:	cmp	al,5
	jnz	ecmd6
	jmp	ecmdx

ecmd6:	cmp	al,6
	jnz	ecmd7
	jmp	ecmdx

ecmd7:	cmp	al,7
	jnz	ecmd8
	call	event_detach
	jmp	ecmdx

ecmd8:	cmp	al,8
	jnz	ecmd9
	call	event_attach
	jmp	ecmdx

ecmd9:	cmp	al,9
	jnz	ecmdx

ecmdx:	call	repair_display
	jmp	evcmds

event_commands	endp

;----------------------------------------------------------------
; Switch bins
ecmdbin	proc	near
	cmp	Fullscreen_Flag,0ffh	; See if SPLIT SCREEN active
	jnz	ecmdbn1			; Skip if NOT
	call	_evnt_dispthis
	call	SS_toggle
	jmp	evcmds

ecmdbn1:call	switch_bins
	jmp	evcmds
ecmdbin	endp

;----------------------------------------------------------------
; Attach the current event with the next event.
; Next event must not be a comment
event_attach	proc	near
	mov	ax,es:Current_Event
	call	_index_storage
	jc	eatac			; Bail out if comment
	mov	dx,es:[bx].ednum_lofst	; Get edit number
	inc	ax			; Set for next event

	FLAGBITS dblline_Fmask		; Test for dbl line
	jnz	eatax			; Bail out if it already is
	call	_index_storage
	jc	eatax			; Bail out if comment
	FLAGBITS dblline_Fmask		; Cannot make three line edits
	jnz	eatax			; Bail out if already double line

	call	_savebin			; Protect the bin

	cmp	es:byte ptr [bx].type_lofst,'C'
	jnz	eatt1
	or	es:word ptr [bx].Flags_lofst,split_Fmask ; Set split mask
eatt1:	mov	es:[bx].ednum_lofst,dx	; 2nd line number = 1st line number
	dec	ax
	call	_index_storage
	or	es:word ptr [bx].Flags_lofst,dblline_Fmask
	ret

eatax:	dec	ax
	call	_index_storage
eatac:	ret
event_attach	endp

;----------------------------------------------------------------
; Detach events which were wrongly married together
; Event must be a dbl line event
; 2nd line must have split attribute
event_detach	proc	near
	mov	ax,es:Current_Event
	call	_index_storage
	FLAGBITS dblline_Fmask		; Test for dbl line
	inc	ax			; Go to next event
	jz	eatax

	call	_index_storage
	FLAGBITS split_Fmask		; Check for split mask
	jz	eatax		; Bail out if not

; Conditions met, clear split_Fmask in 2nd line and
;  clear dblline_Fmask in 1st line.
	and	es:word ptr [bx].Flags_lofst,not split_Fmask
	mov	dx,es:Next_Edit
	mov	es:[bx].ednum_lofst,dx
	inc	es:word ptr Next_Edit
	dec	ax
	call	_index_storage
	and	es:word ptr [bx].Flags_lofst,not dblline_Fmask
	ret
event_detach	endp

;----------------------------------------------------------------
; Change edit mode type to current mode
event_chmode	proc	near
	mov	ax,es:Current_Event
	call	_index_storage
	jc	evchmx

	FLAGBITS dblline_Fmask			; Double line?
	jz	evchmit				;  just execute single line
	cmp	es:byte ptr line_length + [bx].type_lofst,'C'
	jz	evcm_b				; Do both lines if split

evchmagn:
	call	onetwoboth
	jnc	evchm2
	cmp	ax,offset Enter_xcmd		; Enter = 1
	jz	evchmit

	call	_Break_check
	jz	evchmx
	call	_make_ucase
	cmp	al,'B'				; B = both
	jz	evcm_b
	jmp	evchmagn
evchm2:	cmp	al,2
	jz	evcm_2
	cmp	al,1
	JMP_Z	evchit
	jmp	evchmagn

evcm_b:	call	_savebin
	call	evchm
	jmp	evcm_2a
evcm_2:	call	_savebin
evcm_2a:inc	es:word ptr Current_Event
	call	evchm
	dec	es:word ptr Current_Event
	ret

evchmit:call	_savebin
evchm:	mov	ax,es:Current_Event
	call	_index_storage
	mov	al,Mode_Flag
	mov	es:byte ptr [bx].mode_lofst,al	; do for Split_Mode, too
evchmx:	ret
event_chmode	endp

;----------------------------------------------------------------
; Change FCM for source
event_chfcm	proc	near
	IF PAL
	RET
	ENDIF

	mov	ax,es:Current_Event		; Index to current event
	call	_index_storage
	JMP_C	evchfx				; Bail out if comment
	FLAGBITS dblline_Fmask			; Double line?
	jz	evchit				;  just execute single line

	cmp	es:byte ptr line_length + [bx].type_lofst,'C'
	jz	evc_b				; Do both lines if split
evchagn:call	onetwoboth
	jnc	evchf2
	cmp	ax,offset Enter_xcmd		; Enter = 1
	jz	evchit
	call	_Break_check
	jz	evchfx
	call	_make_ucase
	cmp	al,'B'				; B = both
	jz	evc_b
	jmp	evchagn
evchf2:	cmp	al,2
	jz	evc_2
	cmp	al,1
	jz	evchit
	jmp	evchagn

evc_b:	call	_savebin
	call	evchf
	jmp	evc_2a
evc_2:	call	_savebin
evc_2a:	inc	es:word ptr Current_Event
	call	evchf
	dec	es:word ptr Current_Event
	ret

evchit:	call	_savebin
evchf:	mov	ax,es:Current_Event
	call	_index_storage
	mov	dl,es:byte ptr [bx].ptcd_lofst
	cmp	dl,NDF_CHAR
	mov	dl,DF_CHAR
	jz	evchf9
	mov	dl,NDF_CHAR
evchf9:	mov	es:byte ptr [bx].ptcd_lofst,dl
	add	bx,offset ZeroBase.pin_lofst
	cmp	dl,NDF_CHAR
	jz	evchfn
	call	_cnvt2nd_ES
	add	bx,3
	call	_cnvt2nd_ES
	ret

evchfn:	call	_cnvt2df_ES
	add	bx,3
	call	_cnvt2df_ES
evchfx:	ret

onetwoboth:
	push	bx				; Ask for
	mov	bx,offset onetwoboth_ovr	;  Line 1, 2 or Both
	call	_kbd_cln
	call	_msgread
	call	_rdnum
	pop	bx
	ret
event_chfcm	endp


;----------------------------------------------------------------
; Clear all event markers
event_clrmrks	proc	near
	call	_savebin
	push	es:Current_Event
	mov	ax,1
evclmr1:call	_index_storage
	jc	evclmr2
	and	es:word ptr [bx].Flags_lofst,not sort_Fmask
evclmr2:inc	ax
	cmp	ax,es:Next_Avail_Num
	jnz	evclmr1
	pop	es:Current_Event
	ret
event_clrmrks	endp

repair_display	proc	near
	mov	EVcmd_Flag,0ffh
	mov	ax,es:Current_Event
	call	_EDL_display
	ret
repair_display	endp


_TEXT	ends

_DATA	segment byte public 'DATA'
BeepTimeBuf	db	3 dup(0)
_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
