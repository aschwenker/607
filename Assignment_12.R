library(ggplot2)
library(dplyr)
library(maps)
library(ggmap)
library(mongolite)
library(lubridate)
library(gridExtra)
library(nycflights13)

mongod

head(flights)

Flights_Collection = mongo(collection = "flights", db = "NYC")
