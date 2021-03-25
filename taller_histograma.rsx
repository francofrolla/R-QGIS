# Esto es un ejemplo de vinculación qgis+R, esta línea es un comentario 
##Taller = group
##Shape=vector
##Rinde=field Shape
##output_plots_to_html
##showplots
myshp <- as_Spatial(Shape)
hist(na.omit(myshp@data[,Rinde]),xlab = "Rendimiento", ylab="Frecuencia",main="Histograma datos rendimiento",breaks=25,cex.lab=1.5,cex.axis=1.5,cex.main=1.5)

>print('Eureka')
>print(nrow(myshp@data))
