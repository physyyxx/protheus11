/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHCOM042  �Autor  �Marcos R Roquitski  � Data �  13/06/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Aprovacao das Solicitacoes de Compras.                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �WHB                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/* Status de aprovacao
	A - Aprovado
	B - Aguardando
	C - Rejeitado
	  - Pendente
*/	

#include "rwmake.ch"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLOR.CH"
#INCLUDE "FONT.CH"
#INCLUDE "MSOLE.CH"
#INCLUDE "DBTREE.CH"
#include "ap5mail.ch"
#include "tbiconn.ch"
#include "inkey.ch"
#INCLUDE "TOPCONN.CH"

User function Nhcom042()
Local oRadio             
Local oDlgHis                          
SetPrvt("mStruct,mArqTrab,aFields,aRotina,cDelFunc,cCadastro,cMarca,cCoord,_aGrupo,_cLogin,_cLogin2")
SetPrvt("cServer,cAccount,cPassword,lConectou,lEnviado,cMensagem,CRLF,cMSG,_cMail,_cNome")
SetPrvt("_dDatade,_dDatate,_cSitu,_cObs")
SetPrvt("cCadastro,aRotina,cAlias,cMsg,_nPos")


DEFINE FONT oFont NAME "Arial" SIZE 12, -12                                                                  
DEFINE FONT oFont10 NAME "Arial" SIZE 10, -10                                                                  

cServer	  := Alltrim(GETMV("MV_RELSERV")) //"192.168.1.11"
cAccount  := Alltrim(GETMV("MV_RELACNT"))//'protheus'
cPassword := Alltrim(GETMV("MV_RELPSW"))//'siga'
cMensagem := '' 
cMSG      := ""
_aGrupo   := pswret()
_cLogin   := _agrupo[1,2]
_nPos     := 1 

   Define MsDialog oDlgHis Title OemToAnsi("Aprova��o") From 100,050 To 300,400 Pixel 
   @ 110,055 To 010,245                                     
   @ 015,030 Say OemToAnsi("Escolha Uma Op�ao") Color CLR_BLUE Size 450,8 Object oItem                        
      oItem:Setfont(oFont)                      
   @ 035,040 Radio oRadio VAR _nPos ITEMS OemToAnsi("Solicita��o de Compras"),;
		     OemToAnsi("Pedido em Aberto"), OemToAnsi("Autoriza��o de Entrega"),OemToAnsi("Pedido de Compras (Altera��o)") 3D SIZE 90,10 OF oDlgHis //PIXEL ON Change frad() // "&Remessa" ### "R&etorno"   
   @ 080,120 BUTTON OemToAnsi("_OK") SIZE 30,12 ACTION fOK() Object oBtnAp  
   @ 080,070 BUTTON OemToAnsi("_Cancela") SIZE 35,12 ACTION Close(oDlgHis) Object oBtnCa     
   
   Activate msDialog oDlgHis Centered 


Return


