# R-Script
#
# Input: Preprocessed data from the BA-study on lip-synchrony
#
# Output: Cleaned data (cooked)
#
# Author: Christian (Doofnase) Schuler
# Date: 2021 Nov
################################################################################

################################################################################
#                                                                              #
#                    ##################################                        #
#                    ## Prerequisites and data input ##                        #
#                    ##################################                        #
#                                                                              #
################################################################################
# Load tidyverse for many useful functions
library(tidyverse)
# Load dplyr for many useful functions
library(dplyr)
# Load ggplot2 for many fancy plotting-functions
library(ggplot2)
# Load patchwork for neatly patching plots together
# https://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2
# library(patchwork)
# Load data.table for modifying DataFrames in-place
# https://stackoverflow.com/questions/60791256/r-data-table-check-group-condition
library(data.table)

######## Input #################################################################
# Save current working directory (to set it back at the end of this script)
initial_dir <- getwd()
# Name of study-run as variable input-parameter
study_run <- "all" # "yellow", "red", "purple"
working_directory_in_start <- "~/thesis_october/evaluating/data/"
working_directory_in_end <- "/data_preprocessed/"
# Construct path for working directory
working_directory_in <- paste(
  working_directory_in_start,
  study_run,
  working_directory_in_end,
  sep = ""
)
# Set working directory
setwd(working_directory_in)
# Read data from .csv
data <- read.csv(file = "data_preprocessed.csv")
#### Read session_trial_overview ###############################################
working_directory_overview <- "~/thesis_october/testing/"
# Set working directory and read data from .csv
setwd(working_directory_overview)
data_overview <- read.csv(file = "sessions_trials_overview.csv")

######## Output ################################################################
working_directory_out_start <- "~/thesis_october/evaluating/data/"
working_directory_out_end <- "/data_cooked/"
# Construct path for working directory
working_directory_out <- paste(
  working_directory_out_start,
  study_run,
  working_directory_out_end,
  sep = ""
)
# Set working directory
setwd(working_directory_out)

################################################################################
#                                                                              #
#               ############################################                   #
#                         ## Looking at the data ##                            #
#               ############################################                   #
#                                                                              #
################################################################################
#
######## Get all the TrialIDs of a specific study-run (color)
# Filter observations by value (Orange) of column (Study) and then
# extract values of the correspoding columnname (TrialID) to get a subset
# orange_trialIDs <- data_overview %>%
#  filter(Study == "Orange") %>%
#  select(TrialID)
# Take a look:
# orange_trialIDs
# Order the observations by column-name of dataframe
# show_me_order <- orange_trialIDs[order(orange_trialIDs$TrialID), ]
# Print for easy copy&paste of data
# print(show_me_order)


################################################################################
#                                                                              #
#               ############################################                   #
#               ## Finetuning missing aspects of the data ##                   #
#               ############################################                   #
#                                                                              #
################################################################################
# Adding values for TrialID (from draw.io-schematics) corresponding to TestIDs
print(paste("Input read from: ", working_directory_in))
print(paste("Rows of data (input):", nrow(data), sep = " "))
######## Merging (join) Dataframes
# https://stackoverflow.com/questions/1299871/how-to-join-merge-data-frames-
#   inner-outer-left-right
# But only 2 columns from the right dataframe to prevent duplicates
data <- merge(data, data_overview[, c(2:3)], by = "TestID")


######## Ranking of grades inside each trial ###################################
# https://stackoverflow.com/questions/2315601/understanding-the-order-function
# For every trial (TrialID) of every session (SessionID)
# Take the 6 ratings (Grade) and extract/calculate their ranking
# => [How to handle equal values??]
# Add the ranking of every observation/row ("Rating")
#   in a new variable/column (Rank)
data <- data %>%
  group_by(SessionID, TrialID) %>%
  mutate(Rank = order(order(Grade, decreasing = TRUE)))
#### And this is how it is done!
#### DUDE! This is not Python! Get your head out of your ass! ####
# data_grouped <- data %>% group_by(SessionID, TrialID)
#
# for (group in data_grouped) {
#  current_ranking <- order(group) # => current_ranking = 4 6 1 2 5 3
# }
#### DUDE! This is not Python! Get your head out of your ass! ####

head(data, 3)


