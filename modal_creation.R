
create_modal <- function(x, name) {
  
  UseMethod("create_modal", x)
  
}

create_modal.Polynominal <- function(x, name) {
  
  bsModal(paste0(dot_to_underscore(name), "modal"), title = paste("Ordinal Values:", name),
          trigger = paste0(dot_to_underscore(name), "details"),
          dataTableOutput(paste0("dt", name))) 
  
}

create_modal.Real <- function(x, name) {
  nm <- dot_to_underscore(name)
  v <- x$Values
  
  xmean <- x$Average
  qs <- quantile(v, na.rm = T)
  
  xmin <- qs[1]
  xmax <- qs[5]
  xmed <- qs[3]
  q25 <- qs[2]
  q75 <- qs[4]
  
  xsd <- round(sd(v, na.rm = T), 3)
  
  bsModal(paste0(nm, "modal"), title = paste("More Stats:", name),
          trigger = paste0(nm, "more"),
          tags$b("Min:"), xmin, tags$br(),
          tags$b("Q25:"), q25, tags$br(),
          tags$b("Median:"), xmed, tags$br(),
          tags$b("Q75:"), q75, tags$br(),
          tags$b("Max:"), xmax, tags$br(),
          tags$b("Standard Deviation:"), xsd
  )
}

create_modal.Integer <- create_modal.Real

#create_modal.Date <- create_modal.Real

create_modal.Boolean <- create_modal.Polynominal

create_modal.default <- function(x, name) {
  
  fluidRow()
  
}

create_plot_modal <- function(name, plot_id) {
  
  bsModal(paste0(dot_to_underscore(name), "plot_modal"), title = paste0("Plot: ", name),
          trigger = paste0(dot_to_underscore(name), "plot"),
          ggvisOutput(plot_id))
  
}
