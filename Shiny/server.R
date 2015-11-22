library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)


# Define server logic
shinyServer(function(input, output, session) {

 
 
 observeEvent(input$goButton, {gotime<-1
  })
  
 
  
  # get text for header
  output$headerText <- renderUI({
    
    if (input$college!=""){
    
    #normalize
    gpa_normed<-(input$gpa - mean(dataunnormed$GPA))/(max(dataunnormed$GPA)-min(dataunnormed$GPA))
    at_normed<-(input$sat - mean(dataunnormed$admissionstest))/(max(dataunnormed$admissionstest)-min(dataunnormed$admissionstest))
    apave_normed<-(input$apave - mean(dataunnormed$averageAP))/(max(dataunnormed$averageAP)-min(dataunnormed$averageAP))
    sat2ave_normed<-(input$sat2ave - mean(dataunnormed$SATsubject))/(max(dataunnormed$SATsubject)-min(dataunnormed$SATsubject))
    
    logitfun <- glm(acceptStatus ~ GPA + admissionstest + AP + averageAP +
                      SATsubject + schooltype + female + MinorityGender + MinorityRace +
                    international + firstinfamily +sports + artist + workexp + name +
                    earlyAppl + visited + alumni + outofstate + acceptrate +
                      size + public, data = data, family = "binomial")
    testdata<-data.frame(GPA=gpa_normed,admissionstest=at_normed,AP = input$apnum, averageAP = apave_normed,
                           SATsubject = sat2ave_normed, schooltype = input$hs, female=input$gender,
                         MinorityGender=input$gender, MinorityRace = input$race, international = input$international,
                         firstinfamily=input$firstinfamily, sports = input$sports, artist = input$arts,
                         workexp = input$work, name=input$college, earlyAppl = input$early, visited = input$visited,
                           alumni=input$alum,outofstate=input$out,
                         acceptrate=data$acceptrate[data$name==input$college][1], 
                         size = data$size[data$name==input$college][1], public = data$public[data$name==input$college][1])
                        # finAidPct = data$finAidPct[data$name==input$college], instatePct =data$instatePct[data$name==input$college] )
    testdata$rankP<-predict(logitfun,newdata=testdata,type="response")
    
    str1 <- paste("<p>Our algorithm predicts you have a")
    str2 <- paste("percent chance of getting in to")
    HTML(str1,round(100*testdata$rankP,digits=4),str2,input$college)}
    #HTML(str1,at_normed,str2,input$college)}
       
     })
  
 

  

#echo link to CS109
output$link <- renderUI({
   return(h4(p("Want to see other cool machine learning tools and projects? Visit",
                strong(a("the Harvard CS109 homepage", href="http://cs109.github.io")))))
  

})



  ## PART THREE: alert
  output$alert <- renderPlot({
   
    
        createAlert(session, "alert", "Alert", title = "This is not a guarantee of admission!", 
                    "This website is experimental and exploratory.", append = FALSE);
     
  })

  
})
