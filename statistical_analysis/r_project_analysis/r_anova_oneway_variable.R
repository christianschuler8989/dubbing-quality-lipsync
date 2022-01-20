# R-Script
# ANOVA for study data
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

# Plot-preparation
list_of_plots <- list()
pdf_boolean <- TRUE
png_boolean <- TRUE
identifier <- "Attribute"

sink_path <- paste0("anova_oneway/", identifier, "-sink.txt")
options(max.print=1000)
options(dplyr.print_max = 1000)

#### One-way ANOVA #############################################################
################################################################################
#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) # Tighten the scope
  #SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

do.call(sample_n_by, list(data_anch, as.name(identifier), size=1))

#data_anch %>% sample_n_by(as.name(identifier), size = 3)

#current_name <- as.name(identifier)
#current_name

#do.call("<-", list(data_anch[current_name], as.factor(data_anch[current_name])))


#data_anch$Attribute <- as.factor(data_anch$Attribute) # "Char" have no levels
sink(sink_path)
## Levels ######################################################################
#do.call(levels, list(data_anch, as.name(identifier)))
levels(data_anch[[as.name(identifier)]])
sink()

#### Summary statistics
data_anch %>%
  group_by(as.name(identifier)) %>%
  get_summary_stats(Grade, type = "mean_sd")

#### Visualization
list_of_plots[[1]] <- ggboxplot(data_anch, x = "Attribute", y = "Grade", main = "Summary statistics")

#### Check assumptions #########################################################
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
data_anch %>%
  group_by(Attribute) %>%
  identify_outliers(Grade)
sink()

#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model <- lm(Grade ~ Attribute, data = data_anch)
# Create a QQ plot of residuals
list_of_plots[[2]] <- ggqqplot(residuals(model), main = "Check normality assumption by analyzing the model residuals")

# Compute Shapiro-Wilk test of normality
shapiro_test(residuals(model))

#### In the example of the tutorial this happens:
# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
list_of_plots[[3]] <- ggqqplot(data_anch, "Grade", facet.by = "Attribute", main = "Check normality assumption by groups")

#### Homogneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
list_of_plots[[4]] <- plot(model, 1, main = "Check the homogeneity of variances")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
data_anch %>% levene_test(Grade ~ Attribute)

#### Computation ###############################################################
sink(sink_path, append = TRUE)
## Computation #################################################################
res.aov <- data_anch %>% anova_test(Grade ~ Attribute)
res.aov
sink()

######## Post-hoc tests
## A significant one-way ANOVA is generally followed up by Tukey post-hoc tests
## to perform multiple pairwise comparisons between groups. 
## Key R function: tukey_hsd() [rstatix].

# Pairwise comparisons
sink(sink_path, append = TRUE)
## Post-hoc test: pairwise comparisons #########################################
pwc <- data_anch %>% tukey_hsd(Grade ~ Attribute)
pwc
sink()

#### Report ####################################################################

# Visualization: box plots with p-values
pwc <- pwc %>% add_xy_position(x = "Attribute")
list_of_plots[[5]] <- ggboxplot(data_anch, x = "Attribute", y = "Grade", main = "ANOVA box plots with p-values") +
  stat_pvalue_manual(pwc, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.aov, detailed = TRUE),
    caption = get_pwc_label(pwc)
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


