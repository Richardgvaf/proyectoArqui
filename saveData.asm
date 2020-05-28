%macro escribe 2
	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
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

segment .data
msg2 db "leyendo desde un archivo :",0xA
len2 equ $-msg2

archivo db "/home/richard/ensamblador/archivo.txt",0



segment .bss
texto resb 4
idarchivo resd 1

segment .text

global _start

_start:

abrirArchivo 8,archivo    ;ponemos modo edicion y archivo destino; carga el archivo o lo crea


test eax, eax
jz salir
mov dword[idarchivo], eax

escribe msg2, len2
mov eax,'pau'
mov [texto], eax
escribeTxt [idarchivo],texto,3
escribe texto, 4





;cerramos el archivo
cerrarArchivo [idarchivo]




salir:
 mov eax, 1
 xor ebx, ebx
 int 0x80