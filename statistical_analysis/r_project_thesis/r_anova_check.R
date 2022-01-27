# R-Script
# Analysis of listening panel
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################
# https://www.datanovia.com/en/lessons/anova-in-r/
# One-way ANOVA: an extension of the independent samples t-test for comparing
#  the means in a situation where there are more than two groups. This is the
#  simplest case of ANOVA test where the data are organized into several groups
#  according to only one single grouping variable (also called factor variable).
#  Other synonyms are: 1 way ANOVA, one-factor ANOVA and between-subject ANOVA.

##########################################################################
##### The ANOVA test makes the following assumptions about the data: #####
##########################################################################
#                                                                        #
# Assumption 1 : Independence of the observations.                       #
#  Each subject should belong to only one group.                         #
#  There is no relationship between the observations in each group.      #
#  Having repeated measures for the same participants is not allowed.    #
#                                                                        #
# Assumption 2 : No significant outliers in any cell of the design       #
#                                                                        #
# Assumption 3 : Normality. the data for each design cell should be      #
#  approximately normally distributed.                                   #
#                                                                        #
# Assumption 4 : Homogeneity of variances. The variance of the outcome   #
#  variable should be equal in every cell of the design.                 #
##########################################################################

#### Output preparation
identifier <- "Object"
sink_path <- paste0("anova-check/", identifier, "-sink.txt")
pdf_boolean <- TRUE
png_boolean <- TRUE
options(max.print=100000)
options(dplyr.print_max = 100000)
list_of_plots <- list()

#### One-way ANOVA #############################################################
################################################################################
#### Data preparation
data_anch <- data_done %>% 
  dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) # Tighten the scope
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum,

data_anch %>% sample_n_by(Object, size = 1)

data_anch$Object <- as.factor(data_anch$Object) # "Char" have no levels
sink(sink_path, append = FALSE)
## Levels ######################################################################
print("############ Levels ############")
levels(data_anch$Object)
sink()


#### Check assumptions #########################################################
# Assumption 2 : No significant outliers in any cell of the design       #
#### Outliers
sink(sink_path, append = TRUE)
## Outliers ####################################################################
print("############ Assumption 2 : No significant outliers in any cell of the design ############")
print("############ Outlier detection for Grades ############")
data_anch %>%
  group_by(Object) %>%
  identify_outliers(Grade)
print("############ Outlier detection for Rank ############")
data_anch %>%
  group_by(Object) %>%
  identify_outliers(Rank)
sink()

# Assumption 3 : Normality. the data for each design cell should be      #
#  approximately normally distributed.                                   #
#### Normality assumption
## QQ plot draws the correlation between a given data and the normal distribution.
# Build the linear model
model_grade <- lm(Grade ~ Object, data = data_anch)
model_rank <- lm(Rank ~ Object, data = data_anch)
# Create a QQ plot of residuals
list_of_plots[[1]] <- ggqqplot(residuals(model_grade))#,
                               #main = "Check normality assumption by analyzing the model residuals for Grades")
list_of_plots[[2]] <- ggqqplot(residuals(model_rank))#,
                               #main = "Check normality assumption by analyzing the model residuals for Rank")

# Compute Shapiro-Wilk test of normality
sink(sink_path, append = TRUE)
## Shapiro-Wilk test of normality ##############################################
print("############ Assumption 3 : Normality. the data for each design cell should be approximately normally distributed. ############")
print("#### If the p-value is not significant, we can assume normality.")
print("############ Shapiro-Wilk test of normality for Grades ############")
shapiro_test(residuals(model_grade))
print("############ Shapiro-Wilk test of normality for Rank ############")
shapiro_test(residuals(model_rank))
sink()


# QQ plot draws the correlation between a given data and the normal distribution.
#Create QQ plots for each group level:
list_of_plots[[3]] <- ggqqplot(data_anch,
                               "Grade",
                               facet.by = "Object")#,
                               #main = "Check normality assumption by groups for Grade")
list_of_plots[[4]] <- ggqqplot(data_anch,
                               "Rank",
                               facet.by = "Object")#,
                               #main = "Check normality assumption by groups for Rank")


# Assumption 4 : Homogeneity of variances. The variance of the outcome   #
#  variable should be equal in every cell of the design.                 #
#### Homogeneity of variance assumption
## The residuals versus fits plot can be used to check the homogeneity of variances.
list_of_plots[[5]] <- ggqqplot(model_grade, 1)#,
                           #main = "Check the homogeneity of variances for Grades")
list_of_plots[[6]] <- ggqqplot(model_rank, 1)#,
                           #main = "Check the homogeneity of variances for Rank")

## It’s also possible to use the Levene’s test to check the homogeneity of variances:
sink(sink_path, append = TRUE)
## Levene's test to check homogeneity of variance ##############################
print("############ Assumption 4 : Homogeneity of variances. The variance of the outcome variable should be equal in every cell of the design. ############")
print("#### If the p-value is > 0.05, which would mean it is not significant, then there is no significant difference between variances across groups.")
print("#### Therefore we could then assume the homogeneity of variances in the different groups.")
print("############ Levene test to check homogeneity of variance for Grades. ############")
data_anch %>% levene_test(Grade ~ Object)
print("############ Levene test to check homogeneity of variance for Rank. ############")
data_anch %>% levene_test(Rank ~ Object)
sink()


# Saving data to pdf or png ####################################################
################################################################################
if (pdf_boolean == TRUE) { # Print plots to a pdf file:
  pdf(file = paste0("anova-check/", identifier, ".pdf"))
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
      file = paste0("anova-check/", identifier, image_counter_padded, ".png"),
    )
    print(plot)
    dev.off()
    image_counter <- image_counter + 1
  }
}


