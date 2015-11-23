## shape data for MST
load('model.RData')

importdf<-as.data.frame(importance(rf))
importdf$features<-row.names(importdf)
importdf$order<-order(importdf$MeanDecreaseGini)
drops <- c("instatePct")
importdf<-importdf[,!(names(importdf) %in% drops)]