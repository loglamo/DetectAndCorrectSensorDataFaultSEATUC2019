library(forecast)


data_clean<-read.table(file="/home/pi/Desktop/CollectDataToMod/Dataset/clean_drift_2.txt",sep=",",row.names=1,header=TRUE)
data_driff <- read.table(file ="/home/pi/Desktop/CollectDataToMod/Dataset/drift_2_scope.txt",sep=",",row.names=1,header=TRUE )
data.temperature_clean <- data_clean$temperature#data training 
temperature.ts <- ts(data.temperature_clean, frequency = 288)
data.drift <- data_driff$temperature#data needed to test 
data.drift.ts <- ts(data.drift, frequency = 288)

# holtwinter
# fit  <- HoltWinters(temperature.ts)
# result <- forecast(fit)
# plot(forecast(fit))
# alpha <- result$model$alpha
# gamma <- result$model$gamma

#plot(temperature.ts, main="Data and Fitted with model")
#lines(HoltWinters(temperature.ts)$fitted[,2], col="red")
alpha = 0.6236759
gamma = 0.5300464

index <- length(data.drift)
               
#par()
#par(opar <- par())
#plot(index, data.drift[1:1500], type="n", main="drift_2", ylab="Temperature",cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
#lines(index, data.drift[1:1500], type="l",col="blue") # draw line in plot


df <- data.frame(matrix(ncol = 15, nrow = 20))
x <- c('time 1','time 2','time 3','time 4','time 5','time 6','time 7','time 8','time 9','time 10','time 11','time 12','time 13','time 14','time 15')
colnames(df) <- x

for (k in c(1:15)){
 result <- data.drift[1:600]
 time.result <- c()
 for(i in c(601:852)){
  start.time.detecting.correcting <- Sys.time()
  modelI <- HoltWinters(ts(result[(i-577):(i-1)], frequency = 288),alpha = alpha,gamma = gamma)
  data.forecastI <- forecast(modelI,h = 1)
  data.real <- data.drift[i]
  if((data.real < (data.forecastI$lower[,2]-3))||(data.real > (data.forecastI$upper[,2]+2))){
    print("Having fault............")
    result <- c(result, runif(1, min=data.forecastI$lower[,2], max=data.forecastI$upper[,2]))
    end.time.detecting.correcting <- Sys.time()
    time.taken <- end.time.detecting.correcting - start.time.detecting.correcting
    time.result <- c(time.result, time.taken)
  }else{
    print("Normal status.....")
    result <- c(result, data.real)
  }
}


 timei = as.character(k)
name.col <- paste("time",timei)
df[name.col] <- time.result
 print("...........mata")
}
#par()
#par(opar <- par())
#plot(index_result, result, type="n", main="corrected_drift2", ylab="Temperature", cex.main=1.0,  cex.lab=1.0, cex.axis=1.0) # draw plot
write.csv(df, file = "/home/pi/Desktop/CollectDataToMod/result_drift.csv")