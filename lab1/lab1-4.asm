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

N equ 30

data segment use16
	noti_username db 'Please input your username:$'
	noti_userpwd db 'Please input your password:$'
	noti_reinput db 'Please reinput your information:$'
	noti_admin_mode db 'You are in Admin Mode!$'
	noti_guest_mode db 'You are in Guest Mode!$'
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
	shop1_goods Goods <'PEN',35,56,70,25,0>,<'BOOK',12,30,25,5,0>,N-2 dup(<'Temp-Value',15,20,30,2,0>)
	shop2_name db 'SHOP2',0
	shop2_goods Goods <'PEN',35,56,70,25,0>,<'BOOK',12,30,25,5,0>,N-2 dup(<'Temp-Value',15,20,30,2,0>)
	auth db 0
	found_ptr1 dw 0
	found_ptr2 dw 0
	average dw 0 
data ends

extern strcmp:near
extern strlen:near
extern strfcmp:near

code segment para public use16
	assume cs:code, ds:data, ss:stack
start:
	mov ax, data
	mov ds, ax
re_auth:
	@puts noti_username
	@gets in_name_head, 10, 0
	cmp bx, 0
	jz guest_mode
	push offset in_name
	push offset quit_name
	call near ptr strfcmp
	sub sp, -4
	cmp ax, 0
	jz quit
	@puts noti_userpwd
	@gets in_pwd_head, 6, 0
	push offset in_name
	push offset user_name
	call near ptr strfcmp
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
	jmp calc_mode
admin_mode:
	@puts noti_admin_mode
	jmp calc_mode
calc_mode:
	@puts noti_goods
	@gets in_goods_head, 10, 0
	cmp ax, 0
	jz re_auth
shop1_search:
	mov bx, N
	mov si, offset shop1_goods
	push offset in_goods
shop1_search_loop:
	push si
	call near ptr strfcmp
	sub sp,-2
	cmp ax, 0
	jz shop1_found
	add si, sizeof Goods
	dec bx
	jnz shop1_search_loop
shop1_notfound:
	sub sp, -2
	cmp bx, 0
	jz calc_mode
shop1_found:
	mov word ptr[found_ptr1], si
	cmp byte ptr[auth], 0
	jz guest_calc
shop2_search:
	mov bx, N
	mov si, offset shop2_goods
	push offset in_goods
shop2_search_loop:
	push si
	call near ptr strfcmp
	sub sp,-2
	cmp ax, 0
	jz shop2_found
	add si, sizeof Goods
	dec bx
	jnz shop2_search_loop
shop2_notfound:
	sub sp, -2
	cmp bx, 0
	jz calc_mode
shop2_found:
	mov word ptr[found_ptr2], si
;assume si:ptr Goods
;	mov (Goods ptr [si]).goods_name, '$'
;assume si:nothing
admin_calc:
assume si:ptr Goods
;calc ptr1
	mov si, word ptr[found_ptr1]
	mov ax, [si].goods_in
	mov cx, [si].goods_innum
	imul cx
	mov dx, ax
	mov ax, [si].goods_out
	mov cx, [si].goods_outnum
	imul cx
	mov di, ax
	sub dx, ax
	mov ax, dx
	mov cx, 100
	imul cx
	mov cx, di
	mov ax, dx
	push dx
	mov dx, 0
	idiv cx
	pop dx
	mov word ptr[found_ptr1], ax
;calc ptr2
	mov si, word ptr[found_ptr2]
	mov ax, [si].goods_in
	mov cx, [si].goods_innum
	imul cx
	mov dx, ax
	mov ax, [si].goods_out
	mov cx, [si].goods_outnum
	imul cx
	mov di, ax
	sub dx, ax
	mov ax, dx
	mov cx, 100
	imul cx
	mov cx, di
	mov ax, dx
	push dx
	mov dx, 0
	idiv cx
	pop dx
assume si:nothing
;calc aver
	mov word ptr[found_ptr2],ax
	mov cx, word ptr[found_ptr1]
	add ax, cx
	mov cx, 2
	push dx
	mov dx, 0
	idiv cx
	pop dx
	mov word ptr[average], ax
	cmp ax, 90
	jge class_a
	cmp ax, 50
	jge class_b
	cmp ax, 20
	jge class_c
	cmp ax, 0
	jge class_d
	@putchar 10,'F',10
	jmp re_auth
class_a:
	@putchar 10,'A',10
	jmp re_auth
class_b:
	@putchar 10,'B',10
	jmp re_auth
class_c:
	@putchar 10,'C',10
	jmp re_auth
class_d:
	@putchar 10,'D',10
	jmp re_auth
guest_calc:
	push offset in_goods
	call near ptr strlen
	sub sp, -2
	mov si, offset in_goods
	add si, ax
	mov byte ptr[si] ,'$'
	@puts in_goods
quit:
	@puts noti_bye
	mov ah, 4ch
	int 21h
code ends

end start
