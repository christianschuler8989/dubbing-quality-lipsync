# R-Script
# Analysis of material used in study
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

#data_trials <- data_done %>% 
#  select(TrialID) %>%
#  distinct(TrialID, .keep_all = TRUE)
#data_trials <- data_trials[order(data_trials$TrialID), ]

# data_trials # => Every trial (210) has been finished at least once.

################################################################################
#### Distribution of Items
data_item <- data_done %>% 
  select(Item, Object, Excerpt, Modification, Attribute, ) %>%
  distinct(Item, .keep_all = TRUE)
data_item <- data_item[order(data_item$Item), ]

# data_item # => Every item (1260) has been rated at least once.

data_item_object <- data_item %>%
  group_by(Object) %>%
  summarise(Count = n())
#data_item_object 
# => 
#1 a        490
#2 p        496
#3 w        274

data_item_excerpt <- data_item %>%
  group_by(Excerpt) %>%
  summarise(Count = n())
#data_item_excerpt
# =>
#1 Anfang        180
#2 Europaeisch   168
#3 Impfangebot    72
#4 Paar          252
#5 Pandemie      168
#6 Tempo         348
#7 Zusammen       72

data_item_modification <- data_item %>%
  group_by(Modification) %>%
  summarise(Count = n())
#data_item_modification
# =>
#1 aL             161
#2 aR             158
#3 iL             266
#4 iR              56
#5 uL              56
#6 uR             266
#7 vL             147
#8 vR             150

data_item_attribute <- data_item %>%
  group_by(Attribute) %>%
  summarise(Count = n())
#data_item_attribute
# =>
#1         0   210
#2         1   130
#3         2   144
#4         3   144
#5         4   520
#6         5    56
#7         6    56

data_item_object_excerpt <- data_item %>%
  group_by(Object, Excerpt) %>%
  summarise(Count = n())
#data_item_object_excerpt
# =>
#1 a      Anfang         96
#2 a      Europaeisch    72
#3 a      Paar           72
#4 a      Pandemie       72
#5 a      Tempo         106
#6 a      Zusammen       72
#7 p      Anfang         84
#8 p      Europaeisch    96
#9 p      Paar           84
#10 p      Pandemie       96
#11 p      Tempo         136
#12 w      Impfangebot    72
#13 w      Paar           96
#14 w      Tempo         106

data_item_object_modification <- data_item %>%
  group_by(Object, Modification) %>%
  summarise(Count = n())

data_item_object_excerpt_modification <- data_item %>%
  group_by(Object, Excerpt, Modification) %>%
  summarise(Count = n())
#data_item_object_excerpt_modification
# =>


plot_obj <- ggplot(data_item_object, aes(x = Object, y = Count)) +
  geom_bar(stat = "identity")
plot_obj

plot_obj_exc <- ggplot(data_item_object_excerpt, aes(x = Excerpt, y = Count, fill = Object)) +
  geom_bar(stat = "identity")


plot_obj_mod <- ggplot(data_item_object_modification, aes(x = Modification, y = Count, fill = Object)) +
  geom_bar(stat = "identity")


# Saving data to pdf or png ####################################################
################################################################################
png(
  file = paste0("datametadata/datameta-all-object-excerpt", ".png"),
  )
print(plot_obj_exc)
dev.off()
png(
  file = paste0("datametadata/datameta-all-object-modification", ".png"),
)
print(plot_obj_mod)
dev.off()

################################################################################

################################################################################

################################################################################
#### Distribution of Items
#### Same for BLUE
data_item <- data_done %>% 
  dplyr::filter(Study == "Blue") %>%
  select(Item, Object, Excerpt, Modification, Attribute, ) %>%
  distinct(Item, .keep_all = TRUE)
data_item <- data_item[order(data_item$Item), ]

data_item_object_excerpt <- data_item %>%
  group_by(Object, Excerpt) %>%
  summarise(Count = n())

data_item_object_modification <- data_item %>%
  group_by(Object, Modification) %>%
  summarise(Count = n())

plot_obj_exc <- ggplot(data_item_object_excerpt, aes(x = Excerpt, y = Count, fill = Object)) +
  geom_bar(stat = "identity")

plot_obj_mod <- ggplot(data_item_object_modification, aes(x = Modification, y = Count, fill = Object)) +
  geom_bar(stat = "identity")

# Saving data to pdf or png ####################################################
################################################################################
png(
  file = paste0("datametadata/datameta-blue-object-excerpt", ".png"),
)
print(plot_obj_exc)
dev.off()
png(
  file = paste0("datametadata/datameta-blue-object-modification", ".png"),
)
print(plot_obj_mod)
dev.off()

################################################################################

################################################################################

################################################################################
#### Distribution of Items
#### Same for PINK
data_item <- data_done %>% 
  dplyr::filter(TrialID == 186|TrialID == 149|TrialID == 139|TrialID == 050
                |TrialID == 179|TrialID == 168|TrialID == 103|TrialID == 002
                |TrialID == 005|TrialID == 018|TrialID == 113|TrialID == 201
                |TrialID == 134) %>%
  select(TrialID, Item, Object, Excerpt, Modification, Attribute, ) %>%
  distinct(Item, .keep_all = TRUE)
data_item <- data_item[order(data_item$Item), ]

data_item # => Every item from PINK (78) has been rated at least once.

data_item_object_excerpt <- data_item %>%
  group_by(Object, Excerpt) %>%
  summarise(Count = n())

data_item_object_modification <- data_item %>%
  group_by(Object, Modification) %>%
  summarise(Count = n())

plot_obj_exc <- ggplot(data_item_object_excerpt, aes(x = Excerpt, y = Count, fill = Object)) +
  geom_bar(stat = "identity")

plot_obj_mod <- ggplot(data_item_object_modification, aes(x = Modification, y = Count, fill = Object)) +
  geom_bar(stat = "identity")

# Saving data to pdf or png ####################################################
################################################################################
png(
  file = paste0("datametadata/datameta-pink-object-excerpt", ".png"),
)
print(plot_obj_exc)
dev.off()
png(
  file = paste0("datametadata/datameta-pink-object-modification", ".png"),
)
print(plot_obj_mod)
dev.off()

