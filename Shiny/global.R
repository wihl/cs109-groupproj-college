## shape data for MST
load('model.RData')
act2sat<-data.frame(sat=list(1600, 1560, 1510, 1460, 1420, 1380, 1340, 1300, 1260, 1220, 1190, 1150, 1110, 1070, 1030, 990, 950, 910, 870,
                         830, 790, 740, 690, 640, 590, 530),act=list(36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19,
                                                                  18, 17, 16, 15, 14, 13, 12, 11))

datanormed<-read.csv("collegedata_normalized.csv")
datanormed$SATsubject<-as.numeric(datanormed$SATsubject)

drops <- c("X","studentID","classrank","GPA_w","program","intendedgradyear","addInfo","canAfford",
           "MinorityGender","firstinfamily","artist","workexp","collegeID")
subdata<-dataunnormed[,1:27]
subdata<-subdata[,!(names(subdata) %in% drops)]
