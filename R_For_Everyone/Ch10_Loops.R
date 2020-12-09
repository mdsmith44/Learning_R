# philosophy of R is to use vectorization, but sometime need loops

## For loop
for (i in 1:10) {
  print(i)
}

fruit <- c('apple','banana','pomegranate')
for (f in fruit){
  print(nchar(f))
}
#fill out vec with lengths
fruitLength <- rep(NA,length(fruit))
class(fruitLength)
names(fruitLength) <- fruit
for (f in fruit) {
  fruitLength[f] <- nchar(f)
}
fruitLength

#Of coures could also do this with R's built in vectorization
fruitLength2 <- nchar(fruit)
names(fruitLength2) <- fruit
fruitLength2

#Can skip ahead with *next* (instead of continue)
#and break out with *break*
for (i in 1:10){
  if (i%%3==0){
    next
  }
  if (i==8) {
    break
  }
  print(i)
}


## While loops
x <- 1
while(x<5){
  print(x)
  x <- x+1
}

