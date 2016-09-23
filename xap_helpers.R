
### Replicate functionality of xap specific functions used in app

## loading packages
xap.require <- function(...) {
  lapply(list(...), require, character.only = TRUE)
}

## reading data from database
## note reading from database reads text fields as character vectors not factors
## the datatable in XAP will have the same name as the csv
## note that this requires all data reading to be done at the app dir level
xap.read_table <- function(table_name) {
  ## if we are uploading data with the app then it must be in this location relative to the app directory
  csv_name <- paste0("../../", table_name, ".csv")
  d <- read.csv(csv_name, stringsAsFactors = FALSE)
  names(d) <- char_replace(tolower(names(d)))
  d
}

## renaming column headers in the same way as the ETL process
char_replace <- function(x, from = c("\\^", "\\.", "'", "\"", " "),
                         to = "_") {
  out <- x
  for(y in from) {
    out <- gsub(y, to, out)
  }
  out
}

xap.chooseDataTable <- function(input, output, session) {
  userFile <- reactive({
    # If no file is selected, don't do anything
    input$file
  })
  
  # The user's data, parsed into a data frame
  dataframe <- reactive({
    if(is.null(input$file)) {return(NULL)}
    read.csv(userFile()$datapath,
             header = TRUE,
             stringsAsFactors = FALSE)
  })
  
  return(dataframe)
}

xap.chooseDataTableUI <- function(id) {
  ns <- NS(id)
  
  fileInput(ns("file"), NULL)
}

