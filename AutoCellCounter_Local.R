# Analises dos resultados de AutoCellCounter_Local_v1.ijm
# Date: 2017-10-04
# AutoCellCounter Local Methods
# Enhance Constrast = NO
# Area filter = YES
# size = 1000-Infinity
library(tidyr); library(dplyr)

localMethods = c("Bernsen","Contrast","Mean",
                 "Median","MidGrey","Niblack",
                 "Otsu","Phansalkar","Sauvola")
Exp16_manualCount = read.csv("./data/Exp16_manualCount.csv", header=T)
Exp19_manualCount = read.csv("./data/Exp19_manualCount.csv", header=T)

correlation = numeric()

############### Exp16 #
path = "~/Pictures/Exp16/AutoCellCounter_Local_v1/"
files = dir(path, pattern = ".txt")

Exp16_Local = list()
for(i in 1:length(files)){
  Exp16_Local[[i]] = read.table(paste0(path,files[i]), header=T,
                                colClasses=c("character","numeric"))
  Exp16_Local[[i]][,1] = gsub(".tif", "", Exp16_Local[[i]][,1])
  Exp16_Local[[i]] = separate(Exp16_Local[[i]], list, sep="_",
                         c("Exp", "timeDay", "dye", "wellNumbr", "imgNumbr"))
  Exp16_Local[[i]][,"ratio"] =  Exp16_Local[[i]]$cellCount / Exp16_manualCount$cellCount
}
names(Exp16_Local) = localMethods

for(i in 1:9){
  correlation[i] = cor(Exp16_Local[[i]]$cellCount, Exp16_manualCount$cellCount)
}

Exp16_LocalCorrelation = data.frame(thresholdMethod = localMethods,
                                    correlation = correlation)



# Exp16_Local = do.call(rbind.data.frame, Exp16_Local)
# Exp16_Local = mutate(Exp16_Local, thresholdMethod = row.names(Exp16_Local))
head(Exp16_Local[[1]])

############### Exp19 #
path = "~/Pictures/Exp19/AutoCellCounter_Local_v1/"
files = dir(path, pattern = ".txt")

