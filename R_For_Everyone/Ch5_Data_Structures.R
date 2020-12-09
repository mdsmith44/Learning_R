##### R has several data structures which provide more
#functionality that homogeneous vectors.  These include:
# data.frame (e.g. spreadsheet)
# matrix (e.g. all numbers)
# list (sequence of various object types)
# array 

##### data.frame
#data.frame (df) is collection of vectors
#each column/vector holds one data type
#columns of data.frame can hold different types

#Several ways to constuct a df.  Here's one
x <- 10:1
y <- -4:5
q <- c("Hockey", "Football", "Baseball", "Curling", 
       "Rugby", "Lacrosse", "Basketball", "Tennis", 
       "Cricket", "Soccer")
df <- data.frame(x,y,q)
df
#This creates 10x3 df

#We can give names to columns
df <- data.frame(First=x,Second=y,Sport=q)
df
#Note that we don't need to use str for col names,
#though we could and it would work fine
df <- data.frame('First'=x,Second=y,Sport=q)
df

#Get size of df
nrow(df)
ncol(df)
dim(df)
length(df) #returns 3, same as ncol

#Get or set column names with names
names(df) #returns character vector
names(df) <- c("One",'two','three')
df
#Set names back 
names(df) <- c("First",'Second','Sport')

#Get or set rownames
rownames(df) #returns character vector
#Use list comprehension to get list
install.packages("comprehenr")
library(comprehenr)
rownames(df) <- to_vec(for(x in 1:nrow(df)) toString(3*x))
df
#Reset rownamses to null to go back to default
rownames(df) <- NULL
rownames(df)

#View head or tail
head(df)
head(df,2)
tail(df)

#Access individual column with $
df$Sport
df$First
#Note that Sport will return a Factor vector
#whereas df$First returns numerical vector
class(df$Sport)

#Access elements or sections by index
#Get single element
df[3,2]
#Get multiple columns
df[3,2:3]
df[2,c(1,3)]
df[2:3,2]
#Can use numerical index or names
df[2,c("First",'Sport')]
#Leave oen entry blank to get all elements
df[,2] #all of the 2nd column
df[3,] #All of the 3rd row

#Note that there are many ways to call single col
#though may get different resulting data structure
df$Sport #a factor vector
df[,"Sport"] #a factor vector
#use signle bracket to get df w 1 col
df["Sport"] #data.frame w 1 column
#Use double bracket to get just that element
#In this case, just a factor vector
df[["Sport"]] #factor vector. 
#Double bracket grabs just the element
#in this case, 
df[3] #data.frame w 1 column
#Can get single col df with drop=FALSE
df[,"Sport",drop=FALSE]

##### Lists
#A list contains objects of various types
#Each element can be any R object (df, list, whatever)

#3 element list
list1 <- list(1,2,3)
#1 element list, where first element is a num vector
list(c(1,2,3))


#Access list of 1 element with single bracket
list1[2]
#Access just the element itself with double brack
list1[[2]]

#Access range of entries
list1[1:2]

#Negative index says what values to IGNORE
list1[-1]
list1[-c(1,2)]

#lists can have names for their eleemnts
list1 <- list(1,2,3)
names(list1)
names(list1) <- c('a','b','c')
list1
#Can access with eitehr $a or ['a']
list1$a
list1['a'] #returns a list of signle element
list1[['a']] #returns just the element
#or can assign durign list creation
list('a'=1,'b'=2)

#Create empty list 
emptyList <- vector(mode="list", length=4)
emptyList

#Can then fill it by specifying the index
emptyList[1] <- 1
emptyList
emptyList[[2]] <- 2
emptyList

#Can append to list with index that doesn't exist
list1
list1[[4]]=4
list1
#Can also reassign element
list1[[2]] <- 10
list1
#seems to also work with single bracket
list1[2] <- 20
list1

##### Matrix
#Matrix is 2-d data structure that holds 1 data type
#usually numbers
A <- matrix(1:10,nrow=5)
A
B <- matrix(21:30,nrow=5)
B

#Arithmetic by default is element-wise
A*B

#We can do matrix mult with %*%
#We also take advantage of transpose
A %*% t(B)

#Get dimensions same way as with data.frames
c(nrow(A),ncol(A),dim(A))

#matrix can also have col and row names
#Get or set names
colnames(A)
rownames(A)
colnames(A) <- LETTERS[1:2]
A
colnames(A)
#the names(A) will give a name to each element
names(A) <- letters[1:10]
A
#Now in theory we could access an element by its name
A['a']

#Access by numerical row-col index
A[1,1]

##### Arrays
#Arrays are n-dimensional vectors
a <- array(1:12,dim=c(2,3,2))
a
a[,,2]
