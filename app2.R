library(shiny)
library(ggvis)

script <- '$(document).ready(function() { 
  $("#myTable").tablesorter({headers: {3: {sorter: false}}}); 
});'



server <- function(input, output, session) {
  d <- reactive({
    if(input$data == "iris") {
      iris
    } else {
      mtcars
    }
  })
  
  sessionVars <- reactiveValues(prev_data = "None")
  
  summ <- reactive({
    my_summ(d())
  })
  n <- reactive({
    print(names(d()))
    names(d())
  })
  plot_ids <- reactive({
    paste0("plot", sample(1:100000), length(summ()))
  })
  
  ## plot creation
  observe({
  lapply(1:ncol(d()), function(i) {
    d() %>% ggvis(~d()[,i]) %>% layer_bars() %>%
      add_axis("x", title = "") %>%
      add_axis("y", title = "") %>%
      set_options(width = 200, height = 100) %>%
      bind_shiny(plot_ids()[i])
    })
  })
  
  ## we need to call tablesorter on the table each time it is created
  ## needs an extra run-through on initialization
  flushed <- 0
  session$onFlushed(function() {
    flushed <<- flushed + 1
    print("Flushing Reactives")
    isolate(
      if(sessionVars$prev_data != input$data) {
        print("Table has changed. Applying tablesorter")
        session$sendCustomMessage(type='jsCode', list(value = script))
        sessionVars$prev_data <- input$data
      }
    )
    if(flushed < 3) {
      print("Still Initializing")
      session$sendCustomMessage(type='jsCode', list(value = script))
    }
  }, FALSE)
  
  # create a ui chunk containing the table
  output$t <- renderUI({
      create_table(summ(), n(), plot_ids())
  })
  
  # a ui chunk that outputs the created table and create a message handler that applys tablesorter
  output$ui <- renderUI({
    list(
      tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode", function(message) { eval(message.value); });'))),
      uiOutput("t")
    )
  })
  
  
}

ui <- fluidPage(
  includeScript("../../Documents/__jquery.tablesorter/jquery.tablesorter.js"),
  includeCSS("ts_styles.css"),
  selectInput("data", "Select Dataset", choices = c("iris", "mtcars"), selected = "mtcars"),
  
  
  uiOutput("ui")
  
  #create_table(summ, n, plot_ids)
)


runApp(list(ui = ui, server = server))
