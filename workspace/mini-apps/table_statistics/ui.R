

source("global.R")
source("documentation_ui.R")

tables <- xap.list_tables()

ui <- fluidPage(column(12,
  theme = "theme.css",
  includeScript("tablesorter.js"),
  includeCSS("ts_styles.css"),
  tabsetPanel(documentation_tab(),
              tabPanel("Application",
  tags$div(class = "tab", style = "margin-top: 15px;"),
  
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
         actionButton("link", "Preview Table"))),
  
  bsModal("modal", "Plot", "link", size = "large", dataTableOutput("dt")),
  
  uiOutput("t"),
  uiOutput("modals"),
  uiOutput("plot_modals")
)
)))