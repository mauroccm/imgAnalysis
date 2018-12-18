# Close-packing solid spheres
# https://en.wikipedia.org/wiki/Close-packing_of_equal_spheres
# 
# 
# Mauro Morais, 2018-11-28
library("rgl")

outDir = "results/2018-11-30/"

rad1 = 0.5
rad2 = 1
a = sqrt(3)
# h = sqrt(3)/2

# red spheres positions, n=25
X = c(1, 3, 5 ,7, 9,
      2, 4, 6, 8, 10,
      1, 3, 5, 7, 9,
      2, 4, 6, 8, 10,
      1, 3, 5, 7, 9)

Y = c(1, 1, 1, 1, 1,
      1+a, 1+a, 1+a, 1+a, 1+a,
      1+2*a, 1+2*a, 1+2*a, 1+2*a, 1+2*a,
      1+3*a, 1+3*a, 1+3*a, 1+3*a, 1+3*a,
      1+4*a, 1+4*a, 1+4*a, 1+4*a, 1+4*a)

# Z = c(rep(1,16),
#       1+a, 1+a, 1+a, 1+a)      

# blue spheres positions, n=25
m = X/2
n = Y/2

# blue spheres positions, n=100
x = c(0:9+.5, 1:10,
      0:9+.5, 1:10,
      0:9+.5, 1:10,
      0:9+.5, 1:10,
      0:9+.5, 1:10,
      rep(10,5))

y = c(rep(0.5, 10),
      rep(a*.5+.5, 10),
      rep(2*a*.5+.5, 10),
      rep(3*a*.5+.5, 10),
      rep(4*a*.5+.5, 10),
      rep(5*a*.5+.5, 10),
      rep(6*a*.5+.5, 10),
      rep(7*a*.5+.5, 10),
      rep(8*a*.5+.5, 10),
      rep(9*a*.5+.5, 10),
      1*a*0.5+0.5, 
      3*a*0.5+0.5, 
      5*a*0.5+0.5, 
      7*a*0.5+0.5, 
      9*a*0.5+0.5)
      
# 3D sphere plot
# radius = 1
spheres3d(X, Y, z=1, radius=rad2, col="red")
title3d(sub="n=25")
axes3d()
snapshot3d(paste0(outDir, "packingEqualSpheres2.png"))
modMatrix = par3d()$userMatrix

# radius = 0.5 e n = 105
spheres3d(x, y, z=1, radius=rad1, col="blue")
title3d(sub="n=105")
axes3d()
par3d(userMatrix = modMatrix)
snapshot3d(paste0(outDir, "packingEqualSpheres1.png"))

# radius = 0.5 e n = 25
spheres3d(m, n, z=1, radius = rad1, col="blue", 
          xlim=c(0,10), ylim=c(0,10), zlim=c(0,2))
title3d(sub="n=25")
axes3d()
# axis3d(edge="bbox")#, at=c(0,2,4,6,8,10), nticks=6)
par3d(userMatrix = modMatrix)
snapshot3d(paste0(outDir, "packingEqualSpheres1_n25.png"))

# axes3d(c('x--', 'x-+', 'x+-', 'x++'))

foo=data.frame(X,Y) # red spheres positions
bar=data.frame(x,y) # blue spheres positions
zed=data.frame(m,n) # blue spheres positions n=25

# distance distribution of regular hexagonal 
png(paste0(outDir, "packingEqualSpheres_distanceDistribution.png"),
    width=640, height=480, units="px")
par(cex=1.5)
plot(density(dist(foo)), lwd=4, col="red", 
     xlim=c(0,14), ylim=c(0,0.4),
     # cex=1.5,
     xlab="Distance (a.u.)",
     main="Distance distribution of close-packing of equal spheres")
lines(density(dist(bar)), lwd=4, col="blue")
lines(density(dist(zed)), lwd=4, lty=2, col="blue")
legend("topright", bty="n",
       lwd=4, col=c("red", "blue", "blue"), lty=c(1,1,2),
       legend=c("r = 1, n = 25", "r = 0.5, n = 105", "r = 0.5, n = 25"))
dev.off()

save.image("packingSpheres.RData")
