
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MNT061VALID Autor:Jos� Henrique M Felipetto Data:10/22/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o para defeitos na STJ                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MNT061VALID()

ZF7->( DbSetOrder(2) )
If !ZF7->( DbSeek(xFilial("ZF7") + M->TJ_TITULO))
	alert("Defeito por bem n�o encontrado!")
	Return .F.
EndIf
Return .T.
