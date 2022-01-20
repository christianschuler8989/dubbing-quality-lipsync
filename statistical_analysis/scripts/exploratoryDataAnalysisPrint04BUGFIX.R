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
# Set working directory
setwd(working_directory)
# Read data from .csv
data <- read.csv(file = "data_cooked.csv")

#### Read meta_data_text ####
working_directory_meta <- "~/thesis_october/evaluating/data/meta/"
# Set working directory
setwd(working_directory_meta)
# Read data from .csv
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
#                       ###############################                        #
#                       ## Second round of questions ##                        #
#                       ###############################                        #
#                                                                              #
################################################################################
# Grades.Mean() ???

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


######### "How well do the modifications perform for the same object?" #########
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
################################################################################
################################################################################
# a - mixLeft
# data_filter_a_il <- data_filter_a_il(Attribute = as.numeric(Attribute))

p005 <- ggplot(data = data_filter_a_il, aes(x = as.numeric(Attribute), y = Grade, color = Excerpt)) +
  geom_point() +
  geom_smooth(se = FALSE)

################################################################################

################################################################################
# a - mulRight
p008 <- ggplot(data = data_filter_a_ur) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Excerpt)) +
  geom_smooth(
    mapping = aes(x = Attribute, y = Grade, color = Excerpt),
    se = FALSE
  ) + # se = confidence interval around smooth
  ggtitle("Grades per Object (a-uR)") +
  theme(
    plot.title = element_text(
      color = "darkgreen", size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  xlim(0, 6) +
  theme(
    plot.background = element_rect(fill = "#9999FF"),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  ) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = "#CCCCCC")) +
  annotate("label", x = 2, y = 26, label = anfang_a, alpha = 0.2) +
  annotate("label", x = 2, y = 22, label = meta_text_anfang_a_phoneme_chain, alpha = 0.2) +
  annotate("label", x = 2, y = 18, label = meta_text_anfang_a_phoneme_duration_chain, alpha = 0.2) +
  annotate("label", x = 2, y = 14, label = europaeisch_a, alpha = 0.2) +
  annotate("label", x = 2, y = 10, label = paar_a, alpha = 0.2) +
  annotate("label", x = 2, y = 6, label = pandemie_a, alpha = 0.2) +
  annotate("label", x = 2, y = 2, label = tempo_a, alpha = 0.2) +
  annotate("label", x = 2, y = -2, label = zusammen_a, alpha = 0.2)

################################################################################
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
################################################################################

################################################################################
# p - mixLeft
p013 <- ggplot(data = data_filter_p_il) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Excerpt)) +
  geom_smooth(
    mapping = aes(x = Attribute, y = Grade, color = Excerpt),
    se = FALSE
  ) + # se = confidence interval around smooth
  ggtitle("Grades per Object (p-iL)") +
  theme(
    plot.title = element_text(
      color = "darkgreen", size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  xlim(0, 6) +
  theme(
    plot.background = element_rect(fill = "#9999FF"),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  ) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = "#CCCCCC")) +
  annotate("label", x = 2, y = 14, label = anfang_p, alpha = 0.2) +
  annotate("label", x = 2, y = 10, label = europaeisch_p, alpha = 0.2) +
  annotate("label", x = 2, y = 6, label = paar_p, alpha = 0.2) +
  annotate("label", x = 2, y = 2, label = pandemie_p, alpha = 0.2) +
  annotate("label", x = 2, y = -2, label = tempo_p, alpha = 0.2)

################################################################################

################################################################################
# p - mulRight
p016 <- ggplot(data = data_filter_p_ur) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Excerpt)) +
  geom_smooth(
    mapping = aes(x = Attribute, y = Grade, color = Excerpt),
    se = FALSE
  ) + # se = confidence interval around smooth
  ggtitle("Grades per Object (p-uR)") +
  theme(
    plot.title = element_text(
      color = "darkgreen", size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  xlim(0, 6) +
  theme(
    plot.background = element_rect(fill = "#9999FF"),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  ) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = "#CCCCCC")) +
  annotate("label", x = 2, y = 14, label = anfang_p, alpha = 0.2) +
  annotate("label", x = 2, y = 10, label = europaeisch_p, alpha = 0.2) +
  annotate("label", x = 2, y = 6, label = paar_p, alpha = 0.2) +
  annotate("label", x = 2, y = 2, label = pandemie_p, alpha = 0.2) +
  annotate("label", x = 2, y = -2, label = tempo_p, alpha = 0.2)

################################################################################
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
################################################################################
# w - audioLeft

################################################################################
# w - visualRight
p020 <- ggplot(data = data_filter_w_vr) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Excerpt)) +
  geom_smooth(
    mapping = aes(x = Attribute, y = Grade, color = Excerpt),
    se = FALSE
  ) + # se = confidence interval around smooth
  ggtitle("Grades per Object (w-vR)") +
  theme(
    plot.title = element_text(
      color = "darkgreen", size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  xlim(0, 6) +
  theme(
    plot.background = element_rect(fill = "#9999FF"),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  ) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = "#CCCCCC")) +
  annotate("label", x = 2, y = 6, label = impf_w, alpha = 0.2) +
  annotate("label", x = 2, y = 2, label = paar_w, alpha = 0.2) +
  annotate("label", x = 2, y = -2, label = tempo_w, alpha = 0.2)

################################################################################
# w - mixLeft
p021 <- ggplot(data = data_filter_w_il) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Excerpt)) +
  geom_smooth(
    mapping = aes(x = Attribute, y = Grade, color = Excerpt),
    se = FALSE
  ) + # se = confidence interval around smooth
  ggtitle("Grades per Object (w-iL)") +
  theme(
    plot.title = element_text(
      color = "darkgreen", size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  xlim(0, 6) +
  theme(
    plot.background = element_rect(fill = "#9999FF"),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  ) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = "#CCCCCC")) +
  annotate("label", x = 2, y = 6, label = impf_w, alpha = 0.2) +
  annotate("label", x = 2, y = 2, label = paar_w, alpha = 0.2) +
  annotate("label", x = 2, y = -2, label = tempo_w, alpha = 0.2)

################################################################################

################################################################################
# w - mulRight
p024 <- ggplot(data = data_filter_w_ur) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Excerpt)) +
  geom_smooth(
    mapping = aes(x = Attribute, y = Grade, color = Excerpt),
    se = FALSE
  ) + # se = confidence interval around smooth
  ggtitle("Grades per Object (w-uR)") +
  theme(
    plot.title = element_text(
      color = "darkgreen", size = 24,
      face = "bold.italic"
    ),
    axis.title.x = element_text(color = "blue", size = 14, face = "bold"),
    axis.title.y = element_text(color = "#993333", size = 14, face = "bold"),
    axis.text.x = element_text(size = 16),
    axis.text.y = element_text(size = 16)
  ) +
  xlim(0, 6) +
  theme(
    plot.background = element_rect(fill = "#9999FF"),
    plot.margin = unit(c(1, 1, 1, 1), "cm")
  ) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = "#CCCCCC")) +
  annotate("label", x = 2, y = 6, label = impf_w, alpha = 0.2) +
  annotate("label", x = 2, y = 2, label = paar_w, alpha = 0.2) +
  annotate("label", x = 2, y = -2, label = tempo_w, alpha = 0.2)





# Print plots to a pdf file:
pdf("explore_interconnected_local_BUGFIX.pdf")
print(p005)
print(p008)
print(p013)
print(p016)
print(p020)
print(p021)
print(p024)
dev.off()


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
