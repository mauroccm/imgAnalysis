# Analises dos resultados de AutoCellCounter_Global_v1.2.ijm
library(tidyr); library(dplyr); library(ggplot2)

# Variables ####
path  = "./data/Exp19/AutoCellCounter_Global_v122/"
files = dir(path, pattern = ".txt")
manualCount = read.csv("./data/Exp19/Exp19_manualCount.csv")
tail(manualCount)

AutoCellCounter = list()

# Read and format data ####
for(i in 1:length(files)){
  AutoCellCounter[[i]] = read.table(paste0(path,files[i]), header=T)
}
AutoCellCounter = do.call(rbind.data.frame, AutoCellCounter)
AutoCellCounter[,1] = gsub(".tif", "", AutoCellCounter[,1])
AutoCellCounter = separate(data=AutoCellCounter,
                           col=list,
                           into=c("Exp","cellLine", "timeDay","dye","wellNumbr","imgNumbr"),
                           sep="_")
tail(AutoCellCounter)

# Merge Manual and Automatic count data ####
CountData = rbind(manualCount, AutoCellCounter) %>%
  mutate(countMethod = c(rep("Manual",240),rep("Auto",16*240))) %>%
  mutate(manualCount = rep(manualCount$cellCount, 17)) %>%
  mutate(ratio = cellCount / manualCount) %>%
  mutate(imgIndex = rep(1:240, 17))
tail(CountData)

# Correlate manual and automatic count ####
Correlation = numeric()
foo = character()
for(i in 1:length(levels(CountData$thresholdMethod))){
  foo = filter(CountData, thresholdMethod == levels(CountData$thresholdMethod)[i])
  Correlation[i] = cor(manualCount$cellCount, foo$cellCount)
}
names(Correlation) = levels(CountData$thresholdMethod)

# thresholdMethod selection criteria is correlation with manual count
# top 5 best correlations
bestCorrel = Correlation[order(Correlation, decreasing = T)[1:6]]

# Filter good correlation  ####
CountData_filter = filter(CountData, thresholdMethod %in% names(bestCorrel))
tail(CountData_filter)

# CountData_wide = CountData_filter[,8:9] %>%
#   mutate(imgIndex=rep(1:240, 6)) %>%
#   spread(key=thresholdMethod, value=cellCount)
# tail(CountData_wide)

# Plot image count ####
g = ggplot(CountData_filter, aes(x=timeDay, y=cellCount, fill=thresholdMethod))
g + geom_boxplot() + facet_wrap(~ thresholdMethod) + guides(fill="none") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  scale_x_discrete(label=1:8)
ggsave("./plots/AutoCellCounter_Global.png", width=4, height=3, units="in")

# Filter CountData ####
# Huang = filter(CountData, thresholdMethod=="Huang")
# Li = filter(CountData, thresholdMethod=="Li")
# Triangle = filter(CountData, thresholdMethod=="Triangle")
# Percentile = filter(CountData, thresholdMethod=="Percentile")
# Mean = filter(CountData, thresholdMethod=="Mean")

# Ratio data ####
RatioData = select(CountData_filter, imgIndex, ratio, thresholdMethod) %>%
  spread(key = thresholdMethod, value = ratio)

# RatioData = data.frame(Manual = manualCount$cellCount/manualCount$cellCount,
#                        Huang = Huang$cellCount/manualCount$cellCount,
#                        Li = Li$cellCount/manualCount$cellCount,
#                        Triangle = Triangle$cellCount/manualCount$cellCount,
#                        Percentile = Percentile$cellCount/manualCount$cellCount,
#                        Mean = Mean$cellCount/manualCount$cellCount
# )

tail(RatioData)

# Plot correlation ####
r = ggplot(CountData_filter, aes(manualCount, cellCount, color=thresholdMethod))
r + geom_point() + geom_smooth(method="lm", color="black", linetype=2) +
  guides(color="none") +
  facet_wrap(~ thresholdMethod) +
  annotate(geom="text", x=400, y=50, label=paste("r =",round(bestCorrel,4))) +
  labs(x="Manual count (cells/image)", y="Automatic count (cells/image)") +
  theme_light()
ggsave("./plots/AutoCellCounter_Correlation.png", width=4, height=3, units="in")

# png("./plots/AutoCellCounter_Correlation.png", width=1200, height=900, res=150)
# {
#   par(mar=c(2,2,2,1), oma=c(2,2,0,0), mfrow=c(2,3), cex=1.1)
#   for(i in 3:ncol(CountData_wide)){
#     plot(CountData_wide[,2], CountData_wide[,i],
#          xlab="", ylab="", main=names(CountData_wide)[i],
#          xlim=c(1,240), ylim=c(1,240), yaxt="n", xaxt="n",
#          type="p", pch=21, col="black", bg=i
#     )
#     axis(1, at=c(0,50,100,150,200,240), labels=c("0","","100","","200",""))
#     axis(2, at=c(0,50,100,150,200,240), labels=c("0","","100","","200",""))
#     abline(lm(CountData_wide[,i] ~ CountData_wide[,2]),
#            lwd=2, lty=2, col="gray")
#     legend("bottomright", legend=paste("R =", round(bestCorrel[i-1],4)), bty="n")
#   }
#   mtext("Manual Count (image index)", side=1, outer=T)
#   mtext("Automatic Count (image index)", side=2, outer=T)
# }

