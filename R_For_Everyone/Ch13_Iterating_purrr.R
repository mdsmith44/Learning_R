##### purrr
#purrr, another tidyverse/Hadley Wickham production, gives
#tools to iterate and apply functions to each element in 
#a sequence.
# This applies non-vectorized functions to elements.  Of 
#course, it function were vectorized, we would just apply it
#and wouldn't need to iterate through.
# purrr also mainly aimed at lists, but can apply to vectors
#as well.

#Name purrr denotes "pure" programming as it has roots in
#pure functional programming.  Also has 5 letters to match
#other packages such as dplyr, readr, tidyr.



##### Map
#foundation of purrr is map, which applies function to each
#element of a list and returns new list.  Achieves the
#same effect as lapply, though is designed with pipes in mind


theList <- list(A=matrix(1:9, 3), B=1:5,
                C=matrix(1:4, 2), D=2)
#Can use lapply
lapply(theList,sum)

#Or can use purrr
library(purrr)
theList %>% map(sum)
#So effectively [sum(x) for x in theList]


#What if list has NA?
theList2 <- theList
theList2[[1]][2, 1] <- NA
theList2[[2]][4] <- NA
theList2

#Now it probably won't work, or will return NA if any
#elements are NA
theList2 %>% map(sum)
#To ignore NAs, we can wrap sum in anonymous function
theList2 %>% map(function(x) sum(x,na.rm=TRUE))
#Or we could add in extra function args to map
theList2 %>% map(sum,na.rm=TRUE)


#We can also specify the desired output type, as sometimes
#vector can be simpler than a list, which is default output
# Format is map_type to get vector of *type* items.
# If can't get desired result, returns an error

#Lets try it with map_int
theList %>% map_int(nrow)
#So that didn't work.  Why not?  Turns out we need our func
#to return a 1-element vector when operating on each item
#in the list.  nrow returns a number, but NROW returns
#resulting number as a 1-col matrix, which enables it
#to work with map_int

#Note no apparent difference
#Note: use double bracket to grab object, as opposed to
#single bracket which returns list of that item
nrow(theList[[1]])
NROW(theList[[1]])
class(nrow(theList[[1]]))
class(NROW(theList[[1]]))
#Same class.  nrow seems to return NAs whereas NROW doesn't
theList %>% map(nrow)
theList %>% map(NROW)

#Anyway, map_int works wiht NROW
theList %>% map_int(NROW)

#Can't even coerce sum to int vector??? wtf.
#words for map just fine
theList %>% map(sum)
#but not map_int, this thing sucks
theList %>% map_int(sum)
#maybe because sum, mean adn others return numeric type,
#so for these need map_dbl
theList %>% map_dbl(sum)
theList %>% map_dbl(mean)

#Other examples
theList %>% map_chr(class)
#Note that this wouldn't work if we had an element with
#a multi-word class, such as ordered factor
of <- factor(c('a','b','c'),ordered=TRUE)
class(of) # "ordered" "factor"
theList3 <- theList
theList3[['E']] <- of
theList3 %>% map_chr(class)
#will return error since last one is not a single-element
#char vector, but rather is 2-elements, c("ordered","factor")

#map_lgl
theList %>% map_lgl(function(x) NROW(x) < 3)

#map_df
#Unlike map_int/dbl/lgl/chr, which return atomic vector
#of that type, map_df returns a single df by row or col
#binding the df's from operating on each element
buildDF <- function(x)
{
    data.frame(A=1:x, B=x:1)
}
listOfLengths <- list(3, 4, 1, 5)

#If we just use map, we get list of df's
listOfLengths %>% map(buildDF)

#Or we can use map_df to get a SINGLE df
listOfLengths %>% map_df(buildDF)
#seems default is row bind,  can speicfy whihc one
listOfLengths %>% map_dfr(buildDF)
listOfLengths %>% map_dfc(buildDF)#error

#Can use map_if to only modify if some condition holds
#Multiply matrix elements by 2; leave rest unchanged
theList
theList %>% map_if(is.matrix,function(x) x*2)

#map functions provide another mechanism to implement
#anonymous fxns, using formula notation with .x
theList %>% map_if(is.matrix,~ .x*2)




##### Iterating over data.frame
#Since data.frames are technically lists of atomic vectors,
#we can use map functions on them
data(diamonds,package='ggplot2')

#Find mean of each column
diamonds %>% map_dbl(mean)
#Would it work with regular map?
diamonds %>% map(mean) #should return list?
class(diamonds %>% map_dbl(mean))
#class is "numeric", as in numeric vector
class(diamonds %>% map(mean)) #class is list

#This is same as dplyr's summarize_each
diamonds %>% summarize_each(mean)
#Though this will return new df (techhically a tbl)
#Hence main difference seems to be data type returned



##### map with multiple inputs
#We can also use map with multiple inputs
#map2(L1,L2,func) takes two inputs, from each element
#of the two lists
firstList <- list(A=matrix(1:16, 4), B=matrix(1:16, 2), C=1:5)
secondList <- list(A=matrix(1:16, 4), B=matrix(1:16, 8), C=15:1)

## adds the number of rows (or length) of corresponding elements
simpleFunc <- function(x, y)
{
NROW(x) + NROW(y)
}

# apply the function to the two lists
map2(firstList, secondList, simpleFunc)

#We can use anonymous fxn
map2(firstList,secondList,function(x,y) NROW(x)+NROW(y))
#Can also use map's formula notation for anonymous fxns, 
#with .x and .y
map2(firstList,secondList,~ NROW(.x)+NROW(.y))

#Can append _type to map2
map2_int(firstList,secondList,~ NROW(.x)+NROW(.y))


#The more general pmap can take any number of lists,
#which themselves shoudl be in a list
pmap(list(firstList,secondList),simpleFunc)
