
library(dplyr)
library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)



shinyUI(fluidPage(
  titlePanel("What are my chances?"),
  fluidRow(
    column(4,
           wellPanel(
             h4("Input your application information."),
              sliderInput("sat", "SAT score (combined)",
                         0, 2400, 1500, step = 10),
              sliderInput("gpa", "GPA", 0,4, 2, step = .1),
              textInput("apnum", "Number of AP exams taken"),
              sliderInput("apave", "Average AP score",
                         1, 5, 1, step = .1),
             textInput("sat2num", "Number of SAT Subject tests taken"),
              sliderInput("sat2ave", "Average SAT Subject test score",
                          1, 800, 10, step = .1)
              

             
          
             
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
),
column(4,wellPanel(
           selectInput("hs","What type of high school did you attend?",
                        c("Public","Private","Parochial","Homeschool")),
           radioButtons("gender","What gender do you identify as?",
                        c("Female","Male","Other")),
           selectInput("race","What ethnicity do you identify as?",
                       c("African American/Black","Hispanic/Latino",
                         "Asian","Middle Eastern","Pacific Islander",
                         "Native American","Other")),
           radioButtons("international","Are you a foreign national?",
                        c("Yes","No")),
           radioButtons("firstinfamily","Are you the first in your family to attend university?",
                        c("Yes","No")),
           radioButtons("alum","Are you a legacy at this school?",
                        c("Yes","No"))
           )),
column(3,wellPanel(radioButtons("out","Are you applying from out of state?",
                                c("Yes","No")),
                   radioButtons("sports","Do you play varsity athletics?",
                                c("Yes","No")),
                   radioButtons("arts","Are you involved in the arts?",
                                c("Yes","No")),
                   radioButtons("work","Do you have work experience?",
                                c("Yes","No")),
                   selectInput("college", "What college are you applying to?",
                    c("","Princeton","Harvard","Yale","Columbia","Stanford","UChicago",
                      "MIT","Duke","UPenn","CalTech","Johns Hopkins","Dartmouth","Northwestern",
                      "Brown","Cornell","Vanderbilt","WashU","Rice","Notre Dame",
                      "UCB","Emory","Georgetown","Carnegie Mellon","UCLA","USC")),
                        actionButton("goButton", label = "Submit"),
                 h2(uiOutput("headerText")))))))