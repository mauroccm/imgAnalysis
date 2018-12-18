# Script para análise das projeções das simulações

library(rgl); library(data.table); library(tidyverse)

# variables
mainTitle = "sim06"
outputDate = "2018-08-14"

# input data from the sim06 output
simOut = fread("data/2018-02-23/sim06/out.txt", header=T) %>%
  filter(Z <=7)

# set the colors
cols=character()
for(i in 1:nrow(simOut)){
  if(simOut[i,"RADIUS"] == 2) {cols[i] = "red"} else {cols[i] = "blue"}
}
simOut[,"COLS"] = cols

# subsetting the data into 16 fields
simOut.sub = list()
simOut.sub[[1]] = filter(simOut, X >=   0, X < 100, Y >= 0, Y < 100)
simOut.sub[[2]] = filter(simOut, X >= 100, X < 200, Y >= 0, Y < 100)
simOut.sub[[3]] = filter(simOut, X >= 200, X < 300, Y >= 0, Y < 100)
simOut.sub[[4]] = filter(simOut, X >= 300, X < 400, Y >= 0, Y < 100)
simOut.sub[[5]] = filter(simOut, X >=   0, X < 100, Y >= 100, Y < 200)
simOut.sub[[6]] = filter(simOut, X >= 100, X < 200, Y >= 100, Y < 200)
simOut.sub[[7]] = filter(simOut, X >= 200, X < 300, Y >= 100, Y < 200)
simOut.sub[[8]] = filter(simOut, X >= 300, X < 400, Y >= 100, Y < 200)
simOut.sub[[9]] = filter(simOut, X >=   0, X < 100, Y >= 200, Y < 300)
simOut.sub[[10]] = filter(simOut, X >= 100, X < 200, Y >= 200, Y < 300)
simOut.sub[[11]] = filter(simOut, X >= 200, X < 300, Y >= 200, Y < 300)
simOut.sub[[12]] = filter(simOut, X >= 300, X < 400, Y >= 200, Y < 300)
simOut.sub[[13]] = filter(simOut, X >=   0, X < 100, Y >= 300, Y < 400)
simOut.sub[[14]] = filter(simOut, X >= 100, X < 200, Y >= 300, Y < 400)
simOut.sub[[15]] = filter(simOut, X >= 200, X < 300, Y >= 300, Y < 400)
simOut.sub[[16]] = filter(simOut, X >= 300, X < 400, Y >= 300, Y < 400)

simCellCount = numeric()
for(i in 1:length(simOut.sub)) simCellCount[i] = nrow(simOut.sub[[i]])

# simOut for IJ
# simOut_filter = filter(simOut, X < 400, Y < 400)
# write.table(simOut_filter,
#             paste0("results/", outputDate, "/simOutAll.txt"),
#             quote=F, row.names=F, sep="\t")

# count of the number of cells in the sim06
simCellCountData = data.frame( # simulation cell count data
  imgIndex = 1:16,
  cellCount = simCellCount
)

# save the results
dput(simOut.sub, paste0("results/", outputDate, "/simOutSub.txt"))
write.table(simCellCountData, 
            paste0("results/", outputDate, "/simCellCountData.txt"),
            row.names=F)
for(i in 1:length(simOut.sub)){
  write.table(simOut.sub[[i]], 
              paste0("results/", outputDate, "/SIM_cellPositions/simOutSub_", 
                     i, ".txt"),
              row.names=F, sep="\t", quote=F)
}

# plots ####
for(i in 1:16){
  light=F # light the materials?
  r3dDefaults$bg$color = "black" # set the bg color
  par3d(windowRect = c(700, 150, 1212, 662)) # to plot at 512 x 512 px
  # open3d()
  view3d(theta=0, phi=0); par3d(zoom=0.62) # set up the view plane
  material3d(lit=light, specular="#000000")
  # decorate3d(col="white")
  # light3d(theta=0, phi=0, ambient="#000000", 
  #         diffuse="#000000", specular="#000000")
  # rgl.light(theta=0, phi=0, viewpoint.rel=F)
  ids = with(simOut.sub[[i]],
             spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS,
                       shininess=128, forceClipregion=T)["clipplanes"]
  )
  
  # box3d(color="red", shininess=100)
  
  # Sys.sleep(2) # Wait plot before save
  
  snapshot3d(paste0("results/", outputDate, "/",mainTitle,
                    "_XYProjection_field", LETTERS[i], ".png"))
  
  rgl.close()
}


save.image()
