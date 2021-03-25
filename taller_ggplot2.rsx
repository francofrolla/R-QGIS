# Esto es un ejemplo de vinculación qgis+R, esta línea es un comentario 
##Taller = group
##Carpeta=folder
##Punto=vector point
##atributopunto=field Punto
##Tablasalida=output table


 
if("grid" %in% rownames(installed.packages()) == FALSE) {install.packages("grid")} else {print("grid ya esta..")}
if("ggplotify" %in% rownames(installed.packages()) == FALSE) {install.packages("ggplotify")} else {print("ggplotify ya esta..")}
if("gridExtra" %in% rownames(installed.packages()) == FALSE) {install.packages("gridExtra")} else {print("gridExtra ya esta..")}
if("ggplot2" %in% rownames(installed.packages()) == FALSE) {install.packages("ggplot2")} else {print("ggplot2 ya esta..")}

require(ggplot2)
require(grid)
require("gridExtra")

myshp <- as_Spatial(Punto)

datos<-myshp@data[,atributopunto]
datos<-data.frame(datos)
 
 grafico<-ggplot(datos, aes(x=datos)) + 
 geom_histogram(aes(y=..density..), colour="black", fill="white")+
 geom_density(alpha=.2, fill="#FF6666") 
 
title <- textGrob(paste("Probando R & QGIS - INTA Bordenave"),gp=gpar(fontsize=7),just = "center")

 
 arreglo<-grid.arrange(
    		grafico,
    		title,
    		nrow = 2,
    		ncol=1,
    		heights = c(1,0.1))

setwd(Carpeta)
ruta<-getwd()
print(ruta)
nombre1<-paste("probandoRyqgis",".pdf",sep= "")
ggsave(file=paste(ruta,"/",nombre1,sep=""), arreglo)

#Genero una tabla aleatoria para cargar en qgis
tabla<-data.frame(datos[datos>5])


Tablasalida<-tabla
