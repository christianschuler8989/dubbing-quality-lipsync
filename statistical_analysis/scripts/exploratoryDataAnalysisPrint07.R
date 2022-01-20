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
# Ranks.Mean() ???

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
  current_plot <- ggplot(data = data) +
    geom_point(mapping = aes(
      x = data[[my_x]],
      y = data[[my_y]],
      color = data[[my_color]]
    )) +
    # ylim(1, 6) + # y-axis not flipped
    ylim(6, 1) + # y-axis flipped
    geom_smooth(
      mapping = aes(
        x = data[[my_x]],
        y = data[[my_y]],
        color = data[[my_color]]
      ),
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



plot_local_pdf <- function(pdf_boolean,
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
  list_of_plots <- list()
  ######### "How well do the modifications perform for the same object?" #######
  ##########
  # Item a #
  ##########
  data_filter_a <- filter(data, Object == "a")
  data_filter_a_al <- filter(data_filter_a, Modification == "aL")
  data_filter_a_ar <- filter(data_filter_a, Modification == "aR")
  data_filter_a_vl <- filter(data_filter_a, Modification == "vL")
  data_filter_a_vr <- filter(data_filter_a, Modification == "vR")
  data_filter_a_il <- filter(data_filter_a, Modification == "iL")
  data_filter_a_ir <- filter(data_filter_a, Modification == "iR")
  data_filter_a_ul <- filter(data_filter_a, Modification == "uL")
  data_filter_a_ur <- filter(data_filter_a, Modification == "uR")
  ##############################################################################
  # a - audioLeft
  list_of_plots[[1]] <- plot_smooth(
    data_filter_a_al,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-aL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - audioRight
  list_of_plots[[2]] <- plot_smooth(
    data_filter_a_ar,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-aR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - visualLeft
  list_of_plots[[3]] <- plot_smooth(
    data_filter_a_vl,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-vL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - visualRight
  list_of_plots[[4]] <- plot_smooth(
    data_filter_a_vr,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-vR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - mixLeft
  list_of_plots[[5]] <- plot_smooth(
    data_filter_a_il,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-iL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - mixRight
  list_of_plots[[6]] <- plot_smooth(
    data_filter_a_ir,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-iR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - mulLeft
  list_of_plots[[7]] <- plot_smooth(
    data_filter_a_ul,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-uL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # a - mulRight
  list_of_plots[[8]] <- plot_smooth(
    data_filter_a_ur,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (a-uR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  ##########
  # Item p #
  ##########
  data_filter_p <- filter(data, Object == "p")
  data_filter_p_al <- filter(data_filter_p, Modification == "aL")
  data_filter_p_ar <- filter(data_filter_p, Modification == "aR")
  data_filter_p_vl <- filter(data_filter_p, Modification == "vL")
  data_filter_p_vr <- filter(data_filter_p, Modification == "vR")
  data_filter_p_il <- filter(data_filter_p, Modification == "iL")
  data_filter_p_ir <- filter(data_filter_p, Modification == "iR")
  data_filter_p_ul <- filter(data_filter_p, Modification == "uL")
  data_filter_p_ur <- filter(data_filter_p, Modification == "uR")
  ##############################################################################
  # p - audioLeft
  list_of_plots[[9]] <- plot_smooth(
    data_filter_p_al,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-aL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - audioRight
  list_of_plots[[10]] <- plot_smooth(
    data_filter_p_ar,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-aR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - visualLeft
  list_of_plots[[11]] <- plot_smooth(
    data_filter_p_vl,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-vL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - visualRight
  list_of_plots[[12]] <- plot_smooth(
    data_filter_p_vr,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-vR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - mixLeft
  list_of_plots[[13]] <- plot_smooth(
    data_filter_p_il,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-iL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - mixRight
  list_of_plots[[14]] <- plot_smooth(
    data_filter_p_ir,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-iR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - mulLeft
  list_of_plots[[15]] <- plot_smooth(
    data_filter_p_ul,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-uL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # p - mulRight
  list_of_plots[[16]] <- plot_smooth(
    data_filter_p_ur,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (p-uR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  ##############
  # Item pause #
  ##############
  data_filter_w <- filter(data, Object == "w")
  data_filter_w_al <- filter(data_filter_w, Modification == "aL")
  data_filter_w_ar <- filter(data_filter_w, Modification == "aR")
  data_filter_w_vl <- filter(data_filter_w, Modification == "vL")
  data_filter_w_vr <- filter(data_filter_w, Modification == "vR")
  data_filter_w_il <- filter(data_filter_w, Modification == "iL")
  data_filter_w_ir <- filter(data_filter_w, Modification == "iR")
  data_filter_w_ul <- filter(data_filter_w, Modification == "uL")
  data_filter_w_ur <- filter(data_filter_w, Modification == "uR")
  ##############################################################################
  # w - audioLeft
  list_of_plots[[17]] <- plot_smooth(
    data_filter_w_al,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-aL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - audioRight
  list_of_plots[[18]] <- plot_smooth(
    data_filter_w_ar,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-aR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - visualLeft
  list_of_plots[[19]] <- plot_smooth(
    data_filter_w_vl,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-vL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - visualRight
  list_of_plots[[20]] <- plot_smooth(
    data_filter_w_vr,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-vR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - mixLeft
  list_of_plots[[21]] <- plot_smooth(
    data_filter_w_il,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-iL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - mixRight
  list_of_plots[[22]] <- plot_smooth(
    data_filter_w_ir,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-iR)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - mulLeft
  list_of_plots[[23]] <- plot_smooth(
    data_filter_w_ul,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-uL)",
    background_color, x_axis_title_color, y_axis_title_color
  )
  ##############################################################################
  # w - mulRight
  list_of_plots[[24]] <- plot_smooth(
    data_filter_w_ur,
    "Attribute", "Rank", "Excerpt", "Ranks per Attribute for  (w-uR)",
    background_color, x_axis_title_color, y_axis_title_color
  )

  if (pdf_boolean == TRUE) {
    # Print plots to a pdf file:
    pdf(file = paste0("expl_07_local_rank_", identifier, ".pdf"))
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
        file = paste0("plots/", "expl-07-local", image_counter_padded, ".png"),
        width = image_width,
        height = image_height
      )
      print(plot)
      dev.off()
      image_counter <- image_counter + 1
    }
  }
  # Print plots to a pdf file:
  # pdf(paste0("explore_07_local_rank_", identifier, ".pdf"))
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
  plot_local_pdf(
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
