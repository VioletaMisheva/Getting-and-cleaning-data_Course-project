#set the working directory to the one where data unzipped and saved
setwd("C:/Users/user/Dropbox/coursera/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
xtest<-read.table("X_test.txt", header=FALSE)
ytest<-read.table("Y_test.txt", header=FALSE)
subject_test<-read.table("subject_test.txt", header=FALSE)

setwd("C:/Users/user/Dropbox/coursera/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset")
activity<-read.table("activity_labels.txt", header=FALSE)
features<-read.table("features.txt", header=FALSE)

#renaming the columns
colnames(activity)=c("activityID", "activity_type")
colnames(subject_test)="subjectId"
colnames(xtest)=features[,2]
colnames(ytest)="activityID"

#binding the test data together
testdata<-cbind(xtest, ytest,subject_test)

#Similarly, read files from the Train data and combine them
setwd("C:/Users/user/Dropbox/coursera/Getting and cleaning data/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
xtrain<-read.table("X_train.txt", header=FALSE)
ytrain<-read.table("y_train.txt", header=FALSE)
subject_train<-read.table("subject_train.txt", header=FALSE)

#renaming the columns for the train data
colnames(subject_train)="subjectId"
colnames(xtrain)=features[,2]
colnames(ytrain)="activityID"

#binding the train data together
traindata<-cbind(xtrain,ytrain,subject_train)

#binding all data together
combined<-rbind(testdata, traindata)
 

#2. To extract only the measurements of the mean and sd of each measurement
combined_mean_std<-combined[, grepl("mean|std|subjectId|activityID", names(combined))]

#3. Use descriptive activity names to name the activities in the data set
#In this case, simply merge the combined data set (with means and sd, from step 2) 
#and merge it with the activity type

merged<-merge(combined_mean_std, activity, by="activityID")
 
 

#4.Appropriately labels data using label names
#from feature_info.txt, we are given the following shortcuts:
#tBodyAcc-XYZ and tGravityAcc-XYZ are body and gravity acceleration signals
#tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ are bory acceleration jerk and gyro signals
# t refers to time, f to frequency domain signals, Mag to magnitude

#removes parentheses from names
names(combined_mean_std)<-gsub("\\(|\\)", "", names(combined_mean_std))
#make clearer labels
names(combined_mean_std)<-gsub("Acc","Acceleration", names(combined_mean_std))
names(combined_mean_std)<-gsub("-mean", "Mean",names(combined_mean_std))
names(combined_mean_std)<-gsub("^t", "time", names(combined_mean_std))
names(combined_mean_std)<-gsub("^f", "frequency", names(combined_mean_std))
names(combined_mean_std)<-gsub(".std", "Stand dev", names(combined_mean_std))
names(combined_mean_std)<-gsub("Mag", "Magnitude", names(combined_mean_std))

#5.
library(plyr)
newdata<-ddply(combined_mean_std, .(subjectId, activityID), numcolwise(mean)) 

write.table(newdata, file="tidydata.txt", row.names=FALSE)