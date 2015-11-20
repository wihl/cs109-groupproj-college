app = read.csv("collegedata_unnormalized.csv",header=T)
df = app[ , c("GPA","AP","averageAP","schooltype","international","earlyAppl","firstinfamily", "admissionstest","canAfford","female","MinorityRace","collegeID","acceptStatus")]
df$collegeID = as.factor(df$collegeID)
df = df[df$acceptStatus!=0,]
df$firstinfamily = NULL
summary(df)
na_count = sapply(df, function(y) sum(length(which(is.na(y)))))
na_count = data.frame(na_count)
df$averageAP = NULL

fit = aov(acceptStatus~MinorityRace*collegeID, data=df)
summary(fit)

df$acceptRace = df$acceptStatus * df$MinorityRace

harvard = subset(df, df$collegeID=='Harvard')
allothers = subset(df, df$collegeID!='Harvard')
sum(df$MinorityRace==1 & df$collegeID=='WashU' & df$acceptStatus==1)
sum(df$MinorityRace==1 & df$collegeID=='WashU' & df$acceptStatus!=1)
sum(df$collegeID=='WashU')
38/499
42/499
mean(df$admissionstest[df$acceptStatus==1])
mean(df$admissionstest[df$acceptStatus!=1])
mean(df$admissionstest[df$acceptStatus!=1 & df$MinorityRace==1])
mean(df$admissionstest[df$acceptStatus==1 & df$MinorityRace==1])
mean(df$admissionstest[df$acceptStatus==1 & df$MinorityRace!=1])
mean(df$GPA[df$acceptStatus==1 & df$MinorityRace!=1])
mean(df$GPA[df$acceptStatus==1 & df$MinorityRace==1])

library(sqldf)
sqldf("select collegeID, count(*) from df where acceptStatus = 1 group by collegeID")
sqldf("select collegeID,  cast(sum((acceptStatus=1) and (MinorityRace !=1)) as float)/count(*) as ratio from df group by collegeID")
sqldf("select collegeID,  cast(sum((acceptStatus=1) and (MinorityRace =1)) as float)/count(*) as ratio from df group by collegeID")
sqldf("select collegeID,  avg(admissionstest) as a from df group by collegeID order by a")
sqldf("select collegeID,  avg(admissionstest) as a from df where MinorityRace != 1 group by collegeID order by a")
# truly needs blind?
table(df$canAfford,df$acceptStatus)
457 / (457 + 753)
214 / (214 + 364)
# yes = both at 37%

# can't afford it but still got in
sqldf("select collegeID,  cast(sum((canAfford=-1) and (acceptStatus=1)) as float)/count(*) as ratio from df group by collegeID order by ratio")


library(randomForest)
fit = randomForest(as.factor(acceptStatus)~.,data=df2,importance=T, ntree=200)
varImpPlot(fit)
importance(fit)
