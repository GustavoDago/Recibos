set filter to
set order to 1
IF empleado.jor_o_sue = .t.
	seek 1
	insert into line (codigo, descripcio, haberes,tipo) values ;
		(concepto.codigo, concepto.descripcio, Empleado.valor, Concepto.tipo)
ELSE
	seek 2
	insert into line (codigo, descripcio, haberes,tipo) values ;
		(concepto.codigo, concepto.descripcio, Empleado.valor, Concepto.tipo)
endif

IF Empleado.hijos > 0
	seek 680
	m.hab = 0
	for = concepto.formula
	M.hab = &for
	insert into line (codigo, descripcio, haberes,tipo) values ;
		(concepto.codigo, concepto.descripcio, m.hab , Concepto.tipo)
endif

IF Empleado.cuotasindi > 0
	seek 1002
	m.hab = 0
	for = concepto.formula
	M.hab = &for
	insert into line (codigo, descripcio, haberes,tipo) values ;
		(concepto.codigo, concepto.descripcio, m.hab , Concepto.tipo)
ENDIF

SCAN FOR comunatodo = .t.
	INSERT INTO LINE (codigo, descripcio, tipo) ;
		values (concepto.codigo, concepto.descripcio, concepto.tipo)
ENDSCAN

SELECT LINE
DO TOTALES.PRG
go top
SELECT CONCEPTO
set filter to tipo = 1
GO TOP
