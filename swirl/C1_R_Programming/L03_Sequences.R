#L3 Sequences

#Get sequence of numbers with start:end
#Resutling sequence is a vector, and includes start and end values
a <- 1:20

#Can also start from rational number, or even go backwards

#To get help for : operator, need to enclose it in backticks or quotes
?":"

#To get more control over a sequence, use seq()
#E.g. we can specify increment or length
seq(1,20)
seq(0,10,by=0.5)
my_seq <- seq(5,10,length=30)
length(my_seq)

#Can create sequence that enumerates another sequence with seq_along function
#or with along.with option of seq() function.
seq(along.with=my_seq)
seq_along(my_seq)

#Can use rep() to repeat value many times
rep(0,times=40)
#Repeate a vector many times
rep(c(0,1,2),times=10) #returns singel vector c(0,1,2,0,1,2,...)
#Can also repeate first entry, then repeate 2nd, etc
rep(c(0,1,2),each=10)
