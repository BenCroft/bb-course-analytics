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

viz_OutcomesByStudentCreditLoad <- function(statics, sis_no_acad_plan) {
  
  # Create plot
  g <- statics %>%
    left_join(sis_no_acad_plan, by = "StudentID_Anon") %>%
    filter(!SISGradeLetter %in% c('W', 'CW', 'I')) %>%
    ggplot(aes(y = NormalizedScore, x = FullTimePartTimeDescription)) +
    geom_boxplot(aes(fill = FullTimePartTimeDescription)) +
    geom_jitter(width = 0.10) +
    my_theme() +
    labs(title = "Course Outcomes by Student Credit Load", 
         y = "Course Grade (Percent)", 
         x = "", 
         color = "Credit Load",
         subtitle = "Summer 2020 BIOL 228 | Section 4001 and 4002",
         caption = "Note: This dataset excludes students who withdrew or had an incomplete term") +
    scale_fill_manual(values = c("#009DD9", "#999999")) +
    theme(legend.position = "") +
    scale_y_continuous(limits = c(0, 100)) 
}


viz_OutcomesByGender <- function(statics, sis_no_acad_plan) {
  
  # Create plot
  g <- statics %>%
    left_join(sis_no_acad_plan, by = "StudentID_Anon") %>%
    filter(!SISGradeLetter %in% c('W', 'CW', 'I')) %>%
    ggplot(aes(y = NormalizedScore, x = Gender)) +
    geom_boxplot(aes(fill = Gender)) +
    geom_jitter(width = 0.10) +
    my_theme() +
    labs(title = "Course Outcomes by Gender", 
         y = "Course Grade (Percent)", 
         x = "", 
         color = "Credit Load",
         subtitle = "Summer 2020 BIOL 228 | Section 4001 and 4002",
         caption = "Note: This dataset excludes students who withdrew or had an incomplete term") +
    scale_fill_manual(values = c("#009DD9", "#999999")) +
    theme(legend.position = "") +
    scale_y_continuous(limits = c(0, 100)) 
}


viz_OutcomesByFirstTermAtInstitution <- function(statics, sis_no_acad_plan) {
  
  # Create plot
  g <- statics %>%
    left_join(sis_no_acad_plan, by = "StudentID_Anon") %>%
    filter(!SISGradeLetter %in% c('W', 'CW', 'I')) %>%
    ggplot(aes(y = NormalizedScore, x = as.factor(FirstTermAtInstution))) +
    geom_boxplot(aes(fill = as.factor(FirstTermAtInstution))) +
    geom_jitter(width = 0.10) +
    my_theme() +
    labs(title = "Course Outcomes by First Time at Inst. Status", 
         y = "Course Grade (Percent)", 
         x = "", 
         color = "Credit Load",
         subtitle = "Summer 2020 BIOL 228 | Section 4001 and 4002",
         caption = "Note: This dataset excludes students who withdrew or had an incomplete term") +
    scale_fill_manual(values = c("#009DD9", "#999999")) +
    theme(legend.position = "") +
    scale_y_continuous(limits = c(0, 100)) 
}



viz_OutcomesByAcademicLevel <- function(statics, sis_no_acad_plan) {
  
  # Create plot
  tmp <- statics %>%
    left_join(sis_no_acad_plan, by = "StudentID_Anon") %>%
    filter(!SISGradeLetter %in% c('W', 'CW', 'I')) %>%
    mutate(Description = factor(Description, levels=c("Freshman", "Sophomore", "Junior", "Senior", "Post-Bacc Undergraduate")))
  
  g <- ggplot(tmp, aes(y = NormalizedScore, x = as.factor(Description))) +
    geom_boxplot(aes(fill = as.factor(Description)), outlier.shape = NA) +
    geom_jitter(width = 0.10) +
    my_theme() +
    labs(title = "Course Outcomes by Academic Level", 
         y = "Course Grade (Percent)", 
         x = "", 
         color = "Credit Load",
         subtitle = "Summer 2020 BIOL 228 | Section 4001 and 4002",
         caption = "Note: This dataset excludes students who withdrew or had an incomplete term") +
    scale_fill_manual(values = c("#009DD9", "#999999", "#999999", "#999999", "#999999")) +
    theme(legend.position = "") +
    scale_x_discrete(labels = abbreviate) +
    scale_y_continuous(limits = c(0, 100)) #+
  #geom_text_repel(aes(y = NormalizedScore, x = as.factor(Description), label = round(NormalizedScore,0)))
}



