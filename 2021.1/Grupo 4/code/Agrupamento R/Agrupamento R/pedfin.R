install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
getwd()
library(tidyverse)

dados <- read.csv2("~/Downloads/baseGeralaGRUPBIM.csv", sep =";")
select(dados)

pedagogia=dados %>%
  filter(Curso == "Pedagogia") 
print(pedagogia)
basePED=pedagogia[c("PRIMEIRA_PROVA", "SEGUNDA_PROVA", "WEBQUEST01", "WEBQUEST02", "FORUM01","FORUM02","FORUM03", "FORUM04" )]
print(basePED)
df<-scale(basePED)
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 5, linetype = 2)


library(factoextra)
library(fpc)
library(NbClust)

# K-means clustering 
km.res <- eclust(df, "kmeans", k = 5, nstart = 25, graph = FALSE) 
# Visualize k-means clusters 
fviz_cluster(km.res, geom = "point", ellipse.type = "norm", 
             palette = "jco", ggtheme = theme_minimal())


# Hierarchical clustering 
hc.res <- eclust(df, "hclust", k = 5, hc_metric = "euclidean",
                 hc_method = "ward.D2", graph = FALSE)
# Visualize dendrograms 
fviz_dend(hc.res, show_labels = FALSE, palette = "jco", as.ggplot = TRUE)



fviz_silhouette(km.res, palette = "jco", ggtheme = theme_classic())

silinfo <- km.res$silinfo
names(silinfo)

# Silhouette information
silinfo <- km.res$silinfo names(silinfo) 
# Silhouette widths of each observation
head(silinfo$widths[, 1:3], 10) 
# Average silhouette width of each cluster 
silinfo$clus.avg.widths 
# The total average (mean of all individual silhouette widths) 
silinfo$avg.width
# The size of each clusters 
km.res$size


# Silhouette width of observation
sil <- km.res$silinfo$widths[, 1:3] 
# Objects with negative silhouette
neg_sil_index <- which(sil[, "sil_width"] < 0) 
sil[neg_sil_index, , drop = FALSE]

library(fpc)
# Statistics for k-means clustering
km_stats <- cluster.stats(dist(df), 
                          # Dun index km_stats$dunn
                          km.res$cluster)
km_stats$dunn