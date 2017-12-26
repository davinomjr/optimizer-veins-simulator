library(ggplot2) 

data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/results/tabela_parcial.csv', header=TRUE, sep=",")

# Exaustivo
ggplot(data, aes(x=delayMedio_media, y=TotalLostPackets_media, group=v, color=v)) + 
  geom_point() +
  scale_shape_identity() +
  ggtitle("Throughput x Perda de Pacotes") +
  xlab("Throughput") +
  ylab("Perda de Pacotes") 

