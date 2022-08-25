library(shiny)

#Define a ui function that determines layout of objects
#objects can be Input or Output objects
#Each input function has "inputID" as first argument, used to identify it in callbacks.
#Most input functions then have "label" has 2nd arg, and "value" (i.e. initial default value) as 3rd arg
ui <- fluidPage(
  #Try different inputs, one at a time with ID "input", then see its value
  textInput("text",label=NULL,value='Your name'),
  
  #Slider input.  Use two values for multi-slider
  sliderInput("slider", "Number two", value = 0, min = 0, max = 100,step = 5,animate = T),
  
  #Animate scrolling through options
  sliderInput("slider_animate", "Animation", value = 0, min = 0, max = 100),
  
  #Select input with grouping
  selectInput("state", "Choose a state:",
              choices=list('East Coast' = list("NY", "NJ", "CT"),
                           'West Coast' = list("WA", "OR", "CA"),
                           'Midwest' = list("MN", "WI", "IA"))),

  #dateInput returns some integer encoding of dates
  dateRangeInput("daterange", "When do you want to go on vacation next?"),

  #For radioButtons, we can give different labels to user vs values sent back to server
  radioButtons("rb", "Choose one:",
               choiceNames = list(
                 icon("angry"),
                 icon("smile"),
                 icon("sad-tear")
               ),
               choiceValues = list("angry", "happy", "sad")
  ),
  
  #Specify different classes of action buttons
  fluidRow(
    actionButton("click", "Click me!", class = "btn-danger"),
    actionButton("drink", "Drink me!", class = "btn-lg btn-success",icon=icon('cocktail'))
  ),
  
  #File input
  fileInput("input", NULL),
  
  #Output functions all take ID as first arg, and are referenced with output$their_id
  #Three main types: text, tables, and plot
  #Each output has corresponding render functions to populate them
  
  #Text output
  
  #use textOutput to output regular text
  textOutput("summary"), #has corresponding renderText function below
  
  #use verbatimTextOutput to output code and console output
  verbatimTextOutput('code1'),
  verbatimTextOutput('code2')
)


server <- function(input, output, session) {
  # Create a reactive expression which only runs first time then caches results
  #Specify which one we want to see the value of
  get_input_value <- reactive(input$slider)
  
  output$summary <- renderText({
    get_input_value()
  })
  #renderText will create single string, usually paired with textOutput
  #renderPrint will PRINT the results as if you wer in R console, usually
  #paired with verbatimTextOutput
  output$code1 <- renderText(get_input_value())
  output$code2 <- renderPrint(get_input_value())
  #Render functions only need {} if multiple lines
  
}
#Note that we can't have non-reactive function in ther?

shinyApp(ui, server)