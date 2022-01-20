# R-Script
# Analysis of listening panel
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

runtime_total <- sum(data_done$Runtime)/6 # In ms (/6 because 1 Trial = 6 Rows)
runtime_total <- runtime_total / 1000     # In s
runtime_total <- runtime_total / 60       # In m
#runtime_total <- runtime_total / 60      # In h
#runtime_total <- runtime_total / 24      # In d
# Total runtime of entire study in minutes:
runtime_total

#### Preperations
identifier <- "all"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
options(max.print = 100000)
options(dplyr.print_max = 100000)

#### How well did they "find" the Anchros? #####################################
################################################################################
data <- data_done %>% dplyr::filter(Attribute == 0) %>%
  group_by(Attribute, Rank) %>%
  summarise(Count = n())
data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
data$identifier <- "High-Anchor"
  #count(Rank) %>%
  #group_by(Rank) %>%
  #summarise(Count = n())
#data$Percent <- paste(round(data$Count / sum(sexs$Count) * 100, 2), "%")
  #mutate(Percent = paste(round(data$n / sum(data$n) * 100, 2), "%"))
data_rank_high <- data
#data <- data %>% select(Rank, Count, Percent) # For slicker sink in txt
sink(sink_path, append = FALSE)
print("High-Anchor - Attribute = 0")
data
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
data
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
data
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
data
sink()

data <- data_done %>% dplyr::filter(Attribute == 2) %>%
  group_by(Attribute, Rank) %>%
  summarise(Count = n())
data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
data$identifier <- "2-Frames"
data_rank_02 <- data
sink(sink_path, append = TRUE)
print("Attribute = 2")
data
sink()

data <- data_done %>% dplyr::filter(Attribute == 3) %>%
  group_by(Attribute, Rank) %>%
  summarise(Count = n())
data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
data$identifier <- "3-Frames"
data_rank_03 <- data
sink(sink_path, append = TRUE)
print("Attribute = 3")
data
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
data
sink()

data <- data_done %>% dplyr::filter(Attribute == 5) %>%
  group_by(Attribute, Rank) %>%
  summarise(Count = n())
data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
data$identifier <- "5-Frames"
data_rank_05 <- data
sink(sink_path, append = TRUE)
print("Attribute = 5")
data
sink()

data <- data_done %>% dplyr::filter(Attribute == 6) %>%
  group_by(Attribute, Rank) %>%
  summarise(Count = n())
data$Percent <- paste(round(data$Count / sum(data$Count) * 100, 2), "%")
data$identifier <- "6-Frames"
data_rank_06 <- data
sink(sink_path, append = TRUE)
print("Attribute = 6")
data
sink()

####################################################
#### This but depending on mod!!!/obj???/exc??? ####
####################################################
data_anchors <- rbind(data_rank_high, data_rank_mid, data_rank_low)
data_items <- rbind(data_rank_01, data_rank_02, data_rank_03, data_rank_04, data_rank_05, data_rank_06)
data_combined <- rbind(data_anchors, data_items)

#### Barely shit ####
#ggplot(data_anchors, aes(x = Rank, y = Count, color = identifier)) +
#  geom_point() + geom_smooth()
#ggplot(data_items, aes(x = Rank, y = Count, color = identifier)) +
#  geom_point() + geom_smooth()
#### Barely shit ####

gg <- ggplot(data_combined, aes(x = Rank, y = Count, color = identifier)) +
  geom_point() +
  labs(title = "Scatterplot", x = "Rank", y = "Count")
#### Theme adding

gg1 <- gg + theme(plot.title = element_text(size = 30, face = "bold"),
                  axis.text.x = element_text(size = 15),
                  axis.text.y = element_text(size = 15),
                  axis.title.x = element_text(size = 25),
                  axis.title.y = element_text(size = 25)) +
  scale_color_discrete((name = "Type of PVS"))
  #scale_x_discrete(breaks = c("1", "2", "3", "4", "5", "6"))
  #scale_x_discrete(limits = c("1", "6"), breaks = seq(1, 6, 1))
  
