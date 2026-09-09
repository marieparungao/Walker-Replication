# ------------------------------------------------------------
# Walker et al. Replication
# 02_process_ipeds.R
#
# Purpose:
# Import, clean, and combine IPEDS admissions data
# for 2018-2022
# ------------------------------------------------------------

# Load packages
pacman::p_load(
  tidyverse,
  janitor,
  here,
  readxl
)

# Study years
years <- 2018:2022

# ------------------------------------------------------------
# Inspect IPEDS ZIP contents
# ------------------------------------------------------------

ipeds_folder <- here::here(
  "data",
  "original data",
  "IPEDS"
)

# Find all IPEDS ZIP files
zip_files <- list.files(
  ipeds_folder,
  pattern = "\\.zip$",
  full.names = TRUE
)

# List the files contained inside each ZIP
zip_contents <- purrr::map_dfr(
  zip_files,
  function(zip_file) {
    
    contents <- unzip(
      zip_file,
      list = TRUE
    )
    
    contents |>
      mutate(
        zip_file = basename(zip_file)
      )
  }
)

# Show only the ZIP name and files inside it
zip_contents |>
  select(
    zip_file,
    Name
  ) |>
  as_tibble() |>
  print(n = Inf)

# ------------------------------------------------------------
# Extract selected IPEDS files
# ------------------------------------------------------------

# Create folders for each IPEDS component
adm_folder <- here::here(
  "data",
  "original data",
  "IPEDS",
  "ADM"
)

hd_folder <- here::here(
  "data",
  "original data",
  "IPEDS",
  "HD"
)

efc_folder <- here::here(
  "data",
  "original data",
  "IPEDS",
  "EF-C"
)

dir.create(adm_folder, showWarnings = FALSE)
dir.create(hd_folder, showWarnings = FALSE)
dir.create(efc_folder, showWarnings = FALSE)
# Extract revised ADM files
for (year in years) {
  
  zip_path <- file.path(
    ipeds_folder,
    paste0("ADM", year, ".zip")
  )
  
  file_to_extract <- paste0(
    "adm",
    year,
    "_rv.csv"
  )
  
  unzip(
    zip_path,
    files = file_to_extract,
    exdir = adm_folder
  )
}
# Extract HD files
for (year in years) {
  
  zip_path <- file.path(
    ipeds_folder,
    paste0("HD", year, ".zip")
  )
  
  file_to_extract <- paste0(
    "hd",
    year,
    ".csv"
  )
  
  unzip(
    zip_path,
    files = file_to_extract,
    exdir = hd_folder
  )
}
# Extract revised EF-C files
for (year in years) {
  
  zip_path <- file.path(
    ipeds_folder,
    paste0("EF", year, "C.zip")
  )
  
  file_to_extract <- paste0(
    "ef",
    year,
    "c_rv.csv"
  )
  
  unzip(
    zip_path,
    files = file_to_extract,
    exdir = efc_folder
  )
}

# ------------------------------------------------------------
# Import U.S. News rankings data
# ------------------------------------------------------------

# Set path to original data folder
data.path <- here::here(
  "data",
  "original data"
)

# Import rankings workbook
df.rank <- readxl::read_excel(
  here::here(
    data.path,
    "USNWR.xlsx"
  )
)
# Keep variables needed for the Walker replication
df.rank <- df.rank |>
  transmute(
    unitid = as.integer(IPEDS),
    university = `University Name`,
    state = State,
    rank_2023 = `2023`
  ) |>
  filter(
    rank_2023 <= 100
  ) |>
  arrange(
    rank_2023,
    university
  )