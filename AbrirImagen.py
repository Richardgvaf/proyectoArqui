
#*********************************************codigos de referencia bibliografica*******************************************
#https://kite.com/python/answers/how-get-the-rgb-values-of-an-image-using-pil-in-python
#https://linuxconfig.org/install-numpy-on-ubuntu-18-04-bionic-beaver-linux							
#https://stackoverrun.com/es/q/5210471
#https://pypi.org/project/opencv-python/
#https://www.w3schools.com/python/python_file_write.asp
#***************************************************************************************************************************
import numpy as np  												#importamos numpy
import math 														#importamos librerìa matematica
import cv2															#importamos la libreria opencv
from PIL import Image  												#importamos el modulo para leer y cargar la imagen
print("Digite el nombre(si se ubica en el directorio de ejecucion) o ruta de la imagen")	#solicitamos el nombre de la imagen
nombreImg = input()													#capturamos en nombreImg el nombre de la imagen digitada						

image = Image.open(nombreImg) 										#cargamos la imagen para leer los pixeles		
img = cv2.imread(nombreImg) 										#cargamos la imagen con cv2 para obtener las dimensiones
height, width, channels = img.shape									#obtenemos las dimensiones alto,ancho y la cantidad de canales por pixel
print("ancho: ", width)												#alertamos al usuario el ancho de la imagen para la siguiente etapa
print("alto: ",height)												#alertamos al usuario el alto de la imagen para la siguiente etapa

archivo = open("salidaImagen.txt", "w")								#definimos el nombre del archivo donde se guarda la información

i = 0																#definimos el inicio de la lectura de la imagen vertical
while(i<height):													#ciclo desde 0 hasta el alto de la imagen (filas)
	j = 0																#definimos el inicio de la lectura de la imagen horizontal
	while(j < width):													#ciclo desde 0 hasta el ancho de la imagen (columnas)
		imageRgb = image.getpixel((j,i))									#leemos el pixel de la imagen de uno por uno 
		total 	 = math.floor((imageRgb[0] + imageRgb[1] + imageRgb[2])/3)	#nos aseguramos de combertirlo en escala de grises
		if(total<10):														#comprobamos si es menor a 10
			archivo.write('00')												#rellenamos con 00 si es menor que 10, da como resultado 00X
		elif(total<100):												#comprobamos si es menos a 100
			archivo.write('0')											#rellenamos con un 00 si es menor a 100, da como resultado 0XX
		archivo.write(str(total))									#escribimos en el archivo destino el dato con el pixel											
		j += 1														#aumentamos el contador horizontal
	i += 1															#aumentamos el contador vertical
archivo.close()														#cerramos el archivo de escritura