viz_OutcomesByFirstGeneration <- function(statics, sis_no_acad_plan) {
  
  # Create plot
  tmp <- statics %>%
    left_join(sis_no_acad_plan, by = "StudentID_Anon") %>%
    filter(!SISGradeLetter %in% c('W', 'CW', 'I')) %>%
    mutate(FirstGen = case_when(FirstGen == "First Generation (Y)" ~ "First Gen",
                                FirstGen == "Not First Generation (N)" ~ "Not First Gen",
                                FirstGen == "Unknown" ~ "Unknown"))
  
  g <- ggplot(tmp, aes(y = NormalizedScore, x = as.factor(FirstGen))) +
    geom_boxplot(aes(fill = as.factor(FirstGen)), outlier.shape = NA) +
    geom_jitter(width = 0.10) +
    my_theme() +
    labs(title = "Course Outcomes by First Generation Status", 
         y = "Course Grade (Percent)", 
         x = "", 
         color = "Credit Load",
         subtitle = "Summer 2020 BIOL 228 | Section 4001 and 4002",
         caption = "Note: This dataset excludes students who withdrew or had an incomplete term") +
    scale_fill_manual(values = c("#009DD9", "#999999", "#999999", "#999999", "#999999")) +
    theme(legend.position = "") +
    #scale_x_discrete(labels = abbreviate) +
    scale_y_continuous(limits = c(0, 100))
  
}



viz_CourseItemGradeDistributions <- function(grades) {
  # #############################################
  # Step 1: Prep the data
  
  # Summarise the grades for each course item
  courseItemStudentSummary <- grades %>%
    # Filter out bad data and outliers
    filter(CourseItemKey != -1) %>%
    filter(AdjustedGrade > 0) %>%
    filter(LearnGradePercentKey > 20) %>%
    filter(GradeLetterKey != -1) %>%
    # Create a number for each course item 
    arrange(ItemTypeDescription, CourseItem) %>%
    mutate(Number = group_indices(., ItemTypeDescription)) %>%
    select(Number, ItemTypeDescription, CourseItem, AdjustedGrade, LearnGradePercentKey, CourseAccessMinutes) %>%
    arrange(ItemTypeDescription) %>%
    mutate(CourseItem = as.character(CourseItem)) %>%
    mutate(CourseItem_trimmed = ifelse(nchar(CourseItem) > 13, paste0(strtrim(CourseItem, 25), '...'), CourseItem))
  
  
  # #############################################
  # Step 2: Build the viz
  g<- ggplot(courseItemStudentSummary, aes(x = AdjustedGrade, y = CourseItem_trimmed, fill = ItemTypeDescription, color = ItemTypeDescription)) +
    geom_density_ridges(scale = 4, alpha = 0.5) +
    
    scale_x_continuous(expand = c(0, 0), limits = c(0, 110)) +   # for both axes to remove unneeded padding
    #scale_y_discrete(expand = c(0, 0)) +     # will generally have to set the `expand` option
    coord_cartesian(clip = "off") + # to avoid clipping of the very top of the top ridgeline
    theme_ridges() +
    scale_fill_manual(values = c("#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600")) +
    scale_color_manual(values = c("#003f5c", "#58508d", "#bc5090", "#ff6361", "#ffa600")) +
    scale_y_discrete(limits = rev(levels(as.factor(courseItemStudentSummary$CourseItem_trimmed)))) +
    theme(legend.position = "bottom",
          legend.box = "vertical",
          legend.title = element_blank(),
          axis.text.y = element_text(size = 11),
          axis.title.y = element_blank(),
          axis.title.x = element_text(size = 16, color = "gray50", vjust = 0)) +
    guides(fill=guide_legend(nrow=2, byrow = TRUE))
}





















































