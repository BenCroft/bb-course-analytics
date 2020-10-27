# Visualization Customization

# Colors: "#333333" "#707276" "#B6B6B9"
my_theme <- function() {
  background_color <- "transparent" #"transparent"
  # Other key values
  theme_bw(base_size = 18, base_family = "Avenir") +#%+replace% 
    #quartzFonts(ANXTC = c("Avenir Next Condensed Regular", "Avenir Next Condensed Demi Bold", "Avenir Next Condensed Italic", "Avenir Next Condensed Demi Bold Italic"))
    #theme(text = element_text(family = "ANXTC")) +
    theme(panel.background = element_rect(fill = background_color, color = NA)) +
    theme(panel.border = element_rect(color = background_color)) +
    theme(panel.grid.major = element_blank()) +
    theme(panel.grid.minor = element_blank()) +
    theme(panel.grid.major.y = element_line(colour = "#dddddd", linetype = "dotted", size = 1)) + 
    #theme(panel.grid.major.x=element_blank()) +    
    #theme(panel.grid.minor.y = element_line(colour = "#B6B6B9", linetype = "dotted")) + 
    #theme(panel.grid.minor.x =element_blank()) +    
    theme(plot.background = element_rect(fill = background_color, color = NA)) +
    theme(plot.title = element_text(color = "gray30", face = "bold", size = 20, vjust = 1.00)) +
    theme(plot.subtitle = element_text(color = "#707276",  face = "plain", size = 16)) +   
    theme(plot.caption = element_text(color = "#707276", size = 12, face = "plain")) +
    #theme(strip.background = element_rect(fill="white")) +
    theme(axis.ticks = element_blank()) +
    theme(axis.line = element_line(color = "grey30", size = 0.5, linetype = "solid")) + 
    theme(axis.text.x = element_text(size = 16, color = "gray30")) +
    theme(axis.text.y = element_text(size = 16, color = "gray30")) +
    theme(axis.title.x = element_text(size = 16, color = "gray50", vjust = 0)) +
    theme(axis.title.y = element_text(size = 16, color = "gray50", vjust = 1.00)) + 
    theme(legend.position = "top") + #theme(legend.position = "") +
    theme(legend.background = element_rect(fill = background_color)) +
    theme(legend.key = element_rect(color = background_color)) +
    theme(legend.key.width = unit(0.9, "cm")) +
    theme(legend.key.height = unit(0.9, "cm")) +
    theme(legend.text = element_text(size = 14, face = "plain", color = "gray50")) +
    theme(legend.title = element_text(size = 16, face = "bold")) +
    theme(plot.margin = margin(1, 1, 1, 1, "cm")) 
}


viz_FinalGradeDistribution <- function(statics) {
  # Step 1: Prep the data
  statics_viz_df1 <- statics %>%
    select(SISGradeLetter) %>%
    mutate(SISGradeLetter = factor(SISGradeLetter,levels = c("A+", "A", "A-", 
                                                             "B+", "B", "B-", 
                                                             "C+", "C", "C-", 
                                                             "D+", "D", "D-", 
                                                             "F", "CW", "W")))
  
  statis_viz_df2 <- data.frame(table(statics_viz_df1)) %>%
    rename(SISGradeLetter = statics_viz_df1) %>%
    mutate(Count = Freq) %>% 
    mutate(Outcome = case_when(SISGradeLetter %in% c("A+", "A", "A-", "B+", "B", "B-", "C+", "C", "C-") ~ "Above C-",
                               SISGradeLetter %in% c("D+", "D", "D-", "F") ~ "DF",
                               SISGradeLetter %in% c("CW", "W", "I") ~ "Withdrew/Incomplete")) %>%
    mutate(RowNumber = row_number()) %>%
    select(RowNumber, SISGradeLetter, Freq, Outcome)
  
  # #####################################
  # Step 2: Build the visualization
  g <- ggplot(statis_viz_df2, aes(x = SISGradeLetter, y = Freq)) + 
    geom_bar(stat = "identity", aes(fill = Outcome), alpha = 0.8) +
    #   # Add the theme layers
    my_theme() +
    
    scale_y_continuous(breaks = pretty_breaks()) +
    scale_fill_manual(name = "Outcome", 
                      labels = c("Above C-", "Below C-", "Withdrew"), 
                      values = c("#009DD9", "#192841", "#999999")) +
    
    # Add labels
    labs(title = "Final Grade Distribution",
         subtitle = "Number of students receiving each grade letter",
         caption = paste0("eCampus Center"),
         x = "Grade Letter",
         y = "Number of Students")
  g
}