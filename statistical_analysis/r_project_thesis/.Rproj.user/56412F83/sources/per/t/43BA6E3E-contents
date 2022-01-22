# R-Script
# Kruskal-Wallis for study data
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################
# https://www.datanovia.com/en/lessons/kruskal-wallis-test-in-r/
# Kruskal-Wallis test is a non-parametric alternative to the one-way ANOVA test.
#  It extends the two-samples Wilcoxon test in the situation where there are
#  more than two groups to compare. It’s recommended when the assumptions of
#  one-way ANOVA test are not met.

kruskall_object <- function() {
  #### Output preparation
  identifier <- "Object"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName)  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(Object) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(Object) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "Object", y = "Grade", palette = "jco")
  ggboxplot(data, x = "Object", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ Object)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ Object)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ Object)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ Object)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ Object, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ Object, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ Object, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ Object, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "Object")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "Object", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "Object")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "Object", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_excerpt <- function() {
  #### Output preparation
  identifier <- "Excerpt"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName)  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(Excerpt) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(Excerpt) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "Excerpt", y = "Grade", palette = "jco")
  ggboxplot(data, x = "Excerpt", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ Excerpt)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ Excerpt)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ Excerpt)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ Excerpt)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ Excerpt, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ Excerpt, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ Excerpt, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ Excerpt, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "Excerpt")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "Excerpt", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "Excerpt")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "Excerpt", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_modification <- function() {
  #### Output preparation
  identifier <- "Modification"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName)  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(Modification) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(Modification) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "Modification", y = "Grade", palette = "jco")
  ggboxplot(data, x = "Modification", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ Modification)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ Modification)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ Modification)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ Modification)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ Modification, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ Modification, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ Modification, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ Modification, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "Modification")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "Modification", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "Modification")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "Modification", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_attribute <- function() {
  #### Output preparation
  identifier <- "Attribute"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName)  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(Attribute) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(Attribute) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "Attribute", y = "Grade", palette = "jco")
  ggboxplot(data, x = "Attribute", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ Attribute)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ Attribute)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ Attribute)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ Attribute)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ Attribute, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ Attribute, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ Attribute, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ Attribute, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "Attribute")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "Attribute", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "Attribute")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "Attribute", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_subjectSex <- function() {
  #### Output preparation
  identifier <- "SubjectSex"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName, SubjectSex)  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(SubjectSex) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(SubjectSex) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "SubjectSex", y = "Grade", palette = "jco")
  ggboxplot(data, x = "SubjectSex", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ SubjectSex)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ SubjectSex)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ SubjectSex)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ SubjectSex)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ SubjectSex, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ SubjectSex, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ SubjectSex, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ SubjectSex, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "SubjectSex")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "SubjectSex", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "SubjectSex")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "SubjectSex", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_subjectEyesight <- function() {
  #### Output preparation
  identifier <- "SubjectEyesight"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName, SubjectEyesight)  
  #### Tidy Data Up "Normalize"?
  data$SubjectEyesight[data$SubjectEyesight == "ne"] <- "Unimpaired"
  data$SubjectEyesight[data$SubjectEyesight == "Ne"] <- "Unimpaired"
  data$SubjectEyesight[data$SubjectEyesight == "nein"] <- "Unimpaired"
  data$SubjectEyesight[data$SubjectEyesight == "Nein"] <- "Unimpaired"
  data$SubjectEyesight[data$SubjectEyesight == "No"] <- "Unimpaired"
  data$SubjectEyesight[data$SubjectEyesight == "−"] <- "Unimpaired"
  data$SubjectEyesight[data$SubjectEyesight != "Unimpaired"] <- "Impaired"
  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(SubjectEyesight) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(SubjectEyesight) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "SubjectEyesight", y = "Grade", palette = "jco")
  ggboxplot(data, x = "SubjectEyesight", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ SubjectEyesight)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ SubjectEyesight)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ SubjectEyesight)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ SubjectEyesight)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ SubjectEyesight, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ SubjectEyesight, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ SubjectEyesight, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ SubjectEyesight, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "SubjectEyesight")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "SubjectEyesight", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "SubjectEyesight")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "SubjectEyesight", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_subjectLanguage <- function() {
  #### Output preparation
  identifier <- "SubjectLanguage"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName, SubjectLanguage)  
  #### Tidy Data Up "Normalize"?
  data$SubjectLanguage[data$SubjectLanguage == "deutsch"] <- "German"
  data$SubjectLanguage[data$SubjectLanguage == "Russisch"] <- "Russian"
  
  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(SubjectLanguage) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(SubjectLanguage) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "SubjectLanguage", y = "Grade", palette = "jco")
  ggboxplot(data, x = "SubjectLanguage", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ SubjectLanguage)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ SubjectLanguage)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ SubjectLanguage)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ SubjectLanguage)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ SubjectLanguage, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ SubjectLanguage, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ SubjectLanguage, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ SubjectLanguage, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "SubjectLanguage")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "SubjectLanguage", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "SubjectLanguage")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "SubjectLanguage", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ####################################################
  ################################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

