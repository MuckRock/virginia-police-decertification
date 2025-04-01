library(tidyverse)
library(janitor)
library(here)
library(readxl)
library(tidygeocoder)
library(ggmap)

# make sure key is gone for GitHub and not visible in env 
register_google(key = "AIzaSyDumzJk6Xv2r-WDHs6sGTef-tqsj2H-VnA", write = TRUE)


agency_directory <- read_excel(here("data", "raw", "Criminal_Justice_Agency_Directory.xlsx")) %>% 
  clean_names()
certified_officers <- read_excel(here("data", "raw", "Number_of_Certified_Officers_Per_Agency.xlsx")) %>% 
  clean_names()
decert_sheets <- excel_sheets(here("data","raw", "DCJS_Decertification_List.xlsx"))
decertifications <- read_excel(here("data", "raw", "DCJS_Decertification_List.xlsx"), sheet = 1) %>% 
  row_to_names(row_number = 2) %>% 
  clean_names() %>% 
  # Get rid of placeholder rows for years in Excel styling
  filter(!if_any(first_name, is.na))
crosswalk_corrections <- read_csv(here("data", "manual", "crosswalk_corrections.csv"))



decerts_corrected <- decertifications %>% 
  left_join(crosswalk_corrections, join_by(agency)) %>% 
  mutate(agency_name = case_when(is.na(crosswalk_correction) ~ agency, .default = crosswalk_correction))

write.csv(decerts_corrected, "test_decerts_corrected.csv")

# Check numbers later, but looks like we condensed from 126 total to 106 with fixed agency names 
decert_directory_certs_join <- decerts_corrected %>% 
  group_by(agency_name) %>% 
  summarize(decerts = n()) %>% 
  left_join(certified_officers, join_by(agency_name == place_of_employment)) %>% 
  left_join(agency_directory, join_by(agency_name)) %>% 
  mutate(full_address = paste0(physical_street_address, ", ", physical_city, ", ", physical_state," ", physical_zip))

# wamp only about half geocoded with the free stuff 
#geocoded_df <- decert_directory_certs_join %>% 
  #geocode(full_address, method = 'osm', lat = latitude , long = longitude)


geocoded_df <- decert_directory_certs_join %>% 
  mutate_geocode(location = full_address, output = "latlona")

dw_export <- geocoded_df %>% 
  mutate(rate = decerts/certified_officers_jailors)

write.csv(dw_export, "dw_test.csv")  

