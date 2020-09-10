##### Assigning Variables
#Variables can be assigned with <- (preferred) or =
x <- 5
#Use Alt and - as shortcut for <-
print(x)
y = 4
print(y)

#Arrow can go in other direction too
3 -> z
z

#Can also assign multiple variables at once
x <-  y <- 4

#Can assign usuign assign function
assign("j",4)
j

#variable names can have periods, underscores, nums
#Though cannot START with number or underscore

#Can remove variable with remove or rm
rm(j)
j #not found

##### Data Types
#4 main data types: numeric, character, Date, logical
#Can see variable type with class() function
class(x)
c = "Name"
class(c)

#Can test whether variable is numeric
is.numeric(z)

#Numeric can be integer or float
#There is also a pure integer type, designated with L
i <- 5L
class(i)
#TRUE for both numeric and integer
is.numeric(i) 
is.integer(i)

#R will naturally promote integer to numeric
class(4L * 2.2)

#R has 2 ways to deal with string data
#character and factor
x <- "data"
class(x)
y <- factor("data")
y

#Can get length with nchar
nchar(x)
#nchar even works on numbers
nchar(900)

# Many ways to handle dates
# 2 most useulf are Date and POSIXct
#Date is days since 1/1/1970
#POSIX is seconds since 1/1/70
d1 <- as.Date("2002-06-10")
d1
class(d1)
as.numeric(d1) #days since epoch

d2 <- as.POSIXct("2002-06-10")
d2
#Note that POSIX gives time and time zone
d2 <- as.POSIXct("2012-06-28 17:42:00 EDT")
d2
class(d2)
as.numeric(d2) #seconds since epoch


## Logical
#We have TRUE adn FALSE
#Also represented as 1 and 0
TRUE*5
FALSE*5 #0
is.logical(TRUE)
#T and F are shortcuts for TRUE adn FALSE
#But beware as they can be overwritten as variables

#Can get logicals from comparisons
2==3
2!=3


##### Vectors
#vectors are collections of elements of the same type
#Created using combine function c()
v1 <- c(1,2,3)
v1
v2 <- c('R','Excel','Python')
v2
#Vectors have class type of what they contain
class(v1)
class(v2)

#All operations are automatically vectorized
3*v1

#Shortcut for sequence of numbers
r <- 1:10
r
class(r)
#Can go backwards too
5:0

#Operations on two vectors are also elemnt wise
v1*5:7

#If vectors are unequal length, shorter one gets
#recycled to match longer one
1:10 + c(1,2)

#Can also have logical vectors
l = 1:10 > 5
l
#Useful to use any or all on logical vectors
any(l)
all(l)

#Can use nchar on each element
v2
nchar(v2)

#Access elements with square brackets
v1 <-  1:10
v1[1]
v1[1:2]
v1[c(1,5)]
#Get all elements except certain indices
v1[-c(5,6)]
v1[-(5:10)]

#Can give names to elements
x <-c(One="a",Two="y",Last="r")
x
#Can add or change names
w <- c(1,2,3)
names(w) <- c('a','b','c')
w

#Factor vectors are cool
q2 <-c("Hockey", "Lacrosse", "Hockey",
       "Water Polo","Hockey", "Lacrosse")
#Convert to factor
f2 <- as.factor((q2))
f2
#Technically each element is an int, for each level
as.numeric(f2)

#Default is levels are unordered, but can order them
factor(x=c('HS','BS','BS','HS','Masters','Doctorate'),
       levels=c('HS','BS','Masters','Doctorate'),
       ordered=TRUE)
#Factors can reduce size if used properly

##### Gettign Help
#get help on any function with ?function_name
?c

#get help on operators
?`*`

#Lookup function with apropos
apropos('mea')


##### Missing Data
#NA adn NULL both used
#NA is for missing data
z <- c(1,2,NA,7,NA,3)
is.na(z)

#NA's in vectors will block numerical functions
mean(z)
#Unless we set na.rm=TRUE
mean(z,na.rm=TRUE)

#NA means there's a spot with nothign in it
#NULL means there's no spot at all
z <- c(1,NULL,3)
z
#NuLL can't be part of vector
a <- NULL
is.null(a)
class(a)

##### Pipes
#Pipes are way to feed values to a function
#Lets use a pipe from the magrittr package
x <- 1:10
library(magrittr)
x %>% mean
#Pipes are useful to chain together function calls
#Same as multiple "."'s in pandas
#e.g. df.score.str.len().mean()...
#Ex: Find how many elements are NA
z <- c(1,2,NA,3,4,NA,5)
#Can use two functions
sum(is.na(z))
#Or can use pipe
z %>% is.na %>% sum

#Can also add function arguments
z %>% mean(na.rm=TRUE)

#Pipes are used extensively in modern packages
#especially after popularized by dplyr