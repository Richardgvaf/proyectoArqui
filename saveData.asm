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
%macro cerrarArchivo 1
	mov eax, 6
	mov ebx, %1
	mov ecx, 0
	mov edx, 0
	int 0x80
%endmacro
%macro cargar 2
	mov eax, %1
	mov ebx, %2
	mov ecx, 2
	mov edx, 7777h
	int 0x80

%endmacro

segment .data

aviso db "Escribe en archivo :",0xA
lenaviso equ $-aviso
archivo db "/home/richard/ensamblador/archivo.txt",0


segment .bss
texto resb 3
idarchivo resd 1
txtprint  resd 10


segment .text




global _start

_start:


;mov eax, 8
;mov ebx, archivo
;mov ecx, 2
;mov edx, 7777h
;int 0x80
cargar 8,archivo
test eax, eax
jz salir
mov dword[idarchivo], eax			;accedemos al archivo

escribe aviso, lenaviso


mov eax,'012'
mov [texto],eax
escribeTxt [idarchivo],texto,3


mov eax,'abc'
mov [texto],eax
escribeTxt [idarchivo],texto,3


;escribe idarchivo,1
;cerramos el archivo

cerrarArchivo [idarchivo]



;leemos el archivo

mov eax, 5
;mov ebx, archivo
;mov ecx, 0
;mov edx, 0
;int 0x80
cargar 5,archivo
test eax, eax
jz salir
mov dword[idarchivo], eax
;mov eax, '654'
;mov [texto],eax

leeTxt [idarchivo], texto, 3
escribe texto, 3

leeTxt [idarchivo], texto, 3
escribe texto, 3


cerrarArchivo [idarchivo]


salir:
 mov eax, 1
 xor ebx, ebx
 int 0x80