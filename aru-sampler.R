################################################################################
# Random Audio Recording Sampler for WildTrax Upload
################################################################################
# This script:
# 1. Takes a list of ARU locations
# 2. Searches for both .wav and .wac files at each location
# 3. Filters recordings to only include those between 4am-10am- adjust for your needs
# 4. Randomly samples a specified number of recordings per location
# 5. Copies selected files to a destination folder for WildTrax upload
################################################################################

# Load required packages
library(dplyr)
library(reticulate)
library(lubridate)
library(wildrtrax)

###############
# VARIABLES
###############
# Base directory containing ARU recordings
PATH <- "Y:/BU/ARU/OGR/2024/V1/"

# Number of recordings to randomly sample per location
numberofrecordings <- 5

# Destination folder for selected recordings
file_destination <- "Z:/BayneLabWorkSpace/Taylor_workspace/OGR2024WildTraxUpload/Recordings"

# Read location list (expecting CSV with a Location column)
locations <- read.csv("Z:/BayneLabWorkSpace/Taylor_workspace/OGR2024WildTraxUpload/OGR-2024-Locations.csv")
# Clean column names from WildTrax download format
colnames(locations)[1] <- gsub('^...','',colnames(locations)[1])

# Extract location list
locs <- locations$Location

###############
# MAIN LOOP
###############
for(i in 1:length(locs)) {
  location <- locs[i]
  current_path <- paste0(PATH, location, "/")
  
  # Scan for both wav and wac files
  wav_files <- tryCatch({
    wt_audio_scanner(current_path, file_type = "wav")
  }, error = function(e) NULL)
  
  wac_files <- tryCatch({
    wt_audio_scanner(current_path, file_type = "wac")
  }, error = function(e) NULL)
  
  # Combine files if both types exist
  files <- if(!is.null(wav_files) && !is.null(wac_files)) {
    bind_rows(wav_files, wac_files)
  } else if(!is.null(wav_files)) {
    wav_files
  } else if(!is.null(wac_files)) {
    wac_files
  } else {
    NULL
  }
  
  # Process files if any were found
  if(!is.null(files) && nrow(files) > 0) {
    # Filter for morning recordings (4am-10am)
    files <- files %>%
      mutate(hour = hour(recording_date_time)) %>%
      filter(hour %in% 4:10)
    
    if(nrow(files) > 0) {
      # Randomly sample recordings
      sample <- sample_n(files, min(numberofrecordings, nrow(files)), replace = TRUE)
      
      # Create full paths for source and destination
      sample <- sample %>%
        mutate(full_source_path = file.path(current_path, basename(file_path)),
               full_dest_path = file.path(file_destination, basename(file_path)))
      
      # Copy files to destination
      mapply(file.copy, 
             from = sample$full_source_path,
             to = sample$full_dest_path,
             overwrite = TRUE)
    } else {
      warning(paste("No files found in time range (4am-10am) for location:", location))
    }
  } else {
    warning(paste("No audio files found for location:", location))
  }
}

cat("\nProcessing complete! Check warnings above for any locations that couldn't be processed.\n")

