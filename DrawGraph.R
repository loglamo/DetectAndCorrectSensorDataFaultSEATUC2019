
#read file
santander20 <- read.csv("~/R_pro/test_non.txt",stringsAsFactors = FALSE) 
x11(width=10, height=10)# configure plot graph                                   

temperature <- santander20$temperature #take temperature in data
index <- length(temperature)
temp <- temperature[1:index] #take temperature value 
index <- c(1:index) #take index 
par()
par(opar <- par())
plot(index, temp, type="n", main="mixed-graph-16", cex.main=1.2,  cex.lab=1.5, cex.axis=1.5) # draw plot
lines(index, temp, type="l",col="blue") # draw line in plot 



