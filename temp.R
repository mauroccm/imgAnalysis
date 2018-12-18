# Close-packing solid spheres
# https://en.wikipedia.org/wiki/Close-packing_of_equal_spheres
# 
# 
# Mauro Morais, 2018-11-28
library("rgl")

radius = 1
a = sqrt(3)
# h = sqrt(3)/2

X = c(1, 3, 5 ,7, 9,
      2, 4, 6, 8, 10,
      1, 3, 5, 7, 9,
      2, 4, 6, 8, 10,
      1, 3, 5, 7, 9)
      # 2, 4, 6, 8)
Y = c(1, 1, 1, 1, 1,
      1+a, 1+a, 1+a, 1+a, 1+a,
      1+2*a, 1+2*a, 1+2*a, 1+2*a, 1+2*a,
      1+3*a, 1+3*a, 1+3*a, 1+3*a, 1+3*a,
      1+4*a, 1+4*a, 1+4*a, 1+4*a, 1+4*a)
      # 1+h, 1+h, 1+h, 1+h)
# Z = c(rep(1,16),
#       1+a, 1+a, 1+a, 1+a)      

x=X/2
y=Y/2

spheres3d(X, Y, z=1, radius=1, col="red")
spheres3d(x, y, z=1, radius=0.5, col="blue")
title3d(sub="n=25")
axes3d()
snapshot3d("plots/packingEqualSpheres.png")

foo=data.frame(X,Y)
bar=data.frame(x,y)

png("plots/packingEqualSpheres_distanceDistribution.png",
    width=640, height=480, units="px")
par(cex=1.5)
plot(density(dist(foo)), lwd=4, col="red", 
     xlim=c(0,14), ylim=c(0,0.4),
     # cex=1.5,
     xlab="Distance (a.u.)",
     main="Distance distribution of close-packing of equal spheres")
lines(density(dist(bar)), lwd=4, col="blue")
legend("topright", bty="n",
       lwd=4, col=c("red", "blue"),
       legend=c("r = 1", "r = 0.5"))

dev.off()