gg1 + facet_wrap( ~ identifier, ncol = 3) #+
  #scale_x_discrete(breaks = c("1", "2", "3", "4", "5", "6"), labels = c("1", "2", "3", "4", "5", "6"))
png(
  file = paste0("listening_panel_rank/listening_panel_rank", identifier, ".png")
)
print(gg1)
dev.off()

#current_plot <- ggplot(data_anchors, aes(x = data_anchors[[Rank]], y = data_anchors[[Count]])) +
  #geom_bar()#fill = "firebrick", stat = "identity")# + # Y axis is explicit.
  #ggtitle("KACKE MAN") +
  #xlab("Funktionier") +
  #ylab("Halt endlich")

#ggplot(data = data_combined, aes(x = Rank, y = Count))

#p01 <- ggplot(data_rank_high, aes(Rank))

#p01 + geom_bar(Count)
#ggplot(data_rank_high) +
#  geom_bar(aes(x = Rank, y = Count))

#### Plot functions ############################################################
################################################################################
# Function: Plot of qualities of ranks (reversed y-axis) #
##########################################################
plot_quality_rank <- function(data, data_subj, my_x, my_y, my_z, my_title) {
  current_plot <- ggplot(data, aes(x = data[[my_x]], y = data[[my_y]])) +
    geom_point() +
    geom_smooth() +
    #geom_boxplot(outlier.colour = "hotpink") +
    #geom_jitter(
      #position = position_jitter(width = 0.1, height = 0),
      #alpha = 1 / 4
    #) +
    ylim(rev(range(data[[my_y]]))) +
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
    ) +
    theme(
      plot.background = element_rect(fill = "#FFFF99"),
      plot.margin = unit(c(1, 1, 1, 1), "cm")
    )
  return(current_plot)
}

#### Rating-tendencies of listening panel ######################################
################################################################################
# For every single item mean() and var()
data_item <- data_done %>% mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute)) %>%
  group_by(ItemNew) %>%
  mutate(meanRank = mean(Rank)) %>%
  mutate(meanGrade = mean(Grade)) %>%
  mutate(varRank = var(Rank)) %>%
  mutate(varGrade = var(Grade)) %>%
  mutate(number = n())# %>%
  #select(ItemNew, Excerpt, Object, Modification, Attribute, meanRank, varRank, meanGrade, varGrade)

data_item <- data_item %>% distinct(ItemNew, .keep_all = TRUE) %>%
  select(ItemNew, Excerpt, Object, Modification, Attribute, meanRank, varRank, meanGrade, varGrade, number)

# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

# Change the order of factor levels by specifying the order explicitly
# https://rstudio-pubs-static.s3.amazonaws.com/7433_4537ea5073dc4162950abb715f513469.html
data_item$Excerpt <- as.factor(data_item$Excerpt)
data_item$Object <- as.factor(data_item$Object)
data_item$Modification <- as.factor(data_item$Modification)
data_item$Attribute <- as.factor(data_item$Attribute)

# Order by Excerpt - Object - Modification - Attribute
data_item <- data_item[order(data_item$Excerpt, data_item$Object, data_item$Modification, data_item$Attribute),] 

identifier <- "all"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
sink(sink_path)
data_item
sink()

data_item <- data_item[order(data_item$number, data_item$Excerpt, data_item$Object, data_item$Modification, data_item$Attribute),] 

identifier <- "all"
sink_path <- paste0("listening_panel_rank/", identifier, "numbers-sink.txt")
sink(sink_path)
data_item
sink()

#### Get values for the subjects ###############################################
################################################################################
data_item <- data_done %>% mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute, TrialID)) %>%
  group_by(ItemNew) %>%
  #select(ResultID, ItemNew, Grade, Rank, Runtime, SubjectName, Excerpt, Object, Modification, Attribute, TrialID) %>%
  mutate(meanRank = mean(Rank)) %>%
  mutate(meanGrade = mean(Grade)) %>%
  mutate(varRank = var(Rank)) %>%
  mutate(varGrade = var(Grade))

