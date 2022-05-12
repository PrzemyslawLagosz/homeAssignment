### Select Module ###
selectUI <- function(id) {
  #' Select module UI
  #' 
  #' Generate 2 selectInputs with scientificName and vernacularName column
  
  ns <- NS(id)
  tagList(
    box(width = NULL,
        selectInput(ns("v_scientificName"), "Scientific Name", selected = NULL, choices = unique(choicesDF$scientificName), selectize=FALSE)
    ),
    box(width = NULL,
        selectInput(ns("v_vernacularName"), "Vernacular Name ", selected = NULL, choices = unique(choicesDF$vernacularName), selectize=FALSE)
    )
  )
}

selectServer <- function(id) {
  #' Select module Server
  #'
  #' It check with index is actually selected, and update each others to display position with same position
  #' 
  #' @return Returns currently selected vernacularName as a reactive value
   
  moduleServer(id, function(input, output, session) {
    
    # To implement Server-side selectize
    # updateSelectInput(inputId = "v_scientificName", choices = unique(choicesDF$scientificName))
    # updateSelectInput(inputId = "v_vernacularName", choices = unique(choicesDF$vernacularName))
    
    selectedIndex_scientificName <- reactive(which(choicesDF$scientificName == input$v_scientificName)[1])
    selectedIndex_vernacularName <- reactive(which(choicesDF$vernacularName == input$v_vernacularName)[1])
    
    observeEvent(input$v_scientificName, {
      updateSelectInput(inputId = "v_vernacularName", selected = choicesDF$vernacularName[selectedIndex_scientificName()])
    })
    
    observeEvent(input$v_vernacularName, {
      updateSelectInput(inputId = "v_scientificName", selected = choicesDF$scientificName[selectedIndex_vernacularName()])
    })
    
    return(reactive(input$v_scientificName))
  })
}
### Select Module ### ^

### Occurance Table Module ###
tableUI <- function(id) {
  #' Table module UI
  ns <- NS(id)
  tagList(
    box(width = NULL,
        tableOutput(ns("table"))
    )
  )
}

tableServer <- function(id, varFilter) {
  #' Table module Server
  #' 
  #' It filter occurence DF, with curentlly selected vernacularName, group by contry, count number 
  #' of occurencies selected vernacularName, and render table with top 5.
  #' 
  #' @param varFilter vernacularName returned by `selectServer()`
  
  stopifnot(is.reactive(varFilter))
  req(varFilter)
  moduleServer(id, function(input, output, session) {
    
    # DODAc OPIS
    output$table <- renderTable(width = "100%", {
      data <- occurence %>%
        filter(scientificName == varFilter()) %>%
        group_by(country) %>%
        summarise(Number = n()) %>%
        arrange(desc(Number)) %>%
        rename(Country = country)
      
      head(data)
    })
  })
}
### Occurance Table Module ### ^

### MAP MODULE ###
mapUI <- function(id) {
  #' Map module UI
  #' 
  #' Box with a map
  ns <- NS(id)
  
  tagList(
    box(width = NULL, solidHeader = TRUE,
        leafletOutput(ns("map"), height = 500)
    )
  )
}

mapServer <- function(id, varFilter) {
  #' Map module Server
  #' 
  #' Filter occurrence DF with `varFilter`, and generate map with clustering markers 
  #' described by `longitudeDecimal` and `latitudeDecimal` column
  #' 
  #' @param varFilter vernacularName returned by `selectServer()`
 
  stopifnot(is.reactive(varFilter))
  moduleServer(id, function(input, output, session) {
    output$map <- renderLeaflet({
      
      data <- occurence %>%
        filter(scientificName == varFilter())
      
      map <- leaflet(data) %>%
        addTiles() %>%
        addMarkers(lng= ~longitudeDecimal, 
                   lat= ~latitudeDecimal, 
                   popup = paste("ID:",data$id
                                 , "<br>"
                                 , "Details:"
                                 , "<a href='"
                                 , data$occurrenceID
                                 , "' target='_blank'>"
                                 , "Click Here</a>"
                                 , "<br>"
                                 , "Event Date:"
                                 , data$eventDate), 
                   clusterOptions = markerClusterOptions())
    })
  })
}
### MAP MODULE ### ^

### Time Line MODULE ###
timeLineUI <- function(id) {
  #' Map module UI
  #' 
  #' Box with a timeLine plotlyOutput

  ns <- NS(id)
  
  tagList(
    box(width = NULL, solidHeader = TRUE,
        plotlyOutput(ns("timeTable"))
    )
  )
}

timeLineServer <- function(id, varFilter) {
  #' Map module Server
  #' 
  #' It filter occurence DF with `varFilter` and save as df.
  #' Based on df it generate:
  #' df_positions (with geom_points, and geom_segment coordinates for a timeline), 
  #' df_month (with geom_text, contains only with months included in df + bufor months, one at the begging and at the end), 
  #' df_year (with geom_text, contains only with years included in df + bufor months, one at the begging and at the end),
  #' with `df_positions()`, `df_month()`, `df_year()`
  #'
  #' @param varFilter vernacularName returned by `selectServer()`
  
  stopifnot(is.reactive(varFilter))
  moduleServer(id, function(input, output, session) {
    
    output$timeTable <- renderPlotly({
      
      df <- reactive(occurence %>%
                       filter(scientificName == varFilter()) %>%
                       group_by(eventDate, scientificName) %>%
                       summarise(count = n()))
      
      df_positions <- df_positions(df())
      df_month <- df_month(df())
      df_year <- df_year(df())
      
      timeline_plot<- ggplot(df_positions, aes(x=eventDate, y= position, col= eventDate, label = count)) +
        theme_classic() +
        geom_hline(yintercept=0, color = "black", size=0.3) +
        theme(axis.line.y=element_blank(),
              axis.text.y=element_blank(),
              axis.title.x=element_blank(),
              axis.title.y=element_blank(),
              axis.ticks.y=element_blank(),
              axis.text.x =element_blank(),
              axis.ticks.x =element_blank(),
              axis.line.x =element_blank(),
              legend.position = "none")+
        geom_segment(aes(y=position, yend=0, xend=eventDate), color='black', size=0.2)+
        geom_point(aes(y=position), size = 3)+
        geom_text(data=df_month, aes(x=month_date_range,y=-0.15,label=month_format),size=3.5,vjust=0.5, color='black', angle=90)+
        geom_text(data=df_year, aes(x=year_date_range,y=-0.25,label=year_format, fontface="bold"),size=3.5, color='black')+
        geom_text(aes(y=text_position, label=count),size=3.5, vjust=0.6)
      
      ggplotly(timeline_plot)
    })
  })
}
### Time Line MODULE ### ^