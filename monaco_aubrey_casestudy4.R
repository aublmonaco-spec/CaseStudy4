library(tidyverse)
library(nycflights13)
library(sf)
library(spData)
library(dplyr)

View(flights)
View(airports)
JFK_flights <- filter(flights, origin == "JFK")

JFK_flights <- JFK_flights %>% arrange(desc(distance))

JFK_flights <- JFK_flights %>%
  rename(faa = dest)

joined_flights_airports <- left_join(JFK_flights, airports)

farthest_JFK <- slice_head(joined_flights_airports)
View(farthest_JFK)

joined_flights_airports <- joined_flights_airports %>%
  rename(dest = faa) %>%
  rename(dest_name = name)

farthest_JFK <- farthest_JFK %>%
  rename(dest = faa,
         dest_name = name)

farthest_airport <- farthest_JFK$dest_name
sf_airports <- st_as_sf(airports, coords = c("lon", "lat"), crs = 4326)
st_crs(sf_airports)

JFK_airport <- filter(sf_airports, faa == "JFK")

airport_map <- ggplot() + geom_sf(data = world) + geom_sf(data = sf_airports) + geom_sf(data = JFK_airport, aes(color = "red")) + geom_point(data = farthest_JFK, aes(x = lon, y = lat, color = "blue"))

airport_map + coord_sf()