Static Function fOK()
mStruct := {}
aFields := {}

   If  _nPos == 4 .And. !Alltrim(Upper(cUsername))$"MAURICIOFO/ADMINISTRADOR/ALEXANDRERB/BERNYH"  
      MsgBox("Usuario Nao esta Autorizado a Utilizar esta Rotina !","Atencao !","INFO")   
      Return
   Endif

   AADD(mStruct,{"DT_MARCA",    "C",01,0})
   Aadd(aFields,{"DT_MARCA"     ,"C",OemToAnsi("   ")  })   
   
   If _nPos == 1

      cMsg   := OemToAnsi("Solicita��o de Compras")
      cAlias := "SC1"
      AADD(mStruct,{"DT_NUM",      "C",06,0})
      AADD(mStruct,{"DT_ITEM",     "C",04,0})      
      AADD(mStruct,{"DT_DESCRI",   "C",30,0})
      AADD(mStruct,{"DT_PRODUTO",  "C",15,0})
      AADD(mStruct,{"DT_LOGIN",    "C",25,0})
	  AADD(mStruct,{"DT_QUANT",    "N",14,4})
	  AADD(mStruct,{"DT_QTEST",    "N",14,4})
      AADD(mStruct,{"DT_VUNIT",    "N",16,2})
      AADD(mStruct,{"DT_VALOR",    "N",16,2})
      AADD(mStruct,{"DT_VLRPC",    "N",16,2})
	  AADD(mStruct,{"DT_EMISSAO",  "D",08,0})
	  AADD(mStruct,{"DT_ATENCAO",  "C",10,0})
	  AADD(mStruct,{"DT_SOLICIT",  "C",15,0})
	  AADD(mStruct,{"DT_ANEXO",    "C",03,0}) 
 	  AADD(mStruct,{"DT_ANEXO1",  "C",100,0})
	  AADD(mStruct,{"DT_ANEXO2",  "C",100,0})
 	  AADD(mStruct,{"DT_ANEXO3",  "C",100,0})
	  AADD(mStruct,{"DT_OBS",     "C",250,0})
      
	 Aadd(aFields,{"DT_ANEXO"     ,"C",OemToAnsi("Anexo") })    
	 Aadd(aFields,{"DT_NUM"       ,"C",OemToAnsi("Numero") })    
	 Aadd(aFields,{"DT_ITEM"      ,"C",OemToAnsi("Item") })      
 	 Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
	 Aadd(aFields,{"DT_DESCRI"    ,"C",OemToAnsi("Descricao") })
	 Aadd(aFields,{"DT_QUANT"     ,"N",OemToAnsi("Qtde"),"@E 999999999.9999"})
	 Aadd(aFields,{"DT_QTEST"     ,"N",OemToAnsi("Estoque"),"@E 999999999.9999"})
	 Aadd(aFields,{"DT_VUNIT"     ,"N",OemToAnsi("Vlr. Estimado"),"@E 999,999,999.99"})
	 Aadd(aFields,{"DT_VALOR"     ,"N",OemToAnsi("Total"),"@E 999,999,999.99"})
	 Aadd(aFields,{"DT_VLRPC"     ,"N",OemToAnsi("Vl.Ult.PC"),"@E 999,999,999.99"})
	 Aadd(aFields,{"DT_SOLICIT"   ,"C",OemToAnsi("Solicitante")  })
	 Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })
	 Aadd(aFields,{"DT_OBS"       ,"D",OemToAnsi("Observacao") })
	 Aadd(aFields,{"DT_LOGIN"     ,"C",OemToAnsi("Responsavel")})
	 Aadd(aFields,{"DT_ATENCAO"   ,"C",OemToAnsi("Status") })
	      
   ElseIf _nPos == 2

      cMsg := "Pedido em Aberto"
      cAlias := "SC3"      
      AADD(mStruct,{"DT_NUMCT",    "C",06,0})
      AADD(mStruct,{"DT_ITEMCT",   "C",04,0})
	  AADD(mStruct,{"DT_NUMREV",   "C",02,0})
      AADD(mStruct,{"DT_DESCRI",   "C",30,0})
      AADD(mStruct,{"DT_PRODUTO",  "C",15,0})
      AADD(mStruct,{"DT_LOGIN",    "C",25,0})
	  AADD(mStruct,{"DT_QUANTP",    "N",14,4})
	  AADD(mStruct,{"DT_VUNITP",    "N",16,2})
	  AADD(mStruct,{"DT_VALORP",    "N",16,2})
	  AADD(mStruct,{"DT_EMISSAO",  "D",08,0})
      AADD(mStruct,{"DT_NIVEL",     "C",01,0})	  
	        
	  Aadd(aFields,{"DT_NUMCT"     ,"C",OemToAnsi("Ped.Aberto") })    
	  Aadd(aFields,{"DT_ITEMCT"    ,"C",OemToAnsi("Item P.A.") })
	  Aadd(aFields,{"DT_NUMREV"    ,"C",OemToAnsi("Revis�o") })   	  
	  Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
	  Aadd(aFields,{"DT_DESCRI"    ,"C",OemToAnsi("Descricao") })
 	  Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })	  
      Aadd(aFields,{"DT_LOGIN"     ,"C",OemToAnsi("Responsavel")})
	  Aadd(aFields,{"DT_QUANTP"    ,"N",OemToAnsi("Qtde Ped.A."),"@E 999999999.9999"})
	  Aadd(aFields,{"DT_VUNITP"    ,"N",OemToAnsi("Vlr. Ped.A."),"@E 999,999,999.99"})
	  Aadd(aFields,{"DT_VALORP"    ,"N",OemToAnsi("Total Ped.A."),"@E 999,999,999.99"})
      
   ElseIf _nPos == 3

      cMsg := OemToAnsi("Autoriza��o de Entrega")
      cAlias := "SC7"            
      Aadd(mStruct,{"DT_NUMPED",   "C",06,0})    
      Aadd(mStruct,{"DT_ITEMPED",  "C",04,0})
      AADD(mStruct,{"DT_DESCRI",   "C",30,0})
      AADD(mStruct,{"DT_PRODUTO",  "C",15,0})
	  AADD(mStruct,{"DT_EMISSAO",  "D",08,0})
      AADD(mStruct,{"DT_LOGIN",    "C",25,0})
	  AADD(mStruct,{"DT_QUANTAE",  "N",14,4})
	  AADD(mStruct,{"DT_VUNITAE",  "N",16,2})
	  AADD(mStruct,{"DT_VALORAE",  "N",16,2})

	  Aadd(aFields,{"DT_NUMPED"    ,"C",OemToAnsi("Aut.Entrega") })    
	  Aadd(aFields,{"DT_ITEMPED"   ,"C",OemToAnsi("Item A.E.") })
	  Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
	  Aadd(aFields,{"DT_DESCRI"    ,"C",OemToAnsi("Descricao") }) 
 	  Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })	  	  
      Aadd(aFields,{"DT_LOGIN"     ,"C",OemToAnsi("Responsavel")})
	  Aadd(aFields,{"DT_QUANTAE"    ,"N",OemToAnsi("Qtde A.E."),"@E 999999999.9999"})
	  Aadd(aFields,{"DT_VUNITAE"    ,"N",OemToAnsi("Vlr. A.E."),"@E 999,999,999.99"})
	  Aadd(aFields,{"DT_VALORAE"    ,"N",OemToAnsi("Total A.E."),"@E 999,999,999.99"})

   ElseIf _nPos == 4

      cMsg := OemToAnsi("Pedido de Compras (Altera��o)")
      cAlias := "C77"                 
      
      Aadd(mStruct,{"DT_NUMPED",   "C",06,0})    
      Aadd(mStruct,{"DT_ITEMPED",  "C",04,0})
      AADD(mStruct,{"DT_DESCRI",   "C",30,0})
      AADD(mStruct,{"DT_PRODUTO",  "C",15,0})
	  AADD(mStruct,{"DT_EMISSAO",  "D",08,0})
      AADD(mStruct,{"DT_LOGIN",    "C",25,0})
	  AADD(mStruct,{"DT_QUANTAE",  "N",14,4})
	  AADD(mStruct,{"DT_VUNITAE",  "N",16,2})
	  AADD(mStruct,{"DT_VALORAE",  "N",16,2})

	  Aadd(aFields,{"DT_NUMPED"    ,"C",OemToAnsi("Pedido") })    
	  Aadd(aFields,{"DT_ITEMPED"   ,"C",OemToAnsi("Item") })
	  Aadd(aFields,{"DT_PRODUTO"   ,"C",OemToAnsi("Produto") })   
	  Aadd(aFields,{"DT_DESCRI"    ,"C",OemToAnsi("Descricao") }) 
 	  Aadd(aFields,{"DT_EMISSAO"   ,"D",OemToAnsi("Emissao") })	  	  
      Aadd(aFields,{"DT_LOGIN"     ,"C",OemToAnsi("Responsavel")})
	  Aadd(aFields,{"DT_QUANTAE"    ,"N",OemToAnsi("Qtde"),"@E 999999999.9999"})
	  Aadd(aFields,{"DT_VUNITAE"    ,"N",OemToAnsi("Vlr."),"@E 999,999,999.99"})
	  Aadd(aFields,{"DT_VALORAE"    ,"N",OemToAnsi("Total"),"@E 999,999,999.99"})

   Endif

	mArqTrab := CriaTrab(mStruct,.t.) 
	USE &mArqTrab Alias XDET New Exclusive 

    Index on DTOS(XDET->DT_EMISSAO) to (mArqTrab)
    
Processa( {|| fDetalhes()})
                            
DbSelectArea("XDET")
XDET->(DbGotop())

If Reccount() <=0
	MsgBox("Nao ha registro Selecionados !","Atencao !","INFO")
	DbCloseArea("XDET")
	Return
Endif

aRotina := { {"Aprovar"       ,'U_fApSc()', 0 , 1 },;
             {"Rejeitar"      ,'U_fReSc()', 0 , 1 },;
             {"Observacao"    ,'U_fRobs()', 0 , 1 },;
             {"Anexo 1"      ,'U_fAnexodet(1)', 0 , 1 },;
             {"Anexo 2"      ,'U_fAnexodet(2)', 0 , 1 },;
             {"Anexo 3"      ,'U_fAnexodet(3)', 0 , 1 },;
             {"Filtrar"      ,'U_fFilApr()', 0 , 1 },;
             {"Historico"    ,'MacomView(XDET->DT_PRODUTO)', 0 , 1 }}
                                     
cDelFunc  := ".T."  
cCadastro := OemToAnsi("Aprova��o - <ENTER> Marca/Desmarca")
cMarca    := getmark()
cCoord    := {50,50,600,600}
                
MarkBrow("XDET","DT_MARCA" ,"XDET->DT_MARCA",afields,,cMarca)

XDET->(DbGotop())
While !XDET->(Eof())
   If EMPTY(ALLTRIM(XDET->DT_MARCA))
      Dele
   Endif
   XDET->(DbSkip())
Enddo
DbCloseArea("XDET")

Return

Static Function fDetalhes()
Local _aGrupo,_cLogin,nRecno,_cNumSc,_cNivel,_cOk

_aGrupo  := pswret()     // Retorna vetor com dados do usuario
_cLogin  := _agrupo[1,2] // Apelido
_cNivel  := Space(01)
_cOk     := 'S'
_cLogin2 := Space(25)

DbSelectarea("SC1")
SET FILTER TO 
SC1->(DbGotop())
                                             
DbSelectArea("XDET")
Zap

DBSELECTAREA('SZU')
SET FILTER TO SZU->ZU_ORIGEM==cAlias .AND. Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin) .AND. SZU->ZU_STATUS<>'A'

