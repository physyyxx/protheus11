/*
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o    �NHFIN009  � Autor � Jose Roberto Gorski   � Data � 24/04/00  ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �ExecBlock para tratamento Inclusao/Alteracao do Adt. de Viagem��
��������������������������������������������������������������������������Ĵ��
��� Uso      �Exclusivo New Huner                                          ���
��������������������������������������������������������������������������Ĵ��
��� Exemplo  �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/


#include "rwmake.ch"

User Function Nhfin009()


if inclui
   Return(.t.)  
Else 
    // Caso seja uma alteracao so permitir alterar se nao
    // existir Contas a Pagar

    SE2->(DbSetOrder(1)) // Filial+prefixo+numero

    If SE2->(DbSeek(xFilial("SE2") + "ADT" + SZ3->Z3_NUM))
       MsgBox("Exclua primeiramente o Titulo a Pagar, para depois alterar este adiantamento de viagem")
       Return(.f.)    
    Else
       Return(.t.) 
    Endif
Endif

