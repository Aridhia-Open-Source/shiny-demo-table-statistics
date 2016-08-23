

create_header <- function(x, ...) {
  '<thead>
    <th>Name</th>
    <th>Type</th>
    <th>Missing</th>
    <th colspan=3>Statistics</th>
  </thead>'
}


create_row <- function(x, ...) {
  UseMethod("create_row", x)
}


create_row.Real <- function(x, name, plot_id) {
  paste0('<tr>',
         '<td><p>',name, '</p></td>',
         '<td><p>', x$Type, '</p></td>',
         '<td><p>', x$Missing, '</p></td>',
         '<td>', ggvisOutput(plot_id), '</td>',
         '<td><h6>Min</h6><p>', x$Min, '</p></td>',
         '<td><h6>Max</h6><p>', x$Max, '</p></td>',
         '<td><h6>Average</h6><p>', x$Average, '</p></td>',
         '</tr>'
  )
}

create_row.Polynominal <- function(x, name, plot_id) {
  paste0('<tr>',
         '<td><p>',name, '</p></td>',
         '<td><p>', x$Type, '</p></td>',
         '<td><p>', x$Missing, '</p></td>',
         '<td>', ggvisOutput(plot_id), '</td>',
         '<td><h6>Least</h6><p>', x$Least, '</p></td>',
         '<td><h6>Most</h6><p>', x$Most, '</p></td>',
         '<td><h6>Values</h6><p>', x$Values, '</p></td>',
         '</tr>'
  )
}


create_row.Date <- function(x, plot_id) {
  
}

create_table <- function(summ, names, plot_ids) {
  string <- paste0('<table id="myTable" class="tablesorter>',
                   create_header(),
                   '<tbody>'
  )
  
  for(i in seq_along(summ)) {
    string <- paste0(string, create_row(summ[[i]], names[[i]], plot_ids[[i]]))
  }
  
  string <- paste0(string, '</tbody></table>')
  
  HTML(string)
}




