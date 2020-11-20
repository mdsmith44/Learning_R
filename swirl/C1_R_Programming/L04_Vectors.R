#Two types of Vectors:
# Atomic vectors contain single data type (numeric, logical, character, integer, or complex)
# Lists can contain multiple data types

#We've already seen numeric vectors, e.g. with : operator or seq() or rep() functions
num_vect <- c(0.5, 55, -10,6)
class(num_vect)
#Note this returns "integer" in that integer is the atomic data type

#Lets look at logical vectors, where each element is TRUE or FALSE
tf <- num_vect < 1
tf

#Character vector, can be single or double quotes
my_char <- c("My","name",'is')
my_char

#we can use paste() function to combine character vectors
paste(my_char,collapse=" ")

my_name <- c(my_char,'Matt')
my_name
paste(my_name,collapse=" ")

#Can also use paste to join two character vectors
paste("Hello",'world!',sep=" ")

#Note that paste() takes a variable number of vectors (possible of length 1)
#paste returns a char vector where n'th element is combination of n'th element of each input vector
paste(1:3,c('X','Y','Z'))
#Returns c('1 X','2 Y','3 Z')
#Use sep="" to specify separation between elements
paste(1:3,c('X','Y','Z'),sep="")
#Use collapse to collapse/join resulting vector to single character
paste(1:3,c('X','Y','Z'),sep="",collapse="_")

#paste will recycle if vectors are different length
paste(LETTERS,1:4,sep="-")
#Should give c("A-1",'B-2",...)