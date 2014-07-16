/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQMT001  �Autor  �Marcos R. Roquitski � Data �  05/04/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Impressao do Termo de concessao de Instrumentos de medicao. ��
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhqmt001()

SetPrvt("CCADASTRO,AROTINA,")

cCadastro := 'Impressao do Termo de Concessao'
aRotina := {{ "Pesquisa","AxPesqui"       ,0 , 1},;
            { "Visual"  ,"AxVisual"       ,0 , 2},;
            { "Imprime" ,"U_Nhqmt002"     ,0 , 3}}

mBrowse(,,,,"QML",,"QML->QML_FLAGB=='B'",25)

Return(NIL)
