# ARU Recording Sampler

## Description
A tool for randomly sampling Autonomous Recording Unit (ARU) audio files from the BayneLab server for WildTrax upload. This script allows users to:
- Randomly sample a specified number of recordings (.wav and .wac files) from each location
- Filter recordings by time of day or day of year
- Copy selected files to a designated workspace/folder for upload 
- Provide warnings for any locations with missing files or time range issues

## Input Requirements
- A CSV file with ARU location names (must have a 'Location' column)
- Access to the BayneLab server
- Audio files must follow the naming convention: [SITE][DATE][TIME]

## Required R Packages
```R
install.packages(c("dplyr", "reticulate", "lubridate", "remotes"))
remotes::install_github("ABbiodiversity/wildRtrax")
```
## Usage  
1. Clone this repository or download the script and open in RStudio
2. Ensure all required packages are installed and you have R version 4.4.0 or higher
3. Update the following variables in the script:
 - PATH: Base directory containing ARU recordings
 - file_destination: Where you want the selected files to be copied
 - locations: Path to your CSV file containing location names
 - numberofrecordings <- 5  # Change this to sample more/fewer recordings
