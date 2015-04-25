##------------------------------------------------------------------------------------------------------##
# 
#  Getting and Cleaning Data Course Project
#
# Problem Statement:
#   You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activitylabels in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
##------------------------------------------------------------------------------------------------------##
##------------------------------------------------------------------------------------------------------##
# Assumptions
# 1. Inertial Signals directory under the train and test directories is not used in this script
# 2. Zip file is downloaded, unzipped and then used in this script. One requirement of the 
#    'getting and cleaning data' part was that the process be reproducible and repeatable
##------------------------------------------------------------------------------------------------------##

##------------------------------------------------------------------------------------------------------##
################################### Beginning of the run_analysis.R script  ############################
##------------------------------------------------------------------------------------------------------##

library(tidyr)
library(dplyr)

##------------------------------------------------------------------------------------------------------##
# function debugtidydata used to display intermediate object dimensions
# this was used for debugging and testing whether the tidy data is as expected
# in one of the forums the tidy data dimension in the long form was suppose to be:
# 'the long form in normally 4 columns and 180 * (the number of features you kept) rows.'
##------------------------------------------------------------------------------------------------------##
debugtidydata <- function(){
  cat("\ntraining data dimensions: ", dim(traindata), " test data dimensions: ", dim(testdata))
  cat("\ntraining and test data combined, dimensions:", dim(data))
  cat("\nnumber of columns after adding 'subject' and 'activity': ", length(allcolnnames))
  cat("\nnumber of columns after filtering on 'mean' and 'std': ", ncol(selecteddata))
  cat("\n number of columns other than subject and activity (selected features) :" ,(ncol(selecteddata)-2))
  cat("\n total tidy dimensions as per calculations should be, rows =",((ncol(selecteddata)-2)*180), " columns = 4")
  cat ("\n actual tidy data dimensions: ", dim(tidydata))
}
##------------------------------------------------------------------------------------------------------##
# Download the zip file and get the files in the required directory
##------------------------------------------------------------------------------------------------------##
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("UCI HAR Dataset")) {
  if (!file.exists("download")) {
    dir.create("download")
  }
  download.file(fileUrl, destfile="download/dataset.zip", method="curl")
  unzip("download/dataset.zip", exdir="./")
}

##------------------------------------------------------------------------------------------------------##
# Combine the training and test sets to create one homogenous data set to work with 
# for each set, read the three files using read.table and then combine them using cbind
# after each set is built, combine them for all data rows using rbind
##------------------------------------------------------------------------------------------------------##
trainx <- read.table("UCI HAR Dataset//train/X_train.txt")
trainsubj <- read.table("UCI HAR Dataset//train/subject_train.txt")
names(trainsubj) <- "subject" ## change the column name to subject
trainy <- read.table("UCI HAR Dataset/train//y_train.txt")
names(trainy) <- "activity" ## change the column name to activity
traindata <- cbind(trainx, trainsubj, trainy)

# combine all the test data columns into the training data
testx <- read.table("UCI HAR Dataset//test/X_test.txt")
testsubj <- read.table("UCI HAR Dataset/test/subject_test.txt")
names(testsubj) <- "subject"
testy <- read.table("UCI HAR Dataset/test//y_test.txt")
names(testy) <- "activity"
testdata <- cbind(testx, testsubj, testy)

# merge both train and test data rows using rbind
alldata <- rbind(traindata, testdata)

##------------------------------------------------------------------------------------------------------##
# Features.txt has all the column names for the data
# Get all the column names and add "subject" and "activity" to it
##------------------------------------------------------------------------------------------------------##
featurelst <- read.table("UCI HAR Dataset//features.txt")
names(featurelst) <- c("id", "name")
allcolnnames <- append(as.vector(featurelst[, "name"]), c("subject", "activity"))

##------------------------------------------------------------------------------------------------------##
# use selectedcols to get the selecteddata - data that has selected columns only
##------------------------------------------------------------------------------------------------------##
selectedcols <- grepl("mean|std|subject|activity", allcolnnames) 
selecteddata = alldata[, selectedcols]

##------------------------------------------------------------------------------------------------------##
# Modify the column names so that they are more readable
# change to lowercase, remove '-' and '()' characters, remove double words like 'bodybody' etc
# spell out tbody as timebody and fbody as freqbody
##------------------------------------------------------------------------------------------------------##
modifiedcolnames <- allcolnnames[selectedcols]
modifiedcolnames <- tolower(modifiedcolnames)
modifiedcolnames <- gsub("-", "", modifiedcolnames)
modifiedcolnames <- gsub("y$", "-y", modifiedcolnames)
modifiedcolnames <- gsub("x$", "-x", modifiedcolnames)
modifiedcolnames <- gsub("z$", "-z", modifiedcolnames)
modifiedcolnames <- gsub("activit-y", "activity", modifiedcolnames)
#modifiedcolnames <- gsub("^t", "", modifiedcolnames)
#modifiedcolnames <- gsub("^f", "", modifiedcolnames)
modifiedcolnames <- gsub("\\(\\)", "", modifiedcolnames)
modifiedcolnames <- gsub("bodybody", "body", modifiedcolnames)
modifiedcolnames <- gsub("acc", "accelerometer", modifiedcolnames)
modifiedcolnames <- gsub("tbody", "timebody", modifiedcolnames)
modifiedcolnames <- gsub("fbody", "freqbody", modifiedcolnames)
modifiedcolnames <- gsub("tgravity", "timegravity", modifiedcolnames)
modifiedcolnames <- gsub("fgravity", "freqgravity", modifiedcolnames)
##------------------------------------------------------------------------------------------------------##
# Set the tidied column names into the selecteddata
# activitylabels data frame has the activity(id) and the name read from activity_labels.txt file.
# use the merge function to replace the activity id with the lookup description from activitylabels
##------------------------------------------------------------------------------------------------------##
names(selecteddata) <- modifiedcolnames
activitylabels <- read.table("UCI HAR Dataset//activity_labels.txt", col.names=c("activity", "name"))
selecteddata <- merge(selecteddata, activitylabels, by="activity")
selecteddata <- selecteddata[, -c(1)]
selecteddata <- rename(selecteddata, activity=name)
##------------------------------------------------------------------------------------------------------##
# This step does multiple actions in one statement using the pipe operator
# The selected data is grouped by subject and activity using the group_by function
# Then mean function is run on each column to calculate the mean for the selected features
#
# The next steps takes care of the most important aspect of tidy data 
#    ---Each column is a variable
#    ---Each row is an observation
# The three main variables in this excercise are subject, activity and feature that is calculated. 
# The feature is in different columns instead of being in one column. The gather function puts the calculatedmean of each column into
# one column against the subject and activity as the key. So gather gives us an dataframe with columns as
# subject, activity, feature and calculatedmean
##------------------------------------------------------------------------------------------------------##
tidydata <- selecteddata %>% group_by(subject, activity)  %>% summarise_each(funs(mean))  %>% gather(feature, calculatedmean, -subject, -activity)
##------------------------------------------------------------------------------------------------------##
# Write the tidy data to the file as per the statement
##------------------------------------------------------------------------------------------------------##
write.table(tidydata, "tidyoutdata.txt", row.names=FALSE)

##------------------------------------------------------------------------------------------------------##
# This function can be called to see the dimensions of various R objects during the processing
##------------------------------------------------------------------------------------------------------##
#debugtidydata()

##------------------------------------------------------------------------------------------------------##
################################### End of the run_analysis.R script  ###################################
##------------------------------------------------------------------------------------------------------##

