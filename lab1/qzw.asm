.386

public strcmp
public strlen
public strfcmp
public itoa
public divdw
retsize equ 4

cod segment use16

strlen proc far
	push bp
	mov bp, sp
	push bx
	mov bx, word ptr[bp + retsize + 2]
	push si
	mov si, 0
	push dx
strlen_loop:
	mov dl, byte ptr[bx + si]
	cmp dl, 0
	jz strlen_exit
	inc si
	jmp strlen_loop
strlen_exit:
	mov ax, si
	pop dx
	pop si
	pop bx
	pop bp
	ret
strlen endp

strcmp proc far
	push bp
	mov bp, sp
	push bx
	push si
	mov bx, word ptr[bp + retsize + 2]
	mov si, word ptr[bp + retsize + 4]
	push cx
strcmp_loop:
	mov cl, byte ptr[bx]
	cmp cl, 0
	jz strcmp_corrend
	mov ch, byte ptr[si]
	cmp ch, 0
	jz strcmp_corrend
	sub cl, ch
	cmp cl, 0
	jnz strcmp_diffend
	inc bx
	inc si
	jmp strcmp_loop
strcmp_corrend:
	mov ax, 0
	jmp strcmp_exit
strcmp_diffend:
	mov ax, 0
	mov al, cl
	jmp strcmp_exit
strcmp_exit:
	pop cx
	pop si
	pop bx
	pop bp
	ret
strcmp endp

strfcmp proc far
	push bp
	mov bp,sp
	push bx
	push si
	push cx
	push dx
	mov ax, 0
	mov bx, word ptr[bp + retsize + 2]
	mov si, word ptr[bp + retsize + 4]
	push si
	push bx
	call strcmp
	add sp, 4
	cmp ax, 0
	jnz strfcmp_fail
	push bx
	call strlen
	add sp, 2
	mov cx, ax
	push si
	call strlen
	add sp, 2
	mov dx, ax
	sub cx, dx
	mov ax, cx
	cmp ax, 0
	jnz strfcmp_fail
	mov ax, 0
strfcmp_fail:
	pop dx
	pop cx
	pop si
	pop bx
	pop bp
	ret
strfcmp endp

itoa proc far
	push bp
	push ax
	push dx
	push si
	push cx
	mov bp, sp
	mov ax, word ptr[bp + retsize + 0ah]
	mov dx, word ptr[bp + retsize + 0ch]
	mov cx, 0
	push cx
itoa_divs:
	mov cx, 10
	call far ptr divdw
	add cx, 30h
	push cx
	or ax, dx
	mov cx, ax
	jcxz itoa_copy
	jmp itoa_divs
itoa_copy:
	pop cx
	mov [si], cl
	jcxz itoa_return
	inc si
	jmp itoa_copy
itoa_return:
	pop cx
	pop si
	pop dx
	pop ax
	pop bp
	ret
itoa endp

divdw proc far
	jcxz divdw_return
	push bx
	push ax
	mov ax, dx
	mov dx, 0
	div cx
	mov bx, ax
	pop ax
	div cx
	mov cx, dx
	mov dx, bx
	pop bx
divdw_return:
	ret
divdw endp

cod ends
end
