section .data 
	msg	db "Hola, Mundo!!!",0x0A
	len equ $ - msg 
	aster db "*"
	lenAster equ $ - aster
section .bss
	num resb 10
	temp resb 10
	num2 resb 10
	temp2 resb 10 

	;variables para el uso de los loop_fila
	width resb 10

section .text
	global _start       
_start:		    
		mov eax, 10
		mov [width],eax

	   ;saludamos al mundo
	   mov eax, 4		
	   mov ebx, 1		
	   mov ecx, msg		
	   mov edx, len		
	   int 0x80		
	   
	   ; inciiamos el ciclo 

	   mov eax, 0
	   mov ebx, 10
	   mov ecx, [width]

	   loop_fila
	   		;comienzo del ciclo for 
	   		mov eax,[width]
	   		sub eax,ecx
	   		;mov eax,ecx
		    add eax,'0'
		    mov [num],eax
		    add ecx, '0'
		    mov [temp],ecx
		    mov eax, 4
		    mov ebx,1
		    mov ecx, num 
		    mov edx,10
		    int 0x80

		    mov ecx, 10
		    loop_columna
		    	mov [temp2],ecx
		    	mov eax, 4
		    	mov ebx,1
		    	mov ecx, aster 
		    	mov edx,lenAster
		    	int 0x80
		    	mov ecx,[temp2]
		    	loop loop_columna

		    mov ecx, [temp]
		    sub ecx, '0'
	   		loop loop_fila













	   ;**************************Fin del programa*************************	
	   mov eax, 1		
	   int 0x80
