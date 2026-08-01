###############################################################
# 03_lca_with_covariates_onestep.R
#
# This script fits a one step latent class model with covariates
# using the poLCA package.
#
# In this approach, the latent class measurement model and the
# multinomial regression for class membership are estimated
# simultaneously.
#
# The goal is to evaluate whether age, race, education, and
# self perceived HIV risk are associated with latent class
# membership.
#
# This script assumes that:
# 1. 01_packages.R has already been executed
# 3. the object base is already available in the session
###############################################################


# -------------------------------------------------------------
# 1. Load the dataset
# -------------------------------------------------------------

# The synthetic dataset included in this repository mirrors the
# structure of the original PrEP15-19 dataset used in the paper.
base <- fread(
  "Simulated-data/dataPREP-sim-v1.dat",
  header = FALSE,
  col.names = c("pep", "lubrif", "testhiv",	"penet", "condom", "age", "race", "educ", "hivrisk", "classe")
)

base

# In the distributed simulated file, the indicators are coded as
# 0/1. poLCA requires categorical response levels to be positive
# consecutive integers; therefore, recode 0 -> 1 and 1 -> 2.
# Missing values, if present, remain missing after this operation.
base[, c("pep", "lubrif", "testhiv",	"penet", "condom", "age", "race", "educ", "hivrisk", "classe") :=
       lapply(.SD, \(x) x + 1),
     .SDcols = c("pep", "lubrif", "testhiv",	"penet", "condom", "age", "race", "educ", "hivrisk", "classe")]

base


# -------------------------------------------------------------
# 2. Specify the one step LCA model with covariates
# -------------------------------------------------------------


# The indicators define the latent classes.
# The variables on the right side of the formula are covariates
# used to predict class membership.

form_lca_cov <- cbind(
  pep,
  lubrif,
  testhiv,
  penet,
  condom
) ~ age + race + educ + hivrisk


# -------------------------------------------------------------
# 3. Fit the one step model
# -------------------------------------------------------------

# Main arguments used in poLCA:
#
# formula
#   defines the latent class indicators and the covariates
#
# data
#   dataset used for estimation
#
# nclass
#   number of latent classes to be estimated
#
# nrep
#   number of random starts used to reduce the chance of a local maximum
#
# maxiter
#   maximum number of iterations allowed for each run
#
# graphs
#   whether to display standard poLCA diagnostic plots

model_lca_cov_onestep <- poLCA::poLCA(
  formula = form_lca_cov,
  data = base,
  nclass = 2,
  nrep = 200,
  maxiter = 20000,
  graphs = TRUE
)

# -------------------------------------------------------------
# 4. Extract regression coefficients automatically
# -------------------------------------------------------------

# In poLCA, the regression coefficients for class membership
# are stored in:
#
# model$coeff
# model$coeff.se
#
# For a 2 class model, poLCA estimates one set of coefficients
# comparing the non reference class against the reference class.

coef_est <- model_lca_cov_onestep$coeff
coef_se  <- model_lca_cov_onestep$coeff.se

#retirando o intercepto para o gráfico
coef_est = coef_est[-1,]
coef_se = coef_se[-1,]


# -------------------------------------------------------------
# 5. Organize results for interpretation
# -------------------------------------------------------------

# Convert coefficients to odds ratios and 95 percent confidence intervals.
# The intercept is removed because it is usually not shown in the forest plot.

plot_df <- tibble::tibble(
  term = names(coef_est),
  estimate = as.numeric(coef_est),
  se = as.numeric(coef_se)
) %>%
  dplyr::filter(term != "(Intercept)") %>%
  dplyr::mutate(
    OR = exp(estimate),
    lo = exp(estimate - 1.96 * se),
    hi = exp(estimate + 1.96 * se)
  )

# -------------------------------------------------------------
# 6. Create clearer labels for the plot
# -------------------------------------------------------------

# Edit these labels if your coding changes in another dataset.
term_labels <- c(
  idade = "Age 18 to 19 years",
  raca = "White race",
  escol = "Higher education",
  riscper2 = "Self perceived HIV risk moderate or high"
)

plot_df <- plot_df %>%
  dplyr::mutate(
    term_label = dplyr::recode(term, !!!term_labels),
    term_label = factor(term_label, levels = rev(term_label))
  )

# -------------------------------------------------------------
# 7. Table 5 with results
# -------------------------------------------------------------

table_onestep_or <- plot_df %>%
  dplyr::transmute(
    Covariate = term_label,
    Estimate = estimate,
    SE = se,
    OR = OR,
    CI_low = lo,
    CI_high = hi
  )

table_onestep_or


# -------------------------------------------------------------
# 7. Optional Forest plot of odds ratios
# -------------------------------------------------------------

fig_onestep_or <- ggplot(plot_df, aes(x = OR, y = term_label)) +
  geom_vline(xintercept = 1, linewidth = 0.5) +
  geom_errorbar(
    aes(xmin = lo, xmax = hi),
    orientation = "y",
    height = 0.18,
    linewidth = 0.6
  ) +
  geom_point(size = 2.2) +
  scale_x_log10() +
  labs(
    x = "Odds ratio",
    y = NULL
  ) +
  theme_minimal(base_size = 12)

fig_onestep_or

