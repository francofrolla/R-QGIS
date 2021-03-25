# Esto es un ejemplo de vinculación qgis+R, esta línea es un comentario 
##Taller = group
##Shape=vector point
##enestacolumnaestaelrinde=field Shape
##Poligono=vector polygon
##Distancia_busqueda=number 40
##showplots
##kriging=output raster

#output_plots_to_html
##showplots



if("sp" %in% rownames(installed.packages()) == FALSE) {install.packages("sp")} else {print("sp ya esta..")}
if("gstat" %in% rownames(installed.packages()) == FALSE) {install.packages("gstat")} else {print("gstat ya esta..")}
if("spdep" %in% rownames(installed.packages()) == FALSE) {install.packages("spdep")} else {print("spdep ya esta..")}
if("raster" %in% rownames(installed.packages()) == FALSE) {install.packages("raster")} else {print("raster ya esta..")}
if("rgdal" %in% rownames(installed.packages()) == FALSE) {install.packages("rgdal")} else {print("rgdal ya esta..")}

         


library(sp)
library(spdep)
library(gstat)

crs_imagen<-st_crs(Shape)
datos <- as_Spatial(Shape)
poligono <- as_Spatial(Poligono)

proj4string(datos) <- CRS(proj4string(datos))


>print("ARMO GRILLA DE MUESTREO")
poligono <- buffer(poligono, width=100) 
grdpts <- makegrid(poligono, cellsize = 5)
spgrd <- SpatialPoints(grdpts, proj4string = CRS(proj4string(poligono)))
spgrdWithin <- SpatialPixels(spgrd[poligono,])
par(mfrow= c(1,1))
>plot(spgrdWithin,col = "red", pch = 10, cex = 0.2,xlab="X",ylab="Y")
gri<-spgrdWithin
print(str(gri))
print(CRS(proj4string(poligono)))

>print("ARMO VARIOGRAMA")
require(gstat)

semivariograma <- variogram(get(enestacolumnaestaelrinde)~1, datos, cutoff=250)


sill<-max(semivariograma$gamma)
nugget<-semivariograma[1,3]
Limite_distancia<-max(semivariograma$dist)

modelovgm<- fit.variogram(semivariograma, fit.method=1, vgm(sill,"Sph",Limite_distancia,nugget))
error1<-attr(modelovgm , 'SSErr')
>print(paste("Error inicial",error1))
modelo_final = "Sph"


seleccion_modelo<-function(){
	modelos<-c("Sph","Exp","Lin","Gau","Ste","Mat")
		for (i in 1:length(modelos)){
                print(i)
		modelovgm<- fit.variogram(semivariograma, fit.method=1, vgm(sill,modelos[i],Limite_distancia,nugget))
	 	error<-(attr(modelovgm , 'SSErr'))
			print(modelos[i])
			print(error)
			if(error < error1){
                        modelo_final <<- modelos[i]
		        error1<-error
 			>print(paste("Por ahora el mejor modelo es",modelo_final))	
				
                        }
            }
}

suppressWarnings(seleccion_modelo())
>print(paste("Modelo final",modelo_final))
modelovgm<- fit.variogram(semivariograma, fit.method=1, vgm(sill,modelo_final,Limite_distancia,nugget))
plot(semivariograma,modelovgm ,main="",xlab="Distancia",ylab="Semivarianza")

data2<-remove.duplicates(datos)
>print("Datos originales")
>print(nrow(datos))
>print("Datos filtrados")
>print(nrow(data2))

crs(data2)<-NA
crs(gri)<-NA

>print("---------Distancia de interpolado---------------")
>print(Distancia_busqueda)

Kg_wls <- krige(get(enestacolumnaestaelrinde)~1, data2, gri, model = modelovgm, debug.level=-1,maxdist=Distancia_busqueda)

print("Armamos el Raster para ver en QGIS")
raster<- raster(Kg_wls,layer=1)
crs(raster)<-crs(poligono)
kriging <- raster
