# Counting Exp27 images captured at 40x
library(dplyr); library(ggplot2)
path = "data/Exp27_40x_HOE_counts/"
files= dir(path)

manualCounts = list()
numbrCells = numeric()
for(i in 1:length(files)){
  manualCounts[[i]] = read.table(paste0(path, files[i]), header=T,
                                 colClasses = "numeric")[,1:4]
  numbrCells[i] = nrow(manualCounts[[i]])
}

head(manualCounts[[1]])

manualCountData = data.frame(
  timeDays = (rep(seq(2,8,2), each=5)),
  cellCounts = numbrCells
  
)

manualCountData_summary = group_by(manualCountData, timeDays) %>%
  summarise(Avg = mean(cellCounts), StDev = sd(cellCounts), N = n())

# Exp27_sk147_40x_manualCellCount.png
g = ggplot(manualCountData_summary, aes(x=timeDays, y=Avg)) +
  geom_col(width=1) +
  geom_errorbar(aes(ymax=Avg+StDev, ymin=Avg-StDev, width=0.5)) +
  labs(x="Time (days)", y="cells/field", title="SK147 (Exp27)") +
  theme_light()
  
