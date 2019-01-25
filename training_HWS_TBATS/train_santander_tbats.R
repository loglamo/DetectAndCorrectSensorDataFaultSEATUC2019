library(forecast)
library(ggplot2)
require(graphics)
library(fpp2)


data_clean<-read.table(file="~/Fault_Detecting/fault_detect/santander_train.txt",sep=",",row.names=1,header=TRUE)
data.temperature_clean <- data_clean$temperature#data training 
temperature.ts <- ts(data.temperature_clean, frequency = 288)


# holtwinter
fit.tbats <- tbats(temperature.ts)
result <- forecast(fit.tbats)
plot(forecast(fit.tbats))
alpha <- result$model$alpha
gamma <- result$model$gamma

plot(temperature.ts, main="Data and Fitted with model")
#lines(fit.tbats$fitted.values[1:(length(fit.tbats$fitted.values))], col="red")