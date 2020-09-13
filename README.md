# cluster-motifs
Cluster redundant motifs in a set of meme-formatted motifs

The motifs returned by *de novo* motif discovery algorithms are often numerous and redundant, making downstream motif analyses more difficult. This repo presents a simple function
written in R to combine redundant motifs. The approach is based on hierarchical clustering and uses a bootstrapping approach implemented in pvclust[] to avoid the issue of choosing a similarity cutoff for when to combine motifs. 

## Dependencies

1. The universalmotif package
Install with:

```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("universalmotif")

library(universalmotif)
```

2. The pvclust pacakge
Install with:

`install.packages("pvclust")`
