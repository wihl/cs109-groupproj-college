library(lmerTest)

##this is just one example of how LMER may be used to investigate
##college-by-college differences. 

datanormed<-read.csv("collegedata_normalized.csv")


model<-glmer(acceptStatus~ female + (1+female|name),family="binomial",data=datanormed)
plotdf<-data.frame(matrix(nrow=25,ncol=2))
plotdf$names<-row.names(coef(model)$name)
plotdf$vals<-coef(model)$name[,2]
plotdf$sorted<-reorder(plotdf$names,plotdf$vals)


ggplot(data=plotdf,aes(y=vals,x=sorted,fill=vals))+
  geom_bar(stat="identity")+
  ggtitle(paste('Effect of Being Female'))+
  xlab(paste('College'))+
  ylab(paste('Effect Size'))+
  guides(fill=FALSE)+
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
        panel.background = element_blank(), axis.line = element_line(colour = "black"))+
   theme(axis.text.x=element_text(angle = -90, hjust = 0))