// Processa Login Principal
SZU->(DbSetOrder(1))
SZU->(DbSeek(xFilial("SZU")+_cLogin))

procregua(0)

While !SZU->(Eof()) .AND. Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin)

	incproc()
	
	If SZU->ZU_STATUS=='A' .OR. SZU->ZU_ORIGEM!=cAlias
		SZU->(dbSkip())
		loop
	Endif

	If SZU->ZU_FILIAL == xFilial("SZU")

		_cOk := 'S'

		If (SZU->ZU_STATUS == 'B' .OR. Empty(SZU->ZU_STATUS)) .And. SZU->ZU_ORIGEM==cAlias  	
		   If _nPos == 4 // pedido de compras alteracao
			   IF SZU->ZU_ORIGEM$"C77" //Para aparecer o pedido feito sem solicitacao p/ aprovacao
	
					If SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED+SZU->ZU_ITEMPED)) .AND. _cOk == 'S'
						ApTitulo1()
					Endif

			   Endif
		   ElseIf _nPos==3 // AE
				_nRecno  := SZU->(Recno())
				_cNumPed := SZU->ZU_NUMPED+SZU->ZU_ITEMPED
				_cNivel  := SZU->ZU_NIVEL
				
				SZU->(DbSetOrder(4)) //ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL
				SZU->(DbSeek(xFilial("SZU")+_cNumPed))
				
				While !SZU->(Eof()) .And. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == _cNumPed
					If (SZU->ZU_STATUS $ "B/C" .And. Alltrim(SZU->ZU_LOGIN) <> Alltrim(_cLogin) )
						_cOk := "N"
						Exit
					Else
						If (Empty(SZU->ZU_STATUS) .AND. SZU->ZU_NIVEL < _cNivel)		
							_cOk := "N"	
							Exit
						Endif	
					Endif
					SZU->(DbSkip())
				Enddo
				
				SZU->(DbSetOrder(1))
				SZU->(DbGoto(_nRecno))
	
				//-- Conforme acordo com MauricioFO
				//-- para aprova��o de AE n�o precisa ter emitidouma SC.

				If _cOk == 'S'
					ApTitulo1()
				Endif
		   
		   Else
				_nRecno := SZU->(Recno())
				_cNumSc := SZU->ZU_NUM+SZU->ZU_ITEM
				_cNivel := SZU->ZU_NIVEL
				
				SZU->(DbSetOrder(2))
				SZU->(DbSeek(xFilial("SZU")+_cNumSc))

				While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == _cNumSc
					If (SZU->ZU_STATUS $ "B/C" .And. Alltrim(SZU->ZU_LOGIN) <> Alltrim(_cLogin) )
						_cOk := "N"
						Exit
					Else
						If (Empty(SZU->ZU_STATUS) .AND. SZU->ZU_NIVEL < _cNivel)		
							_cOk := "N"	
							Exit
						Endif	
					Endif
					SZU->(DbSkip())
				Enddo
				SZU->(DbSetOrder(1))
				SZU->(DbGoto(_nRecno))
	
				If _cOk == 'S'
					If SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
						ApTitulo1()
					EndIf
				Endif
	
		   Endif		
	
		Endif	
	Endif	
	SZU->(DbSkip())
Enddo

DBSELECTAREA('SZU')
SET FILTER TO


// Processa responsavel nomeado
DbSelectarea("SZV")
SZV->(DbSetOrder(2))
SZV->(DbSeek(xFilial("SZV")+_cLogin))
While !SZV->(Eof())
	If (DATE() >= SZV->ZV_DATDE .AND. DATE() <= SZV->ZV_DATAT)
		If Alltrim(SZV->ZV_LOGDE) == Alltrim(_cLogin)

			_cLogin2 := SZV->ZV_LOGOR
			SZU->(DbSeek(xFilial("SZU")+_cLogin2))

			While !SZU->(Eof()) .AND. Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin2)

				If SZV->ZV_FILIAL == xFilial("SZU")
			
					_cOk := 'S'
			       If (SZU->ZU_STATUS == 'B' .OR. Empty(SZU->ZU_STATUS)) .And. SZU->ZU_ORIGEM==cAlias  	   	           
	   	              If _nPos == 4 // pedido de compras alteracao          	    
	          	         IF SZU->ZU_ORIGEM$"C77"

							SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED+SZU->ZU_ITEMPED))
							If SC7->(Found()) .AND. _cOk == 'S'
								ApTitulo2()
							Endif
						 Endif
				      Else

						_nRecno := SZU->(Recno())
						_cNumSc := SZU->ZU_NUM+SZU->ZU_ITEM
						_cNivel := SZU->ZU_NIVEL
	
						SZU->(DbSetOrder(2))
						SZU->(DbSeek(xFilial("SZU")+_cNumSc))
						While !SZU->(Eof()) .And. SZU->ZU_NUM+SZU->ZU_ITEM == _cNumSc
							
							If SZU->ZU_STATUS $ "B/C"
								_cOk := "N"
								Exit
							Else
								If ( EMPTY(SZU->ZU_STATUS) .And. SZU->ZU_NIVEL < _cNivel)
									_cOk := "N"
									Exit
								Else
									If Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin) .And. SZU->ZU_ORIGEM$cAlias
										Exit
									Endif	
								Endif
							Endif	
							SZU->(DbSkip())
						Enddo
	
						SZU->(DbSetOrder(1))
						SZU->(DbGoto(_nRecno))
	
						SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
						If SC1->(Found()) .AND. _cOk == 'S'
							ApTitulo2()
						Endif
					  Endif
				   Endif
				Endif				   
				SZU->(DbSkip())
			Enddo
		Endif
	Endif
	SZV->(DbSkip())
Enddo

Return(.T.)


Static Function ApTitulo1()
Local _nUltPrc := 0

