if (!requireNamespace("pak")) install.packages("pak")

## Required packages
pkgs_req <- c("tidyverse", "here", "conflicted", "usethis", "markdown", "downlit", "xml2", "weathermetrics", "openmeteo")

## See which ones are missing
(pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])])

## Install missing ones
if (length(pkgs_missing)) pak::pkg_install(pkgs_missing, dependencies=TRUE)

## Re-run the check for missing packages
pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])]
if (length(pkgs_missing)==0) cat("ALL PACKAGES WERE INSTALLED SUCCESSFULLY \n")


## Compute wet bulb global temperature
if (!require(HeatStress)) {
  remotes::install_github("anacv/HeatStress")  
}



##########################################
## TIPS
##
## If you are prompted by the question, 'Do you want to install from sources the 
## package which needs compilation?', select 'No'.
##
## If you get an error message that a package can't be installed because 
## it's already loaded and can't be stopped, restart R (Session >> Restart R), 
## and try again.
##
##########################################

