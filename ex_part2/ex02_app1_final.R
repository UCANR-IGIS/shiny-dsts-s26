library(shiny)
library(leaflet)

ui <- fluidPage(
  
  # tags$head(
  #   tags$link(rel = "stylesheet", type = "text/css", href = "heat-msg-app.css")
  # ),
  
  titlePanel(title = "Heat Safety Messages"),
             
  h3("1. Select location"),
  
  p("Select a location to generate heat warnings for."),
  
  div(leafletOutput("mymap", height = 400)),
  
)

server <- function(input, output, session) {
  
  # ## --- output$mymap (initialize) ----
  # ## Add layers and set the initial map extent (called once but never called again after that)
  # output$mymap <- renderLeaflet({
  #   leaflet(options = leafletOptions(minZoom = 6, maxZoom = 18)) |>
  #     addTiles(group = "Open Street Map") |>
  #     setMaxBounds(lng1 = -124.41, lat1 = 32.5, lng2 = -114.13, lat2 = 42.0) |>
  #     fitBounds(lng1 = -124.41, lat1 = 32.5, lng2 = -114.13, lat2 = 42.0)
  # })
  # 
  # ## ----- pt_coords() (reactiveVal) --------
  # pt_coords <- reactiveVal()
  # 
  # ## The following will run whenever input$mymap_click changes
  # observeEvent(input$mymap_click, {
  #   pt_coords(c(input$mymap_click$lng, input$mymap_click$lat))
  # })
  # 
  # ## loc_xy() observe --------------------------------------------------------------
  # ## The following will run whenever loc_xy() changes. It will update the leaflet map.
  # observeEvent(pt_coords(), {
  #   ## Clear existing markers and add a marker at the new location
  #   leafletProxy('mymap') |>
  #     clearMarkers() |>
  #     addMarkers(lng = pt_coords()[1],
  #                lat = pt_coords()[2])
  # })

}

shinyApp(ui, server)