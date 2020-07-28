; Last revised: 2-22-1995, 11:12:27   (C)1989-1995 Norman H. Strassner

;VMPRINT.ASM
;Containes screen positioning/video routines
;And other screen-oriented subroutines
;-------------------------------------------
.xlist
include	VM.EQU
.xlist

extrn dirfiles:byte,dirlines:byte,edl_fcm:byte,rtcf:byte,swap_bin:byte

extrn DOS_flags:word,Ascii_Line:word,continued_msg:word,current_event:word
extrn cursor:word,edlSES:word,endofprint_msg:word
extrn file_title:word,lstfile_ovr:word,mode_pntr:word
extrn next_avail_num:word,page_msg:word,printing_msg:word,seriel_num:word
extrn start_header:word,tcdispbuf:word,temp_tc_buf:word,time_start:word
extrn tstamp_header:word,type_header:word

extrn lst_co:near,lst_init:near,no_chos_msg:near,timestamp:near

extrn _EDL2ASCII:far,_Space_Out:far
extrn _break_check:FAR,_check4edl:far,_cnvt2tc_DS:far,_delfrm:FAR,_delms:FAR
extrn _dixdly:FAR,_event_display:far,_index_storage:far,_kbd_message:far
extrn _macroindex:FAR,_macrotindex:FAR,_time_value:far,Jogger_FAR:FAR
extrn keyboard:far

_TEXT	segment word public 'CODE'
	assume	cs:_TEXT,ds:_DATA,es:eseg

Public  print_file, prntfl1, prntfl1a, prntfl2, prntfl3, printxit, pfilrc, pf0
Public  pf1, pfilni, leof, leop, print_footer, print_header, prhdr1, prhdr2
Public  pfotr, ldecout_zpad, l_DecOut, ldeclp, ldec2, listmsg_ES, listmsg
Public  listmsg1, lmsg1, lstmsgx, lcrlf

;*****************************
;  Send EDL to list device
;*****************************
print_file	proc	near
	call	_check4edl		; Bail out if no EDL
	JMP_Z	printxit

	mov	bx,offset lstfile_ovr	; Get confirmation from user
	call	no_chos_msg
	JMP_NZ	printxit

	mov	bx,offset printing_msg
	call	_kbd_message

	call	lst_init		; Init list device
	jnc	prntfl1			; Jump if OK
	ERROR	lst_dev_error, ERET_Keyboard

prntfl1:mov	dirlines,0		; No screen lines
	mov	dirfiles,0		; Use for Page number

	test	DOS_flags,ejectpg_DOSBIT
	jz	prntfl1a
	mov	al,12
	call	lst_co
prntfl1a:
	call	lcrlf
	call	lcrlf
	call	lcrlf
	mov	bx,offset file_title
	call	listmsg_ES
	call	lcrlf
	mov	bx,offset type_header
	call	listmsg
	mov	bx,es:mode_pntr		; Display EDL type
	add	bx,offset ZeroBase.E_edl_Name
	call	listmsg
	call	lcrlf

	mov	bx,offset time_start
	call	_time_value
	jz	prntfl2
	mov	bx,offset start_header
	call	listmsg
	mov	bx,offset time_start
	mov	dx,offset tcdispbuf
	mov	cl,es:edl_fcm
	call	_cnvt2tc_DS
	call	listmsg
	call	lcrlf

prntfl2:
	mov	bx,offset tstamp_header
	call	listmsg
	mov	bx,offset Ascii_Line	; Setup pointer for
	mov	temp_tc_buf,bx		;  ASCII decimal bytes
	push	bx			; Save pointer for a later display
	mov	cursor,0		; Set to upper left
	call	timestamp		; Get the time
	pop	bx			; Restore the pointer
	call	listmsg
	mov	bx,SpacePointer(8)
	call	listmsg
	mov	bx,offset edlSES
	call	listmsg

	mov	al,'#'
	call	lst_co
	mov	bx,offset seriel_num
	mov	cx,4
prntfl3:mov	al,[bx]
	inc	bx
	call	lst_co
	loop	prntfl3
	call	lcrlf

	call	lcrlf
	mov	ax,es:current_event
	push	ax
	xor	al,al
	call	pfilrc
	pop	ax
	call	_event_display
