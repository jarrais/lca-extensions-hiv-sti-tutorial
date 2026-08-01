# Advancing the Understanding of HIV-Related Behaviors and Prevention Practices Through Latent Class Analysis and Its Extensions

This repository contains Mplus files, R scripts, and simulated data developed to accompany the manuscript:

Amorim LD, Arrais J, Soares F, Magno L, Dourado I.  
*Advancing the Understanding of HIV-Related Behaviors and Prevention Practices Through Latent Class Analysis and Its Extensions.*

## Overview

Latent class analysis (LCA) and its extensions are useful for identifying unobserved population subgroups characterized by distinct patterns of behaviors or practices. In HIV and sexually transmitted infection (STI) research, these methods can help investigate patterns related to prevention practices, risk behaviors, stigma, and engagement in care.

This repository accompanies the methodological and applied analyses presented in the manuscript. It includes Mplus input and output files associated with Tables 4, 5, and 6, annotated R scripts for latent class models and their extensions, and a dedicated `Simulated-data/` directory containing the simulated datasets required to reproduce the analytical workflow without access to confidential participant-level data.

The simulated datasets follow the analytical structure and variable coding of the original PrEP15-19 data. They were created for reproducibility and methodological illustration and do not contain records from study participants. Consequently, numerical results obtained from the simulated data are not expected to exactly match the results reported in the manuscript using the original data.

## Purpose of the repository

This repository was created to:

1. document the latent class analyses associated with Tables 4, 5, and 6 of the manuscript;
2. provide the corresponding Mplus syntax and output for analyses based on the original and simulated data;
3. provide annotated R scripts for conventional and Bayesian latent class analyses using simulated data;
4. support transparent and reproducible applications of LCA and LCA with covariates in HIV and STI research; and
5. demonstrate how analytical workflows involving sensitive health data can be shared responsibly through simulated data and detailed code documentation.

## Repository structure

```text
.
├── Mplus/
│   ├── Real data/
│   │   ├── Table 4/
│   │   │   ├── LCA-PrEPdata.inp
│   │   │   └── LCA-PrEPdata.out
│   │   ├── Table 5/
│   │   │   ├── LCA-cov-PrEPdata.inp
│   │   │   └── LCA-cov-PrEPdata.out
│   │   └── Table 6/
│   │   │   ├── LCA-Distal-Outcomes-step1.inp
│   │   │   └── LCA-Distal-Outcomes-step1.out
│   │   │   ├── LCA-Distal-Outcomes-step3.inp
│   │   │   └── LCA-Distal-Outcomes-step3.out
│   └── Simulated data/
│       ├── Table 4/
│       │   ├── DataPrEP_LCA-sim.inp
│       │   └── DataPrEP_LCA-sim.out
│       ├── Table 5/
│       │   ├── DataPrEP_LCA-cov-sim.inp
│       │   └── DataPrEP_LCA-cov-sim.out
│       └── Table 6/
│           ├── DataPrEP_LCA-distal outcome-sim-step1.inp
│           └── DataPrEP_LCA-distal outcome-sim-step1.out
│           ├── DataPrEP_LCA-distal outcome-sim-step3.inp
│           └── DataPrEP_LCA-distal outcome-sim-step3.out
├── Rcode/
│   ├── 01_packages.R
│   ├── 02_latent_class_model_estimation.R
│   ├── 03_lca_with_covariates_onestep.R
│   └── 04_bayesian_latent_class_model.R
└── Simulated-data/
    ├── dataPREP-sim-v0.dat
    ├── dataPREP-sim-v1.dat
    └── dataPREP-sim-v2.dat
```

The bracketed filenames in this diagram should be replaced with the exact filenames used in the repository.

### `Mplus/`

The `Mplus` directory contains the model files associated with Tables 4, 5, and 6 of the manuscript. It is divided into two subdirectories:

- `Real data/` contains the Mplus input (`.inp`) and output (`.out`) files for analyses based on the original PrEP15-19 data.
- `Simulated data/` contains the corresponding Mplus input and output files for analyses based on the simulated data.

