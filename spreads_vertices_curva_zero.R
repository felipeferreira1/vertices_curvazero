#Script para filtrar v�rtices da curva zero (ETTJ)
#Feito por: Felipe Simpl�cio Ferreira
#�ltima atualiza��o: 18/12/2020

#Definindo diret�rios a serem utilizados
getwd()
setwd("C:/Users/User/Documents")

##Carregando pacotes que ser�o utilizados
library(tidyverse)
library(rio)
library(openxlsx)

#Importando planilha
  #Definindo as datas
datas <- import("curva_zero.xlsx", col_names = F)
datas <- datas[1,]
seleciona_datas <- seq(2,length(datas), 8)
datas_tratadas <- NA
for (i in 1:length(seleciona_datas)){
  datas_tratadas[i] <- datas[1,seleciona_datas[i]]
}
datas_tratadas <- convertToDate(datas_tratadas)

  #Coletando o resto dos dados
dados <- import("curva_zero.xlsx", col_names = F)
seleciona_coluna <- seq(4,length(dados), 8)

#Filtrando v�rtices de x anos (mudar de acordo com a linha onde est� o v�rtice; ex. 2 anos = 10)
x_anos <- NA
for (i in 1:length(seleciona_coluna)){
  x_anos[i] <- as.numeric(dados[10,seleciona_coluna[i]])
}

#Filtrando v�rtices de y anos (v�rtice mais longo)
y_anos <- NA
for (i in 1:length(seleciona_coluna)){
  y_anos[i] <- as.numeric(dados[24,seleciona_coluna[i]])
}

#Juntando tudo
resultado <- data.frame(datas = datas_tratadas, x_anos, y_anos)
#Calculando y - x
resultado <- resultado %>% mutate(diferen�a = y_anos - x_anos) %>% arrange(datas)

#Exportando arquivo
export(resultado, "resultado.xlsx")