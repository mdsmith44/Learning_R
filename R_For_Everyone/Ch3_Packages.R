#The collection of user generated packages is one of
#the main reasons for R's popularity.  There are 
#currently over 10,000 packages on CRAN, the
#Comprehensive R Archive Network.

#Can install packages from Packages tab GUI in lower right
#Or can install with following commands
install.packages("coefplot")

#To use a package, we have to LOAD it 
#Most common way to load is with library()
library(coefplot)

#Can also load a package with require
#require will return TRUE if loading succeeds,
#or FALSE ow, which can be useful.  library() will
#return error, but library main one used

#Notes:
# Installing package will also install dependencies
# We include quotes to install, no quotes to load

#There is also a movement to install packages from GitHub
#with devtools
#library(devtools)
#install_github(repo="coefplot/jaredlander")

#Can also install packages from local file
#install.packages("coefplot_1.1.7.zip")

#Can also unload a package
#detach("package:coefplot")

#Note that two packages can have same function name
#Default is to use most recently loaded
#To override (both arm and coefplot packages
#have coefplot function):
#arm::coefplot(...)

#Can uninstall packages. 
#Rare but could be necessary to avoid confliction
#remove.packages(...)

#CRAN Task Views has curated list of useful packages
#http://cran.r-project.org/web/views/

#Work please????