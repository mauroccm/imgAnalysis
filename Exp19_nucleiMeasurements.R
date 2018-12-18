# 
# 
# 
# Exp19_nucleiMeasurements
path = "results/2018-04-04_Exp19_nucleiMeasurements/"
nucleiMeasurements = read.table(paste0(path, "Exp19_nuclei_measurements.txt"),
                                header=T)

# The PDF of hacat nuclei area
densArea = density(nucleiMeasurements$Area)
densCirc = density(nucleiMeasurements$Circ.)

summary(nucleiMeasurements$Area)
summary(nucleiMeasurements$Circ.)
summary(nucleiMeasurements$Min)
summary(nucleiMeasurements$Max)

# estimate the particle size filter by Area ####
# probability of findinng a nucleus area >= 1000 px^2
pnorm(1000, 
      mean(nucleiMeasurements$Area), 
      sd(nucleiMeasurements$Area), 
      lower.tail = F) 

# what's nucleus area with probability > 0.9?
qnorm(.9,
      mean(nucleiMeasurements$Area), 
      sd(nucleiMeasurements$Area), 
      lower.tail = F) 

# plot distributions ####
cex=1.6
# hacaT_nucleiArea_distribution.png
{
  png("./docs/plots/hacaT_nucleiArea_distribution.png",
      width=8, height=6, units="in", res=300)
  plot(densArea, lwd=2, col="red", main="HaCaT nuclei area distribution",
       xlab="Nuclei area (pixel²)", #, ylab="density")
       cex.main=cex, cex.lab=cex,cex.axis=cex)
  polygon(c(980, densArea$x[densArea$x>=980]), 
          c(0, densArea$y[densArea$x>=980]),
          density=10, col="red", border="red")
  legend("topright", legend = c("AUC = 0.9"), bty="n", cex=cex)
  dev.off()
}

# estimate the particle size filter by Circularity ####
# probability of findinng a nucleus Circ. >= 0.6
pnorm(0.562, 
      mean(nucleiMeasurements$Circ.), 
      sd(nucleiMeasurements$Circ.), 
      lower.tail = F) 

# what's nucleus Circ. with probability > 0.9
qnorm(.9,
      mean(nucleiMeasurements$Circ.), 
      sd(nucleiMeasurements$Circ.), 
      lower.tail = F) 

# plot circularity density distribution
# hacaT_nucleiCirc_distribution.png
{
  png("./docs/plots/hacaT_nucleiCirc_distribution.png",
      width=8, height=6, units="in", res=300)
  plot(densCirc, lwd=3, col="red",
       main="HaCaT nuclei circ. distribution", xlab="Nuclei circularity",
       cex.main=cex, cex.lab=cex, cex.axis=cex)
  polygon(c(0.562, densCirc$x[densCirc$x>=0.6]), 
          c(0, densCirc$y[densCirc$x>=0.6]),
          density=10, col="red", border="red")
  legend("topleft", legend = c("AUC = 0.9"), bty="n", cex=cex)
  dev.off()
}

# end
save.image()
