library(shiny)
library(shinyBS)
require(ggplot2)
require(reshape2)
require(plyr)
require(curl)
library(randomForest)
library(ggvis)
library(jsonlite)


# Define server logic
shinyServer(function(input, output, session) {

 
 
 observeEvent(input$goButton, {gotime<-1
  })
  
 
  
  # get text for header
  output$headerText <- renderUI({
    
    if (input$college!=""){
      
    #translate SAT and ACT to combined score
    if (as.numeric(input$act)==0 && as.numeric(input$sat)!=0)
    {at = as.numeric(input$sat)}
    else if (as.numeric(input$sat)==0 && as.numeric(input$act)!=0)
    {
      #convert act to sat
      at = act2sat$sat[act2sat$act==as.numeric(input$act)]}
    else
    {at = 0}
    #normalize against test data
    gpa_normed<-(as.numeric(input$gpa) - normedmeans$GPA)/normedstds$GPA
    at_normed<-(at - normedmeans$admissionstest)/normedstds$admissionstest
    apave_normed<-(as.numeric(input$apave) - normedmeans$averageAP)/normedstds$averageAP
    #sat2ave_normed<-(as.numeric(input$sat2ave) - normedmeans$SATsubject)/normedstds$SATsubject
    
    
    #process values into boolean
    if (as.integer(input$race)>0)
      {race = 1}
    else {race=0}
    if (as.integer(input$hs)>0)
    {hs = 1}
    else {hs=0}
    if (as.integer(input$gender)>0)
    {fem = 1}
    else {fem=0}
    if (input$apnum==0)
    {apave_normed=0}
    
    
    pred = data.frame(admissionstest=numeric(0),
                      AP=numeric(0),
                      averageAP=numeric(0),
                      SATsubject=numeric(0),
                      GPA=numeric(0),
                      schooltype=numeric(0),
                      female=numeric(0),
                      MinorityRace=numeric(0),
                      international=numeric(0),
                      sports=numeric(0),
                      earlyAppl=numeric(0),
                      alumni=numeric(0),
                      outofstate=numeric(0),
                      acceptrate=numeric(0),
                      size=numeric(0),
                      public=numeric(0))


    pred[1,] = list(at_normed,  as.numeric(input$apnum), apave_normed,   input$sat2ave,
                    gpa_normed,   hs,   fem,
                    race,   as.numeric(input$international),   as.numeric(input$sports),   as.numeric(input$early),
                    as.numeric(input$alum),   as.numeric(input$out),   
                    datanormed$acceptrate[datanormed$name==input$college][1],   
                    datanormed$size[datanormed$name==input$college][1],
                    datanormed$public[datanormed$name==input$college][1])
    
    
    # create query string
    qs = paste0(colnames(pred),"=",pred[1,],collapse="&")
    
    server = "https://boiling-forest-8250.herokuapp.com/predict"
    
    URL = paste0(server,"?",qs)
    
    js  = fromJSON(URL)
    df = js$preds
    df$college = as.factor(df$college)
    #HTML(qs)
    
    
    #report
    str1 <- paste("<p>Our algorithm predicts you have a<br>")
    str2 <- paste("percent chance of getting in to")
    HTML(str1,100*df$prob[df$college==input$college],str2,input$college)
    }
       
     })
  
  #echo importances
  output$importance<- renderPlot({
    
    if (input$college!=""){
      
      createAlert(session, "alert", "Alert", title = "This prediction is not a guarantee of admission.", 
                  "We are simply interested in exploring how application factors affect college admissions. Our algorithm is 74% accurate.", append = FALSE);
      
      drops <- c("finAidPct","instatePct")
      newimportdf<-importdf[!(rownames(importdf) %in% drops),]
      
    ggplot(data=newimportdf,aes(y=MeanDecreaseGini,x=reorder,fill=MeanDecreaseGini))+
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
    HTML("This plot shows the relative importance of various parts of the application. In other words, when we train a model to predict your chance of admission, it weights the different aspects of your application according to these importances. Notice that admissionstest, which codes your SAT and ACT scores, plays the largest role in determining your chances of acceptance.")
    }
      })
  
  
  #echo scatterplot
  vis<- reactive({

      # Lables for axes
      xvar_name <- colnames(subdata)[colnames(subdata) == input$xvar]
      yvar_name <- colnames(subdata)[colnames(subdata) == input$yvar]
      
      # Normally we could do something like props(x = ~GPA, y = ~admissionstest),
      # but since the inputs are strings, we need to do a little more work.
      xvar <- prop("x", as.symbol(input$xvar))
      yvar <- prop("y", as.symbol(input$yvar))
      
      if (input$college!='')
      {graphdata = dataunnormed[dataunnormed$name==input$college,]
      graphdata$acceptStatus[graphdata$acceptStatus==-1]<-0}
      else
      {graphdata = dataunnormed
      graphdata$acceptStatus[graphdata$acceptStatus==-1]<-0}
      
      
      graphdata %>%
        ggvis(x = xvar, y = yvar) %>%
        layer_points(size := 50, size.hover := 200,
                     fillOpacity := 0.2, fillOpacity.hover := 0.5,
                     stroke = ~acceptStatus) %>%
        #layer_points(x = xvar, y= yvar, size := 50, fillOpacity=1,fill:="red", data = testdata)%>%
        add_axis("x", title = xvar_name) %>%
        add_axis("y", title = yvar_name) %>%
        add_legend("stroke", title = "Accepted", values = c("Yes", "No")) %>%
        #scale_nominal("stroke", domain = c("Yes", "No"),
                      #range = c("blue", "#aaa")) %>%
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
