library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)
library(randomForest)
library(ggvis)


# Define server logic
shinyServer(function(input, output, session) {

 
 
 observeEvent(input$goButton, {gotime<-1
  })
  
 
  
  # get text for header
  output$headerText <- renderUI({
    
    if (input$college!=""){
    
    #normalize
    gpa_normed<-(as.integer(input$gpa) - mean(dataunnormed$GPA))/(max(dataunnormed$GPA)-min(dataunnormed$GPA))
    at_normed<-(as.integer(input$sat) - mean(dataunnormed$admissionstest,na.rm=TRUE))/(max(dataunnormed$admissionstest,na.rm=TRUE)-min(dataunnormed$admissionstest,na.rm=TRUE))
    apave_normed<-(as.integer(input$apave) - mean(dataunnormed$averageAP,na.rm=TRUE))/(max(dataunnormed$averageAP,na.rm=TRUE)-min(dataunnormed$averageAP,na.rm=TRUE))
    sat2ave_normed<-(as.integer(input$sat2ave) - mean(dataunnormed$SATsubject,na.rm=TRUE))/(max(dataunnormed$SATsubject,na.rm=TRUE)-min(dataunnormed$SATsubject,na.rm=TRUE))
    
    #process
    if (as.integer(input$race)>0)
      {race = 1}
    else {race=0}
    if (as.integer(input$hs)>0)
    {hs = 1}
    else {hs=0}
    
    
    
    testdata<-data.frame(GPA=gpa_normed,admissionstest=at_normed,AP = as.numeric(input$apnum), averageAP = apave_normed,
                         SATsubject = sat2ave_normed, 
                         schooltype = hs, female=as.numeric(input$gender),
                         MinorityGender=as.numeric(input$gender), MinorityRace = race,
                          international = as.numeric(input$international),
                          sports = as.numeric(input$sports), earlyAppl = as.numeric(input$early),
                          alumni=as.numeric(input$alum),outofstate=as.numeric(input$out),
                              acceptrate=data$acceptrate[data$name==input$college][1], 
                              size = data$size[data$name==input$college][1], public = data$public[data$name==input$college][1],
                         finAidPct = data$finAidPct[data$name==input$college][1], instatePct =data$instatePct[data$name==input$college][1] )

    prediction<-predict(rf,newdata=testdata,type="prob")
    
    str1 <- paste("<p>Our algorithm predicts you have a<br>")
    str2 <- paste("percent chance of getting in to")
    HTML(str1,prediction[2]*100,str2,input$college)}
       
     })
  
  #echo importances
  output$importance<- renderPlot({
    
    if (input$college!=""){
      
      createAlert(session, "alert", "Alert", title = "This prediction is not a guarantee of admission.", 
                  "This website is experimental. We are simply interested in exploring how application factors affect college admissions.", append = FALSE);
      
      
    ggplot(data=importdf,aes(y=MeanDecreaseGini,x=reorder,fill=MeanDecreaseGini))+
      geom_bar(stat="identity")+coord_flip()+
      ggtitle(paste('Importance of Application Components'))+
      xlab(paste('Application Component'))+
      ylab(paste('Effect Size'))+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
            panel.background = element_blank(), axis.line = element_line(colour = "black"))
    }
    
    
  })
  
  output$importancehelper <-renderUI({
    if (input$college!=""){
    HTML("This plot shows the relative importance of various parts of the application. In other words, when we train a model to predict your chance of admission, it weights the different aspects of your application according to these importances. Notice that admissionstest, which codes your SAT score, plays the largest role in determining your chances of acceptance.")
    }
      })
  
  
  #echo scatterplot
  vis<- reactive({

      # Lables for axes
      xvar_name <- colnames(subdata)[colnames(subdata) == input$xvar]
      yvar_name <- colnames(subdata)[colnames(subdata) == input$yvar]
      
      # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
      # but since the inputs are strings, we need to do a little more work.
      xvar <- prop("x", as.symbol(input$xvar))
      yvar <- prop("y", as.symbol(input$yvar))
      
      
      subdata %>%
        ggvis(x = xvar, y = yvar) %>%
        layer_points(size := 50, size.hover := 200,
                     fillOpacity := 0.2, fillOpacity.hover := 0.5,
                     stroke = ~acceptStatus) %>%
        #layer_points(x = xvar, y= yvar, size := 50, fillOpacity=1,fill:="red", data = testdata)%>%
        add_axis("x", title = xvar_name) %>%
        add_axis("y", title = yvar_name) %>%
        add_legend("stroke", title = "Accepted", values = c("Yes", "No")) %>%
        scale_nominal("stroke", domain = c("Yes", "No"),
                      range = c("blue", "#aaa")) %>%
        set_options(width = 500, height = 500)
      
    
  })
  
  vis %>% bind_shiny("plot1")
  

  

#echo link to CS109
output$link <- renderUI({
   return(h4(p("Want to see other cool machine learning tools and projects? Visit",
                strong(a("the Harvard CS109 homepage.", href="http://cs109.github.io")))))
  

})



  ## PART THREE: alert
  output$alert <- renderUI({
   
    
        createAlert(session, "alert", "Alert", title = "This is not a guarantee of admission!", 
                    "This website is experimental and exploratory. Feel free to toggle the settings to see how your chances might change with an extra AP class or two.", append = FALSE);
     
  })

  
})
