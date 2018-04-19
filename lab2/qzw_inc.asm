extrn strcmp:far
extrn strlen:far
extrn strfcmp:far
extrn itoa:far

@getaddr macro reg:req, adr:req
	if (opattr(adr)) and 00010000y
		mov reg, adr
	elseif (opattr(adr)) and 00000100y
		mov reg, adr
	elseif (type(adr) eq byte) or (type(adr) eq sbyte)
		mov reg, offset adr
	elseif (type(adr) eq far ptr) or (type(adr) eq word)
		mov reg, adr
	elseif (type(adr) eq far ptr) or (type(adr) eq dword)
		mov reg, word ptr adr[0]
		mov ds, word ptr adr[2]
	else
		.err <Illegal argument>
	endif
endm

;Displays one or more characters to screen
@putchar macro chr:vararg
	push ax
	push dx
	mov ah, 02h
	for arg, <chr>
		ifdifi <arg>, <dl>
			mov dl, arg
		endif
		int 21h
	endm
	pop dx
	pop ax
endm

;Gets a keystroke from the keyboard into dl
;Change dl
@getchar macro
	push ax
	mov ah, 01h
	int 21h
	pop ax
ENDM

;Displays a $-terminated string
@puts macro ofset:req
	push ax
	push dx
	@putchar 10
	@getaddr dx, ofset
	mov ah, 9
	int 21h
	pop dx
	pop ax
endm

;Gets a string from the keyboard
;Change si, bx
;length into bx and data into si
@gets macro ofset:req, limit:req, termin:req
	push ax
	push dx
	@getaddr dx, ofset
	mov ah, 0ah
	mov si, dx
	mov byte ptr[si], limit
	int 21h
	inc si
	mov bl, [si]
	sub bh, bh
	inc si
	mov byte ptr[bx+si], termin
	pop dx
	pop ax
endm

@strfcmp macro fir:req, sec:req
	@getaddr ax, fir
	push ax
	@getaddr ax, sec
	push ax
	call far ptr strfcmp
	add sp, 4
endm

@strcmp macro fir:req, sec: req
	@getaddr ax, fir
	push ax
	@getaddr ax, sec
	push ax
	call far ptr strcmp
	add sp, 4
endm

@strlen macro st:req
	@getaddr ax, st
	push ax
	call far ptr strlen
	add sp, 2
endm

@itoa macro addr: req, fir:req, sec: req
	push si
	@getaddr si, addr
	push si
	push fir
	push sec
	call far ptr itoa
	add sp, 6
	pop si
endm

@strpush macro addr: req, chr: req
	push si
	push ax
	@getaddr si, addr
	@strlen addr
	add si, ax
	mov byte ptr[si] , chr
	pop ax
	pop si
endm
