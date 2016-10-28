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
	; | number1 | <-- ESP
	; | number2 |

	call gcdProc

	; stack holds:
	;
	; | number1 | <-- ESP
	; | number2 |
	
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
	; | ret addr|
	; | number1 |
	; | number2 |

	push ebp				; save old ebp so I can use it for accessing parameters
	mov ebp, esp			; establish access to parameters

	; stack holds:
	;
	; | old ebp | <-- ESP <-- EBP
	; | ret addr|
	; | number1 |
	; | number2 |

	; save the registers we will use in this procedure
	push ebx

	; stack holds:
	;
	; | old ebx | <-- ESP
	; | old ebp | <-- EBP
	; | ret addr|
	; | number1 |
	; | number2 |

	push ecx

	; stack holds:
	;
	; | old ecx | <-- ESP
	; | old ebx |
	; | old ebp | <-- EBP
	; | ret addr|
	; | number1 |
	; | number2 |
	
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
	mov ebx, DWORD PTR [ebp + 4 * 3]	; gcd := number1
	mov ecx, DWORD PTR [ebp + 4 * 2]	; remainder := number2

loopStart:
	mov eax, ebx			; dividend := gcd
	mov ebx, ecx			; gcd := remainder
	
	mov edx, 0				; EDX will be used as the higher order bits for the dividend
							; we must set EDX to 0 before dividing because the higher order bits are not significant
	div ebx					; divide dividend by gcd (to get dividend mod gcd)
	mov ecx, edx			; remainder := dividend mod gcd
	cmp ecx, 0				; remainder = 0?
	jnz loopStart			; if (remainder != 0) goto loopStart
loopEnd:
	
	mov eax, ebx			; move gcd to eax for return

	; restore register values (pop in reverse order)
	pop ecx

	; stack holds:
	;
	; | old ebx | <-- ESP
	; | old ebp | <-- EBP
	; | ret addr|
	; | number1 |
	; | number2 |

	pop ebx

	; stack holds:
	;
	; | old ebp | <-- ESP <-- EBP
	; | ret addr|
	; | number1 |
	; | number2 |

	pop ebp

	; stack holds:
	;				  EBP --> ? (whatever it was when we pushed it)
	; | ret addr| <-- ESP
	; | number1 |
	; | number2 |

	; return to caller
	ret

gcdProc ENDP

END   ; end of source code
