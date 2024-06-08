if (!require("pacman")) install.packages("pacman")
pacman::p_load("ggplot2", "ggmap", "googleway", "tidyverse")


# chave
key <- "AIzaSyC78zbXYMb-7nD8R-YiGruRRXicfsdhqiY"

# setup das chaves
set_key(key) # google way
register_google(key=key) # ggmap

endereco <- "Torre de TV, Brasilia, Brasil"
lugar <- geocode(endereco)


# Mapa básico com ggmap
mapa1 <- ggmap::get_map(location = c(lon = lugar$lon, lat = lugar$lat), zoom = 15) 

ggmap(mapa1) +
  geom_point(aes(x = lugar$lon, y = lugar$lat), size = 4)


# Google Directions API
direcao <- google_directions(origin = "BSAN Bloco de Salas de Aula Norte, UNB, Brasília, Brasil",
                             destination = "BSAS Bloco de Salas de Aula Sul, UNB, Brasília, Brasil",
                             key = key,
                             mode = "driving") #mode:	string One of 'driving', 'walking', 'bicycling' or 'transit'.

pontos <- geocode("BSAN Bloco de Salas de Aula Norte, UNB, Brasília, Brasil") %>%
  bind_rows(geocode("BSAS Bloco de Salas de Aula Sul, UNB, Brasília, Brasil"))

rota <- decode_pl(direcao$routes$overview_polyline$points)

mapa2<- get_map(location = c(lon = mean(rota$lon), lat = mean(rota$lat)), zoom = 15) 
ggmap(mapa2) +
  geom_path(data = rota, aes(x = lon, y = lat), color = "blue", size = 1)+
  geom_point(data = pontos, aes(x = lon, y = lat), color = "red", size = 5)



# Google Geocode API
df <- google_geocode(address = "Casa Almeria, Brasília",
                     key = key)

geocode_coordinates(df)

# Google Places API
## Por texto
texto <- google_places(search_string = "Mercados na asa norte, brasilia, Brasil",
                      key = key,
                      language = "pt-BR")

# idiomas: https://developers.google.com/maps/faq#languagesupport
resultados_texto <- texto[["results"]]

mapa3<- get_map(location = c(lon = mean(resultados_texto$geometry$location$lng), lat = mean(resultados_texto$geometry$location$lat)), zoom = 14) 
ggmap(mapa3) +
  geom_point(data = resultados_texto, aes(x = geometry$location$lng, y = geometry$location$lat), color = "red", size = 4)+
  theme_void()





## Por proximidade
proximo<-  google_places(location = c(22.9068, 43.1729),
                         keyword = "Mercado",
                         radius = 5000,
                         key = key,
                         language = "pt-BR")



proximidade <- google_places(
  location = c(-15.808595, -47.885220),
  radius = 1000,
  keyword = "coffee shop",
  key = key
)

centro_lng <- mean(proximidade$results$geometry$location$lng)
centro_lat <- mean(proximidade$results$geometry$location$lat)
  
  
mapa4<- get_map(location = c(centro_lng, centro_lat), zoom = 14)

ggmap(mapa4) +
  geom_point(data = proximidade$results, aes(x = geometry$location$lng, y = geometry$location$lat), color = "red", size = 4)+
  theme_void()


google_map(key = key, search_box = T) %>%
  add_traffic()




