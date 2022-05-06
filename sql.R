library(inborutils)
library(sqldf)
library(data.table)
library(readr)
library(dplyr)

start = 100001
skipCount = 0
  
bothdfs <- data.frame()
  
colnames <- colnames(temp_df)

# Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 10001)
for (k in c(1:59)) {
  #' occurence.csv is to big to load, I tried do this with `sqldf` package but it can't handle NA values
  #' in the file. This loop load occurence.csv in chunks, filter and save it to the dataframe
  print(k)

  temp_df <- read_csv("C:\\Users\\Przemo\\Documents\\R\\home-assignment\\data\\biodiversity-data\\occurence.csv", 
                      n_max = start, 
                      skip = skipCount,
                      col_names = colnames)
  
  temp_df <- temp_df %>%
    #select(id, occurrenceID, scientificName, vernacularName, longitudeDecimal, latitudeDecimal, eventDate, countryCode, country) %>%
    filter(countryCode == "PL")
  
  bothdfs <- rbind(bothdfs, temp_df)
  
  skipCount = skipCount + start
  print(k)
}
  
# ERROR after 27th loop
  # Error: The size of the connection buffer (1310851072) was not large enough
  # to fit a complete line:
  #   * Increase it by setting `Sys.setenv("VROOM_CONNECTION_SIZE")`



sqlite_file <- "example2.sqlite"
table_name <- "birdtracks"
path <- "C:\\Users\\Przemo\\Documents\\R\\home-assignment\\data\\biodiversity-data\\occurance.csv"
csv.name <- "C:\\Users\\Przemo\\Documents\\R\\home-assignment\\data\\biodiversity-data\\occurance.csv"

inborutils::csv_to_sqlite(csv_file = occurance.csv, 
                          sqlite_file, table_name, pre_process_size = 1000, 
                          chunk_size = 50000, show_progress_bar = FALSE)
# Doesn't work
occurenceSQL <- read.csv.sql("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\myApp\\biodiversity-data\\occurence.csv",
                          sql = "select id from file limit 1000",
                          eol = "\r\n")



  
### NOT IMPORTANT ###
occurancePL <- bothdfs
occuranceLite <- read_csv("C:\\Users\\Przemo\\Documents\\R\\home-assignment\\data\\biodiversity-data\\occurence.csv", 
                    n_max = 10000, 
                    skip = 0)
colnames <- colnames(occuranceLite)


write_csv(occuranceLite, "C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\occuranceLite.csv")
write_csv(occurancePL, "C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\occurancePL.csv")

occurence <- read_csv("occurenceLite.csv")
