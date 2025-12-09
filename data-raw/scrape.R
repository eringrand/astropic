library(astropic)
library(lubridate)
library(readr)
library(glue)
library(dplyr)

# Set up what days we want data
today <- today() - 1
today_pic <- get_apod(query = list(date = today))

data("hist_apod")

hist_apod <- hist_apod |> 
  bind_rows(today_pic) |> 
  distinct()

# Push Data to Package
usethis::use_data(hist_apod, overwrite = TRUE)