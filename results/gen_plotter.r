data <- read.csv(file='/home/dmtsj/repos/optimizer-veins-simulator/nsga-veins/gens.csv', header=TRUE, sep=",")
data


plot(x = data$throughputMedioBPS_media,y = data$delayMedio_media,
     xlab = "1/Throughput",
     ylab = "Delay",
     xlim = c(0,1),
     ylim = c(0,1),
     main="Throughput x Delay"
)

;;
plot(x = data$TotalLostPackets_media,y = data$delayMedio_media,
     xlab = "Perda de Pacotes",
     ylab = "Delay",
     xlim = c(0,10),
     ylim = c(0,3),
     main="Perda x Delay"
)


plot(x = data$TotalLostPackets_media,y = data$throughputMedioBPS_media,
     xlab = "Perda de Pacotes",
     ylab = "1/Throughput",
     xlim = c(0,10),
     ylim = c(0,3),
     main="Perda x 1/Throughput"
)




plot(x = data$TotalLostPackets_media,y = data$delayMedio_media,
     xlab = "Perda de Pacotes",
     ylab = "Delay",
     xlim = c(0,10),
     ylim = c(0,3),
     main="Perda x Delay"
)






# Save the file.
dev.off()



input <- mtcars[,c('wt','mpg')]
print(head(input))


attach(mtcars)
plot(wt, mpg, main="Scatterplot Example", 
     xlab="Car Weight ", ylab="Miles Per Gallon ", pch=19)