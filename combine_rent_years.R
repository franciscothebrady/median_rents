# median rents 
# using HUD 50th percentile rents
# NOTE: I downloaded these files from the HUD User site 
# https://www.huduser.gov/portal/datasets/50per.html
# and cleaned up the names a little bit to standardize processing.
# the naming convention i picked (and HUD should stick with...):
# FY[YYYY]_50_County.xlsx

# load libraries
library(ggplot2)
library(tidyr)
library(readxl)
library(maps)
library(dplyr)
library(stringr)
# project directory
# "../rents"

# build a list of excel files (both xlsx and xls)
file_list <- list.files(pattern = ".xls*")

# define function to clean and reshape file
combine_years <- function(file_list) {
  require(readxl)
  require(ggplot2)
  require(dplyr)
  print(file_list)
  
data <- read_excel(file_list) %>%
  mutate(year = regmatches(file_list, gregexpr("[[:digit:]]{4}", file_list))[[1]][1],
         # first we extract the first 5 digits from the fips code (leading zeros)
         # then we convert to numeric and merge with the county.fips dataset (preloaded)
         fips = as.numeric(str_extract(string = fips, pattern = "[0-9]{5}"))) %>%
  # merge by fips code
  inner_join(county.fips, by = c("fips" = "fips")) %>%
  # separate county, state into subregion, region
  separate(polyname, into = c("region", "subregion"), sep = ",") %>%
  # merge again with map_data that has the lat/long combinations
  inner_join(map_data("county"), c("region", "subregion")) %>%
  # select only the variables we care about 
  select(year,
         fips = contains("fips"),
         pop  = contains("pop"),
         contains("rent"),
         region, subregion, long, lat, 
         group, order) %>%
  gather(key = "type", value = "median_rent", 
         -fips, -pop,
         # these are for mapping
         -region, -subregion, -group, 
         -order, -long, -lat, -year) %>%
  # tolower
  mutate(type = tolower(type)) %>%
  # recode apt_type variable to reflect # of bedrooms
  mutate(type = case_when(type == "rent50_0" ~ "studio",
                          type == "rent50_1" ~ "1 bedroom",
                          type == "rent50_2" ~ "2 bedroom",
                          type == "rent50_3" ~ "3 bedroom",
                          type == "rent50_4" ~ "4 bedroom"))
  
}

median_rents <- lapply(file_list[1:6], combine_years)
# median_rents <- purrr::lmap(.x = file_list[1:6], .f = combine_years)
# median_rents[[]]

# unique(median_rents[[1]]$year)
# median_rents %>% select(year == )
# to combine the list into a big old dataframe
rents_df <- dplyr::bind_rows(median_rents)

### plot it on a map!
# median_rents %>% 
#   # filter to year and number of bedrooms
#   dplyr::filter(type == input$type,
#                 year == input$year) %>%
#   ggplot() +
#   geom_polygon(aes(x = long, y = lat, group = group, 
#                    fill = median_rent), 
#                colour="darkgray", size=.1) +
#   scale_fill_gradientn(colours = c("darkgreen","orange","red")) +
#   coord_fixed(1.3) + theme_void()
# 
# 
