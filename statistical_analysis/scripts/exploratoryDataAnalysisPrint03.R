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

#### Spoken text-(part) of excerpt
anfang_a <- "von der ich am [a]nfang gesprochen habe"
anfang_p <- "von der ich am anfang ges[p]rochen habe"
europaeisch_a <- "-stoff nicht n[a]tional, sondern europäisch"
europaeisch_p <- "sondern euro[p]äisch organisiert"
impf_w <- "jedem der [w] das möchte"
paar_a <- "ein langsamer st[a]rt, ein paar hundert-"
paar_p <- "start, ein [p]aar hunderttausend"
paar_w <- "langsamer start,[w] ein paar hunderttausend"
pandemie_a <- "zweite welle der p[a]ndemie, in der"
pandemie_p <- "zweite welle der [p]andemie, in der"
tempo_a <- "werden es mehr. d[a]s tempo wird"
tempo_p <- "mehr. das tem[p]o wird zunehmen"
tempo_w <- "werden es mehr.[w] das tempo wird"
zusammen_a <- "uns desshalb zus[a]mmen weiter das tun"

################################################################################
################################ [TODO] ########################################
# All of this has to happen in a function that takes
# "excerpt-name",
# "object-name"
# and creates the phoneme-chain, phoneme-duration-chain, phoneme-frame-chain
################################################################################
#### Phoneme-Chain of excerpt
meta_text_anfang_a <- filter(data_meta_text, Excerpt == "Anfang" & Object == "a")
meta_text_anfang_a_l9 <- meta_text_anfang_a$ObjLeft9
meta_text_anfang_a_l8 <- meta_text_anfang_a$ObjLeft8
meta_text_anfang_a_l7 <- meta_text_anfang_a$ObjLeft7
meta_text_anfang_a_l6 <- meta_text_anfang_a$ObjLeft6
meta_text_anfang_a_l5 <- meta_text_anfang_a$ObjLeft5
meta_text_anfang_a_l4 <- meta_text_anfang_a$ObjLeft4
meta_text_anfang_a_l3 <- meta_text_anfang_a$ObjLeft3
meta_text_anfang_a_l2 <- meta_text_anfang_a$ObjLeft2
meta_text_anfang_a_l1 <- meta_text_anfang_a$ObjLeft1
meta_text_anfang_a_l0 <- meta_text_anfang_a$Object
meta_text_anfang_a_r1 <- meta_text_anfang_a$ObjRight1
meta_text_anfang_a_r2 <- meta_text_anfang_a$ObjRight2
meta_text_anfang_a_r3 <- meta_text_anfang_a$ObjRight3
meta_text_anfang_a_r4 <- meta_text_anfang_a$ObjRight4
meta_text_anfang_a_r5 <- meta_text_anfang_a$ObjRight5
meta_text_anfang_a_r6 <- meta_text_anfang_a$ObjRight6
meta_text_anfang_a_r7 <- meta_text_anfang_a$ObjRight7
meta_text_anfang_a_r8 <- meta_text_anfang_a$ObjRight8
meta_text_anfang_a_r9 <- meta_text_anfang_a$ObjRight9

meta_text_anfang_a_phoneme_chain <- paste(
  meta_text_anfang_a_l9,
  meta_text_anfang_a_l8,
  meta_text_anfang_a_l7,
  meta_text_anfang_a_l6,
  meta_text_anfang_a_l5,
  meta_text_anfang_a_l4,
  meta_text_anfang_a_l3,
  meta_text_anfang_a_l2,
  meta_text_anfang_a_l1,
  "[",
  meta_text_anfang_a_l0,
  "]",
  meta_text_anfang_a_r1,
  meta_text_anfang_a_r2,
  meta_text_anfang_a_r3,
  meta_text_anfang_a_r4,
  meta_text_anfang_a_r5,
  meta_text_anfang_a_r6,
  meta_text_anfang_a_r7,
  meta_text_anfang_a_r8,
  meta_text_anfang_a_r9
)

