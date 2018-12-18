# Identify density of cells based on dimension reduction algorithm
img = read.table("data/Exp16_day04_HOE_W1_001.txt",
               header=T)
foo = as.matrix(img)
dim(foo)

# scale img
fooScale = scale(foo)

# single value decomposition
fooSvd = svd(fooScale)

# image approx
fooReduction = with(fooSvd, outer(u[,1], v[,1]))

# Plots ####
par(mfrow = c(1, 2))
image(t(foo[nrow(foo):1, ]), main="Original image",
      col=gray(seq(0,1,length.out = 255)))
image(t(fooReduction[nrow(fooReduction):1, ]), main="Reduced image",
      col=gray(seq(0,1,length.out = 255)))

# Singular components
plot(fooSvd$u[,1], nrow(foo):1, 
     ylab = "Row", xlab = "First left singular vector",pch = 19)

plot(fooSvd$v[,1],
     xlab = "Column", ylab = "First right singular vector", pch = 19)

