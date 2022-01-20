# Rscript ( #!/usr/bin/env Rscript ) ??
#
# Input: Preprocessed data from the BA-study on lip-synchrony
#
# Output: New insights
#
# Author: Christian (Doofnase) Schuler
# Date: 2021 Nov
################################################################################

#### [TODO] Calling script with input-parameters vs. callin function from script
# args <- commandArgs(trailingOnly = TRUE)
#
# Test if there are arguments: if not, use default
# if (length(args) == 0) {
#  #-# stop("At least one argument must be supplied (input file).n", call.=FALSE)
#  args[1] <- "#FFFFCC" # Default color for background of plots
#  args[2] <- "d" # Default mode
#  args[3] <- " " # To prevent null-pointing
#  args[4] <- " "
#  args[5] <- " "
# } else if (length(args) == 1) {
#  args[2] <- "d" # Default mode
#  args[3] <- " " # To prevent null-pointing
#  args[4] <- " "
#  args[5] <- " "
# }
#### [TODO] Calling script with input-parameters vs. callin function from script

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
# Load ggpubr for arranging publishable plots
library(ggpubr)

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
#                        ######################                                #
#                        # Plot of quantities #                                #
#                        ######################                                #
#                                                                              #
################################################################################
# As a function, callable with different data-sets as parameters

################################
# Function: Plot of quantities #
################################
plotQuantity <- function(data,
                         my_x,
                         my_y,
                         my_title,
                         bg_color,
                         ti_color,
                         xa_color,
                         ya_color) {
  current_plot <- ggplot(data, aes(x = data[[my_x]], y = data[[my_y]])) +
    geom_bar(fill = "firebrick", stat = "identity") + # Y axis is explicit.
    ggtitle(my_title) +
    xlab(my_x) +
    ylab(my_y) +
    # Change the appearance of the main title and axis labels
    theme(
      plot.title = element_text(
        color = ti_color,
        size = 24,
        face = "bold.italic"
      ),
      axis.title.x = element_text(
        color = xa_color,
        size = 14,
        face = "bold"
      ),
      axis.title.y = element_text(
        color = ya_color,
        size = 14,
        face = "bold"
      )
    ) +
    theme(
      axis.text.x = element_text(
        size = 10,
        angle = 90,
        vjust = 0.5,
        hjust = 0.98
      ),
      axis.text.y = element_text(size = 18)
    ) +
    theme(
      #### [TODO] Calling script with input-parameters vs. callin function from script
      #      plot.background = element_rect(fill = args[1]),
      #### [TODO] Calling script with input-parameters vs. callin function from script
      plot.background = element_rect(fill = bg_color),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    ) #+ # top, right, bottom, left
  # Color of panels and lines for the plot-grid mid/big
  # theme(
  #  panel.background = element_rect(fill = "steelblue"),
  #  panel.grid.major = element_line(colour = "black", size = 1),
  #  panel.grid.minor = element_line(colour = "blue", size = 1)
  # )
  return(current_plot)
}
##################################################
# Function: Plot of quantities in compact format #
##################################################
plotQuantityTiny <- function(data,
                             my_x,
                             my_y,
                             studycolor,
                             bg_color,
                             ti_color,
                             xa_color,
                             ya_color) {
  current_plot <- ggplot(data, aes(x = data[[my_x]], y = data[[my_y]])) +
    geom_bar(fill = "firebrick", stat = "identity") + # Y axis is explicit.
    # Change the appearance of the main title and axis labels
    xlab(studycolor) +
    theme(plot.title = element_blank()) +
    theme(axis.title.y = element_blank()) +
    theme(axis.text.x = element_blank()) +
    theme(
      #### [TODO] Calling script with input-parameters vs. callin function from script
      #      plot.background = element_rect(fill = args[1])
      #### [TODO] Calling script with input-parameters vs. callin function from script
      plot.background = element_rect(fill = bg_color)
    )
  # theme(plot.background = element_rect(fill = "lightblue")) +
  # theme(panel.background = element_rect(fill = "lightblue"))
  return(current_plot)
}


