# R-Script
# Analysis of listening panel
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

# Plot-preparation
pdf_boolean <- TRUE
png_boolean <- FALSE
options(max.print=100000)
options(dplyr.print_max = 100000)

#### One-way ANOVA #############################################################
################################################################################
# Objects #
###########
list_of_plots <- list()
identifier <- "Object"
sink_path <- paste0("anova-oneway/", identifier, "-sink.txt")

#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) # Tighten the scope
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

data_anch %>% sample_n_by(Object, size = 1)

data_anch$Object <- as.factor(data_anch$Object) # "Char" have no levels
sink(sink_path)
## Levels ######################################################################
print("Levels")
levels(data_anch$Object)
sink()

#### Summary statistics
summary_statistics_grade <- data_anch %>%
  group_by(Object) %>%
  get_summary_stats(Grade, type = "mean_sd")
summary_statistics_rank <- data_anch %>%
  group_by(Object) %>%
  get_summary_stats(Rank, type = "mean_sd")

sink(sink_path, append = TRUE)
print("Summary Statistics")
summary_statistics_grade
summary_statistics_rank
sink()

#### Visualization
list_of_plots[[1]] <- ggboxplot(data_anch, x = "Object", y = "Grade", main = "Summary statistics")
list_of_plots[[2]] <- ggboxplot(data_anch, x = "Object", y = "Rank", main = "Summary statistics")

#### Check assumptions #########################################################
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
print("Outlier detection")
data_anch %>%
  group_by(Object) %>%
  identify_outliers(Grade)
data_anch %>%
  group_by(Object) %>%
  identify_outliers(Rank)
sink()

#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model_grade <- lm(Grade ~ Object, data = data_anch)
model_rank <- lm(Rank ~ Object, data = data_anch)
# Create a QQ plot of residuals
list_of_plots[[3]] <- ggqqplot(residuals(model_grade), main = "Check normality assumption by analyzing the model residuals")
list_of_plots[[4]] <- ggqqplot(residuals(model_rank), main = "Check normality assumption by analyzing the model residuals")

# Compute Shapiro-Wilk test of normality
#sink(sink_path, append = TRUE)
## Shapiro-Wilk test of normality ##############################################
#shapiro_test(residuals(model_grade))
#shapiro_test(residuals(model_rank))
#sink()

#### In the example of the tutorial this happens:
# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
list_of_plots[[5]] <- ggqqplot(data_anch, "Grade", facet.by = "Object", main = "Check normality assumption by groups")
list_of_plots[[6]] <- ggqqplot(data_anch, "Rank", facet.by = "Object", main = "Check normality assumption by groups")

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
list_of_plots[[7]] <- plot(model_grade, 1, main = "Check the homogeneity of variances")
list_of_plots[[8]] <- plot(model_rank, 1, main = "Check the homogeneity of variances")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
sink(sink_path, append = TRUE)
## Levene's test to check homogeneity of variance ##############################
print("Levene test to check homogeneity of variance")
data_anch %>% levene_test(Grade ~ Object)
data_anch %>% levene_test(Rank ~ Object)
sink()

#### Computation ###############################################################
sink(sink_path, append = TRUE)
## Computation #################################################################
print("ANOVA")
res_grade.aov <- data_anch %>% anova_test(Grade ~ Object)
res_grade.aov
res_rank.aov <- data_anch %>% anova_test(Rank ~ Object)
res_rank.aov
sink()

######## Post-hoc tests
## A significant one-way ANOVA is generally followed up by Tukey post-hoc tests
## to perform multiple pairwise comparisons between groups. 
## Key R function: tukey_hsd() [rstatix].

# Pairwise comparisons
sink(sink_path, append = TRUE)
## Post-hoc test: pairwise comparisons #########################################
print("Pairwise comparisons with tukey")
pwc_grade <- data_anch %>% tukey_hsd(Grade ~ Object)
pwc_grade
pwc_rank <- data_anch %>% tukey_hsd(Rank ~ Object)
pwc_rank
sink()

#### Report ####################################################################

# Visualization: box plots with p-values
pwc_grade <- pwc_grade %>% add_xy_position(x = "Object")
list_of_plots[[9]] <- ggboxplot(data_anch, x = "Object", y = "Grade", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_grade, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_grade.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_grade)
  )
pwc_rank <- pwc_rank %>% add_xy_position(x = "Object")
list_of_plots[[10]] <- ggboxplot(data_anch, x = "Object", y = "Rank", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_rank, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_rank.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_rank)
  )

# Saving data to pdf or png ####################################################
################################################################################
if (pdf_boolean == TRUE) { # Print plots to a pdf file:
  pdf(file = paste0("anova-oneway/", identifier, ".pdf"))
  for (plot in list_of_plots) {
    print(plot)
  }
  dev.off()
} 
if (png_boolean == TRUE) { # Print plots to sequence of png files:
  image_counter <- 1
  for (plot in list_of_plots) {
    image_counter_padded <- formatC(image_counter, width = 3, format = "d", flag = "0")
    png(
      file = paste0("anova-oneway/", identifier, image_counter_padded, ".png"),
    )
    print(plot)
    dev.off()
    image_counter <- image_counter + 1
  }
}

################################################################################


