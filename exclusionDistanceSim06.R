# Analysis of Bruno's sim06 (StaticModel.zip) result (data/sim06/out.txt)
# data was sent on 2018-02-22.
# imgAnalysis, esferas com raios de exclusão

library(rgl); library(tidyverse)
sim06 = read.table('data/sim06/out.txt', header=T)
head(sim06); nrow(sim06) #just checking...

# Subset the hole data for plotting
# The system cant plot all the 129600 spheres
sim06.sub = subset(sim06, subset=(sim06[,1] >= 0 & sim06[,2] >= 0 & 
                                    sim06[,1] < 50 & sim06[,2] < 50))
head(sim06.sub); nrow(sim06.sub)

# Define colors ####
cols=character()
for(i in 1:nrow(sim06.sub)){
  if(sim06.sub[i,"RADIUS"] == 2) {cols[i] = "red"} else {cols[i] = "blue"}
}
sim06.sub[,"COLS"] = cols
# other colors sugested are:
#   normal: "tan" (#D2B48C)
#   melanocyte: "tan4" (#8B5A2B)
#   melanoma: (#281E00)

# Plot 3D spheres ####
with(sim06.sub,
     spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS, width=512, height=512,
               shininess=50, xlim=c(0,100), ylim=c(0,100))
)
box3d(color = c("red","red"), emission="red", specular="red", shininess = 5)
axes3d(col="red")
title3d(main="sim06", xlab="X", ylab="Y", zlab="Z", col="red")

writeWebGL(dir="plots/sim06_out") #save as index.html
snapshot3d("plots/sim06_out.png")

# Table to identify cells w/ distance shorter than 1.5 ####
# require(fields)
sim06.sub.dist = fields::rdist(sim06.sub[,1:3], compact=T)
sim06.sub.dist.type1 = fields::rdist(sim06.sub[sim06.sub$COLS == 'blue', 1:3])
sim06.sub.dist.type2 = fields::rdist(sim06.sub[sim06.sub$COLS == 'red', 1:3])

bar = data.frame(
  linhas = which(sim06.sub.dist < 1.5 & sim06.sub.dist != 0) %% nrow(sim06.sub.dist),
  colunas = which(sim06.sub.dist < 1.5 & sim06.sub.dist != 0) %/% nrow(sim06.sub.dist) + 1
)
bar

sim06[,"cellType"] = factor(sim06$RADIUS, labels = c("type1","type2"))

# Check the cell layer ####
# Does the cell with shorter radius is at the bottom?
t.test(sim06$Z ~ sim06$cellType, paired=F, var.equal=F)
wilcox.test(Z ~ cellType, data=sim06)

g = ggplot(sim06, aes(x=cellType, y=Z, fill=cellType))
g + geom_boxplot() + theme_light() + ylim(0,10) +
  # annotate("text", x=1.5, y=10.1, label="n.s.") +
  annotate("text", x=1.5, y=10, label="n.s., p = 0.7911") +
  annotate("segment", x=1.1, xend=1.9, y=9.6, yend=9.6) +
  scale_fill_discrete(name="Cell radius (a.u.)", labels=c("1","2"))

# "plots/sim06_height.png"

# Estimate distances distribution ####
sim06.sub.dist.dens = density(sim06.sub.dist)
sim06.sub.dist.type1.dens = density(sim06.sub.dist.type1)
sim06.sub.dist.type2.dens = density(sim06.sub.dist.type2)

plot(sim06.sub.dist.dens, lwd=3, col='black',
     main="Distances distribution", ylim=c(0,0.03), 
     # ylim based on max(sim06.sub.dist.type1.dens$y)
     xlab="Distance (A.U.)", ylab="Probability") 
lines(sim06.sub.dist.type1.dens, lwd=3, col='blue')
lines(sim06.sub.dist.type2.dens, lwd=3, col='red')
