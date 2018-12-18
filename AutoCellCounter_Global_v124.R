# Assessment of results from AutoCellCounter_Global_v125.ijm
# AutoCellCounter Global Methods
# Enhance Constrast = YES
# Area filter = YES
# size = 1000-Infinity
library(tidyr); library(dplyr)

# Variables ####
Exp = "Exp19"
path  = paste0("~/Pictures/",Exp,"/AutoCellCounter_Global_v124/")
files = dir(path, pattern = ".txt")
manualCount = read.csv(paste0("./data/",Exp,"_manualCount.csv"))
tail(manualCount)

# Read the count data from each method ####
AutoCellCounter = list()
for(i in 1:length(files)){
  AutoCellCounter[[i]] = read.table(paste0(path,files[i]), header=T)
}
AutoCellCounter = do.call(rbind.data.frame, AutoCellCounter)
AutoCellCounter[,1] = gsub(".tif", "", AutoCellCounter[,1])
AutoCellCounter = separate(data=AutoCellCounter,
                           col=list,
                           into=c("Exp","cellLine", "timeDay","dye","wellNumbr","imgNumbr"),
                           sep="_")

# Reorder cols in Exp16
if(Exp == "Exp16"){
  AutoCellCounter[c("hacatCount", "sk147Count")] = NA
  AutoCellCounter = AutoCellCounter[c(1:7,10,11,8,9)]
}
tail(AutoCellCounter)

# Merge Manual and Automatic count data ####
CellCounter = rbind(manualCount, AutoCellCounter) %>%
  mutate(countMethod = c(rep("Manual",240),rep("Auto",16*240))) %>%
  mutate(manualCount = rep(manualCount$cellCount, 17)) %>%
  mutate(ratio = cellCount / manualCount) %>%
  # mutate(chi2 = sum((cellCount - manualCount)^2/ manualCount) ) %>%
  mutate(imgIndex = rep(1:240, 17))
tail(CellCounter)

# Correlate manual and automatic count ####
Correlation = numeric()
foo = character()
for(i in 1:length(levels(CellCounter$thresholdMethod))){
  foo = filter(CellCounter, thresholdMethod == levels(CellCounter$thresholdMethod)[i])
  Correlation[i] = cor(manualCount$cellCount, foo$cellCount)
}
names(Correlation) = levels(CellCounter$thresholdMethod)
rm(foo)

# Ratio data ####
ratioData_summary = group_by(CellCounter, thresholdMethod) %>%
  summarise(mu=mean(ratio), sigma=sd(ratio))

save.image(paste0(Exp, "_AutoCellCounter_v124.RData"))
