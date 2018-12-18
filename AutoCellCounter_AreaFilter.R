# AutoCellCounterAreaFilter
library(tidyr); library(dplyr)
Exp = "Exp19"
load(paste0(Exp,"_AutoCellCounter_v12.RData"))

# Set the variables ####
thresholdMethods = levels(AutoCellCounter$thresholdMethod)

path_filter = list()            # list of each method path
files_filter = list()           # list of each method file
AutoCellCounterData = list()    # list of list with each method data
AutoCellCounter_filter = list() # list of each method count

for(i in 1:length(thresholdMethods)){
  path_filter[[i]] = paste0(path, thresholdMethods[i], "/")
  files_filter[[i]] = dir(path_filter[[i]])
  AutoCellCounterData[[i]] = list()
  AutoCellCounter_filter[[i]] = numeric()
}

# Read the count and position data, apply Area filter and count cells ####
for(i in 1:length(thresholdMethods)){
  for(j in 1:nrow(manualCount)){
    AutoCellCounterData[[i]][[j]] = 
      read.table(paste0(path_filter[[i]], files_filter[[i]][j]), header=T) %>%
      filter(Area >= 1000)
    AutoCellCounter_filter[[i]][j] = nrow(AutoCellCounterData[[i]][[j]])
    print(paste0("imgIndex ",j,"/240"))
  }
  print(thresholdMethods[i])
}
names(AutoCellCounterData) = thresholdMethods

foo = AutoCellCounter
foo["cellCount"] = unlist(AutoCellCounter_filter)
AutoCellCounter_filter = foo
rm(foo)

# Merge Manual and Automatic count data ####
CellCounter_filter = rbind(manualCount, AutoCellCounter_filter) %>%
  mutate(countMethod = c(rep("Manual",240),rep("Auto",16*240))) %>%
  mutate(manualCount = rep(manualCount$cellCount, 17)) %>%
  mutate(ratio = cellCount / manualCount) %>%
  # mutate(chi2 = sum((cellCount - manualCount)^2/ manualCount) ) %>%
  mutate(imgIndex = rep(1:240, 17))
tail(CellCounter_filter)

# Correlation between manual and AutoCellCounter after filter by Area ####
Correlation_filter = numeric()
foo = character()
for(i in 1:length(levels(CellCounter$thresholdMethod))){
  foo = filter(CellCounter_filter, thresholdMethod == levels(CellCounter$thresholdMethod)[i])
  Correlation_filter[i] = cor(manualCount$cellCount, foo$cellCount)
}
names(Correlation_filter) = levels(CellCounter$thresholdMethod)
rm(foo)

CorrelationData = data.frame(Correlation, Correlation_filter)
write.table(CorrelationData, paste0("./data/",Exp,"_Correlation.txt"), sep="\t")

# Ratio data w/ filter ####
ratioData_summary_filter = group_by(CellCounter_filter, thresholdMethod) %>%
  summarise(mu=mean(ratio), sigma=sd(ratio))
ratioData = bind_cols(ratioData_summary, ratioData_summary_filter)
ratioData[,4] = NULL
names(ratioData)[4:5] = c("mu_filter", "sigma_filter")
write.table(ratioData, paste0("./data/",Exp,"_ratioData.txt"), sep="\t", row.names=F)

ratioData_long = data.frame(thresholdMethod = rep(ratioData$thresholdMethod, 2),
                            mu = c(ratioData$mu, ratioData$mu_filter),
                            sigma = c(ratioData$sigma, ratioData$sigma_filter),
                            filter = c(rep("noFilter", 17), rep("filter", 17))
                            )

