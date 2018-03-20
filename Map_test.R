#Map Test
#Thomas Zwagerman
#17th of March
####

#Packages----
library(readr)  # For reading in files
library(dplyr)  # For formatting and cleaning data
library(rgdal)  # For manipulating map data
library(raster)  # For clipping shapefile polygons
library(ggplot2)  # For drawing plots
library(maps)  # For making maps
library(mapdata)  # For supplying map data
library(gpclib)  # For clipping polygons
library(maptools) # For reading map data
library(rtools)  # Not bundled with R as standard anymore
library(devtools)  # For installing packages from altenative sources, e.g. Github
devtools::install_github("dkahle/ggmap")
devtools::install_github("oswaldosantos/ggsn")
library(ggmap)  # For plotting map data, downloading map tiles from online sources
library(ggsn)  # For adding scalebars and north arrows.

gpclibPermit()

bbox <- c(min(-151.68),
          min(68.16),
          max(-145.4),
          max(70.9))

map_toolik <- get_map(location = bbox, source = "google", maptype = "satellite")
ggmap(map_toolik)

 map_toolik <- borders("world", fill = 'grey90', colour = 'black' )
ggplot() +
  map_toolik +  # Add world map
  #geom_point(data = ,  # Add and plot species data
             #aes(x = , y = decimallatitude, colour = scientificname)) +
  coord_quickmap() +  # Define aspect ratio of the map, so it doesn't get stretched when resizing
  xlim(-160, -120)+
  ylim(40, 80)+
  theme_classic() +  # Remove ugly grey background
  xlab("Longitude") +
  ylab("Latitude")
  #guides(colour=guide_legend(title="Species"))