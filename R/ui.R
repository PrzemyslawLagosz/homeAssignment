library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyverse)
library(ggplot2)
library(plotly)
library(lubridate)
library(roxygen2)
library(docstring)

source("timeline_functions.R")
source("myAppModules.R")
source("helpers.R")

header <- dashboardHeader(
  title = "Home Assignment"
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
  dashboardSidebar(disable = TRUE, collapsed = TRUE),
  body
)