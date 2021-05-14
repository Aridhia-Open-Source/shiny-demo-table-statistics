documentation_tab <- function() {
  tabPanel("Help",
    fluidPage(width = 12,
      fluidRow(
        column(6,
          h3("Summarising your datasets"),
          p("This RShiny mini-app allows you to quickly visualize a dataset structure (columns, type, missing values...) and a selection of summary statistics. 
          For each variable within the dataset, you can view statistics. Each variable can be displayed as a histogram,
             showing the distribution of the data."),
          h4("How to use the mini-app"),
          p("To summarise your datasets first click on the Application tab, then:"),
          tags$ul(
            tags$li(
              strong("Select your dataset"), 
              "from the drop-down menu - to refresh the list of available datasets, click Refresh
               table list, and preview your selection using Preview table."
            ), 
            tags$li(
              "Click on More stats to ",
              strong("see additional statistics for each numeric variable"),
              " if required."
            ),
            tags$li(
              "Select Details to ",
              strong("see the category count for categoric variables. ")
            ),
            tags$li(
              "To",
              strong("view a histogram of your variable of interest,"),
              "just click anywhere on the row containing the variable, and use the View Plot link to ",
              strong("view a larger version"),
              "of the visualisation."
            )
          ), 
          br()
        ),
        column(6,
          h3("Walkthrough video"),
          tags$video(src="Table Statistics Mini app.mp4", type = "video/mp4", width="100%", height = "350", frameborder = "0", controls = NA),
          p(class = "nb", 
            "NB: This mini-app is for provided for demonstration purposes, is unsupported and is utilised at user's risk. 
             If you plan to use this mini-app to inform your study, please review the code and ensure you are comfortable with 
             the calculations made before proceeding."
          )
        )
      )
    )
  )
}
