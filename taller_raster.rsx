# Esto es un ejemplo de vinculación qgis+R, esta línea es un comentario 
##Taller = group
##Raster= raster
##resultado= output raster
##listadesplegable=selection media;mediana;maximo;minimo;moda

# Imprimo algo de informacion del mapa
print(Raster)

#ventana suavizado 5x5 pixeles.
ventana<-matrix(1,nrow=5,ncol=5)


# Aplico la funcion "focal" del paquete R
if(listadesplegable==0){resultadofocal<-focal(Raster[[1]],w=ventana,fun=mean,na.rm=TRUE); print("Se aplico la media")}
if(listadesplegable==1){resultadofocal<-focal(Raster[[1]],w=ventana,fun=median,na.rm=TRUE); print("Se aplico la mediana")}
if(listadesplegable==2){resultadofocal<-focal(Raster[[1]],w=ventana,fun=max,na.rm=TRUE); print("Se aplico la maxima")}
if(listadesplegable==3){resultadofocal<-focal(Raster[[1]],w=ventana,fun=min,na.rm=TRUE); print("Se aplico la minima")}
if(listadesplegable==4){resultadofocal<-focal(Raster[[1]],w=ventana,fun=modal,na.rm=TRUE); print("Se aplico la moda")}

# Genero la salida.
resultado<-resultadofocal


