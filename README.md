<<<<<<< HEAD
# Getting_and_Cleaning_data_CourseProject

*REPO created in order to full-fill the course project assignment*

Follow the instructions of the script here in the README file (at the Project Tasks and bottom script) and in the run_analysis.R file comments

###Information about the Project

*The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.* 

*The goal is to prepare tidy data that can be used for later analysis.* 

*You will be graded by your peers on a series of yes/no questions related to the project.*

* You will be required to submit:* 

*1) a tidy data set as described below,*

*2) a link to a Github repository with your script for performing the analysis, and* 

*3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.*  

#Project Tasks

The tasks are described here, at the bottom with the commented code, and in the file run_analysis.R, in order to everyone follows what the code does

**Here are the data for the project:** 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

*You should create one R script called run_analysis.R that does the following.* 

First, set working directory, load libraries

* 1 Merges the training and the test sets to create one data set.*

Loads the data separately (Test and Train), combine the data for each set

Give the names to the columns/variables

Combine together both sets

* 2 Extracts only the measurements on the mean and standard deviation for each measurement. *

Creates a Logical vector where it is possible to check for the values with ID | mean | std

subset the data based on the previous logical vector

* 3 Uses descriptive activity names to name the activities in the data set*

Get the original names of the data set

* 4 Appropriately labels the data set with descriptive variable names. *

rename/substitute the column/variable labels based on identified patterns 

* 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.*

In order to get a tidy data

*Each variable forms a column.*

*Each observation forms a row.*

*Each type of observational unit forms a table.*

The observational unit will be activity

Then aggregate the information by activity type and then by subject

Export the data set to working directory

#The Script

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//// Coursera Getting and Cleaning Data Course Project
//// Jorge Antunes
//// 2015-06-18

// runAnalysis.r File Description:

// This script will perform the following steps on the UCI HAR Dataset downloaded from 
// https:////d396qusza40orc.cloudfront.net//getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
// 1. Merge the training and the test sets to create one data set.
// 2. Extract only the measurements on the mean and standard deviation for each measurement. 
// 3. Use descriptive activity names to name the activities in the data set
// 4. Appropriately label the data set with descriptive activity names. 
// 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Clean up workspace

rm(list=ls())

library(dplyr)

// 1. Merge the training and the test sets to create one data set.

//set working directory to the location where the UCI HAR Dataset was unzipped

setwd("C://Users//Jorge//Google Drive//Jorge//DataScience_Specialization//Get_and_Clean_Data//course_project//UCI HAR Dataset");

// Read in the data from files

//features is where we can find the variables

features     = read.table('.//features.txt',header=FALSE); //imports features.txt

//activityType (e.g Walking)     

activityType = read.table('.//activity_labels.txt',header=FALSE); //imports activity_labels.txt

subjectTrain = read.table('.//train//subject_train.txt',header=FALSE); //imports subject_train.txt

xTrain       = read.table('.//train//x_train.txt',header=FALSE); //imports x_train.txt

yTrain       = read.table('.//train//y_train.txt',header=FALSE); //imports y_train.txt

// Assigin column names to the data imported above

colnames(activityType)  = c('activityId','activityType');

//who

colnames(subjectTrain)  = "subjectId";

// features_info.txt: Line 59 "The complete list of variables of each feature vector is available in 'features.txt'"

//extensive data recorded in 'xTrain'

colnames(xTrain)        = features[,2];

//activity id

colnames(yTrain)        = "activityId";

// cCreate the final training set by merging yTrain, subjectTrain, and xTrain

trainingData = cbind(yTrain,subjectTrain,xTrain);

// Read in the test data

//who

subjectTest = read.table('.//test//subject_test.txt',header=FALSE); //imports subject_test.txt

xTest       = read.table('.//test//x_test.txt',header=FALSE); //imports x_test.txt

//activity id

yTest       = read.table('.//test//y_test.txt',header=FALSE); //imports y_test.txt

// Assign column names to the test data imported above

//

colnames(subjectTest) = "subjectId";

colnames(xTest)       = features[,2]; 

colnames(yTest)       = "activityId";


// Create the final test set by merging the xTest, yTest and subjectTest data

testData = cbind(yTest,subjectTest,xTest);

// GOAL1. Merge the training and the test sets to create one data set.

// Combine training and test data to create a final data set

finalData = rbind(trainingData,testData);

// Create a vector for the column names from the finalData, which will be used

// to select the desired mean() & stddev() columns

colNames  = colnames(finalData); 

// 2. Extract only the measurements on the mean and standard deviation for each measurement. 

// Create a logicalVector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others

//grepl -> searches for the pattern

logicalVector = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

// Subset finalData table based on the logicalVector to keep only desired columns

finalData = finalData[logicalVector==TRUE];

// 3. Use descriptive activity names to name the activities in the data set

// Merge the finalData set with the acitivityType table to include descriptive activity names

finalData = merge(finalData,activityType,by='activityId',all.x=TRUE);

// Updating the colNames vector to include the new column names after merge

colNames  = colnames(finalData); 

// 4. Appropriately label the data set with descriptive activity names. 

// Cleaning up the variable names

for (i in 1:length(colNames)) 
{
        colNames[i] = gsub("\\()","",colNames[i])
        colNames[i] = gsub("-std$","StdDev",colNames[i])
        colNames[i] = gsub("-mean","Mean",colNames[i])
        colNames[i] = gsub("^(t)","time",colNames[i])
        colNames[i] = gsub("^(f)","freq",colNames[i])
        colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};

// Reassigning the new descriptive column names to the finalData set

colnames(finalData) = colNames;

// 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

// Create a new table, finalDataNoActivityType without the activityType column

finalDataNoActivityType  = finalData[,names(finalData) != 'activityType'];

// Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject

tidyData    = aggregate(finalDataNoActivityType[,names(finalDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=finalDataNoActivityType$activityId,subjectId = finalDataNoActivityType$subjectId),mean);

// Merging the tidyData with activityType to include descriptive acitvity names

tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

// Export the tidyData set 

write.table(tidyData, './/tidyData.txt',row.names=FALSE,sep='\t');
=======
# cp1
>>>>>>> d123f5da23f952e3ef7a0ac9535caa8c9180f58b
