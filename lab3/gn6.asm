NAME PRINTF1
;黄瑞
;ͬ同组：张立琛
;
;子程序 PRINTF1
;功能：输出商品信息
;无出入口参数
;变量：
;    BUF3 存放待输出的商品名
;寄存器：
;    CX 循环计数器
;    EBX  商品基址寄存器
;    SI  串传送指令指向待传送字符串
;    DI  串传送指令指向被传送字符串
;    DX  存放16位/32位标志
;    AX  存放待转换的二进制数
PUBLIC PRINTF1
EXTRN GA1:BYTE,N:ABS,GB1:BYTE,F2T10:NEAR
.386
WRITE MACRO A
      LEA DX,A
      MOV AH,9
      INT 21H
      ENDM
STACK SEGMENT USE16 STACK 'STACK'
        DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PUBLIC 'DATA'
BUF0 DB 'SHOP1$'
BUF1 DB 'SHOP2$'
BUF2 DB 'Name      InPrice    outPrice  In_num     out_num   1&2Avr_use_rate$'
BUF3 DB 10 DUP(0),'$'
BUF4 DB ' $'
BUF5 DB 'Name      InPrice    outPrice  In_num     out_num   1&2Avr_ranking$'
CRLF    DB  0DH,0AH,'$'
DATA ENDS
CODE SEGMENT USE16 PUBLIC 'CODE'
        ASSUME CS: CODE, DS: DATA, SS: STACK
PRINTF1 PROC
     PUSH AX
     PUSH EBX
     PUSH CX
     PUSH DX
     PUSH DI
     PUSH SI
     MOV AX,DATA
     MOV ES,AX
     WRITE BUF0
     WRITE CRLF
     WRITE BUF2
     WRITE CRLF

     MOV EBX,0
     MOV CL,0
LOAP1:CMP CL,N
     JE LOAP2
     INC CL
     PUSH CX
     LEA SI,GA1[EBX]
     LEA DI,BUF3
     MOV CX,10
     CLD
     REP MOVSB
     WRITE BUF3
     POP CX

     MOV AX,WORD PTR GA1[EBX+10]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GA1[EBX+12]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GA1[EBX+14]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GA1[EBX+16]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GA1[EBX+18]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     WRITE CRLF
     ADD EBX,20
     JMP LOAP1

LOAP2:MOV EBX,0
     WRITE BUF1
     WRITE BUF5
     WRITE CRLF
     MOV CL,0
LOAP3:CMP CL,N
     JE  EXIT
     INC CL
     PUSH CX
     LEA SI,GB1[EBX]
     LEA DI,BUF3
     MOV CX,10
     CLD
     REP MOVSB
     WRITE BUF3
     POP CX

     MOV AX,WORD PTR GB1[EBX+10]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GB1[EBX+12]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GB1[EBX+14]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GB1[EBX+16]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     MOV AX,WORD PTR GB1[EBX+18]
     MOV DX,16
     CALL F2T10
     WRITE BUF4
     WRITE CRLF
     ADD EBX,20
     JMP LOAP3


EXIT:WRITE CRLF
     POP SI
     POP DI
     POP DX
     POP CX
     POP EBX
     POP AX
     RET
PRINTF1 ENDP
CODE ENDS
END
