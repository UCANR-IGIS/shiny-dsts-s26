## CHALLENGE!!
##
## This Shiny app displays includes a placeholder for the number of observations for the selected species.
## Replace the placeholder with the actual number of records for the selected species.
## (don't worry about throwing out missing values)

library(shiny)
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
      textOutput("out_samp_size"),
      
      h3("Summary Stats"),
      tableOutput("out_peng_sumstats")
    )
    
  )
  
)

server <- function(input, output, session) {
  
  output$out_peng_sumstats <- renderTable({
    penguins_filt <- penguins |> 
      filter(species == input$in_species) |> 
      group_by(sex) |> 
      summarise(Count = n(),
                `Avg Flipper Length` = mean(flipper_len),
                `Avg Body Mass` = mean(body_mass))
  })
  
  output$out_samp_size <- renderText({
    
    ## We need an expression that will return the number of non-missing values
    penguins |>
      filter(species == input$in_species) |>
      nrow()
    
  })
  
}

shinyApp(ui, server)

