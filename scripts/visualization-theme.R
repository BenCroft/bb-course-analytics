# Visualization Customization

# Colors: "#333333" "#707276" "#B6B6B9"
new_theme <- function() {
  background_color <- "transparent" #"transparent"
  # Other key values
  theme_bw(base_size = 18, base_family = "Avenir") +#%+replace% 
    #quartzFonts(ANXTC = c("Avenir Next Condensed Regular", "Avenir Next Condensed Demi Bold", "Avenir Next Condensed Italic", "Avenir Next Condensed Demi Bold Italic"))
    theme(text = element_text(family = "ANXTC")) +
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