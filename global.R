library(shiny)
library(leaflet)
library(bslib) # themes
library(tidyverse)
library(janitor) # clean column names
library(ISOcodes) # ISO country/province codes
library(sf) # spatial functions
library(kableExtra) # pretty tables

# Raw personal eBird data
dat_personal <- read_csv("./data/MyEBirdData.csv") %>%
  clean_names() %>%
  mutate(year = year(date))

# eBird taxonomy
dat_taxonomy <- read_csv("./data/eBird_taxonomy_v2024.csv") %>%
  clean_names() %>%
  separate(family, c("family", "family_common_name"), sep = "\\(|\\)") %>%
  select(-taxon_concept_id, -report_as)

# ISO codes
iso_country <- ISO_3166_1 %>%
  clean_names() %>%
  mutate(country = if_else(is.na(common_name), name, common_name)) %>%
  select("country_code"=alpha_2, country)
iso_province <- ISO_3166_2 %>%
  rename(province_code = Code, province = Name, province_type = Type) %>%
  mutate(country_code = str_sub(province_code, end=2)) %>%
  select(-Parent)
dat_iso <- full_join(iso_country, iso_province, by = "country_code")

# Combine personal data, taxonomy, and ISO codes
dat_all <- left_join(dat_personal, dat_taxonomy,
                     by = c("scientific_name"="sci_name")) %>%
  left_join(dat_iso,
            by = c("state_province"="province_code")) %>%
  select(-primary_com_name, -country_code)

# Make into spatial sf dataframe
dat_sf <- st_as_sf(dat_all, coords = c("longitude","latitude")) %>%
  st_set_crs(4326) # set CRS to WGS84
