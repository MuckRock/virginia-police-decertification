# virginia-police-decertification

## Background

### DCJS Decertification List 

MuckRock and the Virginia Center for Investigative Journalism obtained data on officers that have been decertified across the state of Virginia. 

The Virginia Department of Criminal Justice Services (DCJS) maintains a list of certified and decertified officers that began in 1999 and has expanded greatly since a shift in regulations went into effect [based on laws changed in 2020](https://legacylis.virginia.gov/cgi-bin/legp604.exe?202+sum+HB5051) in the wake of George Floyd's murder. 

In February 2024, [DCJS provided a similar list to OpenOversightVA](https://openoversightva.org/documents?title=decertification&department=-1&submit=Submit). Later that year, DCJS stopped providing the records (TK?) and the state legislature [closed access to the records about officer reinstatements](https://vcij.org/stories/police-reform-may-expand-in-virginia-but-behind-closed-doors). In September 2024, the nonprofit newsroom [Invisible Institute sued](https://vcij.org/stories/lawsuit-seeks-to-open-up-virginia-police-disciplinary-records) DCJS for withholding the names and other information on certification and disciplinary actions [in response to a public records request](https://www.muckrock.com/foi/virginia-128/police-certification-data-142519/).  In early February of this year, the Virginia Court of Appeals [issued a ruling in a separate case](https://richmond.com/news/local/crime-courts/article_2fdca590-f3a1-11ef-8ef7-839bbe350ec8.html#tracking-source=home-top-story) that the names of law enforcement personnel are not exempt from Virginia's public records law. 

MuckRock and the Virginia Center for Investigative Journalism obtained the most recent list of decertification list through a public records request to the Henrico County Commonwealth Attorney, filed on TK date.  The newsrooms also obtained data on [the number of certified officers as of TK date for each agency through a request to DCJS](https://www.muckrock.com/foi/virginia-128/licensed-officers-and-total-employees-180642/), as well as [a list of all agencies and their physical addresses](https://www.muckrock.com/foi/virginia-128/criminal-justice-agency-directory-180620/). 

These three datasets are the basis of this analysis and can be found in `data/raw`. The datasets are the cleaned and prepared for analysis in `etl` and analyzed in the `analysis`. 

## General Documentation 
### What information do the records provide?

The data includes all decertifications before the 2021 changes as well as all decertifications since, including pending decertifications and officers that have been reinstated. 

Each row of the data is a decertification case, initiated [through a form](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://www.dcjs.virginia.gov/sites/dcjs.virginia.gov/files/law-enforcement/forms/dcjsrequestforledecertificationdc-1pdf.pdf&ved=2ahUKEwjL7IzC86KMAxUqF1kFHfazB3EQFnoECBcQAQ&usg=AOvVaw0K2RC8shL6a77Cg0xNCG8y) with the new laws' reason for decertifications sent to TK. TK should we request all the underyling PDFs attached to forms?

Each decertification includes the officers name, agency game, position at the agency decertification date and reason for decertification. 


## Caveats and Limitations

Changes in and comparing previous data 

## Technical Documentation
### General Notes
- misspellings 
### Column specific notes 

