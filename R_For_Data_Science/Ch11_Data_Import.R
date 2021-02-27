#main import package is readr, part of tidyverse
library(tidyverse)

#readr has many read_xxx() functions, e.g. read_csv()
#Compared to base-R's read.csv(), read_csv() is much faster
#and also produces tibble.

#Can inject string with csv contents to csv, useful for 
#exploring options
read_csv("a,b,c
1,2,3
4,5,6")

#Skip rows with skip=n
read_csv("The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3", skip = 2)

#Skip all lines starting with comment character
read_csv("# A comment I want to skip
  x,y,z
  1,2,3", comment = "#")

#Tell it not to use first line as col names
read_csv("1,2,3\n4,5,6", col_names = FALSE)

#Pass in col names
read_csv("1,2,3\n4,5,6", col_names = c("x", "y", "z"))

#Specify value in file that signifies NA
read_csv("a,b,c\n1,2,.", na = ".")

#Other useful functions are read_delim() for any delimited
#file, or read_tsv() for tab separated, or read_fwf()

#mistakes
read_csv("a,b\n1,2,3\n4,5,6")


##### Parsing a Vector
#Underpinning the read_xxx functions are a suite of 
#parse_yyy functions which convert char vectors to other
#vector types, such as int, logical, date, etc. 

str(parse_logical(c("TRUE", "FALSE", "NA")))
#>  logi [1:3] TRUE FALSE NA
str(parse_integer(c("1", "2", "3")))
#>  int [1:3] 1 2 3
str(parse_date(c("2010-01-01", "1979-10-14")))
#>  Date[1:2], format: "2010-01-01" "1979-10-14"

#works fine without the str()
parse_logical(c("TRUE", "FALSE", "NA"))

#Can specicy which character represents NA
parse_integer(c("1", "231", ".", "456"), na = ".")
#> [1]   1 231  NA 456

#Can save parsing result, which can be useful when errors
x <- parse_integer(c("123", "345", "abc", "123.45"))
#> Warning: 2 parsing failures.
#> row col               expected actual
#>   3  -- an integer             abc   
#>   4  -- no trailing characters 123.45
#Now x will be accompanied by problems
x
#Get also get the tibble of problems with:
problems(x)

#Can feed in single char (i.e. vector of length 1)
parse_number('20%')

#parse funcs also can use locale to specify formatting
#customs
parse_double("1.23")
#> [1] 1.23
parse_double("1,23", locale = locale(decimal_mark = ","))
#> [1] 1.23
parse_double('1,23')
#problem
# Used in America
parse_number("$123,456,789")
#> [1] 123456789

# Used in many parts of Europe
parse_number("123.456.789", 
             locale = locale(grouping_mark = "."))
#> [1] 123456789
parse_number("123,456,789", 
             locale = locale(grouping_mark = "."))
#> [1] 123.456
# Used in Switzerland
parse_number("123'456'789", locale = locale(grouping_mark = "'"))
#> [1] 123456789

#readr can also guess the str encoding, e.g. UTF-8, which
#is commonly used now to encode all languages and even
#emojis, but older formats like ASCII (for English) or
#Latin1/Latin2 (non-English) are still out there.
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

#Now parse them and specify encoding
parse_character(x1, locale = locale(encoding = "Latin1"))
#> [1] "El Niño was particularly bad this year"
parse_character(x2, locale = locale(encoding = "Shift-JIS"))
#> [1] "こんにちは"

guess_encoding(charToRaw(x1))
#> # A tibble: 2 x 2
#>   encoding   confidence
#>   <chr>           <dbl>
#> 1 ISO-8859-1       0.46
#> 2 ISO-8859-9       0.23
guess_encoding(charToRaw(x2))
#> # A tibble: 1 x 2
#>   encoding confidence
#>   <chr>         <dbl>
#> 1 KOI8-R         0.42


#Parsing dates
#3 Options:
# parse_datetime: seconds since midnight 1970-01-01
# pares_date: days since epoch
# parse_time: seconds since most recent midnight
parse_datetime("2010-10-01T2010")
#> [1] "2010-10-01 20:10:00 UTC"
# If time is omitted, it will be set to midnight
parse_datetime("20101010")
#> [1] "2010-10-10 UTC"

parse_date("2010-10-01")
#> [1] "2010-10-01"

parse_time('01:10 am')
parse_time("20:10:01")

#Can also build your own date-time format
#Year: %Y (4 digit) or %y (2 digit)
#Month: %m (2 digit) %b (Jan) %B (January)
#See rest of chapter for more

#Can use locale to set foreign language
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))
#> [1] "2015-01-01"


#When reading files, readr uses first 1000 entries of each
#row to guess the right parser.  Something like this:
guess_parser(c("2010-01-01",'2020-01-01'))


#Any parse_xxx func has corresponding col_xxx func to 
#hard code format
challenge <- read_csv(readr_example("challenge.csv"))
challenge <- read_csv(
  readr_example("challenge.csv"), 
  col_types = cols(
    x = col_double(),
    y = col_logical()
  )
)


#Can WRITE to csv with write_csv()
write_csv(challenge, "challenge.csv")
