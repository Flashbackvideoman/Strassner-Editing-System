; Last revised: 2-22-1995, 11:12:28   (C)1989-1995 Norman H. Strassner
; VMSCRIPT.ASM

include vm.equ
include asmmacro.inc
;;include vmmsg.equ

extrn Available_Bins:byte,Bottom_Bin:byte,Hardware_Delay:byte,Rtcf:byte
extrn Swap_Bin:byte,Top_Bin:byte,Active_Bin:byte

extrn Alreadyhere_Msg:word,Ascii_Line:word,Current_EDL:word
extrn Authcr:word,Author:word,Bin_Table:word,CMDLINE_OPTS:word,Comspec:word
extrn Current_EIF:word,Cursor:word,DTA:word,Default_File:word,Dflts_Area:word
extrn Dflts_Length:word,Dos_Cmd:word,EIF_Ext:word,EIFfile_Buf:word
extrn Editlist_File:word,Edl_Seg:word,Fcb:word,Hardware_Flags:word
extrn Home_Path:word,INI_Ext:word,INIfile_Buf:word,Int1c_Adr:word,Memory:word
extrn Memory_Len:word,Msg_Seg:word,Nodos_Msg:word,OVRFILE_size:word
extrn Paths:word,Pathspec:word,Pause_Msg:word,PosID:word,Psp_Seg:word
extrn Relaytype_Tbl:word,RunMacro_File:word,RunningCMD_Buf:word
extrn RunningCMD_Cnt:word,SavedMemSize:word,Screen_Seg:word,Script_File:word
extrn Seriel_Num:word,TCM_Ext:word,TCMfile_Buf:word,Temp_Macro:word
extrn Video_Seg:word,Videocard_Msg:word,Videoram:word,Work_Event:word
extrn badscript_ovr:word,initializing_ovr:word,newdflts_ovr:word

extrn Goaway:far
extrn Keyboard_Break:far,ToneOff_interrupt:far,_Bin_Hdr:far,_DecOut:far
extrn _Dflts2Disk:far,_FindRunningSoftware:far,_SaveLoadFile_AHfunc:far
extrn _SaveLoadFile_Close:far,_SaveLoadFile_Open:far
extrn _SetEdlBinFormatPointer:far,_Set_AUXBLACK:far,_Space_Out:far
extrn __init_filewrite:far,_add_backslash:far,_adv2chr:far,_adv2spc:FAR
extrn _cmpchr:far,_comsg:FAR,_convert2bin:far,_dfltver_check:far
extrn _error_bell:FAR,_find_file:far,_index2bin:FAR,_kbd_cln:FAR
extrn _loadall_macros:far,_macsaver:far,_make_ucase:far,_mmv:far
extrn _move_subdir:far,_msgread:far,_opn_ovl:far,_path_extract:far
extrn _read_line:far,_stash_AUTOsubdir:far,_stash_EDLsubdir:far
extrn _stash_TCMsubdir:far,_stash_TMPsubdir:far,_stash_VMEsubdir:far
extrn _stash_homesubdir:far

scrseg	segment word public 'ENTRY'
	assume	cs:scrseg,ds:_DATA,es:eseg

Public _PROGRAM_INIT,_stash_environs,__init_defaults,__READ_SCRIPTS


;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;
;	this segment is is used once at run time and then
; reformatted for use as the VIDEO SCREEN PRE-WRITE segment
;
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************
;****************************************************************

;****************************************************************
; BP = main Code Segment
_PROGRAM_INIT	PROC	FAR

	mov	ds,ax			; AX has data segment
	mov	es,dx			; BX has BIN1
	mov	Edl_Seg,dx

	if DEBUGGER
	mov	Debug_Seg,dx		; Set bin1 for debug
	endif

	mov	Screen_Seg,cx
	mov	Msg_Seg,bx

	mov	cx,25
pgmscr:	mov	dx,offset Authcr
	mov	ah,9
	int	DOS
	loop	pgmscr
	mov	dx,offset Author	; Author, Author
	mov	ah,9
	int	DOS

	mov	ah,30h			; Get DOS version
	int	DOS
	cmp	al,3			; Version 3 or above?
	jae	pgmrng
	mov	dx,offset Nodos_Msg
	mov	ah,9
	int	DOS
	mov	ax,4C01h
	int	DOS