# How far did every subjects rating vary from the meanRating of the listening panel:
data_item <- data_item %>% 
  mutate(meanRankDistance = meanRank - Rank) %>%
  mutate(meanGradeDistance = meanGrade - Grade)

# The mean of which the subjects ratings varied from the listening panel:
# !!! absolute values- otherwise the outlier cancel each other out !!!
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRankDistanceMean = sum(abs(meanRankDistance)) / n()) %>%
  mutate(meanGradeDistanceMean = sum(abs(meanGradeDistance)) / n())

# Mean Runtime for each subject:
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRuntime = mean(Runtime))

# How many trials got finished by each subject:
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(numberTrials = n())

#### Get values for the subjects #
##################################
data_item <- data_item %>% distinct(SubjectName, .keep_all = TRUE) %>%
  select(SubjectName, meanRankDistanceMean, meanGradeDistanceMean, meanRuntime, numberTrials)

data_item$meanRankDistanceMean <- as.factor(data_item$meanRankDistanceMean)

# Order by Excerpt - Object - Modification - Attribute
data_item <- data_item[order(data_item$meanRankDistanceMean),] 

# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

identifier <- "all_subjects"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
sink(sink_path)
data_item
sink()




################################################################################
#### The same procedure, but just fo BLUE 
# (To see if Biggus Dickus and laurenzio are really as good as they seem to be)
data_item <- data_done %>% dplyr::filter(Study == "Blue") %>% 
  mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute)) %>%
  group_by(ItemNew) %>%
  mutate(meanRank = mean(Rank)) %>%
  mutate(meanGrade = mean(Grade)) %>%
  mutate(varRank = var(Rank)) %>%
  mutate(varGrade = var(Grade)) %>%
  mutate(number = n())# %>%
#select(ItemNew, Excerpt, Object, Modification, Attribute, meanRank, varRank, meanGrade, varGrade)

data_item <- data_item %>% distinct(ItemNew, .keep_all = TRUE) %>%
  select(ItemNew, Excerpt, Object, Modification, Attribute, meanRank, varRank, meanGrade, varGrade, number)

# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

# Change the order of factor levels by specifying the order explicitly
# https://rstudio-pubs-static.s3.amazonaws.com/7433_4537ea5073dc4162950abb715f513469.html
data_item$Excerpt <- as.factor(data_item$Excerpt)
data_item$Object <- as.factor(data_item$Object)
data_item$Modification <- as.factor(data_item$Modification)
data_item$Attribute <- as.factor(data_item$Attribute)

# Order by Excerpt - Object - Modification - Attribute
data_item <- data_item[order(data_item$Excerpt, data_item$Object, data_item$Modification, data_item$Attribute),] 

#data_item$ItemNew <- factor(data_item_shadow$ItemNew, levels = data_item_shadow$ItemNew[order(data_item_shadow$meanRank)])

identifier <- "blue"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
sink(sink_path)
data_item
sink()


#### Get values for the subjects of blue #######################################
################################################################################
data_item <- data_done %>% dplyr::filter(Study == "Blue") %>%
  mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute, TrialID)) %>%
  group_by(ItemNew) %>%
  #select(ResultID, ItemNew, Grade, Rank, Runtime, SubjectName, Excerpt, Object, Modification, Attribute, TrialID) %>%
  mutate(meanRank = mean(Rank)) %>%
  mutate(meanGrade = mean(Grade)) %>%
  mutate(varRank = var(Rank)) %>%
  mutate(varGrade = var(Grade))

# How far did every subjects rating vary from the meanRating of the listening panel:
data_item <- data_item %>% 
  mutate(meanRankDistance = meanRank - Rank) %>%
  mutate(meanGradeDistance = meanGrade - Grade)

# The mean of which the subjects ratings varied from the listening panel:
# !!! absolute values- otherwise the outlier cancel each other out !!!
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRankDistanceMean = sum(abs(meanRankDistance)) / n()) %>%
  mutate(meanGradeDistanceMean = sum(abs(meanGradeDistance)) / n())

