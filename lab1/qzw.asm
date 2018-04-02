.386

public strcmp

code segment para public use16

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

code ends
end
