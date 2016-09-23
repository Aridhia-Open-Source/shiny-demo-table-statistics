xap.require("shiny",
            "ggvis",
            "shinyBS")


source("global.R")
#source("modules.R")

ui <- fluidPage(theme = "theme.css",
  includeScript("tablesorter.js"),
  includeCSS("ts_styles.css"),
  
  fluidRow(
    column(6,
      xap.chooseDataTableUI("choose_data")
    ),
    column(6,
      actionButton("link", "View Data")
    )
  ),
                
  bsModal("modal", "Data", "link", size = "large", dataTableOutput("dt")),
                
  uiOutput("ui"),
  uiOutput("modals"),
  uiOutput("plot_modals")
)
