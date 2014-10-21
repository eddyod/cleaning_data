library(dplyr)
library(reshape)
setwd("~/programming/cleaning_data/project")
# columns of data from files
#column1 = id person subject_train.txt
#column2 = activity y_train.txt
#columns3 -> end = measurements, X_train.txt
##### info from the README
#You should create one R script called run_analysis.R that does the following. 
##1. Merges the training and the test sets to create one data set.
##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
##3. Uses descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names. 
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



##### my info
# put in subject as column in both test and train data
# put in activity as column in both test and train data
# append test data to train data
# drop all columns that don't have mean or standard deviation in column title
# rename activity codes to labels
# get mean and std of all data columns
# use write.table

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
variable_names <- read.table("~/programming/cleaning_data/project_data/features2.txt")
names(variable_names) <- c("Var_Name")
## assign var names to X_train
variable_name_vector <- variable_names[,1]
variable_names <- gsub("\\(|\\)|\\-|\\,","", variable_name_vector, ignore.case=TRUE)
variable_names <- c(variable_names, "Subject", "Activity")
## activity labels
activity_labels <- read.table("~/programming/cleaning_data/project_data/activity_labels.txt")
names(activity_labels) <- c("Activity_Id", "Activity")
activity_label_vector <- activity_labels[,2]
newlabels <- factor(activity_label_vector)
# get training and testing data
X_train <- read.table("~/programming/cleaning_data/project_data/train/X_train.txt")
X_train_subject <- read.table("~/programming/cleaning_data/project_data/train/subject_train.txt")
X_train_activity <- read.table("~/programming/cleaning_data/project_data/train/y_train.txt")
# test data
X_test <- read.table("~/programming/cleaning_data/project_data/test/X_test.txt")
X_test_subject <- read.table("~/programming/cleaning_data/project_data/test/subject_test.txt")
X_test_activity <- read.table("~/programming/cleaning_data/project_data/test/y_test.txt")
# Add subject columns to both X_train and X_test
X_train <- cbind(X_train, X_train_subject, X_train_activity)
X_test <- cbind(X_test, X_test_subject, X_test_activity)
# merge data
merged <- rbind(X_train, X_test)
# give vars names
names(merged) <- variable_names
# get relevant columns
named_merged <- select(merged, contains("Subject"), contains("Activity"), contains("mean"), contains("std"))
# recode activity column
named_merged$Activity <- newlabels[ match(named_merged$Activity, activity_labels$Activity_Id)]
# now melt by groups
named_merged_melted <- melt(named_merged, id.vars = c("Subject", "Activity"))
results <- cast(Subject + variable ~ Activity, data = named_merged_melted, fun = mean)

##### last step
write.table(results, file="result_narrow.txt", sep=",", row.names=FALSE)

