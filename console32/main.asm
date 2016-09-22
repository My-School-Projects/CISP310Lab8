; general comments
; This version is compatible with Visual Studio 2012 and Visual C++ Express Edition 2012

; preprocessor directives
.586
.MODEL FLAT

; external files to link with

; stack configuration
.STACK 4096

; named memory allocation and initialization
.DATA

; procedure code
.CODE
main	PROC

	mov eax, 0
	ret
main	ENDP

END
	