#### One-way ANOVA #############################################################
################################################################################
# Attributes #
##############
list_of_plots <- list()
identifier <- "Attribute"
sink_path <- paste0("anova-oneway/", identifier, "-sink.txt")

#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) # Tighten the scope
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

data_anch %>% sample_n_by(Attribute, size = 1)

data_anch$Attribute <- as.factor(data_anch$Attribute) # "Char" have no levels
sink(sink_path)
## Levels ######################################################################
print("Levels")
levels(data_anch$Attribute)
sink()

#### Summary statistics
summary_statistics_grade <- data_anch %>%
  group_by(Attribute) %>%
  get_summary_stats(Grade, type = "mean_sd")
summary_statistics_rank <- data_anch %>%
  group_by(Attribute) %>%
  get_summary_stats(Rank, type = "mean_sd")

sink(sink_path, append = TRUE)
print("Summary Statistics")
summary_statistics_grade
summary_statistics_rank
sink()

#### Visualization
list_of_plots[[1]] <- ggboxplot(data_anch, x = "Attribute", y = "Grade", main = "Summary statistics")
list_of_plots[[2]] <- ggboxplot(data_anch, x = "Attribute", y = "Rank", main = "Summary statistics")

#### Check assumptions #########################################################
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
print("Outlier detection")
data_anch %>%
  group_by(Attribute) %>%
  identify_outliers(Grade)
data_anch %>%
  group_by(Attribute) %>%
  identify_outliers(Rank)
sink()


#### Outlier investigation (manually) ####
#outliers <- data_anch %>%
#  group_by(Attribute) %>%
#  identify_outliers(Grade)
#outliers <- outliers %>% group_by(SubjectName) %>%
#  summarise(Count = n())
#outliers
#### Outlier investigation (manually) ####

#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model_grade <- lm(Grade ~ Attribute, data = data_anch)
model_rank <- lm(Rank ~ Attribute, data = data_anch)
# Create a QQ plot of residuals
list_of_plots[[3]] <- ggqqplot(residuals(model_grade), main = "Check normality assumption by analyzing the model residuals")
list_of_plots[[4]] <- ggqqplot(residuals(model_rank), main = "Check normality assumption by analyzing the model residuals")

# Compute Shapiro-Wilk test of normality
#sink(sink_path, append = TRUE)
## Shapiro-Wilk test of normality ##############################################
#shapiro_test(residuals(model_grade))
#shapiro_test(residuals(model_rank))
#sink()

#### In the example of the tutorial this happens:
# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
list_of_plots[[5]] <- ggqqplot(data_anch, "Grade", facet.by = "Attribute", main = "Check normality assumption by groups")
list_of_plots[[6]] <- ggqqplot(data_anch, "Rank", facet.by = "Attribute", main = "Check normality assumption by groups")

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
list_of_plots[[7]] <- plot(model_grade, 1, main = "Check the homogeneity of variances")
list_of_plots[[8]] <- plot(model_rank, 1, main = "Check the homogeneity of variances")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
sink(sink_path, append = TRUE)
## Levene's test to check homogeneity of variance ##############################
print("Levene test to check homogeneity of variance")
data_anch %>% levene_test(Grade ~ Attribute)
data_anch %>% levene_test(Rank ~ Attribute)
sink()

#### Computation ###############################################################
sink(sink_path, append = TRUE)
## Computation #################################################################
print("ANOVA")
res_grade.aov <- data_anch %>% anova_test(Grade ~ Attribute)
res_grade.aov
res_rank.aov <- data_anch %>% anova_test(Rank ~ Attribute)
res_rank.aov
sink()

######## Post-hoc tests
## A significant one-way ANOVA is generally followed up by Tukey post-hoc tests
## to perform multiple pairwise comparisons between groups. 
## Key R function: tukey_hsd() [rstatix].

# Pairwise comparisons
sink(sink_path, append = TRUE)
## Post-hoc test: pairwise comparisons #########################################
print("Pairwise comparisons with tukey")
pwc_grade <- data_anch %>% tukey_hsd(Grade ~ Attribute)
pwc_grade
pwc_rank <- data_anch %>% tukey_hsd(Rank ~ Attribute)
pwc_rank
sink()

#### Report ####################################################################

# Visualization: box plots with p-values
pwc_grade <- pwc_grade %>% add_xy_position(x = "Attribute")
list_of_plots[[9]] <- ggboxplot(data_anch, x = "Attribute", y = "Grade", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_grade, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_grade.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_grade)
  )
pwc_rank <- pwc_rank %>% add_xy_position(x = "Attribute")
list_of_plots[[10]] <- ggboxplot(data_anch, x = "Attribute", y = "Rank", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_rank, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_rank.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_rank)
  )

# Saving data to pdf or png ####################################################
################################################################################
if (pdf_boolean == TRUE) { # Print plots to a pdf file:
  pdf(file = paste0("anova-oneway/", identifier, ".pdf"))
  for (plot in list_of_plots) {
    print(plot)
  }
  dev.off()
} 
if (png_boolean == TRUE) { # Print plots to sequence of png files:
  image_counter <- 1
  for (plot in list_of_plots) {
    image_counter_padded <- formatC(image_counter, width = 3, format = "d", flag = "0")
    png(
      file = paste0("anova-oneway/", identifier, image_counter_padded, ".png"),
    )
    print(plot)
    dev.off()
    image_counter <- image_counter + 1
  }
}



