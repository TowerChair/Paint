;Este programa solo contiene la interfaz de usuario del proyecto
title "EyPC 2020-1 - Proyecto final" ;directiva 'title' opcional
	ideal			;activa modo ideal del Turbo Assembler
	model small		;model small (segmentos de datos y codigo limitado hasta 64 KB cada uno)
	stack 256		;tamano de stack/pila, define el tamano del segmento de stack, se mide en bytes
	macro clear 	;macro para limpiar la pantalla
		mov ah,00h 	;ah = 00h, limpia la pantalla
		mov al,03h	;al = 03h. opcion de interrupcion
		int 10h		;llama interrupcion 10h
	endm 			;Fin de macro
	macro posicionaCursor renglon,columna 	;macro para posicionar el cursor de teclado en modo texto, recibe como parametros el renglon y la columna que deben ser datos de un byte
		mov dh,renglon	;dh = renglon
		mov dl,columna	;dl = columna
		mov ax,0200h 	;preparar ax para interrupcion, opcion 2
		int 10h 	;interrupcion que maneja entrada y salida de video
	endm 			;Fin de macro
	macro inicia 	;macro para el valor inicial del DS
		mov ax,@data 	;ax = @data
		mov ds,ax 		;ds = ax
	endm 			;Fin de macro
	macro inteclado	;para entradas del teclado 
		mov ah,10h 	;opcion 10
		int 16h		;interrupcion 16h (maneja la entrada del teclado)
		in al,60h 	;entrada desde teclado
	endm 			;Fin de macro
	macro revisamouse	;macro para verificar si existe el driver del mouse, al final el resultado estara en AX
		mov ax,0		;opcion 0
		int 33h			;llama interrupcion 33h para manejo del mouse, devuelve un valor en AX
						;Si AX = 0000h, no existe el driver. Si AX = FFFFh, existe driver
	endm 				;Fin de macro
	macro muestracursormouse	;macro para hacer el cursor del mouse visible
		mov ax,1		;opcion 1, muestra el cursor del mouse
		int 33h			;llama interrupcion 33h para manejo del mouse. Habilita la visibilidad del cursor del mouse en el programa
	endm 				;Fin de macro
	macro modovideo modo 	;macro para establecer el modo de video del programa, recibe como parametro modo que debe ser el valor del modo deseado
		mov al,modo 	;carga el valor de modo en AX
		mov ah,0 		;opcion AH = 00h
		int 10h 		;int 10h con opcion ah = 00h. Establece el modo de video
	endm 				;Fin de macro
	macro ocultacursorteclado ;macro para ocultar el cursor del teclado
		mov ah,01h 		;opcion ah = 01h
		mov cx,2607h 	;pone en CX el valor de 2607h necesario para ocultar el teclado
		int 10h 		;int 10h, oculta el mouse del teclado
	endm 			;Fin de macro
	macro imprimeselector renglon,columna 	;macro para imprimir el caracter utilizado como selector, recibe el renglon y la columna en donde se va a a imprimir el caracter
		posicionaCursor renglon, columna 	;pone el cursor en la posicion deseada
		mov bl,0Fh 			;Atributo de color. Blanco
		mov ah,09h 			;Opcion ah = 09h para imprimir un caracter
		mov al,31 			;al = 31h es el caracter ▼ que sirve de selector
		mov cx,1 			;el caracter se imprimira CX veces
		int 10h 			;int 10, con opcion AH = 09h. Imprime caracter CX veces
	endm 			;Fin de macro
	dataseg
