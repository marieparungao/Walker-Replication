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
  here
)

# Study years
years <- 2018:2022