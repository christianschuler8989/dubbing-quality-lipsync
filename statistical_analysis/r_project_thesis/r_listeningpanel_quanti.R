# R-Script
# Analysis of listening panel
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

# Total Runtime
runtime_total <- sum(data_done$Runtime)/6 # In ms (/6 because 1 Trial = 6 Rows)
runtime_total <- runtime_total / 1000     # In s
runtime_total <- runtime_total / 60       # In m
#runtime_total <- runtime_total / 60      # In h
#runtime_total <- runtime_total / 24      # In d
# Total runtime of entire study in minutes:
runtime_total


# Preparations:
#options(dplyr.print_max = 100000)
options(dplyr.print_max = 10)

# All of the observations
data_prep

# Removed Runtime < 15000 ms
data_rare

# Removed observations where 4 or more Grades had the same value 
# (Every not filled out trial and also if subject could not detect differences)
data_medium_rare

# Removed duplicates of (SubjectName, TrialID, File)
data_medium

# Anonymization
data_done

study_participants <- data_prep %>% group_by(SubjectName) %>%
  distinct(SubjectName, .keep_all = TRUE)
print(paste("Number of participants: ", nrow(study_participants)))

study_participants <- data_rare %>% group_by(SubjectName) %>%
  distinct(SubjectName, .keep_all = TRUE)
print(paste("Number of participants reduced by Runtime: ", nrow(study_participants)))

study_participants <- data_medium_rare %>% group_by(SubjectName) %>%
  distinct(SubjectName, .keep_all = TRUE)
print(paste("Number of participants reduced by Bad detection/empty: ", nrow(study_participants)))

study_participants <- data_medium %>% group_by(SubjectName) %>%
  distinct(SubjectName, .keep_all = TRUE)
print(paste("Number of participants after anonymizing: ", nrow(study_participants)))

study_participants <- data_done %>% group_by(SubjectName) %>%
  distinct(SubjectName, .keep_all = TRUE)
print(paste("Number of participants reduced by duplicates: ", nrow(study_participants)))


study_participants_trials <- data_done %>% group_by(SubjectName) %>%
  #distinct(SubjectName, .keep_all = TRUE)
  summarise(TrialCount = n()/6)
  #mutate(TrialCount = n())
#print(paste("Number of finished trials per subject in average: ", nrow(study_participants_trials)))
study_participants_trials


#### For Blue
subjectTrialsBlue <- data_done %>% 
  dplyr::filter(Study == "Blue") %>%
  group_by(SubjectName) %>%
  summarise(TrialCount = n() / 6)
print(subjectTrialsBlue)
subjectTrialsBlueMean <- mean(subjectTrialsBlue$TrialCount)
subjectTrialsBlueMean

#### For Pink
subjectTrialsPink <- data_done %>% 
  dplyr::filter(TrialID == 186|TrialID == 149|TrialID == 139|TrialID == 050
                |TrialID == 179|TrialID == 168|TrialID == 103|TrialID == 002
                |TrialID == 005|TrialID == 018|TrialID == 113|TrialID == 201
                |TrialID == 134) %>% 
  #dplyr::filter(Study == "Blue") %>%
  group_by(SubjectName) %>%
  summarise(TrialCount = n() / 6)
print(subjectTrialsPink)
subjectTrialsPinkMean <- mean(subjectTrialsPink$TrialCount)
subjectTrialsPinkMean

#### For All
subjectTrialsAll <- data_done %>% 
  group_by(SubjectName) %>%
  summarise(TrialCount = n() / 6)
print(subjectTrialsAll)
subjectTrialsAllMean <- mean(subjectTrialsAll$TrialCount)
subjectTrialsAllMean


#mutate(TrialCount = n())
#print(paste("Number of finished trials per subject in average in BLUE: ", nrow(subjectTrialsBlue)))



################################################################################

################################################################################

################################################################################


plotSubjMetaData <- function(data, identifier, pdf_boolean, png_boolean) {
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
    paste0("listeningpanel-quanti/subjMetaTable-", identifier, ".pdf"),
    height = 11,
    width = 10
  )
  plot.new()
  # text("Subject Names")
  #grid.table(subj_names)
  #plot.new()
  #grid.table(subj_emails)
  #plot.new()
  #grid.table(subj_comments)
  #plot.new()
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
    pdf(file = paste0("listeningpanel-quanti/subjMeta-", identifier, ".pdf"))
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
        file = paste0("listeningpanel-quanti/subjMeta-", identifier, image_counter_padded, ".png"),
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
  #on.exit(setwd(initial_dir))
  # plotMetaPdf(data_prep, "prep")
  # plotMetaPdf(data_rare, "rare")
  # plotMetaPdf(data_medi, "medi")
  #### The final listening panel after all the data cleaning
  #plotSubjMetaData(data_done, "done", pdf_boolean, png_boolean)
  #### All participants right before the first real data cleaning (Reading the data kinda cleaned them a little bit)
  #plotSubjMetaData(data_prep, "prep", pdf_boolean, png_boolean)
}

main()