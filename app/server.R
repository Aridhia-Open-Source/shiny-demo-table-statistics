
script <- '$(document).ready(function() { 
  $("#myTable").tablesorter({headers: {3: {sorter: false}}});
  $("table").tablesorterPager({container: $("#pager")});

});'

row_click_script <- "
$(document).ready(function() {
  var vars = {};

  $('#myTable').find('tbody tr').each(function(row) {
    var id = $(this).attr('id');
    vars['row' + id] = 0;
    Shiny.onInputChange('row' + id, vars['row' + id]);
    $(this).click(function(event) {
      var clickedClass = event.target.className;
      // don't do anything if action button/link is clicked
      if(clickedClass != 'action-button shiny-bound-input') {
        vars['row' + id] = (vars['row' + id] + 1) % 2;
        Shiny.onInputChange('row' + id, vars['row' + id]);
      }
    });
  });

});
"

server <- function(input, output, session) {
  d <- reactive({
    if(input$data == "iris") {
      a <- iris
      a[1,1] <- NA
      return(a)
    } else if(input$data == "mtcars") {
      mtcars
    } else if(input$data == "quakes") {
      quakes
    } else if(input$data == "people") {
      people
    } else {
      NULL
    }
  })
  
  # d <- reactive({
  #   dat <- callModule(csvFile, "data")
  #   if(nrow(dat()) == 0) {
  #     return(NULL)
  #   } else {
  #     dat()
  #   }
  # })
  
  #d <- callModule(csvFile, "data")
    
  output$dt <- renderDataTable(d())
  
  
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
  
  ## we need to call tablesorter on the table each time it is created
  ## needs an extra run-through on initialization
  flushed <- 0
  session$onFlushed(function() {
    isolate({
      print(paste("Input", input$data))
      print(paste("prev", sessionVars$prev_data))
    })
    flushed <<- flushed + 1
    print("Flushing Reactives")
    isolate(
      if(sessionVars$prev_data != input$data) {
        print("Table has changed. Applying tablesorter")
        session$sendCustomMessage(type='jsCode', list(value = script))
        session$sendCustomMessage(type='jsCode2', list(value = row_click_script))
        sessionVars$prev_data <- input$data
      }
    )
    if(flushed < 3) {
      print("Still Initializing")
      session$sendCustomMessage(type='jsCode', list(value = script))
      session$sendCustomMessage(type='jsCode2', list(value = row_click_script))
    }
  }, FALSE)
  
  # create a ui chunk containing the table
  output$t <- renderUI({
    print("Rendering Table...")
    out <- create_table(summ(), n(), plot_ids())
    print("Done")
    out
  })

  # a ui chunk that outputs the created table and create a message handler that applys tablesorter
  output$ui <- renderUI({
    print("Rendering Table UI...")
    out <- list(
      tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode", function(message) { eval(message.value); });'))),
      tags$head(tags$script(HTML('Shiny.addCustomMessageHandler("jsCode2", function(message) { eval(message.value); });'))),
      uiOutput("t")
    )
    print("Done")
    out
  })
  
  output$plot_modals <- renderUI({
    nam <- n()
    if(is.null(nam)) {
      return(NULL)
    }
    ids <- paste0(plot_ids(), "modal")
    print("Creating Plot Modals")
    lapply(1:length(nam), function(i) {
      create_plot_modal(nam[i], ids[i])
    })
  })

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




