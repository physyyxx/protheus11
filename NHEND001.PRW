/*
+----------------------------------------------------------------------------------+
!                         FICHA TECNICA DO PROGRAMA                                !
+----------------------------------------------------------------------------------+
!                             DADOS DO PROGRAMA                                    !
+------------------+---------------------------------------------------------------+
!Modulo            ! END - Endividamento                                           !
+------------------+---------------------------------------------------------------+
!Nome              ! NHEND001.PRW                                                  !
+------------------+---------------------------------------------------------------+
!Descricao         ! Lan�amento de Controle de Dividas - Contrato de Financiamentos+
+------------------+---------------------------------------------------------------+
!Autor             ! Edenilson Santos                                              !
+------------------+---------------------------------------------------------------+
!Data de Criacao   ! 24/01/2014                                                    !
+------------------+---------------------------------------------------------------+
!ATUALIZACOES                                                                      !
+-------------------------------------------+---------------+-----------+----------+
!Descricao detalhada da atualizacao         !Nome do        ! Analista  !Data da   !
!                                           !Solicitante    ! Respons.  !Atualiz.  !
+-------------------------------------------+---------------+-----------+----------+
!                                           !Alexandrevm    ! Edenilson !          !
+-------------------------------------------+---------------+-----------+----------+
*/
#include "protheus.ch"
#include "colors.ch"
#include "rwmake.ch"

User Function NHEND001()
Private aRotina, cCadastro

cCadastro := "Endividamento WHB"
aRotina   := {}
aAdd(aRotina,{ "Pesquisa"       ,"AxPesqui"  	, 0 , 1})
aAdd(aRotina,{ "Incluir"        ,"U_END001(1)"  , 0 , 3})
aAdd(aRotina,{ "Excluir"        ,"U_END001(2)"  , 0 , 5})
aAdd(aRotina,{ "Visualizar"	  ,"U_END001(3)" 	, 0 , 2})
aAdd(aRotina,{ "Libera��es"     ,"U_END001(4)"  , 0 , 2})
aAdd(aRotina,{ "Alterar"        ,"U_END001(5)"  , 0 , 4})

mBrowse(6,1,22,75,"ZF8",,,,,,fCriaCor() )
Return

User Function END001(nParam)
Local bOk        := {||}
Local bCanc      := {|| oDlg:End() }
Local bEnchoice  := {||}
Private aSize    := MsAdvSize()
Private nModal	  := 0
Private cContrato:= Space(15)
Private nVlrFinan:= 0
Private nJurBNDES:= 0
Private nJurBanco:= 0
Private nJurtot  := 0
Private nPrazo   := 0
Private nCarencia:= 0
Private cContC	  := Space(20)
Private aHeader  := {}
Private aCols	  := {}
Private cNumEnd  := ""
Private nModal	  := 0
Private cModal   := Space(Len(ZGA->ZGA_CODMOD))
Private _cDescMod:= Space(Len(ZGA->ZGA_DESMOD))
Private cSaldDev := 0
Private aButtons := {}
Private nDlgAltIn:= aSize[7]
Private nDlgLarIn:= 0
Private nDlgAltFi:= aSize[6]
Private nDlgLarFi:= aSize[5]
Private _isAltera:= .F.
Private nLarGroup:= 295
Private cContCcur:= Space(20)
Private cForn	  := Space(Len(ZF8->ZF8_FORN))
Private cNat	  := Space(Len(ZF8->ZF8_NATUR))
Private cLoja	  := Space(Len(ZF8->ZF8_LOJA))
Private _nSequenc:= 0
Private _dSData  := Ctod(space(8))
Private _SaldDev := 0
Private _cDescBan:= Space(Len(SA6->A6_NOME))
Private _cCodBan := Space(Len(SA6->A6_COD))

oFont1 := TFont():New("Arial",,18,,.t.,,,,,.f.)
oFont2 := TFont():New("Arial",,23,,.t.,,,,,.f.)
oFont3 := TFont():New('Arial',,12,,.t.,,,,,.f.)
oFont4 := TFont():New("Ms Sans Serif",,14,,.t.,,,,,.f.)
oFont5 := TFont():New("Ms Sans Serif",,14,,.t.,,,,,.f.)

SetKey( VK_F9  ,{ || fnewLiber() } )
SetKey( VK_F10 ,{ || AxCadastro('ZF9', 'Libera��o') } )
SetKey( VK_F11 ,{ || DataLiberacoes() } )

Aadd(aHeader,{"Descri��o"        , "ZF9_DESC"    ,"@!"                 ,30,0,".F.","","C","ZF9"}) //01
Aadd(aHeader,{"Valor"    	      , "ZF9_VALOR"   ,"@E 999,999,999.99"  ,20,2,".F.","","N","ZF9"}) //02
Aadd(aHeader,{"Data Base"    	   , "ZF9_DATA"    ,"99/99/9999"         ,10,0,".F.","","D","ZF9"}) //03
Aadd(aHeader,{"Libera��o"        , "ZF9_VCTO"    ,"99/99/9999"         ,10,0,".F.","","D","ZF9"}) //04
Aadd(aHeader,{"Dias"             , "ZF8_NUM"     ,"@!"                 ,12,0,".F.","","C","ZF9"}) //05
Aadd(aHeader,{"N� Parc"          , "ZF8_NUM"     ,"@!"          	     ,12,0,".F.","","C","ZF9"}) //06
Aadd(aHeader,{"Principal"        , "ZF8_NUM"     ,"@E 999,999,999.99"  ,12,2,".F.","","N","ZF9"}) //07
Aadd(aHeader,{"Juros"            , "ZF9_JUROS"   ,"@E 999,999,999,99"  ,12,2,".F.","","N","ZF9"}) //08
Aadd(aHeader,{"Pagamento"        , "ZF9_PGTO"    ,"@E 999,999,999.99"  ,12,2,".F.","","N","ZF9"}) //09
Aadd(aHeader,{"Saldo Devedor"    , "ZF8_SALDDEV" ,"@E 999,999,999.99"  ,12,2,".F.","","N","ZF8"}) //10
Aadd(aHeader,{"Gerado no sistema", "ZF8_SALDDEV" ,"@E 999,999,999.99"  ,12,2,".F.","","N","SB1"}) //11

