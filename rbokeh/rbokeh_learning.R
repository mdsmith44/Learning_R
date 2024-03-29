library(tidyverse)

install.packages('rbokeh')
library(rbokeh)

p <- figure() %>%
  ly_points(Sepal.Length, Sepal.Width, data = iris,
            color = Species, glyph = Species,
            hover = list(Sepal.Length, Sepal.Width))
p
iris
view(iris)
