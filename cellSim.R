# cellSimulation

cell1 = matrix(6, nrow=2, ncol=2)
cell2 = matrix(12, nrow=2, ncol=2)
cell3 = matrix(c(rep(12,4), rep(6,4)), nrow=2, ncol=4)
cell4 = matrix(c(6,6, rep(12,4), 6,6), nrow=2, ncol=4)

# RawIntDen
sum(cell1); sum(cell2); sum(cell3); sum(cell4);

# avgInt
mean(cell1); mean(cell2); mean(cell3); mean(cell4);

# Area
sum(!is.na(cell1)); sum(!is.na(cell2)); sum(!is.na(cell3)); sum(!is.na(cell4));

# IntDen
mean(cell1) * sum(!is.na(cell1)); mean(cell2) * sum(!is.na(cell2)); 
mean(cell3) * sum(!is.na(cell3)); mean(cell4) * sum(!is.na(cell4));

cellX = matrix(c(
  NA, 6, 6, 6, NA,
  6, 12, 12, 12, 6,
  6, 12, 12, 12, 6,
  6, 12, 12, 12, 6,
  NA, 6, 6, 6, NA
), nrow=5, ncol=5)

sum(!is.na(cellX)) #Area
mean(cellX, na.rm=T) #MeanInt
sd(cellX, na.rm=T) #SdInt
sum(cellX, na.rm=T) #RawIntDen
mean(cellX, na.rm=T) * sum(!is.na(cellX)) #IntDen
