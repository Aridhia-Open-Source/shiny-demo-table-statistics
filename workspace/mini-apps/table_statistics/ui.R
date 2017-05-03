

source("global.R")

tables <- xap.list_tables()

ui <- fluidPage(
  theme = "theme.css",
  includeScript("tablesorter.js"),
  includeCSS("ts_styles.css"),
  singleton(
    tags$head(tags$script(src = "tablesorter.js"))
  ),
  singleton(
    tags$head(tags$script(src = "row_click.js"))
  ),
  
  fluidRow(column(
    6,
    xap.chooseDataTableUI("choose_data", label = NULL)
  ),
  column(6,
         actionButton("link", "View Data"))),
  
  bsModal("modal", "Plot", "link", size = "large", dataTableOutput("dt")),
  
  uiOutput("t"),
  uiOutput("modals"),
  uiOutput("plot_modals")
)
