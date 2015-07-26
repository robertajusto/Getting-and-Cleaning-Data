
setwd("~/Coursera/getdata-projectfiles-UCI HAR Dataset/UCI HAR Dataset")

library("plyr")

#read train files
data_x_train <- read.table("train/X_train.txt")
data_y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

#read test files
data_x_test <- read.table("test/X_test.txt")
data_y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

str(data_x_train)
str(data_y_train)
str(subject_train)
str(data_x_test)
str(data_y_test)
str(subject_test)


#STEP 1. Merges the training and the test sets to create one data set.

# Merge X data

data_X_total<- rbind(data_x_train, data_x_test)
str(data_X_total)

# Merge Y data

data_Y_total<- rbind(data_y_train, data_y_test)
str(data_Y_total)

# Merge subject data

data_subject_total<- rbind(subject_train, subject_test)
str(data_subject_total)


# STEP 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Read Features data

features <- read.table("features.txt")

str(features)
head(features)

#correct names for the X data
names(data_X_total)<- features [,2]
head(data_X_total)

# extract only measures with mean or std

data_x_ok <- data_X_total [,grep("-(mean|std)\\(\\)", colnames(data_X_total))]


# STEP 3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("activity_labels.txt")

data_Y_total_ok<- merge(data_Y_total, activity_labels, by.x="V1", by.y="V1", all=TRUE )

colnames(data_Y_total_ok)<-c("number", "activity")
  

#STEP 4. Appropriately labels the data set with descriptive variable names. 

#column name
names(data_subject_total) <- "subject"

#merge all data

total_data <- cbind(data_x_ok, data_Y_total_ok, data_subject_total)


#STEP 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


tidy_data <- ddply(total_data, .(subject, activity), function(x) colMeans(x[, 1:66]))


write.table(tidy_data, "tidy.txt", row.name=FALSE)
