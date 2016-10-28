.586
.MODEL FLAT	; only 32 bit addresses, no segment:offset

.STACK 4096	   ; allocate 4096 bytes for the stack

.DATA
	
	; We are using DWORD sizes, because we are using the cdecl protocol, which requires DWORDs on the stack.
	; We are using unsing unsigned because the problem says the two numbers are positive
	
	number1 DWORD 21
	number2 DWORD 49

.CODE
main PROC
	
	; CONTENTS OF REGISTERS HERE...

	; call gcdProc(number1, number2)
	; set up parameters (push in reverse order)

	mov eax, number2
	push eax

	; stack holds:
	;
	; | number2 | <-- ESP

	mov eax, number1
	push eax

	; stack holds:
	;
	; | number2 |
	; | number1 | <-- ESP

	call gcdProc

	; stack holds:
	;
	; | number2 |
	; | number1 | <-- ESP
	
	; remove parameters from stack
	pop ebx

	; stack holds:
	;
	; | number2 | <-- ESP

	pop ebx									; ebx is trash

	; stack is empty here

	; MUST BE THE SAME HERE AS ABOVE (except for eax, which was used to return a value)

	; eax now holds gcd

	mov eax, 0								; exit with return code 0
	
	ret
main ENDP

; gcdProc(number1, number2)
gcdProc PROC
	
	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr| <-- ESP

	push ebp				; save old ebp so I can use EBP down below as a stationary reference for accessing parameters
	mov ebp, esp			; establish access to parameters

	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr|
	; | old ebp | <-- ESP <-- EBP

	; save the registers we will use in this procedure instructions to calculate the GCD

	push ebx

	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr|
	; | old ebp | <-- EBP
	; | old ebx | <-- ESP

	push ecx

	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr|
	; | old ebp | <-- EBP
	; | old ebx |
	; | old ecx | <-- ESP

	pushfd		; save EFLAGS, because this code will change the EFLAGS register
	
	; no need to push eax, we will be using it to return the value of gcd

	; LOGIC
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

	; Get values from parameters
	; to access the parameters, we use ebp which points 2 elements above the first parameter in the stack.

	; accessing parameters:
	;
	; | number2 |
	; | number1 | <----- EBP + 8
	; | ret addr|      |
	; | old ebp | <-- EBP
	; | old ebx |
	; | old ecx |

	mov ebx, DWORD PTR [ebp + 8]	; gcd := number1

	; accessing parameters:
	;
	; | number2 | <----- EBP + 12
	; | number1 |	   |
	; | ret addr|      |
	; | old ebp | <-- EBP
	; | old ebx |
	; | old ecx |

	mov ecx, DWORD PTR [ebp + 12]	; remainder := number2

loopStart:
	mov eax, ebx			; dividend := gcd
	mov ebx, ecx			; gcd := remainder
	
	mov edx, 0				; EDX will be used as the higher order bits for the dividend
							; we must set EDX to 0 before dividing because the higher order bits are not significant
	div ebx					; divide dividend by gcd (to get dividend mod gcd)
	mov ecx, edx			; remainder := dividend mod gcd
	cmp ecx, 0				; remainder = 0?
	jne loopStart			; if (remainder != 0) goto loopStart
loopEnd:
	
	mov eax, ebx			; move gcd to eax for return

	; restore register values (pop in reverse order)

	popfd		; restore EFLAGS
	pop ecx

	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr|
	; | old ebp | <-- EBP
	; | old ebx | <-- ESP

	pop ebx

	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr|
	; | old ebp | <-- ESP <-- EBP

	pop ebp

	; stack holds:
	;
	; | number2 |
	; | number1 |
	; | ret addr| <-- ESP
	;				  EBP --> ? (whatever it was when we pushed it)

	; return to caller
	ret

gcdProc ENDP

END   ; end of source code
