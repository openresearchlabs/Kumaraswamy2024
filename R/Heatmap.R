#R script used for Heatmap generation: Use R version 4.4.2

#Load "gplots"
library(gplots)

#Load your file, by
# - typing the file path
tablefile <- "File.txt"
# or...
# - by selecting it using the choose.files() function# selecting it using the choose.files() function
tablefile <- choose.files(multi=FALSE)
tablefile              ###This will diaplay the path of the loaded file.

# Read the data from the loaded file
AbundanceGenus <- read.table(tablefile, header=TRUE, row.names=1, sep="\t")
AbundanceGenus                ###This will display the data.

#Convert the data to a matrix
Data_to_Matrix <- data.matrix(AbundanceGenus)

Data_to_Matrix               ###This will display the data matrix.
#Now the table is an R matrix
#Find out the maximum and minimum values, and a rough estimate of the median values.
max(Data_to_Matrix)
min(Data_to_Matrix)
median(Data_to_Matrix)
mean(Data_to_Matrix)
# OR 
#Use summary(Data_to_Matrix)to see the statistical summary of each column.
summary(Data_to_Matrix)

#Take the max, min, and median values and use them to make the "bins" for each color on the heatmap.
pairs.breaks <- c(seq(6.5, 8.2, length.out=50),seq(8.21, 10.26, length.out=50))

mycol <- colorpanel(n=99, low="blue", mid="white", high="red")

#Make heatmap with dendrograms based on both column and row data heatmap.2(Data_to_Matrix, breaks=pairs.breaks, col=mycol, key=TRUE, keysize=2, symkey=FALSE, dendrogram = c("both"), Rowv = TRUE, Colv = TRUE, distfun = dist, hclustfun = hclust, density.info="histogram", denscol="white", trace="none",cexRow=0.5, cexCol=0.5)
