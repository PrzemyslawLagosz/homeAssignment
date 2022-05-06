library(testthat)

#' Check if returned value is equal to `input$v_scientificName`
#' Check if number of occurrences for corresponding inputs is even
testServer(selectServer, {
  
  # Seting the imput
  session$setInputs(v_scientificName = "Aglais io")
  session$setInputs(v_vernacularName = "Peacock")
  
  # Capturing the return value
  v_scientificNameReturned <- session$getReturned()
  
  a <- (which(choicesDF$scientificName == input$v_scientificName))
  b <- (which(choicesDF$vernacularName == input$v_vernacularName))
  
  # Check if returned value is equal to `input$v_scientificName`
  expect_equal(v_scientificNameReturned(), input$v_scientificName)
  
  # Check if number of occurrences for corresponding inputs is even
  expect_equal(length(a), length(b))
  
})
