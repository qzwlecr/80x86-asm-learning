.386

include qzw_inc.asm

stack segment use16 stack
	db 200 dup(0)
stack ends

Goods struct
	goods_name db 10 dup(0)
	goods_in dw 0
	goods_out dw 0
	goods_innum dw 0
	goods_outnum dw 0
	goods_pro dw 0
Goods ends

data segment use16
	noti_username db 'Please input your username:$'
	noti_userpwd db 'Please input your password:$'
	noti_reinput db 'Please reinput your information:$'
	noti_admin_mode db 'You are in Admin Mode!$'
	noti_guest_mode db 'You are in Guest Mode!$'
	noti_bye db 'Byebye!$'
	user_name db 'lichen',0,0,0,0
	user_pwd db 'test',0,0
	unusable1 db 2 dup(0)
	in_name db 16 dup(0)
	unusable2 db 2 dup(0)
	in_pwd db 10 dup(0)
	quit_name db 'q',0
	shop1_name db 'SHOP1',0
	shop1_goods Goods <'PEN',35,56,70,25,0>,<'BOOK',12,30,25,5,0>,28 dup(<'Temp-Value',15,20,30,2,0>)
	shop2_name db 'SHOP2',0
	shop2_goods Goods <'PEN',35,56,70,25,0>,<'BOOK',12,30,25,5,0>,28 dup(<'Temp-Value',15,20,30,2,0>)
	auth db 0
data ends

extern strcmp:near

code segment para public use16
	assume cs:code, ds:data, ss:stack
start:
	mov ax, data
	mov ds, ax
re_auth:
	@puts noti_username
	@gets unusable1, 10, 0
	cmp bx, 0
	jz guest_mode
	push offset in_name
	push offset quit_name
	call near ptr strcmp
	sub sp, -4
	cmp ax, 0
	jz quit
	@puts noti_userpwd
	@gets unusable2, 6, 0
	push offset in_name
	push offset user_name
	call near ptr strcmp
	sub sp, -4
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
admin_mode:
	@puts noti_admin_mode
quit:
	@puts noti_bye
	mov ah, 4ch
	int 21h
code ends

end start
