#Random Forest Implementation in R, Use R version 4.4.2
#set working directory to the data directory of the files (Session->set working directory)
######################################################

#install.packages("randomForest")
library(randomForest)

#For Random_forest, Log 10 transformation of LC-HRMS metabolite data 
#and % relative abundance the original genus-level HITChipdata, 
#grouping and comparing between the categorized groups
#(Cluster-P and Cluster B/R or Fermented milk eater (B+D) and control(A+C) 
#or Fermented Soybean eater (B+C) and control (A+D)).

# my_data <- read.csv("../data/MILK.csv", header = TRUE, row.names=1) #import data
# names(my_data) #column names

# Load data
source("data.R")

# Pick relative abundance data
my_data <- assay(tse, "relabundance") %>% as.matrix

# Add group info 
my_data <- as.data.frame(t(my_data))
my_data$Group <- tse$Group
colnames(my_data) <- gsub(" ", "_", colnames(my_data))
colnames(my_data) <- gsub("\\.", "", colnames(my_data))

# Run random forest
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
