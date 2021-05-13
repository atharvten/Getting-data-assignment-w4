#Our goal in this code is to take a downloaded data file
# that has fitness device data, and organise it into 
# a tidy data tabular form with various activities
# So lets get on with in a step by step manner 

#_________________________________

#dplyr is a grammar of data manipulation, providing a consistent
#set of verbs that help you solve the most common data manipulation challenges
library(dplyr)

# In the following code module we read the data
# that is in the "train" file
#This file is downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
# it has necessary data in a zip folder
#save this in same directory as your project
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# read test data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#After extraction, we have many files
#this code section will read from data section
variable_names <- read.table("./UCI HAR Dataset/features.txt")

# Here we read different activities that were detected
#by the smart device like walking, jumping, etc.
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#What we do here basically is we combine or "bind" the 
#training and testing data sets, by using command rbind
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

# Mean and standard deviation according to the various parameters
#are calculated/ assigned here in this part
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

# We use activity names in a descriptive format to assign labels 
# to them using as.character string function form
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

#Data set if labelled here once above line s completed
colnames(X_total) <- variable_names[selected_var[,1],2]

# A tidy data set is made here with average of each activity 
# in a subject wise format for better representation.
# This tidy data set is then available in a text form
#that is pushed into the Downloaded folder as .txt
colnames(Sub_total) <- "subject"  #name of column as subject
total <- cbind(X_total, activitylabel, Sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)

#In this way the supplied fitness device data is properly
# arranged and represented in a tidy data table format