#We first Install packages, and then Load them
#Can think of this as installing program to computer, 
#and then actually running it

#Install, name in single or double quotes
install.packages("ggplot2")

#Load, name without any quotes
library(ggplot2)

#Can also laod packages with R Studio interface

#Update all installed packages
update.packages()

#Can unload (undo library() command) with detach
#E.g. package might not play well with another
detach("package:ggplot2", unload=TRUE)

#Can uninstall
remove.packages("ggplot2")

#Get current R version 
version

#Get more sessionInfo
sessionInfo()


#Get help on packages
help(package="ggplot2")

#See some vignettes of functionality
browseVignettes("ggplot2")
