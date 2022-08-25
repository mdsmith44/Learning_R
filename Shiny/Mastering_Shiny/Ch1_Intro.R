library(shiny)

#Basic boilerplate is a ui to describe how app looks,
#and a server to describe how it works, plus a call
#to shinyApp(ui,server)
# App is typically contained in a file app.R, and in fact
#when running a shiny app from a folder that folder must
#have a file named app.R.
#more

ui <- fluidPage(
  selectInput("dataset", label = "Dataset", choices = ls("package:datasets")),
  verbatimTextOutput("summary"),
  tableOutput("table")
)

server <- function(input, output, session) {
}
shinyApp(ui, server)