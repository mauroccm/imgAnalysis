library(ggplot2)

# Plot image count w/o filter ####
# Data frame with no filter counts
foo = filter(CellCounter, thresholdMethod == "Manual" | thresholdMethod == "Huang")
g = ggplot(foo, aes(timeDay, cellCount, fill=thresholdMethod))
g + geom_boxplot() + scale_fill_discrete(name="Method") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  scale_x_discrete(label=1:8) + coord_cartesian(ylim=c(0,1200))+
  theme(legend.title=element_text(size=10), legend.text=element_text(size=9))
ggsave(paste0("./plots/",Exp,"_AutoCellCounter_Global.png"), width=5, height=4, units="in")

bar = filter(CellCounter_filter, thresholdMethod == "Manual" | thresholdMethod == "Huang")
h = ggplot(bar, aes(timeDay, cellCount, fill = thresholdMethod))
h + geom_boxplot() + scale_fill_discrete(name="Method") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  scale_x_discrete(label=1:8) +
  theme(legend.title=element_text(size=10), legend.text=element_text(size=9))
ggsave(paste0("./plots/",Exp,"_AutoCellCounter_Global_filter.png"), width=5, height=4, units="in")

# Plot image count ####
g = ggplot(CountData_bestCorrel, aes(x=timeDay, y=cellCount, fill=thresholdMethod))
g + geom_boxplot() + facet_wrap(~ thresholdMethod) + guides(fill="none") +
  theme_light() + labs(x="Time (Days)", y="Cell count (cells/image)") +
  scale_x_discrete(label=1:8)
ggsave("./plots/AutoCellCounter_Global.png", width=4, height=3, units="in")

# Plot correlation ####
r = ggplot(CountData_bestCorrel, aes(manualCount, cellCount, color=thresholdMethod))
r + geom_point() + geom_smooth(method="lm", color="black", linetype=2) +
  guides(color="none") +
  facet_wrap(~ thresholdMethod) +
  annotate(geom="text", x=400, y=50, label=paste("r =",round(bestCorrel,4))) +
  labs(x="Manual count (cells/image)", y="Automatic count (cells/image)") +
  theme_light()
ggsave("./plots/AutoCellCounter_Correlation.png", width=4, height=3, units="in")

# Plot the Ratio Data summary (average and deviation) ####
rd = ggplot(ratioData, aes(thresholdMethod, mu))#, fill=thresholdMethod))
rd + geom_bar(stat="identity", color="black", width=.5, fill="red") + 
  geom_errorbar(aes(ymax=mu+sigma, ymin=mu-sigma), width=.25) +
  labs(x="Threshold methods", y="Ratio average") +
  annotate(geom="text", x=1:17, y=-.25, label=1:17) +
  theme_light() +
  theme(axis.text.x = element_blank())
ggsave("./plots/AutoCellCounter_Ratios.png", width=4, height=3)

rd_filter = ggplot(ratioData, aes(thresholdMethod, mu_filter))
rd_filter + geom_bar(stat="identity", color="black", width=.5, fill="red") + 
  geom_errorbar(aes(ymax=mu_filter+sigma_filter, ymin=mu_filter-sigma_filter), width=.25) +
  labs(x="Threshold methods", y="Ratio average") +
  annotate(geom="text", x=1:17, y=-.25, label=1:17) +
  theme_light() +
  theme(axis.text.x = element_blank())

# rd2 = ggplot(ratioData_long, aes(thresholdMethod, mu, fill=filter))
# rd2 + geom_bar(stat="identity", color="black", width=.5, position="dodge") + 
#   geom_errorbar(aes(ymax=mu+sigma, ymin=mu-sigma), width=.25) +
#   labs(x="Threshold methods", y="Ratio average") +
#   annotate(geom="text", x=1:17, y=-.25, label=1:17) +
#   theme_light() +
#   theme(axis.text.x = element_blank())

# Plot the count data w/ filters ####
foo = data.frame(cellCount = c(manualCount$cellCount, HuangCount),
                 thresholdMethod = c(rep("Manual",240), rep("Huang",240)),
                 timeDay = rep(manualCount$timeDay, 2)
                 )
str(foo)

g2 = ggplot(foo, aes(x=(timeDay), y=cellCount, fill=thresholdMethod))
g2 + geom_boxplot() +
  labs(x="Time (days)", y="Cell count (cells/image)") +
  scale_fill_discrete(name="Method") +
  scale_x_discrete(label=1:8) +
  theme_light()
ggsave("./plots/Exp19_AutoCellCount_areaFilter.png", width=5, height=4, units="in")

# plot the count data without fiters ####

bar = data.frame(cellCount = c(manualCount$cellCount, AutoCellCounter[241:480,"cellCount"]),
                 thresholdMethod = c(rep("Manual",240), rep("Huang",240)),
                 timeDay = rep(manualCount$timeDay, 2)
)
str(bar)

g3 = ggplot(bar, aes(x=timeDay, y=cellCount, fill=thresholdMethod))
g3 + geom_boxplot() + #removing outliers
  labs(x="Time (days)", y="Cell count (cells/image)") +
  scale_fill_discrete(name="Method") +
  scale_x_discrete(label=1:8) +
  coord_cartesian(ylim=c(0,1000)) +
  #scale_y_continuous(limits = c(0,1000)) + # to fit the data in the plot area
  theme_light()
ggsave("./plots/Exp19_AutoCellCount.png",
       width=5, height=4, units="in")


# Plot the ratio comparrison ####
par(mar=c(4,5,2,2)+.1)
plot(IntermodesRatio[,2], col='red', pch=16, 
     ylim=c(0,2.2), xlim=c(0,240), xaxt="n",
     xlab="Image Index", ylab="Count Ratio\n (Auto / Manual)",
     main="Intermodes Method"
     )
axis(1, seq(0,240,20), seq(0,240,20))
points(IntermodesRatio[,1], col='black', pch=16)
legend("bottomright", pch=c(16,16), col=c("black","red"), bty="n",
       legend = c("w/o filter","w/ filter"))
dev.off()


