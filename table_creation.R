
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
  
  tags$tr(id = name,
    tags$td(class = "left", p(tags$b(name))),
    tags$td(p(x$Type)),
    tags$td(p(x$Missing)),
    tags$td(
      conditionalPanel(
        condition = paste0("input[\"row", name,  "\"] === 1"),
        ggvisOutput(plot_id),
        actionLink(paste0(dot_to_underscore(name), "plot"), "View Plot")
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
    tags$td(class = "right",
      h6("Average"),
      p(x$Average),
      actionLink(paste0(dot_to_underscore(name), "more"), "More Stats")
    )
  )
  
}

create_row.Integer <- create_row.Real

create_row.Polynominal <- function(x, name, plot_id) {
  tags$tr(id = name,
    tags$td(class = "left", p(tags$b(name))),
    tags$td(p(x$Type)),
    tags$td(p(x$Missing)),
    tags$td(
      conditionalPanel(
        condition = paste0("input[\"row", name,  "\"] === 1"),
        ggvisOutput(plot_id),
        actionLink(paste0(dot_to_underscore(name), "plot"), "View Plot")
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
      actionLink(paste0(dot_to_underscore(name), "details"), "Details")
    )
  )
}


create_row.Date <- function(x, plot_id) {
  
}

create_table <- function(summ, names, plot_ids) {
  print("Creating Table...")
  out <- tags$table(id = "myTable", class = "tablesorter",
    create_header(),
    tags$tbody(
      lapply(seq_along(summ), function(i) {
        create_row(summ[[i]], names[i], plot_ids[i])
      })
    )
  )
  print("Done")
  out
}



