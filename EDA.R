app = read.csv("collegedata_unnormalized.csv",header=T)
df = app[ , c("studentID", "GPA","AP","averageAP","schooltype","international","earlyAppl","firstinfamily", "admissionstest","canAfford","female","MinorityRace","collegeID","acceptStatus")]
df$collegeID = as.factor(df$collegeID)
df = df[df$acceptStatus!=0,]
df$firstinfamily = NULL
summary(df)
na_count = sapply(df, function(y) sum(length(which(is.na(y)))))
na_count = data.frame(na_count)
df$averageAP = NULL

mod1 = glmer(acceptStatus~MinorityRace*collegeID+(1| studentID),family="binomial", data=df)
# CHANGE acceptStatus to 0,1 instead of -1,+1
# take exp(estimate) to make odds ratio. Or another transform to gen. probability

# why we are doing in R and not Python: http://www.r-bloggers.com/r-vs-python-practical-data-analysis-nonlinear-regression/

sumafit = aov(acceptStatus~MinorityRace*collegeID, data=df)
summary(fit)

# linear mixed effects function, lme, glme

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
462 / (462 + 753)
213 / (213 + 364)
# yes = both at 37%

# Diversity plot in Overview

nonAccNonMin = sqldf("select collegeID,  avg(admissionstest) as a from df where MinorityRace != 1 and acceptStatus != 1 group by collegeID order by collegeID")
AccMin = sqldf("select collegeID,  avg(admissionstest) as a from df where MinorityRace = 1 and acceptStatus = 1 group by collegeID order by collegeID")
AccMaj = sqldf("select collegeID,  avg(admissionstest) as a from df where MinorityRace != 1 and acceptStatus = 1 group by collegeID order by collegeID")
minor = cbind(college = lapply(AccMin$collegeID,as.character), avgAcceptedMinority = AccMin$a, avgRejectedNonMinority = nonAccNonMin$a, avgAcceptedNonMinority = AccMaj$a)

dfs=AccMin
dfs$diff = AccMaj$a - dfs$a
dfs = dfs[dfs$collegeID!='CalTech',]
dfs$colOrder = reorder(dfs$collegeID,dfs$diff)
ggplot(dfs,aes(factor(collegeID), diff, fill=diff)) + 
  geom_bar(aes(x=colOrder),data=dfs,stat="identity") + coord_flip() +
  ylab("Premium Given to Underrepresented Minority Standardized Test Score") +
  xlab("College")
mean(dfs$diff)

df.minor = data.frame(minor)
SATdiff = as.numeric(df.minor$avgAcceptedNonMinority) - as.numeric(df.minor$avgAcceptedMinority)
df.satdiff = cbind(college=df.minor$college, SATdiff = SATdiff)
satdiff.ordered = data.frame(df.satdiff[order(-SATdiff),])


# can't afford it but still got in
sqldf("select collegeID,  cast(sum((canAfford=-1) and (acceptStatus=1)) as float)/count(*) as ratio from df group by collegeID order by ratio")


