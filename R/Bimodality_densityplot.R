library(mia)
library(ggplot2)
theme_set(theme_bw(20))
df <- mia::meltSE(tse["Prevotella tannerae et rel.", ], assay.type="signal", add.col=TRUE)
p <- ggplot(df, aes(x=log10(signal), color=Season)) +
       geom_density() 
print(p)

