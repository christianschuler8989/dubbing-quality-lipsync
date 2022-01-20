# Load tidyverse for many useful functions
library(tidyverse)
# Load dplyr for many useful functions
library(dplyr)

# Load ggplot2 for many fancy plotting-functions
library(ggplot2)

# Name of study-run as variable input-parameter
studyRun <- 'all' # "yellow", "red", "purple"
workingDirectoryStart <- '~/thesis_october/evaluating/data/'
workingDirectoryEnd <- '/data_preprocessed/'
# Construct path for working directory
workingDirectory <- paste(workingDirectoryStart, studyRun, workingDirectoryEnd, sep="")

# Set working directory
setwd(workingDirectory)

# Read data from .csv
data <- read.csv(file = 'dataPreprocessed.csv')

################################################################################
#                                                                              #
#                        ############################                          #
#                        ## DATA TYPES AND ACCESSING DATA.FRAMES AND SUCH ##                          #
#                        ############################                          #
#                                                                              #
################################################################################

######### Quantity of the data #################################################

###################################################
# Number of participants (+ Finished trials each) #
###################################################
dataSubjNum <- data %>%
  group_by(SubjectName)
perSubj <- summarise(dataSubjNum, FinishedTrials = n()/6)
perSubj


################################################################################
perSubj # Data.frame
typeof(perSubj)
################################################################################
select(perSubj, sample(colnames(perSubj[1]))) # All observations of first variable (column)
typeof(select(perSubj, sample(colnames(perSubj[1]))))
################################################################################
perSubj[1]
typeof(perSubj[1])
################################################################################
sample(perSubj[1])
typeof(sample(perSubj[1]))
################################################################################

################################################################################
sample(colnames(perSubj)) # Variable (Column)-names
typeof(sample(colnames(perSubj)))
################################################################################
sample(colnames(perSubj[1])) # First variable (column)-name
typeof(sample(colnames(perSubj[1])))
################################################################################

