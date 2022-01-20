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
identifier <- "ObjectModificationExcerpt"

sink_path <- paste0("anova_threeway/", identifier, "-sink.txt")
options(max.print=1000)
options(dplyr.print_max = 1000)

#### One-way ANOVA #############################################################
################################################################################
#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>%
  mutate(PVS = paste0(Object, Modification, Excerpt))
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

data_anch %>% sample_n_by(Object, Modification, Excerpt, size = 1)

data_anch$Object <- as.factor(data_anch$Object) # "Char" have no levels
data_anch$Modification <- as.factor(data_anch$Modification) # "Char" have no levels
data_anch$Excerpt <- as.factor(data_anch$Excerpt) # "Char" have no levels
sink(sink_path)
## Levels ######################################################################
levels(data_anch$Object)
levels(data_anch$Modification)
levels(data_anch$Excerpt)
sink()

#### Summary statistics
data_anch %>%
  group_by(Object, Modification, Excerpt) %>%
  get_summary_stats(Grade, type = "mean_sd")
data_anch %>%
  group_by(Object, Modification, Excerpt) %>%
  get_summary_stats(Rank, type = "mean_sd")


#### Visualization
bxp_grade <- ggboxplot(data_anch, x = "Object", y = "Grade", main = "Summary statistics",
                       color = "Modification", palette = "jco", facet.by = "Excerpt")
list_of_plots[[1]] <- bxp_grade 
bxp_rank <- ggboxplot(data_anch, x = "Object", y = "Rank", main = "Summary statistics",
                      color = "Modification", palette = "jco", facet.by = "Excerpt")
list_of_plots[[2]] <- bxp_rank

#### Check assumptions #########################################################
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
data_anch %>%
  group_by(Object, Modification, Excerpt) %>%
  identify_outliers(Grade)
data_anch %>%
  group_by(Object, Modification, Excerpt) %>%
  identify_outliers(Rank)
sink()

#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model_grade <- lm(Grade ~ Object*Modification*Excerpt, data = data_anch)
model_rank <- lm(Rank ~ Object*Modification*Excerpt, data = data_anch)
# Create a QQ plot of residuals
list_of_plots[[3]] <- ggqqplot(residuals(model_grade), main = "Check normality assumption by analyzing the model residuals")
list_of_plots[[4]] <- ggqqplot(residuals(model_rank), main = "Check normality assumption by analyzing the model residuals")

# Compute Shapiro-Wilk test of normality to check normality assumption by groups
sink(sink_path, append = TRUE)
## Shapiro-Wilk test of normality ##############################################
data_anch %>% 
  group_by(Object, Modification, Excerpt) %>%
  shapiro_test(Grade)
data_anch %>% 
  group_by(Object, Modification, Excerpt) %>%
  shapiro_test(Rank)
sink()

# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
list_of_plots[[5]] <- ggqqplot(data_anch, "Grade", ggtheme = theme_bw(), main = "Check normality assumption by groups") +
  facet_grid(Object + Modification ~ Excerpt, labeller = "label_both")
list_of_plots[[6]] <- ggqqplot(data_anch, "Rank", ggtheme = theme_bw(), main = "Check normality assumption by groups") +
  facet_grid(Object + Modification ~ Excerpt, labeller = "label_both")

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
#list_of_plots[[7]] <- plot(model_grade, 1, main = "Check the homogeneity of variances")
#list_of_plots[[8]] <- plot(model_rank, 1, main = "Check the homogeneity of variances")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
sink(sink_path, append = TRUE)
## Levene's test to check homoheneity of variance ##############################
data_anch %>% levene_test(Grade ~ Object*Modification*Excerpt)
data_anch %>% levene_test(Rank ~ Object*Modification*Excerpt)
sink()

#### Computation ###############################################################
sink(sink_path, append = TRUE)
## Computation #################################################################
res_grade.aov <- data_anch %>% anova_test(Grade ~ Object*Modification*Excerpt)
res_grade.aov
res_rank.aov <- data_anch %>% anova_test(Rank ~ Object*Modification*Excerpt)
res_rank.aov
sink()

