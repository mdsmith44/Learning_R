##### Intro
#Tibbles are extensions of data.frame objects, with new
#features to facilitate modern data analysis within the
#tidryverse.
library(tidyverse)

#Any tidyverse action will create tibble
#Can coerce non-tibbles df's to tibbles:
as_tibble(iris)

#Can create a new tibble with tibble()
tibble(
  x=1:5,
  y=1,
  z=x^2+y
)
#Note that it uses vectorized ops, with recycling
#Also note it can immediately reference fields in the tibble

#In theory you can provide non-standard variable names as
#col names (e.g. using space) by surrounding in backticks,
#Though this is generally not a good idea
tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb
#> # A tibble: 1 x 3
#>   `:)`  ` `   `2000`
#>   <chr> <chr> <chr> 
#> 1 smile space number

#Can also create tibbles row-wise with tribble()
tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
#> # A tibble: 2 x 3
#>   x         y     z
#>   <chr> <dbl> <dbl>
#> 1 a         2   3.6
#> 2 b         1   8.5


#Two main differences between tibbles and data.frame
#These are printing and subsetting.
#One is printing, as tibbles only show first 10 rows and
#however many columns fit in screen, so no need to use 
#head

#What if you want to actually display more?
#Can use print(tbl,n=num_rows,width=num_cols)
#Use Inf for all 
nycflights13::flights %>% 
  print(n = 10, width = Inf)

#Could also change default print behavior

#Or could use View() to open scrollable viewer
nycflights13::flights %>% 
  View()

#head still works fine
head(nycflights13::flights)


#Subsetting is also diff from base-R data.frame's
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
#Use $ to extract by name
df$x
#Can also use [[]] to extract by name
df[['x']]
#Use single [] to grab new tibble with that field
#Single [] always returns tibble, though isn't used much
#since filter and select from dplyr are preferred
df['x']
#Grab multiple cols
df[c('x','y')] #This works
df[[c('x','y')]] #This doesn't work
#Can also use [] to grab position
df[[1]] #return vector with values of first col
df[1] #return tibble with just 1st col
#Can also use pipe with special placeholder "." to specify
#where the incoming object is injected
df %>% .$x #Same as df$x
df %>% .["x"]

#Recall some typical data.frame subsetting
df <- data.frame(abc = 1, xyz = "a")
df$x #returns col xyz due to partial match
df[, "xyz"]
df[, c("abc", "xyz")]
#May not work on tibble
(df2 <- as_tibble(df))
df2$x #doesnt' return partial matches
df2[,'xyz'] #this seems to work
df2[, c("abc", "xyz")] #seems to work too

#Can turn tibble back to data.frame with as.data.frame()
#Sometimes needed if old code doesn't work with tibbles

#Rename cols with rename(df,c(new1=old1,new2=old2))
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying %>% rename(c('one'=`1`,'two'=`2`))
