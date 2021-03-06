/*                	
+----------------------------------------------------------------------------+
!                             FICHA T�CNICA DO PROGRAMA                      !
+----------------------------------------------------------------------------+
!   DADOS DO PROGRAMA                                                        !
+------------------+---------------------------------------------------------+
!Tipo              ! PONTO DE ENTRADA                                        !
+------------------+---------------------------------------------------------+
!M�dulo            ! Estoque/Custos                                          !
+------------------+---------------------------------------------------------+
!Nome              ! MA261LIN  -> (MATA261) Transf. Mod. II                  !
+------------------+---------------------------------------------------------+
!Tabelas Utilizadas! SD3                                                     !
+------------------+---------------------------------------------------------+
!Descricao         ! Validar o produto de origem com o produto de destino    !
!                  ! e atualizar o campo almox destino no local orig.        !
+------------------+---------------------------------------------------------+
!Autor             ! Alexandre R. Bento                                      !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 17.05.04                                                !
+------------------+---------------------------------------------------------+
!   ATUALIZACOES                                                             !
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !Nome do    ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
!Valida��o do campo D3_DEFEITO e D3_CARDEF, !Andrea Mark!Alexandre  !04.06.04!
!                   D3_FORNECE e D3_LOJA    !           !R. Bento   !        !
+-------------------------------------------+-----------+-----------+--------+
!Valida��o de usuario                       !CesarSM    !Alexandre  !10.03.09!
!                                           !           !R. Bento   !        !
+-------------------------------------------+-----------+-----------+--------+
!Valida��o data Retroativa                  !FernandoW  !Alexandre  !25.02.11!
!                                           !           !R. Bento   !        !
+-------------------------------------------+-----------+-----------+--------+ 
!Valida��o de Invent�rio                    !RogerioS   !Douglas    !23.10.12!
!                                           !           !Dourado    !        !
+-------------------------------------------+-----------+-----------+--------+

*/   

#include "rwmake.ch"     

User Function MA261LIN()

Local lRet      := .T.
Local _cCarDef  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CARDEF"})
Local _cDefeito := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_DEFEITO"})
Local _cFornece := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_FORNECE"})
Local _cLoja    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOJA"})
Local _cLocal   := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"})
Local _cLocDest := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_LOCAL"},_cLocal+1)
Local _cProd    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_COD"})
Local _cUM      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_UM"})
Local _nQtde    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_QUANT"})
Local _cCC      := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CC"})
Local _cCorr    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D3_CORRID"})
Local _nDias    := GETMV("MV_DIASMO")
Local aArea     := GetArea()
Local aAreaSB1  := SB1->(GetArea()) // Guarda a posi�ao inicial  

/******************** INVENTARIO *******************/
//Verifica se produto est� bloqueado para invent�rio 

// Confere Local Origem
If !aCols[n][len(aHeader)+1]	
	If !U_E205BLQ(Acols[n][_cProd],Acols[n][_cLocal])				
	    Return .F. 	
	EndIF
EndIf
     
// Confere Local Destino
If !aCols[n][len(aHeader)+1]	
	If !U_E205BLQ(Acols[n][_cProd],Acols[n][_cLocDest])				
	    Return .F. 	
	EndIF
EndIf
/***************************************************/  

/*
//-- OS N�: 056485
If SM0->M0_CODIGO == "FN" .and. !Alltrim(Upper(Funname()))$"NHEST139" .AND. aCols[n][_cLocal]$"27/47/67"

	//valida saldo computando as transf fun/usi abertas, rotina NHEST139, tabelas ZBA e ZBB
	a139Sld := U_EST139SLD(aCols[n][_cProd],aCols[n][_cLocal])
                        
  	//VALIDACAO COM ERRO - ESPERANDO UMA VARIAVEM DO TIPO ARRAY E RETORNA BOLLEANA, SE VIER DO COLETOR NAO PASSA NA VALIDACAO
  	if Type("MsgRetWMS")!="C"                                              
		If a139Sld[1] < AcOLS[N][_nqtde]
		
					//verifica se a variavel que controla o erro via coletor est� declarada
		  		if Type("MsgRetWMS")=="C"                                              
		  			//retorna o erro ao coletor
		  			MsgRetWMS := "Saldo insuficiente!" +CHR(13)+CHR(10)+;
						"(+)Saldo Atual: "+ Transform(a139Sld[1]+a139Sld[2],"@e 999999")+CHR(13)+CHR(10)+;
						"(-)Saldo em Transf.: "+Transform(a139Sld[2],"@e 999999")+CHR(13)+CHR(10)+;
						"(=)Saldo Dispon�vel: "+Transform(a139Sld[1],"@e 999999")
						
						//indica a origem da mensagem para faciliar o suporte
						MsgRetWMS += " (P.E. MA261LIN)"
						
		  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
					  lMsErroAuto := .T.
					else
						Alert("Saldo insuficiente!" +CHR(13)+CHR(10)+;
						"(+)Saldo Atual: "+ Transform(a139Sld[1]+a139Sld[2],"@e 999999")+CHR(13)+CHR(10)+;
						"(-)Saldo em Transf.: "+Transform(a139Sld[2],"@e 999999")+CHR(13)+CHR(10)+;
						"(=)Saldo Dispon�vel: "+Transform(a139Sld[1],"@e 999999"))
		  		endif		
			Return .F.
		EndIf
	Endif	
Endif
//-- FIM OS N�: 056485
 */
