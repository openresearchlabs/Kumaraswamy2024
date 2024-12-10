#Density plot and Beanplot Implementation in R for all the columns 
#set working directory to the data directory of the files (Session->set working directory)
######################################################
####################Two files#######################
# These are extracted from the log genus HITChip data 

otu_A <- read.csv("../data/Bimodality/Season1.csv", header = TRUE) #open CSV file
otu_B <- read.csv("../data/Bimodality/Season2.csv", header = TRUE) #open CSV file
otu_C <- read.csv("../data/Bimodality/Season3.csv", header = TRUE) #open CSV file

######Plotting all the graphs C&E#######################################
colnames_A <- dimnames(otu_A)[[2]]
colnames_B <- dimnames(otu_B)[[2]]
colnames_C <- dimnames(otu_C)[[2]]


#Density plots
par(mfrow=c(1, 1))
for (i in 2:2)#Select Range of species(columns) 
{
  species_name <- c(colnames_A[i], colnames_B[i], colnames_C[i])
  d2 <- density(otu_A[,i])
  d3 <- density(otu_B[,i])
  d4 <- density(otu_C[,i])
  plot(d4, main=colnames_A[i], col = "green", col.main= "black", 
       sub = colnames_B[i], col.sub = "black",
       Sub = colnames_C[i], col.sub = "black")
  polygon(d3, border="black")
  polygon(d2, border="red")
  
}

