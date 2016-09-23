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
	
	; We will be using DWORDS because the formula gives us final results ranging:
	; -2000d is the value of 2(-999 + 000 - 1) + 0000, which is the minimum possible value for this problem.
	; 11995d is the value of 2(-000 + 999 - 1) + 9999, which is the maximum possible value for this problem.
	; [-2000d, 11995d], which exceeds the range of 16 bit signed integers ([-32768d, 32767d]),
	; but does not exceed the range of 32 bit integers ([-2147483648d, 2147483647d]).
	
	areaCode			DWORD	916		; 16 bit decimal
	phoneNumberFirst3	DWORD	555		; 16 bit decimal
	phoneNumberLast4	DWORD	1234	; 16 bit decimal

; procedure code
.CODE
main	PROC
	
	; The purpose of this program is to compute the value of the expression
	; 2 ( - zipCode + phoneNumberFirst3 - 1 ) + phoneNumberLast4
	; where zipCode = 95822d, phoneNumberFirst3 = 555d,
	; phoneNumberLast4 = 1234d
	; We will be computing this value in the EAX register, because it is 16 bits wide, which is necessary
	; for this application as discussed above.

	mov		eax, areaCode			; EAX := areaCode
	
	neg		eax						; EAX := -areaCode
	
	add		eax, phoneNumberFirst3	; EAX := -areaCode + phoneNumberFirst3
	
	sub		eax, 1					; EAX := -areaCode + phoneNumberFirst3 - 1
	
	add		eax, eax				; EAX := 2(-areaCode + phoneNumberFirst3 - 1)
									; actually done by adding (-areaCode + phoneNumberFirst3 - 1) to itself
	
	add		eax, phoneNumberLast4	; EAX := 2(-areaCode + phoneNumberFirst3 - 1) + phoneNumberLast4

	mov		eax, 0					; return 0
	ret

main	ENDP

END
