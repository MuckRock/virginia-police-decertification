# virginia-police-decertification

This repository contains data and findings for a collaboration between MuckRock and the Virginia Center for Investigative Journalism at WHRO. 

This work is part of MuckRock's larger [project to open up more police disciplinary files across the country](https://www.muckrock.com/project/brady-lists-and-police-disciplinary-files-1177/).  More data and analysis driving the investigations of MuckRock's news team are cataloged in [news-team](https://github.com/MuckRock/news-team).


## Background

### DCJS Decertification List 

MuckRock and VCIJ obtained the database used to track officer decertifications from the Virginia Department of Criminal Justice Services through a public records request.

The data, which also includes decertifications of jail officers, captures disciplinary actions from 1999 to early 2025. Each record includes the officer’s name, law enforcement agency, position at the agency, and the date and reason for decertification. 

To compare rates of decertification among different agencies, we requested [data from Virginia’s Training and Certification Electronic Records (TRACER) database on the total number of certified law enforcement and jail officers](https://www.muckrock.com/foi/virginia-128/licensed-officers-and-total-employees-180642/) employed by each agency in March 2025. We also requested [the data behind the directory of all law enforcement agencies in the state](www.muckrock.com/foi/virginia-128/criminal-justice-agency-directory-180620/). 

These three datasets are the basis of this analysis and can be found in `data/raw`. The datasets are the cleaned and prepared for analysis in `etl` and analyzed in `analysis`. 

## Caveats and Limitations

Laws and policies governing police certification in Virginia have changed since 1999, affecting the number of decertifications. For example, prior to the reforms enacted in 2021, Virginia officers could only be decertified for specific drug or criminal offenses or for failing to complete required training. In 2020, reforms expanded the reasons an officer could be decertified. 

The database includes decertifications before and after recent disciplinary reforms, as well as reinstatements and pending decertifications. We chose not to include pending decertifications in our analysis because pending cases may be in the process of an appeal. 

## Technical Documentation
### General Notes

Much of the data seems to be manually entered into the spreadsheet, which introduced spelling errors to agency names and formatting errors in dates. In [`data/manual`](data/manual) agency names from decertifications are given a crosswalked and corrected name that matches the a name in DCJS' [criminal justice agency directory](data/raw/Criminal_Justice_Agency_Directory.xlsx). Dillon Bergin performed the crosswalk and reporter Emma Rose checked his work. 

The script [`etl/01_clean_dates.R`](etl/01_clean_dates.R) cleans and converts the dates to a single format. 

## Questions / Feedback
Contact Dillon Bergin at dillon@muckrock.com. 
