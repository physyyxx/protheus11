/*
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � Mt241EXT        � Alexandre R. Bento    � Data �17.07.2013���
������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada para validar a exclus�o com base nos dias���
���            liberados no parametro MV_DIASMO p/ Internos Modelo 2	 ���
������������������������������������������������������������������������Ĵ��
���Uso       � Estoque / Custos                                          ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������
*/

#include "rwmake.ch"        

User Function MT241EXT
Local _nDias  :=  GETMV("MV_DIASMO")
Local _lRet   := .T.

If Da241data < (Date()- _nDias) .OR. Da241data < (dDatabase - _nDias)  //Controle de data para n�o permitir mov. com data retroativa controle paramatro mv_diasmo = numero de dias
   MsgBox( "Impossivel Fazer a Movimenta��o Data Menor que a Permitida Depto Custo! - P.E. - MT241EXT", "Mov. Internas 2", "STOP" )
   _lRet   := .F.
Endif

Return (_lRet)