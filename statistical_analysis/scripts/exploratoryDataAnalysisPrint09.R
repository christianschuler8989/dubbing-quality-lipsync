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
# library(patchwork)
library(ggpubr)

library(rstatix)




######## Input #################################################################
# Save current working directory (to set it back at the end of this script)
initial_dir <- getwd()
#### Read data from study ####
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
# Set working directory and read data from .csv
setwd(working_directory)
data_rare <- read.csv(file = "data_cooked_rare.csv")
data_medi <- read.csv(file = "data_cooked_medium.csv")
data_done <- read.csv(file = "data_cooked_done.csv")
data_prep <- read.csv(file = "data_cooked_prep.csv")
#### Read meta_data_text ####
working_directory_meta <- "~/thesis_october/evaluating/data/meta/"
# Set working directory and read data from .csv
setwd(working_directory_meta)
data_meta_text <- read.csv(file = "data_meta_text.csv")
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

######### Quantity of the data #################################################
print(paste(
  "Prep:", nrow(data_prep),
  "Rare:", nrow(data_rare),
  "Medi:", nrow(data_medi),
  "Done:", nrow(data_done),
  sep = " "
))

################################################################################
#                                                                              #
#                       ###############################                        #
#                       ## Listening Panel in Detail ##                        #
#                       ###############################                        #
#                                                                              #
################################################################################
# Distributions

######## Grading trend for the Anchors
# First just for the Hidden High Anchor
# Middle Anchor
# Low Anchor



# Results from study BLUE
#data_blue <- data_done %>% filter(Study == "Blue")
#data_green <- data_done %>% filter(Study == "Green")
# head(data_green)

# Results from study BLUE for GREEN-Anchor-1
# data_blue_anchor_01 <- data_blue %>% filter(TrialID == 55)
#data_green_anchor_01 <- data_green %>% filter(TrialID == 55)


# Results from study BLUE for GREEN-Anchor-2
# data_blue_anchor_02 <- data_blue %>% filter(TrialID == 62)
#data_green_anchor_02 <- data_green %>% filter(TrialID == 62)
# head(data_green_anchor_02)
# data_green_anchor_02
# => 222

# Object = p
#data_green_anchor_02_object_p <- data_green_anchor_02 %>% filter(Object == "p")
# data_green_anchor_02_object_p
# => 148

# Object = a
# [TODO]: Häh? Only 37?!
#data_green_anchor_02_object_a <- data_green_anchor_02 %>% filter(Object == "a")
# data_green_anchor_02_object_p
# => 37

# Object = w
# [TODO]: Häh? Only 37?!
#data_green_anchor_02_object_w <- data_green_anchor_02 %>% filter(Object == "w")
# data_green_anchor_02_object_p
# => 37

# Modification = vR, since TrialID == 62
# Attribute = 0
#data_green_anchor_02_object_p_attr_0 <- data_green_anchor_02_object_p %>% filter(Attribute == 0)
# data_green_anchor_02_object_p_attr_4
# => 37
# Attribute = 4
#data_green_anchor_02_object_p_attr_4 <- data_green_anchor_02_object_p %>% filter(Attribute == 4)
# data_green_anchor_02_object_p_attr_4
# => 111

### Something weird happening with the anchors
### Probably because of naming and Attribute == 4

# Results from study BLUE for #### Tempo - p - aR
#data_blue_trial_74 <- data_blue %>% filter(TrialID == 74)
# data_blue_trial_74
# => 126


# "Tighten the scope"
#data_blue_trial_74 <- data_blue_trial_74 %>% select(ResultID, Excerpt, Attribute, Modification, Grade, Runtime, SubjectName, SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum, Object, TrialID, Rank)


# Attribute range
# data_blue_trial_74_attr_0 => 21
# data_blue_trial_74_attr_2 => 21
# data_blue_trial_74_attr_4 => 63
# data_blue_trial_74_attr_6 => 21

#data_blue_trial_74_attr_low <- data_blue_trial_74 %>% filter(Modification == "iL")
# data_blue_trial_74_attr_low => 21
#data_blue_trial_74_attr_mid <- data_blue_trial_74 %>% filter(Modification == "uR")
# data_blue_trial_74_attr_mid => 21
#data_blue_trial_74_attr_high <- data_blue_trial_74 %>% filter(Attribute == 0)
# data_blue_trial_74_attr_high => 21
#data_blue_trial_74_attr_2 <- data_blue_trial_74 %>% filter(Attribute == 2)
# data_blue_trial_74_attr_2 => 21
# Anchors also have Attribute == 4, therefore special filterin needed:
#data_blue_trial_74_attr_4 <- data_blue_trial_74 %>% filter((Attribute == 4) & (Modification != "uR") & (Modification != "iL"))
# data_blue_trial_74_attr_4 => 21
#data_blue_trial_74_attr_6 <- data_blue_trial_74 %>% filter(Attribute == 6)
# data_blue_trial_74_attr_6 => 21






#### One-way ANOVA #############################################################
#### Data preparation
data_blue <- data_done %>% filter(Study == "Blue")
data_blue_trial_74 <- data_blue %>% filter(TrialID == 74)

data_blue_trial_74 <- mutate(
  data_blue_trial_74, 
  PVS = paste0(Modification, Attribute)
) # PVSs ("Processed Video Sequences")

data_blue_trial_74 %>% sample_n_by(PVS, size = 1)
# [TODO:] Understand why this results in NULL instead of the PVS-groups
levels(data_blue_trial_74$PVS) 

#### Summary statistics
data_blue_trial_74 %>%
  group_by(PVS) %>%
  get_summary_stats(Grade, type = "mean_sd")

#### Visualization
ggboxplot(data_blue_trial_74, x = "PVS", y = "Grade")

