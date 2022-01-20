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


#### Two-way ANOVA #############################################################
#### Data preparation
data_blue <- data_done %>% filter(Study == "Blue")
# Tempo - p - aR
data_blue_trial_074 <- data_blue %>% filter(TrialID == 74) %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")
# Pandemie - p - aR
data_blue_trial_040 <- data_blue %>% filter(TrialID == 40)  %>%  
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")
# Europaeisch - p - aR
data_blue_trial_016 <- data_blue %>% filter(TrialID == 16)  %>% 
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")
# Tempo - p - vL
data_blue_trial_081 <- data_blue %>% filter(TrialID == 81)  %>%  
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")
# Pandemie - p - vL
data_blue_trial_047 <- data_blue %>% filter(TrialID == 47)  %>%  
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")
# Europaeisch - p - vL
data_blue_trial_023 <- data_blue %>% filter(TrialID == 23)  %>%  
  filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")

# Tempo && Pandemie && Europaeisch - p - aR
data_blue_p_aR <- rbind(data_blue_trial_074, data_blue_trial_040, data_blue_trial_016)
#data_blue_p_vL <- rbind(data_blue_trial_081, data_blue_trial_047, data_blue_trial_023)

#### Summary statistics
data_blue_p_aR %>% 
  group_by(PVS, Excerpt) %>%
  get_summary_stats(Grade, type = "mean_sd")

#### Visualization
bxp <- ggboxplot(
  data_blue_p_aR, x = "PVS", y = "Grade",
  color = "Excerpt", palette = "jco"
  )
bxp

#### Check assumptions #########################################################
#### Outliers
data_blue_p_aR %>%
  group_by(PVS, Excerpt) %>%
  identify_outliers(Grade)

#### Normality assumption
## Analyzing the ANOVA model residuals to check the normality for all groups
## together. This approach is easier and it’s very handy when you have many
## groups or if there are few data points per group.
## Check normality assumption by analyzing the model residuals.
## QQ plot and Shapiro-Wilk test of normality are used.
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model <- lm(Grade ~ PVS*Excerpt, data = data_blue_p_aR)
# Create a QQ plot of residuals
ggqqplot(residuals(model))

# Compute Shapiro-Wilk test of normality
shapiro_test(residuals(model))

# Note that, if your sample size is greater than 50, the normal QQ plot is
# preferred because at larger sample sizes the Shapiro-Wilk test becomes very
# sensitive even to a minor deviation from normality.
# QQ plot draws the correlation between a given data and the normal distribution.
# Check normality assumption by groups. Computing Shapiro-Wilk test for each combinations of factor levels:
data_blue_p_aR %>%
  group_by(PVS, Excerpt) %>%
  shapiro_test(Grade)
#Create QQ plots for each group level:
ggqqplot(data_blue_p_aR, "Grade", ggtheme = theme_bw()) +
  facet_grid(PVS ~ Excerpt)



#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
plot(model, 1)


## It’s also possible to use the Levene’s test to check the homogeneity of variances:
data_blue_p_aR %>% levene_test(Grade ~ PVS*Excerpt)



#### Computation ###############################################################
res.aov <- data_blue_p_aR %>% anova_test(Grade ~ PVS*Excerpt)
res.aov

######## Post-hoc tests
## https://www.datanovia.com/en/lessons/anova-in-r/ ~ around the middle?

##### Procedure for significant two-way interaction
# Compute simple main effects
# Group the data by PVS and fit anova
model <- lm(Grade ~ PVS * Excerpt, data = data_blue_p_aR)
data_blue_p_aR %>%
  group_by(PVS) %>%
  anova_test(Grade ~ Excerpt, error = model)

# Compute pairwise comparisons
# Compare the Grade of the different Excerpts by PVS levels:
# pairwise comparisons
library(emmeans)
pwc <- data_blue_p_aR %>% 
  group_by(PVS) %>%
  emmeans_test(Grade ~ Excerpt, p.adjust.method = "bonferroni") 
pwc
# Emmeans stands for estimated marginal means 
# (aka least square means or adjusted means).



# Procedure for non-significant two-way interaction
# Inspect main effects
res.aov


# Compute pairwise comparisons
# Pairwise t-test:
data_blue_p_aR %>%
  pairwise_t_test(
    Grade ~ Excerpt, 
    p.adjust.method = "bonferroni"
  )

# Pairwise comparisons using Emmeans test. You need to specify the overall model, from which the overall degrees of freedom are to be calculated. This will make it easier to detect any statistically significant differences if they exist.
model <- lm(Grade ~ PVS * Excerpt, data = data_blue_p_aR)
data_blue_p_aR %>% 
  emmeans_test(
    Grade ~ Excerpt, p.adjust.method = "bonferroni",
    model = model
  )


#### Report ####################################################################
## ???????????????

# Visualization: box plots with p-values
pwc <- pwc %>% add_xy_position(x = "PVS")
bxp +
  stat_pvalue_manual(pwc, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
  )


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)

