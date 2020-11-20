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
#in addition to defaulting to char and tibbles

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
#Now we can use RSQLite's many methods to connect to db

#To connect to DB, first need to specify the driver
drv <- dbDriver('SQLite')
class(drv)

#Next, establish connection to DB with dbConnect
con <- dbConnect(drv, 'data/diamonds.db')
class(con)

#Now we db
dbListTables(con)
dbListFields(con, name='diamonds')
#Think of Tables as tabs in excel, and fields as col names

#Now run any SQL query with dbGetQuery
diamondsTable <- dbGetQuery(con,
                            "SELECT * FROM diamonds",
                            stringsAsFactors=FALSE)

head(diamondsTable)

#Try longer query
longQuery <- "SELECT * FROM diamonds, DiamondColors
WHERE
diamonds.color = DiamondColors.Color"
Join <-dbGetQuery(con, longQuery,stringsAsFactors=FALSE)
head(Join)


##### Data from other tools
#The foreign package provides functions to read data from
#many other sources, e..g SAS, Octave, Mintab
# Hadley Wickham also has a package haven that mimics foreign
#in a Hadley Wickham kind of way

##### R Binary files
# RData files are common way to represent any R objects
#including data, as a binary file.  Can be passed among Windows,
#Mac, Linux.  

#Save df as rdata file
df_tomato <- df <- read_csv(url)
head(df_tomato)

save(df_tomato, file="data/df_tomato.rdata")
#Remove it
rm(df_tomato)
#It doesn't exist now
head(df_tomato)
#Load it back
load("data/df_tomato.rdata")
head(df_tomato)

#We can also save several objects into RData file
n  <- 20
r  <- 1:10
w  <-data.frame(n, r)
save(n, r, w, file="data/multiple.rdata")
#remove them
rm(n,r,w)
#load them back
load("data/multiple.rdata")
#Now they all exist again
w

# Note that loading RData file restores objects with the same
#name they had when saved.  Hence no need to assign results
#of load to an object

# Another type of R binary file, RDS, doesn't save objects with
#a name.
v <- c(1,5,4)
saveRDS(v, file='thisObject.rds')
#Read object back in and assign to new object
v2 <- readRDS('thisObject.rds')
v2
#We see they are identical
identical(v,v2)


##### Data included with R
#Type data() into console to get list of available data
data()
#e.g. to get diamonds data from ggplot2
data(diamonds, package='ggplot2')
head(diamonds)


##### Get data from web
#If data is neatly in an HTML Table, that's easy
#using readHTMLTable function in XML package
install.packages('XML')
library(XML)
url_table <- "https://www.jaredlander.com/2012/02/another-kind-of-super-bowl-pool/"
df <- readHTMLTable(url_table,
                    which=1, header=FALSE,
                    stringsAsFactors=FALSE)

#Web Scraping
#Hadley Wickham's rvest is good for webscraping
install.packages("rvest")
library(rvest)
#Read in data for a pizza restaurant called Ribalta
ribalta <- read_html('http://www.jaredlander.com/data/ribalta.html')
#This loads HTML data as an xml_document object
class(ribalta)

#see the raw html
ribalta
#Turns out address is in a <span> within a <ul>
#Use html_nodes function from rvest package to find
#all span elements within ul elements
res <- ribalta %>% html_nodes('ul') %>% html_nodes('span')
#result is a list of HTML elements
class(res)
class(res[1]) 
res
#Search for object that has class='street'
ribalta %>% html_nodes('.street')
#Get the text out of this element with html_text
ribalta %>% html_nodes('.street') %>% html_text()
#We could also use html_attr to get info from element attributes

##### reading JSON data
#R has packages for this, rjson and jsonlite
