## shape data for MST
require(plyr)
require(reshape2)

  
dataset<-read.csv("collegedata_normalized.csv")
data <-dataset[dataset$acceptStatus!=0,]
data$acceptStatus[data$acceptStatus==-1]<-0


dataunnormed<-read.csv("collegedata_unnormalized.csv")
dataunnormed$SATsubject<-as.numeric(dataunnormed$SATsubject)



