# info on Uber's H3 hexagonal gird:  https://github.com/obrl-soil/h3jsr/blob/master/vignettes/intro-to-h3jsr.Rmd
# https://github.com/uber/h3/issues/87


# devtools::install_github("obrl-soil/h3jsr")


library(h3jsr)
library(sf)
library(ggplot2)
library(tidyverse)

# read shape
# muni <- st_read(dsn = './Shapes_IBGE', layer ='muni')
muni <- read_sf("../data-raw/municipios/ce/municipios_ce.shp", crs = 4326) %>%
  filter(NM_MUNICIP == "FORTALEZA")

# # projection
# muni <- st_transform(muni, crs = 4326)

# get the unique h3 ids of the hexagons intersecting your polygon at a given resolution
hex_ids <- h3jsr::polyfill(muni, res = 8, simple = FALSE)

# Available resolutions considerinf length of short diagonal - https://uber.github.io/h3/#/documentation/core-library/resolution-table
# 10 ~136 meters
# 09 ~357
# 08 ~960
# 07 ~2510 meters


# pass the h3 ids to return the hexagonal grid
hex_grid <- unlist(hex_ids$h3_polyfillers) %>% 
  h3jsr::h3_to_polygon(simple = FALSE)

plot(hex_grid)


# # Safe hex grid as sf
# sf::st_write(hex_grid, 
#              dsn = "data/hex_municipio/fortaleza", 
#              layer ='hex_fortaleza', 
#              driver = 'ESRI Shapefile')

readr::write_rds(hex_grid, "../data/hex_municipio/hex_fortaleza.rds")

shape_para_hex <- function(shape) {
  
  # read shape
  # muni <- st_read(dsn = './Shapes_IBGE', layer ='muni')
  muni <- read_sf("../data-raw/municipios/ce/municipios_ce.shp", crs = 4326) %>%
    filter(NM_MUNICIP == "FORTALEZA")
  
  # # projection
  # muni <- st_transform(muni, crs = 4326)
  
  # get the unique h3 ids of the hexagons intersecting your polygon at a given resolution
  hex_ids <- h3jsr::polyfill(muni, res = 8, simple = FALSE)
  
  # Available resolutions considerinf length of short diagonal - https://uber.github.io/h3/#/documentation/core-library/resolution-table
  # 10 ~136 meters
  # 09 ~357
  # 08 ~960
  # 07 ~2510 meters
  
  
  # pass the h3 ids to return the hexagonal grid
  hex_grid <- unlist(hex_ids$h3_polyfillers) %>% 
    h3jsr::h3_to_polygon(simple = FALSE)
  
  plot(hex_grid)
  
  
  # # Safe hex grid as sf
  # sf::st_write(hex_grid, 
  #              dsn = "data/hex_municipio/fortaleza", 
  #              layer ='hex_fortaleza', 
  #              driver = 'ESRI Shapefile')
  
  readr::write_rds(hex_grid, "../data/hex_municipio/hex_fortaleza.rds")
  
  
  
}
