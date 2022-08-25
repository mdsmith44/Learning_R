#take a look at nycflights data
#install.packages('nycflights13')
library(nycflights13)
library(tidyverse)

#Check out flights data
flights
class(flights)

#5 key "verbs" in grammar of data:
# filter, arrange, select, mutate, summarise
# All can be used in conjunction with group_by

##### Filter - Get subset based on column values
filter(flights,month==1)
#Can add multiple conditions separated by commas
filter(flights,month==1,day==1)

#Be careful with numerical comparisons, as finite precision
#may wreak havoc
1/49*49==1 #FALSE!!
#Can be better to use near
near(1/49*49,1) #TRUE

#Can also use standard & or | operators
filter(flights,month==1 & day==1)
filter(flights,month==11 | month==12)

#Also useful to use %in% operator
filter(flights,month %in% c(11,12))

#By default filter will exclude any NA's
#To include, use is.na() as one of the conditions
df <- tibble(x=c(1,NA,3))
filter(df,x>1)
filter(df,x>1 | is.na(x))

#Can also simplify with between
filter(df,between(x,1,2))

##### arrange() to re-arrange and sort rows
arrange(flights,year)

#use multiple fields for primary, secondary, etc sorts
arrange(flights,year,month,day)

#Default is ascending.  Use desc(field) for descending
arrange(flights,year,desc(month))

#NA's are always at the end, whether asc or desc
arrange(df,x)
arrange(df,desc(x))
#To put NA's up top create new field is.na
arrange(df,desc(is.na(x)),x)

##### select subset of cols
select(flights,year,month,day)
#select all cols between year and day (inclusive)
select(flights,year:day)
#select all cols except ones to exlude
select(flights,-(year:day))

#Many useful helper functions
select(flights,starts_with('ye'))
select(flights,ends_with('ear'))
select(flights,contains('e'))
#or get regex matches
select(flights,matches("(.)\\1"))
select(flights,num_range('x',1:3)) #matches x1, x2, x3

#rename() is a useful variant of select, used to
#rename cols
rename(flights,Year=year)#new_name=old_name

#Use select to re-order cols by making use of everything()
select(flights,time_hour,air_time,everything())
#This will move those cols up front, then keep everything
#else

select(flights, contains("TIME",ignore.case=FALSE))


##### Add new variables with mutate()
#Get smaller df
flights_sml <- select(flights,
                      year:day,
                      ends_with('delay'),
                      distance,
                      air_time)
flights_sml

#Add new fields as fxn of existing ones
mutate(flights_sml,
       gain=dep_delay-arr_delay,
       speed=distance/air_time*60)

#Only keep new fields with transmute()
transmute(flights,
          gain = dep_delay - arr_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

#Find difference from mean
transmute(flights,
            distance,
            diff=distance-mean(distance))

#lag() and lead() are useful ways to get get offsets
#e.g. useful for runnign differences
x <- 1:10
lag(x)
lead(x)

#Many useful cumulative fxns: cumsum(), cumprod,
#cummin, cummax.
# For rolling fxns, use RcppRoll package

#Many useulf ranking fxns as well
y <- c(1,2,2,NA,3,4)
min_rank(y)
min_rank(desc(y))
quantile(y,.25,na.rm=TRUE)


##### summarise() and group_by()
#Collapse each col to single value
#i.e. collapse df to single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

#summarise mose useful when paired with group_by
by_day <- group_by(flights, year, month, day)
by_day
summarise(by_day,delay=mean(dep_delay,na.rm=TRUE))

#Here's what it looks like with pipes
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")
#This gets counts, mean dist, and mean delay 
#for each value of dest
# Note that n() is a count function, giving num of
#entries for that group, including NAs
delays


#Now plot it
ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

#Save non-cancelled flights to explore 
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

#Get average delays
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

#Get measures of spread
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

#Get earliest and latest flights each day
not_cancelled %>%
  group_by(year,month,day) %>%
  summarise(earliest=min(dep_time),
            latest=max(dep_time))

#Can also use shorthand fxns first, last, nth
not_cancelled %>%
  group_by(year,month,day) %>%
  summarise(first_dep=first(dep_time),
            last_dep=last(dep_time),
            second_dep=nth(dep_time,2))
#e.g. first(x) grabs first element, so x[1]
#may or may not be the lowest number

#n() gives total count (including NAs)
#To get non-NA entries use !is.na(field)
not_cancelled %>%
  group_by(year,month,day) %>%
  summarise(num_non_NA = sum(!is.na(x)))

#To get number of distinct entries, use n_distinct
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

#Get counts with count() straight away
not_cancelled %>% 
  count(dest)

#Same as n()?  No this doesnt' work
not_cancelled %>%
  n(dest)

#Is same as this
not_cancelled %>%
  group_by(dest) %>%
  summarise(n=n())

#Count can also take weight argument
#This gives total cumulative distance for each tailnum
not_cancelled %>%
  count(tailnum,wt=distance)

#Useful to use sum or mean with logicals, which convert
#TRUE to 1 and FALSE to 0
# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

#What porportion are delayed more than an hour each day
not_cancelled %>%
  group_by(year,month,day) %>%
  summarise(hour_prop=mean(arr_delay>60))

#Can also use group_by with other verbs
#Find worst 3 members of each group
flights_sml %>%
  group_by(year,month,day) %>%
  filter(rank(desc(arr_delay))<=3)
#This gives worst n delays for each day

#Only keep groups with certain number of entries
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)
#Now see how many entries each dest has
#Shoudl be at least the thresh
popular_dests %>%
  group_by(dest) %>%
  summarize(count=n()) %>%
  arrange(count)


#Ungrouping can ungroup with ungroup()


