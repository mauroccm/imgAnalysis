# Analysis of Bruno's sim05 (ModelV2.java) result (data/sim05/out.txt)
# imgAnalysis, esferas com raios de exclusão

library(rgl); library(tidyverse)
sim05 = read.table('data/sim05/out.txt', header=T)
head(sim05); nrow(sim05) #just checking...

# Subset the hole data for plotting
# The system cant plot all the 129600 spheres
sim05.sub = subset(sim05, subset=(sim05[,1] >= 0 & sim05[,2] >= 0 & 
                                    sim05[,1] < 50 & sim05[,2] < 50))
head(sim05.sub); nrow(sim05.sub)

# Define colors ####
cols=character()
for(i in 1:nrow(sim05.sub)){
  if(sim05.sub[i,"RADIUS"] == 2) {cols[i] = "red"} else {cols[i] = "blue"}
}
sim05.sub[,"COLS"] = cols
# other colors sugested are:
#   normal: "tan" (#D2B48C)
#   melanocyte: "tan4" (#8B5A2B)
#   melanoma: (#281E00)

# Plot 3D spheres ####
with(sim05.sub,
     spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS, width=512, height=512,
               shininess=50, xlim=c(0,100), ylim=c(0,100))
)
box3d(color = c("red","red"), emission="red", specular="red", shininess = 5)
axes3d(col="red")
title3d(main="sim05", xlab="X", ylab="Y", zlab="Z", col="red")

writeWebGL(dir="plots/sim05_out") #save as index.html
snapshot3d("plots/sim05_out.png")

# Table to identify cells w/ distance shorter than 1.5 ####
# require(fields)
sim05.sub.dist = fields::rdist(sim05.sub[,1:3])

bar = data.frame(
  linhas = which(sim05.sub.dist < 1.5 & sim05.sub.dist != 0) %% nrow(sim05.sub.dist),
  colunas = which(sim05.sub.dist < 1.5 & sim05.sub.dist != 0) %/% nrow(sim05.sub.dist) + 1
)
bar

sim05[,"cellType"] = factor(sim05$RADIUS, labels = c("type1","type2"))

# Check the cell layer ####
# Does the cell with shorter radius is at the bottom?
t.test(sim05$Z ~ sim05$cellType, paired=F, var.equal=F)
wilcox.test(Z ~ cellType, data=sim05)

g = ggplot(sim05, aes(x=cellType, y=Z, fill=cellType))
g + geom_boxplot() + theme_light() + ylim(0,20) +
  annotate("text", x=1.5, y=20, label="n.s.") +
  annotate("text", x=1.5, y=18, label="p = 0.02067") +
  annotate("segment", x=1, xend=2, y=19, yend=19) +
  scale_fill_discrete(name="Cell radius (a.u.)", labels=c("1","2"))

# "plots/sim05_height.png"


