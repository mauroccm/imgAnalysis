## Identify density of cells in a 192 x 153.6 pixel  area
x = read.table("data/Exp16_TXT/CellCounter_Exp16_day01_HOE_W1_001.xml.txt",
               header=T)

n = 10 # numbr of tiles
width = 1920 # image width in pixel
height = 1536 # image height in pixel
tileWidth = 190 # tile x size
tileHeight = 153 # tile y size

# the tile offset
xOff = 0
yOff = 0

# matrix with tile counts
tileCount = matrix(0, nrow = n, ncol = n)

# Count the number of cells in each tile ####
for(i in 0:(n-1)){
  for(j in 0:(n-1)){
    xOff = tileWidth * j # x offset in the matrix columns (j)
    yOff = tileHeight * i # y off set in the matrix rows (i)
    tileCount[i+1,j+1] = length( # add the values in the matrix
      which(x[,1] > (0+xOff) & x[,1] < (xOff + tileWidth) & 
              x[,2] > ((0+yOff)) & x[,2] < ((yOff + tileWidth)))
    )
  }
}

