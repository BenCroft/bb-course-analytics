# Wrangling functions

## Edit week level indicator
fix_week_level <- function(my_data) {
  # Load required dependencies
  if (!require("pacman"))
    install.packages("pacman")
  pacman::p_load(dplyr)
  
  # Transform week level values
  df <- my_data %>%
    mutate(
      WeekLevel = case_when(
        WeekLevel == "Week 1" ~ "01",
        WeekLevel == "Week 2" ~ "02",
        WeekLevel == "Week 3" ~ "03",
        WeekLevel == "Week 4" ~ "04",
        WeekLevel == "Week 5" ~ "05",
        WeekLevel == "Week 6" ~ "06",
        WeekLevel == "Week 7" ~ "07",
        WeekLevel == "Week 8" ~ "08",
        WeekLevel == "Week 9" ~ "09",
        WeekLevel == "Week 10" ~ "10",
        WeekLevel == "Week 11" ~ "11",
        WeekLevel == "Week 12" ~ "12",
        WeekLevel == "Week 13" ~ "13",
        WeekLevel == "Week 14" ~ "14",
        WeekLevel == "Week 15" ~ "15",
        WeekLevel == "Week 16" ~ "16",
        WeekLevel == "Week 16 and After" ~ "16+",
        WeekLevel == "After end of Term" ~ "16+"
      )
    )
}


## Edit 24 hour time band indicator
fix_time_band_24hr <- function(my_data) {
  # Load required dependencies
  if (!require("pacman"))
    install.packages("pacman")
  pacman::p_load(dplyr)
  
  df <- my_data %>%
    mutate(
      TimeDescription = case_when(
        TimeDescription == "12 am - 12:59 am" ~ "00",
        TimeDescription == "1 am - 1:59 am" ~ "01",
        TimeDescription == "2 am - 2:59 am" ~ "02",
        TimeDescription == "3 am - 3:59 am" ~ "03",
        TimeDescription == "4 am - 4:59 am" ~ "04",
        TimeDescription == "5 am - 5:59 am" ~ "05",
        TimeDescription == "6 am - 6:59 am" ~ "06",
        TimeDescription == "7 am - 7:59 am" ~ "07",
        TimeDescription == "8 am - 8:59 am" ~ "08",
        TimeDescription == "9 am - 9:59 am" ~ "09",
        TimeDescription == "10 am - 10:59 am" ~ "10",
        TimeDescription == "11 am - 11:59 am" ~ "11",
        TimeDescription == "12 pm - 12:59 pm" ~ "12",
        TimeDescription == "1 pm - 1:59 pm" ~ "13",
        TimeDescription == "2 pm - 2:59 pm" ~ "14",
        TimeDescription == "3 pm - 3:59 pm" ~ "15",
        TimeDescription == "4 pm - 4:59 pm" ~ "16",
        TimeDescription == "5 pm - 5:59 pm" ~ "17",
        TimeDescription == "6 pm - 6:59 pm" ~ "18",
        TimeDescription == "7 pm - 7:59 pm" ~ "19",
        TimeDescription == "8 pm - 8:59 pm" ~ "20",
        TimeDescription == "9 pm - 9:59 pm" ~ "21",
        TimeDescription == "10 pm - 10:59 pm" ~ "22",
        TimeDescription == "11 pm - 11:59 pm" ~ "23"
      )
    )
}


## Edit day of week indicator
fix_day_of_week <- function(my_data) {
  # Load required dependencies
  if (!require("pacman"))
    install.packages("pacman")
  pacman::p_load(dplyr)
  
  df <- my_data %>%
    mutate(
      DayNameOfWeek = case_when(
        DayNameOfWeek == "Sunday" ~ "1-Sunday",
        DayNameOfWeek == "Monday" ~ "2-Monday",
        DayNameOfWeek == "Tuesday" ~ "3-Tuesday",
        DayNameOfWeek == "Wednesday" ~ "4-Wednesday",
        DayNameOfWeek == "Thursday" ~ "5-Thursday",
        DayNameOfWeek == "Friday" ~ "6-Friday",
        DayNameOfWeek == "Saturday" ~ "7-Saturday"
      )
    )
}

## Anonymize
anonymize_students <- function(my_data) {
  df <- my_data
  
  tryCatch({
    df$StudentID_Anonymous <- df %>%  group_indices(StudentName)
    df <- df %>% select(-StudentID)
  }, error = function(e) {
    df <- df
  })
  
  tryCatch({
    df$StudentID_Anon <- df %>%  group_indices(UserID)
    df <- df %>% select(-UserID)
  }, error = function(e) {
    df <- df
  })
  
  tryCatch({
    df <- df %>% select(-OriginalPostAuthor)
  }, error = function(e) {
    df <- df
  })
  
  return(df)
}