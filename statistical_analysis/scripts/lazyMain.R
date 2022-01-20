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
# library(tidyverse)
# Load dplyr for many useful functions
# library(dplyr)
# Load ggplot2 for many fancy plotting-functions
# library(ggplot2)
# Load patchwork for neatly patching plots together
# https://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2
# library(patchwork)

###########################################
# Preperation of the data for exploration #
###########################################
source("cookData.R")

#######################
# Exploration scripts #
#######################
# Meta
# Subject-Names, -EMails, -Comments
source("exploratoryDataAnalysisPrint00.R")
# Quantitative
# Study-runs (Colors) and Trials
source("exploratoryDataAnalysisPrint01.R")
# Qualitative
# Distribution of ratings, Hidden Anchor
source("exploratoryDataAnalysisPrint02.R")
# Global
# Excerpt-Objekt-Modification combinations
source("exploratoryDataAnalysisPrint03.R")
# Local
# Object-Modification-Excerpt combinations
source("exploratoryDataAnalysisPrint04.R")
# Specific
# Excerpt-Modification for left against right
source("exploratoryDataAnalysisPrint05.R")
# Global Rank
# Excerpt-Objekt-Modification combinations but with ranking
source("exploratoryDataAnalysisPrint06.R")
# Local Rank
# Object-Modification-Excerpt combinations but with ranking
source("exploratoryDataAnalysisPrint07.R")
# Specific Rank
# Excerpt-Modification for left against right but with ranking
source("exploratoryDataAnalysisPrint08.R")
