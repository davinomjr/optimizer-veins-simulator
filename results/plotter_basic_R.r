data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/results/simulations_by_gen.csv', header=TRUE, sep=",")
data

data$pop_size <- as.numeric(data$pop_size)
npopsize <- max(data$pop_size)

xrange <- range(data$gen)
yrange <- range(data$simulations)

plot(xrange, yrange, type="n", xlab="Generations",ylab="#Simulations")
colors <- rainbow(npopsize)
linetype <- c(1:npopsize)
plotchar <- seq(18, 18+npopsize,1)


# add lines 
for (i in 1:npopsize) { 
  pop <- subset(data, pop_size==i) 
  lines(pop$gen, pop$simulations, type="l", lwd=1.5,
        lty=linetype[i], col=colors[i], pch=plotchar[i]) 
} 

# add a title and subtitle 
title("Generations x Simulations", "")

# add a legend 
pop_legend <- c(5,10,15,20,25,30,35,40,45,50)
par(xpd=TRUE)
legend(46, 60, pop_legend, cex=0.8, col=colors,
       pch=plotchar, lty=linetype, title="Populations")