nomouse		db 	'No se encuentra driver de mouse. [Enter] para salir$'
;Los siguientes comentarios sirven de ayuda visual en codigo fuente
;numero de columna, se pondra el numero de columna de la UI
;				001		002		003		004		005		006		007		008		009		010		011		012		013		014		015		016		017		018		019		020		021		022		023		024		025		026		027		028		029		030		031		032		033		034		035		036		037		038		039		040		041		042		043		044		045		046		047		048		049		050		051		052		053		054		055		056		057		058		059		060		061		062		063		064		065		066		067		068		069		070		071		072		073		074		075		076		077		078		079		080
renglon1	db	201,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	'P',	'E',	'I',	'N',	'T',	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	203,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	187
renglon2	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	'C',	'O',	'L',	'O',	'R',	'E',	'S',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon3	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon4	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	0Eh,	0Eh,	0Eh,	' ',	0Ah,	0Ah,	0Ah,	' ',	0Ch,	0Ch,	0Ch,	' ',	09h,	09h,	09h,	' ',	' ',	186
renglon5	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	0Eh,	0Eh,	0Eh,	' ',	0Ah,	0Ah,	0Ah,	' ',	0Ch,	0Ch,	0Ch,	' ',	09h,	09h,	09h,	' ',	' ',	186
renglon6	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon7	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon8	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	'F',	'O',	'R',	'M',	'A',	'S',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon9	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon10	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon11	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	219,	' ',	' ',	219,	' ',	219,	' ',	219,	219,	219,	' ',	' ',	186
renglon12	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	219,	' ',	' ',	219,	219,	219,	' ',	' ',	219,	' ',	' ',	219,	219,	219,	' ',	' ',	186
renglon13	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	219,	' ',	' ',	219,	' ',	219,	' ',	219,	219,	219,	' ',	' ',	186
renglon14	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon15	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon16	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	218,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	191,	186
renglon17	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	179,	' ',	' ',	' ',	' ',	' ',	'B',	'O',	'R',	'R',	'A',	'R',	' ',	' ',	' ',	' ',	' ',	179,	186
renglon18	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	192,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	196,	217,	186
renglon19	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	204,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	185
renglon20	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon21	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	218,	196,	196,	196,	196,	196,	196,	196,	196,	191,	' ',	' ',	' ',	' ',	186
renglon22	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	179,	' ',	'C',	'E',	'R',	'R',	'A',	'R',	' ',	179,	' ',	' ',	' ',	' ',	186
renglon23	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	192,	196,	196,	196,	196,	196,	196,	196,	196,	217,	' ',	' ',	' ',	' ',	186
renglon24	db	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186,	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	' ',	186
renglon25	db	200,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	202,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	205,	188
color		db 	0Eh 	;variable color que almacena el atributo actual de color para interrupcion 10h
; 00h: Negro
; 01h: Azul
; 02h: Verde
; 03h: Cyan
; 04h: Rojo
; 05h: Magenta
; 06h: Cafe
; 07h: Gris Claro
; 08h: Gris Oscuro
; 09h: Azul Claro
; 0Ah: Verde Claro
; 0Bh: Cyan Claro
; 0Ch: Rojo Claro
; 0Dh: Magenta Claro
; 0Eh: Amarillo
; 0Fh: Blanco
forma 		db 	1	;variable para almacenar la forma de la herramienta de dibujo en el lienzo
; 1: punto
; 2: cruz +
; 3: cruz x
; 4: cuadro (3x3)
selectorcolor	db 	63	;variable selectorcolor que guarda el valor de la columna donde se encuentra el selector de color
; 63: en amarillo
; 67: en verde
; 71: en rojo 
; 75: en azul
selectorforma	db 	63	;variable selectorforma que guarda el valor de la columna donde se encuentra el selector de forma
; 63: en punto
; 67: en cruz +
; 71: en cruz x
; 75: en cuadro (3x3)
numaux8		db 	8 	;variable numaux8 que almacena el valor 8 para hacer el calculo de las coordenadas del cursor del mouse en resolucion 80x25 
	codeseg
inicio:
	inicia			;"inicializando" el registro DS
	clear			;limpiar pantalla
	revisamouse		;macro para revisar driver de mouse
	xor ax,0FFFFh	;compara el valor de AX con FFFFh, si el resultado es cero, entonces existe el driver de mouse
	jz imprimeui	;Si existe el driver del mouse, entonces salta a 'imprimeui'
	;Si no existe el driver del mouse entonces se ejecutan las siguientes instrucciones
	lea dx,[nomouse] 	;lee la direccion en donde comienza la cadena 'nomouse'
	mov ax,0900h	;opcion 9 para interrupcion 21h
	int 21h			;interrupcion 21h. Imprime cadena.
	jmp teclado		;salta a 'teclado'
imprimeui:
	ocultacursorteclado 	;para ocultar el cursor del teclado
	muestracursormouse		;para mostrar el cursor del mouse
	call UI 				;procedimiento que imprime en la pantalla la interfaz de usuario del programa
