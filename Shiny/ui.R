
library(dplyr)
library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)
library(randomForest)
library(ggvis)




shinyUI(fluidPage(
  titlePanel("Chance me."),
  fluidRow(column(12,align="center",

           wellPanel(
              sliderInput("sat", "SAT composite score",
                         0, 2400, 1200, step = 10),
              sliderInput("act", "ACT composite score",
                          0, 36, 18, step = 1),
              sliderInput("gpa", "GPA (unweighted)", 0,4, 2, step = .1),
              sliderInput("apnum", "Number of AP exams taken", 0,10, 5, step = 1),
              sliderInput("apave", "Average AP score",
                         0, 5, 2.5, step = .1),
              sliderInput("sat2ave", "Number of SAT Subject tests taken",
                          0, 10, 5, step = 1)

  )
,column(4,selectInput("hs","What type of high school did you attend?",
                        c("Public"="0","Private"="1","Parochial"="2","Homeschool"="3")),
           radioButtons("gender","What gender do you identify as?",
                        c("Female"="1","Male"="-1","Other"="0")),
           selectInput("race","What ethnicity do you identify as?",
                       c("African American/Black"="1","Hispanic/Latino"="2",
                         "Asian"="0","Middle Eastern"="-1","Pacific Islander"="3",
                         "Native American"="4","White"="-2","Other"="5"))
           
        
        
),
column(4, radioButtons("international","Are you a foreign national?",
                       c("No"=0,"Yes"=1)),
       radioButtons("firstinfamily","Are you the first in your family to attend university?",
                    c("No"=0,"Yes"=1)),
       
       radioButtons("sports","Do you play varsity athletics?",
                    c("No"=0,"Yes"=1))                   ),
       column(4, radioButtons("alum","Are you a legacy at this school?",
                              c("No"=0,"Yes"=1)),
              radioButtons("out","Are you applying from out of state?",
                           c("No"=0,"Yes"=1)),
              radioButtons("early","Are you applying early?",
                           c("No"=0,"Yes"=1))))),
fluidRow(    column(12,align="center",selectInput("college", "What college are you applying to?",
                    c("",as.character(unique(dataunnormed$name)))),
              h2(uiOutput("headerText")),
              bsAlert("alert"),
              br(),
              h4(uiOutput("importancehelper")),
              plotOutput("importance"),
              br(),
                conditionalPanel(condition="input.college!=''",wellPanel(
                  selectInput("xvar", "X-axis variable", colnames(subdata), selected = "GPA"),
                  selectInput("yvar", "Y-axis variable", colnames(subdata), selected = "admissionstest"),
                  tags$small(paste0(
                    "Pick any two factors and explore the relationship between them."))),
              ggvisOutput("plot1")),
              
              br()))))