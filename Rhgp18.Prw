#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Rhgp18()        // incluido pelo assistente de conversao do AP5 IDE em 27/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CSAVCUR1,CSAVROW1,CSAVCOL1,CSAVCOR1,CSAVSCR1,CBTXT")
SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM")
SetPrvt("TAMANHO,LIMITE,ARETURN,NLASTKEY,CRODATXT,NCNTIMPR")
SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,NTIPO")
SetPrvt("M_PAG,NOMEPROG,CPERG,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 27/10/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛rograma  � RHGP18          � M.GracaNCarvalho      � Data � 01.12.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escri뇙o � Controle de entregas de documentos                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿞intaxe   � Chamada padr꼘 para programas em RDMake.                  낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽*/

cSavCur1:="";cSavRow1:="";cSavCol1:="";cSavCor1:="";cSavScr1:="";CbTxt:="";CbCont:=""

cabec1:="";cabec2:="";cabec3:="";wnrel:=""

nOrdem:=0
tamanho:="P"
limite :=132
aReturn := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
nLastKey:= 0
cRodaTxt := ""
nCntImpr := 0
titulo   := "Controle de Requerimento de Documento para Arquivo"
cDesc1   := ""
cDesc2   := ""
cDesc3   := ""
cString  := "SRA"
nTipo    := 0
m_pag    := 1
nomeprog := "RHGP18"
cPerg     := 'RHGP07'

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//�                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte('RHGP07',.F.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel := "RHGP18"
wnRel := SetPrint(cString,wnrel,cperg,titulo,cDesc1,cDesc2,cDesc3,.F.,"")

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   RestScreen(3,0,24,79,cSavScr1)
   Return
Endif


#IFDEF WINDOWS
    RptStatus({|| RHG018()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==>     RptStatus({|| Execute(RHG018)})  //-- Chamada do Relatorio.
	Return Nil
#ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 27/10/01 ==> Function RHG018
Static Function RHG018()

DbSelectArea("SRA")
DbSetOrder(01)

SRA->(DbGoTop())
SRA->(SetRegua(RecCount()))

SRA->(DbSeek(mv_par01+mv_par03,.T.))
While SRA->(!Eof()) .and. SRA->RA_FILIAL>=mv_par01 .and. SRA->RA_FILIAL<=mv_par02 .and. SRA->RA_MAT<=mv_par03 .and. SRA->RA_MAT>=mv_par04
   IncRegua()
   @ pRow(), 22 pSay "* * NEW HUBNER COMPONENTES AUTOMOTIVOS * *"
   @ pRow()+2, 18 pSay "CONTROLE DE REQUERIMENTO DE DOCUMENTOS PARA ARQUIVO"
   @ pRow()+3, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "NOME : "+SRA->RA_NOME + " REGISTRO : "+SRA->RA_MAT
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+2, 01 pSay "DOCUMENTOS NECESSARIOS P/ ADMISSAO : " 
   @ pRow()+2, 01 pSay "CURRICULUM / SOLICITACAO DE EMPREGO          (           )"
   @ pRow()+1, 01 pSay "CARTEIRA DE TRABALHO                         (           )"
   @ pRow()+1, 01 pSay "EXAME MEDICO OCUPACIONAL                     (           )"
   @ pRow()+1, 01 pSay "CEDULA DE IDENTIDADE                         (           )"
   @ pRow()+1, 01 pSay "DOCUMENTO MILITAR                            (           )"
   @ pRow()+1, 01 pSay "TITULO DE ELEITOR                            (           )"
   @ pRow()+1, 01 pSay "CARTEIRA DE HABILITACAO                      (           )"
   @ pRow()+1, 01 pSay "COMPROVANTE PIS / PASEP                      (           )"
   @ pRow()+1, 01 pSay "C.P.F.                                       (           )"
   @ pRow()+1, 01 pSay "DOC. DE INSCRICAO ORGAO E CLASSE             (           )"
   @ pRow()+1, 01 pSay "CERTIDAO DE NASCIMENTO                       (           )"
   @ pRow()+1, 01 pSay "CERTIDAO DE CASAMENTO                        (           )"
   @ pRow()+1, 01 pSay "CERTIDAO DE NASCIMENTO FILHOS MENORES 7 ANOS (           )"
   @ pRow()+1, 01 pSay "FOTOGRAFIA 3 X 4                             (           )"
   @ pRow()+1, 01 pSay "RECOLHIMENTO SINDICAL                        (           )"
   @ pRow()+1, 01 pSay "COMPROVANTE DE RESIDENCIA                    (           )"
   @ pRow()+1, 01 pSay "ANTECEDENTES CRIMINAIS                       (           )"
   @ pRow()+1, 01 pSay "COMPROVANTE DE ESCOLARIDADE 2o,3o GRAU       (           )"
   @ pRow()+1, 01 pSay "CURSOS COMPLEMENTARES                        (           )"
   @ pRow()+3, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "COMPROVANTE ENTREGA CARTEIRA DE TRABALHO E PREVIDENCIA SOCIAL PARA ANOTACOES"
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "NOME : "+SRA->RA_NOME + " REGISTRO : "+SRA->RA_MAT
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+1, 01 pSay "CTPS / SERIE : "+SRA->RA_NUMCP + " / " + SRA->RA_SERCP
   @ pRow()+1, 01 pSay Replicate("-",80)
   @ pRow()+2, 01 pSay "Recebemos a CTPS acima, para anotacoes necessarias que sera devolvida dentro"
   @ pRow()+1, 01 pSay "de 48 hs. de acordo com a Lei em vigor :" 
   @ pRow()+3, 01 pSay "Data : "+ Date()
   @ pRow()+3, 01 pSay "__________________________________           __________________________________"
   
   
   SRA->(DbSkip())
Enddo
RestScreen(3,0,24,79,cSavScr1)
If aReturn[5] == 1
	Set Printer To
	Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return