mouse:
	mov ax,3		;opcion ax = 3 para interrupcion 33h. 
	int 33h			;int 33h. para obtener la posicion del mouse y el status de sus botones
	and bx,0001h 	;mascara para obtener únicamente el status del boton izquierdo 
	jz mouse 		;Si el boton izquierdo esta en 0 (suelto), vuelve a leer la posicion del mouse
	mov ax,dx 		;copia el valor del renglon en AX
	div [numaux8] 	;division entre 8 para obtener el valor del renglon en resolucion 80x25
	mov dx,ax 		;devuelve el valor a DX
	xor dh,dh 		;pone en ceros la parte alta de DX ya que el valor de renglon cabe en DL
	mov ax,cx 		;copia el valor de la columna en AX
	div [numaux8] 	;division entre 8 para obtener el valor de la columna en resolucion 80x25
	mov cx,ax 		;devuelve el valor a CX
	xor ch,ch 		;pone en ceros la parte alta de CX ya que el valor de la columna cabe en CL
	cmp cx,60 		;compara el valor de la columna con 60d, ya que 60 es el numero de la columna en donde se separa el lienzo de los controles del programa
	jge botoncerrar0 	;Si es mayor, entonces el cursor del mouse se encuentra en los controles del programa y salta
	mov ax,3		;opcion ax = 3 para interrupcion 33h. 
	int 33h			;int 33h. para obtener la posicion del mouse y el status de sus botones
	and bx,0001h ;salto incondicional a etiqueta 'imprime'
	cmp bx,1 			;compara si el valor del registro BX es 1, eso implicaria que el boton izquierdo del mouse esta presionado
	je lienzo 
lienzo:
	mov ax,3		;opcion ax = 3 para interrupcion 33h. 
	int 33h	
	mov ax,dx 		;copia el valor del renglon en AX
	div [numaux8] 	;division entre 8 para obtener el valor del renglon en resolucion 80x25
	mov dx,ax 		;devuelve el valor a DX
	xor dh,dh 		;pone en ceros la parte alta de DX ya que el valor de renglon cabe en DL
	mov ax,cx 		;copia el valor de la columna en AX
	div [numaux8] 	;division entre 8 para obtener el valor de la columna en resolucion 80x25
	mov cx,ax 		;devuelve el valor a CX
	xor ch,ch 		;pone en ceros la parte alta de CX ya que el valor de l
	posicionaCursor dl,cl	
	mov al,219 		;pone el caracter de cuadro █ en AL para imprimirlo
	mov bl,0Eh 
	;posicionaCursor ax,10	;macro para posicionar cursor del teclado en renglon = 1 y columna = 0
	mov ah,09h		;opcion 9 para interrupcion 10h
	mov cx,1		;cx = 1, se imprimiran cx caracteres
	int 10h			;interrupcion 10h. Imprime el caracter contenido en AL, CX veces.

	jmp mouse

botoncerrar0:
	cmp dx,20 		;compara si el renglon del cursor es 20d, en donde se encuentra el borde superior del boton CERRAR
	jge botoncerrar1 	;si el renglon es mayor o igual a 19d, entonces es posible que se haya presionado el boton CERRAR, pero hay que revisar los demas limites
	jmp mouse 		;salta a mouse para volver a leer la posicion del mouse
botoncerrar1:
	cmp cx,65 		;compara si la columna del cursor es 65d, en donde se encuentra el borde izquierdo del boton CERRAR
	jge botoncerrar2 	;si la columna es mayor o igual a 65d, entonces es posible que se haya presionado el boton CERRAR, pero hay que revisar los demas limites
	jmp mouse 		;salta a mouse para volver a leer la posicion del mouse, ya que no se presiono el boton cerrar
botoncerrar2:
	cmp dx,22		;compara si el renglon del cursor es 22d, en donde se encuentra el borde inferior del boton CERRAR
	jle botoncerrar3 	;Si el renglon es menor o igual a 22d, entonces es posible que se haya presionado el boton CERRAR, pero hay que revisar los demas limites
	jmp mouse 		;salta a mouse para volver a leer la posicion del mouse, ya que no se presiono el boton cerrar
botoncerrar3:
	cmp cx,74 		;compara si la columna del cursor es 74d, en donde se encuentra el borde derecho del boton CERRAR
	jle salir 		;si la columna es menor o igual a 74d, entonces terminamos de revisar todos los limites del boton CERRAR y nos indica que terminamos la ejecucion del programa
	jmp mouse 		;salta a mouse para volver a leer la posicion del mouse, ya que no se presiono el boton cerrar
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;;SI NO SE HIZO CLIC SOBRE EL BOTON CERRAR ENTONCES HAY QUE REVISAR LOS DEMAS CONTROLES;;;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
teclado:
	inteclado
	cmp al,01Ch		;compara la entrada de teclado si fue [enter]
	jnz teclado 	;Si la tecla no fue [enter], vuelve a leer entrada de teclado
salir:
	clear			;limpiar pantalla
	mov ax,04C00h	;opcion 4c y exit code 0. Para terminar el programa
	int 21h			;sale del programa
