/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHEST206  �Autor �Guilherme D. Camargo � Data �  22/08/2012 ���
�������������������������������������������������������������������������͹��
���Desc.     �      CADASTRO DE RESPONS�VEL X ARMAZ�M                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESTOQUE / CUSTOS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


#INCLUDE "protheus.ch"
#INCLUDE "TOPCONN.CH"

User Function NHEST206()

Private aRotina, cCadastro
cCadastro := "Cadastro"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"     , 0 , 1})
aAdd(aRotina,{ "Visualizar"	    ,"U_EST206(2)" 	, 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST206(3)" 	, 0 , 3})
aAdd(aRotina,{ "Alterar"        ,"U_EST206(4)"  , 0 , 4})
aAdd(aRotina,{ "Excluir"        ,"U_EST206(5)"  , 0 , 5})
mBrowse(6,1,22,75,"ZF0",,,,,,)

Return

//������������������� � TELA DO CADASTRO � ��������������������
User Function EST206(nParam) 
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam
Private cResp := Space(25)
Private cLocal := Space(2)
Private oGet1, oGet2  
Private oDlg, oFont1, oSay1, oSay2
Private aSize := MsAdvSize() // ??? ??? ??? ???

	If nPar==2     //visualizar
		fCarrega()
	    bOk := {|| oDlg:End()}
	ElseIf nPar==3 //incluir 
		bOk := {|| fInclui()}
		bCanc := {||RollBackSx8(), oDlg:End()}
	ElseIf nPar==4 //alterar
		fCarrega()
		bOk := {|| fAltera()}
	ElseIf nPar==5 //excluir
		fCarrega()
		bOk := {|| fExclui()}
	EndIf
	oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)}
	
	oDlg  := MsDialog():New(aSize[7],0,aSize[6],aSize[5],"Respons�vel X Armaz�m",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	   
    oSay1 := tSay():New(3,10,{||"Respons�vel:  "},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet1 := tGet():New(10,10,{|u| if(Pcount() > 0, cResp := u,cResp)},oDlg,100,10,"@!",{||.T.},;
						,,,,,.T.,,,{|| .T. },,,,,,"QUS","cResp")
						         					
	oSay2 := tSay():New(23,10,{||"Armaz�m:  "},oDlg,,,,,,.T.,CLR_HBLUE,)
	oGet2 := tGet():New(30,10,{|u| if(Pcount() > 0, cLocal := u,cLocal)},oDlg,10,10,"@!",{||.T.},;
						,,,,,.T.,,,{|| .T. },,,,,,"ALM","cLocal")
	         	  
	oDlg:Activate(,,,.F.,{||.T.},,bEnchoice)
Return

//��������Ŀ
//� VALIDA �
//����������
Static Function fValida()
Private recNum := ZF0->(RECNO())
	If Empty(cResp)
		alert("Informe o Respons�vel!")
		Return .F.
	EndIf
	If Empty(cLocal)
		alert("Informe o Armaz�m!")
		Return .F.
	EndIf
	ZF0->(DbSetOrder(1))
	If ZF0->(DbSeek(xFilial("ZF0")+ PadR(cResp,25) + cLocal))
		Alert("Registro j� cadastrado!")
		Return .F.
	Endif         
	ZF0->(DbGoTo(recNum))
Return .T.

//��������Ŀ
//� INCLUI �
//����������
Static Function fInclui()
	If !fValida()
		Return
	EndIf     
	RecLock("ZF0",.T.)
		ZF0->ZF0_FILIAL := xFilial("ZF0")
		ZF0->ZF0_LOGIN	:= cResp
		ZF0->ZF0_LOCAL	:= cLocal
	MsUnlock("ZF0")	
	ConfirmSx8()	
	oDlg:End()
Return

//��������Ŀ
//� ALTERA �
//����������
Static Function fAltera()
	If !fValida()
		Return
	EndIf
	RecLock("ZF0",.F.)
		ZF0->ZF0_LOGIN	:= cResp
		ZF0->ZF0_LOCAL	:= cLocal
	MsUnlock("ZF0")	
	oDlg:End()
Return

//��������Ŀ
//� EXCLUI �
//����������
Static Function fExclui()
	If MsgYesNo("Tem certeza de que deseja excluir?")
		RecLock("ZF0",.F.)
			ZF0->(dbDelete())
		MsUnLock("ZF0")
	EndIf	
	oDlg:End()
Return

//���������������������������������Ŀ
//� TRAZ OS DADOS PARA VISUALIZACAO �
//�����������������������������������
Static Function fCarrega()
		cResp 	 := ZF0->ZF0_LOGIN
		cLocal 	 := ZF0->ZF0_LOCAL 
Return