######## Quality of life for neat plotting #####################################
# Some runtimes go haywire because people take a break
data$Runtime[data$Runtime > 300000] <- 300000
# And some participants really made use of the not so limited space for naming
# First, un-factorize a string using the as.character function, and,
#   then, re-factorize with the as.factor (or simply factor) function:
# https://stackoverflow.com/questions/16819956/warning-message-in-invalid-
#   factor-level-na-generated
data$SubjectName <- as.character(data$SubjectName)
ifelse(
  nchar(data$SubjectName) > 15,
  data$SubjectName <- substring(data$SubjectName, 1, 15),
  data$SubjectName <- data$SubjectName
)
data$SubjectName <- as.factor(data$SubjectName)



# data$SubjectName[nchar(data$SubjectName) > 15] <- substring(
#  data$SubjectName, 1, 15
# )

# peek <- data %>%
#  ungroup() %>%
#  select(SubjectName) %>%
#  distinct(SubjectName, .keep_all = TRUE)
# peek


################################################################################
#                                                                              #
#                        ############################                          #
#                         ## Removing faulty data ##                           #
#                        ############################                          #
#                                                                              #
################################################################################
# Number of input-rows
write.csv(data, "data_cooked_prep.csv")
print(paste(
  "Rows of data (added TrialIDs) COOKED_PREPROCESSED:",
  nrow(data),
  sep = " "
))

######### Runtime too small ####################################################
################################################################################
# The shortest excerpt is 3 seconds long and every trial contains 6 excerpts +
# the original reference. Even in the case of repeated excerpt and prior
# knowledge (familiarity with the reference) it is impossible to even watch
# all the excerpts under 18 seconds (Runtim == 18000).
# Therefore every result with a Runtime of less than 20000 will be excluded.
data_cleaned_runtime <- data %>%
  filter(Runtime >= 15000)

# https://swcarpentry.github.io/r-novice-inflammation/11-supp-read-write-csv/
write.csv(data_cleaned_runtime, "data_cooked_rare.csv")
print(paste(
  "Rows of data (cleaned runtime) COOKED_RARE:",
  nrow(data_cleaned_runtime),
  sep = " "
))

# https://stackoverflow.com/questions/18514694/how-to-save-a-data-frame-in-a-
#  txt-or-excel-file-separated-by-columns
# write.table(data_cleaned_runtime, "data_cooked.txt", sep = "\t")


######### Ratings all zero #####################################################
################################################################################
# If not even a single excerpt has been graded, there has not been any grading
# in the first place, since the hidden high-anchor (reference) should ideally
# never be rated with less than 95.
# Every result with more than 3 ratings equal to zero will be excluded.
# Every result with more than 3 ratings equal to hundred will be excluded.

#### Create a new Dataframe for this stage
data_cleaned_empty_pre <- data_cleaned_runtime

#### Modify this Dataframe inplace via data.table functionalities
# For each group of "SessionID"&"TrialID" check for duplicates.
# The first occurance will be ignored, but the first duplicate gets flagged.
# Add a new flag for duplicates: Number of FlagDuplicateGrade == 1 is the number
# of Duplicates => In case the sum of these flags is 3, then there are 4 Grades
# with the same value in this specified group.
setDT(data_cleaned_empty_pre)[, FlagDuplicateGrade := fifelse(
  duplicated(Grade) > 0,
  1,
  0
), .(SessionID, TrialID)]

# Count number of duplicates (FlagDuplicateGrade) per group and exclude if > 2
# https://stackoverflow.com/questions/50280820/removing-groups-from-dataframe-
#   if-variable-has-repeated-values
data_cleaned_empty <- data_cleaned_empty_pre %>%
  group_by(SessionID, TrialID) %>%
  mutate(SumDuplicateGrade = sum(FlagDuplicateGrade)) %>%
  filter(SumDuplicateGrade < 3)

write.csv(data_cleaned_empty, "data_cooked_medium_rare.csv")
print(paste(
  "Rows of data (cleaned empty(TODO)) COOKED_MEDIUM_RARE:",
  nrow(data_cleaned_empty),
  sep = " "
))


######## Anonymization of subject names ########################################
################################################################################
#
# data_cleaned_anonymize <- data_cleaned_duplicates
# https://www.r-bloggers.com/2014/11/data-anonymization-in-r/
# Anonymize function
# anonymize <- function(x, algo = "crc32") {
#  unq_hashes <- vapply(unique(x), function(object) digest(object, algo = algo),
#    FUN.VALUE = "", USE.NAMES = TRUE
#  )
#  unname(unq_hashes[x])
# }
# Anonymizing the data
# choose columns to mask
# cols_to_mask <- c("SubjectName")
# anonymize
# data_cleaned_anonymize[, cols_to_mask := lapply(.SD, anonymize), .SDcols = cols_to_mask, with = FALSE]
# pretty print
# kable(head(data_cleaned_anonymize))

