library(shiny)
library(ggvis)

library(shinyBS)

source("../dot_to_underscore.R")
source("../modal_creation.R")
source("../my_summ.R")
source("../plot_creation.R")
source("../table_creation.R")


#people <- read.csv("~/Documents/kaggle/redhat/people.csv", nrow = 10000)
people <- read.csv("~/Documents/gosh_data/pediatrics_demographics.csv")
people$logical <- sample(c(T, F), 500, replace = T)
people$Date <- seq(as.Date("2010-01-01"), as.Date("2011-01-01"), length.out = 500)
people$na <- NA
people$na[1] <- 1
people$na[2] <- 2

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
