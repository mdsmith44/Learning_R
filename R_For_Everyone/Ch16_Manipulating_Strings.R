##### Intro
#As usual, we'll see some base R packages, paste and sprintf,
#and then see Hadley Wickham's next gen package, stringr.

##### paste
#Combines multiple strings into single string
paste("Hello", "Jared", "and others")

#default separater is space; can change with sep
paste("Hello", "Jared", "and others",sep=':')

#Like all R functions, paste is vectorized and can operate
#element wise on inputted vectors
paste(c("Hello", "Hey", "Howdy"), 
      c("Jared", "Bob", "David"))
#This returns a new vector of length 3
#We can collapse into single character
paste(c("Hello", "Hey", "Howdy"), 
      c("Jared", "Bob", "David"),
      collapse=" ")

#Can mess with both sep and collapse
paste(c("Hello", "Hey", "Howdy"), 
      c("Jared", "Bob", "David"),
      collapse=":",sep='_')


##### sprintf
#this is better suited to injecting variables into a string,
#as in s.format()
person <- "Jared"
partySize <- "eight"
waitTime <- 25
sprintf("Hello %s, your party of %s will be seated in %s minutes",
        person, partySize, waitTime)

#sprintf is also vectorized
sprintf("Hello %s, your party of %s will be seated in %s minutes",
        c("Jared", "Bob"), 
        c("eight", 16, "four", 10), 
        waitTime)
#Note: unlike other vectorized funcs, the vectors lengths
#must be multiples of each other, won't recycle



##### stringr
#more useful for handling and parsing text
#has manu useful functions of the form str_func,
#such as str_extract, str_trim, str_split, etc
library(XML)
# load("data/presidents.rdata")
theURL <- "https://www.loc.gov/rr/print/list/057_chron.html"

# presidents <- readHTMLTable(theURL, which=3, 
#                             as.data.frame=TRUE,
#                             skip.rows=1, header=TRUE,
#                             stringsAsFactors=FALSE)

presidents <- read.csv("data/presidents.csv",header=TRUE)
presidents

#Split YEAR (e.g. 1801-1805) into start and end years
library(stringr)

yearList <- str_split(string=presidents$YEAR,
                      pattern="-")
head(yearList)
#Note that we can get two new years, or 1, or empty str
#Combine them into one matrix
yearMatrix <- data.frame(Reduce(rbind,yearList))
head(yearMatrix)

# give the columns good names
names(yearMatrix) <- c("Start", "Stop")
# bind the new columns onto the data.frame
presidents <- cbind(presidents, yearMatrix)
# convert the start and stop columns into numeric
#Note: to convert factor to numeric, need to first
#convert to character, otherwise we get the numeric
#level of each factor
presidents$Start <- as.numeric(as.character(presidents$Start))
presidents$Stop <- as.numeric(as.character(presidents$Stop))
# view the changes
head(presidents)


#Select specific characters with str_sub
str_sub(string=presidents$PRESIDENT, start=1, end=3)

#Can be useful for filtering
#Just get presidents who started in year ending in 1
presidents[str_sub(string=presidents$Start, start=4, end=4) == 1,
           c("YEAR", "PRESIDENT", "Start", "Stop")]


##### regex
#can use str_detect to detect regex pattern
johnPos <- str_detect(string=presidents$PRESIDENT, 
                      pattern="John")
presidents[johnPos, 
           c("YEAR", "PRESIDENT", "Start", "Stop")]

#Can opt to ignore case
# goodSearch <- str_detect(presidents$PRESIDENT, ignore.ca("John"))

#Load some more data to see power of regex
#NOTE: To load rdata file from a url, need to load and
#then cload a connection.
con <- url("http://www.jaredlander.com/data/warTimes.rdata")
load(con)
close(con)
#dataset has dates for start and stop dates of wars
#Is a character vector, which is what str_x expects, 
#though it will try to coerce to char vec
head(warTimes,10)
#'ACAEA' is the Wikipedia encoding for separator
#Though also uses "-" for separater once
#Look for both with regex "(ACAEA)|-"
theTimes <- str_split(string=warTimes, 
                      pattern="(ACAEA)|-")
#Turns out this doesn't quite work because there's an 
#entry with ACAEA and a hyphen in mid-July
theTimes[str_detect(warTimes,"-")]
#Can get around this with n=2
#n=2 means return at most 2 pieces for each item
theTimes <- str_split(string=warTimes, 
                      pattern="(ACAEA)|-",n=2)
theTimes[str_detect(warTimes,"-")]

#Lets just get the first date
#Recall what we have
head(theTimes)
#Use sapply to get just first date
theStart <- sapply(theTimes,
                   FUN=function(x) x[1])
theStart[1:4]

#Some text has trailing white space
#Remove it with str_trim (same as strip())
theStart %>% str_trim %>% head


#Extract patterns with str_extract
# pull out "January" anywhere it's found, 
#otherwise return NA
str_extract(string=theStart, pattern="January")

#Try another pattern, e.g. 4 numbers
#Will we get multiple matches?
head(theTimes)
head(str_extract(theTimes,pattern='[0-9]{4}'))

#Note: in R, character shortcuts need two \'s
#So \\d for digit, not \d
head(str_extract(theStart,pattern='\\d{4}'))

#This just gets first match
#Can get all matches
head(str_extract_all(theTimes,pattern='[0-9]{4}'))

#Use str_detect to see if each entry contains pattern
# just return elements where "January" was detected
theStart[str_detect(string=theStart, 
                    pattern="January")]

#Note that str_x designed to work on char vectors
class(theTimes) #list
class(warTimes) #character (vector)
class(theStart) #character (vector)

#Just look at the start of text
head(str_extract(string=theStart, 
                 pattern="\\d{4}$"), 10)
#beginning and end
head(str_extract(string=theStart, 
                 pattern="^\\d{4}$"), 10)


#Replace text with str_replace
head(str_replace(string=theStart, 
                 pattern="\\d", 
                 replacement="x"), 30)
#Will just replace the FIRST occurence of pattern

#Or replace_all
head(str_replace_all(string=theStart, 
                 pattern="\\d", 
                 replacement="x"), 30)

#Can also replace just a PART of the pattern
# create a vector of HTML commands
commands <- c("<a href=index.html>The Link is here</a>",
              "<b>This is bold text</b>")
#Extract just text between tags
str_extract(commands,
           pattern="<.+?>(.+?)<.+>")
#Hmm, grabs whole pattern, not just group

#Replace the pattern with the n'th group within the 
#pattern with replacement=\\n.  Similar to $n in other
#languages
str_replace(string=commands, 
            pattern="<.+?>(.+?)<.+>",
            replacement="\\1")


#If we just give normal replacment, will replace whole
#pattern
str_replace(string=commands, 
            pattern="<.+?>(.+?)<.+>",
            replacement="test")
