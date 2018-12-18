# Plot the combination of experimental and simulation results
# 
# Mauro Morais, 2018-09-12

# SIMselecetedCellsData.summary = selecetedCellsData.summary
# SIMselectedCellsFreq = selectedCellsFreq
# SIMselectedCellsResults = selectedCellsResults

HAselecetedCellsData.summary = selecetedCellsData.summary
HAselectedCellsFreq = selectedCellsFreq
HAselectedCellsResults = selectedCellsResults

SKselecetedCellsData.summary = selecetedCellsData.summary
SKselectedCellsFreq = selectedCellsFreq
SKselectedCellsResults = selectedCellsResults

#####
foo = rbind(HAselecetedCellsData.summary, SKselecetedCellsData.summary)
foo[,"group"] = c(rep("HaCaT", nrow(HAselecetedCellsData.summary)),
                  rep("SK147", nrow(SKselecetedCellsData.summary))
)

str(foo)
# foo[22, ] = c(2, 0, NA, 0, NA, 0, "EXP")

# plots ####
text.size = 24
point.size = 12
errbar.width = 0.4
line.size = 2

H = ggplot(foo, aes(x=numbrNeighbors, y=countMean, fill=group))+
  geom_col(width=0.8, position="dodge")+
  geom_errorbar(aes(ymin=countMean-countSd, ymax=countMean+countSd), width=0.6,
                position="dodge")+
  theme_minimal()+
  scale_x_continuous(breaks=2:13, labels=2:13)+
  scale_fill_discrete(name="")+
  labs(x="Number of first neighbors", y="Average count per image")+
  theme(
    legend.position="top",
    legend.text = element_text(size = text.size), 
    axis.text.x = element_text(size = text.size),
    axis.text.y = element_text(size = text.size),
    axis.title = element_text(size = text.size)
  )

pdf(file="results/2018-09-14_Exp27_nNeig/plots/nNeigDistribution.pdf", 
    useDingbats = F) #Setting useDingbats = FALSE 
par( mai = c(1,2,1,2), lwd = 96/72, pch=16, ps=point.size)
plot(H)
dev.off()

J = ggplot(foo, aes(x=numbrNeighbors, y=freqMean)) +#, color=group)) +
  geom_line(size=2, aes(color=group)) +
  geom_point(shape=21, size=3, color="black", aes(fill=group)) +
  geom_errorbar(aes(ymin=freqMean-freqSd, ymax=freqMean+freqSd,
                    width=0.4))+
  # geom_line(aes(y=freqMean+freqSd)) +
  # geom_line(aes(y=freqMean-freqSd)) +
  # geom_smooth(aes(y=freqMean, color=group), se=F, method="loess") +
  # ylim(0,0.45) +
  coord_cartesian(ylim=c(0,0.45)) +
  theme_minimal() +
  scale_x_continuous(breaks=2:11, labels=2:11) +
  guides(fill="none", color="none") +
  annotate(geom="text", #size=text.size,
           label="HaCaT: S = 2.08 ± 0.06\nSK147: S = 2.18 ± 0.08",
           x=10, y=0.4) +
  # scale_color_discrete(name="") +#,
  #                      labels=c("HaCaT: S = 2.08 ± 0.06",
  #                               "Sim.: S = 2.87 ± 0.09")) +
  labs(x="Numbr. of neighbors", y="Average frequency") +
  theme(
    axis.text.x = element_text(size = 14),
    axis.text.y = element_text(size = 14),
    axis.title = element_text(size = 14),
    legend.position = "top",
    legend.text = element_text(size = 14)
  )
plot(J)
# ggsave(path=outDir, filename="selectedCellsCombDistribution.png", device="png",
#        width = 8, height = 6, units = "in")
dev.off()

save.image("nNeighborAnalysis.RData")
