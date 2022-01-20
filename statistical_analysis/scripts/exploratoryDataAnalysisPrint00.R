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
# Load ggpubr for arranging publishable plots
# library(ggpubr)
# For printing dataframe to pdf
library(gridExtra)

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



################################################################################
#                                                                              #
#                        ############################                          #
#                        ## First look at the data ##                          #
#                        ############################                          #
#                                                                              #
################################################################################

######### Quantity of the data #################################################
print(paste(
  "Prep:", nrow(data_prep),
  "Rare:", nrow(data_rare),
  "Medi:", nrow(data_medi),
  "Done:", nrow(data_done),
  sep = " "
))



######## Hiding in function and only for manual use ############################
manualUse <- function() {
  #### How many Trials are in each color (Study) ? #############################
  # It is only going to show the ones, that actually have been finished and
  # therefore have corresponding results with Grades in the input-data
  study_colors <- c(
    "Blue", "Yellow", "Red",
    "Purple", "Orange", "Teal",
    "Grey", "Mustard", "Olive"
  )
  numberTrialsAll <- function(CurrentColor) {
    current_trials <- data_prep %>%
      filter(Study == CurrentColor) %>%
      select(TrialID) %>%
      distinct(TrialID, .keep_all = TRUE)
    current_rows <- nrow(current_trials)
    # message(current_rows)
    print(paste(CurrentColor, ":", current_rows))
  }
  for (current_color in study_colors) {
    numberTrialsAll(current_color)
  }
  ##############################################################################

  #### Get TrialIDs of specified subject, that have been finished ##############
  study_colors <- c(
    "Blue", "Yellow", "Red",
    "Purple", "Orange", "Teal",
    "Grey", "Mustard", "Olive"
  )
  subject_names <- c("laurenzio", "Biggus Dickus")
  whodunnitwhat <- function(CurrentName, Color, CookingLevel) {
    current_trials <- CookingLevel %>%
      filter(Study == Color) %>%
      filter(SubjectName == CurrentName) %>%
      # select(TrialID) %>%
      select(TrialID) %>%
      # distinct(TrialID, .keep_all = TRUE)
      distinct(TrialID, .keep_all = TRUE)
    look <- current_trials[order(current_trials$TrialID), ]
    num_rows <- nrow(current_trials)
    # message(CurrentName, Color, num_rows)
    print(paste(CurrentName, Color, num_rows, sep = " "))
    # message(look)
    print(look)
  }

  current_cookinglevel <- data_prep
  # current_cookinglevel <- data_rare
  # current_cookinglevel <- data_medi
  # current_cookinglevel <- data_done

  for (current_name in subject_names) {
    for (current_color in study_colors) {
      whodunnitwhat(current_name, current_color, current_cookinglevel)
    }
  }
  ##############################################################################

  #### Show all the containing trail-IDs in the current data ###################
  # study_trials <- data_prep %>%
  # study_trials <- data_rare %>%
  # study_trials <- data_medi %>%
  study_trials <- data_done %>%
    select(Study, TrialID) %>%
    distinct(TrialID, .keep_all = TRUE)
  look_at_study_trials <- study_trials[order(study_trials$TrialID), ]
  look_at_study_trials
  ##############################################################################

  tiniest_runtime <- data_prep %>%
    filter(SubjectName == "laurenzio") %>%
    select(Runtime) %>%
    arrange(Runtime)

  #### Looking at the data
  options(tibble.print_max = Inf)
  options(dplyr.print_max = 1e9)
  tiniest_runtime %>%
    as_tibble() %>%
    print(n = 200)
}





################################################
# Function: Plot of metadata in compact format #
################################################

plotMetaTiny <- function(data) {
  current_plot <- plot.new()
  text(x = .1, y = .1, data)
  # print(data) # Only works in console, not for PDF-file
  dev.off()
  return(current_plot)
}




