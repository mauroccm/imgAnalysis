# Script para avalair os resultados de evalScriptPerformance.sh
#
# Mauro Morais, 2018-06-28
library("tidyverse")

folder=list()
files=list()
run=list()
for(i in 1:5){
  folder[[i]] = paste0("results/2018-06-28/run0", i, "/")
  files[[i]] = dir(folder[[i]])
  run[[i]] = list() # each shell script run
  for(j in 1:length(files[[i]])){
    run[[i]][[j]] = readLines(paste0(folder[[i]], files[[i]][[j]]))
  }
}
str(run)
runs = unlist(run)
str(runs)

Metrics = c("Command being timed:",
            "User time (seconds):",
            "System time (seconds):",
            "Percent of CPU this job got:",
            "Elapsed (wall clock) time (h:mm:ss or m:ss):",
            "Average shared text size (kbytes):",
            "Average unshared data size (kbytes):",
            "Average stack size (kbytes):",
            "Average total size (kbytes):",
            "Maximum resident set size (kbytes):",
            "Average resident set size (kbytes):",
            "Major (requiring I/O) page faults:",
            "Minor (reclaiming a frame) page faults:",
            "Voluntary context switches:",
            "Involuntary context switches:",
            "Swaps:",
            "File system inputs:",
            "File system outputs:",
            "Socket messages sent:",
            "Socket messages received:",
            "Signals delivered:",
            "Page size (bytes):",
            "Exit status:")
Methods = c("Default",
            "Huang",
            "IJ_IsoData",
            "Intermodes",
            "IsoData",
            "Li",
            "MaxEntropy",
            "Mean",
            "MinError",
            "Minimum",
            "Moments",
            "Otsu",
            "Percentile",
            "RenyiEntropy",
            "Shanbhag",
            "Triangle",
            "Yen")

runsData = matrix(runs, ncol=17*5, nrow=23) %>%
  as.data.frame

# rownames(runsData) = (Metrics)
colnames(runsData) = rep(Methods, 5) #for(i in 1:5) return(paste0(Methods, "_v", i)) 
runsData[, "Metrics"] = Metrics
runsData = as.data.frame(apply(runsData, 2, 
                               gsub, pattern="^.*: ", replacement=""))

runsData = gather(runsData, "Methods", "Value", 1:(5*17))
runsData[, "Methods"] = rep(rep(Methods, each=23), 5)
runsData[, "runNumbr"] = rep(1:5, each=17*23)
# View(foo)
View(runsData)

# Performance metrics
TimePerformanceSummary = filter(
  runsData, 
  Metrics=="Elapsed (wall clock) time (h:mm:ss or m:ss):") %>%
  group_by(Methods) %>%
  summarise(Avg=mean(as.POSIXct(Value, format="%M:%S")),
            StDev=sd(as.POSIXct(Value, format="%M:%S")))

CPUPerformanceSummary = filter(
  runsData, 
  Metrics=="Percent of CPU this job got:") %>%
  mutate(Value=gsub(pattern="%$", replacement="", 
                    x=CPUPerformanceSummary[,"Value"])) %>%
  group_by(Methods) %>%
  summarise(Avg=mean(as.numeric(Value)), stDev=sd(as.numeric(Value)))

MemoryPerformanceSummary = filter(
  runsData, Metrics=="Maximum resident set size (kbytes):") %>%
  group_by(Methods) %>%
  summarise(Avg=mean(as.numeric(Value)), StDev=sd(as.numeric(Value)))

# Summarize performance analysis
PerformanceSummary = data.frame(Methods=Methods,
                                Time=TimePerformanceSummary$Avg,
                                Memory=MemoryPerformanceSummary$Avg,
                                PercentCPU=CPUPerformanceSummary$Avg)
PerformanceSummary["Time"] =  format(PerformanceSummary["Time"],format="%M:%S")
                                
write.table(PerformanceSummary, "results/2018-06-28/methodsPerformanceSummary.txt",
            row.names=F)

# Merge with methodsAnalysis
methodsAnalysis = cbind(methodsAnalysis[-1,], PerformanceSummary[,-1])
write.table(methodsAnalysis,
            "results/2018-06-28/autoCounterV127_imgCleanerV13_methodsAnalysisResults.txt",
            row.names=F)

save.image()
