
xap.chooseDataTable <- function(input, output, session) {
  tables <- xap.list_tables()
  
  d <- reactive(withProgress(message = "Reading table", value = 0, {
    table_name <- input$table_name
    if(table_name == "") {
      return(NULL)
    }
    xap.read_table(table_name)
  }))
  
  output$choose_table_ui <- renderUI({
    ns <- session$ns
    
    selectizeInput(ns("table_name"), label = "Choose a Table", choices = c("Choose One" = "", tables))
  })
  
  return(d)
}

xap.chooseDataTableUI <- function(id) {
  ns <- NS(id)
  
  uiOutput(ns("choose_table_ui"))
}