ZG0->(DbSetOrder(1))
If nParam == 1 // Incluir
	bOk 	  := {|| fInclui() }
	cNumEnd   := GetSxeNum("ZF8","ZF8_NUM")
	ConfirmSx8()
	_nSequenc := GetSxeNum("ZF8","ZF8_SEQ")
	ConfirmSx8()
	nDlgAltIn := 0
	nDlgLarIn := 0
	nDlgAltFi := 300
	nDlgLarFi := 950
ElseIf nParam == 2 // Excluir
	fCarrega()
	bOk := {|| fExclui() }
ElseIf nParam == 3 // Visualizar
	fCarrega()
	bOk := {|| oDlg:End() }
ElseIf nParam == 4 // Libera��es
	fCarrega()
	bOk := {|| oDlg:End() }
ElseIf nParam == 5 // Alterar
	bOk 	  := {|| fAltera() }
	_isAltera := .T.
	nDlgAltIn := 0
	nDlgLarIn := 0
	nDlgAltFi := 300
	nDlgLarFi := 950
	fCarrega()
EndIf

//aAdd(aButtons,{"",{|| AxCadastro("ZG4") },"Feriados"} )
aAdd(aButtons,{"",{|| GeraExcel() },"Gerar Planilha"} )
bEnchoice := {|| EnchoiceBar(oDlg,bOk,bCanc,,@aButtons)}

