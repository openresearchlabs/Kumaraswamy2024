library(TreeSummarizedExperiment)
library(mia)
library(Cairo)
library(dplyr)
library(readxl)
source("funcs.R")

# Abundance profiles
gen <- read_data("../data/Genus_hitchip.xlsx")
phy <- read_data("../data/Phylum_hitchip.xlsx")
oli <- read_data("../data/Oligo_hitchip.xlsx")

# Metadata
md <- read_data("../data/Metadata.xlsx")
rownames(md) <- unname(md[, "Sample"])
md <- as.data.frame(md)
# Group-A: never consumed Hawaijar and Dahi (n=20, control)
# Group-B: consume Hawaijar and Dahi (n=21)
# Group-C: consume Hawaijar, not Dahi (n=23)
# Group-D: consume Dahi, not Hawaijar (n=14)
md[, "Timepoint"] <- as.numeric(unlist(md[, "Timepoint"]))
md[, "Season"] <- factor(unlist(md[, "Season"]), levels=c("summer", "autumn", "winter"))
factors <- c("Age", "Sex", "BMI", "Clan",  "Nature of  birth", "Marital status", "Residence", "Subject", "Group")
for(f in factors) {
  md[, f] <- factor(unlist(md[, f]), levels=sort(unique(md[, f])))
}

# Create tse data object
tse <-TreeSummarizedExperiment(assays=SimpleList(signal=gen), colData=DataFrame(md))
# Add altExps
altExp(tse, "phylum")  <- TreeSummarizedExperiment(assays=SimpleList(signal=phy))

altExp(tse, "oligo")   <- TreeSummarizedExperiment(assays=SimpleList(signal=oli))
# There is one NA, replace it with min value
assay(altExp(tse, "oligo"), "signal")[is.na(assay(altExp(tse, "oligo"), "signal"))] <- min(assay(altExp(tse, "oligo"), "signal"), na.rm=TRUE)

# -------------------------------------------

# Total load in LOG10_16S _RNA_gene copies_per_g
# tabs 6 and 8 have different sample names
tabs <- list()
for (i in 1:9) {
  tabs[[i]] <- read_excel("../data/AbsoluteloadTaxaspecificqPCRdata.xlsx", sheet = i) 
}
tabs <- tabs[-c(6,8)]
d <- Reduce(function(dtf1,dtf2) full_join(dtf1,dtf2,by="Sample"), tabs)
d <- data.frame(d)
rownams <- unname(unlist(d[, "Sample"]))
d <- d[, -1]
d[d %in% c("missing data", "NA")] <- NA
d <- apply(d, 2, as.numeric)
rownames(d) <- rownams
altExp(tse, "total_loads")  <- TreeSummarizedExperiment(assays=SimpleList(signal=t(d)))

# 'Fecal metabolite profile_LC-HRMS Data.xlsx'
x <- read_excel("../data/Fecal\ metabolite\ profile_LC-HRMS Data.xlsx", sheet = 1) 
colnams <- as.character(x[3,])
x <- x[-c(1,2,3),]
colnames(x) <- colnams
xr <- x[, 1:5]
xd <- apply(as.matrix(x[, 6:ncol(x)]), 2, as.numeric)
M <- matrix(NA, nrow=nrow(xd), ncol=ncol(tse))
colnames(M) <- colnames(tse)
# Match samples
M[, colnames(xd)] <- xd
altExp(tse, "metabolites")  <- TreeSummarizedExperiment(assays=SimpleList(signal=M), rowData=xr)

# 'SCFA data-HPLC.xlsx'
x <- read_excel("../data/SCFA\ data-HPLC.xlsx") 
colnams <- unname(unlist(x[1,]))
x <- x[-1, ]
colnames(x) <- colnams
rownams <- x$Sample
x <- x[,-1]
x <- as.matrix(x)
x <- apply(x,2,as.numeric)
scfa <- t(x)
colnames(scfa) <- rownams
M <- matrix(NA, nrow=nrow(scfa), ncol=ncol(tse))
colnames(M) <- colnames(tse)
M[, colnames(scfa)] <- scfa
rownames(M) <- colnams[-1]
altExp(tse, "scfa")  <- TreeSummarizedExperiment(assays=SimpleList(signal=M))

# --------------------------------------------------------------------------------------------------------

# Add relative abundances
tse <- transformAssay(tse, assay_name="signal", method="relabundance")
altExp(tse, "phylum") <- transformAssay(altExp(tse, "phylum"), assay_name="signal", method="relabundance")
altExp(tse, "oligo") <- transformAssay(altExp(tse, "oligo"),   assay_name="signal", method="relabundance")

# Add log10 
tse <- transformAssay(tse, assay_name="relabundance", method="log10", name="log10relabundance")
altExp(tse, "phylum") <- transformAssay(altExp(tse, "phylum"), assay_name="relabundance", method="log10", name="log10relabundance")
altExp(tse, "oligo")  <- transformAssay(altExp(tse, "oligo"),  assay_name="relabundance", method="log10", name="log10relabundance")

# Add alpha diversity calculated at oligo level
tse$shannon <- addAlpha(altExp(tse, "oligo"), assay.type="relabundance", index="shannon")$shannon

saveRDS(tse, file="tse.Rds")

# tse$bmi <- as.numeric(tse$bmi)
# REad clusters
#cl <- read_excel("../DataFromJeyaram2024/HITChip\ data/CommunityClusters.xlsx")
#colData(tse)$oligocluster <- factor(as.vector(cl[,2])[[1]][match(colnames(tse), as.vector(cl[,1])[[1]])])
# source("replicate_clusters.R") # Test alternative clustering
# Two samples are missing cluster information; impute randomly
#inds <- which(is.na(colData(tse)$oligocluster))
#tse$oligocluster[inds] <- sample(na.omit(unique(tse$oligocluster)), length(inds))