plotMetaPdf <- function(data, identifier, pdf_boolean, png_boolean) {
  ##############################################################################
  # Original code basis ########################################################
  ##############################################################################
  # Overview of the SubjectNames #
  ################################
  subj_names <- data %>%
    select(SubjectName) %>%
    distinct(SubjectName, .keep_all = TRUE)
  subj_names <- subj_names[order(subj_names$SubjectName), ]
  # p001 <- plotMetaTiny(subj_names)
  #################################
  # Overview of the SubjectEMails #
  #################################
  subj_emails <- data %>%
    select(SubjectEMail) %>%
    distinct(SubjectEMail, .keep_all = TRUE)
  subj_emails <- subj_emails[order(subj_emails$SubjectEMail), ]
  # subj_emails <- subj_names[order(subj_names$SubjectName), ]
  # p002 <- plotMetaTiny(subj_emails)
  ###################################
  # Overview of the SubjectComments #
  ###################################
  subj_comments <- data %>%
    select(SubjectComment) %>%
    distinct(SubjectComment, .keep_all = TRUE)
  subj_comments <- subj_comments[order(subj_comments$SubjectComment), ]
  # p003 <- plotMetaTiny(subj_comments)

  #####################
  # Quantitative data #
  #####################
  # SubjectAge
  subj_age <- data %>%
    group_by(SubjectName) %>%
    select(SubjectAge) %>%
    distinct(SubjectName, .keep_all = TRUE) %>%
    group_by(SubjectAge) %>%
    summarise(Count = n())
  # SubjectSex
  subj_sex <- data %>%
    group_by(SubjectName) %>%
    select(SubjectSex) %>%
    distinct(SubjectName, .keep_all = TRUE) %>%
    group_by(SubjectSex) %>%
    summarise(Count = n())
  # SubjectAge to SubjectSex
  subj_age_sex <- data %>%
    group_by(SubjectName) %>%
    select(SubjectSex, SubjectAge) %>%
    distinct(SubjectName, .keep_all = TRUE) %>%
    group_by(SubjectSex, SubjectAge) %>%
    summarise(Count = n())
  # SubjectInterest
  subj_interest <- data %>%
    group_by(SubjectName) %>%
    select(SubjectInterest) %>%
    distinct(SubjectName, .keep_all = TRUE) %>%
    group_by(SubjectInterest) %>%
    summarise(Count = n())
  ##############################################################################
  # SubjectLanguage
  subj_language <- data %>%
    group_by(SubjectName) %>%
    select(SubjectLanguage) %>%
    distinct(SubjectName, .keep_all = TRUE)
  subj_language$SubjectLanguage[subj_language$SubjectLanguage == "deutsch"] <- "German"
  subj_language$SubjectLanguage[subj_language$SubjectLanguage == "Russisch"] <- "Russian"
  subj_language <- subj_language %>%
    group_by(SubjectLanguage) %>%
    summarise(Count = n())
  ##############################################################################
  # SubjectEyesight
  subj_eyesight <- data %>%
    group_by(SubjectName) %>%
    select(SubjectEyesight) %>%
    distinct(SubjectName, .keep_all = TRUE)
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight == "ne"] <- "Unimpaired"
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight == "Ne"] <- "Unimpaired"
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight == "nein"] <- "Unimpaired"
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight == "Nein"] <- "Unimpaired"
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight == "No"] <- "Unimpaired"
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight == "−"] <- "Unimpaired"
  subj_eyesight$SubjectEyesight[subj_eyesight$SubjectEyesight != "Unimpaired"] <- "Impaired"
  subj_eyesight <- subj_eyesight %>%
    group_by(SubjectEyesight) %>%
    summarise(Count = n())
  ##############################################################################
  # SubjectHearing
  subj_hearing <- data %>%
    group_by(SubjectName) %>%
    select(SubjectHearing) %>%
    distinct(SubjectName, .keep_all = TRUE) %>%
    group_by(SubjectHearing) %>%
    summarise(Count = n())

  # Print tables to a pdf file:
  pdf(
    paste0("explore_00_metadata_", identifier, ".pdf"),
    height = 11,
    width = 10
  )
  plot.new()
  # text("Subject Names")
  grid.table(subj_names)
  plot.new()
  grid.table(subj_emails)
  plot.new()
  grid.table(subj_comments)
  plot.new()
  grid.table(subj_age)
  plot.new()
  grid.table(subj_sex)
  plot.new()
  grid.table(subj_age_sex)
  plot.new()
  grid.table(subj_interest)
  plot.new()
  grid.table(subj_language)
  plot.new()
  grid.table(subj_eyesight)
  plot.new()
  grid.table(subj_hearing)
  dev.off()
  ##############################################################################

  ##################################
  # Saving plots as pdf and/or png #
  ##################################
  list_of_plots <- list()

  # for (i in 1:14) {
  #  list_of_plots[[i]] <-
  # }
  # 1 : Age
  # 2 : Sex
  # 3 : AgeSex
  # 4 : Interest
  # 5 : Language
  # 6 : Eyesight
  # 7 : Hearing
  subj_age$SubjectAge[subj_age$SubjectAge == "none"] <- "No info"
  subj_age$SubjectAge[subj_age$SubjectAge == "0"] <- "0-10"
  subj_age$SubjectAge[subj_age$SubjectAge == "1"] <- "10-19"
  subj_age$SubjectAge[subj_age$SubjectAge == "2"] <- "20-29"
  subj_age$SubjectAge[subj_age$SubjectAge == "3"] <- "30-39"
  subj_age$SubjectAge[subj_age$SubjectAge == "4"] <- "40-49"
  subj_age$SubjectAge[subj_age$SubjectAge == "5"] <- "50-59"
  subj_age$SubjectAge[subj_age$SubjectAge == "6"] <- "60-69"
  subj_age$SubjectAge[subj_age$SubjectAge == "7"] <- "70-79"
  subj_age$SubjectAge[subj_age$SubjectAge == "8"] <- "80-89"
  subj_age$SubjectAge[subj_age$SubjectAge == "9"] <- "90-99"
  subj_age$SubjectAge[subj_age$SubjectAge == "99"] <- "Over 99"
  ################################################################################
  ages <- subj_age
  # ages <- as.data.frame(table(subj_age$SubjectAge))
  # ages <- table(subj_age$SubjectAge)
  ages$percent <- paste(round(ages$Count / sum(ages$Count) * 100, 2), "%") # Round 2 position after poing
  # ages <- as.data.frame(table(subj_age$SubjectAge))
  list_of_plots[[1]] <- ggplot(ages, aes(x = "", y = Count, fill = SubjectAge)) +
    # geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("green", "red", "royal blue", "yellow", "purple", "orange", "brown", "grey")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    # position = position_stack(vjust = 0.5),   # Alternative for different layout
    # color = c("white", "black", "black", ...),
    # label.size = 0,
    # size = 6,
    # show.legend = FALSE)
    labs(fill = "Agegroups:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )

  ################################################################################
  sexs <- subj_sex
  sexs$percent <- paste(round(sexs$Count / sum(sexs$Count) * 100, 2), "%")
  list_of_plots[[2]] <- ggplot(sexs, aes(x = "", y = Count, fill = SubjectSex)) +
    geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("#ED66FF", "#1E90FF", "grey")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    labs(fill = "Sex:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )
  ################################################################################
  agesexs <- subj_age_sex
  agesexs$percent <- paste(round(agesexs$Count / sum(agesexs$Count) * 100, 2), "%")
  list_of_plots[[3]] <- ggplot(agesexs, aes(x = "", y = Count, fill = SubjectSex, SubjectAge)) +
    geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("#ED66FF", "#1E90FF", "grey")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    labs(fill = "Sex by Agegroups:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )
  ################################################################################
  interests <- subj_interest
  interests$percent <- paste(round(interests$Count / sum(interests$Count) * 100, 2), "%")
  list_of_plots[[4]] <- ggplot(interests, aes(x = "", y = Count, fill = SubjectInterest)) +
    geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("green", "red", "royal blue", "yellow", "purple", "orange")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    labs(fill = "Interests:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )
  ################################################################################
  languages <- subj_language
  languages$percent <- paste(round(languages$Count / sum(languages$Count) * 100, 2), "%")
  list_of_plots[[5]] <- ggplot(languages, aes(x = "", y = Count, fill = SubjectLanguage)) +
    geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("green", "red", "royal blue", "yellow", "purple", "orange")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    labs(fill = "Languages:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )
  ################################################################################
  eyesights <- subj_eyesight
  eyesights$percent <- paste(round(eyesights$Count / sum(eyesights$Count) * 100, 2), "%")
  list_of_plots[[6]] <- ggplot(eyesights, aes(x = "", y = Count, fill = SubjectEyesight)) +
    geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("red", "green")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    labs(fill = "Eyesight:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )
  ################################################################################
  hearings <- subj_hearing
  hearings$percent <- paste(round(hearings$Count / sum(hearings$Count) * 100, 2), "%")
  list_of_plots[[7]] <- ggplot(hearings, aes(x = "", y = Count, fill = SubjectHearing)) +
    geom_bar(stat = "identity") +
    geom_bar(stat = "identity", color = "black") + # For boarder between groups
    coord_polar("y") +
    theme_void() + # Removes theme for basic plot
    scale_fill_manual(values = c("green", "red")) + # For defining colors of groups
    geom_label(aes(label = percent),
      position = position_stack(vjust = 0.5),
      size = 6,
      show.legend = FALSE
    ) +
    labs(fill = "Hearing:") +
    theme(
      legend.text = element_text(size = 15),
      legend.title = element_text(size = 15),
      legend.position = "right"
    )
  ################################################################################


  if (pdf_boolean == TRUE) {
    # Print plots to a pdf file:
    pdf(file = paste0("expl_00_meta_", identifier, ".pdf"))
    for (plot in list_of_plots) {
      print(plot)
    }
    dev.off()
  }
  if (png_boolean == TRUE) {
    # Print plots to sequence of png files:
    image_counter <- 1
    for (plot in list_of_plots) {
      image_counter_padded <- formatC(image_counter, width = 3, format = "d", flag = "0")
      png(
        file = paste0("plots/", "expl-00-meta", image_counter_padded, ".png"),
        width = 600,
        height = 600
      )
      print(plot)
      dev.off()
      image_counter <- image_counter + 1
    }
  }
}


main <- function() {
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  # Set current working directory back to the initial directory prior to script
  on.exit(setwd(initial_dir))
  # plotMetaPdf(data_prep, "prep")
  # plotMetaPdf(data_rare, "rare")
  # plotMetaPdf(data_medi, "medi")
  plotMetaPdf(data_done, "done", pdf_boolean, png_boolean)
}

main()
