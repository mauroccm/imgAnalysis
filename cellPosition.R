## Identify maximal local intensity
## Get the position of each cell from manual counts 
## Manual Counts were performed with the CellCounter plugin in imageJ 
library(XML)
pathXML = "./data/2017-10-30/Exp16_XML/" ## path to files folder ## "./data/Exp19_XML/"
filesXML = dir(pathXML)
fileNames = gsub(".xml", "_cellPosition", filesXML) # rename files
fileNames = gsub("CellCounter_", "", fileNames)

cellPositionManual = list()
doc = list()
rootNode = list()
xValues = list()
yValues = list()

Type1 = list() # number of HaCaT cells
Type2 = list() # number of SK147 cells

for(i in 1:length(filesXML)){
  doc[[i]] = xmlTreeParse(paste0(pathXML,filesXML[i]), useInternalNodes = T)
  rootNode[[i]] = xmlRoot(doc[[i]])
  xValues[[i]] = xpathSApply(rootNode[[i]], "//MarkerX", xmlValue)
  yValues[[i]] = xpathSApply(rootNode[[i]], "//MarkerY", xmlValue)
  Type1[[i]] = length(xmlChildren(rootNode[[i]][[2]][[2]]))-1
  Type2[[i]] = length(xmlChildren(rootNode[[i]][[2]][[3]]))-1
  
  cellPositionManual[[i]] = data.frame(X=as.numeric(xValues[[i]]),
                                       Y=as.numeric(yValues[[i]]),
                                       # Y=1536-as.numeric(yValues[[i]]),
                                       Type=c(rep("HaCaT", Type1[[i]]),
                                              rep("SK147", Type2[[i]]))
                                       )
}
head(cellPositionManual[[211]]) # just cheking...

for(i in 1:240) write.table(cellPositionManual[[i]], 
                            paste0("./data/2017-10-30/Exp16_TXT/", fileNames[i], ".txt"),
                            row.names=F, sep="\t", quote=F)
