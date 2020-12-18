##### tidyverse reshaping
#dplyr and tidyr provide newer packages for reshaping data
#that use pipes and may be easier to use and faster than
#plyr, reshape2, and base R methods.



##### bind_rows and bind_cols
#These are the dplyr analogs to rbind and cbind.  They tend
#to work better, but only work on data.frames (and tibbles),
#whereas r/cbind work on vectors and matrices too.

library(dplyr)
library(tibble)

# create a two-column tibble
sportLeague <- tibble(sport=c("Hockey", "Baseball",
                              "Football"),
                      league=c("NHL", "MLB", "NFL"))

sportLeague

# create a one-column tibble
trophy <- tibble(trophy=c("Stanley Cup", 
                          "Commissioner's Trophy",
                          "Vince Lombardi Trophy"))
trophy

#Now we can combine the columns (stack side by side) with
#bind_cols
trophies1 <- bind_cols(sportLeague,trophy)
trophies1

#To try out bind_rows, lets build a new tibble row-wise
#using shortcut tribble()
trophies2 <- tribble( ~sport, ~league, ~trophy,
                      "Basketball", "NBA", 
                      "Larry O'Brien Championship Trophy",
                      "Golf", "PGA", "Wanamaker Trophy")
trophies2

#Combine rows of trophies 1 and 2
trophies <- bind_rows(trophies1,trophies2)
trophies


##### Joins (aka merge)
#dplyr provides x_join for x = left, right, inner, full,
# semi, and anti

#Read in some more data to augment diamonds
library(readr)
colorsURL <- 'http://www.jaredlander.com/data/DiamondColors.csv'
diamondColors <- read_csv(colorsURL)
diamondColors

#Recall the unique colors from diamonds data
data(diamonds, package='ggplot2')
unique(diamonds$color)

#So diamonds has D-J, and diamondsColors has D-M

#left_join will keep everything
library(dplyr)
#notice notation for specifying to use color in left df
#and Color in right df
left_join(diamonds,diamondColors,
          by=c('color'='Color')) %>%
  select(carat,color,price,Description)

#neat trick to see unique combos of multilpe fields
#same as drop_duplicates()
diamondColors %>% distinct(Color,Description)

#What happens with right join?
#Will we get just 10 rows or 50k?
#Will we get nulls for Colors not in color?
right_join(diamonds,diamondColors,
           by=c('color'='Color')) %>% nrow
#We get 53943 rows, which is all 53940 from diamonds,
#plus 3 rows for 3 colors in diamondsColors but not in
#diamonds.  We we view these?
new_colors <- setdiff(unique(diamondColors$Color),
                      unique(diamonds$color))
new_colors
right_join(diamonds,diamondColors,
           by=c('color'='Color')) %>%
  filter(color %in% new_colors)
#As expected, all other fiels are NA
right_join(diamonds,diamondColors,
           by=c('color'='Color')) %>%
  filter(is.na(carat))

#For this exercise, since all colors in diamond are matched
#in diamondColors, inner join will match left join
all.equal(
  left_join(diamonds, diamondColors, 
            by=c('color'='Color')),
  inner_join(diamonds, diamondColors, 
             by=c('color'='Color'))
)
#Note: identical
#And full join (outer) will be same as right
all.equal(
  full_join(diamonds, diamondColors, 
            by=c('color'='Color')),
  right_join(diamonds, diamondColors, 
             by=c('color'='Color'))
)

#A semi-join returns only the first row in left that has
#a match in right (if any).
semi_join(diamondColors, diamonds, 
          by=c('Color'='color'))
#Only keeps rows in diamondColors, without adding extra
#fields from diamonds.  So basically just row filtering
#of left.
# If we make diamonds left, we'll keep first row of each
#color, since all colors are in diamondColors, but we
#won't get any of the extra fields from dColors
semi_join(diamonds,diamondColors,
          by=c('color'='Color'))


#anti_join keeps rows not matched.
#All such rows or just first one?
anti_join(diamondColors,diamonds,
          by=c('Color'='color'))

# Since semi_join and anti_join are just row filtering, 
#without actually adding new fields, they both can be 
#achieved with filter and unique and %in%.  In fact, for
#df's, filter and unique usually used; semi_join and 
#anti_join mainly useful when using dplyr with databases

#replicate semi join
diamondColors %>% filter(Color %in% 
                          unique(diamonds$color))

#replicate anti join
diamondColors %>% filter(!Color %in% 
                           unique(diamonds$color))


##### pivoting
# Just like dplyr is next gen of plry, tidyr is next gen
#of reshape2 which provided melt and dcast methods for 
#converting between long and wide format. The main 
#advantage of tidyr is ease of use and works with pipes,
#not necessarily speed improvement.

# Also seems like pivot_longer and pivot_wider are even
#newer variants of melt and dcast (plyr), or their dplyr
#corollaries gather and spread.

library(tidyr)

#Read in some data, in tab-separated text file
emotion <- read_tsv('http://www.jaredlander.com/data/reaction.txt')
#Note that reader indicates type of data in each col
emotion


#corollary to melt (wide to long format) is gather
#Lets gather Age, React, and Regulate into new col called
#measurement, and add new col Type
emotion %>%
  gather(key=Type, 
         value=Measurement, 
         Age, BMI, React, Regulate)
#Breaking down what had happened,
# key gives name for new col that will hold the name
#of the previous col whose value is being used (the 'key')
#to knowing what field the current value belongs to
# value gives name for new col that will hold actual data
#from cols being gathered.
# All remaining args provide cols to be gathered and
#pivoted into one col.

#It may or may not work using quotes
emotion %>%
  gather(key=Type,
         value='Measurement',
         Age, BMI, React, Regulate)

#Default is to sort by new key col, sort by ID to see
emotion %>%
  gather(key=Type,
         value='Measurement',
         Age, BMI, React, Regulate) %>%
  arrange(ID)

#Can also specify which cols not to pivot with minus sign
emotion %>%
  gather(key=Type,
         value='Measurement',
         -ID, -Test, -Gender) %>%
  arrange(ID)


# pivot wider is done with spread (corollary to dcast)
emotionLong <- emotion %>%
  gather(key=Type,
         value='Measurement',
         Age, BMI, React, Regulate) 
emotionLong %>% spread(key=Type,
                      value=Measurement)
