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
#library(patchwork)

# Name of study-run as variable input-parameter
studyRun <- 'all' # "yellow", "red", "purple"
workingDirectoryStart <- '~/thesis_october/evaluating/data/'
workingDirectoryEnd <- '/data_preprocessed/'
# Construct path for working directory
workingDirectory <- paste(workingDirectoryStart, studyRun, workingDirectoryEnd, sep="")

# Save current working directory (to set it back at the end of this script)
initialDir <- getwd()

# Set working directory
setwd(workingDirectory)

# Read data from .csv
data <- read.csv(file = 'dataPreprocessed.csv')


################################################################################
#                                                                              #
#                        ############################                          #
#                        ## First look at the data ##                          #
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

###############################
# Number of grades per object #
###############################
dataObjeNum <- data %>%
  group_by(Object)
perObje <- summarise(dataObjeNum, Grades = n())
perObje

################################
# Number of grades per excerpt #
################################
dataExceNum <- data %>%
  group_by(Excerpt)
perExce <- summarise(dataExceNum, Grades = n())
perExce

#####################################
# Number of grades per modification #
#####################################
dataModiNum <- data %>%
  group_by(Modification)
perModi <- summarise(dataModiNum, Grades = n())
perModi

#################################
# Number of grades per attribute #
#################################
dataAttrNum <- data %>%
  group_by(Attribute)
perAttr <- summarise(dataAttrNum, Grades = n())
perAttr

#############################
# Number of grades per item #
#############################
dataItemNum <- data %>%
  group_by(Item)
perItem <- summarise(dataItemNum, Grades = n())
perItem

