# análise da distribuição do número de vizinhos

# Distribuition of the number of neighbours NOT counting the edges
neighbours = read.table(
  "results/2018-08-27/",
                      header=T)
neighbours["freq"] = neighbours["Y"] / sum(neighbours["Y"])

# sum(neighbours[,"Y"]); sum(neighbours[,"freq"])

barplot(height=neighbours[,"Y"], width = 1, space = 0, 
        names.arg=neighbours[,"X"], col="darkgreen",
        sub="(edges excluded)",
        ylab="Cell counts", xlab="numbr. of neighbours")
legend("topright", bty="n", legend=paste0("n = ", sum(neighbours["Y"])))

plot(neighbours[,"freq"],
     type="l", lwd=2, col="darkgreen",
     sub="(edges excluded)",
     ylab="freq. of n. neigbours", xlab="numbr. of neighbours")
legend("topright", bty="n", legend=paste0("n = ", sum(neighbours["Y"])))

###################
# Distribuition of the number of neighbours counting the edges
neighbours_wEdges = read.table(
  "results/2018-08-24/voronoi_neigboursDistribution_withEdges.txt",
  header=T)
neighbours_wEdges["freq"] = neighbours_wEdges["Y"] / sum(neighbours_wEdges["Y"])

# sum(neighbours_wEdges[,"Y"]); sum(neighbours_wEdges[,"freq"])

barplot(height=neighbours_wEdges[,"Y"], width=1, space=0,
        names.arg=neighbours_wEdges[,"X"], col="red",
        sub="(edges included)",
        ylab="Cell counts", xlab="numbr. of neighbours")
legend("topright", bty="n", legend="n = 725")

plot(neighbours_wEdges[,"freq"],
     type="l", lwd=2, col="red",
     sub="(edges included)",
     ylab="freq. of n. neigbours", xlab="numbr. of neighbours")
legend("topright", bty="n", legend="n = 725")
