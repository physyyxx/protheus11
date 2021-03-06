/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM064  �Autor  �Jo�o Felipe da Rosa � Data �  09/06/13   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//-- utilizado como gatilho nos campos C3_SIGLA e C3_DATPRF

User function NHCOM064()
Local nPosRepl := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == STRTRAN(ReadVar(),"M->","")})
Local nPosSC   := aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C3_NUMSC"})
Local xValor   := &(ReadVar())
Local cSCAux   := ''
Local lReplDtP := .f.

For xS:=1 to len(acols)

	If !aCols[xS][len(aHeader)+1]
	
		if cSCAux<>aCols[xS][nPosSC]
			lReplDtP := n==xS
			cSCAux   := aCols[xS][nPosSC]
		Endif
	
		If lReplDtP
			aCols[xS][nPosRepl] := xValor
		Endif

	Endif

next

RETURN xValor