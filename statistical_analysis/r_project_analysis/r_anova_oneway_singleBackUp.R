# R-Script
# ANOVA for study data
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

#### One-way ANOVA #############################################################
################################################################################
#### Data preparation
data_blue <- data_done %>% dplyr::filter(Study == "Blue")
data_blue_trial_74 <- data_blue %>% dplyr::filter(TrialID == 74) %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,
  mutate(PVS = paste0(Modification, Attribute)) # PVSs ("Processed Video Sequences")


data_blue_trial_74 %>% sample_n_by(Attribute, size = 1)
# [TODO:] Understand why this results in NULL instead of the PVS-groups
levels(data_blue_trial_74)

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

# From "char" to "factor" to prevent:
#   Warning message:
#   In leveneTest.default(y = y, group = group, ...) : group coerced to factor.
data_blue_trial_74$PVS <- factor(data_blue_trial_74$PVS)


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





