/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ��
���Programa  � MT103VPC        � Alexandre R. Bento    � Data �03.08.2007���
������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de Entrada p/validar Se ja foi aprovada a A.Entrega ���
���          � na busca do pedido via F5/F6 na entrada da N.F.           ���
������������������������������������������������������������������������Ĵ��
���Sintaxe   � Chamada padr�o para programas em RDMake.                  ���
�������������������������������������������������������������������������ٱ�
����������������������������������������������������������������������������
����������������������������������������������������������������������������*/

#Include "rwmake.ch"    

User Function  MT103VPC()

SZU->(DbSetOrder(4)) //--ZU_FILIAL+ZU_NUMPED+ZU_ITEMPED+ZU_NIVEL
If SZU->(DbSeek(xFilial("SZU")+SC7->C7_NUM+SC7->C7_ITEM)) // Verifica se j� existe aprovacao para autorizacao de entrega
   While SZU->(!Eof()) .And. SZU->ZU_NUMPED+SZU->ZU_ITEMPED == SC7->C7_NUM+SC7->C7_ITEM
      
      IF SZU->ZU_ORIGEM$"SC7/C77/C78" .AND. !SZU->ZU_STATUS$"A" //autorizacao de entrega sem aprova��o
         Return .F.
   	  ENDIF
   	  
      SZU->(DbSkip())
   Enddo   
Endif

Return .T.