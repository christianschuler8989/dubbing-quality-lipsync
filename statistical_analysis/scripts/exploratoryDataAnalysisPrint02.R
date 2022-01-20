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
#                       ##############################                         #
#                       ## First round of questions ##                         #
#                       ##############################                         #
#                                                                              #
################################################################################
# As a function, callable with different data-sets as parameters
# EXCERPT_ITEM_MODIFICATION_ATTRIBUTE
# = "All combinations of these are the set of "conditions" being testet"


###############################
# Function: Plot of qualities #
###############################
plot_quality <- function(data, my_x, my_y, my_title) {
  current_plot <- ggplot(data, aes(x = data[[my_x]], y = data[[my_y]])) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    # if (my_mode == "mode_ranking") {
    #  ylim(rev(range(data[[my_y]]))) +
    # }
    ggtitle(my_title) +
    theme(
      plot.title = element_text(
        color = "darkgreen",
        size = 24,
        face = "bold.italic"
      ),
      axis.title.x = element_text(
        color = "blue",
        size = 14,
        face = "bold"
      ),
      axis.title.y = element_text(
        color = "#993333",
        size = 14,
        face = "bold"
      )
    ) +
    theme(axis.text.x = element_text(
      size = 14,
      angle = 90,
      vjust = 0.5,
      hjust = 0.98
    )) +
    theme(
      plot.background = element_rect(fill = "#FFFF99"),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    )
  return(current_plot)
}
##########################################################
# Function: Plot of qualities of ranks (reversed y-axis) # Temp Copy. I'll clean up later, I promise!
##########################################################
plot_quality_rank_temp <- function(data, my_x, my_y, my_title, my_color) {
  current_plot <- ggplot(data, aes(x = data[[my_x]], y = data[[my_y]], color = data[[my_color]])) +
    geom_boxplot(outlier.colour = "red") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    ylim(rev(range(data[[my_y]]))) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    ggtitle(my_title) +
    theme(
      plot.title = element_text(
        color = "#000000",
        size = 24,
        face = "bold.italic"
      ),
      axis.title.x = element_text(
        color = "#000000",
        size = 14,
        face = "bold"
      ),
      axis.title.y = element_text(
        color = "#000000",
        size = 14,
        face = "bold"
      )
    ) +
    theme(
      plot.background = element_rect(fill = "#FFFFFF"),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    )
  return(current_plot)
}
##########################################################
# Function: Plot of qualities of ranks (reversed y-axis) #
##########################################################
plot_quality_rank <- function(data, my_x, my_y, my_title) {
  current_plot <- ggplot(data, aes(x = data[[my_x]], y = data[[my_y]])) +
    geom_boxplot(outlier.colour = "red") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    ylim(rev(range(data[[my_y]]))) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    ggtitle(my_title) +
    theme(
      plot.title = element_text(
        color = "#000000",
        size = 24,
        face = "bold.italic"
      ),
      axis.title.x = element_text(
        color = "#000000",
        size = 14,
        face = "bold"
      ),
      axis.title.y = element_text(
        color = "#000000",
        size = 14,
        face = "bold"
      )
    ) +
    theme(
      plot.background = element_rect(fill = "#FFFFFF"),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    )
  return(current_plot)
}
####################################################
# Function: Plot of qualities with colors (groups) #
####################################################
plot_quality_color <- function(data, my_x, my_y, my_title, my_color) {
  current_plot <- ggplot(data, aes(
    x = data[[my_x]],
    y = data[[my_y]],
    color = data[[my_color]]
  )) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    ggtitle(my_title) +
    theme(
      plot.title = element_text(
        color = "darkgreen",
        size = 24,
        face = "bold.italic"
      ),
      axis.title.x = element_text(
        color = "blue",
        size = 14,
        face = "bold"
      ),
      axis.title.y = element_text(
        color = "#993333",
        size = 14,
        face = "bold"
      )
    )
  return(current_plot)
}

