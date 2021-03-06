/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  MT116TOK � Autor �  Alexandre R. Bento  � Data � 22/07/10 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � VALIDACAO ADICIONAL PARA Fornecedor no Frete               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Fiscal                                                     ���
���          �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/*
aParametros[1]   Define a Rotina : 2-Inclusao / 1-Exclusao
aParametros[2]   Considerar Notas : 1 - Compra , 2 � Devolucao
aParametros[3]   Data Inicial para Filtro das NFs Originais
aParametros[4]   Data Final para Filtro das NFs originais
aParametros[5]   Cod. Fornecedor para Filtro das NFs Originais
aParametros[6]   Loja Fornecedor para Fltro das NFs Originais
aParametros[7]   Utiliza Formulario proprio ? 1-Sim,2-Nao
aParametros[8]   Num. da NF de Conhecimento de Frete
aParametros[9]   Serie da NF de COnhecimento de Frete
aParametros[10] Codigo do Fornecedor da NF de FRETE
aParametros[11] Loja do Fornecedor da NF de Frete                                                         ADMIN	
aParametros[12] TES utilizada na Classificacao da NF
aParametros[13] Valor total do Frete sem Impostos
aParametros[14] Estado de Origem do Frete
aParametros[15] Aglutina Produtos : .T. , .F.
aParametros[16] Base do Icms Retido
aParametros[17] Valor do Icms Retido
aParametros[18] Filtra notas com conhecimento frete .F. = N�o , .T. = Sim
*/
     
#include "rwmake.ch"              

User Function MT116TOK()      

Local _nCFis  := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CLASFIS"})
Local _nCF    := aScan(aHeader,{|x|UPPER(Alltrim(x[2])) == "D1_CF"})
Local _lRet   := .T.    

//Valida se os fornecedores digitados na tela inicial do conhecimento de frete s�o iguais
If Alltrim(CESPECIE)$"CTR" .And. aParametros[5] == aParametros[10] 
   MsgBox("Fornecedor Incompativel, Verificar !!!","Atencao","ALERT")
   _lRet   := .F.	          
Endif   

   // Criar o seguinte bloqueio nas entradas: Sempre que o campo F1_C103FORM for N�O e o campo F1_CESPECIE for SPED, 
    //o campo F1_CHVNFE de ser diferente de vazio. Esta regra deve ser implantada a partir do dia 19/03/2012

if Alltrim(CESPECIE)$"CTE" .And. Empty(aNfeDanfe[13])
  MsgBox(" Inclua a Chave de Acesso da NF-e","Atencao","ALERT")   
  _lRet   := .F.	          	  
Endif

For _i := 1 to Len(Acols)

//   Atender a O.S. 050479
   If Subs(Alltrim(ACOLS[_i][_nCFis]),1,1) <> '0' .And. Alltrim(ACOLS[_i][_nCF])$"1352/2352"
      ACOLS[_i][_nCFis] := "000"
   Endif

Next _i
   
Return(_lRet)
