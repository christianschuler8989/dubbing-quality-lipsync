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
# Load rstatix for ANOVA testing
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


#### Three-way ANOVA ###########################################################
#### Data preparation
data_blue <- data_done %>% filter(Study == "Blue")
# Tempo - p - aR
data_blue_trial_074 <- data_blue %>% filter(TrialID == 74)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank)
# Pandemie - p - aR
data_blue_trial_040 <- data_blue %>% filter(TrialID == 40)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank)
# Europaeisch - p - aR
data_blue_trial_016 <- data_blue %>% filter(TrialID == 16)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank)
# Tempo - p - vL
data_blue_trial_081 <- data_blue %>% filter(TrialID == 81)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank)
# Pandemie - p - vL
data_blue_trial_047 <- data_blue %>% filter(TrialID == 47)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank)
# Europaeisch - p - vL
data_blue_trial_023 <- data_blue %>% filter(TrialID == 23)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank)

# Tempo && Pandemie && Europaeisch - p - aR
data_blue_p_aR <- rbind(data_blue_trial_074, data_blue_trial_040, data_blue_trial_016)
data_blue_p_vL <- rbind(data_blue_trial_081, data_blue_trial_047, data_blue_trial_023)
data_blue_p <- rbind(data_blue_p_aR, data_blue_p_vL)

data_blue_p %>% sample_n_by(Modification, Attribute, Excerpt, size = 1)

#### Summary statistics
data_blue_p %>% 
  group_by(Modification, Attribute, Excerpt) %>%
  get_summary_stats(Grade, type = "mean_sd")

#### Visualization
bxp <- ggboxplot(
  data_blue_p, x = "Excerpt", y = "Grade",
  color = "Attribute", palette = "jco", facet.by = "Modification"
  )
bxp

#### Check assumptions #########################################################
#### Outliers
data_blue_p %>%
  group_by(Modification, Attribute, Excerpt) %>%
  identify_outliers(Grade)

#### Normality assumption
## Analyzing the ANOVA model residuals to check the normality for all groups
## together. This approach is easier and it’s very handy when you have many
## groups or if there are few data points per group.
## Check normality assumption by analyzing the model residuals.
## QQ plot and Shapiro-Wilk test of normality are used.
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model <- lm(Grade ~ Modification*Attribute*Excerpt, data = data_blue_p)
# Create a QQ plot of residuals
ggqqplot(residuals(model))

# Compute Shapiro-Wilk test of normality
shapiro_test(residuals(model))

# Note that, if your sample size is greater than 50, the normal QQ plot is
# preferred because at larger sample sizes the Shapiro-Wilk test becomes very
# sensitive even to a minor deviation from normality.
# QQ plot draws the correlation between a given data and the normal distribution.
# Check normality assumption by groups. Computing Shapiro-Wilk test for each combinations of factor levels:
data_blue_p %>%
  group_by(Modification, Attribute, Excerpt) %>%
  shapiro_test(Grade)

#Create QQ plots for each group level:
ggqqplot(data_blue_p, "Grade", ggtheme = theme_bw()) +
  facet_grid(Modification + Attribute ~ Excerpt, labeller = "label_both")



#### Homogneity of variance assumption
## This can be checked using the Levene’s test:
data_blue_p %>% levene_test(Grade ~ Modification*Attribute*Excerpt)



#### Computation ###############################################################
res.aov <- data_blue_p %>% anova_test(Grade ~ Modification * Attribute * Excerpt)
res.aov

######## Post-hoc tests
## https://www.datanovia.com/en/lessons/anova-in-r/ ~ around the middle?

##### Procedure for significant two-way interaction
# Compute simple main effects
# Group the data by Modification and fit simple two-way interaction
model <- lm(Grade ~ Modification * Attribute * Excerpt, data = data_blue_p)
data_blue_p %>%
  group_by(Modification) %>%
  anova_test(Grade ~ Attribute * Excerpt, error = model)

# And much more . . .
# Last quarter of:    https://www.datanovia.com/en/lessons/anova-in-r/

#### Report ####################################################################
## ???????????????

#### ONLY WORKS ONCE THE "And much more . . ." Post-Hoc-Stuff has been done!!!
# Visualization: box plots with p-values
pwc <- pwc %>% add_xy_position(x = "Excerpt")
pwc.filtered <- pwc %>% filter(Modification = "vL", Attribute = 2) # Randomly chosen by me
bxp +
  stat_pvalue_manual(
    pwc.filtered, color = "Attribute", linetype = "Attribute", hide.ns = TRUE,
    tip.length = 0, step.increase = 0.1, step.group.by = "Modification"
    ) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
  )


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
