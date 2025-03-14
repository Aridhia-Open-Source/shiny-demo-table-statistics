
library(shiny)
library(ggvis)
library(shinyBS)
library(DT)



source("./code/documentation_ui.R")
source("./code/config.R")

xap.chooseDataTable <- function(input, output, session) {
  d <- reactive(withProgress(message = "Reading table", value = 0, {
    req(input$table_name)
    xap.read_table(input$table_name)
  }))
  
  ## Update the table list when refresh is clicked
  observe({
    i <- input$refresh
    tables <- xap.list_tables()
    ## isolate the update since we use input$table_name
    isolate({
      updateSelectizeInput(session, "table_name", choices = c("Choose a dataset" = "", tables),
                           selected = input$table_name)
    })
  })
  return(list(data = d, table_name = reactive(input$table_name)))
}

xap.chooseDataTableUI <- function(id, label = "Choose a table") {
  ns <- NS(id)
  
  tables <- xap.list_tables()
  
  tagList(
    selectizeInput(ns("table_name"), label = label, choices = c("Select a Table" = "", tables)),
    actionButton(ns("refresh"), "Refresh table list")
  )
}

dot_to_underscore <- function(string) {
  gsub("\\.", "_", string)
}

create_modal <- function(x, name) {
  UseMethod("create_modal", x)
}

