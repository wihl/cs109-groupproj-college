rm(list=ls())
library(randomForest)

dataset<-read.csv("collegedata_imputed.csv")
data <-dataset[!is.na(dataset$acceptStatus),]
data$acceptStatus = as.factor(data$acceptStatus)
drops <- c("name","intendedgradyear","X")
subdata<-data[,!(names(data) %in% drops)]
rf = randomForest(acceptStatus ~., data=subdata,ntree=100,compute_importances=TRUE)
sum(rf$predicted==data$acceptStatus)/length(rf$predicted)
importdf<-as.data.frame(importance(rf))
importdf$features<-rownames(importdf)
importdf$reorder <- reorder(importdf$features,importdf$MeanDecreaseGini)


dataunnormed<-read.csv("collegedata_unnormalized.csv")
dataunnormed$SATsubject<-as.numeric(dataunnormed$SATsubject)
save.image("model.RData")