printxit:ret
print_file	endp


;================================================================
;	Print the file to the list device
pfilrc	proc	near
	cmp	ax,es:next_avail_num
	jnc	leof

	cmp	dirlines,56
	jc	pf0
	push	ax
	call	print_footer
	pop	ax
pf0:	call	_index_storage
	jc	pf1			; No leading CRLF if comment
	call	lcrlf
pf1:	call	_EDL2ASCII		; Convert edit to ASCII
	pushf
	call	listmsg
	popf
	jnc	pfilni			; No CRLF if double line
	call	lcrlf

pfilni:	mov	ah,0bh			; Check for CTRL-Break
	int	DOS
	mov	bx,offset current_event
	inc	word ptr es:[bx]
	mov	ax,es:[bx]
	jmp	pfilrc

leof:	call	lcrlf
	mov	bx,offset endofprint_msg
	call	listmsg
leop:	mov	dirlines,0
	mov	al,12
	call	lst_co
	mov	al,cr
	jmp	lst_co
pfilrc	endp

;----------------------------------------------------------------
print_footer	proc	near
	call	lcrlf
	call	lcrlf
	call	lcrlf
	push	cx

	mov	bx,offset edlSES	; Print SES version info
	call	listmsg
	mov	cx,35-22		; Subtract length of EDLSES
	call	pfotr
	pop	cx
	mov	bx,offset page_msg
	call	listmsg
	mov	bl,dirfiles
	inc	bl
	mov	dirfiles,bl
	mov	bh,0
	call	l_DecOut
	mov	cx,15
	call	pfotr
	mov	temp_tc_buf,offset Ascii_Line
	call	timestamp
	mov	bx,offset Ascii_Line
	call	listmsg
;;;	call	lcrlf
	call	leop
print_footer	endp

print_header	proc	near
	call	lcrlf
	call	lcrlf
	call	lcrlf
	mov	bx,offset file_title + 7
	mov	al,es:[bx]			; Check for title
	or	al,al
	jz	prhdr2
	cmp	al,cr
	jz	prhdr2
prhdr1:	call	listmsg_ES
prhdr2:	mov	bx,offset continued_msg
	call	listmsg
	call	lcrlf
	jmp	lcrlf

pfotr:	mov	al,' '
	call	lst_co
	loop	pfotr
	ret
print_header	endp

ldecout_zpad	proc	near
	cmp	bx,10
	jnc	l_DecOut
	mov	al,'0'
	call	lst_co
ldecout_zpad	endp

	even
l_DecOut	proc	near
	push	bx			; Save everybody
	push	dx
	push	cx
	mov	cx,0fff6h		; Conversion radix
	mov	dx,0ffffh
ldeclp:	inc	dx
	add	bx,cx
	jc	ldeclp
	add	bx,10
	xchg	bx,dx
	or	bx,bx
	jz	ldec2
	call l_DecOut	; This is recursive
ldec2:	mov	al,dl
	add	al,'0'
	call	lst_co
	pop	cx
	pop	dx
	pop	bx
	ret
l_DecOut	endp

;----------------------------------------------------------------
;message pointed to by BX out to console
listmsg_ES	proc	near
	push	es
	jmp	listmsg1
listmsg_ES	endp

listmsg	proc	near
	push	es
	mov	ax,ds
	mov	es,ax
listmsg1:
	mov	al,es:[bx]
	or	al,al
	jz	lstmsgx
	cmp	al,' '+80h
	jz	lcrlf
	cmp	al,lf
	jnz	lmsg1
	inc	dirlines
lmsg1:	call	lst_co
	inc	bx
	jmp	listmsg1
lstmsgx:pop	es
	ret
listmsg	endp


;issue crlf
lcrlf	proc	near
	push	ax
	mov	al,cr
	call	lst_co
	mov	al,lf
	call	lst_co
	pop	ax
	inc	dirlines
	ret
lcrlf	endp

_TEXT	ends

_DATA	segment word public 'DATA'

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends

	end
