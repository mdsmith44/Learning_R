##### Intro
# Most R graphing is done with ggplot2, but helpful to first 
#learn some base R plotting functionality


### Base Graphi


#Load some test data from ggplot2
library(ggplot2)
data(diamonds)
head(diamonds)

#Generate histogram of carat field
hist(diamonds$carat, main="Carat Histogram", xlab="Carat")
#main argument specifies the title (cuz that makes sense)

#Scatterplot of price vs carat using formula notation
plot(price ~ carat, data=diamonds)
#This means price against carat, or price on y vs carat on x
#Could achieve same thing directly
plot(diamonds$price,diamonds$carat)

#Can also do boxplots in base R
boxplot(diamonds$carat)


##### ggplot
# Basic syntax is ggplot(data) 
# then we add (with +) layers such as which geom to use and any 
#aesthetics specifying which variable gets mapped to which 
#axis or other plot feature

#Recreate hist
ggplot(data=diamonds) + geom_histogram(aes(x=carat))

#Create density plot, add fill color
ggplot(data=diamonds) + geom_density(aes(x=carat),
                                     fill='grey50')

#We can call aes inside of ggplot instead of inside geom
ggplot(diamonds, aes(x=carat,y=price)) + geom_point()
#What happens if we add it to geom_point?
ggplot(diamonds) + geom_point(aes(x=carat,y=price))
#Seems to work either way, maybe changes if we want diff geom's to
#have different aes

#Can save plots 
g <-ggplot(diamonds,aes(x=carat, y=price))

#Now we can add layers
#View columns of data
names(diamonds)

#Now vary color by color field, which has about 7 unique values
unique(diamonds$color)
g + geom_point(aes(color=color))
#Note: color field does not specify the color, it just contains
#7 different categories: D, E, ..., J

# Can make faceted plots, making different plot for each
#unique values of given field
# Apply facet_wrap by color field
g + geom_point(aes(color=color)) + facet_wrap(~color)
#This will create different plot for each value of color

#facet_wrap creates separate pane for each value of color
#Can also use facet_grid to put same values in saem row/col
#of resulting grid
g + geom_point(aes(color=color)) + facet_grid(cut~clarity)

#Plot histograms of caret field faceted on color values
ggplot(diamonds,aes(x=carat)) + geom_histogram() + facet_wrap(~color)


#Boxplot
ggplot(diamonds,aes(y=carat)) + geom_boxplot()
#sometimes have to force in aes(x=1) as dummy x aesthetic
#Or show multiple ones
ggplot(diamonds, aes(y=carat, x=cut)) + geom_boxplot()

#Violin plots - similar to boxplot but also shows density
ggplot(diamonds, aes(y=carat, x=cut)) + geom_violin()

#Can plot multiple layers
#But note that layers will be ON TOP of other layers
#This will cover up points with violin
ggplot(diamonds, aes(y=carat, x=cut)) + geom_point() + geom_violin()
#This will plot points on top of violin
ggplot(diamonds, aes(y=carat, x=cut)) + geom_violin() + geom_point()

#Line plots
#Note that we can use any ggplot2 data, such as economics,
#within ggplot() without having to load it with data(economic),
#though we would need to load it to view it on its own
ggplot(economics, aes(x=date, y=pop)) + geom_line()
#Or maybe economics is inlcuded in base R?

#Sometimes need to use aes(group=1) within geom_line as hacky
#solution, as sometimes lines can't be plotted without a 
#group aesthetic

#Plot date range
library(lubridate)
#Create year field
economics$year <- year(economics$date)
#Create month field
#label=TRUE means use month name, not number
economics$month  <- month(economics$date, label=TRUE)
head(economics)
#Get just data after 2000
econ2020 <- economics[which(economics$year>=2000),]
# load the scales package for better axis formatting
library(scales)
names(econ2020)

# Build plot that plots diff color line for each year
ggplot(econ2020,aes(x=month,y=pop)) + 
  geom_line(aes(color=year))

#Doesn't quite work.  
#First, year is double so it gets treated as continuous
#with continuous colorbar.  Set it to factor
ggplot(econ2020,aes(x=month,y=pop)) + 
  geom_line(aes(color=factor(year)))

# We also need to add a GROUP within geom_line aes
#to break lines into different groups
#So facet_wrap plots different pane for each value,
#but GROUP plots different element (e.g. line) on same pane
ggplot(econ2020,aes(x=month,y=pop)) + 
  geom_line(aes(color=factor(year),group=year))

#Some more formatting
g <- ggplot(econ2020,aes(x=month,y=pop)) + 
  geom_line(aes(color=factor(year),group=year))
# name the legend "Year"
g <- g + scale_color_discrete(name="Year")
# format the y axis
g <- g + scale_y_continuous(labels=comma)
# add a title and axis labels
g <- g + labs(title="Population Growth", x="Month", y="Population")
# plot the graph
g


## Can easily change themes
install.packages("ggthemes")
library(ggthemes)

#Build plot 
g2 <- ggplot(diamonds, aes(x=carat, y=price)) +
  geom_point(aes(color=color))
g2

#Try a few themes
g2 + theme_economist() + scale_colour_economist()
g2 + theme_excel() + scale_colour_excel()
g2 + theme_tufte()
g2 + theme_wsj()