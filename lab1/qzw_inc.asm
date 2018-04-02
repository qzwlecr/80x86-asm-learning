npvoid typedef near ptr
fpvoid typedef far ptr

@getaddr macro reg:req, adr:req
	if (opattr(adr)) and 00010000y
		mov reg, adr
	elseif (opattr(adr)) and 00000100y
		mov reg, adr
	elseif (type(adr) eq byte) or (type(adr) eq sbyte)
		mov reg, offset adr
	elseif (type(adr) eq npvoid) or (type(adr) eq word)
		mov reg, adr
	elseif (type(adr) eq fpvoid) or (type(adr) eq dword)
		mov reg, word ptr adr[0]
		mov ds, word ptr adr[2]
	else
		.err <Illegal argument>
	endif
endm

;Displays one or more characters to screen
;Change ax,dl
@putchar macro chr:vararg
	mov ah, 02h
	for arg, <chr>
		ifdifi <arg>, <dl>
			mov dl, arg
		endif
		int 21h
	endm
endm

;Gets a keystroke from the keyboard
;Change ax,dl
@getchar macro
    mov ah, 01h
    int 21h
ENDM

;Displays a $-terminated string
;Change ax,dx
@puts macro ofset:req
	local msg, sseg
	@putchar 0ah
	if @InStr(1,ofset, <!">) EQ 1
		sseg textequ @CurSeg
		.DATA
		msg byte ofset, "$"
	@CurSeg ends
		sseg segment
		mov dx, offset msg
	else
		@getaddr dx, ofset
	endif
	mov ah, 9
	int 21h
endm

;Gets a string from the keyboard
;Change ax,dx,bx,si
@gets macro ofset:req, limit, termin
	@getaddr dx, ofset
	mov ah, 0ah
	mov si, dx
	ifnb <limit>
		mov byte ptr[si], limit
	endif
	int 21h
	inc si
	mov bl, [si]
	sub bh, bh
	inc si
	ifnb <termin>
		mov byte ptr[bx+si], termin
	endif
endm
