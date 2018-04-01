.386

include qzw.asm

;read macro addr
;	lea dx, addr
;	mov ah,10
;	int 21h
;endm

stack segment use16 stack
	db 200 dup(0)
stack ends

data segment use16
	bname db 'Lichen Zhang', 0
	bpass db 'test', 0,0
	N equ 30
	s1name db 'Shop1', 0
	s1good1 db 'Pen', 7 dup(0)
		dw 35,56,70,25,?
	s1good2 db "Book", 6 dup(0)
		dw 12,30,25,5,?
	s1goodn db N dup('Unknown', 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)
	s2name db 'Shop1', 0
	s2good1 db 'Pen', 7 dup(0)
		dw 35,56,70,25,?
	s2good2 db "Book", 6 dup(0)
		dw 12,30,25,5,?
	s2goodn db N dup('Unknown', 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)
data ends

code segment use16
	assume cs:code, ds:data, ss:stack
start:
	mov ax, data
	mov ds, ax
	read bname
    mov ah, 4ch
    int 21h
code ends

end start
