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
#                       ## Third round of questions ##                         #
#                       ##############################                         #
#                                                                              #
################################################################################
# Distributions

######## Phoneme position strings ##############################################
#### Meta-Information about Excerpt and Object
list_of_phoneme_metas <- list()

list_of_phoneme_metas[[1]] <- c("Anfang", "a")
list_of_phoneme_metas[[2]] <- c("Anfang", "p")
list_of_phoneme_metas[[3]] <- c("Europaeisch", "a")
list_of_phoneme_metas[[4]] <- c("Europaeisch", "p")
list_of_phoneme_metas[[5]] <- c("Impfangebot", "w")
list_of_phoneme_metas[[6]] <- c("Paar", "a")
list_of_phoneme_metas[[7]] <- c("Paar", "p")
list_of_phoneme_metas[[8]] <- c("Paar", "w")
list_of_phoneme_metas[[9]] <- c("Pandemie", "a")
list_of_phoneme_metas[[10]] <- c("Pandemie", "p")
list_of_phoneme_metas[[11]] <- c("Tempo", "a")
list_of_phoneme_metas[[12]] <- c("Tempo", "p")
list_of_phoneme_metas[[13]] <- c("Tempo", "w")
list_of_phoneme_metas[[14]] <- c("Zusammen", "a")

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
list_of_phoneme_chains <- list()
list_of_phoneme_lengths <- list()