SB2->(DbSetOrder(1))
   RecLock("XDET",.T.)

   If _nPos == 1 .And. SZU->ZU_ORIGEM$"SC1"
      cMsg   := OemToAnsi("Solicita��o de Compras")
      cAlias := "SC1"
      
	  XDET->DT_NUM       := SC1->C1_NUM
	  XDET->DT_ITEM      := SC1->C1_ITEM
      XDET->DT_QUANT     := SC1->C1_QUANT
	  XDET->DT_VUNIT     := SC1->C1_VUNIT
	  XDET->DT_SOLICIT   := SC1->C1_SOLICIT
	  XDET->DT_VALOR     := (SC1->C1_VUNIT * SC1->C1_QUANT)
	  XDET->DT_EMISSAO   := SC1->C1_EMISSAO
	  XDET->DT_ATENCAO   := IIF(SZU->ZU_STATUS == 'B',"Aguardando",Space(10))
	  XDET->DT_ANEXO     := Iif(!EMPTY(SC1->C1_ANEXO1),"Sim","  ")
	  XDET->DT_ANEXO1    := SC1->C1_ANEXO1
	  XDET->DT_ANEXO2    := SC1->C1_ANEXO2
	  XDET->DT_ANEXO3    := SC1->C1_ANEXO3		
	  XDET->DT_OBS       := SC1->C1_OBS   		
	  XDET->DT_PRODUTO   := SC1->C1_PRODUTO
	  XDET->DT_DESCRI    := SC1->C1_DESCRI
	  

	  SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	  If SB1->(Found())
	  	 If SB1->B1_GENERIC == '1'
			XDET->DT_VLRPC := SB1->B1_UPRC
		 Endif	
      Endif
	
	  SB2->(DbSeek(xFilial("SB2")+SC1->C1_PRODUTO))
 	  While !SB2->(Eof()) .And. SB2->B2_COD == SC1->C1_PRODUTO
		 XDET->DT_QTEST += SB2->B2_QATU
		 SB2->(DbSkip())
	  Enddo		

   ElseIf _nPos == 2 .And. SZU->ZU_ORIGEM$"SC3"
      cMsg := "Pedido em Aberto"
      cAlias := "SC3"      
	XDET->DT_NUMCT     := SZU->ZU_NUMCT  //numero do contrato
	XDET->DT_ITEMCT    := SZU->ZU_ITEMCT	//item do contrato
    XDET->DT_NUMREV    := SZU->ZU_NUMREV //Numero da revisao
    XDET->DT_NIVEL     := SZU->ZU_NIVEL  //Numero da revisao
  //Dados do pedido de compra em aberto para aprovacao         
    If !Empty(SZU->ZU_NUMCT)
       SC3->(DbSetOrder(1))
	   SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT + SZU->ZU_ITEMCT ))
	   If SC3->(Found())
	      XDET->DT_QUANTP     := Iif(Empty(SC3->C3_NUMREV),SC3->C3_QUANT,SC3->C3_QUANT-SC3->C3_QUJE)
	      XDET->DT_VUNITP     := SC3->C3_PRECO
	      XDET->DT_VALORP     := Iif(Empty(SC3->C3_NUMREV),(SC3->C3_PRECO * SC3->C3_QUANT),(SC3->C3_PRECO * (SC3->C3_QUANT-SC3->C3_QUJE)))
      	  XDET->DT_EMISSAO    := SC3->C3_EMISSAO
	      XDET->DT_PRODUTO   := SC3->C3_PRODUTO
	      XDET->DT_DESCRI    := SC1->C1_DESCRI
      	  
       Endif
    Endif   

   ElseIf _nPos == 3 .And. SZU->ZU_ORIGEM$"SC7"

      cMsg := OemToAnsi("Autoriza��o de Entrega")
      cAlias := "SC7"            
	  XDET->DT_NUMPED    := SZU->ZU_NUMPED //numero da autorizacao de entrga
	  XDET->DT_ITEMPED   := SZU->ZU_ITEMPED //item da autorizacao de entrga

    If !Empty(SZU->ZU_NUMPED)
       SC7->(DbSetOrder(1))
	   SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED + SZU->ZU_ITEMPED ))
	   If SC7->(Found())
	      XDET->DT_QUANTAE    := SC7->C7_QUANT
	      XDET->DT_VUNITAE    := SC7->C7_PRECO
	      XDET->DT_VALORAE    := (SC7->C7_PRECO * SC7->C7_QUANT)
      	  XDET->DT_EMISSAO    := SC7->C7_EMISSAO
          XDET->DT_PRODUTO    := SC7->C7_PRODUTO
	      XDET->DT_DESCRI     := SC7->C7_DESCRI
      	  
       Endif
    Endif   
 

   ElseIf _nPos == 4 .And. SZU->ZU_ORIGEM$"C77"
      cMsg :=   OemToAnsi("Pedido de Compras (Altera��o)")
      cAlias := "C77"            
	  XDET->DT_NUMPED    := SZU->ZU_NUMPED //numero da autorizacao de entrga
	  XDET->DT_ITEMPED   := SZU->ZU_ITEMPED //item da autorizacao de entrga

    If !Empty(SZU->ZU_NUMPED)
       SC7->(DbSetOrder(1))
	   SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED + SZU->ZU_ITEMPED ))
	   If SC7->(Found())
	      XDET->DT_QUANTAE    := SC7->C7_QUANT
	      XDET->DT_VUNITAE    := SC7->C7_PRECO
	      XDET->DT_VALORAE    := (SC7->C7_PRECO * SC7->C7_QUANT)
      	  XDET->DT_EMISSAO    := SC7->C7_EMISSAO
	      XDET->DT_PRODUTO   := SC7->C7_PRODUTO
	      XDET->DT_DESCRI    := SC7->C7_DESCRI
      	  
       Endif
    Endif   
 
      
   Endif

//	XDET->DT_PRODUTO   := SC1->C1_PRODUTO
//	XDET->DT_DESCRI    := SC1->C1_DESCRI
	XDET->DT_LOGIN     := _cLogin
		
	MsUnlock("XDET")
	
	
	
Return


//
Static Function ApTitulo2()
Local _nUltPrc := 0
                                                                  
   RecLock("XDET",.T.)

   If _nPos == 1
      cMsg   := OemToAnsi("Solicita��o de Compras")
      cAlias := "SC1"
      
	  XDET->DT_NUM       := SC1->C1_NUM
	  XDET->DT_ITEM      := SC1->C1_ITEM
      XDET->DT_QUANT     := SC1->C1_QUANT
	  XDET->DT_VUNIT     := SC1->C1_VUNIT
	  XDET->DT_SOLICIT   := SC1->C1_SOLICIT
	  XDET->DT_VALOR     := (SC1->C1_VUNIT * SC1->C1_QUANT)
	  XDET->DT_EMISSAO   := SC1->C1_EMISSAO
	  XDET->DT_ATENCAO   := IIF(SZU->ZU_STATUS == 'B',"Aguardando",Space(10))
	  XDET->DT_ANEXO     := Iif(!EMPTY(SC1->C1_ANEXO1),"Sim","  ")
	  XDET->DT_ANEXO1    := SC1->C1_ANEXO1
	  XDET->DT_ANEXO2    := SC1->C1_ANEXO2
	  XDET->DT_ANEXO3    := SC1->C1_ANEXO3		
	  XDET->DT_OBS       := SC1->C1_OBS   		

	  SB1->(DbSeek(xFilial("SB1")+SC1->C1_PRODUTO))
	  If SB1->(Found())
	  	 If SB1->B1_GENERIC == '1'
			XDET->DT_VLRPC := SB1->B1_UPRC
		 Endif	
      Endif
	
	  SB2->(DbSeek(xFilial("SB2")+SC1->C1_PRODUTO))
 	  While !SB2->(Eof()) .And. SB2->B2_COD == SC1->C1_PRODUTO
		 XDET->DT_QTEST += SB2->B2_QATU
		 SB2->(DbSkip())
	  Enddo		
      
   ElseIf _nPos == 2
      cMsg := "Pedido em Aberto"
      cAlias := "SC3"      
	XDET->DT_NUMCT     := SZU->ZU_NUMCT //numero do contrato
	XDET->DT_ITEMCT    := SZU->ZU_ITEMCT	 //item do contrato
    XDET->DT_NUMREV    := SZU->ZU_NUMREV //Numero da revisao	

  //Dados do pedido de compra em aberto para aprovacao         
    If !Empty(SZU->ZU_NUMCT)
       SC3->(DbSetOrder(1))
	   SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT + SZU->ZU_ITEMCT ))
	   If SC3->(Found())
	      XDET->DT_QUANTP     := Iif(Empty(SC3->C3_NUMREV),SC3->C3_QUANT,SC3->C3_QUANT-SC3->C3_QUJE)
	      XDET->DT_VUNITP     := SC3->C3_PRECO
	      XDET->DT_VALORP     := Iif(Empty(SC3->C3_NUMREV),(SC3->C3_QUANT * SC3->C3_PRECO),((SC3->C3_QUANT-SC3->C3_QUJE) * SC3->C3_PRECO))
     	  XDET->DT_EMISSAO    := SC3->C3_EMISSAO	      
       Endif
    Endif   
   ElseIf _nPos == 3
      cMsg := OemToAnsi("Autoriza��o de Entrega")
      cAlias := "SC7"            
	  XDET->DT_NUMPED    := SZU->ZU_NUMPED //numero da autorizacao de entrga
	  XDET->DT_ITEMPED   := SZU->ZU_ITEMPED //item da autorizacao de entrga

    If !Empty(SZU->ZU_NUMPED)
       SC7->(DbSetOrder(1))
	   SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED + SZU->ZU_ITEMPED ))
	   If SC7->(Found())
	      XDET->DT_QUANTAE    := SC7->C7_QUANT
	      XDET->DT_VUNITAE    := SC7->C7_PRECO
	      XDET->DT_VALORAE    := (SC7->C7_PRECO * SC7->C7_QUANT)
    	  XDET->DT_EMISSAO    := SC7->C7_EMISSAO	      
       Endif
    Endif   
   
   ElseIf _nPos == 4
      cMsg :=   OemToAnsi("Pedido de Compras (Altera��o)")
      cAlias := "C77"            
	  XDET->DT_NUMPED    := SZU->ZU_NUMPED //numero da autorizacao de entrga
	  XDET->DT_ITEMPED   := SZU->ZU_ITEMPED //item da autorizacao de entrga

    If !Empty(SZU->ZU_NUMPED)
       SC7->(DbSetOrder(1))
	   SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED + SZU->ZU_ITEMPED ))
	   If SC7->(Found())
	      XDET->DT_QUANTAE    := SC7->C7_QUANT
	      XDET->DT_VUNITAE    := SC7->C7_PRECO
	      XDET->DT_VALORAE    := (SC7->C7_PRECO * SC7->C7_QUANT)
    	  XDET->DT_EMISSAO    := SC7->C7_EMISSAO	      
       Endif
    Endif   

   Endif

	XDET->DT_PRODUTO   := SC1->C1_PRODUTO
	XDET->DT_DESCRI    := SC1->C1_DESCRI
	XDET->DT_LOGIN     := _cLogin2	
		
	MsUnlock("XDET")
