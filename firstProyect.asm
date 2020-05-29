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


section .data 
	msg	db "Hola, Mundo!!!",0x0A
	len equ $ - msg 
	aster db "*"
	lenAster equ $ - aster
	archivo db "/home/richard/ensamblador/archivo.txt",0
	archivo2 db "/home/richard/ensamblador/archivo2.txt",0
	archivoLectura db "/home/richard/ensamblador/archivoLectura.txt",0


section .bss
	num resb 10
	temp resb 10
	num2 resb 10
	temp2 resb 10 
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
	idarchivo resd 1
	idarchivo2 resd 1
	idpointer resd 1
	idpointerNext resd 1
	idpointerPrev resd 1

section .text
	global _start       
_start:		    

		;*********************************en esta seccion cargamos los archivos que vamos a leer o escribir*********************
		abrirArchivo 8,archivo2    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
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

		abrirArchivo 5,archivoLectura    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		test eax, eax
		jz salir
		mov dword[idpointerNext], eax

		abrirArchivo 5,archivoLectura    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea
		test eax, eax
		jz salir
		mov dword[idpointerPrev], eax



		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		;
		;						agregar lecturas de pantalla teclado en esta seccion
		;
		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		mov eax, 4
		mov [width],eax
		mov eax,4
		mov [height],eax

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
		;						vamos a llenar el buffer
		;
		;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		mov ecx,[width]
		ciclollenadoBuffer
			mov [temp],ecx
			;***********************code here***********************
			leeTxt [idpointerNext],texto,3
			

			escribe texto, 3
			mov ecx, [temp]
		    dec ecx
	   	jnz ciclollenadoBuffer


	   ; inciiamos el ciclo 

	   mov eax, 0
	   mov ebx, 10
	   mov ecx, [height]

	   loop_fila
	   		;comienzo del ciclo for 
	   		mov [temp],ecx
	   		mov eax,[height]
	   		sub eax,ecx
		    add eax,'0'
		    mov [num],eax
		    escribe num,10
		    ;escribeTxt [idarchivo],num,10
		    ;add ecx, '0'
		    
		    ;mov eax, 4
		    ;mov ebx,1
		    ;mov ecx, num 
		    ;mov edx,10
		    ;int 0x80

		    mov ecx, [width]
		    loop_columna
		    	mov [temp2],ecx


		    	;*********************************************codigo ejecutable en el loop****************************
		    	escribe aster,lenAster
		    	escribeTxt [idarchivo],aster,lenAster
				;escribe texto, 4

				;escribeTxt [idarchivo],texto,3




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
