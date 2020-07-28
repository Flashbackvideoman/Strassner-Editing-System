comment|*******************************************************************

Name:            Asmmacro.inc
Date:            Oct,06,1994
Author:          Michael J. Steiner

***************************************************************************
|

pushr            MACRO   args                    ;MACRO for pushes
					  irp     x,<&args>
					  push    x
					  ENDM
					  ENDM

popr             MACRO   args                    ;MACRO for pops
					  irp     x,<&args>
					  pop     x
					  ENDM
					  ENDM

iodelay          MACRO
					  jmp     short $+2          ; short delay between I/O
					  jmp     short $+2          ;  to same device
					  ENDM