library(tidyverse)
library(here)
library(janitor)
library(readxl)

present_crosswalk <- read_csv(here("data", "manual", "present_crosswalk_corrections.csv"))
prior_crosswalk <- read_csv(here("data", "manual", "prior_crosswalk_corrections.csv"))
reinstated_crosswalk <- read_csv(here("data", "manual", "reinstated_crosswalk_corrections.csv"))

present <- read_csv(here("data", "processed", "present.csv"))
prior <- read_csv(here("data", "processed", "prior.csv"))
reinstated <- read_csv(here("data", "processed", "reinstated.csv"))

agency_directory <- read_excel(here("data", "raw", "Criminal_Justice_Agency_Directory.xlsx")) %>% 
  clean_names()
certified_officers <- read_excel(here("data", "raw", "Number_of_Certified_Officers_Per_Agency.xlsx")) %>% 
  clean_names()


### JOIN CROSSWALK CORRECTIONS BACK TO ORIGINAL TABLE ###

present_fixed <- present %>% 
  left_join(present_crosswalk, join_by(agency)) %>% 
  mutate(agency_name = case_when(is.na(crosswalk_correction) ~ agency, .default = crosswalk_correction))

prior_fixed <- prior %>% 
  left_join(prior_crosswalk, join_by(agency)) %>% 
  mutate(agency_name = case_when(is.na(crosswalk_correction) ~ agency, .default = crosswalk_correction))

reinstated_fixed <- reinstated %>% 
  left_join(reinstated_crosswalk, join_by(agency)) %>% 
  mutate(agency_name = case_when(is.na(crosswalk_correction) ~ agency, .default = crosswalk_correction))

certified_directory_join <- certified_officers %>% 
  right_join(agency_directory, join_by(place_of_employment == agency_name))

### WRITE TO FOLDER FOR ANALYSIS ###
write.csv(present_fixed, "data/processed/clean_for_analysis/present.csv")
write.csv(prior_fixed, "data/processed/clean_for_analysis/prior.csv")
write.csv(reinstated_fixed, "data/processed/clean_for_analysis/reinstated.csv")
write.csv(certified_directory_join, "data/processed/clean_for_analysis/certified_directory.csv")

