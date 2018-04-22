NAME PUBLIC
.386
PUBLIC F2T10
PUBLIC F10T2
STACK SEGMENT USE16 STACK 'STACK'
        DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PUBLIC 'DATA'
BUF DB 10 DUP(0)
SIGN DB ?
DATA ENDS
CODE SEGMENT PUBLIC USE16 'CODE'
	ASSUME CS:CODE, DS:DATA, SS:STACK

;子程序名: F2T10
;功能将AX/EAX中的有符号二进制数以十进制形式在显示器上输出
;入口参数:AX/EAX 存放代转换的有符号二进制数
;		  DX 存放16位或32位有符号二进制数的标志
;出口参数:转换后的带符号十进制数在显示器上输出
;所用寄存器:EBX 用来存放基数10
;			SI 用来作十进制数ASCII码存储区的指针
;调用子程序名:RADIX
F2T10 PROC
	PUSH EBX
	PUSH SI
	LEA SI,BUF
	CMP DX,32
	JE B
	MOVSX EAX,AX
B:  OR EAX,EAX
	JNS PLUS
	NEG EAX
	MOV BYTE PTR [SI],'-'
	INC SI
PLUS: MOV EBX,10
	CALL RADIX
	MOV BYTE PTR[SI],'$'
	LEA DX,BUF
	MOV AH,9
	INT 21H
	POP SI
	POP EBX
	RET
F2T10 ENDP
;子程序名：RADIX
;功能：将EAX中的32位无符号二进制数转换为P进制数（16位段）
;使用位置:F2T10子程序中被调用
RADIX PROC
	PUSH CX
	PUSH EDX
	XOR CX,CX
LOP1:XOR EDX,EDX
	DIV EBX
	PUSH DX
	INC CX
	OR EAX,EAX
	JNZ LOP1
LOP2:POP AX
	CMP AL,10
	JB R_L1
	ADD AL,7
R_L1: ADD AL,30H
	MOV [SI],AL
	INC SI
	LOOP LOP2
	POP EDX
	POP CX
	RET
RADIX ENDP

;子程序名：F10T2
;功能：将以SI为指针的字节存储区中的有符号十进制数字串传换成二进制数送入AX/EAX之中
F10T2   PROC
        PUSH    EBX
        MOV     EAX, 0
        MOV     SIGN, 0
        MOV     BL, [SI]
        CMP     BL, '+'
        JE      F10
        CMP     BL, '-'
        JNE     NEXT2
        MOV     SIGN, 1
F10:    DEC     CX     
        JZ      ERR
NEXT1:  INC     SI
        MOV     BL, [SI]
NEXT2:  CMP     BL, '0'
        JB      ERR
        CMP     BL, '9'
        JA      ERR
        SUB     BL, 30H
        MOVSX   EBX, BL
        IMUL    EAX, 10
        JO      ERR
        ADD     EAX, EBX
        JO      ERR
        JS      ERR
        JC      ERR
        DEC     CX
		JNZ		NEXT1
		CMP		DX,16
        JNZ     PP0
        CMP     EAX, 7FFFH
        JA      ERR
PP0:    CMP     SIGN, 1
        JNE     QQ
        NEG     EAX
QQ:     POP     EBX
        RET 
ERR:    MOV     SI, -1
        JMP     QQ
F10T2   ENDP
CODE ENDS
END
