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
#                       ###############################                        #
#                       ## Second round of questions ##                        #
#                       ###############################                        #
#                                                                              #
################################################################################
#

######## Phoneme position strings ##############################################
#### Meta-Information about Excerpt and Object
list_of_phoneme_meta <- list()

list_of_phoneme_meta[[1]] <- c("Anfang", "a")
list_of_phoneme_meta[[2]] <- c("Anfang", "p")
list_of_phoneme_meta[[3]] <- c("Europaeisch", "a")
list_of_phoneme_meta[[4]] <- c("Europaeisch", "p")
list_of_phoneme_meta[[5]] <- c("Impfangebot", "w")
list_of_phoneme_meta[[6]] <- c("Paar", "a")
list_of_phoneme_meta[[7]] <- c("Paar", "p")
list_of_phoneme_meta[[8]] <- c("Paar", "w")
list_of_phoneme_meta[[9]] <- c("Pandemie", "a")
list_of_phoneme_meta[[10]] <- c("Pandemie", "p")
list_of_phoneme_meta[[11]] <- c("Tempo", "a")
list_of_phoneme_meta[[12]] <- c("Tempo", "p")
list_of_phoneme_meta[[13]] <- c("Tempo", "w")
list_of_phoneme_meta[[14]] <- c("Zusammen", "a")

#### Spoken text-(part) of excerpt
list_of_phoneme_texts <- list()

list_of_phoneme_texts[[1]] <- "von der ich am [a]nfang gesprochen habe"
# anfang_a <- "von der ich am [a]nfang gesprochen habe"
list_of_phoneme_texts[[2]] <- "von der ich am anfang ges[p]rochen habe"
# anfang_p <- "von der ich am anfang ges[p]rochen habe"
list_of_phoneme_texts[[3]] <- "-stoff nicht n[a]tional, sondern europäisch"
# europaeisch_a <- "-stoff nicht n[a]tional, sondern europäisch"
list_of_phoneme_texts[[4]] <- "sondern euro[p]äisch organisiert"
# europaeisch_p <- "sondern euro[p]äisch organisiert"
list_of_phoneme_texts[[5]] <- "jedem der [w] das möchte"
# impf_w <- "jedem der [w] das möchte"
list_of_phoneme_texts[[6]] <- "ein langsamer st[a]rt, ein paar hundert-"
# paar_a <- "ein langsamer st[a]rt, ein paar hundert-"
list_of_phoneme_texts[[7]] <- "start, ein [p]aar hunderttausend"
# paar_p <- "start, ein [p]aar hunderttausend"
list_of_phoneme_texts[[8]] <- "langsamer start,[w] ein paar hunderttausend"
# paar_w <- "langsamer start,[w] ein paar hunderttausend"
list_of_phoneme_texts[[9]] <- "zweite welle der p[a]ndemie, in der"
# pandemie_a <- "zweite welle der p[a]ndemie, in der"
list_of_phoneme_texts[[10]] <- "zweite welle der [p]andemie, in der"
# pandemie_p <- "zweite welle der [p]andemie, in der"
list_of_phoneme_texts[[11]] <- "werden es mehr. d[a]s tempo wird"
# tempo_a <- "werden es mehr. d[a]s tempo wird"
list_of_phoneme_texts[[12]] <- "mehr. das tem[p]o wird zunehmen"
# tempo_p <- "mehr. das tem[p]o wird zunehmen"
list_of_phoneme_texts[[13]] <- "werden es mehr.[w] das tempo wird"
# tempo_w <- "werden es mehr.[w] das tempo wird"
list_of_phoneme_texts[[14]] <- "uns desshalb zus[a]mmen weiter das tun"
# zusammen_a <- "uns desshalb zus[a]mmen weiter das tun"

################################################################################
################################ [TODO] ########################################
# All of this has to happen in a function that takes
# "excerpt-name",
# "object-name"
# and creates the phoneme-chain, phoneme-duration-chain, phoneme-frame-chain
################################################################################
#### Phoneme-Chain of excerpt
list_of_phoneme_chain <- list()
list_of_phoneme_length <- list()

