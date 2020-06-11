library(dplyr)

# read data
X_train <- read.table("X_train.txt")
X_test <- read.table("X_test.txt")
Y_train <- read.table("Y_train.txt")
Y_test <- read.table("Y_test.txt")
sub_train <- read.table("subject_train.txt")
sub_test <- read.table("subject_test.txt")
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

# Merges the training and the test sets to create one data set.
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
sub_all <- rbind(sub_train, sub_test)

# Extracts only the measurements on the mean and standard deviation for each measurement
features_selected <- features[grep("mean|std",features[,2]),]
X <- X[,features_selected[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(Y) <- "label"
Y$activity <- factor(Y$label, labels = as.character(activity_labels[,2]))
activity <- Y$activity

# Appropriately labels the data set with descriptive variable names
colnames(X) <- features[features_selected[,1],2]

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(sub_all) <- "subject"
#subject=sub_all$subject
combine <- cbind(X, activity, sub_all)
temp <- group_by(combine,activity, subject)
final <- summarize_all(temp,funs(mean))

# write final tidy data
write.table(final, file = "tidy_data.txt", row.names = FALSE, col.names = TRUE)