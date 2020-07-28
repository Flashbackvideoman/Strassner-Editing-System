; Last revised: 2-22-1995, 11:12:28   (C)1989-1995 Norman H. Strassner

; VMBUFFS.ASM

include vm.equ

Public dirbuff

_DATA	segment para public 'DATA'

dirbuff		db	MAX_FILENAME_LENGTH * MAX_FILENAMES dup(0)

_DATA	ends

	end
