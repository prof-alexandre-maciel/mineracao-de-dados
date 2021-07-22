install.packages("ggplot2")
library(ggplot2)
install.packages("dplyr")
library(dplyr)
getwd()
library(tidyverse)

dados <- read.csv2("~/Downloads/baseGeralALINHADA.csv", sep =";")
select(dados)

dados=dados[c("PRIMEIRA_PROVA", "SEGUNDA_PROVA", "WEBQUEST01", "WEBQUEST02", "FORUM01","FORUM02","FORUM03", "FORUM04" )]
print(dados)
df<-scale(dados)
library(factoextra)
fviz_nbclust(df, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)

set.seed(123)
km.res <- kmeans(df, 3, nstart = 25)
print(km.res)

v<-cbind(dados, agrupamento=km.res$cluster)

write.csv(v, "~/Downloads/tabeladados3.csv", row.names = FALSE)



#rergressao logistica
library(tidyverse)
library(caret)
library(foreign)
library(nnet)
library(stargazer)
library(ggplot2)
