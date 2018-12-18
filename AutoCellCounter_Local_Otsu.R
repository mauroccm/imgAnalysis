# AutoCellCounter_Local_Phansalkar
# This script was elaborated to read the AutoCellCount_local_phansalkar method
# from Exp16 and Exp19, and compare with manualCount results.
library(tidyr); library(dplyr)

Exp16 = read.table("~/Pictures/Exp16/AutoCellCounter_Local/AutoCellCounter_Local_Otsu.txt",
                   header=T)
Exp16[,1] = gsub(".tif", "", Exp16[,1])
Exp16 = separate(Exp16, list, c("Exp","timaDay","dye","wellNumbr","imgNumbr"), "_")
Exp16_OtsuCount = Exp16[,"cellCount"]
Exp16_manualCount = read.csv("./data/Exp16_manualCount.csv")
Exp16_manualCount = Exp16_manualCount[,"cellCount"]

Exp16_DF = data.frame(method = c(rep("Manual", 240), rep("Otsu", 240)),
                      timeDay = rep(rep(1:8,each=30),2),
                      cellCount = c(Exp16_manualCount, Exp16_OtsuCount)
)

print("Correlation between manual and Local Otsu count:")
print(cor(Exp16_DF[1:240,3], Exp16_DF[241:480,3]))

Exp19 = read.table("~/Pictures/Exp19/AutoCellCounter_Local/AutoCellCounter_Local_Otsu.txt",
                   header=T)
Exp19[,1] = gsub(".jpg", "", Exp19[,1])
Exp19 = separate(Exp19, list, c("Exp","cellLine","timaDay","dye","wellNumbr","imgNumbr"), "_")
Exp19_Otsu = Exp19[,"cellCount"]
Exp19_manualCount = read.csv("./data/Exp19_manualCount.csv")
Exp19_manualCount = Exp19_manualCount[,"cellCount"]

Exp19_DF = data.frame(method = c(rep("Manual", 240), rep("Otsu", 240)),
                      timeDay = rep(rep(1:8,each=30),2),
                      cellCount = c(Exp19_manualCount, Exp19_Otsu)
)

print("Correlation between manual and Local Otsu count in Exp19:")
print(cor(Exp19_DF[1:240,3], Exp19_DF[241:480,3]))
Exp19_DF[241:480,3] / Exp19_DF[1:240,3]

###############
library(ggplot2)
g16 = ggplot(Exp16_DF, aes(as.character(timeDay), cellCount, fill=method))
g16 + geom_boxplot() + scale_fill_discrete(name="Method") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  #scale_x_discrete(label=1:8) + coord_cartesian(ylim=c(0,1200))+
  theme(legend.title=element_text(size=10), legend.text=element_text(size=9))
ggsave(paste0("./plots/Exp16_AutoCellCounter_Local_Otsu.png"), width=5, height=4, units="in")

g19 = ggplot(Exp19_DF, aes(as.character(timeDay), cellCount, fill=method))
g19 + geom_boxplot() + scale_fill_discrete(name="Method") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  #scale_x_discrete(label=1:8) + coord_cartesian(ylim=c(0,1200))+
  theme(legend.title=element_text(size=10), legend.text=element_text(size=9))
ggsave(paste0("./plots/Exp19_AutoCellCounter_Local_Otsu.png"), width=5, height=4, units="in")