for (i in 1:14) {
  current_excerpt <- list_of_phoneme_metas[[i]][1]
  current_object <- list_of_phoneme_metas[[i]][2]
  ###################
  # Phoneme objects #
  ###################
  # Get objects from data_meta_text input
  padding_factor <- 6
  padding_factor_number <- 4
  meta_text_current <- filter(
    data_meta_text,
    Excerpt == current_excerpt & Object == current_object
  )
  meta_text_current_l9 <- str_pad(
    meta_text_current$ObjLeft9,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l8 <- str_pad(
    meta_text_current$ObjLeft8,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l7 <- str_pad(
    meta_text_current$ObjLeft7,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l6 <- str_pad(
    meta_text_current$ObjLeft6,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l5 <- str_pad(
    meta_text_current$ObjLeft5,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l4 <- str_pad(
    meta_text_current$ObjLeft4,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l3 <- str_pad(
    meta_text_current$ObjLeft3,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l2 <- str_pad(
    meta_text_current$ObjLeft2,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l1 <- str_pad(
    meta_text_current$ObjLeft1,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_l0 <- str_pad(
    paste(
      "[",
      meta_text_current$Object,
      "]"
    ),
    width = padding_factor + 2, side = "both", pad = " "
  )
  meta_text_current_r1 <- str_pad(
    meta_text_current$ObjRight1,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r2 <- str_pad(
    meta_text_current$ObjRight2,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r3 <- str_pad(
    meta_text_current$ObjRight3,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r4 <- str_pad(
    meta_text_current$ObjRight4,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r5 <- str_pad(
    meta_text_current$ObjRight5,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r6 <- str_pad(
    meta_text_current$ObjRight6,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r7 <- str_pad(
    meta_text_current$ObjRight7,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r8 <- str_pad(
    meta_text_current$ObjRight8,
    width = padding_factor, side = "both", pad = " "
  )
  meta_text_current_r9 <- str_pad(
    meta_text_current$ObjRight9,
    width = padding_factor, side = "both", pad = " "
  )
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
    meta_text_current_l0,
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
  list_of_phoneme_chains[[i]] <- meta_text_current_chain

  #####################
  # Phoneme durations #
  #####################
  # Get Phoneme-Duration-Chain of excerpt
  meta_text_current_l9_length <- str_pad(
    meta_text_current$ObjLeftLength9,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l8_length <- str_pad(
    meta_text_current$ObjLeftLength8,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l7_length <- str_pad(
    meta_text_current$ObjLeftLength7,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l6_length <- str_pad(
    meta_text_current$ObjLeftLength6,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l5_length <- str_pad(
    meta_text_current$ObjLeftLength5,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l4_length <- str_pad(
    meta_text_current$ObjLeftLength4,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l3_length <- str_pad(
    meta_text_current$ObjLeftLength3,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l2_length <- str_pad(
    meta_text_current$ObjLeftLength2,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l1_length <- str_pad(
    meta_text_current$ObjLeftLength1,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_l0_length <- str_pad(
    paste(
      "[",
      meta_text_current$ObjectLength,
      "]"
    ),
    width = padding_factor_number + 2, side = "both", pad = " "
  )
  meta_text_current_r1_length <- str_pad(
    meta_text_current$ObjRightLength1,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r2_length <- str_pad(
    meta_text_current$ObjRightLength2,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r3_length <- str_pad(
    meta_text_current$ObjRightLength3,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r4_length <- str_pad(
    meta_text_current$ObjRightLength4,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r5_length <- str_pad(
    meta_text_current$ObjRightLength5,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r6_length <- str_pad(
    meta_text_current$ObjRightLength6,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r7_length <- str_pad(
    meta_text_current$ObjRightLength7,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r8_length <- str_pad(
    meta_text_current$ObjRightLength8,
    width = padding_factor_number, side = "both", pad = " "
  )
  meta_text_current_r9_length <- str_pad(
    meta_text_current$ObjRightLength9,
    width = padding_factor_number, side = "both", pad = " "
  )
  # Combine Phoneme-Duration-Chain of excerpt
  meta_text_current_phoneme_duration_chain <- paste(
    meta_text_current_l9_length,
    meta_text_current_l8_length,
    meta_text_current_l7_length,
    meta_text_current_l6_length,
    meta_text_current_l5_length,
    meta_text_current_l4_length,
    meta_text_current_l3_length,
    meta_text_current_l2_length,
    meta_text_current_l1_length,
    meta_text_current_l0_length,
    meta_text_current_r1_length,
    meta_text_current_r2_length,
    meta_text_current_r3_length,
    meta_text_current_r4_length,
    meta_text_current_r5_length,
    meta_text_current_r6_length,
    meta_text_current_r7_length,
    meta_text_current_r8_length,
    meta_text_current_r9_length
  )
  # Put current phoneme_duration_chain into the list
  list_of_phoneme_lengths[[i]] <- meta_text_current_phoneme_duration_chain
}


#### Left part and therefore inverted x-axis
plot_part_left <- function(data, my_x, my_y, bg_color) {
  current_plot <- ggplot(
    data = data,
    aes(
      x = data[[my_x]],
      y = data[[my_y]]
    )
  ) +
    geom_point() +
    ylim(-1, 101) +
    xlim(6, 0) + # y-axis flipped
    geom_smooth(
      se = TRUE
    ) + # se = confidence interval around smooth
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank()
    ) +
    theme(
      plot.background = element_rect(fill = bg_color),
      plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), "cm")
    ) #+ # top, right, bottom, left
  # theme(panel.background = element_rect(fill = "#CCCCCC"))

  return(current_plot)
}

#### Right part and therefore no inverting of x-axis necessary
plot_part_right <- function(data, my_x, my_y, bg_color) {
  current_plot <- ggplot(
    data = data,
    aes(
      x = data[[my_x]],
      y = data[[my_y]]
    )
  ) +
    geom_point() +
    ylim(-1, 101) +
    geom_smooth(
      se = TRUE
    ) + # se = confidence interval around smooth
    theme(
      axis.title.x = element_blank(),
      axis.title.y = element_blank()
    ) +
    theme(
      plot.background = element_rect(fill = bg_color),
      plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), "cm")
    ) #+ # top, right, bottom, left
  # theme(panel.background = element_rect(fill = "#CCCCCC"))

  return(current_plot)
}

plot_part_arrange <- function(plot_al,
                              plot_ar,
                              plot_vl,
                              plot_vr,
                              my_excerpt,
                              my_object,
                              my_text,
                              my_phoneme_chain,
                              my_phoneme_length,
                              bg_color,
                              ti_color,
                              xa_color,
                              ya_color,
                              ti_boolean,
                              tx_color,
                              pc_color,
                              pl_color) {
  current_plot <- ggarrange(
    plot_al,
    plot_ar,
    plot_vl,
    plot_vr,
    ncol = 2,
    nrow = 2,
    labels = c("aL", "aR", "vL", "vR"),
    hjust = -0.2,
    vjust = 1.2
  )
  if (ti_boolean == TRUE) {
    current_plot <- annotate_figure(
      current_plot,
      top = text_grob(
        paste(my_excerpt, "-", my_object),
        color = ti_color,
        face = "bold",
        size = 14
      )
    )
  }

  current_plot <- annotate_figure(
    current_plot,
    bottom = text_grob(
      my_text,
      color = tx_color,
      face = "bold",
      size = 12
    )
  )
  current_plot <- annotate_figure(
    current_plot,
    bottom = text_grob(
      my_phoneme_chain,
      color = pc_color,
      face = "bold",
      size = 12
    )
  )
  current_plot <- annotate_figure(
    current_plot,
    bottom = text_grob(
      my_phoneme_length,
      color = pl_color,
      face = "bold",
      size = 12
    )
  )
  return(current_plot)
}

#### Arrangement of plots
plot_part <- function(data_al,
                      data_vl,
                      data_ar,
                      data_vr,
                      my_excerpt,
                      my_object,
                      my_text,
                      my_phoneme_chain,
                      my_phoneme_length,
                      bg_color,
                      ti_color,
                      xa_color,
                      ya_color,
                      ti_boolean,
                      tx_color,
                      pc_color,
                      pl_color) {
  plot_al <- plot_part_left(data_al, "Attribute", "Grade", bg_color)
  plot_vl <- plot_part_left(data_vl, "Attribute", "Grade", bg_color)
  plot_ar <- plot_part_right(data_ar, "Attribute", "Grade", bg_color)
  plot_vr <- plot_part_right(data_vr, "Attribute", "Grade", bg_color)

  current_plot <- plot_part_arrange(
    plot_al,
    plot_ar,
    plot_vl,
    plot_vr,
    my_excerpt,
    my_object,
    my_text, # Meta-Phoneme-Text
    my_phoneme_chain,
    my_phoneme_length,
    bg_color,
    ti_color,
    xa_color,
    ya_color,
    ti_boolean,
    tx_color,
    pc_color,
    pl_color
  )

  return(current_plot)
}


plot_specific_pdf <- function(pdf_boolean,
                              png_boolean,
                              data,
                              identifier,
                              bg_color,
                              ti_color,
                              xa_color,
                              ya_color,
                              ti_boolean,
                              tx_color,
                              pc_color,
                              pl_color,
                              im_width,
                              im_height) {
  list_of_plots <- list()
  #### Filtering the data
  # Something like "For each combination of Excerpt and Object" do
  for (i in 1:14) {
    current_excerpt <- list_of_phoneme_metas[[i]][1]
    current_object <- list_of_phoneme_metas[[i]][2]
    current_text <- list_of_phoneme_texts[[i]]
    current_phoneme_chain <- list_of_phoneme_chains[[i]]
    current_phoneme_length <- list_of_phoneme_lengths[[i]]

    data_al <- data %>% filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "aL"
    )
    data_vl <- data %>% filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "vL"
    )
    data_ar <- data %>% filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "aR"
    )
    data_vr <- data %>% filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "vR"
    )

    list_of_plots[[i]] <- plot_part(
      data_al,
      data_vl,
      data_ar,
      data_vr,
      current_excerpt,
      current_object,
      current_text,
      current_phoneme_chain,
      current_phoneme_length,
      bg_color,
      ti_color,
      xa_color,
      ya_color,
      ti_boolean,
      tx_color,
      pc_color,
      pl_color
    )
  }

  if (pdf_boolean == TRUE) {
    # Print plots to a pdf file:
    pdf(file = paste0("explore_05_specific_", identifier, ".pdf"))
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
        file = paste0("plots/", "expl-05-spec", image_counter_padded, ".png"),
        width = im_width,
        height = im_height
      )
      print(plot)
      dev.off()
      image_counter <- image_counter + 1
    }
  }
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
  plot_specific_pdf(
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
