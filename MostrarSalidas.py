#*************************************************referencias****************************************************
#
#https://matplotlib.org/3.1.1/users/installing.html
#
#*****************************************************************************************************************
import matplotlib.pyplot as plt
import numpy as np
from PIL import Image

plt.rcParams['image.cmap'] = 'gray'

archivo = open("archivo.txt","r")

print("Digite el ancho")	#solicitamos el nombre de la imagen
width = input()		
print("Digite el alto")
height = input()
width = int(width)
height = int(height)

matriz = np.zeros((height,width))

i = 0																#definimos el inicio de la lectura de la imagen vertical
while(i<height):													#ciclo desde 0 hasta el alto de la imagen (filas)
	j = 0																#definimos el inicio de la lectura de la imagen horizontal
	while(j < width):	

		#procedemos a procesar los valores de salida en el correcto orden
		cadena1 	= archivo.read(1)	
		pos0 = ord(cadena1)
		cadena1 = archivo.read(1)
		pos1 = ord(cadena1)
		cadena1 = archivo.read(1)	
		pos2 = ord(cadena1)
		pos0 = (pos0-48)*100
		pos1 = (pos1-48)*10
		pos2 = (pos2-48)
		total = pos2+pos1+pos0
		if(total<0):
			total = 0
		elif(total>255):
			total = 255
		print(total)			
		matriz[i,j] = total
		
		j += 1														#aumentamos el contador horizontal
	i += 1															#aumentamos el contador vertical
m = np.array(matriz)
plt.imshow(matriz,vmin=0,vmax=255)
plt.savefig('imgSalida.png')