
xap.require("shiny",
            "ggvis",
            "shinyBS")
 

source("global.R")

tables <- xap.list_tables()

ui <- fluidPage(
  includeScript("tablesorter.js"),
  includeCSS("ts_styles.css"),
  
  fluidRow(
    column(6,
      selectInput("data", "Select Dataset", choices = c("Choose a table" = "", tables))
    ),
    column(6,
      actionButton("link", "View Data")
    )
  ),
  
  bsModal("modal", "Plot", "link", size = "large", dataTableOutput("dt")),
  
  uiOutput("ui"),
  uiOutput("modals"),
  uiOutput("plot_modals")
)
