## Identify density of cells in a 192 x 154 pixel area recursively
# Variables ####
path = "data/Exp16_TXT/" # input
outPath = "data/Exp16_tileCount/" # output
files = dir(path)

n = 10 # numbr of tiles
width = 1920 # image width in pixel
height = 1536 # image height in pixel
tileWidth = 192 # tile x size
tileHeight = 154 # tile y size

# the tile offset
xOff = 0
yOff = 0

# Read cell location files
img = list() # cell location tables
tileCount = list() # count of cells in each tile per image
for(i in 1:length(files)){
  img[[i]] = read.table(paste0(outPath, files[i]), header=T)
}

# matrix with tile counts
tileCount[[i]] = matrix(0, nrow = n, ncol = n)
counter = 0

# Count the number of cells in each tile ####
for(i in 0:(n-1)){
  for(j in 0:(n-1)){
    xOff = tileWidth * j # x offset in the matrix columns (j)
    yOff = tileHeight * i # y off set in the matrix rows (i)
    tileCount[i+1,j+1] = length( # add the values in the matrix
      which(img[,1] >= (0+xOff) & img[,1] < (xOff + tileWidth) & 
              img[,2] >= ((0+yOff)) & img[,2] < ((yOff + tileHeight)))
    )
  }
}

# Plots ####
# View(tileCount) # the matrix is inverted

# heatmap(tileCount, Rowv=NA, Colv=NA, scale="none", main="",
#         col=gray(seq(0,1,length.out = 255)))

image(t(tileCount[nrow(tileCount):1, ]), main="cell count / tile",
      col=gray(seq(0,1,length.out = 255)))

#colorRampPalette(c("white","black"))(256) )
plot(img[,1], img[,2], col=img[,3], main="original", 
     xlim=c(0,1920), ylim=c(0,1536))