Return

//Marca todas as notas
User Function fTdSc()

   XDET->(DbGoTop())
   While !XDET->(eof())     
      
      RecLock("XDET")
         XDET->DT_MARCA := cMarca
      MsUnlock("XDET")
      XDET->(Dbskip())
   Enddo   
   MarkBRefresh()
Return

//Desmarca todas as notas
User Function fPaSc()

   XDET->(DbGoTop())
   While !XDET->(eof())     
      RecLock("XDET")
         XDET->DT_MARCA := "  "
      MsUnlock("XDET")
      XDET->(Dbskip())
   Enddo   
   MarkBRefresh()
Return


//Aprova SC.
User Function fApSc()
Local _nRecno  := 0    
Local _cIndice  
Local _cPosind  

	If MsgBox("Confirma iten(s) ? ","Aguardar SC/P.A./A.E./PC","YESNO")	
	   XDET->(DbGotop())
	   SZU->(DbSetOrder(Iif(_nPos==4,_nPos,_nPos+1)))
	   While !XDET->(Eof())
			If !EMPTY(ALLTRIM(XDET->DT_MARCA)) 
			   If _nPos == 1 //  SC1
			      _cIndice := XDET->DT_NUM+XDET->DT_ITEM
			      _cPosind := 'SZU->ZU_NUM+SZU->ZU_ITEM'
		       ElseIf _nPos == 2 //  SC3
			      _cIndice := XDET->DT_NUMCT+XDET->DT_ITEMCT+XDET->DT_NIVEL+XDET->DT_NUMREV
			      _cPosind := 'SZU->ZU_NUMCT+SZU->ZU_ITEMCT+SZU->ZU_NIVEL+SZU->ZU_NUMREV'
		       ElseIf _nPos == 3 //  SC7
			      _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
			      _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
		       ElseIf _nPos == 4 //  C77
			      _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
			      _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
			   Endif   
			   SZU->(DbSeek(xFilial("SZU")+_cIndice  ))
				While !SZU->(Eof()) .AND.  &_cPosind == _cIndice 
				   //CONTINUAR AQUI
					If Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin) .And. SZU->ZU_ORIGEM$cAlias .And. (Empty(SZU->ZU_STATUS) .OR. SZU->ZU_STATUS=='B')
						
						RecLock("SZU",.F.)
						SZU->ZU_DATAPR := DATE()
						SZU->ZU_HORAPR := TIME()
						SZU->ZU_STATUS := "A"
						MsUnlock("SZU")
					Elseif Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin2) .And. SZU->ZU_ORIGEM$cAlias .And. (Empty(SZU->ZU_STATUS) .OR. SZU->ZU_STATUS=='B')
						RecLock("SZU",.F.)
						SZU->ZU_DATAPR := DATE()
						SZU->ZU_HORAPR := TIME()
						SZU->ZU_STATUS := "A"
					    SZU->ZU_LOGIN  := _cLogin
						MsUnlock("SZU")
					Elseif cAlias=="C77" .And. (Empty(SZU->ZU_STATUS) .OR. SZU->ZU_STATUS=='B')
					    If XDET->DT_NUMPED+XDET->DT_ITEMPED = SZU->ZU_NUMPED+SZU->ZU_ITEMPED 
						   RecLock("SZU",.F.)
						   SZU->ZU_DATAPR := DATE()
						   SZU->ZU_HORAPR := TIME()
						   SZU->ZU_STATUS := "A"
					       SZU->ZU_LOGIN  := _cLogin
						   MsUnlock("SZU")						
						Endif   
					Endif
					
					SZU->(DbSkip())
				Enddo		
			Endif
			XDET->(DbSkip())
		Enddo
		SZU->(DbSetOrder(1))

		DbSelectArea("XDET")
		XDET->(DbGotop())
		While !XDET->(Eof())
		   If !EMPTY(ALLTRIM(XDET->DT_MARCA))
		      RecLock("XDET")
		      Dele
		      MsUnlock("XDET")		      
		   Endif
		   XDET->(DbSkip())
		Enddo
		SET FILTER TO 	
		XDET->(DbGotop())
		MarkBRefresh()
	Endif		
Return



