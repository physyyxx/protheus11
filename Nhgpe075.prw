/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHGPE075  �Autor  �Marcos R Roquitski  � Data �  08/02/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de verbas de terceiros.                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"
#include "protheus.ch"

User Function Nhgpe075()
                                                                                 	
SetPrvt("aRotina,cCadastro,")


aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
             {"Visualizar","AxVisual",0,2} ,;
             {"Incluir","AxInclui",0,3} ,;
             {"Alterar","AxAltera",0,3},;
             {"Incluir","AxInclui",0,4} }

cCadastro := "Cadastro de verbas de terceiros"

mBrowse(,,,,"ZRV",)

Return