for (i in 1:14) {
  current_excerpt <- list_of_phoneme_meta[[i]][1]
  current_object <- list_of_phoneme_meta[[i]][2]
  ###################
  # Phoneme objects #
  ###################
  # Get objects from data_meta_text input
  meta_text_current <- filter(
    data_meta_text,
    Excerpt == current_excerpt & Object == current_object
  )
  meta_text_current_l9 <- meta_text_current$ObjLeft9
  meta_text_current_l8 <- meta_text_current$ObjLeft8
  meta_text_current_l7 <- meta_text_current$ObjLeft7
  meta_text_current_l6 <- meta_text_current$ObjLeft6
  meta_text_current_l5 <- meta_text_current$ObjLeft5
  meta_text_current_l4 <- meta_text_current$ObjLeft4
  meta_text_current_l3 <- meta_text_current$ObjLeft3
  meta_text_current_l2 <- meta_text_current$ObjLeft2
  meta_text_current_l1 <- meta_text_current$ObjLeft1
  meta_text_current_l0 <- meta_text_current$Object
  meta_text_current_r1 <- meta_text_current$ObjRight1
  meta_text_current_r2 <- meta_text_current$ObjRight2
  meta_text_current_r3 <- meta_text_current$ObjRight3
  meta_text_current_r4 <- meta_text_current$ObjRight4
  meta_text_current_r5 <- meta_text_current$ObjRight5
  meta_text_current_r6 <- meta_text_current$ObjRight6
  meta_text_current_r7 <- meta_text_current$ObjRight7
  meta_text_current_r8 <- meta_text_current$ObjRight8
  meta_text_current_r9 <- meta_text_current$ObjRight9
  # Combine objects to a single string for displaying
  meta_text_current_chain <- paste(
    meta_text_current_l9,
    meta_text_current_l8,
    meta_text_current_l7,
    meta_text_current_l6,
    meta_text_current_l5,
    meta_text_current_l4,
    meta_text_current_l3,
    meta_text_current_l2,
    meta_text_current_l1,
    "[",
    meta_text_current_l0,
    "]",
    meta_text_current_r1,
    meta_text_current_r2,
    meta_text_current_r3,
    meta_text_current_r4,
    meta_text_current_r5,
    meta_text_current_r6,
    meta_text_current_r7,
    meta_text_current_r8,
    meta_text_current_r9
  )
  list_of_phoneme_chain[[i]] <- meta_text_current_chain

  #####################
  # Phoneme durations #
  #####################
  # Get Phoneme-Duration-Chain of excerpt
  meta_text_current_l9_length <- meta_text_current$ObjLeftLength9
  meta_text_current_l8_length <- meta_text_current$ObjLeftLength8
  meta_text_current_l7_length <- meta_text_current$ObjLeftLength7
  meta_text_current_l6_length <- meta_text_current$ObjLeftLength6
  meta_text_current_l5_length <- meta_text_current$ObjLeftLength5
  meta_text_current_l4_length <- meta_text_current$ObjLeftLength4
  meta_text_current_l3_length <- meta_text_current$ObjLeftLength3
  meta_text_current_l2_length <- meta_text_current$ObjLeftLength2
  meta_text_current_l1_length <- meta_text_current$ObjLeftLength1
  meta_text_current_l0_length <- meta_text_current$ObjectLength
  meta_text_current_r1_length <- meta_text_current$ObjRightLength1
  meta_text_current_r2_length <- meta_text_current$ObjRightLength2
  meta_text_current_r3_length <- meta_text_current$ObjRightLength3
  meta_text_current_r4_length <- meta_text_current$ObjRightLength4
  meta_text_current_r5_length <- meta_text_current$ObjRightLength5
  meta_text_current_r6_length <- meta_text_current$ObjRightLength6
  meta_text_current_r7_length <- meta_text_current$ObjRightLength7
  meta_text_current_r8_length <- meta_text_current$ObjRightLength8
  meta_text_current_r9_length <- meta_text_current$ObjRightLength9
  # Combine Phoneme-Duration-Chain of excerpt
  meta_text_current_phoneme_duration_chain <- paste(
    # meta_text_current_l9_length,
    # meta_text_current_l8_length,
    # meta_text_current_l7_length,
    # meta_text_current_l6_length,
    # meta_text_current_l5_length,
    # meta_text_current_l4_length,
    meta_text_current_l3_length,
    meta_text_current_l2_length,
    meta_text_current_l1_length,
    "[",
    meta_text_current_l0_length,
    "]",
    meta_text_current_r1_length,
    meta_text_current_r2_length,
    meta_text_current_r3_length
  ) # ,
  # meta_text_current_r4_length,
  # meta_text_current_r5_length,
  # meta_text_current_r6_length,
  # meta_text_current_r7_length,
  # meta_text_current_r8_length,
  # meta_text_current_r9_length
  # )
  # Put current phoneme_duration_chain into the list
  list_of_phoneme_length[[i]] <- meta_text_current_phoneme_duration_chain
}


#### Phoneme-Frame-Chain of excerpt (Even neccessary?!)

################################################################################

