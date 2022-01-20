# R-Script
#
# Input: Preprocessed data from the BA-study on lip-synchrony
#
# Output: New insights
#
# Author: Christian (Doofnase) Schuler
# Date: 2021 Dec
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
#library(dplyr)
# Load ggplot2 for many fancy plotting-functions
#library(ggplot2)

######## Input #################################################################
# Name of study-run as variable input-parameter
study_run <- "all" # "yellow", "red", "purple"
working_directory_start <- "~/thesis_october/evaluating/data/"
working_directory_end <- "/data_cooked/"
# Construct path for working directory
working_directory <- paste(
  working_directory_start,
  study_run,
  working_directory_end,
  sep = ""
)

# Save current working directory (to set it back at the end of this script)
initial_dir <- getwd()

# Set working directory
setwd(working_directory)

# Read data from .csv
data <- read.csv(file = "data_cooked.csv")

######## Output ################################################################
working_directory_out_start <- "~/thesis_october/evaluating/data/"
working_directory_out_end <- "/data_images/"
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
#                        ######################                                #
#                        # Plot of quantities #                                #
#                        ######################                                #
#                                                                              #
################################################################################

###################################################
# Number of participants (+ Finished trials each) #
###################################################
data_subj_num <- data %>%
  group_by(SubjectName)
per_subj <- summarise(data_subj_num, FinishedTrials = n() / 6)

p1 <- ggplot(per_subj, aes(x = SubjectName, y = FinishedTrials)) +
  geom_bar(fill = "firebrick", stat = "identity") + # Y axis is explicit.
  ggtitle("Finished Trials per Subject") +
  theme(
    plot.title = element_text(
      color = "darkgreen",
      size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
  ) +
  theme(
    axis.text.x = element_text(size = 10, angle = 65, vjust = 1, hjust = 1),
    axis.text.y = element_text(size = 18)
  ) +
  theme(
    plot.background = element_rect(fill = "lightblue"),
    plot.margin = unit(c(2, 4, 1, 3), "cm")
  ) + # top, right, bottom, left
  theme(
    panel.background = element_rect(fill = "steelblue"),
    panel.grid.major = element_line(colour = "black", size = 1),
    panel.grid.minor = element_line(colour = "blue", size = 1)
  )
################################################################################

p1

