library(shiny)
library(ggplot2)
library(bslib)
library(bsicons) # Ensure this is installed
library(DT)

# 1. Expanded lookup data
crop_lookup <- data.frame(
  crop = c("Almonds", "Processing Tomatoes", "Lettuce"),
  units = c("lbs meat", "tons", "tons"),
  coeff = c(0.068, 2.5, 3.0), 
  min_yield = c(500, 30, 10),
  max_yield = c(4000, 70, 40),
  def_yield = c(2200, 50, 25),
  stringsAsFactors = FALSE
)

ui <- page_navbar(
  title = "Nitrogen Optimizer Pro",
  theme = bs_theme(bootswatch = "flatly"),
  
  nav_panel("Calculator",
            layout_sidebar(
              sidebar = sidebar(
                title = "Parameters",
                selectInput("crop", "Select Crop:", choices = crop_lookup$crop),
                numericInput("yield", "Target Yield (per acre):", value = 2200),
                sliderInput("n_applied", "Nitrogen to Apply (lbs/acre):", 
                            min = 0, max = 500, value = 150),
                hr(),
                numericInput("n_cost", "Cost of Nitrogen ($/lb):", 
                             value = 0.85, min = 0.10, max = 5.00, step = 0.05),
                helpText("Adjust the cost per pound to see the impact on financial waste.")
              ),
              
              layout_columns(
                fill = FALSE,
                value_box(
                  title = "N Balance (Applied - Required)",
                  value = textOutput("n_balance"),
                  # FIX: Changed "balance-scale" to "scale"
                  #showcase = bs_icon("scale"),
                  showcase = fontawesome::fa("balance-scale"), 
                  theme = "primary"
                ),
                value_box(
                  title = "Estimated Financial Waste",
                  value = textOutput("money_waste"),
                  # FIX: Changed to "cash-stack" for better visual relevance
                  showcase = bs_icon("cash-stack"), 
                  theme = "danger"
                )
              ),
              
              card(
                card_header("Nutrient Balance Visualization"),
                plotOutput("n_plot")
              )
            )
  ),
  
  nav_panel("Reference Data",
            card(
              card_header("Typical Yield & Nutrient Values"),
              DTOutput("ref_table")
            )
  )
)

server <- function(input, output, session) {
  
  # Dynamic Input Update
  observeEvent(input$crop, {
    row <- crop_lookup[crop_lookup$crop == input$crop, ]
    updateNumericInput(session, "yield",
                       label = paste0("Target Yield (", row$units, "):"),
                       value = row$def_yield,
                       min = row$min_yield,
                       max = row$max_yield
    )
  })
  
  # Calculations
  calc_data <- reactive({
    selected <- crop_lookup[crop_lookup$crop == input$crop, ]
    n_required <- input$yield * selected$coeff
    n_balance <- input$n_applied - n_required
    money_lost <- ifelse(n_balance > 0, n_balance * input$n_cost, 0)
    
    list(required = n_required, balance = n_balance, waste = money_lost)
  })
  
  output$n_balance <- renderText({ 
    paste(round(calc_data()$balance, 1), "lbs/acre") 
  })
  
  output$money_waste <- renderText({ 
    paste0("$", format(round(calc_data()$waste, 2), nsmall = 2)) 
  })
  
  output$n_plot <- renderPlot({
    res <- calc_data()
    df <- data.frame(Category = c("Applied", "Required"), Value = c(input$n_applied, res$required))
    ggplot(df, aes(x = Category, y = Value, fill = Category)) +
      geom_col(width = 0.5) +
      scale_fill_manual(values = c("Applied" = "#e74c3c", "Required" = "#2ecc71")) +
      labs(y = "Lbs of Nitrogen", x = "") +
      theme_minimal() +
      theme(legend.position = "none", text = element_text(size = 14))
  })
  
  output$ref_table <- renderDT({
    datatable(crop_lookup[, 1:5], options = list(dom = 't'), rownames = FALSE)
  })
}

shinyApp(ui, server)
