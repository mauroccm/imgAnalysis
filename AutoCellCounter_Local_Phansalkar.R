# AutoCellCounter_Local_Phansalkar
# This script was elaborated to read the AutoCellCount_local_phansalkar method
# from Exp16 and Exp19, and compare with manualCount results.
library(tidyr); library(dplyr)

Exp16 = read.table("~/Pictures/Exp16/AutoCellCounter_Local/AutoCellCounter_Local_Phansalkar.txt",
                   header=T)
Exp16[,1] = gsub(".tif", "", Exp16[,1])
Exp16 = separate(Exp16, list, c("Exp","timaDay","dye","wellNumbr","imgNumbr"), "_")
Exp16_PhansalkarCount = Exp16[,"cellCount"]
Exp16_manualCount = read.csv("./data/Exp16_manualCount.csv")
Exp16_manualCount = Exp16_manualCount[,"cellCount"]

Exp16_DF = data.frame(method = c(rep("Manual", 240), rep("Phansalkar", 240)),
                      timeDay = rep(rep(1:8,each=30),2),
                      cellCount = c(Exp16_manualCount, Exp16_PhansalkarCount)
)

Exp19 = read.table("~/Pictures/Exp19/AutoCellCounter_Local_Phan/AutoCellCounter_Local_Phansalkar.txt",
                   header=T)
Exp19[,1] = gsub(".jpg", "", Exp19[,1])
Exp19 = separate(Exp19, list, c("Exp","cellLine","timaDay","dye","wellNumbr","imgNumbr"), "_")
Exp19_PhansalkarCount = Exp19[,"cellCount"]
Exp19_manualCount = read.csv("./data/Exp19_manualCount.csv")
Exp19_manualCount = Exp19_manualCount[,"cellCount"]

Exp19_DF = data.frame(method = c(rep("Manual", 240), rep("Phansalkar", 240)),
                      timeDay = rep(rep(1:8,each=30),2),
                      cellCount = c(Exp19_manualCount, Exp19_PhansalkarCount)
)

###############
library(ggplot2)
g16 = ggplot(Exp16_DF, aes(as.character(timeDay), cellCount, fill=method))
g16 + geom_boxplot() + scale_fill_discrete(name="Method") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  #scale_x_discrete(label=1:8) + coord_cartesian(ylim=c(0,1200))+
  theme(legend.title=element_text(size=10), legend.text=element_text(size=9))
ggsave(paste0("./plots/Exp16_AutoCellCounter_local_Phansalkar.png"), width=5, height=4, units="in")

g19 = ggplot(Exp19_DF, aes(as.character(timeDay), cellCount, fill=method))
g19 + geom_boxplot() + scale_fill_discrete(name="Method") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  #scale_x_discrete(label=1:8) + coord_cartesian(ylim=c(0,1200))+
  theme(legend.title=element_text(size=10), legend.text=element_text(size=9))
ggsave(paste0("./plots/Exp19_AutoCellCounter_local_Phansalkar.png"), width=5, height=4, units="in")
