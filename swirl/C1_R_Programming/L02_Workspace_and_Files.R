#R provides useful commands to navigate and manage files

#get current working directory
getwd()

#List all objects, including files, directories, and variables
ls()

#list only the FILES in current working directory
list.files()
#Can also do this with dir()
dir()
?list.files

#See arguments a function takes with args()
args(list.files)

#Create directory with dir.create()
dir.create('testdir')

#Set working directory with setwd()
setwd('testdir')

#Create file with file.create()
file.create('mytest.R')
list.files()

#Check if file exists
file.exists('mytest.R')

#Get info on file with file.info()
file.info('mytest.R')
#Grab specific field with $
file.info("mytest.R")$mode

#Rename file with file.rename()
file.rename('mytest.R','mytest2.R')

#Make a copy of file with file.copy()
file.copy('mytest2.R','mytest3.R')

#Get relative path to file with file.path()
file.path('mytest3.R')
file.path('folder1','folder2')

#Can combine file.path with dir.create to create directory and subdir at once
dir.create(file.path('testdir2','testdir3'),recursive=TRUE)

setwd(old.dir)
