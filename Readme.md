---
title: "Readme.md"
output: html_document
---
## Problem Statement
```
You should create one R script called run_analysis.R that does the following.

  1. Merges the training and the test sets to create one data set.
  2. Extracts only the measurements on the mean and standard deviation for each measurement. 
  3. Uses descriptive activity names to name the activities in the data set
  4. Appropriately labels the data set with descriptive variable names. 
  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```

*__Readme.md__* file lists the details of resources present in this directory

* ## run_analysis.R
This is a R file that addresses the problem statement. It has the logic to read in the input zip file and produce the expected tidy data file.
A lot of pointers were picked up from the forum discussion, with a special thanks to David Hood for this [post](https://class.coursera.org/getdata-013/forum/thread?thread_id=31). 
    
    ### Steps in the processing
    1. Read in the zip file and unzip it in the working directory
    2. Read in the training related files. Here there are three files: first with the measurement data, second subject and the third is activity. The column names of the subject and activity dataframes are set to "subject" and "activity" after the data is read in.
    3. The columns are bound together to create a dataframe which has measurement data, subject, activity using cbind
    4. Steps 2 and 3 are repeated for test related files
    5. The output of 3 and 4 - training and test files - are brought together so as to get all the rows using rbind. This data is further referred to as a __*alldata*__
    6. The data at step 5 does not have readable/interpretable column names. The actual column names are in features.txt. This step reads in the feature.txt as column names, appends "subject" and "activity" 
    7. The column names from step6 are used to create a logical vector to get selected columns - columns that have either of the word : *"mean", "std", "subject" or "activity"* in them. When this is paired with the dataframe, we get the __*alldata*__ such that only selected columns pertaining to mean and std deviation are fetched. This is as per the requirement #2 in the problem statement.
    8. Next a function is called to put in appropriate names for the __*alldata*__ columns. This function can be made as fancy as required to give better names for the data columns. As of now it does few transformations such that the column names are less cyrptic
    9. As of this step, the __*alldata*__ has the activity as codes 1, 2...6. Each of these codes represents an activity. The activity id to description look up is read from activity_labels.txt. Merge is used to replace the id with the activity name. Any extra column is removed
    10. Finally the data is grouped by activity and subject and mean is calculated using the pipe operator from *dplyr* package.
       The input data is wide data. The variables required for the output are subject, activity and bunch of measurements. However, the measurements (the various mean, std measurements) are given as columns instead of rows. So the program uses gather() function from tidyr package to move the columns into observations and hence rows. This satisfies the two main important requirements of tidy data
        * Each column is a variable
        * Each row is an observation
    
    ### Assumptions
    1. Should the file download be part of the script. One important observation from the course lectures is that the in getting data and cleaning is that the work should be reproducible and repeatable. So I chose to write the script such that there is a check for the required directories in the working directory and if not present, download and unzip the file.
    2. The directory __*Inertial Signals*__ and resources under it are not used.

* ## CodeBook.md
This markdown file lists details of output data and how it should be read

* ## tidyoutdata.txt
This is the txt file that is produced by the R script and written to the file using write.table() with row.name=FALSE