# dev2bitmap("./plots/AutoCellCounter_Correlation.png", width=600, height=450,
#            units="px", pointsize = 8)

########## ########## ##########
# Since Huang Method presented the best correlation
# Let's see the distribution of the images w/ perfect count match.
# Perfect count match: Auto Count / Manual Count = 1
# And the distribution of the cells in the worst match.
# Worst matches are which.min and which.max(RatioData[,2])
########## ########## ##########

# Get the position of each cell from manual counts ####
library(XML)
pathXML = "./data/Exp19/XML/"
filesXML = dir(pathXML)
filesXML = filesXML[c(which(RatioData[,2] == 1)[c(2,4)], # two best images
                      which.min(RatioData[,2]), # two worst images
                      which.max(RatioData[,2])
                      )]

cellPositionManual = list()
doc = list()
rootNode = list()
xValues = list()
yValues = list()
for(i in 1:length(filesXML)){
  doc[[i]] = xmlTreeParse(paste0(pathXML,filesXML[i]), useInternalNodes = T)
  rootNode[[i]] = xmlRoot(doc[[i]])
  xValues[[i]] = xpathSApply(rootNode[[i]], "//MarkerX", xmlValue)
  yValues[[i]] = xpathSApply(rootNode[[i]], "//MarkerY", xmlValue)
  cellPositionManual[[i]] = data.frame(X=as.numeric(xValues[[i]]),
                                 Y=1536-as.numeric(yValues[[i]]))
}
tail(cellPositionManual[[1]])

# Get the position of each cell from AutoCellCounter Huang method ####
pathHuang = "./data/Exp19/AutoCellCounter_Global_v122/Huang/"
filesHuang = dir(pathHuang)
filesHuang = filesHuang[c(which(RatioData[,2] == 1)[c(2,4)], # two best images
                        which.min(RatioData[,2]), # two worst images
                        which.max(RatioData[,2])
                        )]

cellPositionHuang = list()
for(i in 1:length(filesHuang)){
  cellPositionHuang[[i]] = read.table(paste0(pathHuang, filesHuang[i]), header=T) %>%
    select(X,Y) %>% mutate(Y=1536-Y)
  # cellPositionHuang[[i]] = select(cellPositionHuang[[i]], X, Y) %>%
  #   mutate(Y=1536-Y)
  #cellPositionHuang[[1]] = mutate()
}
tail(cellPositionHuang[[1]])

# Merge cell postion data.frames ####
cellPositionHuang = bind_rows(cellPositionHuang, .id="imgListIndex")
cellPositionManual = bind_rows(cellPositionManual, .id="imgListIndex")
cellPosition = bind_rows(cellPositionManual, cellPositionHuang, .id="countMethod")
cellPosition[,1] = gsub("1", "Haung", cellPosition[,1])
cellPosition[,1] = gsub("2", "Manual", cellPosition[,1])
tail(cellPosition)
str(cellPosition)

# Plot the cell position (best match) ####
h = ggplot(cellPosition, aes(X, Y))
h + geom_point(aes(color=countMethod, alpha=.5)) + 
  facet_wrap(~imgListIndex) + # labeller = labeller = as.list(filesXML)
  scale_color_discrete(name="Count method") + guides(alpha="none") +
  theme_light() + theme(legend.position = "bottom",
                        axis.title = element_blank(),
                        axis.text=element_blank()) # suppress tick labels
ggsave("./plots/AutoCellCounter_CellPosition.png", width=4, height=3)

# par(mfrow=c(4,2), mar=c(2,1,1,1))
# for(i in 1:length(filesHuang)){
#   plot(cellPositionManual[[i]]$X, cellPositionManual[[i]]$Y,
#        xlim=c(0,1920), ylim = c(0,1536), cex=1.2, xaxt="n", yaxt="n",
#        xlab="", ylab="", main="")#paste0("imgIndex_",ratio1[i]))
#   
#   plot(cellPositionHuang[[i]]$X, cellPositionHuang[[i]]$Y, col="red",
#        xlim=c(0,1920), ylim = c(0,1536), cex=1.2, xaxt="n", yaxt="n",
#        xlab="", ylab="", main="")#paste0("imgIndex: ",ratio1[i]))
# }

# Plot the Ratio Data summary (average and deviation)
CountData_summary = select(CountData, thresholdMethod, ratio) %>%
  group_by(thresholdMethod) %>%
  summarise(mu=mean(ratio), sigma=sd(ratio))

rd = ggplot(CountData_summary, aes(thresholdMethod, mu))#, fill=thresholdMethod))
rd + geom_bar(stat="identity", color="black", width=.5, fill="red") + 
  geom_errorbar(aes(ymax=mu+sigma, ymin=mu-sigma), width=.25) +
  labs(x="Threshold methods", y="Ratio average") +
  annotate(geom="text", x=1:17, y=-.25, label=1:17) +
  theme_light() +
  theme(axis.text.x = element_blank())
ggsave("./plots/AutoCellCounter_Ratios.png", width=4, height=3)

save.image("Exp19_AutoCellCounter_v12.RData")
dev.off()
rm(list=ls())
