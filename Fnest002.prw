/*/
��������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������Ŀ��
���Programa  � FNEST002        � Osmar Schimitberger                  � Data �20.10.2004 ���
����������������������������������������������������������������������������������������Ĵ��
���Descricao� Gatilho para atualizacao da Conta Debito do SC1/SC7/SD1/SD3/SE2            ���
����������������������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padrao para programas em RDMake.                                  ���
�����������������������������������������������������������������������������������������ٱ�
���Uso: FUNDI��O NEW HUBNER LTDA											             ���
���       																			 	 ���
�����������������������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������
/*/

#include "rwmake.ch"

User Function fnest002()

SetPrvt("_nTcc,_cCampo,_cConta,_Grupo")
Public CCC

_nTcc   := " "
_cConta := " "					// Variavel de retorno da conta contabil
_Grupo:=SB1->B1_GRUPO

If Upper(FunName())$"MATA240/MATA250/MATA261"
	_nTcc := M->D3_CC
Elseif Upper(FunName())=="MATA110"
	_nTcc := M->C1_CC
Elseif Upper(FunName())=="MATA241"
	_nTcc:= CCC
Elseif Upper(FunName())$"MATA121/MATA122"
	_nTcc := M->C7_CC
Elseif Upper(FunName())=="MATA103"
	_nTcc := M->D1_CC
Elseif Upper(FunName())=="FINA050"
	_nTcc := M->E2_CC
Endif

If !Upper(FunName())$"FINA050"
	
	SBM->(DbSetOrder(1))			// Filial + Grupo
	SBM->(DbSeek(xFilial("SBM")+_GRUPO),.T.)		// Procura no SBM o grupo digitado no SD3
	
	If  AllTrim(_GRUPO) == AllTrim(SBM->BM_GRUPO)  // Se forem iguais SBM e SB1
		Do Case
			Case substr(_nTcc,2,1) $ "3/4"
				_cConta := SBM->BM_CTADIR
			Case substr(_nTcc,2,1) $ "7"
				_cConta := SBM->BM_CTAINOV
			OtherWise
				_cConta := SBM->BM_CTAADM
		EndCase
	Endif

	Return(_cConta)
	
Endif

Return