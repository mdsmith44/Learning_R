##### 
#This Ch covers basic functions for reshaping, merging, 
#and combining data, including base-R functions and those in
#plyr, reshape2, and data.table.  These have largely been
#supersceded by tidyr and dplyr methods, discussed in next 
#chapter, but these are still useful.


##### cbind and rbind
# rbind works with multiple datasets with exact same
#set of column names, e.g. stack rows on top of each other.
# cbind works when we have datasets with same number
#of rows, e.g. stack cols side by side.

# Use cbind on three vectors that each have 3 rows (of len 1)
#make three vectors and combine them as columns in a df
sport <- c("Hockey", "Baseball", "Football")
league <- c("NHL", "MLB", "NFL")
trophy <- c("Stanley Cup", "Commissioner's Trophy",
            "Vince Lombardi Trophy")
trophies1 <- cbind(sport,league,trophy)
trophies1

# make another data.frame using data.frame()
trophies2 <- data.frame(sport=c("Basketball", "Golf"),
                        league=c("NBA", "PGA"),
                        trophy=c("Larry O'Brien Championship Trophy",
                                 "Wanamaker Trophy"),
                        stringsAsFactors=FALSE)
trophies2
#And stack them with rbind
trophies <- rbind(trophies1,trophies2)
trophies

#Can also overwrite col names in cbind
cbind(Sport=sport, Association=league, Prize=trophy)




##### joins (pd.merge)
#can merge iwth *merge* in base R, or join in plyr

#download and unzip 8 different files
url <- "http://jaredlander.com/data/US_Foreign_Aid.zip"
download.file(url=url,destfile="data/ForeignAid.zip")
unzip("data/ForeignAid.zip", exdir="data") #Cool!
#Now iterate through the files
library(stringr)
#Get list with dir
theFiles <- dir('data',pattern='US_.+csv')
theFiles#Get 
#Loop through files to assign a new df for each file 
for (a in theFiles) {
  #Get name to use for df that will hold this df
  #e.g. Aid_40s
  nameToUse <- str_sub(string=a, start=12, end=18)
  
  # read in the csv using read.table
  # file.path is a convenient way to specify a folder 
  #and file name
  temp <- read.table(file=file.path("data", a),
                     header=TRUE, sep=",",
                     stringsAsFactors=FALSE)
    
  # assign them into the workspace
  assign(x=nameToUse, value=temp)
}

#built-in merge function
#works fine but is slower than new methods
Aid90s00s <- merge(x=Aid_90s, y=Aid_00s,
                   by.x=c("Country.Name", "Program.Name"),
                   by.y=c("Country.Name", "Program.Name"))
#could have just done by=c(...) since names are the same
names(Aid90s00s)

#plyr join.  Much faster than merge, but matching keys
#must have same name in each df (no left_on or by.x)
library(plyr)
Aid90s00sJoin <- join(x=Aid_90s, y=Aid_00s,
                      by = c("Country.Name", 
                             "Program.Name"))

head(Aid90s00sJoin)
#can also specify type of join (inner, outer, left, right)
#you can kind of do this with merge, but with funky args
#for all.x and all.y

#To join 8 df's, we can put them in a list and use reduce
# first figure out the names of the data.frames
frameNames <- str_sub(string=theFiles, start=12, end=18)
frameNames

# build an empty list
frameList <- vector("list", length(frameNames))
#Give names to each element
names(frameList) <- frameNames
frameList #names are good, entries still NULL
# add each data.frame into the list
for(a in frameNames)
{
  #We have a as the *name* of the df, not the df itself
  #hence have to evaluate it as code, using eval(parse())
  frameList[[a]] <- eval(parse(text=a))
}

#now iterate through list to join all the df's
#we can use Reduce function to speed this up
allAid <- Reduce(function(...){
  join(..., by=c("Country.Name", "Program.Name"))
  },
  frameList)

dim(allAid)

#To get intuition on Reduce, consider this example
Reduce(sum,1:100)
# This will find sum of first 2 elements (1+2), 
#then find sum of this result with 3rd element, etc.
# The use of ... is an advanced R programming trick meaning
#anything can be passed.  Hence it can handle list of 2
#df's being passed in?

##### Reshape2 (i.e. pivot)
#This is anohter Wickham package which can *melt* data (go
#from col orientation to row), or *cast (row to col)

#melt
#consider Aid_00s
head(Aid_00s)
#We have diff col for each year's spending amount, and
#multiple rows for each Country
# We want one row per country.  For example, this is
#useful for ggplot2 graphic algorithms.
# Get one row per country-program-year
library(reshape2)
melt00 <- melt(Aid_00s,
               id.vars=c('Country.Name',
                         'Program.Name'),
               variable.name="Year",
               value.name="Dollars")
               
head(melt00)
#Now we have a col named "Year" which contains the values
#previously held in the remaining col names after using
#the id.vars and the value.name cols

#Now that we've melted data, going from col orientation
#of different year spending to row orientation, we can go
#back by casting, using dcast(), which is tricky to use.
# In casting, the values in one field (in this case the
#"Year" field) become the col names in the new, wider df.
#Hence, casting is equivalenent to pivot_table.
cast00 <- dcast(melt00, 
                Country.Name + Program.Name ~ Year,
                value.var="Dollars")

head(cast00)
#In dcast, first arg is data, 2nd arg is formula
#where LHS are cols to remain cols, and RHS are cols 
#whose values will become new col names.  3rd arg gives
#the values to fill in for all the new cols