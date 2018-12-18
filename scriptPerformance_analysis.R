# Script para avalair os resultados de evalScriptPerformance.sh
#
# Mauro Morais, 2018-08-09
library("tidyverse")

# Read the performance data ####
# folder=list()
folder = "results/2018-08-09_autoCount_analysis/AutoCount_fromCleanV13/performance/"
performanceSummaryOutput = "results/2018-08-09_autoCount_analysis/performanceSummary_fromCleanV13.txt"
files = dir(folder)
run=list()
for(i in 1:length(files)){
  # folder[[i]] = paste0("results/2018-06-28/run0", i, "/")
  # files[[i]] = dir(folder[[i]])
  # each shell script run for each method: 5 * 17
  run[[i]] =  readLines(paste0(folder, files[[i]]))
  # for(j in 1:length(files[[i]])){
  #   run[[i]][[j]] = readLines(paste0(folder[[i]], files[[i]][[j]]))
  # }
}
# str(run)
runs = unlist(run)
# str(runs)

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
Methods = c("Default", "Huang", "IJ_IsoData", "Intermodes", "IsoData",
            "Li", "MaxEntropy", "Mean", "MinError", "Minimum",
            "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag",
            "Triangle", "Yen")

runsData = matrix(runs, ncol=17*5, nrow=23) %>%
  as.data.frame
# str(runsData)
# head(runsData)

# Reshape the data ####
# rownames(runsData) = (Metrics)
colnames(runsData) = rep(Methods, 5) #for(i in 1:5) return(paste0(Methods, "_v", i)) 
runsData[, "Metrics"] = Metrics
runsData = as.data.frame(apply(runsData, 2, # remove every char up to the colon
                               gsub, pattern="^.*: ", replacement=""))

runsData = gather(runsData, "Methods", "Value", 1:(5*17))
runsData[, "Methods"] = rep(rep(Methods, each=23), 5)
runsData[, "runNumbr"] = rep(1:5, each=17*23)
# View(runsData) # just cehcking

# Performance metrics ####
TimePerformanceSummary = filter(
  runsData, 
  Metrics=="Elapsed (wall clock) time (h:mm:ss or m:ss):") %>%
  group_by(Methods) %>%
  summarise(Avg=mean(as.POSIXct(Value, format="%M:%S")),
            StDev=sd(as.POSIXct(Value, format="%M:%S")))

CPUPerformanceSummary = filter(
  runsData, 
  Metrics=="Percent of CPU this job got:")
CPUPerformanceSummary[,"Value"] = gsub(pattern="%$", replacement="", 
                                      x=CPUPerformanceSummary[,"Value"])
  # mutate(Value=gsub(pattern="%$", replacement="", 
  #                   x=CPUPerformanceSummary["Value"])) %>%
CPUPerformanceSummary = group_by(CPUPerformanceSummary, Methods) %>%
  summarise(Avg=mean(as.numeric(Value)), stDev=sd(as.numeric(Value)))

MemoryPerformanceSummary = filter(
  runsData, Metrics=="Maximum resident set size (kbytes):") %>%
  group_by(Methods) %>%
  summarise(Avg=mean(as.numeric(Value)), StDev=sd(as.numeric(Value)))

# Summarize performance analysis
PerformanceSummary = data.frame(Methods=Methods,
                                Time=TimePerformanceSummary$Avg,
                                Time.sd=TimePerformanceSummary$StDev,
                                Memory=MemoryPerformanceSummary$Avg,
                                Memory.sd=MemoryPerformanceSummary$StDev,
                                PercentCPU=CPUPerformanceSummary$Avg,
                                PercentCPU.sd=CPUPerformanceSummary$stDev)
# Convert time units m:s to secs
PerformanceSummary["Time"] = format(PerformanceSummary["Time"],
                                    format="%M:%S")
PerformanceSummary["Time"] = strtoi(as.difftime(PerformanceSummary[,"Time"], 
                                                format = "%M:%S", 
                                                units = "secs"))

# convert do MB units
PerformanceSummary["Memory"] = PerformanceSummary["Memory"] / 1000
PerformanceSummary["Memory.sd"] = PerformanceSummary["Memory.sd"] / 1000
# View(PerformanceSummary) # just checking...
                                
write.table(PerformanceSummary, file=performanceSummaryOutput, row.names=F)

# Merge with methodsAnalysis from AutoCellCounter_Global_v125.R ####
# methodsAnalysisPerformance = cbind(methodsAnalysis[-1,], 
#                                    PerformanceSummary[,-1])
# write.table(methodsAnalysisPerformance,
#             "results/2018-07-04/autoCounterV127_imgCleanerV13_methodsAnalysisResults.txt",
#             row.names=F)

save.image("performanceAnalysis.RData")
