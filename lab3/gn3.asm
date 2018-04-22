NAME CHANGE
;黄瑞 
;ͬ同组：张立琛
;
;子程序： CHANGE
;功能：修改商品信息
;无出入口参数
;
;   
;变量：
;    shop_name 存放选择的商店名
;    goods_name  存放输入的商品名
;    in_number   存放输入的修改数字
PUBLIC CHANGE
EXTRN GA1:BYTE,N:ABS,GB1:BYTE,F2T10:NEAR,F10T2:NEAR
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
CRLF    DB  0DH,0AH,'$'
BUF1 DB 'Please input shop name!  (1 SHOP1 2 SHOP2)$'
BUF2 DB 'Please input the name of goods!$'
BUF3 DB '>$'
BUF4 DB 'in_price:$'
BUF5 DB 'out_price:$'
BUF6 DB 'in_num:$'
shop_name DB 2
          DB 0
          DB 2 DUP(0)
goods_name DB 15
           DB 0
           DB 15 DUP(0)
in_number DB 13
        DB ?
        DB 13 DUP(0)
DATA ENDS
CODE SEGMENT USE16 PUBLIC 'CODE'
        ASSUME CS: CODE, DS: DATA, SS: STACK
CHANGE PROC
      PUSH EAX
      PUSH CX
      MOV AX,DATA
      MOV ES,AX
START:WRITE BUF1
      WRITE CRLF
      READ shop_name
      CMP shop_name[1],0
      JE EXIT
      CMP shop_name[1],1
      JNE START
      CMP shop_name[2],'1'
      JE TYPE1
      CMP shop_name[2],'2'
      JE TYPE2
      JMP START
TYPE1:MOV CX,1
      JMP NAME1
TYPE2:MOV CX,0
      JMP NAME1

NAME1: WRITE BUF2
      WRITE CRLF
      READ goods_name
      CALL CHANGE2
      CMP EAX,-1
      JE  START

EXIT: POP CX
      POP EAX
      RET
CHANGE ENDP
CHANGE2 PROC
      PUSH CX
      PUSH EBX
      PUSH DX
      PUSH DI
      PUSH SI
      CMP CX,1
      JE  MODIFYA
      CMP CX,0
      JE  MODIFYB
MODIFYA:LEA BX,GA1
        AND EBX, 0FFFFH
        JMP FIND
MODIFYB:LEA BX,GB1
        AND EBX, 0FFFFH
        JMP FIND
FIND: MOV DX,0
COMPARE1:
      CMP DX,N
      JE EXIT2
      INC DX
      LEA SI,[EBX]
      ADD EBX,20
      LEA DI,goods_name+2
      MOV CL,goods_name[1]
      AND CX,0FFH
      REPZ CMPSB
      JNE COMPARE1

      SUB EBX,20
      INFO_MODIFY_PURCHASE_COST:
        WRITE BUF4
        MOV DX, 16
        MOV AX, 10[EBX] ;进货价
        CALL F2T10
        WRITE BUF3
        READ in_number
        WRITE CRLF
        CMP in_number[2], 0DH
        JE INFO_MODIFY_SALE_PRICE
        LEA SI, in_number[2]
        MOV CL, in_number[1]
        MOV CH, 0
        MOV DX, 16
        CALL F10T2
        CMP SI, -1
        JE INFO_MODIFY_PURCHASE_COST
        MOV 10[EBX], AX
    INFO_MODIFY_SALE_PRICE:
        WRITE BUF5
        MOV DX, 16
        MOV AX, 12[EBX] ;销售价
        CALL F2T10
        WRITE BUF3
        READ in_number
        WRITE CRLF
        CMP in_number[2], 0DH
        JE INFO_MODIFY_PURCHASE_QUANTITY
        LEA SI, in_number[2]
        MOV CL, in_number[1]
        MOV CH, 0
        MOV DX, 16
        CALL F10T2
        CMP SI, -1
        JE INFO_MODIFY_SALE_PRICE
        MOV 12[EBX], AX
    INFO_MODIFY_PURCHASE_QUANTITY:
        WRITE BUF6
        MOV DX, 16
        MOV AX, 14[EBX] ;进货总数
        CALL F2T10
        WRITE BUF3
        READ in_number
        WRITE CRLF
        CMP in_number[2], 0DH
        JE EXIT3
        LEA SI, in_number[2]
        MOV CL, in_number[1]
        MOV CH, 0
        MOV DX, 16
        CALL F10T2
        CMP SI, -1
        JE INFO_MODIFY_PURCHASE_QUANTITY
        MOV 14[EBX], AX
        JMP EXIT3
EXIT3:  MOV EAX,0
        POP SI
        POP DI
        POP DX
        POP EBX
        POP CX
        RET
EXIT2:  MOV EAX,-1
        POP SI
        POP DI
        POP DX
        POP EBX
        POP CX
        RET
CHANGE2 ENDP

CODE ENDS
END
