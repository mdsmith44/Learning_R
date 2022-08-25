#First shiny app

library(shiny)

#Define a ui function that determines layout of objects
#objects can be Input or Output objects
#Each has a name as it's first element
ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  tableOutput("table"),
  verbatimTextOutput("summary")
  
)

#We can reference input and output objects in server function by their IDs
#And can reference fields of each object by their labels
# server <- function(input, output, session) {
#   output$summary <- renderPrint({
#     dataset <- get(input$dataset, "package:datasets")
#     summary(dataset)
#   })
#   
#   output$table <- renderTable({
#     dataset <- get(input$dataset, "package:datasets")
#     dataset
#   })
# }
#Note that within server, there is automagically two named lists, "input"
#and "output", where names refer to Input or Output objects.
#E.g. output$table refers to the Output object with the ID "table", 
#which is tableOutput("table").
# Hence, server function describes the behavior of how changes to inputs
#affect outputs.  THis is known as reactivity.

#Also not that the functions which connect Inputs to outputs must be Reactive
#functions.  Hence, if we tried to use "output$summary <- print(...)" it would
#not work because print is not a reactive function.
# In general the renderType reactive function specifies the type of output (e.g.
#text, plots, tables), and the typeOutput element it is paired with seems to be
#the container to hold and display that output (e.g. tableOutput)

#Here's another version of server that uses reactive expression to generate data
#within each output updating function
server <- function(input, output, session) {
  # Create a reactive expression which only runs first time then caches results
  dataset <- reactive({
    get(input$dataset, "package:datasets")
  })
  #Could do same with non-reactive function, but then re-computes each time
  # dataset <- function() {
  #   get(input$dataset, "package:datasets")
  # }
  
  output$summary <- renderPrint({
    # Use a reactive expression by calling it like a function
    summary(dataset())
  })
  
  output$table <- renderTable({
    dataset()
  })
}
#Note that we can't have non-reactive function in ther?

shinyApp(ui, server)

