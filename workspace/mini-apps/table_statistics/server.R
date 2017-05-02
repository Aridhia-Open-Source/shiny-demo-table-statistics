

server <- function(input, output, session) {

  choose_data <- callModule(xap.chooseDataTable, "choose_data")
  d <- choose_data$data
  d_name <- choose_data$table_name
  
  output$dt <- withProgress(message = "Rendering table", {renderDataTable(d())})
  
  sessionVars <- reactiveValues(prev_data = "None", i = 0)
  
  summ <- reactive(withProgress(message = "Calculating summary", value = 0,{
    my_summ(d())
  }))
  
  n <- reactive({
    print(names(d()))
    names(d())
  })
  plot_ids <- reactive({
    paste0("plot", sample(1:100000), length(summ()))
  })
  
  ## plot creation
  observe({
    withProgress(message = "Creating plots", value = 0,{
      dat <- d()
      p_ids <- plot_ids()
      if(is.null(dat)) {
        return()
      }
      lapply(1:ncol(dat), function(i) {
        p <- simple_plot(dat, dat[,i])
        
        p %>% set_options(width = 250, height = 150, resizable = FALSE) %>%
          bind_shiny(p_ids[i])
        
        p %>% set_options(width = "auto", resizable = TRUE) %>% 
          bind_shiny(paste0(p_ids[i], "modal"))
      })
    })
  })
  
  # we need to call tablesorter on the table each time it is created
  # needs an extra run-through on initialization
  flushed <- 0
  session$onFlushed(function() {
    isolate({
      print(paste("Input", d_name()))
      print(paste("prev", sessionVars$prev_data))
    })
    flushed <<- flushed + 1
    print("Flushing Reactives")
    isolate(
      if(sessionVars$prev_data != d_name()) {
        print("Table has changed. Applying tablesorter")
        session$sendCustomMessage(type = 'tablesorter', message = list(id = "myTable"))
        session$sendCustomMessage(type = 'row_click', message = list(id = "myTable"))
        sessionVars$prev_data <- d_name()
      }
    )
    if(flushed < 3) {
      print("Still Initializing")
      session$sendCustomMessage(type = 'tablesorter', message = list(id = "myTable"))
      session$sendCustomMessage(type = 'row_click', message = list(id = "myTable"))
    }
  }, FALSE)
  
  
  # create a ui chunk containing the table
  output$t <- renderUI({
    withProgress(message = "Calculating table statistics", value = 0, {
      print("Rendering Table...")
      out <- create_table(summ(), n(), plot_ids())
      print("Done")
      out
    })
  })
  
  output$plot_modals <- withProgress(message = "Calculating plot", value = 0, {renderUI({
    nam <- n()
    if(is.null(nam)) {
      return(NULL)
    }
    ids <- paste0(plot_ids(), "modal")
    print("Creating Plot Modals")
    lapply(1:length(nam), function(i) {
      create_plot_modal(nam[i], ids[i])
    })
  })})
  
  output$modals <- renderUI({
    s <- summ()
    nam <- n()
    if(is.null(nam)) {
      return(NULL)
    }
    lapply(1:length(s), function(i) {
      output[[paste0("dt", nam[i])]] <- renderDataTable(s[[i]]$dt)
      create_modal(s[[i]], nam[i])
    })
  })
  
}




