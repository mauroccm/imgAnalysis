# AutoCellCounter_Global_v123_plots.R
library(ggplot2)

# Filter countData with good correlation  ####
CountData_filter = filter(CountData, thresholdMethod %in% names(Correlation)[1:6])
tail(CountData_filter); dim(CountData_filter)

# Plot counts (cell proliferation) ####
g = ggplot(CountData_filter, aes(x=timeDay, y=cellCount, fill=thresholdMethod))
g +
  geom_boxplot() + facet_wrap(~ thresholdMethod) + guides(fill="none") +
  annotate(geom="text", x=3, y=3500,
           label=paste0("FDR = ", round(methodsAnalysis[1:6,2],4))) +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  scale_x_discrete(label=1:8)
ggsave("results/2017-09-11 autoCellCounter_Global_v123/Exp19_AutoCellCount_methods.png", 
       width=6, height=4.5, units="in") # 6 x 4.5 inches = 1800 x 1350 pixels


# Plot correlation ####
h = ggplot(CountData_filter, aes(manualCount, cellCount, color=thresholdMethod))
h +
  geom_point() + geom_smooth(method="lm", color="black", linetype=2) +
  guides(color="none") +
  facet_wrap(~ thresholdMethod) +
  annotate(geom="text", x=200, y=3500, 
           label=paste0("r = ",round(methodsAnalysis[1:6,1],4))) +
  labs(x="Manual count (cells/image)", y="Automatic count (cells/image)") +
  theme_light()
ggsave("results/2017-09-11 autoCellCounter_Global_v123/Exp19_AutoCellCount_correl.png",
       width=6, height=4.5, units="in")
dev.off()
