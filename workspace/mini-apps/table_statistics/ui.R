xap.require("shiny",
            "ggvis",
            "shinyBS")


source("global.R")

tables <- xap.list_tables()

ui <- fluidPage(
  theme = "theme.css",
  includeScript("tablesorter.js"),
  includeCSS("ts_styles.css"),
  
  fluidRow(column(
    6,
    xap.chooseDataTableUI("choose_data", label = NULL)
  ),
  column(6,
         actionButton("link", "View Data"))),
  
  bsModal("modal", "Plot", "link", size = "large", dataTableOutput("dt")),
  
  uiOutput("ui"),
  uiOutput("modals"),
  uiOutput("plot_modals")
)
