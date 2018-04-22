name sortrank
;张立琛
;同组：黄瑞

public sortrank
include qzw_inc.asm

extrn ga1:byte, n:abs, gb1:byte
.386

stack segment use16 stack'stack'
	db 200 dup(0)
stack ends

data segment use16 public 'data'
noti_sorting_rank db 'Sorting rank!$'
data ends

code segment use16 public 'code'
	assume cs:code, ds:data, ss:stack
sortrank proc
	pusha
	@puts noti_sorting_rank
	@putchar 10
	lea si, [ga1+18]
	mov cx, n
which_loop:
	push si
	mov dx, 0
	mov bx, n+1
	mov ax, word ptr[si]
	lea si, [ga1-2]
	push cx
rank_loop:
	add si, 20
	dec bx
	je rank_done
	mov cx, word ptr[si]
	cmp ax, cx
	jge rank_loop
	inc dx
	jmp rank_loop
rank_done:
	pop cx
	inc dx
	mov bx, n
	pop si
	sub si, 18
	lea di, [gb1]
shop2_search_loop:
	@strfcmp si, di
	cmp ax, 0
	jz shop2_found
	add di, 20
	dec bx
	jnz shop2_search_loop
shop2_found:
	mov word ptr[di+18], dx
	add si, 18
	add si, 20
	dec cx
	cmp cx, 0
	jnz which_loop
	popa
	ret
sortrank endp
code ends
end
