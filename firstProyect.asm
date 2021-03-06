%macro escribe 2
mov eax, 4
mov ebx, 1
mov ecx, %1
mov edx, %2
int 0x80
%endmacro

%macro leeTxt 3
	mov eax, 3
	mov ebx, %1
	mov ecx, %2
	mov edx, %3
	int 0x80
%endmacro

%macro escribeTxt 3
	mov eax, 4
	mov ebx, %1
	mov ecx, %2
	mov edx, %3
	int 0x80
%endmacro
%macro abrirArchivo 2
	mov eax, %1
	mov ebx, %2
	mov edx,7777h
	int 0x80
%endmacro
%macro cerrarArchivo 1
	mov eax, 6
	mov ebx, %1
	mov ecx, 0
	mov edx, 0
	int 0x80
%endmacro
%macro actualizarpuntero 3
	mov eax,19
	mov ebx,[%1]
	mov ecx,%2
	mov edx,%3
	int 0x80
%endmacro
%macro elKevin 3

	mov eax,[%1]
	cmp eax,0
	jbe %%kerPositivo
		;escribe msg2,len2
		mov eax,[%1]
		mov ebx,-1
		imul ebx
		mov ebx,[%2]
		sub ebx,'000'
		mul ebx
		mov ecx,[%3]
		sub ecx,eax
		mov [%3],ecx
		add eax,'000'
		jmp %%fin
	%%kerPositivo:
		mov eax,[%1]
		mov ebx,[%2]
		sub ebx,'000'
		mul ebx
		mov ecx,[%3]
		add ecx,eax
		mov [%3],ecx
		add eax,'000'
		;mov [result],eax
		;escribe result,3

	%%fin:
	escribe %3, 3
	escribe %3, 3

%endmacro
%macro abrirEscritor 2
	mov eax, %1
	mov ebx, %2
	mov edx,7777h
	int 0x80
%endmacro

section .data 
	;*************************************************mensajes*********************************************
	msg	db "Hola, Mundo!!!",0x0A
	len equ $ - msg 
	msg2	db ",",0x0A
	len2 equ $ - msg2 
	aster db "*",0x0A
	lenAster equ $ - aster
	msgColumna0 db "Estoy en la columna 0",0x0A
	lenMsgColumna0 equ $ - msgColumna0
	msgColumnaFinal db "Estoy en la columna final",0x0A
	lenMsgColumnaFinal equ $ - msgColumnaFinal
	msgColumnaIntermedia db "Estoy en la columna intermedia",0x0A
	lenMsgColumnaIntermedia equ $ - msgColumnaIntermedia	

	msgFila0 db "Estoy en la fila 0",0x0A
	lenMsgFila0 equ $ - msgFila0
	msgFilaFinal db "Estoy en la fila final",0x0A
	lenMsgFilaFinal equ $ - msgFilaFinal
	msgFilaIntermedia db "Estoy en la fila intermedia",0x0A
	lenMsgFilaIntermedia equ $ - msgFilaIntermedia



	;*****************************************nombre de archivos******************************************
	archivo db "/home/richard/ensamblador/archivo.txt",0
	archivo2 db "/home/richard/ensamblador/archivo2.txt",0
	archivoLectura db "/home/richard/ensamblador/salidaImagen.txt",0


section .bss
	write resb 3
	sumatoria resb 8
	temp resb 8
	temp2 resb 8 
	prueba resb 8
	posI   resb 8
	posJ   resb 8
	readpointer resb 4
	;variables de lectura del archivo
	ant0 resb 3 
	ant1 resb 3
	ant2 resb 3
	datoleft resb 3
	dato	resb 3
	datoRight resb 3
	sig0 resb 3
	sig1 resb 3
	sig2 resb 3
	;variables para el sharpening
	mat00 resb 3
	mat01 resb 3
	mat02 resb 3
	mat10 resb 3
	mat11 resb 3
	mat12 resb 3
	mat20 resb 3
	mat21 resb 3
	mat22 resb 3
	mat23 resb 3		;nota si borro esta reserva de memoria se encicla Razon: ni idea 
	;variables para el uso de los loop_fila
	width resb 6
	height resb 6
	texto resb 3
	
	idarchivo resd 4
	idarchivo2 resd 4
	idpointer resd 4
	;idpointerNext resd 4
	;idpointerPrev resd 4