######################
# Plot of quantities #
######################
p1 <- ggplot(perSubj, aes(x=SubjectName, y = FinishedTrials)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Finished Trials per Subject") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 10, angle = 65, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
p2 <- ggplot(perObje, aes(x=Object, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Object") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
p3 <- ggplot(perExce, aes(x=Excerpt, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Excerpt") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 10, angle = 65, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
p4 <- ggplot(perModi, aes(x=Modification, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Modification") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 16, vjust = 1, hjust = 1), # , angle = 65
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
p5 <- ggplot(perAttr, aes(x=Attribute, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Attribute") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 18),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
p6 <- ggplot(perItem, aes(x=Item, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Item") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 6, angle = 90, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
# Excluding the Anchors
dataItemExclAnchNum <- data %>%
  group_by(Item) %>%
  filter( (Attribute != 4 | (Modification != "mixMod_shiftLeft" | Modification != "multiMod_shiftRight")) & (Attribute != 0))
perItemExclAnch <- summarise(dataItemExclAnchNum, Grades = n())
perItemExclAnch

p7 <- ggplot(perItemExclAnch, aes(x=Item, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Item \n excluding Anchors") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 6, angle = 90, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
# Just the a
dataItemANum <- data %>%
  group_by(Item) %>%
  filter(Object == "a") %>%
  filter( (Attribute != 4 | (Modification != "mixMod_shiftLeft" | Modification != "multiMod_shiftRight")) & (Attribute != 0))
perItemANum <- summarise(dataItemANum, Grades = n())
#perItemANum
p8 <- ggplot(perItemANum, aes(x=Item, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Item (a) \n excluding Anchors") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 10, angle = 65, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
# Just the p
dataItemPNum <- data %>%
  group_by(Item) %>%
  filter(Object == "p") %>%
  filter( (Attribute != 4 | (Modification != "mixMod_shiftLeft" | Modification != "multiMod_shiftRight")) & (Attribute != 0))
perItemPNum <- summarise(dataItemPNum, Grades = n())
#perItemANum
p9 <- ggplot(perItemPNum, aes(x=Item, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Item (p) \n excluding Anchors") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 10, angle = 90, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

################################################################################
# Just the w
dataItemWNum <- data %>%
  group_by(Item) %>%
  filter(Object == "w") %>%
  filter( (Attribute != 4 | (Modification != "mixMod_shiftLeft" | Modification != "multiMod_shiftRight")) & (Attribute != 0))
perItemWNum <- summarise(dataItemWNum, Grades = n())
#perItemANum
p10 <- ggplot(perItemWNum, aes(x=Item, y = Grades)) +
        geom_bar(fill="firebrick", stat = "identity") + # Y axis is explicit.
        ggtitle("Grades per Item (w) \n excluding Anchors") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold")) +
        theme(axis.text.x = element_text(size = 10, angle = 90, vjust = 1, hjust = 1),
              axis.text.y = element_text(size = 18)) +
        theme(plot.background=element_rect(fill="lightblue"), plot.margin = unit(c(2, 4, 1, 3), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = 'steelblue'),
              panel.grid.major = element_line(colour = "black", size=1),
              panel.grid.minor = element_line(colour = "blue", size=1))

######### View of the data #####################################################
# View the first few entries
#head(data)




# Print to a png file:
png("p01.png")
print(p1)
dev.off()
png("p02.png")
print(p2)
dev.off()
png("p03.png")
print(p3)
dev.off()
png("p04.png")
print(p4)
dev.off()
png("p05.png")
print(p5)
dev.off()
png("p06.png")
print(p6)
dev.off()
png("p07.png")
print(p7)
dev.off()
png("p08.png")
print(p8)
dev.off()
png("p09.png")
print(p9)
dev.off()
png("p10.png")
print(p10)
dev.off()

# Print plots to a pdf file:
pdf("firstLookQuantitative.pdf")
print(p1)
print(p2)
print(p3)
print(p4)
print(p5)
print(p6)
print(p7)
print(p8)
print(p9)
print(p10)
dev.off()



################################################################################
#                                                                              #
#                       ##############################                         #
#                       ## First round of questions ##                         #
#                       ##############################                         #
#                                                                              #
################################################################################
# EXCERPT_ITEM_MODIFICATION_ATTRIBUTE
# = "All combinations of these are the set of "conditions" being testet"
# Grades.Mean()

######### How well do the single subjects grade? ###############################
dataGroupSubj <- data %>% group_by(SubjectName)
ggplot(dataGroupSubj, aes(x = SubjectName, y = Grade)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4)

######### How well do the single excerpts (video-clips) perform? ###############
dataGroupExce <- data %>% group_by(Excerpt)
ggplot(dataGroupExce, aes(x = Excerpt, y = Grade)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  theme(axis.text.x = element_text(size = 14)) +
  ggtitle("Grades per Excerpt") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"))

######### How well do the single objects (phonemes) perform? #####################
dataGroupObje <- data %>% group_by(Object)
ggplot(dataGroupObje, aes(x = Object, y = Grade)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  theme(axis.text.x = element_text(size = 18)) +
  ggtitle("Grades per Object") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"))

######### How well do the single modifications (type of) perform? ##############
dataGroupModi <- data %>% group_by(Modification)
ggplot(dataGroupModi, aes(x = Modification, y = Grade)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  theme(axis.text.x = element_text(size = 12, angle = 90, vjust = 1, hjust = 1)) +
  ggtitle("Grades per Modification") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"))

######### How well do the single attributes (level of change) perform? #########
dataGroupAttr <- data %>%
  group_by(Attribute) %>%
  mutate(Attribute = as.character(Attribute))
ggplot(dataGroupAttr, aes(x = Attribute, y = Grade)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  theme(axis.text.x = element_text(size = 18)) +
  ggtitle("Grades per Attribute") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"))

######### How well does every single item (combination) perform? ###############
dataGroupItem <- data %>% group_by(Item)
ggplot(dataGroupItem, aes(x = Item, y = Grade)) +
  geom_boxplot(outlier.colour = "hotpink") +
  geom_jitter(position = position_jitter(width = 0.1, height = 0), alpha = 1/4) +
  theme(axis.text.x = element_text(angle = 90, vjust = 1, hjust = 1)) +
  ggtitle("Grades per Item") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"))





######## Interconnected ########################################################

################################################################################
# Get all observations where Object is a
dataFilterA <- filter(data, Object == "a")
dataFilterASelectFacet <- select(dataFilterA, ResultID, Excerpt, Modification, Attribute, Grade)

################################################################################
ggplot(data = dataFilterASelectFacet) +
  geom_point(mapping = aes(x = Excerpt, y = Grade)) +
  facet_grid(Modification ~ Attribute)  +
  ggtitle("Grades per Excerpt to Modification \n to Attribute (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5, hjust = 1)) +
  theme(plot.background=element_rect(fill="#FFFFCC"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#FFCC99'))

################################################################################
# Get all observations where Object is p
dataFilterP <- filter(data, Object == "p")
dataFilterPSelectFacet <- select(dataFilterP, ResultID, Excerpt, Modification, Attribute, Grade)

################################################################################
ggplot(data = dataFilterPSelectFacet) +
  geom_point(mapping = aes(x = Excerpt, y = Grade)) +
  facet_grid(Modification ~ Attribute) +
  ggtitle("Grades per Excerpt to Modification \n to Attribute (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5, hjust = 1)) +
  theme(plot.background=element_rect(fill="#FFFFCC"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#FFCC99'))

################################################################################
# Get all observations where Object is w
dataFilterW <- filter(data, Object == "w")
dataFilterWSelectFacet <- select(dataFilterW, ResultID, Excerpt, Modification, Attribute, Grade)

################################################################################
ggplot(data = dataFilterWSelectFacet) +
  geom_point(mapping = aes(x = Excerpt, y = Grade)) +
  facet_grid(Modification ~ Attribute) +
  ggtitle("Grades per Excerpt to Modification \n to Attribute (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 12, angle = 90, vjust = 0.5, hjust = 1)) +
  theme(plot.background=element_rect(fill="#FFFFCC"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#FFCC99'))





######## Data => Excerpts => Objects => Modifications => Attributes => Grades ##

################################################################################

dataFilterAnfang <- filter(data, Excerpt == "Anfang")
dataFilterAnfangA <- filter(dataFilterAnfang, Object == "a")
dataFilterAnfangP <- filter(dataFilterAnfang, Object == "p")    # Not included
dataFilterAnfangW <- filter(dataFilterAnfang, Object == "w")    # Not included

######## All of it #############################################################
ggplot(data = dataFilterAnfangA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

ggplot(data = dataFilterAnfangA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Anfang) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

ggplot(data = dataFilterAnfangA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Anfang) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

################################################################################

dataFilterEuropaeisch <- filter(data, Excerpt == "Europaeisch")
dataFilterEuropaeischA <- filter(dataFilterEuropaeisch, Object == "a")    # Not included
dataFilterEuropaeischP <- filter(dataFilterEuropaeisch, Object == "p")
dataFilterEuropaeischW <- filter(dataFilterEuropaeisch, Object == "w")    # Not included

######## All of it #############################################################
par(mfrow=c(1,2))    # set the plotting area into a 1*2 array
p1 <- ggplot(data = dataFilterEuropaeischP) +
        geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
        ggtitle("Grades per Excerpts (Europaeisch) (p)") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold"),
              axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16)) +
        theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = '#CCCCCC'))

p2 <- ggplot(data = dataFilterEuropaeischP) +
        geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
        geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
        ggtitle("Grades per Excerpts (Europaeisch) (p)") +
        theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
              axis.title.x = element_text(color="blue", size=14, face="bold"),
              axis.title.y = element_text(color="#993333", size=14, face="bold"),
              axis.text.x = element_text(size = 16),
              axis.text.y = element_text(size = 16)) +
        theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
        theme(panel.background = element_rect(fill = '#CCCCCC'))

p1 + p2


################################################################################

dataFilterPaar <- filter(data, Excerpt == "Paar")
dataFilterPaarA <- filter(dataFilterPaar, Object == "a")    # Not included
dataFilterPaarP <- filter(dataFilterPaar, Object == "p")    # Not included
dataFilterPaarW <- filter(dataFilterPaar, Object == "w")


######## All of it #############################################################
ggplot(data = dataFilterPaarW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Paar) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

ggplot(data = dataFilterPaarW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Paar) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))


################################################################################

dataFilterPandemie <- filter(data, Excerpt == "Pandemie")
dataFilterPandemieA <- filter(dataFilterPandemie, Object == "a")    # Not included
dataFilterPandemieP <- filter(dataFilterPandemie, Object == "p")
dataFilterPandemieW <- filter(dataFilterPandemie, Object == "w")    # Not included

######## All of it #############################################################
ggplot(data = dataFilterPandemieP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Pandemie) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

ggplot(data = dataFilterPandemieP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Pandemie) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

################################################################################

dataFilterTempo <- filter(data, Excerpt == "Tempo")
dataFilterTempoA <- filter(dataFilterTempo, Object == "a")
dataFilterTempoP <- filter(dataFilterTempo, Object == "p")
dataFilterTempoW <- filter(dataFilterTempo, Object == "w")

######## All of it #############################################################
ggplot(data = dataFilterTempo) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Tempo)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

ggplot(data = dataFilterTempo) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Tempo)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the a #############################################################
ggplot(data = dataFilterTempoA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Tempo) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterTempoA) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Tempo) (a)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the p #############################################################
ggplot(data = dataFilterTempoP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Tempo) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterTempoP) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Tempo) (p)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

######## Just the w #############################################################
ggplot(data = dataFilterTempoW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  ggtitle("Grades per Excerpts (Tempo) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))
ggplot(data = dataFilterTempoW) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification), se = FALSE, method = lm) + # se = confidence interval around smooth
  ggtitle("Grades per Excerpts (Tempo) (w)") +
  theme(plot.title = element_text(color="darkgreen", size=24, face="bold.italic"),
        axis.title.x = element_text(color="blue", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(size = 16),
        axis.text.y = element_text(size = 16)) +
  theme(plot.background=element_rect(fill="#9999FF"), plot.margin = unit(c(1, 1, 1, 1), "cm")) + # top, right, bottom, left
  theme(panel.background = element_rect(fill = '#CCCCCC'))

################################################################################



  ################################################################################
  # Different plots oriented on observations
  # dataFilterASelectFacet == a
  # dataFilterPSelectFacet == p
  # dataFilterWSelectFacet == w
  # ##############################################################################
  # https://r4ds.had.co.nz/data-visualisation.html#introduction-1
  # Object a
  ggplot(data = dataFilterASelectFacet) +
    geom_point(mapping = aes(x = Attribute, y = Grade))






################################################################################
#                                                                              #
#                       ###############################                        #
#                       ## Second round of questions ##                        #
#                       ###############################                        #
#                                                                              #
################################################################################
# Grades.Mean()

######### "How well do the items perform in different excerpts?" ###############
#############
# Phoneme a #
#############
# a - Tempo

# a - Anfang

#############
# Phoneme p #
#############
# p - Tempo

# p - Europaeisch

# p - Pandemie

#################
# Phoneme pause #
#################
# w - Tempo

# w - Paar

######### "How well do the modifications perform for the same object?" ###########
##########
# Item a #
##########
# a - audioLeft

# a - audioRight

# a - visualLeft

# a - visualRight

# a - mixLeft

# a - mixRight

# a - mulLeft

# a - mulRight

##########
# Item p #
##########
# p - audioLeft

# p - audioRight

# p - visualLeft

# p - visualRight

# p - mixLeft

# p - mixRight

# p - mulLeft

# p - mulRight

##############
# Item pause #
##############
# pause - audioLeft

# pause - audioRight

# pause - visualLeft

# pause - visualRight

# pause - mixLeft

# pause - mixRight

# pause - mulLeft

# pause - mulRight


######### "How well do the attributes perform for the same modification?" ######
# audioLeft - 0

# audioLeft - 2

# audioLeft - 4

# audioLeft - 6

# audioRight - 2

# audioRight - 4

# audioRight - 6

# visualLeft - 2

# visualLeft - 4

# visualLeft - 6

# visualRight - 2

# visualRight - 4

# visualRight - 6

# mixLeft - 1

# mixLeft - 2

# mixLeft - 3

# mixRight - 1

# mixRight - 2

# mixRight - 3


#########  #############

################################################################################
#                                                                              #
#                   ######################################                     #
#                   ## Testing some plotting-techniques ##                     #
#                   ######################################                     #
#                                                                              #
################################################################################
# https://r4ds.had.co.nz/data-visualisation.html#introduction-1

######### Facet-Grids for each Object #############
# Facet-Grid for a
dataGroupedA <- data %>%
	filter(Object == "a")

dataA <- summarise(dataGroupedA, TrialsNumber = n())

dataA


################################################################################
# Different plots oriented on observations
# dataFilterASelectFacet == a
# dataFilterPSelectFacet == p
# dataFilterWSelectFacet == w
# ##############################################################################
# https://r4ds.had.co.nz/data-visualisation.html#introduction-1
# Object a
ggplot(data = dataFilterASelectFacet) +
  geom_point(mapping = aes(x = Attribute, y = Grade))
# All
ggplot(data = dataFilterASelectFacet) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade))
# Modification Group
ggplot(data = dataFilterASelectFacet) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, group = Modification))
# Modification Color
ggplot(data = dataFilterASelectFacet) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification))
# Modification Combined
ggplot(data = dataFilterASelectFacet) +
  geom_point(mapping = aes(x = Attribute, y = Grade, color = Modification)) +
  geom_smooth(mapping = aes(x = Attribute, y = Grade, color = Modification))


################################################################################
# Object p

################################################################################
# Object w
ggplot(data = dataFilterASelectFacet) +
  geom_point(mapping = aes(x = Excerpt, y = Grade)) +
  facet_grid(Modification ~ Attribute)

################################################################################






#dataFilteredAGroupedModi <- dataFilteredA %>%
#  group_by(Modification)




#ataSubjNum <- data %>%
#  group_by(SubjectName)
#perSubj <- summarise(dataSubjNum, FinishedTrials = n()/6)


#dataFilteredAGroupedModi

#dataGroupedA

# Facet-Grid for p

# Facet-Grid for w







#########  #############

#########  #############

#########  #############

#########  #############

#########  #############





# data


# Set current working directory back to the initial directory prior to script
setwd(initialDir)