pgmrng:	call	_FindRunningSoftware
	jnc	verok
	mov	dx,offset Alreadyhere_Msg
	mov	ah,9
	int	DOS
	mov	ax,4C01h
	int	DOS


; Clear out Memory storage area
verok:	push	ds
	pop	es
	mov	di,offset Memory
	mov	cx,offset Memory_Len	;changed to offset
	xor	ax,ax
	cld
	rep stosw

; Move PSP to top of our data seg
	push	ds
	mov	ax,ds
	mov	es,ax			; Extra seg = data seg
	mov	ax,bp
	sub	ax,10h
	mov	ds,ax			; Dat_TEXT = PSP
	mov	cx,80h			; Move 256 bytes
	mov	si,0
	mov	di,0
	repnz	movsw
	pop	ds


; Trim Memory requirements to the top of the last EDL segment (GSEG)
trimmem:mov	ah,62h			; Get PSP address
	int	DOS
	mov	Psp_Seg,bx		; PSP address to Psp_Seg
	mov	es,bx
	mov	ax,bx
	mov	bx,Edl_Seg		; Get Memory allocation
	sub	bx,ax			; Length = Edl_Seg - psp

	xor	cl,cl			; Clear counter

trmmem1:add	bx,1000h		;  + ( 1000h paras * # bins )
	mov	ah,4ah			; Modify Memory allocation
	int	DOS			; Carry set if failed
	jc	trmmem2
	inc	cl			; Increment Count
	call	format_bin
	cmp	cl,maxbins
	jnz	trmmem1

trmmem2:mov	Available_Bins,cl
	mov	Swap_Bin,cl
	mov	Active_Bin,1
	mov	Top_Bin,1
	mov	Bottom_Bin,2

	mov	al,1
	call	_index2bin
	mov	Active_Bin,al
	mov	Edl_Seg,es

	mov	al,Available_Bins
	mov	byte ptr SavedMemSize + 2,al	; # of 1mb segments
	mov	word ptr SavedMemSize,offset OVRFILE_size ; Plus length of overlay

	call	retud			; Get/stash current Drive and path
	call	_stash_homesubdir	; Store the subdirectory, too
	call	_stash_EDLsubdir	;  as the first line default
	call	_stash_TCMsubdir
	call	_stash_VMEsubdir
	call	_stash_AUTOsubdir
	call	_stash_TMPsubdir
	call	 FAR PTR _stash_environs		; Get COMMAND.COM location

; Check for mono graphics board.  If found, use DMA to screen
	mov	ah,15
	int	10h
	mov	bx,0b000h		; Default to monochrome
	cmp	al,7
	jz	scrs1
	mov	bx,0b800h		; Color adaptor
	jc	scrs1
	mov	bx,0a000h		; EGA card 1
	cmp	al,15
	jz	scrs1
	mov	bx,0a800h		; EGA card 2
	cmp	al,13
	jnc	scrs1
	mov	dx,offset Videocard_Msg
	mov	ah,9
	int	DOS
	mov	ax,4c02h
	int	DOS

scrs1:	mov	Videoram,bx		; Save ram screen address
	mov	Video_Seg,bx

; Set CTRL-C and CTRL-Break handler address
	push	ds
	mov	ah,25h
	mov	al,23h
	mov	ds,bp
	mov	dx,offset Keyboard_Break
	int	DOS
	pop	ds

	push	es
	mov	es,bp
	mov	bx,offset PosID		; Move the seriel number
	mov	si,offset Seriel_Num	;  to the data segment
	mov	cx,16			;  header
ssnlp:	mov	al,es:[bx]
	mov	[si],al
	inc	bx
	inc	si
	loop	ssnlp
	pop	es


;----------------------------------------------------------------
; Set interrupt 71h (IRQ9) for TONE TIMER
	push	es
	push	ds
	mov	ax,3500h + BEEPERINT	; Get old critical error address
	int	DOS		;  from DOS to ES:BX
	mov	Int1c_Adr,bx
	mov	Int1c_Adr +2,es

	mov	ax,seg ToneOff_interrupt
	mov	ds,ax
	mov	dx,offset ToneOff_interrupt
	mov	ax,2500h + BEEPERINT	; Set new critical error address
	int	DOS
	pop	ds		; Restore saved regs
	pop	es


; Open and load overlay file
	call	_opn_ovl

	blinkrev_VIDEO	FALSE,FALSE
	mov	Cursor,1800h
	mov	bx,offset initializing_ovr
	call	_msgread

; Move the default EDITLIST Name to Current_EDL
	mov	bx,offset Editlist_File
	mov	dx,offset Current_EDL
	mov	ch,9
	call	_mmv

	call	_Set_AUXBLACK		; Set proper Aux and Black reels

	RET
_PROGRAM_INIT	ENDP

;================================================================
;	CLEAR AND FORMAT EDL BIN WITH HEADER AND NULL EDL
;================================================================
; ENTER: BX = Paragraph offset from ES:0
;	 CL = Bin number
format_bin:
	push	es
	push	bx
	mov	ax,es
	sub	ax,1000h		; Subtract size of bin
	add	bx,ax
	mov	al,cl
	cbw
	dec	al
	shl	ax,1
	mov	si,offset Bin_Table
	add	si,ax
	mov	[si],bx
	mov	es,bx			; Set segment
	call	_Bin_Hdr
	pop	bx
	pop	es
	ret

;================================================================
;		GET CURRENT Drive AND DIRECTORY
;================================================================
; ENTER: Nothing
; Exit:	 Ascii_Line has subdirectory
;	 SI points to Ascii_Line
;	 CL has Drive designator
retud:	mov	ah,19h
	int	DOS
	mov	cl,al			; Save Drive designator
	add	al,'A'			; 0=A:, 1=B:, etc
	mov	ah,':'
	mov	si,offset Ascii_Line
	push	si			; Save address of subdir
	mov	[si],ax			; Save "d:"
	inc	si
	inc	si
	mov	byte ptr [si],'\'	; Stash a backslash
	inc	si			; Point to start of subdir string
	mov	dl,0			;Default Drive
	mov	ah,47h			;get directory
	int	DOS
	pop	si
	ret


;================================================================
; Locate (from the PSP offset 2ch) the COMMAND.COM path
_stash_environs	proc	far
	push	es
	mov	bx,2ch			; Get segment for environment string
	mov	ax,[bx]
	mov	es,ax			;  to ES

	xor	bx,bx
	mov	si,offset Dos_Cmd	; Where to put it and
	mov	dx,offset Comspec	; What to look for
	mov	ch,8			; Length of find string
	call	envfndr			; Find environment string
	mov	cx,offset pathname_length ; how long is enough
stenv5:	mov	al,es:[bx]		; Store the Comspec string
	mov	[si],al
	inc	bx
	inc	si
	or	al,al
	loopnz	stenv5

; Do for path spec
	xor	bx,bx
	mov	si,offset Paths		; Where to put it and
	mov	dx,offset Pathspec	;  what to look for
	mov	ch,5
	call	envfndr			; Find environment string

stpth4:	mov	al,es:[bx]		; Store the Comspec string
	cmp	al,';'
	jnz	stpth5
	mov	byte ptr [si],0
	inc	bx
	inc	si
	jmps	stpth4

stpth5:	mov	[si],al
	inc	bx
	inc	si
	or	al,al
	jnz	stpth4
	mov	byte ptr [si],0ffh	; Signal end of Paths
	pop	es
	ret

_stash_environs	endp

;................................................................
envfndr:cmp	byte ptr es:[bx],0
	jz	envfnd4			; Jump if absolutely NO ENVIRONMENT
	call	_cmpchr		; Test for string
	jz	envfnd3			; Jump if found

envfnd2:inc	bx			; Not found, Increment to
	cmp	byte ptr es:[bx],0	;  next string after the
	jnz	envfnd2			;  one just searched.
	inc	bx
	jmp	envfndr

envfnd3:mov	cl,ch
	mov	ch,0
	add	bx,cx			; Index past the environment prefix
envfnd4:ret


;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
;================================================================
__init_defaults	proc	far
	call	CMD_line		; Parse command line options
	call	_load_defaults_file	; Load default file
	call	 FAR PTR __READ_SCRIPTS		; Read script file

;... Set defaults according to CMDLINE_OPTS bits
	test	CMDLINE_OPTS,MacroSubdir_BIT
	jz	inid0
	mov	si,offset TCMfile_Buf
	call	_stash_TCMsubdir

inid0:	test	CMDLINE_OPTS,RunMacro_BIT
	jz	inidr1
	mov	dx,offset RunMacro_File
	call	_SaveLoadFile_Open	; Open file, read only, save handle
	jc	inidr
	call	_loadall_macros
	mov	cx,offset Macro_xcmd
	call	macappend

	test	CMDLINE_OPTS,AutoMacro_BIT
	jz	inidr1
	jmp	inidr1a

inidr1:	test	CMDLINE_OPTS,AutoMacro_BIT
	jz	inidr
	mov	cx,offset Macro_xcmd
	call	macappend
inidr1a:mov	cx,0ff30h
	call	macappend

inidr:	ret
__init_defaults	endp

macappend:
	mov	si,offset RunningCMD_Buf
	lodsw					; Get length of CMD
	add	si,ax				; Point to last command in buf
	mov	[si],cx
	inc	RunningCMD_Buf
	inc	RunningCMD_Buf
	inc	RunningCMD_Cnt
	inc	RunningCMD_Cnt
	ret

;================================================================
;Check for presence of command line defaults file
CMD_line:
	mov	bx,offset DTA		; BX points to start of buffer
	mov	al,[bx]			; Get length
	or	al,al			; Check for no command line
	JMP_Z	CMDoptx
	inc	bx
	cbw
	mov	si,ax
	mov	byte ptr [si + bx],0	; Terminate the command with null bytes
	call	adv2cmd			; Find next non-space or EOL
	JMP_Z	CMDoptx			; Bail out if no command line

	cmp	al,'/'
	jz	CMDOpt0
	cmp	al,'?'
	jz	CMDhlp

; Move DEFAULT FILENAME to EIFfile_Buf
CMDfil:	call	_adv2chr
	mov	si,offset EIFfile_Buf	; EIFfile_Buf gets DEFAULT FILENAME
	mov	dx,offset EIF_Ext	; Move the "EIF" extension
	call	MoveOptWithEXT
	or	CMDLINE_OPTS,DefaultFile_BIT

CMDOpt: inc	bx			; Increment to next byte
;................
CMDOpt0:call	_adv2chr		;  and to next character
	JMP_Z	CMDoptx

	cmp	al,';'			; Done on comments
	JMP_Z	CMDoptx

	cmp	al,'/'			; Options?
	JMP_NZ	CMDoptx
	call	adv2nxt		; Get next character after '/'
	JMP_Z	BadCMDtail

	call	_make_ucase

	cmp	al,'?'
	jz	CMDhlp
	cmp	al,'H'			; Help?
	jnz	CMDOpt1

CMDhlp:	push	ds
	push	cs
	pop	ds
	mov	dx,offset cmdlineopts_msg
	mov	ah,9
	int	DOS
	pop	ds
	jmp	Goaway

;................
CMDOpt1:cmp	al,'I'			; Use specified INI FILE?
	jnz	CMDOpt4
	call	adv2nxt
	JMP_Z	BadCMDtail
	mov	si,offset INIfile_Buf	; Use INIfile_Buf as buffer
	mov	dx,offset INI_Ext	; Move the "EIF" extension
	call	MoveOptWithEXT		; Move string from BX to SI
	or	CMDLINE_OPTS,ScriptFile_BIT
	jmp	CMDOpt

;................
CMDOpt4:cmp	al,'E'			; Use specified EDL subdirectory?
	jnz	CMDOpt5
	call	adv2nxt
	JMP_Z	BadCMDtail
	mov	si,offset Work_Event	; Use Work_Event as buffer
	call	MoveOptString		; Move string from BX to SI
	or	CMDLINE_OPTS,DefaultDir_BIT
	jmp	CMDOpt

CMDOpt5:cmp	al,'F'			; Specified file?
	jnz	CMDOpt6
	call	adv2nxt
	jz	BadCMDtail
	jmp	CMDfil

CMDOpt6:cmp	al,'M'			; Execute default macro file?
	jnz	CMDOpt7
	call	adv2nxt
	jz	BadCMDtail
	mov	dx,offset TCMfile_Buf
	call	_path_extract		; C=1 if no subdir
	jc	CMDopt6a
	or	CMDLINE_OPTS,MacroSubdir_BIT
CMDopt6a:
	mov	si,offset RunMacro_File ; Use Work_Event as buffer
	mov	dx,offset TCM_Ext
	call	MoveOptWithEXT		; Move string from BX to SI
	or	CMDLINE_OPTS,RunMacro_BIT
	jmp	CMDOpt

CMDOpt7:cmp	al,'*'			; Auto macro execution?
	jnz	CMDOpt8
	or	CMDLINE_OPTS,AutoMacro_BIT
	jmp	CMDOpt

CMDOpt8:cmp	al,MINUS_ASCII			; Turn off an option?
	jnz	CMDOpt9
	call	adv2nxt
	or	al,al			; End-of-the-line?
	jz	CMDOpt9			;  Ignore it if so
	cmp	al,'/'			; Another slash?
	JMP_Z	CMDOpt0			;  Ignore if so
	call	_make_ucase
	cmp	al,'I'			; No INI file?
	jnz	CMDo8a
	or	CMDLINE_OPTS,NoScriptFile_BIT
	jmp	CMDOpt
CMDo8a:	jmp	CMDOpt

CMDOpt9:	; /S set speed command has been deleted

CMDOpt10:
	cmp	al,'W'	; Windows compatibility?
	jnz	CMDOpt11
	or	CMDLINE_OPTS,MSWINcompat_BIT
	jmp	CMDOpt

CMDOpt11:
;................................................................
; Exit from this routine
CMDoptx:mov	byte ptr DTA,0
	ret

BadCMDtail:
	ret

MoveOptString:
	mov	ah,0
MOSagn:	mov	al,[bx]
	or	al,al
	jz	MOS_x
	cmp	al,' '
	jz	MOS_x
	cmp	al,'.'
	jnz	MOS_1
	mov	ah,al
MOS_1:	mov	[si],al
	inc	bx
	inc	si
	jmp	MOSagn
MOS_x:	mov	byte ptr [si],0
	ret

; Enter with BX having string to move
; DX has extension
MoveOptWithEXT:
	call	MoveOptString		; Move string from BX to SI
	cmp	ah,'.'
	jz	MOWEx
	push	bx
	mov	bx,si
	mov	byte ptr [bx],'.'
	inc	bx
	mov	si,dx
	call	_move_subdir
	pop	bx
MOWEx:	ret

;================================================================
; Initialization of default area
_load_defaults_file:
	mov	bx,offset Current_EIF	; Buffer to use
	test	CMDLINE_OPTS,DefaultFile_BIT
	jz	ldf1
	mov	si,offset EIFfile_Buf	; Filename is in EIFfile_Buf
	call	_move_subdir
	jmp	ldf2
ldf1:	mov	si,offset Home_Path	; Use the DEFAULT.EIF file
	call	_move_subdir
	call	_add_backslash
	mov	si,offset Default_File
	call	_move_subdir
	mov	byte ptr [bx],'.'
	inc	bx
	mov	si,offset EIF_Ext	; Move the "EIF" extension
	call	_move_subdir

ldf2:	mov	dx,offset Current_EIF
	call	_SaveLoadFile_Open	; Open file, read only, save handle
	jc	inid_make		; Make the defaults file if not found

	call	_dfltver_check		; Check for proper DEFAULT version
	jz	inid3
	call	_SaveLoadFile_Close
	mov	dx,offset Current_EIF
	jmp	inid_make

; Read in the rest of the default file
inid3:	mov	dx,offset Dflts_Area + 80h	; Top of defaults area
	mov	cx,offset Dflts_Length - 80h	; Read 128 bytes
	mov	ah,3fh				; Read file function
	call	_SaveLoadFile_AHfunc
	call	_SaveLoadFile_Close
	jmp	inid4

; Make and save default file
inid_make:
	call	_kbd_cln
	mov	bx,offset newdflts_ovr
	call	_msgread
	call	__init_filewrite
	call	_Dflts2Disk

inid4:	test	CMDLINE_OPTS,DefaultDir_BIT
	jz	inid5
	mov	si,offset Work_Event		; EDL subdir is here
	call	_stash_EDLsubdir

inid5:	push	es
	mov	cl,Available_Bins
	mov	ch,0
inid6:	mov	al,cl
	call	_index2bin
	call	_SetEdlBinFormatPointer
	loop	inid6
	pop	es
	clc
inidx:	ret


;================================================================
; 1. Open SES.ISF	(Initialialization Script File)
; 2. Read in and parse
;	- Relay Triggers
;	- Switcher type
; 3. return
__READ_SCRIPTS	proc	far

	test	CMDLINE_OPTS,NoScriptFile_BIT	; Script file allowed?
	jnz	rdisf_x

	test	CMDLINE_OPTS,ScriptFile_BIT	; New script file Name?
	jz	rdisf0
	mov	bx,offset INIfile_Buf	; Use INIfile_Buf as buffer
	jmp	rdisf0a
rdisf0:	mov	bx,offset Script_File
rdisf0a:call	_find_file
	jc	rdisf_x
	mov	dx,offset Ascii_Line

	call	_SaveLoadFile_Open	; Open file, read only, save handle
	jc	rdisf_x

	xor	bp,bp			; Line counter

; READ IN LINES FROM THE FILE AND PARSE THEM
rdisf1:	call	_read_line		; Get line from file
	jc	rdisf_c
	jz	rdisf1			; Skip null lines
	inc	bp
	call	adv2cmd
	call	_make_ucase
	cmp	al,';'			; Skip comment lines
	jz	rdisf1
	cmp	al,'R'			; Relay programming
	jnz	rdisf2
	call	Relay_Script
	jmp	rdisf1

rdisf2:	cmp	al,'I'			; Init?
	jnz	rdisf3
	call	Install_Script
	jmp	rdisf1

rdisf3:
rdisfx:	jmp	rdisf1

rdisf_c:call	_SaveLoadFile_Close	; Close file

rdisf_x:ret
__READ_SCRIPTS	endp


; Process RELAY line
Relay_Script:
	call	_adv2spc		; Advance line position
	call	adv2cmd			;  to the relay number
	cmp	al,','			; FORMAT ERROR?
	JMP_Z	BadScriptLine
	call	_convert2bin		; Get relay number
	JMP_Z	BadScriptLine		; Bad line if zero
	cmp	ax,MAX_RELAYS
	JMP_A	BadScriptLine

	cmp	byte ptr [bx],','
	jnz	Rsc2
	inc	bx
Rsc2:	call	adv2cmd
	cmp	al,'"'
	JMP_NZ	BadScriptLine
	inc	bx

	MULTIPLY_BY RTYPE_LENGTH, DX	; Index to correct buffer
	add	dx,offset Relaytype_Tbl
	mov	si,dx

;......... Save Name
	add	si,offset ZeroBase.Rly_NAME
	mov	cx,8

RSCnm:	mov	al,[bx]			; Move the Name
	cmp	al,'"'
	jz	RSCNameDone
	mov	[si],al
	inc	bx
	inc	si
	loop	RSCnm

RSCNameDone:
	jcxz	RSCpulse_latch
rndfil:	mov	byte ptr [si],' '	; Pad with Spaces
	inc	si
	loop	rndfil

RSCpulse_latch:
	mov	si,dx
	call	adv2comma
	call	adv2cmd
	call	_make_ucase
	cmp	al,','
	JMP_Z	BadScriptLine
	cmp	al,'P'
	jz	RSCpulse
	cmp	al,'L'
	jz	RSClatch
	jmp	BadScriptLine

RSCpulse:
	or	byte ptr [si].Rly_FLAGS,RTYPE_pulse
	jmp	RSCSetReset

RSClatch:
	and	byte ptr [si].Rly_FLAGS,not RTYPE_pulse

RSCSetReset:
	call	adv2comma		; Advance line position
	call	adv2cmd			;  to the pulse width
	call	_make_ucase
	cmp	al,'S'
	jz	RSCSet
	cmp	al,'R'
	jz	RSCReset
	cmp	al,'T'
	jz	RSCtoggle
	jmp	BadScriptLine

RSCSet:	mov	ah,RTYPE_set
	jmp	RSCsrl
RSCReset:
	mov	ah,RTYPE_reset
	jmp	RSCsrl
RSCtoggle:
	mov	ah,0
RSCsrl:	and	byte ptr [si].Rly_FLAGS,not (RTYPE_set OR RTYPE_reset)
	or	byte ptr [si].Rly_FLAGS,ah

; Get the pulse width, if any
	call	adv2comma		; Advance line position
	call	adv2cmd			;  to the pulse width
	call	_convert2bin
	and	byte ptr [si].Rly_FLAGS,not RTYPE_pwidth ; Clear out duration
	or	byte ptr [si].Rly_FLAGS,al	; Set the bits

; Get the advance
	cmp	byte ptr [bx],','
	jnz	RSCsrl1
	inc	bx
RSCsrl1:call	adv2cmd			;  to the pulse width
	cmp	al,PLUS_ASCII
	jz	RSCsrls
	cmp	al,MINUS_ASCII
	jnz	RSCsrns
RSCsrls:call	adv2nxt
RSCsrns:call	_convert2bin
	mov	word ptr [si].Rly_OFFSET, ax
	mov	word ptr [si].Rly_OFFSET + 2, 0
	ret

;================================================================
Install_Script:
	push	es
	push	ds
	pop	es
	mov	di,offset Temp_Macro
	xor	al,al
	mov	cl,al
	stosb

	mov	ax,offset Status_xcmd
	stosw
	inc	cl
	inc	cl
	mov	ax,offset Colonplus_xcmd
	stosw
	inc	cl
	inc	cl

	call	_adv2spc		; Advance line position past :

Inx_lp:	call	adv2cmd			;  to the INSTALL line
	cmp	al,cr
	jz	Ins_xit
	cmp	al,';'			; Skip comments on line
	jz	Ins_xit
	cmp	al,'<'			; ENTER?
	jnz	Ins1
	mov	ax,offset Enter_xcmd
	jmp	Insstor

Ins1:	mov	ah,0ffh			; Inicate ASCII keystroke
Insstor:stosw				; Save first digit
	inc	cl
	inc	cl
	inc	bx
	jmp	Inx_lp

Ins_xit:mov	bx,offset Temp_Macro
	mov	[bx],cl
	call	_macsaver
	pop	es
	ret

;================================================================
BadScriptLine:
	call	_error_bell
	call	_kbd_cln
	mov	bx,offset badscript_ovr
	call	_msgread
	mov	bx,bp
	call	_DecOut
	call	_Space_Out
	mov	bx,offset Pause_Msg
	call	_comsg
	mov	ah,10h
	int	16h
	pop	bx
	jmp	rdisf1

;................................................................
; Advance to a comma
adv2comma:
	mov	al,[bx]
	inc	bx
	cmp	al,','
	jz	adv2cr
	jmps	adv2comma
adv2cr:	ret

adv2nxt:inc	bx
adv2cmd:mov	al,[bx]
	cmp	al,9		; Ignore tabs
	jz	adv2cs
	cmp	al,' '
	jnz	adv2cr
adv2cs:	inc	bx
	jmps	adv2cmd

cmdlineopts_msg:
 db cr,'                        ',cr,lf
 db 'Command line options:',cr,lf
 db ' [/F fname] [/E subdir] [/M fname] [/*] [/I subdir] [/-I] [/H]',cr,lf
 db cr,lf
 db '/Ffname  - Name of DEFAULTS file to load',cr,lf
 db '         - "/F" may be eliminated if this is the first option on line.',cr,lf
 db '/Esubdir - Use specified subdirectory to save/load EDLs',cr,lf
 db '/Mfname  - Load specified MACRO file',cr,lf
 db '/*       - Execute MACRO #0 after program startup',cr,lf
 db '/Ifname  - Load specified initialization script file',cr,lf
 db '/-I      - Bypass loading any initialization script files',cr,lf
 db '/W       - MS Windows compatibility',cr,lf
 db '/H or ?  - Display this help message',cr,lf
 db cr,lf,'$'

	org	0ffeh
vmscrseg_bottom:
	dw	0

scrseg	ends

_DATA	segment byte public 'DATA'

control          dw       0

_DATA	ends

eseg	segment	byte public 'EDLBIN1'

eseg	ends


	end
