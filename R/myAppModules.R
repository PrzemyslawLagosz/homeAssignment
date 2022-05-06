### Select Module ###
selectUI <- function(id) {
  ns <- NS(id)
  tagList(
    box(width = NULL,
        selectInput(ns("v_scientificName"), "Scientific Name", selected = NULL, choices = unique(occurence$scientificName), selectize=FALSE)
    ),
    box(width = NULL,
        selectInput(ns("v_vernacularName"), "Vernacular Name ", selected = NULL, choices = unique(occurence$vernacularName), selectize=FALSE)
    )
  )
}

selectServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Order this alphabeticly
    selectedIndex_scientificName <- reactive(which(occurence$scientificName == input$v_scientificName)[1])
    selectedIndex_vernacularName <- reactive(which(occurence$vernacularName == input$v_vernacularName)[1])
    
    observeEvent(input$v_scientificName, {
      updateSelectInput(inputId = "v_vernacularName", selected = occurence$vernacularName[selectedIndex_scientificName()])
    })
    
    observeEvent(input$v_vernacularName, {
      updateSelectInput(inputId = "v_scientificName", selected = occurence$scientificName[selectedIndex_vernacularName()])
    })
    
    return(reactive(input$v_scientificName))
  })
}
### Select Module ### ^

### Occurance Table Module ###
tableUI <- function(id) {
  ns <- NS(id)
  tagList(
    box(width = NULL,
        tableOutput(ns("table"))
    )
  )
}

tableServer <- function(id, varFilter) {
  stopifnot(is.reactive(varFilter))
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
  #' 
  ns <- NS(id)
  
  tagList(
    box(width = NULL, solidHeader = TRUE,
        leafletOutput(ns("map"), height = 500)
    )
  )
}

mapServer <- function(id, varFilter) {
  stopifnot(is.reactive(varFilter))
  moduleServer(id, function(input, output, session) {
    output$map <- renderLeaflet({
      
      data <- occurence %>%
        filter(scientificName == varFilter())
      
      map <- leaflet(data) %>%
        addTiles() %>%
        addMarkers(lng= ~longitudeDecimal, 
                   lat= ~latitudeDecimal, 
                   popup = ~as.character(id), 
                   clusterOptions = markerClusterOptions())
    })
  })
}
### MAP MODULE ### ^

### Time Line MODULE ###
timeLineUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    box(width = NULL, solidHeader = TRUE,
        plotlyOutput(ns("timeTable"))
    )
  )
}
timeLineServer <- function(id, varFilter) {
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