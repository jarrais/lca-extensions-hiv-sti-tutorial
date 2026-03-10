# Advancing the Understanding of Behaviors and Attitudes in HIV and STI Research Through Latent Class Analysis and Its Extensions

This repository contains code, synthetic data, and supplementary materials for the manuscript:

Amorim LD, Arrais J, Soares F, Magno L, Dourado I.  
Advancing the Understanding of Behaviors and Attitudes in HIV and STI Research Through Latent Class Analysis and Its Extensions.

## Overview

Latent class analysis (LCA) and its extensions have become increasingly important in HIV and STI research for identifying unobserved subgroups related to prevention practices, risk behaviors, stigma, and care engagement. This repository accompanies our methodological and applied paper and was designed to support transparent and reproducible research.

The main goal of this repository is to allow readers to reproduce the analytical workflow presented in the article using a synthetic dataset that mirrors the structure of the original study data while preserving confidentiality.

Although this repository is not organized as a standalone tutorial, the scripts were written in a guided and highly annotated style. In addition to reproducing the results, they are intended to help readers understand the main analytical steps, the logic behind model specification, and the role of key function arguments used in each stage of the analysis.

## Purpose of the repository

This repository was created to:

1. reproduce the analyses presented in the paper using a synthetic dataset modeled after the PrEP15 19 study application

2. provide transparent and well documented R scripts that explain the main steps involved in:
   1. data preparation
   2. latent class model estimation
   3. latent class models with covariates
   4. Bayesian latent class analysis
   5. sensitivity analyses
   6. generation of tables and figures

3. offer a reproducible example of how methodological work involving sensitive HIV related data can be shared responsibly through synthetic data and detailed code annotation

## Repository structure

`data/` contains data documentation, variable coding information, and synthetic datasets used to reproduce the analytical workflow

`code/` contains all scripts used to prepare the data, estimate the models, and generate tables and figures

`results/` contains model outputs, tables, figures, and other derived files

## Data availability

The original PrEP15 19 data are not publicly shared through this repository because they contain sensitive information and are subject to ethical and institutional restrictions.

To support transparency and reproducibility, this repository includes:

1. a synthetic dataset with the same analytical structure as the original data

2. a data dictionary describing the variables used in the analyses

3. variable coding information

4. complete scripts for all analyses reported in the manuscript

The synthetic dataset was created exclusively for reproducibility and illustration purposes. Therefore, numerical results obtained from the synthetic data may not exactly match those reported in the manuscript based on the original dataset, but the full analytical pipeline, model specification strategy, and code structure remain reproducible.

Researchers interested in the original data should contact the corresponding authors and will need to comply with all relevant ethical and institutional requirements.

## Reproducibility

All analyses were conducted in R. Package versions can be restored using `renv`.

To reproduce the workflow:

1. clone this repository

2. open the R project file

3. restore the package environment with `renv::restore()`

4. run the scripts in the `code/` folder in numerical order

The scripts were written to be readable and self explanatory, with comments discussing why each step is performed and how key arguments affect estimation and interpretation.

## Main analysis files

`01_data_preparation.R` prepares the synthetic analytic dataset and recodes variables used in the models

`02_lca_measurement_model.R` estimates unconditional latent class models and compares class solutions

`03_lca_with_covariates_onestep.R` fits latent class models with covariates using a one step approach

`04_lca_with_covariates_threestep.R` implements a three step analysis for external variables

`05_bayesian_lca.R` estimates Bayesian latent class models

`06_sensitivity_analysis.R` evaluates the impact of alternative prior specifications and related modeling choices

`07_figures.R` generates manuscript figures

`08_tables.R` generates manuscript tables

## Software

The analyses in this repository rely primarily on R. Depending on the specific stage of the workflow, scripts may use packages such as:

1. `poLCA`

2. `randomLCA`

3. `BayesLCA`

4. `multilevLCA`

5. `tidyverse`

6. `ggplot2`

## Citation

If you use this repository, please cite the manuscript and the corresponding repository release.

## Contact

For questions about the repository or the analytical workflow, please contact:

Jony Arrais Pinto Junior (jarrais@id.uff.br)

## Acknowledgments

We thank the PrEP15 19 study team and participants for making this work possible.
