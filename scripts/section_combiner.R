
## 


combine_two_course_sections <- function(course1_directory, course2_directory, course_combined_directory, course1_section_number, course2_section_number) {
  
  ## Load data from each section
  
  dynamics1 <- read.csv(paste0(course1_directory, "dynamics.csv"))
  grades1 <- read.csv(paste0(course1_directory, "grades.csv"))
  items1 <- read.csv(paste0(course1_directory, "items.csv"))
  sis1 <- read.csv(paste0(course1_directory, "sis.csv"))
  statics1 <- read.csv(paste0(course1_directory, "statics.csv"))
  submissions1 <- read.csv(paste0(course1_directory, "submissions.csv"))
  
  dynamics2 <- read.csv(paste0(course2_directory, "dynamics.csv"))
  grades2 <- read.csv(paste0(course2_directory, "grades.csv"))
  items2 <- read.csv(paste0(course2_directory, "items.csv"))
  sis2 <- read.csv(paste0(course2_directory, "sis.csv"))
  statics2 <- read.csv(paste0(course2_directory, "statics.csv"))
  submissions2 <- read.csv(paste0(course2_directory, "submissions.csv"))
  
  ## Create a section column
  
  dynamics1 <- dynamics1 %>% mutate(CourseSection = course1_section_number)
  grades1 <- grades1 %>% mutate(CourseSection = course1_section_number)
  items1 <- items1 %>% mutate(CourseSection = course1_section_number)
  sis1 <- sis1 %>% mutate(CourseSection = course1_section_number)
  statics1 <- statics1 %>% mutate(CourseSection = course1_section_number)
  submissions1 <- submissions1 %>% mutate(CourseSection = course1_section_number)
  
  dynamics2 <- dynamics2 %>% mutate(CourseSection = course2_section_number)
  grades2 <- grades2 %>% mutate(CourseSection = course2_section_number)
  items2 <- items2 %>% mutate(CourseSection = course2_section_number)
  sis2 <- sis2 %>% mutate(CourseSection = course2_section_number)
  statics2 <- statics2 %>% mutate(CourseSection = course2_section_number)
  submissions2 <- submissions %>% mutate(CourseSection = course2_section_number)
  
  ## Append datasets 
  
  dynamics <- rbind(dynamics1, dynamics2)
  grades <- rbind(grades1, grades2)
  items <- rbind(items1, items2)
  sis <- rbind(sis1, sis2)
  statics <- rbind(statics1, statics2)
  submissions <- rbind(submissions1, submissions2)
  
  ## Write output files
  
  write.csv(dynamics, paste0(course_combined_directory, "dynamics.csv"))
  write.csv(grades, paste0(course_combined_directory, "grades.csv"))
  write.csv(items, paste0(course_combined_directory, "items.csv"))
  write.csv(sis, paste0(course_combined_directory, "sis.csv"))
  write.csv(statics, paste0(course_combined_directory, "statics.csv"))
  write.csv(submissions, paste0(course_combined_directory, "submissions.csv"))
  
}
