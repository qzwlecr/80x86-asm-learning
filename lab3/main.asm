NAME MAIN   ;主函数
EXTRN SEEKMES:NEAR,PRINTF1:NEAR,CHANGE:NEAR,CALCAVG:NEAR,SORTRANK:NEAR
PUBLIC GA1,N,GB1,S1,S2
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
BNAME DB 'HUANGRUI'
BPASS DB 'text',0,0
N   EQU 3
AUTH DB 0
S1 DB 'SHOP1',0
GA1 DB 'PEN' ,7 DUP(0)
    DW 35,56,30,10,0
GA2 DB 'BOOK',6 DUP(0)
    DW 12,30,25,5,0
GAN DB N-2 DUP( 'Temp-Value', 15, 0, 20, 0, 30, 0, 20, 0, ?, ? )
S2 DB 'SHOP2',0
GB1 DB 'BOOK',6 DUP(0)
    DW 12,28,20,15,0
GB2 DB 'PEN', 7 DUP(0)
    DW 35,50,30,30,0
GBN DB N-2 DUP( 'Temp-Value', 15, 0, 20, 0, 30, 0, 20, 0, ?, ? )
BUF1 DB 'User name:$'
BUF2 DB 'Password:$'
BUF3 DB 'Landing failure!$'
BUF4 DB 'Input the name of goods!$'
BUF5 DB '       MENU',0DH,0AH,'1 Seek Goods Message',0DH,0AH,'2 Change Goods Message',0DH,0AH,'3 Calculated average utilization',0DH,0AH,'4 Calculation of profit margin ranking',0DH,0AH,'5 Output all commodity information',0DH,0AH,'6 EXIT',0DH,0AH,'Input 1-6 of the number into the corresponding function:$'
BUF6 DB '1 Seek Goods Message,6 EXIT$'
CRLF    DB  0DH,0AH,'$'
in_name DB 15
        DB 0
        DB 15 DUP(0)
in_pwd  DB 10
        DB 0
        DB 10 DUP(0)
in_type DB 5
        DB 0
        DB 5  DUP(0)
AVR DD 0
m  EQU 10000
COUNTER DW 0
TIME DW 0;
TEMP3 DD 0;
DATA ENDS
CODE SEGMENT USE16 PUBLIC 'CODE'
        ASSUME CS: CODE, DS: DATA, SS: STACK
START: MOV AX, DATA
       MOV DS, AX
BEGIN: LEA DX, BUF1
       MOV AH, 9
       INT 21H
       LEA DX, in_name
       MOV AH, 10
       INT 21H
       LEA DX, CRLF
       MOV AH, 9
       INT 21H
       MOV BL, [in_name+1]
       CMP BL,0
       JE  PD1
       MOV BL, [in_name+2]
       CMP BL,'q'
       JE EXIT
MIMA:  LEA DX, BUF2
       MOV AH, 9
       INT 21H
       LEA DX, in_pwd
       MOV AH, 10
       INT 21H
       LEA DX, CRLF
       MOV AH, 9
       INT 21H

       MOV ESI,0
       MOV AL,in_name[1]
       MOV AH,0
       AND EAX,0FFFFH
LOPA1: MOV BL, in_name[2+ESI]
       CMP BL, BNAME[ESI]
       JNE LOPA3
       INC ESI
       CMP ESI,EAX
       JNE LOPA1

       MOV ESI,0
       MOV AL,in_pwd[1]
       MOV AH,0
       AND EAX,0FFFFH
LOPA2: MOV BL, in_pwd[2+ESI]
       CMP BL,BPASS[ESI]
       JNE LOPA3
       INC ESI
       CMP ESI,EAX
       JNE LOPA2
       JMP PD2
LOPA3: LEA DX, BUF3
       MOV AH, 9
       INT 21H
       LEA DX, CRLF
       MOV AH, 9
       INT 21H
       JMP BEGIN

LIST1:CMP AUTH,1      
       JNE LIST2
       WRITE BUF5
       WRITE CRLF
       JMP COMFUN

LIST2: WRITE BUF6
       WRITE CRLF
       JMP COMFUN


COMFUN:READ in_type
       CMP in_type[2],'1'
       JE FUN1
       CMP in_type[2],'2'
       JE FUN2
       CMP in_type[2],'3'
       JE FUN3
       CMP in_type[2],'4'
       JE FUN4
       CMP in_type[2],'5'
       JE FUN5
       CMP in_type[2],'6'
       JE EXIT2
       JMP LIST1

FUN1:  CALL SEEKMES    ;子函数:查询商品信息
       JMP LIST1
FUN2:  CALL CHANGE     ;子函数:修改商品信息
       JMP LIST1
FUN3:  CALL CALCAVG    ;子函数:计算平均利率
       JMP LIST1
FUN4:  CALL SORTRANK    ;子函数:计算利率排名
       JMP LIST1
FUN5:  CALL   PRINTF1  ;子函数:输入全部商品信息
        JMP LIST1


PD1:   MOV AUTH,0     ;实验二相关程序
       JMP LIST1
PD2:   MOV AUTH, 1
       JMP LIST1


EXIT:CMP in_name[1],1
     JNE MIMA
EXIT2:MOV AH, 4CH
     INT 21H


CODE ENDS
      END START
