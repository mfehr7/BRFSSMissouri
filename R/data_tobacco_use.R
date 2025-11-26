#' Tobacco Usage data from Missouri residents (BRFSS).
#'
#' A sub-dataset containing tobacco usage information from the
#' years 2023 and 2024.
#'
#' @format A data frame with 14,528 rows and 10 variables:
#' \describe{
#'   \item{SEQNO}{key of the dataset}
#'   \item{SMOKER3}{general smoking status}
#'   \item{SMOKE100}{smoked at least 100 cigarettes}
#'   \item{SMOKE100_IMP1}{1st imputation of SMOKE100}
#'   \item{SMOKE100_IMP2}{2nd imputation of SMOKE100}
#'   \item{SMOKE100_IMP3}{3rd imputation of SMOKE100}
#'   \item{ECIGNOW}{e-cigarettes usage}
#'   \item{ECIGNOW_IMP1}{1st imputation of ECIGNOW}
#'   \item{ECIGNOW_IMP2}{2nd imputation of ECIGNOW}
#'   \item{ECIGNOW_IMP3}{3rd imputation of ECIGNOW}

#' }
#' @source \url{https://www.cdc.gov/brfss/index.html}
"tobacco_use"
