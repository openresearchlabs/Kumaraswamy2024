install.packages("svDialogs")
install.packages("R.utils")
require(svDialogs)

## Open your tab file, Level 1&2 Sum_BGsub_Rel.contribution
#oligo2 <- read.csv("species.csv", header = TRUE) #open CSV file
file <- choose.files(multi=F)
oligo <- read.table(file,sep="\t", header=T, row.names=1)
samples <- colnames(oligo)

## To select samples you can do that in 2 ways: select G1 and those samples not in G1 are G2, for which you would use:
## G2 <- samples[!(samples %in% G1)]
## or select G1 and select G2 (this is useful when you have multiple groups) (standard below)

G1 <- select.list(samples, multiple=T, title="Select samples for 1st group")
G2 <- select.list(samples, multiple=T, title="Select samples for 2nd group")


levels <- rownames(oligo)

M<-matrix(data=NA,length(levels),1)
rownames(M) <- levels

for (i in 1:length(levels)) {
  
  lvl <- levels[i]
  l.g1 <- oligo[lvl,G1]
  l.g2 <- oligo[lvl,G2]
  
  p<-wilcox.test(as.numeric(l.g1),as.numeric(l.g2))$p.value
  
  cat(lvl," p-value: ",p, "\n")
  
  M[i,1]<-p
}

M

## To Adjust P-values for Multiple Comparisons with Benjamini & Hochberg (1995) ("BH" or its alias "fdr")

cor.p <- p.adjust(M,method="bonferroni") # Other methods can be applied here
# c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY",
#   "fdr", "none")
cor.p

#saving output for future use 
write.table(M,quote=FALSE,sep=" ", file="normal_A_D.txt")
write.table(cor.p,quote=FALSE,sep=" ", file="cor_p4_bonferroni_A_D.txt")