//Aprova SC.
User Function fAgSc()
Local _cIndice  
Local _cPosind  


	If MsgBox("Confirma iten(s) ? ","Aguardar SC/P.A./A.E./PC","YESNO")
	   XDET->(DbGotop())
	   SZU->(DbSetOrder(Iif(_nPos==4,_nPos,_nPos+1)))
		While !XDET->(Eof())
			If !EMPTY(ALLTRIM(XDET->DT_MARCA))
			   If _nPos == 1 //  SC1
			      _cIndice := XDET->DT_NUM+XDET->DT_ITEM
			      _cPosind := 'SZU->ZU_NUM+SZU->ZU_ITEM'
		       ElseIf _nPos == 2 //  SC3
			      _cIndice := XDET->DT_NUMCT+XDET->DT_ITEMCT+XDET->DT_NIVEL+XDET->DT_NUMREV
			      _cPosind := 'SZU->ZU_NUMCT+SZU->ZU_ITEMCT+SZU->ZU_NIVEL + SZU->ZU_NUMREV'
		                    //	   SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT + SZU->ZU_ITEMCT +SZU->ZU_NIVEL + SZU->ZU_NUMREV ))			      
		       ElseIf _nPos == 3 //  SC7
			      _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
			      _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
		       ElseIf _nPos == 4 //  C77
			      _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
			      _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
			      
			   Endif   
			   SZU->(DbSeek(xFilial("SZU")+_cIndice  ))
			   While !SZU->(Eof()) .AND.  &_cPosind == _cIndice 
					If Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin) .And. SZU->ZU_ORIGEM$cAlias .And. (Empty(SZU->ZU_STATUS) .OR. SZU->ZU_STATUS=='B')
						RecLock("SZU",.F.)
						SZU->ZU_DATAPR := DATE()
						SZU->ZU_HORAPR := TIME()
						SZU->ZU_STATUS := "B"
						MsUnlock("SZU")
					Endif
					SZU->(DbSkip())				
			   Enddo		
			Endif
			XDET->(DbSkip())
		Enddo
		SZU->(DbSetOrder(1))
	
		DbSelectArea("XDET")
		XDET->(DbGotop())
		While !XDET->(Eof())
		   If !EMPTY(ALLTRIM(XDET->DT_MARCA))
		      RecLock("XDET")
			      Dele
		      MsUnlock("XDET")		      
		   Endif
		   XDET->(DbSkip())
		Enddo
		SET FILTER TO 	
		XDET->(DbGotop())
		MarkBRefresh()
	Endif		
Return


//Rejeita SC.
User Function fReSc()
Local lMail := .F.
Local _cIndice  
Local _cPosind  


	If MsgBox("Confirma iten(s) ? ","Rejeitar SC","YESNO")
       XDET->(DbGotop())	
//	   SZU->(DbSetOrder(_nPos+1))
	   SZU->(DbSetOrder(Iif(_nPos==4,_nPos,_nPos+1)))
	   While !XDET->(Eof())
			If !EMPTY(ALLTRIM(XDET->DT_MARCA))
			   If _nPos == 1 //  SC1
			      _cIndice := XDET->DT_NUM+XDET->DT_ITEM
			      _cPosind := 'SZU->ZU_NUM+SZU->ZU_ITEM'
		       ElseIf _nPos == 2 //  SC3
			      _cIndice := XDET->DT_NUMCT+XDET->DT_ITEMCT+XDET->DT_NIVEL+XDET->DT_NUMREV
			      _cPosind := 'SZU->ZU_NUMCT+SZU->ZU_ITEMCT+SZU->ZU_NIVEL + SZU->ZU_NUMREV'
		       ElseIf _nPos == 3 //  SC7
			      _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
			      _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
		       ElseIf _nPos == 4 //  C77
			      _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
			      _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
			      
			   Endif   
					
			   SZU->(DbSeek(xFilial("SZU")+_cIndice  ))
			   While !SZU->(Eof()) .AND.  &_cPosind == _cIndice 
					If Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin) .And. SZU->ZU_ORIGEM$cAlias .And. (Empty(SZU->ZU_STATUS) .OR. SZU->ZU_STATUS=='B')
					
						Pergunte("NHCO4A",.T.)

						RecLock("SZU",.F.)
						SZU->ZU_DATAPR := DATE()
						SZU->ZU_HORAPR := TIME()
						SZU->ZU_STATUS := "C"
						SZU->ZU_OBS := Alltrim(mv_par01) + Alltrim(mv_par02)
						MsUnlock("SZU")
                        If SZU->ZU_ORIGEM$"SC1"
							SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
							If SC1->(Found())
	    					   //Tira a qtde de reserva no B2 da solicita��o rejeitada
						       SB2->(DbSeek(xFilial("SB2")+SC1->C1_PRODUTO+SC1->C1_LOCAL))
							   If SB2->(Found())
							      RecLock("SB2",.F.)
								     SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC1->C1_QUANT - SC1->C1_QUJE)
								  MsUnlock("SB2")
							   Endif	
	
							   RecLock("SC1",.F.)
							   SC1->C1_APROV   := "R"
							   SC1->C1_QUJE    := 0 
							   SC1->C1_QUANT   := 0 
							   SC1->C1_COTACAO := Space(06)
							   SC1->C1_RESIDUO := "S"
							   MsUnlock("SC1")
							Endif	
						ElseIf SZU->ZU_ORIGEM$"SC3"
								SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT+SZU->ZU_ITEMCT))
								If SC3->(Found())
								   RecLock("SC3",.F.)
								  // SC3->C3_QUJE    := 0 
								   SC3->C3_ENCER   := "E" //encerrado
								   SC3->C3_RESIDUO := "S"
								   MsUnlock("SC3")
								Endif	
							
						ElseIf SZU->ZU_ORIGEM$"SC7"
								SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED+SZU->ZU_ITEMPED))
								If SC7->(Found())
		    					   //Tira a qtde de reserva no B2 da autorizacao de entrega rejeitada
							       SB2->(DbSeek(xFilial("SB2")+SC7->C7_PRODUTO+SC7->C7_LOCAL))
								   If SB2->(Found())
								      RecLock("SB2",.F.)
									     SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC7->C7_QUANT - SC7->C7_QUJE)
									  MsUnlock("SB2")
								   Endif	
		
								   RecLock("SC7",.F.)
								   SC7->C7_RESIDUO := "S"
								   MsUnlock("SC7")
								Endif	
								
						ElseIf SZU->ZU_ORIGEM$"C77"
								SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED+SZU->ZU_ITEMPED))
								If SC7->(Found())
		    					   //Tira a qtde de reserva no B2 da autorizacao de entrega rejeitada
							       SB2->(DbSeek(xFilial("SB2")+SC7->C7_PRODUTO+SC7->C7_LOCAL))
								   If SB2->(Found())
								      RecLock("SB2",.F.)
									     SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC7->C7_QUANT - SC7->C7_QUJE)
									  MsUnlock("SB2")
								   Endif	
		
								   RecLock("SC7",.F.)
								   SC7->C7_RESIDUO := "S"
								   MsUnlock("SC7")
								Endif	
								
							
						Endif
						
                        lMail := .T.

					Elseif Alltrim(SZU->ZU_LOGIN) == Alltrim(_cLogin2) .And. SZU->ZU_ORIGEM$cAlias 

						Pergunte("NHCO4A",.T.)
						RecLock("SZU",.F.)
						SZU->ZU_DATAPR := DATE()
						SZU->ZU_HORAPR := TIME()
						SZU->ZU_STATUS := "C"
						SZU->ZU_OBS := Alltrim(mv_par01) + Alltrim(mv_par02)
						MsUnlock("SZU")                                        
						
                        If SZU->ZU_ORIGEM$"SC1"
							SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
							If SC1->(Found())
	    					   //Tira a qtde de reserva no B2 da solicita��o rejeitada
						       SB2->(DbSeek(xFilial("SB2")+SC1->C1_PRODUTO+SC1->C1_LOCAL))
							   If SB2->(Found())
							      RecLock("SB2",.F.)
								     SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC1->C1_QUANT - SC1->C1_QUJE)
								  MsUnlock("SB2")
							   Endif	
	
							   RecLock("SC1",.F.)
							   SC1->C1_APROV   := "R"
							   SC1->C1_QUJE    := 0 
							   SC1->C1_QUANT   := 0 
							   SC1->C1_COTACAO := Space(06)
							   SC1->C1_RESIDUO := "S"
							   MsUnlock("SC1")
							Endif	
						ElseIf SZU->ZU_ORIGEM$"SC3"
								SC3->(DbSeek(xFilial("SC3")+SZU->ZU_NUMCT+SZU->ZU_ITEMCT))
								If SC3->(Found())
								   RecLock("SC3",.F.)
							  //	   SC3->C3_QUJE    := 0 
								   SC3->C3_ENCER   := "E" //encerrado
								   SC3->C3_RESIDUO := "S"
								   MsUnlock("SC3")
								Endif	
							
						ElseIf SZU->ZU_ORIGEM$"SC7"
								SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED+SZU->ZU_ITEMPED))
								If SC7->(Found())
		    					   //Tira a qtde de reserva no B2 da autorizacao de entrega rejeitada
							       SB2->(DbSeek(xFilial("SB2")+SC7->C7_PRODUTO+SC7->C7_LOCAL))
								   If SB2->(Found())
								      RecLock("SB2",.F.)
									     SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC7->C7_QUANT - SC7->C7_QUJE)
									  MsUnlock("SB2")
								   Endif	
		
								   RecLock("SC7",.F.)
								   SC7->C7_RESIDUO := "S"
								   MsUnlock("SC7")
								Endif	
						ElseIf SZU->ZU_ORIGEM$"C77"
								SC7->(DbSeek(xFilial("SC7")+SZU->ZU_NUMPED+SZU->ZU_ITEMPED))
								If SC7->(Found())
		    					   //Tira a qtde de reserva no B2 da autorizacao de entrega rejeitada
							       SB2->(DbSeek(xFilial("SB2")+SC7->C7_PRODUTO+SC7->C7_LOCAL))
								   If SB2->(Found())
								      RecLock("SB2",.F.)
									     SB2->B2_SALPEDI := SB2->B2_SALPEDI - (SC7->C7_QUANT - SC7->C7_QUJE)
									  MsUnlock("SB2")
								   Endif	
		
								   RecLock("SC7",.F.)
								   SC7->C7_RESIDUO := "S"
								   MsUnlock("SC7")
								Endif	
							
						Endif
						
                        lMail := .T.
				
					Endif

					SZU->(DbSkip())				
				Enddo		
				If lMail 
					fEnvMail()
				Endif	
				lMail := .F.
			Endif
			XDET->(DbSkip())
		Enddo
		SZU->(DbSetOrder(1))

		DbSelectArea("XDET")
		XDET->(DbGotop())
		While !XDET->(Eof())
		   If !EMPTY(ALLTRIM(XDET->DT_MARCA))
		      RecLock("XDET")
			      XDET->(DBDeleTE())
		      MsUnlock("XDET")		      
		   Endif
		   XDET->(DbSkip())
		Enddo
		SET FILTER TO 	
		XDET->(DbGotop())
		MarkBRefresh()
	Endif		
