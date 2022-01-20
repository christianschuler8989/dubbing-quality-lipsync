# R-Script
#
# Input: Preprocessed data from the BA-study on lip-synchrony
#
# Output: New insights
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
#library(patchwork)

# Name of study-run as variable input-parameter
studyRun <- 'all' # "yellow", "red", "purple"
workingDirectoryStart <- '~/thesis_october/evaluating/data/'
workingDirectoryEnd <- '/data_preprocessed/'
# Construct path for working directory
workingDirectory <- paste(workingDirectoryStart, studyRun, workingDirectoryEnd, sep="")

# Save current working directory (to set it back at the end of this script)
initialDir <- getwd()

# Set working directory
setwd(workingDirectory)

# Read data from .csv
data <- read.csv(file = 'dataPreprocessed.csv')


print(data)

#dataPeek <- arrange(data, desc(UserName))

#dataPeek


# Set current working directory back to the initial directory prior to script
setwd(initialDir)
