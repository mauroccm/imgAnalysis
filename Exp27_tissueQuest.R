# Exp27 tissueQuest results analysis
# 2018-03-26
library("dplyr"); library("ggplot2")

path = "data/Exp27_HOE_tissueQuest/"
files = dir(path)
files = files[grep(".csv", files)]

autoCount = list()
for(i in 1:length(files)){
  autoCount[[i]] = read.csv(paste0(path,files[i]), dec=",",
                            header=T, sep=";", stringsAsFactors = F)
}
str(autoCount[[1]])

autoCountSummary = list()
for(i in 1:length(autoCount)){
  autoCountSummary[[i]] = group_by(autoCount[[i]], Field.Of.View) %>%#, HOE...Area..μm..) %>%
    #group_by(Field.Of.View) %>%
    summarise(#areaAvg=mean(HOE...Area..μm..), areaSd=sd(HOE...Area..μm..), 
      cellCount=n())
  autoCountSummary[[i]] = autoCountSummary[[i]][1:30,]
}

foo = do.call(rbind.data.frame, autoCountSummary)
foo = cbind(timeDays=rep(1:8, each=30), foo)
x = c("day01", "day02", "day03", "day04", 
      "day05", "day06", "day07", "dayo8")

fooSummary = group_by(foo, timeDays) %>%
  summarise(Avg=mean(cellCount), stDev=sd(cellCount), N=n())

g = ggplot(fooSummary, aes(x=timeDays, y=Avg)) + 
  geom_col(width=.75) +
  geom_errorbar(aes(ymax=Avg+stDev, ymin=Avg-stDev, width=0.5)) +
  labs(x="Time (days)", y="cells/field", title="SK147 (Exp27)") +
  theme_light()
