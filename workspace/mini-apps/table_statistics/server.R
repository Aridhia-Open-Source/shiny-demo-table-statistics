

server <- function(input, output, session) {

  choose_data <- callModule(xap.chooseDataTable, "choose_data")
  d <- choose_data$data
  d_name <- choose_data$table_name
  
  output$dt <- withProgress(message = "Rendering table", {renderDataTable(d())})
  
  sessionVars <- reactiveValues(prev_data = "None", i = 0)
  
  # create a summary of the selected data
  summ <- reactive(withProgress(message = "Calculating summary", value = 0,{
    my_summ(d())
  }))
  
  # column names of the table
  n <- reactive({
    names(d())
  })
  
  # random ids to assign to created plots
  plot_ids <- reactive({
    paste0("plot", sample(1:100000), length(summ()))
  })
  
  ## plot creation
  observe({
    l <- length(n())
    m <- "Creating plots"
    if(l > 40) {
      m <- paste(m, "-", l, "columns, this may take a while...")
    }
    withProgress(message = m, value = 0,{
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
  # each time reactives are flushed, check whether the selected table has changed and run apply js scripts if so
  session$onFlushed(function() {
    isolate(
      if(sessionVars$prev_data != d_name()) {
        session$sendCustomMessage(type = 'tablesorter', message = list(id = "myTable"))
        session$sendCustomMessage(type = 'row_click', message = list(id = "myTable"))
        sessionVars$prev_data <- d_name()
      }
    )
  }, FALSE)
  
  
  # create a ui chunk containing the table
  output$t <- renderUI({
    withProgress(message = "Calculating table statistics", value = 0, {
      # create the table
      create_table(summ(), n(), plot_ids())
    })
  })
  
  output$plot_modals <- withProgress(message = "Calculating plot", value = 0, {renderUI({
    nam <- n()
    if(is.null(nam)) {
      return(NULL)
    }
    ids <- paste0(plot_ids(), "modal")
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




