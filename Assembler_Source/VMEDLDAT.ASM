; Last revised: 2-22-1995, 11:12:24   (C)1989-1995 Norman H. Strassner
; VMEDLIO.ASM

include vm.equ

;================================================================
_DATA	segment para public 'DATA'
	assume ds:_DATA
.xlist
public edl_formats,NumberOfEdlFormats,ModeText_CASE,ModeText_SES,ModeText_CMX340
public ModeText_CMX3600,ModeText_GVG30
public ModeText_GVG31,ModeText_GVG50,ModeText_CONV,ModeText_MACH1,ModeText_CMX50
.list

edl_formats	equ	$
 EDLFORMAT <ModeText_SES,    'SES PRO',	   ,4,1,6,1,6,2,3,'*',00000100b,00000100b>
 EDLFORMAT <ModeText_CMX340, 'CMX 340',    ,3,2,4,1,4,1,1,'*',00000001b,10000001b>
 EDLFORMAT <ModeText_CMX340, 'CMX 3400',   ,3,2,6,3,4,2,3,'*',00000001b,10000001b>
; EDLFORMAT <ModeText_CMX3600,'CMX 3600',   ,3,2,6,3,5,1,3,'*',00100001b,10000101b>
 EDLFORMAT <ModeText_GVG30,  'GVG 30',     ,3,2,4,1,3,1,0,'R',00010101b,10000001b>
 EDLFORMAT <ModeText_GVG31,  'GVG 31',     ,3,2,6,1,4,1,0,'R',00010100b,10000001b>
 EDLFORMAT <ModeText_GVG50,  'GVG 50',     ,3,2,6,1,6,1,0,'R',00010100b,10000101b>
 EDLFORMAT <ModeText_CONV,   'CONVERGENCE',,3,4,4,1,4,1,0,'*',10001010b,10000001b>
 EDLFORMAT <ModeText_CASE,   'CALAWAY',    ,3,2,6,1,4,1,0,'+',00000100b,10000000b>
 EDLFORMAT <ModeText_MACH1,  'MACH1',      ,4,1,6,1,2,1,0,'*',01000001b,10000010b>
 EDLFORMAT <ModeText_CMX50,  'CMX 50',     ,3,2,2,2,1,2,0,'*',00010001b,10000000b>
;	if NTSC
; EDLFORMAT <ModeText_CASE,  'CASE I',     ,4,2,6,2,4,2,3,'*',00000100b,00000000b>
;	endif
NumberOfEdlFormats	equ	($ - edl_formats) / SIZE EDLFORMAT

;................................................................
ModeText_CASE	equ	$
	db	10000000B,'A1  '
	db	01000000B,'A2  '
	db	00001000B,'V   '
	db	11000000B,'A12 '
	db	10001000B,'VA1 '
	db	01001000B,'VA2 '
	db	11001000B,'VA12'
	db	0FFH			; 36 bytes total

ModeText_SES	equ	$
	db	00001000B,'V     '
	db	10000000B,'A1    '
	db	11000000B,'A12   '
	db	10100000B,'A13   '
	db	10010000B,'A14   '
	db	11010000B,'A124  '
	db	10110000B,'A134  '
	db	11100000B,'A123  '
	db	11110000B,'A1234 '
	db	01000000B,'A2    '
	db	01100000B,'A23   '
	db	01010000B,'A24   '
	db	01110000B,'A234  '
	db	00100000B,'A3    '
	db	00110000B,'A34   '
	db	00010000B,'A4    '
	db	10001000B,'VA1   '
	db	11001000B,'VA12  '
	db	10101000B,'VA13  '
	db	10011000B,'VA14  '
	db	11011000B,'VA124 '
	db	10111000B,'VA134 '

	db	11101000B,'VA123 '
	db	11111000B,'VA1234'
	db	01001000B,'VA2   '
	db	01101000B,'VA23  '
	db	01011000B,'VA24  '
	db	01111000B,'VA234 '
	db	00101000B,'VA3   '
	db	00111000B,'VA34  '
	db	00011000B,'VA4   '
	db	0FFH			; 36 bytes total

