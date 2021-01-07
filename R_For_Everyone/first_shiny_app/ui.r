#To run, run `runApp('dir_name')`. 

#There are numerous ways to layout a Shiny App
#One common one is to use shinydashboard package

library(shiny)
library(shinydashboard)

#Can be just an empty header, sidebar, and body:
# dashboardPage(
#   header=dashboardHeader(),
#   sidebar=dashboardSidebar(),
#   body=dashboardBody(),
#   title='Example Dashboard'
# )

#If run in console, the dashboard page would display
#the html code.  Within ui.r, it is used to build dynamic
#html code that reacts to inputs.

#Lets create header, sidebar, and body
#First a simple header
dashHeader <- dashboardHeader(title='Simple Dashboard')

#Now a clickable sidebar
dashSidebar <- dashboardSidebar(
  sidebarMenu(menuItem('Home',
                       tabName='HomeTab',
                       icon=icon('dashboard')),
              menuItem('Graphs',
                       tabName='GraphsTab',
                       icon=icon('bar-chart-o'))
  )
  )

#And add body.
# We can use tabItems function to build out body which
#is sequence of tabItem items with a name that links them
#to sidebarMenu
# Shiny provides many html tags through htmltools package
# Run names(htmltools::tags) to see them all


dashBody <- dashboardBody(
  tabItems(
    tabItem(tabName='HomeTab',
            h1('Landing Page!'),
            p('This is the landing page for the dashboard.'),
            em('This text is emphasized')
            ),
    tabItem(tabName='GraphsTab',
            h1('Graphs!'),
            selectInput(inputId='VarToPlot',
                        label='Choose a Variable',
                        choices=c('carat', 'depth',
                                  'table', 'price'),
                        selected='price'),
            plotOutput(outputId='HistPlot')
            )
    )
  )
#plotOUtput is blank for now, and will be filled out
#on server side

#Now build complete page
dashboardPage(
  header=dashHeader,
  sidebar=dashSidebar,
  body=dashBody,
  title='Example Dashboard'
  )


