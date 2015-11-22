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
    
    if (input$college!=""&&!is.null(gotime)){
    
    logitfun <- glm(acceptStatus ~ GPA + admissionstest + name, data = data, family = "binomial")
    testdata<-data.frame(GPA=input$gpa,admissionstest=input$sat,name=input$college)
    testdata$rankP<-predict(logitfun,newdata=testdata,type="response")
    
    str1 <- paste("<p>Our algorithm predicts you have a")
    str2 <- paste("percent chance of getting in to")
    HTML(str1,testdata$rankP,str2,input$college)}
       
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
