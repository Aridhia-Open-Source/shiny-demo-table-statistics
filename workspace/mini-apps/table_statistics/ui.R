xap.require("shiny",
            "ggvis",
            "shinyBS")


source("global.R")

tables <- xap.list_tables()

ui <- fluidPage(theme = "theme.css",
  includeScript("tablesorter.js"),
  includeCSS("ts_styles.css"),
  
  fluidRow(
    column(6,
      selectInput("data", NULL, choices = c("Choose a dataset" = "", tables))
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
