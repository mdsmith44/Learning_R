#From https://plotly.com/r/plotly-fundamentals/

library(plotly)

### Figures

#Plotly gives R interface to plotly.js library.
#Main function is plot_ly, used to generate plotly figure objects
fig <- plot_ly(midwest, x = ~percollege, color = ~state, type = "box")

#simply call fig to display the html
fig

#fig is a plotly object, subclass of htmlwidget
class(fig) #[1] "plotly"     "htmlwidget"


