library(tidyverse)
library(janitor)
library(here)
library(readxl)


agency_directory <- read_excel(here("data", "Criminal_Justice_Agency_Directory.xlsx")) %>% 
  clean_names()
certified_officers <- read_excel(here("data", "Number_of_Certified_Officers_Per_Agency.xlsx")) %>% 
  clean_names()
decert_sheets <- excel_sheets(here("data", "DCJS_Decertification_List.xlsx"))
sheet_one <- read_excel(here("data", "DCJS_Decertification_List.xlsx"), sheet = 1)
# Second sheet is very slow cuz text?
two_df <- read_excel(here("data", "DCJS_Decertification_List.xlsx"), sheet = 2)
three_df <- read_excel(here("data", "DCJS_Decertification_List.xlsx"), sheet = 3)
four_df <- read_excel(here("data", "DCJS_Decertification_List.xlsx"), sheet = 4)


decerts <- sheet_one %>% 
  row_to_names(row_number = 2) %>% 
  clean_names() %>% 
  # Get rid of placeholder rows for years in Excel styling
  filter(!if_any(first_name, is.na))
 
  
# So we have 278 decertifications 

# No duplicates of names unless there are misspellings that would need to be spot checked
dupe_check <- decerts %>% 
  group_by(first_name, middle_initial, last_name) %>% 
  summarize(total = n())

# 126 total agencies represented in data
agency_totals <- decerts %>% 
  group_by(agency) %>% 
  summarize(total = n())

# To export for crosswalk
unique_decert_agencies <- decerts %>% 
  distinct(agency)

unique_agency_directory <- agency_directory %>% 
  distinct(agency_name)

non_matches <- unique_decert_agencies %>% 
  anti_join(unique_agency_directory, join_by(agency == agency_name))

write.csv(unique_decert_agencies, "unique_decert_agencies.csv")
write.csv(unique_agency_directory, "unique_agency_directory.csv")
write.csv(non_matches, "non_matches.csv")

# Looks like most agencies have just one or two decerts, would be useful to histogram for quarto to show distribution 



# Let's test joins from decerts, to certified officers, to agency directory 

# First, let's try decerts to certified officers
# Ok so problem is that only 70 of 126 agencys from decerts matched a name in the certified officers table
missing_agencies <- agency_totals %>% 
  anti_join(certified_officers, join_by(agency == place_of_employment))


# And unfortunately, there are agency names spelled wrong too i.e. Albemarle- Charlottseville Regional Jail instead of Albermarle-Charlottesville Regional Jail
# And maybe things like Alexandria County Sheriff's Office and Alexandria Sheriff's Office are the same?
# So we know that the decerts data has misspellings and errors, let's check the other two datasets 
# Newport News Cheriff's Office ... 

# Well first off, agency directory has 512 agencies while there are only 374 unique agencies for the certified officers data
# ^ Why is that?

# The easy way first: do all certified officer agencies have a match in the agency directory?
# Well good, all certified officer agencies have a join in the directory, except one: Emory & Henry University Police Department
certified_directory_join <- certified_officers %>% 
  inner_join(agency_directory, join_by(place_of_employment == agency_name))








