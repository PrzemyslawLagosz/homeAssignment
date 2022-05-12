#occurence <- read_csv("occurenceLite.csv")
#occurence <- read_csv("occurencePL.csv")
occurence <- read_csv("occurencePLDB.csv")

occurence$eventDate <- as.Date(occurence$eventDate)

choicesDF <- occurence %>%
  select(scientificName, vernacularName) %>%
  arrange(scientificName)

NA_values_indexs <- which(is.na(choicesDF$vernacularName))

choicesDF[NA_values_indexs,]$vernacularName <- paste0(choicesDF[NA_values_indexs,]$scientificName, "_equivalent")

#####


# write_csv(occurencePL, "occurencePL.csv")

# which(choicesDF$scientificName == "Aglais io")
# which(occurence$scientificName == "Aglais io")