Within each subdirectory, files are organized by manuscript table. Each table folder contains an `.inp` file documenting the Mplus syntax and estimation settings and an `.out` file containing the corresponding model results.

The `Real data/` directory contains analysis syntax and model output, but it does **not** contain the original participant-level dataset.

### `Rcode/`

The `Rcode` directory contains four annotated R scripts:

- a script that loads the packages required for the analyses;
- a script that imports and prepares the simulated data, estimates the latent class models, compares alternative class solutions, and extracts the principal results;
- a script that fits latent class models with covariates using the simulated data; and
- a script that performs Bayesian latent class analysis.

The scripts include comments explaining the main analytical steps, model specifications, and relevant function arguments. There is no separate Bayesian sensitivity-analysis script in this repository.

### `Simulated-data/`

The `Simulated-data` directory is a separate top-level folder containing the simulated datasets used by the R scripts and by the corresponding Mplus analyses. These datasets reproduce the structures and variable codings required by the different stages of the analytical workflow while protecting the confidentiality of the original study participants.

Keeping the simulated datasets in this dedicated directory separates the data files from the analytical code in `Rcode/` and from the Mplus syntax and output files in `Mplus/`.

## Mplus files and manuscript tables

For each of Tables 4, 5, and 6, the repository provides:

- the Mplus input and output files generated from the original data, under `Mplus/Real data/`; and
- the equivalent Mplus input and output files generated from the simulated data, under `Mplus/Simulated data/`.

This organization allows readers to inspect the specifications and reported results based on the original data and to examine the equivalent implementation using the simulated dataset.

## Data availability and confidentiality

The original PrEP15-19 participant-level data are not publicly available through this repository because they contain sensitive information and are subject to ethical and institutional restrictions.

To support reproducibility, the repository provides simulated datasets in `Simulated-data/` with the structures and variable codings required by the analytical scripts. The simulated data were created exclusively for reproducibility, teaching, and methodological illustration. They do not reproduce the original participant records, and results obtained from them may differ from the estimates reported in the manuscript.

Researchers interested in requesting access to the original data should contact the corresponding authors and comply with the applicable ethical, institutional, and data-sharing requirements.

## Reproducing the analyses with simulated data

### R

To reproduce the workflow in R:

1. clone or download this repository;
2. open R with the repository root as the working directory;
3. run the package-loading script in `Rcode/`;
4. run the LCA script in `Rcode/`;
5. run the LCA-with-covariates script in `Rcode/`; and
6. run the Bayesian LCA script in `Rcode/` when reproducing the Bayesian analysis.

The analytical scripts are configured for the appropriate datasets stored in `Simulated-data/`. Package availability, package versions, random starting values, and simulation settings may affect numerical results.

### Mplus

To reproduce the Mplus analyses using simulated data, open the appropriate `.inp` file under `Mplus/Simulated data/Table 4`, `Table 5`, or `Table 6` and confirm that its data-file path points to the corresponding dataset stored in `Simulated-data/`.

The `.out` files are included so that the model results can be inspected without rerunning the analyses. A licensed installation of Mplus is required to execute the `.inp` files.

## Software

The analyses were implemented in Mplus and R. The required R packages are documented in the package-loading script located in `Rcode/`.

## Citation

If you use the code or materials from this repository, please cite the manuscript and the corresponding repository release.

## Contact

For questions about the repository or the analytical workflow, please contact:

Jony Arrais Pinto Junior  
Email: jarrais@id.uff.br

## Acknowledgments

We thank the PrEP15-19 study team and participants for making this work possible.
To support transparency and reproducibility, this repository includes:

1. a synthetic dataset with the same analytical structure as the original data

2. complete scripts for all analyses reported in the manuscript

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

`01_packages.R` loads the R packages required for data import, data management, latent class model estimation, and presentation of the results.

`02_lca_measurement_model.R` estimates unconditional latent class models and compares class solutions

`03_lca_with_covariates_onestep.R` fits latent class models with covariates using a one step approach

`04_bayesian_lca.R` estimates Bayesian latent class models

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
