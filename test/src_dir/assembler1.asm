; int gcdAsm(int a, int b)
;
; computes gcd(a,b) according to:
; 1. a even, b   even: gcd(a,b) = 2 * gcd(a/2,b/2), 
;    and remember how often this happened
; 2. a even, b uneven: gcd(a,b) = gcd(a/2,b)
; 3. a uneven, b   even: gcd(a,b) = gcd(a,b/2)
; 4. a uneven, b uneven: a>b ? a -= b : b -= a, 
;    i.e. gcd(a,b) = gcd(min(a,b),max(a,b) - min(a,b))
; do 1., repeat 2. - 4. until a = 0 or b = 0
; return (a + b) corrected by the remembered value from 1.

		BITS 32
		GLOBAL _gcdAsm

		SECTION .text
	_gcdAsm:
		push ebp
		mov ebp,esp
		push ebx
		push ecx
		push edx
		push edi
		mov eax,[ebp + 8]   ; eax = a (0 <= a <= 2^31 - 1)
		mov ebx,[ebp + 12]  ; ebx = b (0 <= b <= 2^31 - 1)
		; by definition: gcd(a,0) = a, gcd(0,b) = b, gcd(0,0) = 1 !
		mov ecx,eax
		or ecx,ebx
		bsf ecx,ecx         ; greatest common power of 2 of a and b
		jnz notBoth0
		mov eax,1           ; if a = 0 and b = 0, return 1
		jmp done
	notBoth0:
		mov edi,ecx
		test eax,eax
		jnz aNot0
		mov eax,ebx         ; if a = 0, return b
		jmp done
	aNot0:
		test ebx,ebx
		jz done             ; if b = 0, return a
		bsf ecx,eax         ; "simplify" a as much as possible
		shr eax,cl
		bsf ecx,ebx         ; "simplify" b as much as possible
		shr ebx,cl
	mainLoop:
		mov ecx,ebx
		sub ecx,eax         ; b - a
		sbb edx,edx         ; edx = 0 if b >= a or -1 if a > b
		and ecx,edx         ; ecx = 0 if b >= a or b - a if a > b
		add eax,ecx         ; a-new = min(a,b)
		sub ebx,ecx         ; b-new = max(a,b)
		sub ebx,eax         ; the difference is >= 0
		bsf ecx,eax         ; "simplify" as much as possible by 2
		shr eax,cl
		bsf ecx,ebx         ; "simplify" as much as possible by 2
		shr ebx,cl
		jnz mainLoop        ; keep looping until ebx = 0
		mov ecx,edi         ; shift back with common power of 2
		shl eax,cl
	done:
		pop edi
		pop edx
		pop ecx
		pop ebx
		mov esp,ebp
		pop ebp
		ret                 ; eax = gcd(a,b)
