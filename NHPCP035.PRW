
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHPCP035  �Autor  �Jo�o Felipe da Rosa � Data �  25/11/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     � GATILHO DO CAMPO D3_OPHRINI                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#Include "PROTHEUS.Ch"

User Function NHPCP035(cPrd,nQtd,cHri,dDti,cHD)
Local nHora := 0
Local nDias := 0
Local cRet 
Local cHrFim
Local dDtFim

Default cHD := "H"

	If(Empty(cPrd))
		Alert("Para calcular a hora final � necess�rio informar o produto!")
		Return
	EndIf
    
	If(Empty(nQtd))
		Alert("Para calcular a hora final � necess�rio informar a quantidade!")
		Return
	EndIf
	
	If(Empty(cHri))
		Return
	EndIf
	
	SB1->(dbSetOrder(1)) // FILIAL + COD
	SB1->(dbSeek(xFilial("SB1")+cPrd))
	
	nHora := horaToInt(cHri)
	nHora += ((nQtd/SB1->B1_PPLACA)/SB1->B1_MOLDHR)   
	
	//Se for igual ou maior que 24, subtrair (nHoras/24 * 24)
	If ( nHora >= 24 )
		nDias := round( (nHora - (nHora%24)) / 24 , 0) // dias de producao
		nHora -= (nDias * 24) // hora final
	Endif

	//Hora e Data final
	cHrFim := intToHora(nHora)
	dDtFim := dDti+nDias

	If cHD=="D"
		cRet := dDtFim
	Else	
		cRet := cHrFim
	EndIf
	
Return cRet