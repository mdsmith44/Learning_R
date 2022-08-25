library(shiny)

#Define a ui function that determines layout of objects
#objects can be Input or Output objects
#Each input function has "inputID" as first argument, used to identify it in callbacks.
#Most input functions then have "label" has 2nd arg, and "value" (i.e. initial default value) as 3rd arg
ui <- fluidPage(
  #Try different inputs, one at a time with ID "input", then see its value
  textInput("text",label=NULL,value='Your name'),
  

  
  #Output functions all take ID as first arg, and are referenced with output$their_id
  #Three main types: text, tables, and plot
  #Each output has corresponding render functions to populate them
  
  #Text output
  
  #use textOutput to output regular text
  textOutput("summary"), #has corresponding renderText function below
  
  #use verbatimTextOutput to output code and console output
  verbatimTextOutput('code1'),
  verbatimTextOutput('code2'),
  
  #Tables
  #Use tableOutput (with renderTable) for static tables
  #use dataTabelOutput (with rednerDataTable) for dyanmic tables
  tableOutput("static"),
  dataTableOutput("dynamic"),
  
  plotOutput("plot", width = "400px")
  
)


server <- function(input, output, session) {
  # Create a reactive expression which only runs first time then caches results
  #Specify which one we want to see the value of
  get_input_value <- reactive(input$text)
  
  output$summary <- renderText({
    get_input_value()
  })
  #renderText will create single string, usually paired with textOutput
  #renderPrint will PRINT the results as if you wer in R console, usually
  #paired with verbatimTextOutput
  output$code1 <- renderText(get_input_value())
  output$code2 <- renderPrint(get_input_value())
  #Render functions only need {} if multiple lines
  
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars,
                                    options=list(pageLength=5))
  
  #display plot with plotOutput and renderPlot
  #works for any plots (base, ggplot2, otherwise)
  output$plot <- renderPlot(plot(1:5))
  
}
#Note that we can't have non-reactive function in ther?

shinyApp(ui, server)