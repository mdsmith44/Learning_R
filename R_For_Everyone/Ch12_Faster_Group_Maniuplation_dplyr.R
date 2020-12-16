##### dplry
#dplyr extends plyr package with enhancements to focus on speed.
#d means package is intended to work on df's;
#purr package deals with list and vector functionality

#There is something of an arms race between Matt Dowle (data.table)
#and Hadley Wickham (dplyr) to write fastest code.  dplyr
#seems to be most popular

#Overarching philosophy is to use "grammar of data" to perform
#data manipulation, with functions such as select, filter,
#mutate, group_by representing verbs.

#dplyr uses piping paradigm made possible by magrittr package

#If using dplyr and plyr, be sure to import dplyr 2nd since 
#they have many functions with same name


## First an orientation to piping mechanism, used to chain
#multiple functions together

#piping is enabled by magrittr package
library(magrittr)
data(diamonds,package='ggplot2')
#Get dimensions of first 4 rows of df
dim(head(diamonds,n=4))

#Can get same result with chaining
diamonds %>% head(4) %>% dim

#Note that pipes effectives work "inside out" compared to
#previous statement.
# Intuitively, this means apply head function to diamonds, 
#with next arg = 4, then apply dim() to result
#We could also specify name n=4
diamonds %>% head(n=4) %>% dim

#dplyr also uses tbl objects (aka tibbles, after original
#tibble package) instead of built in R 
#data.frames, in line with rest of tidyverse
head(diamonds)
#Note that we get column dtype displayed, which is nice
class(diamonds) #[1] "tbl_df"     "tbl"        "data.frame"
#Note that it is a tbl_df object, subclass of tbl, etc

#After dplyr is loaded, they will display with some auto
#formatting to display just subset of rows and cols

library(dplyr)
head(diamonds)

#We don't need to use head as tbl's auto display to fit
#just a reasonable amount of screen space
diamonds #will just display few rows and cols




##### select
#lets get into functions, or verbs in grammar of data
#select indicates what coloms to keep
select(diamonds,carat,price)

#Can use pipes
diamonds %>% select(carat,price)

#Same as basic R square bracket syntax?  Seems so
diamonds[c('carat','price')]
#This would also workd
diamonds[,c('carat','price')]

#Feed in vector?  Sure.
select(diamonds,c('carat','price'))
#Don't need quotes, even when in vectors
select(diamonds,c(carat,price))
#Can you use quotes?
select(diamonds,'carat','price')
#Works with quotes

#Can also feed in numerical index position
select(diamonds,1,7)


#NOTE: A basic rule of R is to never have column names
#with a space, since we won't be able to reference that
#column with functions like select(), even with quotes.

#What if you have a variable that contains cols_to_keep?
cols_to_keep <- c('carat','price')
diamonds %>% select(cols_to_keep)
#Seems to work, though does throw an error
#Proper way is to feed it in as the ".dots" arg
diamonds %>% select(.dots=cols_to_keep)
#That doesn't work.  Maybe deprecated?

#Can also use one_of
diamonds %>% select(one_of(cols_to_keep))
#Which, as the name suggests, uses both of cols... hmmm
#one_of has been superceded by more precise any_of
#or all_of
diamonds %>% select(all_of(cols_to_keep))
diamonds %>% select(any_of(cols_to_keep))
#Does any_of work if you feed in bad col?  Seems so
diamonds %>% select(any_of(c('carat','asdfsd'))) #works
diamonds %>% select(all_of(c('carat','asdfsd'))) #error
#Can we also use any_of and feed in several names
#rather than vector of names?  Seems no.
diamonds %>% select(any_of('carat','price')) #error
#Although this WILL work with one_of, but not any/all_of
#though need to use quotes
diamonds %>% select(one_of('carat','price'))

#Can also look for partial matches
diamonds %>% select(starts_with('c'))
diamonds %>% select(ends_with('e'))
diamonds %>% select(contains('l'))
#Look for regex matches
diamonds %>% select(matches('r.+t'))
#col names that contain an r then later contain a t

#Specify columns to exclude
diamonds %>% select(-carat,-price)
diamonds %>% select(-c(carat, price))
diamonds %>% select(-one_of('carat', 'price'))



##### Filter
diamonds %>% filter(cut=='Ideal')

#Note that this is same as base R square brackets
diamonds[diamonds$cut == 'Ideal',]

#Use %in% operator to see if field is in list of vals
#Does %in% require magrittr?
#Unload it to see
detach("package:magrittr")
'cut' %in% names(diamonds)
#This still works, so %in% is not a PIPE, it is just
#a special function/operator
#Re-load magrittr
library(magrittr)
diamonds %>% filter(cut %in% c('Ideal', 'Good'))

#Filter by any logical 
diamonds %>% filter(price>=1000)

#Can get compound AND filtering by separating expressions
#with comma (,) or &
diamonds %>% filter(carat > 2, price < 14000)
diamonds %>% filter(carat > 2 & price < 14000)

#Use | to get OR
diamonds %>% filter(carat < 1 | carat > 5)

#NOTE: We can't use quotes for field names the way we can
#in select.  select() uses "tidy selection" where we can 
#access field by name, number or "name".  filter uses
#"data masking" where we can only use name.


