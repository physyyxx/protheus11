/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �SD3250I  Autor �Guilherme Dem�trio Camargo � Data 07/05/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �     Gera o desmonte do item RT01.000001 no armaz�m 22      ���
���          �     para MP01.000004                                       ���
�������������������������������������������������������������������������͹��
���Uso       � MATA261                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"              
#include "colors.ch"
#include "font.ch"
#include "Topconn.ch"
#include "protheus.ch"

User Function SD3250I()

Local aAreaSD3 := SD3->(GetArea())
Local aAreaSB1 := SB1->(GetArea())

	If alltrim(SC2->C2_LOCAL)$"22/23"
		Processa({||fDesmon()}," Aguarde transferindo RT01.000001...")
	Endif

SD3->(RestArea(aAreaSD3))
SB1->(RestArea(aAreaSB1))

Return NIL

//-- gera o desmonte do item RT01.000001 para MP01.000004
Static Function fDesmon()
Private lMsErroAuto
Private aSB1 	:= {}
Private aArray 	:= {}
Private nI		:= 0                                                                                                       

	cQuery := "SELECT D3_COD,D3_QUANT,D3_LOCAL,D3_CC "
	cQuery += " FROM "+RetSqlName('SD3')+" D3 (NOLOCK) "
	cQuery += " WHERE D3_OP = '" + SC2->C2_NUM + SC2->C2_ITEM + SC2->C2_SEQUEN +"'"
	cQuery += " AND D3_COD = 'RT01.000001'"
	cQuery += " AND D3_LOCAL = '22'"

	If Select("TRA1") > 0
		TRA1->(dbclosearea())
	Endif

	//MemoWrit('C:\TEMP\SD3250I.SQL',cQuery)
	TCQUERY cQuery NEW ALIAS "TRA1" 

	TRA1->(DbGotop())
	SB1->(DbSetOrder(1))// FILIAL + COD

	If(SB1->(DbSeek(xFilial("SB1") + 'MP01.000004')))
		aSB1 := {SB1->B1_DESC, SB1->B1_UM}
	Endif

	DbSelectArea('SD3')
	_cDoc  := NextNumero("SD3",2,"D3_DOC",.T.)//pega o proximo numero do documento do d3_doc
	//-- CABECALHO	
	aArray := {{_cDoc,;		// 01.Numero do Documento
				ddatabase}}	// 02.Data da Transferencia	
	//--DETALHE
	While TRA1->(!Eof())
		If(SB1->(DbSeek(xFilial("SB1") + TRA1->D3_COD)))			

		   	nI := Ascan(aArray, {|x| AllTrim(x[1]) == Alltrim(SB1->B1_COD)})
			If nI <> 0
		      aArray[nI][16] += TRA1->D3_QUANT //Soma a qtde quando tiver mais de uma vez o produto
			Else
				aAdd(aArray,{	SB1->B1_COD,;					// 01.Produto Origem
						    	SB1->B1_DESC,;  				// 02.Descricao
								SB1->B1_UM,; 	            	// 03.Unidade de Medida
								TRA1->D3_LOCAL,; 				// 04.Local Origem
								CriaVar("D3_LOCALIZ",.F.),;		// 05.Endereco Origem
								"MP01.000004    ",;				// 06.Produto Destino
								aSB1[1],;						// 07.Descricao
								aSB1[2],;						// 08.Unidade de Medida
								TRA1->D3_LOCAL,;				// 09.Armazem Destino
								CriaVar("D3_LOCALIZ",.F.),;		// 10.Endereco Destino
								CriaVar("D3_NUMSERI",.F.),;		// 11.Numero de Serie
								CriaVar("D3_LOTECTL",.F.),; 	// 12.Lote Origem
								CriaVar("D3_NUMLOTE",.F.),;		// 13.Sublote
								CriaVar("D3_DTVALID",.F.),;		// 14.Data de Validade
								CriaVar("D3_POTENCI",.F.),;		// 15.Potencia do Lote
								TRA1->D3_QUANT,;				// 16.Quantidade
								CriaVar("D3_QTSEGUM",.F.),;		// 17.Quantidade na 2 UM             	
								CriaVar("D3_ESTORNO",.F.),;		// 18.Estorno
								CriaVar("D3_NUMSEQ",.F.),;		// 19.NumSeq
								CriaVar("D3_LOTECTL",.F.),;		// 20.Lote Destino
								CRIAVAR("D3_DTVALID",.F.),;     // 21.Data Validade
								CRIAVAR("D3_ITEMGRD",.F.),;     // 22.Item da grade
								CRIAVAR("D3_CARDEF",.F.),;		// 23.Car. Defeito
								CRIAVAR("D3_DEFEITO",.F.),;		// 24.Cod. Defeito
								CRIAVAR("D3_OPERACA",.F.),;		// 25.Opera��o
								CRIAVAR("D3_FORNECE",.F.),;		// 26.Fornecedor
								CRIAVAR("D3_LOJA",.F.),;		// 27.Loja
								CRIAVAR("D3_LOCORIG",.F.),;		// 28.Local Origem
								TRA1->D3_CC,;					// 29.CENTRO DE CUSTO
								CRIAVAR("D3_TURNO",.F.),;		// 30.Turno
								CRIAVAR("D3_MAQUINA",.F.),;		// 31.Maquina
								CRIAVAR("D3_LINHA",.F.),;		// 32.Num. Linha Prod.
								CRIAVAR("D3_CODPA",.F.),;		// 33.Cod. PA
								CRIAVAR("D3_DTREF",.F.),;		// 34.Data Ref.
								CRIAVAR("D3_CORRID",.F.),;      // 33.Codigo PA - Adicionado em 12/12/12	
								CRIAVAR("D3_CORRIDA",.F.),;      // 33.Codigo PA - Adicionado em 12/12/12									
								CRIAVAR("D3_OP",.F.)})	        // 35. ADICIONADO 21/10/2013 - OEE X OP
			Endif
		Endif	
		TRA1->(DbSkip())
	Enddo
	
	TRA1->(DbCloseArea())
	
	If Len(aArray) > 1 // 
		DbSelectArea('SD3')
		Processa({|| MSExecAuto({|x| MATA261(x)},aArray)},"Aguarde. Transferindo...")   
		If lMsErroAuto
			mostraerro()
			DisarmTransaction()
			Return 
		EndIf
	EndIf

	aArray := {}
	
Return