.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

INCLUDE io.h   ; header file for input/output

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	
	; We are using DWORD sizes, because the problem spec says to.
	; We are using unsing unsigned because the problem says the two numbers are positive
	
	; These prompts will be displayed when asking for numbers
	; They are null terminated because the input macro expects a C-string
	number1Prompt BYTE "Please input a positive integer", 0
	number2Prompt BYTE "Please input another positive integer", 0

	; inputString will be used to store the user's inputs in ASCII.
	; It is 11 characters long because the longest input will be "4294967295" (11 characters) and the input
	; macro appends a trailing null (11)
	; we tried this with 10 bytes, but because of the trailing null the final character of a 10 character number would get cut off,
	; leaving only 9 characters to represent the number.
	inputString BYTE 11 DUP ("X")

	; gcdString will be used with dtoa, which expects 11 characters + Null terminator
	gcdString BYTE 11 DUP ("X"), 0	; String to store gcd in decimal for output
	
	; gcdOutputLabel will be used to label the gcd when it is displayed
	gcdOutputLabel BYTE "Greatest Common Divisor"


.CODE
_MainProc PROC
	
	; gcd := number1
	; remainder := number2
	; loopStart
	;   dividend := gcd
	;   gcd := remainder
	;   remainder := dividend mod gcd
	; until(remainder = 0)

	; We are using DWORD sizes, because the problem spec says to.
	; ebx = gcd
	; ecx = remainder
	; eax = dividend

	input number1Prompt, inputString, 11	; get input from user (maximum 11 characters, as explained above at inputString)
	atod inputString						; convert input from ASCII coded decimal to binary integer (stored in EAX)
	mov ebx, eax							; gcd := user input

	input number2Prompt, inputString, 11	; get input from user
	atod inputString						; convert input from string to binary integer (stored in EAX)
	mov ecx, eax							; remainder := user input

loopStart:
	mov eax, ebx							; dividend := gcd
	mov ebx, ecx							; gcd := remainder
	
	mov edx, 0								; EDX will be used as the higher order bits for the dividend
											; we must set EDX to 0 before dividing because the higher order bits are not significant
	div ebx									; divide dividend by gcd (to get dividend mod gcd)
	mov ecx, edx							; remainder := dividend mod gcd
	cmp ecx, 0								; remainder = 0?
	jnz loopStart							; if (remainder != 0) goto loopStart
loopEnd:
	
	dtoa gcdString, ebx						; convert gcd to string (for output)
	output gcdOutputLabel, gcdString		; output gcd


	mov eax, 0								; exit with return code 0
	
	ret
_MainProc ENDP

END   ; end of source code
