# análise da distribuição das distâncias de núcleos das imagens Exp19 day08.

# Distribuition of the distances of nuclei NOT counting the edges
inDir = "results/2018-08-29/EDTMaxCount/"
outDir = "results/2018-08-29/distance_analysis/"

inFiles = dir(inDir)

positions = list()
distances = list()
histogramsDistances = list()
histogramsAreas = list()

for(i in 1:length(inFiles)){

  positions[[i]] = read.table(paste0(inDir, inFiles[i]), 
                              header=T)[,c("Area", "X", "Y", "Perim.")]
  
  # calculate the distance matrix
  distances[[i]] = dist(positions[[i]][c("X","Y")])
  
  # the distribution of the distances
  histogramsDistances[[i]] = hist(distances[[i]],
                               breaks=25, include.lowest=T, right=F,
                               plot=F)
  
  # the distribution of the areas
  histogramsAreas[[i]] = hist(positions[[i]][,"Area"],
                              breaks=30, include.lowest=T, right=F,
                              plot=F)
                               # col="darkgreen",
                               # main=inFiles[i],
                               # xlab="ditance", ylab="cell count")
}

# str(histogramsDistances[[1]])
# str(histogramsAreas[[1]])
# sum(histogramsAreas[[1]]$counts)

# plot the histograms ####
plot(histogramsAreas[[15]], col="darkgreen", main="Area distribution",
     xlim=c(0,30000), ylim=c(0,max(histogramsAreas[[15]]$counts)),
     xlab="Area (px²)", ylab="Counts")

plot(histogramsDistances[[15]], col="darkgreen", main="Distances distribution",
     xlim=c(0,2500), ylim=c(0,max(histogramsDistances[[15]]$counts)),
     xlab="Distance (px)", ylab="Counts")

# plot the frequency
AreasFreq = list()
distancesFreq = list()

for(i in 1:30){
  AreasFreq[[i]] = histogramsAreas[[i]]$counts / sum(histogramsAreas[[i]]$counts)
  distancesFreq[[i]] = histogramsDistances[[i]]$counts / sum(histogramsDistances[[i]]$counts)
}

plot(histogramsAreas[[1]]$mids, AreasFreq[[1]],
     type="l", lwd=2, col="darkgreen", main="Area distribution",
     xlim=c(0,30000), ylim=c(0,0.35),
     xlab="Area (px²)", ylab="frequency")
for(i in 2:30){
  lines(histogramsAreas[[i]]$mids, AreasFreq[[i]],
        lwd=2, col="darkgreen")
}

plot(histogramsDistances[[1]]$mids, distancesFreq[[1]],
     type="l", lwd=2, col="darkgreen", main="Distance distribution",
     xlim=c(0,2500), ylim=c(0,0.1),
     xlab="Distance (px²)", ylab="frequency")
for(i in 2:30){
  lines(histogramsDistances[[i]]$mids, distancesFreq[[i]],
        lwd=2, col="darkgreen")
}

