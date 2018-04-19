.386

include qzw_inc.asm

stack segment use16 stack
	db 200 dup(0)
stack ends

Goods struct
	goods_name db 10 dup(0)
	goods_outnum dw 0
	goods_innum dw 0
	goods_out dw 0
	goods_in dw 0
	goods_pro dw 0
Goods ends

N equ 500
times equ 9999

data segment use16
	noti_username db 'Please input your username:$'
	noti_userpwd db 'Please input your password:$'
	noti_reinput db 'Please reinput your information:$'
	noti_admin_mode db 'You are in Admin Mode!$'
	noti_guest_mode db 'You are in Guest Mode!$'
	noti_not_found db 'Not Found!$'
	noti_goods db 'Please input the goods you want to query:$'
	noti_bye db 'Byebye!$'
	user_name db 'lichen',0,0,0,0
	user_pwd db 'test',0,0
	in_name_head db 2 dup(0)
	in_name db 16 dup(0)
	in_pwd_head db 2 dup(0)
	in_pwd db 10 dup(0)
	in_goods_head db 2 dup(0)
	in_goods db 10 dup(0)
	quit_name db 'q',0
	shop1_name db 'SHOP1',0
	shop1_goods Goods <'PEN',0,1000,70,25,0>,<'BOOK',12,30,25,5,0>,N-2 dup(<'Temp-Value',15,20,30,2,0>)
	shop2_name db 'SHOP2',0
	shop2_goods Goods <'PEN',0,1000,70,25,0>,<'BOOK',12,30,25,5,0>,N-2 dup(<'Temp-Value',15,20,30,2,0>)
	auth db 0
	out_num db 10 dup(0)
data ends


code segment use16
	assume cs:code, ds:data, ss:stack
include timer.asm
start:
	mov ax, data
	mov ds, ax
re_auth: 
	@puts noti_username
	@gets in_name_head, 10, 0 ;Use bx, si as input
	cmp bx, 0
	jz guest_mode
	@strfcmp in_name, quit_name ;Use ax as strfcmp result
	cmp ax, 0
	jz quit
	@puts noti_userpwd
	@gets in_pwd_head, 6, 0 ;Use bx, si as input
	@strfcmp in_name, user_name ;Use ax as strfcmp result
	cmp ax, 0
	jnz auth_failed
	@strfcmp in_pwd, user_pwd ;Use ax as strfcmp result
	cmp ax, 0
	jnz auth_failed
	mov byte ptr[auth], 1
	jmp admin_mode
auth_failed:
	@puts noti_reinput
	mov byte ptr[auth], 0
	jmp re_auth
guest_mode:
	@puts noti_guest_mode
	mov byte ptr[auth], 0
	jmp query_goods
admin_mode:
	@puts noti_admin_mode
	jmp query_goods
query_goods:
	@puts noti_goods
	@gets in_goods_head, 10, 0 ;Use bx, si as input
	cmp bx, 0
	jz re_auth
	cmp byte ptr[auth], 0
	jnz shop1_search
;	@putchar 10
;	call timer
	mov ax, 0
	call timer
	mov dx, times
shop1_search:
	mov bx, N ;Use bx as iterator
	mov si, offset shop1_goods ;Use si as shop1 offset
shop1_search_loop:
	@strfcmp in_goods, si ;Use ax as strfcmp result
	cmp ax, 0
	jz shop1_found
	add si, sizeof Goods
	dec bx
	jnz shop1_search_loop
shop1_not_found:
	cmp bx, 0
	
	jz query_goods
shop1_found:
	cmp byte ptr[auth], 0 ;Check auth status
	jnz admin_calc1
assume si:ptr Goods
	mov ax, [si].goods_out
	mov bx, [si].goods_in
	sub ax, bx
	cmp ax, 0
	je re_auth
	add [si].goods_out, 1
assume si:nothing
admin_calc1:
	call recalc_profit
shop2_search:
	mov bx, N ;Use bx as iterator
	mov di, offset shop2_goods ;Use di as shop2 offset
shop2_search_loop:
	@strfcmp in_goods, di
	cmp ax, 0
	jz shop2_found
	add di, sizeof Goods
	dec bx
	jnz shop2_search_loop
shop2_not_found:
	cmp bx, 0
	jz query_goods
shop2_found:
	push si
	mov si, di
	call recalc_profit
	pop si
	cmp byte ptr[auth], 0
	jnz get_class
	cmp dx, 0
	jz finish
	dec dx
	jmp shop1_search
finish:
	@putchar 10
	mov ax, 1
	call timer
	jmp query_goods
get_class:
	call calc_avg
assume si:ptr Goods
	mov ax, [si].goods_pro
assume si:nothing
	cmp ax, 90
	jge class_a
	cmp ax, 50
	jge class_b
	cmp ax, 20
	jge class_c
	cmp ax, 0
	jge class_d
	@putchar 10,'F'
	jmp re_auth
class_a:
	@putchar 10,'A'
	jmp re_auth
class_b:
	@putchar 10,'B'
	jmp re_auth
class_c:
	@putchar 10,'C'
	jmp re_auth
class_d:
	@putchar 10,'D'
	jmp re_auth
quit:
	@puts noti_bye
	mov ah, 4ch
	int 21h

recalc_profit proc ; the starter in si
assume si:ptr Goods
	pusha
	mov ax, [si].goods_out
	mov cx, [si].goods_outnum
	imul cx ;Calc goods out
	mov bx, ax
	mov ax, [si].goods_in
	mov cx, [si].goods_innum
	imul cx ;Calc goods in
	sub bx, ax
	mov ax, bx
	mov cx, 100
	imul cx ;Multiple 100
	push dx
	mov bx, ax
	mov ax, [si].goods_in
	mov cx, [si].goods_innum
	imul cx
	mov cx, ax
	mov ax, bx
	pop dx
	idiv cx ;Calc result
	mov [si].goods_pro, ax
	popa
assume si:nothing
	ret
recalc_profit endp

calc_avg proc ; shop1 in si, shop2 in di
	pusha
assume si:ptr Goods
assume di:ptr Goods
	mov cx, [si].goods_pro
	mov ax, [di].goods_pro
	add ax, cx
	cwd
	mov cx, 2
	idiv cx
	mov [si].goods_pro, ax
	popa
assume di:nothing
assume si:nothing
	ret
calc_avg endp

code ends

end start
