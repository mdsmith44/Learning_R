## R has built-in *apply* family of functions

## apply
#Apply function to each row or col of matrix
m <- matrix(1:9,nrow=3)
m
apply(m,MARGIN = 1,FUN=sum)
#MARGIN specifies to apply function to rows(1) or cols (2)

#Note that R has built in rowSums or colSums
rowSums(m)

#When nulls are present, may need to use na.rm arg
m[2,1] <- NA
m
apply(m,1,sum) #2nd row sums to NA
apply(m,1,sum,na.rm=TRUE) #2nd rum sums to num
#na.rm is usually argument for any such functions
rowSums(m,na.rm = TRUE)


## lapply and sapply
# Apply function to each element of a list (or vector)
L <- list(A=matrix(1:9, 3), B=1:5, C=matrix(1:4, 2), D=2)
L
lapply(L,sum) 

#lapply returns list, which can be cumbersome
#sapply works same way but returns a vecytor
sapply(L,sum)

sapply(c('apple','bananas'),nchar)

## mapply
#Apply function to each element of multiple lists
## build two lists

L1 <- list(A=matrix(1:16, 4), B=matrix(1:16, 2), C=1:5)
L2 <- list(A=matrix(1:16, 4), B=matrix(1:16, 8), C=15:1)

# test element-by-element if they are identical
mapply(identical, L1,L2)

#There are others, but most are not used due to drplyr

##### Aggregations (groupby)
#data(diamonds, package='ggplot2')
head(diamonds)
#Syntax is aggregate(formula, data, func)
#formula is y ~ x, i.e. group y by values of x
a <- aggregate(price ~ cut,diamonds,mean)
a
class(a) #returns a data.frame

#group by multiple variables
aggregate(price ~ cut + color,
          diamonds,mean)
#Aggregate multiple variables
aggregate(cbind(price,carat) ~ cut,diamonds,mean)
#cbind doesn't work to combine two dependents.
#aggregate(price ~ cbind(cut,color),diamonds,mean)

#mutliple variabesl on each side of formula
aggregate(cbind(price,carat) ~ cut+color,diamonds,mean)


##### PLYR
#Aggregate can be slow for bigger data
#The suite of plyr packages, part of tidyverse, have been
#tremendously successful method for data manipulations.
# Name comes from using "pliers" on data.
# First 2 letters of functions specify input and output data
# E.g. ddply takes in data.frame and outputs data.frame
# other letters are l (list), a (array/vec/matrix)

#Note: plyr has been supersceded by dplyr, whihc is even 
#more awesomer?
library(plyr)
head(baseball)

#sac flies (sf) is null before 1954; set to 0
baseball$sf[baseball$year<1954]
#Note no comma, since we're just indexing a vector, not a df
#Set to 0's
#No fillna, have to set them to 0
#$sf[baseball$year<1954] <- 0
#Could also do this
baseball$sf[is.na(baseball$sf)] <- 0

#make sure no NAs left
any(is.na(baseball$sf))

# set NA hbp's to 0
baseball$hbp[is.na(baseball$hbp)] <- 0

#Only keep players with at least 50 ABs
baseball <- baseball[baseball$ab>=50,]

#Now create new field OBP for on base percentage
#Rather than write "baseball$field" for all the fields,
#we can use the *with* function to get fields without
#repeating df name each time
baseball$OBP <- with(baseball, (h + bb + hbp) / 
                       (ab + bb + hbp + sf))
#Look at info for given player
last_yr <- max(baseball$year)
last_yr
test_player <- baseball[baseball$year==last_yr,]$id[1]
test_player
head(baseball[baseball$id==test_player,])

#What if we want each player's career OBP?
#Can't just average each year's OBP, need ddply
#First define function
obp <- function(data){
  c(OBP=with(data,sum(h+bb+hbp)/sum(ab+bb+hbp+sf)))
}
#Note that with(..) returns single number if used on df
with(baseball,sum(h+bb+hbp)/sum(ab+bb+hbp+sf))
#And c(OBP=with(...)) basically assigns name to it
#which helps assign name to resulting column with ddply?
c(OBP=with(baseball,sum(h+bb+hbp)/sum(ab+bb+hbp+sf)))
#But when used to assign new df field it goes row by row?
?with

#Now find career OBP
careerOBP <- ddply(baseball,.variables="id",.fun=obp)
#Sort and view
careerOBP <- careerOBP[order(careerOBP$OBP, decreasing=TRUE), ]
head(careerOBP)

##llply
theList <- list(A=matrix(1:9, 3), B=1:5, C=matrix(1:4, 2), D=2)
theList
llply(theList,sum)

#Can also use anonymous functions
llply(theList,function(x) max(x))

#Get result in vector (not list) with laply ("L" "A" "Ply")
laply(theList,sum)

## Helper functions
#plyr has many useful helper functions
#can use plyr's "each" function with aggregate
#to apply multiple functions
aggregate(price~cut,diamonds,each(mean,median))

#Can use idata.frame to reference a df and save memory
system.time(dlply(baseball,'id',nrow))
#Do same function with idata.frame reference
iBaseball <- idata.frame(baseball)
system.time(dlply(iBaseball, "id", nrow))


##### data.tables
#The data.tables package offers enhanced speed, though hasn't
#seen adoption of tidyverse tibbles.

#data.tables do offer fast aggregation, so may be useful in
#settings where speed is important