//-- OS N�: 056126 
If SM0->M0_CODIGO == "FN" .and. SM0->M0_CODFIL == "02" 
	If (substr(aCols[n][_cLocal],0,1) <> '5' .OR. substr(aCols[n][_cLocDest],0,1) <> '5') .AND. !Alltrim(upper(cUsername))$"ERICALP\ADMIN\JOAOFR\ALEXANDRERB\MARCOSR\DAIANESC\ELISANGELAOS\EMANUELBM\JONESTONBM\HESSLERR\DOUGLASSD\LUIZWJ\RUBENSSR"
	   	
	   	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Armaz�m n�o pode ser utilizado! Na filial 02 (PE) s� pode ser utilizado armazens com inicio 5 !"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox("Armaz�m n�o pode ser utilizado! Na filial 02 (PE) s� pode ser utilizado armazens com inicio 5 !", "Transferencia P.E. MA261LIN (OS 056126)", "ALERT" )
	  		endif		

	   	
		Return .F.
	Endif
EndIf
//FIM OS 056126

If aCols[n][_nQtde]<0
	

				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Quantidade n�o pode ser negativa!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					Alert("Quantidade n�o pode ser negativa!")
	  		endif		
	
	
	Return .F.
Endif

If Da261data < (Date()- _nDias) .OR. Da261data < (dDatabase - _nDias)  //Controle de data para n�o permitir mov. com data retroativa controle paramatro mv_diasmo = numero de dias
   
   
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Impossivel Fazer a Transferencia Data Menor que a Permitida Depto Custo! - P.E. - MA261LIN"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "Impossivel Fazer a Transferencia Data Menor que a Permitida Depto Custo! - P.E. - MA261LIN", "Transferencia", "ALERT" )
	  		endif		

   
   RestArea(aArea)
   Return(.F.)
Endif

If aCols[n][_cLocDest] $ "52" .AND. !Alltrim(Upper(cUsername)) $ "DIOGOBA/ANDERSONSC/MATEUSHD/CARLOSPS/EDERSON/CUSTODIOFS/DANILOCS/DAIANESC/JOAOFR/REGINASM/ANTONIOVG/EVERTONG/JEFFERSONAS/ERICALP/RUBENSSR/DOUGLASSD/HESSLERR/ADRIANOSD"
	
	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Transferencia para o almoxarifado 52 � restrita!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox("Transferencia para o almoxarifado 52 � restrita!","Transfer�ncia P.E. MA261LIN", "ALERT")
	  		endif		

	
	RestArea(aArea)
	Return .F.
EndIf

If !UPPER(FUNNAME())$"MATA250"
	If (SM0->M0_CODIGO$"FN/NH" .and. !Alltrim(Upper(cUsername))$ "ADMINISTRADOR/FERNANDOW/ANAPP/DOUGLASFS/DEVANIRLO/DAIANESC/EVERTONG/JEFFERSONAS" .AND. !Alltrim(aCols[n][_cProd]) $ "MP01.000033/MP01.000031/MP01.000037/MP01.000038/MP01.000015") .or. ;
	   (SM0->M0_CODIGO$"IT"    .and. !Alltrim(Upper(cUsername))$ "ADMINISTRADOR/FERNANDOW/ANAPP/VALDELENEMS/DAIANESC/ELVIS.MENDES/ELITON.JESUS")
	
		If aCols[n][1] <> aCols[n][6] .OR. Empty(aCols[n][6]) .OR. Empty(aCols[n][1])
		
			//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Imposs�vel fazer transfer�ncia de produtos com c�digo diferentes!"+chr(13)+chr(10)+"Permitido apenas com autoriza��o!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox("Imposs�vel fazer transfer�ncia de produtos com c�digo diferentes!"+chr(13)+chr(10)+"Permitido apenas com autoriza��o!", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		
		   
		   lRet := .F.
		Endif
	Endif	
