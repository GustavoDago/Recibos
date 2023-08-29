SET RELATION TO Line.codigo INTO Concepto
M.coincide = 0
SCAN
	scatter memvar
	M.O = CONCEPTO.FORMULA
	m.descuento = &O
	gather memvar
endscan
set relation to
sum descuento to m.totdescuen
go top