ModeText_CMX340	equ	$
	db	10000000B,'A   '
	db	01000000B,'A2  '
	db	00001000B,'V   '
	db	11000000B,'AA  '
	db	10001000B,'B   '
	db	01001000B,'A2/V'
	db	11001000B,'AA/V'
	db	0FFH			; 36 bytes total

ModeText_CMX3600	equ	$
	db	00001000B,'V    '
	db	10000000B,' 1   '
	db	11000000B,' 12  '
	db	10100000B,' 1 3 '
	db	10010000B,' 1  4'
	db	11010000B,' 12 4'
	db	10110000B,' 1 34'
	db	11100000B,' 123 '
	db	11110000B,' 1234'
	db	01000000B,'  2  '
	db	01100000B,'  23 '
	db	01010000B,'  2 4'
	db	01110000B,'  234'
	db	00100000B,'   3 '
	db	00110000B,'   34'
	db	00010000B,'    4'
	db	10001000B,'V1   '
	db	11001000B,'V12  '
	db	10101000B,'V1 3 '
	db	10011000B,'V1  4'
	db	11011000B,'V12 4'
	db	10111000B,'V1 34'

	db	11101000B,'V123 '
	db	11111000B,'V1234'
	db	01001000B,'V 2  '
	db	01101000B,'V 23 '
	db	01011000B,'V 2 4'
	db	01111000B,'V 234'
	db	00101000B,'V  3 '
	db	00111000B,'V  34'
	db	00011000B,'V   4'
	db	0FFH			; 36 bytes total


ModeText_GVG30	equ	$
	db	10000000B,'A1 '
	db	01000000B,'A2 '
	db	00001000B,'V  '
	db	11000000B,'A  '
	db	10001000B,'A1V'
	db	01001000B,'A2V'
	db	11001000B,'AV '
	db	0FFH

ModeText_GVG31	equ	$
	db	10000000B,'A1  '
	db	01000000B,'A2  '
	db	00001000B,'V   '
	db	11000000B,'A12 '
	db	10001000B,'A1V '
	db	01001000B,'A2V '
	db	11001000B,'A12V'
	db	0FFH

ModeText_GVG50	equ	$
	db	00001000B,'V     '
	db	10000000B,'A1    '
	db	11000000B,'A12   '
	db	10100000B,'A13   '
	db	10010000B,'A14   '
	db	11010000B,'A124  '
	db	10110000B,'A134  '

	db	11100000B,'A123  '
	db	11110000B,'A1234 '
	db	01000000B,'A2    '
	db	01100000B,'A23   '
	db	01010000B,'A24   '
	db	01110000B,'A234  '
	db	00100000B,'A3    '
	db	00110000B,'A34   '
	db	00010000B,'A4    '
	db	10001000B,'A1V   '
	db	11001000B,'A12V  '
	db	10101000B,'A13V  '
	db	10011000B,'A14V  '
	db	11011000B,'A124V '
	db	10111000B,'A134V '

	db	11101000B,'A123V '
	db	11111000B,'A1234V'
	db	01001000B,'A2V   '
	db	01101000B,'A23V  '
	db	01011000B,'A24V  '
	db	01111000B,'A234V '
	db	00101000B,'A3V   '
	db	00111000B,'A34V  '
	db	00011000B,'A4V   '
	db	0FFH


ModeText_CONV	equ	$
	db	10000000B,'A1  '
	db	01000000B,'A2  '
	db	00001000B,'V   '
	db	11000000B,'A12 '
	db	10001000B,'V1  '
	db	01001000B,'V2  '
	db	11001000B,'V12 '
	db	0FFH

ModeText_MACH1	equ	$
	db	10000000B,'A1  '
	db	01000000B,'A2  '
	db	00001000B,'V   '
	db	11000000B,'A   '
	db	10001000B,'B1  '
	db	01001000B,'B2  '
	db	11001000B,'B   '
	db	0FFH

ModeText_CMX50	equ	$
	db	10000000B,'A   '
	db	01000000B,'A   '
	db	00001000B,'V   '
	db	11000000B,'A   '
	db	10001000B,'B   '
	db	01001000B,'B   '
	db	11001000B,'B   '
	db	0FFH

_DATA	ends

	end

