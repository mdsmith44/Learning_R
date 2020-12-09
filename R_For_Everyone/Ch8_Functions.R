#Functions

#Function syntax is a bit different in R
say.hello <- function() {
  print("Hello world")
}
#Execute it
say.hello()

#Add arguments
hello.person <- function(name) {
  print(sprintf("Hello %s",name))
}
hello.person('Max')

#Can name arguments in function call
#Add in default arg values as well
hello.person <- function(first='Joe',last='Bloggs') {
  print(sprintf("Hello %s %s",first,last))
}
hello.person(last='Smith')

#Can even go out of order then go unnamed, and R will
#assume you mean earliest unused argument
hello.person(last='Smith','Matt')

#Recall we can see arguments for function
args(hello.person)

#Can also use ... to allow funcino to take arbitrary number
#of additional args
hello.person  <- function(first, last="Doe", ...) {
  print(sprintf("Hello %s %s", first, last))
}
#Now can add extra args and it won't throw an error
hello.person('Matt','Smith','sadlfkdsj')
#But can it actually do anything with extra args?

#If we don't use return, last line is automatically returned
double.num <- function(x)
  {
       x * 2
}
double.num(4)

#But of course better practice to use return
double.num <- function(x) 
  {
  return(x * 2)
  }
double.num(4)

#We can programmatically envoke a function with
# do.call(function,list_of_args)
do.call(hello.person,args=list(first="Matt",last='Smith'))
#Can be useful when creating function that takes func as input
run.this <- function(x,func=mean) {
  do.call(func,args=list(x))
}
run.this(1:10)
run.this(1:100,sum)
