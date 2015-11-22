
library(dplyr)
library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)



shinyUI(fluidPage(
  titlePanel("What are my chances?"),
  fluidRow(column(12,align="center",

           wellPanel(
              sliderInput("sat", "SAT score (combined)",
                         0, 2400, 0, step = 10),
              sliderInput("gpa", "GPA", 0,4, 0, step = .1),
              sliderInput("apnum", "Number of AP exams taken", 0,10, 0, step = 1),
              sliderInput("apave", "Average AP score",
                         0, 5, 0, step = .1),
              sliderInput("sat2ave", "Average SAT Subject test score",
                          0, 800, 0, step = 10)
              

             
          
             
#            )),
            
     
#   
#   wellPanel(
#     #selectInput("xvar", "X-axis variable", axis_vars, selected = "GPA"),
#     #selectInput("yvar", "Y-axis variable", axis_vars, selected = "SAT"),
#     tags$small(paste0(
#       "Note: This predictor tool is based on data from only a sample of students",
#       " and does not provde a guarantee of admission to any institution."
#       
#     )))
  )
,column(4,selectInput("hs","What type of high school did you attend?",
                        c("Public"="-1","Private"="1","Parochial"="1","Homeschool"="1")),
           radioButtons("gender","What gender do you identify as?",
                        c("Female"="1","Male"="-1","Other"="0")),
           selectInput("race","What ethnicity do you identify as?",
                       c("African American/Black"="1","Hispanic/Latino"="1",
                         "Asian"="0","Middle Eastern"="0","Pacific Islander"="1",
                         "Native American"="1","White"="0","Other"="1")),
           radioButtons("international","Are you a foreign national?",
                        c("Yes"=1,"No"=-1))
        
        
),
column(4,
       radioButtons("firstinfamily","Are you the first in your family to attend university?",
                    c("Yes"=1,"No"=-1)),
       
       radioButtons("sports","Do you play varsity athletics?",
                                c("Yes"=1,"No"=-1)),
       radioButtons("arts","Are you involved in the arts?",
                                c("Yes"=1,"No"=-1)),
       radioButtons("work","Do you have work experience?",
                                c("Yes"=1,"No"=-1))
                   ),
       column(4, radioButtons("alum","Are you a legacy at this school?",
                              c("Yes"=1,"No"=-1)),
              radioButtons("out","Are you applying from out of state?",
                              c("Yes"=1,"No"=-1)),
              radioButtons("early","Are you applying early?",
                              c("Yes"=1,"No"=-1)),
              radioButtons("visit","Have you visited the school?",
                           c("Yes"=1,"No"=-1))))),
fluidRow(    column(12,align="center",selectInput("college", "What college are you applying to?",
                    c("","Princeton","Harvard","Yale","Columbia","Stanford","UChicago",
                      "MIT","Duke","UPenn","CalTech","JohnsHopkins","Dartmouth","Northwestern",
                      "Brown","Cornell","Vanderbilt","WashU","Rice","Notre Dame",
                      "UCB","Emory","Georgetown","CarnegieMellon","UCLA","USC")),
              h2(uiOutput("headerText")),
              h5(uiOutput("alert"))))))