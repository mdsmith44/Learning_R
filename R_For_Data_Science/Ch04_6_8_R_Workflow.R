#Some useful RStudio shortcuts and hints


#To see previous commands that started the same way,
#hit CTRL-UPARROW
my_var <- 4

#To see output when new variable is assigned, wrap in ()
(y <- seq(1,10,length.out=5))
#Same as 
#y <- seq(...)
#y


#Use CTRL-Shift-N for new script

#Run current command with CTRL-ENTER

#Run entire script with CTR-Alt-R
#See Code-Run menu for more


#When sharing code, good practive to include library()
#up top.  Bad practice to use install.packages() or
#setwd().

#To "restart and Run All" can use CTRL-SHIFT-F10
#to restart RStudio, then CTRL-Shift-S to run all of 
#current Script.

#With paths and directories, R can use Mac/Linux way (using
#forward slashes /) or Windows way (using back slashes \)
# Though the \ may be represented as \\ since single \ is 
#the special escape character.

#May need this for later:
library(tidyverse)

ggplot(diamonds, aes(carat, price)) + 
  geom_hex()
ggsave("diamonds.pdf")
write_csv(diamonds, "diamonds.csv")

#Vignettes
#run vignette(package) to get useful guide