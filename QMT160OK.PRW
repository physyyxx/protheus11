
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �QMT160OK  �Autor  �Jo�o Felipe da Rosa � Data � 08/06/2009  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para valida��o da movimenta��o dos        ���
���          � dos instrumentos (rotina QMTA160)                          ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function QMT160OK()
Local lRet := .T.

//c_Resp - variavel que vem do sistema contendo a matricula do responsavel

QAA->(DbSetOrder(1)) //FILIAL + MATRICULA
If QAA->(DbSeek(xFilial("QAA")+c_Resp))
	If ALLTRIM(QAA->QAA_LOGIN)$"ALEXANDREAS/SAMUELCF/FABIOPB/SIVONEILS/ERITONAP/MARCELIR/ANDERSONDO/EVERTONJ/THIAGOAS"
		Alert("Imposs�vel realizar retirada em nome dos instrumentistas!")
		lRet := .F.
	EndIf
EndIf    

//c_Status - variavel que vem do sistema contendo o status do instrumento 
//c_Depto  - variavel que vem do sistema contendo o departamento para o qual o instrumento sera emprestado

If Alltrim(c_Depto)=="304003" .AND. AllTrim(c_Status)=="A"
	Alert("Instrumento n�o pode ser movimentado para o C.Custo 304003 com status A=Ativo!")
	lRet := .F.
EndIf

Return lRet
	