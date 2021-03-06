#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"
#include "colors.ch"
#include "font.ch"
#INCLUDE "protheus.ch"
                                                             
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � NHEST210 �Autor �Douglas de S. Dourado� Data � XX/XX/XXXX�  ��
�������������������������������������������������������������������������͹��                            
���Desc.     � CADASTRO DE EMAIL X ROTINA	                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP11 - ESTOQUE E CUSTOS                                    ���
���	         � TABELAS:  ZG1FN0(ROTINA),ZG2FN0(EMAIL) E ZG3FN0(RESP.)     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                   

/*********************************************************/
/************************* BROWSE ************************/
/*********************************************************/

User Function NHEST210
Private oDlg
Private aRotina, cCadastro // Variaveis do Mbrowse

cCadastro := "E-mail por Rotina"
aRotina   := {}
aAdd(aRotina,{ "Visualizar"	    ,"U_EST210(1)"   , 0 , 2})
aAdd(aRotina,{ "Incluir"		,"U_EST210(2)" 	 , 0 , 3})
aAdd(aRotina,{ "Alterar" 		,"U_EST210(3)"   , 0 , 4})
aAdd(aRotina,{ "Legenda"        ,"U_E210Legenda()" , 0 , 1}) 
                                                                                                             
mBrowse(6,1,22,75,"ZG1",,,,,,fCriaCor())                   

Return

/*********************************************************/
/****************** Fun��o Principal *********************/
/*********************************************************/

User Function EST210(nParam)
Local bOk         := {||}
Local bCanc       := {||oDlg:End()}
Local bEnchoice   := {||}
Private nPar 	  := nParam, cTitle, aHeader := {}, aColMail := {} , aColResp := {}, aHead1 := {}, aHead2 := {}, cItem  , nOpc
Private cCodRot   := space(06), cRotina := space(20), dData := CtoD('  /  /  '), cStatus := space(15), cAssunto := space(200)
Private aSize     := MsAdvSize(), cCusto := space(09), cDias := space(02) , cDesc := space(200)
Private aObjects  := {{ 100, 100, .T., .T. },{ 300, 300, .T., .T. }}
Private aInfo     := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 , 5, 5}
Private aPosObj   := MsObjSize( aInfo, aObjects, .T.) , aCombo:={"A=Ativa","D=Desativada"} , cCombo := ''              
 
/************************************************************************/
/****************** Construindo o cabe�alho *****************************/
/************************************************************************/  

	// E-Mail
	aAdd(aHead1,{'Item'       ,"ZG2_ITEM"    , PesqPict("ZG2","ZG2_ITEM")   ,04,0,'.F.','','C','ZG2'})

	// Adicionado em 30/11/12
	aAdd(aHead1,{'Matricula'  ,"ZG2_MAT"     , "@!"  						,06,0,'U_fValMat()','','C','QAA'})	
	
	aAdd(aHead1,{'E-Mail'     ,"ZG2_EMAIL"   , "@!"  						,50,0,'U_fValMail()','','C','ZG2'})		
	
	// Responsaveis
	aAdd(aHead2,{'Item'       ,"ZG3_COD"     , PesqPict("ZG3","ZG3_COD")    ,04,0,'.F.','','C','ZG3'})
	aAdd(aHead2,{'Login'       ,"ZG3_NOME"   , PesqPict("ZG3","ZG3_NOME")   ,40,0,'U_E210ADD()','','C','QUS'})
	aAdd(aHead2,{'Responsavel pela inclus�o' ,"ZG3_CRIAD", PesqPict("ZG3","ZG3_CRIAD"), 25,0,'.F.','','C','ZG3'})
	aAdd(aHead2,{'Data'       ,"ZG3_DATA"    , PesqPict("ZG3","ZG3_DATA")   ,10,0,'.F.','','C','ZG3'})

/************************************************************************/
/************* Identifica a opera��o que ser� realizada *****************/
/************************************************************************/
  
If nPar==1      // visualizar

    cTitle   := 'Visualizar'
    nOpc     := 4
    fCarrega()  	 
   
ElseIf nPar==2  // incluir

    cTitle   := 'Incluir'
	cCodRot  := GetSxeNum("ZG1","ZG1_COD")
	cStatus  := 'ATIVA'
	dData    := Ddatabase
	nOpc     := 3 	
	Aadd(aColResp,{'0001',AllTrim(cUserName),AllTrim(cUserName),dDataBase,.F.})	 
	
