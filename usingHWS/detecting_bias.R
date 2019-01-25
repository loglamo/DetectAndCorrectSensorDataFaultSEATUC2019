library(forecast)
library(ggplot2)
require(graphics)
library(fpp2)


# data_clean<-read.table(file="~/Fault_Detecting/fault_detect/santander16_clean.txt",sep=",",row.names=1,header=TRUE)
data_driff <- read.table(file ="~/Fault_Detecting/fault_detect/drift_2_scope.txt",sep=",",row.names=1,header=TRUE )
data.temperature_clean <- data_clean$temperature#data training 
temperature.ts <- ts(data.temperature_clean, frequency = 288)
data.drift <- data_driff$temperature#data needed to test 
data.drift.ts <- ts(data.drift, frequency = 288)

#holtwinter
# fit  <- HoltWinters(temperature.ts)
# result <- forecast(fit)
# plot(forecast(fit))
# alpha <- result$model$alpha
# gamma <- result$model$gamma

alpha = 0.7174901#santanfer
gamma = 0.2140571#santander

# alpha = 0.6236759#scope
# gamma = 0.5300464 #scope
#draw data graph
index <- length(data.drift)
index <- c(1:index) #take index
par()
par(opar <- par())
plot(index, data.drift, type="n", main="bias_20", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index, data.drift, type="l",col="blue") # draw line in plot


result <- data.drift[1:600]
for(i in c(601:2000)){
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


index <- length(data.drift[1:2000])
index <- c(1:index) #take index
par()
par(opar <- par())
plot(index , data.drift[1:2000], type="n", main="drift_2", ylab="Temperature",cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index , data.drift[1:2000], type="l",col="blue") # draw line in plot




index_result <- length(result[1:2000])
index_result <- c(1:index_result) #take index
par()
par(opar <- par())
plot(index_result, result[1:2000], type="n", main="corrected_drift2", ylab="Temperature", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
lines(index_result, result[1:2000], type="l",col="blue") # draw line in plot

