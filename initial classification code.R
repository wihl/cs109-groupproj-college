library(mice)
library(randomForest)
library(e1071)
setwd("Desktop/Uni/Harvard/121/final-project/cs109-groupproj-college/")
dfr = read.csv("testdf.csv",header=T)
# impute data
y=mice(dfr)
# logistic regression
log_reg = glm(acceptStatus ~., data=complete(y), family=binomial(link="logit"))
log_reg$fitted.values
# random forest
rf = randomForest(acceptStatus ~., data=complete(y))
rf$predicted
# svm
dsvm = svm(acceptStatus~., data=complete(y),probability=T)
dsvm$probA
predict(dsvm,complete(y))
