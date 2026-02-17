library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(s
  
  titlePanel("Penguin Data Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("in_species",
                  label = "Species",
                  choices = unique(penguins$species))
    ),
    
    
    mainPanel(
      p("You selected:"),
      textOutput("out_species"),
      hr(),
      
      plotOutput("out_peng_flip_body", height = "300px"),
      
      h3("Summary Stats"),
      tableOutput("out_peng_sumstats")
    )
    
  )
  
)

server <- function(input, output, session) {
  
  output$out_species <- renderText({
    input$in_species
  })
  
  output$out_peng_flip_body <- renderPlot({
    
    penguins_filt <- penguins |> 
      filter(species == input$in_species) 
    
    ggplot(penguins_filt, aes(x = body_mass, y = flipper_len, color = sex)) +
      geom_point() +
      labs(title = "Flipper Length vs Body Mass by Sex",
           subtitle = input$in_species)
    
  })
  
  output$out_peng_sumstats <- renderTable({
    penguins_filt <- penguins |> 
      filter(species == input$in_species) |> 
      group_by(sex) |> 
      summarise(Count = n(),
                `Avg Flipper Length` = mean(flipper_len),
                `Avg Body Mass` = mean(body_mass))
  })
  
  
}

shinyApp(ui, server)

