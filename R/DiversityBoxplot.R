library(mia)
library(ggplot2)
theme_set(theme_bw(20))
df <- mia::meltSE(tse, assay.type="signal", add.col=TRUE)

# Alpha diversity between community type clusters
p <- ggplot(df, aes(x=Cluster, y=shannon)) +
       geom_boxplot() +
       labs(y="Alpha diversity (Shannon index)")
print(p)


