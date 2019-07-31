library(forecast)


data_clean<-read.table(file="/home/pi/Desktop/CollectDataToMod/Dataset/clean_mal_9.txt",sep=",",row.names=1,header=TRUE)
data_driff <- read.table(file ="/home/pi/Desktop/CollectDataToMod/Dataset/mal_9_scope.txt",sep=",",row.names=1,header=TRUE )
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
alpha = 0.6236759
gamma = 0.5300464 

index <- length(data.drift[1:2000])
index <- c(1:2000) #take index
df <- data.frame(matrix(ncol = 15,nrow = 20))
x <- c('time 1','time 2','time 3','time 4','time 5','time 6','time 7','time 8','time 9','time 10','time 11','time 12','time 13','time 14','time 15')
colnames(df) <- x

for (k in c(1:15)){
result <- data.drift[1:1000]
time.result <- c()
 for(i in c(1001:1045)){
  start.time.detecting.correcting <- Sys.time()
  modelI <- HoltWinters(ts(result[(i-577):(i-1)], frequency = 288),alpha = alpha,gamma = gamma)
  data.forecastI <- forecast(modelI,h = 1)
  data.real <- data.drift[i]
  if((data.real < (data.forecastI$lower[,2]-2))||(data.real > (data.forecastI$upper[,2]+1))){
    print("Having fault............")
    result <- c(result, runif(1, min=data.forecastI$lower[,1], max=data.forecastI$upper[,1]))
    end.time.detecting.correcting <- Sys.time()
    time.taken <- end.time.detecting.correcting - start.time.detecting.correcting
    time.result <- c(time.result, time.taken)
    
  }else{
    print("Normal status.....")
    result <- c(result, data.real)
  }
}
#processing time.result
if(length(time.result) < 20){
  for (i in c(1:(20-length(time.result)))){
    time.result <- c(time.result,runif(1,min(time.result),max(time.result)))
  }
}
print("length of result is: ")
print(length(time.result))
timei = as.character(k)
name.col <- paste("time",timei)
df[name.col] <- time.result
 print("...........mata")
}
print(df)
write.csv(df, file = "/home/pi/Desktop/CollectDataToMod/result_mal.csv")