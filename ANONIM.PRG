SET TALK OFF
DEFINE WINDOW iradi�logo FROM 9, 17 TO 19,61 ;
FLOAT NOCLOSE SHADOW DOUBLE COLOR SCHEME 5
PRIVATE archivo,�ltimobj,entrar,tab,may�stab,arriba,abajo,izquierda,derecha
***	Asignar valores a las teclas ***
entrar		= 13
tab		= 9
may�stab	= 15
arriba		= 5
abajo		= 24
derecha	= 4
izquierda	= 19
�ltimobj	= 1
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
ACTIVATE WINDOW iradi�logo
@ 0,1 TO 8,25
@ 1,3 GET radio PICTURE '@*RVN \<Primero;\<�ltimo;\<Registro;\<Saltar' ;
SIZE 1,10,1 DEFAULT 1 WHEN cuandorad() VALID validrad()
@ 5,15 GET n�mregist SIZE 1,8 DEFAULT 0 ;
FUNCTION 'Z' WHEN cuandoreg() VALID validreg() DISABLE
@ 7,15 GET n�msalto SIZE 1,8 DEFAULT 0 ;
FUNCTION 'Z' WHEN cuandosalto() DISABLE
@ 3,29 GET acepcancel PICTURE '@*VT \!\<Ir a;\?\<Cancelar' ;
SIZE 1,10,2 DEFAULT 0 WHEN acepcuando() VALID acepvalid ()
READ CYCLE
RELEASE WINDOW iradi�logo

*** Sit�a el cursor en el campo n�mregist si est� activado ***
*** y el �ltimo objeto seleccionado es el bot�n radio ***
*** del registro. Hace esto �nicamente si se presiona ***
*** ENTRAR, Tab, Abajo o Derecha para salir del bot�n ***
*** radio del registro. ***
FUNCTION cuandorad
IF _CUROBJ = OBJNUM(radio)+3 AND radio = OBJNUM(radio)+2 ;
	AND �ltimobj = OBJNUM(radio)+2 ;
	AND (LASTKEY() = entrar OR LASTKEY() = tab ;
	OR LASTKEY() = abajo OR LASTKEY() = derecha)
	_CUROBJ = OBJNUM(n�mregist)
	�ltimobj = OBJNUM(n�mregist)
	RETURN
ENDIF
*** Sit�a el cursor en el campo n�mregist si est� activado ***
*** y el �ltimo objeto seleccionado fue el bot�n radio ***
*** saltar. Hace esto �nicamente si presiona May�s+Tab, o ***
*** la flecha Arriba o Izquierda para salir del bot�n radio.***

IF _CUROBJ = OBJNUM(radio)+2 AND radio = OBJNUM(radio)+2 ;
	AND �ltimobj = OBJNUM(radio)+3 AND (LASTKEY() = may�stab ;
	OR LASTKEY() = izquierda OR LASTKEY() = arriba)
	�ltimobj = _CUROBJ
	_CUROBJ = OBJNUM(n�mregist)
	RETURN
ENDIF
�ltimobj = _CUROBJ
*** Activa o desactiva los campos get apropiados ***
*** cuando se selecciona un bot�n radio ***
FUNCTION validrad
DO CASE
	CASE radio = 1 o radio = 2
		STORE 0 TO n�mregist,n�msalto
		SHOW GET n�mregist DISABLED
		SHOW GET n�msalto DISABLED
	CASE radio = 3
		STORE 0 TO n�msalto
		SHOW GET n�mregist ENABLED
		SHOW GET n�msalto DISABLED
		_CUROBJ = OBJNUM(n�mregist)
	CASE radio = 4
		STORE 0 TO n�mregist
		SHOW GET n�mregist DISABLED
		SHOW GET n�msalto ENABLED
		_CUROBJ = OBJNUM(n�msalto)
ENDCASE

*** Rutina para desviar el n�mero de registro y moverse al bot�n de comando "Ir a". ***
*** Pone el cursor en el bot�n de comando "Ir a" si el �ltimo objeto ***
*** seleccionado fue el bot�n radio "Saltar". Hace esto �nicamente ***
*** si se presiona Tab, la flecha Abajo o Derecha para salir del bot�n ***
*** radio saltar. ***
FUNCTION cuandoreg
IF �ltimobj = OBJNUM(radio)+3 AND (LASTKEY() = tab OR LASTKEY() = abajo OR LASTKEY() = derecha)
	_CUROBJ = OBJNUM(acepcancel)
	RETURN
ENDIF
*** Rutina para derivar el campo n�mero de registro y moverlo al ***
*** bot�n "Saltar". Sit�a el cursor en el bot�n "Saltar" si el ***
*** �ltimo objeto seleccionado fue el bot�n "Ir a". Hace esto ***
*** �nicamente si se presiona May�s+Tab, la flecha Arriba ***
*** o Izquierda para salir del bot�n de comando "Ir a".***

IF �ltimobj = OBJNUM(acepcancel) AND (LASTKEY() = may�stab ;
	OR LASTKEY() = arriba OR LASTKEY() = izquierda)
	_CUROBJ = OBJNUM(radio)+3
	RETURN
ENDIF
�ltimobj = _CUROBJ
FUNCTION validreg
IF !MDOWN() AND (LASTKEY() = entrar OR LASTKEY() = tab ; 
	OR LASTKEY() = abajo OR LASTKEY() = derecha)
	_CUROBJ = OBJNUM(radio)+3
	RETURN
ENDIF
IF !MDOWN() AND (LASTKEY()= may�stab ; 
	OR LASTKEY() = arriba OR LASTKEY() = izquierda)
	_CUROBJ = OBJNUM(radio)+2
ENDIF
FUNCTION cuandosalto
�ltimobj = _CUROBJ
FUNCTION acepcuando
�ltimobj = _CUROBJ
*** Rutina para procesar la elecci�n de bot�n ***
FUNCTION acepvalid 
IF acepcancel = 1
	DO CASE
		CASE radio = 1
			GO TOP
		CASE radio = 2
			GO BOTTOM
		CASE radio = 3
			IF n�mregist > RECCOUNT()
				WAIT WINDOW 'Registro fuera del rango ' NOWAIT
			ELSE
				GO n�mregist
			ENDIF
		CASE radio = 4
			IF n�msalto+RECNO() > RECCOUNT() OR n�msalto + RECNO() < 0
				WAIT WINDOW 'Registro fuera de rango' NOWAIT
			ELSE
				SKIP n�msalto
			ENDIF
	ENDCASE
ENDIF