# https://stackoverflow.com/questions/65091138/in-r-how-to-consistently-replace-anonimize-ids-or-names-within-two-separate
# Find all unique ids and create a lookup table.
# all_names <- data_cleaned_anonymize$SubjectName
# name_df <- data.frame(SubjectName = all_names, code = paste0('Urist', sprintf('%04d', 1:length(all_names))))

# Merge df1 with the lookup table, remove the id column, and rename the code column to id.
# data_cleaned_anonymize <- merge(data_cleaned_anonymize, name_df, all.x = TRUE)
# data_cleaned_anonymize <- df1[, c('code', 'row1')]
# names(data_cleaned_anonymize)[1] <- 'SubjectName'

# df3 <- merge(df1, df2, all.x = TRUE, all.y = TRUE)

######## Anonymization of subject names ########################################
################################################################################
# https://stackoverflow.com/questions/65091138/in-r-how-to-consistently-replace-anonimize-ids-or-names-within-two-separate
# https://r-lang.com/r-substr/
data_cleaned_anonymize <- data_cleaned_empty

data_cleaned_anonymize$SubjectName <- sapply(data_cleaned_anonymize$SubjectName, digest::digest, algo = "md5")
data_cleaned_anonymize$SubjectName <- paste0("UristMc", substr(data_cleaned_anonymize$SubjectName, start = 0, stop = 6))

write.csv(data_cleaned_anonymize, "data_cooked_medium.csv")
print(paste(
  "Rows of data (cleaned anonymized) COOKED_MEDIUM:",
  nrow(data_cleaned_anonymize),
  sep = " "
))






######## Multiple ratings from one subject for the same Trial-ID ###############
################################################################################
# If one subject grades the same trial multiple times, the overall
# rating-preference would be scewed towards this subjects preferences.
# Only distinct gradings- every duplicate of the combination of "SubjectName"
# and "TrialID" will be excluded.
#### Maybe we have to work in the realm of "data.tables" now, since there was
#     this ONE step, where we did it above . . .
# https://stackoverflow.com/questions/2900510/r-equivalent-of-select-distinct-
#   on-two-or-more-fields-variables/49051949
setDT(data_cleaned_anonymize)
data_cleaned_duplicates <- unique(
  data_cleaned_anonymize,
  by = c("SubjectName", "TrialID", "File")
)
# data_cleaned_duplicates <- data_cleaned_empty %>%
#  distinct(SubjectName, TrialID, File, .keep_all = TRUE)
write.csv(data_cleaned_duplicates, "data_cooked_done.csv")
print(paste(
  "Rows of data (cleaned duplicates) COOKED_DONE:",
  nrow(data_cleaned_duplicates),
  sep = " "
))




# ????????????????????????????????????
######### Ratings of trial/subject subpar compared to performance of others ####
################################################################################
# Like: Hidden Reference has not been detected in "too many" trials.
# In order to do this, it is neccessary not only to look at the grade itself,
# but at the "category(?)" Was it the best, the second best, ... , the worst?



######## Every trial has a reference which stands for "attribute == 0 " ########
################################################################################
# But since the reference is always the same file (to safe space in repository)
# it always is considered to be an item with "audio left 0" instead of the
# actual modifications of the corresponding trial.
#### Group by trials
# data_trials <- data %>% group_by(SessionID, TestID)

## current_modi = TestID.split("_")[2]
## If current_modi != "aL" then the reference-data has to be modified
## => Modification of reference = current_modi
## => ModificatioName of reference = ???
## => # [TODO] Solve this problem earlier in pipeline please!

#### Replace the "Modification" and "ModificationName" of the reference at hand

#### Handling of special case: The "all"-trials have multiple Modi and ModiName
# => Duplicating a lot of the reference-ratings?
# => Or dropping some of them?
# => # => These do not really have to be considered separately but in
#         conjunction with the other Attribute-Results => Can be dropped!

# Number of output-rows
# number_of_rows <- nrow(data_cleaned)
message("Ouptut written to: ", working_directory_out)


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
