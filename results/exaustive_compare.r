library(ggplot2) 

data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/results/tabela_parcial.csv', header=TRUE, sep=",")


ggplot(data, aes(x=throughputMedioBPS_media, y=TotalLostPackets_media, group=v, color=v)) + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Throughput x Perda de Pacotes") +
  xlab("Throughput") +
  ylab("Perda de Pacotes") 


ggplot(data, aes(x=delayMedio_media, y=throughputMedioBPS_media, group=v, color=v)) + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Delay x Throughput") +
  xlab("Delay") +
  ylab("Throughput") 



ggplot(data, aes(x=delayMedio_media, y=TotalLostPackets_media, group=v, color=v)) + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Delay x Perda de Pacotes") +
  xlab("Delay") +
  ylab("Perda de Pacotes") 