Endif

If Da261data > dDatabase
   
   
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Imposs�vel fazer transfer�ncia com data maior que a database do sistema!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "Imposs�vel fazer transfer�ncia com data maior que a database do sistema!", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		

   
   lRet := .F.
Endif                 

If !Empty(aCols[n,_cDefeito]) // Testa o codigo de defeito se existe
   If !aCols[n,_cUM]$"KG" //se nao pertencer a unidade a kilo verifica a qtde quebrada
	   If (aCols[n,_nQtde] - Int(aCols[n,_nQtde])) > 0 .And.   (aCols[n,_nQtde] - Int(aCols[n,_nQtde])) < 1 //Valida a digitacao de qtde quebrada na unidade
	      
	      
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Quantidade Nao pode ser menor que UM"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "Quantidade Nao pode ser menor que UM", "Transfer�ncia P.E. MA261LIN", "ALERT" )   
	  		endif		
	      
	      lRet := .F.
       Endif
   Endif
   
   If !SZ6->(Dbseek(xfilial("SZ6")+aCols[n,_cDefeito]))
      
      
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Codigo do Defeito nao Existe!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "Codigo do Defeito nao Existe!", "Transfer�ncia P.E. MA261LIN", "ALERT" )   
	  		endif		

      
      lRet := .F.
   Endif
Endif

If !Empty(aCols[n,_cCarDef]) // Testa o codigo da caracteristica do defeito se existe

   If !SZ8->(Dbseek(xfilial("SZ8")+aCols[n,_cCarDef]))                     
      
      
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Codigo da Caracteristica do Defeito nao Existe!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "Codigo da Caracteristica do Defeito nao Existe!", "Transfer�ncia P.E. MA261LIN", "ALERT" )      
	  		endif		
      
      
      lRet := .F.                                                       
   Endif
Endif

//-- valida o saldo em estoque (QATU - A Clasificar - Reserva)
/* Retirado por causa de registros sem perna (rela��o)
SB2->(DbSetOrder(1))
if !SB2->(DbSeek(XFilial("SB2") + GdFieldGet("D3_COD", N) + aCols[N][4]))
	
	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Saldo em estoque do produto de origem n�o localizado!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					Alert("Saldo em estoque do produto de origem n�o localizado!")
	  		endif		
	
	Return .F.
endIF

// valida o saldo em estoque
if (SB2->B2_QATU - SB2->B2_RESERVA - SB2->B2_QACLASS) < GdFieldGet("D3_QUANT", N)
	
	
	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Saldo dispon�vel em estoque do produto de origem insuficiente! Verifique se h� produtos h� endere�ar!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "Saldo dispon�vel em estoque do produto de origem insuficiente! Verifique se h� produtos h� endere�ar!", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		
	
	Return .F.
endIf
*/
If SM0->M0_CODIGO == "NH"
	
	If !Alltrim(UPPER(cUsername))$"DAIANESC/ANAPP/ANDREA/ANGELACS/FERNANDOW/ADMINISTRADOR/VALDELENEMS" .And.  aCols[n][_cLocal]$"00/99" 
	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transfer�ncia de Produtos do Almoxarifado � restrita! Somente permitido para Qualidade/Controladoria!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transfer�ncia de Produtos do Almoxarifado � restrita! Somente permitido para Qualidade/Controladoria!", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		
	
	   
	   lRet := .F.
	Endif   

   	If !Alltrim(UPPER(cUsername))$"FERNANDOEG/MARCOSC/CLOVISE/RODRIGOTS/ELIBERTOSO/ALISSONJL/ROBERTOSH/ALMIRANTEC/DIOGOBA/RAFAELJS/JAIRLM/ANTONIOVG/JOSEMARSP/LEANDROJS/RODRIGOPV/ANDERSONMS/HENRIQUESL/ALEXANDRESC/ANDRELA/ALISSONMS/RODRIGOAC/JOSEAM/LUISC/JOSEPO/LEANDROCA/LUIZAC/ADRIANOSD" .And.  aCols[n][_cLocal]$"02/03" 
      	

				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transfer�ncia de Produtos a este Almoxarifado � restrita! "
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transfer�ncia de Produtos a este Almoxarifado � restrita! ", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		
      	
      	
      	lRet := .F.      
   	Endif	   
   	
