if (!requireNamespace("pak")) install.packages("pak")

## Required packages
pkgs_req <- c("tidyverse", "sf", "leaflet", "here", "conflicted", "usethis", "markdown", "downlit", 
              "xml2", "weathermetrics")

## See which ones are missing
(pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])])

## Install missing ones
if (length(pkgs_missing)) pak::pkg_install(pkgs_missing, dependencies=TRUE)

## tibblify is not on cran right now
if (!require(tibblify)) {
  pak::pkg_install("wranglezone/tibblify")
}

## Compute wet bulb global temperature with HeatStress
if (!require(HeatStress)) {
  pak::pkg_install("anacv/HeatStress")  
}

## opemmeteo is not on cran right now (a dependent package got archived)
if (!require(openmeteo)) {
  install.packages('openmeteo', repos = c('https://tpisel.r-universe.dev', 'https://cloud.r-project.org'))
}




## Re-run the check for missing packages
pkgs_missing <- pkgs_req[!(pkgs_req %in% installed.packages()[,"Package"])]
if (length(pkgs_missing)==0) cat("ALL PACKAGES WERE INSTALLED SUCCESSFULLY \n")


## Compute wet bulb global temperature
if (!require(HeatStress)) {
  pak::pkg_install("anacv/HeatStress")  
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

