###############################################################
# 01_packages.R
#
# This script installs (if necessary) and loads all R packages
# required to reproduce the analyses presented in the paper:
#
# "Advancing the Understanding of Behaviors and Attitudes in
# HIV and STI Research Through Latent Class Analysis and Its
# Extensions"
#
# The goal is to ensure that users can run all scripts even if
# the required packages are not already installed on their system.
###############################################################


# -------------------------------------------------------------
# 1. List of required packages
# -------------------------------------------------------------

required_packages <- c(
  "readxl",
  "dplyr",
  "tidyr",
  "poLCA",
  "poLCAParallel",
  "BayesLCA",
  "ggplot2",
  "stringr",
  "multilevLCA"
)


# -------------------------------------------------------------
# 2. Install packages if they are not already installed
# -------------------------------------------------------------

installed_packages <- installed.packages()[, "Package"]

for (pkg in required_packages) {
  
  if (!(pkg %in% installed_packages)) {
    
    install.packages(pkg)
    
  }
  
}


# -------------------------------------------------------------
# 3. Load all packages
# -------------------------------------------------------------

library(readxl)
library(dplyr)
library(tidyr)
library(poLCAParallel)
library(poLCA)
library(BayesLCA)
library(ggplot2)
library(stringr)
library(multilevLCA)


# -------------------------------------------------------------
# 4. Session information (optional but recommended)
# -------------------------------------------------------------

sessionInfo()
