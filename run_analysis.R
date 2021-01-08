# 1. Read the data

# test data
s_test<-read.table("subject_test.txt")
x_test<-read.table("X_test.txt")
y_test<-read.table("y_test.txt")

# train data
s_train<-read.table("subject_train.txt")
x_train<-read.table("X_train.txt")
y_train<-read.table("y_train.txt")

# feature
feature<-read.table("features.txt")
View(feature)

# activity lables
label<-read.table("activity_labels.txt")
View(label)

#-------------------------------------------------------------------------------

# 2. Merge data

# Merge test data
test<-cbind(s_test,y_test,x_test)

# Merge training data
train<-cbind(s_train,y_train,x_train)

# Merge test data and training data
allData<-rbind(test,train)

#-------------------------------------------------------------------------------

# 3. Extracts only the measurements on the mean and standard deviation 

# Add variable name
colnames(allData)<-c("subjects","activities",feature[,2])

# Select the measurements on the mean and standard deviation
index<-grep("(mean|std)\\(\\)",colnames(allData))
index<-c(1,2,index)
selectedData<-allData[,index]
View(selectedData)

#-------------------------------------------------------------------------------

# 4. Name the activities using descriptive names

# convert the column of activities into factor and name the activities
selectedData[,2]<-factor(selectedData[,2], levels = 1:6,labels = label[,2])

#-------------------------------------------------------------------------------

# 5. Label the data set with descriptive variable name

colnames(selectedData)[-(1:2)]<-gsub("mean\\(\\)","Mean",
                                     colnames(selectedData)[-(1:2)])
colnames(selectedData)[-(1:2)]<-gsub("std\\(\\)","SD",
                                     colnames(selectedData)[-(1:2)])
colnames(selectedData)[-(1:2)]<-gsub("-","",
                                     colnames(selectedData)[-(1:2)])

#-------------------------------------------------------------------------------

# 6. Creates a tidy data set with the average of each variable for each 
#    activity and each subject.

library(reshape2)
meltedData<-melt(selectedData,id=c("subjects","activities"),
                 measure.vars = colnames(selectedData)[3:68])
head(meltedData)
avgData<-dcast(meltedData,subjects+activities~variable,mean)
View(avgData)

#-------------------------------------------------------------------------------

# 7. Write processed data

write.table(selectedData,"traintestdata.txt",row.name=FALSE)
write.table(avgData,"averagedata.txt",row.name=FALSE
