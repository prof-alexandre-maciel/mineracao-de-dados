install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
getwd()
library(tidyverse)

dadosA<-read.csv("~/Downloads/baseGeralALINHADA.csv", header=FALSE, sep=";")
select(dadosA)

dados <- read.csv2("~/Downloads/baseGeralALINHADA.csv", sep =";")
select(dados)

dados %>%
  filter(Curso == "Administracao")

administracao=dados %>%
  filter(Curso == "Administracao") 
print(administracao)
baseADM=administracao[c("PRIMEIRA_PROVA", "SEGUNDA_PROVA", "WEBQUEST01", "WEBQUEST02", "FORUM01","FORUM02","FORUM03", "FORUM04" )]
print(baseADM)
df<-scale(baseADM)
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)
```
Instalando pacotes:
  ```{r}
install.packages("factoextra")
library(factoextra)

set.seed(123)
km.res <- kmeans(df, 4, nstart = 25)
print(km.res)

fviz_cluster(km.res, data = df,
             palette = c("#2E9FDF", "#00AFBB", "#E7B800", "#FC4E07"),
             ellipse.type = "euclid", # Concentration ellipse
             star.plot = TRUE, # Add segments from centroids to items
             repel = TRUE, # Avoid label overplotting (slow)
             ggtheme = theme_minimal()
)


set.seed(123)
fviz_nbclust(df, kmeans, nstart = 25, method = "gap_stat", nboot = 50)+
  labs(subtitle = "Gap statistic method")

library("NbClust")
nb <- NbClust(df, distance = "euclidean", min.nc = 2,
              max.nc = 10, method = "kmeans")


library("factoextra")
fviz_nbclust(nb)

install.packages(c("factoextra", "fpc", "NbClust"))
library(factoextra)
library(fpc)
library(NbClust)

# K-means clustering
km.res <- eclust(df, "kmeans", k = 4, nstart = 25, graph = FALSE)
# Visualize k-means clusters
fviz_cluster(km.res, geom = "point", ellipse.type = "norm",
             palette = "jco", ggtheme = theme_minimal())


fviz_silhouette(km.res, palette = "jco",
                ggtheme = theme_classic())

fviz_nbclust()



#analisando o curso de adm com 3 cluster 

administracao=dados %>%
  filter(Curso == "Administracao") 
print(administracao)
baseADM=administracao[c("PRIMEIRA_PROVA", "SEGUNDA_PROVA", "WEBQUEST01", "WEBQUEST02", "FORUM01","FORUM02","FORUM03", "FORUM04" )]
print(baseADM)
df<-scale(baseADM)
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)


set.seed(123)
km.res <- kmeans(df, 3, nstart = 25)
print(km.res)

aggregate(df, by=list(cluster=km.res$cluster), mean)

dd <- cbind(df, cluster = km.res$cluster)
head(dd)

km.res$cluster
head(km.res$cluster, 3)

km.res$centers


library(factoextra)
set.seed(123)
# K-means on iris dataset
km.res1 <- kmeans(df, 3)
fviz_cluster(list(data = df, cluster = km.res1$cluster),
             ellipse.type = "norm", geom = "point", stand = FALSE,
             palette = "jco", ggtheme = theme_classic())












