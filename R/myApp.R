library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyverse)
library(ggplot2)
library(plotly)
library(lubridate)

myApp <- function(...) {
# source("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\R\\myAppModules.R")
# source("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\R\\timeline_functions.R")

#load("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\data\\occurancePL.rda")
#occurencePL <- read_csv("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\occurancePL.csv") # While looping read_csv changed all data to characters


#occurence <- read_csv("C:\\Users\\Przemo\\Documents\\R\\homeAssignment\\occuranceLite.csv")


header <- dashboardHeader(
  title = "Home Assigment"
)

body <- dashboardBody(
  fluidRow(
    column(width = 9,
           mapUI("map")
    ),
    column(width = 3,
           selectUI("select_species"),
           tableUI("occurance_table"))
  ),
  fluidRow(
    column(12,
           timeLineUI("timeLine"))
  )
)

ui <- dashboardPage(
  header,
  dashboardSidebar(disable = FALSE, collapsed = TRUE),
  body
)

server <- function(input, output, session) {
  
  v_input_scientificName <- selectServer("select_species")
  
  selectServer("select_species")
  
  mapServer("map", varFilter = v_input_scientificName)
  
  tableServer("occurance_table", varFilter = v_input_scientificName)
  
  timeLineServer("timeLine", varFilter = v_input_scientificName)
}

shinyApp(ui, server)

}