##############################################
# Plot with points and added smooth function #
##############################################
plot_smooth <- function(data, my_x, my_y, my_color, my_title) {
  current_plot <- ggplot(
    data = data,
    aes(
      x = as.numeric(data[[my_x]]),
      y = as.numeric(data[[my_y]]),
      color = data[[my_color]]
    )
  ) +
    geom_point() +
    #  geom_point(mapping = aes(
    #    x = as.numeric(data[[my_x]]),
    #    y = as.numeric(data[[my_y]]),
    #    color = data[[my_color]]
    #  )) +
    # ylim(1, 6) + # y-axis not flipped
    ylim(6, 1) + # y-axis flipped
    # Use stat_smooth() if you want to display the results with a non-standard geom.
    # https://ggplot2.tidyverse.org/reference/geom_smooth.html
    # stat_smooth(    # Did not work...
    geom_smooth(
      # Rely on global aesthetics
      # https://community.rstudio.com/t/geom-smooth-lines-now-you-see-me-now-you-dont/5577/13
      #  mapping = aes(
      #    x = as.numeric(data[[my_x]]),
      #    y = as.numeric(data[[my_y]]),
      #    color = data[[my_color]]
      #  ),
      # color = data[[my_color]],
      se = FALSE
    ) + # se = confidence interval around smooth
    ggtitle(my_title) +
    theme(
      plot.title = element_text(
        color = "darkgreen", size = 24,
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
      ),
      axis.text.x = element_text(size = 16),
      axis.text.y = element_text(size = 16)
    ) +
    theme(
      plot.background = element_rect(fill = "#CCFFCC"),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    ) + # top, right, bottom, left
    theme(panel.background = element_rect(fill = "#CCCCCC"))

  return(current_plot)
}



