
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggvis)

bars <- function() {
  
}


server <- function(input, output, session) {
  
  d <- iris
  
  x <- summary(d)
  
  plots <- lapply(1:ncol(d), function(i) {
    d %>% ggvis(~d[,i]) %>% layer_bars() %>%
      add_axis("x", title = "") %>%
      add_axis("y", title = "") %>%
      bind_shiny(paste0("plot", i))
  })
  
  output$plot <- renderPlot({
    plot(rnorm(100))
  })
  
}

ui <- fluidPage(
  
  includeCSS("styles.css"),
  includeScript("click.js"),
  
  div(class = "container",
    div(class = "header",
      span("Expand")
    ),
    div(class = "content", plotOutput("plot")
        # HTML("<ul>
        #   <li>This is just some random content.</li>
        #   <li>This is just some random content.</li>
        #   <li>This is just some random content.</li>
        #   <li>This is just some random content.</li>
        # </ul>"),
        
    )
  )
)

runApp(list(ui = ui, server = server))



