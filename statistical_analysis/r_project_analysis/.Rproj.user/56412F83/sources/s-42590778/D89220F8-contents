# R-Script
# Kruskal-Wallis for study data
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################
options(max.print = 100000)
options(dplyr.print_max = 100000)

################################################################################
################################################################################
################################################################################
################################################################################
identifier = "Excerpt"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName)  
#### Summary statistics
summary_statistics <- data %>% 
  group_by(Excerpt) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "Excerpt", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ Excerpt)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ Excerpt)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ Excerpt, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ Excerpt, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
pwc_dunn <- pwc_dunn %>% add_xy_position(x = Excerpt)
ggboxplot(data, x = "Excerpt", y = "Rank") +
  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_dunn)
  )
# For Wilcox test
pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = Excerpt)
ggboxplot(data, x = "Excerpt", y = "Rank") +
  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_wilcox)
  )
################################################################################
################################################################################
################################################################################
################################################################################
identifier = "Object"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName)  
#### Summary statistics
summary_statistics <- data %>% 
  group_by(Object) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "Object", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ Object)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ Object)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ Object, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ Object, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
pwc_dunn <- pwc_dunn %>% add_xy_position(x = Object)
ggboxplot(data, x = "Object", y = "Rank") +
  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_dunn)
  )
# For Wilcox test
pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = Object)
ggboxplot(data, x = "Object", y = "Rank") +
  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_wilcox)
  )
################################################################################
################################################################################
################################################################################
################################################################################
identifier = "Modification"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName)  
#### Summary statistics
summary_statistics <- data %>% 
  group_by(Modification) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "Modification", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ Modification)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ Modification)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ Modification, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ Modification, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
pwc_dunn <- pwc_dunn %>% add_xy_position(x = Modification)
ggboxplot(data, x = "Modification", y = "Rank") +
  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_dunn)
  )
# For Wilcox test
pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = Modification)
ggboxplot(data, x = "Modification", y = "Rank") +
  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_wilcox)
  )
################################################################################
################################################################################
################################################################################
################################################################################
identifier = "Attribute"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName)  
#### Summary statistics
summary_statistics <- data %>% 
  group_by(Attribute) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "Attribute", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ Attribute)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ Attribute)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ Attribute, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ Attribute, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
pwc_dunn <- pwc_dunn %>% add_xy_position(x = Attribute)
ggboxplot(data, x = "Attribute", y = "Rank") +
  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_dunn)
  )
# For Wilcox test
pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = Attribute)
ggboxplot(data, x = "Attribute", y = "Rank") +
  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_wilcox)
  )
################################################################################
################################################################################
################################################################################
################################################################################
identifier = "ObjExc"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName) %>%
  mutate(ObjExc = paste0(Object,Excerpt))
#### Summary statistics
summary_statistics <- data %>% 
  group_by(ObjExc) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "ObjExc", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ ObjExc)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ ObjExc)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ ObjExc, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ ObjExc, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
pwc_dunn <- pwc_dunn %>% add_xy_position(x = ObjExc)
ggboxplot(data, x = "ObjExc", y = "Rank") +
  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_dunn)
  )
# For Wilcox test
pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = ObjExc)
ggboxplot(data, x = "ObjExc", y = "Rank") +
  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_wilcox)
  )
################################################################################
################################################################################
################################################################################
################################################################################
identifier = "ModAtt"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName) %>%
  mutate(ModAtt = paste0(Modification,Attribute))
#### Summary statistics
summary_statistics <- data %>% 
  group_by(ModAtt) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "ModAtt", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ ModAtt)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ ModAtt)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ ModAtt, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ ModAtt, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
#pwc_dunn <- pwc_dunn %>% add_xy_position(x = ModAtt)
#ggboxplot(data, x = "ModAtt", y = "Rank") +
#  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
#  labs(
#    subtitle = get_test_label(res.kruskal, detailed = TRUE),
#    caption = get_pwc_label(pwc_dunn)
#  )
# For Wilcox test
#pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = ModAtt)
#ggboxplot(data, x = "ModAtt", y = "Rank") +
#  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
#  labs(
#    subtitle = get_test_label(res.kruskal, detailed = TRUE),
#    caption = get_pwc_label(pwc_wilcox)
#  )
################################################################################
################################################################################
################################################################################
################################################################################
identifier = "ObjModAtt"
sink_path <- paste0("kruskal-wallis/", identifier, ".txt")
#### Kruskal-Wallis test  ######################################################
#### Data preparation
data <- data_done %>% dplyr::filter((Modification != "uR") & (Modification != "iL")) %>% # Excluding Mid- and Low- Anchors
  select(Excerpt, Object, Modification, Attribute,
         Grade, Rank, Runtime, SubjectName) %>%
  mutate(ObjModAtt = paste0(Object,Modification,Attribute))
#### Summary statistics
summary_statistics <- data %>% 
  group_by(ObjModAtt) %>%
  get_summary_stats(Rank, type = "common")
sink(sink_path, append = FALSE)
print("Summary Statistics")
summary_statistics
sink()
#### Visualization
ggboxplot(data, x = "ObjModAtt", y = "Rank", palette = "jco")
#### Computation
res.kruskal <- data %>% kruskal_test(Rank ~ ObjModAtt)
sink(sink_path, append = TRUE)
print("Kruskal Computation")
res.kruskal
sink()
#### Effect size
kruskal_effectsize <- data %>% kruskal_effsize(Rank ~ ObjModAtt)
sink(sink_path, append = TRUE)
print("Kruskal Effect Size")
kruskal_effectsize
sink()
#### Multiple pairwise-comparisons
#### Pairwise comparisons using Dunn’s test:
pwc_dunn <- data %>% 
  dunn_test(Rank ~ ObjModAtt, p.adjust.method = "bonferroni") 
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Dunn Test")
pwc_dunn
sink()
#### Pairwise comparisons using Wilcoxon’s test:
pwc_wilcox <- data %>% 
  wilcox_test(Rank ~ ObjModAtt, p.adjust.method = "bonferroni")
sink(sink_path, append = TRUE)
print("Pairwise Comparisons Wilcox Test")
pwc_wilcox
sink()
#### Report
# Visualization: box plots with p-values
# For Dunn test
pwc_dunn <- pwc_dunn %>% add_xy_position(x = ObjModAtt)
ggboxplot(data, x = "ObjModAtt", y = "Rank") +
  stat_pvalue_manual(pwc_dunn, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_dunn)
  )
# For Wilcox test
pwc_wilcox <- pwc_wilcox %>% add_xy_position(x = ObjModAtt)
ggboxplot(data, x = "ObjModAtt", y = "Rank") +
  stat_pvalue_manual(pwc_wilcox, hide.ns = TRUE) +
  labs(
    subtitle = get_test_label(res.kruskal, detailed = TRUE),
    caption = get_pwc_label(pwc_wilcox)
  )