Return

User Function fAnexodet(nParam)
    If nParam == 1
		_cPath    := Alltrim(XDET->DT_ANEXO1)
	Elseif nParam == 2
		_cPath    := Alltrim(XDET->DT_ANEXO2)
	Elseif nParam == 3
		_cPath    := Alltrim(XDET->DT_ANEXO3)
	Endif


   If !Empty(_cPath)
      ShellExecute( "open", _cPath, "", "",5 )  
	Else
		MsgBox("Anexo nao disponivel, ou nao cadastraodo","Anexos","INFO")		

	Endif

Return


User Function fRobs()

@ 135,002 To 310,570 Dialog dlgTitulos Title "Troca Numero do Cheque"
@ 012,010 Say OemToAnsi("Cheque Numero") Size 35,8
@ 027,010 Say OemToAnsi("Valor") Size 25,8
@ 042,010 Say OemToAnsi("Beneficiario") Size 35,8
@ 057,010 Say OemToAnsi("Historico") Size 25,8

M->EF_NOVO    := SEF->EF_NUM
M->EF_NUM     := SEF->EF_NUM
M->EF_BANCO   := SEF->EF_BANCO
M->EF_AGENCIA := SEF->EF_AGENCIA
M->EF_CONTA   := SEF->EF_CONTA

@ 10,60 Get M->EF_NOVO VALID ValCheque() Size 45,8
@ 25,60 Get SEF->EF_VALOR PICT "@E 999,999,999.99" WHEN .F. Size 45,8
@ 40,60 Get SEF->EF_BENEF WHEN .F. Size 160,8
@ 55,60 Get SEF->EF_HIST WHEN .F. Size 160,8

@ 070,200 BMPBUTTON TYPE 01 ACTION Renumerar()
@ 070,237 BMPBUTTON TYPE 02 ACTION Close(DlgTitulos)

Activate Dialog dlgTitulos CENTERED

Return

User Function fFilApr()
	DbSelectArea("SX1")
	SX1->(dbSetOrder(1))
	SX1->(DbSeek("NHCO42"))
	If Sx1->(Found())
		RecLock('SX1')
		SX1->X1_CNT01 := XDET->DT_NUM
		MsUnLock('SX1')
		SX1->(DbSkip())
		RecLock('SX1')
		SX1->X1_CNT01 := XDET->DT_SOLICIT
		MsUnLock('SX1')
		DbCommit()
	Endif


	If Pergunte("NHCO42",.T.) //ativa os parametros
		DbSelectArea("XDET")
		XDET->(DbGotop())
		If !Empty(mv_par01) .AND. !Empty(mv_par02)
			SET FILTER TO XDET->DT_NUM = mv_par01 .AND. XDET->DT_SOLICIT = mv_par02

		Elseif !Empty(mv_par01) .AND. Empty(mv_par02)		
				SET FILTER TO XDET->DT_NUM = mv_par01

		Elseif Empty(mv_par01) .AND. !Empty(mv_par02)		
				SET FILTER TO XDET->DT_SOLICIT = mv_par02

		Else
			SET FILTER TO 			

		Endif	
	Else
		SET FILTER TO 	

	Endif		
	XDET->(Dbgotop())
	MarkBRefresh()	
Return


User function fVizSc1()

Return

Static Function fDlgObs()
	Pergunte("NHCO42",.T.) //ativa os parametros
Return(.t.)

Static Function fEnvMail()
Local lSolic := .T., _cMail2, _cC1Solicit                      
Local _cAssu 
Local _cIndice
Local _cPosind

QAA->(DbSetOrder(6))
//SZU->(DbSetOrder(_nPos+1))
SZU->(DbSetOrder(Iif(_nPos==4,_nPos,_nPos+1)))
lEnd := .F.
e_email = .F.
_cMail2 := ""
_cC1Solicit := Space(15)

If _nPos == 1 //  SC1
   _cIndice := XDET->DT_NUM+XDET->DT_ITEM
   _cPosind := 'SZU->ZU_NUM+SZU->ZU_ITEM'
ElseIf _nPos == 2 //  SC3
   _cIndice := XDET->DT_NUMCT+XDET->DT_ITEMCT+XDET->DT_NIVEL+XDET->DT_NUMREV
   _cPosind := 'SZU->ZU_NUMCT+SZU->ZU_ITEMCT+SZU->ZU_NIVEL+SZU->ZU_NUMREV'
