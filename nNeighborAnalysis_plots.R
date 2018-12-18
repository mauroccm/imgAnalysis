# nNeighborAnalysis_plots.R
library(tidyverse)
load("nNeighborAnalysis.RData")

outDir = paste0("results/", expDate, "/plots/")

# All cells ####
# numbr of neighbors distribuiton plot
G=ggplot(numbrNeighborsData.summary, aes(x=numbrNeighbors, y=countMean))+
  geom_col(width=0.8)+
  geom_errorbar(aes(ymin=countMean-countSd, ymax=countMean+countSd), width=0.6)+
  theme_minimal()+
  labs(x="Numbr. of neighbors", y="Average count per image")+
  scale_x_continuous(breaks=1:13, labels=1:13)+
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 14)
  )
# png(paste0(outDir, "numbrNeighborsDistribution.png"), width=640, height=640)
plot(G)
# dev.off()

# numbr of neighbors vs frequency distributions
# png(paste0(outDir, "numbrNeighborsFrequency.png"), width=640, height=480)
plot(x=as.numeric(names(numbrNeighborsFreq[[1]])),
     y=numbrNeighborsFreq[[1]],
     type="l", col="darkgreen", lwd=2, 
     xlim=c(0,12), ylim=c(0,0.4),
     xlab="Number of Neighbors", ylab="Frequency")
axis(2, at=c(0,0.1,0.2,0.3,0.4), c(0,0.1,0.2,0.3,0.4))
for(i in 2:length(inFiles)){
  lines(
    x=as.numeric(names(numbrNeighborsFreq[[i]])),
    y=numbrNeighborsFreq[[i]], lwd=2, col="darkgreen")
}
legend("topright", bty="n",
       legend=paste("S = ", round(entropyMean, 2), " ± ", round(entropySd,2) ))
# dev.off()

# Numbr of neighbors vs area plot
yLab = expression(paste("Area (", mu, "m²)"))

# png(paste0(outDir, "numbrNeighborsArea.png"), width=640, height=480)
boxplot(ALL$Area ~ ALL$neighborArray,
        col="gray30", main="",
        xlab="Numbr. of neighbors", ylab=yLab)
# dev.off()

# Selected cells (edge-excluded) ####

# numbr of neighbors vs counts
selectedG = ggplot(selecetedCellsData.summary, aes(x=numbrNeighbors, y=countMean))+
  geom_col(width=0.8)+
  geom_errorbar(aes(ymin=countMean-countSd, ymax=countMean+countSd), width=0.6)+
  theme_minimal()+
  scale_x_continuous(breaks=2:13, labels=2:13)+
  labs(x="Numbr. of neighbors", y="Average count per image")+
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 14)
  )
plot(selectedG)
ggsave(path=outDir, filename="selectedCellsDistribution.png", device="png",
       width = 8, height = 6, units = "in")
dev.off()

# numbr of neighbors vs frequency
cex=1.5
{
  png(paste0(outDir, "selectedCellsFrequency.png"), width=8, height=6,
      units="in", res=300)
  plot(x=as.numeric(names(selectedCellsFreq[[1]])),
       y=selectedCellsFreq[[1]],
       col="darkgreen", type="l", lwd=2,
       cex.main=cex, cex.lab=cex,cex.axis=cex,
       xlim=c(2,12), ylim=c(0,0.45),
       xlab="Number of Neighbors", ylab="Frequency")
  for(i in 2:length(selectedCellsFreq)){
    lines(x=as.numeric(names(selectedCellsFreq[[i]])),
          y=selectedCellsFreq[[i]], lwd=3, col="darkgreen")
  }
  axis(2, c(0,.1,.2,.3,.4), c(0,0.1,0.2,0.3,0.4))
  legend("topright", bty="n", cex=cex,
         legend=paste("S = ", round(selectedCellsEntropyMean, 2), " ± ",
                      round(selectedCellsEntropySd,2) ))
  dev.off()
}

# numbr of neighbors vs area
{
  png(paste0(outDir, "selectedCellsArea.png"), 
      width=8, height=6, units="in", res=300)
  boxplot(selectedCellsResults$Area*(scale^2) ~ selectedCellsResults$markedNeighborArray,
          col="gray30", main="",
          xlab="Numbr. of neighbors", ylab=yLab,
          cex.main=cex, cex.lab=cex, cex.axis=cex)
  dev.off()
}
