library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  
  titlePanel("Penguin Data Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("in_species",
                  label = "Species",
                  choices = unique(penguins$species)),
      
      selectInput("in_island",
                  label = "Island",
                  choices = unique(penguins$island)),
      
      sliderInput("in_pct", "Percent Sample", min = 10, max = 100, value = 100, step = 10)
    ),

    mainPanel(
      plotOutput("out_peng_flip_body", height = "200px"),
      h3("Summary Stats"),
      tableOutput("out_peng_sumstats")
    )
    
  )
  
)

server <- function(input, output, session) {
  
  ## -------- penguins_sub -------
  penguins_sub <- reactive({
    penguins |> 
      filter(species == input$in_species,
             island == input$in_island) |> 
      slice_sample(prop = input$in_pct / 100)
  })
  
  ## ---------- out_peng_flip_body -------------
  output$out_peng_flip_body <- renderPlot({
    ggplot(penguins_sub(), aes(x = body_mass, y = flipper_len, color = sex)) +
      geom_point() +
      labs(title = "Flipper Length vs Body Mass by Sex",
           subtitle = glue("Sepcies: {input$in_species}. Island: {input$in_island}"))
  })
  
  ## ---------- out_peng_sumstats -------------
  output$out_peng_sumstats <- renderTable({
    penguins_sub() |> 
      group_by(sex) |> 
      summarise(Count = n(),
                `Avg Flipper Length` = mean(flipper_len),
                `Avg Body Mass` = mean(body_mass))
  })
  
}

shinyApp(ui, server)

