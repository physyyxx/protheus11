/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST176 Autor:Jos� Henrique M Felipetto   Data � 25/11/10  ���
�������������������������������������������������������������������������͹��
���Desc.     �ETIQUETAS DE TRANSFERENCIA DE USINAGEM PARA FUNDICAO        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE/CUSTOS                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"

User Function NHEST176()
Private _cLocal := ""

	If ZBA->ZBA_STATUS == "P"
		Alert("Ordem de Libera��o est� Pendente! N�o ser� poss�vel gerar Etiqueta.")
		Return .F.
	EndIf
	BuscaDados()
Return

Static Function BuscaDados()
Local cQuery := ""
Private aProd := {}
Private _nQtPadr := space(5)

cQuery := "SELECT ZBB_COD,ZBB_LOTE,ZBB_QUANT , ZBA_DATA"
cQuery += " FROM " + RetSqlName("ZBA") + " ZBA (NOLOCK), " + RetSqlName("ZBB") + " ZBB (NOLOCK) "
cQuery += " WHERE ZBA.ZBA_NUM = ZBB.ZBB_NUM "
cQuery += " AND ZBA.ZBA_NUM = '" + ZBA->ZBA_NUM + "'"

cQuery += " AND ZBA.D_E_L_E_T_ = '' "
cQuery += " AND ZBB.D_E_L_E_T_ = '' "
cQuery += " AND ZBA.ZBA_FILIAL = '" + xFilial("ZBA") + "'"
cQuery += " AND ZBB.ZBB_FILIAL = '" + xFilial("ZBB") + "'"

TCQUERY cQuery NEW ALIAS "TMP"
TcSetField("TMP","ZBA_DATA","D")  // Muda a data de string para date    

While TMP->(!Eof() )
	_nQuant := agetDados(TMP->ZBB_COD)
	SB1->(DbSeek(xFilial("SB1") + Alltrim(TMP->ZBB_COD)))
	
	If Empty(_nQtPadr)
		SB5->(DbSeek(xFilial("SB5") + TMP->ZBB_COD ) )
		_nQtPadr := SB5->B5_QPA
	EndIf

	aAdd(aProd,{TMP->ZBB_COD,_nQuant,Iif( SB1->B1_RASTRO == "L", TMP->ZBB_LOTE , U_NHEST002(TMP->ZBA_DATA) ),_nQtPadr,TMP->ZBA_DATA})
    
	_nQtPadr := space(05)
	TMP->( DbSkip() )
EndDo

TMP->( DbCloseArea() )
getLocal()
Processa( {|| Imprimir(aProd)   } , "Imprimindo Etiquetas..." )

Return

Static Function agetDados(Produto)
Local oDlgGet
Local _nQuant  := Space(4)

oDlgLocalNF  := MsDialog():New(0,0,140,260,"Digite a quantide de etiquetas",,,,,CLR_BLACK,CLR_WHITE,,,.T.) // Y,X

	oSay1 := TSay():New(08,10,{||"Produto:      " + Alltrim(TMP->ZBB_COD) },oDlgLocalNF,,,,,,.T.,CLR_HBLUE,)
	oSay2 := TSay():New(18,10,{||"Qtde:  "},oDlgLocalNF,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(16,40,{|u| if(Pcount() > 0, _nQuant := u,_nQuant)},oDlgLocalNF,60,8,"999999",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQuant")

	oSay3 := TSay():New(32,10,{||"Qtde. Padr:  "},oDlgLocalNF,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(32,40,{|u| if(Pcount() > 0, _nQtPadr := u,_nQtPadr)},oDlgLocalNF,60,8,"999999",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,,"_nQtPadr")


	oBtnLocal := tButton():New(48,40,"Avan�ar",oDlgLocalNF,{|| verifica(_nQuant)  } ,60,10,,,,.T.)
oDlgLocalNF:Activate(,,,.t.,{||.T.},,)

Return Val(_nQuant)

Static Function getLocal()
Local oDlgLocalNF

_cLocal := CB5->CB5_CODIGO

oDlgLocalNF  := MsDialog():New(0,0,50,400,"Assistente de etiqueta.",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	oSay1 := TSay():New(08,10,{||"Local:"},oDlgLocalNF,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(06,30,{|u| if(Pcount() > 0, _cLocal := u,_cLocal)},oDlgLocalNF,60,8,"@!",{||.T.},;
					,,,,,.T.,,,{|| .T. },,,,,,"CB5","_cLocal")

	oBtnLocal := tButton():New(06,110,"Avan�ar",oDlgLocalNF,{|| oDlgLocalNF:End() } ,60,10,,,,.T.)
oDlgLocalNF:Activate(,,,.t.,{||.T.},,)

Return

Static Function Imprimir(aArray)
Local _cPorta := ""

If CB5->(DbSeek(xFilial("CB5") + Alltrim(_cLocal) ))
	If CB5->CB5_PORTA == "0"
		_cPorta := "LPT" + CB5->CB5_LPT
	EndIf
Else
	alert("Nenhuma impressora configurada no sistema ou o nome dela est� errado!")
	Return .F.
EndIf

MSCBPRINTER("S4M",_cPorta,,,.F.,NIL,NIL,NIL,NIL,NIL,.T.)
MSCBCHKStatus(.T.)

SB1->( DbSetOrder(1) )
For i := 1 to Len(aArray)
	For j := 1 to aArray[i][2]
		MSCBBEGIN(1,6)
	    MSCBSAY(10,12,"WHB","N","0","100,105")
		MSCBSAY(10,39,"Codigo Peca: " ,"N","0","035,035")
		MSCBSAY(10,51,aArray[i][1] ,"N","0","095,095")
		SB1->(DbSeek(xFilial("SB1") + Alltrim(aArray[i][1]) ))
		MSCBSAY(10,65,"Descricao: " + Alltrim(SB1->B1_DESC) ,"N","0","035,035")
		MSCBSAY(10,71,"Quantidade: ","N","0","035,035")
		MSCBSAY(50,76, Alltrim(aArray[i][4]),"N","0","085,085")
		MSCBSAY(76,34,DTOC( aArray[i][5] ),"N","0","075,075")
		MSCBSAYBAR(10,91,aArray[i][1],"N","MB07",13,.F.,.T.,.F.,,3.4,1,.F.,.F.,"1",.T.)
		MSCBSAYBAR(10,115,aArray[i][3],"N","MB07",13,.F.,.T.,.F.,,3.4,1,.F.,.F.,"1",.T.)
		MSCBInfoEti("Produto","30X100")
		MSCBEND()
	Next j
Next i

MSCBCLOSEPRINTER()
MS_FLUSH()
Return

Static Function verifica(_nQuant)
	If Empty(_nQuant)
		alert("Quantidade deve ser digitada!")
	else
		oDlgLocalNF:End()
	EndIf
Return