ElseIf nPar==3  //Alterar 

    cTitle := 'Alterar'
    nOpc   := 3  
    fCarrega()

 	IF !fCheckLog()				
       MsgBox("Usu�rio n�o tem permiss�o para alterar esta rotina!","Acesso Negado","Alert")
       Return
    EndIF

EndIf 	

/*****************************************************************************/
/********************** Inicializa��o dos Say's e Get's **********************/ 
/*****************************************************************************/

Define MsDialog oDlg Title (cTitle) From aSize[7],00 To aSize[6],aSize[5] Pixel
   
	/***************************************************************/
	/*************************** Campos ****************************/
	/***************************************************************/
    
	@ 08,10  Say "C�digo:" PIXEL OF oDlg    	      
	@ 18,10  Get cCodRot SIZE 30,10 WHEN .F. PIXEL OF oDlg
	
	@ 08,60  Say "Rotina: " PIXEL OF oDlg
	@ 18,60  MSGet oRotina VAR cRotina SIZE 57,10 WHEN (nPar == 2) PIXEL OF oDlg 	
		
	@ 08,137 Say "Status: " PIXEL OF oDlg    	      	
	@ 18,137 Combobox cCombo ITEMS aCombo SIZE 50,10 WHEN (nPar == 2 .or. nPar == 3) PIXEL OF oDlg				
	
	@ 08,203 Say "Data: " PIXEL OF oDlg
	@ 18,203 Get dData WHEN (.F.) SIZE 50,10 PIXEL OF oDlg
	
	@ 08,270 Say "Assunto: " PIXEL OF oDlg
	@ 18,270 Get cAssunto WHEN (nPar == 2 .OR. nPar == 3) SIZE 120,10 PIXEL OF oDlg
	
	@ 08,400 Say "Dias p/ aviso: " PIXEL OF oDlg
	@ 18,400 Get cDias WHEN (nPar == 2 .OR. nPar == 3) SIZE 15,10 PIXEL OF oDlg
	
	@ 08,438 Say "Centro de Custo da Pe�a: " PIXEL OF oDlg
	@ 18,438 MsGet oCusto Var cCusto WHEN (nPar == 2 .OR. nPar == 3) F3 "CTT" Valid fBuscaCC() SIZE 50,10 PIXEL OF oDlg 
	
	@ 08,508 Say "Descricao: " PIXEL OF oDlg
	@ 18,508 Get cDesc WHEN (nPar == 2 .OR. nPar == 3) SIZE 150,10 PIXEL OF oDlg
	
	@ 036,000 FOLDER oFolder PROMPTS OemToAnsi("Emails"),;								
									 OemToAnsi("Respons�veis") SIZE (aSize[5]/2)+3,(aSize[6]/2) OF oDlg PIXEL
			
	bEnchoice := {||EnchoiceBar(oDlg,bOk,bCanc)} // Enchoice Bar     

	// GetDados dos E-Mails
	oGetD1 := MsNewGetDados():New(05 ,; 
								  05,;     
								  280,;     
								  750,;
								  nOpc,;
								  "AllwaysTrue()",;
								  "AllwaysTrue()",;
								  '+ZG2_ITEM',,;
								  0,;
								  99,;
								  "AllwaysTrue()",;
								  '',;
								  "AllwaysTrGue()",;
								  oFolder:aDialogs[1],;
								  aHead1,;
								  aColMail)						  
	
	OGetD1:LDELETE := .T.                   
	
	// GetDados dos responsaveis
	oGetD2 := MsNewGetDados():New(05 ,; 
								  05,;     
								  280,;     
								  750,;
								  nOpc,;
								  "AllwaysTrue()",;
								  "AllwaysTrue()",;
								  '+ZG3_CODIGO',,;
								  0,;
								  99,;
								  "AllwaysTrue()",;
								  '',;
								  "AllwaysTrue()",;
								  oFolder:aDialogs[2],;
								  aHead2,;
								  aColResp)
								  
	OGetD2:LDELETE := .T.              
		
	Activate MsDialog oDlg ON INIT EnchoiceBar(oDlg,{||Confirmar(),.T.},{||Cancelar()})      

Return

/******************************************************************************************************************************/
/* Valida��o no input do login do responsavel, preenchendo automaticamente o resp. por cria��o (usuario atual) e a data atual.*/
/******************************************************************************************************************************/

