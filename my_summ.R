
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
  
  
  out <- list("Type" = xtype, "Missing" = xmissing, "Min" = xmin, "Max" = xmax, "Average" = xmean,
              "Values" = x)
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
  
  out <- list("Type" = "Polynominal",
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

my_summ.POSIXct <- function(x) {
  out <- my_summ(as.character(x))
  class(out) <- "DateTime"
  out$Type <- "DateTime"
  out
}

my_summ.POSIXlt <- my_summ$POSIXct

my_summ.data.frame <- function(x) {
  lapply(x, my_summ)
}

my_summ.logical <- function(x) {
  out <- my_summ(as.character(x))
  class(out) <- "Boolean"
  out$Type <- "Boolean"
  out
}

my_summ.NULL <- function(x) {
  NULL
}
