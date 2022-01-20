# R-Script
# ANOVA for study data
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

# Plot-preparation
list_of_plots <- list()
pdf_boolean <- TRUE
png_boolean <- FALSE
identifier <- "SubjectSex"

sink_path <- paste0("anova_oneway/", identifier, "-sink.txt")
options(max.print=1000)
options(dplyr.print_max = 1000)

#### One-way ANOVA #############################################################
################################################################################
#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank, SubjectSex) # Tighten the scope
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

data_anch %>% sample_n_by(SubjectSex, size = 1)

data_anch$SubjectSex <- as.factor(data_anch$SubjectSex) # "Char" have no levels
sink(sink_path)
## Levels ######################################################################
levels(data_anch$SubjectSex)
sink()

#### Summary statistics
data_anch %>%
  group_by(SubjectSex) %>%
  get_summary_stats(Grade, type = "mean_sd")
data_anch %>%
  group_by(SubjectSex) %>%
  get_summary_stats(Rank, type = "mean_sd")


#### Visualization
list_of_plots[[1]] <- ggboxplot(data_anch, x = "SubjectSex", y = "Grade", main = "Summary statistics")
list_of_plots[[2]] <- ggboxplot(data_anch, x = "SubjectSex", y = "Rank", main = "Summary statistics")

#### Check assumptions #########################################################
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
data_anch %>%
  group_by(SubjectSex) %>%
  identify_outliers(Grade)
data_anch %>%
  group_by(SubjectSex) %>%
  identify_outliers(Rank)
sink()

#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model_grade <- lm(Grade ~ SubjectSex, data = data_anch)
model_rank <- lm(Rank ~ SubjectSex, data = data_anch)
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
list_of_plots[[5]] <- ggqqplot(data_anch, "Grade", facet.by = "SubjectSex", main = "Check normality assumption by groups")
list_of_plots[[6]] <- ggqqplot(data_anch, "Rank", facet.by = "SubjectSex", main = "Check normality assumption by groups")

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
list_of_plots[[7]] <- plot(model_grade, 1, main = "Check the homogeneity of variances")
list_of_plots[[8]] <- plot(model_rank, 1, main = "Check the homogeneity of variances")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
sink(sink_path, append = TRUE)
## Levene's test to check homoheneity of variance ##############################
data_anch %>% levene_test(Grade ~ SubjectSex)
data_anch %>% levene_test(Rank ~ SubjectSex)
sink()

#### Computation ###############################################################
sink(sink_path, append = TRUE)
## Computation #################################################################
res_grade.aov <- data_anch %>% anova_test(Grade ~ SubjectSex)
res_grade.aov
res_rank.aov <- data_anch %>% anova_test(Rank ~ SubjectSex)
res_rank.aov
sink()

######## Post-hoc tests
## A significant one-way ANOVA is generally followed up by Tukey post-hoc tests
## to perform multiple pairwise comparisons between groups. 
## Key R function: tukey_hsd() [rstatix].

# Pairwise comparisons
sink(sink_path, append = TRUE)
## Post-hoc test: pairwise comparisons #########################################
pwc_grade <- data_anch %>% tukey_hsd(Grade ~ SubjectSex)
pwc_grade
pwc_rank <- data_anch %>% tukey_hsd(Rank ~ SubjectSex)
pwc_rank
sink()

#### Report ####################################################################

# Visualization: box plots with p-values
pwc_grade <- pwc_grade %>% add_xy_position(x = "SubjectSex")
list_of_plots[[9]] <- ggboxplot(data_anch, x = "SubjectSex", y = "Grade", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_grade, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_grade.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_grade)
  )
pwc_rank <- pwc_rank %>% add_xy_position(x = "SubjectSex")
list_of_plots[[10]] <- ggboxplot(data_anch, x = "SubjectSex", y = "Rank", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_rank, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_rank.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_rank)
  )

# Saving data to pdf or png ####################################################
################################################################################
if (pdf_boolean == TRUE) { # Print plots to a pdf file:
  pdf(file = paste0("anova_oneway/", identifier, ".pdf"))
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
      file = paste0("anova_oneway/", identifier, image_counter_padded, ".png"),
    )
    print(plot)
    dev.off()
    image_counter <- image_counter + 1
  }
}


