library("rnaturalearthdata")
library("leaflet")
library("RColorBrewer")
## Banco de dados com poligonos 
# countries50

# Construindo a escala
pal <-  colorBin("Blues", domain = log2(countries50$pop_est + 1), bins = 5)

leaflet(data = countries50) %>%
  setView(lng = 0, lat = 0, zoom = 02) %>%
  addPolygons(fillColor = ~ pal( log2(pop_est+1) ),
              fillOpacity = 1,
              color = "#BDBDC3",
              layerId = ~ name,
              weight = 1,
              popup = paste( countries50$name,  "<br>",
                             "População: ", countries50$pop_est)) %>% 
  
  addLegend("bottomright", pal = pal, values = ~log2(countries50$pop_est+1), 
            title = "Escala ", opacity = 1,
            labFormat=labelFormat(transform = function(x)2^(x)-1, digits = 1)) %>%
  addControl("Clique no mapa para ver detalhes", position = "topright")

