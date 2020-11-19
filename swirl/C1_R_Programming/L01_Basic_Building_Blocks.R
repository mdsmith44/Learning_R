#Lesson 1

#Assigning Variables:
#Can use shortcut of ALT and "-" keys to get " <- "
x <- 5+7

#Create vector, collection of objects of same type, with c()
#Stands for "combine" or "concatenate" depending on who you ask
z <- c(1.1,9,3.14)

#Arithmetic operates on vectors element wise
3*z+3
#Common arithmetic: sqrt(), abs(), ^ for power

#If we perform arithmetic with two vectors, R will compute it element-wise
#If one is shorter than the other, R will "recycle" the shorter one as needed
c(1,2,3,4) + c(0,10)


#Get help with ? before function name, without parentheses
?c

