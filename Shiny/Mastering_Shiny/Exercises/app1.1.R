#Create an app that greets the user by name.
library(shiny)

ui <- fluidPage(
  #textInput
  textInput("name", "What's your name?"),
  
  #Create textOutput with ID = 'greeting'
  textOutput("greeting")
)
server <- function(input, output, session) {
  #Use renderText to connect text from input$name to output$greeting
  output$greeting <- renderText({
    paste0('Hello ',input$name)
    })
  
}
shinyApp(ui, server)