# Load package to plot reducedDim
library(scater)

# Run PCoA on relabundance assay with Bray-Curtis distances
tse <- runMDS(
    tse,
    FUN = getDissimilarity,
    method = "bray",
    assay.type = "relabundance",
    name = "MDS_bray")

# Create ggplot object
p <- plotReducedDim(tse, "MDS_bray", colour_by = "Cluster")

print(p)