ggplot(perSubj, aes(x = SubjectName, y = FinishedTrials)) +
  geom_bar(fill = "firebrick", stat = "identity") + # Y axis is explicit.
  ggtitle("Finished Trials per Subject") +
  theme(plot.title = element_text(color = "darkgreen", size = 24, face="bold.italic"),
        axis.title.x = element_text(color = "blue", size = 14, face="bold"),
        axis.title.y = element_text(color = "#993333", size = 14, face="bold")) +
  theme(axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size = 18)) +
  theme(plot.background = element_rect(fill = "lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = 'steelblue'),
        panel.grid.major = element_line(colour = "black", size=2),
        panel.grid.minor = element_line(colour = "blue", size=1))



################################
# Function to plot simple data #
################################
plotSimple.fun <- function(df){
  simplePlot <- ggplot(perSubj, aes(x = df[1], y = df[2])) +
  # ggplot(perSubj, aes(x = SubjectName, y = FinishedTrials)) +
    geom_bar(fill = "firebrick", stat = "identity") + # Y axis is explicit.
    ggtitle("Finished Trials per Subject") +
    theme(plot.title = element_text(color = "darkgreen", size = 24, face="bold.italic"),
          axis.title.x = element_text(color = "blue", size = 14, face="bold"),
          axis.title.y = element_text(color = "#993333", size = 14, face="bold")) +
    theme(axis.text.x = element_text(size = 10),
          axis.text.y = element_text(size = 18)) +
    theme(plot.background = element_rect(fill = "lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
    theme(panel.background = element_rect(fill = 'steelblue'),
          panel.grid.major = element_line(colour = "black", size=2),
          panel.grid.minor = element_line(colour = "blue", size=1))
  #simplePlot <- ggplot(df, aes(x = xIdentifier, y = yIdentifier)) +
  #  geom_bar(fill = "firebrick", stat = "identity") +
  #  ggtitle("Title not variable yet")

  return(simplePlot)
}
test <- plotSimple.fun(perSubj)
test
################################################################################




























########################
# Adding new variables #
########################
# Duration of objects-left
# newMerk <- mutate(myMoerk, ObjectsLeftDuration = (ObjLeft3Length + ObjLeft2Length + ObjLeft1Length))
# Duration of objects-right
# newMerk <- mutate(myMoerk, ObjectsRightDuration = (ObjRight3Length + ObjRight2Length + ObjRight1Length))


summarise(myMoerk, Grading = mean(Grade))

######### Grouping by - Single #################################################
myGradingItem <- myMoerk %>%
  group_by(Item) %>%
  summarise(Grading = mean(Grade))

myGradingModification <- myMoerk %>%
  group_by(Modification) %>%
  summarise(Grading = mean(Grade))

myGradingAttribute <- myMoerk %>%
  group_by(Attribute) %>%
  summarise(Grading = mean(Grade))

myGradingItem

myGradingModification

myGradingAttribute


######### Grouping by - Multiple ###############################################


######## Overview how often each item of the triala has been rated yet ########
# Per Attribute #
myGradingItemModiAttr <- myMoerk %>%
  group_by(Item, Modification, Attribute)
per_attr <- summarise(myGradingItemModiAttr, myMoerk = n())
per_attr

# Per Modification #
myGradingItemModi <- myMoerk %>%
  group_by(Item, Modification)
per_modi <- summarise(myGradingItemModiAttr, myMoerk = n())
per_modi


# Per Item #
myGradingItem <- myMoerk %>%
  group_by(Item)
per_item <- summarise(myGradingItemModiAttr, myMoerk = n())
per_item


######## Overview of mean-ratings of the Item-Modification-Attributes ########
myGradingItemModiAttr <- myMoerk %>%
  group_by(Item, Modification, Attribute)

# Grouped by: Item -> Modification -> Attribute
per_attr <- summarise(myGradingItemModiAttr, MeanGrade = mean(Grade))
per_attr


# Grouped by: Item -> Modification
by_modi <- summarise(per_attr, MeanGrade = mean(MeanGrade)) # Grouped_by good for sum and count, not for mean or variance
by_modi









######## Just the a #############################################################
ggplot(data = dataFilterAnfangA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterAnfangA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
   ggtitle("Grades per Excerpts (Anfang) (a)") +
   theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the p #############################################################
ggplot(data = dataFilterAnfangP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterAnfangP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the w #############################################################
ggplot(data = dataFilterAnfangW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterAnfangW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))




######## Just the a #############################################################
ggplot(data = dataFilterEuropaeischA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Europaeisch) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterEuropaeischA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Europaeisch) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the p #############################################################
ggplot(data = dataFilterEuropaeischP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Europaeisch) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterEuropaeischP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Europaeisch) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the w #############################################################
ggplot(data = dataFilterEuropaeischW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Europaeisch) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterEuropaeischW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Europaeisch) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))




######## Just the a #############################################################
ggplot(data = dataFilterPaarA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Paar) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterPaarA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Paar) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the p #############################################################
ggplot(data = dataFilterPaarP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Paar) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterPaarP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Paar) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))




######## Just the a #############################################################
ggplot(data = dataFilterPandemieA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Pandemie) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterPandemieA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Pandemie) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))


######## Just the w #############################################################
ggplot(data = dataFilterPandemieW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Pandemie) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterPandemieW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Pandemie) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold")) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))













#### Moved from "Print05" ####
################################################################################
#                                                                              #
#                       ##############################                         #
#                       ## Third round of questions ##                         #
#                       ##############################                         #
#                                                                              #
################################################################################
# Distributions

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

#########
# Tempo #
#########
data_tempo <- data %>% filter(Excerpt == "Tempo")
data_tempo_p <- data %>% filter(Excerpt == "Tempo", Object == "p")
data_tempo_p_al_0 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "0")
data_tempo_p_al_1 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "1")
data_tempo_p_al_2 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "2")
data_tempo_p_al_3 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "3")
data_tempo_p_al_4 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "4")
data_tempo_p_al_5 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "5")
data_tempo_p_al_6 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL", Attribute == "6")

data_tempo_p_ar_0 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "0")
data_tempo_p_ar_1 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "1")
data_tempo_p_ar_2 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "2")
data_tempo_p_ar_3 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "3")
data_tempo_p_ar_4 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "4")
data_tempo_p_ar_5 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "5")
data_tempo_p_ar_6 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR", Attribute == "6")

data_tempo_p_il <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "iL")
data_tempo_p_il_0 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "iL", Attribute == "0")
data_tempo_p_il_1 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "iL", Attribute == "1")
data_tempo_p_il_2 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "iL", Attribute == "2")
data_tempo_p_il_3 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "iL", Attribute == "3")
data_tempo_p_il_4 <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "iL", Attribute == "4")

