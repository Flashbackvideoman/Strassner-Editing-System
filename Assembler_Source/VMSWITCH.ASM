; Last revised: 4-12-1991, 22:53:09   (C) 1989, 1990 Norman H. Strassner

;MSW_switch
;MSW_mods_enable
;MSW_mods_disable
;MSW_get_config
;MSW_get_patterns
;MSW_trigger
;MSW_clear

include vm.equ

Public  Vsw_setup, Vswpm_reverse, Vswpm_softedge, Vswpm_border
Public  Vswpm_noedgechange, Vswpm_positioner, Vswpm_modulator, Vswpm_tumble
Public  Vswpm_aspect, VswTran_EDCUT, VswTran_SWCUT, VswTran_DISS, VswTran_WIPE
Public  VswTran_AUTO, VswTran_EMEMDO, VswTran_RECALL, Vsw_Tran_default
Public  Vsw_Tran_ME1, Vsw_Tran_ME2, Vsw_Tran_ME3, VLANswitcher_config
Public  VLANswitcher_trigger

aseg	segment word public 'CODE'
	assume	cs:aseg,ds:dseg,es:dseg

	db	'VLAN Switcher  ',0


Vsw_Switch:
	call	gets_w1		; Get options
	call	getxpt		; Get crosspoint to AL
	mov	ch,al		; Crosspoint to CH
	mov	ax,MSW_switch
	call	vtr_opt
	ret

Vsw_setup:



aseg	ends


dseg	segment byte public 'DATA'

; Pattern modifier specifications

Vswpm_reverse		equ	00000001b	; 
Vswpm_softedge		equ	00000010b	; 
Vswpm_border		equ	00000100b	; 
Vswpm_noedgechange	equ	00001000b	; 
Vswpm_positioner	equ	00010000b	; 
Vswpm_modulator		equ	00100000b	; 
Vswpm_tumble		equ	01000000b	; 
Vswpm_aspect		equ	10000000b	; 

;================================================================
;
; Transition types:	LOWER NIBBLE
VswTran_EDCUT 		equ	0
VswTran_SWCUT		equ	1
VswTran_DISS		equ	2
VswTran_WIPE		equ	3
VswTran_AUTO		equ	8
VswTran_EMEMDO		equ	9
VswTran_RECALL		equ	10

; M/E address:		UPPER NIBBLE
Vsw_Tran_default	equ	0
Vsw_Tran_ME1		equ	1
Vsw_Tran_ME2		equ	2
Vsw_Tran_ME3		equ	3

;================================================================
swconfig	STRUC
Vsw_xpoints		db	0	; Number of crosspoints in main buss
Vsw_spclxpoints		db	0	; number of special crosspoints
Vsw_primarykeyertype	db	0	; Keyer type flag byte for primary keyer
Vsw_extrakeyfor		db	0	; Number of extra key foreground sources
Vsw_extrakeybkg		db	0	; Number of extra key fill sources
Vsw_primarykeyermods	db	0	; Primary keyer modifiers available
Vsw_titlekeyertype	db	0	; Keyer type flag byte for title keyer
Vsw_titlekeyfor		db	0	; Number of extra title foreground sources
Vsw_keyfills		db	0	; Number of extra key fill sources
Vsw_titlekeyermods	db	0	; Title keyer modifiers available
Vsw_patterns		dw	0	; Number of patterns available (2 bytes)
Vsw_mappernmods		db	0	; Pattern modifiers available
Vsw_patternlimits	db	0	; Patytern replication limits
Vsw_quadsplit		db	0	; Quad split availability
Vsw_availemems		db	0	; Number of memory registers available
Vsw_availme		db	0	; Number of addressable M/E's
swconfig	ENDS

trigger_record	STRUC
Vsw_transdur		dw	0	; Transition duration in frames (2 bytes)
Vsw_pattern_num		db	0	; pattern # for wipes, or memory address for memory recall
Vsw_pattern_mod		db	0	; pattern modifier
Vsw_pjattern_rep	db	0	; pattern replication factor
Vsw_transtype		db	0	; transition type /M/E address
Vsw_nextsource		db	0	; next program source
Vsw_nextkeyflags	db	0	; next key flags

Vsw_keyfore		db	0	; key foreground source
Vsw_keysource		db	0	; key source (pattern # if pattern limit
Vsw_keymods		db	0	; Kye modifiers
trigger_record	ENDS


VLANswitcher_config	swconfig	<0>
VLANswitcher_trigger	trigger_record	<0>

dseg	ends