;procedimiento UI
;no requiere parametros de entrada
;Dibuja la interfaz de usuario del programa 
proc UI
	mov bp,sp		;copia el valor del registro sp en bp para mantener la referencia de la cima de pila
	mov di,0		;di = 0000h, registro indice a 0
	mov dh,0		;dh = 00h, para poner cursor en renglon 0
	mov dl,0		;dl = 00h, para poner cursor en columna 0
	mov cx,25		;cx = 25d = 19h. Prepara registro CX para loop. Recorre 25 renglones para imprimir la interfaz de usuario de programa
renglon:
	push cx 		;almacena primer valor de CX  
	mov cx,50h		;cx = 80d = 50h. Preparando CX para loop. Recorre 80 columnas para imprimir la interfaz
columna:
	push cx 		;almacena temporalmente el valor de CX en la pila
	mov ax,0200h	;prepara opcion 2 para posicionar cursor
	mov bh,0		;prepara bx, pagina 0
	int 10h			;Interrupcion 10h, opcion AH=02h. Coloca el cursor en (dh,dl)
	mov al,[renglon1+di]	;al = [renglon1+di]. Obtiene el caracter a imprimir de memoria de datos, se desplaza di bytes empezando en la localidad de renglon1
	cmp al,09h 		;Revisa si el caracter obtenido pertenece a la paleta azul de colores de la interfaz
	je azul  		;Si el caracter es 09h, entonces imprime en la paleta azul
	cmp al,0Ch 		;Revisa si el caracter obtenido pertenece a la paleta roja de colores de la interfaz
	je rojo 		;Si el caracter es 0Ch, entonces imprime en la paleta roja
	cmp al,0Eh		;Revisa si el caracter obtenido pertenece a la paleta amarilla de colores de la interfaz
	je amarillo 	;Si el caracter es 0Eh, entonces imprime en la paleta roja
	cmp al,0Ah		;Revisa si el caracter obtenido pertenece a la paleta verde de colores de la interfaz
	je verde 		;Si el caracter es 0Ah, entonces imprime en la paleta verde
	mov bl,0Fh 		;Si el caracter no es ninguno de los anteriores, entonces el caracter que se imprime es el que se encuentra en memoria de datos y se pone en blanco 0Fh por default 
					;los caracteres pueden ser los siguientes: ╔, ╚, ═, ║, ╦, ╠, ╩, ╣, ╗, ╝, caracteres alfabeticos, ▼, █, ┐, └, ┘, ┌, │, ─
	jmp imprimircaracter 	;salta a imprimir el caracter
azul:
	mov al,219 		;pone el caracter de cuadro █ en AL para imprimirlo
	mov bl,09h		;bl = 09h, atributo de color del caracter a imprimir. Azul
	jmp imprimircaracter 	;salta a imprimir el caracter
rojo:
	mov al,219 		;pone el caracter de cuadro █ en AL para imprimirlo
	mov bl,0Ch 		;bl = 0Ch, atributo de color del caracter a imprimir. Rojo
	jmp imprimircaracter 	;salta a imprimir el caracter
amarillo:
	mov al,219 		;pone el caracter de cuadro █ en AL para imprimirlo
	mov bl,0Eh 		;bl = 0Eh, atributo de color del caracter a imprimir. Amarillo
	jmp imprimircaracter 	;salta a imprimir el caracter
verde:
	mov al,219 		;pone el caracter de cuadro █ en AL para imprimirlo
	mov bl,0Ah 		;bl = 0Ah, atributo de color del caracter a imprimir. Verde
imprimircaracter:
	mov ah,09h		;opcion 9 para interrupcion 10h
	mov cx,1		;cx = 1, se imprimiran cx caracteres
	int 10h			;interrupcion 10h. Imprime el caracter contenido en AL, CX veces.
	inc di 			;di = di + 1, apunta al siguiente caracter en memoria
	inc dl 			;dl = dl + 1, recorre a la siguiente columna
	pop cx 			;saca el valor de CX almacenado temporalmente en la pila
	loop columna	;salto a 'columna' si CX es diferente de 0
	mov dl,0		;para regresar a la columna 0
	inc dh			;se recorre un renglon
	pop cx 			;recupera valor de registro CX almacenado anteriormente
	loop renglon 	;salta a renglon si CX diferente de 0
	imprimeselector 2,[selectorcolor]	;para imprimir el caracter que representa el selector de color, se mueve a traves del renglon 2
	imprimeselector 9,[selectorforma]	;para imprimir el caracter que representa el selector de forma, se mueve a traves del renglon 9
	ret 			;Regreso de llamada a procedimiento
endp	 			;Indica fin de procedimiento UI para el ensamblador
	end inicio 		;Fin del programa