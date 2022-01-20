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
# Kruskal-Wallis test is a non-parametric alternative to the one-way ANOVA test.
# It extends the two-samples Wilcoxon test in the situation where there are more
# than two groups to compare. It’s recommended when the assumptions of one-way
# ANOVA test are not met.



#### Kruskal-Wallis test  ######################################################
kruskal_wallis_test <- function(cur_out_var, cur_group){

  #### Parameter formatting
  # Quasiquotation gives us a standard tool to do so: !!, called “unquote”, and
  # pronounced bang-bang. !! tells a quoting function to drop the implicit quotes
  # https://adv-r.hadley.nz/quasiquotation.html
  ####
  # quote() and eval() are opposites.
  # eval(quote(x)) exactly equivalent to x, regardless of what x is
  # http://adv-r.had.co.nz/Computing-on-the-language.html#nse
  #### Data preparation
  data <- data_done %>% filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName)  
  
  my_samples <- data %>% sample_n_by(!!cur_group, size = 1)
  print(my_samples)
  
  #### Summary statistics
  summary_statistics <- data %>% 
    group_by(!!cur_group) %>%
    get_summary_stats(!!cur_out_var, type = "common")
  summary_statistics
  
  #### Visualization
  ggboxplot(data, x = cur_group, y = cur_out_var)
 
  #### Computation
  res.kruskal <- data %>% kruskal_test(cur_out_var ~ cur_group)
  res.kruskal
  
  #### Effect size
  data %>% kruskal_effsize(!!cur_out_var ~ !!cur_group)
  
  #### Multiple pairwise-comparisons
  # From the output of the Kruskal-Wallis test, we know that there is a
  # significant difference between groups, but we don’t know which pairs of
  # groups are different.
  # A significant Kruskal-Wallis test is generally followed up by Dunn’s test
  # to identify which groups are different. It’s also possible to use the
  # Wilcoxon’s test to calculate pairwise comparisons between group levels with
  # corrections for multiple testing.
  
  # Pairwise comparisons using Dunn’s test:
  pwc_dunn <- data %>% 
    dunn_test(cur_out_var ~ cur_group, p.adjust.method = "bonferroni") 
  pwc_dunn
  
  # Pairwise comparisons using Wilcoxon’s test:
  pwc_wilcoxon <- data %>% 
    wilcox_test(cur_out_var ~ cur_group, p.adjust.method = "bonferroni")
  pwc_wilcoxon
  
  #### Report
  
  # Visualization: box plots with p-values for dunn
  pwc_dunn <- pwc_dunn %>% add_xy_position(x = cur_group)
  pwc_dunn_plot <- ggboxplot(data, x = cur_group_str, y = cur_out_var_str) +
    stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(res.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_dunn)
    )
  pwc_dunn_plot
  # Visualization: box plots with p-values for wilcoxon
  pwc_wilcoxon <- pwc_wilcoxon %>% add_xy_position(x = cur_group)
  pwc_wilcoxon_plot <- ggboxplot(data, x = cur_group_str, y = cur_out_var_str) +
    stat_pvalue_manual(pwc_wilcoxon, hide.ns = TRUE) +
    labs(
      subtitle = get_test_label(res.kruskal, detailed = TRUE),
      caption = get_pwc_label(pwc_wilcoxon)
    )
  pwc_wilcoxon_plot
}

#### Kruskal-Wallis test  ######################################################
test <- function(cur_out_var, cur_group){
  #### Parameter formatting
  #print("type of cur_group")
  #print(typeof(cur_group))
  #print("variable")
  #print(cur_group)
  #print("parsed")
  #parsed <- parse(text = cur_group)
  #print(parsed)
  #print("eval")
  #evaled <- eval(cur_group)
  #print(evaled)
  #print("deparsed")
  #deparsed <- deparse(cur_group)
  #print(deparsed)
  #print("deparsed_string")
  #deparsed_string <- str(deparsed)
  #print(deparsed_string)
  
  #### Data preparation
  data <- data_done %>% filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
    select(Excerpt, Object, Modification, Attribute,
           Grade, Rank, Runtime, SubjectName)  
  
  data %>% sample_n_by(!!cur_group, size = 1)
}

main <- function(){
  # Input-Parameters
  #current_study = "Blue"
  #current_phoneme = "p"
  #current_excerpt = "Tempo"
  #current_modification = "aR"
  #current_rating = "Grade"
  current_output_variable = "Grade"
  current_group = "Modification"
  
  kruskal_wallis_test(current_output_variable, current_group)
  #test(current_output_variable, current_group)
}

main()

# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