plot_quality_pdf <- function(data, identifier) {
  ######### How well do the single subjects grade? ###############################
  data_group_subj <- data %>% group_by(SubjectName)
  p001 <- plot_quality(data_group_subj, "SubjectName", "Grade", "Grades per Subject")

  #################################################
  # Ratings of the Hidden-Reference (High-Anchor) #
  #################################################
  # Data of References
  data_refe <- data %>% filter(Attribute == 0)

  p002 <- plot_quality_color(data_refe, "Excerpt", "Grade", "Grades of Reference (High-Anchor)", "SubjectName")

  p003 <- plot_quality(data_refe, "SubjectName", "Grade", "Grades of High-Anchor (subject)")

  p004 <- plot_quality(data_refe, "Excerpt", "Grade", "Grades of High-Anchor (excerpt)")

  p005 <- plot_quality(data_refe, "TestID", "Grade", "Grades of High-Anchor (trial)")

  ######### How long do the single subjects grade? ###############################
  dataGroupSubj <- data %>% group_by(SubjectName)
  p006 <- ggplot(dataGroupSubj, aes(x = SubjectName, y = Runtime / 1000)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(
      size = 14,
      angle = 90,
      vjust = 0.5,
      hjust = 0.5
    )) +
    ggtitle("Runtimes per Subject (max. 300 s.)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    ) +
    # Change y-axis limits
    scale_y_continuous(breaks = seq(0, 900, 60))

  ######### How well do the single excerpts (video-clips) perform? ###############
  dataGroupExce <- data %>% group_by(Excerpt)
  p007 <- ggplot(dataGroupExce, aes(x = Excerpt, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(size = 14, angle = 65)) +
    ggtitle("Grades per Excerpt") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######### How well do the single objects (phonemes) perform? #####################
  dataGroupObje <- data %>% group_by(Object)
  p008 <- ggplot(dataGroupObje, aes(x = Object, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(size = 18)) +
    ggtitle("Grades per Object") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######### How well do the single modifications (type of) perform? ##############
  dataGroupModi <- data %>% group_by(Modification)
  p009 <- ggplot(dataGroupModi, aes(x = Modification, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(size = 12, vjust = 1, hjust = 1)) +
    ggtitle("Grades per Modification") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######### How well do the single attributes (level of change) perform? #########
  dataGroupAttr <- data %>%
    mutate(Attribute = as.character(Attribute)) %>%
    group_by(Attribute)
  p010 <- ggplot(dataGroupAttr, aes(x = Attribute, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(size = 18)) +
    ggtitle("Grades per Attribute") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######### How well does every single item (combination) perform? ###############
  dataGroupItem <- data %>% group_by(Item)
  p011 <- ggplot(dataGroupItem, aes(x = Item, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1)) +
    ggtitle("Grades per Item") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######## Just the a ############################################################
  dataGroupItemA <- data %>%
    group_by(Item) %>%
    filter(Object == "a")
  p012 <- ggplot(dataGroupItemA, aes(x = Item, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1)) +
    ggtitle("Grades per Item (a)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######## Just the p ############################################################
  dataGroupItemP <- data %>%
    group_by(Item) %>%
    filter(Object == "p")
  p013 <- ggplot(dataGroupItemP, aes(x = Item, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1)) +
    ggtitle("Grades per Item (p)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######## Just the w ############################################################
  dataGroupItemW <- data %>%
    group_by(Item) %>%
    filter(Object == "w")
  p014 <- ggplot(dataGroupItemW, aes(x = Item, y = Grade)) +
    geom_boxplot(outlier.colour = "hotpink") +
    geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1 / 4) +
    theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1)) +
    ggtitle("Grades per Item (w)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold")
    )

  ######## Kind of "Interconnected" using "Facet" ################################
  ################################################################################
  # Get all observations where Object is a
  dataFilterA <- filter(data, Object == "a")
  dataFilterASelectFacet <- select(dataFilterA, ResultID, Excerpt, Modification, Attribute, Grade)

  ################################################################################
  p015 <- ggplot(data = dataFilterASelectFacet) +
    geom_point(mapping = aes(x = Excerpt, y = Grade)) +
    facet_grid(Modification ~ Attribute) +
    ggtitle("Grades per Excerpt to Modification \n to Attribute (a)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
      axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5, hjust = 1)
    ) +
    theme(plot.background = element_rect(fill = "#FFFFCC"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
    theme(panel.background = element_rect(fill = "#FFCC99"))

  ################################################################################
  # Get all observations where Object is p
  dataFilterP <- filter(data, Object == "p")
  dataFilterPSelectFacet <- select(dataFilterP, ResultID, Excerpt, Modification, Attribute, Grade)

  ################################################################################
  p016 <- ggplot(data = dataFilterPSelectFacet) +
    geom_point(mapping = aes(x = Excerpt, y = Grade)) +
    facet_grid(Modification ~ Attribute) +
    ggtitle("Grades per Excerpt to Modification \n to Attribute (p)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
      axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5, hjust = 1)
    ) +
    theme(plot.background = element_rect(fill = "#FFFFCC"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
    theme(panel.background = element_rect(fill = "#FFCC99"))

  ################################################################################
  # Get all observations where Object is w
  dataFilterW <- filter(data, Object == "w")
  dataFilterWSelectFacet <- select(dataFilterW, ResultID, Excerpt, Modification, Attribute, Grade)

  ################################################################################
  p017 <- ggplot(data = dataFilterWSelectFacet) +
    geom_point(mapping = aes(x = Excerpt, y = Grade)) +
    facet_grid(Modification ~ Attribute) +
    ggtitle("Grades per Excerpt to Modification \n to Attribute (w)") +
    theme(
      plot.title = element_text(color = "darkgreen", size = 24, face = "bold.italic"),
      axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
      axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
      axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5, hjust = 1)
    ) +
    theme(plot.background = element_rect(fill = "#FFFFCC"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
    theme(panel.background = element_rect(fill = "#FFCC99"))

  #########
  # Ranks #
  #########
  data_group_subj_rank <- data %>% group_by(SubjectName)
  p018 <- plot_quality_rank(data_group_subj_rank, "SubjectName", "Rank", "Ranks per Subject")

  data_refe <- data %>% filter(Attribute == 0)
  # p019 <- plot_quality_color(data_refe_subj, "Excerpt", "Grade", "Grades of Reference (High-Anchor)", "SubjectName")

  p019 <- plot_quality_rank(data_refe, "SubjectName", "Rank", "Ranks of High-Anchor (subject)")

  p020 <- plot_quality_rank(data_refe, "Excerpt", "Rank", "Ranks of High-Anchor (excerpt)")

  p021 <- plot_quality_rank(data_refe, "TestID", "Rank", "Ranks of High-Anchor (trial)")

  ######### How well do the single excerpts (video-clips) perform (rank)? ######
  dataGroupExce <- data %>% group_by(Excerpt)
  p022 <- plot_quality_rank(dataGroupExce, "Excerpt", "Rank", "Ranks per Excerpt")

  ######### How well do the single objects (phonemes) perform (rank)? ##########
  dataGroupObje <- data %>% group_by(Object)
  p023 <- plot_quality_rank(dataGroupObje, "Object", "Rank", "Ranks per Object")

  ######### How well do the single modifications (type of) perform (rank)? #####
  dataGroupModi <- data %>% group_by(Modification)
  p024 <- plot_quality_rank(dataGroupModi, "Modification", "Rank", "Ranks per Modification")

  ######### How well do the single attributes (level of change) perform(rank)? #
  dataGroupAttr <- data %>%
    mutate(Attribute = as.character(Attribute)) %>%
    group_by(Attribute)
  p025 <- plot_quality_rank(dataGroupAttr, "Attribute", "Rank", "Ranks per Attribute")

  ######## How consistent did the subjects rate the anchor-trials? #############
  # First Anchor-Trial-ID: 055
  # Second Anchor-Trial-ID: 062
  dataAnchorTrial055 <- data %>%
    filter(TrialID == 055) %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p026 <- plot_quality_rank(dataAnchorTrial055, "ItemNew", "Rank", "Ranks per Item for Trial 055")

  dataAnchorTrial062 <- data %>%
    filter(TrialID == 062) %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p027 <- plot_quality_rank(dataAnchorTrial062, "ItemNew", "Rank", "Ranks per Item for Trial 062")
  # Subject01 = UristMc1400f9
  # Subject01 = UristMcaf3821
  dataAnchorTrial055Subj01 <- data_rare %>%
    # filter(TrialID == 055, SubjectName == "UristMc1400f9") %>%
    filter(TrialID == 055, SubjectName == "laurenzio") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p028 <- plot_quality_rank(dataAnchorTrial055Subj01, "ItemNew", "Rank", "Ranks per Item for Trial 055 Subj1")
  dataAnchorTrial062Subj01 <- data_rare %>%
    # filter(TrialID == 062, SubjectName == "UristMc1400f9") %>%
    filter(TrialID == 062, SubjectName == "laurenzio") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p029 <- plot_quality_rank(dataAnchorTrial062Subj01, "ItemNew", "Rank", "Ranks per Item for Trial 062 Subj1")

  dataAnchorTrial055Subj02 <- data_rare %>%
    # filter(TrialID == 055, SubjectName == "UristMc1400f9") %>%
    filter(TrialID == 055, SubjectName == "Biggus Dickus") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p030 <- plot_quality_rank(dataAnchorTrial055Subj02, "ItemNew", "Rank", "Ranks per Item for Trial 055 Subj2")
  dataAnchorTrial062Subj02 <- data_rare %>%
    # filter(TrialID == 062, SubjectName == "UristMc1400f9") %>%
    filter(TrialID == 062, SubjectName == "Biggus Dickus") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p031 <- plot_quality_rank(dataAnchorTrial062Subj02, "ItemNew", "Rank", "Ranks per Item for Trial 062 Subj2")

  # Both together
  dataAnchorTrial055Subj <- data_rare %>%
    # filter(TrialID == 062, SubjectName == "UristMc1400f9") %>%
    filter(TrialID == 055) %>%
    filter(SubjectName == "Biggus Dickus" | SubjectName == "laurenzio") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p032 <- plot_quality_rank_temp(dataAnchorTrial055Subj, "ItemNew", "Rank", "Ranks per Item for Trial 055", "SubjectName")

  dataAnchorTrial062Subj <- data_rare %>%
    # filter(TrialID == 062, SubjectName == "UristMc1400f9") %>%
    filter(TrialID == 062) %>%
    filter(SubjectName == "Biggus Dickus" | SubjectName == "laurenzio") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  p033 <- plot_quality_rank_temp(dataAnchorTrial062Subj, "ItemNew", "Rank", "Ranks per Item for Trial 062", "SubjectName")

  # Print plots to a pdf file:
  pdf(paste0("explore_02_qualitative_", identifier, ".pdf"))
  # print(p001)
  # print(p002)
  # print(p003)
  # print(p004)
  # print(p005)
  # print(p006)
  # print(p007)
  # print(p008)
  # print(p009)
  # print(p010)
  # print(p011)
  # print(p012)
  # print(p013)
  # print(p014)
  # print(p015)
  # print(p016)
  # print(p017)
  # print(p018)
  # print(p019)
  # print(p020)
  # print(p021)
  # print(p022)
  # print(p023)
  # print(p024)
  # print(p025)
  print(p026)
  print(p027)
  print(p028)
  print(p029)
  print(p030)
  print(p031)
  print(p032)
  print(p033)
  dev.off()
}


main <- function() {
  # plot_quality_pdf(data_prep, "prep")
  # plot_quality_pdf(data_rare, "rare")
  # plot_quality_pdf(data_medi, "medi")
  plot_quality_pdf(data_done, "done")
}

main()


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
