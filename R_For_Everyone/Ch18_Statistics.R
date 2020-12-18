##### Quick rundown

#Draw samples from vector
x <- sample(x=1:100,size=100,replace=TRUE)
#Can also specify probs, even if not normalized
sample(x=1:4,size=20,replace=TRUE,
            prob = c(10,10,100,100))

#Basic summary statistics
mean(x)
sd(x)
var(x)
min(x)
max(x)
median(x)
#var and sd take Sample variance (divide by N-1)

#All of these have option to remove NAs with na.rm
#By default this is false, so if any NAs then result is NA
#Set 20 values to NA
y <- x
y[sample(x=1:100, size=20, replace=FALSE)] <- NA
y[1:20]

#Now mean will return NA unless we specify to remove NAs
mean(y) #NA
mean(y,na.rm=TRUE) #numeric

#weighted mean
grades <- c(95, 72, 87, 66)
weights <- c(1/2, 1/4, 1/8, 1/8)
mean(grades)
weighted.mean(grades,weights)

#Get all summary stats with summary
summary(x)
#This automatically removes NAs
summary(y)

#get quantiles
quantile(x,probs=c(.25,.5,.75))



##### Correlation and covariance
#Load some sample data
library(ggplot2)
head(economics)

#correlation between pce (consumption) and psavert (saving)
cor(economics$pce,economics$psavert)

#Will give all cor's when called on matrix
cor(economics[,c(2,4:6)])

# visualize with GGally, collection of useful plots built
#in ggplot2
# Note: GGally may load reshape functions that create 
#conflicts, so best to call its fxn's with GGally::func
# Although we don't want to load it (with library), we
#do need to install it
install.packages('GGally')

GGally::ggpairs(economics[, c(2, 4:6)])

#Another cool example
data(tips,package='reshape2')
GGally::ggpairs(tips)

# NA's are handled differently since we're dealing with
#multiple columns which may be NA at different places
# To specify NA behavior, specify the "use" arg
m <- c(9, 9, NA, 3, NA, 5, 8, 1, 10, 4)
n <- c(2, NA, 1, 6, 6, 4, 1, 1, 6, 7)
p <- c(8, 4, 3, 9, 10, NA, 3, NA, 9, 9)
q <- c(10, 10, 7, 8, 4, 2, 8, 5, 5, 2)
r <- c(1, 9, 7, 6, 5, 6, 2, 7, 9, 10)
# combine them together
theMat <- cbind(m, n, p, q, r)

cor(theMat,use='everything')
#'everything' means entire pair of cols must be NA free

#all.obx means every oberservation in matrix must be good
cor(theMat,use='all.obs')

#reduce down to rows with no NAs
cor(theMat,use='complete.obs')

#For each pair, just keep observartions where neither is NA
cor(theMat,use='pairwise.complete')

#Of course, correlation is not causation
#Use R package to download XKCD
install.packages('RXKCD')
library(RXKCD)
getXKCD(which="552")

#Covariance with cov, works simliar to cor
cov(theMat)
cov(theMat,use='pairwise.complete')


##### T tests
#test whether mean could be 2.5 using 2-sided t test
t.test(tips$tip,
       alternative='two.sided',
       mu=2.5)

#Use 1 sided t test to see if mean is greater than 2.5
t.test(tips$tip, alternative="greater", mu=2.50)

#t-test for 2 samples
#Depends on whether samples have same variance and
#if they are normal

#normality test
shapiro.test(tips$tip)
shapiro.test(tips$tip[tips$sex == "Female"])
#All of these fail the normality test
#inspect
ggplot(tips, aes(x=tip, fill=sex)) +
  geom_histogram(binwidth=.5, alpha=1/2)

#Since samples aren't normal, can't use F-test (var.test)
#or bartlett test (bartlett.test)

#Check if they have same variance
ansari.test(tip~sex,tips)
#variances are equal, so we can use 2-sample t test
t.test(tip ~ sex, data=tips, var.equal=TRUE)

#Can also do ANOVA to compare multiple groups
tipAnova <- aov(tip ~ day - 1, tips)
