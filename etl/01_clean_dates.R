library(tidyverse)
library(here)
library(janitor)
library(readxl)
library(lubridate)
library(stringr)

# Dates in each sheet of decertifications need to be standardized to compare: 
# Finalized - 2021 to Present
# Pending Conclusion: This sheet can be left alone, for now we aren't using the pending data
# 2020 & Prior 
# Reinstated - 2021 to Present


### FINALIZED - 2021 TO PRESENT ###
present <- read_excel(here("data", "raw", "DCJS_Decertification_List.xlsx"), sheet = 1) %>% 
  row_to_names(row_number = 2) %>% 
  clean_names() %>% 
  # Get rid of placeholder rows for years in Excel styling
  filter(!if_any(first_name, is.na)) %>% 
  mutate(fixed_date = case_when(
    # One date looks like a data entry error
    decert_date == "10/04/0222" ~ as.Date("10/04/2022", format = "%m/%d/%Y"),
    .default = as.Date(as.numeric(decert_date), origin = "1899-12-30")))

### 2020 & PRIOR 
prior <- read_excel(here("data", "raw", "DCJS_Decertification_List.xlsx"), sheet = 3, range = "A1:H83") %>% 
  row_to_names(row_number = 1) %>% 
  clean_names() %>% 
  mutate(fixed_date = case_when(
    # One date looks like a data entry error
    decert_date == "11/02/20217" ~ as.Date("11/02/2017", format = "%m/%d/%Y"),
    .default = as.Date(as.numeric(decert_date), origin = "1899-12-30")))

### REINSTATED - 2021 TO PRESENT
reinstated <- read_excel(here("data", "raw", "DCJS_Decertification_List.xlsx"), sheet = 4, range = "A1:G47") %>% 
  row_to_names(row_number = 1) %>% 
  clean_names() %>% 
  # Get rid of placeholder rows for years in Excel styling
  filter(!if_any(first_name, is.na)) %>% 
  mutate(recert_date = parse_date_time(str_extract(status, "\\d{4}-\\d{2}-\\d{2}|\\d{2}/\\d{2}/\\d{4}|\\d{2}-\\d{2}-\\d{4}|[A-Za-z]+ \\d{1,2}, \\d{4}"), "mdy"))


write.csv(present, "../data/processed/present.csv")
write.csv(prior, "../data/processed/prior.csv")
write.csv(reinstated, "../data/processed/reinstated.csv")