plotQuantityNine <- function(plotname,
                             plot1, plot2, plot3,
                             plot4, plot5, plot6,
                             plot7, plot8, plot9) {
  # png(filename = paste(plotname, ".png"), width = 1200, height = 1200)
  current_plot <- ggarrange(
    plot1, plot2, plot3,
    plot4, plot5, plot6,
    plot7, plot8, plot9,
    ncol = 3,
    nrow = 3,
    labels = "AUTO"
  )
  return(current_plot)
  # print(current_plot)
  # dev.off()
}


plotQuantityPdf <- function(data,
                            identifier,
                            bg_color,
                            ti_color,
                            xa_color,
                            ya_color) {
  ##############################################################################
  # The study-colors
  data_blue <- filter(data, Study == "Blue")
  data_yellow <- filter(data, Study == "Yellow")
  data_red <- filter(data, Study == "Red")
  data_purple <- filter(data, Study == "Purple")
  data_orange <- filter(data, Study == "Orange")
  data_teal <- filter(data, Study == "Teal")
  data_grey <- filter(data, Study == "Grey")
  data_mustard <- filter(data, Study == "Mustard")
  data_olive <- filter(data, Study == "Olive")
  data_green <- filter(data, Study == "Green")
  ##############################################################################
  # Distinction of multiple occurrences of the same subject
  # => (someone did multiple sessions)
  ##################
  # dplyr-distinct #
  ##################
  data_blue_distinct <- data_blue %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_yellow_distinct <- data_yellow %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_red_distinct <- data_red %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_purple_distinct <- data_purple %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_orange_distinct <- data_orange %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_teal_distinct <- data_teal %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_grey_distinct <- data_grey %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_mustard_distinct <- data_mustard %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_olive_distinct <- data_olive %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)
  data_green_distinct <- data_green %>%
    distinct(TestID, SubjectName, .keep_all = TRUE)

  ####################################################
  # Number of finished trials per study-run ( color) #
  ####################################################
  data_study_num <- data %>%
    group_by(Study, TestID)
  per_study_num <- summarise(data_study_num, FinishedTrials = n() / 6)
  # /6 because each trial has 6 entries (one for each excerpt)
  p001 <- plotQuantity(
    per_study_num,
    "Study",
    "FinishedTrials",
    "Finished Trials per Study",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  ##############################################################################
  # Just for one single color
  data_trial_num_blue <- data_blue %>% group_by(TestID)
  per_trial_num_blue <- summarise(data_trial_num_blue, Gradings = n() / 6)
  # /6 because each trial has 6 entries (one for each excerpt)
  data_trial_num_yellow <- data_yellow %>% group_by(TestID)
  per_trial_num_yellow <- summarise(data_trial_num_yellow, Gradings = n() / 6)
  data_trial_num_red <- data_red %>% group_by(TestID)
  per_trial_num_red <- summarise(data_trial_num_red, Gradings = n() / 6)
  data_trial_num_purple <- data_purple %>% group_by(TestID)
  per_trial_num_purple <- summarise(data_trial_num_purple, Gradings = n() / 6)
  data_trial_num_orange <- data_orange %>% group_by(TestID)
  per_trial_num_orange <- summarise(data_trial_num_orange, Gradings = n() / 6)
  data_trial_num_teal <- data_teal %>% group_by(TestID)
  per_trial_num_teal <- summarise(data_trial_num_teal, Gradings = n() / 6)
  data_trial_num_grey <- data_grey %>% group_by(TestID)
  per_trial_num_grey <- summarise(data_trial_num_grey, Gradings = n() / 6)
  data_trial_num_mustard <- data_mustard %>% group_by(TestID)
  per_trial_num_mustard <- summarise(data_trial_num_mustard, Gradings = n() / 6)
  data_trial_num_olive <- data_olive %>% group_by(TestID)
  per_trial_num_olive <- summarise(data_trial_num_olive, Gradings = n() / 6)
  data_trial_num_green <- data_green %>% group_by(TestID)
  per_trial_num_green <- summarise(data_trial_num_green, Gradings = n() / 6)


  plot1 <- plotQuantityTiny(
    per_trial_num_blue,
    "TestID",
    "Gradings",
    "Blue",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot2 <- plotQuantityTiny(
    per_trial_num_yellow,
    "TestID",
    "Gradings",
    "Yellow",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot3 <- plotQuantityTiny(
    per_trial_num_red,
    "TestID",
    "Gradings",
    "Red",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot4 <- plotQuantityTiny(
    per_trial_num_purple,
    "TestID",
    "Gradings",
    "Purple",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot5 <- plotQuantityTiny(
    per_trial_num_orange,
    "TestID",
    "Gradings",
    "Orange",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot6 <- plotQuantityTiny(
    per_trial_num_teal,
    "TestID",
    "Gradings",
    "Teal",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot7 <- plotQuantityTiny(
    per_trial_num_grey,
    "TestID",
    "Gradings",
    "Grey",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot8 <- plotQuantityTiny(
    per_trial_num_mustard,
    "TestID",
    "Gradings",
    "Mustard",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  plot9 <- plotQuantityTiny(
    per_trial_num_olive,
    "TestID",
    "Gradings",
    "Olive",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  p002 <- plotQuantityNine(
    "TestName",
    plot1, plot2, plot3,
    plot4, plot5, plot6,
    plot7, plot8, plot9
  )


  ##############################################################################
  # Just for one single color- but distinct
  data_trial_num_blue_dist <- data_blue_distinct %>% group_by(TestID)
  per_trial_num_blue_dist <- summarise(data_trial_num_blue_dist, Gradings = n())
  plot_blue_dist <- plotQuantityTiny(
    per_trial_num_blue_dist,
    "TestID",
    "Gradings",
    "Blue",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  data_trial_num_green_dist <- data_green_distinct %>% group_by(TestID)
  per_trial_num_green_dist <- summarise(
    data_trial_num_green_dist,
    Gradings = n()
  )
  plot_green_dist <- plotQuantityTiny(
    per_trial_num_green_dist,
    "TestID",
    "Gradings",
    "Green",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  p003 <- ggarrange(
    plot_blue_dist, plot_green_dist,
    ncol = 2, nrow = 1, labels = "AUTO"
  )

  ###################################################
  # Number of participants (+ Finished trials each) #
  ###################################################
  data_subj_num <- data %>%
    group_by(SubjectName)
  per_subj <- summarise(data_subj_num, FinishedTrials = n() / 6)
  p004 <- plotQuantity(
    per_subj,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  ####################################################################
  # Number of participants (+ Finished trials each) (only one color) #
  ####################################################################
  data_subj_num_blue <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Blue") %>%
    group_by(SubjectName)
  per_subj_blue <- summarise(data_subj_num_blue, FinishedTrials = n() / 6)
  p005 <- plotQuantity(
    per_subj_blue,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Blue)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_yellow <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Yellow") %>%
    group_by(SubjectName)
  per_subj_yellow <- summarise(data_subj_num_yellow, FinishedTrials = n() / 6)
  p006 <- plotQuantity(
    per_subj_yellow,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Yellow)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_red <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Red") %>%
    group_by(SubjectName)
  per_subj_red <- summarise(data_subj_num_red, FinishedTrials = n() / 6)
  p007 <- plotQuantity(
    per_subj_red,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Red)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_purple <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Purple") %>%
    group_by(SubjectName)
  per_subj_purple <- summarise(data_subj_num_purple, FinishedTrials = n() / 6)
  p008 <- plotQuantity(
    per_subj_purple,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Purple)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_orange <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Orange") %>%
    group_by(SubjectName)
  per_subj_orange <- summarise(data_subj_num_orange, FinishedTrials = n() / 6)
  p009 <- plotQuantity(
    per_subj_orange,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Orange)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_teal <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Teal") %>%
    group_by(SubjectName)
  per_subj_teal <- summarise(data_subj_num_teal, FinishedTrials = n() / 6)
  p010 <- plotQuantity(
    per_subj_teal,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Teal)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_grey <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Grey") %>%
    group_by(SubjectName)
  per_subj_grey <- summarise(data_subj_num_grey, FinishedTrials = n() / 6)
  p011 <- plotQuantity(
    per_subj_grey,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Grey)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_mustard <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Mustard") %>%
    group_by(SubjectName)
  per_subj_mustard <- summarise(data_subj_num_mustard, FinishedTrials = n() / 6)
  p012 <- plotQuantity(
    per_subj_mustard,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Mustard)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  data_subj_num_olive <- data %>%
    # select(Study == "Blue") %>%
    filter(Study == "Olive") %>%
    group_by(SubjectName)
  per_subj_olive <- summarise(data_subj_num_olive, FinishedTrials = n() / 6)
  p013 <- plotQuantity(
    per_subj_olive,
    "SubjectName",
    "FinishedTrials",
    "Finished Trials per Subject (Olive)",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )

  ###############################
  # Number of grades per object #
  ###############################
  data_obje_num <- data %>%
    group_by(Object)
  per_obje <- summarise(data_obje_num, Grades = n())
  p014 <- plotQuantity(
    per_obje,
    "Object",
    "Grades",
    "Grades per Object",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  ################################
  # Number of grades per excerpt #
  ################################
  data_exce_num <- data %>%
    group_by(Excerpt)
  per_exce <- summarise(data_exce_num, Grades = n())
  p015 <- plotQuantity(
    per_exce,
    "Excerpt",
    "Grades",
    "Grades per Excerpt",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  #####################################
  # Number of grades per modification #
  #####################################
  data_modi_num <- data %>%
    group_by(Modification)
  per_modi <- summarise(data_modi_num, Grades = n())
  p016 <- plotQuantity(
    per_modi,
    "Modification",
    "Grades",
    "Grades per Modification",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  #################################
  # Number of grades per attribute #
  #################################
  data_attr_num <- data %>%
    group_by(Attribute)
  per_attr <- summarise(data_attr_num, Grades = n())
  p017 <- plotQuantity(
    per_attr,
    "Attribute",
    "Grades",
    "Grades per Attribute",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  #############################
  # Number of grades per item #
  #############################
  data_item_num <- data %>%
    group_by(Item)
  per_item <- summarise(data_item_num, Grades = n())
  p018 <- plotQuantity(
    per_item,
    "Item",
    "Grades",
    "Grades per Item",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  ##############################
  # Number of grades per grade #
  ##############################
  data_grad_num <- data %>%
    group_by(Grade)
  per_grad <- summarise(data_grad_num, Grades = n())
  p019 <- plotQuantity(
    per_grad,
    "Grade",
    "Grades",
    "Grades per Grade",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )
  #############################
  # Number of grades per rank #
  #############################
  data_rank_num <- data %>%
    group_by(Rank)
  per_rank <- summarise(data_rank_num, Grades = n())
  p020 <- plotQuantity(
    per_rank,
    "Rank",
    "Grades",
    "Grades per Rank",
    bg_color,
    ti_color,
    xa_color,
    ya_color
  )


  # Print plots to a pdf file:
  pdf(paste0("explore_01_quantitative_", identifier, ".pdf"))
  print(p001)
  print(p002)
  print(p003)
  print(p004)
  print(p005)
  print(p006)
  print(p007)
  print(p008)
  print(p009)
  print(p010)
  print(p011)
  print(p012)
  print(p013)
  print(p014)
  print(p015)
  print(p016)
  print(p017)
  print(p018)
  print(p019)
  print(p020)
  dev.off()
}

main <- function() {
  #### [TODO] Calling script with input-parameters vs. callin function from script
  # if (args[2] == "d") {
  #  plotQuantityPdf(data_done, "done")
  # }
  # if (args[3] == "m") {
  #  plotQuantityPdf(data_medi, "medi")
  # }
  # if (args[4] == "r") {
  #  plotQuantityPdf(data_rare, "rare")
  # }
  # if (args[5] == "p") {
  #  plotQuantityPdf(data_prep, "prep")
  # }
  #### [TODO] Calling script with input-parameters vs. callin function from script
  background_color <- "#FFFFFF"
  title_color <- "#000000"
  x_axis_title_color <- "#000000"
  y_axis_title_color <- "#000000"

  plotQuantityPdf(
    data_done,
    "done",
    background_color,
    title_color,
    x_axis_title_color,
    y_axis_title_color
  )
  # plotQuantityPdf(data_medi, "medi")
  # plotQuantityPdf(data_rare, "rare")
  # plotQuantityPdf(data_prep, "prep")
}

main()

# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
