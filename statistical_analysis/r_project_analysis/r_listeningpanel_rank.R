# R-Script
#
# Input: Preprocessed data from the BA-study on lip-synchrony
#
# Output: New insights
#
# Author: Christian (Doofnase) Schuler
# Date: 2022 Jan
################################################################################

#### Plot functions ############################################################
################################################################################
#### Left part and therefore inverted x-axis
plot_part_left <- function(data, my_x, my_y, bg_color, ji_color) {
  current_plot <- ggplot(
    data = data,
    aes(
      x = data[[my_x]],
      y = data[[my_y]]
    )
  ) +
    geom_jitter(
      position = position_jitter(width = 0, height = 0),
      # width-jitter is an incorrect depiction of the results
      color = ji_color
      # alpha = 1 / 4
    ) +
    ylim(6, 1) + # y-axis flipped for rank (lowest == best)
    xlim(6, 0) + # x-axis flipped for left side
    geom_smooth(
      se = TRUE
    ) + # se = confidence interval around smooth
    # [TODO:] Here additional plot of a specified subjects ranking???
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
################################################################################
#### Right part and therefore no inverting of x-axis necessary
plot_part_right <- function(data, my_x, my_y, bg_color, ji_color) {
  current_plot <- ggplot(
    data = data,
    aes(
      x = data[[my_x]],
      y = data[[my_y]]
    )
  ) +
    geom_jitter(
      position = position_jitter(width = 0, height = 0),
      color = ji_color
      # alpha = 1 / 4
    ) +
    ylim(6, 1) + # y-axis flipped for rank (lowest == best)
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
################################################################################
#### Arranging 4 plots into one
plot_part_arrange <- function(plot_al, plot_ar, plot_vl, plot_vr,
                              my_excerpt, my_object, my_text,
                              my_phoneme_chain, my_phoneme_length,
                              bg_color,
                              ti_color,
                              xa_color,
                              ya_color,
                              ti_boolean,
                              tx_color,
                              pc_color,
                              pl_color) {
  current_plot <- ggarrange(
    plot_al, plot_ar, plot_vl, plot_vr,
    ncol = 2, nrow = 2, labels = c("aL", "aR", "vL", "vR"),
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
################################################################################
#### Arrangement of plots
plot_part <- function(data_al, data_vl, data_ar, data_vr,
                      my_excerpt, my_object, my_text,
                      my_phoneme_chain, my_phoneme_length,
                      bg_color,
                      ti_color,
                      xa_color,
                      ya_color,
                      ji_color,
                      ti_boolean,
                      tx_color,
                      pc_color,
                      pl_color) {
  plot_al <- plot_part_left(data_al, "Attribute", "Rank", bg_color, ji_color)
  plot_vl <- plot_part_left(data_vl, "Attribute", "Rank", bg_color, ji_color)
  plot_ar <- plot_part_right(data_ar, "Attribute", "Rank", bg_color, ji_color)
  plot_vr <- plot_part_right(data_vr, "Attribute", "Rank", bg_color, ji_color)
  
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
                              ji_color,
                              ti_boolean,
                              tx_color,
                              pc_color,
                              pl_color,
                              im_width,
                              im_height,
                              current_subject) {
  list_of_plots <- list()
  #### Filtering the data
  # Something like "For each combination of Excerpt and Object" do
  for (i in 1:14) {
    current_excerpt <- list_of_phoneme_metas[[i]][1]
    current_object <- list_of_phoneme_metas[[i]][2]
    current_text <- list_of_phoneme_texts[[i]]
    current_phoneme_chain <- list_of_phoneme_chains[[i]]
    current_phoneme_length <- list_of_phoneme_lengths[[i]]
    
    data_al <- data %>% dplyr::filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "aL"
    )
    data_vl <- data %>% dplyr::filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "vL"
    )
    data_ar <- data %>% dplyr::filter(
      Excerpt == current_excerpt, Object == current_object, Modification == "aR"
    )
    data_vr <- data %>% dplyr::filter(
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
      ji_color,
      ti_boolean,
      tx_color,
      pc_color,
      pl_color
    )
  }
  
  if (pdf_boolean == TRUE) {
    # Print plots to a pdf file:
    pdf(file = paste0("listening-panel-", identifier, ".pdf"))
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
        file = paste0("plots/", "listening-panel-", identifier, image_counter_padded, ".png"),
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
  background_color <- "#FFFFFF" # White
  title_color <- "#000000" # Black
  x_axis_title_color <- "#000000"
  y_axis_title_color <- "#000000"
  jitter_color <- "#000000"
  title_boolean <- FALSE
  text_color <- "#FF3300" # Red
  phoneme_chain_color <- "#0033FF" # Blue
  phoneme_length_color <- "#00CC00" # Green
  image_width <- 600
  image_height <- 600
  current_subject <- "Shadow"
  
  # Filter for Study == "Blue" to relax the plots in regard of the anchor-ratings
  # ! This also removes the GREEN-Anchors !
  # data_blue <- data_done %>% filter(Study == "Blue")
  
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
    jitter_color,
    title_boolean,
    text_color,
    phoneme_chain_color,
    phoneme_length_color,
    image_width,
    image_height,
    current_subject
  )
}

main()


# Set current working directory back to the initial directory prior to script
setwd(initial_dir)
