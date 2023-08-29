SET TALK OFF
DEFINE WINDOW iradiálogo FROM 9, 17 TO 19,61 ;
FLOAT NOCLOSE SHADOW DOUBLE COLOR SCHEME 5
PRIVATE archivo,últimobj,entrar,tab,mayústab,arriba,abajo,izquierda,derecha
***	Asignar valores a las teclas ***
entrar		= 13
tab		= 9
mayústab	= 15
arriba		= 5
abajo		= 24
derecha	= 4
izquierda	= 19
últimobj	= 1
***	Abrir una tabla ***
IF EMPTY(DBF())
	archivo = GETFILE('DBF','Seleccione una tabla')
	IF EMPTY(FILE)
		WAIT WINDOW 'Cancelado' NOWAIT
		RETURN
	ENDIF
	USE (archivo)
ENDIF
*** 	Dibujar los campos   ***
ACTIVATE WINDOW iradiálogo
@ 0,1 TO 8,25
@ 1,3 GET radio PICTURE '@*RVN \<Primero;\<Último;\<Registro;\<Saltar' ;
SIZE 1,10,1 DEFAULT 1 WHEN cuandorad() VALID validrad()
@ 5,15 GET númregist SIZE 1,8 DEFAULT 0 ;
FUNCTION 'Z' WHEN cuandoreg() VALID validreg() DISABLE
@ 7,15 GET númsalto SIZE 1,8 DEFAULT 0 ;
FUNCTION 'Z' WHEN cuandosalto() DISABLE
@ 3,29 GET acepcancel PICTURE '@*VT \!\<Ir a;\?\<Cancelar' ;
SIZE 1,10,2 DEFAULT 0 WHEN acepcuando() VALID acepvalid ()
READ CYCLE
RELEASE WINDOW iradiálogo

*** Sitúa el cursor en el campo númregist si está activado ***
*** y el último objeto seleccionado es el botón radio ***
*** del registro. Hace esto únicamente si se presiona ***
*** ENTRAR, Tab, Abajo o Derecha para salir del botón ***
*** radio del registro. ***
FUNCTION cuandorad
IF _CUROBJ = OBJNUM(radio)+3 AND radio = OBJNUM(radio)+2 ;
	AND últimobj = OBJNUM(radio)+2 ;
	AND (LASTKEY() = entrar OR LASTKEY() = tab ;
	OR LASTKEY() = abajo OR LASTKEY() = derecha)
	_CUROBJ = OBJNUM(númregist)
	últimobj = OBJNUM(númregist)
	RETURN
ENDIF
*** Sitúa el cursor en el campo númregist si está activado ***
*** y el último objeto seleccionado fue el botón radio ***
*** saltar. Hace esto únicamente si presiona Mayús+Tab, o ***
*** la flecha Arriba o Izquierda para salir del botón radio.***

IF _CUROBJ = OBJNUM(radio)+2 AND radio = OBJNUM(radio)+2 ;
	AND últimobj = OBJNUM(radio)+3 AND (LASTKEY() = mayústab ;
	OR LASTKEY() = izquierda OR LASTKEY() = arriba)
	últimobj = _CUROBJ
	_CUROBJ = OBJNUM(númregist)
	RETURN
ENDIF
últimobj = _CUROBJ
*** Activa o desactiva los campos get apropiados ***
*** cuando se selecciona un botón radio ***
FUNCTION validrad
DO CASE
	CASE radio = 1 o radio = 2
		STORE 0 TO númregist,númsalto
		SHOW GET númregist DISABLED
		SHOW GET númsalto DISABLED
	CASE radio = 3
		STORE 0 TO númsalto
		SHOW GET númregist ENABLED
		SHOW GET númsalto DISABLED
		_CUROBJ = OBJNUM(númregist)
	CASE radio = 4
		STORE 0 TO númregist
		SHOW GET númregist DISABLED
		SHOW GET númsalto ENABLED
		_CUROBJ = OBJNUM(númsalto)
ENDCASE

*** Rutina para desviar el número de registro y moverse al botón de comando "Ir a". ***
*** Pone el cursor en el botón de comando "Ir a" si el último objeto ***
*** seleccionado fue el botón radio "Saltar". Hace esto únicamente ***
*** si se presiona Tab, la flecha Abajo o Derecha para salir del botón ***
*** radio saltar. ***
FUNCTION cuandoreg
IF últimobj = OBJNUM(radio)+3 AND (LASTKEY() = tab OR LASTKEY() = abajo OR LASTKEY() = derecha)
	_CUROBJ = OBJNUM(acepcancel)
	RETURN
ENDIF
*** Rutina para derivar el campo número de registro y moverlo al ***
*** botón "Saltar". Sitúa el cursor en el botón "Saltar" si el ***
*** último objeto seleccionado fue el botón "Ir a". Hace esto ***
*** únicamente si se presiona Mayús+Tab, la flecha Arriba ***
*** o Izquierda para salir del botón de comando "Ir a".***

IF últimobj = OBJNUM(acepcancel) AND (LASTKEY() = mayústab ;
	OR LASTKEY() = arriba OR LASTKEY() = izquierda)
	_CUROBJ = OBJNUM(radio)+3
	RETURN
ENDIF
últimobj = _CUROBJ
FUNCTION validreg
IF !MDOWN() AND (LASTKEY() = entrar OR LASTKEY() = tab ; 
	OR LASTKEY() = abajo OR LASTKEY() = derecha)
	_CUROBJ = OBJNUM(radio)+3
	RETURN
ENDIF
IF !MDOWN() AND (LASTKEY()= mayústab ; 
	OR LASTKEY() = arriba OR LASTKEY() = izquierda)
	_CUROBJ = OBJNUM(radio)+2
ENDIF
FUNCTION cuandosalto
últimobj = _CUROBJ
FUNCTION acepcuando
últimobj = _CUROBJ
*** Rutina para procesar la elección de botón ***
FUNCTION acepvalid 
IF acepcancel = 1
	DO CASE
		CASE radio = 1
			GO TOP
		CASE radio = 2
			GO BOTTOM
		CASE radio = 3
			IF númregist > RECCOUNT()
				WAIT WINDOW 'Registro fuera del rango ' NOWAIT
			ELSE
				GO númregist
			ENDIF
		CASE radio = 4
			IF númsalto+RECNO() > RECCOUNT() OR númsalto + RECNO() < 0
				WAIT WINDOW 'Registro fuera de rango' NOWAIT
			ELSE
				SKIP númsalto
			ENDIF
	ENDCASE
ENDIF