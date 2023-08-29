SET RELATION TO CODIGO INTO CONCEPTO
GO TOP
macro = 0
M.toma = 0
DO WHILE .NOT. EOF()
	macro = concepto.formula
	m.toma = &macro
	replace descuento with m.toma
	SKIP
enddo
SET RELATION OFF INTO CONCEPTO
