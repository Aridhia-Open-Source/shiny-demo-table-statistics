
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

