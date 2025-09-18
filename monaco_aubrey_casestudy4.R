library(tidyverse)
library(nycflights13)
library(sf)
library(spData)
library(dplyr)

View(flights)
View(airports)

#This step is filtering out all flights except those leaving from JFK in the "flights" table
JFK_flights <- filter(flights, origin == "JFK")

#This step is arranging the "flights" table from greatest distance to least distance
JFK_flights <- JFK_flights %>% arrange(desc(distance))

#This step is renaming the the "dest" column in "JFK_flights" to "faa" to match with the "airports" table
JFK_flights <- JFK_flights %>%
  rename(faa = dest)

#This step is joining the "JFK_flights" and "airports" table by the "faa" column
joined_flights_airports <- left_join(JFK_flights, airports)

#This step is taking out the row of data that shows the airport with the greatest distance to JFK
farthest_JFK <- slice_head(joined_flights_airports)
View(farthest_JFK)

#This step is revertin the names in the "farthest_JFK" data for clarity 
farthest_JFK <- farthest_JFK %>%
  rename(dest = faa,
         dest_name = name)

#This step is filtering "airports" to only choose airports that interact with JFK
airports_filtered <- airports %>% inner_join(joined_flights_airports)

#This step is reverting back to the previous column names for clarity
joined_flights_airports <- joined_flights_airports %>%
  rename(dest = faa,
         dest_name = name)

#This step is taking the name of the farthest airport and making it an object
farthest_airport <- farthest_JFK$dest_name

#This step is converting the "airports_filtered" table into a spatial object; I also added the proper coordinate system
sf_airports <- st_as_sf(airports_filtered, coords = c("lon", "lat"), crs = 4326)
#I used this function to double check the data frame's coordinate system
st_crs(sf_airports)

#This step created a point to highlight the JFK airport
JFK_airport <- filter(airports, faa == "JFK")

#For this map, I used geom_sf for the basemap and the "sf_airports" data, since they are spatial, then I used geom_point for the JFK_airport and farthest_JFK data. I specified for the point layers that the x-axis is based on longitude and the y-axis is based on latitude. I also added labels to the legend. Scale_color_hue allowed me to change the labels within the legend. 
airport_map <- ggplot() + geom_sf(data = world) + geom_sf(data = sf_airports, aes(color = "black")) + geom_point(data = JFK_airport, aes(x = lon, y = lat, color = "blue")) + geom_point(data = farthest_JFK, aes(x = lon, y = lat, color = "red")) + labs(title = "Global Airports With NYC Origins", x = "Longitude", y = "Latitude", color = "Airport Type") + scale_color_hue(labels = c("black" = "Other Destinations", "blue" = "JFK", "red" = "Farthest Airport"))

#This step helped create a proper map view of my map
airport_map + coord_sf()
