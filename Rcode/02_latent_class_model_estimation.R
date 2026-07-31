###############################################################
# 02_latent_class_model_estimation.R
#
# This script reproduces the latent class analysis (LCA)
# presented in the manuscript.
#
# The goal is to identify latent profiles of HIV prevention
# practices among adolescents in the PrEP15-19 study.
#
# The script estimates latent class models with 1 to 4 classes
# and extracts the information necessary to reproduce:
#
# Table 2 – Model fit statistics
# Table 3 – Item-response probabilities by class
#
# The code is written with extensive comments so that
# applied researchers in HIV and STI research can follow
# each step of the analysis.
#
# This script assumes that:
# 1. 01_packages.R has already been executed
###############################################################

# -------------------------------------------------------------
# 1. Load the dataset
# -------------------------------------------------------------

# The synthetic dataset included in this repository mirrors the
# structure of the original PrEP15-19 dataset used in the paper.

base <- readxl::read_xlsx("data/prep1519_synthetic.xlsx")
base = read_xlsx(path = "/Users/jonyarrais/Documents/UFF/Projetos/LCA Leila/Bancos Enviado pela Fabi/Base analise sem missing 724 pessoas.xlsx")

# -------------------------------------------------------------
# 2. Entropy function
# -------------------------------------------------------------

# Entropy is commonly reported in mixture models as a measure
# of classification quality.
#
# Values closer to 1 indicate better separation between classes.

entropy_lca <- function(model) {
  posterior_matrix <- model$posterior
  n <- model$N
  c <- ncol(posterior_matrix)
  numerator <- -sum(posterior_matrix * log(posterior_matrix),
                    na.rm = TRUE)
  denominator <- n * log(c)
  entropy <- 1 - (numerator / denominator)
  return(entropy)
}

# -------------------------------------------------------------
# 3. Model specification
# -------------------------------------------------------------

# The poLCA package uses a formula interface.
#
# cbind() lists the observed indicators used to define the
# latent classes.
#
# "~ 1" indicates that no covariates are included in the
# measurement model.

form_lca <- cbind(
  pep,
  lubrif,
  testhiv,
  gouinag,
  camcaspa
) ~ 1


# -------------------------------------------------------------
# 4. Why two different packages are used
# -------------------------------------------------------------

# We use:
#
# poLCA      → for the 1-class model
# poLCAParallel → for models with 2 or more classes
#
# The reason is computational efficiency.
#
# When multiple random starting values are used (nrep = 200),
# estimation becomes computationally expensive for models with
# several classes.
#
# poLCAParallel distributes the estimation across multiple
# CPU cores, substantially reducing computation time.


# -------------------------------------------------------------
# 5. Estimate the 1-class model
# -------------------------------------------------------------

model_lca_1 <- poLCA::poLCA(formula = form_lca,
                            data = base,
                            nclass = 1,
                            nrep = 200,
                            maxiter = 5000)

# -------------------------------------------------------------
# 6. Estimate the 2-class model
# -------------------------------------------------------------

model_lca_2 <- poLCAParallel::poLCA(formula = form_lca,
                                    data = base,
                                    nclass = 2,
                                    nrep = 200,
                                    maxiter = 5000,
                                    graphs = TRUE)

# -------------------------------------------------------------
# 7. Estimate the 3-class model
# -------------------------------------------------------------

model_lca_3 <- poLCAParallel::poLCA(formula = form_lca,
                                    data = base,
                                    nclass = 3,
                                    nrep = 200,
                                    maxiter = 5000,
                                    graphs = TRUE)

# -------------------------------------------------------------
# 8. Estimate the 4-class model
# -------------------------------------------------------------

model_lca_4 <- poLCAParallel::poLCA(formula = form_lca,
                                    data = base,
                                    nclass = 4,
                                    nrep = 200,
                                    maxiter = 5000,
                                    graphs = TRUE)

# -------------------------------------------------------------
# 9. Bootstrap Likelihood Ratio Test (BLRT)
# -------------------------------------------------------------

# The BLRT compares models with k classes vs k-1 classes.

blrt_1_2 <- blrt(model_null = model_lca_1,
                 model_alt = model_lca_2,
                 n_bootstrap = 1000)

blrt_1_2$p_value


blrt_2_3 <- blrt(model_null = model_lca_2,
                 model_alt = model_lca_3,
                 n_bootstrap = 1000)

blrt_2_3$p_value

blrt_3_4 <- blrt(model_null = model_lca_3,
                 model_alt = model_lca_4,
                 n_bootstrap = 1000)

blrt_3_4$p_value

# -------------------------------------------------------------
# 10. Extract results for Table 2
# -------------------------------------------------------------

table2 <- tibble(
  
  Classes = 1:4,
  
  AIC = c(
    model_lca_1$aic,
    model_lca_2$aic,
    model_lca_3$aic,
    model_lca_4$aic
  ),
  
  BIC = c(
    model_lca_1$bic,
    model_lca_2$bic,
    model_lca_3$bic,
    model_lca_4$bic
  ),
  
  LogLik = c(
    model_lca_1$llik,
    model_lca_2$llik,
    model_lca_3$llik,
    model_lca_4$llik
  ),
  
  Entropy = c(
    NA,
    entropy_lca(model_lca_2),
    entropy_lca(model_lca_3),
    entropy_lca(model_lca_4)
  )
)

table2

# -------------------------------------------------------------
# 11. Extract results for Table 3
# -------------------------------------------------------------

# Conditional item probabilities for the selected model
# (two-class solution)

item_probabilities <- model_lca_2$probs

item_probabilities
