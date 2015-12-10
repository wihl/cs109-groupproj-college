## shape data for MST
library(dplyr)
load('model.RData')
act2sat<-data.frame(sat=list(1600, 1560, 1510, 1460, 1420, 1380, 1340, 1300, 1260, 1220, 1190, 1150, 1110, 1070, 1030, 990, 950, 910, 870,
                         830, 790, 740, 690, 640, 590, 530),act=list(36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19,
                                                                  18, 17, 16, 15, 14, 13, 12, 11))

datanormed<-read.csv("collegedata_normalized.csv")
datanormed$SATsubject<-as.numeric(datanormed$SATsubject)

drops <- c("X","studentID","classrank","GPA_w","program","intendedgradyear","addInfo","canAfford",
           "MinorityGender","firstinfamily","artist","workexp","collegeID","visited")
dataunnormed$female[dataunnormed$female<1]<-0
dataunnormed$MinorityRace[dataunnormed$MinorityRace<1]<-0
dataunnormed$schooltype[dataunnormed$schooltype<1]<-0
dataunnormed$earlyAppl[dataunnormed$earlyAppl<1]<-0
dataunnormed$outofstate[dataunnormed$outofstate<1]<-0
dataunnormed$alumni[dataunnormed$alumnil<1]<-0
dataunnormed$international[dataunnormed$international<1]<-0
dataunnormed$sports[dataunnormed$sports<1]<-0
dataunnormed<-plyr::rename(dataunnormed,c("admissionstest"= "ACT/SAT score",
                                          "GPA"= "GPA",
                                          "averageAP"= "average AP score",
                                          "AP"= "# AP exams taken",
                                          "SATsubject"= "# SAT subject tests taken",
                                          "female"= "female indicator",
                                          "schooltype"= "private high-school indicator",
                                          "MinorityRace"= "minority indicator",
                                          "earlyAppl"= "early application",
                                          "outofstate"= "out of state indicator",
                                          "alumni"= "alumni indicator",
                                          "international"= "international indicator",
                                          "sports"= "varsity sports indicator"))
subdata<-dataunnormed[,1:27]
subdata<-subdata[,!(names(subdata) %in% drops)]


normedmeans<-read.csv("normalize_means.csv")
normedstds<-read.csv("normalize_stds.csv")

better_labels<-c("varsity sports indicator",
                 "international indicator",
                 "alumni indicator",
                 "public university indicator",
                 "out of state indicator",
                 "early application",
                 "minority indicator",
                 "private high-school indicator",
                 "female indicator",
                 "# SAT subject tests taken",
                 "# AP exams taken",
                 "college size",
                 "average AP score",
                 "GPA",
                 "ACT/SAT score")