plot_global_pdf <- function(data, identifier) {
  list_of_dataframes <- list()
  list_of_plots <- list()
  list_of_plot_titles <- list()

  ######### "How well do the items perform in different excerpts?" ###############
  list_of_dataframes[[1]] <- filter(data, Excerpt == "Anfang", Object == "a")
  list_of_plot_titles[[1]] <- "Ranks per Object (Anfang-a)"
  list_of_dataframes[[2]] <- filter(data, Excerpt == "Anfang", Object == "p")
  list_of_plot_titles[[2]] <- "Ranks per Object (Anfang-p)"
  # dataFilterAnfang <- filter(data, Excerpt == "Anfang")
  # dataFilterAnfangA <- filter(dataFilterAnfang, Object == "a")
  # dataFilterAnfangP <- filter(dataFilterAnfang, Object == "p")
  # dataFilterAnfangW <- filter(dataFilterAnfang, Object == "w")    # Not included

  list_of_dataframes[[3]] <- filter(data, Excerpt == "Europaeisch", Object == "a")
  list_of_plot_titles[[3]] <- "Ranks per Object (Europaeisch-a)"
  list_of_dataframes[[4]] <- filter(data, Excerpt == "Europaeisch", Object == "p")
  list_of_plot_titles[[4]] <- "Ranks per Object (Europaeisch-p)"
  # dataFilterEuropaeisch <- filter(data, Excerpt == "Europaeisch")
  # dataFilterEuropaeischA <- filter(dataFilterEuropaeisch, Object == "a")
  # dataFilterEuropaeischP <- filter(dataFilterEuropaeisch, Object == "p")
  # dataFilterEuropaeischW <- filter(dataFilterEuropaeisch, Object == "w") # N.i.

  list_of_dataframes[[5]] <- filter(data, Excerpt == "Impfangebot", Object == "w")
  list_of_plot_titles[[5]] <- "Ranks per Object (Impfangebot-w)"
  # dataFilterImpfangebot <- filter(data, Excerpt == "Impfangebot")
  # dataFilterImpfangebotA <- filter(dataFilterImpfangebot, Object == "a") # N.i.
  # dataFilterImpfangebotP <- filter(dataFilterImpfangebot, Object == "p") # N.i.
  # dataFilterImpfangebotW <- filter(dataFilterImpfangebot, Object == "w")

  list_of_dataframes[[6]] <- filter(data, Excerpt == "Paar", Object == "a")
  list_of_plot_titles[[6]] <- "Ranks per Object (Paar-a)"
  list_of_dataframes[[7]] <- filter(data, Excerpt == "Paar", Object == "p")
  list_of_plot_titles[[7]] <- "Ranks per Object (Paar-p)"
  list_of_dataframes[[8]] <- filter(data, Excerpt == "Paar", Object == "w")
  list_of_plot_titles[[8]] <- "Ranks per Object (Paar-w)"
  # dataFilterPaar <- filter(data, Excerpt == "Paar")
  # dataFilterPaarA <- filter(dataFilterPaar, Object == "a")
  # dataFilterPaarP <- filter(dataFilterPaar, Object == "p")
  # dataFilterPaarW <- filter(dataFilterPaar, Object == "w")

  list_of_dataframes[[9]] <- filter(data, Excerpt == "Pandemie", Object == "a")
  list_of_plot_titles[[9]] <- "Ranks per Object (Pandemie-a)"
  list_of_dataframes[[10]] <- filter(data, Excerpt == "Pandemie", Object == "p")
  list_of_plot_titles[[10]] <- "Ranks per Object (Pandemie-p)"
  # dataFilterPandemie <- filter(data, Excerpt == "Pandemie")
  # dataFilterPandemieA <- filter(dataFilterPandemie, Object == "a")
  # dataFilterPandemieP <- filter(dataFilterPandemie, Object == "p")
  # dataFilterPandemieW <- filter(dataFilterPandemie, Object == "w") # N.i.

  list_of_dataframes[[11]] <- filter(data, Excerpt == "Tempo", Object == "a")
  list_of_plot_titles[[11]] <- "Ranks per Object (Tempo-a)"
  list_of_dataframes[[12]] <- filter(data, Excerpt == "Tempo", Object == "p")
  list_of_plot_titles[[12]] <- "Ranks per Object (Tempo-p)"
  list_of_dataframes[[13]] <- filter(data, Excerpt == "Tempo", Object == "w")
  list_of_plot_titles[[13]] <- "Ranks per Object (Tempo-w)"
  # dataFilterTempo <- filter(data, Excerpt == "Tempo")
  # dataFilterTempoA <- filter(dataFilterTempo, Object == "a")
  # dataFilterTempoP <- filter(dataFilterTempo, Object == "p")
  # dataFilterTempoW <- filter(dataFilterTempo, Object == "w")

  list_of_dataframes[[14]] <- filter(data, Excerpt == "Zusammen", Object == "a")
  list_of_plot_titles[[14]] <- "Ranks per Object (Zusammen-a)"
  # dataFilterZusammen <- filter(data, Excerpt == "Zusammen")
  # dataFilterZusammenA <- filter(dataFilterZusammen, Object == "a")
  # dataFilterZusammenP <- filter(dataFilterZusammen, Object == "p") # N.i.
  # dataFilterZusammenW <- filter(dataFilterZusammen, Object == "w") # N.i.
  ################################################################################

  #### Filterin to prevent weird problem of geom_smooth-lines not showing.
  #### Looping and appending to lists is a bit of a hassle in R:
  #### https://stackoverflow.com/questions/26508519/how-to-add-elements-to-a-list-in-r-loop
  for (i in 1:14) {
    current_dataframe <- list_of_dataframes[[i]]
    current_plot_title <- list_of_plot_titles[[i]]
    dataframe_filtered <- filter(
      current_dataframe,
      Modification == "aL" |
        Modification == "aR" |
        # Modification == "iL" |
        Modification == "iR" |
        Modification == "uL" |
        # Modification == "uR" |
        Modification == "vL" |
        Modification == "vR"
    )
    current_plot <- plot_smooth(
      dataframe_filtered,
      "Attribute",
      "Rank",
      "Modification",
      current_plot_title
    )
    # print(current_plot)
    # append(list_of_plots, current_plot)
    list_of_plots[[i]] <- current_plot
  }

  ##################
  # Excerpt Anfang #
  ##################
  # Debuggin: Smooth_Problem
  # data_filter_a_al <- filter(
  #  dataFilterAnfang,
  #  Modification == "aL" |
  #    Modification == "aR" |
  #    # Modification == "iL" |
  #    Modification == "iR" |
  #    Modification == "uL" |
  #    # Modification == "uR" |
  #    Modification == "vL" |
  #    Modification == "vR"
  # )
  # p001 <- plot_smooth(data_filter_a_al, "Attribute", "Grade", "Modification", "Grades per Object (Anfang-all)")
  # Anfang - all
  # p001 <- plot_smooth(dataFilterAnfang, "Attribute", "Grade", "Modification", "Grades per Object (Anfang-all)")
  # Anfang - a
  # p002 <- plot_smooth(dataFilterAnfangA, "Attribute", "Grade", "Modification", "Grades per Object (Anfang-a)")
  # Anfang - p
  # p003 <- plot_smooth(dataFilterAnfangP, "Attribute", "Grade", "Modification", "Grades per Object (Anfang-p)")
  #######################
  # Excerpt Europaeisch #
  #######################
  # Europaeisch - all
  # p004 <- plot_smooth(dataFilterEuropaeisch, "Attribute", "Grade", "Modification", "Grades per Object (Europaeisch-all)")
  # Europaeisch - a
  # p005 <- plot_smooth(dataFilterEuropaeischA, "Attribute", "Grade", "Modification", "Grades per Object (Europaeisch-a)")
  # Europaeisch - p
  # p006 <- plot_smooth(dataFilterEuropaeischP, "Attribute", "Grade", "Modification", "Grades per Object (Europaeisch-p)")
  #######################
  # Excerpt Impfangebot #
  #######################
  # Impfangebot - w
  # p007 <- plot_smooth(dataFilterImpfangebotW, "Attribute", "Grade", "Modification", "Grades per Object (Impfangebot-w)")
  ################
  # Excerpt Paar #
  ################
  # Paar - all
  # p008 <- plot_smooth(dataFilterPaar, "Attribute", "Grade", "Modification", "Grades per Object (Paar-all)")
  # Paar - a
  # p009 <- plot_smooth(dataFilterPaarA, "Attribute", "Grade", "Modification", "Grades per Object (Paar-a)")
  # Paar - p
  # p010 <- plot_smooth(dataFilterPaarP, "Attribute", "Grade", "Modification", "Grades per Object (Paar-p)")
  # Paar - w
  # p011 <- plot_smooth(dataFilterPaarW, "Attribute", "Grade", "Modification", "Grades per Object (Paar-w)")
  ####################
  # Excerpt Pandemie #
  ####################
  # Pandemie - all
  # p012 <- plot_smooth(dataFilterPandemie, "Attribute", "Grade", "Modification", "Grades per Object (Pandemie-all)")
  # Pandemie - a
  # p013 <- plot_smooth(dataFilterPandemieA, "Attribute", "Grade", "Modification", "Grades per Object (Pandemie-a)")
  # Pandemie - p
  # p014 <- plot_smooth(dataFilterPandemieP, "Attribute", "Grade", "Modification", "Grades per Object (Pandemie-p)")
  #################
  # Excerpt Tempo #
  #################
  # Tempo - all
  # p015 <- plot_smooth(dataFilterTempo, "Attribute", "Grade", "Modification", "Grades per Object (Tempo-all)")
  # Tempo - a
  # p016 <- plot_smooth(dataFilterTempoA, "Attribute", "Grade", "Modification", "Grades per Object (Tempo-a)")
  # Tempo - p
  # p017 <- plot_smooth(dataFilterTempoP, "Attribute", "Grade", "Modification", "Grades per Object (Tempo-p)")
  # Tempo - w
  # p018 <- plot_smooth(dataFilterTempoW, "Attribute", "Grade", "Modification", "Grades per Object (Tempo-w)")
  ####################
  # Excerpt Zusammen #
  ####################
  # Zusammen - a
  # p019 <- plot_smooth(dataFilterZusammenA, "Attribute", "Grade", "Modification", "Grades per Object (Zusammen-a)")


    if (pdf_boolean == TRUE) {
      # Print plots to a pdf file:
      pdf(file = paste0("expl_03_global_", identifier, ".pdf"))
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
          file = paste0("plots/", "expl-03-global", image_counter_padded, ".png"),
          width = image_width,
          height = image_height
        )
        print(plot)
        dev.off()
        image_counter <- image_counter + 1
      }
    }
  # Print plots to a pdf file:
  #pdf(paste0("explore_06_global_rank_", identifier, ".pdf"))
  #for (plot in list_of_plots) {
  #  print(plot)
  #}
  #dev.off()
}


main <- function() {
  # Parameter for plotting
  pdf_boolean <- TRUE
  png_boolean <- TRUE
  background_color <- "#FFFFFF"
  title_color <- "#000000"
  x_axis_title_color <- "#000000"
  y_axis_title_color <- "#000000"
  title_boolean <- FALSE
  text_color <- "#FF3300" # Red
  phoneme_chain_color <- "#0033FF" # Blue
  phoneme_length_color <- "#00CC00" # Green
  image_width <- 600
  image_height <- 600

  # plot_specific_pdf(data_prep, "prep")
  # plot_specific_pdf(data_rare, "rare")
  # plot_specific_pdf(data_medi, "medi")
  plot_global_pdf(
    pdf_boolean,
    png_boolean,
    data_done,
    "done",
    background_color,
    title_color,
    x_axis_title_color,
    y_axis_title_color,
    title_boolean,
    text_color,
    phoneme_chain_color,
    phoneme_length_color,
    image_width,
    image_height
  )
}

main()


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
