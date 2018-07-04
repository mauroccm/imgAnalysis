# Analises dos resultados de autoCounter_Global_v1.2.3ijm
library(tidyverse)

# Variables ####
# open auto counts 
path  = "data/2017-08-25/AutoCellCounter_Global_v123/"
files = dir(path, pattern = ".txt")

# open manual counts
manualCount = read.csv("results/2017-10-30 autoCounter/Exp19_manualCount.csv")
tail(manualCount) # just checking...

# Read and format data ####
autoCounter = list()
for(i in 1:length(files)){
  autoCounter[[i]] = read.table(paste0(path,files[i]), header=T)
}
autoCounter = do.call(rbind.data.frame, autoCounter) # rbind the data.frames
autoCounter[,1] = gsub(".tif", "", autoCounter[,1]) # remove extension from file names
autoCounter = separate(data=autoCounter, # reshape the data.frame
                           col=list,
                           into=c("Exp","cellLine", "timeDay","dye","wellNumbr","imgNumbr"),
                           sep="_")
tail(autoCounter) # just checking...

# Merge Manual and Automatic count data ####
CountData = rbind(manualCount, autoCounter) %>%
  mutate(countMethod = c(rep("Manual",240),rep("Auto",16*240))) %>%
  mutate(manualCount = rep(manualCount$cellCount, 17)) %>%
  mutate(ratio = cellCount / manualCount) %>%
  mutate(OE = (Mod(cellCount - manualCount) / manualCount)) %>% # see the OEData
  mutate(imgIndex = rep(1:240, 17))
tail(CountData)

# Correlate manual and auto count ####
Correlation = numeric()
foo = data.frame()
for(i in 1:length(levels(CountData$thresholdMethod))){
  foo = filter(CountData, thresholdMethod == levels(CountData$thresholdMethod)[i])
  Correlation[i] = cor(manualCount$cellCount, foo$cellCount)
}
rm(foo)
names(Correlation) = levels(CountData$thresholdMethod)
# Correlation = sort(Correlation, decreasing = T) # sort correlations
CorrelData = t(t(Correlation)) # data.frame correlations
print(CorrelData)

# Ratio data ####
# RatioData = select(CountData, imgIndex, ratio, thresholdMethod) %>%
#   spread(key = thresholdMethod, value = ratio)
# # tail(RatioData)
# ratioDataSummary = apply(RatioData, 2, summary)
# ratioDataMean = t(t(sort(ratioDataSummary["Mean", ])))
# ratioDataMean = t(t(ratioDataMean[-17, ])) # remove the imgIndex line

# OEData ####
# OEData is the ratio between the difference of observed and expected value,
# and the expected value.
OEData = select(CountData, imgIndex, OE, thresholdMethod) %>%
  spread(key= thresholdMethod, value = OE)
OEDataSummary = apply(OEData, 2, summary)
OEDataMean = t(t(sort(OEDataSummary["Mean", ])))
OEDataMean = t(t(sort(OEDataMean[-17, ]))) # remove the imgIndex line
OEDataMean = t(t(OEDataMean[rownames(CorrelData), ]))
print(OEDataMean)

methodsAnalysis = cbind(CorrelData, OEDataMean)
colnames(methodsAnalysis) = c("Correlation", "FDR")
# write.table(methodsAnalysis,
#             "results/2017-09-11 autoCellCounter_Global_v123/methodsAnalysis.txt")
save.image()