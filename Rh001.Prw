#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

User Function rh001()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CCONTA,")

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �rh001     � Autor �Marco A.Fagundes       � Data � 04.04.00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualizacao de Contas da Folha de pagamento                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �New Hubner                                                  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

SI3->(DbGoTop())


While SI3->(!Eof())

         // Determina o Centro de Custo
         If SubStr(SI3->I3_CUSTO,1,1) == "1"
            _cConta := "40107001"
         ElseIf AllTrim(SI3->I3_CUSTO) == "770001"
             _cConta := "40106001"
         ElseIf AllTrim(SI3->I3_CUSTO) == "770006"
             _cConta := "40106001"
         ElseIf SubStr(SI3->I3_CUSTO,1,1) == "7"
             _cConta := "40108001"
         ElseIf AllTrim(SI3->I3_CUSTO) == "880001"
             _cConta := "30401001"
         ElseIf SubStr(SI3->I3_CUSTO,1,1) == "8"            
             _cConta := "30401002"
         Endif
         
         RecLock("SI3",.f.)
            SI3->I3_CONTNH := _cConta
         MsUnLock("SI3")
      
      SI3->(DbSkip())
EndDo
MsgBox("Terminou")
Return