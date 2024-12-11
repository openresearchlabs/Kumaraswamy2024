#Random Forest Implementation in R, Use R version 4.4.2
#set working directory to the data directory of the files (Session->set working directory)
######################################################
install.packages("randomForest")
library(randomForest)


#For Random_forest, Log 10 transformation of LC-HRMS metabolite data 
#and % relative abundance the original genus-level HITChipdata, 
#grouping and comparing between the categorized groups
#(Cluster-P and Cluster B/R or Fermented milk eater (B+D) and control(A+C) 
#or Fermented Soybean eater (B+C) and control (A+D)).

my_data <- read.csv("MILK.csv", header = TRUE) #import data

names(my_data) #column names

my_ranfor <- randomForest(Group ~ ., importance=TRUE, ntree=10000,
                          proximity=TRUE, data = my_data)#random forest 

str(my_ranfor)
plot(my_ranfor) #plotting random forest output

#plotting importance
varImpPlot(my_ranfor,
           sort = T,
           main="Variable_Importance",
           n.var=20)

imp <- importance(my_ranfor) #saving output for future use 
write.table(imp,quote=FALSE,sep=" ", file="importance_A_B.txt")
