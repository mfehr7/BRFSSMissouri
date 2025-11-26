#' Health survey data from Missouri residents (BRFSS).
#'
#' The full dataset containing basic survey information, demographics, health
#' information, tobacco usage, and cognitive decline prevalence from the
#' years 2023 and 2024.
#'
#' @format A data frame with 14,528 rows and 34 variables:
#' \describe{
#'   \item{SEQNO}{key of the dataset}
#'   \item{IDAY}{interview day}
#'   \item{IMONTH}{interview month}
#'   \item{IYEAR}{interview year}
#'   \item{MARITAL}{marital status}
#'   \item{EDUCA}{education level}
#'   \item{VETERAN3}{veteran status}
#'   \item{EMPLOY1}{employment status}
#'   \item{CHILDREN}{number of children in household}
#'   \item{INCOME3}{income level}
#'   \item{PREGNANT}{pregnancy status}
#'   \item{WEIGHT2}{reported weight in pounds}
#'   \item{CRACE1}{child non-hispanic race including multiracial}
#'   \item{ASTHMS1}{asthma status}
#'   \item{SMOKER3}{general smoking status}
#'   \item{CAGEG}{child age}
#'   \item{AGE80}{age}
#'   \item{CHCOCNC1}{melanoma or other types of cancer}
#'   \item{ALCDAY4}{days in the past 30 had alcohol}
#'   \item{MARJSMOK}{marijuana usage}
#'   \item{GENHLTH}{general health}
#'   \item{MENTHLTH}{mental health}
#'   \item{SMOKE100}{smoked at least 100 cigarettes}
#'   \item{SMOKE100_IMP1}{1st imputation of SMOKE100}
#'   \item{SMOKE100_IMP2}{2nd imputation of SMOKE100}
#'   \item{SMOKE100_IMP3}{3rd imputation of SMOKE100}
#'   \item{ECIGNOW}{e-cigarettes usage}
#'   \item{ECIGNOW_IMP1}{1st imputation of ECIGNOW}
#'   \item{ECIGNOW_IMP2}{2nd imputation of ECIGNOW}
#'   \item{ECIGNOW_IMP3}{3rd imputation of ECIGNOW}
#'   \item{CIMEMLO1}{difficulties with thinking or memory}
#'   \item{CIMEMLO1_IMP1}{1st imputation of CIMEMLO1}
#'   \item{CIMEMLO1_IMP2}{2nd imputation of CIMEMLO1}
#'   \item{CIMEMLO1_IMP3}{3rd imputation of CIMEMLO1}
#' }
#' @source \url{https://www.cdc.gov/brfss/index.html}
"missouri_brfss"