ElseIf _nPos == 3 //  SC7
   _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
   _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
ElseIf _nPos == 4 //  C77
   _cIndice := XDET->DT_NUMPED+XDET->DT_ITEMPED
   _cPosind := 'SZU->ZU_NUMPED+SZU->ZU_ITEMPED'
   
Endif   
SZU->(DbSeek(xFilial("SZU")+_cIndice  ))
While !SZU->(Eof()) .AND.  &_cPosind == _cIndice 

	If Empty(SZU->ZU_STATUS)
		SZU->(DbSkip())
		Loop
	Endif

	lRet   := .F.
	_cMail := ""
	_cNome := "Ola, "

	QAA->(DbSeek(SZU->ZU_LOGIN))
	If QAA->(Found())           
//		_cMail := "alexandrerb@whbbrasil.com.br"
		_cMail := QAA->QAA_EMAIL
		_cNome := "Ola, "+QAA->QAA_NOME
	Endif

	cMsg := '<html>' +  CHR(13)+CHR(10)
	cMsg += '<head>' +  CHR(13)+CHR(10)
	
    If !Empty(SZU->ZU_NUMPED) .And. SZU->ZU_ORIGEM$"SC7"
	   cMsg += '<title> APROVACAO ELETRONICA DE AUTORIZACAO DE ENTREGA</title>' +  CHR(13)+CHR(10)	
 	   _cAssu := "Autorizacao de Entrega  <<< REJEITADAS >>>."	   
    ElseIf !Empty(SZU->ZU_NUMCT) .And. SZU->ZU_ORIGEM$"SC3"
	   cMsg += '<title> APROVACAO ELETRONICA DE PEDIDO EM ABERTO</title>' +  CHR(13)+CHR(10)	    
   	   _cAssu :="Pedidos em Abertos de Compras  <<< REJEITADOS >>>."					   
    ElseIf !Empty(SZU->ZU_NUM) .And. SZU->ZU_ORIGEM$"SC1"
     	cMsg += '<title> APROVACAO ELETRONICA DE SC</title>' +  CHR(13)+CHR(10)
		_cAssu :="Solicitacoes de Compras  <<< REJEITADAS >>>."     	
		
    ElseIf !Empty(SZU->ZU_NUMPED) .And. SZU->ZU_ORIGEM$"C77"
     	cMsg += '<title> APROVACAO ELETRONICA DE PEDIDO DE COMPRAS</title>' +  CHR(13)+CHR(10)
		_cAssu :="Pedido de Compras Alteracao <<< REJEITADOS >>>."     	
		
   	Endif   

	cMsg += '</head>' +  CHR(13)+CHR(10)
    cMsg += '<b><font size="2" face="Arial">' + _cNome + '</font></b>' +  CHR(13)+CHR(10)
	cMsg += '</tr>' +  CHR(13)+CHR(10)
    cMsg += '<tr>'
//	cMsg += '<b><font size="3" face="Arial">Solicitacoes de compras rejeitadas. </font></b>' +  CHR(13)+CHR(10)
	cMsg += '<b><font size="3" face="Arial">'+_cAssu +  CHR(13)+CHR(10)
	cMsg += '</tr>' +  CHR(13)+CHR(10)
    cMsg += '<tr>'
	cMsg += '<font size="2" face="Arial">Itens rejeitados.</font>' +  CHR(13)+CHR(10)
	cMsg += '<table border="1" width="100%" bgcolor="#0080C0">'	
	cMsg += '<tr>'
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">SC Nr.</font></td>'
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Item</font></td>'
	
    cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Contrato Nr.</font></td>'
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Item CT</font></td>'
   	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Revis�o</font></td>'
    
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Aut.Ent. Nr.</font></td>'
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Item A.E.</font></td>'
	
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Emissao</font></td>'
	cMsg += '<td width="15%">'
	cMsg += '<font size="2" face="Arial">Produto</font></td>' 
	cMsg += '<td width="30%">'
	cMsg += '<font size="2" face="Arial">Descricao</font></td>'
	cMsg += '<td width="10%">'
	cMsg += '<font size="2" face="Arial">Observacao</font></td>'
	cMsg += '</tr>' +  CHR(13)+CHR(10)
	e_email = .T.

	SC1->(DbSeek(xFilial("SC1")+SZU->ZU_NUM+SZU->ZU_ITEM))
	If SC1->(Found())
		cMsg += '<tr>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_NUM + '</font></td>'
	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_ITEM + '</font></td>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SZU->ZU_NUMCT + '</font></td>'
	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SZU->ZU_ITEMCT + '</font></td>'
	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SZU->ZU_NUMREV + '</font></td>'
	    cMsg += '<td width="06%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SZU->ZU_NUMPED + '</font></td>'
	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SZU->ZU_ITEMPED + '</font></td>'
	    cMsg += '<td width="06%">'
    	cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + DTOC(SC1->C1_EMISSAO) + '</font></td>'
	    cMsg += '<td width="18%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_PRODUTO + '</font></td>'
    	cMsg += '<td width="30%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' + SC1->C1_DESCRI + '</font></td>'
    	cMsg += '<td width="30%">'
	    cMsg += '<font size="2" Color="#FFFFFF" face="Arial">' +  Alltrim(mv_par01) + Alltrim(mv_par02) + '</font></td>'
		cMsg += '</tr>'
		lRet := .T.
		_cC1Solicit := SC1->C1_SOLICIT
	Endif

	If lRet .and. !Empty(_cMail)
		cMsg += '</table>'
		cMsg += '</body>' +  CHR(13)+CHR(10)
		cMsg += '</html>' +  CHR(13)+CHR(10)
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail); //'marcosr@whbbrasil.com.br';		
			SUBJECT _cAssu;
			BODY cMsg;
			RESULT lEnviado
			If !lEnviado
				Send Mail from 'protheus@whbbrasil.com.br' To 'marcosr@whbbrasil.com.br';		
				SUBJECT _cAssu;
				BODY cMsg;
				RESULT lEnviado
	    	Endif
		Endif
		lRet := .F.
	Endif


	// Imprime para o solicitante
	QAA->(DbSeek(_cC1Solicit))
	If QAA->(Found())
//		_cMail2 := "alexandrerb@whbbrasil.com.br"		
		_cMail2 := QAA->QAA_EMAIL		
		_cNome  := "Ola, "+QAA->QAA_NOME
	Endif

	If lSolic .and. !Empty(_cMail2)
		cMsg += '</table>'
		cMsg += '</body>' +  CHR(13)+CHR(10)
		cMsg += '</html>' +  CHR(13)+CHR(10)

	
		CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lConectou
		If lConectou
			Send Mail from 'protheus@whbbrasil.com.br' To Alltrim(_cMail2); //'marcosr@whbbrasil.com.br';
			SUBJECT _cAssu;
			BODY cMsg;
			RESULT lEnviado
	
			If !lEnviado
				Send Mail from 'protheus@whbbrasil.com.br' To 'marcosr@whbbrasil.com.br';
				SUBJECT _cAssu;
				BODY cMsg;
				RESULT lEnviado
	    	Endif
		Endif
		lSolic := .F.
	Endif

	SZU->(DbSkip())

Enddo

Return(.T.)



