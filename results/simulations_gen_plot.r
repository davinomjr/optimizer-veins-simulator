library(ggplot2) 

data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/results/simulations_by_gen.csv', header=TRUE, sep=",")
data$pop_size <- as.numeric(data$pop_size)

ggplot(data, aes(x=gen, y=simulations, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Generations x Simulations") +
  xlab("Generations") +
  ylab("#Simulations")