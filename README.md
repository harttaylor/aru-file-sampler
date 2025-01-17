# ARU Recording Sampler

## Description
A tool for randomly sampling Autonomous Recording Unit (ARU) audio files from the BayneLab server for WildTrax upload. This script allows users to:
- Randomly sample audio recordings (.wav and .wac files) from specified locations
- Filter recordings by time of day
- Automatically copy selected files to a designated workspace

## Prerequisites
- R (version 4.4.0 or higher)
- RStudio (recommended)

## Required R Packages
```R
install.packages(c("dplyr", "reticulate", "lubridate", "remotes"))
remotes::install_github("ABbiodiversity/wildRtrax")
