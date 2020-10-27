# Wrangling functions

## Edit week level indicator
fix_week_level <- function(dataset) {
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
        WeekLevel == "Week 16 and After" ~ "16+"
      )
    )
}


## Edit 24 hour time band indicator
fix_time_band_24hr <- function(dataset) {
  # Load required dependencies
  if (!require("pacman"))
    install.packages("pacman")
  pacman::p_load(dplyr)
  
  df <- dataset %>%
    mutate(
      TimeDescription = case_when(
        TimeBandDescription24Hour == "12 am - 12:59 am" ~ "00",
        TimeBandDescription24Hour == "1 am - 1:59 am" ~ "01",
        TimeBandDescription24Hour == "2 am - 2:59 am" ~ "02",
        TimeBandDescription24Hour == "3 am - 3:59 am" ~ "03",
        TimeBandDescription24Hour == "4 am - 4:59 am" ~ "04",
        TimeBandDescription24Hour == "5 am - 5:59 am" ~ "05",
        TimeBandDescription24Hour == "6 am - 6:59 am" ~ "06",
        TimeBandDescription24Hour == "7 am - 7:59 am" ~ "07",
        TimeBandDescription24Hour == "8 am - 8:59 am" ~ "08",
        TimeBandDescription24Hour == "9 am - 9:59 am" ~ "09",
        TimeBandDescription24Hour == "10 am - 10:59 am" ~ "10",
        TimeBandDescription24Hour == "11 am - 11:59 am" ~ "11",
        TimeBandDescription24Hour == "12 pm - 12:59 pm" ~ "12",
        TimeBandDescription24Hour == "1 pm - 1:59 pm" ~ "13",
        TimeBandDescription24Hour == "2 pm - 2:59 pm" ~ "14",
        TimeBandDescription24Hour == "3 pm - 3:59 pm" ~ "15",
        TimeBandDescription24Hour == "4 pm - 4:59 pm" ~ "16",
        TimeBandDescription24Hour == "5 pm - 5:59 pm" ~ "17",
        TimeBandDescription24Hour == "6 pm - 6:59 pm" ~ "18",
        TimeBandDescription24Hour == "7 pm - 7:59 pm" ~ "19",
        TimeBandDescription24Hour == "8 pm - 8:59 pm" ~ "20",
        TimeBandDescription24Hour == "9 pm - 9:59 pm" ~ "21",
        TimeBandDescription24Hour == "10 pm - 10:59 pm" ~ "22",
        TimeBandDescription24Hour == "11 pm - 11:59 pm" ~ "23"
      )
    )
}


## Edit day of week indicator
fix_time_band_24hr <- function(dataset) {
  # Load required dependencies
  if (!require("pacman"))
    install.packages("pacman")
  pacman::p_load(dplyr)
  
  df <- dataset %>%
    mutate(
      DayNameOfWeek = case_when(
        DayOfWeek == 1 ~ "1-Sunday",
        DayOfWeek == 2 ~ "2-Monday",
        DayOfWeek == 3 ~ "3-Tuesday",
        DayOfWeek == 4 ~ "4-Wednesday",
        DayOfWeek == 5 ~ "5-Thursday",
        DayOfWeek == 6 ~ "6-Friday",
        DayOfWeek == 7 ~ "7-Saturday"
      )
    )
}

## Anonymize
anonymize_students <- function(dataset) {
  df <- dataset
  
  tryCatch({
    df$StudentID_Anon <- df %>%  group_indices(StudentID)
    df <- df %>% select(-StudentID)
  }, error = function(e){
    df <- df
  })
  
  tryCatch({
    df$StudentID_Anon <- df %>%  group_indices(UserID)
    df <- df %>% select(-UserID)
  }, error = function(e){
    df <- df
  })
  
  tryCatch({
    df <- df %>% select(-OriginalPostAuthor)
  }, error = function(e){
    df <- df
  })
  
  return(df)
}














