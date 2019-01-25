
#read file
santander20 <- read.csv("~/R_pro/santander20_clean.txt",stringsAsFactors = FALSE) 
x11(width=10, height=10)# configure plot graph                                   

temperature <- santander20$temperature #take temperature in data
index <- length(temperature)
temp <- temperature[1:index] #take temperature value 
index <- c(1:index) #take index 
par()
par(opar <- par())
plot(index, temp, type="n", main="clean-graph-20", cex.main=1.2,  cex.lab=1.5, cex.axis=1.5) # draw plot
lines(index, temp, type="l",col="blue") # draw line in plot 

library(forecast)

data_clean<-read.table(file="~/R_pro/santander20_clean.txt",sep=",",row.names=1,header=TRUE)

temperature.ts <- ts(data_clean$temperature, frequency = 288)
# data.forecast <- forecast(temperature.ts, h = 30, gamma = 0.5)
# temperature.test <- data$temperature[830:864]
# test.ts <- ts(temperature.test, frequency = 288)
# datatest.forecast <- forecast(temperature.ts, h = 30)
decompose_temp = decompose(temperature.ts, "additive")

plot(decompose_temp)



