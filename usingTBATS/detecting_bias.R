library(forecast)
library(ggplot2)
require(graphics)
library(fpp2)


data_clean<-read.table(file="~/Fault_Detecting/fault_detect/santander16_clean.txt",sep=",",row.names=1,header=TRUE)
data_driff <- read.table(file ="~/Fault_Detecting/fault_detect/bias_20.txt",sep=",",row.names=1,header=TRUE )
data.temperature_clean <- data_clean$temperature#data training 
temperature.ts <- ts(data.temperature_clean, frequency = 288)
data.drift <- data_driff$temperature#data needed to test 
data.drift.ts <- ts(data.drift, frequency = 288)

#holtwinter
fit  <- HoltWinters(temperature.ts)
result <- forecast(fit)
plot(forecast(fit))
alpha <- result$model$alpha
gamma <- result$model$gamma

# alpha = 0.7174901
# gamma = 0.2140571
#draw data graph
index <- length(data.drift)
index <- c(1:index) #take index
par()
par(opar <- par())
plot(index, data.drift, type="n", main="drift_16", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index, data.drift, type="l",col="blue") # draw line in plot


result <- data.drift[1:600]
for(i in c(601:3500)){
  modelI <- HoltWinters(ts(result[(i-577):(i-1)], frequency = 288),alpha = alpha,gamma = gamma)
  data.forecastI <- forecast(modelI,h = 1)
  data.real <- data.drift[i]
  if((data.real < (data.forecastI$lower[,2]-7))||(data.real > (data.forecastI$upper[,2]+6))){
    print("Having fault............")
    result <- c(result, runif(1, min=data.forecastI$lower[,1], max=data.forecastI$upper[,1]))
  }else{
    print("Normal status.....")
    result <- c(result, data.real)
  }
}


index_result <- length(result)
index_result <- c(1:index_result) #take index
par()
par(opar <- par())
plot(index_result, result, type="n", main="drift_16", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index_result, result, type="l",col="blue") # draw line in plot


for(i in c(601:3000)){
forecastI <- HoltWinters(ts(result[((i-1) - 576):(i-1)], frequency = 288),alpha = alpha,gamma = gamma)
data.forecastI <- forecast(forecastI,h = 1)
data.real <- data.drift[i]
if((data.real< data.forecastI$lower[,2])||(data.real > data.forecastI$upper[,2])){
   result <- c(result,data.forecastI$mean)
}else{
  result <- c(result, data.real)

}
}
data.real <- data.drift[601:610]


index_result <- length(result[1:3300])
index_result <- c(1:index_result) #take index
par()
par(opar <- par())
plot(index_result, result[1:3300], type="n", main="correct_16", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index_result, result[1:3300], type="l",col="blue") # draw line in plot