User Function E210ADD()

	QAA->(DBSETORDER(6))
	
	IF  !QAA->(DBSEEK(AllTrim(M->ZG3_NOME)))
	    MsgBox("Login de usu�rio n�o existe ou n�o est� cadastrado na tabela de usuarios (QAA), favor verificar.","Login n�o encontrado","Alert")
	    Return .F.	
	
	ELSEIF AllTrim(M->ZG3_NOME) == '' 
		MsgBox("N�o � poss�vel inserir com o campo em branco ! Favor preencher "," Campo em branco ","Alert")
	    Return .F.		
	ELSE     
		oGetD2:aCols[n][3] := cUserName
		oGetD2:aCols[n][4] := dDataBase
		oGeTD2:Refresh()	
	EndIf

Return .T.  

/******************************************************************************************************************************/
/******************************************** Valida��o do e-mail digitado*****************************************************/
/******************************************************************************************************************************/

User Function fValMail()

	If !IsEmail(ALLTRIM(M->ZG2_EMAIL))
	   		Alert('Email inv�lido! Digite o endere�o de e-mail corretamente!')
		Return .f.
	Endif

Return .T.

/******************************************************************************************************************************/
/******************************************** Valida��o da matricula **********************************************************/
/******************************************************************************************************************************/

User Function fValMat() 
Local cDatVal

	SRA->(DBSETORDER(1))    
	
	// Busca a matricula no SRA
	If SRA->( DBSEEK (xFilial("SRA") + ALLTRIM(M->ZG2_MAT)) )
	
		cDatVal := SRA->RA_DEMISSA
	    
		// Verifica se funcion�rio n�o est� demitido
		If !Empty(cDatVal)
	   		MsgBox('Matricula referente a funcion�rio desativado !  Verifique !',"Matricula Inv�lida","ALERT")
			Return .f.
		Endif  
		
	    QAA->(DBSETORDER(1))		

	    QAA->(DBSEEK(xFilial("QAA") + ALLTRIM(M->ZG2_MAT)))
	    
	    // Preenche automaticamente o campo e-mail, com o e-mail cadastrado no QAA
	    
	    If AllTrim(QAA->QAA_EMAIL) == ''
	       MsgBox('Funcion�rio n�o contem e-mail cadastrado na tabela de funcion�rios, digite o e-mail manualmente !' ,"Email N�o Cadastrado","ALERT")
	    Else	    
		   oGetD1:aCols[n][3] := QAA->QAA_EMAIL	    	    
	    EndIf
	    
	Else
	
   		Alert('Matricula n�o encontrada! Verifique!')
		Return .f.		
		
	EndIF

Return .T.


/******************************************************************************************************************************/
/******************************************** Valida��o do Centro de Custo ****************************************************/
/******************************************************************************************************************************/

Static Function fBuscaCC()

	CTT->(DBSETORDER(1))
	
	IF !CTT->( DBSEEK( xFilial("CTT") + AllTrim(cCusto) ) )
	   MsgBox("Centro de Custo n�o existe ! Favor verificar.","CC n�o encontrado","Alert")	
       Return .F.
 	EndIf
 	
Return .T.

/*******************************************************************************************/
/****************** Confere se o usuario tem acesso para alterar  **************************/  
/*******************************************************************************************/ 

Static Function fCheckLog()                                                                
      
	ZG3->(DBSETORDER(1))
	
	IF ZG3->( DBSEEK( xFilial("ZG3") + cRotina + AllTrim(cUserName) ) )
       Return .T.
 	EndIf

Return .F.

