#At minimum, server.R needs to instantiate a server
#wit the shinyServer function
library(shiny)

library(ggplot2)

data(diamonds, package='ggplot2')



shinyServer(function(input,  output, session)
  
{
  
  output$HistPlot <- renderPlot({
    
    ggplot(diamonds, aes_string(x=input$VarToPlot)) +
      
      geom_histogram(bins=30)
    
  })
  
})
# input is named list holding all values of user inputs.  Names are the inputId's of various
#input element.  Ex: 
# output is named list of rendered R objects accessible by UI, names are outputId's.  
#session is optional

#function can be blank, which means it has no effect
#other than simply enabling app to be run