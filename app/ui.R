library(shiny)
library(ggvis)

library(shinyBS)

source("../dot_to_underscore.R")
source("../modal_creation.R")
source("../my_summ.R")
source("../plot_creation.R")
source("../table_creation.R")


people <- read.csv("~/Documents/kaggle/redhat/people.csv", nrow = 10000)

ui <- fluidPage(
  includeScript("~/Documents/__jquery.tablesorter/jquery.tablesorter.js"),
  includeScript("../pager.js"),
  includeCSS("../ts_styles.css"),
  
  fluidRow(
    column(6,
      selectInput("data", "Select Dataset",
                  choices = c("Choose a Dataset" = "", "iris", "mtcars", "quakes", "people"),
                  selected = "")
      #csvFileInput("data")
    ),
    column(6,
      actionButton("link", "View Data")
    )
  ),
  
  bsModal("modal", "Plot", "link", size = "large", dataTableOutput("dt")),
  
  uiOutput("ui"),
  uiOutput("modals"),
  uiOutput("plot_modals")
)
