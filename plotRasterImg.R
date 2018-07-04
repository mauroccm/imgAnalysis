library(raster)

# set the colors
thermal = source("../LUTs/Thermal_LUT.R")[[1]]
thermal[1] = "gray50"

# Visually inspect the data and the calculated local maxima
# tractions_basal_localMaxArrows.png 
plot(basalCellImgRaster, col=thermal, main="tractions - basal")

points(basalResults[-1, 2:3], col='white', pch=3)
points(basalResults[-1 ,2:3], bg='yellow', pch=21, cex=0.7)
points(basalCentroid, col='white', pch=3)
points(basalCentroid, bg='red', pch=21, cex=0.7)

for(i in 2:NROW(basalResults)){
  arrows(basalCentroid[1,"X"], basalCentroid[1,"Y"],
         basalResults[i,"X"], basalResults[i,"Y"],
         col="yellow", angle=15, length=0.1)
}


# tractioins_basal_massVector.png
plot(basalCellImgRaster, col=thermal, main="tractions - basal (mass vector)")
points(basalCentroid, col='white', pch=3)
points(basalCentroid, bg='red', pch=21, cex=0.7)

points(basalMass, pch=3, col="white")
points(basalMass, pch=21, bg="green", cex=0.7)

arrows(basalCentroid[1,"X"], basalCentroid[1,"Y"],
       basalMass[1,"X"], basalMass[1,"Y"],
       col="green", angle=15, length=0.1)


# tractions_iso_localMaxArrows.png
plot(isoCellImgRaster, col=thermal, main="tractions - iso")

points(isoResults[-1,2:3], col='white', pch=3)
points(isoResults[-1,2:3], bg='yellow', pch=21, cex=0.7)
points(isoCentroid, col='white', pch=3)
points(isoCentroid, bg='red', pch=21, cex=0.7)


for(i in 2:NROW(isoResults)){
  arrows(isoCentroid[1,"X"], isoCentroid[1,"Y"],
         isoResults[i,"X"], isoResults[i,"Y"],
         col="yellow", angle=15, length=0.1)
}

# tractions_iso_massVector.png
plot(isoCellImgRaster, col=thermal, main="tractions - iso (mass vector)")
points(isoCentroid, col='white', pch=3)
points(isoCentroid, bg='red', pch=21, cex=0.7)
points(isoMass, col='white', pch=3)
points(isoMass, bg='green', pch=21, cex=0.7)

arrows(isoCentroid[1,"X"], isoCentroid[1,"Y"],
       isoMass[1,"X"], isoMass[1,"Y"],
       col="green", angle=15, length=0.1)

dev.off()
