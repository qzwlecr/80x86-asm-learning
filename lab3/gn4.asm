name calcavg
;张立琛
;同组：黄瑞

public calcavg
include qzw_inc.asm

extrn ga1:byte, n:abs, gb1:byte
.386

stack segment use16 stack'stack'
	db 200 dup(0)
stack ends

data segment use16 public 'data'
noti_calcing db 'Calculating average profit!$'
data ends

code segment use16 public 'code'
	assume cs:code, ds:data, ss:stack
calcavg proc
	pusha
	@puts noti_calcing 
	@putchar 10
	mov dx, n
	mov si, offset ga1
calc_loop:
	call recalc_profit 
	mov bx, n
	mov di, offset gb1
shop2_search_loop:
	@strfcmp si, di
	cmp ax, 0
	jz shop2_found
	add di, 20
	dec bx
	jnz shop2_search_loop
shop2_found:
	push si
	mov si, di
	call recalc_profit
	pop si
	call calc_each
	add si, 20
	dec dx
	cmp dx, 0
	jne calc_loop
	popa
	ret
calcavg endp

recalc_profit proc ; the starter in si
	push ax
	push bx
	push cx
	push dx
	mov ax, [si+12]
	mov cx, [si+16]
	imul cx ;Calc goods out
	mov bx, ax
	mov ax, [si+10]
	mov cx, [si+14]
	imul cx ;Calc goods in
	sub bx, ax
	mov ax, bx
	mov cx, 100
	imul cx ;Multiple 100
	push dx
	mov bx, ax
	mov ax, [si+10]
	mov cx, [si+14]
	imul cx
	mov cx, ax
	mov ax, bx
	pop dx
	idiv cx ;Calc result
	mov [si+18], ax
	pop dx
	pop cx
	pop bx
	pop ax
	ret
recalc_profit endp

calc_each proc ; shop1 in si, shop2 in di
	push cx
	push dx
	push ax
	mov cx, [si+18]
	mov ax, [di+18]
	add ax, cx
	mov cx, 2
	cwd
	idiv cx
	mov [si+18], ax
	pop ax
	pop dx
	pop cx
	ret
calc_each endp

code ends
end
