###############################################################
# 04_bayesian_latent_class_model.R
#
# Purpose
# -------
# This script fits the Bayesian latent class analysis (LCA)
# presented in the manuscript. The model identifies profiles of
# HIV-prevention practices among adolescents in the PrEP15-19
# study using Markov chain Monte Carlo (MCMC) estimation.
#
# The complete workflow is configured to run with the SIMULATED
# dataset distributed with the repository. The simulated data
# reproduce the structure and coding of the analytical variables
# without disclosing records from the original study participants.
#
# Main outputs
# ------------
# - `modelo_mcmc`: fitted two-class Bayesian LCA model;
# - `posterior_summary`: posterior medians and 95% credible
#   intervals for the item-response probabilities;
# - `probability_plot`: graphical representation of the posterior
#   item-response probabilities and their credible intervals.
#
# Requirements
# ------------
# 1. Run this script from the root directory of the repository.
# 2. Run `Rcode/01_packages.R` first, or otherwise load the
#    packages used below (`data.table`, `dplyr`, `BayesLCA`,
#    `coda`, `ggplot2`, and `stringr`).
# 3. Store the simulated input file at:
#    `Simulated-data/dataPREP-sim-v0.dat`.
###############################################################
# -------------------------------------------------------------
# 1. Load the dataset
# -------------------------------------------------------------

# The synthetic dataset included in this repository mirrors the
# structure of the original PrEP15-19 dataset used in the paper.
base <- fread(
  "Simulated-data/dataPREP-sim-v0.dat",
  header = FALSE,
  col.names = c("pep", "lubrif", "testhiv",	"penet", "condom", "X")
)

base


base = base |> dplyr::select(-X)

# Retain the five binary indicators. BayesLCA uses their original
# 0/1 coding, so no recoding to 1/2 is performed in this script.
indicator_names <- c("pep", "lubrif", "testhiv", "penet", "condom")

base_Blca <- base |>
  dplyr::select(dplyr::all_of(indicator_names))

# Descriptive labels used only when presenting the model results.
indicator_labels <- c(
  "PEP use (Yes)",
  "Lubricant use (Consistent)",
  "HIV testing within partnership (Always/Frequent)",
  "Sexual intercourse without penetration (Always/Frequently)",
  "Condom use (Always)"
)

# -------------------------------------------------------------
# 2. Estimate the Bayesian latent class model
# -------------------------------------------------------------

# Set the random-number seed to make the MCMC estimation
# reproducible when the same data, package versions, and model
# settings are used.
set.seed(123)

# Fit a two-class Bayesian LCA using Gibbs sampling:
# - `G = 2` requests two latent classes;
# - `burn.in` discards the initial MCMC iterations;
# - `iter` sets the total number of iterations;
# - `thin` controls retention of posterior draws; and
# - `relabel = TRUE` addresses label switching across iterations.
modelo_mcmc <- BayesLCA::blca.gibbs(
  X = base_Blca,
  G = 2,
  burn.in = 15000,
  iter = 120000,
  thin = 0.01,
  relabel = TRUE
)

# Number of retained posterior draws under the settings above.
n_retained_draws <- (120000 - 15000) * 0.01
n_retained_draws

# -------------------------------------------------------------
# 3. Inspect the model and MCMC diagnostics
# -------------------------------------------------------------

# Print the fitted model and its numerical summary.
modelo_mcmc
summary(modelo_mcmc)

# Display the diagnostic plots provided by BayesLCA.
plot.blca(modelo_mcmc)

# Calculate the Raftery-Lewis diagnostic for the retained chain.
coda::raftery.diag(coda::as.mcmc(modelo_mcmc))

# Display the item-probability traces supplied by the fitted model.
graphics::par(
  mar = c(3, 3, 2, 1),
  oma = c(0, 0, 0, 0),
  mfrow = c(3, 2)
)
plot(modelo_mcmc, which = 5)

# Restore the default single-panel graphical layout for subsequent
# plots created in the same R session.
graphics::par(mfrow = c(1, 1))

# -------------------------------------------------------------
# 4. Summarize posterior item-response probabilities
# -------------------------------------------------------------

# `itemprob` is a three-dimensional array containing posterior
# draws by latent class and indicator. The code below extracts the
# median and the 2.5th and 97.5th percentiles for every combination
# of indicator and class. This avoids manually copying estimates
# from printed model output.
item_probability_samples <- modelo_mcmc$samples$itemprob

# Labels reflect the substantive interpretation of the two classes
# after the relabeling performed during model estimation.
class_labels <- c("Lower Engagement", "Higher Engagement")

posterior_summary <- dplyr::bind_rows(
  lapply(seq_along(indicator_names), function(j) {
    indicator_samples <- item_probability_samples[, , j]
    
    tibble::tibble(
      Indicator = indicator_labels[j],
      Class = class_labels,
      median = apply(indicator_samples, 2, stats::median, na.rm = TRUE),
      lo = apply(
        indicator_samples,
        2,
        stats::quantile,
        probs = 0.025,
        na.rm = TRUE
      ),
      hi = apply(
        indicator_samples,
        2,
        stats::quantile,
        probs = 0.975,
        na.rm = TRUE
      )
    )
  })
)

posterior_summary

# Preserve the substantive order of the indicators in the figure.
posterior_summary <- posterior_summary |>
  dplyr::mutate(
    Indicator = factor(
      stringr::str_wrap(Indicator, width = 28),
      levels = stringr::str_wrap(indicator_labels, width = 28)
    ),
    Class = factor(Class, levels = class_labels)
  )

# -------------------------------------------------------------
# 5. Plot posterior item-response probabilities
# -------------------------------------------------------------

# Points represent posterior medians, and error bars represent 95%
# credible intervals calculated directly from the MCMC samples.
probability_plot <- ggplot2::ggplot(
  posterior_summary,
  ggplot2::aes(
    x = Indicator,
    y = median,
    color = Class,
    group = Class
  )
) +
  ggplot2::geom_line(linewidth = 1) +
  ggplot2::geom_point(size = 2.5) +
  ggplot2::geom_errorbar(
    ggplot2::aes(ymin = lo, ymax = hi),
    width = 0.15
  ) +
  ggplot2::scale_color_manual(
    values = c(
      "Lower Engagement" = "blue",
      "Higher Engagement" = "red"
    )
  ) +
  ggplot2::coord_cartesian(ylim = c(0, 1)) +
  ggplot2::labs(
    x = NULL,
    y = "Conditional probability",
    color = NULL
  ) +
  ggplot2::theme_minimal(base_size = 13) +
  ggplot2::theme(
    axis.text.x = ggplot2::element_text(angle = 30, hjust = 1),
    legend.position = "top"
  )

probability_plot
