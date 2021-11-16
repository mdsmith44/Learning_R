install.packages('Rtools')
install.packages('plotly')
library(plotly)

df <- data.frame(
  x = c(1,2,1), 
  y = c(1,2,1), 
  f = c(1,2,3)
)

fig <- df %>%
  plot_ly(
    x = ~x,
    y = ~y,
    frame = ~f,
    type = 'scatter',
    mode = 'markers',
    showlegend = F
  )

fig

library(plotly)
install.packages('gapminder')
library(gapminder)

df <- gapminder 
head(df)
fig <- df %>%
  plot_ly(
    x = ~gdpPercap, 
    y = ~lifeExp, 
    size = ~pop, 
    color = ~continent, 
    frame = ~year, 
    text = ~country, 
    hoverinfo = "text",
    type = 'scatter',
    mode = 'markers'
  )
fig <- fig %>% layout(
  xaxis = list(
    type = "log"
  )
)

fig

library(htmlwidgets)
#p <- plot_ly(x = rnorm(100))
saveWidget(fig, "test_R_file.html", selfcontained = T)#, libdir = "lib")
#saveWidget(p, "p2.html", selfcontained = F, libdir = "lib")