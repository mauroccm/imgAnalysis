# imgAnalysis, esferas com raios de exclusão
library(rgl); library(tidyverse)

# Variables ####
mainTitle = "sim06"
inputDate = "2018-02-23"
outputDate = "2018-05-11"
RADIUS = 2 # min. sphere radius (distance)

# Read the results table from Bruno simulation ####
simOut = read.table(paste("data", inputDate, mainTitle, "out.txt", sep="/"),
                    header=T)

# sim02.c1 = read.table('data/2017-12-13/sim02/out_0.5538236458328383.txt', 
#                       header=T)
# sim02.c2 = read.table('data/2017-12-13/sim01/out_1.2000739531892701.txt', 
#                       header=T)
# sim02.c3 = read.table('data/2017-12-13/sim01/out_1.8658456729358734.txt', 
#                       header=T)
# simOut = rbind(sim02.c1, sim02.c2, sim02.c3)

head(simOut); nrow(simOut); sqrt(nrow(simOut)) #just checking...

# Subset the data ####
# Subset the simOut data for plotting
# The system cant plot all the spheres
simOut.sub = filter(simOut, X >= 0, X < 50, Y >= 0, Y < 50, Z <= 7)
head(simOut.sub); nrow(simOut.sub)

# Define colors ####
# cols = "blue"
cols=character()
for(i in 1:nrow(simOut.sub)){
  if(simOut.sub[i,"RADIUS"] == 2) {cols[i] = "red"} else {cols[i] = "blue"}
}
simOut.sub[,"COLS"] = cols

# other colors sugested are:
#   normal: "tan" (#D2B48C) RGB: (210, 180, 140)
#   melanocyte: "tan4" (#8B5A2B) RGB: (139, 90, 43)
#   melanoma: (#281E00) RGB: (40 ,30 ,0)

# Plot 3D spheres ####
with(simOut.sub,
     spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS, width=512, height=512,
               shininess=50, xlim=c(0,100), ylim=c(0,100))
     )
box3d(color = c("red","red"), emission="red", specular="red", shininess = 0)
axes3d(col="red")
title3d(main=mainTitle, xlab="X", ylab="Y", zlab="Z", col="red")

# writeWebGL(dir=paste("results", outputDate, mainTitle, sep="/")) #save as index.html
rglwidget()

snapshot3d(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle, ".png"))

view3d(0,0) # the XY projection
snapshot3d(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle, "_XY.png"))

view3d(0,-90) # the XZ projection
snapshot3d(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle, "_XZ.png"))

view3d(-90, 0) # the YZ projection
snapshot3d(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle, "_YZ.png"))

# Table to identify cells w/ distance shorter than 1 ####
# Does the spheres are overlapping? Which ones?
require(fields)
simOut.sub.dist = fields::rdist(simOut.sub[,1:3]) #

simOut.sub.dist.table = data.frame(
  row = which(simOut.sub.dist < RADIUS & simOut.sub.dist != 0) %% nrow(simOut.sub.dist),
  column = (which(simOut.sub.dist < RADIUS & simOut.sub.dist != 0) %/% nrow(simOut.sub.dist)) + 1
)
head(simOut.sub.dist.table) # which spheres are overlapping?
# simOut.sub.dist[1:5,1:5]

# Check the cell layer ####
# Does the cell with shorter radius is at the top/bottom?
simOut = filter(simOut, Z <= 7, Z >= 1) %>%
  mutate(cellType = as.factor(RADIUS))
# simOut.sub = mutate(simOut.sub, cellType = as.factor(RADIUS))
t.test(simOut$Z ~ simOut$cellType, paired=F, var.equal=F)
wilcox.test(Z ~ cellType, data=simOut)

g = ggplot(simOut, aes(x=RADIUS, y=Z, fill=cellType))
g + geom_boxplot() + theme_light() + ylim(0,8) +
  # annotate("text", x=1.5, y=11, label="n.s.") +
  # annotate("text", x=1.5, y=9, label="t-test, p = 4.4e-05") +
  # annotate("segment", x=1, xend=2, y=10, yend=10) +
  scale_fill_discrete(name="Cell radius (a.u.)", labels=c("1","2"))

# sim06_height.png
res=150
ggsave(paste0("results/", outputDate, "/", mainTitle, "/sim06_height.png"),
       width=800/res, height=600/res, unit="in", dpi=res)

save.image(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle, 
                  ".RData"))
