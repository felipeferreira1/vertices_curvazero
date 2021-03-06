#Script para filtrar a expectativa de infla��o impl�cita acumulada em 12 meses - t�tulos p�blicos (Anbima)
#Feito por: Felipe Simpl�cio Ferreira
#�ltima atualiza��o: 01/03/2021

#Definindo diret�rios a serem utilizados
getwd()
setwd("C:/Users/User/Documents")

##Carregando pacotes que ser�o utilizados
library(tidyverse)
library(rio)
library(openxlsx)
library(lubridate)
library(data.table)


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
seleciona_coluna <- seq(5,length(dados), 8)

#Filtrando v�rtices de x anos (mudar de acordo com a linha onde est� o v�rtice; ex. 1 ano = 8)
x_anos <- NA
for (i in 1:length(seleciona_coluna)){
  x_anos[i] <- as.numeric(dados[8,seleciona_coluna[i]])
}

#Juntando tudo
resultado <- data.frame(datas = datas_tratadas, x_anos)
resultado <- setDT(resultado)[order(datas), .(x_anos[which.max(datas)], datas[which.max(datas)]), by = .(year(datas), month(datas))]

#Exportando arquivo
export(resultado, "resultado.xlsx")
