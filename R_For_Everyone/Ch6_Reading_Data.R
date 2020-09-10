##### Reading CSVs

#Can read csv into data.frame with read.table
url <- "http://www.jaredlander.com/data/TomatoFirst.csv"
df <- read.table(url,sep=',')
head(df)

#read.table forces you to specify sep=','
#most normal people prefer read.csv which has that
#as default
df <- read.csv(url)
head(df)
?read.csv

#R defaults all strings to be read as factors
#Sometimes is helpful to disable this
#What is current class of Tomato column?
df$Tomato
#It's a factor
#Read it in as string instead
df <- read.csv(url,stringsAsFactors = FALSE)
df$Tomato
#Now it's a character vector

#There are some other functions better suited to 
#reading in large files: read_delim and fread.

#read_delim is from Hadley Wickam's readr package,
#a family of functions for reading data files
install.packages("readr")
library(readr)

#Have to specify delim
df2 <- read_delim(url,delim = ',')
head(df2)
#Note that we get a "tibble"
#It also reads in chr, not factor by default
#A tibble shows the data types which is also nice
class(df2)
?read_delim

#Turns out read_delim is faster than read_table,
#in addition to defaulting to char adn tibbles

#readr package also has extensions read_csv that
#is wrapper around read_delim with delim=','
df2 <- read_csv(url)
head(df2)

#fread
#fread is another option for reading large data quickly
#it's from the data.table package
install.packages("data.table")
library(data.table)
df3 <- fread(url)
head(df3)
#Results in a data.table object, which is extension of 
#data.frame

#Decision between read_delim vs fread depends on whether you
#want to use reader/dplyr or data.table for overall data
#manipulation.  dplyr seems to be most popular.

#readr also has read_excel, which was previously not supported
#in R.
class(df3)


##### Databases
# Most popular databases have R packages such as RPostgreSQL
#and RMySQL.  
# There's also a generic package RODBC to connect to many
#database types.

# Lets look at an SQLite ex, which is nice since the whole
#database is in a single file
url2 <- "http://www.jaredlander.com/data/diamonds.db"
download.file(url2,destfile = "data/diamonds.db", mode='wb')
#SQLite has its own R package, RSQLite
install.packages("RSQLite")
library(RSQLite)
#First specify the driver
drv <- dbDriver('SQLite')
class(drv)


