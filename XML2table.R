# XML2table.R
# Convert the XML count data to a TXT table.
# <!-- UNDER REVISION -->
# Mauro, 2018-04-20

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

# Get the position of each cell from autoCounter Huang method ####
pathHuang = "./data/Exp19/autoCounter_Global_v122/Huang/"
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
ggsave("./plots/autoCounter_CellPosition.png", width=4, height=3)

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
ggsave("./plots/autoCounter_Ratios.png", width=4, height=3)

save.image("Exp19_autoCounter_v12.RData")
dev.off()
rm(list=ls())