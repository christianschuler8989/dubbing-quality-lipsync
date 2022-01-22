# R-Script
# Analysis of listening panel
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

##### Finding the two MadLads ##################################################
# At this point we can simply look for the two subjects with the highest count
subjectTrialNumberAll <- data_done %>% 
  group_by(SubjectName) %>%
  summarise(TrialCount = n() / 6) 
subjectTrialNumberAll <- subjectTrialNumberAll[order(-subjectTrialNumberAll$TrialCount), ]
#print(subjectTrialNumberAll)
# =>
# 1 UristMccc2211        210
# 2 UristMcaae4cb        199


listeningpanel_rank_anchors_detection <- function() {
  #### Preperations
  identifier <- "anchors"
  sink_path <- paste0("listeningpanel-quali/", identifier, "-sink.txt")
  options(max.print = 100000)
  options(dplyr.print_max = 100000)
  
  #### How well did they "find" the Anchors? #####################################
  ################################################################################
  data <- data_done %>% dplyr::filter(Attribute == 0) %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "High-Anchor"
  data_rank_high <- data
  #data <- data %>% select(Rank, Count, Percent) # For slicker sink in txt
  sink(sink_path, append = FALSE)
  print("High-Anchor - Attribute = 0")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 4) %>%
    dplyr::filter(Modification == "uR") %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "Middle-Anchor"
  data_rank_mid <- data
  sink(sink_path, append = TRUE)
  print("Middle-Anchor - Attribute = 4 and Modification = uR")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 4) %>%
    dplyr::filter(Modification == "iL") %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "Low-Anchor"
  data_rank_low <- data
  sink(sink_path, append = TRUE)
  print("Low-Anchor - Attribute = 4 and Modification = iL")
  print(data)
  sink()
  
  #### How well did they "find" the "order" of attributes? #######################
  ################################################################################
  data <- data_done %>% dplyr::filter(Attribute == 1) %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "1-Frame"
  data_rank_01 <- data
  sink(sink_path, append = TRUE)
  print("Attribute = 1")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 2) %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "2-Frames"
  data_rank_02 <- data
  sink(sink_path, append = TRUE)
  print("Attribute = 2")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 3) %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "3-Frames"
  data_rank_03 <- data
  sink(sink_path, append = TRUE)
  print("Attribute = 3")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 4) %>%
    dplyr::filter(Modification != "iL") %>%
    dplyr::filter(Modification != "uR") %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "4-Frames"
  data_rank_04 <- data
  sink(sink_path, append = TRUE)
  print("Attribute = 4")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 5) %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "5-Frames"
  data_rank_05 <- data
  sink(sink_path, append = TRUE)
  print("Attribute = 5")
  print(data)
  sink()
  
  data <- data_done %>% dplyr::filter(Attribute == 6) %>%
    group_by(Attribute, Rank) %>%
    summarise(Count = n())
  data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
  data$identifier <- "6-Frames"
  data_rank_06 <- data
  sink(sink_path, append = TRUE)
  print("Attribute = 6")
  print(data)
  sink()
  
  
  ####################################################
  #### This but depending on mod!!!/obj???/exc??? ####
  ####################################################
  data_anchors <- rbind(data_rank_high, data_rank_mid, data_rank_low)
  data_items <- rbind(data_rank_01, data_rank_02, data_rank_03, data_rank_04, data_rank_05, data_rank_06)
  data_combined <- rbind(data_anchors, data_items)
  
  
  #### Facet-Plot of the Anchor-Detection tendencies
  gg <- ggplot(data_combined, aes(x = Rank, y = Count, color = identifier)) +
    geom_col() +
    labs(title = "Scatterplot", x = "Rank", y = "Count")
  #### Theme adding
  gg1 <- gg + theme(plot.title = element_text(size = 30, face = "bold"),
                    axis.text.x = element_text(size = 15),
                    axis.text.y = element_text(size = 15),
                    axis.title.x = element_text(size = 25),
                    axis.title.y = element_text(size = 25)) +
    scale_color_discrete((name = "Type of PVS")) +
    scale_x_continuous(breaks = scales::pretty_breaks(n = 6))
  
  gg1 + facet_wrap( ~ identifier, ncol = 3)
  png(
    file = paste0("listeningpanel-quali/listening_panel_rank", identifier, ".png")
  )
  print(gg1)
  dev.off()
  
  # MANUAL EXPORT REQUIRED:
  # Bottom right click on "Export", 
  #  navigate to the directory /listening-quali/ 
  #  and save as listening-panel-rankanchors.png
  
}



