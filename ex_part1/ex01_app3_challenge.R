## CHALLENGE!!
##
## This Shiny app displays includes a placeholder for the number of observations for the selected species.
## Replace the placeholder with the actual number of non-missing values for the selected species.
## (don't worry about throwing out missing values)

library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  
  titlePanel("Penguin Data Explorer"),
  
  sidebarLayout(
    
    sidebarPanel(
      selectInput("in_species",
                  label = "Species",
                  choices = unique(penguins$species))
    ),
    
    
    mainPanel(
      
      h3("Sample Size"),
      p("Number of observations for the selected species:"),
      p("xx"),
      hr(),       ## add a horizontal rule
      
      h3("Flipper Length vs. Body Mass"),
      plotOutput("out_peng_flip_body", height = "300px"),
      hr(),
      
      h3("Summary Stats"),
      tableOutput("out_peng_sumstats")
    )
    
  )
  
)

server <- function(input, output, session) {
  
  output$out_peng_flip_body <- renderPlot({
    
    penguins_filt <- penguins |> 
      filter(species == input$in_species) 
    
    ggplot(penguins_filt, aes(x = body_mass, y = flipper_len, color = sex)) +
      geom_point() +
      xlab("body mass") +
      ylab("flipper length")
    
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