If nParam == 1 // Incluir
	oDlg  := MsDialog():New(nDlgAltIn,nDlgLarIn,nDlgAltFi,nDlgLarFi,"Endividamento | Inclus�o de Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
ElseIf nParam == 2 // Excluir
	oDlg  := MsDialog():New(nDlgAltIn,nDlgLarIn,nDlgAltFi,nDlgLarFi,"Endividamento | Exclus�o de Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
ElseIf nParam == 3 // Visualizar
	oDlg  := MsDialog():New(nDlgAltIn,nDlgLarIn,nDlgAltFi,nDlgLarFi,"Endividamento | Visualiza��o de Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
ElseIf nParam == 4 // Libera��o
	oDlg  := MsDialog():New(nDlgAltIn,nDlgLarIn,nDlgAltFi,nDlgLarFi,"Endividamento | Libera��o de Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
ElseIf nParam == 5 // Altera��o
	oDlg  := MsDialog():New(nDlgAltIn,nDlgLarIn,nDlgAltFi,nDlgLarFi,"Endividamento | Altera��o de Contrato",,,,,CLR_BLACK,CLR_WHITE,,,.T.)
Endif

oGroup := tGroup():New(010,005,035,470," Dados do Endividamento ",oDlg,,,.T.)

oSay1 := TSay():New(21,10,{||"N�mero do Endividamento: "},oDlg,,,,,,.T.,,)
oSay2 := TSay():New(20,75,{||cNumEnd},oDlg,,oFont1,,,,.T.,,)

//If nParam == 1 .Or. nParam == 3
oSay1  := TSay():New(021,175,{||"Modalidade:"},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet2  := tGet():New(020,205,{|u| if(Pcount() > 0, cModal := u,cModal)},oDlg,20,08,"@!",{|| DescMod(cModal) },;
,,,,,.T.,,,{|| nParam == 1 },,,,,,"ZGA","cModal")
oSayMod := TSay():New(019,230,{||_cDescMod},oDlg,,oFont1,,,,.T.,,)
//Endif

//If nParam == 1 .Or. nParam == 3
oSayb := TSay():New(21,300,{||"Cod Banco: "},oDlg,,,,,,.T.,CLR_HBLUE,)
oGetb := tGet():New(20,330,{|u| if(Pcount() > 0, _cCodBan := u,_cCodBan)},oDlg,10,8,PesqPict("SA6","A6_COD"), {|| DescBco(_cCodBan) },;
,,,,,.T.,,,{|| nParam == 1 },,,,,,"SA6","_cCodBan")
oSayB1 := TSay():New(019,362,{||_cDescBan},oDlg,,oFont1,,,,.T.,,)
//EndIf

oGroup := tGroup():New(036,005,061,470," Dados do Contrato ",oDlg,,,.T.)

oSay4 := TSay():New(047,10,{||"N�mero do Contrato: "},oDlg,,,,,,.T.,,)
oGet1 := tGet():New(045,75,{|u| if(Pcount() > 0, cContrato := u,cContrato)},oDlg,75,8,"@!",/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"cContrato")

oSay5 := TSay():New(047,152,{||"Valor Financiamento: "},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet2 := tGet():New(045,205,{|u| if(Pcount() > 0, nVlrFinan := u,nVlrFinan)},oDlg,85,8,"@E 999,999,999,999.99",/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"nVlrFinan")

oSay9 := TSay():New(047,312,{||"Prazo: "},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet6 := tGet():New(045,330,{|u| if(Pcount() > 0, nPrazo := u,nPrazo)},oDlg,53,8,PesqPict("ZF8","ZF8_PRAZO"),/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"nPrazo")

oSay10 := TSay():New(047,387,{||"Car�ncia: "},oDlg,,,,,,.T.,,)
oGet7  := tGet():New(045,412,{|u| if(Pcount() > 0, nCarencia := u,nCarencia)},oDlg,53,8,PesqPict("ZF8","ZF8_CARENC"),/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"nCarencia")

oGroup := tGroup():New(062,005,087,470," Juros do Contrato ",oDlg,,,.T.)

oSay6 := TSay():New(73,10,{||"Taxa de Juros BNDES: "},oDlg,,,,,,.T.,,)
oGet3 := tGet():New(71,75,{|u| if(Pcount() > 0, nJurBNDES := u,nJurBNDES)},oDlg,75,8,PesqPict("ZF8","ZF8_JUBNDS"),/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"nJurBNDES")

oSay7 := TSay():New(73,152,{||"Taxa de Juros Banco: "},oDlg,,,,,,.T.,,)
oGet4 := tGet():New(71,205,{|u| if(Pcount() > 0, nJurBanco := u,nJurBanco)},oDlg,85,8,PesqPict("ZF8","ZF8_JUBANC"),{|| JurTotais(nJurBNDES,nJurBanco) },;
,,,,,.T.,,,{|| /* When */},,,,,,,"nJurBanco")

oSay8 := TSay():New(73,302,{||"Juro Total: "},oDlg,,,,,,.T.,CLR_HBLUE,)
oGet5 := tGet():New(71,330,{|u| if(Pcount() > 0, nJurTot := u,nJurTot)},oDlg,135,8,PesqPict("ZF8","ZF8_JURTOT"),/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,.T.,,,"nJurTot")

oGroup := tGroup():New(088,005,115,470," Dados Contabeis ",oDlg,,,.T.)

oSay11_:= TSay():New(093,095,{||"Curto Prazo"},oDlg,,oFont3,,,,.T.,,)
oSay11 := TSay():New(102,010,{||"Conta Cont�bil: "},oDlg,,,,,,.T.,,)
@ 100,075 Get cContCcur Picture "@!"  When(nParam == 1 .Or. nParam == 5) F3 "CT1" Size 75,8 Valid fnCContab(1) Object oGet8

oSay12 := TSay():New(093,235,{||"Longo Prazo "},oDlg,,oFont3,,,,.T.,,)
oSay12 := TSay():New(102,165,{||"Conta Cont�bil: "},oDlg,,,,,,.T.,,)
@ 100,205 Get cContC Picture "@!"  When(nParam == 1 .Or. nParam == 5) F3 "CT1" Size 85,8 Valid fnCContab(2) Object oGet9

oSay12 := TSay():New(102,298,{||"Fornecedor: "},oDlg,,,,,,.T.,,)
@ 100,330 Get cForn Picture "@!"  When(nParam == 1 .Or. nParam == 5) F3 "SA2" Size 30,8 Valid fnFornece() Object oForn

oSay12 := TSay():New(102,365,{||"Loja: "},oDlg,,,,,,.T.,,)
@ 100,379 Get cLoja Picture "@!"  When(nParam == 1 .Or. nParam == 5) Size 10,8 Object oLoja

oSay12 := TSay():New(102,395,{||"Natureza:"},oDlg,,,,,,.T.,,)
@ 100,420 Get cNat Picture "@!" When (nParam ==1 .or. nParam == 5) F3 "SED" Size 30,8 Valid fnNatureza() Object oNat

If nParam != 1 .and. nParam != 5 // Incluir ou alterar
	
	oGroup := tGroup():New(088,005,115,470," Dados Contabeis ",oDlg,,,.T.)
	oSay12 := TSay():New(20,480,{||"Data saldo: "},oDlg,,,,,,.T.,,)
	oGet9  := tGet():New(18,510,{|u| if(Pcount() > 0, _dSData := u,_dSData)},oDlg,45,8,"@!",{|| findSaldo(_dSData) },;
	,,,,,.T.,,,{|| /* When */},,,,,,,"_dSData")
	
	oGroup := tGroup():New(010,475,115,655," Informa��es Adicionais",oDlg,,,.T.)
	oSay12 := TSay():New(020,560,{||"Saldo Devedor: "},oDlg,                   ,oFont4,,,,.T.,,)
	oSay13 := TSay():New(020,610,{||_SaldDev}       ,oDlg,"@E 999,999,999.99",oFont5,,,,.T.,,)
	
	@122,005 TO 305,655 MULTILINE MODIFY OBJECT oMultiline
	oMultiline:nMax := Len(aCols) // N�o permite adicionar mais uma linha no aCols
	
	oButton1 := tButton():New(310,10,"Nova Libera��o(F9)"     ,oDlg,{|| fnewLiber() },70,15,,,,.T.)
	oButton2 := tButton():New(310,90,"Altera Libera��o(F10)"  ,oDlg,{|| AxCadastro('ZF9','Libera��o') },70,15,,,,.T.)
	oButton4 := tButton():New(310,170,"Pag. de Juros(F11)"    ,oDlg,{|| DataLiberacoes()  },70,15,,,,.T.)
EndIf

oDlg:Activate(,,,.T.,{||.T.},,bEnchoice)
Return

Static Function fInclui()

If !fValida()
	Return .F.
EndIf

RecLock("ZF8",.T.)
ZF8->ZF8_FILIAL := xFilial("ZF8")
ZF8->ZF8_NUM 	 := cNumEnd
ZF8->ZF8_CONTRA := cContrato
ZF8->ZF8_VLRFIN := nVlrFinan
ZF8->ZF8_JUBNDS := nJurBNDES
ZF8->ZF8_JUBANC := nJurBanco
ZF8->ZF8_JURTOT := nJurTot
ZF8->ZF8_PRAZO  := nPrazo
ZF8->ZF8_CARENC := nCarencia
ZF8->ZF8_CONTAC := cContC
ZF8->ZF8_CC	    := cContCCur
ZF8->ZF8_FORN   := cForn
ZF8->ZF8_LOJA	 := cLoja
ZF8->ZF8_NATUR  := cNat
ZF8->ZF8_STATUS := "A"
ZF8->ZF8_SEQ	 := Val(_nSequenc)
ZF8->ZF8_CODBAN := _cCodBan
ZF8->ZF8_MODAL := cModal

MsUnLock("ZF8")

If MsgYesNo("Deseja programar as datas de pagamento de juros?")
	DataLiberacoes()
EndIf
oDlg:End()
Return

Static Function fExclui()
Local _cNum := ""

ZF9->( DbSetOrder(2) )
ZF9->( DbSeek(xFilial("ZF9") + ZF8->ZF8_NUM))

/* Exclui os itens da d�vida */
_cNum := ZF9->ZF9_NUM
While ZF9->( !Eof() ) .and. ZF9->ZF9_NUM == _cNum
	RecLock("ZF9",.F.)
	ZF9->( DbDelete() )
	MsUnLock("ZF9")
	ZF9->( DbSkip() )
EndDo

ZG0->( DbSeek(xFilial("ZG0") + @cNumEnd))
While ZG0->( !Eof() ) .and. ZG0->ZG0_CONTRA == @cNumEnd
	RecLock("ZG0",.F.)
	ZG0->( DbDelete() )
	MsUnLock("ZG0")
	ZG0->( DbSkip() )
EndDo

/* Exclui o cabe�alho das d�vidas. */
RecLock("ZF8",.F.)
ZF8->( DbDelete() )
MsUnLock("ZF8")

oDlg:End()
Return

Static Function fCarrega()

Local 	_nAux 	  	 := 0
Local 	_aAuxCols 	 := {}
Local 	_dData 	  	 := _dData1 := CTOD(space(8))
Local 	_lTemLib  	 := .F.
Local 	_nPot,_nPrim := 0
Private _nJuros 	 := 0

aCols := {}

/* Carrega Cabecalho */
cNumEnd    := ZF8->ZF8_NUM
cContrato  := ZF8->ZF8_CONTRA
nVlrFinan  := ZF8->ZF8_VLRFIN
nJurBNDES  := ZF8->ZF8_JUBNDS
nJurBanco  := ZF8->ZF8_JUBANC
nJurTot    := ZF8->ZF8_JURTOT
nPrazo	  := ZF8->ZF8_PRAZO
nCarencia  := ZF8->ZF8_CARENC
cContCcur  := ZF8->ZF8_CC
cContC     := ZF8->ZF8_CONTAC
cForn 	  := ZF8->ZF8_FORN
cLoja 	  := ZF8->ZF8_LOJA
cNat 	     := ZF8->ZF8_NATUR
_nSequenc  := ZF8->ZF8_SEQ
cModal     := ZF8->ZF8_MODAL
_cDescMod  := Posicione('ZGA',1,xFilial('ZGA')+cModal,'ZGA_DESMOD')
_cCodBan   := ZF8->ZF8_CODBAN
_cDescBan  := Posicione('SA6',1,xFilial('SA6')+_cCodBan,'A6_NOME')
_nNumDia   := 200
_dPrimLib  := Date()
_nSomJur   := 0
_nAuxCont  := 0
_nCareDias := nCarencia * 30
_nAuxMes   := 0
_dLastData := Ctod(Space(8))

If _isAltera
	Return
EndIf

/* Carrega Itens e c�lculo da d�vida. */
ZF9->( DbSetOrder(2) )
ZF9->( DbSeek(xFilial("ZF9") + cNumEnd))

While ZF9->( !Eof() ) .and. ZF9->ZF9_NUM == cNumEnd
	If Alltrim(ZF9->ZF9_DESC) == "1"
		aAdd(aCols,{"Libera��o",ZF9->ZF9_VALOR,ZF9->ZF9_BASE,ZF9->ZF9_DATA,"","",0,0,0,ZF9->ZF9_VALOR,""} )
		cSaldDev := ZF9->ZF9_VALOR
		_dData := _dPrimLib := ZF9->ZF9_BASE
		_lTemLib := .T.
		exit
	Endif
	ZF9->( DbSkip() )
EndDo

_lTemPag  := .F.
_lPagDB   := .F.
_lTemLib2 := .F.
_nPrim2   := 0
_nPrim3   := 0
_lHavPag  := .T.
If _lTemLib
	ZF9->( DbSetOrder(3) )
	_dLastDia := _dData1
	_dData1 := (_dData + 1)
	_nDia 	 := _dData1 - _dData
	
	/* Calcula valores at� a data do final da car�ncia */
	For i := 1 to _nCareDias
		If i > 1
			_dLastDia := LastDate(_dData1)
			If _dData1 == _dLastDia
				_nDia 	:= _dData1 - aCols[Len(aCols)][3]
				_nAux 	:= nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nAuxMes := 0
				_nSomJur += _nJuros
			EndIf
			
			If ZG0->(DbSeek(xFilial("ZG0") + cNumEnd + DTOS(_dData1) ))
				/* Gera t�tulo de pagamento dos juros */
				_nDia 	:= _dData1 - aCols[Len(aCols)][3]
				_nAux 	:= nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nAuxMes := 0
				_nSomJur += _nJuros
				cSaldDev -= _nSomJur
				aAdd(aCols,{"Pagamento de Juros",0,_dData1,"",_nDia,"",0,_nJuros * 100,_nSomJur,cSaldDev,_nSomJur} )
				_nSomJur := 0
				_lTemPag := .T.
			EndIf
			
			If !_lTemPag .and. _dData1 == _dLastDia
				aAdd(aCols,{"Apropria��o de Juros",0,_dData1,"",_nDia,"",0,_nJuros * 100,0,cSaldDev,_nSomJur} )
				_nAuxCont := 0
			EndIf
			
			/* Verifica se h� uma libera��o no dia */
			If ZF9->( DbSeek(xFilial("ZF9") + DTOS(_dData1) + cNumEnd ))
				_nDia 	:= ZF9->ZF9_BASE - aCols[Len(aCols)][3]
				_nAux 	:= nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nSomJur += _nJuros
				aAdd(aCols,{"Libera��o",ZF9->ZF9_VALOR,ZF9->ZF9_BASE,ZF9->ZF9_DATA,_nDia,"",0,_nJuros * 100,0,cSaldDev,_nSomJur} )
				cSaldDev += ZF9->ZF9_VALOR
			EndIf
			
			_lTemPag := .F.
			_dData1++
			_nAuxCont++
			_nAuxMes++
		EndIf
	Next i
	
	nFinanDias := (nPrazo * 31)
	nVlrParc   := nVlrFinan/nPrazo
	_lTemPag   := .F.
	_nPag      := 0
	_nParcela  := 1
	lSJnot	  := .F. // vari�vel que verifica se a soma dos juros n�o � igual 0, ou seja, teve uma apropria��o depois da �ltima amortiza��o, tendo assim que jogar nos juros da pr�xima parcela
	_nJurCer   := 0
	
	If _nSomJur != 0
		lSJnot := .T.
	EndIf
	
	/* Calcula valores do fim da car�ncia at� a data do final da d�vida */
	For i := 1 to nFinanDias
		
		/* Verifica se h� uma libera��o no dia */
		If ZF9->( DbSeek(xFilial("ZF9") + DTOS(_dData1) + cNumEnd ))
			_nDia 	 := ZF9->ZF9_BASE - aCols[Len(aCols)][3]
			_nAux 	 := nJurTot/100
			_nPrim2  := Round(1 + _nAux,4)
			_nPrim3  := _nDia/360
			_nPrim   := _nPrim2 ** _nPrim3 - 1
			cSaldDev := Round(cSaldDev,2)
			_nJuros  := cSaldDev * _nPrim
			cSaldDev += _nJuros
			_nSomJur += _nJuros
			aAdd(aCols,{"Libera��o",ZF9->ZF9_VALOR,ZF9->ZF9_BASE,ZF9->ZF9_DATA,_nDia,"",0,_nJuros * 100,0,cSaldDev,_nSomJur} )
			cSaldDev += ZF9->ZF9_VALOR
		EndIf
		
		// Realiza um pagamento da parcela + Juros
		If _nParcela <= nPrazo
			
			If Day(_dData1) == 15
				
				If isFeriado(_dData1)
					_dData1++
				EndIf
				
				If verificaDia(_dData1) == 7
					_dData1 += 2 //
				ElseIf verificaDia(_dData1) == 1
					_dData1++
				EndIf
				
				_nDia 	 := _dData1 - aCols[Len(aCols)][3]
				_nAux 	 := nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				
				cSaldDev += _nJuros
				_nPag    := Round(nVlrParc,2) + _nJuros
				
				If lSJnot
					_nPag  := Round(nVlrParc,2) + _nJuros + _nSomJur
					lSJnot := .F.
				EndIf
				cSaldDev -= _nPag
				_nSomJur += _nJuros
				aAdd(aCols,{"Principal + Juros ",0,_dData1,"",_nDia,_nParcela,nVlrParc,_nJuros * 100,_nPag,cSaldDev,_nSomJur} )
				_nSomJur := 0
				_lTemPag := .T.
				_nParcela++
			EndIf
			
			_dLastDia := LastDate(_dData1)
			If _dData1 == _dLastDia
				_nDia 	 := _dData1 - aCols[Len(aCols)][3]
				_nAux 	 := nJurTot/100
				_nPrim2  := Round(1 + _nAux,4)
				_nPrim3  := _nDia/360
				_nPrim   := _nPrim2 ** _nPrim3 - 1
				cSaldDev := Round(cSaldDev,2)
				_nJuros  := cSaldDev * _nPrim
				cSaldDev += _nJuros
				_nAuxMes := 0
				_nSomJur += _nJuros
				lSJnot   := .T.
				aAdd(aCols,{"Apropria��o de Juros",0,_dData1,"",_nDia,"",0,_nJuros * 100,0,cSaldDev,_nSomJur} )
			EndIf
			
		EndIf
		
		_nAuxCont++
		_lTemPag := .F.
		_dData1++
	Next i
	fPagaJur()
EndIf
Return

Static Function fAtuLibera(Tipo,Dataa,Valor,Base)

If Valor > nVlrFinan
	alert("O valor digitado deve ser menor que o valor do financiamento!")
	Return .F.
EndIf

RecLock("ZF9",.T.)
ZF9->ZF9_FILIAL := xFilial("ZF9")
ZF9->ZF9_DESC   := Tipo
ZF9->ZF9_VALOR	 := Valor
ZF9->ZF9_DATA   := Dataa
ZF9->ZF9_NUM    := cNumEnd
ZF9->ZF9_BASE	 := Base
MsUnLock("ZF9")

MsgInfo("Libera��o gravada com sucesso!")

oDlg1:End()
fCarrega()
oDlg:Refresh()
Return

Static Function fAltera()

RecLock("ZF8",.F.)
ZF8->ZF8_CONTRA := cContrato
ZF8->ZF8_VLRFIN := nVlrFinan
ZF8->ZF8_JUBNDS := nJurBNDES
ZF8->ZF8_JUBANC := nJurBanco
ZF8->ZF8_JURTOT := nJurTot
ZF8->ZF8_PRAZO  := nPrazo
ZF8->ZF8_CARENC := nCarencia
ZF8_CONTAC		 := cContC
ZF8->ZF8_MODAL  := cModal
MsUnLock("ZF8")

oDlg:End()
Return

Static Function JurTotais(JuroBNDES,JuroBanco)
nJurTot := JuroBNDES + JuroBanco
oGet5:Refresh()
Return

Static Function fnewLiber()
Private nTipo ,_dLocData := Date() ,_nLocValor := 0 , aTipo := {"1=Libera��o"} , _dBase := CTOD( space(8) )

oDlg1  := MsDialog():New(0,0,300,280,"Libera��o - Incluir",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1b   := TSay():New(20,10,{||"Tipo"},oDlg1,,,,,,.T.,CLR_HBLUE,)
oCombo1b := TComboBox():New(18,50,{|u| if(Pcount() > 0,nTipo := u,nTipo)},;
aTipo,70,10,oDlg1,,{||},,,,.T.,,,,{|| .T. },,,,,"nTipo")

oSay2b   := TSay():New(40,10,{||"Data"},oDlg1,,,,,,.T.,CLR_HBLUE,)
oGet2b   := tGet():New(38,50,{|u| if(Pcount() > 0, _dLocData := u,_dLocData)},oDlg1,60,8,"99/99/9999",{|| fFindVlr(_dLocData) } ,;
,,,,,.T.,,,{|| /* When */},,,,,,,"_dLocData")

oSay3b   := TSay():New(60,10,{||"Valor"},oDlg1,,,,,,.T.,CLR_HBLUE,)
oGet3b   := tGet():New(58,50,{|u| if(Pcount() > 0, _nLocValor := u,_nLocValor)},oDlg1,60,8,"@E 999,999,999.99",/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"_nLocValor")

oSay4b   := TSay():New(80,10,{||"Base"},oDlg1,,,,,,.T.,CLR_HBLUE,)
oGet4b   := tGet():New(78,50,{|u| if(Pcount() > 0, _dBase := u,_dBase)},oDlg1,60,8,"99/99/9999",/*valid*/,;
,,,,,.T.,,,{|| /* When */},,,,,,,"_dBase")

oButton := tButton():New(100,30,"Confirmar",oDlg1,{|| Processa({|| fAtuLibera(nTipo,_dLocData,_nLocValor,_dBase)} , "Recalculando...")},60,15,,,,.T.)

oDlg1:Activate(,,,.T.,{||.T.},,)
Return

Static Function verificaDia(Datta)

_nNumDia := DoW(Datta)

If _nNumDia == 1 .or. _nNumDia == 7
	Return _nNumDia
EndIf

Return 12

Static Function fFindVlr(Datta)

If @nTipo == "3"
	_x := aScan(aCols,{|x| x[3] == Datta})
	If _x != 0
		@_nLocValor := aCols[_x,11]
		oDlg1:refresh()
	EndIf
EndIf

Return

Static Function DataLiberacoes()
aHead := {}
aCol  := {}
aAdd(aHead,{'Data(s) de Pagamento(s)',"ZG0_DATA","99/99/9999",10,0,'.T.','.t.','D','','R'})

oDlg2  := MsDialog():New(0,0,340,255,"Programar Pagamento de Juros",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

oSay1   := TSay():New(10,05,{||"N�mero do Endividamento: "},oDlg2,,,,,,.T.,,)
oSay2   := TSay():New(10,70,{||@cNumEnd},oDlg2,,@oFont1,,,,.T.,,)

ZG0->(DbSetOrder(1))
If ZG0->(DbSeek(xFilial("ZG0")+cNumEnd))
	While ZG0->(!EoF()) .And. ZG0->ZG0_CONTRA == cNumEnd
		aadd(aCol,{ZG0->ZG0_DATA,.F.})
		ZG0->( DbSkip() )
	EndDo
EndIf

oGetD   := MsNewGetDados():New(20,05,140,125,3,{|| .T. },"AllwaysTrue()",,,0,99,"AllwaysTrue()",'',"AllwaysTrue()",oDlg2,aHead,aCol)

oButton1:= tButton():New(145,05,"Confirmar",oDlg2,{|| Processa({|| fGravaDatas(oGetD:aCols)} , "Recalculando...")},55,15,,,,.T.)
oButton2:= tButton():New(145,70,"Fechar"   ,oDlg2,{|| oDlg2:End() },55,15,,,,.T.)

oDlg2:Activate(,,,.T.,{||.T.},,)
Return

Static Function fGravaDatas(aDatas)
ZG0->(DbSetOrder(1))
If ZG0->(DbSeek(xFilial("ZG0")+cNumEnd))
	MsgRun('Processando...','Aguarde')
	While ZG0->(!EoF()) .And. ZG0->ZG0_CONTRA == cNumEnd
		RecLock("ZG0",.F.)
		ZG0->(DbDelete())
		MsUnlock("ZG0")
		ZG0->(DbSkip())
	EndDo
EndIf

For i := 1 to Len(aDatas)
	RecLock("ZG0",.T.)
	ZG0->ZG0_FILIAL:= xFilial("ZG0")
	ZG0->ZG0_CONTRA:= Alltrim(@cNumEnd)
	ZG0->ZG0_DATA	:= aDatas[i,1]
	MsUnLock("ZG0")
Next i

MsgInfo("Datas gravadas com sucesso!")
@oDlg2:End()
fCarrega()

Return

Static Function fValida()

If Empty(cModal)
	alert("Modalidade do Financiamento deve ser preenchida.Favor verifique!")
	Return .F.
EndIf

If Empty(nVlrFinan)
	alert("O valor do financiamento deve ser informado.Favor verifique!")
	Return .F.
EndIf

If Empty(nPrazo)
	alert("O prazo do financiamento deve ser informado.Favor verifique!")
	Return .F.
EndIf

If Empty(nJurTot)
	alert("A taxa de Juros totais deve ser informada.Favor verifique!")
	Return .F.
EndIf

If Empty(cForn)
	alert("O campo fornecedor deve ser preenchido!.Favor verifique!")
	Return .F.
EndIf

If Empty(cLoja)
	alert("O campo loja deve ser preenchido!.Favor verifique!")
	Return .F.
EndIf

If Empty(cNat)
	alert("O campo natureza deve ser preenchido!.Favor verifique!")
	Return .F.
EndIf

If Empty(_cCodBan)
	alert("O campo c�digo do banco deve ser preenchido!")
	Return .F.
EndIf

Return .T.


Static Function fPagaJur()
Local _cNomFor := ""
Local nCont    := 1

If ZF8->ZF8_FINJUR
	Return .F.
EndIf

If !ZG0->( DbSeek(xFilial("ZG0") + @cNumEnd ))
	Return .F.
EndIf

If !MsgYesNo("N�o foi gerado t�tulo para pagamento dos juros. Deseja gerar estes t�tulos?")
	Return .F.
EndIf

If SA2->(DbSeek(xFilial("SA2") +  @cForn + @cLoja))
	_cNomFor  := SA2->A2_NREDUZ
EndIf

While ZG0->( !Eof() ) .and. ZG0->ZG0_CONTRA == @cNumEnd
	_x := aScan(aCols,{|x| x[3] == ZG0->ZG0_DATA})
	If _x != 0
		RecLock("SE2",.T.)
		SE2->E2_FILIAL	  := xFilial("SE2")
		SE2->E2_PREFIXO   := "END" // Prefixo para ENDIVIDAMENTO
		SE2->E2_NUM       := Alltrim(Str(_nSequenc)) + "J" + Strzero(nCont,3) + "A" // N�mero do contrato + caracter de controle(J = Pagamento de Juros; P = Pagamento de Parcelas
		SE2->E2_TIPO      := "01" // Modalidade do endividamento. 01 = Finame
		SE2->E2_NATUREZ   := @cNat
		SE2->E2_FORNECE   := @cForn
		SE2->E2_LOJA      := @cLoja
		SE2->E2_NOMFOR    := _cNomFor
		SE2->E2_EMISSAO   := dDataBase
		SE2->E2_VENCTO    := ZG0->ZG0_DATA
		SE2->E2_VENCREA   := ZG0->ZG0_DATA
		SE2->E2_VENCORI   := ZG0->ZG0_DATA
		SE2->E2_VALOR     := aCols[_x][9]
		SE2->E2_EMIS1     := ZG0->ZG0_DATA
		SE2->E2_SALDO     := aCols[_x][9]
		SE2->E2_MOEDA     := 1
		SE2->E2_FATURA    := ""
		SE2->E2_VLCRUZ    := aCols[_x][9]
		SE2->E2_ORIGEM    := ""
		SE2->E2_CC        := "IMOBILIZ"
		SE2->E2_FLUXO     := "S"
		SE2->E2_FILORIG   := xFilial("SE2")
		SE2->E2_DESDOBR   := "N"
		SE2->E2_RATEIO    := "N"
		SE2->E2_HIST	  := Alltrim(@cContrato)
		MsUnlock("SE2")
		nCont++
	EndIf
	ZG0->( DbSkip() )
EndDo

RecLock("ZF8",.F.)
ZF8->ZF8_FINJUR := .T.
MsUnLock("ZF8")
Return


User Function END001LEG()

Local aLegenda :=	{ {"BR_VERMELHO", OemToAnsi("Encerrado") },;
{"BR_VERDE"   , OemToAnsi("Aberto")}}

BrwLegenda(OemToAnsi("Endividamento"), "Legenda", aLegenda)

Return

//��������������������������Ŀ
//� CRIA A LEGENDA DO BROWSE �
//����������������������������
Static Function fCriaCor()
Local aLegenda :=	{ {"BR_VERMELHO", OemToAnsi("Fechada") },;
{"BR_VERDE"   , OemToAnsi("Aberta")}}
Local uRetorno := {}

Aadd(uRetorno, { 'ZF8_STATUS=="A" ' , aLegenda[2][1] } )
aAdd(uRetorno, { 'ZF8_STATUS=="E" ' , aLegenda[1][1] } )

Return(uRetorno)

*-------------------------*
Static Function GeraExcel()
*-------------------------*
_nOutFile := fCreate("C:\TEMP\ENDIVIDA.XLS",0)

If !File("C:\TEMP\ENDIVIDA.XLS")
	Alert("Arquivo n�o pode ser criado!")
	Return .F.
EndIf
cExcel := '<style>.tabela td {border:1px solid #000}</style>'
cExcel += "<table>		  	            	                  "
cExcel += '		<tr style="font-weight:bold">                '
cExcel += "			<td>No. do Endividamento            </td> "
cExcel += "			<td>Modalidade                      </td> "
cExcel += "			<td>Banco                           </td> "
cExcel += "			<td>N�mero do Contrato              </td> "
cExcel += "			<td>Valor do Financiamento          </td> "
cExcel += "			<td>Prazo   	                     </td> "
cExcel += "			<td>Car�ncia  	                     </td> "
cExcel += "			<td>Taxa de Juros BNDES             </td> "
cExcel += "			<td>Taxa de Juros  Banco            </td> "
cExcel += "			<td>Taxa de Juros Total             </td> "
cExcel += "			<td>Cta Contab.(Curto Prazo)        </td> "
cExcel += "			<td>Cta Contab.(Longo Prazo)        </td> "
cExcel += "			<td>Fornecedor                      </td> "
cExcel += "			<td>Natureza                        </td> "
cExcel += "		</tr>          		 		                  "

cExcel += "  	<tr>                        	                                                                     "
cExcel += "			<td>"+ cNumEnd                                                                       + "  </td> "
cExcel += "			<td>"+ cModal + '-' + _cDescMod                                                      + "  </td> "
cExcel += "			<td>"+ _cCodBan + '-' + _cDescBan                                                    + "  </td> "
cExcel += "			<td>"+ cContrato                                                                     + "  </td> "
cExcel += "			<td>"+ Transform(Val(Str(nVlrFinan)),"@E 999,999,999.99")                            + "  </td> "
cExcel += "			<td>"+ Str(nPrazo)                                                                   + "  </td> "
cExcel += "			<td>"+ Str(nCarencia)                                                                + "  </td> "
cExcel += "			<td>"+ Str(nJurBNDES)                                                                + "  </td> "
cExcel += "			<td>"+ Str(nJurBanco)                        										          + "  </td> "
cExcel += "			<td>"+ Str(nJurTot)            											                      + "  </td> "
cExcel += "			<td>"+ cContCcur                                     											 + "  </td> "
cExcel += "			<td>"+ cContC                                                                        + "  </td> "
cExcel += "			<td>"+ cForn + '-' + cLoja + Posicione('SA2',1,xFilial('SA2')+cForn+cLoja,'A2_NOME') + "  </td> "
cExcel += "			<td>"+ cNat                               										             + "  </td> "
cExcel += "  	</tr>                                                                                              "

cExcel += '		<tr style="font-weight:bold">'
cExcel += "			<td> Descri��o           </td> "
cExcel += "			<td> Valor 	           </td> "
cExcel += "			<td> Data Base           </td> "
cExcel += "			<td> Libera��o           </td> "
cExcel += "			<td> Dias 	              </td> "
cExcel += "			<td> N� Parcela          </td> "
cExcel += "			<td> Principal 	        </td> "
cExcel += "			<td> Juros 	           </td> "
cExcel += "			<td> Pagamento 	        </td> "
cExcel += "			<td> Saldo devedor       </td> "
cExcel += "			<td> Gerado no Sistema   </td> "
cExcel += "  	</tr>						 		                                            "

For i := 1 to Len(aCols)
	cExcel += '  <tr class="tabela">  				 	  		  '
	cExcel += '	 	<td> ' + aCols[i][1] 		 + '</td> '                                  	            		   	      			               			  // Descri��o
	cExcel += '		<td style=mso-number-format:"currency"> ' + Str(aCols[i][2])  + '</td> '   	      	      		   	         	         				  // Valor
	cExcel += '		<td> ' + Dtoc(aCols[i][3] )  + '</td> '                                       		            		               				   		  // Data/Data Base
	cExcel += '		<td> ' + Iif(!Empty(aCols[i][4]),Dtoc(aCols[i][4]),'')  + '</td> '	      	   	            	   	            		  					  // Data de Vencimento
	cExcel += '		<td> ' + Iif(!Empty(aCols[i][5]),Str(aCols[i][5]),'') + '</td> '	      	         	      	         	      					     	  	  // Dias
	cExcel += '		<td> ' + Iif(!Empty(aCols[i][6]),Str(aCols[i][6]),'') + '</td> '     	               		               		 	     						  // N�mero da Parcela
	cExcel += '		<td style=mso-number-format:"currency"> ' + Transform(Val(Str(aCols[i][07])),"@E 999,999,999.99") + '</td> ' 										  // Valor Principal
	cExcel += '		<td style=mso-number-format:"currency"> ' + Transform(Val(Str(aCols[i][08])),"@E 999,999,999.99") + '</td> '                                // Valor Juros
	cExcel += '		<td style=mso-number-format:"currency"> ' + Transform(Val(Str(aCols[i][09])),"@E 999,999,999.99") + '</td> '                                // Valor p/Pagamento
	cExcel += '		<td style=mso-number-format:"currency"> ' + Transform(Val(Str(aCols[i][10])),"@E 999,999,999.99") + '</td> '                                // Saldo Devedor
	cExcel += '		<td style=mso-number-format:"currency"> ' + Iif(!Empty(aCols[i][11]),Transform(Val(Str(aCols[i][11])),"@E 999,999,999.99"),'') + '</td> '   // Gerado no Sistema
	cExcel += '  </tr>						 	  		  '
Next i
cExcel += "</table>								  		  "

fWrite(_nOutFile,cExcel)
fClose(_nOutFile)

ShellExecute( "open", "excel.exe","C:\TEMP\ENDIVIDA.XLS","",5 )

Return

Static Function isFeriado(Datta)

ZG4->( DbSetOrder(1) )
If ZG4->( DbSeek(xFilial("ZG4") + Dtos(Datta) ))
	Return .T.
EndIf

Return .F.

Static Function findSaldo(Datta)

If Datta > aCols[Len(aCols)][3]
	alert("Data digitada deve ser menor que a �ltima parcela do contrato! Favor verifique!")
	Return .F.
EndIf

_x := aScan(aCols,{|x| x[3] == Datta} )
While _x == 0
	_x := aScan(aCols,{|x| x[3] == Datta} )
	Datta++
EndDo

_SaldDev := aCols[_x,10]
_dSData	 := aCols[_x,3]
oDlg:Refresh()
Return

Static Function DescBco(Cod)
SA6->( DbSetOrder(1) )
If !SA6->(DbSeek(xFilial("SA6") + Cod ))
	alert("Banco n�o encontrado, Verifique!")
	Return .F.
EndiF
_cDescBan := SA6->A6_NOME
oDlg:Refresh()
Return

Static Function DescMod(Cod)
ZGA->( DbSetOrder(1) )
If !ZGA->(DbSeek(xFilial("ZGA") + Cod ))
	alert("Modalidade n�o encontrada, Verifique!")
	Return .F.
EndiF
_cDescMod := ZGA->ZGA_DESMOD
oDlg:Refresh()
Return

Static Function fnCContab(vConta)
If Empty(Iif(vConta==1,cContCcur,cContC))
	Return(.F.)
Endif
CT1->(DbSetOrder(1))
If !CT1->(DbSeek(xFilial("CT1")+Iif(vConta==1,cContCcur,cContC)))
	Msgbox("Conta n�o encontrada, Verifique!" ,"Atencao","ALERT" )
	Iif(vConta==1,oGet8,oGet9):SetFocus(Iif(vConta==1,oGet8,oGet9))
	Iif(vConta==1,oGet8,oGet9):Refresh()
	Return(.F.)
Endif

Iif(vConta==1,oGet8,oGet9):Refresh()

Return(.T.)

Static Function fnFornece()

If Empty(cForn) .Or. Len(Alltrim(cForn)) < 6
	Return(.F.)
Endif

SA2->(DbSetOrder(1))
If !SA2->(DbSeek(xFilial("SA2")+cForn,.T.))
	Msgbox("Fornecedor n�o encontrado, Verifique !!!" ,"Atencao","ALERT" )
	oForn:SetFocus(oForn)
	oForn:Refresh()
	Return(.F.)
Endif

If Empty(cLoja)
	cLoja := "01" //traz a loja padrao
EndIf

oLoja:Refresh()

Return(.T.)

Static Function fnNatureza()

If Empty(cNat)
	Return(.F.)
Endif

SED->(DbSetOrder(1))
If !SED->(DbSeek(xFilial("SED")+cNat))
	Msgbox("Natureza n�o encontrada, Verifique !!!" ,"Atencao","ALERT" )
	oNat:SetFocus(oNat)
	oNat:Refresh()
	Return(.F.)
Endif

oNat:Refresh()

Return(.T.)
