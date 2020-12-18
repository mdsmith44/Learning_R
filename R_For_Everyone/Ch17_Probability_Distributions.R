##### Since R is statistical programming language, it
#has all the prob and stats goodness built in


#Get draws from normal
rnorm(10)
rnorm(10,mean=100,sd=20)

#Find prob density of norm
dnorm(c(-1,0,1))

#Use pnorm to get CDF probability
pnorm(c(-1,0,1))

#Plot 3000 points for fun
randNorm <- rnorm(30000)
randDensity <- dnorm(randNorm)
library(ggplot2)
ggplot(data.frame(x=randNorm,y=randDensity)) +
  aes(x=x,y=y) +
  geom_point() +
  labs(x="Random Normal",y='Density')


#qnorm gives inverse CDF 
qnorm(c(.1,.5,.9))


#Other distributions follow similar structure,
# rdist for random draws
# ddist for density
# pdist for CDF probability
# qdist for inverse CDF

#we have rbinom, rpois, 

#binomial
rbinom(n=1,size=10,prob=.4)
