library(tidyverse)
library(here)
library(janitor)
library(readxl)

present_crosswalk <- read_csv(here("data", "manual", "present_crosswalk_corrections.csv"))
prior_crosswalk <- read_csv(here("data", "manual", "prior_crosswalk_corrections.csv"))
reinstated_crosswalk <- read_csv(here("data", "manual", "reinstated_crosswalk_corrections.csv"))

present <- read_csv(here("data", "processed","etl", "present.csv"))
prior <- read_csv(here("data", "processed","etl", "prior.csv"))
reinstated <- read_csv(here("data", "processed", "etl", "reinstated.csv"))

agency_directory <- read_excel(here("data", "raw", "Criminal_Justice_Agency_Directory.xlsx")) %>% 
  clean_names()
certified_officers <- read_excel(here("data", "raw", "Number_of_Certified_Officers_Per_Agency.xlsx")) %>%
  clean_names()


### JOIN CROSSWALK CORRECTIONS BACK TO ORIGINAL TABLE ###

present_fixed <- present %>% 
  left_join(present_crosswalk, by = "agency") %>% 
  mutate(agency_name = case_when(
    !is.na(crosswalk_correction) ~ crosswalk_correction,
    # Two agencies names are still encoding weird after crosswalk correction and need to be hardcoded
    last_name == "Rohwer" & first_name == "William" ~ "Fauquier County Sheriff's Office",
    last_name == "Williams" & first_name == "Dustin" ~ "Montgomery County Sheriff`s Office",
    TRUE ~ agency))  

prior_fixed <- prior %>% 
  left_join(prior_crosswalk, join_by(agency)) %>% 
  mutate(agency_name = case_when(is.na(crosswalk_correction) ~ agency, .default = crosswalk_correction))

reinstated_fixed <- reinstated %>% 
  left_join(reinstated_crosswalk, join_by(agency)) %>% 
  mutate(agency_name = case_when(is.na(crosswalk_correction) ~ agency, .default = crosswalk_correction))

certified_directory_join <- certified_officers %>% 
  right_join(agency_directory, join_by(place_of_employment == agency_name))

### WRITE TO FOLDER FOR ANALYSIS ###
write.csv(present_fixed, "../data/processed/analysis/present.csv")
write.csv(prior_fixed, "../data/processed/analysis/prior.csv")
write.csv(reinstated_fixed, "../data/processed/analysis/reinstated.csv")
write.csv(certified_directory_join, "../data/processed/analysis/certified_directory.csv")

