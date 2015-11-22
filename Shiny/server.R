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
    at_normed<-(input$sat - mean(dataunnormed$admissionstest,na.rm=TRUE))/(max(dataunnormed$admissionstest,na.rm=TRUE)-min(dataunnormed$admissionstest,na.rm=TRUE))
    apave_normed<-(input$apave - mean(dataunnormed$averageAP,na.rm=TRUE))/(max(dataunnormed$averageAP,na.rm=TRUE)-min(dataunnormed$averageAP,na.rm=TRUE))
    sat2ave_normed<-(input$sat2ave - mean(dataunnormed$SATsubject,na.rm=TRUE))/(max(dataunnormed$SATsubject,na.rm=TRUE)-min(dataunnormed$SATsubject,na.rm=TRUE))
    
    logitfun <- glm(acceptStatus ~ GPA + admissionstest + AP + averageAP +
                      #SATsubject + schooltype + female + 
                      #MinorityGender + MinorityRace +
                      #international + 
                      #sports + 
                      name,
                      #earlyAppl +
                      #alumni + outofstate + acceptrate +
                      #size + public, 
                      data = data, family = "binomial",na.action=na.omit)
     
    testdata<-data.frame(GPA=gpa_normed,admissionstest=at_normed,AP = input$apnum, averageAP = apave_normed,
                           #SATsubject = sat2ave_normed, schooltype = as.numeric(input$hs), female=as.numeric(input$gender),
                        #MinorityGender=as.numeric(input$gender), MinorityRace = as.numeric(input$race), 
                         name=input$college) #international = as.numeric(input$international),
                          #sports = as.numeric(input$sports), name=input$college, earlyAppl = as.numeric(input$early),
                           #alumni=as.numeric(input$alum),outofstate=as.numeric(input$out),
                         #acceptrate=data$acceptrate[data$name==input$college][1], 
                         #size = data$size[data$name==input$college][1], public = data$public[data$name==input$college][1])
                        # finAidPct = data$finAidPct[data$name==input$college], instatePct =data$instatePct[data$name==input$college] )
    testdata$rankP<-predict(logitfun,newdata=testdata,type="response")
    
    str1 <- paste("<p>Our algorithm predicts you have a")
    str2 <- paste("percent chance of getting in to")
    HTML(str1,round(100*testdata$rankP,digits=2),str2,input$college)}
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