kruskall_subjectInterest <- function() {
  #### Output preparation
  identifier <- "SubjectInterest"
  sink_path <- paste0("kruskalwallis/", identifier, "-sink.txt")
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  options(max.print=100000)
  options(dplyr.print_max = 100000)
  
  #### Kruskal-Wallis test  ######################################################
  #### Data preparation
  data <- data_done %>% 
    dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName, SubjectInterest)  

  #### Summary statistics
  summary_statistics_grade <- data %>% 
    group_by(SubjectInterest) %>%
    get_summary_stats(Grade, type = "common")
  summary_statistics_rank <- data %>% 
    group_by(SubjectInterest) %>%
    get_summary_stats(Rank, type = "common")
  
  sink(sink_path, append = FALSE)
  print("Summary Statistics fo Grade")
  print(summary_statistics_grade)
  print("Summary Statistics fo Rank")
  print(summary_statistics_rank)
  sink()
  
  #### Visualization
  ggboxplot(data, x = "SubjectInterest", y = "Grade", palette = "jco")
  ggboxplot(data, x = "SubjectInterest", y = "Rank", palette = "jco")
  
  #### Computation
  resGrade.kruskal <- data %>% kruskal_test(Grade ~ SubjectInterest)
  resRank.kruskal <- data %>% kruskal_test(Rank ~ SubjectInterest)
  sink(sink_path, append = TRUE)
  print("######## Question: We want to know if there is any significant difference between the average ratings of items in the experimental conditions. ########")
  print("######## Kruskal Computation for Grade ########")
  print(resGrade.kruskal)
  print("######## Kruskal Computation for Rank ########")
  print(resRank.kruskal)
  sink()
  
  #### Effect size
  kruskal_effectsize_grade <- data %>% kruskal_effsize(Grade ~ SubjectInterest)
  kruskal_effectsize_rank <- data %>% kruskal_effsize(Rank ~ SubjectInterest)
  sink(sink_path, append = TRUE)
  print("######## The eta squared, based on the H-statistic, can be used as the measure of the Kruskal-Wallis test effect size. ########")
  print("######## It is calculated as follow : eta2[H] = (H - k + 1)/(n - k); where H is the value obtained in the Kruskal-Wallis test; ########")
  print("######## k is the number of groups; n is the total number of observations (M. T. Tomczak and Tomczak 2014). ########")
  print("######## The eta-squared estimate assumes values from 0 to 1 and multiplied by 100 indicates the percentage of variance in the dependent variable explained by the independent variable. ########")
  print("######## The interpretation values commonly in published literature are: ########")
  print("######## 0.01- < 0.06 (small effect), 0.06 - < 0.14 (moderate effect) and >= 0.14 (large effect). ########")
  print("######## Kruskal Effect Size for Grade ########")
  print(kruskal_effectsize_grade)
  print("######## Kruskal Effect Size for Rank ########")
  print(kruskal_effectsize_rank)
  sink()
  
  #### Multiple pairwise-comparisons
  #### Pairwise comparisons using Dunn’s test:
  pwc_dunn_grade <- data %>% 
    dunn_test(Grade ~ SubjectInterest, p.adjust.method = "bonferroni") 
  pwc_dunn_rank <- data %>% 
    dunn_test(Rank ~ SubjectInterest, p.adjust.method = "bonferroni") 
  sink(sink_path, append = TRUE)
  print("######## From the output of the Kruskal-Wallis test, we know that there is a significant difference between groups, but we don’t know which pairs of groups are different. ########")
  print("######## A significant Kruskal-Wallis test is generally followed up by Dunn’s test to identify which groups are different. ########")
  print("######## Compared to the Wilcoxon’s test, the Dunn’s test takes into account the rankings used by the Kruskal-Wallis test. It also does ties adjustments. ########")
  print("######## Pairwise Comparisons Dunn Test for Grade ########")
  print(pwc_dunn_grade)
  print("######## Pairwise Comparisons Dunn Test for Rank ########")
  print(pwc_dunn_rank)
  sink()
  
  #### Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcox_grade <- data %>% 
    wilcox_test(Grade ~ SubjectInterest, p.adjust.method = "bonferroni")
  pwc_wilcox_rank <- data %>% 
    wilcox_test(Rank ~ SubjectInterest, p.adjust.method = "bonferroni")
  sink(sink_path, append = TRUE)
  print("######## It’s also possible to use the Wilcoxon’s test to calculate pairwise comparisons between group levels with corrections for multiple testing. ########")
  print("######## Pairwise Comparisons Wilcox Test for Grade ########")
  print(pwc_wilcox_grade)
  print("######## Pairwise Comparisons Wilcox Test for Rank ########")
  print(pwc_wilcox_rank)
  sink()
  
  #### Report
  # Visualization: box plots with p-values
  # For Dunn test
  pwc_dunn_grade <- pwc_dunn_grade %>% add_xy_position(x = "SubjectInterest")
  plot_pwc_dunn_grade <- ggboxplot(data, x = "SubjectInterest", y = "Grade") +
    stat_pvalue_manual(pwc_dunn_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn_grade)
    )
  # For Wilcox test
  pwc_wilcox_grade <- pwc_wilcox_grade %>% add_xy_position(x = "SubjectInterest")
  plot_pwc_wilcox_grade <- ggboxplot(data, x = "SubjectInterest", y = "Grade") +
    stat_pvalue_manual(pwc_wilcox_grade, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(resGrade.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcox_grade)
    )
  
  # Saving data to pdf or png ##################################################
  ##############################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-dunn.png"),
    )
    print(plot_pwc_dunn_grade)
    dev.off()
    png(
      file = paste0("kruskalwallis/", identifier, "-pwc-wilcox.png"),
    )
    print(plot_pwc_wilcox_grade)
    dev.off()
  }
}

################################################################################

################################################################################

main <- function() {
  #kruskall_object()
  #kruskall_excerpt()
  #kruskall_modification()
  #kruskall_attribute()
  #kruskall_subjectSex()
  #kruskall_subjectEyesight()
  #kruskall_subjectLanguage()
  #kruskall_subjectInterest()
}

main()
