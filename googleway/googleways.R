library(googleway)
library(ggmap)
key <- "AIzaSyC78zbXYMb-7nD8R-YiGruRRXicfsdhqiY"

register_google(key = key)
set_key(key)

address <- "Praça da Sé, São Paulo, Brasil"
location <- geocode(address)
print(location)


library(ggplot2)

# Mapa base
map <- get_map(location = c(lon = location$lon, lat = location$lat), zoom = 15)
ggmap(map) +
  geom_point(aes(x = location$lon, y = location$lat), color = "red", size = 5)



origin <- "Praça da Sé, São Paulo, Brasil"
destination <- "Avenida Paulista, São Paulo, Brasil"

# Obter direções
directions <- google_directions(origin = origin, destination = destination, key = key)

# Extrair os pontos da rota
route <- decode_pl(directions$routes$overview_polyline$points)

# Plotar o mapa com a rota
map <- get_map(location = c(lon = mean(route$lon), lat = mean(route$lat)), zoom = 13)
ggmap(map) +
  geom_path(aes(x = lon, y = lat), color = "blue", size = 2, data = route)
