### Network prepare script
require(igraph)
file <- "C:\\Users\\DELL\\Desktop\\New folder\\Level2abundance1.txt"  # Level 2 file
gr1.file <- "level2abundance.graphml"                                 # Ouput file
                                                                      # ALWAYS end in ".graphml"
lev2 <- read.table(file,sep="\t",header=T,row.names=1) #check if read correctly!

### Step 1
#   Calcalute correlation (Pearson, Spearman, log-transformed or not ? Up to you)
correlations <- cor(t(lev2))


### Step 2
#   Determine your threshold
#   r-theshold? or p-value calculated threshold? Up to you

r.lim <- 0.4

n <- 214                          # subjects used (enter yourself)
p.lim <- 0.0001/214                  # Example only here
df.lim <- 214-2                    # degrees of freedom
t.lim <- abs(qt(p.lim/2,df.lim))  # t-value (abs() is used to prevent negative numbers)
R.lim <- sqrt((t.lim^2)/(t.lim^2 + df.lim)) # "calcuted" r-limit
R.lim
#r.lim <- R.lim # uncomment this line in case you want to use the calculated r-limit

### Step 3
#   Convert to graphml ready format
#   Step 3-1: Set diagonal to zero, prevent self networking of the nodes in GePhi
correlations <- as.matrix(correlations)
diag(correlations)<-0
#   Step 3-2: Create igraph object
graph1 <- graph.adjacency(abs(correlations)> r.lim, # Use only corralations above threshold
                          diag=FALSE, weighted=TRUE,
                          mode="upper") # Take only one half of your matrix
  E(graph1)$weight <- correlations[lower.tri(correlations)][abs(correlations[lower.tri(correlations)])> r.lim]
	V(graph1)$label<- colnames(correlations)
  plot(graph1) # just to check in R (horrible picture)

### Step 4
#   Save it!

write.graph(graph1,gr1.file, format="graphml")
min(correlations)