#### Phoneme-Duration-Chain of excerpt
meta_text_anfang_a_l9_length <- meta_text_anfang_a$ObjLeftLength9
meta_text_anfang_a_l8_length <- meta_text_anfang_a$ObjLeftLength8
meta_text_anfang_a_l7_length <- meta_text_anfang_a$ObjLeftLength7
meta_text_anfang_a_l6_length <- meta_text_anfang_a$ObjLeftLength6
meta_text_anfang_a_l5_length <- meta_text_anfang_a$ObjLeftLength5
meta_text_anfang_a_l4_length <- meta_text_anfang_a$ObjLeftLength4
meta_text_anfang_a_l3_length <- meta_text_anfang_a$ObjLeftLength3
meta_text_anfang_a_l2_length <- meta_text_anfang_a$ObjLeftLength2
meta_text_anfang_a_l1_length <- meta_text_anfang_a$ObjLeftLength1
meta_text_anfang_a_l0_length <- meta_text_anfang_a$ObjectLength
meta_text_anfang_a_r1_length <- meta_text_anfang_a$ObjRightLength1
meta_text_anfang_a_r2_length <- meta_text_anfang_a$ObjRightLength2
meta_text_anfang_a_r3_length <- meta_text_anfang_a$ObjRightLength3
meta_text_anfang_a_r4_length <- meta_text_anfang_a$ObjRightLength4
meta_text_anfang_a_r5_length <- meta_text_anfang_a$ObjRightLength5
meta_text_anfang_a_r6_length <- meta_text_anfang_a$ObjRightLength6
meta_text_anfang_a_r7_length <- meta_text_anfang_a$ObjRightLength7
meta_text_anfang_a_r8_length <- meta_text_anfang_a$ObjRightLength8
meta_text_anfang_a_r9_length <- meta_text_anfang_a$ObjRightLength9

meta_text_anfang_a_phoneme_duration_chain <- paste(
  # meta_text_anfang_a_l9_length,
  # meta_text_anfang_a_l8_length,
  # meta_text_anfang_a_l7_length,
  # meta_text_anfang_a_l6_length,
  # meta_text_anfang_a_l5_length,
  # meta_text_anfang_a_l4_length,
  meta_text_anfang_a_l3_length,
  meta_text_anfang_a_l2_length,
  meta_text_anfang_a_l1_length,
  "[",
  meta_text_anfang_a_l0_length,
  "]",
  meta_text_anfang_a_r1_length,
  meta_text_anfang_a_r2_length,
  meta_text_anfang_a_r3_length
) # ,
# meta_text_anfang_a_r4_length,
# meta_text_anfang_a_r5_length,
# meta_text_anfang_a_r6_length,
# meta_text_anfang_a_r7_length,
# meta_text_anfang_a_r8_length,
# meta_text_anfang_a_r9_length
# )

#### Phoneme-Frame-Chain of excerpt (Even neccessary?!)

################################################################################

##############################################
# Plot with points and added smooth function #
##############################################
plot_smooth <- function(data,
                        my_x,
                        my_y,
                        my_color,
                        my_title,
                        background_color,
                        title_color,
                        x_axis_title_color,
                        y_axis_title_color) {
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
    ylim(-1, 101) +
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
        color = title_color, size = 24,
        face = "bold.italic"
      ),
      legend.title = element_blank(),
      axis.title.x = element_blank(),
      # axis.title.x = element_text(
      #  color = x_axis_title_color,
      #  size = 14,
      #  face = "bold"
      # ),
      axis.title.y = element_blank(),
      # axis.title.y = element_text(
      #  color = y_axis_title_color,
      #  size = 14,
      #  face = "bold"
      # ),
      axis.text.x = element_text(size = 16),
      axis.text.y = element_text(size = 16)
    ) +
    theme(
      plot.background = element_rect(fill = background_color),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    ) + # top, right, bottom, left
    theme(panel.background = element_rect(fill = "#CCCCCC"))

  return(current_plot)
}