# [TODO:] Function call results in stupid labels in plot... Learn how to R!
#### Function for plotting rating-tendencies of anchors (Taken from expl-script-02)
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


#### Listening panel's rating tendencies for Anchor-Trials TrialID: 055 and 062
anchors_tendency_listeningpanel <- function(png_boolean) {
  identifier <- "all"
  ######## How consistent did the subjects rate the anchor-trials? #############
  # First Anchor-Trial-ID: 055
  # Second Anchor-Trial-ID: 062
  
  ##### For BLUE ###############################################################
  dataAnchorTrial055Blue <- data_medium %>%
    dplyr::filter((TrialID == 55) & (SubjectName != "UristMcaae4cb") & (SubjectName != "UristMccc2211")) %>%
    #dplyr::filter(TrialID == 55) %>%
    #dplyr::filter(SubjectName != ("UristMcaae4cb" |"UristMccc2211")) %>%
    #dplyr::filter(SubjectName != "UristMccc2211") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  #print(dataAnchorTrial055Blue)
  plot_anchor055 <- ggplot(dataAnchorTrial055Blue, aes(x = ItemNew, y = Rank)) +
    geom_boxplot(outlier.colour = "red") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    ylim(rev(range(dataAnchorTrial055Blue$Rank))) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    theme(
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
    ) +
    theme(legend.position = "bottom")
    #plot_quality_rank(dataAnchorTrial055, "ItemNew", "Rank", "Ranks per Item for Trial 055")
  
  dataAnchorTrial062Blue <- data_medium %>%
    dplyr::filter((TrialID == 62) & (SubjectName != "UristMcaae4cb") & (SubjectName != "UristMccc2211")) %>%
    #dplyr::filter(TrialID == 62) %>%
    #dplyr::filter(SubjectName != "UristMcaae4cb" | SubjectName != "UristMccc2211") %>%
    #dplyr::filter(SubjectName != "UristMccc2211") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  plot_anchor062 <- ggplot(dataAnchorTrial062Blue, aes(x = ItemNew, y = Rank)) +
    geom_boxplot(outlier.colour = "red") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    ylim(rev(range(dataAnchorTrial062Blue$Rank))) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    theme(
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
    ) +
    theme(legend.position = "bottom")
  #plot_quality_rank(dataAnchorTrial062, "ItemNew", "Rank", "Ranks per Item for Trial 062")
  
  ##### For PINK ###############################################################
  # This part does not feel that important and would reuire some dataframe-maig
  # Since the observations don't know about "Pink" one would have to take all
  # observations, exclude the anchors from "Blue" and then exclude the anchros
  # rated by the two "MadLads"- which at this time feels very error-prone.
  
  ##### For MadLads ############################################################
  # At this point we can simply look for the two subjects with the highest count
  #subjectTrialNumberAll <- data_done %>% 
  #  group_by(SubjectName) %>%
  #  summarise(TrialCount = n() / 6) 
  #subjectTrialNumberAll <- subjectTrialNumberAll[order(subjectTrialNumberAll$TrialCount), ]
  #print(subjectTrialNumberAll)
  
  #### Each for their own ###################################################### 
  #dataAnchorTrial055MadLad01 <- data_done %>%
  #  dplyr::filter(TrialID == 055, SubjectName == "UristMcaae4cb") %>%
  #  mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
  #  group_by(ItemNew)
  #plot_anchor055ml01 <- plot_quality_rank(dataAnchorTrial055MadLad01, "ItemNew", "Rank", "Ranks per Item for Trial 055")
  #
  #dataAnchorTrial062MadLad01 <- data_done %>%
  #  dplyr::filter(TrialID == 062, SubjectName == "UristMcaae4cb") %>%
  #  mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
  #  group_by(ItemNew)
  #plot_anchor062ml01 <- plot_quality_rank(dataAnchorTrial062MadLad01, "ItemNew", "Rank", "Ranks per Item for Trial 062")
  #
  #dataAnchorTrial055MadLad02 <- data_done %>%
  #  dplyr::filter(TrialID == 055, SubjectName == "UristMccc2211") %>%
  #  mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
  #  group_by(ItemNew)
  #plot_anchor055ml02 <- plot_quality_rank(dataAnchorTrial055MadLad02, "ItemNew", "Rank", "Ranks per Item for Trial 055")
  #
  #dataAnchorTrial062MadLad02 <- data_done %>%
  #  dplyr::filter(TrialID == 062, SubjectName == "UristMccc2211") %>%
  #  mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
  #  group_by(ItemNew)
  #plot_anchor062ml02 <- plot_quality_rank(dataAnchorTrial062MadLad02, "ItemNew", "Rank", "Ranks per Item for Trial 062")
  ##############################################################################
  
  #### Both MadLads together  ##################################################
  dataAnchorTrial055MadLads <- data_medium %>%
    dplyr::filter((TrialID == 55) & ((SubjectName == "UristMcaae4cb") | (SubjectName == "UristMccc2211"))) %>%
    #dplyr::filter(TrialID == 55) %>%
    #dplyr::filter(SubjectName == "UristMcaae4cb" | SubjectName == "UristMccc2211") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  plot_anchor055ml <- ggplot(dataAnchorTrial055MadLads, aes(x = ItemNew, y = Rank, color = SubjectName)) +
    geom_boxplot(outlier.colour = "red") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    ylim(rev(range(dataAnchorTrial055MadLads$Rank))) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    theme(
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
    ) +
    theme(legend.position = "bottom")
  #plot_quality_rank_temp(dataAnchorTrial055MadLads, "ItemNew", "Rank", "Ranks per Item for Trial 055", "SubjectName")
  
  dataAnchorTrial062MadLads <- data_medium %>%
    dplyr::filter((TrialID == 62) & ((SubjectName == "UristMcaae4cb") | (SubjectName == "UristMccc2211"))) %>%
    #dplyr::filter(TrialID == 62) %>%
    #dplyr::filter(SubjectName == "UristMcaae4cb" | SubjectName == "UristMccc2211") %>%
    mutate(ItemNew = paste0(Object, Modification, Attribute)) %>%
    group_by(ItemNew)
  plot_anchor062ml <- ggplot(dataAnchorTrial062MadLads, aes(x = ItemNew, y = Rank, color = SubjectName)) +
    geom_boxplot(outlier.colour = "red") +
    geom_jitter(
      position = position_jitter(width = 0.1, height = 0),
      alpha = 1 / 4
    ) +
    ylim(rev(range(dataAnchorTrial062MadLads$Rank))) +
    theme(axis.text.x = element_text(size = 14, angle = 90)) +
    theme(
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
    ) +
    theme(legend.position = "bottom")
  #plot_quality_rank_temp(dataAnchorTrial062MadLads, "ItemNew", "Rank", "Ranks per Item for Trial 062", "SubjectName")

  # Saving data to pdf or png ##################################################
  ##############################################################################
  if (png_boolean == TRUE) { # Print plots to sequence of png files:
    png(
      file = paste0("listeningpanel-quali/", identifier, "anchor055.png"),
    )
    print(plot_anchor055)
    dev.off()
    png(
      file = paste0("listeningpanel-quali/", identifier, "anchor062.png"),
    )
    print(plot_anchor062)
    dev.off()
    png(
      file = paste0("listeningpanel-quali/", identifier, "anchor055-madlads.png"),
    )
    print(plot_anchor055ml)
    dev.off()
    png(
      file = paste0("listeningpanel-quali/", identifier, "anchor062-madlads.png"),
    )
    print(plot_anchor062ml)
    dev.off()
  }
}



#### Rating tendencies for Anchor-Trials from the two mad-lads


################################################################################

################################################################################




################################################################################

################################################################################


main <- function() {
  png_boolean <- TRUE
  #listeningpanel_rank_anchors_detection()
  anchors_tendency_listeningpanel(png_boolean)
  
}

main()



