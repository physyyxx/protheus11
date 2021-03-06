#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function rhgp28()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,CSTRING,ARETURN,NLASTKEY,CRODATXT")
SetPrvt("NCNTIMPR,TITULO,CDESC1,CDESC2,CDESC3,NTIPO")
SetPrvt("NOMEPROG,CPERG,NPAG,NROS,ADRIVER,CCOMPAC")
SetPrvt("CNORMAL,CQUERY,NUMERO,CULTIMO,")

// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> #INCLUDE "TOPCONN.CH"
#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  � RHGP28          � Marcelo J. Santos     � Data �04.01.2000낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇙o � Relacao de Funcionarios em Ordem de Sal쟲io               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿞intaxe   � Chamada padr꼘 para programas em RDMake.                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:=""
CbCont:="";cabec1:="";cabec2:="";cabec3:="";wnrel:=""
nOrdem:=0
tamanho:="M"
limite :=132
cString:="SRA"
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Relatorio de Funcionarios por Grau de Instrucao"
cDesc1   := "O objetivo deste relatorio e' listar os Funcionarios totalizados"
cDesc2   := "por Grau de Instrucao."
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
nomeprog := "RHGP28"
cPerg    := "RHGP28"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//�                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//pergunte('GPM450',.T.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel:= "RHGP28"

SetPrint("SRA",NomeProg,cPerg,titulo,cDesc1,cDesc2,cDesc3,.T.,"")
If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica se deve comprimir ou nao                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
ntipo  := IIF(aReturn[4]==1,GetMV("MV_COMP"),GetMV("MV_NORM"))

nPag := 1

cabec1 := "MATRICULA    NOME                                         SALARIO                 "
cabec2 := "---------    -------------------------------------------  ------------------------"

nRos:=SM0->M0_CGC
aDriver := ReadDriver()
cCompac := aDriver[1]
cNormal := aDriver[2]

rptStatus({||Imprime()},"Imprimindo...")// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> rptStatus({||Execute(Imprime)},"Imprimindo...")
Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Imprime
Static Function Imprime()

If mv_par01 == 1
   cQuery := "SELECT (RA_SALARIO * 220) AS SALARIO,RA_NOME,RA_MAT"
   cQuery := cQuery + " FROM SRANH0"
   cQuery := cQuery + " WHERE RA_SITFOLH <> 'D' AND"
   cQuery := cQuery + " RA_CATFUNC = 'H' AND D_E_L_E_T_ <> '*'"
Else
   cQuery := "SELECT RA_SALARIO AS SALARIO,RA_NOME,RA_MAT"
   cQuery := cQuery + " FROM SRANH0"
   cQuery := cQuery + " WHERE RA_SITFOLH <> 'D' AND"
   cQuery := cQuery + " RA_CATFUNC = 'M' AND D_E_L_E_T_ <> '*'"
Endif
If mv_par02 == 1
   cQuery := cQuery + " ORDER BY SALARIO"
Else
   cQuery := cQuery + " ORDER BY SALARIO DESC"
Endif

//TCQuery Abre uma workarea com o resultado da query
TCQUERY cQuery NEW ALIAS "PROCSRA"
DbSelectArea("PROCSRA")

DbSelectArea("SRA")
SetRegua(RecCount())

DbSelectArea("PROCSRA")

Cabecalho()

Numero:=1
Numero:=Numero+1
cULTIMO := "  "
PROCSRA->(dbGoTop())
While PROCSRA->(!Eof())
   If pRow() > 66
      Eject
      nPag := nPag + 1
      Cabecalho()
   Endif
   @ prow()+1,00 PSAY PROCSRA->RA_MAT
   @ prow(),13   PSAY PROCSRA->RA_NOME
   @ prow(),58   PSAY PROCSRA->SALARIO picture "@E 99,999,999.99"
   PROCSRA->(DbSkip())
   IncRegua()
Enddo

Eject

RestScreen(3,0,24,79,cSavScr1)
DbSelectArea("PROCSRA")
DbCloseArea()

If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

Return

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function Cabecalho
Static Function Cabecalho()
@ prow()+1,00 Psay &cCompac+Repli("*",132)
@ prow()+1,00 Psay "*"+SM0->M0_NOMECOM
@ prow(),112 Psay "Folha : "                                                                                                    
@ prow(),124 Psay StrZero(nPag,5,0)+"  *"
@ prow()+1,00 Psay "*S.I.G.A. / "+nomeprog
@ prow(),20 Psay PadC(titulo,82)
@ prow(),112 Psay "DT.Ref.: "+Dtoc(dDataBase)+"  *"
@ prow()+1,00 Psay "*Hora...: "+Time()
@ prow(),112 Psay "Emissao: "+Dtoc(Date())+"  *"
@ prow()+1,00 Psay Repli("*",132)
@ prow()+1,00 Psay " "
@ prow()+1,00 Psay cabec1 
@ prow()+1,00 Psay cabec2 

Return