create_modal.Polynominal <- function(x, name) {
  bsModal(
    paste0(dot_to_underscore(name), "modal"),
    title = paste("Ordinal Values:", name),
    trigger = paste0(dot_to_underscore(name), "details"),
    DTOutput(paste0("dt", name))
  ) 
  print(DTOutput(paste0("dt", name)))
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
  
  bsModal(
    paste0(nm, "modal"),
    title = paste("More Stats:", name),
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


my_summ <- function(x) {
  UseMethod("my_summ", x)
}

my_summ.numeric <- function(x) {
  xmin <- min(x, na.rm = T)
  xmax <- max(x, na.rm = T)
  xmean <- round(mean(x, na.rm = T), 3)
  xmissing <- sum(is.na(x))
  
  xtype <- class(x)
  if(xtype == "numeric") {
    xtype <- "Real"
  } else if (xtype == "integer")  {
    xtype <- "Integer"
  }
  
  out <- list("Type" = xtype, "Missing" = xmissing, "Min" = xmin,
              "Max" = xmax, "Average" = xmean, "Values" = x)
  class(out) <- xtype
  return(out)
}

my_summ.character <- function(x) {
  t <- table(x)
  xmissing <- sum(is.na(x))
  xleast <- t[which.min(t)]
  xmost <- t[which.max(t)]
  xvalues <- t[order(-t)]
  xvalues_string <- paste(paste0(names(xvalues), " (", xvalues, ")"), collapse = ", ")
  
  matches <- gregexpr("), ", xvalues_string)[[1]]
  show <- matches[matches < 40]
  if(length(show) == 0) {
    show <- matches[1]
  }
  
  if(length(show) == length(matches)) {
    string <- xvalues_string
  } else {
    to <- rev(show) + 1
    left <- length(matches) - length(show)
    string <- paste0(substr(xvalues_string, 1, to), " ...[", left, " more]")
  }
  
  out <- list(
    "Type" = "Polynominal",
    "Missing" = xmissing, 
    "Least" = paste0(names(xleast), " (", xleast, ")"), 
    "Most" = paste0(names(xmost), " (", xmost, ")"), 
    "Values" = string,
    "dt" = data.frame("Nominal value" = names(xvalues), "Absolute count" = as.vector(xvalues),
                      "Fraction" = as.vector(xvalues) / sum(xvalues))
  )
  class(out) <- "Polynominal"
  return(out)
}


my_summ.factor <- function(x) {
  my_summ(as.character(x))
}

my_summ.Date <- function(x) {
  out <- my_summ(as.character(x))
  class(out) <- "Date"
  out$Type <- "Date"
  out
}

my_summ.data.frame <- function(x) {
  lapply(x, my_summ)
}

my_summ.logical <- function(x) {
  out <- my_summ(as.character(x))
  class(out) <- "Boolean"
  out$Type <- "Boolean"
  out
}

my_summ.POSIXct <- function(x) {
  out <- my_summ(as.character(x))
  class(out) <- "DateTime"
  out$Type <- "DateTime"
  out
}

my_summ.POSIXlt <- my_summ.POSIXct

my_summ.NULL <- function(x) {
  NULL
}


simple_plot <- function(data, x) {
  UseMethod("simple_plot", x)
}

simple_plot.factor <- function(data, x) {
  simple_plot(data, as.character(x))
}

simple_plot.character <- function(data, x) {
  t <- table(x)
  n <- names(sort(-t))[1:5]
  l <- x %in% n
  d <- data[l,]
  x_ <- factor(x[l], levels = n)
  
  d %>% ggvis(~x_) %>% 
    layer_bars(fill := "#2C88A2", strokeWidth := 0.5) %>%
    add_axis("x", title = "") %>%
    add_axis("y", title = "", ticks = 8)
}

simple_plot.numeric <- function(data, x) {
  d <- data
  x_ <- x
  
  d %>% ggvis(~x_) %>%
    layer_histograms(width = diff(range(x, na.rm = T))/12, fill := "#2C88A2", strokeWidth := 0.5) %>%
    add_axis("x", title = "", ticks = 6) %>%
    add_axis("y", title = "", ticks = 8)
}

simple_plot.integer <- function(data, x) {
  d <- data
  x_ <- x
  
  d %>% ggvis(~x_) %>%
    layer_histograms(width = diff(range(x))/12, fill := "#2C88A2", strokeWidth := 0.5) %>%
    add_axis("x", title = "", ticks = 6) %>%
    add_axis("y", title = "", ticks = 8)
}

simple_plot.logical <- function(data, x) {
  simple_plot(data, as.character(x))
}

simple_plot.Date <- function(data, x) {
  d <- data
  x_ <- x
  
  d %>% ggvis(~x_) %>%
    layer_histograms(width = diff(range(x, na.rm = T))/12, fill := "#2C88A2", strokeWidth := 0.5) %>%
    add_axis("x", title = "", ticks = 6) %>%
    add_axis("y", title = "", ticks = 8)
}

simple_plot.POSIXct <- simple_plot.Date
simple_plot.POSIXlt <- simple_plot.Date

create_header <- function(x, ...) {
  tags$thead(
    tags$th("Name"),
    tags$th("Type"),
    tags$th("Missing"),
    tags$th("Statistics", colspan = 4)
  )
}

create_row <- function(x, ...) {
  UseMethod("create_row", x)
}


create_row.Real <- function(x, name, plot_id) {
  tags$tr(
    id = name,
    title = "Click to Expand",
    tags$td(class = "left", p(tags$b(name))),
    tags$td(p(x$Type)),
    tags$td(p(x$Missing)),
    tags$td(
      conditionalPanel(
        condition = paste0("input[\"row", name,  "\"] === 1"),
        ggvisOutput(plot_id),
        actionLink(paste0(dot_to_underscore(name), "plot"), "View plot")
      )
    ),
    tags$td(
      h6("Min"),
      p(x$Min)
    ),
    tags$td(
      h6("Max"),
      p(x$Max)
    ),
    tags$td(
      class = "right",
      h6("Average"),
      p(x$Average),
      actionLink(paste0(dot_to_underscore(name), "more"), "More stats")
    )
  )
}

create_row.Integer <- create_row.Real

create_row.Polynominal <- function(x, name, plot_id) {
  tags$tr(id = name,
    title = "Click to Expand",
    tags$td(class = "left", p(tags$b(name))),
    tags$td(p(x$Type)),
    tags$td(p(x$Missing)),
    tags$td(
      conditionalPanel(
        condition = paste0("input[\"row", name,  "\"] === 1"),
        ggvisOutput(plot_id),
        actionLink(paste0(dot_to_underscore(name), "plot"), "View plot")
      )
    ),
    tags$td(
      h6("Least"),
      p(x$Least)
    ),
    tags$td(
      h6("Most"),
      p(x$Most)
    ),
    tags$td(class = "right",
      h6("Values"),
      p(x$Values),
      DTOutput(paste0("dt", name)),
      actionButton(paste0(dot_to_underscore(name), "details"), "Details")
    )
  )
}

create_row.Date <- create_row.Polynominal
create_row.DateTime <- create_row.Polynominal
create_row.Boolean <- create_row.Polynominal


create_table <- function(summ, names, plot_ids) {
  print("Creating Table...")
  out <- tags$table(
    id = "myTable", class = "tablesorter table-striped",
    create_header(),
    tags$tbody(
      lapply(seq_along(summ), function(i) {
        create_row(summ[[i]], names[i], plot_ids[i])
      })
    )
  )
  return(out)
}
