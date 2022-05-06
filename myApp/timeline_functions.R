

df_positions <- function(df) {
  #' Generate coordinates for timline dots, segments, and text
  #'
  #' Function that takes data frame with `eventDate` column, and return data frame with positions 
  #' of geom_points, and positions of geom_text with offset, to generate timeLine leter on.
  #' 
  #' @param df Data frame with `eventDate`

  # Set the heights.
  positions <- c(0.5, -0.5, 1.0, -1.0, 1.25, -1.25, 1.5, -1.5) 
  
  # Set the directions for text (above and below).
  directions <- c(1, -1) 
  
  # Assign the positions & directions to each date from those set above.
  line_pos <- data.frame(
    "eventDate"=unique(df$eventDate),
    "position"=rep(positions, length.out=length(unique(df$eventDate))),
    "direction"=rep(directions, length.out=length(unique(df$eventDate))))
  
  df <- merge(x=df, y=line_pos, by="eventDate", all = TRUE) 
  
  text_offset <- 0.2 
  
  # Absolute value since we want to add the text_offset and increase space away from the scatter points 
  absolute_value<-(abs(df$position)) 
  text_position<- absolute_value + text_offset
  
  # Direction above or below for the labels to match the scatter points
  df$text_position<- text_position * df$direction
  df
}

df_month <- function(df) {
  #' Generate coordinates for timline month texts
  #'
  #' Function that takes data frame with `eventDate` column, and return data frame with positions 
  #' of geom_text, to generate months on timeLine
  #' 
  #' @param df Data frame with `eventDate`

  month_buffer <- 1 
  
  month_date_range <- seq(min(df$eventDate) - months(month_buffer), max(df$eventDate) + months(month_buffer), by='month')
  
  month_format <- format(month_date_range, '%b')
  month_df <- data.frame(month_date_range, month_format)
}

# Function that takes data frame, and return data frame with years
df_year <- function(df) {
  #' Generate coordinates for timline years texts
  #'
  #' Function that takes data frame with `eventDate` column, and return data frame with positions 
  #' of geom_text, to generate years on timeLine
  #' 
  #' @param df Data frame with `eventDate`
  
  month_buffer <- 1 
  
  year_date_range <- seq(min(df$eventDate) - months(month_buffer), max(df$eventDate) + months(month_buffer), by='year')
  
  # We want the format to be in the four digit format for years.
  year_format <- format(year_date_range, '%Y') 
  year_df <- data.frame(year_date_range, year_format) ## <-
}
