library("Polychrome") # colors
metCols = rep(glasbey.colors(17),5)

# Re-shape data
TimePerformance = filter(runsData,
                         Metrics=="Elapsed (wall clock) time (h:mm:ss or m:ss):") %>%
  group_by(Methods) %>%
  mutate(Value = as.numeric(as.difftime(Value,
                                    format = "%M:%S", 
                                    units = "secs")))

MemoryPerformance = filter(runsData,
                           Metrics=="Maximum resident set size (kbytes):") %>%
  group_by(Methods) %>%
  mutate(Value=as.numeric(Value)/1000)

methodsPerformance = data.frame(tempo=TimePerformance$Value,
                 memory=MemoryPerformance$Value,
                 methods=TimePerformance$Methods,
                 run=TimePerformance$runNumbr,
                 colz=metCols)
str(methodsPerformance) # checking...
# write.table(methodsPerformance, "results/2018-10-23/methodsPerformance.txt",
#             row.names = F)

#  Plot time of execution vs Memory usage ####
pdf("results/2018-10-23/userTime_memUse_methodsPerformance.pdf", 
    width=6, height=6, useDingbats=F)
plot(x=methodsPerformance$tempo, y=methodsPerformance$memory, 
     pch=21, col="black", bg=metCols, cex=1.2,
     main="Methods performance", 
     xlab="User-time (seconds)", ylab="Memory usage (Mb)")
dev.off()

pdf("results/2018-10-23/methodsPerformance_legend.pdf", width=5, height=4,
    useDingbats=F)
plot(1:100,1:100,col="white", axes = F, frame.plot = F, ylab="", xlab="")
legend("topleft", pch=21, legend=methodsPerformance$methods[1:8], col="black", 
       pt.bg=metCols[1:8], bty = "n")
legend("top", pch=21, legend=methodsPerformance$methods[9:17], col="black", 
       pt.bg=metCols[9:17], bty = "n")
dev.off()

save.image("computerPerformance.RData")
