
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST194 Autor:Jos� Henrique M Felipetto  Data �  02/22/12  ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para Cancelamento de MRP                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EST                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                  

#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"

User Function NHEST194()
Local _nSC		  := Space(Len(SC1->C1_NUM))

If !U_NHEST195("NHEST194")
	Return .F.
EndIf

Private oDlg  	  := MsDialog():New(0,0,50,350,"Cancelamento de MRP",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"N�mero S.C"},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,45,{|u| if(Pcount() > 0, _nSC := u,_nSC)},oDlg,60,8,"@!",{||validaSC(_nSC)},;
					,,,,,.T.,,,{|| .T. },,,,,,"SC1","_nSC")
	
	oBtnMRP := tButton():New(06,110,"Ok",oDlg,{|| Processa({|| cancelaMRP(_nSC) },"Cancelando MRP...") } ,60,10,,,,.T.)
	//oBtnCanc := tButton():New(06,180,"Cancelar",oDlg,{||oDlg:End()} ,60,10,,,,.T.)

oDlg:Activate(,,,.T.,{||.T.},,)

Return

Static Function validaSC(SC)

SC1->(DbSetOrder(1) )
If !SC1->(DbSeek(xFilial("SC1") + SC))
	Alert("Solicita��o de Compra n�o encontrada!")
	Return .F.
EndIf

Return

Static Function cancelaMRP(SC)
Local nScAux := SC
Local lParc1 := .F.
Local lParc2 := .F.

//Begin Transaction
While SC1->(!EOF() ) .and. nScAux == SC // Percorre todos os itens da SC
	
	If SC1->C1_QUJE > 0 
		lParc1 := .T. // Se o produto corrente tiver sido entregue, marca o controle como True
		SC1->(DbSkip() )
		nScAux := SC1->C1_NUM
		Loop
	EndIf   
	
	lParc2 := .T. // Se n�o tiver pedido feito no produto corrente, marca como .T., pois n�o ir� entrar no If acima. 
	SB2->(DbSeek(xFilial("SB2") + SC1->C1_PRODUTO + SC1->C1_LOCAL))
	RecLock("SB2",.F.)
		SB2->B2_SALPEDI -= SC1->C1_QUANT - SC1->C1_QUJE
	MsUnLock("SB2")

	RecLock("SC1",.F.)
		SC1->C1_QUANT := 0
		SC1->C1_APROV = 'R'
		SC1->C1_QUJE = 0
		SC1->C1_COTACAO = ''
		SC1->C1_RESIDUO = 'S'
	MsUnLock("SC1")
	
	SC1->(DbSkip() )
	nScAux := SC1->C1_NUM
EndDo
//End Transaction

If lParc1 .and. !lParc2 // Se todos os produtos j� foram entregues
	MsgInfo("Erro: Todos os produtos da SC j� foram entregues!. O cancelamento n�o ser� feito!")
ElseIf lParc1 .and. lParc2 // Se tiver entrega parcial
	MsgInfo("Alguns produtos j� possuem pedido!. S� foram cancelados aqueles que n�o possuem pedido!")
ElseIf !lParc1 .and. lParc2 // Se nenhum tiver sido entregue
	MsgInfo("MRP Cancelado com Sucesso!")
EndIf
oDlg:End()

Return