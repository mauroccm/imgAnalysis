# Exp19_nucleiMeasurements
path = "results/2018-04-04/"
nucleiMeasurements = read.table(paste0(path, "Exp19_nuclei_measurements.txt"),
                                header=T)

# The PDF of hacat nuclei area
densArea = density(nucleiMeasurements$Area)
densCirc = density(nucleiMeasurements$Circ.)

summary(nucleiMeasurements$Area)
summary(nucleiMeasurements$Circ.)

# estimate the particle size filter by Area ####
# probability of findinng a nucleus area >= 1000 px^2
pnorm(1000, 
      mean(nucleiMeasurements$Area), 
      sd(nucleiMeasurements$Area), 
      lower.tail = F) 

# what's nucleus area with probability > 0.9
qnorm(.9,
      mean(nucleiMeasurements$Area), 
      sd(nucleiMeasurements$Area), 
      lower.tail = F) 

# plot area density distribution
# hacaT_nucleiArea_distribution.png
plot(densArea, lwd=2, col="red", main="HaCaT nuclei area distribution")
polygon(c(980, densArea$x[densArea$x>=980]), 
        c(0, densArea$y[densArea$x>=980]),
        density=10, col="red", border="red")
legend("topright", legend = c("AUC = 0.9"), bty="n")

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
plot(densCirc, lwd=2, col="red", main="HaCaT nuclei circ. distribution")
polygon(c(0.562, densCirc$x[densCirc$x>=0.6]), 
        c(0, densCirc$y[densCirc$x>=0.6]),
        density=10, col="red", border="red")
legend("topleft", legend = c("AUC = 0.9"), bty="n")
save.image()
