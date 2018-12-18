# Analysis of the number of neighbors and area relationship
# 
# Sctript para a análise da relação entre o número de vizinhos e uma dada cél.
# Os dados em 2018-08-14 são das simulações (Sim06),
# Os dados de 2018-09-06 são contagem (marcação) manual do Exp19 (HaCaT)
# Os dados de 2018-09-14 são contagem (marcação) manual do Exp27 (SK147)
# 
#  Mauro Morais, 2018-09-12
library(tidyverse)

# input files ####
# for nNeigh vs area analysis
img = T # image or simulation? TRUE means images from Exp19
if(img) {
  scale = 50/233 # scale of 20x objective from E600 microscope
  expDate = "2018-09-06_Exp19_nNeig" # HaCaT cells
  # expDate = "2018-09-14_Exp27_nNeig" # SK147 cells
  yLab = expression(paste("Area (", mu, "m²)"))
} else {
  scale = 1
  expDate = "2018-08-14"
  yLab = "Area (A.U.)"
}

inDir = paste0("results/", expDate, "/nNeig_analysis/")
inDirResults = paste0("results/", expDate, "/nNeig_results/")

inFiles = dir(inDir)
cellsResultsFiles = dir(inDirResults)

# variables ####
numbrNeighbors = list() # numbr of neighbors of each cell
numbrNeighborsTable = list() # numbr of neighbors counts
numbrNeighborsFreq = list() # numbr of neighbors frequency
entropy = list() # entropy value of each image numbr of neighbors distribution
cellsResults = list() # the results table of each cell from IJ

# selected cells
selectedCells = list()
selectedCellsTable = list()
selectedCellsFreq = list()
selectedCellsEntropy = list()

for(i in 1:length(inFiles)){ # loop read the data

  numbrNeighbors[[i]] = read.table(paste0(inDir, inFiles[i]), header=T)
  numbrNeighborsTable[[i]] = table(numbrNeighbors[[i]]$neighborArray)
  numbrNeighborsFreq[[i]] = numbrNeighborsTable[[i]] / sum(numbrNeighborsTable[[i]])
  entropy[[i]] = -sum(numbrNeighborsFreq[[i]] * log2(numbrNeighborsFreq[[i]]))
  
  # to remove zeros from numbr. of neighbors 
  # that represent edge-excluded particles
  selectedCells[[i]] = numbrNeighbors[[i]][which(numbrNeighbors[[i]]$markedNeighborArray != 0), ]
  selectedCellsTable[[i]] = table(selectedCells[[i]]$markedNeighborArray)
  selectedCellsFreq[[i]] = selectedCellsTable[[i]] / sum(selectedCellsTable[[i]])
  selectedCellsEntropy[[i]] = -sum(selectedCellsFreq[[i]] * log2(selectedCellsFreq[[i]]))
  
  # Area analysis
  cellsResults[[i]] = read.table(
    paste0(inDirResults, cellsResultsFiles[i]), 
    header=T, colClasses="numeric")[c("Area", "X", "Y")]#, "Perim.")]

}

# re-shape data
numbrNeighborsAll = do.call(rbind.data.frame, numbrNeighbors)
numbrNeighborsCounts = unlist(numbrNeighborsTable)
numbrNeighborsFrequency = unlist(numbrNeighborsFreq)
numbrNeighborsResults = do.call(rbind.data.frame, cellsResults)
ALL = cbind(numbrNeighborsResults, numbrNeighborsAll)

selectedCellsCounts = unlist(selectedCellsTable)
selectedCellsFrequency = unlist(selectedCellsFreq)
selectedCellsResults = filter(ALL, markedNeighborArray != 0)

# numbr of neigbors data frame
numbrNeighborsData = data.frame(
  numbrNeighbors = as.numeric(names(numbrNeighborsCounts)),
  counts = numbrNeighborsCounts,
  frequency = numbrNeighborsFrequency
)

selectedCellsData = data.frame(
  numbrNeighbors = as.numeric(names(selectedCellsCounts)),
  counts = selectedCellsCounts,
  frequency = selectedCellsFrequency
)

# summary...
numbrNeighborsData.summary = group_by(numbrNeighborsData, numbrNeighbors) %>%
  summarise(countMean = mean(counts), countSd = sd(counts),
            freqMean = mean(frequency), freqSd = sd(frequency), N=n())

selecetedCellsData.summary = group_by(selectedCellsData, numbrNeighbors) %>%
  summarise(countMean = mean(counts), countSd = sd(counts),
            freqMean = mean(frequency), freqSd = sd(frequency), N=n())

# calculate entropy 
entropyMean = mean(unlist(entropy))
entropySd = sd(unlist(entropy))

selectedCellsEntropyMean = mean(unlist(selectedCellsEntropy))
selectedCellsEntropySd = sd(unlist(selectedCellsEntropy))

save.image("nNeighborAnalysis.RData")
