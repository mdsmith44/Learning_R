#if else syntax

a = 10
if (a > 5) {
  print('high')
} else if (a < 0) {
  print('low')
}else{
  print('med')
}
a>5
#Note that we don't HAVE to have spaces before or after brackets

## Switch
#We can emulate if-else if-... functionality with switch
use.switch <- function(x) {
  switch (x,
          "a"="first",
          "b"="second",
          'other'
  )
}
use.switch('a') #'first'
use.switch('b') #'second'
use.switch('x') #'other', which is default
#So switch is essentially a dict?
#Can also reference argument by num index
use.switch(2) #'second'
use.switch(3) #'other'
use.switch(4) #NULL


## ifelse
#can use ifelse to take one action if TRUE, and another if FALSE
ifelse(1==1,'yes','no') #'yes'
ifelse(1==2,'yes','no') #'no'

#main value to code speedup is when operating on vectors
toTest <- c(1,1,0,1,0,1)
ifelse(toTest==1,'yes','no')
#Can feed in vectors as well
ifelse(toTest==1,3*toTest,toTest)

#NAs will result in NAs
toTest[2] <- NA
toTest
ifelse(toTest==1,'yes','no')

#Note that ifelse returns vector, which must have single type
#e.g. it may force numerics to be strings to get single type
ifelse(toTest==1,toTest,'one') #will return '1' instead of 1


## Compound Statements
#And (&) and or (|) operators can be used in single or 
#double form.  Differ in how they handle multiple logical vecs
a <- c(1,1,0,1)
b <- c(2,1,0,1)

(a==1)&(b==1) #Single returns vec, (F,T,F,T)
(a==1)&&(b==1) #Double returns just first element, F 

#better to use single &, | for ifelse
ifelse(a==1 & b==1,'Yes','No')
ifelse(a==1 && b==1,'Yes','No') #just returns "No"
