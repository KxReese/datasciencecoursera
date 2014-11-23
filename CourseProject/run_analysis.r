## The run_analysis script combines, tidies and summarizes data collected
## from Samsung Galaxy S accelerometer and gyroscope readings. The full dataset
## is part of the UCI Machine Learning Repository and can be found at this link:
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

## 	Required R packages for script 
	require(data.table)

## Reading in all the data files - note: filepaths declared in Windows OS format
	## Read features  and activity label files
	features <- read.table("UCI HAR Dataset/features.txt", header=F)
	act_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header=F)
	
	## Read training files
	train_sub <- read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
	train_x <- read.table("UCI HAR Dataset/train/x_train.txt", header=F)
	train_y <- read.table("UCI HAR Dataset/train/y_train.txt", header=F)

	## Read test files
	test_sub <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
	test_x <- read.table("UCI HAR Dataset/test/x_test.txt", header=F)
	test_y <- read.table("UCI HAR Dataset/test/y_test.txt", header=F)

## Combining the separate files into one dataset	
	## Column binding the training data then the test data
	train_df <- cbind(train_sub, train_y, train_x)
	test_df <- cbind(test_sub, test_y, test_x)

	## Combining the training data and the test data and labelling the columns
	full_df <- rbind(train_df, test_df)
	colnames(full_df) <- c("SubjectID", "Activity", t(features)[2,])

## Isolating only the needed data	
	## Identify the mean and standard deviation columns and pull them from the dataset
	meanstdcols <- c(TRUE, TRUE, grepl("-std\\(\\)|-mean\\(\\)", features[,2]))
	full_df_subset <- full_df[,meanstdcols]
	
## Cleaning up the dataset
	## Cleaning up the variable names with substitutions
	variable_names <- colnames(full_df_subset)
	variable_names<-sub("^t","TimeDomain",variable_names)
	variable_names<-sub("^f","FreqDomain",variable_names)
	variable_names<-sub("Acc","Accelerometer",variable_names)
	variable_names<-sub("Gyro","Gyroscope",variable_names)
	variable_names<-sub("Mag","Magnitude",variable_names)
	variable_names<-sub("\\(\\)-","on",variable_names)
	variable_names<-sub("BodyBody","Body",variable_names)
	variable_names<-sub("-mean|-mean\\(\\)","Mean",variable_names)
	variable_names<-sub("-std|-std\\(\\)","STD",variable_names)
	
	## Applying cleaned up names as column names
	colnames(full_df_subset) <- variable_names
	
	## Replacing activity numbers with descriptions
	full_df_subset$Activity <- factor(full_df_subset$Activity)
	levels(full_df_subset$Activity) <- act_labels[,2]
	
## Create summary table and write to TXT file
	## Convert the data frame to a data table in order to utilize the data.table package
	full_table <- setDT(full_df_subset)
	
	## Create table of summarized data containing the mean for each variable by activity and subject
	tidydata <- full_table[,lapply(.SD,mean),by=list(Activity,SubjectID)]
	
	## Write summary table to TXT file
	write.table(tidydata, "tidydata.txt", row.name=FALSE)
	
	