/*******************************************************************************************/
/***************************** Carrega os campos do dialog *********************************/  
/*******************************************************************************************/
Static Function fCarrega()  	

	cCodRot      := ZG1->ZG1_COD 
	cRotina		 := ZG1->ZG1_ROTINA
	cCombo  	 := ZG1->ZG1_STAT
	dData        := ZG1->ZG1_DATA
	cAssunto     := ZG1->ZG1_ASS
	cCusto		 := ZG1->ZG1_CC
	cDias		 := ZG1->ZG1_DIAS
	cDesc		 := ZG1->ZG1_DESC	             
        
        // E-Mail                         
 		cQuery := " SELECT ZG2_ITEM, ZG2_EMAIL, ZG2_MAT " 	 
		cQuery += " FROM "+RetSqlName("ZG1")+" ZG1, " +RetSqlName("ZG2")+" ZG2 " 
		cQuery += " WHERE ZG1_COD = '"+cCodRot+"' "		
		cQuery += " AND ZG2_CODROT = ZG1_COD "		
		cQuery += " AND ZG1.ZG1_FILIAL = '"+xFilial("ZG1")+"' "			
		cQuery += " AND ZG2.ZG2_FILIAL = '"+xFilial("ZG2")+"' "
		cQuery += " AND ZG1.D_E_L_E_T_ = ' '"		
		cQuery += " AND ZG2.D_E_L_E_T_ = ' '"			
		cQuery += " ORDER BY ZG2_ITEM ASC"		
		
		TcQuery cQuery NEW ALIAS "ITENS" 	
			
		ITENS->(dbGoTop())  
		
		// ITENS DO ACOLS DE EMAIL
		While !ITENS->(Eof())   
	    	    aAdd(aColMail,{(ITENS->ZG2_ITEM),; // ITEM 	
   				ITENS->ZG2_MAT,;      // MATRICULA			    	    	
				ITENS->ZG2_EMAIL,;    // EMAIL			    
				.F.}) 								
				ITENS->(DbSkip())					    						
    	EndDo   
    	   	
    	ITENS->(DbCloseArea())
    	
    	// Responsaveis                         
 		cQuery := " SELECT ZG3_COD, ZG3_NOME, ZG3_CRIAD, ZG3_DATA " 	 
		cQuery += " FROM "+RetSqlName("ZG1")+" ZG1, " +RetSqlName("ZG3")+" ZG3 " 
		cQuery += " WHERE ZG1_COD = '"+cCodRot+"' "		
		cQuery += " AND ZG3_CODROT = ZG1_COD "		
		cQuery += " AND ZG1.ZG1_FILIAL = '"+xFilial("ZG1")+"' "
		cQuery += " AND ZG3.ZG3_FILIAL = '"+xFilial("ZG3")+"' " 
		cQuery += " AND ZG1.D_E_L_E_T_ = ' '"
		cQuery += " AND ZG3.D_E_L_E_T_ = ' '"
		cQuery += " ORDER BY ZG3_COD ASC"		
		
		TcQuery cQuery NEW ALIAS "ITENS" 	
			
		ITENS->(dbGoTop())  
		
		// ITENS DO ACOLS
		While !ITENS->(Eof())   
		    aAdd(aColResp,{(ITENS->ZG3_COD),;  		 // ITEM 		    	
							ITENS->ZG3_NOME,;  		 // NOME			    
							ITENS->ZG3_CRIAD,;       // CRIADOR			    
							STOD(ITENS->ZG3_DATA),;  // DATA			    
							.F.}) 								
			ITENS->(DbSkip())					    						
    	EndDo   
    	   	
    	ITENS->(DbCloseArea())
    		
Return

/*******************************************************************************************/
/***************************** Inclui, Altera, ou Desativa *********************************/  
/*******************************************************************************************/