ElseIf SM0->M0_CODIGO == "FN"

	//-- OS N�: 044447
	If (aCols[n][_cLocal]$"35" .OR. aCols[n][_cLocDest]$"35") .AND. (!Alltrim(upper(cUsername))$"ANAP\ADMIN\REGINASM\DAIANESC\JOAOFR\DOUGLASSD\ALEXANDRERB") 
		   	
					//verifica se a variavel que controla o erro via coletor est� declarada
		  		if Type("MsgRetWMS")=="C"                                              
			  			//retorna o erro ao coletor
			  			MsgRetWMS := "Armaz�m n�o pode ser utilizado! Armaz�m substitu�do pelo armaz�m 3F!"
						//indica a origem da mensagem para faciliar o suporte
						MsgRetWMS += " (P.E. MA261LIN)"
						
		  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
					  lMsErroAuto := .T.
					else
						MsgBox("Armaz�m n�o pode ser utilizado! Armaz�m substitu�do pelo armaz�m 3F!", "Transferencia P.E. MA261LIN (OS 044447)", "ALERT" )
		  		endif		
	   	
		Return .F.
	Endif
	//FIM OS 044447
	
	
	//-- OS N�: 066950
	If (aCols[n][_cLocal]$"31" .OR. aCols[n][_cLocDest]$"31") .AND. (Alltrim(upper(cUsername))$"ANTONIOVG") 
		   	
					//verifica se a variavel que controla o erro via coletor est� declarada
		  		if Type("MsgRetWMS")=="C"                                              
			  			//retorna o erro ao coletor
			  			MsgRetWMS := "Usuario n�o pode utilizar o armazem 31!"
						//indica a origem da mensagem para faciliar o suporte
						MsgRetWMS += " (P.E. MA261LIN)"						
		  		       //retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
					   lMsErroAuto := .T.
				else
						MsgBox("Usuario n�o pode usar o armaz�m 31!", "Transferencia P.E. MA261LIN (OS 066950)", "ALERT" )
		  		endif		
	   	
		Return .F.
	Endif
	//FIM OS 044447
	
	
	
	//-- OS. N�: 024365
	//-- autor: Jo�o Felipe da Rosa
	//-- data: 03/11/2011
	//-- quando armazem for 37, s� permitir para pessoal da logistica
	If aCols[n][_cLocal]$"37" .AND. !Alltrim(UPPER(cUsername))$"LUPERCIOC/PAULOAD/ALISSONJL/CASSIANORS/ADACIRD/HESSLERR/ADMIN/ADMINISTRADOR/ANAPP/DAIANESC/CLOVISE/RAFAELDW/JOAOFR/FERNANDOEG/JEFERSONAS/TIAGOMS/ANDERSONSC/ANDERSONMS/DOUGLASSD"
      	
      	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transferencia de Produtos a este Almoxarifado � restrita ! "
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transferencia de Produtos a este Almoxarifado � restrita ! ", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		

      	
      	RestArea(aArea)
      	Return .f.
    Endif
	//-- Fim OS N�: 024365 	
	
	
	//-- OS. N�: 075003
	//-- autor: Douglas de Sousa Dourado
	//-- data: 20/05/2014
	//-- quando for do 45 para o 32 , obrigatorio preenchimento da corrida
	If aCols[n][_cLocal]$"45" .AND. aCols[n][_cLocDest]$"32" .AND. Empty(aCols[n,_cCorr])     	
      	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  		   	//retorna o erro ao coletor
	  			MsgRetWMS := "Obrigatorio o preenchimento do campo CORRIDA para est� transferencia!  "
				//indica a origem da mensagem para faciliar o suporte
				MsgRetWMS += "(P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
			    lMsErroAuto := .T.
			else
				MsgBox( "Obrigatorio o preenchimento do campo CORRIDA para transferencia do 45 para 32 !", "Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		
      
      	Return .f.
    Endif
	//-- Fim OS N�: 075003	
	
 
   	If !Alltrim(UPPER(cUsername))$"MARCOSC/RODRIGOTS/ELIBERTOSO/ALISSONJL/"+;
   								  "ROBERTOSH/ALMIRANTEC/DIOGOBA/JAIRLM/ANTONIOVG/"+;
   								  "JOSEMARSP/LEANDROJS/RODRIGOPV/ANDERSONMS/HENRIQUESL/ALEXANDRESC/"+;
   								  "ANDRELA/ALISSONMS/RODRIGOAC/JOSEAM/LUISC/FERNANDOP/JOSEPO/ANAP/"+;
   								  "FERNANDOW/FERNANDOEG/LEANDROCA/ROBSONST/LUIZAC/DAIANESC/ADMINISTRADOR/JOAOFR/"+;
   								  "HESSLERR/ELIBERTOSO/CAROLINEOE/LUIZAC/MARCOSC/SOLIANEFF/LUCASCS/ADRIANOSD/"+;
   								  "JOSEMARSP/ALMIRANTEC/RODRIGOTS/DAVIDMC/DOUGLASSD" .And.  aCols[n][_cLocal]$"32" .and. !aCols[n][_cLocDest]$"3F"

				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transferencia de Produtos a este Almoxarifado � restrita ! "
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transferencia de Produtos a este Almoxarifado � restrita ! ", "Transferencia P.E. MA261LIN", "ALERT" )
	  		endif				  
      	
      	lRet := .F.      
   	Endif	   
   	                                                         
   	//-- OS N�: 036220
   	If aCols[n][_cLocal]$"32" .and. aCols[n][_cLocDest]$"3F" .and. ;
	   	!Alltrim(UPPER(cUsername))$"JEFFERSONVL/ARTHURCE/GUILHERMELF/MARCELOM/PAULOHG/TIAGOJO/MATHEUSB/ADMINISTRADOR/"+;
	   							   "JOAOFR/ELIBERTOSO/CAROLINEOE/LUIZAC/MARCOSC/SOLIANEFF/JOSEMARSP/ALMIRANTEC/"+;
	   							   "RODRIGOTS/DAVIDMC/ANDREIAP/LUIZADB/DOUGLASSD/ADRIANOSD"

				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transferencia de Produtos a este Almoxarifado � restrita! "
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					      	MsgBox( "A Transferencia de Produtos a este Almoxarifado � restrita! ", "Transferencia P.E. MA261LIN (OS 036220)", "ALERT" )
	  		endif		
      	
      	
      	lRet := .F.    		
	Endif
	//FIM OS 036220
	
  	//-- os. n�: 022600
   	//-- autor: Jo�o Felipe da Rosa
   	//-- data: 15/09/2011
   	//-- desc: limitar transfer�ncia dos armaz�ns da forjaria para determinados usu�rios
   	If !Upper(Funname())$"NHEST139/NHPCP043" .and. !Alltrim(UPPER(cUsername))$"MARIOCP/ANAPP/DAIANESC/FERNANDOW/FABIANESR/"+;
   	                                                                          "MARCELOV/EDERSON/LUCASDS/CARLOSDI/MATHEUSAR/"+;
   	                                                                          "ADMINISTRADOR/JOAOFR/LEANDROFP/ANSELMOAR/AUDINEIB/"+;
   	                                                                          "ALESSANDROCR/DIOGOPO/ZACARIASA/ANGELAMH/MATHEUSAR" .And. aCols[n][_cLocal]$"41/42/44/45/47/49"
      	
      	
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transferencia de Produtos a este Almoxarifado � restrita! Entre em contato com a Log�stica Virabrequim! "
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transferencia de Produtos a este Almoxarifado � restrita! Entre em contato com a Log�stica Virabrequim! ", "P.E. MA261LIN (OS n�: 022600)", "ALERT" )
	  		endif		

      	
      	RestArea(aArea)
      	Return .f.
   	Endif	   
	//-- Fim OS n�: 022600

   	SB1->(DbSetOrder(1)) //filial+cod
	SB1->(DbSeek(xFilial("SB1")+Acols[n][_cProd]))
	
	/*  // liberado pela RNC EM 20/11/12
	If SB1->B1_GRUPO$"PA02/PA03" .And. Acols[n][_cLocDest]$"34"//verifica se o local de destino
		MsgBox("O Produto nao pode ser Movimentado neste almoxarifado. Verifique!","Atencao","ALERT")
	    lRet := .F.
	Endif
    */
    
	If SB1->B1_GRUPO$"PA02" .And. Acols[n][_cLocDest]$"23/27"//verifica se o local de destino

				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "O Produto nao pode ser Movimentado neste almoxarifado. Verifique!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox("O Produto nao pode ser Movimentado neste almoxarifado. Verifique!","Atencao","ALERT")
	  		endif		
	
		
	    lRet := .F.
	Endif
    RestArea(aAreaSB1) // Volta a posicaodo arquivo
    
	
	If Acols[n][_cLocal]$"32" // almoxarifado origem
		If !Alltrim(UPPER(cUsername))$"ADMINISTRADOR/JOAOFR/FERNANDOW/ANAPP/DAIANESC/LEANDROJS/RODRIGOPV/ARTHURCE/JOSELS/ADRIANOSD"+;
									"ALLANPR/OLAIRD/ELIETETM/PEDROOC/RAFAELG/OZIELFC/ANGELACS/FRANCISCOPS/FABIENEA/DIEGOP/ALMIRANTEC/"+;
									"LUISC/HESSLERR/MATHEUSB/ELIBERTOSO/CAROLINEOE/LUIZAC/MARCOSC/SOLIANEFF/LUCASCS/DAVIDMC/ADRIANOSD" .AND. !Acols[n][_cLocDest]$"34/32/33/52/54/55/25/3F" //verifica se o local de destino � diferente de 34/32
									
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transferencia do Local 32 s� Pode ser feita para o Local 32 ou 33 ou 34 ou 52 ou 54 ou 55 ou 25 ou 3F !"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transferencia do Local 32 s� Pode ser feita para o Local 32 ou 33 ou 34 ou 52 ou 54 ou 55 ou 25 ou 3F !", "Transferencia P.E. MA261LIN", "ALERT" )
	  		endif		
									
			
		    lRet := .F.
		Endif
	Endif
	
	
	// OS 051785
	// ANALISTA: DOUGLAS DOURADO	
	If Acols[n][_cLocal]$"63/65/67/69" .or. Acols[n][_cLocDest]$"63/65/67/69"  
		If !Alltrim(UPPER(cUsername))$"ADMINISTRADOR/JOAOFR/ANAPP/DAIANESC/ALEXANDRERB/MARCOSR/GUILHERMEDC/EVERTONG/JEFFERSONAS/CLOVISM/DOUGLASSD/ALMIRANTEC/RODRIGOTS/JOSEMARSP/PAULOFG/ADRIANOSD"
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Armazens 63/65/67/69 s� podem utilizados pela Logistica Aluminio. Favor entrar em contato com os mesmos."
				//indica a origem da mensagem para faciliar o suporte
				MsgRetWMS += " (P.E. MA261LIN)"					
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
			    lMsErroAuto := .T.
			else
			    MsgBox( "Armazens 63 / 65 / 67 / 69 s� podem utilizados pela Logistica Aluminio. Favor entrar em contato com os mesmos.", "Transferencia P.E. MA261LIN", "ALERT" )
	  		endif										
			
		    lRet := .F.
		    
		Endif
	Endif     
	     
	
	If Acols[n][_cLocal]$"33" // almoxarifado origem  - OS: 049215 - A pedido de Eliberto / Diogo - 08-08-13
		If !Alltrim(UPPER(cUsername))$"ADMINISTRADOR/JOAOFR/FERNANDOW/ANAPP/DAIANESC/ELIBERTOSO/LUIZAC/SOLIANEFF/DIOGOBA/HENRIQUESL/DOUGLASSD/ALEXANDRERB/MARCOSR/JONESTONBM/ERICALP/RSAC/DAVIDMC/LEANDROJS/ADRIANOSD/EMANUELBM/BRUNOAM" 
		
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "A Transferencia do Local 33 s� Pode ser feita pelo pessoal da logistica !"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox( "A Transferencia do Local 33 s� Pode ser feita pelo pessoal da logistica !", "Transferencia P.E. MA261LIN", "ALERT" )
	  		endif		
		
			
		    lRet := .F.
		Endif
	Endif
	   
	//-- chamado 016205 do portal
	//-- quando o armazem for diferente de 32 n�o permitir transferencia p/ c.custo ALMOXI
	/*If !Acols[n][_cLocDest]$'22/32' .and. ALLTRIM(Acols[n][_cCC])$'ALMOXARI' .AND. !ALLTRIM(UPPER(SB1->B1_CC))$'ALMOXARI'
		MsgBox("C.Custo n�o pode ser ALMOXARI quando o armaz�m de destino for diferente de 32!","Transfer�ncia P.E. MA261LIN", "ALERT" )
		Return .F.
	EndIf*/
	
	//-- OS N�: 021437
	//-- data: 09/08/2011
	//-- autor: Jo�o Felipe da Rosa
	//-- desc: bloquear baixas como kg para o item IVE01.5.0008.03 pois � controlado em unidade. 
	//--       E mostrar mensagem caso itens PSA01.5.0008.01 e GMB01.5.0008.01
	//-- 	   D�vidas entrar em contato com RODRIGOPV do PCP
	If ALLTRIM(Acols[n][_cProd])$"IVE01.5.0008.03" .AND. (aCols[n,_nQtde] - Int(aCols[n,_nQtde])) > 0 .And. (aCols[n,_nQtde] - Int(aCols[n,_nQtde])) < 1 //Valida a digitacao de qtde quebrada na unidade
		
		
				//verifica se a variavel que controla o erro via coletor est� declarada
	  		if Type("MsgRetWMS")=="C"                                              
	  			//retorna o erro ao coletor
	  			MsgRetWMS := "Quantidade n�o pode ser quebrada, produto � controlado por Unidade!"
					//indica a origem da mensagem para faciliar o suporte
					MsgRetWMS += " (P.E. MA261LIN)"
	  			//retorna o erro a variavel de controle, importante para que o coletor exiba o erro corretamente
				  lMsErroAuto := .T.
				else
					MsgBox("Quantidade n�o pode ser quebrada, produto � controlado por Unidade!","Transfer�ncia P.E. MA261LIN", "ALERT" )
	  		endif		

		
		RestArea(aArea)
		Return .F.
	EndIf
		
	If ALLTRIM(Acols[n][_cProd])$"PSA01.5.0008.01/GMB01.5.0008.01"
		If !MSGYesNo('ATEN��O: ESTE ITEM � CONTROLADO POR KG. DESEJA CONTIUNAR?')	
			RestArea(aArea)
			Return .f.
		Endif
	EndIf
	//-- fim OS 021437
	
