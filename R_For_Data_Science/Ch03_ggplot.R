#Load meta library of all tidyverse packages
library(tidyverse)

#First look at some data, which was automacially loaded when ggplot
#is loaded
mpg

#NOTE: If you hadn't loaded ggplot2, could have accessed it via
data(mpg,package='ggplot2')
mpg

#make basic scatter plot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

#Basic structure is:
# ggplot() function to initialize coordinates
# adding layers of different plot geometries, e.g geom_point()
# geom functions always take a mapping argument, which uses aes() func
#to map data fields to plot properties.

#Just ggplot() will display empty pane
ggplot(data=mpg)

#Check out mpg data
nrow(mpg)
?mpg
#Make scatter of hwy vs cyl
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))

#There are many aesthetics beyond x and y coords.  Others include
#size, shape, color.  
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
#Note that ggplot automatically assigns unique values to each 
#data value (process known as scaling) and also adds legend.

#Can we reference class with quotes?
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = 'class'))
#Every point is red, and legend says red = 'class'

#We could also vary size by class
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, 
                           size = class))
#Note that class is discrete variable, so is a bit wonky
#Try scaling continuous variable (displ) to size
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, 
                           size = displ))


#alpha
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

#shape
# Right
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
#NOTE that it won't give you more than 6 shapes when scaling
#to data values

#Can also set an aesthetic manually
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")
#Note that we set mapping to fixed value OUTSIDE of aes()
#Within aes() it tries to find that field in data and then
#use a different level of that aesthetic for different values
#of that field.  
#This won't make the points blue
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))

#Manually set shape using index of 25 shapes
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), shape = 2)

#stroke aes does something
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy,stroke= displ))

#We can also feed in boolean condition:
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, 
                           color = displ < 5))


##### Facets
#Get different plot for each value of a discrete variable
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

#Use facet_grid for 2 variables
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

#Use "." to not facet one dimension
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(.~ cyl)



##### Other geoms

#geom_smooth gives line with error bars
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

#We can vary the line type by a field
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy,
                            linetype=drv))

#Note: If you want to make the SAME plot for different 
#levels of a categorical variable, can use group aesthetic
#but this doesn't add a legend
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, 
                            group = drv))

#Easy to add and layer multiple geoms
#For any aesthetics that are the same in all geoms, best
#to add them to ggplot() up front
ggplot(data=mpg,mapping=aes(x=displ,y=hwy,color=drv)) +
  geom_point(mapping=aes(color=drv)) +
  geom_smooth(mapping=aes(linetype=drv))
#If you add a local aes, it will overwrite global one
#just for that local layer
?geom_smooth

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv)
  )

#Exercises
ggplot(data=mpg,mapping=aes(x=displ,y=hwy)) + 
  geom_point(mapping=aes(color=drv)) +
  geom_smooth(se=FALSE)
?geom_point


##### Statistical Transformations
#Some plots, like bar charts, automatically compute some
#stat xformation.  
#Bar charts with geom_bar
ggplot(data=diamonds) + 
  geom_bar(mapping=aes(x=cut))

#This uses a default method to compute statistical xforms,
#which we can see from inspecting the stat argument

#We can change the stat, e.g. identity if we have the 
#value to plot already, here in the 'freq' col
diamond_cuts <- diamonds %>% group_by(cut) %>%
  summarize(freq=length(price))
diamond_cuts
ggplot(data = diamond_cuts) +
  geom_bar(mapping = aes(x = cut, y = freq), 
           stat = "identity")

#Recreate original plot useing stat='count'?
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut), 
           stat = "count")

#Plot proportion rather than raw counts
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(prop), 
                         group = 1))



#There are over 20 different stats
#1. Can call them with stat='type' within geom
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut), 
           stat = "count")
#2. Or can call the stat fxn instead of geom
ggplot(data = diamonds) +
  stat_count(mapping = aes(x = cut))
#3. Or can set y = stat(type) within geom 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(count), 
                         group = 1))
#Why did we need group=1?
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = stat(count)))

#here's how you could use stat_summary
ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

#Each stat_type() fxn has default geom, and each geom that
#requires stat xform has default stat
?stat_summary

#Recreate previous plot with the geom_freqpoly

#exercise
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(prop)))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))


#Add color with fill
#Set to same variable as x:
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))
#Set to diff variable to get stacked bar chart
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

#To control stacking, use position argument
#position = 'identity' plots them as is, i.e. overlap
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity")

#position = 'fill' to make all bars same height
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), 
           position = "fill")

#position = 'dodge'
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), 
           position = "dodge")

#Note: default is position='stack'

#Within geom_point, can use position='jitter' to add
#small amount of random noise to each point
ggplot(data=mpg) +
  geom_point(mapping=aes(x=displ,y=hwy),
             position='jitter')
#geom_jitter() is a short hand for geom_point() with 
#position default set to jitter

#Coordinate Systems
#We can flip with coord_flip(), useful for fitting
#long tick labels
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

#coord_quickmap() sets aspect ratio for maps
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#Use coord_polar() to flip into polar plot
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()
