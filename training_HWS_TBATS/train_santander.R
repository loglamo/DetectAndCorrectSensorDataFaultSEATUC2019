library(forecast)
library(ggplot2)
require(graphics)
library(fpp2)


data_clean<-read.table(file="~/Fault_Detecting/fault_detect/santander_train.txt",sep=",",row.names=1,header=TRUE)
data.temperature_clean <- data_clean$temperature#data training 
temperature.ts <- ts(data.temperature_clean, frequency = 288)


# holtwinter
fit  <- HoltWinters(temperature.ts)
result <- forecast(fit)
plot(forecast(fit))
alpha <- result$model$alpha
gamma <- result$model$gamma

plot(temperature.ts, main="Data and Fitted with model")
lines(fit$fitted[,2], col="red")