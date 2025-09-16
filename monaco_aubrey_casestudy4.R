library(tidyverse)
library(nycflights13)
library(sf)
library(spData)
library(dplyr)

View(flights)
View(airports)
flight_table <- View(flights)
JFK_flights <- filter(flights, origin == "JFK")

JFK_flights <- JFK_flights %>% arrange(desc(distance))

farthest_JFK <- slice_head(JFK_flights)
View(farthest_JFK)
