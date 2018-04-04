.386

public strcmp
public strlen
public strfcmp

code segment para public use16

strlen proc near
	push bp
	mov bp, sp
	push bx
	mov bx, word ptr[bp + 4]
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

strcmp proc near
	push bp
	mov bp, sp
	push bx
	push si
	mov bx, word ptr[bp + 4]
	mov si, word ptr[bp + 6]
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

strfcmp proc near
	push bp
	mov bp,sp
	push bx
	push si
	push cx
	push dx
	mov ax, 0
	mov bx, word ptr[bp + 4]
	mov si, word ptr[bp + 6]
	push si
	push bx
	call strcmp
	sub sp, -4
	cmp ax, 0
	jnz strfcmp_fail
	push bx
	call strlen
	sub sp, -2
	mov cx, ax
	push si
	call strlen
	sub sp, -2
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

code ends
end