# Mean Runtime for each subject:
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRuntime = mean(Runtime))

# How many trials got finished by each subject:
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(numberTrials = n())

#### Get values for the subjects #
##################################
data_item <- data_item %>% distinct(SubjectName, .keep_all = TRUE) %>%
  select(SubjectName, meanRankDistanceMean, meanGradeDistanceMean, meanRuntime, numberTrials)

data_item$meanRankDistanceMean <- as.factor(data_item$meanRankDistanceMean)

# Order by Excerpt - Object - Modification - Attribute
data_item <- data_item[order(data_item$meanRankDistanceMean),] 

# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

identifier <- "blue_subjects"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
sink(sink_path)
data_item
sink()





################################################################################

################################################################################

################################################################################














  
  
  
  
  
  
  mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute, TrialID)) %>%
  group_by(ItemNew) %>%
  select(ResultID, ItemNew, Excerpt, Object, Modification, Attribute, TrialID) %>%
  mutate(meanRank = mean(Rank)) %>%
  mutate(meanGrade = mean(Grade)) %>%
  mutate(varRank = var(Rank)) %>%
  mutate(varGrade = var(Grade))
  
# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

identifier <- "blue"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
sink(sink_path)
data_item
sink()

#### Get values for the subjects ###############################################
################################################################################
data_item <- data_done %>% dplyr::filter(Study == "Blue") %>% 
  mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute, TrialID)) %>%
  group_by(ItemNew) %>%
  select(ResultID, ItemNew, Grade, Rank, Runtime, SubjectName, Excerpt, Object, Modification, Attribute, TrialID) %>%
  mutate(meanRank = mean(Rank)) %>%
  mutate(meanGrade = mean(Grade)) %>%
  mutate(varRank = var(Rank)) %>%
  mutate(varGrade = var(Grade))

# How far did every subjects rating vary from the meanRating of the listening panel:
data_item <- data_item %>% 
  mutate(meanRankDistance = meanRank - Rank) %>%
  mutate(meanGradeDistance = meanGrade - Grade)

# The mean of which the subjects ratings varied from the listening panel:
# !!! absolute values- otherwise the outlier cancel each other out !!!
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRankDistanceMean = sum(abs(meanRankDistance)) / n()) %>%
  mutate(meanGradeDistanceMean = sum(abs(meanGradeDistance)) / n())

# Mean Runtime for each subject:
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRuntime = mean(Runtime))

# How many trials got finished by each subject:
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(numberTrials = n())

#### Get values for the subjects #
##################################
data_item <- data_item %>% distinct(SubjectName, .keep_all = TRUE) %>%
  select(SubjectName, meanRankDistanceMean, meanGradeDistanceMean, meanRuntime, numberTrials)

# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

identifier <- "blue_subjects"
sink_path <- paste0("listening_panel_rank/", identifier, "-sink.txt")
sink(sink_path)
data_item
sink()




#
#
#
#
#
#








