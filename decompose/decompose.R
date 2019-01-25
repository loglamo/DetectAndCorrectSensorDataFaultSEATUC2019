library(forecast)

data_clean<-read.table(file="~/Fault_Detecting/fault_detect/santander16_clean.txt",sep=",",row.names=1,header=TRUE)

temperature.ts <- ts(data_clean$temperature, frequency = 288)
# data.forecast <- forecast(temperature.ts, h = 30, gamma = 0.5)
# temperature.test <- data$temperature[830:864]
# test.ts <- ts(temperature.test, frequency = 288)
# datatest.forecast <- forecast(temperature.ts, h = 30)
decompose_temp = decompose(temperature.ts, "additive")

plot(decompose_temp)