section .text
	global _start       
_start:		    

		;*********************************en esta seccion cargamos los archivos que vamos a leer o escribir*********************
		abrirEscritor 8,archivo2    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		test eax, eax
		jz salir
		mov dword[idarchivo2], eax

		abrirArchivo 8,archivo    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		test eax, eax
		jz salir
		mov dword[idarchivo], eax

		abrirArchivo 5,archivoLectura    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		test eax, eax
		jz salir
		mov dword[idpointer], eax

		;abrirArchivo 5,archivoLectura    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		;test eax, eax
		;jz salir
		;mov dword[idpointerNext], eax

		;abrirArchivo 5,archivoLectura    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		;test eax, eax
		;jz salir
		;mov dword[idpointerPrev], eax




		mov eax,'0'
		mov [sig0],eax
		mov eax,'0'
		mov [sig1],eax
		mov eax,'0'
		mov [sig2],eax



		

		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		;
		;						cargamos el kernel sharpen
		;
		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		mov eax,-1
		mov [mat00],eax
		
		mov eax,-2
		mov [mat01],eax

		mov eax,-1,
		mov [mat02],eax

		mov eax,0
		mov [mat10],eax

		mov eax,0
		mov [mat11],eax

		mov eax,0
		mov [mat12],eax

		mov eax,1
		mov [mat20],eax

		mov eax,2
		mov [mat21],eax

		mov eax,1
		mov [mat22],eax

	   ;saludamos al mundo
	   escribe msg,len
	   
		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		;
		;						
		;
		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		;mov ecx,[width]
		;ciclollenadoBuffer
		
	   	mov eax,20
	   	mov [readpointer],eax
	   	actualizarpuntero idpointer,[readpointer], 0
	   	leeTxt [idpointer],texto,3
	   	escribe texto,3





	   	escribe msg,len
	   	escribe msg,len
	   	escribe [sig1],3
	   	escribe msg,len
	   	escribe msg,len
	    

	   ;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		;
		;						agregar lecturas de pantalla teclado en esta seccion
		;
		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		mov eax, 8
		mov [width],eax
		mov eax,6
		mov [height],eax

		; inciiamos el ciclo
	   mov eax, 0
	   mov ebx, 10
	   mov ecx, [height]

	   loop_fila:
	   		;comienzo del ciclo for 
	   		mov [temp],ecx
	   		mov eax,[height]
	   		sub eax,ecx
		    ;add eax,'0'
		    mov [posI],eax
		    ;escribe posI,8
		   	

		    mov ecx, [width]
		    loop_columna:
		    	mov [temp2],ecx
		    	mov eax,[width]
		    	sub eax,ecx
		    	mov [posJ],eax
		    	;escribe posJ,4
		    	;*********************************************codigo ejecutable en el loop****************************
		    	;escribe aster,lenAster
		    	;escribeTxt [idarchivo],aster,lenAster
		    	
		    	;*********************************************condiciones para el calculo ****************************
		    	mov eax,'000'
		    	mov [sumatoria],eax

		    	escribe msg2,len2
		    	escribe msg2,len2
		    	escribe msg2,len2

		    	mov eax,[temp2]
		    	add eax,'0'
		    	mov [prueba],eax
		   		escribe prueba,8

		   		mov eax,[temp]
		    	add eax,'0'
		    	mov [prueba],eax
		   		escribe prueba,8

		   		escribe msg2,len2
		   		escribe msg2,len2
		   		escribe msg2,len2

		   		;**********************************   CONDICIONALES COLUMNA0   **********************
		   		mov eax,[posI]
		    	cmp eax,0
		    	jnz NoFil0 
		    		;nos ubicamos en la fila 0
		    		
		    		escribe msgFila0,lenMsgFila0
		    		mov eax,[posJ]
		    		cmp eax,0
		    		jnz fil0Nocol0
		    			escribe msgColumna0, lenMsgColumna0
		    			;*****************************codigo************************* 
		    			
	   					;********************leemos el primer dato********************
	   					mov eax, 0
	   					mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat11,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos dato de la derecha**************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat12,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos dato de abajo ******************
	   					mov eax, [width]
	   					mov ebx,3
	   					mul ebx
	   					mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat21,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos dato abajo derecha**************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat22,dato,sumatoria
	   					escribe msg2,len2
	   					;*************************terminamos primer etapa*************
		    			jmp finCompares
		    		fil0Nocol0:
		    			mov eax,[temp2]
		    			cmp eax,1
		    			jnz fil0ColInter
		    				escribe msgColumnaFinal,lenMsgColumnaFinal
		    				;escribe msgFilaFinal, lenMsgFilaFinal
		    				;***************************codigo************************
		    				
		    				;*****************leemos dato izquierdo*********************
		    				mov eax,[width]
		    				mov ebx,2
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat10,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos dato***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat11,dato,sumatoria
	   						escribe msg2,len2
	   						;***************leemos dato abajo izquierdo******************
	   						mov eax,[width]
	   						mov ebx,[width]
	   						add eax,ebx
	   						mov ebx,2
	   						sub eax,ebx
	   						mov ebx,3
	   						mul ebx
	   						mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat20,dato,sumatoria
	   						escribe msg2,len2
	   						;*********************leemos dato abajo*********************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat21,dato,sumatoria
	   						escribe msg2,len2
	   						;*****************fin fila0 columna final********************

		    				jmp finCompares
		    			fil0ColInter:
		    				escribe msgColumnaIntermedia,lenMsgColumnaIntermedia
		    				;escribe msgFilaIntermedia,lenMsgFilaIntermedia
		    				;***************************codigo***************************
		    				mov eax,[posJ]
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		    				escribe readpointer,4
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat10,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos dato***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat11,dato,sumatoria
	   						escribe msg2,len2
		    				;**********************leemos derecho************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat11,dato,sumatoria
	   						escribe msg2,len2
	   						;***************leemos el dato abajo izquierdo***************
	   						mov eax,[posJ]
	   						mov ebx,[width]
	   						add eax,ebx
	   						mov ebx,1
	   						sub eax,ebx
	   						mov ebx,3
	   						mul ebx
	   						mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat20,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos abajo***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat21,dato,sumatoria
	   						escribe msg2,len2
		    				;**********************leemos derecho************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat22,dato,sumatoria
	   						escribe msg2,len2

		    				jmp finCompares
		    	NoFil0:
		    	;*********************************   FIN CONDICIONALES COLUMNA0   *******************

				mov eax,[temp]
				cmp eax,1
				jnz noFilFin
					escribe msgFilaFinal,lenMsgFilaFinal
					;escribe msgColumnaFinal, lenMsgColumnaFinal
					mov eax,[posJ]
					cmp eax,0
					jnz noFilFinCol0
						escribe msgColumna0,lenMsgColumna0
						;escribe msgFila0,lenMsgFila0
		    			;*****************************codigo************************* 

		    			;*********************obtenemos arriba*********************** 
		    			mov eax,[posI]
		    			mov ebx,1
		    			sub eax,ebx
		    			mov ebx,[width]
		    			mul ebx
		    			mov ebx,3
		    			mul ebx
		    			mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat01,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos arriba derecha***************************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat02,dato,sumatoria
	   					escribe msg2,len2
	   					;****************************leemos dato*******************************
	   					mov eax,[posI]
	   					mov ebx,[width]
	   					mul ebx
	   					mov ebx,3
	   					mul ebx
	   					mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat11,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos   dato  derecha***************************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat12,dato,sumatoria
	   					escribe msg2,len2
	   					;***********************************************************************

		    			jmp finCompares
					noFilFinCol0:
						mov eax,[temp2]
						cmp eax,1
						jne filfincolInter
							escribe msgColumnaFinal,lenMsgColumnaFinal
		    				;***************************codigo*********************************

		    				;******************obtenemos izquierda arriba**********************
		    				mov eax,[posI]
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3 
		    				mul ebx
							mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat00,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos   ariiba  ***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat01,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************obtenemos dato izquierda*******************
	   						mov eax,[posI]
	   						mov ebx,[width]
	   						mul ebx
	   						mov ebx,[posJ]
	   						add eax,ebx
	   						mov ebx,1
	   						sub eax,ebx
	   						mov ebx,3
	   						mul ebx
	   						mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat10,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos   dato  ***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat11,dato,sumatoria
	   						escribe msg2,len2
	   						;***************************fin del ultimo dato********************


		    				jmp finCompares
						filfincolInter:
							escribe msgColumnaIntermedia,lenMsgColumnaIntermedia
							;escribe msgFilaIntermedia,lenMsgFilaIntermedia
		    				;***************************codigo**********************
		    				;***************************************************************************************************************
		    				mov eax,[posI]
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3 
		    				mul ebx
							mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat00,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos   ariiba  ***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat01,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos   ariiba derecha  ***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat01,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************obtenemos dato izquierda*******************
	   						mov eax,[posI]
	   						mov ebx,[width]
	   						mul ebx
	   						mov ebx,[posJ]
	   						add eax,ebx
	   						mov ebx,1
	   						sub eax,ebx
	   						mov ebx,3
	   						mul ebx
	   						mov [readpointer],eax
	   						actualizarpuntero idpointer,[readpointer], 0
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat10,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos   dato  ***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat11,dato,sumatoria
	   						escribe msg2,len2
	   						;**********************leemos   dato derecha ***************************
	   						leeTxt [idpointer],texto,3
	   						escribe texto,3
	   						mov eax,[texto]
	   						mov [dato],eax
	   						elKevin mat11,dato,sumatoria
	   						escribe msg2,len2

		    				;***************************************************************************************************************

		    				jmp finCompares
				noFilFin:
					escribe msgFilaIntermedia,lenMsgFilaIntermedia
					;escribe msgColumnaIntermedia,lenMsgFilaIntermedia
					mov eax,[posJ]
					cmp eax,0
					jnz filinterNoCol0
						escribe msgColumna0,lenMsgColumna0
		    			;*****************************codigo************************* 

		    			;*********************obtenemos arriba*********************** 
		    			mov eax,[posI]
		    			mov ebx,1
		    			sub eax,ebx
		    			mov ebx,[width]
		    			mul ebx
		    			mov ebx,3
		    			mul ebx
		    			mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat01,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos arriba derecha***************************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat02,dato,sumatoria
	   					escribe msg2,len2
	   					;****************************leemos dato*******************************   ##################FUNCIONA CUALQUIER POS
	   					mov eax,[posI]
	   					mov ebx,[width]
	   					mul ebx
	   					mov ebx,[posJ]
	   					add eax,ebx
	   					mov ebx,3
	   					mul ebx
	   					mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat11,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos   dato  derecha***************************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat12,dato,sumatoria
	   					escribe msg2,len2
	   					;***********************************************************************
	   					;***************leemos el dato abajo***************
	   					mov eax,[posI]
	   					mov ebx,1
	   					add eax,ebx
	   					mov ebx,[width]
	   					mul ebx
	   					mov ebx,[posJ]
	   					add eax,ebx
	   					mov ebx,3 
	   					mul ebx 
	   					mov [readpointer],eax
	   					actualizarpuntero idpointer,[readpointer], 0
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat21,dato,sumatoria
	   					escribe msg2,len2
	   					;**********************leemos   abajo  derecha***************************
	   					leeTxt [idpointer],texto,3
	   					escribe texto,3
	   					mov eax,[texto]
	   					mov [dato],eax
	   					elKevin mat22,dato,sumatoria
	   					escribe msg2,len2

	   					;***********************************Terminamos lectura filainter col0*****************************
		    			jmp finCompares
					filinterNoCol0:
						mov eax,[temp2]
						cmp eax,1
						jnz filaIntermediaColInter
							escribe msgColumnaFinal,lenMsgColumnaFinal
							;escribe msgFilaFinal, lenMsgFilaFinal
		    				;***************************codigo**********************
		    				;***********************leemos arriba izquierda**********
		    				mov eax,[posI]
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		   					actualizarpuntero idpointer,[readpointer], 0
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat00,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   arriba  ***************************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat01,dato,sumatoria
		   					escribe msg2,len2
		   					;*********************leemos dato izquierda************************
		   					mov eax,[posI]
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		   					actualizarpuntero idpointer,[readpointer], 0
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat10,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   arriba  ***************************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat11,dato,sumatoria
		   					escribe msg2,len2
		   					;********************leemos dato abajo izquierda*******************
		   					mov eax,[posI]
		    				mov ebx,1
		    				add eax,ebx
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		   					actualizarpuntero idpointer,[readpointer], 0
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat20,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   arriba  ***************************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat21,dato,sumatoria
		   					escribe msg2,len2



			    			jmp finCompares
						filaIntermediaColInter:
							escribe msgColumnaIntermedia,lenMsgColumnaIntermedia
							;escribe msgFilaIntermedia,lenMsgFilaIntermedia
		    				;***************************codigo**********************
		    				;***************************************************************************************************************
		    				;***********************leemos arriba izquierda**********
		    				mov eax,[posI]
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		   					actualizarpuntero idpointer,[readpointer], 0
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat00,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   arriba  ***************************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat01,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   arriba  derecha********************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat02,dato,sumatoria
		   					escribe msg2,len2
		   					;*********************leemos dato izquierda************************
		   					mov eax,[posI]
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		   					actualizarpuntero idpointer,[readpointer], 0
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat10,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   dato  ****************************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat11,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   dato derecha**********************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat12,dato,sumatoria
		   					escribe msg2,len2
		   					;********************leemos dato abajo izquierda*******************
		   					mov eax,[posI]
		    				mov ebx,1
		    				add eax,ebx
		    				mov ebx,[width]
		    				mul ebx
		    				mov ebx,[posJ]
		    				add eax,ebx
		    				mov ebx,1
		    				sub eax,ebx
		    				mov ebx,3
		    				mul ebx
		    				mov [readpointer],eax
		   					actualizarpuntero idpointer,[readpointer], 0
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat20,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   abajo  ***************************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat21,dato,sumatoria
		   					escribe msg2,len2
		   					;**********************leemos   abajo derecha**********************
		   					leeTxt [idpointer],texto,3
		   					escribe texto,3
		   					mov eax,[texto]
		   					mov [dato],eax
		   					elKevin mat21,dato,sumatoria
		   					escribe msg2,len2
		    				;***************************************************************************************************************
		    				jmp finCompares

		    	

				finCompares:
					mov eax,[sumatoria]
			    	mov [write],eax
			    	;escribe texto,3
			    	;mov eax,[posI]
			    	;mov ebx,[width]
			    	;mul ebx
			    	;mov ebx,[posJ]
			    	;add eax,ebx
			    	;mov [readpointer],eax
			    	;actualizarpuntero idarchivo,[readpointer], 0
					escribeTxt [idarchivo],write,3

		    	mov ecx,[temp2]
		    	dec ecx
		    	jnz loop_columna

		    mov ecx, [temp]
		    dec ecx
	   		jnz loop_fila










	   ;**************************Fin del programa*************************	
	  
		salir:
		 mov eax, 1
		 xor ebx, ebx
		 int 0x80
