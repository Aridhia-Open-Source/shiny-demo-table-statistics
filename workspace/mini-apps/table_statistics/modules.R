
xap.chooseDataTable <- function(input, output, session) {
  tables <- xap.list_tables()
  
  d <- reactive(withProgress(message = "Reading table", value = 0, {
    table_name <- input$table_name
    if(table_name == "") {
      return(NULL)
    }
    xap.read_table(table_name)
  }))
  
  observe({
    i <- input$refresh
    tables <- xap.list_tables()
    isolate({
      updateSelectizeInput(session, "table_name", choices = c("Choose One" = "", tables),
                           selected = input$table_name)
    })
  })
  
  # output$choose_table_ui <- renderUI({
  #   ns <- session$ns
  #   
  #   selectizeInput(ns("table_name"), label = "Choose a Table", choices = c("Choose One" = "", tables))
  # })
  
  return(list(data = d, table_name = reactive(input$table_name)))
}

xap.chooseDataTableUI <- function(id) {
  ns <- NS(id)
  
  tables <- xap.list_tables()
  
  tagList(
    selectizeInput(ns("table_name"), label = "Choose a Table", choices = c("Choose One" = "", tables)),
    actionButton(ns("refresh"), "Refresh")
  )
  #uiOutput(ns("choose_table_ui"))
}
