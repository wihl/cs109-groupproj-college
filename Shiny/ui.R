library(ggvis)
library(dplyr)
library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

shinyUI(fluidPage(
  titlePanel("What are my chances?"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Input your application information."),
             sliderInput("sat", "SAT score (combined)",
                         0, 2400, 1500, step = 10),
             sliderInput("gpa", "GPA", 0, 5, step = .1),
             textInput("apnum", "Number of AP exams taken"),
             sliderInput("apave", "Average AP score",
                         1, 5, 1, step = .1),
             textInput("sat2num", "Number of SAT Subject tests taken"),
             sliderInput("sat2ave", "Average SAT Subject test score",
                         1, 800, 10, step = .1),
             radioButton("hs","What type of high school did you attend?",
                         c("Public","Private","Parochial","Homeschool")),
             radioButton("gender","What gender do you identify as?",
                         c("Female","Male","Other")),
             selectInput("race","What ethnicity do you identify as?",
                         c("African American/Black","Hispanic/Latino",
                           "Asian","Middle Eastern","Pacific Islander",
                           "Native American","Other")),
             radioButton("international","Are you a foreign national?",
                         c("Yes","No")),
             radioButton("firstinfamily","Are you the first in your family to attend university?",
                         c("Yes","No")),
             radioButton("alum","Are you a legacy at this school?",
                         c("Yes","No")),
             radioButton("alum","Are you applying from out of state?",
                         c("Yes","No")),
             radioButton("sports","Do you play varsity athletics?",
                         c("Yes","No")),
             radioButton("arts","Are you involved in the arts?",
                         c("Yes","No")),
             radioButton("work","Do you have work experience?",
                         c("Yes","No")),
             
          
             
           ),
           selectInput("college", "What college are you applying to?",
                       c("Princeton","Harvard","Yale","Columbia","Stanford","UChicago",
                         "MIT","Duke","UPenn","CalTech","Johns Hopkins","Dartmouth","Northwestern",
                         "Brown","Cornell","Vanderbilt","WashU","Rice","Notre Dame",
                         "UCB","Emory","Georgetown","Carnegie Mellon","UCLA","USC"))
    )),
  
  wellPanel(
    selectInput("xvar", "X-axis variable", axis_vars, selected = "GPA"),
    selectInput("yvar", "Y-axis variable", axis_vars, selected = "SAT"),
    tags$small(paste0(
      "Note: This predictor tool is based on data from only a sample of students",
      " and does not provde a guarantee of admission to any institution."
      
    ))
  )
),
column(9,
       ggvisOutput("plot"),
       
)
)
)
))