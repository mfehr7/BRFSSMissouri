
###################################
##### Preparation #################
###################################

# Load the data
brfss_2024 <- haven::read_xpt(unz("data-raw/LLCP2024XPT.zip", "LLCP2024.XPT ")) # 457,670 records
brfss_2023 <- haven::read_xpt(unz("data-raw/LLCP2023XPT.zip", "LLCP2023.XPT ")) # 433,323 records

# Get just Missouri's data
brfss_2024 <- brfss_2024 |> dplyr::filter(`_STATE` == 29.00)
brfss_2023 <-brfss_2023 |> dplyr::filter(`_STATE` == 29)

# Selecting only the columns that we are going to focus on (this is just a start, might add/drop)
brfss_2024_tob_cog <- brfss_2024 |>
  dplyr::select(`SEQNO`, # Key
         `IDAY`, `IMONTH`, `IYEAR`, # Survey Date
         `SMOKE100`, `ECIGNOW3`, # Tobacco Use
         `CIMEMLO1`, # Cognitive Decline
         `MARITAL`, `EDUCA`, `VETERAN3`, `EMPLOY1`, `CHILDREN`, `INCOME3`, `PREGNANT`, `WEIGHT2`, `_CRACE1`, # Demographics
         `_ASTHMS1`, `_SMOKER3`, `CAGEG`, `_AGE80`, `CHCOCNC1`, `ALCDAY4`, `MARJSMOK`, `GENHLTH`, `MENTHLTH` # Extras
  ) |>
  dplyr::rename(ECIGNOW = ECIGNOW3, # for uniform names
         CRACE1 = `_CRACE1`, # the rest are changed to not cause problems in mice
         ASTHMS1 = `_ASTHMS1`,
         SMOKER3 = `_SMOKER3`,
         AGE80 = `_AGE80`
  )

brfss_2023_tob_cog <- brfss_2023 |>
  dplyr::select(`SEQNO`, # Key
         `IDAY`, `IMONTH`, `IYEAR`, # Survey Date
         `SMOKE100`, `ECIGNOW2`, # Tobacco Use
         `CIMEMLO1`, # Cognitive Decline
         `MARITAL`, `EDUCA`, `VETERAN3`, `EMPLOY1`, `CHILDREN`, `INCOME3`, `PREGNANT`, `WEIGHT2`, `_CRACE1`, # Demographics
         `_ASTHMS1`, `_SMOKER3`, `CAGEG`, `_AGE80`, `CHCOCNC1`, `ALCDAY4`, `MARJSMOK`, `GENHLTH`, `MENTHLTH` # Extras
  ) |>
  dplyr::rename(ECIGNOW = ECIGNOW2, # for uniform names
         CRACE1 = `_CRACE1`, # the rest are changed to not cause problems in mice
         ASTHMS1 = `_ASTHMS1`,
         SMOKER3 = `_SMOKER3`,
         AGE80 = `_AGE80`
  )


###################################
##### IMPUTING MISSING VALUES #####
###################################

# Joining the two datasets for imputation / tidying
brfss_tob_cog <- dplyr::bind_rows(brfss_2023_tob_cog, brfss_2024_tob_cog)

#
# Imputing
#

# Dry run to get the matrix skeleton, so that we can alter it for each column
ini <- mice::mice(brfss_tob_cog, maxit = 0)
pred <- ini$predictorMatrix
# Reset the entire matrix to 0
pred[,] <- 0

# Predictors (everything except the targets)
predictors <- c("MARITAL", "EDUCA", "VETERAN3", "EMPLOY1", "CHILDREN", "INCOME3", "PREGNANT", "WEIGHT2", "CRACE1",
                "ASTHMS1", "CAGEG", "AGE80", "CHCOCNC1", "ALCDAY4", "MARJSMOK", "GENHLTH", "MENTHLTH")

# Set Predictors for each target column
pred["SMOKE100", predictors] <- 1
pred["ECIGNOW", predictors] <- 1
pred["CIMEMLO1", predictors] <- 1

# Actual imputation
brfss_imputed <- mice::mice(
  brfss_tob_cog,
  m = 3,
  predictorMatrix = pred,
  method = "pmm",
  seed = 20251124,
  print = FALSE
)

#
# Loop to add imputed values
#
brfss_complete <- brfss_tob_cog
for(i in 1:3) {
  # Imputed data for the i-th imputation
  completed <- mice::complete(brfss_imputed, action = i)

  # Select only the target columns
  imp_cols <- completed |>
    dplyr::select(all_of(c("SMOKE100", "ECIGNOW", "CIMEMLO1"))) |>
    dplyr::rename_with(~ paste0(., "_IMP", i))  # renaming them for clarity

  # Append to complete dataset
  brfss_complete <- dplyr::bind_cols(brfss_complete, imp_cols)
}

#
# Testing
#
# summary(brfss_complete)
#
# sum(is.na(brfss_complete$`SMOKE100`))
# sum(is.na(brfss_complete$`SMOKE100_IMP1`))
# sum(is.na(brfss_complete$`SMOKE100_IMP2`))
# sum(is.na(brfss_complete$`SMOKE100_IMP3`))
# sum(is.na(brfss_complete$`ECIGNOW`))
# sum(is.na(brfss_complete$`ECIGNOW_IMP1`))
# sum(is.na(brfss_complete$`ECIGNOW_IMP2`))
# sum(is.na(brfss_complete$`ECIGNOW_IMP3`))
# sum(is.na(brfss_complete$`CIMEMLO1`))
# sum(is.na(brfss_complete$`CIMEMLO1_IMP1`))
# sum(is.na(brfss_complete$`CIMEMLO1_IMP2`))
# sum(is.na(brfss_complete$`CIMEMLO1_IMP3`))
#
# dim(brfss_complete)


###################################
##### TIDYING DATASET #############
###################################

# Creation of Demographics Dataset
demographics <- brfss_complete |> dplyr::select(SEQNO, AGE80, CAGEG, CRACE1, MARITAL, EDUCA, INCOME3, EMPLOY1, CHILDREN, VETERAN3, PREGNANT, WEIGHT2, GENHLTH, MENTHLTH)

# Creation of Cognitive Decline Dataset
cognitive_decline <- brfss_complete |> dplyr::select(SEQNO, CIMEMLO1, CIMEMLO1_IMP1,CIMEMLO1_IMP2,CIMEMLO1_IMP3)

# Creation of Tobacco Use Dataset
tobacco_use <- brfss_complete |> dplyr::select(SEQNO, SMOKE100, SMOKE100_IMP1, SMOKE100_IMP2, SMOKE100_IMP3, ECIGNOW, ECIGNOW_IMP1, ECIGNOW_IMP2, ECIGNOW_IMP3, SMOKER3)

# Base Dataset
missouri_brfss <- brfss_complete

#
# Testing
#
# summary(demographics)
# summary(cognitive_decline)
# summary(tobacco_use)
# summary(missouri_brfss)
#
# dim(demographics)
# dim(cognitive_decline)
# dim(tobacco_use)
# dim(missouri_brfss)


###################################
##### UPDATING PACKAGE ############
###################################

# Use this data in the package
usethis::use_data(demographics, overwrite = TRUE)
usethis::use_data(cognitive_decline, overwrite = TRUE)
usethis::use_data(tobacco_use, overwrite = TRUE)
usethis::use_data(missouri_brfss, overwrite = TRUE)