Static Function Confirmar() 
 
 DO CASE // Verifica a opera��o que ser� feita
  
	CASE nPar == 2    // Inclui um novo registro 	    
	    
		IF !Validar()
			Return  
   		EndIf      
		     
			DbSelectArea("ZG1")
		    // Rotina
			RecLock("ZG1",.T.) 
				ZG1->ZG1_FILIAL := xFilial("ZG1")		
				ZG1->ZG1_COD 	:= AllTrim(cCodRot)			
				ZG1->ZG1_ROTINA := AllTrim(cRotina)		
				ZG1->ZG1_STAT   := cCombo
				ZG1->ZG1_DATA   := dData			
				ZG1->ZG1_ASS    := AllTrim(cAssunto)				
				ZG1->ZG1_CC     := cCusto
				ZG1->ZG1_DIAS   := cDias
				ZG1->ZG1_DESC   := cDesc
			MsUnlock("ZG1")
			
			ConfirmSX8() 
			
			DbSelectArea("ZG2")			     
			// EMAILS
	   		For x:=1 to Len(oGetD1:aCols)
		   		If !oGetD1:aCols[x][len(oGetD1:aHeader)+1] // Nao pega quando estiver deletado	   		    
					RecLock("ZG2",.T.) 	     	    
			   			ZG2->ZG2_FILIAL  := xFilial("ZG2")		
						ZG2->ZG2_ITEM	 := oGetD1:aCols[x][1]			
						ZG2->ZG2_MAT	 := AllTrim(oGetD1:aCols[x][2])	
						ZG2->ZG2_EMAIL	 := AllTrim(oGetD1:aCols[x][3])								
						ZG2->ZG2_ROTINA	 := AllTrim(cRotina)
						ZG2->ZG2_CODROT	 := AllTrim(cCodRot)
					MsUnlock("ZG2") 				
			    EndIf
			Next       		 
			
			DbSelectArea("ZG3")			
			// RESPONSAVEIS
	   		For x:=1 to Len(oGetD2:aCols)
		   		If !oGetD2:aCols[x][len(oGetD2:aHeader)+1] // Nao pega quando estiver deletado	   		    
					RecLock("ZG3",.T.) 	     	    
			   			ZG3->ZG3_FILIAL  := xFilial("ZG3")		
						ZG3->ZG3_COD	 := oGetD2:aCols[x][1]			
						ZG3->ZG3_NOME	 := AllTrim(oGetD2:aCols[x][2])			
						ZG3->ZG3_CRIAD	 := AllTrim(oGetD2:aCols[x][3])
						ZG3->ZG3_DATA	 := oGetD2:aCols[x][4]
						ZG3->ZG3_ROTINA	 := AllTrim(cRotina)						
						ZG3->ZG3_CODROT	 := AllTrim(cCodRot)
					MsUnlock("ZG3") 				
			    EndIf
			Next       				
			
			MsgBox('Rotina inclu�da com sucesso.', 'Inclus�o', 'INFO') 
			    	
	   		oDlg:End()   	   					 	    
    			
    CASE nPar == 3 // Alterar
   
    		DbSelectArea("ZG1")
		    
		    // Altera��o da rotina
		    
			RecLock("ZG1",.F.) 					
				ZG1->ZG1_ASS  := AllTrim(cAssunto)
				ZG1->ZG1_STAT := cCombo				
				ZG1->ZG1_CC   := cCusto
				ZG1->ZG1_DIAS := cDias
				ZG1->ZG1_DESC := cDesc
			MsUnlock("ZG1")	
			
			DbSelectArea("ZG2")
			ZG2->(DBSETORDER(3))
										     
			// ALTERAR EMAILS
	   		For x:=1 to Len(oGetD1:aCols)
		   		If !oGetD1:aCols[x][len(oGetD1:aHeader)+1] // Nao pega quando estiver deletado	   		    	   		    
					If ZG2->(DbSeek( xFilial("ZG2")+ cCodRot + AllTrim(oGetD1:aCols[x][1] ) ) ) // Filial + Codigo Rotina + N� Item					
						RecLock("ZG2",.F.) 
							ZG2->ZG2_MAT	 := AllTrim(oGetD1:aCols[x][2])			   		
							ZG2->ZG2_EMAIL	 := AllTrim(oGetD1:aCols[x][3])										
						MsUnlock("ZG2") 				
					Else 											
						RecLock("ZG2",.T.) 	     	    
				   			ZG2->ZG2_FILIAL  := xFilial("ZG2")		
							ZG2->ZG2_ITEM	 := oGetD1:aCols[x][1]			
							ZG2->ZG2_MAT	 := AllTrim(oGetD1:aCols[x][2])		
							ZG2->ZG2_EMAIL	 := AllTrim(oGetD1:aCols[x][3])			
							ZG2->ZG2_ROTINA	 := AllTrim(cRotina)	
							ZG2->ZG2_CODROT  := cCodRot
						MsUnlock("ZG2") 										
					EndiF
				Else 
					ZG2->(DbSeek( xFilial("ZG2")+ cCodRot + AllTrim(oGetD1:aCols[x][1] ) ) )	// Filial + Codigo Rotina + N� Item
					RecLock("ZG2",.F.)
	  		   		   ZG2->(dbDelete())
	 	   			MsUnLock("ZG2")				
			    EndIf
			Next       		 
			
	   		DbSelectArea("ZG3")
			ZG3->(DBSETORDER(2))	
						
			// ALTERAR RESPONSAVEIS
	   		For x:=1 to Len(oGetD2:aCols)
		   		If !oGetD2:aCols[x][len(oGetD2:aHeader)+1] // Nao pega quando estiver deletado		   		   	 	   		    
					If ZG3->(DbSeek( xFilial("ZG3") + cCodRot + AllTrim(oGetD2:aCols[x][1])))					
						RecLock("ZG3",.F.)
							ZG3->ZG3_NOME	 := AllTrim(oGetD2:aCols[x][2])			
							ZG3->ZG3_CRIAD	 := AllTrim(oGetD2:aCols[x][3])
							ZG3->ZG3_DATA	 := oGetD2:aCols[x][4]
						MsUnlock("ZG3") 				
					Else
						RecLock("ZG3",.T.) 	     	    
				   			ZG3->ZG3_FILIAL  := xFilial("ZG3")		
							ZG3->ZG3_COD	 := oGetD2:aCols[x][1]			
							ZG3->ZG3_NOME	 := AllTrim(oGetD2:aCols[x][2])			
							ZG3->ZG3_CRIAD	 := AllTrim(oGetD2:aCols[x][3])
							ZG3->ZG3_DATA	 := oGetD2:aCols[x][4]
							ZG3->ZG3_ROTINA	 := AllTrim(cRotina)
							ZG3->ZG3_CODROT	 := AllTrim(cCodRot)
						MsUnlock("ZG3") 										
					EndiF
				Else
					ZG3->(DbSeek( xFilial("ZG3") + cCodRot + AllTrim(oGetD2:aCols[x][1])))
					RecLock("ZG3",.F.)
	  		   			ZG3->(dbDelete())
	 	   			MsUnLock("ZG3")				
			    EndIf
			Next       		 		
				
			MsgBox('Altera��o feita com sucesso.', 'Altera��o', 'INFO')	  
	
			oDlg:End() 
	
    CASE nPar == 4 // Desativar
	      
		If MsgYesNo("Tem certeza de que deseja desativar esta rotina ?")
			RecLock("ZG1",.T.) 				
				ZG1->ZG1_STAT := 'D'
			MsUnlock("ZG1")	 	 		
		EndIf
		
		oDlg:end()   		
	 	        
    OTHERWISE  		// No caso de uma opera��o de "Visualizar"         
    	oDlg:end()   
		
  ENDCASE  		 		  
	
