# SSD imgAnalysis 
# Minimizing the difference increases the accuracy

source("../SSD.R")

# Input directories
inDirOrig = "~/Pictures/Exp19/hacat_HOE_cleanV10_TXT/"
inDirTransf = "~/Pictures/Exp19/hacat_HOE_cleanV11_TXT/"

# Input files
filesOrigImgs = dir(inDirOrig)
filesTransfImgs = dir(inDirTransf)

# Read the files
originalImgs = list()
transfImgs = list()

# Imgs Annotation
SumSqDif = numeric()
CorCoef = numeric()

# Loop
for(i in 1:5){
  originalImgs[[i]] = 
    as.matrix(read.table(paste0(inDirOrig, filesOrigImgs[i]), 
                         colClasses="integer"))
  
  transfImgs[[i]] = 
    as.matrix(read.table(paste0(inDirTransf, filesTransfImgs[i]),
                         colClasses="integer"))
  
  SumSqDif[i] = SSD(originalImgs[[i]], transfImgs[[i]])
  
  CorCoef[i] = CC(originalImgs[[i]], transfImgs[[i]])
}