#### Check assumptions #########################################################
#### Outliers
data_blue_trial_74 %>%
  group_by(PVS) %>%
  identify_outliers(Grade)

#### Normality assumption
## Analyzing the ANOVA model residuals to check the normality for all groups
## together. This approach is easier and it’s very handy when you have many
## groups or if there are few data points per group.
## Check normality assumption by analyzing the model residuals.
## QQ plot and Shapiro-Wilk test of normality are used.
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model <- lm(Grade ~ PVS, data = data_blue_trial_74)
# Create a QQ plot of residuals
ggqqplot(residuals(model))

# Compute Shapiro-Wilk test of normality
shapiro_test(residuals(model))

#### In the example of the tutorial this happens:
# In the QQ plot, as all the points fall approximately along the reference line,
# we can assume normality. 
# This conclusion is supported by the Shapiro-Wilk test.
# Computing Shapiro-Wilk test for each group level. 
# If the data is normally distributed, the p-value should be greater than 0.05.
# The p-value is not significant (p = 0.13), so we can assume normality.
# => but here we have: statistic = 0.974 and p.value = 0.0174

# Note that, if your sample size is greater than 50, the normal QQ plot is
# preferred because at larger sample sizes the Shapiro-Wilk test becomes very
# sensitive even to a minor deviation from normality.
# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
ggqqplot(data_blue_trial_74, "Grade", facet.by = "PVS")

# All the points fall approximately along the reference line, for each cell.
# So we can assume normality of the data.

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
plot(model, 1)
# In the plot above, there is no evident relationships between residuals and
# fitted values (the mean of each groups), which is good.
# So, we can assume the homogeneity of variances.

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
data_blue_trial_74 %>% levene_test(Grade ~ PVS)
# Here we get statistic = 1.10 and p = 0.363
# From the output above, we can see that the p-value is > 0.05,
# which is not significant. This means that, there is not significant difference
# between variances across groups. Therefore, we can assume the homogeneity of
# variances in the different treatment groups.
## ! In a situation where the homogeneity of variance assumption is not met,
# you can compute the Welch one-way ANOVA test using the function
# welch_anova_test()[rstatix package]. This test does not require the assumption
# of equal variances.


#### Computation ###############################################################
res.aov <- data_blue_trial_74 %>% anova_test(Grade ~ PVS)
res.aov
## In the table above, the column ges corresponds to the
## generalized eta squared (effect size).
## It measures the proportion of the variability in the outcome variable
## (here plant weight) that can be explained in terms of the predictor
## (here, treatment group). An effect size of 0.26 (26%) means that 26% of the
## change in the weight can be accounted for the treatment conditions.
## where,
## F indicates that we are comparing to an F-distribution (F-test); (2, 27)
##    indicates the degrees of freedom in the numerator (DFn) and the
##    denominator (DFd), respectively; 4.85 indicates the obtained F-statistic
##    value
## p specifies the p-value
## ges is the generalized effect size (amount of variability due to the factor)



######## Post-hoc tests
## A significant one-way ANOVA is generally followed up by Tukey post-hoc tests
## to perform multiple pairwise comparisons between groups. 
## Key R function: tukey_hsd() [rstatix].

# Pairwise comparisons
pwc <- data_blue_trial_74 %>% tukey_hsd(Grade ~ PVS)
pwc
## The output contains the following columns:
## estimate: estimate of the difference between means of the two groups
## conf.low, conf.high: the lower and the upper end point of the confidence
##    interval at 95% (default)
## p.adj: p-value after adjustment for the multiple comparisons.




#### Report ####################################################################
## We could report the results of one-way ANOVA as follow:

# A one-way ANOVA was performed to evaluate if the grading by the listening
# panel was different for the 6 different processed video sequence groups: 
# aR0, aR2, aR4, aR6, iL4, uR4 (each n = 21)

# Data is presented as mean +/- standard deviation. 
# The listening panels Grading was statistically significantly different between
# different processed video sequence groups, 
# F(5, 120) = 10.084, p = 0.0000000445, generalized eta squared = 0.296.

# The listening panels Grading increased in aR4 group (? +/- ?)
# compared to aR2 group (? +/- ?).
# It also increased in uR4 group (? +/- ?) compared to iL4 group (? +/- ?).
# Otherwise it decreased in every comparison.

# Tukey post-hoc analyses revealed that some of the decreases were
# statistically significant. In increasing order of significance:
# From aR2 to uR4 (-24.8, 95% CI (-47.2 to -2.41)) with p = 0.0207.
# From aR4 to uR4 (-26.7, 95% CI (-48.7 to -3.89)) with p = 0.0116.
# ...
# From aR4 to iL4 (-38.9, 95% CI (-61.3 to -16.5)) with p = 0.0000259.
# From aR0 to iL4 (-45.0, 95% CI (-67.3 to -22.6)) with p = 0.000000767.


# Visualization: box plots with p-values
pwc <- pwc %>% add_xy_position(x = "PVS")
ggboxplot(data_blue_trial_74, x = "PVS", y = "Grade") +
  stat_pvalue_manual(pwc, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
  )
































######## How close is a specific subject to the general trend?



######## Grading consistency of subjects
# If a subject finished the same trial multiple times,
# how consistent is the grading?



######## Effects on the grading trend
# Phoneme length

# Phoneme type

# Phoneme neighbours

# Video type (angle, distance, ...)



# ANOVA IN R - Tutorial
# https://www.datanovia.com/en/lessons/anova-in-r/

# 1. Compute the within-group variance, also known as residual variance.
# This tells us, how different each participant is from their own group mean


# 2. Compute the variance between group means


# 3. Produce the F-statistic as the ratio of variance.between.groups/variance.within.groups.




main <- function() {

}

# main()


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