Return     

/*******************************************************************************************/
/************************************** Legenda ********************************************/  
/*******************************************************************************************/ 

USER Function E210Legenda()       

Local aLegenda :=	{ {"BR_VERDE" , "Rotina ativa"},;
  				 	  {"BR_VERMELHO" , "Rotina desativada"}}			 	  

BrwLegenda(OemToAnsi("Status da Rotina x Email"), "Legenda", aLegenda)

Return           

Static Function fCriaCor()       

Local aLegenda :=	{ {"BR_VERDE" , "Rotina ativa"},;
                      {"BR_VERMELHO" , "Rotina desativada"}}

Local uRetorno := {}

Aadd(uRetorno, { " ZG1_STAT = 'A' ",aLegenda[1][1] }) // ativa
Aadd(uRetorno, { " ZG1_STAT = 'D' ",aLegenda[2][1] }) // desativada

Return(uRetorno)

/*******************************************************************************************/
/************************************** Valida��es *****************************************/  
/*******************************************************************************************/

Static Function Validar()

	If Empty(cRotina)
		MsgBox("Digite o nome da rotina !","Campo nome da rotina est� em branco","Alert")
		Return .F.
	EndIF
	
	If Empty(cAssunto)
		MsgBox("Digite o assunto do e-mail !","Campo assunto est� em branco","Alert")
		Return .F.
	EndIF
	
	If Empty(oGetD1:aCols[1][3]) .AND. Len(oGetD1:aCols) == 1
	   MsgBox("Insira ao menos 1 e-mail !","Nenhum e-mail inserido","Alert")        	
       Return .F.	   
	EndIF    
	
	If empty(oGetD2:aCols[1][2]) .AND. Len(oGetD2:aCols) == 1
	   MsgBox("Insira ao menos 1 respons�vel !","Nenhum respons�vel inclu�do","Alert")        	
  	   Return .F.
	EndIF   

Return .T. 

/*******************************************************************************************/
/**************************************** Cancelar *****************************************/  
/*******************************************************************************************/

Static Function Cancelar() 
	
	RollBackSX8()
	oDlg:end()      

Return