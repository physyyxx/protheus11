/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NHQNC004  �Autor  �Marcos R Roquitski  � Data �  14/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera codigo por planta.                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � WHB                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"

User Function Nhqnc005()

SetPrvt("_nQnc,_cQnc,_nRecz")

_nQnc := 0
_aQnc := Space(06)

_nRecz := QI2->(Recno())
QI2->(DbsetOrder(9)) // QI2_FILIAL+QI2_PLANTA                                                                                                                                           
QI2->(DbSeek(xFilial("QI2")+M->QI2_PLANTA))
While !QI2->(Eof()) .AND. QI2->QI2_PLANTA == M->QI2_PLANTA
	_aQnc := Substr(QI2->QI2_FNC,3,4)
	QI2->(Dbskip())
Enddo
_nQnc := Val(_aQnc) + 1
_aQnc := M->QI2_PLANTA+StrZero(_nQnc,4) + Substr(Dtos(Date()),1,4)

QI2->(Dbsetorder(1))
If QI2->(DbSeek(xFilial("QI2")+_aQnc))
	Alert("Ja existe FNC com este codigo")
else
	M->QI2_FNC := _aQnc 
Endif
QI2->(DbGoto(_nRecz))
Return(.t.)
