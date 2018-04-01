read macro addr
	lea dx, addr
	mov ah,10
	int 21h
endm
