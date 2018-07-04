library(rgl); library(tydiverse)

##############################
X = rep(seq(1, 50, by=2), each=50)
Y = rep(seq(1, 50, by=2), 50)
Z = rep(1, 1250)

foo = data.frame(X = X, Y = Y, Z = Z, 
                 RADIUS = rep(1, 1250), COLS = rep("blue", 1250))
foo = unique(foo)
set.seed(42);foo[, "Z"] = runif(nrow(foo), 1, 7)
set.seed(42);foo[, "X"] = foo$X * runif(nrow(foo), .95, 1.05)
set.seed(42);foo[, "Y"] = foo$Y * runif(nrow(foo), .95, 1.05)

# plot 3D ####
with(foo,
     spheres3d(x=X, y=Y, z=Z, radius=RADIUS, col=COLS, width=512, height=512,
               shininess=50)#, xlim=c(0,100), ylim=c(0,100))
)
view3d(0,0); par3d(zoom=0.64) # set up the view plane

# Table to identify cells w/ distance shorter than 1 ####
# Does the spheres are overlapping? Which ones?
require(fields)
foo.dist = fields::rdist(foo[,1:3]) #

foo.dist.table = data.frame(
  row = which(foo.dist < 2 & foo.dist != 0) %% nrow(foo.dist),
  column = (which(foo.dist < 2 & foo.dist != 0) %/% nrow(foo.dist)) + 1
)
head(foo.dist.table) # which spheres are overlapping?
