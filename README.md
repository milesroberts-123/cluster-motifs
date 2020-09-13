# cluster-motifs
Cluster redundant motifs in a set of meme-formatted motifs

The motifs returned by *de novo* motif discovery algorithms are often numerous and redundant, making downstream motif analyses more difficult. This repo presents a simple function
written in R to combine redundant motifs. The approach is based on hierarchical clustering and uses a bootstrapping approach implemented in pvclust[] to avoid the issue of having to manually choose a similarity cutoff for when to combine motifs. 

## USAGE

Download the Rscript and run all of the code within. This will define the necessary functions and test whether the script works on some example data.

Afterwards, if you load your motifs into an R object called `motifs`, you can call

`clustered_motifs = ensemble_motifs(motifs)`

to begin the clustering process. A list of motifs will be saved to `clustered_motifs` and any motifs that were very similar will have been combined. You can save the output with:

`write_meme(clustered_motifs, "my_motifs.meme")`

**NOTE:** All of the motifs will be automatically renamed based on their order in the input list of motifs. 

## Input

1. All you need for this to work is a file of motif position weight matricies (PWM) in one of the formats supported by the `universalmotif` package (MEME, HOMER, matrix format, etc.). The `read_meme()` function in `universalmotif` package will accept either minimal MEME format (often output by command line motif finders) or extended MEME format (often output by online MEME suite tools).

**NOTE:** If you need to convert your motifs into minmal MEME format, see [my other repositories](https://github.com/milesroberts-123?tab=repositories).

2. A number for `alpha_value`, which will define how similar motifs need to be in order to be part of the same cluster.

**NOTE:** I would recommend using a very strict cutoff for combining motifs (the default of 0.99 or higher). Otherwise, you may end up combining many similar motifs and be left with many super long motifs that are basically nonsensical.

3. The method used to combine similar motifs. The methods are listed in the details of the R documentation [here](http://127.0.0.1:24519/library/universalmotif/html/merge_motifs.html). By default, the "ALLR" method in the universalmotif package will be used.

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

```
install.packages("pvclust")
library(pvclust)
```

