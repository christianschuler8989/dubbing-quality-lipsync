# Rprofile
#
# Preparation at start-up of project
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

# Prerequisites ################################################################
################################################################################
print("Loading packages:")
library(tidyverse) # Many useful functions
library(dplyr)    # Many useful functions
library(ggplot2) # Fancy plotting-functions
library(ggpubr)
library(rstatix)
# Load patchwork for neatly patching plots together
# https://stackoverflow.com/questions/1249548/side-by-side-plots-with-ggplot2

# Data and directories #########################################################
################################################################################
print("Reading data:")
# Set working directory for input
initial_dir <- getwd() # Save current working directory
setwd("~/thesis_october/evaluating/data/all/data_cooked") # Set working directory
# Read data
data_done <- read_csv(file = "data_cooked_done.csv")
print(paste("Number of observations in Done:", nrow(data_done), sep = " "))
# Set working directory for meta data
setwd("~/thesis_october/evaluating/data/meta/")
data_meta_text <- read_csv(file = "data_meta_text.csv")
# Set working directory for output
setwd("~/thesis_october/evaluating/data/all/data_images/")
# Meta data ####################################################################
################################################################################
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


print("Ready to go:")


