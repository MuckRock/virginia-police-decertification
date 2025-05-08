library(tidyverse)
library(here)
library(janitor)
library(readxl)

# Read in data with clean dates
present <- read_csv(here("data", "processed", "etl", "present.csv"))
prior <- read_csv(here("data", "processed", "etl", "prior.csv"))
reinstated <- read_csv(here("data", "processed", "etl", "reinstated.csv"))

# Read tables with general info for each agency
agency_directory <- read_excel(here("data", "raw", "Criminal_Justice_Agency_Directory.xlsx")) %>% 
  clean_names()
certified_officers <- read_excel(here("data", "raw", "Number_of_Certified_Officers_Per_Agency.xlsx")) %>% 
  clean_names()

### JOIN AGENCY DIRECTORY AND CERTIFIED OFFICER TABLES ###
#All certified officer agencies have a join in the directory, except one: Emory & Henry University Police Department
certified_directory_join <- certified_officers %>% 
  right_join(agency_directory, join_by(place_of_employment == agency_name))

# Agencies that don't have a certified officer number
agencies_missing_cert_num <- agency_directory %>% 
  anti_join(certified_officers, join_by(agency_name == place_of_employment))

### CHECK MATCHES IN PRESENT TABLE ###
# 134 unique agencies in Present
present_agencies <- present %>% 
  distinct(agency)
# 57 agencies that don't have a match and need to be manually crosswalked
present_join <- present_agencies %>% 
  anti_join(certified_directory_join, join_by(agency == place_of_employment))

### CHECK MATCHES IN PRIOR TABLE ###
# 43 unique agencies in Prior 
prior_agencies <- prior %>% 
  distinct(agency)
# 15 agencies that don't have a match and need to be manually crosswalked
prior_join <- prior_agencies %>% 
  anti_join(certified_directory_join, join_by(agency == place_of_employment))

### CHECK MATCHES IN REINSTATED TABLE ###
# 38 unique agencies in Prior 
reinstated_agencies <- reinstated %>% 
  distinct(agency)
# 14 agencies that don't have a match and need to be manually crosswalked
reinstated_join <- reinstated_agencies %>% 
  anti_join(certified_directory_join, join_by(agency == place_of_employment))


### EXPORT NONMATCHES TO CROSSWALK ###
write.csv(present_join, "../data/processed/etl/unmatched_present.csv")
write.csv(prior_join, "../data/processed/etl/unmatched_prior.csv")
write.csv(reinstated_join, "../data/processed/etl/unmatched_reinstated.csv")
write.csv(certified_directory_join, "../data/processed/etl/directory_crosswalk.csv")
