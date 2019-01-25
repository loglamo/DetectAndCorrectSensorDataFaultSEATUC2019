library(forecast)
library(ggplot2)
require(graphics)
library(fpp2)


#data_clean<-read.table(file="~/Fault_Detecting/fault_detect/santander16_clean.txt",sep=",",row.names=1,header=TRUE)
data_driff <- read.table(file ="~/Fault_Detecting/fault_detect/clean_random_9.txt",sep=",",row.names=1,header=TRUE )
#data.temperature_clean <- data_clean$temperature#data training 
#temperature.ts <- ts(data.temperature_clean, frequency = 288)
data.drift <- data_driff$temperature[1:2000]#data needed to test 
data.drift.ts <- ts(data.drift, frequency = 288)

index <- length(data.drift)
index <- c(1:2000) #take index
par()
par(opar <- par())
plot(index, data.drift, type="n", main="clean_malfs_9", ylab = "Temperature", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index, data.drift, type="l",col="blue") # draw line in plot
