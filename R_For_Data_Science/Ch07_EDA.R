library(tidyverse)

#Cool quote (answer what matters, not what data you have):
#“Far better an approximate answer to the right question, 
#which is often vague, than an exact answer to the wrong 
#question, which can always be made precise.” — John Tukey

#Can easily view variation of categorical variables
#with bar chart
ggplot(data=diamonds) +
  geom_bar(mapping=aes(x=cut))

#Can we do same thing with histogram?
#No
ggplot(data=diamonds) +
  geom_histogram(mapping=aes(x=cut))

#Get the same thing with groupby and n() counter fxn
diamonds %>%
  group_by(cut) %>%
  summarise(n=n())

#Or use the dplyr::count() shortcut
diamonds %>%
  count(cut)

#See continuous variables with geom_hist
ggplot(data=diamonds) +
  geom_histogram(mapping=aes(x=carat),binwidth=.5)

#Or get table using count
#Using as is, we get count for every value of carat
diamonds %>%
  count(carat)
#Use cutwidth argument to get bins
diamonds %>%
  count(cut_width(carat,.5))

#To overlay multiple histograms, can use freq_poly, which
#uses lines to trace tops of hist bars
smaller <- diamonds %>%
  filter(carat<3)
ggplot(data = smaller, 
       mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

#What if we want to zoom in to see outliers?
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
#Can't see outliers, since heights are too small
#zoom in with coord_cartesian()
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim=c(0,50))
#NOTE: ggplot2's xlim() and ylim() functions will throw 
#away data outside those limits.  Lets try it
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  ylim(0,3000)

#Take a look at outliers, which are clearly data errors
#as x, y, z are dimensions in mm of diamonds
diamonds %>%
  filter(y<3 | y>20) %>%
  select(price,x,y,z) %>%
  arrange(y)

##### Handling Missing Values
#We can replace outliers with NAs using mutate along with
#ifelse, which acts like np.where
diamonds2 <- diamonds %>%
  mutate(y=ifelse(y<3|y>20,NA,y))
#Could also use dplyr::case_when() in similar way, but with
#multiple ifelse statements supposedly

#Note that ggplot will automatically remove missing
#values, and display a warning
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()
#to suppress warning, use na.rm=TRUE
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm=TRUE)



##### Covariation

#1 Categorical and 1 continuous
#Can use frequency polygon
ggplot(diamonds) + 
  geom_freqpoly(mapping=aes(x=price,color=cut))
#Raw counts can be misleading towards those with more
#Can also display density curve
ggplot(data = diamonds, mapping = aes(x = price, 
                                      y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut), 
                binwidth = 500)

#Could also try a boxplot
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

#Can also reorder variables if needed
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
#Reorder class based on median value of hwy
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class,
                                         desc(hwy),
                                         FUN=median),
                             y = hwy))

#For long names, useful to flip them to y axis
#using coord_flip()
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()

#Some other potentially useful packages that provide
#extensions off of ggplot2, i.e. they provide more 
#geom functions

#ggstance for horizontal plots? e.g. provides 
#geom_boxploth
install.packages('ggstance')
library(ggstance)
#Now instead of coord_flip() use horizontal version,
#geom_boxploth
ggplot(mpg, aes(hwy, class, fill = factor(cyl))) +
  geom_boxploth()

#use letter value plot with geom_lv
install.packages('lvplot')
library(lvplot)
ggplot(diamonds) +
  geom_lv(mapping=aes(y=price,x=cut))
#so similar to violin plot..with geom_violin()

#ggbeeswarm package provides more methods similar to 
#geom_jitter()

### Two Categorical Variables
#Can start with counts with geom_count()
ggplot(diamonds) +
  geom_count(mapping=aes(x=cut,y=color))

#Get same thing in tibble
diamonds %>%
  count(cut,color)

#Can visualize with geom_tile
diamonds %>%
  count(color,cut) %>%
  ggplot(mapping=aes(x=color,y=cut)) +
  geom_tile(mapping=aes(fill=n))

#could also try d3heatmap or heatmaply

### Two Continuous Variables
#In addition to just scatter plots, could use geom_bin2d
#of geom_hex to get density with fill color
ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

install.packages('hexbin')
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

#Could also bin one continuous variable so that it
#acts like a discrete one.  To do this, use group
#aesthetic with cut_width()
ggplot(data = smaller, mapping = aes(x = carat, 
                                     y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

#Could also specify number of groups with cut_number
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))



#As final note, note that we often omit the name for 
#arguments data and mapping, as they are always 1st 2 
#args to ggplot.  Also can omit x and y as 1st 2
#args to aes.  So this:
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_freqpoly(binwidth = 0.25)

#can be rewritten as
ggplot(faithful,aes(eruptions)) +
  geom_freqpoly(binwidth=.25)
