library(inborutils)
library(sqldf)
library(data.table)
library(readr)
library(dplyr)
library(tidyverse)
#library(sqldf)
library(RSQLite)

### SOLUTION ###
db <- dbConnect(SQLite(), dbname="occureneceDB.db") # Located in another folder 

dbListTables(db)
dbListFields(db, "occurence")

x <- dbGetQuery(db, "select * from occurence where countryCode = 'PL'")

write_csv(x, "occurencePLDB.csv")
write_csv(occurencePL, "occurencePLDB.csv")




start = 100001
skipCount = 0
  
bothdfs <- data.frame()
  
colnames <- colnames(occurence)

# Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 10001)
for (k in c(1:59)) {
  #' occurence.csv is to big to load, I tried do this with `sqldf` package but it can't handle NA values
  #' in the file. This loop load occurence.csv in chunks, filter and save it to the dataframe
  print(k)

  temp_df <- read_csv("C:\\Users\\Przemo\\Documents\\R\\home-assignment\\data\\biodiversity-data\\occurence.csv", 
                      n_max = start, 
                      skip = skipCount,
                      col_names = colnames,
                      col_types = "ccccccccccccccccccccccccccccccccccccc") #without this read_csv corupted dataEvent to numeric and character format
  
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


data <- data.frame(x1 = 1:5,    # Create example data
                   x2 = 5:1,
                   x3 = 5)
data  

write_csv(data, "C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\R\\test.csv")

data1 <- read_csv("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\R\\test.csv", col_types = "ccccccccccccccccccccccccccccccccccccc")


paste(replicate(37, "c"), collapse = "")







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
occurencePL <- bothdfs
occurenceLite <- read_csv("C:\\Users\\Przemo\\Documents\\R\\home-assignment\\data\\biodiversity-data\\occurence.csv", 
                    n_max = 10000, 
                    skip = 0)
colnames <- colnames(occuranceLite)


write_csv(occurenceLite, "C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\occurenceLite.csv")
write_csv(occurencePL, "C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\R\\occurencePL.csv")

occurence <- read_csv("occurenceLite.csv")


x <- dbGetQuery(db, "select * from miasto where name LIKE 'A%'")


