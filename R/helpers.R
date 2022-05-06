occurence <- read_csv("occurenceLite.csv")
# occurence <- read_csv("occurencePL.csv")


choicesDF <- occurence %>%
  select(scientificName, vernacularName) %>%
  arrange(scientificName)

NA_values_indexs <- which(is.na(choicesDF$vernacularName))

choicesDF[NA_values_indexs,]$vernacularName <- paste0(choicesDF[NA_values_indexs,]$scientificName, "_equivalent")



