#Load dependencies
library(pvclust)
library(universalmotif)

#Combine motif lists, change names to avoid duplicates
rename_motifs = function(motifs){
	newmotifs = list()
	i = 1
	#For each motif in list, define new motif name
	for(motif in motifs){
		motif["name"] = paste("motif", i, sep = "")
		newmotifs[i] = motif
		i = i + 1
	}
	return(newmotifs)
}

#Define function for clustering motifs
#EACH MOTIF MUST HAVE A UNIQUE NAME INORDER FOR THIS TO WORK PROPERLY!
ensemble_motifs = function(motifs, alpha_value = 0.99, merge_method = "ALLR"){
	#Initialize list for final output
	finalmotifs = list()

	#Rename motifs to avoid quirks with clustering. If two motifs in list have the same name, then
	#some functions may get confused
	motifs = rename_motifs(motifs)	

	#Perform hierarchical clustering with bootstrapping
	fit <- pvclust(compare_motifs(motifs, method = "EUCL"), method.hclust="average", 
		method.dist="euclidean")
	
	#extract which motifs are in which clusters. motifs that aren't in clusters are not included
	#in this list
	clustermems = pvpick(fit, alpha=alpha_value)$clusters

	#Build list of motif names
	names = c()
	for(motif in motifs){
		names = c(names, motif["name"])
	}

	#Determine which motifs are not in a cluster
	notclustered = names[which(!(names %in% unlist(clustermems)))]

	#Add non-clustered motifs to final motif list
	for(motif in motifs){
		if(motif["name"] %in% notclustered){
			finalmotifs[(length(finalmotifs) + 1)] = motif
		}
	}

	#If there are no significant clusters, do not combine motifs. Otherwise, combine motifs
	if(is.null(unlist(clustermems)) == FALSE){

		#Extract, then combine the motifs present in each cluster
		for(clustermem in clustermems){
			group = list()
			for(name in clustermem){
				for(motif in motifs){
					if(motif["name"] == name){
						group[[(length(group) + 1)]] = motif
					}
				}
			}

			#Combine motifs that are in the same cluster
			mergedmotif = merge_motifs(group, method = merge_method)
			finalmotifs[[(length(finalmotifs) + 1)]] = mergedmotif
		}
	}
	return(finalmotifs)
}

#############################################################################################
#
# EXECUTE FUNCTIONS ON EXAMPLE DATA
#
#############################################################################################

#Load example motifs
#Change the working directory below to where you saved the example motif file
setwd("C:\\Users\\miles\\OneDrive\\Education\\MichiganStateUniversity\\github_projects")
motifs = read_meme("meme_example_motifs.txt")

#Execute ensemble_motifs function on example motif set
ensemble_motifs(motifs)
