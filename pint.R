library(xml2)
library(rvest)
#Pegando os dados do site
pints <- readLines("https://pintofscience.com.br/")
#pegando as cidades
pintslocais<-pints[grep("https://pintofscience.com.br/events/", pints)]
#pegando apenas os URL das cidades
pints_local_end <- as.data.frame(sub(".*href=\" *(.*?) *\".*", "\\1", pintslocais), stringsAsFactors=FALSE)

#deixando o URL de cada cidade como um character para poder usar o readLines
lista_end <- list()
for(i in 1:nrow(pints_local_end)) {
  lista_end[i] <- as.character(unlist(pints_local_end[i, ]))
}
lista_end

#Pegando os HTML de cada cidade 
cidade<-list()
for (i in seq(lista_end)) {
    cidade[[i]] <- readLines(lista_end[[i]])
}
str(cidade)

cidade[[42]]

#Pegando a lista de palestras de cada cidade
palestras <- list()
for (i in seq(cidade)) {
  palestras[[i]] <- cidade[[i]][grep('<a href="http://pintofscience.com.br/event|<a href="https://pintofscience.com.br/event', cidade[[i]])]
}
str(palestras)

palestras[[42]]

#pegando apenas os URL das palestras
palestras_url <- list()
for (i in seq(palestras)){
  palestras_url[[i]] <- sub(".*<a href=\" *(.*?) *\"><i.*", "\\1", palestras[[i]])
}
str(palestras_url)

palestras_url[[1]]

palestras_url2 <- list()
for (i in seq(palestras_url)){
  palestras_url2[[i]] <- palestras_url[[i]][grep('^(?!.*<a href=)', palestras_url[[i]], perl=TRUE)]
}
str(palestras_url2)


palestras_url3 <- as.data.frame(unlist(palestras_url2), stringsAsFactors=FALSE)
Encoding(palestras_url3$`unlist(palestras_url2)`) <- "UTF-8" #lidando os caracteres especiais


palestras_url3 <- as.character(unlist(palestras_url3))


#Pegando os HTML de cada palestras
palestra_html <-list()
for (i in seq(palestras_url3)){
  palestra_html[[i]] <- readLines(palestras_url3[[i]])
}

str(palestra_html)
head(palestra_html[[1]])



speakers <- list()
for(i in seq(palestra_html)){
  speakers[[i]] <- palestra_html[[i]][grep("(speakers)", palestra_html[[i]])+2]
}
str(speakers)

speakers1 <- as.data.frame(unlist(speakers))
speakers1$`unlist(speakers)` <- as.character(speakers1$`unlist(speakers)`)
Encoding(speakers1$`unlist(speakers)`) <- "UTF-8"

palestrantes_final <- as.data.frame(unique(speakers1$`unlist(speakers)`))
colnames(palestrantes_final)[1] <- "palestrante"

library(stringr)
palestrantes_final$nome <- word(palestrantes_final$palestrante,1)

palestrantes_final$letra <- str_sub(palestrantes_final$nome,-1)

write.csv(palestrantes_final, "palestrantes.csv", row.names = F)


#Nomes das cidades
nomes_cidades <- list()
for (i in seq(lista_end)) {
  nomes_cidades[[i]] <- gsub("^.*https://pintofscience.com.br/events/","", lista_end[[i]])
}
str(nomes_cidades)
nomes_cidades[[42]]


#Contando o numero de palestras por cidade
n_palestras <- list()
for (i in seq(palestras_url2)){
  n_palestras[[i]] <- length(palestras_url2[[i]])
}
n_palestras


