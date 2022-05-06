server <- function(input, output, session) {
  
  v_input_scientificName <- selectServer("select_species")
  
  selectServer("select_species")
  
  mapServer("map", varFilter = v_input_scientificName)
  
  tableServer("occurance_table", varFilter = v_input_scientificName)
  
  timeLineServer("timeLine", varFilter = v_input_scientificName)
}