plotMyNormal <- function(dataset) {
  number_of_rows <- nrow(dataset)
  plot_title <- paste("Number of observations: ", number_of_rows)
  my_plot <- ggplot(dataset, aes(x = Grade)) +
    geom_histogram(aes(y = ..density..),
      fill = "steelblue",
      color = "grey",
      binwidth = 2
    ) +
    xlim(-1, 101) +
    stat_function(
      fun = dnorm,
      args = list(
        mean = mean(dataset$Grade),
        sd = sd(dataset$Grade)
      ),
      color = "red", size = 2
    ) +
    ggtitle(plot_title) # +
  # annotate("label", x = 10, y = 0.05, label = number_of_rows, alpha = 0.4)
  return(my_plot)
}

plotty <- plotMyNormal(data_tempo_p_il_4)
plotty

plotto <- plotMyNormal(data_tempo_p_al_1)
plotto

plotMyNormal(data_tempo_p_al_2)
plotMyNormal(data_tempo_p_al_3)
plotMyNormal(data_tempo_p_al_4)
plotMyNormal(data_tempo_p_al_5)
plotMyNormal(data_tempo_p_al_6)

plotMyNormal(data_tempo_p_ar_0)
plotMyNormal(data_tempo_p_ar_1)
plotMyNormal(data_tempo_p_ar_2)
plotMyNormal(data_tempo_p_ar_3)
plotMyNormal(data_tempo_p_ar_4)
plotMyNormal(data_tempo_p_ar_5)
plotMyNormal(data_tempo_p_ar_6)

plotMyNormal(data)

#### Quantity ##################################################################
nrow(data)
nrow(data_tempo_p_al_0)
nrow(data_tempo_p_al_1)
nrow(data_tempo_p_al_2)
nrow(data_tempo_p_al_3)
nrow(data_tempo_p_al_4)
nrow(data_tempo_p_al_5)
nrow(data_tempo_p_al_6)

nrow(data_tempo_p_ar_0)
nrow(data_tempo_p_ar_1)
nrow(data_tempo_p_ar_2)
nrow(data_tempo_p_ar_3)
nrow(data_tempo_p_ar_4)
nrow(data_tempo_p_ar_5)
nrow(data_tempo_p_ar_6)

nrow(data_tempo_p_il_0)
nrow(data_tempo_p_il_1)
nrow(data_tempo_p_il_2)
nrow(data_tempo_p_il_3)
nrow(data_tempo_p_il_4)




#### Quality ###################################################################
install.packages("ggpubr")
library(ggpubr)

data_tempo_p_al <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aL")
data_tempo_p_ar <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "aR")
data_tempo_p_vl <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "vL")
data_tempo_p_vr <- data %>% filter(Excerpt == "Tempo", Object == "p", Modification == "vR")



plotMyExcerpt <- function(dataset) {
  number_of_rows <- nrow(dataset)
  plot_title <- paste("Number of observations: ", number_of_rows)
  my_plot <- ggplot(dataset, aes(x = Attribute, y = Grade)) +
    geom_point(mapping = aes(x = Attribute, y = Grade, color = Object)) +
    geom_smooth(
      mapping = aes(x = Attribute, y = Grade, color = Object),
      se = FALSE
    ) + # se = confidence interval around smooth
    ggtitle(plot_title) +
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
    theme(panel.background = element_rect(fill = "#CCCCCC"))
  return(my_plot)
}

myplot01 <- plotMyExcerpt(data_tempo_p_al)

myplot02 <- plotMyExcerpt(data_tempo_p_ar)

myplot03 <- plotMyExcerpt(data_tempo_p_vl)

myplot04 <- plotMyExcerpt(data_tempo_p_vr)


plotMyExcerpts <- function(plotname, plot01, plot02, plot03, plot04) {
  png(filename = paste(plotname, ".png"), width = 1200, height = 1200)
  current_plot <- ggarrange(plot01, plot02, plot03, plot04,
    ncol = 2, nrow = 2, labels = "AUTO"
  )
  print(current_plot)
  dev.off()
}

plotMyExcerpts("TestName", myplot01, myplot02, myplot03, myplot04)
