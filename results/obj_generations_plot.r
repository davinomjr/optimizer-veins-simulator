library(ggplot2) 

data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/results/paretos.csv', header=TRUE, sep=",")
data$pop_size <- as.numeric(data$pop_size)

ggplot(data, aes(x=gen, y=TotalLostPackets_media, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Generations x Lost Packets") +
  xlab("Generations") +
  ylab("Lost Packets") +
  scale_color_gradientn(colours = rainbow(5))

ggplot(data, aes(x=gen, y=delayMedio_media, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Generations x Delay") +
  xlab("Generations") +
  ylab("Delay") +
  scale_color_gradientn(colours = rainbow(5))


ggplot(data, aes(x=gen, y=throughputMedioBPS_media, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Generations x 1/Throughput") +
  xlab("Generations") +
  ylab("1/Throughput") +
  scale_color_gradientn(colours = rainbow(5))