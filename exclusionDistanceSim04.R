# Analysis of runo's Sim04 (ModelV2.java) result (data/sim04/out.txt)
# imgAnalysis, esferas com raios de exclusão

library(rgl); library(tidyverse)
sim04 = read.table('data/sim04/out.txt', header=T)
head(sim04); nrow(sim04) #just checking...

# Subset the hole data for plotting
# The system cant plot all the 129600 spheres
sim04.sub = subset(sim04, subset=(sim04[,1] >= 0 & sim04[,2] >= 0 & 
                          sim04[,1] < 50 & sim04[,2] < 50))
head(sim04.sub); nrow(sim04.sub)

# Define colors ####
cols=character()
for(i in 1:nrow(sim04.sub)){
  if(sim04.sub[i,"RADIUS"] == 1) {cols[i] = "red"} else {cols[i] = "blue"}
}
sim04.sub[,"COLS"] = cols
# other colors sugested are:
#   normal: "tan" (#D2B48C)
#   melanocyte: "tan4" (#8B5A2B)
#   melanoma: (#281E00)

# Plot 3D spheres ####
with(sim04.sub,
     spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS, width=512, height=512,
               shininess=50, xlim=c(0,100), ylim=c(0,100))
)
box3d(color = c("red","red"), emission="red", specular="red", shininess = 5)
axes3d(col="red")
title3d(main="sim04", xlab="X", ylab="Y", zlab="Z", col="red")

writeWebGL(dir="plots/sim04_out") #save as index.html
snapshot3d("plots/sim04_out.png")

# Table to identify cells w/ distance shorter than 1.5 ####
# require(fields)
sim04.sub.dist = fields::rdist(sim04.sub[,1:3])

bar = data.frame(
  linhas = which(sim04.sub.dist < 1.5 & sim04.sub.dist != 0) %% nrow(sim04.sub.dist),
  colunas = which(sim04.sub.dist < 1.5 & sim04.sub.dist != 0) %/% nrow(sim04.sub.dist) + 1
)
bar

sim04[,"cellType"] = factor(sim04$RADIUS, labels = c("type1","type2"))

# Check the cell layer ####
# Does the cell with shorter radius is at the bottom?
t.test(sim04$Z ~ sim04$cellType, paired=F, var.equal=F)
wilcox.test(Z ~cellType, data=sim04)

g = ggplot(sim04, aes(x=cellType, y=Z, fill=cellType))
g + geom_boxplot() + theme_light() + ylim(0,20) +
  annotate("text", x=1.5, y=20, label="***") +
  annotate("text", x=1.5, y=18, label="p < 2.2e-16") +
  annotate("segment", x=1, xend=2, y=19, yend=19) +
  scale_fill_discrete(name="Cell radius (a.u.)", labels=c("0.5","1"))
  
# "plots/sim04_height.png"


