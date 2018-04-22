NAME SEEKMES
;黄瑞
;ͬ同组：张立琛
;
;子程序 SEEKMES
;功能：查找商品信息
;无出入口参数
;变量：
;    BUF3 待输出商品名
;    goods_name 输入的商品名
;    TEMP 存储商品的字符长度
;寄存器：
;    CL 循环计数器
;    EDI、EBX、EAX 商品基址寄存器
;    SI  串传送指令指向待传送的字符串
;    DI  串传送指令指向被传送的字符串
;    EDX  存放16位、32位标志，存放商品的字符长度
;    AX  存放待转换的二进制数

PUBLIC SEEKMES
EXTRN GA1:BYTE,N:ABS,GB1:BYTE,F2T10:NEAR
.386
WRITE MACRO A
      LEA DX,A
      MOV AH,9
      INT 21H
      ENDM
READ  MACRO A
      LEA DX,A
      MOV AH,10
      INT 21H
      ENDM
STACK SEGMENT USE16 STACK 'STACK'
        DB 200 DUP(0)
STACK ENDS
DATA SEGMENT USE16 PUBLIC 'DATA'
BUF1 DB 'Input the name of goods!$'
BUF2 DB 'SHOP1,Goods name,Price,Total stock,The number of sold$'
BUF3 DB 10 DUP(0),'$'
BUF4 DB '   $'
BUF5 DB 'SHOP2,Goods name,Price,Total stock,The number of sold$'
CRLF    DB  0DH,0AH,'$'
goods_name DB 15
           DB 0
           DB 15 DUP(0)
TEMP DW 0;  存储商品长度
DATA ENDS
CODE SEGMENT USE16 PUBLIC 'CODE'
        ASSUME CS: CODE, DS: DATA, SS: STACK
SEEKMES PROC
      PUSH EAX
      PUSH EBX
      PUSH ECX
      PUSH EDX
      PUSH EDI
      PUSH SI
      MOV AX,DATA
      MOV ES,AX

SEEK: WRITE BUF1
      WRITE CRLF
      READ goods_name
      WRITE CRLF
      MOV CL, [goods_name+1]
      CMP CL,0
      JE EXIT

      MOV EDI,0
      MOV CL,0
      MOV DL,goods_name[1]
      MOV DH,0
      AND EDX,0FFFFH
      MOV TEMP,DX
LOAP1:CMP CL,N
      JE  SEEK
      MOV EBX,EDI
      ADD EDI,20
      MOV EAX,0
      INC CL
LOAP2:MOV CH,goods_name[EAX+2]
      CMP GA1[EBX],CH
      JNE LOAP1
      INC EBX
      INC EAX
      CMP EAX,EDX
      JNE  LOAP2
      SUB EDI,20
      MOV ECX,EDI
      WRITE BUF2
      WRITE CRLF
      PUSH CX
      LEA SI,GA1[ECX]
      LEA DI,BUF3
      MOV CX,10
      CLD
      REP MOVSB
      POP CX
      WRITE BUF3
      MOV AX,WORD PTR GA1[ECX+12]
      MOV DX,16
      PUSH ECX
      CALL F2T10
      POP  ECX
      WRITE BUF4
      MOV AX,WORD PTR GA1[ECX+14]
      MOV DX,16
      PUSH ECX
      CALL F2T10
      POP  ECX
      WRITE BUF4
      MOV AX,WORD PTR GA1[ECX+16]
      MOV DX,16
      PUSH ECX
      CALL F2T10
      POP  ECX
      WRITE BUF4
      WRITE CRLF

      MOV EAX,0
      
COMPARE:LEA SI,GB1[EAX]
      ADD EAX,20
      LEA DI,goods_name+2
      MOV CL,goods_name[1]
      AND CX,0FFH
      REPZ CMPSB
      JNE COMPARE

      SUB EAX,20
      MOV ECX,EAX
      WRITE BUF5
      WRITE CRLF
      WRITE BUF3
      MOV AX,WORD PTR GB1[ECX+12]
      MOV DX,16
      PUSH ECX
      CALL F2T10
      POP  ECX
      WRITE BUF4
      MOV AX,WORD PTR GB1[ECX+14]
      MOV DX,16
      PUSH ECX
      CALL F2T10
      POP  ECX
      WRITE BUF4
      MOV AX,WORD PTR GB1[ECX+16]
      MOV DX,16
      PUSH ECX
      CALL F2T10
      POP  ECX
      WRITE BUF4
      WRITE CRLF

EXIT: 
      POP SI
      POP EDI
      POP EDX
      POP ECX
      POP EBX
      POP EAX

      RET
SEEKMES ENDP
CODE ENDS
END
