# run_analysis script

The run_analysis script combines, tidies and summarizes data collected
from Samsung Galaxy S accelerometer and gyroscope readings. The full dataset
is part of the UCI Machine Learning Repository and can be found at this link: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
 
The data.table package is required for this script to work properly. Additionally,
the filepaths have been provided in the Windows operating system format so using this
script under other operating systems may require some modification.

This script operates in four phases before exporting the summarized data.
* Reading the data files
* Combining the data frames
* Tidying the data
* Summarizing the data

## Reading the data

Assuming the data files are in one's working directory and since all files are TXT files, 
the read.table function is used to read in all training and test files.

## Combining the data frames

The subject and activity columns are bound to the variable measures using cbind
for the training and test files separately. The training set and test set are 
then combined using rbind. 

Once all the data has been combined the relevant columns are selected and
subsetted to isolate the measurements pertaining to the mean or standard deviation.  

## Tidying the data 

First the measurement variables are given more descriptive names using the sub
function. 

* Example: tBodyGyroJerk-mean()-Z became TimeDomainBodyGyroscopeJerkMeanonZ 

Then the activity numbers are replaced with activity descriptions.

## Summarizing the data

The data.table package is used in conjunction with the lapply function to aggregate the 
mean of each measurement variable grouped the subject and the activity being performed.

## Finally, some tidy and summarized data!

The write.table function is used to output the summarized data to a TXT file in the 
working directory.  