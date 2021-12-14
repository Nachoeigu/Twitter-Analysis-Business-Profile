library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library("tidyr")
library("writexl")
library(scales)

#We use the raw data file we downloaded from Twitter
raw_data <- read_csv("twitter.csv")

#We remove the unecessary columns
raw_data <- raw_data %>% 
            select(-1,-13,-16,-17,-18, -19,-20,-31,-34,-35,-36,-37,-38)

#Adjusting the hour to Argentina Zone
raw_data$hora <- ymd_h(str_sub(raw_data$hora, 1, 14))
raw_data$hora  <- raw_data$hora - hours(4)
raw_data <- raw_data %>%
            separate(col = hora, c("dia", "horario"), sep = " ") 
raw_data$horario <- as.character(raw_data$horario) %>%
            str_sub(1,2)

#Cleaning promotional posts
raw_data[,17:28] <- ifelse(raw_data[,17:28]== "-", 0, raw_data[,17:28])

#Generating new KPIs
colnames(raw_data)
raw_data <- raw_data %>% 
            mutate(activity_rate= interacciones/impresiones, CTR = `clics en URL`/impresiones, Engagement = interacciones+`clics de perfil de usuario`+ `clics en URL`+`ampliaciones de detalles`+`interacciones con el contenido multimedia`+`clics de perfil de usuario promocionado`+`clics en URL`+`ampliaciones de detalles promocionado`+`interacciones con el contenido multimedia promocionado`, engagement_rate = Engagement / impresiones)

#Cleaning the rates
raw_data$activity_rate <- label_percent()(raw_data$activity_rate)
raw_data$`tasa de interacci�n` <- label_percent()(raw_data$`tasa de interacci�n`)
raw_data$`tasa de interacci�n promocionado` <- label_percent()(raw_data$`tasa de interacci�n promocionado`)
raw_data$CTR <- label_percent()(raw_data$CTR)
raw_data$engagement_rate <- label_percent()(raw_data$engagement_rate)

#Saving everything in an Excel file
write_xlsx(raw_data,"Twitter.xlsx")
