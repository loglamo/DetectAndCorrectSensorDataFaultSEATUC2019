library(forecast)
library(ggplot2)
getOption("device")
require(graphics)
library(fpp2)

data_clean<-read.table(file="~/Fault_Detecting/fault_detect/sensorscope_train.txt",sep=",",row.names=1,header=TRUE)
data_driff <- read.table(file ="~/Fault_Detecting/fault_detect/drift_9_scope.txt",sep=",",row.names=1,header=TRUE )
data.temperature_clean <- data_clean$temperature#data training 
temperature.ts <- ts(data.temperature_clean, frequency = 288)
data.drift <- data_driff$temperature#data needed to test 
data.drift.ts <- ts(data.drift, frequency = 288)

# tbats training 
# fit.tbats <- tbats(temperature.ts)
# plot(forecast(fit.tbats))


index <- length(data.drift)
index <- c(1:2000) #take index
par()
par(opar <- par())
plot(index, data.drift[1:2000], type="n", main="drift_9", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index, data.drift[1:2000], type="l",col="blue") # draw line in plot


result <- data.drift[1:600]
for(i in c(601:2000)){
  modelI <- tbats(ts(result[(i-577):(i-1)], frequency = 288),model = fit.tbats)
  data.forecastI <- forecast(modelI,h = 1)
  data.real <- data.drift[i]
  if((data.real < (data.forecastI$lower[,2]))||(data.real > (data.forecastI$upper[,2]))){
    print("Having fault............")
    result <- c(result, runif(1, min=data.forecastI$lower[,2], max=data.forecastI$upper[,2]))
    # result <- c(result, data.forecastI$mean)
  }else{
    print("Normal status.....")
    result <- c(result, data.real)
  }
}



index_result <- length(result[1:2000])
index_result <- c(1:index_result) #take index
par()
par(opar <- par())
plot(index_result, result[1:2000], type="n", main="correct_9", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index_result, result[1:2000], type="l",col="blue") # draw line in plot


