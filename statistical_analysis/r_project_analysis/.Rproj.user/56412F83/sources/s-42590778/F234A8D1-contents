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
identifier <- "ObjectModification"

sink_path <- paste0("anova_twoway/", identifier, "-sink.txt")
options(max.print=1000)
options(dplyr.print_max = 1000)

#### One-way ANOVA #############################################################
################################################################################
#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>%
  mutate(PVS = paste0(Object, Modification))
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

data_anch %>% sample_n_by(PVS, size = 1)

data_anch$Object <- as.factor(data_anch$Object) # "Char" have no levels
data_anch$Modification <- as.factor(data_anch$Modification) # "Char" have no levels
sink(sink_path)
## Levels ######################################################################
levels(data_anch$Object)
levels(data_anch$Modification)
sink()

#### Summary statistics
data_anch %>%
  group_by(Object, Modification) %>%
  get_summary_stats(Grade, type = "mean_sd")
data_anch %>%
  group_by(Object, Modification) %>%
  get_summary_stats(Rank, type = "mean_sd")


#### Visualization
list_of_plots[[1]] <- ggboxplot(data_anch, x = "Object", y = "Grade", main = "Summary statistics",
                                color = "Modification", palette = "jco")
list_of_plots[[2]] <- ggboxplot(data_anch, x = "Object", y = "Rank", main = "Summary statistics",
                                color = "Modification", palette = "jco")

#### Check assumptions #########################################################
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
data_anch %>%
  group_by(Object, Modification) %>%
  identify_outliers(Grade)
data_anch %>%
  group_by(Object, Modification) %>%
  identify_outliers(Rank)
sink()

#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model_grade <- lm(Grade ~ Object*Modification, data = data_anch)
model_rank <- lm(Rank ~ Object*Modification, data = data_anch)
# Create a QQ plot of residuals
list_of_plots[[3]] <- ggqqplot(residuals(model_grade), main = "Check normality assumption by analyzing the model residuals")
list_of_plots[[4]] <- ggqqplot(residuals(model_rank), main = "Check normality assumption by analyzing the model residuals")

# Compute Shapiro-Wilk test of normality
sink(sink_path, append = TRUE)
## Shapiro-Wilk test of normality ##############################################
shapiro_test(residuals(model_grade))
shapiro_test(residuals(model_rank))
sink()

# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
list_of_plots[[5]] <- ggqqplot(data_anch, "Grade", ggtheme = theme_bw(), main = "Check normality assumption by groups") +
  facet_grid(Object ~ Modification)
list_of_plots[[6]] <- ggqqplot(data_anch, "Rank", ggtheme = theme_bw(), main = "Check normality assumption by groups") +
  facet_grid(Object ~ Modification)

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
#list_of_plots[[7]] <- plot(model_grade, 1, main = "Check the homogeneity of variances")
#list_of_plots[[8]] <- plot(model_rank, 1, main = "Check the homogeneity of variances")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
sink(sink_path, append = TRUE)
## Levene's test to check homoheneity of variance ##############################
data_anch %>% levene_test(Grade ~ Object*Modification)
data_anch %>% levene_test(Rank ~ Object*Modification)
sink()

#### Computation ###############################################################
sink(sink_path, append = TRUE)
## Computation #################################################################
res_grade.aov <- data_anch %>% anova_test(Grade ~ Object*Modification)
res_grade.aov
res_rank.aov <- data_anch %>% anova_test(Rank ~ Object*Modification)
res_rank.aov
sink()

######## Post-hoc tests
## A significant two-way interaction indicates that the impact that one factor
## (e.g., Modification) has on the outcome variable (e.g., job satisfaction
## Grade) depends on the level of the other factor (e.g., Object) (and vice
## versa). So, you can decompose a significant two-way interaction into:
## Simple main effect: run one-way model of the first variable at each level of
##   the second variable,
## Simple pairwise comparisons: if the simple main effect is significant, run
##    multiple pairwise comparisons to determine which groups are different.
## For a non-significant two-way interaction, you need to determine whether you
##    have any statistically significant main effects from the ANOVA output.
##    A significant main effect can be followed up by pairwise comparisons
##    between groups.

#### Procedure for significant two-way interaction
# Compute simple main effects
# Group the data by Object and fit  anova
model_grade <- lm(Grade ~ Object * Modification, data = data_anch)
data_anch %>%
  group_by(Object) %>%
  anova_test(Grade ~ Modification, error = model_grade)
model_rank <- lm(Grade ~ Object * Modification, data = data_anch)
data_anch %>%
  group_by(Object) %>%
  anova_test(Rank ~ Modification, error = model_rank)

# [TODO:] Fix:
#    Error in emmeans::emmeans(model, formula.emmeans) : 
#        No variable named Modification in the reference grid
# Compute pairwise comparisons
# pairwise comparisons
library(emmeans)
pwc_grade <- data_anch %>% 
  group_by(Object) %>%
  emmeans_test(Grade ~ Modification, p.adjust.method = "bonferroni") 
pwc_grade
pwc_rank <- data_anch %>% 
  group_by(Object) %>%
  emmeans_test(Rank ~ Modification, p.adjust.method = "bonferroni") 
pwc_rank

#### Procedure for non-significant two-way interaction
# Inspect main effects
# If the two-way interaction is not statistically significant, you need to consult the main effect for each of the two variables (Object and Modification) in the ANOVA output.
res_grade.aov
res_rank.aov

# Compute pairwise comparisons
# Pairwise t-test:
data_anch %>%
  pairwise_t_test(
    Grade ~ Modification, 
    p.adjust.method = "bonferroni"
)
data_anch %>%
  pairwise_t_test(
    Rank ~ Modification, 
    p.adjust.method = "bonferroni"
  )

# Pairwise comparisons using Emmeans test. You need to specify the overall
# model, from which the overall degrees of freedom are to be calculated.
# This will make it easier to detect any statistically significant differences
# if they exist.
model_grade <- lm(Grade ~ Object * Modification, data = data_anch)
data_anch %>% 
  emmeans_test(
    Grade ~ Modification, p.adjust.method = "bonferroni",
    model = model
  )
model_rank <- lm(Rank ~ Object * Modification, data = data_anch)
data_anch %>% 
  emmeans_test(
    Rank ~ Modification, p.adjust.method = "bonferroni",
    model = model
  )

#### Report ####################################################################

# Visualization: box plots with p-values
pwc_grade <- pwc_grade %>% add_xy_position(x = "Object")
list_of_plots[[7]] <- ggboxplot(data_anch, x = "Object", y = "Grade", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_grade, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_grade.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_grade)
  )
pwc_rank <- pwc_rank %>% add_xy_position(x = "Object")
list_of_plots[[8]] <- ggboxplot(data_anch, x = "Object", y = "Rank", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc_rank, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res_rank.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_rank)
  )

# Saving data to pdf or png ####################################################
################################################################################
if (pdf_boolean == TRUE) { # Print plots to a pdf file:
  pdf(file = paste0("anova_twoway/", identifier, ".pdf"))
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
      file = paste0("anova_twoway/", identifier, image_counter_padded, ".png"),
    )
    print(plot)
    dev.off()
    image_counter <- image_counter + 1
  }
}


