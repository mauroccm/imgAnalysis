# AutoCellCounterAreaFilter
library(tidyr); library(dplyr); library(ggplot2)
load("Exp19_AutoCellCounter_v12.RData")

# Set the files ####
thresholdMethods = levels(AutoCellCounter$thresholdMethod)

path_filter = list()
files_filter = list()
AutoCellCounter_filter = list()
AutoCount_filter = list()
Correlation_filter = numeric()

for(i in 1:length(thresholdMethods)){
  path_filter[[i]] = paste0(path, thresholdMethods[i], "/")
  files_filter[[i]] = dir(path_filter[[i]])
  AutoCellCounter_filter[[i]] = list()
  AutoCount_filter[[i]] = numeric()
}

# Read the count and position data, apply Area filter and count cells ####
for(i in 1:length(thresholdMethods)){
  for(j in 1:nrow(manualCount)){
    AutoCellCounter_filter[[i]][[j]] = 
      read.table(paste0(path_filter[[i]], files_filter[[i]][j]), header=T) %>%
      filter(Area >= 1000)
    AutoCount_filter[[i]][j] = nrow(AutoCellCounter_filter[[i]][[j]])
    print(paste0("imgIndex ",j,"/240"))
  }
  print(thresholdMethods[i])
}

names(AutoCellCounter_filter) = thresholdMethods
names(AutoCount_filter) = thresholdMethods

# Correlation between manual and AutoCellCounter after filter by Area ####
for(i in 1:length(thresholdMethods)) {
  Correlation_filter[i] = cor(manualCellCount, AutoCount_filter[[i]])
}
names(Correlation_filter) = thresholdMethods

# 
CorrelationData = data.frame(Correlation[2:17], Correlation_filter)
write.table(CorrelationData, "./data/Correlation.txt", sep="\t")


# CountData_filter ####
CountData_filter = CountData
CountData_filter[,"cellCount"] = c(manualCellCount, foo)
CountData_filter = mutate(CountData_filter, ratio = cellCount / manualCount)


str(CountData_filter)

# Estimate Ratios ####
HuangRatio = filter(CountData, thresholdMethod == "Huang") %>%
  select(ratio)
HuangRatio_filter = filter(CountData_filter, thresholdMethod == "Huang") %>%
  select(ratio)
HuangRatio = cbind(HuangRatio, HuangRatio_filter)

IntermodesRatio = filter(CountData, thresholdMethod == "Intermodes") %>%
  select(ratio)
IntermodesRatio_filter = filter(CountData_filter, thresholdMethod == "Intermodes") %>%
  select(ratio)
IntermodesRatio = cbind(IntermodesRatio, IntermodesRatio_filter)

foo = which(CountData$ratio >= 0.95 & CountData$ratio <= 1.05)
bar = which(CountData_filter$ratio >= 0.95 & CountData_filter$ratio <= 1.05)

rm(foo, bar)
##################




save.image("AutoCellCounter_features.RData")