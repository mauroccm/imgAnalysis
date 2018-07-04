# Assessment of results from AutoCellCounter_Global_v125.ijm
# AutoCellCounter Global Methods
# Enhance Constrast = YES
# Area filter = YES
# size = 980-Infinity
# Circularity = 0.562-1.0
require(tidyverse)

# Variables ####
# open auto counts 
path  = "results/2018-06-28/AutoCellCounter/"
files = dir(path, pattern = ".txt")
# files = files[1:17] # remove the log file.
# files = files[-9] # remove the MinError file #why?

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
                       col=imgList,
                       into=c("Exp","cellLine", "timeDay","dye","wellNumbr","imgNumbr"),
                       sep="_")
tail(autoCounter) # just checking...

# Merge Manual and Automatic count data ####
CountData = rbind(manualCount, autoCounter) %>%
  mutate(countMethod = c(rep("Manual",240),rep("Auto",17*240))) %>%
  mutate(manualCount = rep(manualCount$cellCount, 18)) %>%
  mutate(ratio = cellCount / manualCount) %>%
  mutate(residuals = abs(cellCount - manualCount)) %>%
  mutate(OE = (residuals / manualCount)) %>% # see the OEData
  mutate(imgIndex = rep(1:240, 18))
tail(CountData) # just checking

# Correlate manual and auto count ####
MethodsCounts = select(CountData, cellCount, thresholdMethod, imgIndex) %>%
  spread(thresholdMethod, cellCount)
tail(MethodsCounts)

MethodsCorrelation = apply(MethodsCounts, 2, cor, x=MethodsCounts[,2], 
                           use="pairwise.complete.obs")[-1] # remove the imgIndex

# Root mean square error ####
# source(../../RMSE.R) # functions for RMSE e MAE
MethodsRMSE = apply(MethodsCounts, 2, RMSE, actual=MethodsCounts[,"Manual"])[-1]
MethodsMAE = apply(MethodsCounts, 2, MAE, actual=MethodsCounts[,"Manual"])[-1]

# OEData ####
# OEData is the ratio of the difference of observed and expected value,
# and the expected value (manual count). $|O - E| / E$
OEData = select(CountData, imgIndex, OE, thresholdMethod) %>%
  spread(key= thresholdMethod, value = OE)
tail(OEData)

MethodsFDR = apply(OEData, 2, mean)[-1]

# Save Correlation and FDR results table ####
methodsAnalysis = data.frame(Methods=names(MethodsCorrelation),
                             Correlations=MethodsCorrelation,
                             FDR=MethodsFDR,
                             RMSE=MethodsRMSE,
                             MAE=MethodsMAE
)
View(methodsAnalysis)

write.table(methodsAnalysis,
           "results/2018-06-28/autoCounterV127_imgCleanerV13_methodsAnalysisResults.txt",
           row.names=F)
save.image("AutoCounter.RData")
