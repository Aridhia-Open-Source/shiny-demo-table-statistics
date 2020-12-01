

tables <- xap.list_tables()

ui <- fluidPage(width = 12,
                theme = "theme.css",
                includeScript("www/tablesorter.js"),
                includeCSS("www/ts_styles.css"),
                tabsetPanel( 
                  tabPanel("Application",
                           fluidPage(
                             
                             singleton(
                               tags$head(tags$script(src = "tablesorter.js"))
                             ),
                             singleton(
                               tags$head(tags$script(src = "row_click.js"))
                             ),
                             
                             tags$div(class = "well",
                                      fluidRow(column(
                                        6,
                                        h3("Select your dataset"),
                                        xap.chooseDataTableUI("choose_data", label = NULL),
                                        actionButton("link", "Preview table")
                                      ))),
                             
                             bsModal("modal", "Plot", "link", size = "large", dataTableOutput("dt")),
                             
                             uiOutput("t"),
                             uiOutput("modals"),
                             uiOutput("plot_modals")
                           )),
                  documentation_tab()
                ))