######## Post-hoc tests
## If there is a significant three-way interaction effect, you can decompose it into:
## Simple two-way interaction: run two-way interaction at each level of third variable,
## Simple simple main effect: run one-way model at each level of second variable, and
## simple simple pairwise comparisons: run pairwise or other post-hoc comparisons if necessary.

## If you do not have a statistically significant three-way interaction, you
##   need to determine whether you have any statistically significant two-way
##   interaction from the ANOVA output. You can follow up a significant two-way
##   interaction by simple main effects analyses and pairwise comparisons
##   between groups if necessary.
## In this section we’ll describe the procedure for a significant three-way interaction.

#### Compute simple two-way interactions
# Group the data by gender and 
# fit simple two-way interaction 
model_grade <- lm(Grade ~ Object*Modification*Excerpt, data = data_anch)
data_anch %>%
  group_by(Object) %>%
  anova_test(Grade ~ Modification*Excerpt, error = model_grade)
model_rank <- lm(Grade ~ Object*Modification*Excerpt, data = data_anch)
data_anch %>%
  group_by(Object) %>%
  anova_test(Rank ~ Modification*Excerpt, error = model_rank)

#### Compute simple simple main effects
# Group the data by gender and risk, and fit  anova
## You will only need to do this for the simple two-way interaction for “males”
##    as this was the only simple two-way interaction that was statistically
##    significant. The error term again comes from the three-way ANOVA.
#treatment.effect <- headache %>%
#  group_by(gender, risk) %>%
#  anova_test(pain_score ~ treatment, error = model)
#treatment.effect %>% filter(gender == "male")


#### Compute simple simple comparisons
# Pairwise comparisons
library(emmeans)
pwc_grade <- data_anch %>% 
  group_by(Object, Modification) %>%
  emmeans_test(Grade ~ Excerpt, p.adjust.method = "bonferroni") %>%
  select(-df, -statistic, -p) # Remove details
# Show comparison results for "p" and "aR"
pwc_grade %>% filter(Object == "p", Modification == "aR")
pwc_grade
# Estimated marginal means (i.e. adjusted means) with 95% confidence interval
get_emmeans(pwc_grade) %>% filter(Object == "p", Modification == "aR")

pwc_rank <- data_anch %>% 
  group_by(Object, Modification) %>%
  emmeans_test(Rank ~ Excerpt, p.adjust.method = "bonferroni") %>%
  select(-df, -statistic, -p) # Remove details
# Show comparison results for "p" and "aR"
pwc_rank %>% filter(Object == "p", Modification == "aR")
pwc_rank
# Estimated marginal means (i.e. adjusted means) with 95% confidence interval
get_emmeans(pwc_rank) %>% filter(Object == "p", Modification == "aR")


#### Report ####################################################################

# Visualization: box plots with p-values
pwc_grade <- pwc_grade %>% add_xy_position(x = "Excerpt")
pwc_grade.filtered <- pwc_grade %>% filteR(Object == "p", Modifictaion == "aR")
bxp_grade +
  stat_pvalue_manual(
    pwc_grade.filtered, color = "Modification", linetype = "Modification", hide.ns = TRUE,
    tip.length = 0, step.increase = 0.1, step.group.by = "Object"
    ) +
  labs(
    subtitle = get_test_label(res_grade.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_grade)
  )
list_of_plots[[7]] <- bxp_grade
pwc_rank <- pwc_rank %>% add_xy_position(x = "Excerpt")
pwc_rank.filtered <- pwc_rank %>% filteR(Object == "p", Modifictaion == "aR")
bxp_rank +
  stat_pvalue_manual(
    pwc_rank.filtered, color = "Modification", linetype = "Modification", hide.ns = TRUE,
    tip.length = 0, step.increase = 0.1, step.group.by = "Object"
  ) +
  labs(
    subtitle = get_test_label(res_rank.aov, detailed = TRUE),
    caption = get_pwc_label(pwc_rank)
  )
list_of_plots[[8]] <- bxp_rank

# Saving data to pdf or png ####################################################
################################################################################
if (pdf_boolean == TRUE) { # Print plots to a pdf file:
  pdf(file = paste0("anova_threeway/", identifier, ".pdf"))
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
      file = paste0("anova_threeway/", identifier, image_counter_padded, ".png"),
    )
    print(plot)
    dev.off()
    image_counter <- image_counter + 1
  }
}


