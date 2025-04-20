library(rvest) # para scrapear
library(tidyverse) # para modelar
library(magick) # muestra imagenes

url <- "https://es.wikipedia.org/wiki/Santa_Fe_(Argentina)"

pagina <- read_html(url)


## Voy a scrapear la pagina de Wikipedia de mi ciudad, Santa Fe

# titulo
titulo <- pagina %>%
  html_element("span.mw-page-title-main") %>%
  html_text()

print(paste("Mi ciudad está ubicada en", titulo))

# una pequeña introducción
introduccion <- pagina %>%
  html_element("div.mw-parser-output > p") %>%
  html_text(trim = TRUE)

# Mostrar el resultado
print(introduccion)

# conozcamos la población. cuántas personas la habitan y la habitaron?
tabla_poblacion <- pagina %>%
  html_element("table.toccolours") %>%
  html_table()

# Ver la tabla
print(tabla_poblacion)

# Leer la imagen desde la URL
imagen <- image_read("https://upload.wikimedia.org/wikipedia/commons/f/f9/Casa_de_gobierno_de_la_provincia_de_Santa_Fe.jpg")

# Mostrarla en el visor
print(imagen)
image_write(imagen, path = "casa_gobierno_santa_fe.jpg")

# Datos clave de la ciudad
infobox <- pagina %>%
  html_element(".infobox") %>%
  html_table()

# Ver la infobox
print(infobox)

# genero un dataframe con algunas curiosidades en el dialecto de la ciudad / region
tabla <- pagina %>%
  html_node(xpath = "/html/body/div[2]/div/div[3]/main/div[3]/div[3]/div[1]/table[7]") %>%
  html_table(fill = TRUE)

print(tabla)

tabla_limpia <- tabla %>%
  na.omit()  


print(tabla_limpia)

write.csv(tabla_limpia, "tabla_santa_fe.csv", row.names = FALSE)