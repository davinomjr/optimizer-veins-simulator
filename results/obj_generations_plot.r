library(ggplot2) 

data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/results/paretos.csv', header=TRUE, sep=",")
data$pop_size <- as.numeric(data$pop_size)

ggplot(data, aes(x=gen, y=TotalLostPackets_media, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Gerações x Perda de pacotes") +
  xlab("Gerações") +
  ylab("Perda de pacotes") +
  scale_color_gradientn(colours = rainbow(5))

ggplot(data, aes(x=gen, y=1/delayMedio_media, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Gerações x Delay") +
  xlab("Gerações") +
  ylab("Delay") +
  scale_color_gradientn(colours = rainbow(5))

ggplot(data, aes(x=gen, y=throughputMedioBPS_media, group=pop_size, color=pop_size)) + 
  geom_line() + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Gerações x 1/Throughput") +
  xlab("Gerações") +
  ylab("1/Throughput") +
  scale_color_gradientn(colours = rainbow(5))

# Exaustivo
ggplot(data, aes(x=delayMedio_media, y=throughputMedioBPS_media)) + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Delay x Throughput") +
  xlab("Delay") +
  ylab("Throughput") +
  scale_color_gradientn(colours = rainbow(5))
