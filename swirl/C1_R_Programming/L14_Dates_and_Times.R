#Dates are stored by the 'Date' class
#Times by the 'POSIXct' and 'POSIXlt' classes, both subclasses of POSIXt
#Date is days since epoch (1970-01-01)
#POSIXct is seconds since epoch
#POSIXlt is list of seconds, minutes, hours, other fields since epoch

#get current date
d1 <- Sys.Date()
class(d1)
#Use as.numeric(d1) or unclass(d1) to see the internal value
unclass(d1)

#printing d1 will show the formatted date
d1

d2 <- as.Date("1969-01-01")
unclass(d2)
#We get negative number, negative days since epoch

#Get current time
t1 <- Sys.time()
unclass(t1)
t1
class(t1)

#get is as POSIXltt
t2 <- as.POSIXlt(Sys.time())
class(t2)
t2
unclass(t2)
#Get more compact view
str(unclass(t2))

#Get just the minutes
t2$min

#Get the day of the week
weekdays(d1) #works on any date or time objects
weekdays(t1)
#Return month of any date or time objects
months(t1)
quarters(t2)

#Convert character vectors to POSIXlt with strptime
t3 <- "October 17, 1986 08:24"
t4 <- strptime(t3, "%B %d, %Y %H:%M")
t4

strptime('12:30 pm','%H:%M')

Sys.time() > t1
#How much time has passed since we created t1
Sys.time() - t1
td <- Sys.time() - t1
class(td)

#use difftime to specify units
class(difftime(Sys.time(),t1,units='days'))


t1 <- Sys.time()
t2 <- Sys.time()
td <- t2-t1
td
class(td)
as.numeric(td)
unclass(td)