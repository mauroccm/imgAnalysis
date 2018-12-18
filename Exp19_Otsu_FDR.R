# Working on FDR for Otsu method comparing with maual count for Exp19
man = read.table("data/Exp19_TXT/CellCounter_Exp19_hacat_day01_HOE_W1_001.jpg.xml.txt",
                 header=T)
otsu = read.table("data/AutoCellCounter_Global_v123/Otsu/Exp19_hacat_day01_HOE_W1_001.tif_Otsu.txt",
                  header=T)
otsu$Y = 1536-otsu$Y

nuc = read.table("data/Exp19_nuclei_measurements.txt", header=T)

plot(man)
points(otsu$X, otsu$Y, col='red')

head(man)
plot(man$Y)
plot(otsu$X)
dev.off()

foo = with(man, man[order(Y, decreasing=T), ])
plot(foo$Y)
points(otsu$Y, col='red')
head(nuc) #manual measurements of 50 nuclei
with(nuc, summary(Area))