##### Slice
#filter selects rows based on logical expression
#slice selects rows by number (e.g. iloc)
diamonds %>% slice(1:5)
#same as..
diamonds[1:5,]
#Get few different ranges (like iloc[np.r[]])
diamonds %>% slice(c(1:5, 8, 15:20))
#Note that resulting row #s are new ones, e.g. 1 to 12
#Can we get first fiew nad last few rows?
rbind(head(diamonds),tail(diamonds))

#Speicfy what to ignore
diamonds %>% slice(-1)


##### mutate
#create or modify existing columns

#Get col that is price/carat
diamonds %>% mutate(price/carat)
#now col name is 'price/carat', but doesn't show up
#try to get it to show up by just keeping those cols
df <- diamonds %>% select(price,carat) %>%
  mutate(price/carat)
df
#new col is given default name 'price/carat'
names(df)
#Can assign diff name
diamonds %>% select(price,carat) %>%
  mutate(Ratio=price/carat)

#Can even use newly created cols immediately, even
#within the same mutate call
diamonds %>%
  select(carat,price) %>%
  mutate(Ratio=price/carat,Double=Ratio*2)


#So far we've just been using %>% pipe to push our df
#into a new df, leaving original variable unchanged.
# We can also CHANGE the df using %<>% which pipes the df
#through the functions, and assigns result back

#Make copy first
diamonds2 <- diamonds
#Now use assignment pipe %<>%
diamonds2 %<>%
  select(carat, price) %>%
  mutate(Ratio=price/carat, Double=Ratio*2)
diamonds2

#Of course could always use <- assignment operator
diamonds2 <- diamonds %>%
  select(carat, price) %>%
  mutate(Ratio=price/carat, Double=Ratio*2)


##### Summarize
#summarize functions return signle number from each col
summarize(diamonds,mean(price))
diamonds %>% summarize(mean(price))
#Results in most concise and easy to understand code
#when expressions are more complex
diamonds %>%
  summarize(AvgPrice=mean(price),
            MedianPrice=median(price),
            AvgCarat=mean(carat))

#If we want the func applied to each col, need to use
#summarize_each
# This will give mean of each col.  It will work, though
#it will give a warning about having to return NA for non-
#num cols
diamonds %>% summarize_each(mean)
summarize_each(diamonds,mean)


##### group_by
#summarize is really most useful when used with group_by
#as it specifies the "apply" func in split-apply-combine

#Lets get average price by cut
diamonds %>% group_by(cut) %>%
  summarize(AvgPrice=mean(price))
#This turns out to be more elegent and faster than base-R
#aggregate function, and can also more easily handle
#multiple calculations

#Get avg price and total carats by cut
diamonds %>% group_by(cut) %>%
  summarize(AvgPrice=mean(price),SumCarat=sum(carat))


##### arrange
#arrange provides methods to sort df in a way that is 
#easier than base R's order and sort functions
diamonds %>% arrange(carat)

#default is ascending, but can get descending
diamonds %>% arrange(desc(carat))

#Mutlilpe variables?
diamonds %>% 
  select(depth,price) %>%
  arrange(desc(depth,price))

#Use quotes?  Seems to work
diamonds %>% 
  select(depth,price) %>%
  arrange(desc('depth','price'))


##### Do
#Can also apply arbitrary functions with do
#Whereas group_by %>% summarize is similar to 
#df.groupby().apply(), do is maybe more similar to 
#df.groupby().agg(func) in taht we can feed in arbitrary
#func (or even anonymous?)

#First specify function to apply to df and returns
#top 5 rows with highest price
topN <- function(x,N=5){
  #use pipe to transform inputed df 'x'
  #Note that last line is automatically returned
  x %>% arrange(desc(price)) %>%
    head(N)
}
#Now can combine do with group_by to return top N rows,
#by price, for each cut.  Syntax is a bit tricky at first:
diamonds %>% group_by(cut) %>% do(topN(., N=3))

#This gives top 3 rows, by price, for each cut
#Why do we need the funny period?  When using pipes, the 
#LHS object by default becomes the FIRST argument of next
#function. In this case, that default would mean that the
#grouped data would be first argument to the "do()" func,
#and the topN funct would be 2nd arg to the do function.
# To specify different location, use "."


#If we add a name within do, we get diff behavior
#as it returns tibble to each rather than unpacking it
diamonds %>%
  # group the data according to cut
  # this essentially creates a separate dataset for each
  group_by(cut) %>%
  # apply the topN function, with the second argument 
  #set to 3
  # this is done independently to each group of data
  do(Top=topN(., 3))
#Result is a "rowwise_df" with tibbles as entries
#Using do with named args is same as ldply?

#Can we also use do to apply arbitrary function?
#This seems to work
add_html_code <- function(x) {
  s <-  "New val is "
  p <- x$price
  s <- paste(s,as.character(p))
  x['New'] <- s
  return(x)
}
diamonds %>% select(price) %>% do(add_html_code(.))

#Can we feed in anonymous functions?
# diamonds %>% select(price,carat) %>%
#   do(function(x) x$price + x$carat)
#Hmm, doesn't quite work, since we need to call the 
#function with a period where data should be inputted

##### databases
#dplyr works with many database types
