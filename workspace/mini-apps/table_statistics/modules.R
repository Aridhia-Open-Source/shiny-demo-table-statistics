
xap.chooseDataTable <- function(input, output, session) {
  d <- reactive(withProgress(message = "Reading table", value = 0, {
    table_name <- input$table_name
    if(table_name == "") {
      return(NULL)
    }
    xap.read_table(table_name)
  }))
  
  ## Update the table list when refresh is clicked
  observe({
    i <- input$refresh
    tables <- xap.list_tables()
    ## isolate the update since we use input$table_name
    isolate({
      updateSelectizeInput(session, "table_name", choices = c("Choose One" = "", tables),
                           selected = input$table_name)
    })
  })
  return(list(data = d, table_name = reactive(input$table_name)))
}

xap.chooseDataTableUI <- function(id, label = "Choose a Table") {
  ns <- NS(id)
  
  tables <- xap.list_tables()
  
  tagList(
    selectizeInput(ns("table_name"), label = label, choices = c("Choose One" = "", tables)),
    actionButton(ns("refresh"), "Refresh")
  )
}
