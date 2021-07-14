#analisando o curso de Letras com 3 cluster 
install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
getwd()
library(tidyverse)

dados <- read.csv2("~/Downloads/baseGeralALINHADA.csv", sep =";")
select(dados)

dados %>%
  filter(Curso == "Letras")
letras=dados %>%
  filter(Curso == "Letras") 
print(letras)
baseLET=letras[c("PRIMEIRA_PROVA", "SEGUNDA_PROVA", "WEBQUEST01", "WEBQUEST02", "FORUM01","FORUM02","FORUM03", "FORUM04" )]
print(baseLET)
df<-scale(baseLET)
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)