assembler	comment	; int gcdAsm(int a, int b)
assembler	comment	;
assembler	comment	; computes gcd(a,b) according to:
assembler	comment	; 1. a even, b   even: gcd(a,b) = 2 * gcd(a/2,b/2), 
assembler	comment	;    and remember how often this happened
assembler	comment	; 2. a even, b uneven: gcd(a,b) = gcd(a/2,b)
assembler	comment	; 3. a uneven, b   even: gcd(a,b) = gcd(a,b/2)
assembler	comment	; 4. a uneven, b uneven: a>b ? a -= b : b -= a, 
assembler	comment	;    i.e. gcd(a,b) = gcd(min(a,b),max(a,b) - min(a,b))
assembler	comment	; do 1., repeat 2. - 4. until a = 0 or b = 0
assembler	comment	; return (a + b) corrected by the remembered value from 1.
assembler	blank	
assembler	code			BITS 32
assembler	code			GLOBAL _gcdAsm
assembler	blank	
assembler	code			SECTION .text
assembler	code		_gcdAsm:
assembler	code			push ebp
assembler	code			mov ebp,esp
assembler	code			push ebx
assembler	code			push ecx
assembler	code			push edx
assembler	code			push edi
assembler	code			mov eax,[ebp + 8]   ; eax = a (0 <= a <= 2^31 - 1)
assembler	code			mov ebx,[ebp + 12]  ; ebx = b (0 <= b <= 2^31 - 1)
assembler	comment			; by definition: gcd(a,0) = a, gcd(0,b) = b, gcd(0,0) = 1 !
assembler	code			mov ecx,eax
assembler	code			or ecx,ebx
assembler	code			bsf ecx,ecx         ; greatest common power of 2 of a and b
assembler	code			jnz notBoth0
assembler	code			mov eax,1           ; if a = 0 and b = 0, return 1
assembler	code			jmp done
assembler	code		notBoth0:
assembler	code			mov edi,ecx
assembler	code			test eax,eax
assembler	code			jnz aNot0
assembler	code			mov eax,ebx         ; if a = 0, return b
assembler	code			jmp done
assembler	code		aNot0:
assembler	code			test ebx,ebx
assembler	code			jz done             ; if b = 0, return a
assembler	code			bsf ecx,eax         ; "simplify" a as much as possible
assembler	code			shr eax,cl
assembler	code			bsf ecx,ebx         ; "simplify" b as much as possible
assembler	code			shr ebx,cl
assembler	code		mainLoop:
assembler	code			mov ecx,ebx
assembler	code			sub ecx,eax         ; b - a
assembler	code			sbb edx,edx         ; edx = 0 if b >= a or -1 if a > b
assembler	code			and ecx,edx         ; ecx = 0 if b >= a or b - a if a > b
assembler	code			add eax,ecx         ; a-new = min(a,b)
assembler	code			sub ebx,ecx         ; b-new = max(a,b)
assembler	code			sub ebx,eax         ; the difference is >= 0
assembler	code			bsf ecx,eax         ; "simplify" as much as possible by 2
assembler	code			shr eax,cl
assembler	code			bsf ecx,ebx         ; "simplify" as much as possible by 2
assembler	code			shr ebx,cl
assembler	code			jnz mainLoop        ; keep looping until ebx = 0
assembler	code			mov ecx,edi         ; shift back with common power of 2
assembler	code			shl eax,cl
assembler	code		done:
assembler	code			pop edi
assembler	code			pop edx
assembler	code			pop ecx
assembler	code			pop ebx
assembler	code			mov esp,ebp
assembler	code			pop ebp
assembler	code			ret                 ; eax = gcd(a,b)
