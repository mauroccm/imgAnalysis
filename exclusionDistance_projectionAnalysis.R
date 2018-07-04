library(rgl); library(data.table); library(tidyverse)

# variables
mainTitle = "sim06"
outputDate = "2018-05-14"

# input data from the sim06 output
simOut = fread("data/2018-02-23/sim06/out.txt", header=T) %>%
  filter(Z <=7)

# set the colors
cols=character()
for(i in 1:nrow(simOut)){
  if(simOut[i,"RADIUS"] == 2) {cols[i] = "red"} else {cols[i] = "blue"}
}
simOut[,"COLS"] = cols

# subsetting the data
simOut.sub = filter(simOut, X >= 0, X < 100, Y >= 0, Y < 100)
write.table(simOut.sub, "results/2018-05-14/sim06/simOutSub.csv", 
            row.names=F)

# plots
light=T # light the materials?
r3dDefaults$bg$color = "black" # set the bg color
par3d(windowRect = c(700, 150, 1212, 662)) # to plot at 512 x 512 px
# open3d()
view3d(theta=0, phi=0); par3d(zoom=0.62) # set up the view plane
material3d(lit=light, specular="#000000")
# decorate3d(col="white")
# light3d(theta=0, phi=0, ambient="#000000", 
#         diffuse="#000000", specular="#000000")
# rgl.light(theta=0, phi=0, viewpoint.rel=F)
ids = with(simOut.sub,
           spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS,
                     shininess=128, forceClipregion=T)["clipplanes"]
)

if(light){
  for(i in 8:1){
    clipplanes3d(0,0,-1, i) # insert clipping at height=d
    snapshot3d(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle,
                      "_XYAnalysisProjection_height", i, ".png"))
  }
  
} else {
  for(i in 8:1){
    clipplanes3d(0,0,-1, i) # insert clipping at height=d
    snapshot3d(paste0("results/", outputDate, "/", mainTitle, "/", mainTitle,
                      "_XYAnalysisProjection_matte_height", i, ".png"))
  }
  
}
clipplanes3d(0,0,-1, 4)
# planes3d(0,0,1,-4, color="green", alpha=1) # plot a plane in the box

# k = scene3d()
# widget = rglwidget(k) %>%
#   playwidget(clipplaneControl(d = c(0, 7), clipplaneids = ids["clipplanes"]),
#              start = 0, stop = 1, step = 0.01, rate = 0.5)


rgl.close()
# plot3d(k)

save.image()
