SELECT CONCEPTO
SET FILTER TO CONCEPTO.TIPO = M.gato
GO TOP
SCATTER MEMVAR
SELECT LINE
SET FILTER TO LINE.TIPO = M.GATO
GO TOP
DO TOTALES.PRG

_curobj = OBJNUM(M.V)
m. v = TRANSFORM(Line.Codigo, "9999") + " " + TRANSFORM( Line.Unidades,"9999.99") + " " + ;
	 TRANSFORM(Line.Descripcio, "XXXXXXXXXXXXXXXXXXXX") + "  " + TRANSFORM( Line.Haberes,"9999.99") + ;
	 " " + TRANSFORM( Line.Descuento,"9999.99")
SCATTER MEMVAR
