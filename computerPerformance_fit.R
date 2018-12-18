# Script para ajustar os dados de desempenho do computador 
# nos medelos de threshold
# 
# Mauro Morais, 2018-10-30

library(tidyverse)
library(car)
load("computerPerformance.RData")

str(methodsPerformance)

# the initial memory
t0 = which.min(methodsPerformance[,"tempo"])
mem0 = methodsPerformance[t0,"memory"]

# exponential model
exponential = formula(memory ~ mem0 * exp(lambda * tempo) )

lmFit = lm(memory ~ tempo, data=methodsPerformance)
nlsFit = nls(exponential, data=methodsPerformance, 
             start=list(lambda=1), trace=F,
             nls.control(maxiter = 1000))#, algorithm="port")
coef(nlsFit) # decrease rate

# abline(lmFit, lwd=2, lty=2)
with(methodsPerformance,
     plot(tempo, memory, pch=16, xlab="tempo", ylab="memory"),
     x=seq(min(tempo), max(tempo), by=1),
     y=mem0 * exp(coef(nlsFit) * x)
)
lines(x, y, lwd=2, lty=2, col='red')
dev.off()

# ggplot(methodsPerformance, aes(x=tempo, y=memory))+
#   geom_point() + geom_smooth(method = lm)+
#   theme_classic()
