```{r}

paquetes_lista <- c(
  "curl", "remotes", "spotifyr", "rjson", "gt", "reticulate", "pdftools"
)

install.packages(paquetes_lista)
```



```{r}
remotes::install_github("jooyoungseo/youtubecaption")
```


```{r}
reticulate::install_miniconda()

```

```{r}


library(youtubecaption)
library(reticulate)
library(tidyverse) 
library(spotifyr)  # Trabajar con la API de spotify
library(rjson)     # Lectura de archivo json
library(gt) # Para hacer tablas lindas

```

```{r}
#SPOTIFY (CREDENCIALES)




```

```{r}
#TIRA ERROR, NO ENCUENTRA CREDENTIALS

credentials <- fromJSON(file = "credentials.json")

Sys.setenv(SPOTIFY_CLIENT_ID = credentials$SPOTIFY_CLIENT_ID)
Sys.setenv(SPOTIFY_CLIENT_SECRET = credentials$SPOTIFY_CLIENT_SECRET)
access_token <- get_spotify_access_token()


```

```{r}
# Tranajamos con Youtube para extraer subtitulos automaticos de videos

link <- "https://www.youtube.com/watch?v=TfW5qAajtWw"
df_subtitulos<- get_caption(url = link, language = "es")
```
```{r}
print(df_subtitulos)
```

```{r}
# Trabajamos con CURL para traer los datos de la API de Star Wars

library(curl)

h <- new_handle()
handle_setheaders(h, "User-Agent" = "Mozilla/5.0")

```
```{r}
# Trabajamos con planetas.

url <- "https://www.swapi.tech/api/planets/1"
response <- curl_fetch_memory(url, h)
```

```{r}
json_text <- rawToChar(response$content)
data <- fromJSON(json_text)

# Observo resultados
print(data$result$properties)
```


```{r}

planeta <- data$result$properties

# Lo convierto a un dataframe:
data.frame(
  nombre = planeta$name,
  clima = planeta$climate,
  rotacion = as.numeric(planeta$rotation_period),
  paisaje = planeta$terrain,
  poblacion = as.numeric(planeta$population)
) |>
  gt()
```


```{r}
# Contruir un bucle

url <- "https://www.swapi.tech/api/planets"
response <- curl_fetch_memory(url, h)
json_text <- rawToChar(response$content)
data <- fromJSON(json_text)

data.frame(data$result)

```


```{r}
# ACA TIRA ERROR! 

df_planeta <- data.frame()

# Me quedo con un vector con los IDs de los personajes
ids <- sapply(data$result, function(x) x$uid)


for (i in ids) {
 
  # Repetimos los pasos anteriores para consolidar la data 
url <- paste0("https://www.swapi.tech/api/planets/",i)
response <- curl_fetch_memory(url, h)
json_text <- rawToChar(response$content)
data <- fromJSON(json_text)

# Extraigo solo los resultados
planeta <- data$result$properties

df <- data.frame(
  nombre = planeta$name,
  clima = planeta$climate,
  rotacion = as.numeric(planeta$rotation_period),
  paisaje = planeta$terrain,
  poblacion = as.numeric(planeta$population)
) 
  

 
 df_planeta <- df_planeta |> 
   bind_rows(df)

}
```

```{r}
#YOUTUBE

link <- "https://www.youtube.com/watch?v=WtD_FJHxpWM&t=108s"
df_subtitulos<- get_caption(url = link, language = "es")

```

```{r}
df_subtitulos |> 
  gt()
```
```{r}
df_subtitulos |> 
  summarise(texto = paste(text, collapse = " ")) |> 
  gt()
```
```{r}
library(stopwords)
```

```{r}
# Limpio subs
df_subtitulos <- gsub("\\s+", " ",df_subtitulos)
```