plot_global_pdf <- function(pdf_boolean,
                            png_boolean,
                            data,
                            identifier,
                            background_color,
                            title_color,
                            x_axis_title_color,
                            y_axis_title_color,
                            title_boolean,
                            text_color,
                            phoneme_chain_color,
                            phoneme_length_color,
                            image_width,
                            image_height) {
  list_of_dataframes <- list()
  list_of_plots <- list()
  list_of_plot_titles <- list()

  ######### "How well do the items perform in different excerpts?" ###############
  list_of_dataframes[[1]] <- filter(data, Excerpt == "Anfang", Object == "a")
  list_of_plot_titles[[1]] <- "Grades per Attribute for (Anfang-a)"
  list_of_dataframes[[2]] <- filter(data, Excerpt == "Anfang", Object == "p")
  list_of_plot_titles[[2]] <- "Grades per Attribute for  (Anfang-p)"
  # dataFilterAnfang <- filter(data, Excerpt == "Anfang")
  # dataFilterAnfangA <- filter(dataFilterAnfang, Object == "a")
  # dataFilterAnfangP <- filter(dataFilterAnfang, Object == "p")
  # dataFilterAnfangW <- filter(dataFilterAnfang, Object == "w")    # Not included

  list_of_dataframes[[3]] <- filter(data, Excerpt == "Europaeisch", Object == "a")
  list_of_plot_titles[[3]] <- "Grades per Attribute for  (Europaeisch-a)"
  list_of_dataframes[[4]] <- filter(data, Excerpt == "Europaeisch", Object == "p")
  list_of_plot_titles[[4]] <- "Grades per Attribute for  (Europaeisch-p)"
  # dataFilterEuropaeisch <- filter(data, Excerpt == "Europaeisch")
  # dataFilterEuropaeischA <- filter(dataFilterEuropaeisch, Object == "a")
  # dataFilterEuropaeischP <- filter(dataFilterEuropaeisch, Object == "p")
  # dataFilterEuropaeischW <- filter(dataFilterEuropaeisch, Object == "w") # N.i.

  list_of_dataframes[[5]] <- filter(data, Excerpt == "Impfangebot", Object == "w")
  list_of_plot_titles[[5]] <- "Grades per Attribute for  (Impfangebot-w)"
  # dataFilterImpfangebot <- filter(data, Excerpt == "Impfangebot")
  # dataFilterImpfangebotA <- filter(dataFilterImpfangebot, Object == "a") # N.i.
  # dataFilterImpfangebotP <- filter(dataFilterImpfangebot, Object == "p") # N.i.
  # dataFilterImpfangebotW <- filter(dataFilterImpfangebot, Object == "w")

  list_of_dataframes[[6]] <- filter(data, Excerpt == "Paar", Object == "a")
  list_of_plot_titles[[6]] <- "Grades per Attribute for  (Paar-a)"
  list_of_dataframes[[7]] <- filter(data, Excerpt == "Paar", Object == "p")
  list_of_plot_titles[[7]] <- "Grades per Attribute for  (Paar-p)"
  list_of_dataframes[[8]] <- filter(data, Excerpt == "Paar", Object == "w")
  list_of_plot_titles[[8]] <- "Grades per Attribute for  (Paar-w)"
  # dataFilterPaar <- filter(data, Excerpt == "Paar")
  # dataFilterPaarA <- filter(dataFilterPaar, Object == "a")
  # dataFilterPaarP <- filter(dataFilterPaar, Object == "p")
  # dataFilterPaarW <- filter(dataFilterPaar, Object == "w")

  list_of_dataframes[[9]] <- filter(data, Excerpt == "Pandemie", Object == "a")
  list_of_plot_titles[[9]] <- "Grades per Attribute for  (Pandemie-a)"
  list_of_dataframes[[10]] <- filter(data, Excerpt == "Pandemie", Object == "p")
  list_of_plot_titles[[10]] <- "Grades per Attribute for  (Pandemie-p)"
  # dataFilterPandemie <- filter(data, Excerpt == "Pandemie")
  # dataFilterPandemieA <- filter(dataFilterPandemie, Object == "a")
  # dataFilterPandemieP <- filter(dataFilterPandemie, Object == "p")
  # dataFilterPandemieW <- filter(dataFilterPandemie, Object == "w") # N.i.

  list_of_dataframes[[11]] <- filter(data, Excerpt == "Tempo", Object == "a")
  list_of_plot_titles[[11]] <- "Grades per Attribute for  (Tempo-a)"
  list_of_dataframes[[12]] <- filter(data, Excerpt == "Tempo", Object == "p")
  list_of_plot_titles[[12]] <- "Grades per Attribute for  (Tempo-p)"
  list_of_dataframes[[13]] <- filter(data, Excerpt == "Tempo", Object == "w")
  list_of_plot_titles[[13]] <- "Grades per Attribute for  (Tempo-w)"
  # dataFilterTempo <- filter(data, Excerpt == "Tempo")
  # dataFilterTempoA <- filter(dataFilterTempo, Object == "a")
  # dataFilterTempoP <- filter(dataFilterTempo, Object == "p")
  # dataFilterTempoW <- filter(dataFilterTempo, Object == "w")

  list_of_dataframes[[14]] <- filter(data, Excerpt == "Zusammen", Object == "a")
  list_of_plot_titles[[14]] <- "Grades per Attribute for  (Zusammen-a)"
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
      "Grade",
      "Modification",
      current_plot_title,
      background_color,
      title_color,
      x_axis_title_color,
      y_axis_title_color
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
  # p001 <- plot_smooth(data_filter_a_al, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Anfang-all)")
  # Anfang - all
  # p001 <- plot_smooth(dataFilterAnfang, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Anfang-all)")
  # Anfang - a
  # p002 <- plot_smooth(dataFilterAnfangA, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Anfang-a)")
  # Anfang - p
  # p003 <- plot_smooth(dataFilterAnfangP, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Anfang-p)")
  #######################
  # Excerpt Europaeisch #
  #######################
  # Europaeisch - all
  # p004 <- plot_smooth(dataFilterEuropaeisch, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Europaeisch-all)")
  # Europaeisch - a
  # p005 <- plot_smooth(dataFilterEuropaeischA, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Europaeisch-a)")
  # Europaeisch - p
  # p006 <- plot_smooth(dataFilterEuropaeischP, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Europaeisch-p)")
  #######################
  # Excerpt Impfangebot #
  #######################
  # Impfangebot - w
  # p007 <- plot_smooth(dataFilterImpfangebotW, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Impfangebot-w)")
  ################
  # Excerpt Paar #
  ################
  # Paar - all
  # p008 <- plot_smooth(dataFilterPaar, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Paar-all)")
  # Paar - a
  # p009 <- plot_smooth(dataFilterPaarA, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Paar-a)")
  # Paar - p
  # p010 <- plot_smooth(dataFilterPaarP, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Paar-p)")
  # Paar - w
  # p011 <- plot_smooth(dataFilterPaarW, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Paar-w)")
  ####################
  # Excerpt Pandemie #
  ####################
  # Pandemie - all
  # p012 <- plot_smooth(dataFilterPandemie, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Pandemie-all)")
  # Pandemie - a
  # p013 <- plot_smooth(dataFilterPandemieA, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Pandemie-a)")
  # Pandemie - p
  # p014 <- plot_smooth(dataFilterPandemieP, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Pandemie-p)")
  #################
  # Excerpt Tempo #
  #################
  # Tempo - all
  # p015 <- plot_smooth(dataFilterTempo, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Tempo-all)")
  # Tempo - a
  # p016 <- plot_smooth(dataFilterTempoA, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Tempo-a)")
  # Tempo - p
  # p017 <- plot_smooth(dataFilterTempoP, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Tempo-p)")
  # Tempo - w
  # p018 <- plot_smooth(dataFilterTempoW, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Tempo-w)")
  ####################
  # Excerpt Zusammen #
  ####################
  # Zusammen - a
  # p019 <- plot_smooth(dataFilterZusammenA, "Attribute", "Grade", "Modification", "Grades per Attribute for  (Zusammen-a)")

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
  # pdf(paste0("explore_03_global_", identifier, ".pdf"))
  # for (plot in list_of_plots) {
  #  print(plot)
  # }
  # dev.off()
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
