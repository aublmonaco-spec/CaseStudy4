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