Elseif SM0->M0_CODIGO$"IT"   

		If acols[n][_cLocal]$"37" .and. !Alltrim(UPPER(cUsername))$"ELIANE.VANTROBA/TIAGO.SALDANHA/FERNANDO.SILVA/JOSE.TEIXEIRA/ANTONIO.SECHI"
 			Alert("Usu�rio sem permiss�o para retirar pe�a do Armaz�m 37!")
 			Return .f.
		Endif

   		// solicitado por Luciano Camargo - Itesapar - 03/02/2014
		If (acols[n][_cLocal]$"32" .or. aCols[n][_cLocDest]$"32") .and. !Alltrim(cUsername)$"wagner.ferreira/pamela.silva/priscila.prinz/michel.ferraz/cleverson.wience/LUCIANOC/DOUGLASSD/JOAOFR/claudineia.vardenski/antonio.sechi/cristina.rochinski"
 			Alert("Usu�rio sem permiss�o para utilizar o Armaz�m 32 !")
 			Return .f.
		Endif
		
		// solicitado por Luciano Camargo - Itesapar - 03/02/2014
		If (acols[n][_cLocal]$"62" .or. aCols[n][_cLocDest]$"62") .and. !Alltrim(cUsername)$"wagner.ferreira/pamela.silva/priscila.prinz/michel.ferraz/cleverson.wience/LUCIANOC/DOUGLASSD/JOAOFR/cristina.rochinski"
 			Alert("Usu�rio sem permiss�o para utilizar o Armaz�m 62 !")
 			Return .f.
		Endif  
		
			//-- solicitado por valdelenems 06/01/2014
	   	SB1->(DbSetOrder(1)) //filial+cod
		SB1->(DbSeek(xFilial("SB1")+Acols[n][_cProd]))
		
		IF SB1->B1_GRUPO$"FE31/FE32/FE33/FE35" .AND. ACOLS[n][_cLocDest]$"31"
			Alert("Armaz�m n�o permitido, favor utilizar armaz�m 35!")
			return .f.
		Endif
   
Endif	

RestArea(aArea)

Return(lRet)