#### Rating-tendencies of listening panel ######################################
################################################################################
# For every single item
data_item <- data_done %>% dplyr::filter(Study == "Blue") %>%
  mutate(ItemNew = paste0(Excerpt, Object, Modification, Attribute, TrialID)) %>%
  group_by(ItemNew) %>%
  select(ResultID, ItemNew, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>%
  mutate(meanRank = mean(Rank))

# How far did every subjects Rank vary from the meanRank of the listening panel:
data_item <- data_item %>% mutate(meanRankVar = meanRank - Rank)

# Mean of variance of Rank from meanRank - for each subject:
# !!! absolute values- otherwise the outlier cancel each other out !!!
data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(meanRankVarMean = sum(abs(meanRankVar)) / n())
#head(data_item)

data_item <- data_item[order(data_item$meanRankVarMean),] 
#head(data_item)
#tail(data_item)

data_item <- data_item %>% group_by(SubjectName) %>%
  mutate(number = n())
data_item <- data_item %>% distinct(SubjectName, .keep_all = TRUE)

# From tibble to data.frame for printing more than 90 observations into sink
data_item <- as.data.frame(data_item)

sink(sink_path)
data_item
sink()








# For a specific subject
data_item_shadow <- data_item %>% dplyr::filter(SubjectName == "Shadow") %>%
  select(SubjectName, Rank, meanRank, ItemNew, Object)

# Order by meanRank
#data_item_shadow <- data_item_shadow[order(data_item_shadow$meanRank),] 

# Change the order of factor levels by specifying the order explicitly
# https://rstudio-pubs-static.s3.amazonaws.com/7433_4537ea5073dc4162950abb715f513469.html
data_item_shadow$ItemNew <- as.factor(data_item_shadow$ItemNew)

data_item_shadow$ItemNew <- factor(data_item_shadow$ItemNew, levels = data_item_shadow$ItemNew[order(data_item_shadow$meanRank)])



sink(sink_path)
## Levels ######################################################################
data_item_shadow
sink()

# Plot
#plot_quality_rank(data_item, data_item_shadow, "ItemNew", "meanRank", "Rank", "Subjects Rank to meanRank")


ggplot(data_item_shadow) +
  geom_line(aes(x = ItemNew, y = meanRank, color = Object)) +
  geom_line(aes(x = ItemNew, y = Rank, color = Object)) +
  theme(
    axis.text.x = element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1)
  )


ggplot(data_item_shadow, aes(x = ItemNew, y = meanRank, color = Object)) +
  geom_point() +
  theme(
    axis.text.x = element_text(size = 6, angle = 90, vjust = 0.5, hjust = 1)
    ) +
  geom_line(aes(x = ItemNew, y = Rank, color = Object))



#### Rating-tendencies of listening panel ######################################
################################################################################
data_t055 <- data_done %>% # TrialID 055 = First global Anchor
  dplyr::filter(TrialID == 055) %>%
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>% 
  mutate(PVS = paste0(Object, Modification, Attribute)) # PVSs ("Processed Video Sequences")
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum
data_t062 <- data_done %>% # TrialID 062 = Second global Anchor
  dplyr::filter(TrialID == 062) %>%
  select(ResultID, Excerpt, Attribute, Modification, Grade,
         Runtime, SubjectName, Object, TrialID, Rank) %>%
  mutate(PVS = paste0(Object, Modification, Attribute)) # PVSs ("Processed Video Sequences")
#SubjectAge, SubjectSex, SubjectInterest, SubjectLanguage, SessionID, SeqNum

data_t055$PVS <- as.factor(data_t055$PVS)
data_t062$PVS <- as.factor(data_t062$PVS)

levels(data_t055$PVS)
levels(data_t062$PVS)

data_t055 <- data_t055 %>%
  reorder_levels(PVS, order = c("paL0", "paL4", "aaL4", "waL4", "puR4", "piL4"))
data_t062 <- data_t062 %>%
  reorder_levels(PVS, order = c("pvR0", "pvR4", "avR4", "wvR4", "puR4", "piL4"))

levels(data_t055$PVS)
levels(data_t062$PVS)


#### Summary statistics
data_t055 %>%
  group_by(Object, Modification, Attribute) %>%
  get_summary_stats(Grade, type = "mean_sd")
data_t062 %>%
  group_by(Object, Modification, Attribute) %>%
  get_summary_stats(Grade, type = "mean_sd")

#### Visualization
ggboxplot(data_t055, x = "PVS", y = "Grade", main = "Summary statistics")

ggboxplot(data_t062, x = "PVS", y = "Grade", main = "Summary statistics")

# [TODO]: The above for every single PVS (?!)

#### Rating subjects by their alignment to listening panel (?) #################
################################################################################


#### Rating subjects by their ability to recognize the High-Anchor  ############
################################################################################



#### Rating subjects by their relation of the three anchors  ###################
################################################################################

