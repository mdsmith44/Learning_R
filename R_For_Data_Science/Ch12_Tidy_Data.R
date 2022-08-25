#tidyr is a package with many tools to help clean data
#to make it "tidy", meaning each variable is a column, 
#and each observation a row

# In real world you may encounter non-tidy data, typically
#due to fact that the format facilitated data entry.
# Typically non-tidy data will have variables spread across
#mutliple columns, or observations spread across multiple rows.
# The main tools to deal with these and make data tidy are
#pivot_longer and pivot_wider.
# tidyr has built in tables giving examples of nontidy data,
#saved in table1, table2, table4a, table4b, ...

#Use pivot_longer when col names should be values
#Use pivot_wider when col values should be names

library(tidyverse)

#Note that they arent' perfectly symmetric
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
  pivot_wider(names_from = year, values_from = return)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

#Separate
table3
table3 %>% separate(rate,into=c('a','b'))
#by default it looks for any non alpha-num characters to split on
#by default it keeps original formatting; use convert=TRUE to convert
table3 %>% separate(rate,into=c('a','b'),convert=TRUE)

#opposite of separate is unite
table3 %>% 
  separate(rate,into=c('a','b'),convert=TRUE) %>%
  unite('new_col','a','b')
  
#We can use separate to "split" and only keep first piece?
df <- tibble(G1=c('Matt Smith (123)','Bob Jones (456)'))
df
df %>% separate(G1,into=c('Name1'),sep=" \\(",
                extra='drop')

##### Missing values
#pivoting wider and longer will often introduce NAs

#Some tricks for dealing with NAs...

#Can use option to ignore NAs when pivoting longer
#look at toy example.  Note that 2015QTR4 is explicitly NA,
#wherease 2016QTR1 is implicitly NA (not present)
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

#pivoting wider will carry thru explicit NAs and add in 
#implicit ones
stocks %>% 
  pivot_wider(names_from = year, values_from = return)

#When pivoting longer, can drop NAs
stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(
    cols = c(`2015`, `2016`), 
    names_to = "year", 
    values_to = "return", 
    values_drop_na = TRUE
  )
#> # A tibble: 6 x 3
#>     qtr year  return
#>   <dbl> <chr>  <dbl>
#> 1     1 2015    1.88
#> 2     2 2015    0.59
#> 3     2 2016    0.92
#> 4     3 2015    0.35
#> 5     3 2016    0.17
#> 6     4 2016    2.66

#copmlete() is useful tool to get one row for every combo of
#designated columns
stocks %>% complete(year,qtr)

#many ways to fill NAs
#Use fill() to fill nulls with adjacent non-null values
stocks %>% 
  complete(year,qtr) %>%
  fill(return)
